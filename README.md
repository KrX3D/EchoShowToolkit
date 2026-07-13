# EchoShowToolkit

PowerShell toolkit for Amazon Echo Show devices running LineageOS.

Designed for:

- Echo Show 5 Gen 1 (Checkers)
- Echo Show 5 Gen 2 (Cronos)
- Echo Show 8 Gen 1 (Crown)


## Requirements

- Windows 10/11
- PowerShell 5+ (PowerShell 7 recommended)
- Android Platform Tools

Download Android Platform Tools and place:

    adb.exe

inside the main `EchoShowToolkit` folder.

Example structure:

    EchoShowToolkit
    |
    |-- EchoShowToolkit.ps1
    |-- Config.json
    |-- adb.exe
    |
    |-- Modules
        |
        |-- Adb.psm1
        |-- Device.psm1
        |-- Cleanup.psm1
        |-- AppInstaller.psm1
        |-- Lineage.psm1
        |-- Tweaks.psm1


## First Start

Connect the Echo Show using USB.

Enable:

    Settings
     -> System
     -> Developer options
     -> USB debugging

Start:

    .\EchoShowToolkit.ps1

Accept the RSA debugging prompt on the Echo.


# Features


## ADB Management

Supports:

- USB ADB
- ADB authorization check
- ADB over WiFi


WiFi setup:

1. Connect USB
2. Enable TCP mode
3. Disconnect USB
4. Enter Echo IP address


Example:

    adb connect 192.168.x.x:5555



## Device Detection

Automatically detects:

- Echo model
- Android version
- LineageOS version
- Device codename


Supported devices:

| Device | Codename |
|---|---|
| Echo Show 5 Gen 1 | Checkers |
| Echo Show 5 Gen 2 | Cronos |
| Echo Show 8 Gen 1 | Crown |



# App Management


## Home Assistant Companion

Features:

- Detect installed version
- Download latest release
- Install/update automatically
- Cleanup afterwards


Package:

    io.homeassistant.companion.android.minimal


After installation you can apply:

- SYSTEM_ALERT_WINDOW permission
- Doze whitelist



## ViewAssist Companion

Features:

- Check latest GitHub release
- Download APK
- Install/update automatically


Repository:

    https://github.com/msp1974/ViewAssist_Companion_App



## F-Droid

Features:

- Install F-Droid APK
- Update existing installation
- Cleanup APK files



## Custom APK

Install any APK:

- Select local APK
- Install with adb install -r
- Cleanup afterwards



# Storage Management

Checks:

    /data

Shows:

- Total storage
- Used space
- Available space


Cleanup options:

- Remove APK files
- Remove BIN files
- Clear Android cache



# LineageOS Helper

Functions:

- Detect Echo model
- Open correct XDA thread
- Push LineageOS ZIP to device


Supported ROM threads:


## Echo Show 5 Gen 1

Checkers:

    https://xdaforums.com/t/rom-unofficial-11-checkers-lineageos-18-1-for-the-amazon-echo-show-5-2019.4763475/


## Echo Show 5 Gen 2

Cronos:

    https://xdaforums.com/t/rom-unofficial-11-cronos-lineageos-18-1-for-the-amazon-echo-show-5-2021.4772598/


## Echo Show 8 Gen 1

Crown:

    https://xdaforums.com/t/rom-unofficial-11-crown-lineageos-18-1-for-the-amazon-echo-show-8-2019.4766709/


The toolkit can upload:

    lineage-*.zip

to:

    /sdcard/


The ROM still has to be flashed manually using recovery/TWRP.



# Tweaks


## LineageOS Tweaks

Optional:

Disable:

- Contacts
- Recorder
- Calculator
- Music
- Calendar


Enable:

- Dark mode


Increase screen timeout:

- 30 minutes



## Home Assistant Tweaks

Optional:

Allow notifications:

    SYSTEM_ALERT_WINDOW


Prevent Android Doze killing Home Assistant:

    deviceidle whitelist



## Screen / Kiosk Tweaks

Optional:

Disable:

- Screensaver
- Doze
- Always-on display
- Wake pulses
- Lock screen



# Configuration

All device/app settings are stored in:

    Config.json


Contains:

- App package names
- GitHub release URLs
- Echo model mappings
- XDA links



# Safety Notes

This toolkit:

- Does not unlock bootloader
- Does not flash ROMs automatically
- Does not modify partitions
- Does not erase user data


Always create a backup before:

- ROM updates
- Recovery changes
- Major Android changes



# License

Personal use project.

Use at your own risk.
