# Inbox appx Source
# Auto = automatically search all local disks, default;
# Customize the path, for example, specify the F drive: $ISO = "F:\packages"
$ISO = "Auto"

# Mount Install to
$Mount = "D:\OS_11_Custom\Install\Install\Mount"

# Architecture
$Arch = "x64"

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
        #region Group 1
        @{
            Name = @( "Core"; "CoreN"; "CoreSingleLanguage"; )
            Apps = @(
                "Microsoft.UI.Xaml.2.3"
                "Microsoft.UI.Xaml.2.4"
                "Microsoft.UI.Xaml.2.7"
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"
                "Microsoft.HEIFImageExtension"
                "Microsoft.HEVCVideoExtension"
                "Microsoft.SecHealthUI"
                "Microsoft.VP9VideoExtensions"
                "Microsoft.WebpImageExtension"
                "Microsoft.WindowsStore"
                "Microsoft.GamingApp"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.ScreenSketch"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsTerminal"
                "Clipchamp.Clipchamp"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsMaps"
                "Microsoft.ZuneMusic"
                "Microsoft.BingNews"
                "Microsoft.BingWeather"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.WindowsCamera"
                "Microsoft.Getstarted"
                "Microsoft.Cortana"
                "Microsoft.GetHelp"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.People"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.WebMediaExtensions"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsCalculator"
                "Microsoft.windowscommunicationsapps"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.Xbox.TCUI"
                "Microsoft.XboxGameOverlay"
                "Microsoft.XboxGamingOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "Microsoft.ZuneVideo"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.RawImageExtension"
                "MicrosoftCorporationII.MicrosoftFamily"
            )
        }
        #endregion

        #region Group 2
        @{
            Name = @( "Education"; "Professional"; "ProfessionalEducation"; "ProfessionalWorkstation"; "Enterprise"; "IoTEnterprise"; "ServerRdsh"; "ServerStandard"; "ServerDatacenter"; )
            Apps = @(
                "Microsoft.UI.Xaml.2.3"
                "Microsoft.UI.Xaml.2.4"
                "Microsoft.UI.Xaml.2.7"
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"
                "Microsoft.HEIFImageExtension"
                "Microsoft.HEVCVideoExtension"
                "Microsoft.SecHealthUI"
                "Microsoft.VP9VideoExtensions"
                "Microsoft.WebpImageExtension"
                "Microsoft.WindowsStore"
                "Microsoft.GamingApp"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.ScreenSketch"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsTerminal"
                "Clipchamp.Clipchamp"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsMaps"
                "Microsoft.ZuneMusic"
                "Microsoft.BingNews"
                "Microsoft.BingWeather"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.WindowsCamera"
                "Microsoft.Getstarted"
                "Microsoft.Cortana"
                "Microsoft.GetHelp"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.People"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.WebMediaExtensions"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsCalculator"
                "Microsoft.windowscommunicationsapps"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.Xbox.TCUI"
                "Microsoft.XboxGameOverlay"
                "Microsoft.XboxGamingOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "Microsoft.ZuneVideo"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.RawImageExtension"
            )
        }
        #endregion

        #region Group 3
        @{
            Name = @( "EnterpriseN"; "EnterpriseGN"; "EnterpriseSN"; "ProfessionalN"; "EducationN"; "ProfessionalWorkstationN"; "ProfessionalEducationN"; "CloudN"; "CloudEN"; "CloudEditionLN"; "StarterN" )
            Apps = @(
                "Microsoft.UI.Xaml.2.3"
                "Microsoft.UI.Xaml.2.4"
                "Microsoft.UI.Xaml.2.7"
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"
                "Microsoft.SecHealthUI"
                "Microsoft.WindowsStore"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.ScreenSketch"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsTerminal"
                "Clipchamp.Clipchamp"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsMaps"
                "Microsoft.BingNews"
                "Microsoft.BingWeather"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.WindowsCamera"
                "Microsoft.Getstarted"
                "Microsoft.Cortana"
                "Microsoft.GetHelp"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.People"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsCalculator"
                "Microsoft.windowscommunicationsapps"
                "Microsoft.XboxGameOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
            )
        }
        #endregion
    )
    Rule = @(
        @{ Name = "Microsoft.UI.Xaml.2.3";                  Match = "UI.Xaml*{ARCHC}*2.3";               License = "UI.Xaml*{ARCHC}*2.3";               Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.UI.Xaml.2.4";                  Match = "UI.Xaml*{ARCHTag}*2.4";             License = "UI.Xaml*{ARCHTag}*2.4";             Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.UI.Xaml.2.7";                  Match = "UI.Xaml*{ARCHTag}*2.7";             License = "UI.Xaml*{ARCHTag}*2.7";             Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.UI.Xaml.2.8";                  Match = "UI.Xaml*{ARCHTag}*2.8";             License = "UI.Xaml*{ARCHTag}*2.8";             Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.NET.Native.Framework.2.2";     Match = "Native.Framework*{ARCHTag}*2.2";    License = "Native.Framework*{ARCHTag}*2.2";    Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.NET.Native.Runtime.2.2";       Match = "Native.Runtime*{ARCHTag}*2.2";      License = "Native.Runtime*{ARCHTag}*2.2";      Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.VCLibs.140.00";                Match = "VCLibs*{ARCHTag}";                  License = "VCLibs*{ARCHTag}";                  Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.VCLibs.140.00.UWPDesktop";     Match = "VCLibs*{ARCHTag}*Desktop";          License = "VCLibs*{ARCHTag}*Desktop";          Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.Services.Store.Engagement";    Match = "Services.Store.Engagement*{ARCHC}"; License = "Services.Store.Engagement*{ARCHC}"; Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.HEIFImageExtension";           Match = "HEIFImageExtension";                License = "HEIFImageExtension*";               Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.HEVCVideoExtension";           Match = "HEVCVideoExtension*{ARCHC}";        License = "HEVCVideoExtension*{ARCHC}*xml";    Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.SecHealthUI";                  Match = "SecHealthUI*{ARCHC}";               License = "SecHealthUI*{ARCHC}";               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.4", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.VP9VideoExtensions";           Match = "VP9VideoExtensions*{ARCHC}";        License = "VP9VideoExtensions*{ARCHC}";        Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WebpImageExtension";           Match = "WebpImageExtension*{ARCHC}";        License = "WebpImageExtension*{ARCHC}";        Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsStore";                 Match = "WindowsStore";                      License = "WindowsStore";                      Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.GamingApp";                    Match = "GamingApp";                         License = "GamingApp";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.3", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.MicrosoftStickyNotes";         Match = "MicrosoftStickyNotes";              License = "MicrosoftStickyNotes";              Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Paint";                        Match = "Paint";                             License = "Paint";                             Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.UI.Xaml.2.7"); }
        @{ Name = "Microsoft.PowerAutomateDesktop";         Match = "PowerAutomateDesktop";              License = "PowerAutomateDesktop";              Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.ScreenSketch";                 Match = "ScreenSketch";                      License = "ScreenSketch";                      Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsNotepad";               Match = "WindowsNotepad";                    License = "WindowsNotepad";                    Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.UI.Xaml.2.7"); }
        @{ Name = "Microsoft.WindowsTerminal";              Match = "WindowsTerminal";                   License = "WindowsTerminal";                   Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Clipchamp.Clipchamp";                    Match = "Clipchamp.Clipchamp";               License = "Clipchamp.Clipchamp";               Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.MicrosoftSolitaireCollection"; Match = "MicrosoftSolitaireCollection";      License = "MicrosoftSolitaireCollection";      Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsAlarms";                Match = "WindowsAlarms";                     License = "WindowsAlarms";                     Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsFeedbackHub";           Match = "WindowsFeedbackHub";                License = "WindowsFeedbackHub";                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsMaps";                  Match = "WindowsMaps";                       License = "WindowsMaps";                       Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.ZuneMusic";                    Match = "ZuneMusic";                         License = "ZuneMusic";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "MicrosoftCorporationII.MicrosoftFamily"; Match = "MicrosoftFamily";                   License = "MicrosoftFamily";                   Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.BingNews";                     Match = "BingNews";                          License = "BingNews";                          Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.BingWeather";                  Match = "BingWeather";                       License = "BingWeather";                       Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.DesktopAppInstaller";          Match = "DesktopAppInstaller";               License = "DesktopAppInstaller";               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsCamera";                Match = "WindowsCamera";                     License = "WindowsCamera";                     Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Getstarted";                   Match = "Getstarted";                        License = "Getstarted";                        Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Cortana";                      Match = "Cortana";                           License = "Cortana";                           Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.GetHelp";                      Match = "GetHelp";                           License = "GetHelp";                           Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.MicrosoftOfficeHub";           Match = "MicrosoftOfficeHub";                License = "MicrosoftOfficeHub";                Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.People";                       Match = "People";                            License = "People";                            Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.StorePurchaseApp";             Match = "StorePurchaseApp";                  License = "StorePurchaseApp";                  Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Todos";                        Match = "Todos";                             License = "Todos";                             Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.Services.Store.Engagement"); }
        @{ Name = "Microsoft.WebMediaExtensions";           Match = "WebMediaExtensions";                License = "WebMediaExtensions";                Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Windows.Photos";               Match = "Windows.Photos";                    License = "Windows.Photos";                    Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.4", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsCalculator";            Match = "WindowsCalculator";                 License = "WindowsCalculator";                 Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.windowscommunicationsapps";    Match = "WindowsCommunicationsApps";         License = "WindowsCommunicationsApps";         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsSoundRecorder";         Match = "WindowsSoundRecorder";              License = "WindowsSoundRecorder";              Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.3", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.Xbox.TCUI";                    Match = "Xbox.TCUI";                         License = "Xbox.TCUI";                         Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxGameOverlay";              Match = "XboxGameOverlay";                   License = "XboxGameOverlay";                   Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxGamingOverlay";            Match = "XboxGamingOverlay";                 License = "XboxGamingOverlay";                 Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxIdentityProvider";         Match = "XboxIdentityProvider";              License = "XboxIdentityProvider";              Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxSpeechToTextOverlay";      Match = "XboxSpeechToTextOverlay";           License = "XboxSpeechToTextOverlay";           Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.YourPhone";                    Match = "YourPhone";                         License = "YourPhone";                         Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.ZuneVideo";                    Match = "ZuneVideo";                         License = "ZuneVideo";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.7", "Microsoft.VCLibs.140.00"); }
        @{ Name = "MicrosoftCorporationII.QuickAssist";     Match = "QuickAssist";                       License = "QuickAssist";                       Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "MicrosoftWindows.Client.WebExperience";  Match = "WebExperience";                     License = "WebExperience";                     Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.MinecraftEducationEdition";    Match = "MinecraftEducationEdition";         License = "MinecraftEducationEdition";         Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.Whiteboard";                   Match = "Whiteboard";                        License = "Whiteboard";                        Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.RawImageExtension";            Match = "RawImageExtension";                 License = "RawImageExtension";                 Region = "All"; Dependencies = @(); }
    )
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

Function Match_InBox_Apps_Install_Pack
{
    param
    (
        $NewPath
    )

    <#
        .Transform variables
    #>
    $NewArch  = $Arch
    $NewArchC = $Arch.Replace("AMD64", "x64")

    $NewArchCTag = $Arch.Replace("AMD64", "x64")
    if ($Arch -eq "arm64") { $NewArchCTag = "arm" }

    if ($Pre_Config_Rules.Rule.Count -gt 0) {
        ForEach ($itemInBoxApps in $Pre_Config_Rules.Rule){
            $InstallPacker = ""
            $InstallPackerCert = ""

            <#
                .Substitute variables
            #>
            $SearchNewStructure = $itemInBoxApps.Match.Replace("{ARCH}", $NewArch).Replace("{ARCHC}", $NewArchC).Replace("{ARCHTag}", $NewArchCTag)
            $SearchNewLicense = $itemInBoxApps.License.Replace("{ARCH}", $NewArch).Replace("{ARCHC}", $NewArchC).Replace("{ARCHTag}", $NewArchCTag)

            Get-ChildItem -Path $NewPath -Filter "*$($SearchNewStructure)*" -Include "*.appx", "*.appxbundle", "*.msixbundle", "*.msix" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                if (Test-Path -Path $_.FullName -PathType Leaf) {

                    $InstallPacker = $_.FullName

                    Get-ChildItem -Path $NewPath -Filter "*$($SearchNewLicense)*" -Include *.xml -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        $InstallPackerCert = $_.FullName
                    }

                    $Script:InBoxAppx += @{
                        Name            = $itemInBoxApps.Name
                        Depend          = $itemInBoxApps.Dependencies
                        Region          = $itemInBoxApps.Region
                        Search          = $SearchNewStructure
                        InstallPacker   = $InstallPacker
                        Certificate     = $InstallPackerCert
                        CertificateRule = $SearchNewLicense
                    }

                    return
                }
            }
        }
    }
}

Write-Host "`n   InBox Apps: Installation packages, automatic search for full disk or specified paths" -ForegroundColor Yellow
Write-Host "   $('-' * 80)"
$Script:InBoxAppx = @()
if ($ISO -eq "Auto") {
    Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
        $AppPath = Join-Path -Path $_.Root -ChildPath "packages"
        Match_InBox_Apps_Install_Pack -NewPath $AppPath
    }
} else {
    Match_InBox_Apps_Install_Pack -NewPath $ISO
}
Write-Host "   Search Complete" -ForegroundColor Green

Write-Host "`n   InBox Apps: Installer Match Results" -ForegroundColor Yellow
Write-Host "   $('-' * 80)"
if ($Script:InBoxAppx.Count -gt 0) {
    Write-Host "   Match successful" -ForegroundColor Green
} else {
    Write-Host "   Failed match" -ForegroundColor Red
    return
}

Write-Host "`n   InBox Apps: Details of the application to be installed ( $($Script:InBoxAppx.Count) item )" -ForegroundColor Yellow
Write-Host "   $('-' * 80)"
ForEach ($Rule in $Script:InBoxAppx) {
    Write-Host "   Apps name: ".PadRight(22) -NoNewline; Write-Host $Rule.Name -ForegroundColor Yellow
    Write-Host "   Region: ".PadRight(22) -NoNewline; Write-Host $Rule.Region -ForegroundColor Yellow
    Write-Host "   Apps installer: ".PadRight(22) -NoNewline; Write-Host $Rule.InstallPacker -ForegroundColor Yellow
    Write-Host "   License: ".PadRight(22) -NoNewline; Write-Host $Rule.Certificate -ForegroundColor Yellow
    Write-Host
}

Write-Host "`n   InBox Apps: Installation" -ForegroundColor Yellow
Write-Host "   $('-' * 80)"
ForEach ($Rule in $Script:InBoxAppx) {
    Write-Host "   Name: " -NoNewline; Write-Host $Rule.Name -ForegroundColor Yellow
    Write-Host "   $('-' * 80)"

    if($Allow_Install_App -contains $Rule.Name) {
        Write-Host "   Search for apps: " -NoNewline; Write-Host $Rule.InstallPacker -ForegroundColor Yellow
        Write-Host "   Search for License: " -NoNewline; Write-Host $Rule.Certificate -ForegroundColor Yellow

        if (Test-Path -Path $Rule.InstallPacker -PathType Leaf) {
            Write-Host "   Region: " -NoNewline; Write-Host $Rule.Region -ForegroundColor Yellow

            if ([string]::IsNullOrEmpty($Rule.Certificate)) {
                Write-Host "   No License".PadRight(22) -NoNewline -ForegroundColor Red
                Write-Host "   Installing".PadRight(22) -NoNewline

                try {
                    Add-AppxProvisionedPackage -Path $Mount -PackagePath $Rule.InstallPacker -SkipLicense -Regions $Rule.Region -ErrorAction SilentlyContinue | Out-Null
                    Write-Host "Done`n" -ForegroundColor Green
                } catch {
                    Write-Host "Failed" -ForegroundColor Red
                    Write-Host "   $($_)`n" -ForegroundColor Red
                }
            } else {
                if (Test-Path -Path $Rule.Certificate -PathType Leaf) {
                    Write-Host "   License: " -NoNewline
                    Write-Host $Rule.Certificate -ForegroundColor Yellow

                    Write-Host "   With License".PadRight(22) -NoNewline -ForegroundColor Green
                    Write-Host "   Installing".PadRight(22) -NoNewline

                    try {
                       Add-AppxProvisionedPackage -Path $Mount -PackagePath $Rule.InstallPacker -LicensePath $Rule.Certificate -Regions $Rule.Region -ErrorAction SilentlyContinue | Out-Null
                       Write-Host "Done`n" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed" -ForegroundColor Red
                        Write-Host "   $($_)`n" -ForegroundColor Red
                    }
                } else {
                    Write-Host "   No License".PadRight(22) -NoNewline -ForegroundColor Red
                    Write-Host "   Installing".PadRight(22) -NoNewline

                    try {
                        Add-AppxProvisionedPackage -Path $Mount -PackagePath $Rule.InstallPacker -SkipLicense -Regions $Rule.Region -ErrorAction SilentlyContinue | Out-Null
                        Write-Host "Done`n" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed" -ForegroundColor Red
                        Write-Host "   $($_)`n" -ForegroundColor Red
                    }
                }
            }
        } else {
            Write-Host "   The installation package does not exist" -ForegroundColor Red
        }
    } else {
        Write-Host "   Skip the installation`n" -ForegroundColor Red
    }
}
