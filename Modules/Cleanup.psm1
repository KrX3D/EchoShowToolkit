function Cleanup-DeviceFiles {


    Write-Host ""
    Write-Host "Checking device download folder..." -ForegroundColor Cyan
    Write-Host ""



    $Files =
        Invoke-Adb "shell ls -lh /sdcard/Download"



    if (-not $Files) {

        Write-Host "No files found."
        return
    }



    Write-Host $Files



    Write-Host ""

    $Answer =
        Read-Host "Delete APK and BIN files from Echo? (Y/N)"



    if ($Answer -notmatch "^[Yy]$") {

        return
    }



    Invoke-Adb "shell rm /sdcard/Download/*.apk"

    Invoke-Adb "shell rm /sdcard/Download/*.bin"



    Write-Host ""
    Write-Host "Device cleanup complete." -ForegroundColor Green
}

function Cleanup-DeviceFilesAuto {
    Invoke-Adb "shell rm -f /sdcard/Download/*.apk"

    Invoke-Adb "shell rm -f /sdcard/Download/*.bin"
}

function Clear-AndroidCache {


    Write-Host ""
    Write-Host "Cleaning Android cache..." -ForegroundColor Cyan



    Invoke-Adb "shell pm trim-caches 2G"



    Write-Host ""
    Write-Host "Cache cleanup finished." -ForegroundColor Green
}



function Cleanup-LocalTemp {


    Write-Host ""
    Write-Host "Cleaning local temporary APK files..." -ForegroundColor Cyan



    $Files = @(
        "$env:TEMP\*.apk",
        "$env:TEMP\*.bin"
    )



    foreach ($File in $Files) {


        Get-ChildItem `
            -Path $File `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Force `
            -ErrorAction SilentlyContinue
    }



    Write-Host ""
    Write-Host "Local cleanup finished." -ForegroundColor Green
}



function Full-Cleanup {


    Cleanup-DeviceFiles

    Clear-AndroidCache

    Cleanup-LocalTemp
}
