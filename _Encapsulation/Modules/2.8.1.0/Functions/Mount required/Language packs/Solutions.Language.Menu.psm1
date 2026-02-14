<#
	.Menu: Language
	.菜单：语言
#>
Function Language_Menu
{
	Logo -Title $lang.Language
	Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "  " -NoNewline
	if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
		Write-Host " O'D RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Mount_To_Route -ForegroundColor Green
	} else {
		Write-Host " O'D RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Mount_To_Route -ForegroundColor Red
	}

	Write-host "  " -NoNewline
	if (Test-Path -Path $Global:Image_source -PathType Container) {
		Write-Host " O'D MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Image_source -ForegroundColor Green
	} else {
		Write-Host " O'D MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Image_source -ForegroundColor Red

		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red

		ToWait -wait 6
		Language_Menu
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n  $($lang.Unzip_Language)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "    " -NoNewline
	Write-Host " E " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.LanguageExtract)" -ForegroundColor Green

	Write-host "    " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		Write-Host "  $($lang.AddTo)" -ForegroundColor Green
	} else {
		Write-Host "  $($lang.AddTo)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		Write-Host "  $($lang.Del)" -ForegroundColor Green
	} else {
		Write-Host "  $($lang.Del)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " 3 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		Write-Host "  $($lang.SwitchLanguage)" -ForegroundColor Green
	} else {
		Write-Host "  $($lang.SwitchLanguage)" -ForegroundColor Red
	}

	$test_mount_folder_Current  = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
	$LanguageRepair_ISO_Path    = Join-Path -Path $Global:Image_source -ChildPath "Sources"
	$LanguageRepair_Path        = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount\Sources"

	Write-Host "`n  $($lang.BootSyncToISO)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Verify_Is_Current_Same) {
		if (Image_Is_Select_Boot) {
			Write-host "    " -NoNewline
			Write-Host " 4 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			if (Test-Path -Path $LanguageRepair_Path -PathType Container) {
				Write-Host "  $($lang.BootSyncToISO)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.BootSyncToISO)" -ForegroundColor Red
			}

			Write-Host "         > $($lang.ProcessSources): "
			Write-Host "           $($LanguageRepair_Path)" -ForegroundColor Yellow

			Write-Host "         + $($Lang.Sync_Language_To): "
			Write-Host "           $($LanguageRepair_ISO_Path)" -ForegroundColor Yellow
		} else {
			Write-Host "  $($lang.BootProcess -f "boot")" -ForegroundColor Red
		}
	} else {
		Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "`n  $($lang.MoreFeature)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "    " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		Write-Host "  $($lang.OnlyLangCleanup)" -ForegroundColor Green
	} else {
		Write-Host "  $($lang.OnlyLangCleanup)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " L " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		if (Image_Is_Select_Boot) {
			Write-Host "  $($lang.LangIni)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.LangIni)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.LangIni)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " V " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Verify_Is_Current_Same) {
		Write-Host "  $($lang.ViewLanguage)" -ForegroundColor Green
	} else {
		Write-Host "  $($lang.ViewLanguage)" -ForegroundColor Red
	}

	Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "    " -NoNewline
	Write-Host " P " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " S " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.ExportShow)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.ExportShow)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.ExportShow)" -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value

			Write-Host "`n   $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "   $('-' * 79)"
			Write-host "   " -NoNewline
			Write-Host " SS " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($Temp_Expand_Rule)" -ForegroundColor Green
		}
	}

	Solutions_Menu_Shortcut
	Solutions_Input_Menu
	$NewEnter = Read-Host

	<#
		.The prefix cannot contain spaces
		.前缀不能带空格
	#>
	while ($true) {
		if ($NewEnter -match '^\s') {
			$NewEnter = $NewEnter.Remove(0, 1)
		} else {
			break
		}
	}

	switch -Wildcard ($NewEnter)
	{
		"e" {
			Language_Extract_UI
			ToWait -wait 2
			Language_Menu
		}
		"1" {
			Language_Menu_Shortcuts_LA
			ToWait -wait 2
			Language_Menu
		}
		"2" {
			Language_Menu_Shortcuts_LD
			ToWait -wait 2
			Language_Menu
		}
		"3" {
			Language_Menu_Shortcuts_LS
			ToWait -wait 2
			Language_Menu
		}
		"4" {
			Write-Host "`n  $($lang.BootSyncToISO)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.ProcessSources)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($LanguageRepair_Path)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Test-Path -Path $LanguageRepair_Path -PathType Container) {
				if (Image_Is_Select_Boot) {
					if (Test-Path -Path $LanguageRepair_Path -PathType Container) {
						Language_Sync_To_ISO_Process
						Get_Next -DevCode "LM 1"
					} else {
						Write-Host $lang.Mounted -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.BootProcess -f "boot")" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"c" {
			Write-Host "`n  $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					<#
						.Assign available tasks
						.分配可用的任务
					#>
					Event_Assign -Rule "Language_Cleanup_Components_UI" -Run
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"l" {
			Write-Host "`n  $($lang.LangIni)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					if (Image_Is_Select_Boot) {
						Language_Refresh_Ini
						Get_Next -DevCode "LM 2"
					} else {
						Write-Host "  $($lang.BootProcess -f "boot")" -ForegroundColor Red
					}
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"v" {
			Write-Host "`n  $($lang.ViewLanguage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Dism.exe /Image:""$($test_mount_folder_Current)"" /Get-Intl" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
					}

					start-process "Dism.exe" -ArgumentList "/Image:""$($test_mount_folder_Current)"" /Get-Intl" -wait -nonewwindow
					Get_Next -DevCode "LM 3"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"p" {
			Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Components_Package -Save $Temp_Export_SaveTo
					Get_Next -DevCode "LM 4"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"s" {
			Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Components_Package -Save $Temp_Export_SaveTo -View
					Get_Next -DevCode "LM 5"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}
		"ss" {
			Write-Host "`n  $($lang.Setting): $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					Setting_Export_To_UI
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Language_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Language_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Language_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount
			ToWait -wait 2
			Language_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount_Key_and_Index -Command $PSItem
			ToWait -wait 2
			Language_Menu
		}

			<#
				.快捷指令：重新挂载
			#>
			"rmt" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_ReMount
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重新挂载 + 主键
			#>
			"rmt *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_ReMount_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

		<#
			.快捷指令：保存当前映像
		#>
		"Save*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Save -Name $PSItem
			ToWait -wait 2
			Language_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Unmt -Name $PSItem
			ToWait -wait 2
			Language_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：保存
		#>
		"ESE*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.Save -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			if ($PSItem -like "*-Q*") {
				Eject_Forcibly_All -Save -DontSave -Quick
			} else {
				Eject_Forcibly_All -Save -DontSave
			}

			ToWait -wait 2
			Language_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：不保存
		#>
		"EDNS*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.DoNotSave -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			if ($PSItem -like "*-Q*") {
				Eject_Forcibly_All -DontSave -Quick
			} else {
				Eject_Forcibly_All -DontSave
			}

			ToWait -wait 2
			Language_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Language_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Select -Name $PSItem
			ToWait -wait 2
			Language_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next -DevCode "LM 6"
			ToWait -wait 2
			Language_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Language_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Shortcuts_Developers_Mode
			ToWait -wait 2
			Language_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Language_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Language_Menu"
		}

		<#
			.快捷指令：查看并接受许可条款
		#>
		“vTC" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Eject_Abandon_Agreement
			ToWait -wait 2
			Language_Menu
		}

		default {
			Mainpage
		}
	}
}

<#
	.同步语言包到安装程序
#>
Function Language_Sync_To_ISO_Process
{
	$SearchImageSources = Join-Path -Path $Global:Image_source -ChildPath "Sources"

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		<#
			.同步已挂载的语言包到 ISO 安装程序
		#>
		$TestFolderRegion = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount\sources\$($itemRegion.Region)"

		if (Test-Path -Path $TestFolderRegion -PathType Container) {
			Write-Host "  $($lang.Paste)"
			Write-Host "  > $($TestFolderRegion)"
			Write-Host "  + $($SearchImageSources)\$($itemRegion.Region)"

			Copy-Item -Path $TestFolderRegion -Destination $SearchImageSources -Recurse -Force -ErrorAction SilentlyContinue

			Write-Host "  $($lang.Done)`n" -ForegroundColor Green
		}
	}
}

<#
	.自动修复安装程序缺少项：已挂载
#>
Function Language_Repair_Cli
{
	param
	(
		$PathSources,
		$SaveTo
	)

	$Language_Repair_FileList = @(
		"arunres.dll.mui"
		"spwizres.dll.mui"
		"w32uires.dll.mui"
	)

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$LanguageRepair_Path = "$($PathSources)\$($itemRegion.Region)"
		$Offline_Mount_Path_Sources = "$($SaveTo)\$($itemRegion.Region)"

		if (Test-Path -Path $Offline_Mount_Path_Sources -PathType Container) {
			Write-Host "  $($lang.SaveTo): " -NoNewline
			Write-Host $Offline_Mount_Path_Sources -ForegroundColor Yellow

			ForEach ($itemCheckRepir in $Language_Repair_FileList) {
				$NewRepairFullPath = "$($LanguageRepair_Path)\$($itemCheckRepir)"

				Write-Host "  $($itemCheckRepir): " -NoNewline -ForegroundColor Yellow
				if (Test-Path -Path $NewRepairFullPath -PathType leaf) {
					Write-Host " $($lang.Paste): " -NoNewline
					Check_Folder -chkpath $Offline_Mount_Path_Sources
					Copy-Item -Path $NewRepairFullPath -Destination $Offline_Mount_Path_Sources -Force -ErrorAction SilentlyContinue

					if (Test-Path -Path "$($Offline_Mount_Path_Sources)\$($itemCheckRepir)" -PathType leaf) {
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} else {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					}
				} else {
					Write-Host "$($lang.MatchMode), $($lang.Failed)" -ForegroundColor Red
				}
			}

			Write-Host
		}
	}
}

<#
	.生成同步语言列表
#>
Function Language_Refresh_Ini
{
	$TestFolderMount_To_Route = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	Write-Host "  $($lang.Rebuilding): " -NoNewline
	dism /image:""$($TestFolderMount_To_Route)"" /gen-langini /distribution:""$($TestFolderMount_To_Route)""
	dism /image:""$($TestFolderMount_To_Route)"" /gen-langini /distribution:""$($Global:Image_source)""
	Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
}


Function Language_Menu_Shortcuts_LA
{
	Write-Host "`n  $($lang.Language): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Language_Add_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Language_Menu_Shortcuts_LD
{
	Write-Host "`n  $($lang.Language): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Language_Delete_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Language_Menu_Shortcuts_LS
{
	Write-Host "`n  $($lang.SwitchLanguage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Language_Change_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}