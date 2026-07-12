function Get-AdbPath {

    $LocalAdb = Join-Path $PSScriptRoot "..\adb.exe"

    if (Test-Path $LocalAdb) {
        return $LocalAdb
    }

    $Adb = Get-Command adb.exe -ErrorAction SilentlyContinue

    if ($Adb) {
        return $Adb.Source
    }

    Write-Host "adb.exe not found." -ForegroundColor Red
    Write-Host "Place adb.exe in the EchoShowToolkit folder or install Android Platform Tools."
    return $null
}


function Invoke-Adb {

    param(
        [Parameter(Mandatory)]
        [string]$Arguments
    )

    $Adb = Get-AdbPath

    if (-not $Adb) {
        return $null
    }

    return & $Adb $Arguments
}


function Initialize-Adb {

    $Adb = Get-AdbPath

    if (-not $Adb) {
        exit
    }

    Write-Host "Checking ADB..." -ForegroundColor Cyan

    & $Adb start-server | Out-Null

    $Devices = & $Adb devices

    if ($Devices -match "unauthorized") {

        Write-Host ""
        Write-Host "Device unauthorized!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Unlock your Echo Show."
        Write-Host "Accept the 'Allow USB debugging' message."
        Write-Host "Enable 'Always allow from this computer'."
        Write-Host ""

        Read-Host "Press ENTER after accepting"

        & $Adb devices
    }

}


function Connect-AdbWifi {

    Write-Host ""
    Write-Host "ADB over WiFi setup" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "On the Echo:"
    Write-Host "Settings -> Network -> WiFi"
    Write-Host "Find the IP address"
    Write-Host ""

    $Ip = Read-Host "Enter Echo IP"

    if ($Ip) {

        $Result = Invoke-Adb "connect $Ip`:5555"

        Write-Host $Result

        if ($Result -match "connected") {
            Write-Host "WiFi ADB connected" -ForegroundColor Green
        }
        else {
            Write-Host "Connection failed" -ForegroundColor Red
        }
    }
}
