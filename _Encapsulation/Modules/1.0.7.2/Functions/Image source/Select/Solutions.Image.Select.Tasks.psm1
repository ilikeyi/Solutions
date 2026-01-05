<#
	.Select the image source index number user interface
	.选择映像源索引号用户界面
#>
Function Image_Select_Tasks_UI
{
	param
	(
		$Go,
		[switch]$IsEvent
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.Ok_Go_To
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 550
		autoSizeMode   = 1
		Location       = '0,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	$UI_Primary_Key_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 585
		Width          = 280
		autoSizeMode   = 1
		Location       = '620,15'
		autoScroll     = $True
	}

	#region View Details
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
		}
	}
	$UI_Main_Mask_Rule_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Mask_Rule_Detailed.Visible = $False
		}
	}
	#endregion

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,613"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,615"
		Height         = 60
		Width          = 255
		Text           = ""
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed,
		$UI_Main_Menu,
		$UI_Primary_Key_Select,
		$UI_Main_Error_Icon,
		$UI_Main_Error
	))
	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_Mask_Rule_Detailed_Ok,
		$UI_Main_Mask_Rule_Detailed_Hide
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

	Function New_Image_Select_Tasks_View
	{
		param (
			$ImageFilePath
		)

		$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
		if (Test-Path -Path $wimlib -PathType Leaf) {
			$LabelNewFilename = New-Object system.Windows.Forms.Label -Property @{
				AutoSize       = 1
				Padding        = "16,0,0,0"
				Text           = "$($lang.FileName): $($ImageFilePath)"
			}
			$LabelNewFilename_Warp = New-Object system.Windows.Forms.Label -Property @{
				Height         = 10
				Width          = 470
			}
			$UI_Main_Menu.controls.AddRange((
				$LabelNewFilename,
				$LabelNewFilename_Warp
			))

			$RandomGuid = [guid]::NewGuid()
			$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
			$Arguments = "info ""$($ImageFilePath)"" --extract-xml ""$($Export_To_New_Xml)"""
			Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

			if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
				[XML]$empDetails = Get-Content $Export_To_New_Xml

				ForEach ($empDetail in $empDetails.wim.IMAGE) {
					$Index_Name        = New-Object System.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.MountedIndex): $($empDetail.index)"
					}
					$Index_Name_Wrap   = New-Object system.Windows.Forms.Label -Property @{
						Height         = 2
						Width          = 460
					}

					$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.Wim_Edition): $($empDetail.FLAGS)"
					}
					$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 2
						Width          = 460
					}

					$UI_Main_Menu.controls.AddRange((
						$Index_Name,
						$Index_Name_Wrap,
						$New_Wim_Edition,
						$New_Wim_Edition_Wrap
					))

					if ($empDetail.FLAGS -eq $empDetail.WINDOWS.EDITIONID) {
					} else {
						$New_Wim_Edition_Error = New-Object system.Windows.Forms.Label -Property @{
							autosize       = 1
							Padding        = "16,0,0,0"
							Text           = "$($lang.Wim_Edition): $($empDetail.WINDOWS.EDITIONID), $($lang.SelectFromError)"
						}
						$New_Wim_Edition_Error_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 2
							Width          = 460
						}

						$UI_Main_Menu.controls.AddRange((
							$New_Wim_Edition_Error,
							$New_Wim_Edition_Error_Wrap
						))
					}

					$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.Wim_Image_Name): $($empDetail.NAME)"
					}
					$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 2
						Width          = 460
					}
					$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.Wim_Image_Description): $($empDetail.DESCRIPTION)"
					}
					$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 2
						Width          = 460
					}
					$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.Wim_Display_Name): $($empDetail.DISPLAYNAME)"
					}
					$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 2
						Width          = 460
					}
					$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
						autosize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.Wim_Display_Description): $($empDetail.DISPLAYDESCRIPTION)"
					}
					$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 25
						Width          = 460
					}

					$UI_Main_Menu.controls.AddRange((
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

				Remove-Item -Path $Export_To_New_Xml
			}
		} else {
			try {
				Get-WindowsImage -ImagePath $ImageFilePath -ErrorAction SilentlyContinue | ForEach-Object {
					Get-WindowsImage -ImagePath $ImageFilePath -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
						$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
							Name      = $_.EditionId
							Height    = 35
							Width     = 460
							Padding   = "16,0,0,0"
							Text      = "$($lang.MountedIndex): $($_.ImageIndex)"
							Tag       = $_.ImageIndex
							Checked   = $True
						}

						$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
							autosize       = 1
							Padding        = "16,0,0,0"
							Text           = "$($lang.Wim_Image_Name): $($_.ImageName)"
						}
						$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 2
							Width          = 460
						}
						$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
							autosize       = 1
							Padding        = "16,0,0,0"
							Text           = "$($lang.Wim_Image_Description): $($_.ImageDescription)"
						}
						$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 25
							Width          = 460
						}

						$UI_Main_Menu.controls.AddRange((
							$CheckBox,
							$New_Wim_Image_Name,
							$New_Wim_Image_Name_Wrap,
							$New_Wim_Image_Description,
						$New_Wim_Image_Description_Wrap
						))
					}
				}
			} catch {
				$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height         = 40
					Width          = 460
					margin         = "16,0,0,0"
					Text           = "$($lang.SelectFromError): $($lang.UpdateUnavailable)"
				}

				$UI_Main_Menu.controls.AddRange($UI_Main_Other_Rule_Not_Find)
			}
		}
	}

	Function New_Image_Select_Tasks_Set
	{
		param (
			$Uid,
			$Group,
			$Filename
		)

		$NewFilenameName = New-Object System.Windows.Forms.Label -Property @{
			Height    = 30
			Width     = 245
			Padding   = "16,0,0,0"
			Text      = $Filename
		}

		$UI_Main_Pri_Key_Setting_Pri = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 255
			Padding        = "35,0,0,0"
			Text           = $lang.Pri_Key_Setting
			Tag            = $Uid
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Hide()
				$Global:Save_Current_Default_key = ""
				Image_Set_Global_Primary_Key -Uid $this.Tag -Detailed -DevCode "AE 1"
				$UI_Main.Close()
			}
		}

		$NewOkGoTo = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 255
			Padding        = "35,0,0,0"
			Text           = $lang.Ok_Go_To
			Tag            = $Uid
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Hide()
				$Global:Save_Current_Default_key = ""
				Image_Set_Global_Primary_Key -Uid $this.Tag -Detailed -DevCode "AE 2"

				switch ($Go) {
					"Rebuild_Image_File" {
						Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						write-host "  " -NoNewline

						if (Verify_Is_Current_Same) {
							Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
						} else {
							Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
							Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
							Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
						}
					}
					Default {
						if ($IsEvent) {
							Event_Assign -Rule $Go -Run
						} else {
							Invoke-Expression -Command $Go
						}
					}
				}
				$UI_Main.Close()
			}
		}

		$NewFilenameName_Warp = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 255
		}

		$UI_Primary_Key_Select.controls.AddRange((
			$NewFilenameName,
			$UI_Main_Pri_Key_Setting_Pri,
			$NewOkGoTo,
			$NewFilenameName_Warp
		))
	}

	ForEach ($item in $Global:Image_Rule) {
		$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
		if (Test-Path -Path $TestWimFile -PathType Leaf) {
			$GUIImageSelectInstall = New-Object System.Windows.Forms.Label -Property @{
				Height             = 30
				Width              = 245
				Text               = "$($lang.Event_Group): $($item.Main.Group)"
			}
			$UI_Primary_Key_Select.controls.AddRange($GUIImageSelectInstall)

			New_Image_Select_Tasks_Set -Uid $item.Main.Uid -Group $item.Main.Group -Filename "$($item.Main.ImageFileName).$($item.Main.Suffix)"
			New_Image_Select_Tasks_View -ImageFilePath $TestWimFile
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"
				if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
					New_Image_Select_Tasks_Set -Uid $Expand.Uid -Group $Expand.Group -Filename "$($Expand.ImageFileName).$($Expand.Suffix)"
					New_Image_Select_Tasks_View -ImageFilePath $test_mount_folder_Current
				}
			}
		}
	}

	switch ($Go) {
		"Image_Additional_Edition_UI" { $NewMainText = $lang.AdditionalEdition }
		"Image_Select_Index_UI"       { $NewMainText = "$($lang.SelectSettingImage): $($lang.MountedIndexSelect)" }
		"Image_Select_Append_UI"      { $NewMainText = "$($lang.SelectSettingImage): $($lang.Wim_Append)" }
		"Image_Select_Del_UI"         { $NewMainText = "$($lang.SelectSettingImage): $($lang.Del)" }
		"Wimlib_Extract_And_Update"   { $NewMainText = $lang.Wim_Rule_Update }
		"Image_Select_Export_UI"      { $NewMainText = "$($lang.SelectSettingImage): $($lang.Export_Image)" }
		"Feature_More_UI_Menu"        { $NewMainText = $lang.MoreFeature }
		"Rebuild_Image_File"          { $NewMainText = $lang.Rebuild }
		Default { $NewMainText = $lang.ImageCodenameNo }
	}

	Write-Host "`n  $($lang.Ok_Go_To): $($NewMainText)" -ForegroundColor Yellow
	$UI_Main.Text = "$($UI_Main.Text): $($NewMainText)"
	$UI_Main_Error.Text = "$($lang.Ok_Go_To): $($NewMainText)"
	$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
	Write-Host "  $('-' * 80)"

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