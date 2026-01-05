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
$Global:Custom_Rule = @(
	#region Template Test 1
	@{
		GUID        = "82661f02-8a22-4729-a7b7-74865c1600ba"
		Author      = "Yi"
		Copyright   = "FengYi, Inc. All rights reserved."
		Name        = "Template Test 1"
		Description = ""
		Autopilot   = @{
			Prerequisite = @{
				x64 = @{
					ISO = @{
						Language  = @(
							"x64_Template_LOF_PACKAGES.iso"
						)
						InBoxApps = @(
							"x64_Template_InboxApps.iso"
						)
					}
				}
				arm64 = @{
					ISO = @{
						Language  = @(
							"arm64_Template_LOF_PACKAGES.iso"
						)
						InBoxApps = @(
							"arm64_Template_InboxApps.iso"
						)
					}
				}
			}
		}
		ISO = @(
			@{
				ISO = "en-us_Template_x64.iso"
				CRCSHA = @{
					SHA256 = ""
					SHA512 = ""
				}
			}
		)
		InboxApps = @{
			ISO = @(
				@{
					ISO = "x64_InboxApps.iso"
					CRCSHA = @{
						SHA256 = ""
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
				#region Group 1
				@{
					Name = @(
						"Enterprise"
					)
					Apps = @(
						"Microsoft.UI.Xaml.2.8"
					)
				}
				#endregion
			)
			Rule = @(
				@{ Name = "Microsoft.UI.Xaml.2.8";                  Match = "UI.Xaml*{ARCHTag}*2.8";             License = "UI.Xaml*{ARCHTag}*2.8";             Dependencies = @(); }
			)
		}
		Language = @{
			ISO = @(
				@{
					ISO = "x64_Template_LOF_PACKAGES.iso";
					AlternativeFilenames = @()
					CRCSHA = @{
						SHA256 = "";
						SHA521 = ""
					}
				}
				@{
					ISO = "arm64_Template_LOF_PACKAGES.iso";
					AlternativeFilenames = @()
					CRCSHA = @{
						SHA256 = "";
						SHA521 = ""
					}
				}
			)
			Rule = @(
				#region Boot
				@{
					Uid  = "Boot;wim;Boot;wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
							)
						}
					)
					Repair = @()
				}
				#endregion

				#region Install
				@{
					Uid  = "Install;wim;Install;wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~{ARCH}~~.cab";                      Structure = "LanguagesAndOptionalFeatures"; }
							)
						}
					)
				}
				#endregion

				#region WinRE
				@{
					Uid  = "Install;wim;WinRE;wim;"
					Rule = @(
						@{
							Architecture = "Auto"
							Rule = @(
								@{ Match = "WinPE-FontSupport-{Lang}.cab";     Structure = "Windows Preinstallation Environment\{ARCHC}\WinPE_OCs"; }
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