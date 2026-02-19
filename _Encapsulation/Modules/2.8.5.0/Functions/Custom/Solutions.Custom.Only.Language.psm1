<#
	.搜索机制

	{Lang}  = 语言标记
	{ARCH}  = 架构：原始 amd64
	{ARCHC} = 架构：转换后的结果：x64

	.排序：内核、系统类型、boot 或 Install、所需文件、文件路径
#>
$Global:Preconfigured_Rule_Language = @(
	#region Windows Server 2025
	@{
		GUID        = "11fe132f-1c84-41fd-a66e-fbc60b79d457"
		Author      = 'Yi'
		Copyright   = 'FengYi, Inc. All rights reserved.'
		Name        = "Microsoft Windows Server 2025"
		Description = ""
		Autopilot   = @{
			Prerequisite = @{
				x64 = @{
					ISO = @{
						Language = @(
							"https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1.240331-1435.ge_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso"
						)
						InBoxApps = @()
					}
				}
			}
		}
		ISO = @(
			@{
				ISO = "en-us_windows_server_2025_x64_dvd_b7ec10f3.iso"
				AlternativeFilenames = @(
					"26100.1742.240906-0331.ge_release_svc_refresh_SERVER_OEMRET_x64FRE_en-us.iso"
					"X23-81958_26100.1742.240906-0331.ge_release_svc_refresh_SERVER_OEMRET_x64FRE_en-us.iso"
				)
				FileList = "https://files.rg-adguard.net/file/f415465a-71bd-3823-ecb5-f249f9bce844"
				CRCSHA = @{
					SHA256 = "854109e1f215a29fc3541188297a6ca97c8a8f0f8c4dd6236b78dfdf845bf75e"
					SHA512 = "66a96031566f2e5b9fdaa4c4506799ab0b86b50f7acf6f6192e8d35775326e4a455b43ced293155222be570d9ea15b7c9adf0562d99bd7b8f4746f7639de8150"
				}
			}
			@{
				ISO = "SW_DVD9_Win_Server_STD_CORE_2025_24H2_64Bit_English_DC_STD_MLF_X23-81891.ISO"
				FileList = "https://files.rg-adguard.net/file/4d45d643-66f8-5769-74c7-8773a2811e5a"
				CRCSHA = @{
					SHA256 = "7cbb65644248cdbe8a72f51fbd9f98c4888e0a4938575fc4f052d52b927116df"
					SHA512 = "7bc4e68c7b3dae00c27480e0492b40f9e190b05688e7c729730b7a45a230f806d640be8b7d1dd41a0cc222c515129c11b2c5fa79c596a0e2cbab9c279fa06d56"
				}
			}
			@{
				ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVERAZURESTACKHCICOR_OEMRET_x64FRE_en-us.iso"
				FileList = "https://files.rg-adguard.net/file/663f398a-93d3-29c6-835a-49108ac358df"
				CRCSHA = @{
					SHA256 = "2dc9279bc3ba9752520a31a345a479761972427e12ea05cf921f5ac1c671ed70"
					SHA512 = "a28a7e26e174ee2421af65666bcad61ae68e93850ce4279e0cd9f65cdcaecd0831bbe1a4f34e16e9b4b35879a8deb47a01ed500fe64b9f92bd362cec132912a5"
				}
			}
			@{
				ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVERDCAZURE_VOL_x64FRE_en-us.iso"
				FileList = "https://files.rg-adguard.net/file/427687bc-efde-0637-b624-bce8a4a2468e"
				CRCSHA = @{
					SHA256 = "23d598c12aed83baefe19ac0ea5f1fd272c51dd8de8fb17fc3cfb621765aacf0"
					SHA512 = "3a9d0daf3d0d970910afce6d206be819ac361c9716e02eb46e54fb9c95f2b6f1a9db07905ca1be677b403923c6c5eb169eca815cddf7c1d75b08d1640710336a"
				}
			}
			@{
				ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
				FileList = "https://files.rg-adguard.net/file/85aa9bf9-7509-e52b-721a-df432383c942"
				CRCSHA = @{
					SHA256 = "d0ef4502e350e3c6c53c15b1b3020d38a5ded011bf04998e950720ac8579b23d"
					SHA512 = "8fef7ef369668f48d58ee3bcd888bffd7f2483ba8465912aee9624d5e358fb5d4c179237d5458c5e2e42fbe9121f902d9702b29eaf2d0a996d9154d933ee0f8e"
				}
			}
		)
		InboxApps = @{
			ISO = @()
			SN = @{}
			Edition = @()
			Rule = @()
		}
		Language = @{
			ISO = @(
				@{
					ISO = "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1.240331-1435.ge_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso"
					AlternativeFilenames = @(
						"mul_languages_and_optional_features_for_windows_server_2025_x64_dvd_762b4771.iso"
						"mul_languages_and_optional_features_for_windows_server_2025_preview_x64_dvd_762b4771.iso"
						"SW_DVD9_NTRL_Server_Languages_and_Optional_Features_24H2_64bit_Multilang_X23-69975.ISO"
						"OPK_Server_2025_24H2_MUI_Langpack_LOF_X23_75880.iso"
					)
					FileList = "https://files.rg-adguard.net/file/8f17df69-94b4-b8d2-6430-560748cdb0ca"
					CRCSHA = @{
						SHA256 = "72c33705d0c35610cba354de8c3cbf1274b55a096227135b5bd8babb8b222be3"
						SHA512 = "7359da28ceba136f189e1bbaf0985e5c987ef3a1c2a3617c72739b4230dceda916d5cfd354a93a9822a5c4eef4d6e59f8bb5c73623fb2264cfd38e87e8133ca6"
					}
				}
			)
			Rule = @(
				@{
					Uid = @(
						"Boot;wim;Boot;wim;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
								@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "WinPE-Setup_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "WINPE-SETUP-Server_{Lang}.CAB";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
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
				@{
					Uid = @(
						"Install;wim;Install;wim;"
						"Install;esd;Install;esd;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Server-Language-Pack_{ARCHC}_{Lang}.cab";                                                          Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                              Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                        Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                                Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                             Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                       Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                            Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MediaPlayer-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                         Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                         Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-SnippingTool-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                              Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WMIC-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                              Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ProjFS-OptionalFeature-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                           Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-SenseClient-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Telnet-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-TFTP-Client-FOD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab";                                      Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                          Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-VBSCRIPT-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                          Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WinOcr-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                            Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WinOcr-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                                            Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ServerCoreFonts-NonCritical-Fonts-MinConsoleFonts-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab"; Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";         Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";        Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-ServerCoreFonts-NonCritical-Fonts-UAPFonts-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";        Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-SimpleTCP-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                                         Structure = "LanguagesAndOptionalFeatures"; }
							)
						}
					)
				}
				@{
					Uid  = @(
						"Install;wim;WinRE;wim;"
						"Install;esd;WinRE;wim;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
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
								@{ Match = "winpe-appxdeployment_{Lang}.cab";  Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-appxpackaging_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-storagewmi_{Lang}.cab";      Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-wifi_{Lang}.cab";            Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-windowsupdate_{Lang}.cab";   Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-rejuv_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-opcservices_{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-hta_{Lang}.cab";             Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "winpe-connectivity_{Lang}.cab";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
							)
						}
					)
				}
			)
		}
	}
	#endregion

	#region Windows Server 2022
	@{
		GUID        = "a70389a7-bb7b-4774-91c7-2507c1472db0"
		Author      = 'Yi'
		Copyright   = 'FengYi, Inc. All rights reserved.'
		Name        = "Microsoft Windows Server 2022"
		Description = ""
		Autopilot   = @{
			Prerequisite = @{
				x64 = @{
					ISO = @{
						Language = @("https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso")
						InBoxApps = @()
					}
				}
			}
		}
		ISO = @(
			@{
				ISO = "en-us_windows_server_2022_x64_dvd_620d7eac.iso"
				FileList = "https://files.rg-adguard.net/file/9a0f4eb7-c3a9-e46b-3fc8-cdb71289dbfb"
				CRCSHA = @{
					SHA256 = "5a077ee2a95976ef9f3623eb4040e25cdf7f8f01dee3b8165a32a7626f39f025"
					SHA512 = "850f040f450a12f04c64aab66479dfc71ee82b6b71a3427a8a0a66dbbedbfc10dbfacf3b454456bf971571d435be886fdea08e2ed6de3a7dabb5918eab666246"
				}
			}
		)
		InboxApps = @{
			ISO = @()
			SN = @{
				Edition = @()
			}
			Edition = @(
				@{
					Name = @()
					Apps = @()
				}
			)
			Rule = @()
		}
		Language = @{
			ISO = @(
				@{
					ISO = "https://software-download.microsoft.com/download/sg/20348.1.210507-1500.fe_release_amd64fre_SERVER_LOF_PACKAGES_OEM.iso"
					AlternativeFilenames = @(
						"mul_windows_server_2022_languages_optional_features_x64_dvd_08a242b4.iso"
						"SW_DVD9_NTRL_Win_Svr_2022_64Bit_MultiLang_Langpack_FOD_App_Compat_X22-61280.ISO"
					)
					FileList = "https://files.rg-adguard.net/file/f4a036a7-5c8e-6bd6-764a-83655c1a9ce5"
					CRCSHA = @{
						SHA256 = "850a318c277f9b0d7436031efd91b36f5d27dad6e8ea9972179204a3fc756517"
						SHA512 = "6c61594a6c1e7bc01f90e026cc20eaa6c367adee02a494d109f5a79b7be1e18dd43648d7559cde8a95de1f113035b324936aa067383aff1991ea20af8ea4ae6b"
					}
				}
			)
			Rule = @(
				@{
					Uid = @(
						"Boot;wim;Boot;wim;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
								@{ Match = "lp.cab";                           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "WinPE-Setup_{Lang}.cab";           Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
								@{ Match = "WINPE-SETUP-Server_{Lang}.CAB";    Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs\{Lang}"; }
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
				@{
					Uid = @(
						"Install;wim;Install;wim;"
						"Install;esd;Install;esd;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~{ARCH}~~.cab";     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Server-Language-Pack_{ARCHC}_{Lang}.cab";                                    Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";        Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";  Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";          Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab";       Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~{ARCH}~~.cab"; Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";              Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";              Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                   Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                   Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
								@{ Match = "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~{Lang}~.cab";                     Structure = "LanguagesAndOptionalFeatures"; }
							)
						}
					)
				}
				@{
					Uid  = @(
						"Install;wim;WinRE;wim;"
						"Install;esd;WinRE;wim;"
					)
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
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
			)
		}
	}
	#endregion
)