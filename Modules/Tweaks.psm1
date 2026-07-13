function Invoke-Tweak {


    param(
        [string]$Command
    )


    Write-Host ""
    Write-Host "Running:"
    Write-Host $Command -ForegroundColor Cyan


    Invoke-Adb "shell $Command"
}



function Ask-Tweak {


    param(
        [string]$Name,
        [string]$Command
    )


    $Answer =
        Read-Host "$Name? (Y/N)"



    if ($Answer -match "^[Yy]$") {

        Invoke-Tweak $Command
    }
}



function Apply-LineageTweaks {


    Write-Host ""
    Write-Host "LineageOS Tweaks" -ForegroundColor Cyan
    Write-Host ""



    Ask-Tweak `
        "Disable Contacts" `
        "pm disable-user com.android.contacts"



    Ask-Tweak `
        "Disable Recorder" `
        "pm disable-user org.lineageos.recorder"



    Ask-Tweak `
        "Disable Calculator" `
        "pm disable-user com.android.calculator2"



    Ask-Tweak `
        "Disable Music Player" `
        "pm disable-user org.lineageos.eleven"



    Ask-Tweak `
        "Disable Calendar" `
        "pm disable-user org.lineageos.etar"



    Ask-Tweak `
        "Set screen timeout to 30 minutes" `
        "settings put system screen_off_timeout 1800000"



    Ask-Tweak `
        "Enable Dark Mode" `
        "cmd uimode night yes"



    Write-Host ""
    Write-Host "LineageOS tweaks finished." -ForegroundColor Green
}



function Apply-HomeAssistantTweaks {


    Write-Host ""
    Write-Host "Home Assistant Companion Tweaks" -ForegroundColor Cyan
    Write-Host ""



    $Config =
        Get-ToolkitConfig



    $Package =
        $Config.HomeAssistant.PackageName



    Ask-Tweak `
        "Allow overlay notifications" `
        "appops set $Package SYSTEM_ALERT_WINDOW allow"



    Ask-Tweak `
        "Whitelist Home Assistant from Doze" `
        "dumpsys deviceidle whitelist +$Package"



    Write-Host ""
    Write-Host "Home Assistant tweaks finished." -ForegroundColor Green
}



function Apply-ScreenTweaks {


    Write-Host ""
    Write-Host "Screen / Kiosk Tweaks" -ForegroundColor Cyan
    Write-Host ""



    Ask-Tweak `
        "Disable screensaver" `
        "settings put secure screensaver_enabled 0"



    Ask-Tweak `
        "Disable screensaver on sleep" `
        "settings put secure screensaver_activate_on_sleep 0"



    Ask-Tweak `
        "Disable screensaver on dock" `
        "settings put secure screensaver_activate_on_dock 0"



    Ask-Tweak `
        "Disable Doze" `
        "settings put secure doze_enabled 0"



    Ask-Tweak `
        "Disable Always On Doze" `
        "settings put secure doze_always_on 0"



    Ask-Tweak `
        "Disable pickup pulse" `
        "settings put secure doze_pulse_on_pick_up 0"



    Ask-Tweak `
        "Disable double tap pulse" `
        "settings put secure doze_pulse_on_double_tap 0"



    Ask-Tweak `
        "Disable lockscreen" `
        "locksettings set-disabled true"



    Write-Host ""
    Write-Host "Screen tweaks finished." -ForegroundColor Green
}
