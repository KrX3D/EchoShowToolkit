function Get-DeviceProperty {

    param(
        [string]$Property
    )

    $Value =
        Invoke-Adb "shell getprop $Property"


    if ($Value) {

        return $Value.Trim()
    }


    return $null
}



function Get-EchoDevice {


    $Devices =
        Get-AdbDevices



    $Connected =
        $Devices |
        Where-Object {
            $_ -match "\tdevice$"
        }



    if (-not $Connected) {


        Write-Host ""
        Write-Host "No authorized Echo device found." -ForegroundColor Red

        Write-Host ""
        Write-Host "Check:"
        Write-Host "- USB debugging enabled"
        Write-Host "- RSA prompt accepted"
        Write-Host "- ADB WiFi connected"


        return $false
    }


    return $true
}



function Get-EchoCodename {


    $Codename =
        Get-DeviceProperty "ro.product.device"


    return $Codename
}



function Get-EchoModel {


    $Model =
        Get-DeviceProperty "ro.product.model"


    return $Model
}



function Get-LineageVersion {


    $Version =
        Get-DeviceProperty "ro.lineage.version"


    return $Version
}



function Get-AndroidVersion {


    $Version =
        Get-DeviceProperty "ro.build.version.release"


    return $Version
}



function Get-ToolkitConfig {


    $ConfigFile =
        Join-Path $PSScriptRoot "..\Config.json"


    return Get-Content $ConfigFile -Raw | ConvertFrom-Json
}



function Get-LineageDeviceInfo {


    $Config =
        Get-ToolkitConfig



    $Code =
        Get-EchoCodename



    foreach ($Device in $Config.LineageDevices.PSObject.Properties) {


        if ($Device.Name -eq $Code) {


            return $Device.Value
        }
    }



    return $null
}



function Show-DeviceInfo {


    Write-Host ""
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host " Device Information"
    Write-Host "================================"
    Write-Host ""



    $Model =
        Get-EchoModel


    $Code =
        Get-EchoCodename


    $Android =
        Get-AndroidVersion


    $Lineage =
        Get-LineageVersion



    Write-Host "Model:"
    Write-Host $Model



    Write-Host ""
    Write-Host "Codename:"
    Write-Host $Code



    Write-Host ""
    Write-Host "Android:"
    Write-Host $Android



    Write-Host ""
    Write-Host "LineageOS:"
    Write-Host $Lineage



    $Known =
        Get-LineageDeviceInfo



    Write-Host ""



    if ($Known) {


        Write-Host "Detected Echo:"
        Write-Host $Known.Name -ForegroundColor Green
    }

    else {


        Write-Host "Unknown Echo model." -ForegroundColor Yellow
    }



    Write-Host ""
}



function Get-InstalledApps {


    Write-Host ""
    Write-Host "Installed Toolkit Apps" -ForegroundColor Cyan
    Write-Host ""



    $Apps = @{

        "Home Assistant" =
        "io.homeassistant.companion.android.minimal"

        "ViewAssist" =
        "com.viewassist"

        "F-Droid" =
        "org.fdroid.fdroid"
    }



    foreach ($App in $Apps.GetEnumerator()) {


        $Result =
            Invoke-Adb "shell pm list packages $($App.Value)"



        if ($Result -match $App.Value) {


            Write-Host "✓ $($App.Key)" -ForegroundColor Green
        }

        else {


            Write-Host "✗ $($App.Key)"
        }
    }


}



function Get-DeviceStorage {


    Write-Host ""
    Write-Host "Storage (/data)" -ForegroundColor Cyan
    Write-Host ""


    Invoke-Adb "shell df -h /data"
}
