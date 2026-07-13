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
    Write-Host "Cleaning temporary APK files..."

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


    Write-Host ""
    Write-Host "Installing..."

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
        Write-Host "Not enough storage." -ForegroundColor Yellow


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


    Write-Host ""
    Write-Host "F-Droid installed." -ForegroundColor Green
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



    $APK =
        $Release.assets |
        Where-Object {
            $_.name -like "*.apk"
        } |
        Select-Object -First 1



    if (-not $APK) {

        Write-Host "No APK found." -ForegroundColor Red
        return
    }



    Write-Host ""
    Write-Host "Latest version:"
    Write-Host $APK.name



    $Target =
        Join-Path $env:TEMP $APK.name



    Write-Host ""
    Write-Host "Downloading..."


    Invoke-WebRequest `
        -Uri $APK.browser_download_url `
        -OutFile $Target



    $Adb = Get-AdbPath


    Write-Host ""
    Write-Host "Installing ViewAssist..."


    & $Adb install -r "$Target"



    Remove-Item $Target -Force


    Cleanup-InstallFiles


    Write-Host ""
    Write-Host "ViewAssist update complete." -ForegroundColor Green
}



function Test-PackageInstalled {

    param(
        [string]$Package
    )


    $Result =
        Invoke-Adb "shell pm list packages $Package"


    return $Result -match $Package
}



function Install-HomeAssistant {


    $Config = Get-Config


    $Package =
        $Config.HomeAssistant.PackageName



    Write-Host ""
    Write-Host "Home Assistant" -ForegroundColor Cyan



    if (Test-PackageInstalled $Package) {

        Write-Host ""
        Write-Host "Home Assistant is already installed." -ForegroundColor Green
    }
    else {


        Write-Host ""
        Write-Host "Home Assistant is not installed."
        Write-Host ""

        Write-Host "Recommended installation:"
        Write-Host "1. Install F-Droid"
        Write-Host "2. Search for Home Assistant"
        Write-Host "3. Install the Companion App"
        Write-Host ""


        $FDroid =
            Read-Host "Install F-Droid now? (Y/N)"


        if ($FDroid -match "^[Yy]$") {

            Install-FDroid
        }


        Write-Host ""
        Write-Host "After installing Home Assistant, run:"
        Write-Host "Home Assistant Tweaks from the menu."
        Write-Host ""
    }


    $Tweaks =
        Read-Host "Apply Home Assistant tweaks now? (Y/N)"


    if ($Tweaks -match "^[Yy]$") {

        Apply-HomeAssistantTweaks
    }

}
