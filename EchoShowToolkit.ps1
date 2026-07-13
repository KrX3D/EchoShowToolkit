<#
.SYNOPSIS
    EchoShowToolkit

.DESCRIPTION
    Toolkit for Amazon Echo Show devices running LineageOS.

    Features:
    - ADB USB/WiFi
    - Device detection
    - App install/update
    - F-Droid
    - Home Assistant Companion
    - ViewAssist
    - LineageOS helper
    - Tweaks
#>


$Root = Split-Path -Parent $MyInvocation.MyCommand.Path


$Modules = @(
    "Adb.psm1",
    "Device.psm1",
    "Cleanup.psm1",
    "AppInstaller.psm1",
    "Lineage.psm1",
    "Tweaks.psm1"
)


foreach ($Module in $Modules) {

    Import-Module "$Root\Modules\$Module" -Force
}



Clear-Host


Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " EchoShowToolkit"
Write-Host " LineageOS Echo Show Manager"
Write-Host "=============================================="
Write-Host ""



Initialize-Adb



if (-not (Get-EchoDevice)) {

    Write-Host ""
    Write-Host "No Echo Show detected." -ForegroundColor Red
    Read-Host "Press ENTER"
    exit
}



Show-DeviceInfo



while ($true) {


    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host " MENU"
    Write-Host "=============================================="

    Write-Host ""
    Write-Host "1  Device information"
    Write-Host "2  Storage check"
    Write-Host "3  Cleanup APK/BIN files"
    Write-Host ""
    Write-Host "4  Install / Update Apps"
    Write-Host ""
    Write-Host "5  LineageOS helper"
    Write-Host ""
    Write-Host "6  LineageOS tweaks"
    Write-Host "7  Home Assistant tweaks"
    Write-Host "8  Screen / Doze tweaks"
    Write-Host ""
    Write-Host "9  ADB WiFi setup"
    Write-Host ""
    Write-Host "Q  Exit"
    Write-Host ""


    $Choice = Read-Host "Select"



    switch ($Choice) {


        "1" {

            Show-DeviceInfo
        }


        "2" {

            Get-DeviceStorage
        }


        "3" {

            Cleanup-DeviceFiles
        }


        "4" {

            Show-AppMenu
        }


        "5" {

            Show-LineageMenu
        }


        "6" {

            Apply-LineageTweaks
        }


        "7" {

            Apply-HomeAssistantTweaks
        }


        "8" {

            Apply-ScreenTweaks
        }


        "9" {

            Connect-AdbWifi
        }


        "q" {

            break
        }


        "Q" {

            break
        }


        default {

            Write-Host "Invalid selection" -ForegroundColor Yellow
        }
    }
}
