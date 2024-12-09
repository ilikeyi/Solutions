﻿<#
	.Menu: Language
	.菜单：语言
#>
Function Solutions_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.Solution
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
			Solutions_Menu
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n   $($lang.Solution)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	Write-Host "      C   $($lang.IsCreate)" -ForegroundColor Green

	Write-Host "`n   $($Global:Image_source)" -ForegroundColor Yellow

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container) {
		Write-Host "      1   $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Sources\`$OEM$" -ForegroundColor Yellow
	} else {
		Write-Host "      1   $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Sources\`$OEM$" -ForegroundColor Yellow
	}

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType leaf) {
		Write-Host "      2   $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Sources\Unattend.xml" -ForegroundColor Yellow
	} else {
		Write-Host "      2   $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Sources\Unattend.xml" -ForegroundColor Yellow
	}

	if (Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType leaf) {
		Write-Host "      3   $($lang.Del): " -NoNewline -ForegroundColor Green
		Write-Host "\Autounattend.xml" -ForegroundColor Yellow
	} else {
		Write-Host "      3   $($lang.Del): " -NoNewline -ForegroundColor Red
		Write-Host "\Autounattend.xml" -ForegroundColor Yellow
	}

	Write-Host
	if ((Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container))
	{
		Write-Host "      A   $($lang.EnglineDoneClearFull)" -ForegroundColor Green
	} else {
		Write-Host "      A   $($lang.EnglineDoneClearFull)" -ForegroundColor Red
	}

	if (Image_Is_Select_IAB) {
		$TestNewFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"
		Write-Host "`n   $($TestNewFolder)" -ForegroundColor Yellow

		$File_Path_MainFolder = "$($TestNewFolder)\$((Get-Module -Name Solutions).Author)"
		if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
			Write-Host "     11   $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host $((Get-Module -Name Solutions).Author) -ForegroundColor Yellow
		} else {
			Write-Host "     11   $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\$((Get-Module -Name Solutions).Author)" -ForegroundColor Yellow
		}

		$File_Path_Unattend = "$($TestNewFolder)\Windows\Panther\Unattend.xml"
		if (Test-Path -Path $File_Path_Unattend -PathType leaf) {
			Write-Host "     12   $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host "\Windows\Panther\Unattend.xml" -ForegroundColor Yellow
		} else {
			Write-Host "     12   $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\Windows\Panther\Unattend.xml" -ForegroundColor Yellow
		}

		$File_Path_Office = "$($TestNewFolder)\Users\Public\Desktop\Office"
		if (Test-Path -Path $File_Path_Office -PathType Container) {
			Write-Host "     13   $($lang.Del): " -NoNewline -ForegroundColor Green
			Write-Host "\Users\Public\Desktop\Office" -ForegroundColor Yellow
		} else {
			Write-Host "     13   $($lang.Del): " -NoNewline -ForegroundColor Red
			Write-Host "\Users\Public\Desktop\Office" -ForegroundColor Yellow
		}

		Write-Host
		if ((Test-Path -Path $File_Path_MainFolder -PathType Container) -or
			(Test-Path -Path $File_Path_Unattend -PathType Leaf) -or
			(Test-Path -Path $File_Path_Office -PathType Container))
		{
			Write-Host "     AA   $($lang.EnglineDoneClearFull)" -ForegroundColor Green
		} else {
			Write-Host "     AA   $($lang.EnglineDoneClearFull)" -ForegroundColor Red
		}
	}

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"c" {
			Solutions
			ToWait -wait 2
			Solutions_Menu
		}
		"1" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType Container) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"2" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"3" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"a" {
			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType Container) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			$File_Path = Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml"

			Write-Host "`n   $($File_Path)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path -PathType leaf) {
				Remove_Tree $File_Path
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"11" {
			$File_Path_MainFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)"

			Write-Host "`n   $($File_Path_MainFolder)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
				Remove_Tree $File_Path_MainFolder
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"12" {
			$File_Path_Unattend = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\Panther\Unattend.xml"

			Write-Host "`n   $($File_Path_Unattend)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_Unattend -PathType Leaf) {
				Remove_Tree $File_Path_Unattend
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"13" {
			$File_Path_Office = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Users\Public\Desktop\Office"

			Write-Host "`n   $($File_Path_Office)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_Office -PathType Container) {
				Remove_Tree $File_Path_Office
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}
		"aa" {
			$File_Path_MainFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)"

			Write-Host "`n   $($File_Path_MainFolder)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_MainFolder -PathType Container) {
				Remove_Tree $File_Path_MainFolder
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			$File_Path_Unattend = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\Panther\Unattend.xml"

			Write-Host "`n   $($File_Path_Unattend)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_Unattend -PathType Leaf) {
				Remove_Tree $File_Path_Unattend
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			$File_Path_Office = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Users\Public\Desktop\Office"

			Write-Host "`n   $($File_Path_Office)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Del)".PadRight(28) -NoNewline
			if (Test-Path -Path $File_Path_Office -PathType Container) {
				Remove_Tree $File_Path_Office
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host $lang.Failed -ForegroundColor Red
			}

			ToWait -wait 2
			Solutions_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "Open" -Pause
			Solutions_Menu
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
			Solutions_Menu
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
			Solutions_Menu
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
			Solutions_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Save" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Solutions_Menu
		}
		"Save *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"unmount" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Solutions_Menu
		}
		"unmount *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 7).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

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
			Solutions_Menu
		}

		default {
			Mainpage
		}
	}
}