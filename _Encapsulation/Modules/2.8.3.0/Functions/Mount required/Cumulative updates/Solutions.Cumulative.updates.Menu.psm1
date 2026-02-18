<#
	.Update management
	.更新管理
#>
Function Cumulative_updates_menu
{
	Logo -Title $lang.CUpdate
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
		Cumulative_updates_menu
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n  $($lang.CUpdate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "   " -NoNewline
	Write-Host " CT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RuleNewTempate)" -ForegroundColor Green


	Write-host "    " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.AddTo)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.AddTo)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.AddTo)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Del)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Del)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Del)" -ForegroundColor Red
	}

	Write-Host "`n  $($lang.MoreFeature)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "    " -NoNewline
	Write-Host " 3 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.CuringUpdate)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.CuringUpdate)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.CuringUpdate)" -ForegroundColor Red
	}

	Write-Host "         $('-' * 73)"
	Write-host "         " -NoNewline
	Write-Host " 31 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Superseded)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Superseded)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Superseded)" -ForegroundColor Red
	}

	Write-host "         " -NoNewline
	Write-Host " 32 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Superseded), $($lang.ExcludeItem)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Superseded), $($lang.ExcludeItem)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Superseded), $($lang.ExcludeItem)" -ForegroundColor Red
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
		"ct" {
			Create_Template_UI
			ToWait -wait 2
			Cumulative_updates_menu
		}
		"1" {
			Shortcuts_Cumulative_updates_Add
			ToWait -wait 2
			Cumulative_updates_menu
		}
		"2" {
			Shortcuts_Cumulative_updates_Delete
			ToWait -wait 2
			Cumulative_updates_menu
		}
		"3" {
			Write-Host "`n  $($lang.CuringUpdate)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
					Event_Process_Task_Need_Mount
					New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Uid)" -Value $False -Force

					Get_Next -DevCode "CU 1"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Cumulative_updates_menu
		}
		"31" {
			Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
					Image_Clear_Superseded
					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Uid)" -Value $False -Force

					Get_Next -DevCode "CU 2"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Cumulative_updates_menu
		}
		"32" {
			Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline

				if (Verify_Is_Current_Same) {
					Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
					New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
					Image_Clear_Superseded
					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
					New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Uid)" -Value $False -Force

					Get_Next -DevCode "CU 3"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Cumulative_updates_menu
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
					Get_Next -DevCode "CU 4"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Cumulative_updates_menu
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
					Get_Next -DevCode "CU 5"
				} else {
					Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Cumulative_updates_menu
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
			Cumulative_updates_menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Cumulative_updates_menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Cumulative_updates_menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount
			ToWait -wait 2
			Cumulative_updates_menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount_Key_and_Index -Command $PSItem
			ToWait -wait 2
			Cumulative_updates_menu
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
			Cumulative_updates_menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Unmt -Name $PSItem
			ToWait -wait 2
			Cumulative_updates_menu
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
			Cumulative_updates_menu
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
			Cumulative_updates_menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Cumulative_updates_menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Select -Name $PSItem
			ToWait -wait 2
			Cumulative_updates_menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next -DevCode "CU 5"
			ToWait -wait 2
			Cumulative_updates_menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Cumulative_updates_menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Shortcuts_Developers_Mode
			ToWait -wait 2
			Cumulative_updates_menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Cumulative_updates_menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Cumulative_updates_menu"
		}

		<#
			.快捷指令：查看并接受许可条款
		#>
		“vTC" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Eject_Abandon_Agreement
			ToWait -wait 2
			Cumulative_updates_menu
		}

		default {
			Mainpage
		}
	}
}

Function Shortcuts_Cumulative_updates_Add
{
	Write-Host "`n  $($lang.CUpdate): $($lang.AddTo)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Cumulative_updates_Add_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Shortcuts_Cumulative_updates_Delete
{
	Write-Host "`n  $($lang.CUpdate): $($lang.Del)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Cumulative_updates_Delete_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}