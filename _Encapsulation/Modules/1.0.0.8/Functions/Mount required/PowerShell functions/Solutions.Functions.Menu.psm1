﻿<#
	.Menu: Running PowerShell Functions
	.菜单：运行 PowerShell 函数
#>
Function Functions_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.SpecialFunction
		Write-Host "   $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		Write-host "   " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host " Open RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host " Open RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Red
		}

		Write-host "   " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host " Open MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host " Open MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Image_source -ForegroundColor Red

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 6
			Functions_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n   $($lang.SpecialFunction)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "      1   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Before -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Before -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Before -ForegroundColor Red
	}

	Write-Host "      2   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Rear -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Rear -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Rear -ForegroundColor Red
	}


	Write-Host "`n      F   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Function_Unrestricted -ForegroundColor Green

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
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
		"F" {
			Functions_Unrestricted_UI
			ToWait -wait 2
			Functions_Menu
		}

		"open" {
			Solutions_Help_Command -Name "Open" -Pause
			Functions_Menu
		}
		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Functions_Menu
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

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
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '') -Pause
			ToWait -wait 2
			Functions_Menu
		}
		"help *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 5).Replace(' ', '') -Pause
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
	Write-Host "`n   $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Functions_Before_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Functions_Menu_Shortcuts_PFA
{
	Write-Host "`n   $($lang.SpecialFunction): $($lang.Functions_Rear)" -ForegroundColor Yellow
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
			Event_Assign -Rule "Functions_Rear_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}