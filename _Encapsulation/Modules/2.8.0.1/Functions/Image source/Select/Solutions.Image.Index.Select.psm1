<#
	.Select the image source index number user interface
	.选择映像源索引号用户界面
#>
Function Image_Select_Index_UI
{
	param
	(
		$AutoSelectIndex
	)

	Write-Host "`n  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.事件：挂载
	#>
	Function Verify_Is_Select_New_Mount_Index
	{
		$UI_Main_Menu_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$UI_Main.Hide()

						ForEach ($item in $Global:Primary_Key_Image.Index) {
							if ($item.ImageIndex -eq $_.Tag) {
								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.ImageIndex -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.ImageName -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $item.ImageDescription -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
								Write-Host $item.DISPLAYNAME -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
								Write-Host $item.DISPLAYDESCRIPTION -ForegroundColor Yellow

								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 90" -ForegroundColor Green
								}

								$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

								if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
									if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
										Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"
										Write-Host "  Repair-WindowsImage -Path ""$($test_mount_folder_Current)"" -RestoreHealth" -ForegroundColor Green
										Write-Host "  $('-' * 80)`n"
									}

									Repair-WindowsImage -Path $test_mount_folder_Current -RestoreHealth -ErrorAction SilentlyContinue | Out-Null
									dism /cleanup-wim | Out-Null
									Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
									Remove_Tree $test_mount_folder_Current
								}

								Check_Folder -chkpath $test_mount_folder_Current

								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 91`n" -ForegroundColor Green
								}

								$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
								$Arguments = @(
									"-ImagePath"
									"""$($Global:Primary_Key_Image.FullPath)""",
									"-Path",
									"""$($test_mount_folder_Current)""",
									"-Index",
									"""$($_.Tag)"""
								)

								Write-Host "`n  $($lang.SelectSettingImage)" -ForegroundColor Yellow
								Write-Host "  $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Green

								Write-Host "`n  $($lang.MountedIndex)" -ForegroundColor Yellow
								Write-Host "  $($_.Tag)" -ForegroundColor Green

								Write-Host "`n  $($lang.Wim_Rule_ReadOnly)" -ForegroundColor Yellow
								if ($UI_Main_Select_Adv_ReadOnly.Checked) {
									Write-Host "  $($lang.Operable)" -ForegroundColor Green
									$Arguments += "-ReadOnly"
								} else {
									Write-Host "  $($lang.NoWork)" -ForegroundColor Red
								}

								Write-Host "`n  $($lang.Wim_Rule_Optimize)" -ForegroundColor Yellow
								if ($UI_Main_Select_Adv_Optimize.Checked) {
									Write-Host "  $($lang.Operable)" -ForegroundColor Green
									$Arguments += "-Optimize"
								} else {
									Write-Host "  $($lang.NoWork)" -ForegroundColor Red
								}

								Write-Host "`n  $($lang.Wim_Rule_CheckIntegrity)" -ForegroundColor Yellow
								if ($UI_Main_Select_Adv_CheckIntegrity.Checked) {
									Write-Host "  $($lang.Operable)" -ForegroundColor Green
									$Arguments += "-CheckIntegrity"
								} else {
									Write-Host "  $($lang.NoWork)" -ForegroundColor Red
								}

								Write-Host "`n  $($lang.Wim_Rule_SupportEa)" -ForegroundColor Yellow
								if ($UI_Main_Select_Adv_SupportEa.Checked) {
									Write-Host "  $($lang.Operable)" -ForegroundColor Green
									$Arguments += "-SupportEa"
								} else {
									Write-Host "  $($lang.NoWork)" -ForegroundColor Red
								}

								Write-Host "`n  $($lang.MountImageTo)" -ForegroundColor Yellow
								Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Green

								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Mount-WindowsImage $($Arguments)" -ForegroundColor Green
									Write-Host "  $('-' * 80)"
								}

								Write-Host
								Write-Host "  " -NoNewline
								Write-Host " $($lang.Mount) " -NoNewline -BackgroundColor White -ForegroundColor Black
								try {
									Invoke-Expression -Command "Mount-WindowsImage -ScratchDirectory ""$(Get_Mount_To_Temp)"" -LogPath ""$(Get_Mount_To_Logs)\Expand.log"" $($Arguments)"
									Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
								} catch {
									Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
									Write-Host "  $($_)" -ForegroundColor Red
								}
							}
						}

						$UI_Main.Close()
					}
				}
			}
		}

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
	}

	<#
		.事件：应用映像
	#>
	Function Refres_Image_Apply_Detial
	{
		param
		(
			$Index
		)

		<#
			.清除所有旧的信息
		#>
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UIUnzipPanel_To_Path.Text = ""
		$UI_Main_Apply_Image_Index_Name.Text = $lang.MountedIndex
		$UI_Main_Apply_Image_Index_Name.Tag = ""
		$UI_Main_Apply_Language.Text = $lang.Language
		$UI_Main_Apply_Image_Name.Text = $lang.Wim_Image_Name
		$UI_Main_Apply_Image_Description.Text = $lang.Wim_Image_Description
		$UI_Main_Apply_Display_Name.Text = $lang.Wim_Display_Name
		$UI_Main_Apply_Display_Description.Text = $lang.Wim_Display_Description
		$UI_Main_Apply_Edition.Text = $lang.Wim_Edition
		$UI_Main_Apply_Architecture.Text = $lang.Architecture
		$UI_Main_Apply_Created.Text = $lang.Wim_CreatedTime
		$UI_Main_Apply_ModifiedTime.Text = $lang.Wim_ModifiedTime
		$UI_Main_Apply_FileCount.Text = $lang.Wim_FileCount
		$UI_Main_Apply_DirectoryCount.Text = $lang.Wim_DirectoryCount
		$UI_Main_Apply_Expander_Space.Text = $lang.Wim_Expander_Space
		$UI_Main_Apply_System_Version.Text = $lang.Editions

		ForEach ($item in $Global:Primary_Key_Image.Index) {
			if ($item.ImageIndex -eq $index) {
				$UIUnzipPanel_To_Path.Text = $Global:Primary_Key_Image.FullPath

				<#
					.索引号
				#>
				$UI_Main_Apply_Image_Index_Name.Text = "$($lang.MountedIndex): $($item.ImageIndex)"
				$UI_Main_Apply_Image_Index_Name.Tag = $item.ImageIndex

				<#
					.语言
				#>
				$UI_Main_Apply_Language.Text = "$($lang.Language): $($item.Language)"

				<#
					.映像名称
				#>
				$UI_Main_Apply_Image_Name.Text = "$($lang.Wim_Image_Name): $($item.ImageName)"

				<#
					.映像描述
				#>
				$UI_Main_Apply_Image_Description.Text = "$($lang.Wim_Image_Description): $($item.ImageDescription)"

				<#
					.显示名称
				#>
				$UI_Main_Apply_Display_Name.Text = "$($lang.Wim_Display_Name): $($item.DISPLAYNAME)"

				<#
					.显示说明
				#>
				$UI_Main_Apply_Display_Description.Text = "$($lang.Wim_Display_Description): $($item.DISPLAYDESCRIPTION)"

				<#
					.映像标志
				#>
				$UI_Main_Apply_Edition.Text = "$($lang.Wim_Edition): $($item.EditionId)"

				<#
					.架构
				#>
				switch ($item.Architecture) {
					0 {
						$New_Architecture = "x86"
					}
					9 {
						$New_Architecture = "x64"
					}
					Default 
					{
						$New_Architecture = "arm64"
					}
				}
				$UI_Main_Apply_Architecture.Text = "$($lang.Architecture): $($New_Architecture)"

				<#
					.创建日期
				#>
				$UI_Main_Apply_Created.Text = "$($lang.Wim_CreatedTime): $($item.CreatedTime)"

				<#
					.上次修改时间
				#>
				$UI_Main_Apply_ModifiedTime.Text = "$($lang.Wim_ModifiedTime): $($item.LastModifiTime)"

				<#
					.文件数目
				#>
				$UI_Main_Apply_FileCount.Text = "$($lang.Wim_FileCount): $($item.FILECOUNT)"

				<#
					.目录数目
				#>
				$UI_Main_Apply_DirectoryCount.Text = "$($lang.Wim_DirectoryCount): $($item.DirectoryCount)"

				<#
					.展开空间
				#>
				$UI_Main_Apply_Expander_Space.Text = "$($lang.Wim_Expander_Space): $(ConvertFrom-Bytes -Bytes $item.ImageSize)"

				<#
					.系统版本
				#>
				$UI_Main_Apply_System_Version.Text = "$($lang.Editions): $($item.Version)"
			}
		}

		$UI_Main_Apply_Detailed.Visible = $True
	}

	<#
		.事件：查看详细内容
	#>
	Function Wimlib_Image_Edit_Index_Detial
	{
		param
		(
			$Index
		)

		<#
			.清除所有旧的信息
		#>
		$UI_Main_Mask_Rule_Wim_Image_Index.Text = ""
		$UI_Main_Mask_Rule_Wim_Image_Name_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Image_Description_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Display_Name_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Display_Description_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = ""

		$UI_Main_Mask_Rule_Wim_Edition_Select.SelectedIndex = -1
		$UI_Main_Mask_Rule_Wim_Edition_Select.Text = ""

		$UI_Main_Mask_Rule_Wim_Architecture.Text = $lang.Architecture
		$UI_Main_Mask_Rule_Wim_Language.Text = $lang.Language
		$UI_Main_Mask_Rule_Wim_CreatedTime.Text = $lang.Wim_CreatedTime
		$UI_Main_Mask_Rule_Wim_ModifiedTime.Text = $lang.Wim_ModifiedTime
		$UI_Main_Mask_Rule_Wim_FileCount.Text = $lang.Wim_FileCount
		$UI_Main_Mask_Rule_Wim_DirectoryCount.Text = $lang.Wim_DirectoryCount
		$UI_Main_Mask_Rule_Wim_Expander_Space.Text = $lang.Wim_Expander_Space
		$UI_Main_Mask_Rule_Wim_System_Version.Text = ""

		ForEach ($item in $Global:Primary_Key_Image.Index) {
			if ($item.ImageIndex -eq $index) {
				<#
					.映像路径
				#>
				$UI_Main_Mask_Rule_Wim_Image_Path.Text = $Global:Primary_Key_Image.FullPath

				<#
					.索引号
				#>
				$UI_Main_Mask_Rule_Wim_Image_Index.Text = $item.ImageIndex

				<#
					.映像名称
				#>
				$UI_Main_Mask_Rule_Wim_Image_Name_Edit.Text = $item.ImageName

				<#
					.映像说明
				#>
				$UI_Main_Mask_Rule_Wim_Image_Description_Edit.Text = $item.ImageDescription

				<#
					.显示名称
				#>
				$UI_Main_Mask_Rule_Wim_Display_Name_Edit.Text = $item.DISPLAYNAME

				<#
					.显示说明
				#>
				$UI_Main_Mask_Rule_Wim_Display_Description_Edit.Text = $item.DISPLAYDESCRIPTION

				<#
					.映像标志
				#>
				$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $item.EditionId
				$UI_Main_Mask_Rule_Wim_Edition_Select.SelectedIndex = $UI_Main_Mask_Rule_Wim_Edition_Select.FindString($item.EditionId)

				<#
					.架构
				#>
				switch ($item.Architecture) {
					0 {
						$New_Architecture = "x86"
					}
					9 {
						$New_Architecture = "x64"
					}
					Default 
					{
						$New_Architecture = "arm64"
					}
				}
				$UI_Main_Mask_Rule_Wim_Architecture.Text = "$($lang.Architecture): $($New_Architecture)"

				<#
					.语言
				#>
				$UI_Main_Mask_Rule_Wim_Language.Text = "$($lang.Language): $($item.Language)"

				<#
					.创建日期
				#>
				$UI_Main_Mask_Rule_Wim_CreatedTime.Text = "$($lang.Wim_CreatedTime): $($item.CreatedTime)"

				<#
					.上次修改时间
				#>
				$UI_Main_Mask_Rule_Wim_ModifiedTime.Text = "$($lang.Wim_ModifiedTime): $($item.LastModifiTime)"

				<#
					.文件数目
				#>
				$UI_Main_Mask_Rule_Wim_FileCount.Text = "$($lang.Wim_FileCount): $($item.FILECOUNT)"

				<#
					.目录数目
				#>
				$UI_Main_Mask_Rule_Wim_DirectoryCount.Text = "$($lang.Wim_DirectoryCount): $($item.DirectoryCount)"

				<#
					.展开空间
				#>

				$UI_Main_Mask_Rule_Wim_Expander_Space.Text = "$($lang.Wim_Expander_Space): $(ConvertFrom-Bytes -Bytes $item.ImageSize)"

				<#
					.系统版本
				#>
				$UI_Main_Mask_Rule_Wim_System_Version.Text = "$($lang.Editions): $($item.Version)"
			}
		}

		$UI_Main_Mask_Rule_Detailed.Visible = $True
	}

	<#
		.刷新
	#>
	Function Wimlib_Image_Refresh_Details_Rule
	{
		param
		(
			[switch]$Refresh
		)

		[PSCustomObject]$EditionIDError = @()

		if ($Refresh) {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "25"
		}
		$UI_Main_Menu_Select.controls.clear()

		ForEach ($item in $Global:Primary_Key_Image.Index) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 35
				Width     = 510
				Text      = "$($lang.MountedIndex): $($item.ImageIndex)"
				Tag       = $item.ImageIndex
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "15,0,0,0"
				Text           = "$($lang.Wim_Edition): $($item.EditionId)"
			}
			$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 510
			}

			$UI_Main_Menu_Select.controls.AddRange((
				$CheckBox,
				$New_Wim_Edition,
				$New_Wim_Edition_Wrap
			))

			if ($item.FLAGS -eq $item.EditionId) {
			} else {
				$EditionIDError += [pscustomobject]@{
					Index     = $item.ImageIndex
					Name      = $item.ImageName
					FLAGS     = $item.FLAGS
					EditionID = $item.EditionId
				}

				$New_Wim_Edition_Error = New-Object system.Windows.Forms.Label -Property @{
					autosize       = 1
					Padding        = "15,0,0,0"
					Text           = "$($lang.AE_New_EditionID): $($item.FLAGS) < $($lang.Prerequisite_Not_satisfied)"
				}
				$New_Wim_Edition_Error_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 10
					Width          = 460
				}

				$UI_Main_Menu_Select.controls.AddRange((
					$New_Wim_Edition_Error,
					$New_Wim_Edition_Error_Wrap,
					$New_Wim_Image_Name,
					$New_Wim_Image_Name_Wrap
				))
			}

			$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "15,0,0,0"
				Text           = "$($lang.Wim_Image_Name): $($item.ImageName)"
			}
			$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 510
			}

			$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "15,0,0,0"
				Text           = "$($lang.Wim_Image_Description): $($item.ImageDescription)"
			}
			$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 510
			}
			$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "15,0,0,0"
				Text           = "$($lang.Wim_Display_Name): $($item.DISPLAYNAME)"
			}
			$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 510
			}
			$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "15,0,0,0"
				Text           = "$($lang.Wim_Display_Description): $($item.DISPLAYDESCRIPTION)"
			}
			$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 510
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 510
				Padding        = "15,0,0,0"
				Text           = $lang.Detailed_View
				Tag            = $item.ImageIndex
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					Wimlib_Image_Edit_Index_Detial -Index $this.Tag
				}
			}
			$New_End_Wrap      = New-Object system.Windows.Forms.Label -Property @{
				Height         = 20
				Width          = 510
			}

			$UI_Main_Menu_Select.controls.AddRange((
				$New_Wim_Image_Description,
				$New_Wim_Image_Description_Wrap,
				$New_Wim_Display_Name,
				$New_Wim_Display_Name_Wrap,
				$New_Wim_Display_Description,
				$New_Wim_Display_Description_Wrap,
				$UI_Main_Rule_Details_View,
				$New_End_Wrap
			))

			if ($EditionIDError.count -gt 0 ) {
				$UI_Main_View_Detailed_History.Visible = $True

				foreach ($Report in $EditionIDError) {
					$UI_Main_View_Detailed_Show.Text = $lang.EditionErrorNoMatch -f $EditionIDError.count
					$UI_Main_View_Detailed_Show.Text += "`n$('-' * 80)`n"

					$UI_Main_View_Detailed_Show.Text += "   $($lang.MountedIndex): $($Report.Index)`n"
					$UI_Main_View_Detailed_Show.Text += "   $($lang.Wim_Image_Name): $($Report.Name)`n"
					$UI_Main_View_Detailed_Show.Text += "   $($lang.AE_New_EditionID): $($Report.FLAGS)`n"
					$UI_Main_View_Detailed_Show.Text += "   $($lang.Wim_Edition): $($Report.EditionID)`n"
					$UI_Main_View_Detailed_Show.Text += "   $($lang.Prerequisite_Not_satisfied): $($Report.FLAGS) / $($Report.EditionID)`n`n"
				}

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
				$UI_Main_Error.Text = $lang.EditionErrorNoMatch -f $EditionIDError.count
			}
		}

		<#
			.非 install.wim 时，禁用其它功能，和显示解锁按钮
		#>
		switch ($Global:Primary_Key_Image.Uid) {
			"Boot;wim;Boot;wim;" {
				$UI_Main_Image_Add.Enabled = $False           # 添加
				$UI_Main_Image_Del.Enabled = $False           # 删除
				$UI_Main_Tips.Visible = $True
			}
			"install;swm;install;swm;" {
				$UI_Main_Mount.Visible = $False
				$UI_Main_Image_Add.Enabled = $False           # 添加
				$UI_Main_Image_Del.Enabled = $True            # 删除
				$UI_Main_Rebuild_All.Enabled = $False         # 重建
			}
		}

		<#
			.判断是否有扩展项，有则启用：提取、更新 WIM 内的文件
		#>
		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
					if ($item.Expand.Count -gt 0) {
						$UI_Main_Image_WIM_Update.Enabled = $True
					}
				}

				if ($item.Expand.Count -gt 0) {
					if ($item.Expand.Uid -eq $Global:Primary_Key_Image.Uid) {
						if ($item.Expand.Expand.Count -gt 0) {
							$UI_Main_Image_WIM_Update.Enabled = $True
						}
					}
				}
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.SelectSettingImage): $($lang.MountedIndexSelect)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $true
		ControlBox     = $true
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 550
		autoSizeMode   = 1
		Padding        = "15,20,0,0"
		autoScroll     = $True
		dock	       = 3
	}

	<#
		.可选功能
	#>
	$UI_Main_Select_Adv_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Text           = $lang.AdvOption
	}

	<#
		.只读权限
	#>
	$UI_Main_Select_Adv_ReadOnly = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 510
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_ReadOnly
	}

	<#
		.优化
	#>
	$UI_Main_Select_Adv_Optimize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 510
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_Optimize
	}

	<#
		.检查完整性
	#>
	$UI_Main_Select_Adv_CheckIntegrity = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 510
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_CheckIntegrity
		Checked        = $True
	}

	<#
		.应用带有扩展属性的图像
	#>
	$UI_Main_Select_Adv_SupportEa = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 510
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_SupportEa
	}

	$UI_Main_Menu_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		margin         = "0,35,0,0"
		autoScroll     = $False
	}

	$UI_Main_Select_Adv_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
	}

	<#
		.Mask: Apply image
		.蒙板：应用映像
	#>
	$UI_Main_Apply_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Apply_Menu = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	<#
		.映像源
	#>
	$UIUnzipPanel_To   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.SelectSettingImage
	}
	$UIUnzipPanel_To_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "22,0,0,35"
		Text           = ""
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.目的地
	#>
	$GUIImageSourceISOSaveTo = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Destination
	}
	$GUIImageSourceISOCustomizePath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "18,0,0,25"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.事件：目地的，选择目录
	#>
	$GUIImageSourceISOCustomizePathSelect = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$GUIImageSourceISOCustomizePath.Text = $FolderBrowser.SelectedPath
				} else {
					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Apply_Detailed_Error.Text = $lang.FailedCreateFolder
				}
			} else {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = $lang.UserCanel
			}
		}
	}

	<#
		.事件：目地的，打开目录
	#>
	$GUIImageSourceISOCustomizePathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
			} else {
				if (Test-Path -Path $GUIImageSourceISOCustomizePath.Text -PathType Container) {
					Start-Process $GUIImageSourceISOCustomizePath.Text

					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Apply_Detailed_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
				} else {
					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Apply_Detailed_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				}
			}
		}
	}

	<#
		.事件：目地的，复制路径
	#>
	$GUIImageSourceISOCustomizePathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $GUIImageSourceISOCustomizePath.Text

				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.可选功能
	#>
	$UI_Main_Apply_Adv = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.验证
	#>
	$UI_Main_Apply_Verify = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_Check
		Checked        = $True
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.检查完整性
	#>
	$UI_Main_Apply_CheckIntegrity = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_CheckIntegrity
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.可启动
	#>
	$UI_Main_Apply_WIMBoot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_WIMBoot
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.Compact
	#>
	$UI_Main_Apply_Compact = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_Compact
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.显示详细信息，控件
	#>
	<#
		.可选功能
	#>
	$UI_Main_Apply_Select_Detailed = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.Detailed
	}

	<#
		.索引号
	#>
	$UI_Main_Apply_Image_Index_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.MountedIndex
		Tag            = ""
		Padding        = "18,0,0,0"
	}

	<#
		.映像名称
	#>
	$UI_Main_Apply_Image_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Image_Name
		Padding        = "18,0,0,0"
	}

	<#
		.映像说明
	#>
	$UI_Main_Apply_Image_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Image_Description
		Padding        = "18,0,0,0"
	}

	<#
		.显示名称
	#>
	$UI_Main_Apply_Display_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Display_Name
		Padding        = "18,0,0,0"
	}

	<#
		.显示说明
	#>
	$UI_Main_Apply_Display_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Display_Description
		Padding        = "18,0,0,0"
	}

	<#
		.映像标志
	#>
	$UI_Main_Apply_Edition = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Edition
		Padding        = "18,0,0,0"
	}

	<#
		.语言
	#>
	$UI_Main_Apply_Language = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Language
		Padding        = "18,0,0,0"
	}

	<#
		.架构
	#>
	$UI_Main_Apply_Architecture = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Architecture
		Padding        = "18,0,0,0"
	}

	<#
		.创建日期
	#>
	$UI_Main_Apply_Created = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_CreatedTime
		Padding        = "18,0,0,0"
	}

	<#
		.创建日期
	#>
	$UI_Main_Apply_ModifiedTime = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_ModifiedTime
		Padding        = "18,0,0,0"
	}

	<#
		.文件数目
	#>
	$UI_Main_Apply_FileCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_FileCount
		Padding        = "18,0,0,0"
	}

	<#
		.目录数目
	#>
	$UI_Main_Apply_DirectoryCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_DirectoryCount
		Padding        = "18,0,0,0"
	}

	<#
		.展开空间
	#>
	$UI_Main_Apply_Expander_Space = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Expander_Space
		Padding        = "18,0,0,0"
	}

	<#
		.系统版本
	#>
	$UI_Main_Apply_System_Version = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Editions
		Padding        = "18,0,0,0"
	}

	$UI_Main_Apply_Detailed_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,518"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Apply_Detailed_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,520"
		Height         = 30
		Width          = 275
		Text           = ""
	}
	$UI_Main_Apply_Detailed_Apply = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Apply
		add_Click      = {
			<#
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.Destination)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '^\s') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 3. No spaces at the end
				.判断：3. 后缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s$') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 4. There can be no two spaces in between
				.判断：4. 中间不能含有二个空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s{2,}') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 5. Cannot contain: \\ /: *? "" <> |
				.判断：5, 不能包含：\\ / : * ? "" < > |
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			if (Test_Available_Disk -Path $GUIImageSourceISOCustomizePath.Text) {
				$UI_Main.Hide()

				$Arguments = @(
					"-ImagePath"
					"""$($UIUnzipPanel_To_Path.Text)""",
					"-ApplyPath",
					"""$($GUIImageSourceISOCustomizePath.Text)""",
					"-Index",
					"""$($UI_Main_Apply_Image_Index_Name.Tag)"""
				)

				Write-Host "`n  $($lang.SelectSettingImage)" -ForegroundColor Yellow
				Write-Host "  $($UIUnzipPanel_To_Path.Text)" -ForegroundColor Green
				
				Write-Host "`n  $($lang.MountedIndex)" -ForegroundColor Yellow
				Write-Host "  $($UI_Main_Apply_Image_Index_Name.Tag)" -ForegroundColor Green

				Write-Host "`n  $($lang.Destination)" -ForegroundColor Yellow
				Write-Host "  $($GUIImageSourceISOCustomizePath.Text)" -ForegroundColor Green

				Write-Host "`n  $($lang.Wim_Rule_Verify)" -ForegroundColor Yellow
				if ($UI_Main_Apply_Verify.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-Verify"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.Wim_Rule_CheckIntegrity)" -ForegroundColor Yellow
				if ($UI_Main_Apply_CheckIntegrity.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-CheckIntegrity"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.可启动
				#>
				Write-Host "`n  $($lang.Wim_Rule_WIMBoot)" -ForegroundColor Yellow
				if ($UI_Main_Apply_WIMBoot.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-WIMBoot"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.Wim_Rule_Compact)" -ForegroundColor Yellow
				if ($UI_Main_Apply_Compact.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-Compact"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Expand-WindowsImage $($Arguments)" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				Write-Host "  " -NoNewline
				Write-Host " $($lang.apply) " -NoNewline -BackgroundColor White -ForegroundColor Black
				try {
					Invoke-Expression -Command "Expand-WindowsImage -ScratchDirectory ""$(Get_Mount_To_Temp)"" -LogPath ""$(Get_Mount_To_Logs)\Expand.log"" $($Arguments)"
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					Write-Host "  $($_)" -ForegroundColor Red
				}

				$UI_Main.Close()
			} else {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = $lang.ISOCreateFailed
			}
		}
	}
	$UI_Main_Apply_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Apply_Detailed.Visible = $False
		}
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Mask_Rule_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Rule_Detailed_Results = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	<#
		.显示详细信息，控件
	#>
	<#
		.映像路径
	#>
	$UI_Main_Mask_Rule_Wim_Image_Path_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.SelectSettingImage
	}
	$UI_Main_Mask_Rule_Wim_Image_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "22,0,0,35"
		Text           = ""
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.索引号
	#>
	$UI_Main_Mask_Rule_Wim_Image_Index_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.MountedIndex
	}
	$UI_Main_Mask_Rule_Wim_Image_Index = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.映像名称
	#>
	$UI_Main_Mask_Rule_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Image_Name
	}
	$UI_Main_Mask_Rule_Wim_Image_Name_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		BackColor      = "#FFFFFF"
	}

	<#
		.映像说明
	#>
	$UI_Main_Mask_Rule_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Image_Description
	}
	$UI_Main_Mask_Rule_Wim_Image_Description_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		BackColor      = "#FFFFFF"
	}

	<#
		.显示名称
	#>
	$UI_Main_Mask_Rule_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Display_Name
	}
	$UI_Main_Mask_Rule_Wim_Display_Name_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		BackColor      = "#FFFFFF"
	}

	<#
		.显示说明
	#>
	$UI_Main_Mask_Rule_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Display_Description
	}
	$UI_Main_Mask_Rule_Wim_Display_Description_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		BackColor      = "#FFFFFF"
	}

	<#
		.映像标志
	#>
	$UI_Main_Mask_Rule_Wim_Edition = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Edition
	}
	$UI_Main_Mask_Rule_Wim_Edition_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,25"
		BackColor      = "#FFFFFF"
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Wim_Edition_Select_Know
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 482
		Margin         = "40,0,0,35"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
			$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $this.Text
		}
	}
	foreach ($item in $Global:WindowsEdition) {
		$UI_Main_Mask_Rule_Wim_Edition_Select.Items.Add($item) | Out-Null
	}

	<#
		.架构
	#>
	$UI_Main_Mask_Rule_Wim_Architecture = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,12,0,12"
		Text           = $lang.Architecture
	}

	<#
		.语言
	#>
	$UI_Main_Mask_Rule_Wim_Language = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Language
	}

	<#
		.创建日期
	#>
	$UI_Main_Mask_Rule_Wim_CreatedTime = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_CreatedTime
	}

	<#
		.上次修改时间
	#>
	$UI_Main_Mask_Rule_Wim_ModifiedTime = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_ModifiedTime
	}

	<#
		.文件数目
	#>
	$UI_Main_Mask_Rule_Wim_FileCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_FileCount
		margin         = "2,0,0,12"
	}

	<#
		.目录数目
	#>
	$UI_Main_Mask_Rule_Wim_DirectoryCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_DirectoryCount
		margin         = "2,0,0,12"
	}

	<#
		.展开空间
	#>
	$UI_Main_Mask_Rule_Wim_Expander_Space = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_Expander_Space
	}

	<#
		.系统版本
	#>
	$UI_Main_Mask_Rule_Wim_System_Version = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Editions
	}

	$UI_Main_Mask_Rule_Detailed_Ok = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Wim_Rename
		add_Click      = {
			$UI_Main_Mask_Rule_Detailed.Visible = $False

			$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
			if (Test-Path -Path $wimlib -PathType Leaf) {
				$Arguments = "info ""$($Global:Primary_Key_Image.FullPath)"" $($UI_Main_Mask_Rule_Wim_Image_Index.Text) --image-property NAME=""$($UI_Main_Mask_Rule_Wim_Image_Name_Edit.Text)"" --image-property DESCRIPTION=""$($UI_Main_Mask_Rule_Wim_Image_Description_Edit.Text)"" --image-property DISPLAYNAME=""$($UI_Main_Mask_Rule_Wim_Display_Name_Edit.Text)"" --image-property DISPLAYDESCRIPTION=""$($UI_Main_Mask_Rule_Wim_Display_Description_Edit.Text)"" --image-property FLAGS=""$($UI_Main_Mask_Rule_Wim_Edition_Edit.Text)"""

				Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
			}

			Wimlib_Image_Refresh_Details_Rule -Refresh
		}
	}
	$UI_Main_Mask_Rule_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Mask_Rule_Detailed.Visible = $False
		}
	}

	<#
		.添加
	#>
	$UI_Main_Image_Add = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.AddTo
		add_Click      = {
			$UI_Main.Hide()
			Image_Select_Append_UI
			$UI_Main.Close()
		}
	}

	<#
		.删除
	#>
	$UI_Main_Image_Del = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.Del
		add_Click      = {
			$UI_Main.Hide()
			Image_Select_Del_UI
			$UI_Main.Close()
		}
	}

	<#
		.导出
	#>
	$UI_Main_Export_Image = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,90"
		Height         = 36
		Width          = 280
		Text           = $lang.Export_Image
		add_Click      = {
			$UI_Main.Hide()
			Image_Select_Export_UI
			$UI_Main.Close()
		}
	}

	<#
		.重建
	#>
	$UI_Main_Rebuild_All = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,130"
		Height         = 36
		Width          = 280
		Text           = $lang.RebuildAll
		add_Click      = {
			$UI_Main.Hide()
			Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
			$UI_Main.Close()
		}
	}

	<#
		.修改映像信息
	#>
	$UI_Main_Image_WIM_Update = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,170"
		Height         = 36
		Width          = 280
		Text           = $lang.Wim_Rule_Update
		Enabled        = $False
		add_Click      = {
			$UI_Main.Hide()
			Wimlib_Extract_And_Update
			$UI_Main.Close()
		}
	}

	<#
		.不可操作时，可选按钮：解锁
	#>
	$UI_Main_Tips      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 200
		Width          = 280
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Padding        = "8,8,8,8"
		Location       = "620,220"
		Visible        = $False
	}
	$UI_Main_Tips_Show = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.SolutionsToError
	}
	$UI_Main_Unlock    = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 300
		Text           = $lang.UnlockBoot
		Location       = '88,8'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Tips.Visible = $False

			$UI_Main_Image_Add.Enabled = $True
			$UI_Main_Export_Image.Enabled = $True
			$UI_Main_Image_Del.Enabled = $True
			$UI_Main_Image_WIM_Update.Enabled = $True
		}
	}

	$UI_Main_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_View_Detailed_Show = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_View_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $False
		}
	}
	$UI_Main_View_Detailed_History = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = "620,465"
		Text           = $lang.History_View
		Visible        = $False
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $True
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,513"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,515"
		Height         = 70
		Width          = 255
		Text           = ""
	}
	$UI_Main_Apply     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Apply
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null

			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$Temp_Select_Index = $False
			$UI_Main_Menu_Select.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Temp_Select_Index = $true
							Refres_Image_Apply_Detial -Index $_.Tag
							return
						}
					}
				}
			}

			if ($Temp_Select_Index) {

			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main_Mount     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Mount
		add_Click      = { Verify_Is_Select_New_Mount_Index }
	}
	$UI_Main.controls.AddRange((
		$UI_Main_View_Detailed,
		$UI_Main_Mask_Rule_Detailed,
		$UI_Main_Apply_Detailed,
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Image_Add,
		$UI_Main_Image_Del,
		$UI_Main_Image_WIM_Update,
		$UI_Main_Rebuild_All,
		$UI_Main_Export_Image,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Apply,
		$UI_Main_Mount,
		$UI_Main_View_Detailed_History
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Select_Adv_Name,
		$UI_Main_Select_Adv_ReadOnly,
		$UI_Main_Select_Adv_Optimize,
		$UI_Main_Select_Adv_CheckIntegrity,
		$UI_Main_Select_Adv_SupportEa,
		$UI_Main_Menu_Select,
		$UI_Main_Select_Adv_Warp
	))
	$UI_Main_Tips.controls.AddRange((
		$UI_Main_Tips_Show,
		$UI_Main_Unlock
	))
	$UI_Main_Apply_Detailed.controls.AddRange((
		$UI_Main_Apply_Menu,
		$UI_Main_Apply_Detailed_Error_Icon,
		$UI_Main_Apply_Detailed_Error,
		$UI_Main_Apply_Detailed_Apply,
		$UI_Main_Apply_Detailed_Canel
	))
	$UI_Main_Apply_Menu.controls.AddRange((
		$UIUnzipPanel_To,
		$UIUnzipPanel_To_Path,
		$GUIImageSourceISOSaveTo,
		$GUIImageSourceISOCustomizePath,
		$GUIImageSourceISOCustomizePathSelect,
		$GUIImageSourceISOCustomizePathOpen,
		$GUIImageSourceISOCustomizePathPaste,

		$UI_Main_Apply_Adv,
		$UI_Main_Apply_Verify,
		$UI_Main_Apply_CheckIntegrity,
		$UI_Main_Apply_WIMBoot,
		$UI_Main_Apply_Compact,

		$UI_Main_Apply_Select_Detailed,
		$UI_Main_Apply_Image_Index_Name,
		$UI_Main_Apply_Language,
		$UI_Main_Apply_System_Version,
		$UI_Main_Apply_Architecture,
		$UI_Main_Apply_Image_Name,
		$UI_Main_Apply_Image_Description,
		$UI_Main_Apply_Display_Name,
		$UI_Main_Apply_Display_Description,
		$UI_Main_Apply_Edition,
		$UI_Main_Apply_Created,
		$UI_Main_Apply_ModifiedTime,
		$UI_Main_Apply_FileCount,
		$UI_Main_Apply_DirectoryCount,
		$UI_Main_Apply_Expander_Space
	))

	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_Mask_Rule_Detailed_Ok,
		$UI_Main_Mask_Rule_Detailed_Canel
	))
	$UI_Main_Mask_Rule_Detailed_Results.controls.AddRange((
		$UI_Main_Mask_Rule_Wim_Image_Path_Name,
		$UI_Main_Mask_Rule_Wim_Image_Path,
		$UI_Main_Mask_Rule_Wim_Image_Index_Name,
		$UI_Main_Mask_Rule_Wim_Image_Index,
		$UI_Main_Mask_Rule_Wim_Image_Name,
		$UI_Main_Mask_Rule_Wim_Image_Name_Edit,
		$UI_Main_Mask_Rule_Wim_Image_Description,
		$UI_Main_Mask_Rule_Wim_Image_Description_Edit,
		$UI_Main_Mask_Rule_Wim_Display_Name,
		$UI_Main_Mask_Rule_Wim_Display_Name_Edit,
		$UI_Main_Mask_Rule_Wim_Display_Description,
		$UI_Main_Mask_Rule_Wim_Display_Description_Edit,
		$UI_Main_Mask_Rule_Wim_Edition,
		$UI_Main_Mask_Rule_Wim_Edition_Edit,
		$UI_Main_Mask_Rule_Wim_Edition_Select_Tips,
		$UI_Main_Mask_Rule_Wim_Edition_Select,
		$UI_Main_Mask_Rule_Wim_Architecture,
		$UI_Main_Mask_Rule_Wim_Language,
		$UI_Main_Mask_Rule_Wim_CreatedTime,
		$UI_Main_Mask_Rule_Wim_ModifiedTime,
		$UI_Main_Mask_Rule_Wim_FileCount,
		$UI_Main_Mask_Rule_Wim_DirectoryCount,
		$UI_Main_Mask_Rule_Wim_Expander_Space,
		$UI_Main_Mask_Rule_Wim_System_Version
	))

	Wimlib_Image_Refresh_Details_Rule

	if (Verify_Is_Current_Same) {
		$UI_Main_Image_Add.Enabled = $False
		$UI_Main_Image_Del.Enabled = $False
		$UI_Main_Export_Image.Enabled = $False
		$UI_Main_Rebuild_All.Enabled = $False
		$UI_Main_Image_WIM_Update.Enabled = $False      # 提取，更新映像内文件

		Write-Host "  $($lang.Mounted)" -ForegroundColor Green
		$UI_Main_Mount.Enabled = $False
		$UI_Main_Mask_Rule_Detailed_Ok.Enabled = $False
	}

	if ($Global:Primary_Key_Image.Index.Count -gt 0) {
	} else {
		$UI_Main_Image_Add.Enabled = $False
		$UI_Main_Image_Del.Enabled = $False
		$UI_Main_Image_WIM_Update.Enabled = $False      # 提取，更新映像内文件
		$UI_Main_Rebuild_All.Enabled = $False
		$UI_Main_Export_Image.Enabled = $False
		$UI_Main_Mount.Enabled = $False

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.Inoperable)"
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$IsNumber = [int]::TryParse($AutoSelectIndex, [ref]$null)
	if ($IsNumber) {
		$Get_Current_All_Index = @()
		$UI_Main_Menu_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				$Get_Current_All_Index += $_.Tag

				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Tag -eq $AutoSelectIndex) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}
		}

		if ($Get_Current_All_Index -contains $AutoSelectIndex) {
			Verify_Is_Select_New_Mount_Index
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = $lang.AutoSelectIndexFailed -f $AutoSelectIndex

			$UI_Main.ShowDialog() | Out-Null
		}
		return
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}