<#
	.快捷指令：不保存当前
#>
Function Shortcuts_Dont_Save_Current
{
	Write-Host "`n  $($lang.Unmount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 60`n" -ForegroundColor Green
			}

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
			Image_Eject_Abandon -Uid $Global:Primary_Key_Image.Uid -VerifyPath $test_mount_folder_Current
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

<#
	.快捷指令：保存当前
#>
Function Shortcuts_Save_Current
{
	Write-Host "`n  $($lang.Save)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Save-WindowsImage -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
			}

			Write-Host
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_folder_Current | Out-Null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Shortcuts_Save
{
	param
	(
		$Name
	)

	$Name = $Name.ToLower().Replace('save ', '').Replace('save', '')

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Save" -ForegroundColor Green

	Write-Host "`n  $($lang.AdvOption): " -ForegroundColor Yellow
	Write-Host "  $('.' * 80)"
	Write-Host "  " -NoNewline
	Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($Name -like "*-u*") {
		Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		$Name = $Name.Replace('-u', '')
		$IsSaveUnmount = $True
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		$IsSaveUnmount = $False
	}

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Allow) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($Name -like "*-Q*") {
		Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		$Name = $Name.Replace('-q', '')
		$Quick = $True
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		$Quick = $False
	}

	$Name = $Name.Replace(' ', '')
	if (([string]::IsNullOrEmpty($Name))) {
		if (([string]::IsNullOrEmpty($Global:Primary_Key_Image.Uid))) {
		} else {
			ForEach ($item in $Global:Image_Rule) {
				if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
					$Name = $item.Main.Shortcuts
					break
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Expand.Uid -eq $Global:Primary_Key_Image.Uid) {
							$Name = $Expand.Shortcuts
							break
						}
					}
				}
			}
		}
	}

	Write-Host
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Write-Host "`n  $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"
			Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $test_mount_folder_Current -ForegroundColor Green

			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Image_Is_Mount_Specified -Uid $item.Main.Uid) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Green

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Save-WindowsImage -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
					Write-Host "  $('-' * 80)"
				}

				Write-Host
				Write-Host "  " -NoNewline
				Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_folder_Current | Out-Null
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host
				Write-Host "  " -NoNewline
				Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor White -ForegroundColor Black
				if ($IsSaveUnmount) {
					Write-Host " $($lang.UpdateAvailable) " -BackgroundColor DarkGreen -ForegroundColor White

					if ($Quick) {
						New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $True -Force
					}

					Shortcuts_Dont_Save_Current
				} else {
					Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green

					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($Expand.ImageFileName).$($Expand.Suffix)\Mount"
					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $test_mount_folder_Current -ForegroundColor Green

					Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"

					if (Image_Is_Mount_Specified -Uid $Expand.Uid) {
						Write-Host "  $($lang.Mounted)" -ForegroundColor Green

						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Save-WindowsImage -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
							Write-Host "  $('-' * 80)"
						}

						Write-Host
						Write-Host "  " -NoNewline
						Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_folder_Current | Out-Null
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

						Write-Host
						Write-Host "  " -NoNewline
						Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor White -ForegroundColor Black
						if ($IsSaveUnmount) {
							Write-Host " $($lang.UpdateAvailable) " -BackgroundColor DarkGreen -ForegroundColor White

							if ($Quick) {
								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Expand.Uid)" -Value $True -Force
							}

							Shortcuts_Dont_Save_Current
						} else {
							Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
						}
					} else {
						Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

Function Shortcuts_Unmt
{
	param
	(
		$Name
	)

	$Name = $Name.ToLower().Replace('unmt ', '').Replace('unmt', '')

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Unmt" -ForegroundColor Green

	Write-Host "`n  $($lang.AdvOption): " -ForegroundColor Yellow
	Write-Host "  $('.' * 80)"
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Allow) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($Name -like "*-q*") {
		Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		$Name = $Name.Replace('-q', '')
		$Quick = $True
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		$Quick = $False
	}

	$Name = $Name.Replace(' ', '')
	if (([string]::IsNullOrEmpty($Name))) {
		if (([string]::IsNullOrEmpty($Global:Primary_Key_Image.Uid))) {
		} else {
			ForEach ($item in $Global:Image_Rule) {
				if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
					$Name = $item.Main.Shortcuts
					break
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Expand.Uid -eq $Global:Primary_Key_Image.Uid) {
							$Name = $Expand.Shortcuts
							break
						}
					}
				}
			}
		}
	}

	Write-Host
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Write-Host "`n  $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"
			Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $test_mount_folder_Current -ForegroundColor Green

			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			<#
				.搜索扩展项是否已挂载
			#>
			if ($item.Expand.Count -gt 0) {
				$WaitUnmountError = @()
				ForEach ($Expand in $item.Expand) {
					if (Image_Is_Mount_Specified -Uid $Expand.Uid) {
						$WaitUnmountError += $Expand.Uid
					}
				}

				if ($WaitUnmountError.count -gt 0) {
					ForEach ($itemError in $WaitUnmountError) {
						Write-Host "  $($lang.Mounted): " -NoNewline
						Write-Host $itemError -ForegroundColor Green
					}

					Write-Host "`n  $($lang.ImageEjectSpecification -f $item.Main.Uid)" -ForegroundColor Red

					Get_Next -DevCode "EPA 1"
					return
				}
			}

			<#
				.弹出主要项
			#>
			if (Image_Is_Mount_Specified -Uid $item.Main.Uid) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Green

				if ($Global:Developers_Mode) {
					Write-Host "`n  $($lang.Developers_Mode_Location): 500`n" -ForegroundColor Green
				}

				if ($Quick) {
					New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $True -Force
				}

				Image_Eject_Abandon -Uid $item.Main.Uid -VerifyPath $test_mount_folder_Current
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green

					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($Expand.ImageFileName).$($Expand.Suffix)\Mount"
					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $test_mount_folder_Current -ForegroundColor Green

					Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"

					if (Image_Is_Mount_Specified -Uid $Expand.Uid) {
						Write-Host "  $($lang.Mounted)" -ForegroundColor Green

						if ($Global:Developers_Mode) {
							Write-Host "`n  $($lang.Developers_Mode_Location): 600`n" -ForegroundColor Green
						}

						if ($Quick) {
							New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Expand.Uid)" -Value $True -Force
						}

						Image_Eject_Abandon -Uid $Expand.Uid -VerifyPath $test_mount_folder_Current
					} else {
						Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

<#
	.允许使用快速抛弃方式
#>
Function Image_Eject_Abandon
{
	param (
		$Uid,
		$VerifyPath
	)

	$IsAllowCheck = $False

	<#
		.Allow automatic activation of the quick discard method
		.允许自动开启快速抛弃方式
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Uid)" -ErrorAction SilentlyContinue).Value) {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $($lang.Developers_Mode_Location): 22`n" -ForegroundColor Green
						Write-host "  Queue_Eject_Do_Not_Save_Abandon_Allow_$($Uid), $($lang.Enable)" -ForegroundColor Green
					}

					$IsAllowCheck = $True
				}
			}
		}
	}

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Allow) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($IsAllowCheck) {
		$OnlySupportMain = $False

		ForEach ($item in $Global:Image_Rule) {
			if ($item.Main.Uid -eq $Uid) {
				$OnlySupportMain = $True
			}
		}

		if ($OnlySupportMain) {
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			$IsMountImageGet = @()
			Get-WindowsImage -Mounted | ForEach-Object {
				$IsMountImageGet += $_.Path
			}

			write-host
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Prerequisites) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if ($IsMountImageGet.Count -ge 2) {
				Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White

				write-host "`n  $($lang.ViewMounted)"
				Write-Host "  $('-' * 80)"
				foreach ($item in $IsMountImageGet) {
					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $item -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.Unmount) " -NoNewline -BackgroundColor White -ForegroundColor Black
					if ($VerifyPath -contains $item) {
						Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
					} else {
						Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
					}

					write-host 
				}
			} else {
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Other_Tasks_RAMDISK_AR
				return
			}
		} else {
			Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
	}

	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  Dismount-WindowsImage -Path ""$($VerifyPath)"" -Discard" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
	}

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Unmount) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Dismount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Dismount.log" -Path "$($VerifyPath)" -Discard -ErrorAction SilentlyContinue | Out-Null
	Image_Mount_Force_Del -NewPath $VerifyPath
	Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

	<#
		.检查了已挂载后，判断目录是否存在，再次删除。
	#>
	if (Test-Path -Path $VerifyPath -PathType Container) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 18`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Dismount-WindowsImage -Path ""$($VerifyPath)"" -Discard" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
		}

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Unmount) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Dismount-WindowsImage -ScratchDirectory $(Get_Mount_To_Temp) -LogPath "$(Get_Mount_To_Logs)\Dismount.log" -Path "$($VerifyPath)" -Discard -ErrorAction SilentlyContinue | Out-Null
		Image_Mount_Force_Del -NewPath $VerifyPath
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	}
}