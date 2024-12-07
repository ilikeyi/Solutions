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
	Write-Host " H * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
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

		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
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
		"hf" {
			Solutions_Help -Full
			Get_Next
			ToWait -wait 2
			Feature_Menu
		}
		"h" {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Feature_Menu
		}
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '') -Pause
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