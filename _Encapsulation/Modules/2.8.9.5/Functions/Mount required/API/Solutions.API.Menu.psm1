<#
	.Menu: API
	.菜单：API
#>
Function API_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.API
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
			API_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n  $($lang.API)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "    " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Functions_Before)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Functions_Before)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Functions_Before)" -ForegroundColor Red
	}

	Write-host "    " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Functions_Rear)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Functions_Rear)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Functions_Rear)" -ForegroundColor Red
	}

	Write-Host
	Write-host "  " -NoNewline
	Write-Host " API * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Function_Unrestricted) " -ForegroundColor Green

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
		"1" {
			API_Menu_Shortcuts_PFB
			ToWait -wait 2
			API_Menu
		}
		"2" {
			API_Menu_Shortcuts_PFA
			ToWait -wait 2
			API_Menu
		}
		"API" {
			API_Unrestricted_UI
			ToWait -wait 2
			API_Menu
		}
		"API *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_API_Command -Name $PSItem.Remove(0, 4)

			Write-Host "  $('-' * 80)"
			Write-Host "  API: $($lang.API), $($lang.Done)" -ForegroundColor Green
			ToWait -wait 2
			API_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			API_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			API_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount
			ToWait -wait 2
			API_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount_Key_and_Index -Command $PSItem
			ToWait -wait 2
			API_Menu
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
			API_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Unmt -Name $PSItem
			ToWait -wait 2
			API_Menu
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
			API_Menu
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
			API_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			API_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Select -Name $PSItem
			ToWait -wait 2
			API_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next -DevCode "API 1"
			ToWait -wait 2
			API_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			API_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Shortcuts_Developers_Mode
			ToWait -wait 2
			API_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "API_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "API_Menu"
		}

		<#
			.快捷指令：查看并接受许可条款
		#>
		“vTC" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Eject_Abandon_Agreement
			ToWait -wait 2
			API_Menu
		}

		default {
			Mainpage
		}
	}
}

Function API_Menu_Shortcuts_PFB
{
	Write-Host "`n  $($lang.API): $($lang.Functions_Before)" -ForegroundColor Yellow
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
			Event_Assign -Rule "API_Before_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function API_Menu_Shortcuts_PFA
{
	Write-Host "`n  $($lang.API): $($lang.Functions_Rear)" -ForegroundColor Yellow
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
			Event_Assign -Rule "API_Rear_UI" -Run
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}