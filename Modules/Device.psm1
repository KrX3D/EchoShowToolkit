function Get-EchoDevice {

    $Devices = Invoke-Adb "devices"

    $Connected = $Devices |
        Where-Object {
            $_ -match "\tdevice$"
        }


    if (-not $Connected) {

        Write-Host ""
        Write-Host "No authorized device found." -ForegroundColor Red

        Write-Host ""
        Write-Host "Check:"
        Write-Host "- USB debugging enabled"
        Write-Host "- Accept RSA prompt on Echo"
        Write-Host "- USB cable"

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



function Get-EchoCodename {

    $Device = Get-AdbProperty "ro.product.device"

    return $Device.Trim()
}



function Get-LineageInfo {


    $Codename = Get-EchoCodename


    $ConfigPath = Join-Path $PSScriptRoot "..\Config.json"

    $Config = Get-Content $ConfigPath | ConvertFrom-Json


    $DeviceConfig =
        $Config.LineageDevices.$Codename


    return $DeviceConfig
}



function Show-DeviceInfo {


    Write-Host ""
    Write-Host "Device Information" -ForegroundColor Cyan
    Write-Host "----------------------------"


    $Model =
        Get-AdbProperty "ro.product.model"


    $Codename =
        Get-AdbProperty "ro.product.device"


    $Android =
        Get-AdbProperty "ro.build.version.release"


    $Lineage =
        Get-AdbProperty "ro.lineage.version"


    Write-Host "Model:"
    Write-Host $Model.Trim()

    Write-Host ""

    Write-Host "Codename:"
    Write-Host $Codename.Trim()

    Write-Host ""

    Write-Host "Android:"
    Write-Host $Android.Trim()

    Write-Host ""

    Write-Host "LineageOS:"
    Write-Host $Lineage.Trim()


    $LineageInfo = Get-LineageInfo


    if ($LineageInfo) {

        Write-Host ""
        Write-Host "Supported device:"
        Write-Host $LineageInfo.Name -ForegroundColor Green
    }

}



function Get-DeviceStorage {


    Write-Host ""
    Write-Host "Storage:" -ForegroundColor Cyan


    Invoke-Adb "shell df -h /data"

}
