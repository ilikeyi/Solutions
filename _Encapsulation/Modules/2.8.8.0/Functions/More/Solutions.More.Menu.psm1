<#
	.Mul menu
	.多菜单
#>
Function Solutions_Menu_Shortcut
{
	$IsShowQ = $False
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
						"True" {
							$IsShowQ = $True
						}
					}
				}
			}
		}
	}

	Write-Host
	Write-host "  $($lang.Shortcut)"
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.SelectSettingImage): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mount) " -NoNewline -ForegroundColor Green
	Write-Host " MT * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Remount) " -NoNewline -ForegroundColor Green
			Write-Host " rMT * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.Remount) " -NoNewline -ForegroundColor Green
				Write-Host " rMT * " -BackgroundColor DarkMagenta -ForegroundColor White
			} else {
				Write-Host "$($lang.NotMounted) " -ForegroundColor Red
			}
		}
	} else {
		if (Image_Is_Mount) {
			Write-Host "$($lang.Remount) " -NoNewline -ForegroundColor Green
			Write-Host " rMT * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.NotMounted) " -ForegroundColor Red
		}
	}

	Write-Host "  $($lang.Mounted_Status): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Save * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host " -U " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", "

			Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
			} else { write-host }
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " Save * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

				Write-Host " -U " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
				if ($IsShowQ) {
					Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				}
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				if ($IsShowQ) {
					Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				}
				Write-Host ", "

				Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				if ($IsShowQ) {
					Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				}
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				if ($IsShowQ) {
					Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
				} else { write-host }
			} else {
				Write-Host "$($lang.NotMounted) " -ForegroundColor Red
			}
		}
	} else {
		if (Image_Is_Mount) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Save * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host " -U " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", "

			Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			}
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			if ($IsShowQ) {
				Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
			} else { write-host }
		} else {
			Write-Host "$($lang.NotMounted) " -ForegroundColor Red
		}
	}

	if ($IsShowQ) {
		write-host "  " -NoNewline
		Write-Host “ vTC " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.View) " -NoNewline -BackgroundColor DarkYellow -ForegroundColor White
		Write-Host " $($lang.Abandon_Terms) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
				"True" {
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
				}
				"False" {
					Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
				}
			}
		}
	}
}

Function Solutions_Input_Menu
{
	param (
		[switch]$PS
	)

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.RefreshModules) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " R'R " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor Green -ForegroundColor Black

	if ($ps) {
		Write-Host " PS * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host ": " -NoNewline
}