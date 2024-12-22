<#
	.Menu: Running PowerShell Functions
	.菜单：运行 PowerShell 函数
#>
Function Functions_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.SpecialFunction
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
			Functions_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n  $($lang.SpecialFunction)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "     1   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Before -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Before -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Before -ForegroundColor Red
	}

	Write-Host "     2   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Rear -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Rear -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Rear -ForegroundColor Red
	}

	Write-Host
	Write-host "  " -NoNewline
	Write-Host " FX * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Function_Unrestricted) " -ForegroundColor Green

	Write-Host
	Write-host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " " -NoNewline

	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline

	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host ": " -NoNewline

	switch -Wildcard (Read-Host)
	{
		"1" {
			Functions_Menu_Shortcuts_PFB
			ToWait -wait 2
			Functions_Menu
		}
		"2" {
			Functions_Menu_Shortcuts_PFA
			ToWait -wait 2
			Functions_Menu
		}
		"FX" {
			Functions_Unrestricted_UI
			ToWait -wait 2
			Functions_Menu
		}
		"FX *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_PowerShell_functions_Unrestricted -Command $PSItem
			ToWait -wait 2
			Functions_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Functions_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount_Index -Command $PSItem
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Save" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Functions_Menu
		}
		"Save *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"unmount" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Functions_Menu
		}
		"unmount *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 7).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：保存
		#>
		"ESA" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.Save -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Eject_Forcibly_All -Save -DontSave

			ToWait -wait 2
			Functions_Menu
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
			Functions_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Functions_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Functions_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Write-Host "`n  $($lang.Developers_Mode)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Setting): " -NoNewline
			if ($Global:Developers_Mode) {
				$Global:Developers_Mode = $False
				Write-Host " $($lang.Disable) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				$Global:Developers_Mode = $True
				Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White
			}

			ToWait -wait 2
			Functions_Menu
		}

		default {
			Mainpage
		}
	}
}

Function Functions_Menu_Shortcuts_PFB
{
	Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Functions_Before_UI" -Run
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Functions_Menu_Shortcuts_PFA
{
	Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Rear)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Functions_Rear_UI" -Run
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}