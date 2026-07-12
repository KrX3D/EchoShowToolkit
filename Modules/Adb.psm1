function Get-AdbPath {

    $LocalAdb = Join-Path $PSScriptRoot "..\adb.exe"

    if (Test-Path $LocalAdb) {
        return $LocalAdb
    }


    $Adb = Get-Command adb.exe -ErrorAction SilentlyContinue

    if ($Adb) {
        return $Adb.Source
    }


    Write-Host ""
    Write-Host "adb.exe not found." -ForegroundColor Red
    Write-Host "Copy adb.exe into the EchoShowToolkit folder."
    Write-Host ""

    return $null
}



function Invoke-Adb {

    param(
        [string]$Arguments
    )


    $Adb = Get-AdbPath

    if (-not $Adb) {
        return $null
    }


    $Args = $Arguments -split " "

    return & $Adb $Args
}



function Initialize-Adb {


    $Adb = Get-AdbPath


    if (-not $Adb) {
        exit
    }


    Write-Host "Starting ADB..." -ForegroundColor Cyan


    & $Adb start-server | Out-Null


    $Devices = & $Adb devices


    if ($Devices -match "unauthorized") {


        Write-Host ""
        Write-Host "ADB authorization required" -ForegroundColor Yellow
        Write-Host ""

        Write-Host "On the Echo:"
        Write-Host "1. Unlock screen"
        Write-Host "2. Accept USB debugging prompt"
        Write-Host "3. Enable 'Always allow'"
        Write-Host ""

        Read-Host "Press ENTER when done"


        & $Adb devices
    }

}



function Connect-AdbWifi {


    Write-Host ""
    Write-Host "ADB WiFi Setup" -ForegroundColor Cyan
    Write-Host ""


    Write-Host "First connect USB."
    Write-Host ""

    $EnableTcp = Read-Host "Enable ADB TCP mode using USB? (Y/N)"


    if ($EnableTcp -match "^[Yy]$") {

        Invoke-Adb "tcpip 5555"

        Write-Host ""
        Write-Host "USB can now be disconnected."
    }


    Write-Host ""

    $IP = Read-Host "Enter Echo IP address"


    if (-not $IP) {
        return
    }


    $Result = Invoke-Adb "connect $IP`:5555"


    Write-Host ""

    if ($Result -match "connected") {

        Write-Host "ADB WiFi connected." -ForegroundColor Green
    }
    else {

        Write-Host $Result -ForegroundColor Red
    }

}
