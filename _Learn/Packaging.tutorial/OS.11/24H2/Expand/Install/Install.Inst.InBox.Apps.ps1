# Inbox appx Source
# Auto = automatically search all local disks, default;
# Customize the path, for example, specify the F drive: $ISO = "F:\packages"
$ISO = "Auto"

# Mount Install to
$Mount = "D:\ISOTemp_Custom\Install\Install\Mount"

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
            Name = @(
                "Core"
                "CoreSingleLanguage"
            )
            Apps = @(
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.WindowsAppRuntime.1.5"
                "Microsoft.WindowsAppRuntime.1.6"
                "Microsoft.WindowsAppRuntime.1.7"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"

                "Clipchamp.Clipchamp"
                "Microsoft.ApplicationCompatibilityEnhancements"
                "Microsoft.AV1VideoExtension"
                "Microsoft.AVCEncoderVideoExtension"
                "Microsoft.BingNews"
                "Microsoft.BingSearch"
                "Microsoft.BingWeather"
                "Microsoft.Copilot"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.GamingApp"
                "Microsoft.GetHelp"
                "Microsoft.HEIFImageExtension"
                "Microsoft.HEVCVideoExtension"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.MPEG2VideoExtension"
                "Microsoft.OutlookForWindows"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.RawImageExtension"
                "Microsoft.ScreenSketch"
                "Microsoft.SecHealthUI"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.VP9VideoExtensions"
                "Microsoft.WebMediaExtensions"
                "Microsoft.WebpImageExtension"
                "Microsoft.Windows.DevHome"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsCalculator"
                "Microsoft.WindowsCamera"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.WindowsStore"
                "Microsoft.WindowsTerminal"
                "Microsoft.Xbox.TCUI"
                "Microsoft.XboxGamingOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "Microsoft.ZuneMusic"
                "MicrosoftCorporationII.MicrosoftFamily"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.CrossDevice"
                "MSTeams"
            )
        }
        #endregion

        #region Group 2
        @{
            Name = @(
                "CoreN"
            )
            Apps = @(
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.WindowsAppRuntime.1.5"
                "Microsoft.WindowsAppRuntime.1.6"
                "Microsoft.WindowsAppRuntime.1.7"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"

                "Clipchamp.Clipchamp"
                "Microsoft.ApplicationCompatibilityEnhancements"
                "Microsoft.BingNews"
                "Microsoft.BingSearch"
                "Microsoft.BingWeather"
                "Microsoft.Copilot"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.GetHelp"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.OutlookForWindows"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.ScreenSketch"
                "Microsoft.SecHealthUI"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsCalculator"
                "Microsoft.WindowsCamera"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsStore"
                "Microsoft.WindowsTerminal"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "MicrosoftCorporationII.MicrosoftFamily"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.CrossDevice"
                "MSTeams"
            )
        }
        #endregion

        #region Group 3
        @{
            Name = @(
                "Education"
                "Professional"
                "ProfessionalEducation"
                "ProfessionalWorkstation"
                "Enterprise"
                "IoTEnterprise"
                "IoTEnterpriseK"
                "ServerRdsh"

#                "ServerStandardCore"
                "ServerStandard"
#                "ServerDataCenterCore"
                "ServerDatacenter"
            )
            Apps = @(
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.WindowsAppRuntime.1.5"
                "Microsoft.WindowsAppRuntime.1.6"
                "Microsoft.WindowsAppRuntime.1.7"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"

                "Clipchamp.Clipchamp"
                "Microsoft.ApplicationCompatibilityEnhancements"
                "Microsoft.AV1VideoExtension"
                "Microsoft.AVCEncoderVideoExtension"
                "Microsoft.BingNews"
                "Microsoft.BingSearch"
                "Microsoft.BingWeather"
                "Microsoft.Copilot"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.GamingApp"
                "Microsoft.GetHelp"
                "Microsoft.HEIFImageExtension"
                "Microsoft.HEVCVideoExtension"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.MPEG2VideoExtension"
                "Microsoft.OutlookForWindows"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.RawImageExtension"
                "Microsoft.ScreenSketch"
                "Microsoft.SecHealthUI"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.VP9VideoExtensions"
                "Microsoft.WebMediaExtensions"
                "Microsoft.WebpImageExtension"
                "Microsoft.Windows.DevHome"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsCalculator"
                "Microsoft.WindowsCamera"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsSoundRecorder"
                "Microsoft.WindowsStore"
                "Microsoft.WindowsTerminal"
                "Microsoft.Xbox.TCUI"
                "Microsoft.XboxGamingOverlay"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "Microsoft.ZuneMusic"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.CrossDevice"
                "MSTeams"
            )
        }
        #endregion

        #region Group 4
        @{
            Name = @(
                "EducationN"
                "ProfessionalN"
                "ProfessionalEducationN"
                "ProfessionalWorkstationN"
                "EnterpriseN"
                "EnterpriseGN"
                "EnterpriseSN"
                "CloudN"
                "CloudEN"
                "CloudEditionLN"
                "StarterN"
            )
            Apps = @(
                "Microsoft.UI.Xaml.2.8"
                "Microsoft.WindowsAppRuntime.1.5"
                "Microsoft.WindowsAppRuntime.1.6"
                "Microsoft.WindowsAppRuntime.1.7"
                "Microsoft.NET.Native.Framework.2.2"
                "Microsoft.NET.Native.Runtime.2.2"
                "Microsoft.VCLibs.140.00"
                "Microsoft.VCLibs.140.00.UWPDesktop"
                "Microsoft.Services.Store.Engagement"

                "Clipchamp.Clipchamp"
                "Microsoft.ApplicationCompatibilityEnhancements"
                "Microsoft.BingNews"
                "Microsoft.BingSearch"
                "Microsoft.BingWeather"
                "Microsoft.Copilot"
                "Microsoft.DesktopAppInstaller"
                "Microsoft.GetHelp"
                "Microsoft.MicrosoftOfficeHub"
                "Microsoft.MicrosoftSolitaireCollection"
                "Microsoft.MicrosoftStickyNotes"
                "Microsoft.OutlookForWindows"
                "Microsoft.Paint"
                "Microsoft.PowerAutomateDesktop"
                "Microsoft.ScreenSketch"
                "Microsoft.SecHealthUI"
                "Microsoft.StorePurchaseApp"
                "Microsoft.Todos"
                "Microsoft.Windows.Photos"
                "Microsoft.WindowsAlarms"
                "Microsoft.WindowsCalculator"
                "Microsoft.WindowsCamera"
                "Microsoft.WindowsFeedbackHub"
                "Microsoft.WindowsNotepad"
                "Microsoft.WindowsStore"
                "Microsoft.WindowsTerminal"
                "Microsoft.XboxIdentityProvider"
                "Microsoft.XboxSpeechToTextOverlay"
                "Microsoft.YourPhone"
                "MicrosoftCorporationII.QuickAssist"
                "MicrosoftWindows.Client.WebExperience"
                "Microsoft.CrossDevice"
                "MSTeams"
            )
        }
        #endregion

        #region Group 5
        @{
            Name = @(
                "EnterpriseS"
                "EnterpriseSN"
                "IoTEnterpriseS"
                "IoTEnterpriseSK"
            )
            Apps = @(
                "Microsoft.SecHealthUI"
            )
        }
    )
    Rule = @(
        @{ Name = "Microsoft.UI.Xaml.2.8";                          Match = "UI.Xaml*{ARCHTag}*2.8";                       License = "UI.Xaml*{ARCHTag}*2.8";                       Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.WindowsAppRuntime.1.5";                Match = "WindowsAppRuntime.{ARCHC}.1.5";               License = "WindowsAppRuntime.{ARCHC}.1.5";               Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.WindowsAppRuntime.1.6";                Match = "WindowsAppRuntime.{ARCHC}.1.6";               License = "WindowsAppRuntime.{ARCHC}.1.6";               Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.WindowsAppRuntime.1.7";                Match = "WindowsAppRuntime.{ARCHC}.1.7";               License = "WindowsAppRuntime.{ARCHC}.1.7";               Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.NET.Native.Framework.2.2";             Match = "Native.Framework*{ARCHTag}*2.2";              License = "Native.Framework*{ARCHTag}*2.2";              Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.NET.Native.Framework.2.2";             Match = "Native.Framework*{ARCHTag}*2.2";              License = "Native.Framework*{ARCHTag}*2.2";              Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.NET.Native.Runtime.2.2";               Match = "Native.Runtime*{ARCHTag}*2.2";                License = "Native.Runtime*{ARCHTag}*2.2";                Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.VCLibs.140.00";                        Match = "Microsoft.VCLibs.{ARCHTag}.14.00.appx";       License = "VCLibs.{ARCHTag}.14.00.appx";                 Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.VCLibs.140.00.UWPDesktop";             Match = "Microsoft.VCLibs.{ARCHTag}.14.00.UWPDesktop"; License = "Microsoft.VCLibs.{ARCHTag}.14.00.UWPDesktop"; Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.Services.Store.Engagement";            Match = "Services.Store.Engagement*{ARCHC}";           License = "Services.Store.Engagement*{ARCHC}";           Region = "All"; Dependencies = @(); }

        @{ Name = "Microsoft.DesktopAppInstaller";                  Match = "DesktopAppInstaller";                         License = "DesktopAppInstaller";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsStore";                         Match = "WindowsStore";                                License = "WindowsStore";                                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "MicrosoftWindows.Client.WebExperience";          Match = "WebExperience";                               License = "WebExperience";                               Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Clipchamp.Clipchamp";                            Match = "Clipchamp.Clipchamp";                         License = "Clipchamp.Clipchamp";                         Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.ApplicationCompatibilityEnhancements"; Match = "ApplicationCompatibilityEnhancements";        License = "ApplicationCompatibilityEnhancements";        Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.AV1VideoExtension";                    Match = "AV1VideoExtension";                           License = "AV1VideoExtension";                           Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.AVCEncoderVideoExtension";             Match = "AVCEncoderVideoExtension";                    License = "AVCEncoderVideoExtension";                    Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.BingNews";                             Match = "BingNews";                                    License = "BingNews";                                    Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.BingSearch";                           Match = "BingSearch";                                  License = "BingSearch";                                  Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.BingWeather";                          Match = "BingWeather";                                 License = "BingWeather";                                 Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.Copilot";                              Match = "Copilot";                                     License = "Copilot";                                     Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.GamingApp";                            Match = "GamingApp";                                   License = "GamingApp";                                   Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.GetHelp";                              Match = "GetHelp";                                     License = "GetHelp";                                     Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.HEIFImageExtension";                   Match = "HEIFImageExtension";                          License = "HEIFImageExtension*";                         Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.HEVCVideoExtension";                   Match = "HEVCVideoExtension";                          License = "15a6383d188a454ca98e15931ce48dc4_License1";   Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.MicrosoftOfficeHub";                   Match = "MicrosoftOfficeHub";                          License = "MicrosoftOfficeHub";                          Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.MicrosoftSolitaireCollection";         Match = "MicrosoftSolitaireCollection";                License = "MicrosoftSolitaireCollection";                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.MicrosoftStickyNotes";                 Match = "MicrosoftStickyNotes";                        License = "MicrosoftStickyNotes";                        Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.MPEG2VideoExtension";                  Match = "MPEG2VideoExtension";                         License = "MPEG2VideoExtension";                         Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.OutlookForWindows";                    Match = "Microsoft.OutlookForWindows_8wekyb3d8bbwe";   License = "Microsoft.OutlookForWindows_8wekyb3d8bbwe";   Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BY;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CU;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IR;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KP;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RU;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SY;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @(); }
        @{ Name = "Microsoft.Paint";                                Match = "Paint";                                       License = "Paint";                                       Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.UI.Xaml.2.8"); }
        @{ Name = "Microsoft.PowerAutomateDesktop";                 Match = "PowerAutomateDesktop";                        License = "PowerAutomateDesktop";                        Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.RawImageExtension";                    Match = "RawImageExtension";                           License = "RawImageExtension";                           Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.ScreenSketch";                         Match = "ScreenSketch";                                License = "ScreenSketch";                                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.WindowsAppRuntime.1.3", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.SecHealthUI";                          Match = "SecHealthUI*{ARCHC}";                         License = "SecHealthUI*{ARCHC}";                         Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.StorePurchaseApp";                     Match = "StorePurchaseApp";                            License = "StorePurchaseApp";                            Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.Todos";                                Match = "Todos";                                       License = "Todos";                                       Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.Services.Store.Engagement"); }
        @{ Name = "Microsoft.VP9VideoExtensions";                   Match = "VP9VideoExtensions";                          License = "VP9VideoExtensions";                          Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.WebMediaExtensions";                   Match = "WebMediaExtensions";                          License = "WebMediaExtensions";                          Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WebpImageExtension";                   Match = "WebpImageExtension";                          License = "WebpImageExtension";                          Region = "All"; Dependencies = @(); }
        @{ Name = "Microsoft.Windows.DevHome";                      Match = "DevHome";                                     License = "DevHome";                                     Region = "All"; Dependencies = @("Microsoft.WindowsAppRuntime.1.3", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.Windows.Photos";                       Match = "Windows.Photos";                              License = "Windows.Photos";                              Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsAlarms";                        Match = "WindowsAlarms";                               License = "WindowsAlarms";                               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.WindowsAppRuntime.1.3"); }
        @{ Name = "Microsoft.WindowsCalculator";                    Match = "WindowsCalculator";                           License = "WindowsCalculator";                           Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsCamera";                        Match = "WindowsCamera";                               License = "WindowsCamera";                               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.WindowsFeedbackHub";                   Match = "WindowsFeedbackHub";                          License = "WindowsFeedbackHub";                          Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsNotepad";                       Match = "WindowsNotepad";                              License = "WindowsNotepad";                              Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsSoundRecorder";                 Match = "WindowsSoundRecorder";                        License = "WindowsSoundRecorder";                        Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.WindowsTerminal";                      Match = "WindowsTerminal";                             License = "WindowsTerminal";                             Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8"); }
        @{ Name = "Microsoft.Xbox.TCUI";                            Match = "Xbox.TCUI";                                   License = "Xbox.TCUI";                                   Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxGamingOverlay";                    Match = "XboxGamingOverlay";                           License = "XboxGamingOverlay";                           Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxIdentityProvider";                 Match = "XboxIdentityProvider";                        License = "XboxIdentityProvider";                        Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.XboxSpeechToTextOverlay";              Match = "XboxSpeechToTextOverlay";                     License = "XboxSpeechToTextOverlay";                     Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
        @{ Name = "Microsoft.YourPhone";                            Match = "YourPhone";                                   License = "YourPhone";                                   Region = "All"; Dependencies = @("Microsoft.WindowsAppRuntime.1.4", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.ZuneMusic";                            Match = "ZuneMusic";                                   License = "ZuneMusic";                                   Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
        @{ Name = "MicrosoftCorporationII.QuickAssist";             Match = "QuickAssist";                                 License = "QuickAssist";                                 Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "Microsoft.CrossDevice";                          Match = "CrossDevice";                                 License = "CrossDevice";                                 Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "MSTeams";                                        Match = "MSTeams*{ARCHC}";                             License = "MSTeams*{ARCHC}";                             Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BY;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CU;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IR;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KP;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RU;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SY;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @("Microsoft.WindowsAppRuntime.1.3", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
        @{ Name = "MicrosoftCorporationII.MicrosoftFamily";         Match = "MicrosoftFamily";                             License = "MicrosoftFamily";                             Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
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

                    $Script:InBoxAppx += [pscustomobject]@{
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
