function Get-Config {


    $Config =
        Join-Path $PSScriptRoot "..\Config.json"


    return Get-Content $Config | ConvertFrom-Json

}



function Cleanup-InstallFiles {


    $Config = Get-Config


    if ($Config.CleanupAfterInstall -ne $true) {
        return
    }


    Write-Host ""
    Write-Host "Cleaning device download folder..."


    Invoke-Adb "shell rm /sdcard/Download/*.apk"
    Invoke-Adb "shell rm /sdcard/Download/*.bin"

}



function Install-Apk {


    Write-Host ""
    Write-Host "APK Installation" -ForegroundColor Cyan


    $APK = Read-Host "APK path"


    if (-not (Test-Path $APK)) {

        Write-Host "File not found." -ForegroundColor Red
        return
    }


    $Adb = Get-AdbPath


    $Result =
        & $Adb install -r "$APK" 2>&1


    if ($LASTEXITCODE -eq 0) {

        Write-Host ""
        Write-Host "Installation successful." -ForegroundColor Green

        Cleanup-InstallFiles

        return
    }


    Write-Host ""
    Write-Host $Result -ForegroundColor Red


    if ($Result -match "INSUFFICIENT_STORAGE") {


        Write-Host ""
        Write-Host "Cleaning cache..."


        Invoke-Adb "shell pm trim-caches 2G"


        $Retry =
            Read-Host "Retry installation? (Y/N)"


        if ($Retry -match "^[Yy]$") {

            Install-Apk
        }
    }

}



function Install-FDroid {


    $Config = Get-Config


    $Target =
        Join-Path $env:TEMP "F-Droid.apk"


    Write-Host ""
    Write-Host "Downloading F-Droid..." -ForegroundColor Cyan


    Invoke-WebRequest `
        -Uri $Config."F-DroidUrl" `
        -OutFile $Target



    $Adb = Get-AdbPath


    & $Adb install -r "$Target"



    Remove-Item $Target -Force


    Cleanup-InstallFiles

}



function Install-ViewAssist {


    $Config = Get-Config


    Write-Host ""
    Write-Host "Checking latest ViewAssist release..." -ForegroundColor Cyan


    $Release =
        Invoke-RestMethod `
        -Uri $Config.ViewAssist.GitHubApi `
        -Headers @{
            "User-Agent"="EchoShowToolkit"
        }


    $APKAsset =
        $Release.assets |
        Where-Object {
            $_.name -match "\.apk$"
        } |
        Select-Object -First 1



    if (-not $APKAsset) {

        Write-Host "No APK found."
        return
    }



    Write-Host ""
    Write-Host "Latest:"
    Write-Host $APKAsset.name



    $Target =
        Join-Path $env:TEMP $APKAsset.name



    Write-Host ""
    Write-Host "Downloading..."


    Invoke-WebRequest `
        -Uri $APKAsset.browser_download_url `
        -OutFile $Target



    $Adb = Get-AdbPath


    Write-Host ""
    Write-Host "Installing ViewAssist..."


    & $Adb install -r "$Target"



    Remove-Item $Target -Force


    Cleanup-InstallFiles


    Write-Host ""
    Write-Host "ViewAssist installed." -ForegroundColor Green

}
