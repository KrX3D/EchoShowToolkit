function Show-LineageMenu {


    while ($true) {


        Write-Host ""
        Write-Host "================================" -ForegroundColor Cyan
        Write-Host " LineageOS Helper"
        Write-Host "================================"
        Write-Host ""



        $Device =
            Get-LineageDeviceInfo



        if ($Device) {

            Write-Host "Detected:"
            Write-Host $Device.Name -ForegroundColor Green

        }

        else {

            Write-Host "Unknown device" -ForegroundColor Yellow
        }



        Write-Host ""
        Write-Host "1 - Open XDA LineageOS page"
        Write-Host "2 - Push LineageOS ZIP to Echo"
        Write-Host "0 - Back"
        Write-Host ""



        $Choice =
            Read-Host "Select"



        switch ($Choice) {


            "1" {

                Open-LineagePage
            }


            "2" {

                Push-LineageZip
            }


            "0" {

                break
            }
        }
    }
}



function Open-LineagePage {


    $Device =
        Get-LineageDeviceInfo



    if (-not $Device) {

        Write-Host ""
        Write-Host "Unknown Echo model." -ForegroundColor Red
        return
    }



    Write-Host ""
    Write-Host "Opening:"
    Write-Host $Device.XdaUrl



    Start-Process $Device.XdaUrl
}



function Push-LineageZip {


    $Device =
        Get-LineageDeviceInfo



    if (-not $Device) {

        Write-Host ""
        Write-Host "Unknown Echo model." -ForegroundColor Red
        return
    }



    Write-Host ""
    Write-Host "Device:"
    Write-Host $Device.Name -ForegroundColor Green

    Write-Host ""

    Write-Host "Steps:"
    Write-Host "1. Download the correct LineageOS ZIP"
    Write-Host "2. Boot Echo into TWRP"
    Write-Host "3. Connect USB"
    Write-Host ""



    $Zip =
        Read-Host "Path to Lineage ZIP"



    if (-not (Test-Path $Zip)) {


        Write-Host "ZIP not found." -ForegroundColor Red
        return
    }



    if ([IO.Path]::GetExtension($Zip) -ne ".zip") {


        Write-Host "Selected file is not a ZIP." -ForegroundColor Red
        return
    }



    Write-Host ""
    Write-Host "Uploading ZIP..." -ForegroundColor Cyan



    $Adb =
        Get-AdbPath



    & $Adb push "$Zip" "/sdcard/"



    if ($LASTEXITCODE -eq 0) {


        Write-Host ""
        Write-Host "Upload complete." -ForegroundColor Green


        Write-Host ""
        Write-Host "File on Echo:"
        Write-Host "/sdcard/$(Split-Path $Zip -Leaf)"

    }

    else {


        Write-Host ""
        Write-Host "Upload failed." -ForegroundColor Red
    }
}
