function Get-AdbPath {


    $Local =
        Join-Path $PSScriptRoot "..\adb.exe"


    if (Test-Path $Local) {

        return $Local
    }


    $Adb =
        Get-Command adb.exe -ErrorAction SilentlyContinue


    if ($Adb) {

        return $Adb.Source
    }


    Write-Host ""
    Write-Host "adb.exe not found." -ForegroundColor Red
    Write-Host "Place adb.exe in the EchoShowToolkit folder."
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


    $ArgumentList =
        $Arguments -split " "


    return & $Adb $ArgumentList
}



function Initialize-Adb {


    $Adb = Get-AdbPath


    if (-not $Adb) {

        exit
    }


    Write-Host "Starting ADB..." -ForegroundColor Cyan


    & $Adb start-server | Out-Null



    $Devices =
        & $Adb devices



    if ($Devices -match "unauthorized") {


        Write-Host ""
        Write-Host "ADB authorization required" -ForegroundColor Yellow
        Write-Host ""

        Write-Host "On the Echo:"
        Write-Host ""
        Write-Host "1. Unlock the screen"
        Write-Host "2. Accept USB debugging prompt"
        Write-Host "3. Enable 'Always allow'"
        Write-Host ""

        Read-Host "Press ENTER after accepting"


        & $Adb devices
    }

}



function Get-AdbDevices {


    $Adb = Get-AdbPath


    if (-not $Adb) {

        return $null
    }


    return & $Adb devices
}



function Connect-AdbWifi {


    Write-Host ""
    Write-Host "ADB WiFi setup" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "Recommended procedure:"
    Write-Host ""
    Write-Host "1. Connect Echo via USB"
    Write-Host "2. Enable TCP mode"
    Write-Host "3. Disconnect USB"
    Write-Host "4. Connect using IP"
    Write-Host ""


    $Tcp =
        Read-Host "Enable ADB TCP mode now? (Y/N)"



    if ($Tcp -match "^[Yy]$") {

        Invoke-Adb "tcpip 5555"

        Write-Host ""
        Write-Host "ADB TCP mode enabled."
    }



    Write-Host ""

    $IP =
        Read-Host "Echo IP address"



    if (-not $IP) {

        return
    }



    $Result =
        Invoke-Adb "connect $IP`:5555"



    Write-Host ""
    Write-Host $Result



    if ($Result -match "connected") {

        Write-Host ""
        Write-Host "ADB WiFi connected." -ForegroundColor Green
    }

    else {

        Write-Host ""
        Write-Host "ADB WiFi connection failed." -ForegroundColor Red
    }
}



function Disconnect-AdbWifi {


    $IP =
        Read-Host "IP address to disconnect"



    if ($IP) {

        Invoke-Adb "disconnect $IP`:5555"
    }
}
