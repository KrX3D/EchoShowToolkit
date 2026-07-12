function Open-LineageDownloadPage {

    $Device = Get-LineageInfo


    if (-not $Device) {

        Write-Host ""
        Write-Host "Unknown Echo model." -ForegroundColor Yellow
        Write-Host "Cannot determine LineageOS download page."
        return
    }


    Write-Host ""
    Write-Host "Detected device:" -ForegroundColor Cyan
    Write-Host $Device.Name -ForegroundColor Green

    Write-Host ""
    Write-Host "Opening XDA LineageOS page..."

    Start-Process $Device.XdaUrl
}



function Push-LineageZip {


    $Device = Get-LineageInfo


    if (-not $Device) {

        Write-Host ""
        Write-Host "Unknown device." -ForegroundColor Red
        return
    }


    Write-Host ""
    Write-Host "LineageOS update helper"
    Write-Host "Device:"
    Write-Host $Device.Name -ForegroundColor Green

    Write-Host ""

    Write-Host "Before continuing:"
    Write-Host "1. Download the correct LineageOS ZIP from XDA"
    Write-Host "2. Boot Echo into TWRP"
    Write-Host "3. Connect USB"
    Write-Host ""

    $Zip = Read-Host "Enter Lineage ZIP path"



    if (-not (Test-Path $Zip)) {

        Write-Host ""
        Write-Host "File not found." -ForegroundColor Red
        return
    }



    if ([System.IO.Path]::GetExtension($Zip) -ne ".zip") {

        Write-Host ""
        Write-Host "Selected file is not a ZIP." -ForegroundColor Red
        return
    }



    Write-Host ""
    Write-Host "Pushing ZIP to Echo..." -ForegroundColor Cyan


    $Adb = Get-AdbPath


    & $Adb push "$Zip" "/sdcard/"


    if ($LASTEXITCODE -eq 0) {

        Write-Host ""
        Write-Host "LineageOS ZIP copied successfully." -ForegroundColor Green

        Write-Host ""
        Write-Host "You can now install it from TWRP:"
        Write-Host "/sdcard/$(Split-Path $Zip -Leaf)"
    }
    else {

        Write-Host ""
        Write-Host "Push failed." -ForegroundColor Red
    }

}
