<#
	.预配置规则

	 Group       = 名称
	 GUID        = 规则唯一标识符
	 Description = 描述

	* InBox Apps
		ISO      = 规则命名通过验证 ISO 文件。
		SN       = S 版、SN 版
		Edition  = Windows 操作系统版本识别

		N        = N 版
		Edition  = Windows 操作系统版本识别
		Exclude  = 遇到 N 版时，排除的应用规则

		Rule     = 规则
				   安装包类型，唯一识别名，模糊查找名，依赖

	* Language
		ISO      = 规则命名通过验证 ISO 文件。
		Rule     = Boot
				 = Install

	.替换机制
		{Lang}      = 语言标记
		{ARCH}      = 架构：原始 amd64
		{ARCHC}     = 架构：转换后的结果：x64
		{ARCHTag}   = 架构：缩写
		{Specific}  = 特定包转换，了解：
					  https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod?view=windows-11#other-region-specific-Prerequisite

	.排序：内核、系统类型、boot 或 Install、所需文件、文件路径
#>
$Global:Pre_Config_Rules = @(
	@{
		Group   = "Microsoft Windows 11"
		Version = @(
			#region Windows 11 25H2
			@{
				GUID        = "67b30543-6bdf-4d35-b5cd-edeed1b20333"
				Author      = "Yi"
				Copyright   = "FengYi, Inc. All rights reserved."
				Name        = "Microsoft Windows 11 24H2 and 25H2"
				Description = ""
				Autopilot   = @{
					Prerequisite = @{
						x64 = @{
							ISO = @{
								Language  = @(
									"26100.1.240331-1435.ge_release_amd64fre_CLIENT_LOF_PACKAGES_OEM.iso"
								)
								InBoxApps = @(
									"26100.6584.250904-1728.ge_release_svc_prod1_amd64fre_InboxApps.iso"
								)
							}
						}
						arm64 = @{
							ISO = @{
								Language  = @()
								InBoxApps = @(
									"26100.6584.250904-1728.ge_release_svc_prod1_amd64fre_InboxApps.iso"
								)
							}
						}
					}
				}
				ISO = @(
					#region Windows 11 24H2 Business
					@{
						ISO = "en-us_windows_11_business_editions_version_24h2_x64_dvd_59a1851e.iso"
						AlternativeFilenames = @(
							"SW_DVD9_Win_Pro_11_24H2_64BIT_English_Pro_Ent_EDU_N_MLF_X23-69812.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/4bfa831a-0073-3bb4-5dde-6c07df68d7e3"
						CRCSHA = @{
							SHA256 = "d0dca325314322518ae967d58c3061bcae57ee9743a8a1cf374aad8637e5e8ac"
							SHA512 = "8ee14deaf0a931f1cb1f0ee5efa6117c7924cefd8baf337dde48a150920178ba9ac1c1911408b6d05e4c9eb3cf1748116d31074a7a113764bcc69cc5128bfd04"
						}
					}
					@{
						ISO = "en-us_windows_11_business_editions_version_24h2_arm64_dvd_ad92e9d8.iso"
						AlternativeFilenames = @(
							"SW_DVD9_Win_Pro_11_24H2_Arm64_English_Pro_Ent_EDU_N_MLF_X23-69850.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/cfb08972-7f11-f3a5-ae7c-8f084dc1996e"
						CRCSHA = @{
							SHA256 = "15ff94a99e89846c54316275f60ea697c9517e5dea7b3a963157a4c632524f72"
							SHA512 = "8b4676c50b7b5a56a648ee7192ddaf00bf3c84dd99bcc3308db82625573affcb36b379723358aa368700b1800b678e40e65a25b5cf83d9c561c68142aa46d393"
						}
					}
					#endregion

					#region Windows 11 24H2 Consumer editions
					@{
						ISO = "en-us_windows_11_consumer_editions_version_24h2_x64_dvd_1d5fcad3.iso"
						AlternativeFilenames = @(
							"X23-81971_26100.1742.240906-0331.ge_release_svc_refresh_CLIENT_CONSUMER_x64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/1ebf9c88-803f-636e-ad8a-5b60966dcd64"
						CRCSHA = @{
							SHA256 = "b56b911bf18a2ceaeb3904d87e7c770bdf92d3099599d61ac2497b91bf190b11"
							SHA512 = "4292beb7cd8e3aa75a3e07e3426d49def735cca6b8914456530f9541bf02bd913710117d5bd2492d2002774a13916b951b8ab7012bee5322decacf3c3224a0a7"
						}
					}
					@{
						ISO = "en-us_windows_11_consumer_editions_version_24h2_arm64_dvd_4cc70bf6.iso"
						AlternativeFilenames = @(
							"X23-81973_26100.1742.240906-0331.ge_release_svc_refresh_CLIENT_CONSUMER_A64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/9f751f60-0919-4a5a-8fb5-7bd6340a5df6"
						CRCSHA = @{
							SHA256 = "57d1dfb2c6690a99fe99226540333c6c97d3fd2b557a50dfe3d68c3f675ef2b0"
							SHA512 = "f3ce15b98b58c2879ab213a99d9396d7c923f92b139c8d60668fadc2215aa0ffcb7ceb2b8343c1e38ca25830b9d3474f9874dc69b1ec5faa2cc535263481d8c4"
						}
					}
					#endregion

					#region Windows 11 IoT Enterprise, version 24H2
					@{
						ISO = "en-us_windows_11_iot_enterprise_version_24h2_x64_dvd_3a99b72b.iso"
						AlternativeFilenames = @(
							"X23-81952_26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISE_OEM_x64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/d8ee9445-b9eb-5f45-f75e-e92a057820bf"
						CRCSHA = @{
							SHA256 = "eceb8dc167077e07f9a9bd04e472ea542944974b81b2ebc25477772a71bdbb69"
							SHA512 = "0747dcdae094a88962d7fc74e56d85aa7fa00a0f6add522d10a098ffae130d6688f37593f00d99e976380fcfe9847bc2757f30c04768624328d0f27c40eef5f9"
						}
					}
					@{
						ISO = "en-us_windows_11_iot_enterprise_version_24h2_arm64_dvd_e9155a10.iso"
						AlternativeFilenames = @(
							"X23-81976_26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISE_OEM_A64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/bacf17e5-a307-5a01-1a35-71268dc0c2e3"
						CRCSHA = @{
							SHA256 = "a931b791cadd12e0d38aac2d765d389a06bcba3154a4164afeacc839a3bdbc0d"
							SHA512 = "f583c979e84e3c5650c3c1979cd25897470d95db2ad44e384b254b39932a201d93f61693bf803bf81c9bfe489ab478c1f347844b51a85ebe4283a97c5d946c18"
						}
					}
					#endregion

					#region Windows 11 Enterprise LTSC 2024
					@{
						ISO = "en-us_windows_11_enterprise_ltsc_2024_x64_dvd_965cfb00.iso"
						AlternativeFilenames = @(
							"SW_DVD9_WIN_ENT_LTSC_2024_64-bit_English_MLF_X23-70046.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/142ca376-487f-e858-a606-e120e70b9d02"
						CRCSHA = @{
							SHA256 = "157d8365a517c40afeb3106fdd74d0836e1025debbc343f2080e1a8687607f51"
							SHA512 = "ea4e8e31bc45c078eb23b5e1e294c7bab0ba79c1a17769b9e7ede2ad32576d2b31355196f7ce39db8075a115d0464e7d70395b95a6ae6086a45c1f7e85e8e112"
						}
					}
					#endregion

					#region Windows 11 IoT Enterprise LTSC 2024
					@{
						ISO = "en-us_windows_11_iot_enterprise_ltsc_2024_x64_dvd_f6b14814.iso"
						AlternativeFilenames = @(
							"X23-81951_26100.1742.240906-0331.ge_release_svc_refresh_CLIENT_ENTERPRISES_OEM_x64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/9160d5cf-f480-a1c9-a62c-b75ab0708d2c"
						CRCSHA = @{
							SHA256 = "4f59662a96fc1da48c1b415d6c369d08af55ddd64e8f1c84e0166d9e50405d7a"
							SHA512 = "b3b8ab225537518a9baa3a85124947a1e4dfbb639ea277d9355b17165f195490ad21f44e9b72778ac2a41bc6561a18ed599bb72f6f3648e0cb110b9e1a35bdb9"
						}
					}
					@{
						ISO = "en-us_windows_11_iot_enterprise_ltsc_2024_arm64_dvd_ec517836.iso"
						AlternativeFilenames = @(
							"X23-81950_26100.1742.240906-0331.ge_release_svc_refresh_CLIENT_ENTERPRISES_OEM_A64FRE_en-us.iso"
						)
						FileList = "https://files.rg-adguard.net/file/de2234af-1514-ff50-50af-5a3395549c42"
						CRCSHA = @{
							SHA256 = "f8f068cdc90c894a55d8c8530db7c193234ba57bb11d33b71383839ac41246b4"
							SHA512 = "fa4bc7823dfd7e9c1776442f2567f8530252fcd5a9ed702a0dfdbdd967d0f6a41c7607f03a154411b8d77d297114946259f403304260f6de94123120d233201d"
						}
					}
					#endregion
				)
				InboxApps = @{
					ISO = @(
						@{
							ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.6584.250904-1728.ge_release_svc_prod1_amd64fre_InboxApps.iso"
							AlternativeFilenames = @(
								"SW_DVD9_NTRL_Win_11_25H2_64_Arm64_Inbox_Apps_OEM_VL_X24-12858.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/ada764e8-717a-d080-099b-d3aa44b84dab"
							CRCSHA = @{
								SHA256 = "93928f6b2a7e72b9f40037c493f4d311c6de124bc1e4ec41f22b7189e72f712a"
								SHA512 = "d3b902dd4d21ba732c05f119d9a0d771e0b219ed2041ee8bca1a7e51b9d67230676598e8c45b209d218e9b817a9426b86632d9154e40397fc5f44347c0ed0578"
							}
						}
					)
					SN = @{
						Edition = @(
							"EnterpriseS"
							"EnterpriseSN"
							"IoTEnterpriseS"
						)
					}
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

#								"ServerStandardCore"
								"ServerStandard"
#								"ServerDataCenterCore"
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
						@{ Name = "Microsoft.NET.Native.Runtime.2.2";               Match = "Native.Runtime*{ARCHTag}*2.2";                License = "Native.Runtime*{ARCHTag}*2.2";                Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.VCLibs.140.00";                        Match = "Microsoft.VCLibs.{ARCHTag}.14.00.appx";       License = "VCLibs.{ARCHTag}.14.00.appx";                 Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.VCLibs.140.00.UWPDesktop";             Match = "Microsoft.VCLibs.{ARCHTag}.14.00.UWPDesktop"; License = "Microsoft.VCLibs.{ARCHTag}.14.00.UWPDesktop"; Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.Services.Store.Engagement";            Match = "Services.Store.Engagement*{ARCHC}";           License = "Services.Store.Engagement*{ARCHC}";           Region = "All"; Dependencies = @(); }

						@{ Name = "Microsoft.DesktopAppInstaller";                  Match = "DesktopAppInstaller";                         License = "DesktopAppInstaller";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsStore";                         Match = "WindowsStore";                                License = "WindowsStore";                                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "MicrosoftWindows.Client.WebExperience";          Match = "WebExperience";                               License = "WebExperience";                               Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.WindowsAppRuntime.1.6", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Clipchamp.Clipchamp";                            Match = "Clipchamp.Clipchamp";                         License = "Clipchamp.Clipchamp";                         Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.WindowsAppRuntime.1.6", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.ApplicationCompatibilityEnhancements"; Match = "ApplicationCompatibilityEnhancements";        License = "ApplicationCompatibilityEnhancements";        Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.AV1VideoExtension";                    Match = "AV1VideoExtension";                           License = "AV1VideoExtension";                           Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.AVCEncoderVideoExtension";             Match = "AVCEncoderVideoExtension";                    License = "AVCEncoderVideoExtension";                    Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.BingNews";                             Match = "BingNews";                                    License = "BingNews";                                    Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.BingSearch";                           Match = "BingSearch";                                  License = "BingSearch";                                  Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.BingWeather";                          Match = "BingWeather";                                 License = "BingWeather";                                 Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.Copilot";                              Match = "Copilot";                                     License = "Copilot";                                     Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.GamingApp";                            Match = "GamingApp";                                   License = "GamingApp";                                   Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.WindowsAppRuntime.1.5"); }
						@{ Name = "Microsoft.GetHelp";                              Match = "GetHelp";                                     License = "GetHelp";                                     Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.HEIFImageExtension";                   Match = "HEIFImageExtension";                          License = "HEIFImageExtension*";                         Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.HEVCVideoExtension";                   Match = "HEVCVideoExtension";                          License = "15a6383d188a454ca98e15931ce48dc4_License1";   Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.MicrosoftSolitaireCollection";         Match = "MicrosoftSolitaireCollection";                License = "MicrosoftSolitaireCollection";                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.MicrosoftStickyNotes";                 Match = "MicrosoftStickyNotes";                        License = "MicrosoftStickyNotes";                        Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.MPEG2VideoExtension";                  Match = "MPEG2VideoExtension";                         License = "MPEG2VideoExtension";                         Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.OutlookForWindows";                    Match = "Microsoft.OutlookForWindows_8wekyb3d8bbwe";   License = "Microsoft.OutlookForWindows_8wekyb3d8bbwe";   Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BY;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CU;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IR;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KP;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RU;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SY;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @(); }
						@{ Name = "Microsoft.Paint";                                Match = "Paint";                                       License = "Paint";                                       Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.UI.Xaml.2.8"); }
						@{ Name = "Microsoft.PowerAutomateDesktop";                 Match = "PowerAutomateDesktop";                        License = "PowerAutomateDesktop";                        Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.RawImageExtension";                    Match = "RawImageExtension";                           License = "RawImageExtension";                           Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.ScreenSketch";                         Match = "ScreenSketch";                                License = "ScreenSketch";                                Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.WindowsAppRuntime.1.5", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.SecHealthUI";                          Match = "SecHealthUI*{ARCHC}";                         License = "SecHealthUI*{ARCHC}";                         Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.StorePurchaseApp";                     Match = "StorePurchaseApp";                            License = "StorePurchaseApp";                            Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.Todos";                                Match = "Todos";                                       License = "Todos";                                       Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.Services.Store.Engagement"); }
						@{ Name = "Microsoft.VP9VideoExtensions";                   Match = "VP9VideoExtensions";                          License = "VP9VideoExtensions";                          Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.WebMediaExtensions";                   Match = "WebMediaExtensions";                          License = "WebMediaExtensions";                          Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.WebpImageExtension";                   Match = "WebpImageExtension";                          License = "WebpImageExtension";                          Region = "All"; Dependencies = @(); }
						@{ Name = "Microsoft.Windows.DevHome";                      Match = "DevHome";                                     License = "DevHome";                                     Region = "All"; Dependencies = @("Microsoft.WindowsAppRuntime.1.5", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.Windows.Photos";                       Match = "Windows.Photos";                              License = "Windows.Photos";                              Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsAlarms";                        Match = "WindowsAlarms";                               License = "WindowsAlarms";                               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.WindowsAppRuntime.1.5"); }
						@{ Name = "Microsoft.WindowsCalculator";                    Match = "WindowsCalculator";                           License = "WindowsCalculator";                           Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsCamera";                        Match = "WindowsCamera";                               License = "WindowsCamera";                               Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsFeedbackHub";                   Match = "WindowsFeedbackHub";                          License = "WindowsFeedbackHub";                          Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsNotepad";                       Match = "WindowsNotepad";                              License = "WindowsNotepad";                              Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsSoundRecorder";                 Match = "WindowsSoundRecorder";                        License = "WindowsSoundRecorder";                        Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.WindowsTerminal";                      Match = "WindowsTerminal";                             License = "WindowsTerminal";                             Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8"); }
						@{ Name = "Microsoft.Xbox.TCUI";                            Match = "Xbox.TCUI";                                   License = "Xbox.TCUI";                                   Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxGamingOverlay";                    Match = "XboxGamingOverlay";                           License = "XboxGamingOverlay";                           Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.XboxIdentityProvider";                 Match = "XboxIdentityProvider";                        License = "XboxIdentityProvider";                        Region = "All"; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxSpeechToTextOverlay";              Match = "XboxSpeechToTextOverlay";                     License = "XboxSpeechToTextOverlay";                     Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.YourPhone";                            Match = "YourPhone";                                   License = "YourPhone";                                   Region = "All"; Dependencies = @("Microsoft.WindowsAppRuntime.1.7", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.ZuneMusic";                            Match = "ZuneMusic";                                   License = "ZuneMusic";                                   Region = "All"; Dependencies = @("Microsoft.UI.Xaml.2.8", "Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
						@{ Name = "MicrosoftCorporationII.QuickAssist";             Match = "QuickAssist";                                 License = "QuickAssist";                                 Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.CrossDevice";                          Match = "CrossDevice";                                 License = "CrossDevice";                                 Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00.UWPDesktop", "Microsoft.WindowsAppRuntime.1.7"); }
						@{ Name = "MSTeams";                                        Match = "MSTeams*{ARCHC}";                             License = "MSTeams*{ARCHC}";                             Region = "AD;AE;AF;AG;AI;AL;AM;AO;AQ;AR;AS;AT;AU;AW;AX;AZ;BA;BB;BD;BE;BF;BG;BH;BI;BJ;BL;BM;BN;BO;BQ;BR;BS;BT;BV;BW;BY;BZ;CA;CC;CD;CF;CG;CH;CI;CK;CL;CM;CO;CR;CU;CV;CW;CX;CY;CZ;DE;DJ;DK;DM;DO;DZ;EC;EE;EG;ER;ES;ET;FI;FJ;FK;FM;FO;FR;GA;GB;GD;GE;GF;GG;GH;GI;GL;GM;GN;GP;GQ;GR;GS;GT;GU;GW;GY;HK;HM;HN;HR;HT;HU;ID;IE;IL;IM;IN;IO;IQ;IR;IS;IT;JE;JM;JO;JP;KE;KG;KH;KI;KM;KN;KP;KR;KW;KY;KZ;LA;LB;LC;LI;LK;LR;LS;LT;LU;LV;LY;MA;MC;MD;ME;MF;MG;MH;MK;ML;MM;MN;MO;MP;MQ;MR;MS;MT;MU;MV;MW;MX;MY;MZ;NA;NC;NE;NF;NG;NI;NL;NO;NP;NR;NU;NZ;OM;PA;PE;PF;PG;PH;PK;PL;PM;PN;PR;PS;PT;PW;PY;QA;RE;RO;RS;RU;RW;SA;SB;SC;SD;SE;SG;SH;SI;SJ;SK;SL;SM;SN;SO;SR;SS;ST;SV;SX;SY;SZ;TC;TD;TF;TG;TH;TJ;TK;TL;TM;TN;TO;TR;TT;TV;TW;TZ;UA;UG;UM;US;UY;UZ;VA;VC;VE;VG;VI;VN;VU;WF;WS;XK;YE;YT;ZA;ZM;ZW"; Dependencies = @("Microsoft.WindowsAppRuntime.1.5", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "MicrosoftCorporationII.MicrosoftFamily";         Match = "MicrosoftFamily";                             License = "MicrosoftFamily";                             Region = "All"; Dependencies = @("Microsoft.WindowsAppRuntime.1.5", "Microsoft.VCLibs.140.00", "Microsoft.VCLibs.140.00.UWPDesktop"); }
					)
				}
				Language = @{
					ISO = @(
						@{
							ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1.240331-1435.ge_release_amd64fre_CLIENT_LOF_PACKAGES_OEM.iso";
							AlternativeFilenames = @(
								"mul_languages_and_optional_features_for_windows_11_version_24h2_x64_dvd_eb44bee0.iso"
								"SW_DVD9_Win_11_24H2_x64_MultiLang_LangPackAll_LIP_LoF_X23-69888.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/025cfc5d-f5fa-7d00-246e-76c04a40e210"
							CRCSHA = @{
								SHA256 = "fdbd87c2cd69ba84ef2ea69d5b468938355d0d634b7de7a1988480f94713a738";
								SHA512 = "b8b76fd8bef3ee29a2efccf73a23e30395762f43260cf3be6e014181cd5e754e912c2fc63c001745a7c71afa70f70d8357f403780dd70cef72c101dce1b0796b"
							}
						}
						@{
							ISO = "26100.1.240331-1435.ge_release_arm64fre_CLIENT_LOF_PACKAGES_OEM.iso";
							AlternativeFilenames = @(
								"mul_languages_and_optional_features_for_windows_11_version_24h2_arm64_dvd_5c4dae5b.iso"
							)
							FileList = "https://files.rg-adguard.net/file/a75a5453-30a4-2197-1ecb-3a602d92d9a0"
							CRCSHA = @{
								SHA256 = "cce90237f1dcb00840ca1a279b1f075a1df29787afa5a516b13db716fc6481fa";
								SHA512 = "e109003ae0479dfa4d91d3bd2164d1bcc56a5204c15d7599e0a5fb8bacc33cbae291a68d85c718d034cbbad5f8d338fafad3ba61bc08b525a2f5c75126542bb2"
							}
						}
					)
					Rule = @(
						#region Boot
						@{
							Uid  = "Boot;Boot;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "WinPE-Setup_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "WINPE-SETUP-CLIENT_{Lang}.CAB";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-securestartup_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-atbroker_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiocore_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiodrivers_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-enhancedstorage_{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-narrator_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-scripting_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-speech-tts_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srh_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srt_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wds-tools_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wmi_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
									)
								}
							)
							Repair = @()
						}
						#endregion

						#region Install
						@{
							Uid  = "Install;Install;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                      Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Client-Language-Pack_{ARCHC}_{Lang}.cab";                                                     Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                         Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                           Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                        Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                  Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                       Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                              Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MSPaint-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-MSPaint-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                              Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                             Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                        Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                         Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "HyperV-OptionalFeature-VirtualMachinePlatform-Client-Disabled-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab"; Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-DirectoryServices-ADAM-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-DirectoryServices-ADAM-Client-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-EnterpriseClientSync-Host-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-EnterpriseClientSync-Host-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-ProjFS-OptionalFeature-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                      Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SenseClient-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                 Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SnippingTool-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-SimpleTCP-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SmbDirect-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Telnet-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-TerminalServices-AppServer-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";           Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-TerminalServices-AppServer-Client-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";            Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-TFTP-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                 Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WinOcr-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WinOcr-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                       Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-InternationalFeatures-{Specific}-Package~31bf3856ad364e35~{ARCH}~~.cab";                      Structure = "LanguagesAndOptionalFeatures"; }
									)
								}
								@{
									Architecture = "Arm64"
									Rule = @(
										@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~arm64~~.cab";                       Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Client-Language-Pack_arm64_{Lang}.cab";                                                       Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~arm64~~.cab";                          Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~arm64~~.cab";                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~arm64~~.cab";                            Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~arm64~~.cab";                         Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~arm64~~.cab";                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                        Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                  Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Notepad-System-FoD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                           Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                  Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-MSPaint-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-MSPaint-FOD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                  Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                               Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                           Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                              Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                         Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "HyperV-OptionalFeature-VirtualMachinePlatform-Client-Disabled-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";  Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-DirectoryServices-ADAM-Client-FOD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";            Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-EnterpriseClientSync-Host-FOD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-ProjFS-OptionalFeature-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                       Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SenseClient-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                  Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SnippingTool-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                 Structure = "LanguagesAndOptionalFeatures"; } # Windows 11 Enterprise LTSC 2024
										@{ Match = "Microsoft-Windows-SimpleTCP-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-SmbDirect-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-Telnet-Client-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-TFTP-Client-FOD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                  Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~arm64~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                 Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-WinOcr-FOD-Package~31bf3856ad364e35~arm64.x86~{Lang}~.cab";                                   Structure = "LanguagesAndOptionalFeatures"; }
										@{ Match = "Microsoft-Windows-InternationalFeatures-{Specific}-Package~31bf3856ad364e35~arm64~~.cab";                       Structure = "LanguagesAndOptionalFeatures"; }
									)
								}
							)
						}
						#endregion

						#region WinRE
						@{
							Uid  = "Install;WinRE;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-securestartup_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-arm64ec-support_{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-atbroker_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiocore_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiodrivers_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-connectivity_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-enhancedstorage_{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-narrator_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-scripting_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-speech-tts_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srh_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srt_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wds-tools_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wmi_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-appxdeployment_{Lang}.cab";  Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-appxpackaging_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-storagewmi_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wifi_{Lang}.cab";            Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-windowsupdate_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-rejuv_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-opcservices_{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-hta_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
									)
								}
							)
						}
						#endregion
					)
				}
			}
			#endregion
			#endregion
		)
	}
	@{
		Group   = "Microsoft Windows 10"
		Version = @(
			#region Windows 10
			@{
				GUID        = "d33b848d-ef73-470b-ba0e-8b7f21536ccd"
				Author      = "Yi"
				Copyright   = "FengYi, Inc. All rights reserved."
				Name        = "Microsoft Windows 10"
				Description = ""
				Autopilot   = @{
					Prerequisite = @{
						x64 = @{
							ISO = @{
								Language  = @(
									"19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso"
									"19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso"
								)
								InBoxApps = @(
									"19041.3031.230508-1728.vb_release_svc_prod3_amd64fre_InboxApps.iso"
								)
							}
						}
						x86 = @{
							ISO = @{
								Language  = @(
									"19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso"
									"19041.1.191206-1406.vb_release_x86fre_FOD-PACKAGES_OEM_PT1_x86fre_MULTI.iso"
								)
								InBoxApps = @(
									"19041.3031.230508-1728.vb_release_svc_prod3_amd64fre_InboxApps.iso"
								)
							}
						}
					}
				}
				ISO = @(
					#region Windows 10 22H2 Business
					#region x64
					@{
						ISO = "en-us_windows_10_business_editions_version_22h2_x64_dvd_8cf17b79.iso"
						AlternativeFilenames = @(
							"SW_DVD9_Win_Pro_10_22H2_64BIT_English_Pro_Ent_EDU_N_MLF_X23-20019.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/b4901318-96a5-3755-c26d-c8cb5c816092"
						CRCSHA = @{
							SHA256 = "18a84e0da1043d7c1d3cf46ee127e8f637d425ad57e115ee862af203fa4932a8"
							SHA512 = "9669bd394fdc7ed335c0728111f6113abb35eab6e557bb072e034e3d1351ad640789e78921e0badbd65aa66a0aec695dd45fd4eabb872e613154142c143f70bc"
						}
					}
					#endregion

					#region x86
					@{
						ISO = "en-us_windows_10_business_editions_version_22h2_x86_dvd_186a68c3.iso"
						AlternativeFilenames = @(
							"SW_DVD9_Win_Pro_10_22H2_32BIT_English_Pro_Ent_EDU_N_MLF_X23-19943.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/19fd5653-1ca5-2160-7572-7e3313babacf"
						CRCSHA = @{
							SHA256 = "9319bdd9e09bef723e09536519a082618caf7aa8dc1a4135520d7a5a8a8893a4"
							SHA512 = "c0f260b9b00053ee8b714397e1f4e10b194ac7a300e46962feebbcc71b436dd90aded93ec6d87ab5151a15efd5538b40d6e91d885d7aeb83bbeb8cbc798fe82a"
						}
					}
					#endregion

					#region Windows 10 22H2 Consumer
					#region x64
					@{
						ISO = "en-us_windows_10_consumer_editions_version_22h2_x64_dvd_8da72ab3.iso"
						FileList = "https://files.rg-adguard.net/file/cbafa23b-cef5-6401-d0e2-da1533785c71"
						CRCSHA = @{
							SHA256 = "f41ba37aa02dcb552dc61cef5c644e55b5d35a8ebdfac346e70f80321343b506"
							SHA512 = "090b7cf99fe6463eb406ea7912aa7005764860976f45e1d069031e1c8cda1fa2c9a44090767906d74803ecd33143b8ab0879e08f9ba95072d46e7e637eddc4f8"
						}
					}
					#endregion

					#region x86
					@{
						ISO = "en-us_windows_10_consumer_editions_version_22h2_x86_dvd_90883feb.iso"
						FileList = "https://files.rg-adguard.net/file/09710916-5ec1-9526-f67e-87ab8c929be4"
						CRCSHA = @{
							SHA256 = "7cb5e0e18b0066396a48235d6e56d48475225e027c17c0702ea53e05b7409807"
							SHA512 = "d3c2f7d7188ece1bed197581f495071646411522560a9459789efd2afd0d7bc88d940b6150c7cb09aad737b45f33ef622c806892c9aa7174e000b8ae51e11dc4"
						}
					}
					#endregion

					#region Windows 10 IoT Enterprise 22H2
					@{
						ISO = "en-us_windows_10_iot_enterprise_version_22h2_x64_dvd_51cc370f.iso"
						FileList = "https://files.rg-adguard.net/file/8fe3555c-9e65-138a-e204-53e90c57c20d"
						CRCSHA = @{
							SHA256 = "2070c6eb71143a1207805f264d756b25f985769452f0bafccadf393c85d47f30"
							SHA512 = "2cdd3533a63a764bc1b98b7c43857d4a3ca95be069fecef565f9610f52cdb16b2f4e5abcbb2fc45daa6678720e0e6a4dfb17ee354640a2c7f5a5167897c7ac27"
						}
					}
					@{
						ISO = "en-us_windows_10_iot_enterprise_version_22h2_arm64_dvd_39566b6b.iso"
						FileList = "https://files.rg-adguard.net/file/5f90028e-6a65-3ece-5b90-7c7e30f0fadc"
						CRCSHA = @{
							SHA256 = "aad4fff6702e681c3238dfc64da6a58beefc8246e8b75170b30b52af31d20f0b"
							SHA512 = "76260e42fdce2dbea403e38ac65e39840f7e165f7cfd6c166e17fa7df342166e44ddcc0b4915fd00bf1d2fc2bc41e3c456ecfac6bbbceac9d7952d7d681666ad"
						}
					}

					@{
						ISO = "en-us_windows_10_enterprise_ltsc_2021_x64_dvd_d289cf96.iso"
						AlternativeFilenames = @(
							"SW_DVD9_WIN_ENT_LTSC_2021_64BIT_English_MLF_X22-84414.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/19a36b7b-269b-ebf8-105b-a375f70b7ae2"
						CRCSHA = @{
							SHA256 = "c90a6df8997bf49e56b9673982f3e80745058723a707aef8f22998ae6479597d"
							SHA512 = "0a2cd4cadf0395f0374974cd2bc2407e5cc65c111275acdffb6ecc5a2026eee9e1bb3da528b35c7f0ff4b64563a74857d5c2149051e281cc09ebd0d1968be9aa"
						}
					}
					@{
						ISO = "en-us_windows_10_enterprise_ltsc_2021_x86_dvd_9f4aa95f.iso"
						AlternativeFilenames = @(
							"SW_DVD9_WIN_ENT_LTSC_2021_32BIT_English_MLF_X22-84413.ISO"
						)
						FileList = "https://files.rg-adguard.net/file/dad92dcb-222d-c6ca-ebe2-3e12c6bcb22b"
						CRCSHA = @{
							SHA256 = "3276d60fa27f513b411224cd474278a9abe406159ba47776747862c7080292bc"
							SHA512 = "438e6c9b2d074d5270b263e9aeb662387d2bdc4a020607d77fa1697a134fdd186a752af5a93d587d560fde02d26450725e25b4c3d8b80187914528b3c6062bbd"
						}
					}
					#endregion

					
					#region Windows 10 Iot Enterprise LTSC 2021
					@{
						ISO = "en-us_windows_10_iot_enterprise_ltsc_2021_x64_dvd_257ad90f.iso"
						FileList = "https://files.rg-adguard.net/file/d4af271c-9bfb-7457-fba3-b600a921d9cc"
						CRCSHA = @{
							SHA256 = "a0334f31ea7a3e6932b9ad7206608248f0bd40698bfb8fc65f14fc5e4976c160"
							SHA512 = "640942d93daf8cd183d06e35d5d753a4b93c952c3196c3e3fa7876295b39d8bfef5df8ef2a3b420b5247905fe396606f94ccf093982ee999e503d09e69850143"
						}
					}
					@{
						ISO = "en-us_windows_10_iot_enterprise_ltsc_2021_arm64_dvd_e8d4fc46.iso"
						FileList = "https://files.rg-adguard.net/file/a9e8ed40-8540-f309-0065-b9060cbd47ac"
						CRCSHA = @{
							SHA256 = "d265df49b30a1477d010c79185a7bc88591a1be4b3eb690c994bed828ea17c00"
							SHA512 = "cbf5196a0a539f5285b8c98eea093823bd396cad8d7d34e25936bfc5936a1c86d040d938c6ae49bd8483325e0f2a87c231f005a3a01edb353adea82dfb006720"
						}
					}
				)
				InboxApps = @{
					ISO = @(
						@{
							ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/19041.3031.230508-1728.vb_release_svc_prod3_amd64fre_InboxApps.iso"
							AlternativeFilenames = @(
								"SW_DVD9_NTRL_Win_10_21H1_32_64_Arm64_MltLng_InboxApps_updated_May_2023_X23-47809.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/009d4cb1-90f4-8856-9b07-9ede5858d7da"
							CRCSHA = @{
								SHA256 = "6c5b583738e3c33b00c912783d1743ebe2e240e12fa3d9803d446f1b88675c14"
								SHA512 = "49713075d3fd1d93bcb8a1ece7d51d8eace1d4250b1b6ee7fe3f257518572b02a6060af14b2605bd1bf8c4ebae195fe645e37ead955f9fe826d795481dbc56ad"
							}
						}
					)
					SN = @{
						Edition = @(
							"EnterpriseS"
							"EnterpriseSN"
							"IoTEnterpriseS"
						)
					}
					Edition = @(
						#region Group 1
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
								"Microsoft.MicrosoftSolitaireCollection"
								"Microsoft.MicrosoftStickyNotes"
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
								"Microsoft.windowscommunicationsapps"
								"Microsoft.WindowsFeedbackHub"
								"Microsoft.WindowsMaps"
								"Microsoft.WindowsSoundRecorder"
								"Microsoft.YourPhone"
								"Microsoft.ZuneMusic"
								"Microsoft.ZuneVideo"
							)
						}
						#endregion

						#region Group 2
						@{
							Name = @(
								"EnterpriseN"
								"EnterpriseGN"
								"EnterpriseSN"
								"ProfessionalN"
								"CoreN"
								"EducationN"
								"ProfessionalWorkstationN"
								"ProfessionalEducationN"
								"CloudN"
								"CloudEN"
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
								"Microsoft.MicrosoftSolitaireCollection"
								"Microsoft.MicrosoftStickyNotes"
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
								"Microsoft.windowscommunicationsapps"
								"Microsoft.WindowsFeedbackHub"
								"Microsoft.WindowsMaps"
								"Microsoft.YourPhone"
							)
						}
						#endregion
					)
					Rule = @(
						@{ Name = "Microsoft.UI.Xaml.2.0";                   Match = "UI.Xaml*2.0";                       License = "UI.Xaml*2.0";                       Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.UI.Xaml.2.1";                   Match = "UI.Xaml*2.1";                       License = "UI.Xaml*2.1";                       Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.UI.Xaml.2.3";                   Match = "UI.Xaml*2.3";                       License = "UI.Xaml*2.3";                       Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.Advertising.Xaml";              Match = "Advertising.Xaml";                  License = "Advertising.Xaml";                  Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.NET.Native.Framework.1.7";      Match = "Native.Framework*1.7";              License = "Native.Framework*1.7";              Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.NET.Native.Framework.2.2";      Match = "Native.Framework*2.2";              License = "Native.Framework*2.2";              Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.NET.Native.Runtime.1.7";        Match = "Native.Runtime*1.7";                License = "Native.Runtime*1.7";                Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.NET.Native.Runtime.2.2";        Match = "Native.Runtime*2.2";                License = "Native.Runtime*2.2";                Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.VCLibs.140.00";                 Match = "VCLibs*14.00";                      License = "VCLibs*14.00";                      Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.VCLibs.140.00.UWPDesktop";      Match = "VCLibs*Desktop";                    License = "VCLibs*Desktop";                    Region = ""; Dependencies = @(); }
						@{ Name = "Microsoft.Services.Store.Engagement";     Match = "Services.Store.Engagement*{ARCHC}"; License = "Services.Store.Engagement*{ARCHC}"; Region = ""; Dependencies = @(); }

						@{ Name = "Microsoft.WindowsStore";                  Match = "WindowsStore";                      License = "WindowsStore";                      Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.HEIFImageExtension";            Match = "HEIFImageExtension";                License = "HEIFImageExtension";                Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WebpImageExtension";            Match = "WebpImageExtension";                License = "WebpImageExtension";                Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.VP9VideoExtensions";            Match = "VP9VideoExtensions";                License = "VP9VideoExtensions";                Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Xbox.TCUI";                     Match = "Xbox.TCUI";                         License = "Xbox.TCUI";                         Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxApp";                       Match = "XboxApp";                           License = "XboxApp";                           Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.1.7"; "Microsoft.NET.Native.Runtime.1.7"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxGameOverlay";               Match = "XboxGameOverlay";                   License = "XboxGameOverlay";                   Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxGamingOverlay";             Match = "XboxGamingOverlay";                 License = "XboxGamingOverlay";                 Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxIdentityProvider";          Match = "XboxIdentityProvider";              License = "XboxIdentityProvider";              Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.XboxSpeechToTextOverlay";       Match = "XboxSpeechToTextOverlay";           License = "XboxSpeechToTextOverlay";           Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Cortana";                       Match = "Cortana";                           License = "Cortana";                           Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"; "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.BingWeather";                   Match = "BingWeather";                       License = "BingWeather";                       Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.1"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"; "Microsoft.Advertising.Xaml"); }
						@{ Name = "Microsoft.DesktopAppInstaller";           Match = "DesktopAppInstaller";               License = "DesktopAppInstaller";               Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"; "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.GetHelp";                       Match = "GetHelp";                           License = "GetHelp";                           Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.1.7"; "Microsoft.NET.Native.Runtime.1.7"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Getstarted";                    Match = "Getstarted";                        License = "Getstarted";                        Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Microsoft3DViewer";             Match = "Microsoft3DViewer";                 License = "Microsoft3DViewer";                 Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.1"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"; "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.MicrosoftOfficeHub";            Match = "MicrosoftOfficeHub";                License = "MicrosoftOfficeHub";                Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"; "Microsoft.VCLibs.140.00.UWPDesktop"); }
						@{ Name = "Microsoft.MicrosoftSolitaireCollection";  Match = "MicrosoftSolitaireCollection";      License = "MicrosoftSolitaireCollection";      Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.MicrosoftStickyNotes";          Match = "MicrosoftStickyNotes";              License = "MicrosoftStickyNotes";              Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"; "Microsoft.Services.Store.Engagement"); }
						@{ Name = "Microsoft.MixedReality.Portal";           Match = "MixedReality.Portal";               License = "MixedReality.Portal";               Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.MSPaint";                       Match = "MSPaint";                           License = "MSPaint";                           Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.0"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Office.OneNote";                Match = "Office.OneNote";                    License = "Office.OneNote";                    Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.People";                        Match = "People";                            License = "People";                            Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.ScreenSketch";                  Match = "ScreenSketch";                      License = "ScreenSketch";                      Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.0"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.SkypeApp";                      Match = "SkypeApp";                          License = "SkypeApp";                          Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.StorePurchaseApp";              Match = "StorePurchaseApp";                  License = "StorePurchaseApp";                  Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.1.7"; "Microsoft.NET.Native.Runtime.1.7"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Wallet";                        Match = "Wallet";                            License = "Wallet";                            Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WebMediaExtensions";            Match = "WebMediaExtensions";                License = "WebMediaExtensions";                Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Windows.Photos";                Match = "Windows.Photos";                    License = "Windows.Photos";                    Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.0"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsAlarms";                 Match = "WindowsAlarms";                     License = "WindowsAlarms";                     Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsCalculator";             Match = "WindowsCalculator";                 License = "WindowsCalculator";                 Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.0"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsCamera";                 Match = "WindowsCamera";                     License = "WindowsCamera";                     Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.1.7"; "Microsoft.NET.Native.Runtime.1.7"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.windowscommunicationsapps";     Match = "windowscommunicationsapps";         License = "windowscommunicationsapps";         Region = ""; Dependencies = @("Microsoft.Advertising.Xaml"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsFeedbackHub";            Match = "WindowsFeedbackHub";                License = "WindowsFeedbackHub";                Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.0"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsMaps";                   Match = "WindowsMaps";                       License = "WindowsMaps";                       Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.NET.Native.Framework.2.2"; "Microsoft.NET.Native.Runtime.2.2"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.WindowsSoundRecorder";          Match = "WindowsSoundRecorder";              License = "WindowsSoundRecorder";              Region = ""; Dependencies = @("Microsoft.UI.Xaml.2.3"; "Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.YourPhone";                     Match = "YourPhone";                         License = "YourPhone";                         Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.ZuneMusic";                     Match = "ZuneMusic";                         License = "ZuneMusic";                         Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.ZuneVideo";                     Match = "ZuneVideo";                         License = "ZuneVideo";                         Region = ""; Dependencies = @("Microsoft.VCLibs.140.00"); }
						@{ Name = "Microsoft.Whiteboard";                    Match = "Whiteboard";                        License = "Whiteboard";                        Region = ""; Dependencies = @("Microsoft.NET.Native.Framework.2.2", "Microsoft.NET.Native.Runtime.2.2", "Microsoft.VCLibs.140.00"); }
					)
				}
				Language = @{
					ISO = @(
						@{
							ISO = "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso";
							AlternativeFilenames = @(
								"mu_windows_10_language_pack_version_2004_x86_arm64_x64_dvd_7729a9da.iso"
								"SW_DVD9_NTRL_Win_10_2004_32_64_ARM64_MultiLang_LangPackAll_LIP_X22-21307.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/5a38c0c8-036a-e4e8-fa4a-c1d3ecd073d6"
							CRCSHA = @{
								SHA256 = "201269a05a09dba91d47923c733d43f38f38ebf33de2fd0750887d2763886743";
								SHA512 = "2BE0D994760E35FFF61B73599270BF065C15313C50DC87AF10A15B187C1A8293F0DE8AE7563E013F35ED971C94BAA4E2C13BE5D6DEF61DE0FCEDA4CF657495B6"
							}
						}
						@{
							ISO = "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso";
							AlternativeFilenames = @(
								"en_windows_10_features_on_demand_part_1_version_2004_x64_dvd_7669fc91.iso"
								"SW_DVD9_NTRL_Win_10_2004_64Bit_MultiLang_FOD_1_X22-21311.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/16fccb80-0d4c-3d94-2a7c-b0bf020f6422"
							CRCSHA = @{
								SHA256 = "0faaa11d86fbf66af059df4330a5ecf664323ce370ea898bc9beb4f03c048e95";
								SHA512 = "C39F1FCCEF93325D722BDD793705068CEE8BEFA0D0D64E3FBBA53E71BA425C281DF2202508D794C5B64F6305512CAE165BF6E92696CFC2C48FD31D7CE7AF1D2F"
							}
						}
						@{
							ISO = "https://software-static.download.prss.microsoft.com/pr/download/19041.1.191206-1406.vb_release_x86fre_FOD-PACKAGES_OEM_PT1_x86fre_MULTI.iso";
							AlternativeFilenames = @(
								"en_windows_10_features_on_demand_part_1_version_2004_x86_dvd_ae6dc6f7.iso"
								"SW_DVD9_NTRL_Win_10_2004_W32_MultiLang_FOD_1_X22-21312.ISO"
							)
							FileList = "https://files.rg-adguard.net/file/7758afd0-e097-e9f3-86ee-ebef4deff834"
							CRCSHA = @{
								SHA256 = "6db431827d5ce782c09e9092eb1c8cd7ba873012e6599b997462f91be2a60f51";
								SHA512 = "ba6887ad9df29ec5fa4b47d4907363af74828614deb2748bf8a03b336d38c7a01b81cf314cc20c956ee060940019c3af32798ec66a15917e38d67f6d94a63e46"
							}
						}
					)
					Rule = @(
						#region Boot
						@{
							Uid  = "Boot;Boot;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "WinPE-Setup_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "WINPE-SETUP-CLIENT_{Lang}.CAB";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-securestartup_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-atbroker_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiocore_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiodrivers_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-enhancedstorage_{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-narrator_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-scripting_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-speech-tts_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srh_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srt_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wds-tools_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wmi_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
									)
								}
							)
						}
						#endregion

						#region Install
						@{
							Uid  = "Install;Install;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~{ARCH}~~.cab";     Structure = ""; }
										@{ Match = "Microsoft-Windows-Client-Language-Pack_{ARCHC}_{Lang}.cab";                                    Structure = "{ARCHC}\langpacks"; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";        Structure = ""; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";  Structure = ""; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";          Structure = ""; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";       Structure = ""; }
										@{ Match = "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab"; Structure = ""; }
										@{ Match = "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";      Structure = ""; }
										@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                    Structure = ""; }
										@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = ""; }
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                    Structure = ""; }
										@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = ""; }
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";             Structure = ""; }
										@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";              Structure = ""; }
										@{ Match = "Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";               Structure = ""; }
										@{ Match = "Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";            Structure = ""; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                  Structure = ""; }
										@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                   Structure = ""; }
										@{ Match = "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                    Structure = ""; }
										@{ Match = "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = ""; }
										@{ Match = "Microsoft-Windows-InternationalFeatures-{Specific}-Package~31bf3856ad364e35~{ARCH}~~.cab";     Structure = ""; }
									)
								}
							)
						}
						#endregion

						#region WinRE
						@{
							Uid  = "Install;WinRE;Wim;"
							Rule = @(
								@{
									Architecture = "Auto"
									Rule = @(
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
										@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-securestartup_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-atbroker_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiocore_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-audiodrivers_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-enhancedstorage_{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-narrator_{Lang}.cab";        Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-scripting_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-speech-tts_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srh_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-srt_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wds-tools_{Lang}.cab";       Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wmi_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-appxpackaging_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-storagewmi_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-wifi_{Lang}.cab";            Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-rejuv_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-opcservices_{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
										@{ Match = "winpe-hta_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
									)
								}
							)
						}
						#endregion
					)
				}
			}
			#endregion
		)
	}
)

<#
	Template

	@{
		GUID        = "Template"
		Author      = ""
		Copyright   = ""
		Name        = "Template"
		Description = ""
		Autopilot   = @{
			Prerequisite = @{
				x64 = @{
					ISO = @{
						Language  = @(
							""
						)
						InBoxApps = @(
							""
						)
					}
				}
			}
		}
		ISO = @(
			""
		)
		InboxApps = @{
			ISO = @(
				@{
					ISO = "";
					CRCSHA = @{
						SHA256 = "";
						SHA512 = ""
					}
				}
			)
			SN = @{
				Edition = @(
					"EnterpriseS"
					"EnterpriseSN"
					"IoTEnterpriseS"
				)
			}
			Edition = @(
				@{
					Name = @(
						"Core"
						"CoreN"
						"CoreSingleLanguage"
						"EnterpriseN"
						"EnterpriseGN"
						"EnterpriseSN"
						"ProfessionalN"
						"EducationN"
						"ProfessionalWorkstationN"
						"ProfessionalEducationN"
						"CloudN"
						"CloudEN"
						"CloudEditionLN"
						"StarterN"
					)
					Apps = @(
						"Microsoft.UI.Xaml.2.3"
					)
				}
			)
			Rule = @(
				@{ Name ="Microsoft.ZuneVideo"; Match = "ZuneVideo"; License = "ZuneVideo"; Region = "All"; Dependencies = @("Microsoft.VCLibs.140.00"); }
			)
		}
		Language = @{
			ISO = @(
				ISO = "";
				FileList = ""
				CRCSHA = @{
					SHA256 = "";
					SHA512 = ""
				}
			)
			Rule = @(
				@{
					Uid  = "Boot;Boot;Wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
							)
						}
					)
				}
				@{
					Uid  = "Install;Install;Wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
							)
						}
					)
				}
				@{
					Uid  = "Install;WinRE;Wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab"; Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
							)
						}
					)
				}
			)
		}
	}
#>