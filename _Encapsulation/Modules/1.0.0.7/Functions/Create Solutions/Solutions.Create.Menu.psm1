<#
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
	Write-Host " H * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
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

		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		"VW *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 3).Replace(' ', '')
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
		"h" {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Solutions_Menu
		}
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '')
			ToWait -wait 2
			Solutions_Menu
		}

		default {
			Mainpage
		}
	}
}