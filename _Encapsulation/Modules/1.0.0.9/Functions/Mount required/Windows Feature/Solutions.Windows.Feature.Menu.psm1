<#
	.Open the functional user interface
	.开启功能用户界面
#>
Function Feature_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.WindowsFeature
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

			ToWait -wait 6
			Functions_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n   $($lang.WindowsFeature)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	if (Verify_Is_Current_Same) {
		Write-Host "      1   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Enable -ForegroundColor Green
	} else {
		Write-Host "      1   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Enable -ForegroundColor Red
	}

	if (Verify_Is_Current_Same) {
		Write-Host "      2   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Disable -ForegroundColor Green
	} else {
		Write-Host "      2   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Disable -ForegroundColor Red
	}

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"1" {
			Feature_Menu_Shortcuts_Enabled
			ToWait -wait 2
			Feature_Menu
		}
		"2" {
			Feature_Menu_Shortcuts_Disabled
			ToWait -wait 2
			Feature_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "Open" -Pause
			Feature_Menu
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
			Feature_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mount" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n   $($lang.Mount)"
			Write-Host "   $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Red
				} else {
					Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
					Image_Select_Index_UI
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red

				Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   $($lang.OnDemandPlanTask)" -ForegroundColor Green

				ToWait -wait 2
				Image_Assign_Event_Master
			}

			ToWait -wait 2
			Feature_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"Mount *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n   $($lang.Command): " -NoNewline
			Write-host "Mount" -ForegroundColor Green

			$NewRuleName = $PSItem.Remove(0, 6).Replace(' ', '')
			Write-Host "   $($lang.MountedIndexSelect): " -NoNewline
			Write-Host $NewRuleName -ForegroundColor Green
			Write-Host "   $('-' * 80)"

			if ($NewRuleName -match '^\d+$') {
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"

					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
						Image_Select_Index_UI -AutoSelectIndex $NewRuleName
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red

					Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   $($lang.OnDemandPlanTask)" -ForegroundColor Green

					ToWait -wait 2
					Image_Assign_Event_Master
				}
			} else {
				Write-Host "   $($lang.VerifyNumberFailed)" -ForegroundColor Red
			}

			ToWait -wait 2
			Feature_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Save" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Feature_Menu
		}
		"Save *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Feature_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"unmount" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Feature_Menu
		}
		"unmount *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 7).Replace(' ', '')
			ToWait -wait 2
			Feature_Menu
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Feature_Menu
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Feature_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Feature_Menu
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
			Feature_Menu
		}

		default {
			Mainpage
		}
	}
}

Function Feature_Menu_Shortcuts_Enabled
{
	Write-Host "`n   $($lang.WindowsFeature): $($lang.Enable)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Feature_Enabled_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Feature_Menu_Shortcuts_Disabled
{
	Write-Host "`n   $($lang.WindowsFeature): $($lang.Disable)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Feature_Disable_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}