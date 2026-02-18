<#
	.Export image source user interface
	.导出映像源用户界面
#>
Function Image_Select_Export_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = "$($lang.SelectSettingImage): $($lang.Export_Image)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
		Add_FormClosed = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 580
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "0,8,0,0"
		Dock           = 3
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips   = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 300
		Width          = 265
		BorderStyle    = 0
		Location       = "575,15"
		Text           = $lang.SelectTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "570,523"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "595,525"
		Height         = 30
		Width          = 255
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			<#
				.Reset selected
				.重置已选择
			#>
			$MarkSelectIndexin = @()

			$SearchImageSources = Join-Path -Path $Global:Image_source -ChildPath "Sources"
			if (Test-Path -Path $SearchImageSources -PathType Container) {
				$InitialPath = $SearchImageSources
			} else {
				$InitialPath = $Global:Image_source
			}

			<#
				.Mark: Check the selection status
				.标记：检查选择状态
			#>
	
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_.Enabled) {
					if ($_.Checked) {
						$MarkSelectIndexin += $_.Tag
					}
				}
			}

			if ($MarkSelectIndexin.Count -gt 0) {
				Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				ForEach ($item in $MarkSelectIndexin) {
					ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
						if ($item -eq $itemDetail.ImageIndex) {
							Write-Host "  $($lang.MountedIndex): " -NoNewline
							Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
							Write-Host $itemDetail.ImageName -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
							Write-Host $itemDetail.ImageDescription -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
							Write-Host $itemDetail.DISPLAYNAME -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
							Write-Host $itemDetail.DISPLAYDESCRIPTION -ForegroundColor Yellow

							Write-Host
						}
					}
				}

				Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				switch ($Global:Primary_Key_Image.Suffix) {
					"swm" {
						$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
							FileName         = "$($Global:Primary_Key_Image.ImageFileName).wim"
							Filter           = "Export WIM Files (*.wim;)|*.wim;"
							InitialDirectory = $InitialPath
						}

						if ($FileBrowser.ShowDialog() -eq "OK") {
							$UI_Main.Hide()
	
							ForEach ($item in $MarkSelectIndexin) {
								ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
									if ($item -eq $itemDetail.ImageIndex) {
										Write-Host "  $($lang.MountedIndex): " -NoNewline
										Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

										Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
										Write-Host $itemDetail.ImageName -ForegroundColor Yellow
	
										Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
										Write-Host $itemDetail.ImageDescription -ForegroundColor Yellow

										Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
										Write-Host $itemDetail.DISPLAYNAME -ForegroundColor Yellow

										Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
										Write-Host $itemDetail.DISPLAYDESCRIPTION -ForegroundColor Yellow

										Write-Host "  " -NoNewline
										Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
										try {
											dism /ScratchDir:"""$(Get_Mount_To_Temp)""" /LogPath:"$(Get_Mount_To_Logs)\Export.log" /export-image /SourceImageFile:"""$($Global:Primary_Key_Image.FullPath)""" /swmfile:"""$($Global:Primary_Key_Image.Path)\$($Global:Primary_Key_Image.ImageFileName)*.$($Global:Primary_Key_Image.Suffix)""" /SourceIndex:"""$($itemDetail.ImageIndex)""" /DestinationImageFile:"""$($FileBrowser.FileName)""" /Compress:max /CheckIntegrity
											Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
										} catch {
											Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
											Write-Host "  $($_)" -ForegroundColor Red
										}

										Write-Host
									}
								}
							}

							$UI_Main.Close()
						} else {
							Write-Host "  $($lang.UserCancel)"
						}
					}
					"esd" {
						$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
							FileName         = "$($Global:Primary_Key_Image.ImageFileName).wim"
							Filter           = "Export WIM Files (*.wim;)|*.wim;"
							InitialDirectory = $InitialPath
						}

						if ($FileBrowser.ShowDialog() -eq "OK") {
							$UI_Main.Hide()

							ForEach ($item in $MarkSelectIndexin) {
								ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
									if ($item -eq $itemDetail.ImageIndex) {
										Write-Host "  $($lang.MountedIndex): " -NoNewline
										Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

										Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
										Write-Host $itemDetail.ImageName -ForegroundColor Yellow

										Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
										Write-Host $itemDetail.ImageDescription -ForegroundColor Yellow

										if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
											Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
											Write-Host "  $('-' * 80)"
											Write-Host "  Export-WindowsImage -SourceImagePath ""$($Global:Primary_Key_Image.FullPath)"" -SourceIndex ""$($item)"" -DestinationImagePath ""$($FileBrowser.FileName)"" -CompressionType Max -CheckIntegrity" -ForegroundColor Green
											Write-Host "  $('-' * 80)"
										}

										Write-Host
										Write-Host "  " -NoNewline
										Write-Host " $($lang.Export_Image) " -NoNewline -BackgroundColor White -ForegroundColor Black
										try {
											Export-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Export.log" -SourceImagePath $Global:Primary_Key_Image.FullPath -SourceIndex $item -DestinationImagePath $FileBrowser.FileName -CompressionType Max -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
											Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
										} catch {
											Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
											Write-Host "  $($_)" -ForegroundColor Red
										}

										Write-Host
									}
								}
							}

							$UI_Main.Close()
						} else {
							Write-Host "  $($lang.UserCancel)"
						}
					}
					Default {
						$UI_Main.Hide()

						$TempReBuildWim = Join-Path -Path $Global:Image_source -ChildPath "Sources\ReBuild.wim"
						Remove-Item -Path $TempReBuildWim -ErrorAction SilentlyContinue

						Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						ForEach ($item in $MarkSelectIndexin) {
							ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
								if ($item -eq $itemDetail.ImageIndex) {
									Write-Host "  $($lang.MountedIndex): " -NoNewline
									Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
									Write-Host $itemDetail.ImageName -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
									Write-Host $itemDetail.ImageDescription -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
									Write-Host $itemDetail.DISPLAYNAME -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
									Write-Host $itemDetail.DISPLAYDESCRIPTION -ForegroundColor Yellow

									if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
										Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"
										Write-Host "  Export-WindowsImage -SourceImagePath ""$($Global:Primary_Key_Image.FullPath)"" -SourceIndex ""$($item)"" -DestinationImagePath ""$($TempReBuildWim)"" -CompressionType Max -CheckIntegrity" -ForegroundColor Green
										Write-Host "  $('-' * 80)"
									}

									Write-Host
									Write-Host "  " -NoNewline
									Write-Host " $($lang.Export_Image) " -NoNewline -BackgroundColor White -ForegroundColor Black
									try {
										Export-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Export.log" -SourceImagePath $Global:Primary_Key_Image.FullPath -SourceIndex $item -DestinationImagePath $TempReBuildWim -CompressionType Max -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
										Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
									} catch {
										Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
										Write-Host "  $($_)" -ForegroundColor Red
									}

									Write-Host
								}
							}
						}

						<#
							.导出，检查是否成功
						#>
						Write-Host "`n  $($lang.Wim_Rule_Verify)"
						Write-Host "  $('-' * 80)"
						Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
						Write-Host $TempReBuildWim -ForegroundColor Green

						Write-Host "  " -NoNewline
						Write-Host " $($lang.Wim_Rule_Verify) " -NoNewline -BackgroundColor White -ForegroundColor Black
						if (Test-Path -Path $TempReBuildWim -PathType Leaf) {
							Remove-Item -Path $Global:Primary_Key_Image.FullPath -ErrorAction SilentlyContinue
							Rename-Item -Path $TempReBuildWim -NewName $Global:Primary_Key_Image.FullPath -ErrorAction SilentlyContinue

							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} else {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						}

						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "04292024"

						$UI_Main.Close()
					}
				}
			} else {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
	))

	ForEach ($item in $Global:Primary_Key_Image.Index) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 35
			Width     = 460
			Padding   = "16,0,0,0"
			Text      = "$($lang.MountedIndex): $($item.ImageIndex)"
			Tag       = $item.ImageIndex
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
			autosize       = 1
			Padding        = "31,0,0,0"
			Text           = "$($lang.Wim_Edition): $($item.EditionId)"
		}
		$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}
		$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
			autosize       = 1
			Padding        = "31,0,0,0"
			Text           = "$($lang.Wim_Image_Name): $($item.ImageName)"
		}
		$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}
		$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
			autosize       = 1
			Padding        = "31,0,0,0"
			Text           = "$($lang.Wim_Image_Description): $($item.ImageDescription)"
		}
		$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}
		$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
			autosize       = 1
			Padding        = "31,0,0,0"
			Text           = "$($lang.Wim_Display_Name): $($item.DISPLAYNAME)"
		}
		$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}
		$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
			autosize       = 1
			Padding        = "31,0,0,0"
			Text           = "$($lang.Wim_Display_Description): $($item.DISPLAYDESCRIPTION)"
		}
		$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
		}

		$UI_Main_Menu.controls.AddRange((
			$CheckBox,
			$New_Wim_Edition,
			$New_Wim_Edition_Wrap,
			$New_Wim_Image_Name,
			$New_Wim_Image_Name_Wrap,
			$New_Wim_Image_Description,
			$New_Wim_Image_Description_Wrap,
			$New_Wim_Display_Name,
			$New_Wim_Display_Name_Wrap,
			$New_Wim_Display_Description,
			$New_Wim_Display_Description_Wrap
		))
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select

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