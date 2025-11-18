<#
	.空任务
#>
Function Other_Tasks_Empty
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_Empty" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_Empty) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
}

<#
	.清理解决方案 Yi 目录
#>
Function Other_Tasks_Clear
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_Clear" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_Clear) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$Local_Regedit_File_System = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)"
			Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Green
			
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $Local_Regedit_File_System -PathType Container) {
				Remove_Tree -Path $Local_Regedit_File_System

				if (Test-Path -Path $Local_Regedit_File_System -PathType Container) {
					Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				} else {
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				}
			} else {
				Write-Host " $($lang.NoInstallImage) " -BackgroundColor DarkRed -ForegroundColor White
			}
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}

	write-host
}

<#
	.添加测试目录
#>
Function Other_Tasks_CTD
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_CTD" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_CTD) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$RandomGuid = [guid]::NewGuid()
			$Local_Regedit_File_System = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\$((Get-Module -Name Solutions).Author)\$($RandomGuid)"

			Check_Folder -chkpath $Local_Regedit_File_System
			Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Green

			Write-Host "  $($lang.Done)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}

	write-host
}

<#
	.TPM 2.0 检查
#>
Function Other_Tasks_TPM
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_TPM" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_TPM) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$Local_Regedit_File_System = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\System32\Config\SYSTEM"

			Write-Host "  $($lang.SelFile)"
			Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Green
			if (Test-Path -Path $Local_Regedit_File_System -PathType Leaf) {
				$RandomGuid = [guid]::NewGuid()

				Write-Host "`n  $($lang.Select_Path): " -NoNewline
				Write-Host "HKLM:\$($RandomGuid)" -ForegroundColor Yellow

				New-PSDrive -PSProvider Registry -Name OtherTasksTPM -Root HKLM -ErrorAction SilentlyContinue | Out-Null

				Start-Process reg -ArgumentList "Load ""HKLM\$($RandomGuid)"" ""$($Local_Regedit_File_System)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

				if (Test-Path -Path "HKLM:\$($RandomGuid)" -PathType Container) {
					if((Test-Path -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig") -ne $true) {
						New-Item "HKLM:\$($RandomGuid)\Setup\LabConfig" -force -ErrorAction SilentlyContinue | Out-Null
					}

					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig" -Name "BypassCPUCheck" -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig" -Name "BypassStorageCheck" -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig" -Name "BypassRAMCheck" -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig" -Name "BypassTPMCheck" -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\Setup\LabConfig" -Name "BypassSecureBootCheck" -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

					[gc]::collect()

					Start-Process reg -ArgumentList "unload ""HKLM\$($RandomGuid)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

					if (Test-Path -Path "HKLM:\$($RandomGuid)" -PathType Container) {
						for ($i = 0; $i -lt 5; $i++) {
							Start-Process reg -ArgumentList "unload ""HKLM\$($RandomGuid)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
							Start-Sleep -Seconds 5
						}
					}

					Remove-PSDrive -Name OtherTasksTPM
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.AddTo), $($lang.Failed)" -ForegroundColor Red
				}
			} else {
				Write-Host "`n  $($lang.NoInstallImage)"
				Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

<#
	.修改 boot.wim 支持安装于 REFS 分区
#>
Function Other_Tasks_REFS
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_REFS" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_REFS) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$Local_Regedit_File_System = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount\Windows\System32\Config\SYSTEM"

			Write-Host "  $($lang.SelFile)"
			Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Green
			if (Test-Path -Path $Local_Regedit_File_System -PathType Leaf) {
				$RandomGuid = [guid]::NewGuid()

				Write-Host "`n  $($lang.Select_Path): " -NoNewline
				Write-Host "HKLM:\$($RandomGuid)" -ForegroundColor Yellow

				New-PSDrive -PSProvider Registry -Name OtherTasksREFS -Root HKLM -ErrorAction SilentlyContinue | Out-Null

				Start-Process reg -ArgumentList "Load ""HKLM\$($RandomGuid)"" ""$($Local_Regedit_File_System)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

				if (Test-Path -Path "HKLM:\$($RandomGuid)" -PathType Container) {
					if((Test-Path -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748") -ne $true) {
						New-Item "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -force -ErrorAction SilentlyContinue | Out-Null
					}

					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -Name 'EnabledState' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -Name 'EnabledStateOptions' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -Name 'Variant' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -Name 'VariantPayload' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
					New-ItemProperty -LiteralPath "HKLM:\$($RandomGuid)\ControlSet001\Control\FeatureManagement\Overrides\8\3689412748" -Name 'VariantPayloadKind' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

					[gc]::collect()

					Start-Process reg -ArgumentList "unload ""HKLM\$($RandomGuid)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

					if (Test-Path -Path "HKLM:\$($RandomGuid)" -PathType Container) {
						for ($i = 0; $i -lt 5; $i++) {
							Start-Process reg -ArgumentList "unload ""HKLM\$($RandomGuid)""" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
							Start-Sleep -Seconds 5
						}
					}

					Remove-PSDrive -Name OtherTasksREFS
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.AddTo), $($lang.Failed)" -ForegroundColor Red
				}
			} else {
				Write-Host "`n  $($lang.NoInstallImage)"
				Write-Host "  $($Local_Regedit_File_System)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}

	write-host
}

<#
	.Force format drive letter: volume name
	.强行格式化盘符：卷标名
#>
Function Other_Tasks_RAMDISK
{
	param
	(
		[switch]$Verify,
		[Switch]$Silent
	)

	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_RAMDISK" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $lang.Other_Tasks_RAMDISK -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	<#
		.获取 RAMDISK 卷标名
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
		$GetRegRAMDISKVolumeLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
		$WaitFormatTasks = @()

		Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
			if ($_.Label -eq $GetRegRAMDISKVolumeLabel) {
				$WaitFormatTasks += @{
					Label = $GetRegRAMDISKVolumeLabel
					DriveLetter = $_.DriveLetter.Replace(":", "")
				}
			}
		}

		if ($WaitFormatTasks.Count -gt 0) {
			ForEach ($item in $WaitFormatTasks) {
				Write-Host "  $($lang.AutoSelectRAMDISK): " -NoNewline
				Write-host $item.Label -ForegroundColor Green

				Write-Host "  $($lang.Select_Path): " -NoNewline
				Write-Host $item.DriveLetter -ForegroundColor Green

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Format-Volume -DriveLetter $($item.DriveLetter) -NewFileSystemLabel ""$($item.Label)""" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				Write-Host "  " -NoNewline
				Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Invoke-Expression -Command "Format-Volume -DriveLetter $($item.DriveLetter) -NewFileSystemLabel ""$($item.Label)"""
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}
		} else {
			Write-Host "  $($lang.AutoSelectRAMDISK): " -NoNewline
			Write-host $GetRegRAMDISKVolumeLabel -ForegroundColor Green
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
	}

	write-host
}

<#
	.Force format drive letter: volume name + automatic repair
	.强行格式化盘符：卷标名 + 自动修复
#>
Function Other_Tasks_RAMDISK_AR
{
	param
	(
		[switch]$Verify,
		[Switch]$Silent
	)

	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_RAMDISK_AR" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $lang.Other_Tasks_RAMDISK_AR -ForegroundColor Yellow

	Write-Host "`n  $($lang.Repair)" -ForegroundColor Yellow
	Write-Host "    * $($lang.HistoryClearDismSave)" -ForegroundColor Green
	Write-Host "    * $($lang.Clear_Bad_Mount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	<#
		.获取 RAMDISK 卷标名
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
		$GetRegRAMDISKVolumeLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
		$WaitFormatTasks = @()

		Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
			if ($_.Label -eq $GetRegRAMDISKVolumeLabel) {
				$WaitFormatTasks += @{
					Label = $GetRegRAMDISKVolumeLabel
					DriveLetter = $_.DriveLetter.Replace(":", "")
				}
			}
		}

		if ($WaitFormatTasks.Count -gt 0) {
			ForEach ($item in $WaitFormatTasks) {
				Write-Host "  $($lang.AutoSelectRAMDISK): " -NoNewline
				Write-host $item.Label -ForegroundColor Green

				Write-Host "  $($lang.Select_Path): " -NoNewline
				Write-Host $item.DriveLetter -ForegroundColor Green

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Format-Volume -DriveLetter $($item.DriveLetter) -NewFileSystemLabel ""$($item.Label)""" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				Write-Host "  " -NoNewline
				Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Invoke-Expression -Command "Format-Volume -DriveLetter $($item.DriveLetter) -NewFileSystemLabel ""$($item.Label)"""
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}

			write-host "`n  $($lang.HistoryClearDismSave)"
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			write-host "`n  $($lang.Clear_Bad_Mount)"
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Repair): " -NoNewline
			dism /cleanup-wim | Out-Null
			Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host "  $($lang.AutoSelectRAMDISK): " -NoNewline
			Write-host $GetRegRAMDISKVolumeLabel -ForegroundColor Green
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
	}

	write-host
}

<#
	.暂停
#>
Function Other_Tasks_Pause
{
	Write-Host "  $($lang.RuleName): ".PadRight(22) -NoNewline
	Write-host "Function Other_Tasks_Pause" -ForegroundColor Yellow

	Write-Host "  $($lang.RuleDescription): ".PadRight(22) -NoNewline
	Write-host $($lang.Other_Tasks_Pause) -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Get_Next
	Write-Host "  $($lang.Done)" -ForegroundColor Green
	Write-Host
}