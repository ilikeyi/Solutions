<#
	.Register user interface
	.注册用户界面
#>
Function FirstExperience
{
	param
	(
		[switch]$Force,
		[switch]$Quit
	)

	Logo -Title $lang.FirstDeployment
	write-host "  $($lang.FirstDeployment)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	if ($Force) {
		if (Deploy_Sync -Mark "Auto_Update") {
			write-host "  $($lang.ForceUpdate)"
			Update -Auto -Force -IsProcess
		} else {
			write-host "  $($lang.UpdateSkipUpdateCheck)"
		}

		FirstExperience_Process
	} else {
		FirstExperience_Setting_UI
	}

	if ($Quit) {
		Stop-Process $PID
	}
}

Function FirstExperience_Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$GUIFE             = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.FirstDeployment
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$GUIFEPanel        = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 520
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,0,8,0"
		Dock           = 1
		Location       = "10,5"
	}
	$GUIFEPreAppxCleanup = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.PreAppxCleanup
		Checked        = $True
		add_Click      = {
			if ($GUIFEPreAppxCleanup.Checked) {
				$GUIFEPreAppxCleanupSel.Enabled = $True
			} else {
				$GUIFEPreAppxCleanupSel.Enabled = $False
			}
		}
	}
	$GUIFEPreAppxCleanupSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,20"
	}
	$GUIFEPreAppxCleanupEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
	}
	$GUIFEPreAppxCleanupDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}
	$GUIFELanguageComponents = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.CleanupOndemandLP
		Checked        = $True
		add_Click      = {
			if ($GUIFELanguageComponents.Checked) {
				$GUIFELanguageComponentsSel.Enabled = $True
			} else {
				$GUIFELanguageComponentsSel.Enabled = $False
			}
		}
	}
	$GUIFELanguageComponentsSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,20"
	}
	$GUIFELanguageComponentsEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
	}
	$GUIFELanguageComponentsDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}

	$GUIFECleanupUnusedLP = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.CleanupUnusedLP
		Checked        = $True
		add_Click      = {
			if ($GUIFECleanupUnusedLP.Checked) {
				$GUIFECleanupUnusedLPSel.Enabled = $True
			} else {
				$GUIFECleanupUnusedLPSel.Enabled = $False
			}
		}
	}
	$GUIFECleanupUnusedLPSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,20"
	}
	$GUIFECleanupUnusedLPEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
	}
	$GUIFECleanupUnusedLPDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}
	$GUIFEVolume       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 490
		Text           = $lang.SelectVolumename
		Checked        = $True
		add_Click      = {
			if ($GUIFEVolume.Checked) {
				$GUIFEVolumePanel.Enabled = $True
			} else {
				$GUIFEVolumePanel.Enabled = $False
			}
		}
	}
	$GUIFEVolumePanel  = New-Object system.Windows.Forms.Panel -Property @{
		Height         = 70
		Width          = 485
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,0,8,0"
	}
	$GUIFEVolumeDefault = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 300
		Text           = "OS"
		Location       = '16,0'
		Checked        = $True
	}
	$GUIFEVolumeSync   = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 300
		Text           = $((Get-Module -Name Engine).Author)
		Location       = '16,25'
	}
	$GUIFEDeskMenu     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.DesktopMenu
		Checked        = $True
		add_Click      = {
			if ($GUIFEDeskMenu.Checked) {
				$GUIFEDeskMenuShift.Enabled = $True
			} else {
				$GUIFEDeskMenuShift.Enabled = $False
			}
		}
	}
	$GUIFEDeskMenuShift = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.DesktopMenuShift
	}
	$GUIFEDefenders    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.ExcludeDefenders
		Checked        = $True
	}
	$GUIFELangAndKeyboard = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.SettingLangAndKeyboard
		Checked        = $True
	}
	$GUIFEUtf8         = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.SettingUTF8
	}
	$GUIFEUtf8Tips     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 370
		Text           = $lang.SettingUTF8Tips
		Padding        = "16,0,8,0"
	}
	$GUIFELocale       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = "$($lang.SettingLocale) ( $((Get-Culture).Name) )"
	}
	$GUIFELocaleTips   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 370
		Text           = $lang.SettingLocaleTips
		Padding        = "16,0,8,0"
	}
	$GUIFEFixMainFolder = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = "$($lang.FixMainFolder): $((Get-Module -Name Engine).Author)"
		Checked        = $True
	}
	$GUIFEFDPermissions = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.FDPermissions
		Checked        = $True
	}
	$GUIFEShortcut     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.Shortcuts
		Checked        = $True
	}
	$GUIFEDeployCleanup = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 30
		Width          = 505
		Text           = $lang.DeployCleanup
		Location       = "12,550"
		Checked        = $True
	}
	$GUIFEReboot       = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 30
		Width          = 505
		Text           = $lang.Reboot
		Location       = "12,585"
	}
	$GUIFEOK           = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$GUIFE.Hide()

			if ($GUIFEPreAppxCleanup.Checked) {
				if ($GUIFEPreAppxCleanupEnabled.Checked) {
					Cleanup_Appx_Tasks -Enabled
				}

				if ($GUIFEPreAppxCleanupDisable.Checked) {
					Cleanup_Appx_Tasks -Disable
				}
			} else {
				write-host "  $($lang.PreAppxCleanup)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFELanguageComponents.Checked) {
				if ($GUIFELanguageComponentsEnabled.Checked) {
					Cleanup_Unsed_Language -Enabled
				}

				if ($GUIFELanguageComponentsDisable.Checked) {
					Cleanup_Unsed_Language -Disable
				}
			} else {
				write-host "  $($lang.CleanupOndemandLP)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFECleanupUnusedLP.Checked) {
				if ($GUIFECleanupUnusedLPEnabled.Checked) {
					Cleanup_On_Demand_Language -Enabled
				}

				if ($GUIFECleanupUnusedLPDisable.Checked) {
					Cleanup_On_Demand_Language -Disable
				}
			} else {
				write-host "  $($lang.CleanupUnusedLP)"
				write-host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			if ($GUIFEVolume.Enabled) {
				if ($GUIFEVolume.Checked) {
					if ($GUIFEVolumeDefault.Checked) {
						System_Disk_Label -VolumeName "OS"
					}

					if ($GUIFEVolumeSync.Checked) {
						System_Disk_Label -VolumeName $(Get-Module -Name Engine).Author
					}
				} else {
					write-host "`n  $($lang.VolumeLabel)"
					write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
				}
			} else {
				write-host "`n  $($lang.VolumeLabel)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFEDeskMenu.Enabled) {
				if ($GUIFEDeskMenu.Checked) {
					Personalise -Del
					if ($GUIFEDeskMenuShift.Checked) {
						Personalise -Add -Hide
					} else {
						Personalise -Add
					}
				} else {
					write-host "  $($lang.DesktopMenu)" -ForegroundColor Green
					write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
				}
			} else {
				write-host "  $($lang.DesktopMenu)" -ForegroundColor Green
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.ExcludeDefenders)"
			if ($GUIFEDefenders.Checked) {
				Firewall_Exclusion
			} else {
				write-host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			if ($GUIFELangAndKeyboard.Checked) {
				Language_Setting
				write-host "  $($lang.Done)" -ForegroundColor Green
			} else {
				write-host "`n  $($lang.SettingLangAndKeyboard)"
				write-host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			if ($GUIFEUtf8.Checked) {
				Language_Use_UTF8 -Enabled
			} else {
				write-host "`n  $($lang.SettingUTF8)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFELocale.Checked) {
				Language_Region_Setting -Force
			} else {
				write-host "  $($lang.SettingLocale)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFEFixMainFolder.Checked) {
				Repair_Home_Directory
			} else {
				write-host "  $($lang.FixMainFolder): $((Get-Module -Name Engine).Author)"
				write-host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			if ($GUIFEFDPermissions.Checked) {
				Permissions
			} else {
				write-host "`n  $($lang.FDPermissions)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.Shortcuts)"
			if ($GUIFEShortcut.Checked) {
				Shortcut_Process
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.DeployCleanup)"
			if ($GUIFEDeployCleanup.Checked) {
				Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy"
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.Reboot)"
			if ($GUIFEReboot.Checked) {
				Restart-Computer -Force
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			$GUIFE.Close()
		}
	}
	$GUIFECanel        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "268,635"
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$GUIFE.Close()
		}
	}
	$GUIFE.controls.AddRange((
		$GUIFEPanel,
		$GUIFEDeployCleanup,
		$GUIFEReboot,
		$GUIFEOK,
		$GUIFECanel
	))
	$GUIFEPanel.controls.AddRange((
		$GUIFEPreAppxCleanup,
		$GUIFEPreAppxCleanupSel,
		$GUIFELanguageComponents,
		$GUIFELanguageComponentsSel,
		$GUIFECleanupUnusedLP,
		$GUIFECleanupUnusedLPSel,
		$GUIFEVolume,
		$GUIFEVolumePanel,
		$GUIFEDeskMenu,
		$GUIFEDeskMenuShift,
		$GUIFEDefenders,
		$GUIFELangAndKeyboard,
		$GUIFEUtf8,
		$GUIFEUtf8Tips,
		$GUIFELocale,
		$GUIFELocaleTips,
		$GUIFEFixMainFolder,
		$GUIFEFDPermissions,
		$GUIFEShortcut
	))
	$GUIFEPreAppxCleanupSel.controls.AddRange((
		$GUIFEPreAppxCleanupEnabled,
		$GUIFEPreAppxCleanupDisable
	))
	$GUIFELanguageComponentsSel.controls.AddRange((
		$GUIFELanguageComponentsEnabled,
		$GUIFELanguageComponentsDisable
	))
	$GUIFECleanupUnusedLPSel.controls.AddRange((
		$GUIFECleanupUnusedLPEnabled,
		$GUIFECleanupUnusedLPDisable
	))
	if ($GUIFEPreAppxCleanup.Checked) {
		$GUIFEPreAppxCleanupSel.Enabled = $True
	} else {
		$GUIFEPreAppxCleanupSel.Enabled = $False
	}
	if ($GUIFELanguageComponents.Checked) {
		$GUIFELanguageComponentsSel.Enabled = $True
	} else {
		$GUIFELanguageComponentsSel.Enabled = $False
	}
	if ($GUIFECleanupUnusedLP.Checked) {
		$GUIFECleanupUnusedLPSel.Enabled = $True
	} else {
		$GUIFECleanupUnusedLPSel.Enabled = $False
	}
	$GUIFEVolumePanel.controls.AddRange((
		$GUIFEVolumeDefault,
		$GUIFEVolumeSync
	))

	if ($Global:EventQueueMode) {
		$GUIFE.Text = "$($GUIFE.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$GUIFE.ShowDialog() | Out-Null
}

<#
	.Prerequisite deployment
	.先决部署
#>
Function FirstExperience_Process
{
	<#
		.Refresh all known languages installed
		.刷新已安装的所有已知语言
	#>
	Language_Known_Available

	<#
		.Determine whether all languages currently installed are multilingual versions, and add known policies to multilingual versions
		.获取已安装所有语言是否是多语版，多语版则添加已知策略
	#>
	if ($Global:LanguagesAreInstalled.count -ge 2) {
		write-host "  $($lang.LangMul) ( $($Global:LanguagesAreInstalled.count) )"

		<#
			.Appx cleanup maintenance tasks
			.Appx 清理维护任务
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Appx_Tasks") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_Appx_Tasks -Disable
		} else {
			write-host "  $($lang.PreAppxCleanup)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}

		<#
			.Prevent cleanup of unused feature-on-demand language packs
			.阻止清理未使用的按需功能语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_On_Demand_Language") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_On_Demand_Language -Disable
		} else {
			write-host "  $($lang.CleanupOndemandLP)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}

		<#
			.Prevent cleaning of unused language packs
			.阻止清理未使用的语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Unsed_Language") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_Unsed_Language -Disable
		} else {
			write-host "  $($lang.CleanupUnusedLP)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	} else {
		write-host "  $($lang.LangSingle) ( $($Global:LanguagesAreInstalled.count) )"
	}

	<#
		.Network Location Wizard
		.网络位置向导
	#>
	if (Deploy_Sync -Mark "Disable_Network_Location_Wizard") {
		Network_Location_Wizard -Disable
	} else {
		write-host "  $($lang.NetworkLocationWizard)"
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	<#
		.After using the $OEM$ mode to add files, the default is read-only. Change all files to: Normal.
		.使用 $OEM$ 模式添加文件后默认为只读，更改所有文件为：正常。
	#>
	Get-ChildItem "$($PSScriptRoot)\..\..\..\..\..\.." -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	if (Test-Path -Path "$($env:SystemDrive)\Users\Public\Desktop\Office" -PathType Container) {
		Get-ChildItem "$($env:SystemDrive)\Users\Public\Desktop\Office" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	}
	<#
		.Change system disk volume label
		.更改系统盘卷标
	#>
	if (Deploy_Sync -Mark "Sync_Volume_Name") {
		System_Disk_Label -VolumeName $(Get-Module -Name Engine).Author
	} else {
		System_Disk_Label -VolumeName "OS"
	}

	<#
		.Add exclusion to firewall
		.向防火墙添加排除
	#>
	write-host "  $($lang.ExcludeDefenders)"
	if (Deploy_Sync -Mark "Exclude_Defender") {
		Firewall_Exclusion
	} else {
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}

	<#
		.Desktop right-click menu
		.桌面右键菜单
	#>
	if (Deploy_Sync -Mark "Desktop_Menu") {
		Personalise -Del

		if (Deploy_Sync -Mark "Desktop_Menu_Shift") {
			if (Test-Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Desktop_Menu_Shift" -PathType Leaf) {
				Personalise -Add -Hide
			} else {
				Personalise -Add
			}
		} else {
			Personalise -Add
		}
	} else {
		Personalise -Del
	}

	<#
		.Set system language, keyboard, etc.
		.设置系统语言、键盘等
	#>
	Language_Setting

	<#
		.Refresh icon cache
		.刷新图标缓存
	#>
	RefreshIconCache

	<#
		.Set folder and file permissions
		.设置文件夹、文件权限
	#>
	Permissions

	<#
		.Install fonts
		.安装字体
	#>
	Install_Fonts_Process

	<#
		.Unzip the compressed package
		.解压压缩包
	#>
	Unzip_Compressed_Package

	<#
		.After completing the prerequisite deployment, determine whether to restart the computer
		.完成先决条件部署后，判断是否重启计算机
	#>
	write-host "  $($lang.Reboot)"
	if (Deploy_Sync -Mark "Prerequisites_Reboot") {
		write-host "  $($lang.Operable)".PadRight(28) -NoNewline

		<#
			.Setting: Forcibly bypass UAC prompts
			.设置：强行绕过 UAC 提示
		#>
		$Uac_Bypass = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
		if (Get-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue) {
			$GetLanguagePrompt = Get-ItemPropertyValue -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin"
			Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak" -Value $GetLanguagePrompt -ErrorAction SilentlyContinue

			Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -Value 0 -ErrorAction SilentlyContinue
		}

		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		if (-not (Test-Path $regPath)) {
			New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
		}

		$regValue = "cmd /c start /min """" powershell -Command ""Start-Process 'Powershell' -Argument '-ExecutionPolicy ByPass -File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""FirstExperience_Deploy -Quit\""' -WindowStyle Minimized -Verb RunAs"""
		New-ItemProperty -Path $regPath -Name "$((Get-Module -Name Engine).Author)" -Value $regValue -PropertyType STRING -Force | Out-Null

		Restart-Computer -Force
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)`n"
		FirstExperience_Deploy
	}
}

<#
	.First Deployment
	.首次部署
#>
Function FirstExperience_Deploy
{
	param
	(
		[switch]$Quit
	)

	Logo -Title $lang.FirstDeployment
	write-host "  $($lang.FirstDeployment)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	<#
		.Prerequisite deployment rules
		.先决部署规则
	#>
	$Global:MarkRebootComputer = $False
	$FlagsClearSolutionsRule = $False

	if ($Reboot) {
		$Global:MarkRebootComputer = $True
	}
	if (Deploy_Sync -Mark "First_Experience_Reboot") {
		$Global:MarkRebootComputer = $True
	}

	if (Deploy_Sync -Mark "Clear_Solutions") {
		$FlagsClearSolutionsRule = $True
	}
	if (Deploy_Sync -Mark "Clear_Engine") {
		$FlagsClearSolutionsRule = $True
	}

	<#
		.Restore last setting: Bypass the UAC prompt
		.恢复上次设置：绕过 UAC 提示
	#>
	$Uac_Bypass = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	if (Get-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak" -ErrorAction SilentlyContinue) {
		$GetLanguagePrompt = Get-ItemPropertyValue -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak"
		Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -Value $GetLanguagePrompt -ErrorAction SilentlyContinue

		Remove-ItemProperty -LiteralPath $Uac_Bypass -Name 'ConsentPromptBehaviorAdmin_Bak' -Force -ErrorAction SilentlyContinue | Out-Null
	}

	<#
		.Pop up the main interface
		.弹出主界面
	#>
	write-host "  $($lang.FirstDeploymentPopup)"
	if ($FlagsClearSolutionsRule) {
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	} else {
		if (Deploy_Sync -Mark "Popup_Engine") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Start-Process powershell -ArgumentList "-file $((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"
		} else {
			write-host "  $($lang.Inoperable)" -ForegroundColor Red
		}
	}

	<#
		.Create Shortcut
		.创建快捷方式
	#>
	Shortcut_Process

	<#
		.Allow the first pre-experience, as planned
		.允许首次预体验，按计划
	#>
	write-host "`n  $($lang.FirstExpFinishOnDemand)"
	if (Deploy_Sync -Mark "Allow_First_Pre_Experience") {
		write-host "  $($lang.Operable)" -ForegroundColor Green

		<#
			.Create a restore point
			.创建还原点
		#>
#		Restore_Point_Create

		<#
			.Change user directory
			.更改用户目录
		#>
#		Change_Location_Set_Path -KnownFolder 'Desktop'   -NewFolder "D:\Yi\Desktop"
#		Change_Location_Set_Path -KnownFolder 'Documents' -NewFolder "D:\Yi\Documents"
#		Change_Location_Set_Path -KnownFolder 'Downloads' -NewFolder "D:\Yi\Downloads"
#		Change_Location_Set_Path -KnownFolder 'Music'     -NewFolder "D:\Yi\Music"
#		Change_Location_Set_Path -KnownFolder 'Pictures'  -NewFolder "D:\Yi\Pictures"
#		Change_Location_Set_Path -KnownFolder 'Videos'    -NewFolder "D:\Yi\Videos"

		<#
			.Desktop icons
			.桌面图标
		#>
		Desktop_ICON_ThisPC -AllUsers           # 此电脑              | This computer
#		Desktop_ICON_Recycle_Bin -AllUsers      # 回收站              | Recycle Bin
		Desktop_ICON_User -AllUsers             # 用户                | User
#		Desktop_ICON_Control_Panel -AllUsers    # 控制面板            | Control Panel
#		Desktop_ICON_Network -AllUsers          # 网络                | Network
#		Desktop_ICON_God_Mode                   # 上帝模式            | God Mode
#		Desktop_ICON_IE -AllUsers               # Internet Explorer
		Reset_Desktop                           # 重新排列桌面图标     | Rearrange desktop icons

		<#
			.优化电源前判断计算机类型
			.Determine the computer type before optimizing the power supply
		#>
		$NoSelectPowerSupply = @(8, 9, 10, 11, 14)
		Get-CimInstance -ClassName Win32_SystemEnclosure | ForEach-Object {
			if ($NoSelectPowerSupply -notcontains $_.SecurityStatus) {
				Hibernation -Disable            # Disable, Enabled            | $lang.Hibernation
				Power_Supply -Optimize          # Optimize, Restore           | $lang.PowerSupply
			}
		}

		<#
			.优化系统
			.Optimize the system
		#>
		if (IsWin11) {
			Win11_TPM_Setup
			Win11_TPM_Update
		}
		Keep_Space -Disable             # Disable, Enabled             | $lang.KeepSpace
		App_Restart_Screen -Disable     # Disable, Enabled             | $lang.AppRestartScreen
		Numlock -Enabled                # Disable, Enabled             | $lang.Numlock
		UAC_Never -Disable              # Disable, Enabled             | $lang.UAC $lang.UACNever
		Smart_Screen_Apps -Disable      # Disable, Enabled             | $lang.SmartScreenApps
		Smart_Screen_Safe -Disable      # Disable, Enabled             | $lang.SmartScreenSafe
		Easy_Access_Keyboard -Disable   # Disable, Enabled             | $lang.EasyAccessKeyboard
		Maintain -Disable               # Disable, Enabled             | $lang.Maintain
		Experience -Disable             # Disable, Enabled             | $lang.Experience
		Defragmentation -Disable        # Disable, Enabled             | $lang.Defragmentation
		Compatibility -Disable          # Disable, Enabled             | $lang.Compatibility
		Animation_Effects -Optimize     # Optimize, Restore            | $lang.AnimationEffects
		Error_Recovery -Disable         # Disable, Enabled             | $lang.ErrorRecovery
#		DEPPAE -Disable                 # Disable, Enabled             | $lang.DEP
		Power_Failure -Disable          # Disable, Enabled             | $lang.PowerFailure
		Scheduled_Tasks -Disable        # Disable, Restore             | $lang.ScheduledTasks
		Password_Unlimited -Disable     # Disable, Enabled             | $lang.PwdUnlimited
		RAM -Disable                    # Disable, Enabled             | $lang.RAM
		Storage_Sense -Disable          # Disable, Enabled             | $lang.StorageSense
		Delivery -Disable               # Disable, Enabled             | $lang.Delivery
		Photo_Preview -Enabled          # Disable, Enabled             | $lang.PhotoPreview
		Protected -Disable              # Disable, Enabled             | $lang.Protected
		Error_Reporting -Disable        # Disable, Enabled             | $lang.ErrorReporting
#		F8_Boot_Menu -Disable           # Disable, Enabled             | $lang.F8BootMenu
		SSD -Disable                    # Disable, Enabled             | $lang.OptSSD
		Memory_Compression -Disable     # Disable, Enabled             | $lang.MemoryCompression
		Prelaunch -Disable              # Disable, Enabled             | $lang.Prelaunch

		<#
			.网络优化
		#>
#		IEProxy                               # Disable, Enabled             | $lang.IEProxy
		Auto_Detect -Disable                  # Disable, Enabled             | $lang.IEAutoSet
#		Network_Discovery -Disable            # Disable, Enabled             | $lang.NetworkDiscovery
#		Network_Adapters_Save_Power -Disable  # Disable, Enabled             | $lang.NetworkAdaptersPM
#		IPv6_Component -Disable               # Disable, Enabled             | $lang.IPv6Component
		QOS -Disable                          # Disable, Enabled             | $lang.QOS
		Network_Tuning -Disable               # Disable, Enabled             | $lang.NetworkTuning
		ECN -Disable                          # Disable, Enabled             | $lang.ECN

		<#
			.Resource manager
			.资源管理器
		#>
#		Separate_Process -Disable       # Disable, Enabled             | $lang.SeparateProcess
#		Restart_Apps -Disable           # Disable, Enabled             | $lang.RestartApps
#		Check_Boxes -Disable            # Disable, Enabled             | $lang.CheckBoxes
#		Thumbnail_Cache -Disable        # Disable, Enabled             | $lang.ThumbnailCache
		Explorer_Open_To -ThisPC        # Disable, Enabled             | $lang.ExplorerToThisPC
		Aero_Shake -Disable -AllUser    # Disable, Enabled             | $lang.AeroShake
		File_Extensions -Show           # Show, Hide                   | $lang.FileExtensions
		Safety_Warnings -Disable        # Disable, Enabled             | $lang.SafetyWarnings
		File_Transfer_Dialog -Detailed  # Detailed, Simple             | $lang.FileTransfer
		Nav_Show_All -Enabled            # Disable, Enabled            | $lang.NavShowAll
#		Autoplay -Disable               # Disable, Enabled             | $lang.Autoplay
#		Autorun -Disable                # Disable, Enabled             | $lang.Autorun
		Quick_Access_Files -Hide        # Show, Hide                   | $lang.QuickAccessFiles
		Quick_Access_Folders -Hide      # Show, Hide                   | $lang.QuickAccessFolders
		Shortcut_Arrow -Disable         # Disable, Enabled             | $lang.ShortcutArrow

		Desktop_Icon_ThisPC -Disable    # Disable, Enabled             | $lang.LocationDesktop
		Desktop_Icon_Document -Disable  # Disable, Enabled             | $lang.LocationDocuments
		Desktop_Icon_Download -Disable  # Disable, Enabled             | $lang.LocationDownloads
		Desktop_Icon_Music -Disable     # Disable, Enabled             | $lang.LocationMusic
		Desktop_Icon_Picture -Disable   # Disable, Enabled             | $lang.LocationPictures
		Desktop_Icon_Video -Disable     # Disable, Enabled             | $lang.LocationVideos
		if (-not (IsWin11)) {
			Desktop_Icon_3D -Disable    # Disable, Enabled             | $lang.Location3D
		}

		<#
			.Right click menu
			.右键菜单
		#>
		if (IsWin11) {
			Win11_Context_Menu -Modern        # Modern, Classic             | $lang.ClassicMenu
		}
		Take_Ownership -Remove                # Del $lang.AddOwnership
		Take_Ownership -Add                   # Add $lang.AddOwnership
		File_Selection_Restrictions -Disable  # Disable, Enabled            | $lang.MultipleIncrease
		Copy_Path -Add                        # Remove, Add                 | $lang.CopyPath

		<#
			.Start menu and taskbar
			.开始菜单和任务栏
		#>
		if (IsWin11) {
#			Taskbar_Alignment -Leaf          # Leaf, Center                | $lang.TaskbarAlignment
			Taskbar_Widgets -Hide            # Show, Hide                  | $lang.TaskbarWidgets
		}
		Teams_Autostarting -Disable          # Disable, Enabled            | $lang.TeamsAutostarting
		Teams_Taskbar_Chat -Hide             # Show, Hide                  | $lang.TeamsTaskbarChat
		Bing_Search -Disable                 # Disable, Enabled            | $lang.BingSearch
		Taskbar_Suggested_Content -Hide      # Show, Hide                  | $lang.TaskbarSuggestedContent
		Suggestions_Device -Disable          # Disable, Enabled            | $lang.SuggestionsDevice
		Search_Box -SearchIcon               # Hide, SearchIcon, SearchBox | $lang.SearchBox
		Merge_Taskbar_Never -Enabled         # Disable, Enabled            | $lang.MergeTaskbarNever
		Notification_Center_Always -Enabled  # Disable, Enabled            | $lang.NotificationAlways
		Cortana -Disable                     # Disable, Enabled            | $lang.Cortana
		Task_View -Hide                      # Show, Hide                  | $lang.TaskView

		<#
			.Game Bar
		#>
		XboxGameBar -Disable                 # Disable, Enabled            | $lang.XboxGameBar
		XboxGameBarTips -Disable             # Disable, Enabled            | $lang.XboxGameBarTips
		XboxGameMode -Disable                # Disable, Enabled            | $lang.XboxGameMode
		XboxGameDVR -Disable                 # Disable, Restore            | $lang.XboxGameDVR

		<#
			.Privacy
			.隐私
		#>
		Privacy_Voice_Typing -Disable            # Disable, Enabled     | $lang.PrivacyVoiceTyping
		Privacy_Contacts_Speech -Disable         # Disable, Enabled     | $lang.PrivacyContactsSpeech
		Privacy_Language_Opt_Out -Disable        # Disable, Enabled     | $lang.PrivacyLanguageOptOut
		Privacy_Ads -Disable                     # Disable, Enabled     | $lang.PrivacyAds
		Privacy_Locaton_Aware -Disable           # Disable, Enabled     | $lang.PrivacyLocatonAware
		Privacy_Set_Sync -Disable                # Disable, Enabled     | $lang.PrivacySetSync
		Privacy_Inking_Typing -Disable           # Disable, Enabled     | $lang.PrivacyInkingTyping
		Privacy_Share_Unpaired_Devices -Disable  # Disable, Enabled     | $lang.PrivacyShareUnpairedDevices
		Privacy_Location_Sensor -Disable         # Disable, Enabled     | $lang.PrivacyLocationSensor
		Privacy_Biometrics -Disable              # Disable, Enabled     | $lang.PrivacyBiometrics
		Privacy_Compatible_Telemetry -Disable    # Disable, Enabled     | $lang.PrivacyCompatibleTelemetry
		Privacy_Diagnostic_Data -Disable         # Disable, Enabled     | $lang.PrivacyDiagnosticData
		Privacy_Tailored_Experiences -Disable    # Disable, Enabled     | $lang.TailoredExperiences
		Privacy_Feedback_Notifications -Disable  # Disable, Enabled     | $lang.PrivacyFeedbackNotifications
		Privacy_Location_Tracking -Disable       # Disable, Enabled     | $lang.PrivacyLocationTracking
		Privacy_Experiences_Telemetry -Disable   # Disable, Enabled     | $lang.ExperiencesTelemetry
		Privacy_Background_Access -Disable       # Disable, Enabled     | $lang.PrivacyBackgroundAccess
		if (-not (IsWin11)) {
			Timeline_Time -Disable               # Disable, Enabled     | $lang.TimelineTime
			Collect_Activity -Disable            # Disable, Enabled     | $lang.CollectActivity
		}

		<#
			.Paging size
			.分页大小
		#>
		System_Disk_Page_Size -Enabled -size 8   # 8, 16  | $lang.PagingSize 8G and 16G

		<#
			.Notification Center
			.通知中心
		#>
		Notification_Center -Part       # Full, Part, Restore | $lang.Notification $lang.Full

		<#
			.Other
			.其它
		#>
#		Remote_Desktop                  # $lang.StRemote
#		SMB_File_Share                  # $lang.StSMB

		<#
			.Clean
			.清理
		#>
		Send_To                         # $lang.SendTo
		Cleanup_System_Log              # $lang.Logs
		Cleanup_Disk                    # $lang.DiskCleanup
#		Cleanup_SxS                     # $lang.SxS

		<#
			.Optimize service
			.优化服务
		#>
		$PreServices = @(
#			"Spooler"
			"DPS"
			"WdiSystemHost"
			"WdiServiceHost"
			"diagnosticshub.standardcollector.service"
			"dmwappushservice"
			"lfsvc"
			"MapsBroker"
			"NetTcpPortSharing"
			"RemoteAccess"
			"RemoteRegistry"
			"SharedAccess"
			"TrkWks"
			"WbioSrvc"
			"WlanSvc"
			"WMPNetworkSvc"
			"WSearch"
			"XblAuthManager"
			"XblGameSave"
			"XboxNetApiSvc"
		)

		ForEach ($item in $PreServices) {
			write-host "  $($lang.Close) $item"
			Get-Service -Name $item | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
			Stop-Service $item -Force -NoWait -ErrorAction SilentlyContinue | Out-Null
			write-host "  $($lang.Done)`n" -ForegroundColor Green
		}

		<#
			.Delete UWP app
			.删除 UWP 应用
		#>
		[Windows.Management.Deployment.PackageManager, Windows.Web, ContentType = WindowsRuntime]::new().FindPackages() | Select-Object -ExpandProperty Id -Property DisplayName | Where-Object -FilterScript {
			($_.Name -in (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name) -and ($null -ne $_.DisplayName)} | ForEach-Object {
			if (($AppsUncheck + $AppsExcluded) -Contains $_.Name) {
			} else {
				write-host "  $($_.Name)"
				write-host "  $($lang.Del)".PadRight(22) -NoNewline
				Get-AppXProvisionedPackage -Online | Where-Object DisplayName -Like "$($_.Name)" | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
				Get-AppxPackage -Name "$($_.Name)" | Remove-AppxPackage | Out-Null
				Write-Host "$($lang.Done)`n" -ForegroundColor Green
			}
		}
		Write-Host

		<#
			.Install prerequisite software
			.安装必备软件
		#>
		$DynamicInstl = "$($PSScriptRoot)\..\..\..\Instl\Instl.ps1"
		if (Test-Path $DynamicInstl -PathType Leaf) {
			$init_Install_App = @(
				"45bf2c42-ec67-440a-8403-0ad31864f47a"    # Google Chrome
				"a1f51cf8-32c8-431c-8b2e-f7f8ad208863"    # 7Zip
			)

			$NewConfig = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..") -ChildPath "langpacks\$($Global:IsLang)\App.json"

			if (Test-Path $NewConfig -PathType Leaf) {
				Start-Process powershell -ArgumentList "-File $($DynamicInstl) -Config ""$($NewConfig)"" -App ""$($init_Install_App)""" -NoNewWindow -Wait
			} else {
				write-host "    $($lang.UpdateUnavailable)" -ForegroundColor Yellow
				write-host "    $($NewConfig)" -ForegroundColor Red
			}
		} else {
			write-host "`n  $($lang.InstlNo)$DynamicInstl" -ForegroundColor Red
		}

		<#
			.Install common software
			.安装常用软件
		#>
#		if (Test-Path $DynamicInstl -PathType Leaf) {
#			$init_Install_App = @(
#				"5512e164-3969-488f-a48e-1dd24145c633"    # QQ
#				"1da42d07-876c-4134-9b22-c2608634e8d8"    # Weixin
#				"45bf2c42-ec67-440a-8403-0ad31864f47a"    # Google Chrome
#				"a1f51cf8-32c8-431c-8b2e-f7f8ad208863"    # 7Zip
#			)

#			& $DynamicInstl -App $init_Install_App
#		} else {
#			write-host "`n  $($lang.InstlNo)$DynamicInstl" -ForegroundColor Red
#		}
	} else {
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	write-host "`n  $($lang.FirstDeployment)"
	Deploy_Guide

	<#
		.Search for Bat and PS1
		.搜索 Bat、PS1
	#>
	write-host "`n  $($lang.DiskSearch)"

	<#
		.Search for local deployment: Bat
		.搜索本地部署：Bat
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\bat" -Filter "*.bat" -ErrorAction SilentlyContinue | ForEach-Object {
		Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
		Write-host $_.Fullname -ForegroundColor Green
		Start-Process -FilePath $_.Fullname  -wait -WindowStyle Minimized
	}

	<#
		.Search for local deployment: ps1
		.搜索本地部署：ps1
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\ps1" -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
		Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
		Write-host $_.Fullname -ForegroundColor Green
		$arguments = @(
			"-ExecutionPolicy",
			"ByPass",
			"-file",
			"""$($_.Fullname)"""
		)

		Start-Process "powershell" -ArgumentList $arguments -Wait -WindowStyle Minimized
	}

	<#
		.Full plan, search by rule: Bat
		.全盘计划，按规则搜索：Bat
	#>
	$SearchBatFile = @(
		"$((Get-Module -Name Engine).Author).bat"
		"$((Get-Module -Name Engine).Author)\$((Get-Module -Name Engine).Author).bat"
		"$((Get-Module -Name Engine).Author)\Deploy\$((Get-Module -Name Engine).Author).bat"
		"$((Get-Module -Name Engine).Author)\Deploy\Bat\$((Get-Module -Name Engine).Author).bat"
	)
	ForEach ($item in $SearchBatFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path $_.Root -ChildPath $item

			write-host "  $($TempFilePath)"
			if (Test-Path $TempFilePath -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TempFilePath -ForegroundColor Green
				Start-Process -FilePath $TempFilePath -wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Full plan, search by rule: ps1
		.全盘计划，按规则搜索：ps1
	#>
	$SearchPSFile = @(
		"$((Get-Module -Name Engine).Author).ps1"
		"$((Get-Module -Name Engine).Author)\$((Get-Module -Name Engine).Author).ps1"
		"$((Get-Module -Name Engine).Author)\Deploy\$((Get-Module -Name Engine).Author).ps1"
		"$((Get-Module -Name Engine).Author)\Deploy\PS1\$((Get-Module -Name Engine).Author).ps1"
	)
	ForEach ($item in $SearchPSFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path $_.Root -ChildPath $item

			write-host "  $($TempFilePath)"
			if (Test-Path $TempFilePath -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TempFilePath -ForegroundColor Green

				$arguments = @(
					"-ExecutionPolicy",
					"ByPass",
					"-file",
					"""$($TempFilePath)"""
				)

				Start-Process "powershell" -ArgumentList $arguments -Wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Recovery PowerShell strategy
		.恢复 PowerShell 策略
	#>
	write-host "`n  $($lang.Restricted)`n" -ForegroundColor Green
	if (Deploy_Sync -Mark "Reset_Execution_Policy") {
		write-host "  $($lang.Operable)" -ForegroundColor Green
		Set-ExecutionPolicy -ExecutionPolicy Restricted -Force
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	<#
		.Clean up the solution
		.清理解决方案
	#>
	if (Deploy_Sync -Mark "Clear_Solutions") {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		$UniqueMainFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\.." -ErrorAction SilentlyContinue
		Remove_Tree -Path $UniqueMainFolder

		<#
			.In order to prevent the solution from being unable to be cleaned up, the next time you log in, execute it again
			.为了防止无法清理解决方案，下次登录时，再次执行
		#>
		write-host "  $($lang.NextDelete)`n" -ForegroundColor Green
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		$regKey = "Clear $((Get-Module -Name Engine).Author) Folder"
		$regValue = "cmd.exe /c rd /s /q ""$($UniqueMainFolder)"""
		if (Test-Path $regPath) {
			New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
		} else {
			New-Item -Path $regPath -Force | Out-Null
			New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
		}
	}

	<#
		.Clean up the main engine
		.清理主引擎
	#>
	if (Deploy_Sync -Mark "Clear_Engine") {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		Remove_Tree -Path "$($PSScriptRoot)\..\..\..\.."
	}

	<#
		.Clean up deployment configuration
		.清理部署配置
	#>
	Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy"

	write-host "  $($lang.Reboot)"
	if ($Global:MarkRebootComputer) {
		<#
			.Reboot Computer
			.重启计算机
		#>
		Restart-Computer -Force
		write-host "  $($lang.Done)" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)"
	}

	if ($Quit) {
		Stop-Process $PID
	}
}


<#
	.Appx cleanup maintenance tasks
	.Appx 清理维护任务
#>
Function Cleanup_Appx_Tasks
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PreAppxCleanup)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Prevent cleaning of unused language packs
	.阻止清理未使用的语言包
#>
Function Cleanup_On_Demand_Language
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.CleanupUnusedLP)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null

		Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name 'BlockCleanupOfUnusedPreinstalledLangPacks' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null

		If (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Control Panel\International")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name "BlockCleanupOfUnusedPreinstalledLangPacks" -Type DWord -Value 1 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Prevent cleanup of unused feature-on-demand language packs
	.阻止清理未使用的按需功能语言包
#>
Function Cleanup_Unsed_Language
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.CleanupOndemandLP)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null

		Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name 'AllowLanguageFeaturesUninstall' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null

		If (-not (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput")) {
			New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name "AllowLanguageFeaturesUninstall" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Network Location Wizard
	.网络位置向导
#>
Function Network_Location_Wizard
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.NetworkLocationWizard)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Change system disk volume label
	.更改系统盘卷标
#>
Function System_Disk_Label
{
	param
	(
		[string]$VolumeName
	)

	write-host "`n  $($lang.VolumeLabel): " -NoNewline
	Write-host $VolumeName -ForegroundColor Green
	write-host "  $($lang.Setting)".PadRight(28) -NoNewline
	(New-Object -ComObject "Shell.Application").NameSpace($env:SystemDrive).Self.Name = $VolumeName
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Add exclusion to firewall
	.向防火墙添加排除
#>
Function Firewall_Exclusion
{
	$ExcludeMpPreference = @(
		(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue)
	)

	ForEach ($item in $ExcludeMpPreference) {
		write-host "  $($item)"
		write-host "  $($lang.AddTo)".PadRight(28) -NoNewline
		Add-MpPreference -ExclusionPath (Convert-Path -Path $item -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)" -ForegroundColor Green
	}
}

Function Repair_Home_Directory
{
	write-host "`n  $($lang.FixMainFolder): $((Get-Module -Name Engine).Author)"

	$DeskEdit = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\..\AIO\DeskEdit")\DeskEdit.exe"
	if (Test-Path $DeskEdit -PathType Leaf) {
		Start-Process -FilePath $DeskEdit -ArgumentList "/F=""$($Global:UniqueMainFolder)"" /S=.ShellClassInfo /L=LocalizedResourceName=""$((Get-Module -Name Engine).Author)'s Solutions""" -wait

		$IconPath = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Assets\icons\Engine.ico" -ErrorAction SilentlyContinue
		if (Test-Path -Path $IconPath -PathType Leaf) {
			Start-Process -FilePath $DeskEdit -ArgumentList "/F=""$($Global:UniqueMainFolder)"" /S=.ShellClassInfo /L=IconResource=""$($IconPath),0"""
		}
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}
}