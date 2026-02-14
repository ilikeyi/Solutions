<#
	.Image version
	.映像版本
#>
Function Image_Version_Menu
{
	Logo -Title $lang.Editions
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
		Image_Version_Menu
	}

	Image_Get_Mount_Status -IsHotkey

	Write-Host "`n  $($lang.Editions)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-host "    " -NoNewline
			Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Change)" -ForegroundColor Green
		} else {
			Write-host "    " -NoNewline
			Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Change)" -ForegroundColor Red
		}
	} else {
		Write-host "    " -NoNewline
		Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Change)" -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-host "    " -NoNewline
			Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.OOBEProductKey)" -ForegroundColor Green
		} else {
			Write-host "    " -NoNewline
			Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.OOBEProductKey)" -ForegroundColor Red
		}
	} else {
		Write-host "    " -NoNewline
		Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.OOBEProductKey)" -ForegroundColor Red
	}

	$EICfgPath = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
	Write-Host "`n  $($lang.InstlMode)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "  $($lang.Select_Path): " -NoNewline
	Write-host $EICfgPath -ForegroundColor Yellow

	Write-Host "`n  $($lang.Change)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Test-Path -Path $EICfgPath -PathType leaf) {
		Write-Host "    [*]  " -NoNewline -ForegroundColor Green
		Write-Host " $($lang.Business) " -BackgroundColor DarkGreen -ForegroundColor White
		Write-Host "         $($lang.BusinessTips)" -ForegroundColor Green

		write-host

		Write-host "   " -NoNewline
		Write-Host " EI " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host " " -NoNewline -ForegroundColor Green
		Write-Host " $($lang.Consumer) "
		Write-Host "         $($lang.ConsumerTips)" -ForegroundColor Yellow
	} else {
		Write-host "   " -NoNewline
		Write-Host " EI " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host " " -NoNewline -ForegroundColor Green
		Write-Host " $($lang.Business) "
		Write-Host "         $($lang.BusinessTips)" -ForegroundColor Yellow

		write-host

		Write-Host "    [*]  " -NoNewline -ForegroundColor Green
		Write-Host " $($lang.Consumer) " -BackgroundColor DarkGreen -ForegroundColor White
		Write-Host "         $($lang.ConsumerTips)" -ForegroundColor Green
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
		"1" {
			Editions_GUI
			ToWait -wait 2
			Image_Version_Menu
		}
		"2" {
			Editions_GUI
			ToWait -wait 2
			Image_Version_Menu
		}
		"ei" {
			Write-Host "`n  $($lang.Change)"
			Write-Host "  $('-' * 80)"
			Shortcuts_EI_Switch
			ToWait -wait 2
			Image_Version_Menu
		}
 
		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Image_Version_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Image_Version_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount
			ToWait -wait 2
			Image_Version_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Mount_Key_and_Index -Command $PSItem
			ToWait -wait 2
			Image_Version_Menu
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
			Image_Version_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt*" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Unmt -Name $PSItem
			ToWait -wait 2
			Image_Version_Menu
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
			Image_Version_Menu
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
			Image_Version_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Image_Version_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Select -Name $PSItem
			ToWait -wait 2
			Image_Version_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next -DevCode "IV 1"
			ToWait -wait 2
			Image_Version_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Image_Version_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Shortcuts_Developers_Mode
			ToWait -wait 2
			Image_Version_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Image_Version_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Image_Version_Menu"
		}

		<#
			.快捷指令：查看并接受许可条款
		#>
		“vTC" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name "Eula"
			ToWait -wait 2
			Image_Version_Menu
		}

		default { Mainpage }
	}
}