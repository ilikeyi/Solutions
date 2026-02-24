<#
	.Quick disposal method: agreement
	.快速抛弃方式：协议
#>
Function Eject_Abandon_Agreement
{
	Write-Host "`n  $($lang.Abandon_Agreement)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refresh_Disk_Volume_UI
	{
		$UI_Main_Select_Disk.controls.Clear()

		<#
			.获取 RAMDISK 卷标名
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
			$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
			$WaitFormatTasks = @()

			Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
				if ($_.Label -eq $CustomRAMDISKLabel) {
					$WaitFormatTasks += [pscustomobject]@{
						Label = $CustomRAMDISKLabel
						DriveLetter = $_.DriveLetter.Replace(":", "")
					}
				}
			}

			if ($WaitFormatTasks.Count -gt 0) {
				ForEach ($item in $WaitFormatTasks) {
					$LinkLabel          = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 445
						Text           = "$($item.DriveLetter):\"
						Tag            = $item.DriveLetter
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null

							$Temp_Get_Select_Function = @()
							$UI_Main_Select_Disk_Range.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.CheckBox]) {
									$Temp_Get_Select_Function += $_.Text
								}
							}

							if ($Temp_Get_Select_Function -contains $this.Text) {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.Existed): $($This.Text)"
							} else {
								$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
									Height    = 40
									Width     = 445
									Text      = $this.Text
									Tag       = $this.Tag
									Checked   = $True
									add_Click = {
										$UI_Main_Error.Text = ""
										$UI_Main_Error_Icon.Image = $null
									}
								}

								$UI_Main_Select_Disk_Range.controls.AddRange($CheckBox)

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
							}
						}
					}

					$LinkLabel_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 15
						Width          = 445
					}

					$UI_Main_Select_Disk.controls.AddRange((
						$LinkLabel,
						$LinkLabel_Wrap
					))
				}
			} else {
				$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 445
					Text           = $lang.NoWork
				}
				$UI_Main_Select_Disk.controls.AddRange($UI_Main_Pre_Rule_Not_Find)

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.AutoSelectRAMDISK): $($CustomRAMDISKLabel)"
			}
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = $lang.AutoSelectRAMDISKFailed
			$UI_Main_Save.Enabled = $False
			$UI_Main.Enabled = $False
		}
	}

	Function Eject_Abandon_Agreement_UI_Save
	{
		$CustomSelect = @()
		<#
			.Mark: Check the selection status
			.标记：检查选择状态
		#>
		$UI_Main_Select_Disk_Range.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$CustomSelect += $_.Tag
					}
				}
			}
		}

		if ($CustomSelect.Count -gt 0) {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Abandon_Disks" -value $CustomSelect -Type "MultiString"

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save): $($lang.Done)"
		} else {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Abandon_Disks" -value "" -Type "MultiString"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.Save): $($lang.Done), $($lang.SelectFromError): $($lang.NoChoose)"
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = $lang.Abandon_Agreement
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 530
		Width          = 500
		Location       = '0,15'
		Padding        = "15,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
	}

	<#
		.选择本地磁盘分区
	#>
	$UI_Main_Select_Disk_Name = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Location       = "560,15"
		Text           = $lang.AutoSelectRAMDISK
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Refresh_Disk_Volume_UI

			$UI_Main_Error.Text = "$($lang.Refresh): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
		$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
		$UI_Main_Select_Disk_Name.Text = "$($lang.AutoSelectRAMDISK): $($CustomRAMDISKLabel)"
	} else {
		$UI_Main_Select_Disk_Name.Text = "$($lang.AutoSelectRAMDISK): $($Global:Init_RAMDISK_Volume_Label)"
	}

	$UI_Main_Select_Disk = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 220
		Width          = 485
		Location       = '560,50'
		Padding        = "16,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
	}

	<#
		.已接受快速抛弃的磁盘分区
	#>
	$UI_Main_Select_Disk_Range_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.Abandon_Agreement_Disk_range
		Location       = '560,300'
	}
	$UI_Main_Select_Disk_Range = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 220
		Width          = 485
		Location       = '560,330'
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
	}

	if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name 'RAMDisk_Abandon_Disks' -ErrorAction SilentlyContinue)) {
		Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Abandon_Disks" -value "" -Type "MultiString"
	}
	$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Abandon_Disks" -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	if ($GetExcludeSoftware.Count -gt 0) {
		foreach ($item in $GetExcludeSoftware) {
			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = 40
				Width     = 445
				Text      = "$($item):\"
				Tag       = $item
				Checked   = $True
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$UI_Main_Select_Disk_Range.controls.AddRange($CheckBox)
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "585,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UI_Main_Terms_Tips_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "22,560"
		Height         = 30
		Width          = 550
		Text           = $lang.LXPsAddDelTips
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Mask_Tips_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "Tips_Abandon_Terms" -value "False"
			} else {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "Tips_Abandon_Terms" -value "True"
			}
		}
	}

	$UI_Main_Accept    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 60
		Width          = 508
		Location       = '22,600'
		Text           = $lang.Abandon_Agreement_Allow
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Accept" -value "True"
				$UI_Main_Save.Enabled = $True
				$UI_Main_Select_Disk_Name.Enabled = $True
				$UI_Main_Select_Disk.Enabled = $True
				$UI_Main_Select_Disk_Range.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Accept" -value "False"
				$UI_Main_Save.Enabled = $False
				$UI_Main_Select_Disk_Name.Enabled = $False
				$UI_Main_Select_Disk.Enabled = $False
				$UI_Main_Select_Disk_Range.Enabled = $False
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Accept.Checked = $True
			}
			"False" {
				$UI_Main_Accept.Checked = $False
			}
		}
	} 

	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 485
		Text           = $lang.Save
		add_Click      = { Eject_Abandon_Agreement_UI_Save }
	}

	if ($UI_Main_Accept.Checked) {
		$UI_Main_Save.Enabled = $True
		$UI_Main_Select_Disk_Name.Enabled = $True
		$UI_Main_Select_Disk.Enabled = $True
		$UI_Main_Select_Disk_Range.Enabled = $True
	} else {
		$UI_Main_Save.Enabled = $False
		$UI_Main_Select_Disk_Name.Enabled = $False
		$UI_Main_Select_Disk.Enabled = $False
		$UI_Main_Select_Disk_Range.Enabled = $False
	}

	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Select_Disk_Name,
		$UI_Main_Select_Disk,
		$UI_Main_Select_Disk_Range_Name,
		$UI_Main_Select_Disk_Range,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Terms_Tips_Do_Not,
		$UI_Main_Accept,
		$UI_Main_Save
	))

	$UI_Main_Terms_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.Abandon_Terms
	}
	$UI_Main_Terms_A_Name = New-Object System.Windows.Forms.Label -Property @{
		autosize       = $True
		Padding        = "20,10,10,10"
		Text           = "1. $($lang.Abandon_Allow)"
	}
	$UI_Main_Terms_A_Name_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 10
		Width          = 455
	}

	$UI_Main_Terms_B_Name = New-Object System.Windows.Forms.Label -Property @{
		autosize       = $True
		Padding        = "20,10,10,10"
		Text           = "2. $($lang.Abandon_Allow_Format): $($lang.Abandon_Agreement_Disk_range)"
	}
	$UI_Main_Terms_B_Name_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 10
		Width          = 455
	}

	$UI_Main_Terms_C_Name = New-Object System.Windows.Forms.Label -Property @{
		autosize       = $True
		Padding        = "20,10,10,10"
		Text           = "3. $($lang.Abandon_Allow_Time_Range): "
	}
	$UI_Main_Terms_C_Name_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 10
		Width          = 455
	}

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Terms_Name,
		$UI_Main_Terms_A_Name,
		$UI_Main_Terms_A_Name_Warp,
		$UI_Main_Terms_B_Name,
		$UI_Main_Terms_B_Name_Warp,
		$UI_Main_Terms_C_Name,
		$UI_Main_Terms_C_Name_Warp
	))

	$PowerShell_Function_Tasks = @()
	Get-Command -CommandType Function | ForEach-Object {
		if ($_ -like "Other_Tasks_RAMDISK*") {
			$PowerShell_Function_Tasks += $_.Name
		}
	}

	if ($PowerShell_Function_Tasks.Count -gt 0) {
		foreach ($item in $PowerShell_Function_Tasks) {
			$i++
			$LinkLabel          = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 445
				Padding        = "33,0,20,0"
				Text           = "3.$($i)    $($item)"
				ForeColor      = "#008000"
			}

			$LinkLabel_Tips = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "62,0,20,0"
				Text           = $($lang.$($item))
			}

			$LinkLabel_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 445
			}

			$UI_Main_Menu.controls.AddRange((
				$LinkLabel,
				$LinkLabel_Tips,
				$LinkLabel_Wrap
			))
		}
	}

	Refresh_Disk_Volume_UI

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$UI_Main.ShowDialog() | Out-Null
}

Function Refresh_Eject_Abandon_Agreement
{
	<#
		.是否接受协议
	#>
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Allow) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
			"True" {
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"False" {
				Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
				Eject_Abandon_Agreement
			}
		}
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		Eject_Abandon_Agreement
	}
}

Function Refresh_Eject_Abandon_NewDisk
{
	<#
		.获取允许格式化的磁盘
	#>
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Agreement_Disk_range) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Abandon_Disks" -ErrorAction SilentlyContinue) {
		$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Abandon_Disks" -ErrorAction SilentlyContinue
		$CustomRAMDISKLabel = $CustomRAMDISKLabel | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($CustomRAMDISKLabel.Count -gt 0) {
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
			Eject_Abandon_Agreement
		}
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		Eject_Abandon_Agreement
	}
}

Function Refresh_Eject_Abandon_Compatibility
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Accept" -ErrorAction SilentlyContinue) {
						"True" {
							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Abandon_Disks" -ErrorAction SilentlyContinue) {
								$CustomRAMDisk_Abandon_Disks = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Abandon_Disks" -ErrorAction SilentlyContinue
								$CustomRAMDisk_Abandon_Disks = $CustomRAMDisk_Abandon_Disks | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

								$WaitFormatTasks = @()

								Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
									if ($_.Label -eq $CustomRAMDISKLabel) {
										$WaitFormatTasks += [pscustomobject]@{
											Label = $CustomRAMDISKLabel
											DriveLetter = $_.DriveLetter.Replace(":", "")
										}
									}
								}

								if ($WaitFormatTasks.Count -gt 0) {
									<#
										.判断是否有可格式化的磁盘
									#>
									$Unauthorized = @()
									foreach ($item in $WaitFormatTasks) {
										if ($CustomRAMDisk_Abandon_Disks -notcontains $item.DriveLetter) {
											$Unauthorized += $item.DriveLetter
										}
									}

									if ($Unauthorized.Count -gt 0) {
										Write-Host "  " -NoNewline
										Write-Host " $($lang.Abandon_Terms) " -NoNewline -BackgroundColor White -ForegroundColor Black
										Write-Host " $($lang.Abandon_Terms_Change) " -BackgroundColor DarkRed -ForegroundColor White

										Eject_Abandon_Agreement
									}
								}
							}
						}
					}
				} else {
					$WaitFormatTasks = @()

					Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
						if ($_.Label -eq $CustomRAMDISKLabel) {
							$WaitFormatTasks += [pscustomobject]@{
								Label = $CustomRAMDISKLabel
								DriveLetter = $_.DriveLetter.Replace(":", "")
							}
						}
					}

					if ($WaitFormatTasks.Count -gt 0) {
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Tips_Abandon_Terms" -ErrorAction SilentlyContinue) {
							switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\RAMDisk" -Name "Tips_Abandon_Terms" -ErrorAction SilentlyContinue) {
								"True" {
									Eject_Abandon_Agreement
								}
								"False" {}
							}
						} else {
							Eject_Abandon_Agreement
						}
					}
				}
			}
		}
	}
}