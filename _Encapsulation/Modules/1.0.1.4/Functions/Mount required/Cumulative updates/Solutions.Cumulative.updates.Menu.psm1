<#
	.Update management
	.更新管理
#>
Function Update_Menu
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
		Update_Menu
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n  $($lang.CUpdate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
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
			$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

			Write-Host "`n   $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "   $('-' * 79)"
			Write-host "   " -NoNewline
			Write-Host " SS " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($Temp_Expand_Rule)" -ForegroundColor Green
		}
	}

	Write-Host
	Write-host "  $($lang.Shortcut): "
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.SelectSettingImage): " -ForegroundColor Yellow -NoNewline
	Write-Host " MT * "-BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  $($lang.Mounted_Status): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Se * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmt * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.Image_Unmount_After): " -NoNewline
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " EDNS " -BackgroundColor DarkMagenta -ForegroundColor White
			} else {
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Red
				Write-Host " Se * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Red
				Write-Host " Unmt * " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		if (Image_Is_Mount) {
			Write-Host "$($lang.Image_Unmount_After): " -NoNewline
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Red
			Write-Host " Se * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Red
			Write-Host " Unmt * " -BackgroundColor DarkRed -ForegroundColor White
		}
	}

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.RefreshModules) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " R'R " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host ": " -NoNewline

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
		"1" {
			Update_Menu_Shortcuts_Add
			ToWait -wait 2
			Update_Menu
		}
		"2" {
			Update_Menu_Shortcuts_Delete
			ToWait -wait 2
			Update_Menu
		}
		"3" {
			Write-Host "`n  $($lang.CuringUpdate)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					Event_Process_Task_Need_Mount
					New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

					Get_Next
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}
		"31" {
			Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					Image_Clear_Superseded
					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

					Get_Next
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}
		"32" {
			Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					Image_Clear_Superseded
					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
					New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

					Get_Next
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}
		"p" {
			Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Components_Package -Save $Temp_Export_SaveTo
					Get_Next
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}
		"s" {
			Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Components_Package -Save $Temp_Export_SaveTo -View
					Get_Next
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}
		"ss" {
			Write-Host "`n  $($lang.Setting): $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green

					Setting_Export_To_UI
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Update_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Update_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount
			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount_Index -Command $PSItem
			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Se" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Update_Menu
		}
		"Se *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Update_Menu
		}
		"Unmt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：保存
		#>
		"ESE" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.Save -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Eject_Forcibly_All -Save -DontSave

			ToWait -wait 2
			Update_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：不保存
		#>
		"EDNS" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.DoNotSave -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Eject_Forcibly_All -DontSave

			ToWait -wait 2
			Update_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Update_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Update_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Update_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Update_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Menu_Shortcuts_Developers_Mode
			ToWait -wait 2
			Update_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Update_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Update_Menu"
		}

		default {
			Mainpage
		}
	}
}

Function Update_Menu_Shortcuts_Add
{
	Write-Host "`n  $($lang.CUpdate): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Cumulative_updates_Add_UI" -Run
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}


Function Update_Menu_Shortcuts_Delete
{
	Write-Host "`n  $($lang.CUpdate): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Cumulative_updates_Delete_UI" -Run
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}