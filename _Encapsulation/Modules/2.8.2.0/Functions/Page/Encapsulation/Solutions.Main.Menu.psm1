<#
	.LOGO
#>
Function Logo
{
	param
	(
		$Title,
		[switch]$ShowUpdate
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($Global:Author)'s Solutions | $($Title)"

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($Global:Author)'s Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v$((Get-Module -Name Solutions).Version.ToString()) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

	if ($ShowUpdate) {
		Write-Host " $($lang.ChkUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Upd " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Auto_Update_New_Version" -ErrorAction SilentlyContinue) {
		$SaveOldVersion = (Get-Module -Name Solutions).Version.ToString()
		$SaveNewVersion = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Auto_Update_New_Version" -ErrorAction SilentlyContinue

		if ($SaveOldVersion.Replace('.', '') -eq $SaveNewVersion.Replace('.', '')) {
		} else {
			if ($SaveOldVersion -gt $SaveNewVersion) {
			} else {
				$Global:SaveTempVersion = $SaveNewVersion
				write-host " $($lang.UpdateNewLatest) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			}
		}
	} else {
		if (-not ([string]::IsNullOrEmpty($Global:SaveTempVersion))) {
			$SaveOldVersion = (Get-Module -Name Solutions).Version.ToString()

			if ($SaveOldVersion.Replace('.', '') -eq $Global:SaveTempVersion.Replace('.', '')) {
				$Global:SaveTempVersion = ""
			} else {
				if ($SaveOldVersion -gt $Global:SaveTempVersion) {
					write-host " $($lang.UpdateNewLatest) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
				}
			}
		}
	}

	if ($Global:Developers_Mode) {
		$Host.UI.RawUI.WindowTitle += " | $($lang.Developers_Mode)"
		Write-Host " $($lang.Developers_Mode) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Dev " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Learn) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $((Get-Module -Name Solutions).PrivateData.PSData.ProjectUri) " -BackgroundColor DarkBlue -ForegroundColor White

	Write-Host
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToWait
{
	param
	(
		[int]$Wait
	)

	Write-Host
	Write-Host "  $($lang.ToMsg -f $wait)" -ForegroundColor Red
	start-process "timeout.exe" -argumentlist "/t $($wait) /nobreak" -wait -nonewwindow
}

Function Mainpage
{
	$Global:EventQueueMode = $False
	$Global:AutopilotMode = $False

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

	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.Menu -ShowUpdate
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Red
		}

		Write-Host "  " -NoNewline
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
			Mainpage
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n  $($lang.EventManager)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "   " -NoNewline
	Write-Host " A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Autopilot)" -NoNewline -ForegroundColor Green

	Write-host "    " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.OnDemandPlanTask)" -ForegroundColor Green

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Setting) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " S'et * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", $($lang.SelectSettingImage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "   " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Mount) " -NoNewline -ForegroundColor Green
	Write-Host " MT * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Remount) " -NoNewline -ForegroundColor Green
	Write-Host " rMT * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Rebuild) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " RBD * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " RBD * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " RBD * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.Wim_Append) " -NoNewline -ForegroundColor Green
	Write-Host " ISA * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
	Write-Host " ISD * " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "      " -NoNewline
	Write-Host " $($lang.AdditionalEdition) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " iAE * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " iAE * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " iAE * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Wim_Capture) " -NoNewline -ForegroundColor Green
	Write-Host " ISC " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host ", $($lang.Export_Image) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " Exp * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " Exp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " Exp * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.Apply) " -NoNewline -ForegroundColor Green
	Write-Host " App * " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "       $($lang.Wim_Rule_Update) " -NoNewline -ForegroundColor Green
	Write-Host " Euwl * " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-host "   " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.UnpackISO)" -NoNewline -ForegroundColor Yellow

	Write-host ", " -NoNewline
	Write-Host " $($lang.CompressionType_Fast) " -NoNewline -ForegroundColor Green
	Write-Host " FF " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-host "   " -NoNewline
	if ((Image_Is_Mount_Specified -Uid "Install;wim;Install;wim;") -or
		(Image_Is_Mount_Specified -Uid "Install;esd;Install;esd;")) {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host " $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Red
	} else {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Green
	}

	Write-host "   " -NoNewline
	Write-Host " 4 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.MoreFeature)" -ForegroundColor Yellow

	Write-Host "`n  $($lang.AssignNeedMount)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "  " -NoNewline
	Write-Host " 11 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.Mounted_Status): " -NoNewline -ForegroundColor Yellow
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

			Write-Host "       $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
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

			if ($IsShowQ) {
				write-host "       " -NoNewline
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
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.NotMounted), " -NoNewline -ForegroundColor Red

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

				Write-Host "       $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				if ($IsShowQ) {
					Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
				} else { write-host }

				if ($IsShowQ) {
					write-host "       " -NoNewline
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

			Write-Host "       $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
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

			if ($IsShowQ) {
				write-host "       " -NoNewline
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
		} else {
			Write-Host "$($lang.NotMounted) " -ForegroundColor Red
		}
	}

	Write-host "  " -NoNewline
	Write-Host " 12 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.Solution): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.IsCreate) " -NoNewline -ForegroundColor Green
	Write-Host " SC " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", $($lang.Del): " -NoNewline -ForegroundColor Yellow

	if ((Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container))
	{
		Write-Host "ISO " -NoNewline -ForegroundColor Green
		Write-Host " SC DI " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	} else {
		Write-Host "ISO " -NoNewline -ForegroundColor Red
		Write-Host " SC DI " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host ", " -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$TestNewFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
			$File_Path_MainFolder = "$($TestNewFolder)\$($Global:Author)"
			$File_Path_Unattend = "$($TestNewFolder)\Windows\Panther\Unattend.xml"
			$File_Path_Office = "$($TestNewFolder)\Users\Public\Desktop\Office"

			if ((Test-Path -Path $File_Path_MainFolder -PathType Container) -or
				(Test-Path -Path $File_Path_Unattend -PathType Leaf) -or
				(Test-Path -Path $File_Path_Office -PathType Container))
			{
				Write-Host "$($lang.Mounted) " -NoNewline -ForegroundColor Green
				Write-Host " SC DM " -BackgroundColor DarkMagenta -ForegroundColor White
			} else {
				Write-Host "$($lang.Mounted) " -NoNewline -ForegroundColor Red
				Write-Host " SC DM " -BackgroundColor DarkRed -ForegroundColor White
			}
		} else {
			Write-Host "$($lang.Mounted) " -NoNewline -ForegroundColor Red
			Write-Host " SC DM " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Mounted) " -NoNewline -ForegroundColor Red
		Write-Host " SC DM " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 13 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.Unzip_Language): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.LanguageExtract) " -NoNewline -ForegroundColor Green
	Write-Host " LP E " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " LP A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " LP D " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Green
			Write-Host " LP S " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " LP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " LP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
			Write-Host " LP S " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " LP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " LP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
		Write-Host " LP S " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 14 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.InboxAppsManager): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " IA A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " IA D " -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host "       $($lang.LocalExperiencePack) " -NoNewline -ForegroundColor Yellow
			Write-Host " LXPs " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.Download) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ": " -NoNewline

			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " EP A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " EP D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " IA A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " IA D " -BackgroundColor DarkRed -ForegroundColor White

			Write-Host "       $($lang.LocalExperiencePack) " -NoNewline -ForegroundColor Yellow
			Write-Host " LXPs " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.Download) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ": " -NoNewline

			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " EP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " EP D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " IA A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " IA D " -BackgroundColor DarkRed -ForegroundColor White

		Write-Host "       $($lang.LocalExperiencePack) " -NoNewline -ForegroundColor Yellow
		Write-Host " LXPs " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.Download) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host ": " -NoNewline

		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " EP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " EP D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 22 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.CUpdate): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.RuleNewTempate) " -NoNewline -ForegroundColor Green
	Write-Host " CT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " CU A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " CU D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " CU A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " CU D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " CU A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " CU D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 23 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.Drive): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " DD A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " DD D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " DD A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " DD D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " DD A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " DD D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 24 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.Editions): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Green
			Write-Host " IV C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.OOBEProductKey) " -NoNewline -ForegroundColor Green
			Write-Host " IV K " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
			Write-Host " IV C " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.OOBEProductKey) " -NoNewline -ForegroundColor Red
			Write-Host " IV K " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
		Write-Host " IV C " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.OOBEProductKey) " -NoNewline -ForegroundColor Red
		Write-Host " IV K " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	$EICfgPath = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
	Write-host ", $($lang.InstlMode): " -NoNewline -ForegroundColor Yellow
	if (Test-Path -Path $EICfgPath -PathType leaf) {
		Write-Host "$($lang.Business) " -NoNewline -ForegroundColor Green
		Write-Host " EI " -BackgroundColor DarkMagenta -ForegroundColor White
	} else {
		Write-Host "$($lang.Consumer) " -NoNewline -ForegroundColor Green
		Write-Host " EI " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 33 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.WindowsFeature): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Green
			Write-Host " WF E " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Green
			Write-Host " WF D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
			Write-Host " WF E " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
			Write-Host " WF D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
		Write-Host " WF E " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
		Write-Host " WF D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " 34 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " $($lang.SpecialFunction): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Green
			Write-Host " PF B " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Green
			Write-Host " PF A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
			Write-Host " PF B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
			Write-Host " PF A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
		Write-Host " PF B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
		Write-Host " PF A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
		Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-host "  " -NoNewline
	Write-Host " AA " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host " API: " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Green
			Write-Host " API B " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Green
			Write-Host " API A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " API * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
			Write-Host " API B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
			Write-Host " API A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " API * " -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
		Write-Host " API B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
		Write-Host " API A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
		Write-Host " API * " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Solutions_Input_Menu -PS
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
			Image_Assign_Event_Master
			ToWait -wait 2
			Mainpage
		}
		"2" {
			ISO_Create
			ToWait -wait 2
			Mainpage
		}
		"FF" {
			ISO_Create_UI -Quick -ISO

			if ($Global:Queue_ISO) {
				ISO_Create_Process
			} else {
				Write-host "  " -NoNewline
				Write-Host " $($lang.UnpackISO) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.NoWork) " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
				Write-Host
			}

			Get_Next -DevCode "SMM 1"
			Mainpage
		}
		"3" {
			Image_Convert
			ToWait -wait 2
			Mainpage
		}
		"4" {
			Feature_More_Menu
			ToWait -wait 2
			Mainpage
		}
		"11" {
			Image_Eject
			ToWait -wait 2
			Mainpage
		}
		"12" {
			Solutions_Menu
			ToWait -wait 2
			Mainpage
		}
		"13" {
			Language_Menu
			ToWait -wait 2
			Mainpage
		}
		"14" {
			InBox_Apps_Menu
			ToWait -wait 2
			Mainpage
		}
		"22" {
			Cumulative_updates_menu
			ToWait -wait 2
			Mainpage
		}
		"23" {
			Drive_Menu
			ToWait -wait 2
			Mainpage
		}
		"24" {
			Image_Version_Menu
			ToWait -wait 2
			Mainpage
		}
		"33" {
			Windows_Feature_Menu
			ToWait -wait 2
			Mainpage
		}
		"34" {
			PowerShell_Functions_Menu
			ToWait -wait 2
			Mainpage
		}
		"a" {
			Event_Assign_Task_Customize_Autopilot

			ToWait -wait 2
			Mainpage
		}
		"c" {
			Event_Assign_Task_Customize

			ToWait -wait 2
			Mainpage
		}

		<#
			设置、选择映像源
		#>
		{ "s", "Set", "S'et" -eq $_ } {
			Image_Select
			ToWait -wait 2
			Mainpage
		}
		{ $_ -like "s *" -or $_ -like "set *" -or $_ -like "s'et *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Setting -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
		}

		<#
			.快捷指令：查看并接受许可条款
		#>
		“vTC" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Eject_Abandon_Agreement
			ToWait -wait 2
			Mainpage
		}

		<#
			快捷指令
		#>
			<#
				.快捷指令：校验所有自动驾驶配置文件
			#>
			"va" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Verify_Autopilot_Custom_File
				ToWait -wait 2
				Mainpage
			}

			"vu" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Verify_Unattend_Custom_File
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：挂载
			#>
			"mt" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Mount
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：挂载 + 索引号
			#>
			"mt *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Mount_Key_and_Index -Command $PSItem
				ToWait -wait 2
				Mainpage
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
				Mainpage
			}

			<#
				.快捷指令：卸载，默认不保存
			#>
			"Unmt*" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Unmt -Name $PSItem
				ToWait -wait 2
				Mainpage
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
				Mainpage
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
				Mainpage
			}

			<#
				.快捷指令：追加
			#>
			"isa" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Append
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：追加 + 索引号
			#>
			"isa *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Append_IAB -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除
			#>
			"isd" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Remove
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除 + 索引号
			#>
			"isd *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Remove_Index -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：捕获
			#>
			"isc" {
				Write-Host "`n  $($lang.Short_Cmd): " -NoNewline
				Write-host "ISC" -ForegroundColor Green
				Image_Capture_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：提取、更新映像内里的文件
			#>
			"euwl" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Euwl
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：提取、更新映像内里的文件 + 主键
			#>
			"euwl *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Euwl_Primary_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：附加版本
			#>
			"iAE" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Additional_Edition
				ToWait -wait 2
				Mainpage
			}

			"iAE *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Additional_Edition_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"Exp" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Export
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出 + 主键
			#>
			"Exp *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Export_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重建映像文件
			#>
			"Rbd" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Rebuild
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重建映像文件 + 主键
			#>
			"Rbd *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Rebuild_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"App" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Apply
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出 + 主键
			#>
			"App *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Apply_Key -Name $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：解决方案：创建
			#>
			"sc" {
				Solutions
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：解决方案：删除，ISO
			#>
			"SC DI" {
				Solutions_Remove_Source_ISO
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：解决方案：删除，已挂载
			#>
			"SC DM" {
				Solutions_Remove_Mount_OEM
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：组：InBox Apps
			#>

			"IA *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_InBox_Apps_IA -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			"EP *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_LXPs_EP -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：组：累积更新
			#>
			"CU *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Cumulative_updates_CU -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			"ct" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Create_Template_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：驱动
			#>
			"DD *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Drive -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: Image Version
				.快捷指令：组：映像版本
			#>
			"IV *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Image_version -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: Installation Method
				.快捷指令：组：安装方式
			#>
			"EI" {
				Shortcuts_EI_Switch
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: Windows Function
				.快捷指令：组：Windows 功能
			#>
			"WF *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Windows_features -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: PowerShell Functions
				.快捷指令：组：PowerShell Functions 函数功能
			#>
			"PF *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				$NewRuleName = $PSItem.Remove(0, 3)
				Shortcuts_PowerShell_Functions -Command $NewRuleName
				ToWait -wait 2
				Mainpage
			}

				<#
					.Shortcut: PowerShell Functions Function: Unlimited
					.快捷指令：PowerShell Functions 函数功能：不受限制
				#>
					"FX" {
						Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
						Functions_Unrestricted_UI
						ToWait -wait 2
						Mainpage
					}
					"FX *" {
						Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
						$NewRuleName = $PSItem.Remove(0, 3)
						Shortcuts_PowerShell_Functions_Unrestricted -Command $NewRuleName
						ToWait -wait 2
						Mainpage
					}

			<#
				.开发者模式
			#>
			"Dev" {
				Shortcuts_Developers_Mode
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：在线更新
			#>
			"Upd" {
				Update
				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：在线更新，静默更新
			#>
			"Upd *" {
				Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
				Shortcuts_Update -Command $PSItem
				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：转换所有软件包为压缩包
			#>
			"zip" {
				Write-Host "`n  $($lang.ConvertToArchive)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				Covert_Software_Package_Unpack
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：打包
			#>
			"Unpack" {
				UnPack_Create_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：创建部署引擎升级包
			#>
			"Ceup" {
				Update_Create_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：修复 DISM 挂载
			#>
			"Fix" {
				Shortcuts_Fix
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：清除并释放已选择主键: Install, WimRE, Boot
			#>
			"CPK" {
				Write-Host "`n  $($lang.Event_Primary_Key_CPK)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				$Global:Primary_Key_Image = @()
				$Global:Save_Current_Default_key = ""

				Write-Host "  $($lang.Done)" -ForegroundColor Green

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：清除变量
			#>
			"Reset" {
				Additional_Edition_Reset
				Event_Reset_Variable
				ToWait -wait 2
				Mainpage
			}

		<#
			.切换语言
		#>
		"lang" {
			Language -Reset
			ToWait -wait 2
			Mainpage
		}

		"lp *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Image_Language -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		"lang *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Lang -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Mainpage
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Mainpage
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_Select -Name $PSItem
			ToWait -wait 2
			Mainpage
		}

		<#
			.LXPs
		#>
		"lxps" {
			Shortcuts_Engine_LXPs
			ToWait -wait 2
			Mainpage
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next -DevCode "SMM 2"
			ToWait -wait 2
			Mainpage
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		<#
			.退出
		#>
		"exit" {
			Stop-Process $PID
			exit
		}
		default {
			Mainpage
		}

		"aa" {
			API_Menu
			ToWait -wait 2
			Mainpage
		}
		"API" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			API_Unrestricted_UI
			ToWait -wait 2
			Mainpage
		}
		"API *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_API_Command -Name $PSItem.Remove(0, 4)

			Write-Host "  $('-' * 80)"
			Write-Host "  API: $($lang.API), $($lang.Done)" -ForegroundColor Green
			ToWait -wait 2
			Mainpage
		}

		<#
			.快捷指令：清除变量
		#>
		"PS *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Shortcuts_PS_Cmd -Command $PSItem
			ToWait -wait 2
			Mainpage
		}
		"t" {
			Write-Host "`n  $($lang.Developers_Mode)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			# Start
			$Global:EventQueueMode = $True
			$Global:AutopilotMode = $True

#			$Autopilot = Get-Content -Raw -Path "$($PSScriptRoot)\..\..\..\..\..\_Autopilot\Microsoft Windows 11\25H2\1.zh-CN.Additional.Edition.json" | ConvertFrom-Json
#			$GroupSelectAE = "Install;wim;Install;wim;"
#			if ($Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition.Count -gt 0) {
#				foreach ($item in $Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition) {
#					if ($GroupSelectAE -contains $item.Uid) {
#						Image_Set_Global_Primary_Key -Uid $item.Uid -Silent -DevCode "Autopilot - 9000"
#						Additional_Edition_UI -Autopilot $item
#					}
#				}
#			}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<#
				.运行事件
			#>
#			Event_Assign_Task

			$Global:EventQueueMode = $False
			$Global:AutopilotMode = $False
			# End

			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Developers_Mode), $($lang.Done)" -ForegroundColor Green

			<#
				.暂停
			#>
			Get_Next -DevCode "SMM 3"

			<#
				.添加 ToWait 防止直接退出
			#>
			ToWait -wait 2
			Mainpage
		}
	}
}