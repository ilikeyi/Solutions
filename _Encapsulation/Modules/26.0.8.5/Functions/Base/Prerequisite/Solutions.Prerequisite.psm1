<#
	.Prerequisite
	.先决条件
#>
Function Prerequisite
{
	# Elevating priviledges for this process
	do {} until ( ElevatePrivileges SeTakeOwnershipPrivilege )

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($Global:Author)'s Solutions | $($lang.Prerequisites)"
	Write-Host "`n  $($lang.Prerequisites)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-Host "  $($lang.Check_PSVersion): " -NoNewline
	if ($PSVersionTable.PSVersion.major -ge "5") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		Write-Host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "    1. $($lang.UpdatePSVersion)`n"
		pause
		exit
	}

	Write-Host "  $($lang.Check_OSVersion): " -NoNewline
	$OSVer = [System.Environment]::OSVersion.Version;
	if (($OSVer.Major -eq 10 -and $OSVer.Minor -eq 0 -and $OSVer.Build -ge 16299)) {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		Write-Host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "    $($lang.UpdateOSVersion)`n"
		pause
		exit
	}

	Write-Host "  $($lang.Check_Higher_elevated): " -NoNewline
	if (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White

		Write-Host "  $($lang.Check_execution_strategy): " -NoNewline
		try { 
			$GetEp = Get-ExecutionPolicy
		} catch {
			$getep = "Undefined"
		}
		switch ($GetEp) {
			"Bypass" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"RemoteSigned" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"Unrestricted" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"Undefined" {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			}
			default {
				Write-Host " $($lang.Check_Did_not_pass) " -BackgroundColor DarkRed -ForegroundColor White

				Write-Host "`n  $($lang.How_solve): " -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "    $($lang.HigherTermail)`n"
				pause
				exit
			}
		}
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		Write-Host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "    $($lang.HigherTermailAdmin)`n"

		$arguments = @(
			"-ExecutionPolicy",
			"ByPass",
			"-File",
			"""$($MyInvocation.MyCommand.Path)"""
		)
		Start-Process "powershell" -ArgumentList $arguments -Verb RunAs

		pause
		exit
	}

	Write-Host "  $($lang.UpdateClean): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue) {
		$GetOldVersion = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue
		$SaveCurrentVersion = (Get-Module -Name Solutions).Version.ToString()

		if ($GetOldVersion -eq $SaveCurrentVersion) {
			Write-Host " $($lang.UpdateNotExecuted) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Del) " -BackgroundColor DarkRed -ForegroundColor White

			$Wait_Clean_Folder_Full = Join-Path -Path "$($PSScriptRoot)\..\..\..\.." -ChildPath $GetOldVersion

			Write-Host "  $($lang.Del): $($GetOldVersion): " -NoNewline -ForegroundColor Green
			remove-item -path $Wait_Clean_Folder_Full -Recurse -force -ErrorAction SilentlyContinue

			if (Test-Path -Path $Wait_Clean_Folder_Full -PathType Container) {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	Write-Host "`n  $($lang.Check_OSEnv)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.IsAuto_Repair): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAuto_Repair" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAuto_Repair" -ErrorAction SilentlyContinue) {
			"True" {
				Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White

				$IsMountImageGet = @()
				Get-WindowsImage -Mounted | ForEach-Object {
					$IsMountImageGet += [pscustomobject]@{
						Path        = $_.Path
						ImagePath   = $_.ImagePath
						ImageIndex  = $_.ImageIndex
						MountMode   = $_.MountMode
						MountStatus = $_.MountStatus
					}
				}

				Write-Host "    * $($lang.Repair): " -NoNewline
				if ($IsMountImageGet.Count -gt 0) {
					Write-Host "$($lang.Mounted), " -NoNewline -ForegroundColor Green
					Write-Host " $($lang.NoWork) " -BackgroundColor DarkRed -ForegroundColor White
				} else {
					dism /cleanup-wim | Out-Null
					Clear-WindowsCorruptMountPoint -ErrorAction SilentlyContinue | Out-Null
					Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				}

				Write-host
			}
			"False" {
				Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "  $($lang.Check_Image_Bad): " -NoNewline
	$MarkErrorMounted = @()
	try {
		<#
			.标记是否捕捉到事件
		#>
		Get-WindowsImage -Mounted -ErrorAction SilentlyContinue | ForEach-Object {
			if ($_.MountStatus -eq "Invalid") {
				$MarkErrorMounted += [pscustomobject]@{
					Path        = $_.Path
					ImagePath   = $_.ImagePath
					ImageIndex  = $_.ImageIndex
					MountMode   = $_.MountMode
					MountStatus = $_.MountStatus
				}
			}

			if ($_.MountStatus -eq "NeedsRemount") {
				$MarkErrorMounted += [pscustomobject]@{
					Path        = $_.Path
					ImagePath   = $_.ImagePath
					ImageIndex  = $_.ImageIndex
					MountMode   = $_.MountMode
					MountStatus = $_.MountStatus
				}
			}
		}
	} catch {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}

	if ($MarkErrorMounted.count -gt 0) {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.Check_Need_Fix): $($MarkErrorMounted.count)" -ForegroundColor Green

		foreach ($item in $MarkErrorMounted) {
			Write-Host "    $('-' * 77)"
			Write-Host "    $($lang.Select_Path): " -NoNewline
			Write-Host $item.Path -ForegroundColor Yellow

			Write-Host "    $($lang.Image_Path): " -NoNewline
			Write-Host $item.ImagePath -ForegroundColor Yellow

			Write-Host "    $($lang.MountedIndex): " -NoNewline
			Write-Host $item.ImageIndex -ForegroundColor Yellow

			Write-Host "    $($lang.Image_Mount_Mode): " -NoNewline
			Write-Host $item.MountMode -ForegroundColor Yellow

			Write-Host "    $($lang.Image_Mount_Status): " -NoNewline
			Write-Host $item.MountStatus -ForegroundColor Red
		}
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	<#
		.Windows Defender 排除项
	#>
	Write-Host "`n  $($lang.DefenderExclude)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.SearchImageSource): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
			"True" {
				Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White

				<#
					.获取 RAMDISK 卷标名
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
					$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue

					$GetAddFolderExclude = @()
					foreach ($item in $GetDiskTo) {
						$GetAddFolderExclude += $item
					}

					if ($GetAddFolderExclude.count -gt 0) {
						$isExclude = @()

						try	{
							$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
							foreach ($exclusion in $extensionExclusion.ExclusionPath) {
								if ($GetAddFolderExclude -contains $exclusion) {
									$isExclude += $exclusion
								}
							}
						} catch {
							
						}

						$WaitAddExclude = @()

						<#
							.Windows Defender 已添加排除项
						#>
						$ExcludeAdded = @()
						if ($isExclude.Count -gt 0) {
							foreach ($item in $GetAddFolderExclude) {
								if ($item -NotContains $isExclude) {
									$ExcludeAdded += $item
								}
							}

							foreach ($item in $GetAddFolderExclude) {
								if ($item -contains $ExcludeAdded) {
									$WaitAddExclude += $item
								}
							}
						} else {
							foreach ($AddRAMDISK in $GetAddFolderExclude) {
								$WaitAddExclude += $AddRAMDISK
							}
						}

						foreach ($item in $GetAddFolderExclude) {
							Write-host "      $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
							write-host $item -ForegroundColor Green -NoNewline

							Write-Host ", $($lang.AddTo): " -NoNewline
							if ($WaitAddExclude -contains $item) {
								Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
								Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
							} else {
								Write-Host " $($lang.Existed) " -BackgroundColor DarkRed -ForegroundColor White
							}
						}
					} else {
						Write-Host "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
					}
				} else {
					Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
				}

				write-host
			}
			"False" {
				Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "  $($lang.AutoSelectRAMDISK): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
						"True" {
							Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White

							<#
								.获取 RAMDISK 卷标名
							#>
							Write-Host "    * $($lang.RAMDISK_Search): " -NoNewline
							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
								$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
								write-host $CustomRAMDISKLabel -ForegroundColor Green

								$GetRAMDISK = @()
								Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
									if ($_.Label -eq $CustomRAMDISKLabel) {
										$GetRAMDISK += (Join_MainFolder -Path $_.DriveLetter)
									}
								}

								if ($GetRAMDISK.count -gt 0) {
									$isExclude = @()

									try {
										$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
										foreach ($exclusion in $extensionExclusion.ExclusionPath) {
											if ($GetRAMDISK -contains $exclusion) {
												$isExclude += $exclusion
											}
										}
									} catch {
										
									}

									$WaitAddExclude = @()

									<#
										.Windows Defender 已添加排除项
									#>
									$ExcludeAdded = @()
									if ($isExclude.Count -gt 0) {
										foreach ($item in $GetRAMDISK) {
											if ($item -NotContains $isExclude) {
												$ExcludeAdded += $item
											}
										}

										foreach ($item in $GetRAMDISK) {
											if ($item -contains $ExcludeAdded) {
												$WaitAddExclude += $item
											}
										}
									} else {
										foreach ($AddRAMDISK in $GetRAMDISK) {
											$WaitAddExclude += $AddRAMDISK
										}
									}

									foreach ($item in $GetRAMDISK) {
										Write-host "      $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
										write-host $item -ForegroundColor Green -NoNewline
									
										Write-Host ", $($lang.AddTo): " -NoNewline
										if ($WaitAddExclude -contains $item) {
											Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
											Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
										} else {
											Write-Host " $($lang.Existed) " -BackgroundColor DarkRed -ForegroundColor White
										}
									}
								} else {
									Write-Host "      $($lang.AutoSelectRAMDISKFailed): " -NoNewline
									write-host $CustomRAMDISKLabel -ForegroundColor Red
								}

								Write-Host
							} else {
								Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
							}
						}
						"False" {
							Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
						}
					}
				} else {
					Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
				}
			}
			"False" {
				Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "  $($lang.CacheDiskCustomize): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
			"True" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
						"True" {
							Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White

							<#
								.获取自定义目录
							#>
							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue) {
								$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue

								$GetAddFolderExclude = @()
								foreach ($item in $GetDiskTo) {
									$GetAddFolderExclude += $item
								}

								if ($GetAddFolderExclude.count -gt 0) {
									$isExclude = @()

									try {
										$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
										foreach ($exclusion in $extensionExclusion.ExclusionPath) {
											if ($GetAddFolderExclude -contains $exclusion) {
												$isExclude += $exclusion
											}
										}
									} catch {
										
									}

									$WaitAddExclude = @()

									<#
										.Windows Defender 已添加排除项
									#>
									$ExcludeAdded = @()
									if ($isExclude.Count -gt 0) {
										foreach ($item in $GetAddFolderExclude) {
											if ($item -NotContains $isExclude) {
												$ExcludeAdded += $item
											}
										}

										foreach ($item in $GetAddFolderExclude) {
											if ($item -contains $ExcludeAdded) {
												$WaitAddExclude += $item
											}
										}
									} else {
										foreach ($AddRAMDISK in $GetAddFolderExclude) {
											$WaitAddExclude += $AddRAMDISK
										}
									}

									foreach ($item in $GetAddFolderExclude) {
										Write-host "      $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
										write-host $item -ForegroundColor Green -NoNewline

										Write-Host ", $($lang.AddTo): " -NoNewline
										if ($WaitAddExclude -contains $item) {
											Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
											Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
										} else {
											Write-Host " $($lang.Existed) " -BackgroundColor DarkRed -ForegroundColor White
										}
									}
								} else {
									Write-Host "$($lang.DefenderExclude): $($lang.CacheDiskCustomize): $($CustomRAMDISKLabel)"
								}
							} else {
								Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
							}
						}
						"False" {
							Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
						}
					}
				} else {
					Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
				}
			}
			"False" {
				Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
	}

	<#
		模块名称
		模块最低版本
	#>
	$ExpansionModule = @(
		@{
			Name    = "Solutions.Custom.Extension"
			Version = "1.0.0.0"
		}
	)

	Write-Host "`n  $($lang.RuleCustomize)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $ExpansionModule) {
		Write-Host "  $($item.name).psd1: " -NoNewline -ForegroundColor Green

		$MarkFindModule = $False
		$MarkFindModuleVersion = ""

		Get-Module -Name $item.Name | ForEach-Object {
			if ($item.Name -eq $_.Name) {
				$MarkFindModule = $True
				$MarkFindModuleVersion = $_.Version
			}
		}

		if ($MarkFindModule) {
			Write-Host " $($lang.UpdateAvailable) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "    $($lang.LowAndCurrentError -f $item.Version, $MarkFindModuleVersion)"
			Write-Host "    $($lang.Check_Eligible): " -NoNewline -ForegroundColor Green

			if ($item.Version -eq $MarkFindModuleVersion) {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

				Write-Host "`n  $($lang.Check_Version_PSM_Error -f $item.Name)" -ForegroundColor Red
				start-process "timeout.exe" -argumentlist "/t 6 /nobreak" -wait -nonewwindow
				Modules_Import
				Stop-Process $PID
				exit
			}

			Write-Host
		} else {
			Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		}
	}

	Write-Host "`n  $($lang.Check_Compatibility)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.Check_Duplicate_rule)" -ForegroundColor Yellow
	Write-Host "    $($lang.RuleGUID): " -NoNewline

	$Duplicate_Rule_GUID = @()
	$Duplicate_Rule_GUID_seen = @{}
	$Duplicate_Rule_GUID_duplicates = @()
	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		ForEach ($item in $itemPre.Version) {
			$Duplicate_Rule_GUID += $item.GUID
		}
	}
	ForEach ($item in $Global:Preconfigured_Rule_Language) {
		$Duplicate_Rule_GUID += $item.GUID
	}
	ForEach ($item in $Global:Custom_Rule) {
		$Duplicate_Rule_GUID += $item.GUID
	}

	<#
		.检查重复项
	#>
	foreach ($item in $Duplicate_Rule_GUID) {
		if ($Duplicate_Rule_GUID_seen[$item]) {
			$Duplicate_Rule_GUID_duplicates += $item
		} else {
			$Duplicate_Rule_GUID_seen[$item] = $true
		}
	}
	$Duplicate_Rule_GUID_duplicates = $Duplicate_Rule_GUID_duplicates | Select-Object -Unique

	if ($Duplicate_Rule_GUID_duplicates.Count -gt 0) {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "        $($Duplicate_Rule_GUID_duplicates.count) $($lang.Duplicates)" -ForegroundColor Green
		Write-Host "        $('-' * 74)"
		foreach ($item in $Duplicate_Rule_GUID_duplicates) {
			Write-Host "        $($item)" -ForegroundColor Red
		}

		Write-Host
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	Write-Host "    $($lang.ISO_File): " -NoNewline
	$Duplicate_Rule_ISO = @()
	$Duplicate_Rule_ISO_seen = @{}
	$Duplicate_Rule_ISO_duplicates = @()

	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		ForEach ($item in $itemPre.Version) {
			foreach ($itemISO in $item.ISO) {
				if (-not [string]::IsNullOrEmpty($itemISO.ISO)) {
					$Duplicate_Rule_ISO += [System.IO.Path]::GetFileName($itemISO.ISO)
				}
			}
		}
	}

	ForEach ($item in $Global:Preconfigured_Rule_ISO) {
		foreach ($itemISO in $item.ISO) {
			if (-not [string]::IsNullOrEmpty($itemISO.ISO)) {
				$Duplicate_Rule_ISO += [System.IO.Path]::GetFileName($itemISO.ISO)
			}
		}
	}

	ForEach ($item in $Global:Custom_Rule) {
		foreach ($itemISO in $item.ISO) {
			if (-not [string]::IsNullOrEmpty($itemISO.ISO)) {
				$Duplicate_Rule_ISO += [System.IO.Path]::GetFileName($itemISO.ISO)
			}
		}
	}

	<#
		.检查重复项
	#>
	foreach ($item in $Duplicate_Rule_ISO) {
		if ($Duplicate_Rule_ISO_seen[$item]) {
			$Duplicate_Rule_ISO_duplicates += $item
		} else {
			$Duplicate_Rule_ISO_seen[$item] = $true
		}
	}
	$Duplicate_Rule_ISO_duplicates = $Duplicate_Rule_ISO_duplicates | Select-Object -Unique

	if ($Duplicate_Rule_ISO_duplicates.Count -gt 0) {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "        $($Duplicate_Rule_ISO_duplicates.count) $($lang.Duplicates)" -ForegroundColor Green
		Write-Host "        $('-' * 74)"
		foreach ($item in $Duplicate_Rule_ISO_duplicates) {
			Write-Host "        $($item)" -ForegroundColor Red
		}

		Write-Host
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	Write-Host "    $($lang.ISO_Langpack): " -NoNewline
	$Duplicate_Rule_Language = @()
	$Duplicate_Rule_Language_seen = @{}
	$Duplicate_Rule_Language_duplicates = @()

	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		ForEach ($item in $itemPre.Version) {
			foreach ($itemlanguage in $item.Language.ISO) {
				$Duplicate_Rule_Language += [System.IO.Path]::GetFileName($itemlanguage.ISO)
			}
		}
	}

	ForEach ($item in $Global:Preconfigured_Rule_Language) {
		foreach ($itemlanguage in $item.Language.ISO) {
			$Duplicate_Rule_Language += [System.IO.Path]::GetFileName($itemlanguage.ISO)
		}
	}

	ForEach ($item in $Global:Custom_Rule) {
		foreach ($itemlanguage in $item.Language.ISO) {
			$Duplicate_Rule_Language += [System.IO.Path]::GetFileName($itemlanguage.ISO)
		}
	}

	<#
		.检查重复项
	#>
	foreach ($item in $Duplicate_Rule_Language) {
		if ($Duplicate_Rule_Language_seen[$item]) {
			$Duplicate_Rule_Language_duplicates += $item
		} else {
			$Duplicate_Rule_Language_seen[$item] = $true
		}
	}
	$Duplicate_Rule_Language_duplicates = $Duplicate_Rule_Language_duplicates | Select-Object -Unique

	if ($Duplicate_Rule_Language_duplicates.Count -gt 0) {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "        $($Duplicate_Rule_Language_duplicates.count) $($lang.Duplicates)" -ForegroundColor Green
		Write-Host "        $('-' * 74)"
		foreach ($item in $Duplicate_Rule_Language_duplicates) {
			Write-Host "        $($item)" -ForegroundColor Red
		}

		Write-Host
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	Write-Host "    InBox Apps ISO: " -NoNewline
	$Duplicate_Rule_InBox_Apps = @()
	$Duplicate_Rule_InBox_Apps_seen = @{}
	$Duplicate_Rule_InBox_Apps_duplicates = @()
	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		ForEach ($item in $itemPre.Version) {
			foreach ($itemInBox_Apps in $item.InboxApps.ISO) {
				$Duplicate_Rule_InBox_Apps += [System.IO.Path]::GetFileName($itemInBox_Apps.ISO)
			}
		}
	}
	ForEach ($item in $Global:Preconfigured_Rule_InBox_Apps) {
		foreach ($itemInBox_Apps in $item.InboxApps.ISO) {
			$Duplicate_Rule_InBox_Apps += [System.IO.Path]::GetFileName($itemInBox_Apps.ISO)
		}
	}
	ForEach ($item in $Global:Custom_Rule) {
		foreach ($itemInBox_Apps in $item.InboxApps.ISO) {
			$Duplicate_Rule_InBox_Apps += [System.IO.Path]::GetFileName($itemInBox_Apps.ISO)
		}
	}

	<#
		.检查重复项
	#>
	foreach ($item in $Duplicate_Rule_InBox_Apps) {
		if ($Duplicate_Rule_InBox_Apps_seen[$item]) {
			$Duplicate_Rule_InBox_Apps_duplicates += $item
		} else {
			$Duplicate_Rule_InBox_Apps_seen[$item] = $true
		}
	}
	$Duplicate_Rule_InBox_Apps_duplicates = $Duplicate_Rule_InBox_Apps_duplicates | Select-Object -Unique

	if ($Duplicate_Rule_InBox_Apps_duplicates.Count -gt 0) {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "        $($Duplicate_Rule_InBox_Apps_duplicates.count) $($lang.Duplicates)" -ForegroundColor Yellow
		Write-Host "        $('-' * 74)"
		foreach ($item in $Duplicate_Rule_InBox_Apps_duplicates) {
			Write-Host "        $($item)" -ForegroundColor Red
		}

		Write-Host
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	# Wimlib
	$WimlibSync = @(
		"OS.11\24H2\Expand"
		"OS.10\22H2\Expand"
	)

	foreach ($item in $WimlibSync) {
		$PathOneFUll = "$($PSScriptRoot)\..\..\..\..\..\..\_Learn\Packaging.tutorial\$($item)"
		if (Test-Path -Path $PathOneFUll -PathType Container) {
			$PathTwoFUll = "$($PathOneFUll)\Wimlib"

			if (Test-Path -Path $PathTwoFUll -PathType Container) {
			} else {
				$PublicWimlibPath = "$($PSScriptRoot)\..\..\..\..\AIO\Wimlib"
				if (Test-Path -Path $PublicWimlibPath -PathType Container) {
					Copy-Item -Path $PublicWimlibPath -Destination $PathTwoFUll -Recurse -Force -ErrorAction SilentlyContinue
				}
			}
		}
	}

	# 7Zip
	$ZipSync = @(
		"LXPs"
		"Multilingual"
		"Yi.Suite"
	)

	foreach ($item in $ZipSync) {
		$PathOneFUll = "$($PSScriptRoot)\..\..\..\..\..\_Custom\Engine\$($item)"
		$PathTwoFUll = "$($PathOneFUll)\AIO"

		$PublicWimlibPath = "$($PSScriptRoot)\..\..\..\..\AIO\7zPacker"
		if (Test-Path -Path $PublicWimlibPath -PathType Container) {
			Copy-Item -Path $PublicWimlibPath -Destination $PathTwoFUll -Recurse -Force -ErrorAction SilentlyContinue

			$Remove = @(
				"AMD64"
				"arm64"
				"x86"
			)

			foreach ($itemRemove in $Remove) {
				$NewFilepath = "$($PathTwoFUll)\$($itemRemove)\7zG.exe"
				if (Test-Path -Path $NewFilepath -PathType leaf) {
					Remove-Item -path $NewFilepath -Force -ErrorAction SilentlyContinue
				}
			}
		}
	}

	<#
		.允许自动更新
	#>
	Write-Host "`n  $($lang.Auto_Update_Allow)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
			"True"  {
				$SIPPS = Join-path -Path $PSScriptRoot -ChildPath "..\..\..\..\..\_Sip.ps1"
				$arguments = @(
					"-ExecutionPolicy",
					"ByPass",
					"-File",
					"""$($SIPPS)""",
					"-Functions",
					"Auto_Update"
				)

				<#
					.自动检查更新间隔小时
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue) {
					$WaitHoursTime = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue
				} else {
					$WaitHoursTime = "2"
					Save_Dynamic -regkey "Solutions\Update" -name "AutoCheckUpdate_Hours" -value "2"
				}
				$WaitSecoundsTime = [int]$WaitHoursTime * 3600

				<#
					.判断是否有上次执行时间
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Last_Auto_Update_Time" -ErrorAction SilentlyContinue) {
					$GetLastAutoUpdateTime = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Last_Auto_Update_Time" -ErrorAction SilentlyContinue
					$restoredDate = New-Object DateTime($GetLastAutoUpdateTime)

					Write-Host "  $($lang.Auto_Last_Check_Time): " -NoNewline
					Write-Host "$($restoredDate.ToString("yyyy/MM/dd hh:mm:ss tt"))" -ForegroundColor Yellow
					$currentTime = (Get-Date)
					$timeDiff = New-TimeSpan -Start $restoredDate -End $currentTime
#					Write-Host "  Time: $($timeDiff.TotalSeconds) Seconds"

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Auto_Update_Last_status" -ErrorAction SilentlyContinue) {
						$GetAuto_Update_Last_status = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "Auto_Update_Last_status" -ErrorAction SilentlyContinue
					} else {
						$GetAuto_Update_Last_status = $lang.ImageCodenameNo
					}
					Write-Host "  $($lang.Auto_Update_Last_status): " -NoNewline
					Write-Host $GetAuto_Update_Last_status -ForegroundColor Green

					if ($timeDiff.TotalSeconds -ge $WaitSecoundsTime) {
						write-host "  $($lang.Auto_Update_Allow)" -ForegroundColor Green
						Start-Process "powershell" -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -ErrorAction SilentlyContinue
					} else {
						$nextRunTime = $restoredDate.AddSeconds($WaitSecoundsTime)
						Write-host "  $($lang.Auto_Next_Check_Time -f $($WaitHoursTime)): " -NoNewline
						Write-Host "$($nextRunTime.ToString("yyyy/MM/dd hh:mm:ss tt"))" -ForegroundColor Yellow
					}
				} else {
					write-host "  $($lang.Auto_First_Check)" -ForegroundColor Green
					Start-Process "powershell" -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -ErrorAction SilentlyContinue
				}
			}
			"False" {
				Write-host "  $($lang.Disable)" -ForegroundColor Red
			}
		}
	} else {
		Write-host "  $($lang.Prerequisite_Not_satisfied)" -ForegroundColor Red
	}

	Write-Host "`n  $($lang.Check_Pass_Done)" -ForegroundColor Green
	Start-Sleep -s 2
}