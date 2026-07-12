function Cleanup-Downloads {

    Write-Host ""
    Write-Host "Checking /sdcard/Download..." -ForegroundColor Cyan

    $Files = Invoke-Adb "shell ls -lh /sdcard/Download"

    if (-not $Files) {
        Write-Host "No files found."
        return
    }

    Write-Host ""
    Write-Host "Files:"
    Write-Host $Files

    Write-Host ""

    $Answer = Read-Host "Delete APK and BIN files? (Y/N)"

    if ($Answer -notmatch "^[Yy]$") {
        Write-Host "Skipped."
        return
    }


    Invoke-Adb "shell rm /sdcard/Download/*.apk"
    Invoke-Adb "shell rm /sdcard/Download/*.bin"


    Write-Host ""
    Write-Host "Cleanup completed." -ForegroundColor Green


    Write-Host ""
    $Trim = Read-Host "Run Android cache cleanup? (Y/N)"

    if ($Trim -match "^[Yy]$") {

        Invoke-Adb "shell pm trim-caches 2G"

        Write-Host "Cache cleanup finished." -ForegroundColor Green
    }
}
