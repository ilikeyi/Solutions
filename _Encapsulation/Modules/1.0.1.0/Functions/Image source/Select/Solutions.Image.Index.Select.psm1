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
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$UI_Main.Hide()

						ForEach ($item in $Global:Primary_Key_Image.Index) {
							if ($item.ImageIndex -eq $_.Tag) {
								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.ImageName -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.ImageIndex -ForegroundColor Yellow

								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 90`n" -ForegroundColor Green
								}

								$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

								if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
									if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
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

								$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Mount-WindowsImage -ImagePath ""$($Global:Primary_Key_Image.FullPath)"" -Index ""$($_.Tag)"" -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
									Write-Host "  $('-' * 80)`n"
								}

								Write-Host "  $($lang.Mount): " -NoNewline
								try {
									Mount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Mount.log" -ImagePath $Global:Primary_Key_Image.FullPath -Index $_.Tag -Path $test_mount_folder_Current
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

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
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
		$UI_Main_Apply_Image_Name.Text = $lang.Wim_Image_Name
		$UI_Main_Apply_Image_Description.Text = $lang.Wim_Image_Description
		$UI_Main_Apply_Display_Name.Text = $lang.Wim_Display_Name
		$UI_Main_Apply_Display_Description.Text = $lang.Wim_Display_Description
		$UI_Main_Apply_Edition.Text = $lang.Wim_Edition
		$UI_Main_Apply_Architecture.Text = $lang.Architecture
		$UI_Main_Apply_Created.Text = $lang.Wim_Created
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
				$UI_Main_Apply_Created.Text = "$($lang.Wim_Created): $($item.CreatedTime)"

				<#
					.展开空间
				#>
				$UI_Main_Apply_Expander_Space.Text = "$($lang.Wim_Expander_Space): $($item.ImageSize)"

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
		$UI_Main_Mask_Rule_Wim_Created.Text = $lang.Wim_Created
		$UI_Main_Mask_Rule_Wim_Expander_Space.Text = $lang.Wim_Expander_Space
		$UI_Main_Mask_Rule_Wim_System_Version.Text = ""

		ForEach ($item in $Global:Primary_Key_Image.Index) {
			if ($item.ImageIndex -eq $index) {
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
					.创建日期
				#>
				$UI_Main_Mask_Rule_Wim_Created.Text = "$($lang.Wim_Created): $($item.CreatedTime)"

				<#
					.展开空间
				#>
				$UI_Main_Mask_Rule_Wim_Expander_Space.Text = "$($lang.Wim_Expander_Space): $($item.ImageSize)"

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

		if ($Refresh) {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "25"
		}
		$UI_Main_Menu.controls.clear()

		ForEach ($item in $Global:Primary_Key_Image.Index) {
			$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
				Height  = 55
				Width   = 528
				Text    = "$($lang.Wim_Image_Name): $($item.ImageName)`n$($lang.MountedIndex): $($item.ImageIndex)"
				Tag     = $item.ImageIndex
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 515
				Padding        = "0,0,0,0"
				Margin         = "18,5,0,25"
				Text           = $lang.Detailed_View
				Tag            = $item.ImageIndex
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					Wimlib_Image_Edit_Index_Detial -Index $this.Tag
				}
			}

			$UI_Main_Menu.controls.AddRange((
				$CheckBox,
				$UI_Main_Rule_Details_View
			))
		}

		<#
			.非 install.wim 时，禁用其它功能，和显示解锁按钮
		#>
		switch ($Global:Primary_Key_Image.Uid) {
			"boot;boot;wim;" {
				$UI_Main_Image_Add.Enabled = $False           # 添加
				$UI_Main_Image_Del.Enabled = $False           # 删除
				$UI_Main_Tips.Visible = $True
			}
			"install;install;esd;" {
				$UI_Main_Mount.Visible = $False
				$UI_Main_Image_Add.Enabled = $False           # 添加
				$UI_Main_Image_Del.Enabled = $True            # 删除
				$UI_Main_Rebuild_All.Enabled = $False         # 重建
			}
			"install;install;swm;" {
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
			if ($item.Main.Suffix -eq "wim") {
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
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
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
		Padding        = "8,0,8,0"
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
		Margin         = "20,0,0,35"
		Text           = ""
		ReadOnly       = $True
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
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
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
					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Apply_Detailed_Error.Text = $lang.FailedCreateFolder
				}
			} else {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
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
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
			} else {
				if (Test-Path -Path $GUIImageSourceISOCustomizePath.Text -PathType Container) {
					Start-Process $GUIImageSourceISOCustomizePath.Text

					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Apply_Detailed_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
				} else {
					$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
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
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $GUIImageSourceISOCustomizePath.Text

				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
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
		Text           = $lang.Wim_Rule_Verify
		Checked        = $True
		add_Click      = {
			$GUIImageSourceISOCustomizePath.BackColor = "#FFFFFF"

			$UI_Main_Apply_Detailed_Error.Text = ""
			$UI_Main_Apply_Detailed_Error_Icon.Image = $null
		}
	}

	<#
		.检查
	#>
	$UI_Main_Apply_Check = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_Check
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
		Text           = $lang.Wim_Created
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
	$UI_Main_Apply_Detailed_Ok = New-Object system.Windows.Forms.Button -Property @{
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
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.Destination)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '^\s') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace))"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 3. No spaces at the end
				.判断：3. 后缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s$') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace))"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 4. There can be no two spaces in between
				.判断：4. 中间不能含有二个空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s{2,}') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace))"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 5. Cannot contain: \\ /: *? "" <> |
				.判断：5, 不能包含：\\ / : * ? "" < > |
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther))"
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
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.Wim_Rule_Check)" -ForegroundColor Yellow
				if ($UI_Main_Apply_Check.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-CheckIntegrity"
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.apply): " -NoNewline -ForegroundColor Yellow
				try {
					Invoke-Expression -Command "Expand-WindowsImage $($Arguments)"
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					Write-Host "  $($_)" -ForegroundColor Red
				}

				$UI_Main.Close()
			} else {
				$UI_Main_Apply_Detailed_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Apply_Detailed_Error.Text = $lang.ISOCreateFailed
			}
		}
	}
	$UI_Main_Apply_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
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
		Padding        = "8,0,8,0"
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
		.索引号
	#>
	$UI_Main_Mask_Rule_Wim_Image_Index_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.MountedIndex
	}
	$UI_Main_Mask_Rule_Wim_Image_Index = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 480
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
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
		Width          = 480
		Text           = ""
		margin         = "22,0,0,30"
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
		Width          = 480
		Text           = ""
		margin         = "22,0,0,30"
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
		Width          = 480
		Text           = ""
		margin         = "22,0,0,30"
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
		Width          = 480
		Text           = ""
		margin         = "22,0,0,30"
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
		Width          = 480
		Text           = ""
		margin         = "22,0,0,25"
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Wim_Edition_Select_Know
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 462
		Margin         = "40,0,0,35"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
			$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $this.Text
		}
	}
	$Edition = @(
		"EnterpriseS"
		"EnterpriseSN"
		"IoTEnterpriseS"
		"CloudEdition"
		"Core"
		"CoreSingleLanguage"
		"Education"
		"Professional"
		"ProfessionalEducation"
		"ProfessionalWorkstation"
		"Enterprise"
		"IoTEnterprise"
		"ServerRdsh"
		"CoreN"
		"EnterpriseN"
		"EnterpriseGN"
		"ProfessionalN"
		"EducationN"
		"ProfessionalWorkstationN"
		"ProfessionalEducationN"
		"CloudN"
		"CloudEN"
		"CloudEditionLN"
		"StarterN"
		"ServerStandardCore"
		"ServerStandard"
		"ServerDataCenterCore"
		"ServerDatacenter"
		"WindowsPE"
	)
	foreach ($item in $Edition) {
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
		.创建日期
	#>
	$UI_Main_Mask_Rule_Wim_Created = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_Created
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
		Text           = $lang.Cancel
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
			Image_Select_Add_UI
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
		Padding        = "8,0,8,0"
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
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Tips.Visible = $False

			$UI_Main_Image_Add.Enabled = $True
			$UI_Main_Export_Image.Enabled = $True
			$UI_Main_Image_Del.Enabled = $True
			$UI_Main_Image_WIM_Update.Enabled = $True
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,503"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,505"
		Height         = 45
		Width          = 255
		Text           = ""
	}
	$UI_Main_Apply     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,555"
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
			$UI_Main_Menu.Controls | ForEach-Object {
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
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main_Mount     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Mount
		add_Click      = { Verify_Is_Select_New_Mount_Index }
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
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
		$UI_Main_Canel
	))
	$UI_Main_Tips.controls.AddRange((
		$UI_Main_Tips_Show,
		$UI_Main_Unlock
	))
	$UI_Main_Apply_Detailed.controls.AddRange((
		$UI_Main_Apply_Menu,
		$UI_Main_Apply_Detailed_Error_Icon,
		$UI_Main_Apply_Detailed_Error,
		$UI_Main_Apply_Detailed_Ok,
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
		$UI_Main_Apply_Check,

		$UI_Main_Apply_Select_Detailed,
		$UI_Main_Apply_Image_Index_Name,
		$UI_Main_Apply_Image_Name,
		$UI_Main_Apply_Image_Description,
		$UI_Main_Apply_Display_Name,
		$UI_Main_Apply_Display_Description,
		$UI_Main_Apply_Edition,
		$UI_Main_Apply_Architecture,
		$UI_Main_Apply_Created,
		$UI_Main_Apply_Expander_Space,
		$UI_Main_Apply_System_Version
	))

	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_Mask_Rule_Detailed_Ok,
		$UI_Main_Mask_Rule_Detailed_Canel
	))
	$UI_Main_Mask_Rule_Detailed_Results.controls.AddRange((
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
		$UI_Main_Mask_Rule_Wim_Created,
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

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
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
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$IsNumber = [int]::TryParse($AutoSelectIndex, [ref]$null)
	if ($IsNumber) {
		$Get_Current_All_Index = @()
		$UI_Main_Menu.Controls | ForEach-Object {
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
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = $lang.AutoSelectIndexFailed -f $AutoSelectIndex

			$UI_Main.ShowDialog() | Out-Null
		}
		return
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.选择索引号，多
#>
Function Image_Select_Mul_UI
{
	param
	(
		$ImageFileName
	)

	Write-Host "`n  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = "$($lang.SelectSettingImage): $($lang.MountedIndexSelect)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 580
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,8,0,0"
		Dock           = 3
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips   = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 300
		Width          = 270
		BorderStyle    = 0
		Location       = "575,15"
		Text           = $lang.SelectTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '570,395'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "24" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '570,425'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.SuggestedSkip
		Location       = '570,390'
		add_Click      = {
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True" -String
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False" -String
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '586,426'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '586,455'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
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
		Location       = "570,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			<#
				.Reset selected
				.重置已选择
			#>
			$TempQueueProcessImageSelectPending = @()
			$MarkSelectIndexin = @()

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
				$UI_Main.Hide()

				ForEach ($item in $MarkSelectIndexin) {
					ForEach ($WildCard in (Get-Variable -Scope global -Name "Queue_Process_Image_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
						if ($item -eq $WildCard.Index) {
							$TempQueueProcessImageSelectPending += @{
								Name   = $WildCard.Name
								Index  = $WildCard.Index
							}
						}
					}
				}
				New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempQueueProcessImageSelectPending -Force

				ForEach ($item in $TempQueueProcessImageSelectPending) {
					Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
					Write-Host $item.Name -ForegroundColor Yellow

					Write-Host "  $($lang.MountedIndex): " -NoNewline
					Write-Host $item.Index -ForegroundColor Yellow

					Write-Host
				}

				if ($UI_Main_Suggestion_Not.Checked) {
					Init_Canel_Event -All
				}
				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$TempQueueProcessImageSelect = @()
	if (Test-Path -Path $ImageFileName -PathType Leaf) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 92`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($ImageFileName)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Get-WindowsImage -ImagePath $ImageFileName -ErrorAction SilentlyContinue | ForEach-Object {
				$TempQueueProcessImageSelect += @{
					Name   = $_.ImageName
					Index  = $_.ImageIndex
				}

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 55
					Width     = 450
					margin    = "0,0,0,18"
					Text      = "$($lang.Wim_Image_Name): $($_.ImageName)`n$($lang.MountedIndex): $($_.ImageIndex)"
					Tag       = $_.ImageIndex
					Checked   = $True
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Queue) {
					$CheckBox.Checked = $True
				}
				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($ImageFileName)"
			Write-Host "  $($_)" -ForegroundColor Yellow
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			return
		}
	}
	New-Variable -Scope global -Name "Queue_Process_Image_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempQueueProcessImageSelect -Force

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

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}
	
	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

		<#
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Suggestion_Not.Checked = $True
					$UI_Main_Suggestion_Setting.Enabled = $False
					$UI_Main_Suggestion_Stop.Enabled = $False
				}
				"False" {
					$UI_Main_Suggestion_Not.Checked = $False
					$UI_Main_Suggestion_Setting.Enabled = $True
					$UI_Main_Suggestion_Stop.Enabled = $True
				}
			}
		} else {
			$UI_Main_Suggestion_Not.Checked = $False
			$UI_Main_Suggestion_Setting.Enabled = $True
			$UI_Main_Suggestion_Stop.Enabled = $True
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
				$UI_Main.controls.AddRange((
					$UI_Main_Suggestion_Not,
					$UI_Main_Suggestion_Setting,
					$UI_Main_Suggestion_Stop
				))
			}
		}
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$UI_Main.ShowDialog() | Out-Null
}