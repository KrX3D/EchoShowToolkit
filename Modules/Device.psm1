function Get-EchoDevice {

    $Adb = Get-AdbPath

    if (-not $Adb) {
        return $null
    }


    $Devices = & $Adb devices


    $Connected = $Devices |
        Where-Object {
            $_ -match "\tdevice$"
        }


    if (-not $Connected) {

        Write-Host ""
        Write-Host "No authorized ADB device found." -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible reasons:"
        Write-Host "- USB debugging disabled"
        Write-Host "- Device not authorized"
        Write-Host "- Wrong USB cable"
        Write-Host "- ADB WiFi not connected"

        return $null
    }


    return $true
}



function Get-AdbProperty {

    param(
        [string]$Property
    )

    return Invoke-Adb "shell getprop $Property"
}



function Show-DeviceInfo {

    param(
        $Device
    )


    Write-Host ""
    Write-Host "Device Information" -ForegroundColor Cyan
    Write-Host "--------------------------------"


    $Model = Get-AdbProperty "ro.product.model"
    $DeviceName = Get-AdbProperty "ro.product.device"
    $Android = Get-AdbProperty "ro.build.version.release"
    $Lineage = Get-AdbProperty "ro.lineage.version"


    Write-Host "Model:"
    Write-Host $Model

    Write-Host ""

    Write-Host "Codename:"
    Write-Host $DeviceName

    Write-Host ""

    Write-Host "Android:"
    Write-Host $Android

    Write-Host ""

    Write-Host "LineageOS:"
    Write-Host $Lineage


    Write-Host ""
}



function Get-DeviceStorage {

    Write-Host ""
    Write-Host "Storage information" -ForegroundColor Cyan

    $Storage = Invoke-Adb "shell df -h /data"

    Write-Host ""

    $Storage
}
