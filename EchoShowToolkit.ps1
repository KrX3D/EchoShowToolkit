<#
.SYNOPSIS
    Amazon Echo Show LineageOS Toolkit

.DESCRIPTION
    Helper script for managing Echo Show devices running LineageOS.
    Supports:
    - ADB USB/WiFi connection
    - Device information
    - Storage cleanup
    - APK installation
    - F-Droid installation
    - ViewAssist installation
    - LineageOS/Home Assistant tweaks
#>

$RootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$Modules = @(
    "Adb.psm1",
    "Device.psm1",
    "Installer.psm1",
    "Cleanup.psm1",
    "Tweaks.psm1",
    "Lineage.psm1"
)

foreach ($Module in $Modules) {
    Import-Module "$RootPath\Modules\$Module" -Force
}

Clear-Host

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " Echo Show LineageOS Toolkit" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

Initialize-Adb

$Device = Get-EchoDevice

if (-not $Device) {
    Write-Host ""
    Write-Host "No device connected." -ForegroundColor Red
    Pause
    exit
}

Show-DeviceInfo $Device


while ($true) {

    Write-Host ""
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host " MENU"
    Write-Host "==============================================" -ForegroundColor Cyan

    Write-Host "1 - Check storage"
    Write-Host "2 - Cleanup old APK/BIN files"
    Write-Host "3 - Install APK"
    Write-Host "4 - Install F-Droid"
    Write-Host "5 - Install ViewAssist"
    Write-Host "6 - Install Home Assistant"
    Write-Host "7 - Apply LineageOS Tweaks"
    Write-Host "8 - Apply Home Assistant Tweaks"
    Write-Host "9 - Apply Screen/Doze Tweaks"
    Write-Host "10 - Reconnect ADB WiFi"
    Write-Host "11 - Open LineageOS download page"
    Write-Host "12 - Push LineageOS ZIP to device"
    Write-Host "Q - Exit"

    $Choice = Read-Host "Select"

    switch ($Choice) {

        "1" {
            Get-DeviceStorage
        }

        "2" {
            Cleanup-Downloads
        }

        "3" {
            Install-Apk
        }

        "4" {
            Install-FDroid
        }

        "5" {
            Install-ViewAssist
        }

        "6" {
            Install-HomeAssistant
        }

        "7" {
            Apply-LineageTweaks
        }

        "8" {
            Apply-HomeAssistantTweaks
        }

        "9" {
            Apply-ScreenTweaks
        }

        "10" {
            Connect-AdbWifi
        }

        "11" {
            Open-LineageDownloadPage
        }


        "12" {
            Push-LineageZip
        }

        "Q" {
            break
        }

        default {
            Write-Host "Invalid selection" -ForegroundColor Yellow
        }
    }
}
