<#
	.Menu: Save and unmount images
	.菜单：保存、卸载映像
#>
Function Image_Eject
{
	if (-not $Global:EventQueueMode) {
		Logo -Title "$($lang.Mounted_Status): $($lang.Mount), $($lang.Unmount)"
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.MountImageTo): " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host $Global:Mount_To_Route -ForegroundColor Yellow
		}

		Write-Host "  $($lang.MainImageFolder): " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Red
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 2
			Mainpage
		}

		Image_Get_Mount_Status

		<#
			.先决条件
		#>
		<#
			.判断是否选择 Install, Boot, WinRE
		#>
		if (Image_Is_Select_IAB) {
		} else {
			Write-Host "`n  $($lang.Mounted_Status): $($lang.Mount), $($lang.Unmount)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			return
		}

		<#
			.判断挂载合法性
		#>
		Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

		if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

			return
		}
	}

	<#
		.Assign available tasks
		.分配可用的任务
	#>
	Event_Assign -Rule "Eject" -Run
}

<#
	.User interface: Save and unmount images
	.用户界面：保存、卸载映像
#>
Function Image_Eject_UI
{
	Write-Host "`n  $($lang.Mounted_Status): $($lang.Mount), $($lang.Unmount)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.Matches whether to mount other image files in the image in the main item
		.匹配主要项里，是否挂载映像内的其它映像文件
	#>
	Function Image_Eject_Refresh_Expand_Report
	{
		$UI_Main_Expand_Detailed_Menu.controls.Clear()
		$UI_Main_Sync_Expand_Tips.controls.Clear()
		$Script:Mark_No_Find_Expand = $True

		ForEach ($item in $Global:Image_Rule) {
			$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 435
			}

			if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
				if ($item.Expand.Count -gt 0) {
					ForEach ($itemExpandNew in $item.Expand) {
						if ($Global:Primary_Key_Image.Group -eq $itemExpandNew.Group) {
							$Temp_Main_Save_Expand_Name = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 435
								Padding        = "30,0,0,0"
								Text           = "$($lang.Unique_Name): $($item.Main.Uid)"
							}

							$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height          = 30
								Width           = 435
								Padding         = "30,0,0,0"
								Text            = $lang.Detailed
								Tag             = $itemExpandNew.Uid
								LinkColor       = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior    = "NeverUnderline"
								add_Click       = {
									Image_Eject_Refresh_Expand_Config -Uid $this.Tag
									$UI_Main_Mask_Rule_Detailed.Visible = $True
								}
							}

							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($itemExpandNew.Uid)").Value) {
								$Script:Mark_No_Find_Expand = $False
								$UI_Main_Save_Expand_Select.controls.AddRange((
									$Temp_Main_Save_Expand_Name,
									$AddSourcesPathPaste,
									$UI_Add_End_Wrap
								))
							}

							<#
								.需弹出主要项后的操作
							#>
							$GUIImage_Select_Expand_Group = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
								Name           = $itemExpandNew.Uid
								Tag            = $itemExpandNew.Uid
								BorderStyle    = 0
								AutoSize       = 1
								autoSizeMode   = 1
								autoScroll     = $False
							}
							$GUIImage_Select_Expand = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								margin         = "4,0,0,22"
								Text           = ""
							}
							$GUIImage_Select_Expand_Adv = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 435
								Text           = $lang.AdvOption
							}

							$GUIImage_Select_Expand_Select_Group = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
								Tag            = "ADV"
								BorderStyle    = 0
								AutoSize       = 1
								autoSizeMode   = 1
								autoScroll     = $False
							}
							<#
								.允许更新规则
							#>
							$GUIImage_Select_Expand_Rule = New-Object System.Windows.Forms.CheckBox  -Property @{
								Height         = 30
								Width          = 435
								Padding        = "16,0,0,0"
								Text           = $lang.Event_Allow_Update_Rule
								Tag            = "Is_Update_Rule"
								add_Click      = {
									if ($this.Checked) {
										Image_Select_Eject_Disable_Expand_Item -Group $this.Parent.Parent.Name -Name $this.Tag -Open
										New-Variable -Scope global -Name "Queue_$($this.Tag)_$($this.Parent.Parent.Name)" -Value $True -Force
									} else {
										Image_Select_Eject_Disable_Expand_Item -Group $this.Parent.Parent.Name -Name $this.Tag -Close
										New-Variable -Scope global -Name "Queue_$($this.Tag)_$($this.Parent.Parent.Name)" -Value $False -Force
									}
								}
							}

							$GUIImage_Select_Expand_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
								AutoSize       = 1
								Padding        = "31,0,0,0"
								Text           = $lang.Event_Allow_Update_Rule_Tips -f $itemExpandNew.ImageFileName, $item.Main.ImageFileName, $itemExpandNew.ImageFileName, $item.Main.ImageFileName
							}

							<#
								.更新规则同步到所有索引号
							#>
							$GUIImage_Select_Expand_Rule_To_All = New-Object System.Windows.Forms.CheckBox  -Property @{
								Height         = 30
								Width          = 435
								Padding        = "35,0,0,0"
								margin         = "0,15,0,0"
								Text           = $lang.Event_Allow_Update_To_All
								Tag            = "Is_Update_Rule_Expand_To_All"
								add_Click      = {
									if ($this.Checked) {
										Image_Select_Eject_Disable_Expand_Item -Group $this.Parent.Parent.Name -Name $this.Tag -Open
										New-Variable -Scope global -Name "Queue_$($this.Tag)_$($this.Parent.Parent.Name)" -Value $True -Force
									} else {
										Image_Select_Eject_Disable_Expand_Item -Group $this.Parent.Parent.Name -Name $this.Tag -Close
										New-Variable -Scope global -Name "Queue_$($this.Tag)_$($this.Parent.Parent.Name)" -Value $False -Force
									}
								}
							}

							$GUIImage_Select_Expand_Rule_To_All_Tips = New-Object system.Windows.Forms.Label -Property @{
								AutoSize       = 1
								Padding        = "48,0,0,0"
								Text           = $lang.Event_Allow_Update_To_All_Tips -f $itemExpandNew.ImageFileName, $item.Main.ImageFileName, "$($item.Main.ImageFileName);$($item.Main.ImageFileName);"
							}

							$Clear_History_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height          = 30
								Width           = 435
								margin          = "0,30,0,40"
								Text            = $lang.Del
								Tag             = $itemExpandNew.Uid
								LinkColor       = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior    = "NeverUnderline"
								add_Click       = {
									New-Variable -Scope global -Name "Queue_Is_Update_Rule_$($this.Tag)" -Value $False -Force
									New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_To_All_$($this.Tag)" -Value $False -Force
									New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($this.Tag)" -Value @() -Force

									<#
										.刷新列表
									#>
									Image_Eject_Refresh_Expand_Report
								}
							}

							$Is_Expand_Rule_Update = (Get-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($itemExpandNew.Uid)" -ErrorAction SilentlyContinue).Value
							if ($Is_Expand_Rule_Update.Count -gt 0) {
								$UI_Main_Expand_Detailed_Menu.controls.AddRange($GUIImage_Select_Expand_Group)

								$GUIImage_Select_Expand_Group.controls.AddRange((
									$GUIImage_Select_Expand,
									$GUIImage_Select_Expand_Select_Group
								))
								$GUIImage_Select_Expand_Select_Group.controls.AddRange((
									$GUIImage_Select_Expand_Adv,
									$GUIImage_Select_Expand_Rule,
									$GUIImage_Select_Expand_Rule_Tips,
									$GUIImage_Select_Expand_Rule_To_All,
									$GUIImage_Select_Expand_Rule_To_All_Tips,
									$Clear_History_Current
								))

								$GUIImage_Select_Expand.Text = "$($lang.Event_Group): $($item.Main.Group)`n$($lang.Unique_Name): $($item.Main.Group)`n`n$($lang.Setting_Pri_Key)`n$($Is_Expand_Rule_Update.Uid)`n`n$($lang.Pri_Key_Update_To)`n$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)`n`n$($lang.Select_Path)`n$($Is_Expand_Rule_Update.UpdatePath)"
							}

							if ((Get-Variable -Scope global -Name "Queue_Is_Update_Rule_$($itemExpandNew.Uid)" -ErrorAction SilentlyContinue).Value) {
								$GUIImage_Select_Expand_Rule.Checked = $True
								$GUIImage_Select_Expand_Rule_To_All.Enabled = $True
							} else {
								$GUIImage_Select_Expand_Rule.Checked = $False
								$GUIImage_Select_Expand_Rule_To_All.Enabled = $False
							}

							if ((Get-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_To_All_$($itemExpandNew.Uid)" -ErrorAction SilentlyContinue).Value) {
								$GUIImage_Select_Expand_Rule_To_All.Checked = $True
							} else {
								$GUIImage_Select_Expand_Rule_To_All.Checked = $False
							}
						}
					}
				}

				break
			}
		}

		[int]$Temp_Save_Count_item = 0

		$UI_Main_Expand_Detailed_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				$Temp_Save_Count_item++
			}
		}

		if ($Temp_Save_Count_item -gt 0) {
			$UI_Main_Is_New_Event = New-Object system.Windows.Forms.LinkLabel -Property @{
				autosize       = 1
				Text           = "$($lang.Wimlib_New -f $Temp_Save_Count_item)"
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Expand_Detailed.Visible = $False
				}
			}

			$UI_Main_Sync_Expand_Tips.controls.AddRange($UI_Main_Is_New_Event)
		} else {
			$UI_Main_Is_No_Event = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Text           = $lang.Wimlib_New_Tips
			}

			$UI_Main_Sync_Expand_Tips.controls.AddRange($UI_Main_Is_No_Event)
		}
	}

	Function Image_Eject_Refresh_Expand_Config
	{
		param
		(
			$Uid
		)

		<#
			.刷新 UI 标签
		#>
		$UI_Main_Expand_Name.Text = "$($lang.Unique_Name): $($Uid)"
		$UI_Main_Expand_Name.Name = $Uid
		$UI_Main_Expand_Rebuild.Text = $lang.Reconstruction -f $Uid

		if ($UI_Main_Mount_Save_End_Eject.Enabled) {
			if ($UI_Main_Mount_Save_End_Eject.Checked) {
				$UI_Main_Expand_Mount_Save_End_Eject.Checked = $True
				$UI_Main_Expand_Mount_Save_End_Eject.Enabled = $False
			} else {
				<#
					.不保存
				#>
				$UI_Main_Expand_Mount_Save_End_Eject.Enabled = $True

				if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($Uid)").Value) {
					$UI_Main_Expand_Mount_Save_End_Eject.Checked = $True
				} else {
					$UI_Main_Expand_Mount_Save_End_Eject.Checked = $False
				}
			}
		} else {
			$UI_Main_Expand_Mount_Save_End_Eject.Checked = $False
		}

		<#
			.保存
		#>
		if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($Uid)").Value) {
			$UI_Main_Expand_Mount_Save.Checked = $True
			$UI_Main_Expand_Rebuild.Enabled = $True
		} else {
			$UI_Main_Expand_Mount_Save.Checked = $False
			$UI_Main_Expand_Rebuild.Enabled = $False
		}

		<#
			.不保存
		#>
		if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($Uid)").Value) {
			$UI_Main_Expand_Mount_Dot_Save.Checked = $True
		} else {
			$UI_Main_Expand_Mount_Dot_Save.Checked = $False
		}

		<#
			.重建
		#>
		if ((Get-Variable -Scope global -Name "Queue_Expand_Rebuild_$($Uid)").Value) {
			$UI_Main_Expand_Rebuild.Checked = $True
		} else {
			$UI_Main_Expand_Rebuild.Checked = $False
		}

		<#
			.健康
		#>
		if ((Get-Variable -Scope global -Name "Queue_Expand_Healthy_$($Uid)").Value) {
			$UI_Main_Expand_Healthy.Checked = $True
		} else {
			$UI_Main_Expand_Healthy.Checked = $False
		}
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Additional_Edition_Reset
		Event_Reset_Variable
		$UI_Main.Close()
	}
 
	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.Mount), $($lang.Unmount)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Is_Save_And_Unmount = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "15,10"
		Height         = 40
		Width          = 400
		Text           = $lang.Mounted_Status
		Checked        = $True
		add_Click      = {
			$UI_Main_Mount_Save_End_Eject.Enabled = $True

			if ($UI_Main_Is_Save_And_Unmount.Checked) {
				$UI_Main_Do_Not_Save.Enabled = $True
				$UI_Main_Save_Expand_Select.Enabled = $True
			} else {
				$UI_Main_Do_Not_Save.Enabled = $False
				$UI_Main_Save_Expand_Select.Enabled = $False
			}

			if ($UI_Main_Mount_Save.Enabled) {
				if ($UI_Main_Mount_Save.Checked) {
					$UI_Main_Mount_Save_End_Eject.Enabled = $True

					if ($UI_Main_Healthy.Enabled) {
						$UI_Main_Healthy.Enabled = $True
					}
				}
			}

			if ($UI_Main_Mount_Dot_Save.Enabled) {
				if ($UI_Main_Mount_Dot_Save.Checked) {
					$UI_Main_Mount_Save_End_Eject.Enabled = $False

					if ($UI_Main_Healthy.Enabled) {
						$UI_Main_Healthy.Enabled = $False
					}
				}
			}
		}
	}

	$UI_Main_Menu      = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}
	$UI_Main_Do_Not_Save = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,8,0"
		margin         = "0,0,0,35"
		autoScroll     = $True
	}

	<#
		.保存
	#>
	$UI_Main_Mount_Save = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 495
		Text           = $lang.Save
		Checked        = $True
		add_Click      = {
			if ($UI_Main_Is_Save_And_Unmount.Enabled) {
				$UI_Main_Mount_Save_End_Eject.Enabled = $True
				$UI_Main_Save_Expand_Select.Enabled = $True

				if ($UI_Main_Healthy.Enabled) {
					$UI_Main_Healthy.Enabled = $True
				}
			}
		}
	}

		<#
			.保存：可选项，不保存
		#>
		$UI_Main_Mount_Save_End_Eject = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 480
			Text           = $lang.UnmountAndSave
			margin         = "20,0,20,0"
		}

	$UI_Main_Mount_Save_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 495
	}

	<#
		.不保存
	#>
	$UI_Main_Mount_Dot_Save = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 495
		Text           = $lang.DoNotSave
		add_Click      = {
			if ($UI_Main_Is_Save_And_Unmount.Enabled) {
				<#
					.关闭按钮：保存
				#>
				$UI_Main_Mount_Save_End_Eject.Enabled = $False

				<#
					.关闭：扩展组
				#>
				$UI_Main_Save_Expand_Select.Enabled = $False

				if ($UI_Main_Healthy.Enabled) {
					$UI_Main_Healthy.Enabled = $False
				}
			}
		}
	}
	$UI_Main_Mount_Dot_Save_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "16,0,0,0"
		Text           = $lang.DoNotSaveTips
	}

	<#
		.Extensions
		.扩展项
	#>
	$UI_Main_Save_Expand_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 515
		Padding        = "31,0,0,0"
		Text           = $lang.ImageEjectExpand
	}
	$UI_Main_Save_Expand_Select = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,8,0"
		autoScroll     = $True
	}

	<#
		.Optional features
		.可选功能
	#>
	$UI_Main_Adv_Name  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 515
		margin         = "0,10,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.允许使用快速抛弃方式
	#>
	$UI_Main_Abandon_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 495
		margin         = "22,0,0,0"
		Text           = $lang.Abandon_Allow
	}

	<#
		.Rebuild
		.重建
	#>
	$UI_Main_Rebuild   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 495
		margin         = "22,0,0,0"
		Text           = $lang.Reconstruction -f $Global:Primary_Key_Image.ImageFileName
		add_Click      = {
			if ($this.Checked) {
				New-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			}
		}
	}

	<#
		.Healthy
		.健康
	#>
	$UI_Main_Healthy   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 495
		margin         = "22,0,0,0"
		Text           = $lang.Healthy
		add_Click      = {
			if ($This.Checked) {
				$UI_Main_Healthy_Save.Enabled = $True
			} else {
				$UI_Main_Healthy_Save.Enabled = $False
			}
		}
	}
	$UI_Main_Healthy_Save = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 495
		margin         = "38,0,0,0"
		Text           = $lang.Healthy_Save
	}

	$UI_Main_Menu_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 495
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 350
		Width          = 270
		BorderStyle    = 0
		Location       = "620,20"
		Text           = $lang.ImageEjectTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
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
	$UI_Main_Expand_Menu = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,20,0,0"
		autoScroll     = $True
	}
	$UI_Main_Expand_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 495
		Text           = $lang.Unique_Name
	}
	$UI_Main_Expand_Do_Not_Save = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,8,0"
		margin         = "0,0,0,35"
		autoScroll     = $True
	}

	<#
		.Save, extend the item
		.保存，扩展项
	#>
	$UI_Main_Expand_Mount_Save = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 26
		Width          = 495
		Text           = $lang.Save
		Checked        = $True
		add_Click      = {
			$UI_Main_Expand_Mount_Save_End_Eject.Enabled = $True
			$UI_Main_Expand_Rebuild.Enabled = $True
			$UI_Main_Expand_Healthy.Enabled = $True
		}
	}
	$UI_Main_Expand_Mount_Save_End_Eject = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.UnmountAndSave
		margin         = "20,0,20,0"
	}

	<#
		.The extension item is not saved
		.不保存，扩展项
	#>
	$UI_Main_Expand_Mount_Dot_Save = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 495
		Text           = $lang.DoNotSave
		add_Click      = {
			<#
				.Close button: Save
				.关闭按钮：保存
			#>
			$UI_Main_Expand_Mount_Save_End_Eject.Enabled = $False

			$UI_Main_Expand_Rebuild.Enabled = $False
			$UI_Main_Expand_Healthy.Enabled = $False
		}
	}
	$UI_Main_Expand_Mount_Dot_Save_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "16,0,0,0"
		Text           = $lang.DoNotSaveTips
	}

	<#
		.Optional features
		.可选功能
	#>
	$UI_Main_Expand_Adv_Name  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 515
		margin         = "0,10,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.Rebuild
		.重建
	#>
	$UI_Main_Expand_Rebuild = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 495
		margin         = "22,0,0,0"
		Text           = $lang.Reconstruction -f "Expand"
	}

	<#
		.Healthy
		.健康
	#>
	$UI_Main_Expand_Healthy = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 495
		margin         = "22,0,0,0"
		Text           = $lang.Healthy
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Expand_Tips = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 350
		Width          = 270
		BorderStyle    = 0
		Location       = "620,20"
		Text           = $lang.ImageEjectExpandTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Mask_Rule_Detailed_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Mask_Rule_Detailed.Visible = $False

			<#
				.刷新 UI 标签
			#>
			<#
				.初始化变量
			#>
			<#
				.保存，扩展项
			#>
			New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($UI_Main_Expand_Name.Name)" -Value $False -Force

			<#
				.不保存，扩展项
			#>
			New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($UI_Main_Expand_Name.Name)" -Value $False -Force

			<#
				.重建映像
			#>
			New-Variable -Scope global -Name "Queue_Expand_Rebuild_$($UI_Main_Expand_Name.Name)" -Value $False -Force

			<#
				.健康
			#>
			New-Variable -Scope global -Name "Queue_Expand_Healthy_$($UI_Main_Expand_Name.Name)" -Value $False -Force

			<#
				.保存
			#>
			if ($UI_Main_Expand_Mount_Save.Enabled) {
				if ($UI_Main_Expand_Mount_Save.Checked) {
					New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($UI_Main_Expand_Name.Name)" -Value $True -Force
					$UI_Main_Expand_Rebuild.Enabled = $True

					<#
						.不保存
					#>
					<#
						.优先判断主要项，不保存
					#>
					if ($UI_Main_Mount_Save_End_Eject.Enabled) {
						if ($UI_Main_Mount_Save_End_Eject.Checked) {
							New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($UI_Main_Expand_Name.Name)" -Value $True -Force

							<#
								.勾选：扩展项，不保存按钮
							#>
							$UI_Main_Expand_Mount_Save_End_Eject.Checked = $True
						} else {
							<#
								.判断扩展项，不保存
							#>
							if ($UI_Main_Expand_Mount_Save_End_Eject.Enabled) {
								if ($UI_Main_Expand_Mount_Save_End_Eject.Checked) {
									New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($UI_Main_Expand_Name.Name)" -Value $True -Force
								}
							}
						}
					}
				}
			}

			<#
				.不保存
			#>
			if ($UI_Main_Expand_Mount_Dot_Save.Enabled) {
				if ($UI_Main_Expand_Mount_Dot_Save.Checked) {
					New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($UI_Main_Expand_Name.Name)" -Value $True -Force
				}
			}

			<#
				.重建
			#>
			if ($UI_Main_Expand_Rebuild.Enabled) {
				if ($UI_Main_Expand_Rebuild.Checked) {
					New-Variable -Scope global -Name "Queue_Expand_Rebuild_$($UI_Main_Expand_Name.Name)" -Value $True -Force
				}
			}

			<#
				.健康
			#>
			if ($UI_Main_Expand_Healthy.Enabled) {
				if ($UI_Main_Expand_Healthy.Checked) {
					New-Variable -Scope global -Name "Queue_Expand_Healthy_$($UI_Main_Expand_Name.Name)" -Value $True -Force
				}
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

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Expand_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Expand_Detailed_Menu = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,20,0,0"
		autoScroll     = $True
	}
	<#
		.Note
		.注意
	#>
	$UI_Main_Expand_Detailed_Tips = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 350
		Width          = 270
		BorderStyle    = 0
		Location       = "620,20"
		Text           = $lang.ImageEjectExpandTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Expand_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Expand_Detailed.Visible = $False
		}
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '620,395'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '620,425'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "10" -Uid $Global:Primary_Key_Image.Uid -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Additional_Edition_Reset_Uid -Uid $Global:Primary_Key_Image.Uid
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '620,455'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.SuggestedSkip
		Location       = '620,390'
		add_Click      = {
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True"
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False"
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '636,426'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '636,455'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Sync_Expand_Tips = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Location       = "620,525"
		Height         = 60
		Width          = 280
	}

	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			$UI_Main.Hide()

			<#
				.重置变量
			#>
			New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force   # 保存
			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force # 不保存
			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Global:Primary_Key_Image.Uid)" -Value $False -Force # 不保存

			<#
				.健康
			#>
			New-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Uid)" -Value $False -Force

			Write-Host "  $($lang.Healthy)" -ForegroundColor Yellow
			if ($UI_Main_Healthy.Enabled) {
				if ($UI_Main_Healthy.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					New-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			Write-Host "`n  $($lang.Healthy_Save)" -ForegroundColor Yellow
			if ($UI_Main_Healthy_Save.Enabled) {
				if ($UI_Main_Healthy_Save.Checked) {
					New-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					New-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			} else {
				New-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($UI_Main_Is_Save_And_Unmount.Enabled) {
				if ($UI_Main_Is_Save_And_Unmount.Checked) {
					<#
						.保存
					#>
					Write-Host "  $($lang.Save)" -ForegroundColor Yellow
					if ($UI_Main_Mount_Save.Checked) {
						Write-Host "  $($lang.Operable)" -ForegroundColor Green
						New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force

						Write-Host "`n  $($lang.UnmountAndSave)" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
						if ($UI_Main_Mount_Save_End_Eject.Enabled) {
							if ($UI_Main_Mount_Save_End_Eject.Checked) {
								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
								Write-Host "  $($lang.Operable)" -ForegroundColor Green
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}
						} else {
							Write-Host "  $($lang.NoWork)" -ForegroundColor Red
						}
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}

					<#
						.不保存
					#>
					Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					if ($UI_Main_Mount_Dot_Save.Checked) {
						New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
						Write-Host "  $($lang.Operable)" -ForegroundColor Green
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red

				Write-Host "`n  $($lang.Save)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($UI_Main_Mount_Save.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.强行开启不保存
				#>
				New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			}

			Write-Host "`n  $($lang.Abandon_Allow)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($UI_Main_Abandon_Allow.Checked) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green

				New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event -All
			}
			$UI_Main.Close()
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()

			if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
				Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

				Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				<#
					.保存
				#>
				New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force   # 保存
				Write-Host "  $($lang.SaveTo)" -ForegroundColor Yellow
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red

				<#
					.不保存
				#>
				Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
				New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -Value $False -Force # 不保存
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red

				<#
					.健康
				#>
				Write-Host "`n  $($lang.Healthy)" -ForegroundColor Yellow
				New-Variable -Scope global -Name "Queue_Expand_Healthy_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Expand_Detailed,
		$UI_Main_Mask_Rule_Detailed,
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Sync_Expand_Tips,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	<#
		.弹出弹出：替换功能
	#>
	$UI_Main_Expand_Detailed.controls.AddRange((
		$UI_Main_Expand_Detailed_Menu,
		$UI_Main_Expand_Detailed_Tips,
		$UI_Main_Expand_Detailed_Hide
	))

	<#
		.Pop-up extension functionality
		.弹出扩展项功能
	#>
	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Expand_Menu,
		$UI_Main_Expand_Tips,
		$UI_Main_Mask_Rule_Detailed_OK,
		$UI_Main_Mask_Rule_Detailed_Hide
	))
	$UI_Main_Expand_Menu.controls.AddRange((
		$UI_Main_Expand_Name,
		$UI_Main_Expand_Do_Not_Save,

		$UI_Main_Expand_Adv_Name,
		$UI_Main_Expand_Rebuild,
		$UI_Main_Expand_Healthy
	))
	$UI_Main_Expand_Do_Not_Save.controls.AddRange((
		$UI_Main_Expand_Mount_Save,
		$UI_Main_Expand_Mount_Save_End_Eject,
		$UI_Main_Expand_Mount_Dot_Save,
		$UI_Main_Expand_Mount_Dot_Save_Tips
	))

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Is_Save_And_Unmount,
		$UI_Main_Do_Not_Save,

		<#
			.Extensions
			.扩展项
		#>
		$UI_Main_Save_Expand_Name,
		$UI_Main_Save_Expand_Select,

		$UI_Main_Adv_Name
	))

	<#
		.Allow automatic activation of the quick discard method
		.允许自动开启快速抛弃方式
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Menu.controls.AddRange($UI_Main_Abandon_Allow)

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
						"True" {
							$UI_Main_Abandon_Allow.Checked = $True
						}
					}
				}
			}
		}
	}

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Rebuild,
		$UI_Main_Healthy,
		$UI_Main_Healthy_Save,
		$UI_Main_Menu_Wrap
	))

	$UI_Main_Do_Not_Save.controls.AddRange((
		$UI_Main_Mount_Save,
		$UI_Main_Mount_Save_End_Eject,
		$UI_Main_Mount_Save_Wrap,
		$UI_Main_Mount_Dot_Save,
		$UI_Main_Mount_Dot_Save_Tips
	))

	<#
		.重建
	#>
	if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Rebuild.Checked = $True
	} else {
		$UI_Main_Rebuild.Checked = $False
	}

	<#
		.不保存
	#>
	if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Mount_Dot_Save.Checked = $True
	}

	<#
		.Healthy
		.健康
	#>
	if ((Get-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Healthy.Checked = $True
	}

	<#
		.Healthy, Don't Save
		.健康，不保存
	#>
	if ((Get-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Healthy_Save.Checked = $True
	}

	if ($UI_Main_Healthy.Enabled) {
		if ($UI_Main_Healthy.Checked) {
			$UI_Main_Healthy_Save.Enabled = $True
		} else {
			$UI_Main_Healthy_Save.Enabled = $False
		}
	} else {
		$UI_Main_Healthy_Save.Enabled = $False
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))

		$UI_Main_Is_Save_And_Unmount.Enabled = $False
		$UI_Main_Mount_Save_End_Eject.Enabled = $False
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		}

		<#
			.Initialization checkbox: No longer recommended
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
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

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
				$UI_Main.controls.AddRange((
					$UI_Main_Suggestion_Not,
					$UI_Main_Suggestion_Setting,
					$UI_Main_Suggestion_Stop
				))
			}
		}
	}

	<#
		.Matches whether to mount other image files in the image in the main item
		.匹配主要项里，是否挂载映像内的其它映像文件
	#>
	Image_Eject_Refresh_Expand_Report

	if ($Script:Mark_No_Find_Expand) {
		$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
			Height         = 40
			Width          = 465
			margin         = "30,0,0,20"
			Text           = $lang.NoWork
		}

		$UI_Main_Save_Expand_Select.controls.AddRange($UI_Main_Other_Rule_Not_Find)
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

	$UI_Main.ShowDialog() | Out-Null
}

Function Image_Select_Eject_Disable_Expand_Item
{
	param
	(
		$Group,
		$Name,
		[switch]$Open,
		[switch]$Close
	)

	$UI_Main_Expand_Detailed_Menu.Controls | ForEach-Object {
		if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {

			if ($Group -eq $_.Name) {
				$_.Controls | ForEach-Object {
					if ($_.Tag -eq "ADV") {
						ForEach ($ItemNew in $_.Controls) {
							if ($ItemNew -is [System.Windows.Forms.checkbox]) {
								if ($ItemNew.Tag -like "$($Name)_Expand*") {
									if ($open) {
										$ItemNew.Enabled = $True
									}

									if ($Close) {
										$ItemNew.Enabled = $False
									}
								}
							}
						}
					}
				}
			}
		}
	}
}