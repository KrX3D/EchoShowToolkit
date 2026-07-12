function Invoke-TweakCommand {

    param(
        [string]$Command
    )

    Write-Host ""
    Write-Host $Command

    Invoke-Adb "shell $Command"
}



function Apply-LineageTweaks {


    Write-Host ""
    Write-Host "LineageOS Tweaks" -ForegroundColor Cyan
    Write-Host ""


    $Options = @(
        @{
            Name="Disable Contacts"
            Cmd="pm disable-user com.android.contacts"
        },
        @{
            Name="Disable Recorder"
            Cmd="pm disable-user org.lineageos.recorder"
        },
        @{
            Name="Disable Calculator"
            Cmd="pm disable-user com.android.calculator2"
        },
        @{
            Name="Disable Music"
            Cmd="pm disable-user org.lineageos.eleven"
        },
        @{
            Name="Disable Calendar"
            Cmd="pm disable-user org.lineageos.etar"
        }
    )


    foreach ($Option in $Options) {

        $Answer = Read-Host "$($Option.Name)? (Y/N)"

        if ($Answer -match "^[Yy]$") {

            Invoke-TweakCommand $Option.Cmd
        }
    }


    $Timeout = Read-Host "Set screen timeout to 30 minutes? (Y/N)"

    if ($Timeout -match "^[Yy]$") {

        Invoke-TweakCommand "settings put system screen_off_timeout 1800000"
    }


    $Dark = Read-Host "Enable dark mode? (Y/N)"

    if ($Dark -match "^[Yy]$") {

        Invoke-TweakCommand "cmd uimode night yes"
    }

}



function Apply-HomeAssistantTweaks {


    Write-Host ""
    Write-Host "Home Assistant Tweaks" -ForegroundColor Cyan


    $Overlay = Read-Host "Allow SYSTEM_ALERT_WINDOW? (Y/N)"

    if ($Overlay -match "^[Yy]$") {

        Invoke-TweakCommand `
        "appops set io.homeassistant.companion.android.minimal SYSTEM_ALERT_WINDOW allow"
    }


    $Whitelist = Read-Host "Add Home Assistant to device idle whitelist? (Y/N)"

    if ($Whitelist -match "^[Yy]$") {

        Invoke-TweakCommand `
        "dumpsys deviceidle whitelist +io.homeassistant.companion.android.minimal"
    }

}



function Apply-ScreenTweaks {


    Write-Host ""
    Write-Host "Screen / Doze Tweaks" -ForegroundColor Cyan


    $Commands = @(
        "settings put secure screensaver_enabled 0",
        "settings put secure screensaver_activate_on_sleep 0",
        "settings put secure screensaver_activate_on_dock 0",
        "settings put secure doze_enabled 0",
        "settings put secure doze_always_on 0",
        "settings put secure doze_pulse_on_pick_up 0",
        "settings put secure doze_pulse_on_double_tap 0",
        "locksettings set-disabled true"
    )


    foreach ($Cmd in $Commands) {

        $Answer = Read-Host "Apply '$Cmd'? (Y/N)"

        if ($Answer -match "^[Yy]$") {

            Invoke-TweakCommand $Cmd
        }
    }

}
