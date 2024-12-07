<#
	.Drive management
	.驱动管理
#>
Function Drive_Menu
{
	Logo -Title $lang.Drive
	Write-Host "   $($lang.Dashboard)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	Write-Host "   $($lang.MountImageTo): " -NoNewline
	if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
		Write-Host $Global:Mount_To_Route -ForegroundColor Green
	} else {
		Write-Host $Global:Mount_To_Route -ForegroundColor Yellow
	}

	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
		Write-Host " Open RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Green
		Write-Host $Global:Mount_To_Route -ForegroundColor Green
	} else {
		Write-Host " Open RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Red
		Write-Host $Global:Mount_To_Route -ForegroundColor Red
	}

	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Image_source -PathType Container) {
		Write-Host " Open MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Green
		Write-Host $Global:Image_source -ForegroundColor Green
	} else {
		Write-Host " Open MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Red
		Write-Host $Global:Image_source -ForegroundColor Red

		Write-Host "   $('-' * 80)"
		Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red

		ToWait -wait 6
		Drive_Menu
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n   $($lang.Drive)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "      1   " -NoNewline -ForegroundColor Yellow
			Write-Host $lang.AddTo -ForegroundColor Green
		} else {
			Write-Host "      1   " -NoNewline -ForegroundColor Yellow
			Write-Host $lang.AddTo -ForegroundColor Red
		}
	} else {
		Write-Host "      1   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.AddTo -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "      2   " -NoNewline -ForegroundColor Yellow
			Write-Host $lang.Del -ForegroundColor Green
		} else {
			Write-Host "      2   " -NoNewline -ForegroundColor Yellow
			Write-Host $lang.Del -ForegroundColor Red
		}
	} else {
		Write-Host "      2   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Del -ForegroundColor Red
	}

	Write-Host "`n   $($lang.ViewDrive)" -ForegroundColor Yellow
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

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"1" {
			Drive_Menu_Shortcuts_Add
			ToWait -wait 2
			Drive_Menu
		}
		"2" {
			Drive_Menu_Shortcuts_Delete
			ToWait -wait 2
			Drive_Menu
		}
		"p" {
			Write-Host "`n   $($lang.ViewDrive)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.ExportToLogs)" -ForegroundColor Yellow

			if (Image_Is_Select_IAB) {
				$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
					$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
				} else {
					$Temp_Export_SaveTo = $Temp_Expand_Rule
				}

				Image_Get_Installed_Drive -Save $Temp_Export_SaveTo
				Get_Next
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Drive_Menu
		}
		"s" {
			Write-Host "`n   $($lang.ViewDrive)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"

			Write-Host "   $($lang.ExportToLogs)" -ForegroundColor Yellow
			if (Image_Is_Select_IAB) {
				$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
					$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
				} else {
					$Temp_Export_SaveTo = $Temp_Expand_Rule
				}

				Image_Get_Installed_Drive -Save $Temp_Export_SaveTo -View
				Get_Next
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Drive_Menu
		}
		"ss" {
			Write-Host "`n   $($lang.Setting): $($lang.SaveTo)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			if (Image_Is_Select_IAB) {
				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green

					Setting_Export_To_UI
				} else {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
			}

			ToWait -wait 2
			Drive_Menu
		}

		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Drive_Menu
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Drive_Menu
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Drive_Menu
		}

		<#
			.帮助
		#>
		"h" {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Drive_Menu
		}
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '')
			ToWait -wait 2
			Drive_Menu
		}

		default { Mainpage }
	}
}

Function Drive_Menu_Shortcuts_Add
{
	Write-Host "`n   $($lang.Drive): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Event_Assign -Rule "Drive_Add_UI" -Run
		} else {
			Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Drive_Menu_Shortcuts_Delete
{
	Write-Host "`n   $($lang.Drive): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Event_Assign -Rule "Drive_Delete_UI" -Run
		} else {
			Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}