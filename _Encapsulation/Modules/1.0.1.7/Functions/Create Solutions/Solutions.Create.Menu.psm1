﻿<#
	.Menu: Language
	.菜单：语言
#>
Function Solutions_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.Solution
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
			Solutions_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n  $($lang.Solution)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "    " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.IsCreate)" -ForegroundColor Green

	Write-Host "`n  $($Global:Image_source)" -ForegroundColor Yellow

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container) {
		Write-host "    " -NoNewline
		Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Sources\`$OEM$" -ForegroundColor Yellow
	} else {
		Write-host "    " -NoNewline
		Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Sources\`$OEM$" -ForegroundColor Yellow
	}

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType leaf) {
		Write-host "    " -NoNewline
		Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Sources\Unattend.xml" -ForegroundColor Yellow
	} else {
		Write-host "    " -NoNewline
		Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Sources\Unattend.xml" -ForegroundColor Yellow
	}

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType leaf) {
		Write-host "    " -NoNewline
		Write-Host " 3 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Autounattend.xml" -ForegroundColor Yellow
	} else {
		Write-host "    " -NoNewline
		Write-Host " 3 " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Autounattend.xml" -ForegroundColor Yellow
	}

	Write-Host
	if ((Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container))
	{
		Write-host "    " -NoNewline
		Write-Host " A " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.EnglineDoneClearFull)" -ForegroundColor Green
	} else {
		Write-host "    " -NoNewline
		Write-Host " A " -NoNewline -BackgroundColor Green -ForegroundColor Black
		Write-Host "  $($lang.EnglineDoneClearFull)" -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		$TestNewFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"
		Write-Host "`n  $($TestNewFolder)" -ForegroundColor Yellow

		$File_Path_MainFolder = "$($TestNewFolder)\$((Get-Module -Name Solutions).Author)"
		if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
			Write-host "   " -NoNewline
			Write-Host " 11 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host $((Get-Module -Name Solutions).Author) -ForegroundColor Yellow
		} else {
			Write-host "   " -NoNewline
			Write-Host " 11 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\$((Get-Module -Name Solutions).Author)" -ForegroundColor Yellow
		}

		$File_Path_Unattend = "$($TestNewFolder)\Windows\Panther\Unattend.xml"
		if (Test-Path -Path $File_Path_Unattend -PathType leaf) {
			Write-host "   " -NoNewline
			Write-Host " 12 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host "\Windows\Panther\Unattend.xml" -ForegroundColor Yellow
		} else {
			Write-host "   " -NoNewline
			Write-Host " 12 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\Windows\Panther\Unattend.xml" -ForegroundColor Yellow
		}

		$File_Path_Office = "$($TestNewFolder)\Users\Public\Desktop\Office"
		if (Test-Path -Path $File_Path_Office -PathType Container) {
			Write-host "   " -NoNewline
			Write-Host " 13 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host "\Users\Public\Desktop\Office" -ForegroundColor Yellow
		} else {
			Write-host "   " -NoNewline
			Write-Host " 13 " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\Users\Public\Desktop\Office" -ForegroundColor Yellow
		}

		Write-Host
		if ((Test-Path -Path $File_Path_MainFolder -PathType Container) -or
			(Test-Path -Path $File_Path_Unattend -PathType Leaf) -or
			(Test-Path -Path $File_Path_Office -PathType Container))
		{
			Write-host "   " -NoNewline
			Write-Host " AA " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.EnglineDoneClearFull)" -ForegroundColor Green
		} else {
			Write-host "   " -NoNewline
			Write-Host " AA " -NoNewline -BackgroundColor Green -ForegroundColor Black
			Write-Host "  $($lang.EnglineDoneClearFull)" -ForegroundColor Red
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
		"c" {
			Solutions
			ToWait -wait 2
			Solutions_Menu
		}
		"1" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$"

			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType Container) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			ToWait -wait 2
			Solutions_Menu
		}
		"2" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml"

			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			ToWait -wait 2
			Solutions_Menu
		}
		"3" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml"

			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			ToWait -wait 2
			Solutions_Menu
		}
		"a" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$"

			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType Container) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml"
			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml"
			Write-Host "`n  $($File_Path)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			write-host

			ToWait -wait 2
			Solutions_Menu
		}
		"11" {
			$File_Path_MainFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)"

			Write-Host "`n  $($File_Path_MainFolder)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
				Remove_Tree $File_Path_MainFolder
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"12" {
			$File_Path_Unattend = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\Panther\Unattend.xml"

			Write-Host "`n  $($File_Path_Unattend)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_Unattend -PathType Leaf) {
				Remove_Tree $File_Path_Unattend
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"13" {
			$File_Path_Office = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Users\Public\Desktop\Office"

			Write-Host "`n  $($File_Path_Office)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_Office -PathType Container) {
				Remove_Tree $File_Path_Office
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"aa" {
			$File_Path_MainFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)"

			Write-Host "`n  $($File_Path_MainFolder)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
				Remove_Tree $File_Path_MainFolder
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			$File_Path_Unattend = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\Panther\Unattend.xml"

			Write-Host "`n  $($File_Path_Unattend)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_Unattend -PathType Leaf) {
				Remove_Tree $File_Path_Unattend
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			$File_Path_Office = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Users\Public\Desktop\Office"

			Write-Host "`n  $($File_Path_Office)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $File_Path_Office -PathType Container) {
				Remove_Tree $File_Path_Office
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}

			ToWait -wait 2
			Solutions_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Solutions_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount_Index -Command $PSItem
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Se" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Solutions_Menu
		}
		"Se *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Solutions_Menu
		}
		"Unmt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Solutions_Menu
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
			Solutions_Menu
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
			Solutions_Menu
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Solutions_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Menu_Shortcuts_Developers_Mode
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Solutions_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Solutions_Menu"
		}

		default {
			Mainpage
		}
	}
}