function Get-ToolkitConfig {

    $Path = Join-Path $PSScriptRoot "..\Config.json"

    return Get-Content $Path -Raw | ConvertFrom-Json
}



function Get-InstalledVersion {

    param(
        [string]$Package
    )


    $Result = Invoke-Adb "shell dumpsys package $Package"


    if ($Result -match "versionName=([^\s]+)") {

        return $Matches[1]
    }


    return $null
}



function Test-AppInstalled {

    param(
        [string]$Package
    )


    $Result = Invoke-Adb "shell pm list packages $Package"


    return ($Result -match $Package)
}



function Compare-AppVersion {

    param(
        [string]$Installed,
        [string]$Latest
    )


    if (-not $Installed) {
        return $true
    }


    try {

        return ([version]$Latest -gt [version]$Installed)

    }
    catch {

        return $true
    }
}



function Install-DownloadedApk {

    param(
        [string]$File
    )


    $Adb = Get-AdbPath


    Write-Host ""
    Write-Host "Installing $File ..." -ForegroundColor Cyan


    $Result = & $Adb install -r "$File" 2>&1



    if ($LASTEXITCODE -eq 0) {

        Write-Host "Installation successful." -ForegroundColor Green

        Cleanup-DeviceFiles

        return $true
    }


    Write-Host ""
    Write-Host $Result -ForegroundColor Red


    if ($Result -match "INSUFFICIENT_STORAGE") {

        Write-Host ""
        Write-Host "Storage full. Cleaning cache..."

        Invoke-Adb "shell pm trim-caches 2G"
    }


    return $false
}



function Download-And-Install {

    param(
        [string]$Url,
        [string]$Name
    )


    $Target = Join-Path $env:TEMP $Name


    Write-Host ""
    Write-Host "Downloading $Name..." -ForegroundColor Cyan


    Invoke-WebRequest `
        -Uri $Url `
        -OutFile $Target



    Install-DownloadedApk $Target


    Remove-Item $Target -Force -ErrorAction SilentlyContinue
}



function Update-GithubApp {

    param(
        [string]$Name,
        [string]$Package,
        [string]$ApiUrl
    )


    Write-Host ""
    Write-Host "Checking $Name..." -ForegroundColor Cyan



    $Release = Invoke-RestMethod `
        -Uri $ApiUrl `
        -Headers @{
            "User-Agent"="EchoShowToolkit"
        }



    $Asset =
        $Release.assets |
        Where-Object {
            $_.name -match "\.apk$"
        } |
        Select-Object -First 1



    if (-not $Asset) {

        Write-Host "No APK found." -ForegroundColor Red
        return
    }



    $Latest = $Release.tag_name.TrimStart("v")


    $Installed = Get-InstalledVersion $Package



    Write-Host ""
    Write-Host "Installed:"
    Write-Host ($Installed ?? "Not installed")

    Write-Host ""
    Write-Host "Available:"
    Write-Host $Latest



    if ($Installed) {

        if (-not (Compare-AppVersion $Installed $Latest)) {

            Write-Host ""
            Write-Host "Already up to date." -ForegroundColor Green
            return
        }
    }



    Write-Host ""

    $Confirm =
        Read-Host "Install/update $Name? (Y/N)"



    if ($Confirm -notmatch "^[Yy]$") {

        return
    }



    Download-And-Install `
        -Url $Asset.browser_download_url `
        -Name $Asset.name
}



function Install-FDroid {


    $Config = Get-ToolkitConfig


    Update-GithubApp `
        -Name "F-Droid" `
        -Package "org.fdroid.fdroid" `
        -ApiUrl "https://f-droid.org/api/v1/releases"



}



function Install-ViewAssist {


    $Config = Get-ToolkitConfig


    Update-GithubApp `
        -Name "ViewAssist" `
        -Package "com.viewassist" `
        -ApiUrl $Config.ViewAssist.GitHubApi
}



function Install-HomeAssistant {


    $Config = Get-ToolkitConfig


    Update-GithubApp `
        -Name "Home Assistant Companion" `
        -Package $Config.HomeAssistant.PackageName `
        -ApiUrl $Config.HomeAssistant.GitHubApi
}



function Show-AppMenu {


    while ($true) {


        Write-Host ""
        Write-Host "=============================="
        Write-Host " Apps"
        Write-Host "=============================="

        Write-Host ""
        Write-Host "1 - Home Assistant Companion"
        Write-Host "2 - ViewAssist"
        Write-Host "3 - F-Droid"
        Write-Host "4 - Custom APK"
        Write-Host "0 - Back"
        Write-Host ""


        $Choice = Read-Host "Select"



        switch ($Choice) {


            "1" {

                Install-HomeAssistant
            }


            "2" {

                Install-ViewAssist
            }


            "3" {

                Install-FDroid
            }


            "4" {

                Install-Apk
            }


            "0" {

                break
            }
        }
    }
}



function Install-Apk {


    $File = Read-Host "APK path"


    if (Test-Path $File) {

        Install-DownloadedApk $File
    }
    else {

        Write-Host "File not found." -ForegroundColor Red
    }
}
