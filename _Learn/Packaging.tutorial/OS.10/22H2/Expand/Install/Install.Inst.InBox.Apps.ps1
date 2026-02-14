Function InBoxApps
{
    param
    (
        $Arch,
        $Mount,
        $ISO
    )

    Function Install_Appx
    {
        param
        (
            $File,
            $License
        )

        Write-Host "   $('-' * 80)"
        Write-Host "   Installing: " -NoNewline; Write-Host $File -ForegroundColor Yellow

        if (Test-Path -Path $File -PathType Leaf) {
            if (Test-Path -Path $License -PathType Leaf) {
                Write-Host "   License: " -NoNewline
                Write-Host $License -ForegroundColor Yellow

                Write-Host "   With License".PadRight(22) -NoNewline -ForegroundColor Green
                Write-Host "   Installing".PadRight(22) -NoNewline

                try {
                   Add-AppxProvisionedPackage -Path $Mount -PackagePath $File -LicensePath $License -ErrorAction SilentlyContinue | Out-Null
                   Write-Host "Done" -ForegroundColor Green
                } catch {
                    Write-Host "Failed" -ForegroundColor Red
                    Write-Host "   $($_)" -ForegroundColor Red
                }
            } else {
                Write-Host "   No License".PadRight(22) -NoNewline -ForegroundColor Red
                Write-Host "   Installing".PadRight(22) -NoNewline

                try {
                    Add-AppxProvisionedPackage -Path $Mount -PackagePath $File -SkipLicense -ErrorAction SilentlyContinue | Out-Null
                    Write-Host "Done" -ForegroundColor Green
                } catch {
                    Write-Host "Failed" -ForegroundColor Red
                    Write-Host "   $($_)" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "   The installation package does not exist" -ForegroundColor Red
        }
    }

    try {
        Write-Host "`n   Offline image version: " -NoNewline
        $Current_Edition_Version = (Get-WindowsEdition -Path $Mount).Edition
        Write-Host $Current_Edition_Version -ForegroundColor Green
    } catch {
        Write-Host "Error" -ForegroundColor Red
        Write-Host "   $($_)" -ForegroundColor Yellow
        return
    }

    $Pre_Config_Rules = @{
        Edition = @(
            @{
                Name = @(
                    "Core"
                    "CoreSingleLanguage"
                    "Education"
                    "Professional"
                    "ProfessionalEducation"
                    "ProfessionalWorkstation"
                    "Enterprise"
                    "IoTEnterprise"
                    "ServerRdsh"
                )
                Apps = @(
                    "Microsoft.UI.Xaml.2.0"
                    "Microsoft.UI.Xaml.2.1"
                    "Microsoft.UI.Xaml.2.3"
                    "Microsoft.Advertising.Xaml"
                    "Microsoft.NET.Native.Framework.1.7"
                    "Microsoft.NET.Native.Framework.2.2"
                    "Microsoft.NET.Native.Runtime.1.7"
                    "Microsoft.NET.Native.Runtime.2.2"
                    "Microsoft.VCLibs.140.00"
                    "Microsoft.VCLibs.140.00.UWPDesktop"
                    "Microsoft.Services.Store.Engagement"
                    "Microsoft.HEIFImageExtension"
                    "Microsoft.WebpImageExtension"
                    "Microsoft.VP9VideoExtensions"
                    "Microsoft.WindowsStore"
                    "Microsoft.Xbox.TCUI"
                    "Microsoft.XboxApp"
                    "Microsoft.XboxGameOverlay"
                    "Microsoft.XboxGamingOverlay"
                    "Microsoft.XboxIdentityProvider"
                    "Microsoft.XboxSpeechToTextOverlay"
                    "Microsoft.Cortana"
                    "Microsoft.BingWeather"
                    "Microsoft.DesktopAppInstaller"
                    "Microsoft.GetHelp"
                    "Microsoft.Getstarted"
                    "Microsoft.Microsoft3DViewer"
                    "Microsoft.MicrosoftOfficeHub"
                    "Microsoft.Solitaire.Collection"
                    "Microsoft.Sticky.Notes"
                    "Microsoft.MixedReality.Portal"
                    "Microsoft.MSPaint"
                    "Microsoft.Office.OneNote"
                    "Microsoft.People"
                    "Microsoft.ScreenSketch"
                    "Microsoft.SkypeApp"
                    "Microsoft.StorePurchaseApp"
                    "Microsoft.Wallet"
                    "Microsoft.WebMediaExtensions"
                    "Microsoft.Windows.Photos"
                    "Microsoft.WindowsAlarms"
                    "Microsoft.WindowsCalculator"
                    "Microsoft.WindowsCamera"
                    "Microsoft.Windows.CommunicationsApps"
                    "Microsoft.WindowsFeedbackHub"
                    "Microsoft.WindowsMaps"
                    "Microsoft.WindowsSoundRecorder"
                    "Microsoft.YourPhone"
                    "Microsoft.ZuneMusic"
                    "Microsoft.ZuneVideo"
                )
            }
            @{
                Name = @(
                    "EnterpriseN"
                    "EnterpriseGN"
                    "ProfessionalN"
                    "CoreN"
                    "EducationN"
                    "ProfessionalWorkstationN"
                    "ProfessionalEducationN"
                    "CloudN"
                    "CloudEN"
                    "CloudEditionN"
                    "CloudEditionLN"
                    "StarterN"
                )
                Apps = @(
                    "Microsoft.UI.Xaml.2.0"
                    "Microsoft.UI.Xaml.2.1"
                    "Microsoft.UI.Xaml.2.3"
                    "Microsoft.Advertising.Xaml"
                    "Microsoft.NET.Native.Framework.1.7"
                    "Microsoft.NET.Native.Framework.2.2"
                    "Microsoft.NET.Native.Runtime.1.7"
                    "Microsoft.NET.Native.Runtime.2.2"
                    "Microsoft.VCLibs.140.00"
                    "Microsoft.VCLibs.140.00.UWPDesktop"
                    "Microsoft.Services.Store.Engagement"
                    "Microsoft.WindowsStore"
                    "Microsoft.XboxApp"
                    "Microsoft.XboxGameOverlay"
                    "Microsoft.XboxIdentityProvider"
                    "Microsoft.XboxSpeechToTextOverlay"
                    "Microsoft.Cortana"
                    "Microsoft.BingWeather"
                    "Microsoft.DesktopAppInstaller"
                    "Microsoft.GetHelp"
                    "Microsoft.Getstarted"
                    "Microsoft.Microsoft3DViewer"
                    "Microsoft.MicrosoftOfficeHub"
                    "Microsoft.Solitaire.Collection"
                    "Microsoft.Sticky.Notes"
                    "Microsoft.MSPaint"
                    "Microsoft.Office.OneNote"
                    "Microsoft.People"
                    "Microsoft.ScreenSketch"
                    "Microsoft.StorePurchaseApp"
                    "Microsoft.Wallet"
                    "Microsoft.Windows.Photos"
                    "Microsoft.WindowsAlarms"
                    "Microsoft.WindowsCalculator"
                    "Microsoft.WindowsCamera"
                    "Microsoft.Windows.CommunicationsApps"
                    "Microsoft.WindowsFeedbackHub"
                    "Microsoft.WindowsMaps"
                    "Microsoft.YourPhone"
                )
            }
        )
        Rule = @(
            @{ Name = "Microsoft.UI.Xaml.2.0";                   Match = "UI.Xaml*{ARCHC}*2.0";               License = ""; }
            @{ Name = "Microsoft.UI.Xaml.2.1";                   Match = "UI.Xaml*{ARCHC}*2.1";               License = ""; }
            @{ Name = "Microsoft.UI.Xaml.2.3";                   Match = "UI.Xaml*{ARCHC}*2.3";               License = ""; }
            @{ Name = "Microsoft.Advertising.Xaml";              Match = "Advertising.Xaml";                  License = ""; }
            @{ Name = "Microsoft.NET.Native.Framework.1.7";      Match = "Native.Framework*1.7";              License = ""; }
            @{ Name = "Microsoft.NET.Native.Framework.2.2";      Match = "Native.Framework*2.2";              License = ""; }
            @{ Name = "Microsoft.NET.Native.Runtime.1.7";        Match = "Native.Runtime*1.7";                License = ""; }
            @{ Name = "Microsoft.NET.Native.Runtime.2.2";        Match = "Native.Runtime*2.2";                License = ""; }
            @{ Name = "Microsoft.VCLibs.140.00";                 Match = "VCLibs*14.00";                      License = ""; }
            @{ Name = "Microsoft.VCLibs.140.00.UWPDesktop";      Match = "VCLibs*Desktop";                    License = ""; }
            @{ Name = "Microsoft.Services.Store.Engagement";     Match = "Services.Store.Engagement";         License = ""; }
            @{ Name = "Microsoft.HEIFImageExtension";            Match = "HEIFImageExtension";                License = "HEIFImageExtension"; }
            @{ Name = "Microsoft.WebpImageExtension";            Match = "WebpImageExtension";                License = "WebpImageExtension"; }
            @{ Name = "Microsoft.VP9VideoExtensions";            Match = "VP9VideoExtensions";                License = "VP9VideoExtensions"; }
            @{ Name = "Microsoft.WindowsStore";                  Match = "WindowsStore";                      License = "WindowsStore"; }
            @{ Name = "Microsoft.Xbox.TCUI";                     Match = "Xbox.TCUI";                         License = "Microsoft.Xbox.TCUI_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.XboxApp";                       Match = "XboxApp";                           License = "Microsoft.XboxApp_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.XboxGameOverlay";               Match = "XboxGameOverlay";                   License = "Microsoft.XboxGameOverlay_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.XboxGamingOverlay";             Match = "XboxGamingOverlay";                 License = "Microsoft.XboxGamingOverlay_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.XboxIdentityProvider";          Match = "XboxIdentityProvider";              License = "Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.XboxSpeechToTextOverlay";       Match = "XboxSpeechToTextOverlay";           License = "Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Cortana";                       Match = "Cortana";                           License = "Cortana"; }
            @{ Name = "Microsoft.BingWeather";                   Match = "BingWeather";                       License = "BingWeather"; }
            @{ Name = "Microsoft.DesktopAppInstaller";           Match = "DesktopAppInstaller";               License = "DesktopAppInstaller"; }
            @{ Name = "Microsoft.GetHelp";                       Match = "Microsoft.GetHelp";                 License = "Microsoft.GetHelp_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Getstarted";                    Match = "Microsoft.Getstarted";              License = "Microsoft.Getstarted_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Microsoft3DViewer";             Match = "Microsoft.Microsoft3DViewer";       License = "Microsoft.Microsoft3DViewer_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.MicrosoftOfficeHub";            Match = "MicrosoftOfficeHub";                License = "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Solitaire.Collection";          Match = "MicrosoftSolitaireCollection";      License = "MicrosoftSolitaireCollection"; }
            @{ Name = "Microsoft.Sticky.Notes";                  Match = "MicrosoftStickyNotes";              License = "MicrosoftStickyNotes"; }
            @{ Name = "Microsoft.MixedReality.Portal";           Match = "MixedReality.Portal";               License = "Microsoft.MixedReality.Portal_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.MSPaint";                       Match = "MSPaint";                           License = "Microsoft.MSPaint_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Office.OneNote";                Match = "Office.OneNote";                    License = "Office.OneNote"; }
            @{ Name = "Microsoft.People";                        Match = "People";                            License = "Microsoft.People_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.ScreenSketch";                  Match = "ScreenSketch";                      License = "Microsoft.ScreenSketch_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.SkypeApp";                      Match = "SkypeApp";                          License = "Microsoft.SkypeApp_kzf8qxf38zg5c.xml"; }
            @{ Name = "Microsoft.StorePurchaseApp";              Match = "StorePurchaseApp";                  License = "Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Wallet";                        Match = "Wallet";                            License = "Microsoft.Wallet_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WebMediaExtensions";            Match = "WebMediaExtensions";                License = "Microsoft.WebMediaExtensions_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Windows.Photos";                Match = "Windows.Photos";                    License = "Microsoft.Windows.Photos_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsAlarms";                 Match = "WindowsAlarms";                     License = "Microsoft.WindowsAlarms_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsCalculator";             Match = "WindowsCalculator";                 License = "Microsoft.WindowsCalculator_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsCamera";                 Match = "WindowsCamera";                     License = "Microsoft.WindowsCamera_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.Windows.CommunicationsApps";    Match = "windowscommunicationsapps";         License = "Microsoft.WindowsCommunicationsApps_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsFeedbackHub";            Match = "WindowsFeedbackHub";                License = "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsMaps";                   Match = "WindowsMaps";                       License = "Microsoft.WindowsMaps_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.WindowsSoundRecorder";          Match = "WindowsSoundRecorder";              License = "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.YourPhone";                     Match = "YourPhone";                         License = "Microsoft.YourPhone_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.ZuneMusic";                     Match = "ZuneMusic";                         License = "Microsoft.ZuneMusic_8wekyb3d8bbwe.xml"; }
            @{ Name = "Microsoft.ZuneVideo";                     Match = "ZuneVideo";                         License = "Microsoft.ZuneVideo_8wekyb3d8bbwe.xml"; }
        )
    }

    switch ($Arch) {
        "x86" { $NewArch = "x86fre" }
        "x64" { $NewArch = "amd64fre"}
        "arm64" { $NewArch = "arm64fre"}
    }

    $Allow_Install_App = @()
    ForEach ($item in $Pre_Config_Rules.Edition) {
        if ($item.Name -contains $Current_Edition_Version) {
            Write-Host "`n   Match to: "-NoNewline; Write-Host $Current_Edition_Version -ForegroundColor Green

            $Allow_Install_App = $item.Apps
            break
        }
    }

    Write-Host "`n   The app to install ( $($Allow_Install_App.Count) item )" -ForegroundColor Yellow
    Write-Host "   $('-' * 80)"
    ForEach ($item in $Allow_Install_App) {
        Write-Host "   $($item)" -ForegroundColor Green
    }

    ForEach ($Rule in $Pre_Config_Rules.Rule) {
        Write-Host "`n   Name: " -NoNewline; Write-Host $Rule.Name -ForegroundColor Yellow
        Write-Host "   $('-' * 80)"

        if($Allow_Install_App -contains $Rule.Name) {
            Write-Host "   Search for apps: " -NoNewline; Write-Host $Rule.File -ForegroundColor Yellow
            Write-Host "   Search for License: " -NoNewline; Write-Host $Rule.License -ForegroundColor Yellow

            if ($ISO -eq "Auto") {
                Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
                    $AppPath = Join-Path -Path $_.Root -ChildPath "$($NewArch)\$($Rule.File)"
                    $LicensePath = Join-Path -Path $_.Root -ChildPath "$($NewArch)\$($Rule.License)"

                    if (Test-Path $AppPath -PathType Leaf) {
                        Write-Host "   $('-' * 80)"
                        Write-Host "   Discover apps: " -NoNewLine; Write-Host $AppPath -ForegroundColor Green

                        if (Test-Path $LicensePath -PathType Leaf) {
                            Write-Host "   Discover License: " -NoNewLine; Write-Host $LicensePath -ForegroundColor Green
                        } else {
                            Write-Host "   License: " -NoNewLine; Write-Host "Not found" -ForegroundColor Red
                        }

                        Install_Appx -File $AppPath -License $LicensePath
                        return
                    }
                }
            } else {
                Install_Appx -File "$($ISO)\$($Rule.File)" -License "$($ISO)\$($Rule.License)"
            }
        } else {
            Write-Host "   Skip the installation" -ForegroundColor Red
        }
    }
}

InBoxApps -Arch "x64" -Mount "D:\ISOTemp_Custom\Install\Install\Mount" -ISO "Auto"
