Function InBox_Apps_Menu
{
	Logo -Title $lang.InboxAppsManager
	Write-Host "   $($lang.Dashboard)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
		Write-Host " O'D RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Mount_To_Route -ForegroundColor Green
	} else {
		Write-Host " O'D RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Mount_To_Route -ForegroundColor Red
	}

	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Image_source -PathType Container) {
		Write-Host " O'D MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Image_source -ForegroundColor Green
	} else {
		Write-Host " O'D MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Image_source -ForegroundColor Red

		Write-Host "   $('-' * 80)"
		Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n   $($lang.Menu)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Verify_Is_Current_Same) {
		Write-Host "      1   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.AddTo)" -ForegroundColor Green
	} else {
		Write-Host "      1   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.AddTo)" -ForegroundColor Red
	}

	if (Verify_Is_Current_Same) {
		Write-Host "      2   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Green
	} else {
		Write-Host "      2   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Red
	}

	if (Verify_Is_Current_Same) {
		Write-Host "      3   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.Update)" -ForegroundColor Green
	} else {
		Write-Host "      3   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.Update)" -ForegroundColor Red
	}

	if (Verify_Is_Current_Same) {
		Write-Host "      4   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.Del)" -ForegroundColor Green
	} else {
		Write-Host "      4   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.LocalExperiencePack): $($lang.Del)" -ForegroundColor Red
	}

	Write-Host "`n      $($lang.InboxAppsManager)" -ForegroundColor Yellow
	Write-Host "      $('-' * 77)"
	if (Verify_Is_Current_Same) {
		Write-Host "         A   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel)" -ForegroundColor Green
	} else {
		Write-Host "         A   " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel)" -ForegroundColor Red
	}

	Write-Host "`n      $($lang.InboxAppsClear)" -ForegroundColor Yellow
	Write-Host "      $('-' * 77)"
	if (Verify_Is_Current_Same) {
		Write-Host "         F   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.AllClear -ForegroundColor Green
	} else {
		Write-Host "         F   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.AllClear -ForegroundColor Red
	}

	if (Verify_Is_Current_Same) {
		Write-Host "         E   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.ExcludeItem -ForegroundColor Green
	} else {
		Write-Host "         E   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.ExcludeItem -ForegroundColor Red
	}

	Write-Host "`n`n   $($lang.GetInBoxApps)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "      P   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.ExportToLogs -ForegroundColor Green
		} else {
			Write-Host $lang.ExportToLogs -ForegroundColor Red
		}
	} else {
		Write-Host $lang.ExportToLogs -ForegroundColor Red
	}

	Write-Host "      S   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.ExportShow -ForegroundColor Green
		} else {
			Write-Host $lang.ExportShow -ForegroundColor Red
		}
	} else {
		Write-Host $lang.ExportShow -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

			Write-Host "`n          $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "          $('-' * 73)"
			Write-Host "     SS   " -NoNewline -ForegroundColor Yellow
			Write-Host $Temp_Expand_Rule -ForegroundColor Green
		}
	}

	if (Verify_Is_Current_Same) {
		Write-Host "`n      C   $($lang.OnDemandPlanTask)" -ForegroundColor Green
	} else {
		Write-Host "`n      C   $($lang.OnDemandPlanTask)" -ForegroundColor Red
	}

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"1" {
			InBox_Apps_Menu_Shortcuts_LXPs_Add
			ToWait -wait 2
			InBox_Apps_Menu
		}
		"2" {
			InBox_Apps_Menu_Shortcuts_Add
			ToWait -wait 2
			InBox_Apps_Menu
		}
		"3" {
			InBox_Apps_Menu_Shortcuts_LXPs_Update
			ToWait -wait 2
			InBox_Apps_Menu
		}
		"4" {
			InBox_Apps_Menu_Shortcuts_LXPs_Delete
			ToWait -wait 2
			InBox_Apps_Menu
		}
		"c" {
			Write-Host "`n   $($lang.User_Interaction): $($lang.OnDemandPlanTask)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					<#
							.Assign available tasks
							.分配可用的任务
					#>
					Event_Assign -Rule "LXPs_Region_Add" -Run
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}
		"A" {
			InBox_Apps_Menu_Shortcuts_Delete
			ToWait -wait 2
			InBox_Apps_Menu
		}
		"f" {
			Write-Host "`n   $($lang.InboxAppsClear)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					InBox_Apps_LIPs_Clean_Process
					Get_Next
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}
		"e" {
			Write-Host "`n   $($lang.InboxAppsClear)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force

			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					InBox_Apps_LIPs_Clean_Process
					Get_Next
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}
		"p" {
			Write-Host "`n   $($lang.GetInBoxApps)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.ExportToLogs)" -ForegroundColor Yellow
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Apps_Package -Save $Temp_Export_SaveTo
					Get_Next
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}
		"s" {
			Write-Host "`n   $($lang.GetInBoxApps)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.ExportShow)"
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
					if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
						$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
					} else {
						$Temp_Export_SaveTo = $Temp_Expand_Rule
					}

					Image_Get_Apps_Package -Save $Temp_Export_SaveTo -View
					Get_Next
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}
		"ss" {
			Write-Host "`n   $($lang.Setting): $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					Setting_Export_To_UI
				} else {
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "Open" -Pause
			InBox_Apps_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n   $($lang.Short_Cmd)`n" -ForegroundColor Yellow

			if ($_ -like "O'D *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "O'D" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 4).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Open_Command -Name $NewRuleName
			}

			if ($_ -like "OD *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "OD" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 3).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Open_Command -Name $NewRuleName
			}

			if ($_ -like "O *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "O" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 2).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Open_Command -Name $NewRuleName
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			InBox_Apps_Menu
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			InBox_Apps_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			InBox_Apps_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n   $($lang.Short_Cmd)`n" -ForegroundColor Yellow

			if ($_ -like "H'elp *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "H'elp" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 6).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Help_Command -Name $NewRuleName
			}

			if ($_ -like "Help *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "Help" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 5).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Help_Command -Name $NewRuleName
			}

			if ($_ -like "H *") {
				Write-Host "   $($lang.Command): " -NoNewline
				Write-host "H" -ForegroundColor Green

				$NewRuleName = $PSItem.Remove(0, 2).Replace(' ', '')
				Write-Host "   $($lang.RuleName): " -NoNewline
				Write-host $NewRuleName -ForegroundColor Green
				Solutions_Help_Command -Name $NewRuleName
			}

			ToWait -wait 2
			InBox_Apps_Menu
		}

		default {
			Mainpage
		}
	}
}

Function InBox_Apps_Menu_Shortcuts_Add
{
	Write-Host "`n   $($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "InBox_Apps_Add_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function InBox_Apps_Menu_Shortcuts_Delete
{
	Write-Host "`n   $($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "InBox_Apps_Offline_Delete_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function InBox_Apps_Menu_Shortcuts_LXPs_Add
{
	Write-Host "`n   $($lang.LocalExperiencePack): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "LXPs_Region_Add" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function InBox_Apps_Menu_Shortcuts_LXPs_Update
{
	Write-Host "`n   $($lang.LocalExperiencePack): $($lang.Update)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "LXPs_Update_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function InBox_Apps_Menu_Shortcuts_LXPs_Delete
{
	Write-Host "`n   $($lang.LocalExperiencePack): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green

			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "LXPs_Remove_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}