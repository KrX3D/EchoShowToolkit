function Install-Apk {

    Write-Host ""
    Write-Host "APK Installation" -ForegroundColor Cyan
    Write-Host ""

    $Apk = Read-Host "Enter APK path"

    if (-not (Test-Path $Apk)) {

        Write-Host "File not found." -ForegroundColor Red
        return
    }


    if ([System.IO.Path]::GetExtension($Apk) -ne ".apk") {

        Write-Host "File is not an APK." -ForegroundColor Red
        return
    }


    Write-Host ""
    Write-Host "Installing APK..."
    Write-Host ""


    $Adb = Get-AdbPath

    $Result = & $Adb install -r "$Apk" 2>&1


    if ($LASTEXITCODE -eq 0) {

        Write-Host ""
        Write-Host "Installation successful." -ForegroundColor Green


        $Clean = Read-Host "Remove old APK files from device? (Y/N)"

        if ($Clean -match "^[Yy]$") {

            Invoke-Adb "shell rm /sdcard/Download/*.apk"
            Invoke-Adb "shell rm /sdcard/Download/*.bin"

        }

        return
    }


    Write-Host ""
    Write-Host "Installation failed:" -ForegroundColor Red
    Write-Host $Result


    if ($Result -match "INSUFFICIENT_STORAGE") {

        Write-Host ""
        Write-Host "Not enough storage." -ForegroundColor Yellow

        $Clean = Read-Host "Run storage cleanup and retry? (Y/N)"

        if ($Clean -match "^[Yy]$") {

            Invoke-Adb "shell pm trim-caches 2G"

            Install-Apk
        }
    }


    if ($Result -match "VERSION_DOWNGRADE") {

        Write-Host ""
        $Downgrade = Read-Host "Force downgrade install? (Y/N)"

        if ($Downgrade -match "^[Yy]$") {

            & $Adb install -r -d "$Apk"
        }
    }

}



function Install-FDroid {

    Write-Host ""
    Write-Host "Installing F-Droid" -ForegroundColor Cyan


    $Url = "https://f-droid.org/F-Droid.apk"

    $Temp = Join-Path $env:TEMP "F-Droid.apk"


    Invoke-WebRequest `
        -Uri $Url `
        -OutFile $Temp


    Install-APKFile $Temp


    Remove-Item $Temp -Force
}



function Install-APKFile {

    param(
        [string]$File
    )


    $Adb = Get-AdbPath

    & $Adb install -r "$File"
}



function Install-ViewAssist {

    Write-Host ""
    Write-Host "ViewAssist installation" -ForegroundColor Cyan

    Write-Host ""
    Write-Host "Download latest release manually:"
    Write-Host ""
    Write-Host "https://github.com/msp1974/ViewAssist_Companion_App"
    Write-Host ""

    Write-Host "After downloading the APK:"
    
    Install-Apk
}
