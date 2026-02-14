<#
	.配置文件最低
#>
$Script:Autopilot_Scheme_Config_Low = "1.0.0.0"

<#
	.Select the image source user interface, select install.wim or boot.wim
	.选择映像源用户界面，选择 install.wim 或 boot.wim
#>
Function Image_Assign_Autopilot_Master
{
	<#
		.初始化先决条件
	#>
	$Script:InBox_Apps_Rule_Select_Single = @()
	$Script:Prerequisite_Is_Satisfy = @()

	Logo -Title $lang.Autopilot
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
	}

	Image_Get_Mount_Status

	Write-Host "`n  $($lang.Autopilot)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_Import_Eject_ISO
	{

		param
		(
			$GUID
		)

		$InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		if ($InBox_Apps_Rule_Select_Single.count -gt 0) {
			switch ($Global:Architecture) {
				"arm64" { $NewInBoxAppsFolder += "arm64" }
				"AMD64" { $NewInBoxAppsFolder += "x64" }
				"x86"   { $NewInBoxAppsFolder += "x86"   }
			}

			if ($InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.Language.count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.Language) {
					if ($item.Count -gt 0) {
						foreach ($ItemAlFile in $item) {
							Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
								Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
									$NewFileName = [IO.Path]::GetFileName($_.ImagePath)

									if ($NewFileName -eq $ItemAlFile) {
										DisMount-DiskImage -ImagePath $_.ImagePath
									}
								}
							}
						}
					}
				}
			}
		}
	}

	Function Image_Select_Public_Autopilot
	{
		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				Image_Select_Public_Autopilot_Add -Uid $item.Main.Uid -Group $item.Main.Group -Mainquests

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						Image_Select_Public_Autopilot_Add -Uid $Expand.Uid -Group $Expand.Group
					}
				}
			}
		}

		Autopilot_Refresh_Public_Events_All
	}

	Function Image_Select_Public_Autopilot_Add
	{
		param
		(
			$Uid,
			$Group,
			[switch]$Mainquests
		)

		<#
			.控件组，开始
		#>
		<#
			.控件组，结束
		#>
		$paneel            = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			AutoSize       = 1
			autoSizeMode   = 1
			Name           = $Uid
			Tag            = $Uid
			autoScroll     = $True
		}

		if ($Mainquests) {
			$MainquestsNew = $lang.Main_quests
		} else {
			$MainquestsNew = $lang.Side_quests
		}
		$GUIImageSelectGroup = New-Object system.Windows.Forms.Label -Property @{
			Height         = 70
			Width          = 450
			Text           = "$($lang.Event_Group): $($Group)`n$($lang.Unique_Name): $($Uid)`n$($lang.Autopilot_Scheme): $($MainquestsNew)"
		}

		$paneel.controls.AddRange($GUIImageSelectGroup)

		<#
			.组，有新的挂载映像时
		#>
		$GUIImageSelectFunctionNeedMount = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Text           = $lang.AssignNeedMount
		}

		<#
			.组，更新
		#>
		$GUIImageSelectFunctionUpdate = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.CUpdate
		}
		$GUIImageSelectFunctionUpdateAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Cumulative_updates_Add_UI_Autopilot"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Name -Silent -DevCode "Autopilot - 3ly00"

				Cumulative_updates_Add_UI_Autopilot
				Autopilot_Refresh_Public_Events_All
			}
		}
		$GUIImageSelectFunctionUpdateDel = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Cumulative_updates_Delete_UI_Autopilot"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Name -Silent -DevCode "Autopilot - 3li11"

				Cumulative_updates_Delete_UI_Autopilot
				Autopilot_Refresh_Public_Events_All
			}
		}
		$GUIImageSelectFunctionUpdate_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，驱动
		#>
		$GUIImageSelectFunctionDrive = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.Drive
		}
		$GUIImageSelectFunctionDriveAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Drive_Add_UI_Autopilot"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Name -Silent -DevCode "Autopilot - li500"

				Drive_Add_UI_Autopilot
				Autopilot_Refresh_Public_Events_All
			}
		}
		$GUIImageSelectFunctionDriveDel = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Drive_Delete_UI_Autopilot"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Name -Silent -DevCode "Autopilot - 510"

				Drive_Delete_UI_Autopilot
				Autopilot_Refresh_Public_Events_All
			}
		}
		$GUIImageSelectFunctionDrive_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		$paneel.controls.AddRange((
			$GUIImageSelectFunctionNeedMount,

				$GUIImageSelectFunctionUpdate,
					$GUIImageSelectFunctionUpdateAdd,
					$GUIImageSelectFunctionUpdateDel,
					$GUIImageSelectFunctionUpdate_Wrap,

				$GUIImageSelectFunctionDrive,
					$GUIImageSelectFunctionDriveAdd,
					$GUIImageSelectFunctionDriveDel,
					$GUIImageSelectFunctionDrive_Wrap
		))

		$UI_Main_Public_Select_Rule.controls.AddRange($paneel)
	}

	<#
		.导入后或即时更新事件
	#>
	Function Autopilot_Refresh_Public_Events_All
	{
		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				$Tasks = Autopilot_Public_Event_Assign_Task_Verify -Uid $item.Main.Uid

				$UI_Main_Public_Select_Rule.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
						if ($item.Main.Uid -eq $_.Name) {
							$_.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.LinkLabel]) {
									if ($Tasks -contains $_.Tag) {
										$_.LinkColor = "#008000"
									} else {
										$_.LinkColor = "#FF0000"
									}
								}
							}
						}
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						$Tasks = Autopilot_Public_Event_Assign_Task_Verify -Uid $Expand.Uid 

						$UI_Main_Public_Select_Rule.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ($Expand.Uid -eq $_.Name) {
									$_.Controls | ForEach-Object {
										if ($_ -is [System.Windows.Forms.LinkLabel]) {
											if ($Tasks -contains $_.Tag) {
												$_.LinkColor = "#008000"
											} else {
												$_.LinkColor = "#FF0000"
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
	}

	Function Autopilot_Public_Event_Assign_Task_Verify
	{
		param
		(
			$Uid
		)

		$FlagIsWait = @()

		<#
			.Autopilot: Add update
			.自动驾驶：添加更新
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Autopilot\Deploy\Update" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Add_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Cumulative_updates_Add_UI_Autopilot"
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Add_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Cumulative_updates_Add_UI_Autopilot"
		}

		<#
			.Autopilot: Delete update
			.自动驾驶：删除更新
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Autopilot\Deploy\Update" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Cumulative_updates_Delete_UI_Autopilot"
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Cumulative_updates_Delete_UI_Autopilot"
		}

		<#
			.Autopilot: Add driver
			.自动驾驶：添加驱动
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Autopilot\Deploy\Drive" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Add_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Drive_Add_UI_Autopilot"
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive\Autopilot" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Add_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Drive_Add_UI_Autopilot"
		}

		<#
			.Autopilot: Remove driver
			.自动驾驶：删除驱动
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Autopilot\Deploy\Drive" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Drive_Delete_UI_Autopilot"
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive\Autopilot" -Name "$($Uid)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$FlagIsWait += "Drive_Delete_UI_Autopilot"
		}

		return $FlagIsWait
	}

	Function Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add
	{
		param
		(
			$Master,
			$ImageName,
			$Group,
			$Uid,
			$MainUid,
			$ImageFilePath,
			[switch]$Mainquests
		)

		<#
			.控件组，开始
		#>
		<#
			.控件组，结束
		#>
		$paneel            = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			AutoSize       = 1
			autoSizeMode   = 1
			Name           = $Uid
			Tag            = $Uid
			autoScroll     = $True
			Enabled        = $False
		}

		if ($Mainquests) {
			$MainquestsNew = $lang.Main_quests
		} else {
			$MainquestsNew = $lang.Side_quests
		}

		$GUIImageSelectGroup = New-Object system.Windows.Forms.Label -Property @{
			Height         = 70
			Width          = 450
			Text           = "$($lang.Event_Group): $($Group)`n$($lang.Unique_Name): $($Uid)`n$($lang.Autopilot_Scheme): $($MainquestsNew)"
		}

		<#
			.选择映像源控件
		#>
		$GUIImageSourceGroupMountFrom = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
			Text           = $lang.SelectSettingImage
		}
		$paneel.controls.AddRange((
			$GUIImageSelectGroup,
			$GUIImageSourceGroupMountFrom
		))

		if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)").Value) {
#			Write-Host "已挂载"
			<#
				.未发现文件
			#>
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 445
				margin         = "16,0,0,35"
				Text           = $lang.Mounted
			}

			$paneel.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		} else {
			if (Test-Path -Path $ImageFilePath -PathType Leaf) {
				<#
					.初始化映像源选择
				#>
				$TempQueueProcessImageSelect = @()

				$Group_Image_Sources = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
					BorderStyle    = 0
					autosize       = 1
					autoSizeMode   = 1
					autoScroll     = $False
					margin         = "0,0,0,35"
					Name           = "ImageSources"
				}

				#region 右键映像源
				<#
					.Add right-click menu: select all, clear button
					.添加右键菜单：全选、清除按钮
				#>
				$UI_Main_Select_Assign_Group_Image_Sources = New-Object System.Windows.Forms.ContextMenuStrip

				<#
					.显示当前控制对象
				#>
				$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("$($lang.Event_Group): $($Group)")
				$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("$($lang.Unique_Name): $($Uid)")

				<#
					.界河
				#>
				$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("-")

				<#
					.选择所有
				#>
				$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("   - $($lang.AllSel)")
				$UI_Group_Image_Sources_Select_All.Tag = $Uid
				$UI_Group_Image_Sources_Select_All.add_Click({
					$TempSelectItem = $This.Tag

					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($TempSelectItem -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSources") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.CheckBox]) {
												$_.Checked = $true
											}
										}
									}
								}
							}
						}
					}
				})

				<#
					.清除全部
				#>
				$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("   - $($lang.AllClear)")
				$UI_Group_Image_Sources_Select_All.Tag = $Uid
				$UI_Group_Image_Sources_Select_All.add_Click({
					$TempSelectItem = $This.Tag

					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($TempSelectItem -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSources") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.CheckBox]) {
												$_.Checked = $false
											}
										}
									}
								}
							}
						}
					}
				})
				#endregion

				$Group_Image_Sources.ContextMenuStrip = $UI_Main_Select_Assign_Group_Image_Sources
				$paneel.controls.AddRange($Group_Image_Sources)

				$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
				if (Test-Path -Path $wimlib -PathType Leaf) {
					$RandomGuid = [guid]::NewGuid()
					$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
					$Arguments = "info ""$($ImageFilePath)"" --extract-xml ""$($Export_To_New_Xml)"""
					Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

					if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
						[XML]$empDetails = Get-Content $Export_To_New_Xml

						ForEach ($empDetail in $empDetails.wim.IMAGE) {
							$TempQueueProcessImageSelect += [pscustomobject]@{
								Index              = $empDetail.index
								Name               = $empDetail.NAME
								ImageDescription   = $empDetail.DESCRIPTION
								DISPLAYNAME        = $empDetail.DISPLAYNAME
								DISPLAYDESCRIPTION = $empDetail.DISPLAYDESCRIPTION
								EditionId          = $empDetail.FLAGS
							}

							$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
								Name      = $empDetail.FLAGS
								Height    = 35
								Width     = 460
								Padding   = "16,0,0,0"
								Text      = "$($lang.MountedIndex): $($empDetail.index)"
								Tag       = $empDetail.index
								Checked   = $True
							}

							$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Edition): $($empDetail.FLAGS)"
							}
							$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 10
								Width          = 460
							}

							$Group_Image_Sources.controls.AddRange((
								$CheckBox,
								$New_Wim_Edition,
								$New_Wim_Edition_Wrap
							))

							if ($empDetail.FLAGS -eq $empDetail.WINDOWS.EDITIONID) {
							} else {
								$New_Wim_Edition_Error = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.AE_New_EditionID): $($empDetail.WINDOWS.EDITIONID) < $($lang.Prerequisite_Not_satisfied)"
								}
								$New_Wim_Edition_Error_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 10
									Width          = 460
								}

								$Group_Image_Sources.controls.AddRange((
									$New_Wim_Edition_Error,
									$New_Wim_Edition_Error_Wrap
								))
							}

							$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Image_Name): $($empDetail.NAME)"
							}
							$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 10
								Width          = 460
							}
							$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Image_Description): $($empDetail.DESCRIPTION)"
							}
							$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 10
								Width          = 460
							}
							$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Display_Name): $($empDetail.DISPLAYNAME)"
							}
							$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 10
								Width          = 460
							}
							$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Display_Description): $($empDetail.DISPLAYDESCRIPTION)"
							}
							$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 25
								Width          = 460
							}

							$Group_Image_Sources.controls.AddRange((
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

						New-Variable -Scope global -Name "Queue_Process_Image_Select_$($Uid)" -Value $TempQueueProcessImageSelect -Force
						Remove-Item -Path $Export_To_New_Xml
					}
				} else {
					try {
						Get-WindowsImage -ImagePath $ImageFilePath -ErrorAction SilentlyContinue | ForEach-Object {
							Get-WindowsImage -ImagePath $ImageFilePath -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
								$TempQueueProcessImageSelect += [pscustomobject]@{
									Index            = $_.ImageIndex
									Name             = $_.ImageName
									ImageDescription = $_.ImageDescription
									EditionId        = $_.EditionId
								}

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
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Name): $($_.ImageName)"
								}
								$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 10
									Width          = 460
								}
								$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Description): $($_.ImageDescription)"
								}
								$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 25
									Width          = 460
								}

								$Group_Image_Sources.controls.AddRange((
									$CheckBox,
									$New_Wim_Image_Name,
									$New_Wim_Image_Name_Wrap,
									$New_Wim_Image_Description,
									$New_Wim_Image_Description_Wrap
								))
							}
						}

						New-Variable -Scope global -Name "Queue_Process_Image_Select_$($Uid)" -Value $TempQueueProcessImageSelect -Force
					} catch {
						$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height         = 40
							Width          = 460
							margin         = "16,0,0,0"
							Text           = "$($lang.SelectFromError): $($lang.UpdateUnavailable)"
						}

						$Group_Image_Sources.controls.AddRange($UI_Main_Other_Rule_Not_Find)
					}
				}
			} else {
				<#
					.未发现文件
				#>
				$UI_Main_Autopoilot_Expand_Select_Index= New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 30
					Width          = 460
					Text           = $lang.Index_Is_Event_Select
					margin         = "16,0,0,35"
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 11"

						Image_Select_Index_Custom_UI
						Autopilot_Refresh_Event_All
					}
				}

				$paneel.controls.AddRange($UI_Main_Autopoilot_Expand_Select_Index)
			}
		}

		$Group_Image_Sources_Console = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			autosize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			margin         = "0,0,0,35"
			Name           = "ImageSourcesConsole"
		}
		$paneel.controls.AddRange($Group_Image_Sources_Console)

		<#
			.组，有新的挂载映像时
		#>
		$GUIImageSelectFunctionNeedMount = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Text           = $lang.AssignNeedMount
		}

		<#
			.解决方案：创建
		#>
		$GUIImageSelectFunctionSolutions = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = "$($lang.Solution): $($lang.IsCreate)"
			Tag            = "Solutions_Create_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 3s11"

				Solutions_Create_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionSolutions_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，语言
		#>
		$GUIImageSelectFunctionLang = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.Language
		}
		$GUIImageSelectFunctionLangAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Language_Add_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 111"

				Language_Add_UI
				Autopilot_Refresh_Event_All
			}
		}

		$GUIImageSelectFunctionLangDel = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Language_Delete_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 112"

				Language_Delete_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionLangChange = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.SwitchLanguage
			Tag            = "Language_Change_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 113"

				Language_Change_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectLangComponents = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.OnlyLangCleanup
			Tag            = "Language_Cleanup_Components_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 114"

				Language_Cleanup_Components_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，InBox Apps
		#>
		$GUIImageSelectInBoxApps = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.InboxAppsManager
		}
		$GUIImageSelectInBoxAppsOne = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)"
			Tag            = "LXPs_Region_Add"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 200"

				LXPs_Region_Add
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectInBoxAppsTwo = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.InboxAppsManager): $($lang.AddTo)"
			Tag            = "InBox_Apps_Add_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 211"

				InBox_Apps_Add_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectInBoxApps_Update = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)"
			Tag            = "LXPs_Update_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 222"

				LXPs_Update_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectInBoxApps_Delete = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)"
			Tag            = "LXPs_Remove_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 22222"

				LXPs_Remove_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectInBoxApps_Match_Delete = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.InboxAppsMatchDel
			Tag            = "InBox_Apps_Match_Delete_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 233"

				InBox_Apps_Match_Delete_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectInBoxApps_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，更新
		#>
		$GUIImageSelectFunctionUpdate = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.CUpdate
		}
		$GUIImageSelectFunctionUpdateAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Cumulative_updates_Add_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 300"

				Cumulative_updates_Add_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionUpdateDel = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Cumulative_updates_Delete_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 311"

				Cumulative_updates_Delete_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionUpdate_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，驱动
		#>
		$GUIImageSelectFunctionDrive = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.Drive
		}
		$GUIImageSelectFunctionDriveAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Drive_Add_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 500"

				Drive_Add_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionDriveDel = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Drive_Delete_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 510"

				Drive_Delete_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionDrive_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.组，Windows 功能
		#>
		$GUIImageSelectFunctionWindowsFeature = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.WindowsFeature
		}
		<#
			.Windows 功能
		#>
		$UI_Main_Need_Mount_Feature_Enabled_Match = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.Enable), $($lang.MatchMode)"
			Tag            = "Feature_Enabled_Match_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 600"

				Feature_Enabled_Match_UI
				Autopilot_Refresh_Event_All
			}
		}
		$UI_Main_Need_Mount_Feature_Disable_Match = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = "$($lang.Disable), $($lang.MatchMode)"
			Tag            = "Feature_Disable_Match_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 610"

				Feature_Disable_Match_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImageSelectFunctionWindowsFeature_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.更多功能
		#>
		$GUIImageSelectFeature_More_UI = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.MoreFeature
			Tag            = "Feature_More_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 800"

				Feature_More_UI
				Autopilot_Refresh_Event_All
			}
		}

		<#
			.运行 PowerShell 函数
		#>
		$GUIImage_Special_Function = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.SpecialFunction
		}
		$GUIImage_Functions_Before = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Before
			Tag            = "Functions_Before_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 900"

				Functions_Before_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImage_Functions_Rear = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Rear
			Tag            = "Functions_Rear_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 910"

				Functions_Rear_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImage_Special_Function_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		<#
			.运行 API
		#>
		$GUIImage_Special_API = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 450
			Padding        = "15,0,0,0"
			Text           = $lang.API
		}
		$GUIImage_APIs_Before = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Before
			Tag            = "API_Before_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 900"

				API_Before_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImage_API_Rear = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 450
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Rear
			Tag            = "API_Rear_UI"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Set_Global_Primary_Key -Uid $this.Parent.Parent.Name -Silent -DevCode "Autopilot - 910"

				API_Rear_UI
				Autopilot_Refresh_Event_All
			}
		}
		$GUIImage_Special_API_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
		}

		$UI_Image_Eject_Force_Main = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "EjectForce"
			Height         = 35
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = $lang.Image_Eject_Force
			Tag            = $Uid
			add_Click      = {
				if ($This.Checked) {
					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($This.Tag -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSourcesConsole") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
												if ($_.Tag -eq "EjectMain") {
													$_.Enabled = $True
												}
											}
										}
									}
								}
							}
						}
					}
				} else {
					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($This.Tag -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSourcesConsole") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
												if ($_.Tag -eq "EjectMain") {
													$_.Enabled = $false
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
		}

		$UI_Image_Eject_Force_Expand = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "EjectForce"
			Height         = 35
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = $lang.Image_Eject_Force
			Tag            = $Uid
			add_Click      = {
				if ($This.Checked) {
					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($This.Tag -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSourcesConsole") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
												if ($_.Tag -eq "EjectExpand") {
													$_.Enabled = $True
												}
											}
										}
									}
								}
							}
						}
					}
				} else {
					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($This.Tag -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSourcesConsole") {
										ForEach ($_ in $_.Controls) {
											if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
												if ($_.Tag -eq "EjectExpand") {
													$_.Enabled = $False
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
		}

		<#
			.保存：主要项
		#>
		$GUIImageSelectImageEject_Tips_Main = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			Padding        = "15,0,0,0"
			margin         = "0,25,0,0"
			Text           = $lang.UnmountNotAssignMain -f $MainUid
		}
		$GUIImageSelectImageEject_Tips_Main_New = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			Padding        = "31,0,0,0"
			margin         = "0,20,0,15"
			Text           = $lang.UnmountNotAssignMain_Tips
		}
		$UI_Main_Eject_Mount_Main = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			Name           = $MainUid
			Tag            = "EjectMain"
			BorderStyle    = 0
			AutoSize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Padding        = "31,0,0,0"
		}

		<#
			.允许开启快速抛弃方式
		#>
		$UI_Main_Eject_Mount_Abandon_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 55
			Width          = 405
			Text           = $lang.Abandon_Allow
			Tag            = "AbandonAllow"
		}

			<#
				.保存
			#>
			$UI_Main_Eject_Mount_Save_Main = New-Object System.Windows.Forms.RadioButton -Property @{
				Height         = 55
				Width          = 405
				Text           = "$($lang.Save)`n$($MainUid)"
				Tag            = "Save"
			}

			<#
				.不保存
			#>
			$UI_Main_Eject_Mount_DoNotSave_Main = New-Object System.Windows.Forms.RadioButton -Property @{
				Height         = 55
				Width          = 405
				Text           = "$($lang.DoNotSave)`n$($MainUid)"
				Tag            = "DoNotSave"
			}

		<#
			.保存：扩展项
		#>
		$GUIImageSelectImageEject_Tips = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			Padding        = "15,0,0,0"
			margin         = "0,25,0,0"
			Text           = $lang.ImageEjectDone
		}
		$UI_Main_Eject_Mount_Expand = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			Name           = $Uid
			Tag            = "EjectExpand"
			BorderStyle    = 0
			AutoSize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Padding        = "31,0,0,0"
		}

			<#
				.保存
			#>
			$UI_Main_Eject_Mount_Save_Expand = New-Object System.Windows.Forms.RadioButton -Property @{
				Height         = 55
				Width          = 405
				Text           = "$($lang.Save)`n$($Uid)"
				Tag            = "Save"
			}

			<#
				.不保存
			#>
			$UI_Main_Eject_Mount_DoNotSave_Expand = New-Object System.Windows.Forms.RadioButton -Property @{
				Height         = 55
				Width          = 405
				Text           = "$($lang.DoNotSave)`n$($Uid)"
				Tag            = "DoNotSave"
			}

			<#
				.扩展项
			#>
			$GUIImage_Select_Expand_Group = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
				Tag            = "ADV"
				BorderStyle    = 0
				AutoSize       = 1
				autoSizeMode   = 1
				autoScroll     = $False
				Padding        = "15,0,0,0"
			}

		$GUIImage_Select_Expand = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 430
			Text           = $lang.Event_Assign_Expand
		}

		<#
			.重建
		#>
		$GUIImage_Select_Expand_Rebuild = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 30
			Width          = 430
			Padding        = "16,0,0,0"
			Text           = $lang.Reconstruction -f $ImageName
			Tag            = "Rebuild"
			add_Click      = {
				if ($this.Checked) {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Open
				} else {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Close
				}

				Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -MainUid $this.Parent.Parent.Parent.Name
			}
		}
		$GUIImage_Select_Expand_Rebuild_Tips = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			Padding        = "35,0,0,0"
			margin         = "0,0,0,25"
			Text           = $lang.Reconstruction_Tips_Select
		}

		<#
			.允许更新规则
		#>
		$GUIImage_Select_Expand_Rule = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 30
			Width          = 432
			Padding        = "16,0,0,0"
			Text           = $lang.Event_Allow_Update_Rule
			Tag            = "Is_Update_Rule"
			add_Click      = {
				if ($this.Checked) {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Open
				} else {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Close
				}

				Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -MainUid $this.Parent.Parent.Parent.Name
			}
		}
		$GUIImage_Select_Expand_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			margin         = "33,0,0,0"
			Text           = $lang.Event_Allow_Update_Rule_Tips -f $ImageName, $Master, $ImageName, $Master
		}

		<#
			.更新到所有索引号
		#>
		$GUIImage_Select_Expand_Rule_To_All = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 30
			Width          = 427
			Padding        = "35,0,0,0"
			margin         = "0,35,0,0"
			Text           = $lang.Event_Allow_Update_To_All
			Tag            = "Is_Update_Rule_Expand_To_All"
			add_Click      = {
				if ($this.Checked) {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Open
				} else {
					Image_Select_Disable_Expand_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -Name $this.Tag -Close
				}
				Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Parent.Parent.Parent.Name -MainUid $this.Parent.Parent.Parent.Name
			}
		}
		$GUIImage_Select_Expand_Rule_To_All_Tips = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			margin         = "54,0,0,25"
			Text           = $lang.Event_Allow_Update_To_All_Tips -f $ImageName, $Master, $Group
		}

		switch -Wildcard ($Uid) {
			#region boot;wim;boot;wim;
			"Boot;wim;Boot;wim;" {
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x2`n  Start"
				}

				$Group_Image_Sources_Console.controls.AddRange((
					$GUIImageSelectFunctionNeedMount,

						$GUIImageSelectFunctionSolutions,
							$GUIImageSelectFunctionSolutions_Wrap,

						$GUIImageSelectFunctionLang,
							$GUIImageSelectFunctionLangAdd,
							$GUIImageSelectFunctionLangDel,
							$GUIImageSelectFunctionLangChange,
							$GUIImageSelectLangComponents,
							$GUIImageSelectFunctionLang_Wrap,

						$GUIImageSelectInBoxApps,
							$GUIImageSelectInBoxAppsOne,
							$GUIImageSelectInBoxAppsTwo,
							$GUIImageSelectInBoxApps_Update,
							$GUIImageSelectInBoxApps_Delete,
							$GUIImageSelectInBoxApps_Match_Delete,
							$GUIImageSelectInBoxApps_Wrap,

						$GUIImageSelectFunctionUpdate,
							$GUIImageSelectFunctionUpdateAdd,
							$GUIImageSelectFunctionUpdateDel,
							$GUIImageSelectFunctionUpdate_Wrap,

						$GUIImageSelectFunctionDrive,
							$GUIImageSelectFunctionDriveAdd,
							$GUIImageSelectFunctionDriveDel,
							$GUIImageSelectFunctionDrive_Wrap,

						$GUIImageSelectFunctionWindowsFeature,
							$UI_Main_Need_Mount_Feature_Enabled_Match,
							$UI_Main_Need_Mount_Feature_Disable_Match,
							$GUIImageSelectFunctionWindowsFeature_Wrap,

						$GUIImage_Special_Function,
							$GUIImage_Functions_Before,
							$GUIImage_Functions_Rear,
							$GUIImage_Special_Function_Wrap,

						$GUIImage_Special_API,
							$GUIImage_APIs_Before,
							$GUIImage_API_Rear,
							$GUIImage_Special_API_Wrap,

						$GUIImageSelectFeature_More_UI
				))
				$Group_Image_Sources_Console.controls.AddRange($GUIImage_Select_Expand_Group)
				$GUIImage_Select_Expand_Group.controls.AddRange((
					$GUIImage_Select_Expand,
					$GUIImage_Select_Expand_Rebuild,
					$GUIImage_Select_Expand_Rebuild_Tips
				))

				<#
					.挂载
				#>
				if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)").Value) {
					$Group_Image_Sources_Console.controls.AddRange((
						$UI_Image_Eject_Force_Main,
						$UI_Main_Eject_Mount_Main
					))

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
							"True" {
								$UI_Main_Eject_Mount_Main.controls.AddRange($UI_Main_Eject_Mount_Abandon_Allow)
	
								if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
									switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
										"True" {
											$UI_Main_Eject_Mount_Abandon_Allow.Checked = $True
										}
									}
								}
							}
						}
					}

					$UI_Main_Eject_Mount_Main.controls.AddRange((
						$UI_Main_Eject_Mount_Save_Main,
						$UI_Main_Eject_Mount_DoNotSave_Main
					))

					if ($UI_Image_Eject_Force_Main.Checked) {
						$UI_Main_Eject_Mount_Main.Enabled = $True
					} else {
						$UI_Main_Eject_Mount_Main.Enabled = $False
					}

					$UI_Main_Eject_Mount_Save_Main.Checked = $True
				} else {
					$Group_Image_Sources_Console.controls.AddRange((
						$GUIImageSelectImageEject_Tips_Main,
						$UI_Main_Eject_Mount_Main
					))

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
							"True" {
								$UI_Main_Eject_Mount_Main.controls.AddRange($UI_Main_Eject_Mount_Abandon_Allow)

								if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
									switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
										"True" {
											$UI_Main_Eject_Mount_Abandon_Allow.Checked = $True
										}
									}
								}
							}
						}
					}

					$UI_Main_Eject_Mount_Main.controls.AddRange((
						$UI_Main_Eject_Mount_Save_Main,
						$UI_Main_Eject_Mount_DoNotSave_Main
					))

					$UI_Main_Eject_Mount_Save_Main.Checked = $True
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x2`n  End"
				}
			}
			#endregion

			#region Install;Install;wim;
			{ "Install;wim;Install;wim;", "Install;esd;Install;esd;" -eq $_ } {
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x6`n  Start"
				}

				$Group_Image_Sources_Console.controls.AddRange((
					$GUIImageSelectFunctionNeedMount,

						$GUIImageSelectFunctionSolutions,
							$GUIImageSelectFunctionSolutions_Wrap,

						$GUIImageSelectFunctionLang,
							$GUIImageSelectFunctionLangAdd,
							$GUIImageSelectFunctionLangDel,
							$GUIImageSelectFunctionLangChange,
							$GUIImageSelectLangComponents,
							$GUIImageSelectFunctionLang_Wrap,

						$GUIImageSelectInBoxApps,
							$GUIImageSelectInBoxAppsOne,
							$GUIImageSelectInBoxAppsTwo,
							$GUIImageSelectInBoxApps_Update,
							$GUIImageSelectInBoxApps_Delete,
							$GUIImageSelectInBoxApps_Match_Delete,
							$GUIImageSelectInBoxApps_Wrap,

						$GUIImageSelectFunctionUpdate,
							$GUIImageSelectFunctionUpdateAdd,
							$GUIImageSelectFunctionUpdateDel,
							$GUIImageSelectFunctionUpdate_Wrap,

						$GUIImageSelectFunctionDrive,
							$GUIImageSelectFunctionDriveAdd,
							$GUIImageSelectFunctionDriveDel,
							$GUIImageSelectFunctionDrive_Wrap,

						$GUIImageSelectFunctionWindowsFeature,
							$UI_Main_Need_Mount_Feature_Enabled_Match,
							$UI_Main_Need_Mount_Feature_Disable_Match,
							$GUIImageSelectFunctionWindowsFeature_Wrap,

						$GUIImage_Special_Function,
							$GUIImage_Functions_Before,
							$GUIImage_Functions_Rear,
							$GUIImage_Special_Function_Wrap,

						$GUIImage_Special_API,
							$GUIImage_APIs_Before,
							$GUIImage_API_Rear,
							$GUIImage_Special_API_Wrap,

						$GUIImageSelectFeature_More_UI,

					$GUIImage_Select_Expand_Group
				))
				$GUIImage_Select_Expand_Group.controls.AddRange((
					$GUIImage_Select_Expand,
					$GUIImage_Select_Expand_Rebuild,
					$GUIImage_Select_Expand_Rebuild_Tips
				))

				<#
					.挂载
				#>
				if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)").Value) {
					$Group_Image_Sources_Console.controls.AddRange((
						$UI_Image_Eject_Force_Main,
						$UI_Main_Eject_Mount_Main
					))

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
							"True" {
								$UI_Main_Eject_Mount_Main.controls.AddRange($UI_Main_Eject_Mount_Abandon_Allow)

								if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
									switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
										"True" {
											$UI_Main_Eject_Mount_Abandon_Allow.Checked = $True
										}
									}
								}
							}
						}
					}

					$UI_Main_Eject_Mount_Main.controls.AddRange((
						$UI_Main_Eject_Mount_Save_Main,
						$UI_Main_Eject_Mount_DoNotSave_Main
					))

					if ($UI_Image_Eject_Force_Main.Checked) {
						$UI_Main_Eject_Mount_Main.Enabled = $True
					} else {
						$UI_Main_Eject_Mount_Main.Enabled = $False
					}

					$UI_Main_Eject_Mount_Save_Main.Checked = $True
				} else {
					$Group_Image_Sources_Console.controls.AddRange((
						$GUIImageSelectImageEject_Tips_Main,
						$UI_Main_Eject_Mount_Main
					))

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
							"True" {
								$UI_Main_Eject_Mount_Main.controls.AddRange($UI_Main_Eject_Mount_Abandon_Allow)

								if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
									switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
										"True" {
											$UI_Main_Eject_Mount_Abandon_Allow.Checked = $True
										}
									}
								}
							}
						}
					}

					$UI_Main_Eject_Mount_Main.controls.AddRange((
						$UI_Main_Eject_Mount_Save_Main,
						$UI_Main_Eject_Mount_DoNotSave_Main
					))

					$UI_Main_Eject_Mount_Save_Main.Checked = $True
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x6`n  End"
				}
			}
			#endregion

				#region Install;WinRE;wim
				"Install;wim;WinRE;wim;" {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x5`n  Start"
					}

					$Group_Image_Sources_Console.controls.AddRange((
						$GUIImageSelectFunctionNeedMount,

							$GUIImageSelectFunctionSolutions,
								$GUIImageSelectFunctionSolutions_Wrap,
	
							$GUIImageSelectFunctionLang,
								$GUIImageSelectFunctionLangAdd,
								$GUIImageSelectFunctionLangDel,
								$GUIImageSelectFunctionLangChange,
								$GUIImageSelectLangComponents,
								$GUIImageSelectFunctionLang_Wrap,

							$GUIImageSelectInBoxApps,
								$GUIImageSelectInBoxAppsOne,
								$GUIImageSelectInBoxAppsTwo,
								$GUIImageSelectInBoxApps_Update,
								$GUIImageSelectInBoxApps_Delete,
								$GUIImageSelectInBoxApps_Match_Delete,
								$GUIImageSelectInBoxApps_Wrap,

							$GUIImageSelectFunctionUpdate,
								$GUIImageSelectFunctionUpdateAdd,
								$GUIImageSelectFunctionUpdateDel,
								$GUIImageSelectFunctionUpdate_Wrap,

							$GUIImageSelectFunctionDrive,
								$GUIImageSelectFunctionDriveAdd,
								$GUIImageSelectFunctionDriveDel,
								$GUIImageSelectFunctionDrive_Wrap,

							$GUIImageSelectFunctionWindowsFeature,
								$UI_Main_Need_Mount_Feature_Enabled_Match,
								$UI_Main_Need_Mount_Feature_Disable_Match,
								$GUIImageSelectFunctionWindowsFeature_Wrap,

							$GUIImage_Special_Function,
								$GUIImage_Functions_Before,
								$GUIImage_Functions_Rear,
								$GUIImage_Special_Function_Wrap,

							$GUIImage_Special_API,
								$GUIImage_APIs_Before,
								$GUIImage_API_Rear,
								$GUIImage_Special_API_Wrap,

							$GUIImageSelectFeature_More_UI
					))

					$Group_Image_Sources_Console.controls.AddRange($GUIImage_Select_Expand_Group)
					$GUIImage_Select_Expand_Group.controls.AddRange((
						$GUIImage_Select_Expand,
						$GUIImage_Select_Expand_Rebuild,
						$GUIImage_Select_Expand_Rebuild_Tips,
						$GUIImage_Select_Expand_Rule,
						$GUIImage_Select_Expand_Rule_Tips,
						$GUIImage_Select_Expand_Rule_To_All,
						$GUIImage_Select_Expand_Rule_To_All_Tips
					))

					#region 挂载：当前
					if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)").Value) {
						$Group_Image_Sources_Console.controls.AddRange((
							$UI_Image_Eject_Force_Expand,
							$UI_Main_Eject_Mount_Expand
						))
						$UI_Main_Eject_Mount_Expand.controls.AddRange((
							$UI_Main_Eject_Mount_Save_Expand,
							$UI_Main_Eject_Mount_DoNotSave_Expand
						))

						if ($UI_Image_Eject_Force_Expand.Checked) {
							$UI_Main_Eject_Mount_Expand.Enabled = $True
						} else {
							$UI_Main_Eject_Mount_Expand.Enabled = $False
						}

						$UI_Main_Eject_Mount_Save_Expand.Checked = $True
					} else {
						$Group_Image_Sources_Console.controls.AddRange((
							$GUIImageSelectImageEject_Tips,
							$UI_Main_Eject_Mount_Expand
						))
						$UI_Main_Eject_Mount_Expand.controls.AddRange((
							$UI_Main_Eject_Mount_Save_Expand,
							$UI_Main_Eject_Mount_DoNotSave_Expand
						))

						$UI_Main_Eject_Mount_Save_Expand.Checked = $True
					}
					#endregion

					#region 挂载：指定 Install
					if (((Get-Variable -Scope global -Name "Mark_Is_Mount_install;wim;install;wim;").Value) -or 
						((Get-Variable -Scope global -Name "Mark_Is_Mount_install;esd;install;esd;").Value)) {
					} else {
						$Group_Image_Sources_Console.controls.AddRange((
							$GUIImageSelectImageEject_Tips_Main,
							$GUIImageSelectImageEject_Tips_Main_New,
							$UI_Main_Eject_Mount_Main
						))

						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
							switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
								"True" {
									$UI_Main_Eject_Mount_Main.controls.AddRange($UI_Main_Eject_Mount_Abandon_Allow)

									if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
										switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
											"True" {
												$UI_Main_Eject_Mount_Abandon_Allow.Checked = $True
											}
										}
									}
								}
							}
						}

						$UI_Main_Eject_Mount_Main.controls.AddRange((
							$UI_Main_Eject_Mount_Save_Main,
							$UI_Main_Eject_Mount_DoNotSave_Main
						))

						$UI_Main_Eject_Mount_Save_Main.Checked = $True
					}
					#endregion

					$GUIImage_Select_Expand_Rebuild.Checked = $True
					$GUIImage_Select_Expand_Rule.Checked = $True
					$GUIImage_Select_Expand_Rule_To_All.Checked = $True

					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.0x5`n  End"
					}
				}
				#endregion
		}

		$UI_Main_Select_Assign_Multitasking.controls.AddRange($paneel)
	}

	Function Image_Select_Disable_Expand_Main_Item_Autopilot
	{
		param
		(
			$Group,
			$MainUid
		)

		$Wait_Sync_Some_Select = @()
		$UI_Main_Select_Wim.Controls | ForEach-Object {
			if ($_.Enabled) {
				if ($_.Checked) {
					$Wait_Sync_Some_Select += $_.Tag
				}
			}
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.009x2`n  Start"
			Write-Host "`n  $($lang.Choose)"
			ForEach ($item in $Wait_Sync_Some_Select) {
				Write-Host "  $($item)"
			}
		}

		$Wait_Match_Expand_Item = @()
		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				if ($item.Main.Uid -eq $MainUid) {
					if ($item.Expand.Count -gt 0) {
						$Wait_Match_Expand_Item += $item.Expand.Uid
					}
				}
			}
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.009x99`n  Start"
			Write-Host "`n  $($lang.Event_Primary_Key)"
			ForEach ($item in $Wait_Match_Expand_Item) {
				Write-Host "  $($item)"
			}
		}

		if ($Wait_Match_Expand_Item.Count -gt 0) {
			ForEach ($item in $Wait_Match_Expand_Item) {
				<#
					.关闭所有扩展项
				#>
				$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
						if ($item -eq $_.Name) {
							$_.Controls | ForEach-Object {
								if ($_.Name -eq "ImageSourcesConsole") {
									ForEach ($_ in $_.Controls) {
										if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
											if ($_.Tag -eq "EjectMain") {
												$_.Enabled = $False

												if ($Wait_Sync_Some_Select -Contains $_.Name) {
													if ($Global:Developers_Mode) {
														Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.001x1`n  Start"
														Write-Host "  $($lang.Disable): " -NoNewline
														Write-Host $_.Name -ForegroundColor Green
													}
												} else {
													if ($Global:Developers_Mode) {
														Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.002x2`n  Start"
														Write-Host "  $($lang.Enable): " -NoNewline
														Write-Host $_.Name -ForegroundColor Red
													}

													$_.Enabled = $True
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
		}
	}

	Function Image_Select_Disable_Expand_Item_Autopilot
	{
		param
		(
			$Group,
			$Name,
			[switch]$Open,
			[switch]$Close
		)

		$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				if ($Group -eq $_.Name) {
					$_.Controls | ForEach-Object {
						if ($_.Name -eq "ImageSourcesConsole") {
							ForEach ($ImageSourcesConsole in $_.Controls) {
								if ($ImageSourcesConsole -is [System.Windows.Forms.FlowLayoutPanel]) {
									if ($ImageSourcesConsole.Tag -eq "ADV") {
										ForEach ($ItemNew in $ImageSourcesConsole.Controls) {
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
		}
	}

	<#
		.添加控件按钮

		映像文件：
			判断文件格式是否正确：
				1.    正确
					  1.1   主文件：判断当前文件是否挂载
							1.1.1    已挂载：变绿色
									 1.1.1.1    判断是否有扩展项
												1.1.1.1.1    有

												1.1.1.1.2    无

							1.1.2    未挂载

				2.    不正确，提示文件错误。
	#>
	Function Image_Select_Refresh_Install_Boot_WinRE_Autopilot
	{
		$UI_Main_Select_Wim.controls.clear()
		$UI_Main_Select_Assign_Multitasking.controls.clear()

		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				$NewFileFullPathMain = "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)"

				$UI_Expand_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 440
				}

				<#
					.批量模式
				#>
				if ($Global:AutopilotMode) {
					if (Test-Path -Path $NewFileFullPathMain -PathType Leaf) {
						$GUIImageSelectInstall = New-Object System.Windows.Forms.CheckBox -Property @{
							Name               = $item.Main.Uid
							Tag                = $item.Main.Uid
							Height             = 30
							Width              = 440
							Text               = "$($item.Main.ImageFileName).$($item.Main.Suffix)"
							Checked            = $True
							add_Click          = {
								Check_Select_New_Autopilot
								Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Tag -MainUid $this.Name
							}
						}

						if ($Global:Primary_Key_Image.Uid -eq $item.Main.Uid) {
							$GUIImageSelectInstall.Checked = $True
						}

						$UI_Main_Select_Wim.controls.AddRange($GUIImageSelectInstall)

						$Verify_Main_WIM = @()
						try {
							Get-WindowsImage -ImagePath $NewFileFullPathMain -ErrorAction SilentlyContinue | ForEach-Object {
								$Verify_Main_WIM += [pscustomobject]@{
									Name   = $_.ImageName
									Index  = $_.ImageIndex
								}
							}
						} catch {
							$GUIImageSelectInstall.Text = "$($item.Main.ImageFileName).$($item.Main.Suffix), $($lang.SelectFileFormatError)"
							$GUIImageSelectInstall.Enabled = $false
							$GUIImageSelectInstall.ForeColor = "#FF0000"
						}

						#region 获取到主文件里有映像内容
						if ($Verify_Main_WIM.Count -gt 0) {
							Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add -Master $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -Uid $item.Main.Uid -MainUid $item.Main.Uid -Group $item.Main.Group -ImageFilePath $NewFileFullPathMain -Mainquests

							#region 获取是否挂载
							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($item.Main.Uid)").Value) {
								$GUIImageSelectInstall.ForeColor = "#008000"
								$GUIImageSelectInstall.Checked = $True

								if ($item.Expand.Count -gt 0) {
									ForEach ($Expand in $item.Expand) {
										$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

										$GUIImageSelectInstallExpand = New-Object System.Windows.Forms.CheckBox -Property @{
											Name               = $item.Main.Uid
											Tag                = $Expand.Uid
											Height             = 35
											Width              = 423
											margin             = "20,0,0,0"
											Text               = "$($Expand.ImageFileName).$($Expand.Suffix)"
											add_Click          = {
												Check_Select_New_Autopilot
												Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Tag -MainUid $this.Name
											}
										}

										if ($Global:Primary_Key_Image.Uid -eq $Expand.Uid) {
											$GUIImageSelectInstallExpand.Checked = $True
										}

										$UI_Main_Pri_Key_Setting_Expand_Not = New-Object system.Windows.Forms.Label -Property @{
											Height         = 30
											Width          = 442
											Padding        = "33,0,0,0"
											Text           = $lang.NoInstallImage
										}
										$UI_Main_Select_Wim.controls.AddRange($GUIImageSelectInstallExpand)

										#region 已挂载是存在文件
										if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
											Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add -Tasks $Expand -Master $item.Main.ImageFileName -ImageName $Expand.ImageFileName -Uid $Expand.Uid -MainUid $item.Main.Uid -Group $Expand.Group -ImageFilePath $test_mount_folder_Current

											$Verify_Expand_WIM = @()

											try {
												Get-WindowsImage -ImagePath $test_mount_folder_Current -ErrorAction SilentlyContinue | ForEach-Object {
													$Verify_Expand_WIM += [pscustomobject]@{
														Name   = $_.ImageName
														Index  = $_.ImageIndex
													}
												}
											} catch {
												$GUIImageSelectInstallExpand.Text = "$($Expand.ImageFileName).$($Expand.Suffix), $($lang.SelectFileFormatError)"
												$GUIImageSelectInstallExpand.Enabled = $False
												$GUIImageSelectInstallExpand.ForeColor = "#FF0000"
											}

											if ($Verify_Expand_WIM.Count -gt 0) {
												$UI_Main_Select_Wim.controls.AddRange($UI_Expand_Wrap)

												if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Expand.Uid)").Value) {
													$GUIImageSelectInstallExpand.ForeColor = "#008000"
													$GUIImageSelectInstallExpand.Checked = $True
												}
											}
										} else {
											$GUIImageSelectInstallExpand.Enabled = $False
											$GUIImageSelectInstallExpand.Checked = $False
											$UI_Main_Select_Wim.controls.AddRange((
												$UI_Main_Pri_Key_Setting_Expand_Not,
												$UI_Expand_Wrap
											))
										}
										#endregion 已挂载是存在文件
									}
								}
							} else {
								if ($item.Expand.Count -gt 0) {
									ForEach ($Expand in $item.Expand) {
										$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

										Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add -Tasks $Expand -Master $item.Main.ImageFileName -ImageName $Expand.ImageFileName -Uid $Expand.Uid -MainUid $item.Main.Uid -Group $Expand.Group -ImageFilePath $test_mount_folder_Current

										$GUIImageSelectInstallExpand = New-Object System.Windows.Forms.CheckBox -Property @{
											Name               = $item.Main.Uid
											Tag                = $Expand.Uid
											Height             = 35
											Width              = 423
											margin             = "20,0,0,0"
											Text               = "$($Expand.ImageFileName).$($Expand.Suffix)"
											add_Click          = {
												Check_Select_New_Autopilot
												Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Tag -MainUid $this.Name
											}
										}

										if ($Global:Primary_Key_Image.Uid -eq $Expand.Uid) {
											$GUIImageSelectInstallExpand.Checked = $True
										}

										$UI_Main_Select_Wim.controls.AddRange((
											$GUIImageSelectInstallExpand,
											$UI_Expand_Wrap
										))
									}
								}
							}
							#endregion 获取是否挂载
						}
						#endregion
					} else {
						# 无主要文件
					}

					Check_Select_New_Autopilot
				} else {
					<#
						.非批量模式
					#>
					if (Test-Path -Path $NewFileFullPathMain -PathType Leaf) {
						$GUIImageSelectInstall = New-Object System.Windows.Forms.RadioButton -Property @{
							Name               = $item.Main.Uid
							Tag                = $item.Main.Uid
							Height             = 35
							Width              = 380
							Text               = "$($item.Main.ImageFileName).$($item.Main.Suffix)"
							add_Click          = {
								Check_Select_New_Autopilot
								Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Tag -MainUid $this.Name
							}
						}

						if ($Global:Primary_Key_Image.Uid -eq $item.Main.Uid) {
							$GUIImageSelectInstall.Checked = $True
						}

						$UI_Main_Select_Wim.controls.AddRange($GUIImageSelectInstall)

						$Verify_Main_WIM = @()
						try {
							Get-WindowsImage -ImagePath $NewFileFullPathMain -ErrorAction SilentlyContinue | ForEach-Object {
								$Verify_Main_WIM += [pscustomobject]@{
									Name   = $_.ImageName
									Index  = $_.ImageIndex
								}
							}
						} catch {
							$GUIImageSelectInstall.Text = "$($item.Main.ImageFileName).$($item.Main.Suffix), $($lang.SelectFileFormatError)"
							$GUIImageSelectInstall.Enabled = $False
							$GUIImageSelectInstall.ForeColor = "#FF0000"
						}

						if ($Verify_Main_WIM.Count -gt 0) {
							Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add -Tasks $item.Main -Master $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -Uid $item.Main.Uid -MainUid $item.Main.Uid -Group $item.Main.Group -ImageFilePath $NewFileFullPathMain -Mainquests

							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($item.Main.Uid)").Value) {
								$GUIImageSelectInstall.ForeColor = "#FF0000"
							}

							if ($item.Expand.Count -gt 0) {
								ForEach ($Expand in $item.Expand) {
									$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

									if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
										$GUIImageSelectInstallExpand = New-Object System.Windows.Forms.RadioButton -Property @{
											Name               = $item.Main.Uid
											Tag                = $Expand.Uid
											Height             = 40
											Width              = 363
											margin             = "20,0,0,0"
											Text               = "$($Expand.ImageFileName).$($Expand.Suffix)"
											add_Click          = {
												Check_Select_New_Autopilot
												Image_Select_Disable_Expand_Main_Item_Autopilot -Group $this.Tag -MainUid $this.Name
											}
										}

										if ($Global:Primary_Key_Image.Uid -eq "$($item.Main.ImageFileName);$($Expand.ImageFileName);$($Expand.Suffix);") {
											$GUIImageSelectInstallExpand.Checked = $True
										}

										$UI_Main_Select_Wim.controls.AddRange($GUIImageSelectInstallExpand)

										$Verify_Expand_WIM = @()
										try {
											Get-WindowsImage -ImagePath $test_mount_folder_Current -ErrorAction SilentlyContinue | ForEach-Object {
												$Verify_Expand_WIM += [pscustomobject]@{
													Name   = $_.ImageName
													Index  = $_.ImageIndex
												}
											}
										} catch {
											$GUIImageSelectInstallExpand.Text = "$($Expand.ImageFileName).$($Expand.Suffix), $($lang.SelectFileFormatError)"
											$GUIImageSelectInstallExpand.Enabled = $False
											$GUIImageSelectInstallExpand.ForeColor = "#FF0000"
										}

										if ($Verify_Expand_WIM.Count -gt 0) {
											Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Add -Tasks $Expand -Master $item.Main.ImageFileName -ImageName $Expand.ImageFileName -Uid $Expand.Uid -MainUid $item.Main.Uid -Group $Expand.Group -ImageFilePath $test_mount_folder_Current

											if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Expand.Uid)").Value) {
												$GUIImageSelectInstallExpand.ForeColor = "#FF0000"
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

		Autopilot_Refresh_Event_All
	}

	Function Check_Select_New_Autopilot
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$MainItem = @()
		$disable  = @()

		$Wait_Sync_Some_Select = @()
		$UI_Main_Select_Wim.Controls | ForEach-Object {
			if ($_.Enabled) {
				if ($_.Checked) {
					$Wait_Sync_Some_Select += $_.Tag
				}
			}
		}

		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				if ($Wait_Sync_Some_Select -contains $item.Main.uid) {
					$MainItem += $item.Main.uid
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Wait_Sync_Some_Select -contains $Expand.uid) {
							$MainItem += $item.Main.uid
							$MainItem += $Expand.uid

							if ($Wait_Sync_Some_Select -notcontains $item.Main.uid) {
								$disable += $item.Main.uid
							}
						}
					}
				}
			}
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Assign.9x99`n  Start"
			Write-Host "  $($lang.Event_Assign_Main)"
			Write-Host "  $($lang.Main_quests)" -ForegroundColor Yellow
			Write-Host "  $($MainItem)"

			Write-Host "`n  $($lang.Event_Assign_Expand)"
			Write-Host "  $($lang.Side_quests)" -ForegroundColor Yellow
			Write-Host "  $($disable)"
		}

		$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				if ($Wait_Sync_Some_Select -contains $_.Name) {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $($lang.Developers_Mode_Location): Assign.9x0000001`n  Start"
					}

					$_.Enabled = $True
					$_.Controls | ForEach-Object {
						if ($_.Name -eq "ImageSourcesConsole") {
							$_.Enabled = $true
						}
					}
				} else {
					<#
						.判断禁用主要项
					#>
					if ($MainItem -contains $_.Name) {
						if ($Global:Developers_Mode) {
							Write-Host "`n  $($lang.Developers_Mode_Location): Assign.9x1111111`n  Start"
						}

						<#
							.检查到有主要项时，开启主要，禁用扩展项
						#>
						$_.Enabled = $true
						$_.Controls | ForEach-Object {
							if ($_.Name -eq "ImageSourcesConsole") {
								$_.Enabled = $False
							}
						}
					} else {
						if ($disable -contains $_.Name) {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $($lang.Developers_Mode_Location): Assign.9x22222222`n  Start"
							}

							$_.Enabled = $True
							$_.Controls | ForEach-Object {
								if ($_.Name -eq "ImageSourcesConsole") {
									$_.Enabled = $true
								}
							}
						} else {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $($lang.Developers_Mode_Location): Assign.9x3333333333333`n  Start"
							}

							$_.Enabled = $False
							$_.Controls | ForEach-Object {
								if ($_.Name -eq "ImageSourcesConsole") {
									$_.Enabled = $False
								}
							}
						}
					}
				}
			}
		}
	}


	<#
		.自动驾驶编组
	#>
	Function Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Export_Add
	{
		param
		(
			$Master,
			$ImageName,
			$Group,
			$Uid,
			$MainUid,
			$ImageFilePath,
			$Tasks,
			$NewTasksFull,
			$SelectUid
		)

		<#
			.控件组，开始
		#>
		<#
			.控件组，结束
		#>
		$paneel            = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			AutoSize       = 1
			autoSizeMode   = 1
			Name           = $Uid
			Tag            = "IsMainGroup"
			autoScroll     = $True
		}

		$GUIImageSelectGroup = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsUseGroup"
			Tag            = $Uid
			Height         = 55
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = "$($lang.Event_Group): $($Group)`n$($lang.Unique_Name): $($Uid)"
			add_Click      = {
				if ($This.Checked) {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($this.Parent.Name -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
										if ($_.Name -eq "ImageSourcesConsole") {
											$_.Enabled = $true
										} else {
											$_.Enabled = $false
										}
									}
								}
							}
						}
					}
				} else {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($this.Parent.Name -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
										if ($_.Name -eq "ImageSourcesConsole") {
											$_.Enabled = $False
										} else {
											$_.Enabled = $True
										}
									}
								}
							}
						}
					}
				}
			}
		}

		$paneel.controls.AddRange($GUIImageSelectGroup)

		$Group_Image_Sources_Console = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			autosize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Padding        = "30,0,0,0"
			Name           = "ImageSourcesConsole"
		}
		$paneel.controls.AddRange($Group_Image_Sources_Console)

		if ($SelectUid -contains $Uid) {
			$GUIImageSelectGroup.Checked = $True
			$Group_Image_Sources_Console.Enabled = $True
		} else {
			$GUIImageSelectGroup.Checked = $False
			$Group_Image_Sources_Console.Enabled = $False
		}

		<#
			.组，有新的挂载映像时
		#>
		$GUIImageSelectFunctionNeedMount = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Text           = $lang.AssignNeedMount
		}

		<#
			.解决方案：创建
		#>
		$GUIImageSelectFunctionSolutions = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "16,0,0,0"
			Text           = "$($lang.Solution): $($lang.IsCreate)"
			Tag            = "Solutions_Create_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Solutions_Create_UI") {
			$GUIImageSelectFunctionSolutions.Checked = $True
		}
		$GUIImageSelectFunctionSolutions_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.组，语言
		#>
		$GUIImageSelectFunctionLang = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.Language
		}
		$GUIImageSelectFunctionLangAdd = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Language_Add_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Language_Add_UI") {
			$GUIImageSelectFunctionLangAdd.Checked = $True
		}

		$GUIImageSelectFunctionLangDel = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Language_Delete_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Language_Delete_UI") {
			$GUIImageSelectFunctionLangDel.Checked = $True
		}

		$GUIImageSelectFunctionLangChange = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.SwitchLanguage
			Tag            = "Language_Change_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Language_Change_UI") {
			$GUIImageSelectFunctionLangChange.Checked = $True
		}

		$GUIImageSelectLangComponents = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.OnlyLangCleanup
			Tag            = "Language_Cleanup_Components_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Language_Cleanup_Components_UI") {
			$GUIImageSelectLangComponents.Checked = $True
		}

		$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.组，InBox Apps
		#>
		$GUIImageSelectInBoxApps = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.InboxAppsManager
		}
		$GUIImageSelectInBoxAppsOne = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)"
			Tag            = "LXPs_Region_Add"
		}
		if ($NewTasksFull.IsAutoSelect -contains "LXPs_Region_Add") {
			$GUIImageSelectInBoxAppsOne.Checked = $True
		}

		$GUIImageSelectInBoxAppsTwo = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = "$($lang.InboxAppsManager): $($lang.AddTo)"
			Tag            = "InBox_Apps_Add_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "InBox_Apps_Add_UI") {
			$GUIImageSelectInBoxAppsTwo.Checked = $True
		}

		$GUIImageSelectInBoxApps_Update = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)"
			Tag            = "LXPs_Update_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "LXPs_Update_UI") {
			$GUIImageSelectInBoxApps_Update.Checked = $True
		}

		$GUIImageSelectInBoxApps_Remove = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)"
			Tag            = "LXPs_Remove_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "LXPs_Remove_UI") {
			$GUIImageSelectInBoxApps_Remove.Checked = $True
		}

		$GUIImageSelectInBoxApps_Match_Delete = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.InboxAppsMatchDel
			Tag            = "InBox_Apps_Match_Delete_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "InBox_Apps_Match_Delete_UI") {
			$GUIImageSelectInBoxApps_Match_Delete.Checked = $True
		}

		$GUIImageSelectInBoxApps_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.组，更新
		#>
		$GUIImageSelectFunctionUpdate = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.CUpdate
		}
		$GUIImageSelectFunctionUpdateAdd = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Cumulative_updates_Add_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Cumulative_updates_Add_UI") {
			$GUIImageSelectFunctionUpdateAdd.Checked = $True
		}

		$GUIImageSelectFunctionUpdateDel = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Cumulative_updates_Delete_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Cumulative_updates_Delete_UI") {
			$GUIImageSelectFunctionUpdateDel.Checked = $True
		}

		$GUIImageSelectFunctionUpdate_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.组，驱动
		#>
		$GUIImageSelectFunctionDrive = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.Drive
		}
		$GUIImageSelectFunctionDriveAdd = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.AddTo
			Tag            = "Drive_Add_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Drive_Add_UI") {
			$GUIImageSelectFunctionDriveAdd.Checked = $True
		}

		$GUIImageSelectFunctionDriveDel = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Del
			Tag            = "Drive_Delete_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Drive_Delete_UI") {
			$GUIImageSelectFunctionDriveDel.Checked = $True
		}

		$GUIImageSelectFunctionDrive_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.组，Windows 功能
		#>
		$GUIImageSelectFunctionWindowsFeature = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.WindowsFeature
		}
		<#
			.Windows 功能
		#>
			$UI_Main_Need_Mount_Feature_Enabled_Match = New-Object System.Windows.Forms.CheckBox -Property @{
				Name           = "IsAssign"
				Height         = 35
				Width          = 412
				Padding        = "31,0,0,0"
				Text           = "$($lang.Enable), $($lang.MatchMode)"
				Tag            = "Feature_Enabled_Match_UI"
			}
			if ($NewTasksFull.IsAutoSelect -contains "Feature_Enabled_Match_UI") {
				$UI_Main_Need_Mount_Feature_Enabled_Match.Checked = $True
			}

			$UI_Main_Need_Mount_Feature_Disable_Match = New-Object System.Windows.Forms.CheckBox -Property @{
				Name           = "IsAssign"
				Height         = 35
				Width          = 412
				Padding        = "31,0,0,0"
				Text           = "$($lang.Disable), $($lang.MatchMode)"
				Tag            = "Feature_Disable_Match_UI"
			}
			if ($NewTasksFull.IsAutoSelect -contains "Feature_Disable_Match_UI") {
				$UI_Main_Need_Mount_Feature_Disable_Match.Checked = $True
			}

			$GUIImageSelectFunctionWindowsFeature_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 20
				Width          = 412
			}

		<#
			.更多功能
		#>
		$GUIImageSelectFeature_More_UI = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "16,0,0,0"
			Text           = $lang.MoreFeature
			Tag            = "Feature_More_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Feature_More_UI") {
			$GUIImageSelectFeature_More_UI.Checked = $True
		}

		<#
			.运行 PowerShell 函数
		#>
		$GUIImage_Special_Function = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.SpecialFunction
		}
		$GUIImage_Functions_Before = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Before
			Tag            = "Functions_Before_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Functions_Before_UI") {
			$GUIImage_Functions_Before.Checked = $True
		}

		$GUIImage_Functions_Rear = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Rear
			Tag            = "Functions_Rear_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "Functions_Rear_UI") {
			$GUIImage_Functions_Rear.Checked = $True
		}

		$GUIImage_Special_Function_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.运行 API
		#>
		$GUIImage_API_Function = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 412
			Padding        = "15,0,0,0"
			Text           = $lang.API
		}
		$GUIImage_API_Before = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Before
			Tag            = "API_Before_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "API_Before_UI") {
			$GUIImage_API_Before.Checked = $True
		}

		$GUIImage_API_Rear = New-Object System.Windows.Forms.CheckBox -Property @{
			Name           = "IsAssign"
			Height         = 35
			Width          = 412
			Padding        = "31,0,0,0"
			Text           = $lang.Functions_Rear
			Tag            = "API_Rear_UI"
		}
		if ($NewTasksFull.IsAutoSelect -contains "API_Rear_UI") {
			$GUIImage_API_Rear.Checked = $True
		}

		$GUIImage_API_Function_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 412
		}

		<#
			.映像源
		#>
		if ($Tasks -contains "Image_source_selection") {
			<#
				.选择映像源控件
			#>
			$GUIImageSourceGroupMountFrom = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 412
				Text           = $lang.SelectSettingImage
			}
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSourceGroupMountFrom)

			if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)").Value) {
#				Write-Host "已挂载"
				<#
					.未发现文件
				#>
				$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height         = 40
					Width          = 412
					Padding        = "15,0,0,0"
					Text           = $lang.Mounted
				}

				$Group_Image_Sources_Console.controls.AddRange($UI_Main_Other_Rule_Not_Find)
			} else {
				$GUI_Image_source_selection = New-Object System.Windows.Forms.CheckBox -Property @{
					Height         = 30
					Width          = 412
					Padding        = "16,0,0,0"
					Text           = $lang.Prerequisite_Is_SeleceImage
					Tag            = "Image_source_selection"
				}

				if ($NewTasksFull.IsAutoSelect -contains "Image_source_selection") {
					$GUI_Image_source_selection.Checked = $True
				}

				$Group_Image_Sources_Console.controls.AddRange($GUI_Image_source_selection)

				if ($NewTasksFull.IsAutoSelectIndexAndEditionID -eq "Auto") {
					$GUI_Image_source_selection_Tips_Auto = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 412
						Padding        = "30,0,0,0"
						Text           = $lang.AllSel
					}
					$Group_Image_Sources_Console.controls.AddRange($GUI_Image_source_selection_Tips_Auto)
				} else {
					$GUI_Image_source_selection_Tips_NoAuto = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 412
						Padding        = "30,0,0,0"
						Text           = "$($lang.MountedIndexSelect): $($NewTasksFull.IsAutoSelectIndexAndEditionID)"
					}
					$Group_Image_Sources_Console.controls.AddRange($GUI_Image_source_selection_Tips_NoAuto)
				}

				$GUI_Image_source_selection_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 412
				}
				$Group_Image_Sources_Console.controls.AddRange($GUI_Image_source_selection_Wrap)
			}
		}

		<#
			.添加控件
		#>
		$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionNeedMount)

		if ($Tasks -contains "Solutions_Create_UI") {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionSolutions)
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionSolutions_Wrap)
		}

		<#
			.添加控件：语言
		#>
		$MarkLanguageGroup = $False
		if ($Tasks -contains "Language_Add_UI") { $MarkLanguageGroup = $True }
		if ($Tasks -contains "Language_Delete_UI") { $MarkLanguageGroup = $True }
		if ($Tasks -contains "Language_Change_UI") { $MarkLanguageGroup = $True }
		if ($Tasks -contains "Language_Cleanup_Components_UI") { $MarkLanguageGroup = $True }

		if ($MarkLanguageGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionLang)

			if ($Tasks -contains "Language_Add_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionLangAdd) }
			if ($Tasks -contains "Language_Delete_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionLangDel) }
			if ($Tasks -contains "Language_Change_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionLangChange) }
			if ($Tasks -contains "Language_Cleanup_Components_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectLangComponents) }
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
		}

		$MarkInBoxAppsGroup = $False
		if ($Tasks -contains "LXPs_Region_Add") { $MarkInBoxAppsGroup = $True }
		if ($Tasks -contains "InBox_Apps_Add_UI") { $MarkInBoxAppsGroup = $True }
		if ($Tasks -contains "LXPs_Update_UI") { $MarkInBoxAppsGroup = $True }
		if ($Tasks -contains "InBox_Apps_Match_Delete_UI") { $MarkInBoxAppsGroup = $True }

		if ($MarkInBoxAppsGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxApps)

			if ($Tasks -contains "LXPs_Region_Add") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxAppsOne) }
			if ($Tasks -contains "InBox_Apps_Add_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxAppsTwo) }
			if ($Tasks -contains "LXPs_Update_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxApps_Update) }
			if ($Tasks -contains "LXPs_Remove_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxApps_Remove) }
			if ($Tasks -contains "InBox_Apps_Match_Delete_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxApps_Match_Delete) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectInBoxApps_Wrap)
		}

		$MarkUpdateGroup = $False
		if ($Tasks -contains "Cumulative_updates_Add_UI") {  $MarkUpdateGroup = $True }
		if ($Tasks -contains "Cumulative_updates_Delete_UI") { $MarkUpdateGroup = $True }

		if ($MarkUpdateGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionUpdate)

			if ($Tasks -contains "Cumulative_updates_Add_UI") {  $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionUpdateAdd) }
			if ($Tasks -contains "Cumulative_updates_Delete_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionUpdateDel) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionUpdate_Wrap)
		}

		$MarkDriveGroup = $False
		if ($Tasks -contains "Drive_Add_UI") { $MarkDriveGroup = $True }
		if ($Tasks -contains "Drive_Delete_UI") { $MarkDriveGroup = $True }

		if ($MarkDriveGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionDrive)

			if ($Tasks -contains "Drive_Add_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionDriveAdd) }
			if ($Tasks -contains "Drive_Delete_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionDriveDel) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionDrive_Wrap)
		}

		$MarkWinFeatureGroup = $False
		if ($Tasks -contains "Feature_Enabled_Match_UI") { $MarkWinFeatureGroup = $True }
		if ($Tasks -contains "Feature_Disable_Match_UI") { $MarkWinFeatureGroup = $True }

		if ($MarkWinFeatureGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionWindowsFeature)

			if ($Tasks -contains "Feature_Enabled_Match_UI") { $Group_Image_Sources_Console.controls.AddRange($UI_Main_Need_Mount_Feature_Enabled_Match) }
			if ($Tasks -contains "Feature_Disable_Match_UI") { $Group_Image_Sources_Console.controls.AddRange($UI_Main_Need_Mount_Feature_Disable_Match) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFunctionWindowsFeature_Wrap)
		}

		$MarkFunctionsGroup = $False
		if ($Tasks -contains "Functions_Before_UI") { $MarkFunctionsGroup = $True }
		if ($Tasks -contains "Functions_Rear_UI") { $MarkFunctionsGroup = $True }

		if ($MarkFunctionsGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImage_Special_Function)

			if ($Tasks -contains "Functions_Before_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImage_Functions_Before) }
			if ($Tasks -contains "Functions_Rear_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImage_Functions_Rear) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImage_Special_Function_Wrap)
		}

		$MarkAPIGroup = $False
		if ($Tasks -contains "API_Before_UI") { $MarkAPIGroup = $True }
		if ($Tasks -contains "API_Rear_UI") { $MarkAPIGroup = $True }

		if ($MarkAPIGroup) {
			$Group_Image_Sources_Console.controls.AddRange($GUIImage_API_Function)

			if ($Tasks -contains "API_Before_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImage_API_Before) }
			if ($Tasks -contains "API_Rear_UI") { $Group_Image_Sources_Console.controls.AddRange($GUIImage_API_Rear) }

			$Group_Image_Sources_Console.controls.AddRange($GUIImage_API_Function_Wrap)
		}

		if ($Tasks -contains "Feature_More_UI") {
			$Group_Image_Sources_Console.controls.AddRange($GUIImageSelectFeature_More_UI)
		}

		<#
			.Add right-click menu: select all, clear button
			.添加右键菜单：全选、清除按钮
		#>
		$UI_Main_Select_Assign_MultitaskingSelectMenu = New-Object System.Windows.Forms.ContextMenuStrip

		<#
			.显示当前控制对象
		#>
		$UI_Main_Panel_Select_All = $UI_Main_Select_Assign_MultitaskingSelectMenu.Items.Add("$($lang.Event_Group): $($Group)")
		$UI_Main_Panel_Select_All = $UI_Main_Select_Assign_MultitaskingSelectMenu.Items.Add("$($lang.Unique_Name): $($Uid)")

		<#
			.界河
		#>
		$UI_Main_Panel_Clear_All = $UI_Main_Select_Assign_MultitaskingSelectMenu.Items.Add("-")

		<#
			.选择所有
		#>
		$UI_Main_Panel_Select_All = $UI_Main_Select_Assign_MultitaskingSelectMenu.Items.Add("   - $($lang.AllSel)")
		$UI_Main_Panel_Select_All.Tag = $Uid
		$UI_Main_Panel_Select_All.add_Click({
			$TempSelectItem = $This.Tag

			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($TempSelectItem -eq $_.Name) {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ($_.Name -eq "ImageSourcesConsole") {
									ForEach ($_ in $_.Controls) {
										if ($_ -is [System.Windows.Forms.CheckBox]) {
											$_.Checked = $true
										}
									}
								}
							}
						}
					}
				}
			}
		})

		<#
			.清除全部
		#>
		$UI_Main_Panel_Clear_All = $UI_Main_Select_Assign_MultitaskingSelectMenu.Items.Add("   - $($lang.AllClear)")
		$UI_Main_Panel_Clear_All.Tag = $Uid
		$UI_Main_Panel_Clear_All.add_Click({
			$TempSelectItem = $This.Tag

			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($TempSelectItem -eq $_.Name) {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ($_.Name -eq "ImageSourcesConsole") {
									ForEach ($_ in $_.Controls) {
										if ($_ -is [System.Windows.Forms.CheckBox]) {
											$_.Checked = $False
										}
									}
								}
							}
						}
					}
				}
			}
		})

		$Group_Image_Sources_Console.ContextMenuStrip = $UI_Main_Select_Assign_MultitaskingSelectMenu
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($paneel)

		$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 410
		}
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($UI_Add_End_Wrap)
	}

	<#
		.添加规则：自定义规则、预规则
	#>
	Function Refresh_Autopilot_Custom_Rule
	{
		$UI_Main_Select_Rule.controls.Clear()

		<#
			.选择全局唯一规则 GUID
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectGUID" -ErrorAction SilentlyContinue) {
			$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectGUID" -ErrorAction SilentlyContinue
		} else {
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue) {
				$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue
			} else {
				$GetDefaultSelectLabel = ""
			}
		}

		<#
			.添加规则：预置规则
		#>
		$UI_Main_Extract_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Text           = $lang.RulePre
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Pre_Rule)
		if ($Global:Pre_Config_Rules.count -gt 0) {
			ForEach ($itemPre in $Global:Pre_Config_Rules) {
				$UI_Main_Extract_Group = New-Object system.Windows.Forms.Label -Property @{
					Height    = 30
					Width     = 460
					Padding   = "18,0,0,0"
					Text      = $itemPre.Group
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group)

				ForEach ($item in $itemPre.Version) {
					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						Height    = 30
						Width     = 460
						Padding   = "36,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
						add_Click = {
							Refresh_Prerequisite_Verify -GUID $this.Tag
							Refresh_Prerequisite_Is_Satisfy
						}
					}

					$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 460
						Padding        = "54,0,0,0"
						Margin         = "0,0,0,5"
						Text           = $lang.Detailed_View
						Tag            = $item.GUID
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Autopilot_Rule_Details_View -GUID $this.Tag
						}
					}

					if ($GetDefaultSelectLabel -eq $item.GUID) {
						$CheckBox.Checked = $True
					}

					$UI_Main_Select_Rule.controls.AddRange((
						$CheckBox,
						$UI_Main_Rule_Details_View
					))
				}

				$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 460
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group_Wrap)
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 460
				margin    = "0,0,0,35"
				Text      = $lang.NoWork
			}
			$UI_Main_Select_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}

		<#
			.添加规则：其它规则
		#>
		$UI_Main_Extract_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Text           = $lang.RuleOther
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Other_Rule)
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 30
				Width     = 460
				Padding   = "18,0,0,0"
				Text      = $item.Name
				Tag       = $item.GUID
				add_Click = {
					Refresh_Prerequisite_Verify -GUID $this.Tag
					Refresh_Prerequisite_Is_Satisfy
				}
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 460
				Padding        = "36,0,0,0"
				Margin         = "0,0,0,5"
				Text           = $lang.Detailed_View
				Tag            = $item.GUID
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					Autopilot_Rule_Details_View -GUID $this.Tag
				}
			}

			if ($GetDefaultSelectLabel -eq $item.GUID) {
				$CheckBox.Checked = $True
			}

			$UI_Main_Select_Rule.controls.AddRange((
				$CheckBox,
				$UI_Main_Rule_Details_View
			))
		}

		<#
			.添加规则，自定义
		#>
		$UI_Main_Extract_Customize_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Margin         = "0,35,0,0"
			Text           = $lang.RuleCustomize
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule)
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						Height    = 30
						Width     = 435
						Padding   = "18,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
						add_Click = {
							Refresh_Prerequisite_Verify -GUID $this.Tag
							Refresh_Prerequisite_Is_Satisfy
						}
					}

					$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 435
						Padding        = "36,0,0,0"
						Margin         = "0,0,0,5"
						Text           = $lang.Detailed_View
						Tag            = $item.GUID
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Autopilot_Rule_Details_View -GUID $this.Tag
						}
					}

					if ($GetDefaultSelectLabel -eq $item.GUID) {
						$CheckBox.Checked = $True
					}

					$UI_Main_Select_Rule.controls.AddRange((
						$CheckBox,
						$UI_Main_Rule_Details_View
					))
				}
			} else {
				$UI_Main_Extract_Customize_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
					AutoSize       = 1
					Padding        = "18,0,0,0"
					Text           = $lang.RuleCustomizeTips
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips)
			}
		} else {
			$UI_Main_Extract_Customize_Rule_Tips_Not = New-Object system.Windows.Forms.Label -Property @{
				AutoSize       = 1
				Padding        = "18,0,0,0"
				Text           = $lang.RuleCustomizeNot
			}
			$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips_Not)
		}

		$GUIImageSelectInstall_Wrap = New-Object System.Windows.Forms.Label -Property @{
			Height             = 30
			Width              = 460
		}
		$UI_Main_Select_Rule.controls.AddRange($GUIImageSelectInstall_Wrap)

		Refresh_Prerequisite_Verify -GUID $GetDefaultSelectLabel
	}

	<#
		.事件：查看规则命名，详细内容
	#>
	Function Autopilot_Rule_Details_View
	{
		param
		(
			$GUID
		)

		$Script:InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$Script:InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$Script:InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$Script:InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		if ($Script:InBox_Apps_Rule_Select_Single.count -gt 0) {
			$UI_Main_Autopilot_View_Detailed.Visible = $True
			$UI_Main.Text = "$($lang.Autopilot): $($lang.Prerequisite)"
			$UI_Main_Autopilot_View_Detailed_Show.Text = ""

			$UI_Main_Autopilot_View_Detailed_Show.Text += "$($lang.RuleAuthon)`n"
			$UI_Main_Autopilot_View_Detailed_Show.Text += "   $($Script:InBox_Apps_Rule_Select_Single.Author)"

			$UI_Main_Autopilot_View_Detailed_Show.Text += "`n`n$($lang.RuleGUID)`n"
			$UI_Main_Autopilot_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.GUID)"

			$UI_Main_Autopilot_View_Detailed_Show.Text += "`n`n$($lang.RuleName)`n"
			$UI_Main_Autopilot_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.Name)"

			$UI_Main_Autopilot_View_Detailed_Show.Text += "`n`n$($lang.RuleDescription)`n"
			$UI_Main_Autopilot_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.Description)"

			$UI_Main_Autopilot_View_Detailed_Show.Text += "`n`n$($lang.Autopilot)`n"
			$UI_Main_Autopilot_View_Detailed_Show.Text += "     $($lang.Prerequisite)`n"
			if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.Count -gt 0) {
				$UI_Main_Autopilot_View_Detailed_Show.Text += "         arm64`n"
				if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.Count -gt 0) {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.Language.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.Language.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.Language) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
					}

					$UI_Main_Autopilot_View_Detailed_Show.Text += "`n             InBox Apps: $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.InBoxApps.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.InBoxApps.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.arm64.ISO.InBoxApps) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
					}
				} else {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
				}

				$UI_Main_Autopilot_View_Detailed_Show.Text += "`n         x64`n"
				if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.Count -gt 0) {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.Language.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.Language.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.Language) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($lang.NoWork)`n"
					}

					$UI_Main_Autopilot_View_Detailed_Show.Text += "`n             InBox Apps: $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.InBoxApps.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.InBoxApps.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x64.ISO.InBoxApps) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($lang.NoWork)`n"
					}
				} else {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
				}


				$UI_Main_Autopilot_View_Detailed_Show.Text += "`n         x86`n"
				if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.Count -gt 0) {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.Language.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.Language.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.Language) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($lang.NoWork)`n"
					}

					$UI_Main_Autopilot_View_Detailed_Show.Text += "`n             InBox Apps: $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.InBoxApps.Count) $($lang.EventManagerCount)`n"
					if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.InBoxApps.Count -gt 0) {
						ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.x86.ISO.InBoxApps) {
							$UI_Main_Autopilot_View_Detailed_Show.Text += "                 $($item)`n"
						}
					} else {
						$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
					}
				} else {
					$UI_Main_Autopilot_View_Detailed_Show.Text += "             $($lang.NoWork)`n"
				}
			} else {
				$UI_Main_Autopilot_View_Detailed_Show.Text += "     $($lang.NoWork)`n"
			}
		} else {
			$UI_Main_Prerequisite_Error.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
			$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Refresh_Prerequisite_Sources
	{
		$UI_Main_Select_Sources.controls.Clear()
		$UI_Main_Select_Sources_Config_Select.controls.Clear()
        $UI_Main_Export_Event_Custom_Menu.controls.Clear()

		$itemISO = "$($PSScriptRoot)\..\..\..\..\.."
		if (Test-Path -Path $itemISO -PathType Container) {
			$itemISO = Convert-Path -Path $itemISO -ErrorAction SilentlyContinue
			$itemISO = Join-Path -Path $itemISO -ChildPath "_Autopilot"
		}

		$TempSelectAraayPreRule = @()
		Get-ChildItem $itemISO -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			$MainFolder = $_.FullName
			$IsMulFolder = @()

			Get-ChildItem $_.FullName -Directory -ErrorAction SilentlyContinue | ForEach-Object {
				$IsMulFolder += $_.FullName
			}
 
			$TempSelectAraayPreRule += [pscustomobject]@{
				MainFolder   = $MainFolder
				ExpandFolder = $IsMulFolder
			}
		}

		$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize       = 1
			Text           = $itemISO
			Tag            = $itemISO
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Export_Error.Text = ""
				$UI_Main_Export_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
					$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Container) {
						Start-Process $This.Tag

						$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
						$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
						$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}
		$UI_Main_Pre_Rule_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 15
			Width          = 438
		}
		$UI_Main_Select_Sources.controls.AddRange((
			$UI_Main_Pre_Rule,
			$UI_Main_Pre_Rule_Wrap
		))

		if ($TempSelectAraayPreRule.ExpandFolder.count -gt 0) {
			<#
				.选择自定义目录
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectDriving" -ErrorAction SilentlyContinue) {
				$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectDriving" -ErrorAction SilentlyContinue
			} else {
				$GetDefaultSelectLabel = ""
			}

			ForEach ($item in $TempSelectAraayPreRule) {
				$UI_Main_New_Name = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize       = 1
						Padding        = "20,0,0,0"
						Text           = [IO.Path]::GetFileName($item.MainFolder)
						Tag            = $item.MainFolder
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							$UI_Main_Export_Error.Text = ""
							$UI_Main_Export_Error_Icon.Image = $null

							if ([string]::IsNullOrEmpty($This.Tag)) {
								$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Inoperable)"
								$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							} else {
								if (Test-Path -Path $This.Tag -PathType Container) {
									Start-Process $This.Tag

									$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Done)"
									$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								} else {
									$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Inoperable)"
									$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								}
							}
						}
					}
				$UI_Main_New_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 15
					Width          = 438
				}
				$UI_Main_Select_Sources.controls.AddRange((
					$UI_Main_New_Name,
					$UI_Main_New_Name_Wrap
				))

				ForEach ($itemExpand in $item.ExpandFolder) {
					$NewFileOnlyName = [IO.Path]::GetFileName($itemExpand)
					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						autosize  = 1
						Padding   = "36,0,0,0"
						Text      = $NewFileOnlyName
						Tag       = $itemExpand
						add_Click = {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectDriving" -value $this.Tag
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectConfig" -value ""
							Refresh_Prerequisite_Config
						}
					}

					$New_RadioButton_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 5
						Width          = 438
					}

					if ($GetDefaultSelectLabel -contains $itemExpand) {
						$CheckBox.Checked = $True
					} else {
						$CheckBox.Checked = $False
					}
 
					$UI_Main_Select_Sources.controls.AddRange((
						$CheckBox,
						$New_RadioButton_Wrap
					))
				}

				$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 25
					Width          = 438
				}
				$UI_Main_Select_Sources.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				autosize = 1
				Padding  = "20,0,0,0"
				margin   = "0,5,0,5"
				Text     = $lang.Autopilot_No_PreSource
			}
			$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	Function Refresh_Config_Rule_Sync_To_Show
	{
		<#
			.转换变量
		#>
		$NewArch  = $Global:Architecture
		$NewArchC = $Global:Architecture.Replace("AMD64", "x64")

		$UI_Main_Export_Error.Text = ""
		$UI_Main_Export_Error_Icon.Image = $null

		<#
			.获取选择的目录
		#>
		$MainSources = ""
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$MainSources = $_.Tag
					}
				}
			}
		}

		if ([string]::IsNullOrEmpty($MainSources)) {
			return
		}

		<#
			.获取选择的配置文件
		#>
		
		$ConfigFile = ""
		$Is_Eject_dependencies_ISO = $False
		$UI_Main_Select_Sources_Config_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$ConfigFile = $_.Tag
					}
				}
			}
		}

		if ([string]::IsNullOrEmpty($ConfigFile)) {
			return
		}

		<#
			蒙板：导入公共规则，动态显示已知方案，提供用户选择，清除全部
		#>
		$UI_Main_Export_Event_Custom_Menu.controls.clear()

		try {
			$Autopilot = Get-Content -Raw -Path $ConfigFile | ConvertFrom-Json
		} catch {
			$UI_Main_Export_Error.Text = "$($lang.Autopilot_Select_Config), $($lang.Failed)"
			$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.先决条件
		#>
		$Autopilot_Assign_Menu_Prerequisite = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Text           = $lang.Prerequisite
		}
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Prerequisite)

			<#
				.提取语言包
			#>
			$GUIImageSelectFunctionLang = New-Object system.Windows.Forms.Label -Property @{
				Height         = 35
				Width          = 450
				Padding        = "15,0,0,0"
				Text           = "$($lang.Language), $($lang.LanguageExtract): "
			}
			$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLang)

				#region 语言包添加
				$GUIImageSelectFunctionLangAdd = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 435
					Padding        = "31,0,0,0"
					Text           = $lang.AddTo
				}
				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd)

				if ([string]::IsNullOrEmpty($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region)) {
					$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
						Padding        = "50,0,0,0"
						Text           = $lang.NoWork
					}
					$UI_Main_Export_Event_Custom_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
				} else {
					if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Adv.IsEjectISO) {
						$Is_Eject_dependencies_ISO = $True
					}

					switch ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.SaveTo.Schome) {
						"Custom" {
							#region Custom
							$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.SaveTo.Custom.Path

							$Autopilot_Language_Is_Finish = @()
							$Autopilot_Language_Falied = @()

							if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region -eq "Auto") {
								$GUIImageSelectFunctionLangAdd_SelectAll = New-Object System.Windows.Forms.CheckBox -Property @{
									Height         = 30
									Width          = 425
									Padding        = "50,0,0,0"
									Text           = $lang.AllSel
									Tag            = "Prerequisite_Extract_Language_Add"
								}

								if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Add") {
									$GUIImageSelectFunctionLangAdd_SelectAll.Checked = $True
								}

								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_SelectAll)
							} else {
								ForEach ($item in $Global:Image_Rule) {
									if ($Global:SMExt -contains $item.Main.Suffix) {
										if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Scope -contains $item.main.Uid) {
											foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region) {
												$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($item.main.ImageFileName)\Language\Add\$($ConfigRegion)"

												if (Test-Path -Path $TempPathMain -PathType Container) {
													if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
														$Autopilot_Language_Is_Finish += [pscustomobject]@{
															Uid    = $item.main.Uid
															Failed = $TempPathMain
														}
													} else {
														$Autopilot_Language_Falied += [pscustomobject]@{
															Uid    = $item.main.Uid
															Failed = $TempPathMain
														}
													}
												} else {
													$Autopilot_Language_Falied += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												}
											}
										}

										if ($item.Expand.Count -gt 0) {
											ForEach ($itemExpandNew in $item.Expand) {
												if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Scope -contains $itemExpandNew.Uid) {
													foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region) {
														$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($itemExpandNew.ImageFileName)\Language\Add\$($ConfigRegion)"

														if (Test-Path -Path $TempPathMain -PathType Container) {
															if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
																$Autopilot_Language_Is_Finish += [pscustomobject]@{
																	Uid    = $itemExpandNew.Uid
																	Failed = $TempPathMain
																}
															} else {
																$Autopilot_Language_Falied += [pscustomobject]@{
																	Uid    = $itemExpandNew.Uid
																	Failed = $TempPathMain
																}
															}
														} else {
															$Autopilot_Language_Falied += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														}
													}
												}
											}
										}
									}
								}

								if ($Autopilot_Language_Falied.Count -gt 0) {
									$GUIImageSelectFunctionLangAdd_btn = New-Object System.Windows.Forms.CheckBox -Property @{
										Height         = 30
										Width          = 425
										Padding        = "50,0,0,0"
										Text           = $lang.Prerequisite_Extract_Auto
										Tag            = "Prerequisite_Extract_Language_Add"
									}

									if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Add") {
										$GUIImageSelectFunctionLangAdd_btn.Checked = $True
									}

									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_btn)

									$GUIImageSelectFunctionLangAdd_Status = New-Object system.Windows.Forms.Label -Property @{
										Height         = 30
										Width          = 435
										Padding        = "66,0,0,0"
										Text           = $lang.Prerequisite_Is_Extract -f $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region.Count, $Autopilot_Language_Is_Finish.Count, $Autopilot_Language_Falied.Count
									}
									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_Status)
								} else {
									$GUIImageSelectFunctionLangAdd_Status = New-Object system.Windows.Forms.Label -Property @{
										Height         = 30
										Width          = 435
										Padding        = "50,0,0,0"
										Text           = "$($lang.Prerequisite_satisfy): $($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region.Count) $($lang.EventManagerCount)"
									}
									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_Status)
								}
							}
							#endregion
						}
						"Multi" {
							#region Multi
							$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.SaveTo.Multi.Path
							$New_Custom_Name = $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.SaveTo.Multi.Name

							$Autopilot_Language_Is_Finish = @()
							$Autopilot_Language_Falied = @()

							ForEach ($item in $Global:Image_Rule) {
								if ($Global:SMExt -contains $item.Main.Suffix) {
									if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Scope -contains $item.main.Uid) {
										Image_Set_Global_Primary_Key -Silent -Uid $item.main.Uid -DevCode "9800"

										foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region) {
											$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($item.main.ImageFileName)\Language\$($New_Custom_Name)\$($NewArchC)\Add\$($ConfigRegion)"

											if (Test-Path -Path $TempPathMain -PathType Container) {
												if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
													$Autopilot_Language_Is_Finish += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												} else {
													$Autopilot_Language_Falied += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												}
											} else {
												$Autopilot_Language_Falied += [pscustomobject]@{
													Uid    = $item.main.Uid
													Failed = $TempPathMain
												}
											}
										}
									}

									if ($item.Expand.Count -gt 0) {
										ForEach ($itemExpandNew in $item.Expand) {
											if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Scope -contains $itemExpandNew.Uid) {
												Image_Set_Global_Primary_Key -Silent -Uid $itemExpandNew.Uid -DevCode "9990"

												foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region) {
													$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($itemExpandNew.ImageFileName)\Language\$($New_Custom_Name)\$($NewArchC)\Add\$($ConfigRegion)"

													if (Test-Path -Path $TempPathMain -PathType Container) {
														if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
															$Autopilot_Language_Is_Finish += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														} else {
															$Autopilot_Language_Falied += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														}
													} else {
														$Autopilot_Language_Falied += [pscustomobject]@{
															Uid    = $itemExpandNew.Uid
															Failed = $TempPathMain
														}
													}
												}
											}
										}
									}
								}
							}

							if ($Autopilot_Language_Falied.Count -gt 0) {
								$GUIImageSelectFunctionLangAdd_btn = New-Object System.Windows.Forms.CheckBox -Property @{
									Height         = 30
									Width          = 425
									Padding        = "50,0,0,0"
									Text           = $lang.Prerequisite_Extract_Auto
									Tag            = "Prerequisite_Extract_Language_Add"
								}

								if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Add") {
									$GUIImageSelectFunctionLangAdd_btn.Checked = $True
								}

								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_btn)
							
								$GUIImageSelectFunctionLangAdd_Status = New-Object system.Windows.Forms.Label -Property @{
									Height         = 30
									Width          = 435
									Padding        = "66,0,0,0"
									Text           = $lang.Prerequisite_Is_Extract -f $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region.Count, $Autopilot_Language_Is_Finish.Count, $Autopilot_Language_Falied.Count
								}
								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_Status)
							} else {
								$GUIImageSelectFunctionLangAdd_Status = New-Object system.Windows.Forms.Label -Property @{
									Height         = 30
									Width          = 435
									Padding        = "50,0,0,0"
									Text           = "$($lang.Prerequisite_satisfy): $($Autopilot.Deploy.Prerequisite.ExtractLanguage.Add.Region.Count) $($lang.EventManagerCount)"
								}
								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_Status)
							}
							#endregion
						}
					}
				}
				#endregion

				#region 语言包：删除
				$GUIImageSelectFunctionLangDel = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 435
					Padding        = "31,0,0,0"
					margin         = "0,20,0,0"
					Text           = $lang.Del
				}
				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel)

				if ([string]::IsNullOrEmpty($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region)) {
					$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
						Padding        = "50,0,0,0"
						Text           = $lang.NoWork
					}
					$UI_Main_Export_Event_Custom_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
				} else {
					if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Adv.IsEjectISO) {
						$Is_Eject_dependencies_ISO = $True
					}

					switch ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.SaveTo.Schome) {
						"Custom" {
							#region Custom
							$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.SaveTo.Custom.Path

							$Autopilot_Language_Is_Finish = @()
							$Autopilot_Language_Falied = @()

							if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region -eq "Auto") {
								$GUIImageSelectFunctionLangAdd_SelectAll = New-Object System.Windows.Forms.CheckBox -Property @{
									Height         = 30
									Width          = 425
									Padding        = "50,0,0,0"
									Text           = $lang.AllSel
									Tag            = "Prerequisite_Extract_Language_Del"
								}

								if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Del") {
									$GUIImageSelectFunctionLangAdd_SelectAll.Checked = $True
								}

								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangAdd_SelectAll)
							} else {
								ForEach ($item in $Global:Image_Rule) {
									if ($Global:SMExt -contains $item.Main.Suffix) {
										if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Scope -contains $item.main.Uid) {
											foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region) {
												$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($item.main.ImageFileName)\Language\Del\$($ConfigRegion)"

												if (Test-Path -Path $TempPathMain -PathType Container) {
													if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
														$Autopilot_Language_Is_Finish += [pscustomobject]@{
															Uid    = $item.main.Uid
															Failed = $TempPathMain
														}
													} else {
														$Autopilot_Language_Falied += [pscustomobject]@{
															Uid    = $item.main.Uid
															Failed = $TempPathMain
														}
													}
												} else {
													$Autopilot_Language_Falied += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												}
											}
										}

										if ($item.Expand.Count -gt 0) {
											ForEach ($itemExpandNew in $item.Expand) {
												if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Scope -contains $itemExpandNew.Uid) {
													foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region) {
														$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($itemExpandNew.ImageFileName)\Language\Del\$($ConfigRegion)"
													
														if (Test-Path -Path $TempPathMain -PathType Container) {
															if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
																$Autopilot_Language_Is_Finish += [pscustomobject]@{
																	Uid    = $itemExpandNew.Uid
																	Failed = $TempPathMain
																}
															} else {
																$Autopilot_Language_Falied += [pscustomobject]@{
																	Uid    = $itemExpandNew.Uid
																	Failed = $TempPathMain
																}
															}
														} else {
															$Autopilot_Language_Falied += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														}
													}
												}
											}
										}
									}
								}

								if ($Autopilot_Language_Falied.Count -gt 0) {
									$GUIImageSelectFunctionLangDel_btn = New-Object System.Windows.Forms.CheckBox -Property @{
										Height         = 30
										Width          = 425
										Padding        = "50,0,0,0"
										Text           = $lang.Prerequisite_Extract_Auto
										Tag            = "Prerequisite_Extract_Language_Del"
									}

									if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Del") {
										$GUIImageSelectFunctionLangDel_btn.Checked = $True
									}

									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_btn)

									$GUIImageSelectFunctionLangDel_Status = New-Object system.Windows.Forms.Label -Property @{
										Height         = 30
										Width          = 435
										Padding        = "66,0,0,0"
										Text           = $lang.Prerequisite_Is_Extract -f $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region.Count, $Autopilot_Language_Is_Finish.Count, $Autopilot_Language_Falied.Count
									}
									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_Status)
								} else {
									$GUIImageSelectFunctionLangDel_Status = New-Object system.Windows.Forms.Label -Property @{
										Height         = 30
										Width          = 435
										Padding        = "50,0,0,0"
										Text           = "$($lang.Prerequisite_satisfy): $($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region.Count) $($lang.EventManagerCount)"
									}
									$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_Status)
								}
							}
							#endregion
						}
						"Multi" {
							#region Multi
							$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.SaveTo.Multi.Path
							$New_Custom_Name = $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.SaveTo.Multi.Name

							$Autopilot_Language_Is_Finish = @()
							$Autopilot_Language_Falied = @()

							ForEach ($item in $Global:Image_Rule) {
								if ($Global:SMExt -contains $item.Main.Suffix) {
									if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Scope -contains $item.main.Uid) {
										Image_Set_Global_Primary_Key -Silent -Uid $item.main.Uid -DevCode "9800"

										foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region) {
											$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($item.main.ImageFileName)\Language\$($New_Custom_Name)\$($NewArchC)\Del\$($ConfigRegion)"

											if (Test-Path -Path $TempPathMain -PathType Container) {
												if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
													$Autopilot_Language_Is_Finish += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												} else {
													$Autopilot_Language_Falied += [pscustomobject]@{
														Uid    = $item.main.Uid
														Failed = $TempPathMain
													}
												}
											} else {
												$Autopilot_Language_Falied += [pscustomobject]@{
													Uid    = $item.main.Uid
													Failed = $TempPathMain
												}
											}
										}
									}

									if ($item.Expand.Count -gt 0) {
										ForEach ($itemExpandNew in $item.Expand) {
											if ($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Scope -contains $itemExpandNew.Uid) {
												Image_Set_Global_Primary_Key -Silent -Uid $itemExpandNew.Uid -DevCode "9990"

												foreach ($ConfigRegion in $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region) {
													$TempPathMain = "$($New_Custom_Path)\$($item.main.ImageFileName)\$($itemExpandNew.ImageFileName)\Language\$($New_Custom_Name)\$($NewArchC)\Del\$($ConfigRegion)"

													if (Test-Path -Path $TempPathMain -PathType Container) {
														if((Get-ChildItem $TempPathMain -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
															$Autopilot_Language_Is_Finish += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														} else {
															$Autopilot_Language_Falied += [pscustomobject]@{
																Uid    = $itemExpandNew.Uid
																Failed = $TempPathMain
															}
														}
													} else {
														$Autopilot_Language_Falied += [pscustomobject]@{
															Uid    = $itemExpandNew.Uid
															Failed = $TempPathMain
														}
													}
												}
											}
										}
									}
								}
							}

							if ($Autopilot_Language_Falied.Count -gt 0) {
								$GUIImageSelectFunctionLangDel_btn = New-Object System.Windows.Forms.CheckBox -Property @{
									Height         = 30
									Width          = 425
									Padding        = "50,0,0,0"
									Text           = $lang.Prerequisite_Extract_Auto
									Tag            = "Prerequisite_Extract_Language_Del"
								}

								if ($Autopilot.Deploy.Prerequisite.IsAutoSelect -contains "Prerequisite_Extract_Language_Del") {
									$GUIImageSelectFunctionLangDel_btn.Checked = $True
								}

								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_btn)

								$GUIImageSelectFunctionLangDel_Status = New-Object system.Windows.Forms.Label -Property @{
									Height         = 30
									Width          = 435
									Padding        = "66,0,0,0"
									Text           = $lang.Prerequisite_Is_Extract -f $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Region.Count, $Autopilot_Language_Is_Finish.Count, $Autopilot_Language_Falied.Count
								}
								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_Status)
							} else {
								$GUIImageSelectFunctionLangDel_Status = New-Object system.Windows.Forms.Label -Property @{
									Height         = 30
									Width          = 435
									Padding        = "50,0,0,0"
									Text           = "$($lang.Prerequisite_satisfy): $($Autopilot.Deploy.Prerequisite.ExtractLanguage.Del.Scope.Count) $($lang.EventManagerCount)"
								}
								$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectFunctionLangDel_Status)
							}
							#endregion
						}
					}
				}
				#endregion

			<#
					.提取语言结束后
			#>
			$Autopilot_Assign_Extract_Reaf = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 435
				Padding        = "31,0,0,0"
				margin         = "0,25,0,0"
				Text           = $lang.Functions_Rear
			}

			$Autopilot_Assign_Extract_Reaf_EJect = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = 30
				Width     = 435
				Padding   = "55,0,0,0"
				Text      = $lang.Export_Lang_Eject_ISO
				Tag       = "Popup_Dependencies_ISO"
			}
			$Autopilot_Assign_Extract_Reaf_EJect_Tips = New-Object system.Windows.Forms.Label -Property @{
				Height         = 35
				Width          = 435
				Padding        = "70,0,0,0"
				Text           = "ISO: $($lang.Unzip_Language), $($lang.Unzip_Fod)"
			}
			$UI_Main_Export_Event_Custom_Menu.controls.AddRange((
				$Autopilot_Assign_Extract_Reaf,
				$Autopilot_Assign_Extract_Reaf_EJect,
				$Autopilot_Assign_Extract_Reaf_EJect_Tips
			))

			if ($Is_Eject_dependencies_ISO) {
				$Autopilot_Assign_Extract_Reaf_EJect.Checked = $true
			} else {
				$Autopilot_Assign_Extract_Reaf_EJect.Checked = $False
			}

		<#
			.生成 ISO
		#>
		$Autopilot_Assign_Menu_ISO_Associated_Schemes = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 35
			Width          = 435
			margin         = "0,35,0,0"
			Text           = $lang.ISO_Associated_Schemes
			Checked        = $True
			add_Click      = {
				if ($This.Checked) {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("ISO" -eq $_.Name) {
								$_.Enabled = $True
							}
						}
					}
				} else {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("ISO" -eq $_.Name) {
								$_.Enabled = $False
							}
						}
					}
				}
			}
		}
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_ISO_Associated_Schemes)

		$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			Name           = "ISO"
			tag            = $MainSources
			BorderStyle    = 0
			autosize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Padding        = "15,0,0,0"
		}

		#region 右键映像源
		<#
			.Add right-click menu: select all, clear button
			.添加右键菜单：全选、清除按钮
		#>
		$UI_Main_Select_Assign_Group_Image_Sources = New-Object System.Windows.Forms.ContextMenuStrip

		<#
			.选择所有
		#>
		$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("   - $($lang.AllSel)")
		$UI_Group_Image_Sources_Select_All.Tag = $Uid
		$UI_Group_Image_Sources_Select_All.add_Click({
			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($_.Name -eq "ISO") {
						ForEach ($_ in $_.Controls) {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								$_.Checked = $true
							}
						}
					}
				}
			}
		})

		<#
			.清除全部
		#>
		$UI_Group_Image_Sources_Select_All = $UI_Main_Select_Assign_Group_Image_Sources.Items.Add("   - $($lang.AllClear)")
		$UI_Group_Image_Sources_Select_All.Tag = $Uid
		$UI_Group_Image_Sources_Select_All.add_Click({
			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($_.Name -eq "ISO") {
						ForEach ($_ in $_.Controls) {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								$_.Checked = $False
							}
						}
					}
				}
			}
		})
		#endregion

		$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.ContextMenuStrip = $UI_Main_Select_Assign_Group_Image_Sources

		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_ISO_Associated_Schemes_Show)

			if ([string]::IsNullOrEmpty($Autopilot.Deploy.ImageSource.Tasks.ISO.Association)) {
				$SelectAssociation = ""
			} else {
				$SelectAssociation = $Autopilot.Deploy.ImageSource.Tasks.ISO.Association
			}

			Get-ChildItem -Path "$($MainSources)\_ISO" -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
				$FileA = [IO.Path]::GetFileNameWithoutExtension($_.FullName)

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 30
					Width     = 435
					Text      = $FileA
					Tag       = $_.FullName
				}

				if ($SelectAssociation -contains $FileA) {
					$CheckBox.Checked = $True
				} else {
					$CheckBox.Checked = $False
				}

				$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($CheckBox)

				$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 435
				}
				$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
			}

			<#
				.关联 ISO 多级目录
			#>
			Get-ChildItem -Path "$($MainSources)\_ISO" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
				$NewEnglinePath = Convert-Path "$($PSScriptRoot)\..\..\..\..\.."
				$TempFilePath = Join-Path -Path $NewEnglinePath -ChildPath "\_Custom\Engine"

				$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 30
					Width          = 435
					Text           = [IO.Path]::GetFileName($_.FullName)
					Tag            = $_.FullName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$UI_Main_Export_Error.Text = ""
						$UI_Main_Export_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Inoperable)"
							$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Done)"
								$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							} else {
								$UI_Main_Export_Error.Text = "$($lang.OpenFolder): $($This.Text), $($lang.Inoperable)"
								$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							}
						}
					}
				}
				$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($UI_Main_Pre_Rule_Not_Find)

				Foreach ($item in $_.FullName) {
					Get-ChildItem -Path $item -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
						$FileA = [IO.Path]::GetFileNameWithoutExtension($_.FullName)
						$FileB = [IO.Path]::GetFileName($_.FullName)

						try {
							$Autopilot_Test_Config = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json

							if ([string]::IsNullOrEmpty($Autopilot_Test_Config.Deploy.ImageSource.Tasks.Solutions.Schome.Engine.Version)) {

							} else {
								if (Test-Path -Path "$($TempFilePath)\$($Autopilot_Test_Config.Deploy.ImageSource.Tasks.Solutions.Schome.Engine.Version)" -PathType Container) {
									$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
										Height    = 30
										Width     = 435
										Padding   = "16,0,0,0"
										Text      = $FileA
										Tag       = $_.FullName
									}
									$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($CheckBox)

									if ($SelectAssociation -contains $FileA) {
										$CheckBox.Checked = $True
									} else {
										$CheckBox.Checked = $False
									}

									$AutopilotTestOffice = Get-Content -Raw -Path $_.FullName | ConvertFrom-Json
									if ($AutopilotTestOffice.Deploy.ImageSource.Tasks.Solutions.Schome.Collection.Office.IsDeploy) {
										$MatchIs = $True
										$TestFullOffice = "$($PSScriptRoot)\..\..\..\..\..\_Custom\Office\$($AutopilotTestOffice.Deploy.ImageSource.Tasks.Solutions.Schome.Collection.Office.Version)\$($Global:Architecture)"

										if (Test-Path -Path $TestFullOffice -PathType Container) {
											Get-ChildItem -Path $TestFullOffice -directory -ErrorAction SilentlyContinue | ForEach-Object {
												if (Test-Path -Path "$($_.FullName)\Data\v64.cab" -PathType Leaf) {
													$MatchIs = $False
												}

												if (Test-Path -Path "$($_.FullName)\Data\v32.cab" -PathType Leaf) {
													$MatchIs = $False
												}
											}
										}

										if ($MatchIs) {
											$CheckBox.Checked = $False
											$CheckBox.ForeColor = "#FF0000"
										}
									}
								} else {
									$FileError    = New-Object system.Windows.Forms.Label -Property @{
										Height    = 35
										Width     = 435
										Text      = "$($lang.NoInstallImage): $($Autopilot_Test_Config.Deploy.ImageSource.Tasks.Solutions.Schome.Engine.Version)"
										Padding   = "14,0,0,0"
									}
									$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($FileError)
								}
							}
						} catch {
							$FileError = New-Object system.Windows.Forms.Label -Property @{
								Height        = 30
								Width         = 435
								margin        = "0,10,0,5"
								Text          = "$($FileB), $($lang.SelectFileFormatError)"
								Padding       = "16,0,0,0"
							}
							$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($FileError)
						}
					}

					$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
					}
					$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
				}
			}

		$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 435
		}
		$Autopilot_Assign_Menu_ISO_Associated_Schemes_Show.controls.AddRange($GUIImageSelectFunctionLang_Wrap)

		<#
			.没有挂载映像时
		#>
		$GUIImageSelectEventNeedMount = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
			Text           = $lang.AssignNoMount
		}
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectEventNeedMount)

			<#
				.附加版本
			#>
			if ($Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition.Count -gt 0) {
				$GetScpoeAE = @()
				<#
					.获取主菜单附加版本，主键范围
				#>
				$UI_Main_Select_AdditionalEdition_Select.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						$GetScpoeAE += $_.Tag
					}
				}

				$GUIImageSelect_Additional_Edition_Name = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 450
					Padding        = "16,0,0,0"
					Text           = $lang.AdditionalEdition
				}
				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelect_Additional_Edition_Name)

				foreach ($item in $Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition) {
					foreach ($itemUid in $item.Uid) {
						$Autopilot_Assign_Menu_Additional_Edition = New-Object System.Windows.Forms.CheckBox -Property @{
							Name           = "AdditionalEdition"
							Height         = 35
							Width          = 450
							Padding        = "32,0,0,0"
							Text           = $itemUid
							Tag            = $itemUid
						}
						$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Additional_Edition)

						if ($Autopilot.Deploy.ImageSource.Tasks.IsAutoSelect -contains "Additional_Edition_$($itemUid)") {
							$Autopilot_Assign_Menu_Additional_Edition.Checked = $True
						} else {
							$Autopilot_Assign_Menu_Additional_Edition.Checked = $False
						}

						if ($GetScpoeAE -contains $itemUid) {
							$Autopilot_Assign_Menu_Additional_Edition.Enabled = $True
						} else {
							$Autopilot_Assign_Menu_Additional_Edition.Enabled = $False
						}
					}
				}

				$GUIImageSelect_Additional_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 15
					Width          = 438
				}
				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelect_Additional_Edition_Wrap)
			}

			<#
				.转换
			#>
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.ImageSource.Tasks.Convert)) {
			} else {
				<#
					.互转, 合并, 拆分
				#>
				$Autopilot_Assign_Menu_Convert_Image = New-Object System.Windows.Forms.CheckBox -Property @{
					Height         = 30
					Width          = 450
					Padding        = "16,0,0,0"
					Text           = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"
					Tag            = "Image_Convert_UI"
				}

				if ($Autopilot.Deploy.ImageSource.Tasks.IsAutoSelect -contains "Image_Convert_UI") {
					$Autopilot_Assign_Menu_Convert_Image.Checked = $True
				} else {
					$Autopilot_Assign_Menu_Convert_Image.Checked = $False
				}

				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image)

				$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
				$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
				$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"

				switch ($Autopilot.Deploy.ImageSource.Tasks.Convert.Schome)
				{
					'ESDtoWIM'
					{
						if (Test-Path -Path $Install_ESD -PathType Leaf) {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $True
						} else {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $False

							$Autopilot_Assign_Menu_Convert_Image_isMount = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 450
								Padding        = "32,0,0,0"
								Text           = "$($lang.Converting -f "ESD", "WIM"), $($lang.Inoperable)"
							}
							$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image_isMount)
						}
					}
					'WIMtoESD'
					{
						if (Test-Path -Path $Install_wim -PathType Leaf) {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $True
						} else {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $False

							$Autopilot_Assign_Menu_Convert_Image_isMount = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 450
								Padding        = "32,0,0,0"
								Text           = "$($lang.Converting -f "Wim", "Swm"), $($lang.Inoperable)"
							}
							$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image_isMount)
						}
					}
					'SplitWim'
					{
						if (Test-Path -Path $Install_wim -PathType Leaf) {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $True
						} else {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $False

							$Autopilot_Assign_Menu_Convert_Image_isMount = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 450
								Padding        = "32,0,0,0"
								Text           = "$($lang.Converting -f "Wim", "Swm"), $($lang.Inoperable)"
							}
							$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image_isMount)
						}
					}
					'MergedSWM'
					{
						if (Test-Path -Path $Install_swm -PathType Leaf) {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $True
						} else {
							$Autopilot_Assign_Menu_Convert_Image.Enabled = $False

							$Autopilot_Assign_Menu_Convert_Image_isMount = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 450
								Padding        = "32,0,0,0"
								Text           = "$($lang.Converting -f "Swm", "wim"), $($lang.Inoperable)"
							}
							$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image_isMount)
						}
					}
				}

				if (Image_Is_Mount) {
#					$Autopilot_Assign_Menu_Convert_Image.Enabled = $False

					$Autopilot_Assign_Menu_Convert_Image_isMount = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 450
						Padding        = "34,0,0,0"
						margin         = "0,5,0,10"
						Text           = "$($lang.Mounted), $($lang.Image_Unmount_After): $($lang.DoNotSave)"
					}
					$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Convert_Image_isMount)
				} 
			}

			<#
				.生成解决方案
			#>
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.ImageSource.Tasks.Solutions)) {
			} else {
				<#
					.互转, 合并, 拆分
				#>
				$Autopilot_Assign_Menu_Solution_IsCreate = New-Object System.Windows.Forms.CheckBox -Property @{
					Height         = 30
					Width          = 450
					Padding        = "16,0,0,0"
					Text           = "$($lang.Solution): $($lang.IsCreate), ISO"
					Tag            = "Solutions_Create_UI"
				}

				if ($Autopilot.Deploy.ImageSource.Tasks.IsAutoSelect -contains "Solutions") {
					$Autopilot_Assign_Menu_Solution_IsCreate.Checked = $True
				} else {
					$Autopilot_Assign_Menu_Solution_IsCreate.Checked = $False
				}

				$UI_Main_Export_Event_Custom_Menu.controls.AddRange($Autopilot_Assign_Menu_Solution_IsCreate)
			}


		<#
			.需要挂载项
		#>
		$GUIImageSelectEventAssignNeedMount = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 35
			Width          = 450
			margin         = "0,35,0,0"
			Text           = $lang.AssignNeedMount
			Checked        = $True
			add_Click      = {
				if ($This.Checked) {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("IsMainGroup" -eq $_.Tag) {
								$_.Enabled = $True
							}
						}
					}
				} else {
					$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("IsMainGroup" -eq $_.Tag) {
								$_.Enabled = $False
							}
						}
					}
				}
			}
		}
		$UI_Main_Export_Event_Custom_Menu.controls.AddRange($GUIImageSelectEventAssignNeedMount)

		$Wait_Sync_Some_Select = @()
		$UI_Main_Select_Wim.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$Wait_Sync_Some_Select += $_.Tag
			}
		}

		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				if ($Wait_Sync_Some_Select -contains $item.Main.uid) {
					if (-not [string]::IsNullOrEmpty($Autopilot.Deploy.Mount.Tasks)) {
						foreach ($itemDeploy in $Autopilot.Deploy.Mount.Tasks) {
							if ($itemDeploy.Uid -eq $item.Main.uid) {
								Refresh_Config_Rule_Global -Master $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -Uid $item.Main.Uid -MainUid $item.Main.Uid -Group $item.main.Group -ImageFilePath $NewFileFullPathMain -NewTasks $itemDeploy -NewTasksFull $itemDeploy -SelectUid $Autopilot.Deploy.Mount.IsAutoSelect
							}
						}
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Wait_Sync_Some_Select -contains $Expand.uid) {
							if (-not [string]::IsNullOrEmpty($Autopilot.Deploy.Mount.Tasks)) {
								foreach ($itemDeploy in $Autopilot.Deploy.Mount.Tasks) {
									if ($itemDeploy.Uid -eq $Expand.uid) {
										Refresh_Config_Rule_Global -Master $item.Main.ImageFileName -ImageName $Expand.ImageFileName -Uid $Expand.Uid -MainUid $item.Main.Uid -Group $Expand.Group -ImageFilePath $test_mount_folder_Current -NewTasks $itemDeploy -NewTasksFull $itemDeploy -SelectUid $Autopilot.Deploy.Mount.IsAutoSelect
									}
								}
							}
						}
					}
				}
			}
		}

		<#
			.导入后，刷新所有事件
		#>
		Autopilot_Refresh_Event_All
	}


	<#
		.自动驾驶：从所有规则里批量读取
	#>
	Function Refresh_Config_Rule_Global
	{
		param
		(
			$Master,
			$ImageName,
			$Group,
			$Uid,
			$MainUid,
			$ImageFilePath,
			$NewTasks,
			$NewTasksFull,
			$SelectUid
		)

		$Wait_Assign_To_New_Button = @()

		<#
			.映像源选择
		#>
		if (-not [string]::IsNullOrEmpty($NewTasks.IsAutoSelectIndexAndEditionID)) {
			$Wait_Assign_To_New_Button += "Image_source_selection"
		}

		<#
			.解决方案：创建
		#>
		if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Solutions)) {
			$Wait_Assign_To_New_Button += "Solutions_Create_UI"
		}

		<#
			.语言
		#>
			<#
				.添加
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Language.Add)) {
				$Wait_Assign_To_New_Button += "Language_Add_UI"
			}

			<#
				.删除
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Language.Del)) {
				$Wait_Assign_To_New_Button += "Language_Delete_UI"
			}

			<#
				.更改
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Language.Change)) {
				$Wait_Assign_To_New_Button += "Language_Change_UI"
			}

			<#
				.清理组件
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Language.Cleanup)) {
				$Wait_Assign_To_New_Button += "Language_Cleanup_Components_UI"
			}

		<#
			.InBox Apps
		#>
			<#
				.本地语言体验包：添加
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.InBoxApps.Mark)) {
				$Wait_Assign_To_New_Button += "LXPs_Region_Add"
			}

			<#
				.InBox Apps：添加
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.InBoxApps.Add)) {
				$Wait_Assign_To_New_Button += "InBox_Apps_Add_UI"
			}

			<#
				.本地语言体验包：更新
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.InBoxApps.Update)) {
				$Wait_Assign_To_New_Button += "LXPs_Update_UI"
			}

			<#
				.本地语言体验包：删除
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.InBoxApps.Remove)) {
				$Wait_Assign_To_New_Button += "LXPs_Remove_UI"
			}

			<#
				.匹配删除
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.InBoxApps.MatchRemove)) {
				$Wait_Assign_To_New_Button += "InBox_Apps_Match_Delete_UI"
			}

		<#
			.累积更新
		#>
			<#
				.添加
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.CumulativeUpdate.Add)) {
				$Wait_Assign_To_New_Button += "Cumulative_updates_Add_UI"
			}

			<#
				.删除
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.CumulativeUpdate.Del)) {
				$Wait_Assign_To_New_Button += "Cumulative_updates_Delete_UI"
			}

		<#
			.驱动
		#>
			<#
				.添加
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Drive.Add)) {
				$Wait_Assign_To_New_Button += "Drive_Add_UI"
			}

			<#
				.删除
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.Drive.Del)) {
				$Wait_Assign_To_New_Button += "Drive_Delete_UI"
			}

		<#
			.Windows 功能
		#>

			<#
				.更改
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.WindowsFeatures.Enable)) {
				$Wait_Assign_To_New_Button += "Feature_Enabled_Match_UI"
			}

			<#
				.更改
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.WindowsFeatures.Disable)) {
				$Wait_Assign_To_New_Button += "Feature_Disable_Match_UI"
			}

		<#
			.导入：PowerShell 函数
		#>

			<#
				.运行前
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.PSFunctions.Before)) {
				$Wait_Assign_To_New_Button += "Functions_Before_UI"
			}

			<#
				.运行后
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.PSFunctions.After)) {
				$Wait_Assign_To_New_Button += "Functions_Rear_UI"
			}

		<#
			.导入：API
		#>

			<#
				.运行前
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.API.Before)) {
				$Wait_Assign_To_New_Button += "API_Before_UI"
			}

			<#
				.运行后
			#>
			if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.API.After)) {
				$Wait_Assign_To_New_Button += "API_Rear_UI"
			}

		<#
			.导入：更多
		#>
		if (-not [string]::IsNullOrEmpty($NewTasks.Tasks.More)) {
			$Wait_Assign_To_New_Button += "Feature_More_UI"
		}

		if ($Wait_Assign_To_New_Button.Count -gt 0) {
			Image_Select_Refresh_Install_Boot_WinRE_Autopilot_Export_Add -Master $Master -ImageName $ImageName -Uid $Uid -MainUid $MainUid -Group $Group -ImageFilePath $ImageFilePath -Tasks $Wait_Assign_To_New_Button -NewTasksFull $NewTasksFull -SelectUid $SelectUid
		}
	}

	<#
		.自动驾驶：导入
	#>
	Function Refresh_Config_Rule_Import_To_Event
	{
		<#
			.导入前，重置所有变量
		#>
		Additional_Edition_Reset
		Event_Reset_Variable -Silent

		$Temp_Save_Sources = ""
		$UI_Main_Select_Sources_Config_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Save_Sources = $_.Tag
					}
				}
			}
		}

		if ([string]::IsNullOrEmpty($Temp_Save_Sources)) {
			$UI_Main_Export_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.Autopilot_Select_Config) )"
			$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		} else {
			try {
				$Autopilot = Get-Content -Raw -Path $Temp_Save_Sources | ConvertFrom-Json
			} catch {
				$UI_Main_Export_Error.Text = "$($lang.Autopilot_Select_Config), $($lang.Failed)"
				$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				return
			}

			$Select = @()
			$GroupSelectAE = @()
			$ISO_path = ""
			$ISO = @()
			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Select += $_.Tag
						}
					}
				}

				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ("AdditionalEdition" -eq $_.Name) {
						if ($_.Enabled) {
							if ($_.Checked) {
								$GroupSelectAE += $_.Tag
							}
						}
					}
				}

				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ("ISO" -eq $_.Name) {
						$ISO_path = $_.Tag

						ForEach ($ItemNew in $_.Controls) {
							if ($ItemNew -is [System.Windows.Forms.CheckBox]) {
								if ($ItemNew.Enabled) {
									if ($ItemNew.Checked) {
										$ISO += $ItemNew.Tag
									}
								}
							}
						}
					}
				}
			}

			<#
				.无需挂载项，公共事件：导入
			#>
				<#
					.先决条件
				#>
					<#
						.语言：提取
					#>
						<#
							.导入：语言：添加
						#>
						if ($Select -contains "Prerequisite_Extract_Language_Add") {
							Language_Extract_UI -Add -Autopilot $Autopilot.Deploy.Prerequisite.ExtractLanguage.Add
						}

						<#
							.导入：语言：删除
						#>
						if ($Select -contains "Prerequisite_Extract_Language_Del") {
							Language_Extract_UI -Del -Autopilot $Autopilot.Deploy.Prerequisite.ExtractLanguage.Del
						}

						<#
							.选择全局唯一规则 GUID
						#>
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectGUID" -ErrorAction SilentlyContinue) {
							$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectGUID" -ErrorAction SilentlyContinue
						} else {
							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue) {
								$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue
							} else {
								$GetDefaultSelectLabel = ""
							}
						}

						<#
							.导入：语言，添加、删除后，判断是否：
							 提取完成后弹出已挂载的 ISO，规则
						#>
						Write-Host "`n  $($lang.Export_Lang_Eject_ISO)" -ForegroundColor Yellow
						Write-host "  ISO: $($lang.Unzip_Language), $($lang.Unzip_Fod)" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
						if ($Select -contains "Popup_Dependencies_ISO") {
							write-host "  $($lang.Prerequisite_satisfy)" -ForegroundColor Green
							Autopilot_Import_Eject_ISO -GUID $GetDefaultSelectLabel
						} else {
							write-host "  $($lang.Prerequisite_Not_satisfied)" -ForegroundColor Red
						}

						<#
							.刷新先决条件 ISO
						#>
						Refresh_Prerequisite_Verify -GUID $GetDefaultSelectLabel
						Refresh_Prerequisite_Is_Satisfy

				<#
					.关联 ISO 方案
				#>
				if ($ISO.count -gt 0) {
					$Global:Queue_ISO_Associated = $true                      # 关联 ISO 方案
					$Global:Queue_ISO_Associated_Tasks = @{
						Sources = $ISO_path
						Rule = $ISO
					}
				} else {
					$Global:Queue_ISO_Associated = $false                      # 关联 ISO 方案
					$Global:Queue_ISO_Associated_Tasks = @{
						Sources = $ISO_path
						Rule = ""
					}
				}


				<#
					.附加版本
				#>
				if ($GroupSelectAE.count -gt 0) {
					Write-Host "`n  $($lang.AdditionalEdition): $($lang.Import)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					<#
						.选择主界面附加版本菜单
					#>
					$UI_Main_Select_AdditionalEdition_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($GroupSelectAE -contains $_.Name) {
								$_.Checked = $True
							} else {
								$_.Checked = $False
							}
						}
					}

					<#
						.批量导入到附加版本
					#>
					if ($Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition.Count -gt 0) {
						foreach ($item in $Autopilot.Deploy.ImageSource.Tasks.AdditionalEdition) {
							foreach ($itemUid in $item.Uid) {
								if ($GroupSelectAE -contains $itemUid) {
									Image_Set_Global_Primary_Key -Uid $itemUid -Silent -DevCode "Autopilot - 6700"
									Additional_Edition_UI -Autopilot $item
								}
							}
						}
					}
				} else {
					$UI_Main_Select_AdditionalEdition_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							$_.Checked = $False
						}
					}
				}

				<#
					.导入：转换
				#>
				if ($Select -contains "Image_Convert_UI") {
					Write-Host "`n  $($lang.Import): $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm), $($lang.Done)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Image_Convert_UI -Autopilot $Autopilot.Deploy.ImageSource.Tasks.Convert
				}

				<#
					.导入：解决方案：生成
				#>
				if ($Select -contains "Solutions_Create_UI") {
					Write-Host "`n  $($lang.Import): $($lang.Solution): $($lang.IsCreate)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Autopilot_Solutions_Create_Import -Tasks $Autopilot.Deploy.ImageSource.Tasks.Solutions -ISO
				}

			<#
				.循环所有任务
			#>
			#region All tasks
			$Wait_Sync_Some_Select_Group = @()
			$UI_Main_Export_Event_Custom_Menu.Controls | ForEach-Object {
				$Temp_Save_Select_Name = ""
				$Temp_Save_Select_Tasks = @()

				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ("IsMainGroup" -eq $_.Tag) {
						ForEach ($NewGroup in $_.Controls) {
							if ($NewGroup -is [System.Windows.Forms.CheckBox]) {
								if ("IsUseGroup" -eq $NewGroup.Name) {
									if ($NewGroup.Enabled) {
										if ($NewGroup.Checked) {
											$Temp_Save_Select_Name = $NewGroup.Tag
										}
									}
								}
							}
						}

						If (-not [String]::IsNullOrEmpty($Temp_Save_Select_Name)) {
							ForEach ($NewGroup in $_.Controls) {
								if ($NewGroup -is [System.Windows.Forms.FlowLayoutPanel]) {
									if ($NewGroup.Name -eq "ImageSourcesConsole") {
										ForEach ($NewChecke in $NewGroup.Controls) {
											if ($NewChecke -is [System.Windows.Forms.CheckBox]) {
												if ($NewChecke.Enabled) {
													if ($NewChecke.Checked) {
														$Temp_Save_Select_Tasks += $NewChecke.Tag
													}
												}
											}
										}
									}
								}
							}

							If ($Temp_Save_Select_Tasks.count -gt 0) {
								$Wait_Sync_Some_Select_Group += [pscustomobject]@{
									Uid         = $Temp_Save_Select_Name
									SelectTasks = $Temp_Save_Select_Tasks
								}
							}
						}
					}
				}
			}

			$UI_Main_Select_Wim.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Wait_Sync_Some_Select_Group.Uid -contains $_.Tag) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}

					Check_Select_New_Autopilot
					Image_Select_Disable_Expand_Main_Item_Autopilot -Group $_.Tag -MainUid $_.Tag
				}
			}

			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					foreach ($itemVerify in $Wait_Sync_Some_Select_Group) {
						if ($itemVerify.Uid -eq $item.Main.uid) {
							foreach ($itemDeploy in $Autopilot.Deploy.Mount.Tasks) {
								if ($itemDeploy.Uid -eq $item.Main.uid) {
									Image_Set_Global_Primary_Key -Uid $item.Main.uid -Silent -DevCode "Autopilot - 5000"
									Autopilot_Refresh_Export_Event_To_WIM -Master $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -ImageUid $item.Main.Uid -Suffix $item.Main.Suffix -SelectEvent $itemVerify.SelectTasks -NewTasks $itemDeploy
								}
							}
						}
					}

					if ($item.Expand.Count -gt 0) {
						ForEach ($Expand in $item.Expand) {
							foreach ($itemVerify in $Wait_Sync_Some_Select_Group) {
								if ($itemVerify.Uid -eq $Expand.uid) {
									foreach ($itemDeploy in $Autopilot.Deploy.Mount.Tasks) {
										if ($itemDeploy.Uid -eq $Expand.uid) {
											$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

											Image_Set_Global_Primary_Key -Uid $Expand.uid -Silent -DevCode "Autopilot - 5200"
											Autopilot_Refresh_Export_Event_To_WIM -Master $item.Main.ImageFileName -ImageName $Expand.ImageFileName -ImageFile $test_mount_folder_Current -ImageUid $Expand.Uid -Expand -Suffix $Expand.Suffix -SelectEvent $itemVerify.SelectTasks -NewTasks $itemDeploy
										}
									}
								}
							}
						}
					}
				}
			}
			#endregion

			#region 导入完成事件后
			<#
				.什么时候开始
			#>
			Write-Host "`n  $($lang.Import): $($lang.WaitTimeTitle)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.IsEvent.Scheduled)) {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			} else {
				Event_Completion_Start_Setting_UI -Autopilot $Autopilot.Deploy.IsEvent.Scheduled
			}

			<#
				.队列中有任务
			#>
			Write-Host "`n  $($lang.Import): $($lang.AfterFinishingNotExecuted)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.IsEvent.AfterCompletion)) {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			} else {
				Event_Completion_Setting_UI -Autopilot $Autopilot.Deploy.IsEvent.AfterCompletion
			}
			#endregion

			Autopilot_Refresh_Event_All

#			Refresh_Config_Rule_Sync_To_Show
			
			$UI_Main_Export_Error.Text = "$($lang.Import), $($lang.Done)"
			$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.导入后或即时更新事件
	#>
	Function Autopilot_Refresh_Event_All
	{
		<#
			转换
		#>
		if ($Global:QueueConvert) {
			$GUIImageSelectFunctionConvertImage_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$GUIImageSelectFunctionConvertImage_Clear.Text = $lang.EventManagerNo
		}

		if ($Global:Queue_Convert_Tasks) {
			$GUIImageSelectFunctionConvertImage.Text = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm): $($lang.Enable)"
		} else {
			$GUIImageSelectFunctionConvertImage.Text = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm): $($lang.Disable)"
		}

		<#
			.关联 ISO 方案
		#>
		if ($Global:Queue_ISO_Associated) {
			$GUIImageSelectFunctionISO_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"

			if ($Global:Queue_ISO_Associated_Tasks.count -gt 0) {
				$GUIImageSelectFunctionISO.Text = "$($lang.ISO_Associated_Schemes): $($lang.Enable)"
			} else {
				$GUIImageSelectFunctionISO.Text = "$($lang.ISO_Associated_Schemes): $($lang.Disable)"
			}
		} else {
			$GUIImageSelectFunctionISO_Clear.Text = $lang.EventManagerNo
			$GUIImageSelectFunctionISO.Text = "$($lang.ISO_Associated_Schemes): $($lang.Disable)"
		}
	
		<#
			.生成解决方案到 ISO
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_ISO" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Autopilot_Create_Solutions_To_ISO.Text = "$($lang.Solution): $($lang.IsCreate), ISO: $($lang.Enable)"
			$UI_Main_Autopilot_Create_Solutions_To_ISO_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Autopilot_Create_Solutions_To_ISO.Text = "$($lang.Solution): $($lang.IsCreate), ISO: $($lang.Disable)"
			$UI_Main_Autopilot_Create_Solutions_To_ISO_Clear.Text = $lang.EventManagerNo
		}

		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				$Tasks = Autopilot_Event_Assign_Task_Verify -Uid $item.Main.Uid

				$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
						if ($item.Main.Uid -eq $_.Name) {
							$_.Controls | ForEach-Object {
								if ($_.Name -eq "ImageSourcesConsole") {
									ForEach ($_ in $_.Controls) {
										if ($_ -is [System.Windows.Forms.LinkLabel]) {
											if ($Tasks -contains $_.Tag) {
												$_.LinkColor = "#008000"
											} else {
												$_.LinkColor = "#FF0000"
											}
										}
									}
								}
							}
						}
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						$Tasks = Autopilot_Event_Assign_Task_Verify -Uid $Expand.Uid

						$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ($Expand.Uid -eq $_.Name) {
									$_.Controls | ForEach-Object {
										if ($_.Name -eq "ImageSourcesConsole") {
											ForEach ($_ in $_.Controls) {
												if ($_ -is [System.Windows.Forms.LinkLabel]) {
													if ($Tasks -contains $_.Tag) {
														$_.LinkColor = "#008000"
													} else {
														$_.LinkColor = "#FF0000"
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
			}
		}
	}

	Function Autopilot_Event_Assign_Task_Verify
	{
		param
		(
			$Uid
		)

		$FlagIsWait = @()
	
		<#
			.生成解决方案
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Solutions_Create_UI"
		}

		<#
			.语言添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Language_Add_UI"
		}

		<#
			.语言删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Del_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Language_Delete_UI"
		}

		<#
			.更改映像语言
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Change_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Language_Change_UI"
		}

		<#
			.清理组件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Language_Cleanup_Components_UI"
		}

		<#
			.本地语言体验包：标记
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "LXPs_Region_Add"
		}

		<#
			InBox Apps，添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "InBox_Apps_Add_UI"
		}

		<#
			.本地语言体验（LXPs），更新
		#>
		$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
			$FlagIsWait += "LXPs_Update_UI"
		}

		<#
			.本地语言体验（LXPs），删除
		#>
		$Temp_LXPs_Delete = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Delete_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_LXPs_Delete.Count -gt 0) {
			$FlagIsWait += "LXPs_Remove_UI"
		}

		<#
			.按匹配规则删除 InBox Apps 预安装软件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Match_Rule_Delete_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "InBox_Apps_Match_Delete_UI"
		}

		<#
			.更新添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Add_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Cumulative_updates_Add_UI"
		}

		<#
			.更新删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Del_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Cumulative_updates_Delete_UI"
		}

		<#
			.驱动添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Drive_Add_UI"
		}

		<#
			.驱动删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Delete_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Drive_Delete_UI"
		}

		<#
			.Windows 功能：启用，匹配
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Enable_Match_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Feature_Enabled_Match_UI"
		}

		<#
			.Windows 功能：禁用，匹配
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Disable_Match_$($Uid)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait += "Feature_Disable_Match_UI"
		}

		<#
			.运行 PowerShell 函数：有任务前
		#>
		$Temp_Functions_Before_Task = (Get-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Functions_Before_Task.Count -gt 0) {
			$FlagIsWait += "Functions_Before_UI"
		}

		<#
			.运行 PowerShell 函数：完成任务后
		#>
		$Temp_Functions_Rear_Task = (Get-Variable -Scope global -Name "Queue_Functions_Rear_Select_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Functions_Rear_Task.Count -gt 0) {
			$FlagIsWait += "Functions_Rear_UI"
		}

		<#
			.运行 API：有任务前
		#>
		$Temp_API_Before_Task = (Get-Variable -Scope global -Name "Queue_API_Before_Select_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_API_Before_Task.Count -gt 0) {
			$FlagIsWait += "API_Before_UI"
		}

		<#
			.运行 API：完成任务后
		#>
		$Temp_API_Rear_Task = (Get-Variable -Scope global -Name "Queue_API_Rear_Select_$($Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_API_Rear_Task.Count -gt 0) {
			$FlagIsWait += "API_Rear_UI"
		}

		return $FlagIsWait
	}

	Function Refresh_Prerequisite_Config
	{
		$UI_Main_Export_Error.Text = ""
		$UI_Main_Export_Error_Icon.Image = $null

		$UI_Main_Select_Sources_Config_Select.controls.Clear()
		$UI_Main_Export_Event_Custom_Menu.controls.Clear()

		$Temp_Save_Sources = @()
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Save_Sources = $_.Tag
					}
				}
			}
		}

		if ($Temp_Save_Sources.Count -gt 0) {
			$TempSelectAraayPreRule = @()
			Get-ChildItem -Path $Temp_Save_Sources -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
				$TempSelectAraayPreRule += [pscustomobject]@{
					Sources = $Temp_Save_Sources
					FileName = $_.FullName
				}
			}

			if ($TempSelectAraayPreRule.Count -gt 0) {
				<#
					.选择配置文件
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectConfig" -ErrorAction SilentlyContinue) {
					$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "SelectConfig" -ErrorAction SilentlyContinue
				} else {
					$GetDefaultSelectLabel = ""
				}

				ForEach ($item in $TempSelectAraayPreRule) {
					$NewFileOnlyName = [IO.Path]::GetFileName($item.FileName)
					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						Name      = $item.Sources
						Height    = 30
						Width     = 435
						Padding   = "20,0,0,0"
						Text      = $NewFileOnlyName
						Tag       = $item.FileName
						add_Click = {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectConfig" -value $this.Tag
							Refresh_Config_Rule_Sync_To_Show
						}
					}

					try {
						$Autopilot = Get-Content -Raw -Path $item.FileName | ConvertFrom-Json
						$UI_Main_Select_Sources_Config_Select.controls.AddRange($CheckBox)

						if ($Autopilot.Config.Version.Replace('.', '') -ge $Script:Autopilot_Scheme_Config_Low.Replace('.', '')) {
						} else {
							$CheckBox.Enabled = $False

							$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
								Height    = 30
								Width     = 435
								Padding   = "40,0,0,0"
								margin    = "0,0,0,10"
								Text      = $lang.Autopilot_Config_File_Low
							}
							$UI_Main_Select_Sources_Config_Select.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
						}
					} catch {
						$CheckBox.Text = "$([IO.Path]::GetFileName($item.FileName)), $($lang.SelectFileFormatError)"
						$CheckBox.Enabled = $False
					}

					if ($GetDefaultSelectLabel -contains $item.FileName) {
						$CheckBox.Checked = $True
					} else {
						$CheckBox.Checked = $False
					}
				}
			} else {
				$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height    = 30
					Width     = 435
					Padding   = "20,0,0,0"
					Text      = $lang.NoWork
				}
				$UI_Main_Select_Sources_Config_Select.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 435
				Padding   = "20,0,0,0"
				Text      = $lang.Autopilot_No_PreSource
			}

			$UI_Main_Select_Sources_Config_Select.controls.AddRange($UI_Main_Pre_Rule_Not_Find)

			$UI_Main_Export_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.Autopilot_Select_Scheme) )"
			$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Refresh_Prerequisite_Verify
	{
		param
		(
			$GUID
		)

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectGUID" -value $GUID

		$UI_Main_Prerequisite_Error.Text = ""
		$UI_Main_Prerequisite_Error_Icon.Image = $null

		$Script:InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$Script:InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$Script:InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$Script:InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		Refresh_All_Rule_Guid
	}

	Function Refresh_All_Rule_Guid
	{
		<#
			.初始化先决条件
		#>
		$Script:Prerequisite_Is_Satisfy = @()

		$UI_Main_Prerequisite_Verify_Select.controls.Clear()

		switch ($Global:Architecture) {
			"arm64" { $NewInBoxAppsFolder += "arm64" }
			"AMD64" { $NewInBoxAppsFolder += "x64" }
			"x86"   { $NewInBoxAppsFolder += "x86"   }
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
			$itemISO = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue
			$NewSources_ISO = Join-Path -Path $itemISO -ChildPath $Global:Init_Search_ISO_Folder_Name
		}

		$Init_Folder_All_File = @()
		Get-ChildItem -Path $NewSources_ISO -Recurse -Include ($Global:SearchISOType) -ErrorAction SilentlyContinue | ForEach-Object {
			$Init_Folder_All_File += $_.FullName
		}

		<#
			.语言包
		#>
		$UI_Main_Prerequisite_Language_Name  = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Text           = "$($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.Language.count) $($lang.EventManagerCount)"
		}
		$UI_Main_Prerequisite_Verify_Select.controls.AddRange($UI_Main_Prerequisite_Language_Name)

		if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.Language.count -gt 0) {
			foreach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.Language) {
				$FlagFailed = $True
				$FileA = [IO.Path]::GetFileName($item)

				$UI_Main_Prerequisite_Language_Name = New-Object system.Windows.Forms.Label -Property @{
					autosize       = 1
					Padding        = "16,0,0,0"
					margin         = "0,0,0,10"
					Text           = "$($lang.Filename): $($FileA)"
					Tag            = $FileA
				}
				$UI_Main_Prerequisite_Verify_Select.controls.AddRange($UI_Main_Prerequisite_Language_Name)

				foreach ($Verifyfile in $Init_Folder_All_File) {
					$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 20
						Width          = 435
					}

					$FileB = [IO.Path]::GetFileName($Verifyfile)
					if ($FileA -eq $FileB) {
						$FlagFailed = $false
						$UI_Main_Prerequisite_Language_Name.Text = "$($lang.MatchMode) > $($lang.Filename): $($Verifyfile)"
						$UI_Main_Prerequisite_Language_Name.Tag  = $Verifyfile
						$UI_Main_Prerequisite_Language_Name.ForeColor = "#008000"

						$ISODrive = (Get-DiskImage -ImagePath $Verifyfile -ErrorAction SilentlyContinue | Get-Volume).DriveLetter
						if ($ISODrive) {
							$ISODrive = (Get-DiskImage -ImagePath $Verifyfile | Get-Volume).DriveLetter

							$UI_Main_Prerequisite_Mounted = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 30
								Width          = 435
								Padding        = "14,0,0,0"
								Text           = "$($lang.Prerequisite_satisfy), $($lang.Mounted): $($ISODrive):\"
								Tag            = "$($ISODrive):\"
								LinkColor      = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									$UI_Main_Prerequisite_Error.Text = ""
									$UI_Main_Prerequisite_Error_Icon.Image = $null

									if (Test-Path -Path $This.Tag -PathType Container) {
										Start-Process $This.Tag

										$UI_Main_Prerequisite_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
										$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									} else {
										$UI_Main_Prerequisite_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
										$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
									}
								}
							}

							$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
								$UI_Main_Prerequisite_Mounted,
								$GUIImageSelectFunctionLang_Wrap
							))

							$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
								File      = $item
								NewFile   = $Verifyfile
								IsProcess = "Yes"
							}
							break
						} else {
							$UI_Main_Prerequisite_NotMounted = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 30
								Width          = 435
								Padding        = "14,0,0,0"
								Text           = "$($lang.Prerequisite_satisfy), $($lang.NotMounted)"
								Tag            = $Verifyfile
								LinkColor      = "#FF0000"
								ActiveLinkColor = "#008000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									Mount-DiskImage -ImagePath $this.Tag -StorageType ISO
									Refresh_All_Rule_Guid
									Refresh_Prerequisite_Is_Satisfy
								}
							}
							$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
								$UI_Main_Prerequisite_NotMounted,
								$GUIImageSelectFunctionLang_Wrap
							))

							$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
								File      = $item
								NewFile   = $Verifyfile
								IsProcess = "WaitMount"
							}
							break
						}
					}
				}

				if ($FlagFailed) {
					$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
						File      = $item
						NewFile   = ""
						IsProcess = "Failed"
					}
					$UI_Main_Prerequisite_satisfied = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
						Padding        = "14,0,0,0"
						Text           = $lang.Prerequisite_Not_satisfied
					}
					$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
					}
					$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
						$UI_Main_Prerequisite_satisfied,
						$GUIImageSelectFunctionLang_Wrap
					))
				}
			}

		<#
			.未发现主要文件语言包
		#>
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				autosize = 1
				Padding  = "16,0,0,0"
				Text     = $lang.NoWork
			}

			$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 435
			}
			$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
				$UI_Main_Pre_Rule_Not_Find,
				$GUIImageSelectFunctionLang_Wrap
			))
		}

		<#
			.InBox Apps
		#>
		$UI_Main_Prerequisite_Language_Name  = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Text           = "InBox Apps: $($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.InBoxApps.count) $($lang.EventManagerCount)"
		}
		$UI_Main_Prerequisite_Verify_Select.controls.AddRange($UI_Main_Prerequisite_Language_Name)

		if ($Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.InBoxApps.count -gt 0) {
			foreach ($item in $Script:InBox_Apps_Rule_Select_Single.Autopilot.Prerequisite.$NewInBoxAppsFolder.ISO.InBoxApps) {
				$FlagFailed = $True
				$FileA = [IO.Path]::GetFileName($item)

				$UI_Main_Prerequisite_Language_Name = New-Object system.Windows.Forms.Label -Property @{
					autosize       = 1
					Padding        = "16,0,0,0"
					margin         = "0,0,0,10"
					Text           = "$($lang.Filename): $($FileA)"
					Tag            = $FileA
				}
				$UI_Main_Prerequisite_Verify_Select.controls.AddRange($UI_Main_Prerequisite_Language_Name)

				foreach ($Verifyfile in $Init_Folder_All_File) {
					$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 20
						Width          = 435
					}

					$FileB = [IO.Path]::GetFileName($Verifyfile)
					if ($FileA -eq $FileB) {
						$FlagFailed = $false
						$UI_Main_Prerequisite_Language_Name.Text = "$($lang.MatchMode) > $($lang.Filename): $($Verifyfile)"
						$UI_Main_Prerequisite_Language_Name.Tag  = $Verifyfile
						$UI_Main_Prerequisite_Language_Name.ForeColor = "#008000"

						$ISODrive = (Get-DiskImage -ImagePath $Verifyfile -ErrorAction SilentlyContinue | Get-Volume).DriveLetter
						if ($ISODrive) {
							$ISODrive = (Get-DiskImage -ImagePath $Verifyfile | Get-Volume).DriveLetter

							$UI_Main_Prerequisite_Mounted = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 30
								Width          = 435
								Padding        = "14,0,0,0"
								Text           = "$($lang.Prerequisite_satisfy), $($lang.Mounted): $($ISODrive):\"
								Tag            = "$($ISODrive):\"
								LinkColor      = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									$UI_Main_Prerequisite_Error.Text = ""
									$UI_Main_Prerequisite_Error_Icon.Image = $null

									if (Test-Path -Path $This.Tag -PathType Container) {
										Start-Process $This.Tag

										$UI_Main_Prerequisite_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
										$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									} else {
										$UI_Main_Prerequisite_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
										$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
									}
								}
							}

							$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
								$UI_Main_Prerequisite_Mounted,
								$GUIImageSelectFunctionLang_Wrap
							))

							$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
								File      = $item
								NewFile   = $Verifyfile
								IsProcess = "Yes"
							}
							break
						} else {
							$UI_Main_Prerequisite_NotMounted = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 30
								Width          = 435
								Padding        = "14,0,0,0"
								Text           = "$($lang.Prerequisite_satisfy), $($lang.NotMounted)"
								Tag            = $Verifyfile
								LinkColor      = "#FF0000"
								ActiveLinkColor = "#008000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									Mount-DiskImage -ImagePath $this.Tag -StorageType ISO
									Refresh_All_Rule_Guid
									Refresh_Prerequisite_Is_Satisfy
								}
							}
							$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
								$UI_Main_Prerequisite_NotMounted,
								$GUIImageSelectFunctionLang_Wrap
							))

							$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
								File      = $item
								NewFile   = $Verifyfile
								IsProcess = "WaitMount"
							}
							break
						}
					}
				}

				if ($FlagFailed) {
					$Script:Prerequisite_Is_Satisfy += [pscustomobject]@{
						File      = $item
						NewFile   = ""
						IsProcess = "Failed"
					}
					$UI_Main_Prerequisite_satisfied = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
						Padding        = "14,0,0,0"
						Text           = $lang.Prerequisite_Not_satisfied
					}
					$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 435
					}
					$UI_Main_Prerequisite_Verify_Select.controls.AddRange((
						$UI_Main_Prerequisite_satisfied,
						$GUIImageSelectFunctionLang_Wrap
					))
				}
			}

		<#
			.未发现主要文件 InBox Apps
		#>
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				autosize = 1
				Padding  = "16,0,0,0"
				Text     = $lang.NoWork
			}

			$UI_Main_Prerequisite_Verify_Select.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	function Refresh_Prerequisite_Is_Satisfy
	{
		[int]$CountSatisfy = 0

		# 已挂载的所有 ISO
		$Other_ISO_File = @()

		$Script:Other_ISO_is_Mount = @()
		$Other_ISO_Falied = 0

		if ($Script:Prerequisite_Is_Satisfy.Count -gt 0) {
			Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
				Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
					$Other_ISO_File += $_.ImagePath
				}
			}

			foreach ($item in $Script:Prerequisite_Is_Satisfy) {
				if ($item.IsProcess -eq "WaitMount") {
					$CountSatisfy++
				}

				if ($item.IsProcess -eq "Failed") {
					$Other_ISO_Falied++
				}
			}

			foreach ($item in $Other_ISO_File) {
				if ($Script:Prerequisite_Is_Satisfy.NewFile -notcontains $item) {
					$Script:Other_ISO_is_Mount += $item
				}
			}

			if ($Script:Other_ISO_is_Mount.count -gt 0) {
				$UI_Main_Prerequisite_Eject_Cdrom_After.Checked = $True
				$UI_Main_Prerequisite_Eject_Cdrom_After_Tips.Text = "$($lang.Eject_Cdrom_Is_Other): $($Script:Other_ISO_is_Mount.Count) $($lang.EventManagerCount)"
			} else {
				$UI_Main_Prerequisite_Eject_Cdrom_After.Checked = $False
				$UI_Main_Prerequisite_Eject_Cdrom_After_Tips.Text = $lang.Eject_Cdrom_Not_Mount
			}

			<#
				.等待挂载
			#>
			if ($CountSatisfy -gt 0) {
				$UI_Main_Prerequisite_Ok.Enabled = $True
				$UI_Main_Prerequisite_Error.Text = $lang.Prerequisite_Is_Not_satisfied -f $Script:Prerequisite_Is_Satisfy.Count, $CountSatisfy, $Other_ISO_Falied
				$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")

			} else {
				if ($Other_ISO_Falied -gt 0) {
					$UI_Main_Prerequisite_Ok.Enabled = $False
					$UI_Main_Prerequisite_Error.Text = $lang.Prerequisite_Is_Not_satisfied -f $Script:Prerequisite_Is_Satisfy.Count, $CountSatisfy, $Other_ISO_Falied
					$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")

				} else {
					$UI_Main_Prerequisite_Ok.Enabled = $False
					$UI_Main_Prerequisite_Error.Text = $lang.Prerequisite_Is_satisfy -f $Script:Prerequisite_Is_Satisfy.Count
					$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		} else {
			$UI_Main_Prerequisite_Ok.Enabled = $False
			$UI_Main_Prerequisite_Error.Text = $lang.Nowork
			$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Prerequisite_Eject_Cdrom_After_Tips.Text = $lang.Nowork

			$UI_Main_Prerequisite_Eject_Cdrom_After.Checked = $False
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = $lang.Autopilot
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Autopilot_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Autopilot_View_Detailed_Show = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 1030
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Autopilot_View_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "807,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main.Text = $lang.Autopilot
			$UI_Main_Autopilot_View_Detailed.Visible = $False
		}
	}

	<#
		.Mask: Public
		.蒙板：公共库
	#>
	$UI_Main_Public_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}

	<#
		.选择规则
	#>
	$UI_Main_Public_Select_Rule = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 500
		Location       = "0,0"
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,15,10,10"
	}

	$UI_Main_Public_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Location       = "560,15"
		Text           = $lang.Import_Event_Public
	}

	$UI_Main_Public_Tips = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 340
		Width          = 460
		BorderStyle    = 0
		Location       = "580,50"
		Text           = $lang.Import_Event_Public_Tips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.公共事件：可选功能
	#>
	$UI_Main_Public_Adv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = '560,430'
		Text           = $lang.AdvOption
	}

	<#
		.自动隐藏“导入公共事件”设置界面
	#>
	$UI_Main_Public_Auto_Hide = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 465
		Location       = "580,460"
		Text           = $lang.Autopilot_Auto_Hide
		add_Click      = {
			if ($UI_Main_Public_Auto_Hide.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "Is_Auto_Hide_Public" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "Is_Auto_Hide_Public" -value "False"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "Is_Auto_Hide_Public" -ErrorAction SilentlyContinue) {
		$GetLanguagePrompt = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -Name "Is_Auto_Hide_Public" -ErrorAction SilentlyContinue
		switch ($GetLanguagePrompt) {
			"True" {
				$UI_Main.Text = "$($lang.Autopilot): $($lang.Import_Event_Public)"
				$UI_Main_Public_Auto_Hide.Checked = $True
				$UI_Main_Public_Detailed.Visible = $False
			}
			"False" {
				$UI_Main.Text = "$($lang.Autopilot): $($lang.Prerequisite)"
				$UI_Main_Public_Auto_Hide.Checked = $False
				$UI_Main_Public_Detailed.Visible = $true
			}
		}
	} else {
		$UI_Main.Text = "$($lang.Autopilot): $($lang.Prerequisite)"
		$UI_Main_Public_Auto_Hide.Checked = $False
		$UI_Main_Public_Detailed.Visible = $true
	}

	<#
		.清除所有全局公共事件
	#>
	$UI_Main_Public_Clear_Global = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Location       = '594,510'
		Text           = $lang.Import_Event_Clear_Global
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Public_Error.Text = ""
			$UI_Main_Public_Error_Icon.Image = $null

			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Autopilot\Deploy" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

			Autopilot_Refresh_Public_Events_All

			$UI_Main_Public_Error.Text = "$($lang.Import_Event_Clear_Global): $($lang.Done)"
			$UI_Main_Public_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.清除所有当前公共事件
	#>
	$UI_Main_Public_Clear_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Location       = '594,545'
		Text           = $lang.Import_Event_Clear_Current
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Public_Error.Text = ""
			$UI_Main_Public_Error_Icon.Image = $null

			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive\Autopilot" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

			Autopilot_Refresh_Public_Events_All

			$UI_Main_Public_Error.Text = "$($lang.Import_Event_Clear_Current): $($lang.Done)"
			$UI_Main_Public_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	$UI_Main_Public_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Public_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "586,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}
	$UI_Main_Public_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

			<#
				.重置变量
			#>
			Additional_Edition_Reset
			Event_Reset_Variable

			$UI_Main.Close()
		}
	}
	$UI_Main_Public_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main.Text = $lang.Autopilot
			$UI_Main_Public_Detailed.visible = $False
		}
	}

	<#
		.Masks: importing public rules
		.蒙板：导入公共规则
	#>
	$UI_Main_Export_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}

	<#
		.蒙板：导入公共规则，动态显示已知方案，提供用户选择
	#>
	$UI_Main_Export_Event_Custom_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 500
		Location       = "0,0"
		Padding        = "15,15,0,0"
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.自动驾驶：选择配置方案：刷新按钮
	#>
	$UI_Main_Prerequisite_Refresh_Sources = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Location       = "560,15"
		Text           = $lang.Autopilot_Select_Scheme
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectDriving" -value ""
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Autopilot" -name "SelectConfig" -value ""

			Refresh_Prerequisite_Sources

			$UI_Main_Export_Error.Text = "$($lang.Refresh), $($lang.Done)"
			$UI_Main_Export_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.蒙板：导入公共规则，显示菜单
	#>
	$UI_Main_Export_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 405
		Width          = 485
		Location       = "560,46"
		Padding        = "15,0,0,0"
		autoSizeMode   = 0
		autoScroll     = $True
	}

	$UI_Main_Select_Sources = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.自动驾驶配置文件
	#>
	$UI_Main_Select_Sources_Config = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Padding        = "22,0,0,0"
		Text           = $lang.Autopilot_Select_Config
	}

	$UI_Main_Select_Sources_Config_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "16,0,0,0"
	}

	<#
		.自动驾驶：选择配置方案：前往
	#>
	$UI_Main_Export_Go_To = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,485"
		Height         = 30
		Width          = 460
		Text           = $lang.Ok_Go_To
	}

		<#
			.自动驾驶：选择配置方案：前往：导入公共事件
		#>
		$UI_Main_Export_Go_To_Public = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 485
			Location       = "576,520"
			Text           = $lang.Import_Event_Public
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Text = "$($lang.Autopilot): $($lang.Import_Event_Public)"
				$UI_Main_Public_Detailed.visible = $true
			}
		}

		<#
			.自动驾驶：选择配置方案：前往：先决规则
		#>
		$UI_Main_Export_Go_To_Prerequisite = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 485
			Location       = "576,555"
			Text           = $lang.Prerequisite
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Text = "$($lang.Autopilot): $($lang.Prerequisite)"
				$UI_Main_Prerequisite_Detailed.visible = $true
			}
		}

	$UI_Main_Export_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,600"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Export_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "585,602"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UI_Main_Export_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

			<#
				.重置变量
			#>
			Additional_Edition_Reset
			Event_Reset_Variable

			$UI_Main.Close()
		}
	}
	$UI_Main_Export_Detailed_Import = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Import
		add_Click      = { Refresh_Config_Rule_Import_To_Event }
	}
	$UI_Main_Export_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main.Text = $lang.Autopilot
			$UI_Main_Export_Detailed.Visible = $False
		}
	}

	<#
		.Mask: Prerequisite
		.蒙板：先决条件
	#>
	$UI_Main_Prerequisite_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}

	<#
		.选择规则
	#>
	$UI_Main_Select_Rule = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 500
		Location       = "0,0"
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,15,10,10"
	}

	<#
		.蒙板：先决条件，显示菜单
	#>
	$UI_Main_Prerequisite_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 430
		Width          = 485
		Location       = "560,15"
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.选择先决条件
	#>
	$UI_Main_Prerequisite_Verify = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Text           = $lang.Prerequisite
	}

	$UI_Main_Prerequisite_Verify_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "16,0,0,0"
		margin         = "0,0,0,35"
	}

	<#
		.Pop up the mounted ISO file
		.弹出已挂载 ISO 文件
	#>
	$UI_Main_Prerequisite_Eject_Cdrom_After = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 485
		Location       = "560,475"
		Text           = $lang.Eject_Cdrom_After
		Checked        = $True
		add_Click      = {
			$UI_Main_Prerequisite_Error.Text = ""
			$UI_Main_Prerequisite_Error_Icon.Image = $null
		}
	}
	$UI_Main_Prerequisite_Eject_Cdrom_After_Tips = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 470
		Location       = "575,512"
		Text           = ""
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if ($Script:Other_ISO_is_Mount.count -gt 0) {
				foreach ($item in $Script:Other_ISO_is_Mount) {
					try {
						DisMount-DiskImage -ImagePath $item
					} catch {
					}
				}

				Refresh_All_Rule_Guid
				Refresh_Prerequisite_Is_Satisfy
			} else {
				$UI_Main_Prerequisite_Eject_Cdrom_After_Tips.Text = $lang.Eject_Cdrom_Not_Mount
			}
		}
	}

	$UI_Main_Prerequisite_Eject_Cdrom = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 470
		Location       = "575,545"
		Text           = $lang.Eject_Cdrom
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
				Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
					DisMount-DiskImage -ImagePath $_.ImagePath
				}
			}

			Refresh_All_Rule_Guid
			Refresh_Prerequisite_Is_Satisfy
		}
	}

	$UI_Main_Prerequisite_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Prerequisite_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "586,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UI_Main_Prerequisite_Canel_Close = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

			<#
				.重置变量
			#>
			Additional_Edition_Reset
			Event_Reset_Variable

			$UI_Main.Close()
		}
	}
	$UI_Main_Prerequisite_Ok = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.OK
		Enabled        = $false
		add_Click      = {
			$UI_Main_Prerequisite_Error.Text = ""
			$UI_Main_Prerequisite_Error_Icon.Image = $null

			if ($Script:Prerequisite_Is_Satisfy.count -gt 0) {
				if ($UI_Main_Prerequisite_Eject_Cdrom_After.Checked) {
					Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
						Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
							DisMount-DiskImage -ImagePath $_.ImagePath
						}
					}

					foreach ($item in $Script:Prerequisite_Is_Satisfy) {
						if ([string]::IsNullOrEmpty($item.NewFile)) {

						} else {
							Mount-DiskImage -ImagePath $item.NewFile -StorageType ISO
						}
					}
				} else {
					$GetDiskImageCurrent = @()
					Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
						Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
							$GetDiskImageCurrent += $_.ImagePath
						}
					}

					foreach ($item in $Script:Prerequisite_Is_Satisfy) {
						if ($item.IsProcess -eq "WaitMount") {
							if ($GetDiskImageCurrent -notcontains $item.NewFile) {
								Mount-DiskImage -ImagePath $item.NewFile -StorageType ISO
							}
						}
					}
				}

				Refresh_All_Rule_Guid
				Refresh_Prerequisite_Is_Satisfy
			} else {
				$UI_Main_Prerequisite_Error.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
				$UI_Main_Prerequisite_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\info.ico")
			}
		}
	}
	$UI_Main_Prerequisite_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main.Text = $lang.Autopilot
			$UI_Main_Prerequisite_Detailed.visible = $False
		}
	}

	$UI_Main_Group     = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 510
		Dock           = 3
		BorderStyle    = 0
		autoSizeMode   = 0
		Padding        = "15,10,10,10"
		autoScroll     = $True
	}

	<#
		.选择 install.wim 或 boot.wim 及跳过选择
	#>
	$UI_Main_Is_Select_Wim = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 485
		Text           = $lang.AssignSkip
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($this.Checked) {
				$UI_Main_Select_Wim.Enabled = $False

				$UI_Main_Select_Wim.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						Check_Select_New_Autopilot
						Image_Select_Disable_Expand_Main_Item_Autopilot -Group $_.Tag -MainUid $_.Tag
					}
				}
			} else {
				$UI_Main_Select_Wim.Enabled = $True

				$UI_Main_Select_Wim.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						Check_Select_New_Autopilot
						Image_Select_Disable_Expand_Main_Item_Autopilot -Group $_.Tag -MainUid $_.Tag
					}
				}
			}
		}
	}

	$UI_Main_Select_Wim = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,45"
		autoScroll     = $False
	}

	$UI_Main_Select_Assign_Multitasking = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.无需挂载时
	#>
	$UI_Main_Select_No_Mounting_Group = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 390
		Width          = 485
		Location       = "560,15"
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.组，无挂载时可用事件
	#>
	$UI_Main_Select_No_Mounting = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}
	$GUIImageSelectEventNeedMount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.AssignNoMount
	}

	<#
		.附加版本
	#>
	$UI_Main_Select_AdditionalEdition_Config = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = $lang.AdditionalEdition
	}

	$UI_Main_Select_AdditionalEdition_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "36,0,0,0"
		margin         = "0,0,0,25"
	}

	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if (Test-Path -Path "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -PathType Leaf) {
				$GUIImageSelectInstall = New-Object System.Windows.Forms.CheckBox -Property @{
					Name               = $item.Main.Uid
					Tag                = $item.Main.Uid
					Height             = 30
					Width              = 280
					Text               = $item.Main.Uid
				}

				$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
					Name           = $item.Main.Uid
					Height         = 30
					Width          = 400
					Padding        = "18,0,0,0"
					Margin         = "0,0,0,10"
					Text           = $lang.Detailed_View
					Tag            = $item.GUID
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						Image_Set_Global_Primary_Key -Uid $this.Name -Silent -DevCode "Autopilot - 3333"
						Additional_Edition_UI
					}
				}

				$UI_Main_Select_AdditionalEdition_Select.controls.AddRange((
					$GUIImageSelectInstall,
					$UI_Main_Rule_Details_View
				))
			}
		}
	}

	<#
		.转换
	#>
	$GUIImageSelectFunctionConvertImage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"
		Tag            = "Image_Convert_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Image_Convert_UI
			Autopilot_Refresh_Event_All
		}
	}
	$GUIImageSelectFunctionConvertImage_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "32,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Global:QueueConvert = $False
			$Global:Queue_Convert_Tasks = @()

			Autopilot_Refresh_Event_All

			$UI_Main_Error.Text = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm), $($lang.EventManagerCurrentClear): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.生成解决方案：ISO
	#>
	$UI_Main_Autopilot_Create_Solutions_To_ISO = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "16,0,0,0"
		margin         = "0,15,0,0"
		Text           = "$($lang.Solution): $($lang.IsCreate), ISO"
		Tag            = "ISO_Create_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Solutions_Create_UI -ISO
			Autopilot_Refresh_Event_All
		}
	}
	$UI_Main_Autopilot_Create_Solutions_To_ISO_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "32,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			New-Variable -Scope global -Name "Queue_Is_Solutions_ISO" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_ISO" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsUnattend_ISO" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsSoftwarePacker_ISO" -Value $False -Force

			Autopilot_Refresh_Event_All

			$UI_Main_Error.Text = "$($lang.Solution): $($lang.IsCreate), ISO, $($lang.EventManagerCurrentClear): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.关联 ISO 方案
	#>
	$GUIImageSelectFunctionISO = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "16,0,0,0"
		margin         = "0,15,0,0"
		Text           = $lang.ISO_Associated_Schemes
		Tag            = "ISO_Create_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			ISO_Associated_UI
			Autopilot_Refresh_Event_All
		}
	}
	$GUIImageSelectFunctionISO_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "32,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Global:Queue_ISO_Associated = $False
			$SavePath = $Global:Queue_ISO_Associated_Tasks.Sources

			$Global:Queue_ISO_Associated_Tasks = @{
				Sources = $SavePath
				Rule = @()
			}

			Autopilot_Refresh_Event_All

			$UI_Main_Error.Text = "$($lang.UnpackISO), $($lang.EventManagerCurrentClear): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.组，有任务可用时
	#>
	$GUIImageSelectEventHave = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 450
		margin         = "0,25,0,0"
		Text           = $lang.AfterFinishingNotExecuted
	}
	$GUIImageSelectEventCompletionGUI = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = $lang.WaitTimeTitle
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Completion_Start_Setting_UI }
	}
	$GUIImageSelectFunctionWaitTime = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = "$($lang.AfterFinishingPause), $($lang.AfterFinishingReboot), $($lang.AfterFinishingShutdown)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Completion_Setting_UI }
	}

	<#
		.选择菜单
	#>
	$UI_Main_Reselect_New_Go_To = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 460
		Text           = $lang.Ok_Go_To
		Location       = '560,450'
	}
	<#
		.自动驾驶：选择配置方案：选择先决规则界面
	#>
	$UI_Main_Reselect_Prerequisite = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 460
		Padding        = "16,0,0,0"
		Location       = '560,485'
		Text           = $lang.Prerequisite
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Text = "$($lang.Autopilot): $($lang.Prerequisite)"
			$UI_Main_Prerequisite_Detailed.visible = $true
			$UI_Main_Export_Detailed.visible = $False
		}
	}

	<#
		.自动驾驶：选择配置方案：前往：导入公共事件
	#>
	$UI_Main_Reselect_Go_To_Public = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 460
		Padding        = "16,0,0,0"
		Location       = '560,520'
		Text           = $lang.Import_Event_Public
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Text = "$($lang.Autopilot): $($lang.Import_Event_Public )"
			$UI_Main_Public_Detailed.visible = $true
		}
	}

	$UI_Main_Reselect_Config = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 460
		Padding        = "16,0,0,0"
		Location       = '560,555'
		Text           = $lang.Autopilot_Select_Config
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Text = "$($lang.Autopilot): $($lang.Autopilot_Select_Config )"
			$UI_Main_Prerequisite_Detailed.visible = $False
			$UI_Main_Export_Detailed.visible = $true
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "565,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "590,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}
	$UI_Main_Canel_Close = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

			<#
				.重置变量
			#>
			Additional_Edition_Reset
			Event_Reset_Variable

			$UI_Main.Close()
		}
	}
	$UI_Main_Ok        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			<#
				.初始化变量
			#>
			ForEach ($item in $Global:Image_Rule) {
				New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($item.Main.Uid)" -Value $False -Force
				New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($item.Main.Uid)" -Value $False -Force
				New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -Value $False -Force
				New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $False -Force
				New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($item.Main.Uid)" -Value $False -Force

				if ($item.Expand.Count -gt 0) {
					ForEach ($itemExpandNew in $item.Expand) {
						New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($itemExpandNew.Uid)" -Value $False -Force
						New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($itemExpandNew.Uid)" -Value $False -Force
						New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpandNew.Uid)" -Value $False -Force
						New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($itemExpandNew.Uid)" -Value $False -Force
					}
				}
			}

			<#
				.多任务分配
			#>

			<#
				.开始分配可用的多会话任务
			#>
			<#
				1、分配前获取已选的所有项，根据唯一识别码
			#>
			$MainItem = @()
			$disable = @()

			<#
				.附加版本：清除未选择的项
			#>
			$UI_Main_Select_AdditionalEdition_Select.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
					} else {
						New-Variable -Scope global -Name "Queue_Additional_Edition_$($_.Tag)" -Value @() -Force
						New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($_.Tag)" -Value @() -Force
					}
				}
			}

			$Wait_Sync_Some_Select = @()
			$UI_Main_Select_Wim.Controls | ForEach-Object {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Wait_Sync_Some_Select += $_.Tag
					}
				}
			}

			<#
				.清除未选择的事件
			#>
			if ($UI_Main_Is_Select_Wim.Checked) {
				Event_Reset_Specified_Variable -IsNoRefresh "Yes"
			} else {
				Event_Reset_Specified_Variable -IsNoRefresh "Yes" -Tasks $Wait_Sync_Some_Select
			}

			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					if ($Wait_Sync_Some_Select -contains $item.Main.uid) {
						$MainItem += $item.Main.uid
					}

					if ($item.Expand.Count -gt 0) {
						ForEach ($Expand in $item.Expand) {
							if ($Wait_Sync_Some_Select -contains $Expand.uid) {
								$MainItem += $item.Main.uid
								$MainItem += $Expand.uid

								if ($Wait_Sync_Some_Select -notcontains $item.Main.uid) {
									$disable += $item.Main.uid
								}
							}
						}
					}
				}
			}
			$MainItem = $MainItem | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$disable = $disable | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

			#region Image Rule
			ForEach ($item in $Global:Image_Rule) {
				$Fix_Eject_Force_Expand = $False

				if ($MainItem -Contains $item.Main.Uid) {
					<#
						.判断是否分配事件
					#>
					$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($item.Main.Uid -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_.Name -eq "ImageSources") {
										$TempQueueProcessImageSelectPending = [pscustomobject]@()
										$MarkSelectIndexin = @()

										ForEach ($ItemNew in $_.Controls) {
											if ($ItemNew -is [System.Windows.Forms.CheckBox]) {
												if ($ItemNew.Enabled) {
													if ($ItemNew.Checked) {
														$MarkSelectIndexin += $ItemNew.Tag
													}
												}
											}
										}

										if ($MarkSelectIndexin.Count -gt 0) {
											ForEach ($itemIndex in $MarkSelectIndexin) {
												ForEach ($WildCard in (Get-Variable -Scope global -Name "Queue_Process_Image_Select_$($item.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
													if ($itemIndex -eq $WildCard.Index) {
														$TempQueueProcessImageSelectPending += [pscustomobject]@{
															Index            = $WildCard.Index
															Name             = $WildCard.Name
															ImageDescription = $WildCard.ImageDescription
														}
													}
												}
											}

											New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($item.Main.Uid)" -Value $TempQueueProcessImageSelectPending -Force
										}
									}

									ForEach ($ItemNew in $_.Controls) {
										if ($ItemNew -is [System.Windows.Forms.CheckBox]) {
											if ($ItemNew.Name -eq "EjectForce") {
												if ($ItemNew.Enabled) {
													if ($ItemNew.Checked) {
														<#
															.强制打开扩展项不保存，不管选没有选。
														#>
														$Fix_Eject_Force_Expand = $True

														New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -Value $True -Force
													}
												}
											}
											#endregion
										}

										if ($ItemNew -is [System.Windows.Forms.FlowLayoutPanel]) {
											#region 保存：主要项
											if ($ItemNew.Tag -eq "EjectMain") {
												ForEach ($ItemNewTwo in $ItemNew.Controls) {
													if ($ItemNewTwo -is [System.Windows.Forms.CheckBox]) {
														<#
															.判断：允许自动开启快速抛弃方式
														#>
														if ($ItemNewTwo.Enabled) {
															if ($ItemNewTwo.Checked) {
																if ($ItemNewTwo.Tag -eq "AbandonAllow") {
																	New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $True -Force
																}
															}
														}
													}

													if ($ItemNewTwo -is [System.Windows.Forms.RadioButton]) {
														<#
															.判断保存
														#>
														if ($ItemNewTwo.Enabled) {
															if ($ItemNewTwo.Checked) {
																if ($ItemNewTwo.Tag -eq "Save") {
																	New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($item.Main.Uid)" -Value $True -Force

																	if ($Global:Developers_Mode) {
																		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.101x1`n  Start"
																		Write-Host "$($lang.Event_Assign_Main), " -NoNewline
																		Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																		Write-Host "Queue_Eject_Only_Save_$($item.Main.Uid)"
																	}
																}

																if ($ItemNew.Tag -eq "DoNotSave") {
																	New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -Value $True -Force

																	if ($Global:Developers_Mode) {
																		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.200x1`n  Start"
																		Write-Host "$($lang.Event_Assign_Main), " -NoNewline
																		Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																		Write-Host "Queue_Eject_Do_Not_Save_$($item.Main.Uid)"
																	}
																}
															}
														}
													}
												}
											}
											#endregion
										}

										#region ADV
										if ($ItemNew.Tag -eq "ADV") {
											ForEach ($ItemNewTTTT in $ItemNew.Controls) {
												if ($ItemNewTTTT -is [System.Windows.Forms.CheckBox]) {
													if ($ItemNewTTTT.Enabled) {
														if ($ItemNewTTTT.Checked) {
															New-Variable -Scope global -Name "Queue_$($ItemNewTTTT.Tag)_$($item.Main.Uid)" -Value $True -Force
														}
													}
												}
											}
										}
									}
									#endregion
								}
							}
						}
					}
				}
				#endregion

				#region Expand
				if ($item.Expand.Count -gt 0) {
					ForEach ($itemExpand in $item.Expand) {
						if ($MainItem -Contains $itemExpand.Uid) {
							#region 判断是否分配事件
							$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
									if ($itemExpand.Uid -eq $_.Name) {
										#region Object
										$_.Controls | ForEach-Object {
											if ($_.Name -eq "ImageSources") {
												$TempQueueProcessImageSelectPending = [pscustomobject]@()
												$MarkSelectIndexin = @()

												ForEach ($ItemNew in $_.Controls) {
													if ($ItemNew -is [System.Windows.Forms.CheckBox]) {
														if ($ItemNew.Enabled) {
															if ($ItemNew.Checked) {
																$MarkSelectIndexin += $ItemNew.Tag
															}
														}
													}
												}

												if ($MarkSelectIndexin.Count -gt 0) {
													ForEach ($itemIndex in $MarkSelectIndexin) {
														ForEach ($WildCard in (Get-Variable -Scope global -Name "Queue_Process_Image_Select_$($itemExpand.Uid)" -ErrorAction SilentlyContinue).Value) {
															if ($itemIndex -eq $WildCard.Index) {
																$TempQueueProcessImageSelectPending += [pscustomobject]@{
																	Index            = $WildCard.Index
																	Name             = $WildCard.Name
																	ImageDescription = $WildCard.ImageDescription
																}
															}
														}
													}

													New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($itemExpand.Uid)" -Value $TempQueueProcessImageSelectPending -Force
												}
											}

											if ($_ -is [System.Windows.Forms.CheckBox]) {
												if ($_.Name -eq "EjectForce") {
													if ($_.Enabled) {
														if ($_.Checked) {
															New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -Value $True -Force
														}
													}
												}
											}

											ForEach ($ItemNew in $_.Controls) {
												if ($ItemNew -is [System.Windows.Forms.CheckBox]) {
													if ($ItemNew.Name -eq "EjectForce") {
														if ($ItemNew.Enabled) {
															if ($ItemNew.Checked) {
																New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -Value $True -Force
															}
														}
													}
												}

												if ($ItemNew -is [System.Windows.Forms.FlowLayoutPanel]) {
													#region 保存：主要项
													if ($ItemNew.Tag -eq "EjectMain") {
														ForEach ($ItemNewTwo in $ItemNew.Controls) {
															if ($ItemNewTwo -is [System.Windows.Forms.CheckBox]) {
																<#
																	.判断：允许自动开启快速抛弃方式
																#>
																if ($ItemNewTwo.Enabled) {
																	if ($ItemNewTwo.Checked) {
																		if ($ItemNewTwo.Tag -eq "AbandonAllow") {
																			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $True -Force
																		}
																	}
																}
															}

															if ($ItemNewTwo -is [System.Windows.Forms.RadioButton]) {
																<#
																	.判断保存
																#>
																if ($ItemNewTwo.Enabled) {
																	if ($ItemNewTwo.Checked) {
																		if ($ItemNewTwo.Tag -eq "Save") {
																			New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($item.Main.Uid)" -Value $True -Force

																			if ($Global:Developers_Mode) {
																				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.11200x1`n  Start"
																				Write-Host "$($lang.Event_Assign_Main), " -NoNewline
																				Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																				Write-Host "Queue_Eject_Only_Save_$($item.Main.Uid)"
																			}
																		}

																		if ($ItemNewTwo.Tag -eq "DoNotSave") {
																			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -Value $True -Force

																			if ($Global:Developers_Mode) {
																				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectMain.21200x1`n  Start"
																				Write-Host "$($lang.Event_Assign_Main), " -NoNewline
																				Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																				Write-Host "Queue_Eject_Do_Not_Save_$($item.Main.Uid)"
																			}
																		}
																	}
																}
															}
														}
													}
													#endregion

													#region 保存：扩展项
													if ($ItemNew.Tag -eq "EjectExpand") {
														ForEach ($ItemNewTwo in $ItemNew.Controls) {
															if ($ItemNewTwo -is [System.Windows.Forms.CheckBox]) {
																<#
																	.判断：允许自动开启快速抛弃方式
																#>
																if ($ItemNewTwo.Enabled) {
																	if ($ItemNewTwo.Checked) {
																		if ($ItemNewTwo.Tag -eq "AbandonAllow") {
																			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($itemExpand.Uid)" -Value $True -Force
																		}
																	}
																}
															}

															if ($ItemNewTwo -is [System.Windows.Forms.RadioButton]) {
																<#
																	.判断保存
																#>
																if ($ItemNewTwo.Enabled) {
																	if ($ItemNewTwo.Checked) {
																		if ($ItemNewTwo.Tag -eq "Save") {
																			New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($itemExpand.Uid)" -Value $True -Force

																			if ($Global:Developers_Mode) {
																				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectExpand.200x1`n  Start"
																				Write-Host "$($lang.Event_Assign_Expand), " -NoNewline
																				Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																				Write-Host "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)"
																			}
																		}

																		if ($ItemNewTwo.Tag -eq "DoNotSave") {
																			New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -Value $True -Force

																			if ($Global:Developers_Mode) {
																				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EjectExpand.222x1`n  Start"
																				Write-Host "$($lang.Event_Assign_Expand), " -NoNewline
																				Write-Host "$($lang.DoNotSave), " -NoNewline -ForegroundColor Green
																				Write-Host "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)"
																			}
																		}
																	}
																}
															}
														}

														<#
															.强行修复不保存项
															如果主要项选择了不保存，扩展项默认强制弹出。
														#>
														if ($Fix_Eject_Force_Expand) {
															New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -Value $True -Force
														}
													}
													#endregion
												}

												#region ADV
												if ($ItemNew.Tag -eq "ADV") {
													ForEach ($ItemNewTwo in $ItemNew.Controls) {
														if ($ItemNewTwo -is [System.Windows.Forms.CheckBox]) {
															if ($ItemNewTwo.Enabled) {
																if ($ItemNewTwo.Checked) {
																	New-Variable -Scope global -Name "Queue_$($ItemNewTwo.Tag)_$($itemExpand.Uid)" -Value $True -Force
																} else {
																	New-Variable -Scope global -Name "Queue_$($ItemNewTwo.Tag)_$($itemExpand.Uid)" -Value $False -Force
																}
															} else {
																New-Variable -Scope global -Name "Queue_$($ItemNewTwo.Tag)_$($itemExpand.Uid)" -Value $False -Force
															}
														}
													}
												}
												#endregion
											}
										}
										#endregion
									}
								}
							}
							#endregion
						}
					}
				}
				#endregion
			}
			#endregion

			#region 验证保存和不保存事件
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): Developers_Mode.0x009200x1`n  Start"
				Write-Host "`n  $($lang.Verify_Save_And_DonSave)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				ForEach ($item in $Global:Image_Rule) {
					if ($Global:SMExt -contains $item.Main.Suffix) {
						Write-Host "  $($item.Main.Uid)"
						Write-Host "  $('-' * 80)"
						Write-Host "  $($lang.Event_Assign_Main)"
						Write-Host "  $($lang.Main_quests)" -ForegroundColor Yellow
						Write-Host "  $($lang.SaveTo)"
						if ((Get-Variable -Scope global -Name "Queue_Eject_Only_Save_$($item.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
							Write-Host "  $($lang.Enable), Queue_Eject_Only_Save_$($item.Main.Uid)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Disable), Queue_Eject_Only_Save_$($item.Main.Uid)"
						}
						if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($item.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
							Write-Host "  $($lang.Enable), Queue_Expand_Eject_Only_Save_$($item.Main.Uid)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Disable), Queue_Expand_Eject_Only_Save_$($item.Main.Uid)"
						}

						Write-Host "`n  $($lang.DoNotSave)"
						if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
							Write-Host "  $($lang.Enable), Queue_Eject_Do_Not_Save_$($item.Main.Uid)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Disable), Queue_Eject_Do_Not_Save_$($item.Main.Uid)"
						}
						if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($item.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
							Write-Host "  $($lang.Enable), Queue_Expand_Eject_Do_Not_Save_$($item.Main.Uid)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Disable), Queue_Expand_Eject_Do_Not_Save_$($item.Main.Uid)"
						}

						Write-Host "`n  $($lang.Event_Assign_Expand)"
						Write-Host "  $($lang.Side_quests)" -ForegroundColor Yellow
						if ($item.Expand.Count -gt 0) {
							ForEach ($itemExpand in $item.Expand) {
								Write-Host "  $($lang.SaveTo)"
								if ((Get-Variable -Scope global -Name "Queue_Eject_Only_Save_$($itemExpand.Uid)" -ErrorAction SilentlyContinue).Value) {
									Write-Host "  $($lang.Enable), Queue_Eject_Only_Save_$($itemExpand.Uid)" -ForegroundColor Green
								} else {
									Write-Host "  $($lang.Disable), Queue_Eject_Only_Save_$($itemExpand.Uid)"
								}

								if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($itemExpand.Uid)" -ErrorAction SilentlyContinue).Value) {
									Write-Host "  $($lang.Enable), Queue_Expand_Eject_Only_Save_$($itemExpand.Uid)" -ForegroundColor Green
								} else {
									Write-Host "  $($lang.Disable), Queue_Expand_Eject_Only_Save_$($itemExpand.Uid)"
								}

								Write-Host "`n  $($lang.DoNotSave)"
								if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -ErrorAction SilentlyContinue).Value) {
									Write-Host "  $($lang.Enable), Queue_Eject_Do_Not_Save_$($itemExpand.Uid)" -ForegroundColor Green
								} else {
									Write-Host "  $($lang.Disable), Queue_Eject_Do_Not_Save_$($itemExpand.Uid)"
								}

								if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($itemExpand.Uid)" -ErrorAction SilentlyContinue).Value) {
									Write-Host "  $($lang.Enable), Queue_Expand_Eject_Do_Not_Save_$($itemExpand.Uid)" -ForegroundColor Green
								} else {
									Write-Host "  $($lang.Disable), Queue_Expand_Eject_Do_Not_Save_$($itemExpand.Uid)"
								}
							}
						} else {
							Write-Host "  $($lang.NoWork)" -ForegroundColor Red
						}

						Write-Host
					}
				}
			}
			#endregion

			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Autopilot_View_Detailed,
		$UI_Main_Prerequisite_Detailed,
		$UI_Main_Public_Detailed,
		$UI_Main_Export_Detailed,

		$UI_Main_Group,
		
		$UI_Main_Select_No_Mounting_Group,

		<#
			.选择 Install、Boot、WinRE
		#>
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Reselect_New_Go_To,
		$UI_Main_Reselect_Prerequisite,
		$UI_Main_Reselect_Go_To_Public,
		$UI_Main_Reselect_Config,
		$UI_Main_Canel_Close,
		$UI_Main_Ok
	))
	$UI_Main_Group.controls.AddRange((
		$UI_Main_Is_Select_Wim,
		$UI_Main_Select_Wim,
		$UI_Main_Select_Assign_Multitasking
	))
	$UI_Main_Prerequisite_Detailed.controls.AddRange((
		$UI_Main_Prerequisite_Menu,
		$UI_Main_Select_Rule,
		$UI_Main_Prerequisite_Eject_Cdrom_After,
		$UI_Main_Prerequisite_Eject_Cdrom_After_Tips,
		$UI_Main_Prerequisite_Eject_Cdrom,
		$UI_Main_Prerequisite_Error_Icon,
		$UI_Main_Prerequisite_Error,
		$UI_Main_Prerequisite_Canel_Close,
		$UI_Main_Prerequisite_Ok,
		$UI_Main_Prerequisite_Canel
	))
	$UI_Main_Prerequisite_Menu.controls.AddRange((
		<#
			.选择先决条件
		#>
		$UI_Main_Prerequisite_Verify,
		$UI_Main_Prerequisite_Verify_Select
	))

	$UI_Main_Autopilot_View_Detailed.controls.AddRange((
		$UI_Main_Autopilot_View_Detailed_Show,
		$UI_Main_Autopilot_View_Detailed_Hide
	))

	$UI_Main_Public_Detailed.controls.AddRange((
		$UI_Main_Public_Select_Rule,
		$UI_Main_Public_Name,
		$UI_Main_Public_Tips,
		$UI_Main_Public_Adv,
		$UI_Main_Public_Clear_Global,
		$UI_Main_Public_Clear_Current,
		$UI_Main_Public_Error_Icon,
		$UI_Main_Public_Error,
		$UI_Main_Public_Auto_Hide,
		$UI_Main_Public_Canel,
		$UI_Main_Public_Hide
	))

	$UI_Main_Export_Detailed.controls.AddRange((
		<#
			.蒙板：导入公共规则，动态显示已知方案，提供用户选择
		#>
		$UI_Main_Export_Event_Custom_Menu,

		<#
			.蒙板：导入公共规则，显示菜单
		#>
		$UI_Main_Export_Menu,
		$UI_Main_Prerequisite_Refresh_Sources,

		<#
			.先决条件：选择配置方案：前往
		#>
		$UI_Main_Export_Go_To,

			<#
				.前往：导入公共事件
			#>
			$UI_Main_Export_Go_To_Public,

			<#
				.前往：先决条件
			#>
			$UI_Main_Export_Go_To_Prerequisite,

		$UI_Main_Export_Error_Icon,
		$UI_Main_Export_Error,
		$UI_Main_Export_Detailed_Canel,
		$UI_Main_Export_Detailed_Import,
		$UI_Main_Export_Detailed_Hide
	))
	$UI_Main_Export_Menu.controls.AddRange((
		<#
			.选择方案
		#>
		$UI_Main_Select_Sources,

		<#
			.自动驾驶配置文件
		#>
		$UI_Main_Select_Sources_Config,
		$UI_Main_Select_Sources_Config_Select
	))

	$UI_Main_Select_No_Mounting_Group.controls.AddRange($UI_Main_Select_No_Mounting)
	$UI_Main_Select_No_Mounting.controls.AddRange((
		$GUIImageSelectEventNeedMount,
		$UI_Main_Select_AdditionalEdition_Config,
		$UI_Main_Select_AdditionalEdition_Select,
		$GUIImageSelectFunctionConvertImage,
		$GUIImageSelectFunctionConvertImage_Clear,
		$UI_Main_Autopilot_Create_Solutions_To_ISO,
		$UI_Main_Autopilot_Create_Solutions_To_ISO_Clear,
		$GUIImageSelectFunctionISO,
		$GUIImageSelectFunctionISO_Clear,
		$GUIImageSelectEventHave,
		$GUIImageSelectEventCompletionGUI,
		$GUIImageSelectFunctionWaitTime
	))

	Image_Select_Refresh_Install_Boot_WinRE_Autopilot

	Refresh_Autopilot_Custom_Rule
	Image_Select_Public_Autopilot
	Refresh_Prerequisite_Sources
	Refresh_Prerequisite_Config
	Refresh_Config_Rule_Sync_To_Show
	Refresh_Prerequisite_Is_Satisfy

	$UI_Main.ShowDialog() | Out-Null
}

<#
	.导入：批量注入事件到每任务，示例：Install、WinRE、Boot	
#>
Function Autopilot_Refresh_Export_Event_To_WIM
{
	param
	(
		$Master,
		$ImageName,
		$ImageFile,
		$ImageUid,
		$Suffix,
		$SelectEvent,
		$NewTasks
	)

	$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
		if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
			if ($ImageUid -eq $_.Name) {
				$_.Controls | ForEach-Object {
					ForEach ($ImageSourcesConsole in $_.Controls) {
						if ($ImageSourcesConsole -is [System.Windows.Forms.Checkbox]) {
							if ($ImageSourcesConsole.Name -eq "EjectForce") {
								<#
									.强行弹出
								#>
								if ($NewTasks.Tasks.Eject.ForectEject) {
									$ImageSourcesConsole.Checked = $True

									$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
										if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
											if ($ImageUid -eq $_.Name) {
												$_.Controls | ForEach-Object {
													if ($_.Name -eq "ImageSourcesConsole") {
														ForEach ($_ in $_.Controls) {
															if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
																if ($_.Tag -eq "EjectMain") {
																	$_.Enabled = $True
																}
															}
														}
													}
												}
											}
										}
									}
								} else {
									$ImageSourcesConsole.Checked = $False

									$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
										if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
											if ($ImageUid -eq $_.Name) {
												$_.Controls | ForEach-Object {
													if ($_.Name -eq "ImageSourcesConsole") {
														ForEach ($_ in $_.Controls) {
															if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
																if ($_.Tag -eq "EjectMain") {
																	$_.Enabled = $False
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
						}
					}

					<#
						.选择索引号
					#>
					if ($_.Name -eq "ImageSources") {
						ForEach ($_ in $_.Controls) {
							if ($_ -is [System.Windows.Forms.Checkbox]) {
								if ($NewTasks.IsAutoSelectIndexAndEditionID -eq "Auto") {
									$_.Checked = $True
								} else {
									if (($NewTasks.IsAutoSelectIndexAndEditionID -contains $_.Tag) -or
									    ($NewTasks.IsAutoSelectIndexAndEditionID -contains $_.Name)) {
										$_.Checked = $True
									} else {
										$_.Checked = $False
									}
								}
							}
						}
					}

					if ($_.Name -eq "ImageSourcesConsole") {
						ForEach ($ImageSourcesConsole in $_.Controls) {
							if ($ImageSourcesConsole -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ($ImageSourcesConsole.Tag -eq "EjectMain") {
									ForEach ($ItemNew in $ImageSourcesConsole.Controls) {
										if ($ItemNew -is [System.Windows.Forms.RadioButton]) {
											if ($NewTasks.Tasks.Eject.Schome -eq $ItemNew.Tag) {
												$ItemNew.Checked = $True
											} else {
												$ItemNew.Checked = $False
											}
										}
									}
								}

								if ($ImageSourcesConsole.Tag -eq "ADV") {
									ForEach ($ItemNew in $ImageSourcesConsole.Controls) {
										if ($ItemNew -is [System.Windows.Forms.Checkbox]) {
											<#
												.配置：重建
											#>
											if ($ItemNew.Tag -eq "Rebuild") {
												if ($NewTasks.Tasks.Expand.Rebuild) {
													$ItemNew.Checked = $True
												} else {
													$ItemNew.Checked = $False
												}
											}

											<#
												.允许更新规则
											#>
											if ($ItemNew.Tag -eq "Is_Update_Rule") {
												if ($NewTasks.Tasks.Expand.Rules.isUpdate) {
													$ItemNew.Checked = $True
													Image_Select_Disable_Expand_Item_Autopilot -Group $ItemNew.Parent.Parent.Parent.Name -Name $ItemNew.Tag -Open
												} else {
													$ItemNew.Checked = $False
													Image_Select_Disable_Expand_Item_Autopilot -Group $ItemNew.Parent.Parent.Parent.Name -Name $ItemNew.Tag -Close
												}
											}

											<#
												.更新到所有索引号
											#>
											if ($ItemNew.Tag -eq "Is_Update_Rule_Expand_To_All") {
												if ($NewTasks.Tasks.Expand.Rules.UpdateToAll) {
													$ItemNew.Checked = $True
													Image_Select_Disable_Expand_Item_Autopilot -Group $ItemNew.Parent.Parent.Parent.Name -Name $ItemNew.Tag -Open
												} else {
													$ItemNew.Checked = $False
													Image_Select_Disable_Expand_Item_Autopilot -Group $ItemNew.Parent.Parent.Parent.Name -Name $ItemNew.Tag -Close
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
		}
	}

	<#
		.导入：解决方案：生成
	#>
	if ($SelectEvent -contains "Solutions_Create_UI") {
		Write-Host "`n  $($lang.Import): $($lang.Solution): $($lang.IsCreate)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Autopilot_Solutions_Create_Import -Tasks $NewTasks.Tasks.Solutions -Mount
	}

	<#
		.导入：语言
	#>
		<#
			.添加
		#>
		if ($SelectEvent -contains "Language_Add_UI") {
			Write-Host "`n  $($lang.Import): $($lang.Language): $($lang.AddTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Language_Add_UI -Autopilot $NewTasks.Tasks.Language.Add
		}

		<#
			.删除
		#>
		if ($SelectEvent -contains "Language_Delete_UI") {
			Write-Host "`n  $($lang.Import): $($lang.Language): $($lang.Del)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Language_Delete_UI -Autopilot $NewTasks.Tasks.Language.Del
		}

		<#
			.更改
		#>
		if ($SelectEvent -contains "Language_Change_UI") {
			Write-Host "`n  $($lang.Import): $($lang.SwitchLanguage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Language_Change_UI -Autopilot $NewTasks.Tasks.Language.Change
		}

		<#
			.清理组件
		#>
		if ($SelectEvent -contains "Language_Cleanup_Components_UI") {
			Write-Host "`n  $($lang.Import): $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Language_Cleanup_Components_UI -Autopilot $NewTasks.Tasks.Language.Cleanup
		}

	<#
		.导入：InBox Apps
	#>
		<#
			.本地语言体验（LXPs）：标记
		#>
		if ($SelectEvent -contains "LXPs_Region_Add") {
			Write-Host "`n  $($lang.Import): $($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			LXPs_Region_Add -Autopilot $NewTasks.Tasks.InBoxApps.Mark
		}

		<#
			.InBox Apps：添加
		#>
		if ($SelectEvent -contains "InBox_Apps_Add_UI") {
			Write-Host "`n  $($lang.Import): $($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			InBox_Apps_Add_UI -Autopilot $NewTasks.Tasks.InBoxApps.Add
		}

		<#
			.本地语言体验（LXPs）：更新
		#>
		if ($SelectEvent -contains "LXPs_Update_UI") {
			Write-Host "`n  $($lang.Import): $($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			LXPs_Update_UI -Autopilot $NewTasks.Tasks.InBoxApps.Update
		}

		<#
			.本地语言体验（LXPs）：删除
		#>
		if ($SelectEvent -contains "LXPs_Remove_UI") {
			Write-Host "`n  $($lang.Import): $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			LXPs_Remove_UI -Autopilot $NewTasks.Tasks.InBoxApps.Remove
		}

		<#
			.匹配删除
		#>
		if ($SelectEvent -contains "InBox_Apps_Match_Delete_UI") {
			Write-Host "`n  $($lang.Import): $($lang.InboxAppsMatchDel)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			InBox_Apps_Match_Delete_UI -Autopilot $NewTasks.Tasks.InBoxApps.MatchRemove
		}

	<#
		.导入：累积更新
	#>
		<#
			.添加
		#>
		if ($SelectEvent -contains "Cumulative_updates_Add_UI") {
			Write-Host "`n  $($lang.Import): $($lang.Update): $($lang.AddTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Cumulative_updates_Add_UI_Import -Tasks $NewTasks.Tasks.CumulativeUpdate.Add
		}

		<#
			.删除
		#>
		if ($SelectEvent -contains "Cumulative_updates_Delete_UI") {
			Write-Host "`n  $($lang.Import): $($lang.Update): $($lang.Del)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Cumulative_updates_Delete_UI_Import -Tasks $NewTasks.Tasks.CumulativeUpdate.Del
		}

	<#
		.导入：驱动
	#>
		<#
			.添加
		#>
		if ($SelectEvent -contains "Drive_Add_UI") {
			Write-Host "`n  $($lang.Import): $($lang.Drive): $($lang.AddTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Drive_Add_UI_Import -Tasks $NewTasks.Tasks.Drive.Add
		}

		<#
			.删除
		#>
		if ($SelectEvent -contains "Drive_Delete_UI") {
			Write-Host "`n`n  $($lang.Import): $($lang.Drive): $($lang.Del)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Drive_Delete_UI_Import -Tasks $NewTasks.Tasks.Drive.Del
		}

	<#
		.导入：Windows 功能
	#>
		<#
			.启用
		#>
		if ($SelectEvent -contains "Feature_Enabled_Match_UI") {
			Write-Host "`n  $($lang.Import): $($lang.WindowsFeature): $($lang.Enable), $($lang.MatchMode)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Feature_Enabled_Match_UI_Import -Tasks $NewTasks.Tasks.WindowsFeatures.Enable
		}

		<#
			.禁用
		#>
		if ($SelectEvent -contains "Feature_Disable_Match_UI") {
			Write-Host "`n  $($lang.Import): $($lang.WindowsFeature): $($lang.Disable), $($lang.MatchMode)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Autopilot_Feature_Disable_Match_UI_Import -Tasks $NewTasks.Tasks.WindowsFeatures.Disable
		}

	<#
		.导入：PowerShell 函数
	#>
		<#
			.运行前
		#>
		if ($SelectEvent -contains "Functions_Before_UI") {
			Write-Host "`n  $($lang.Import): $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Functions_Before_UI -Autopilot $NewTasks.Tasks.PSFunctions.Before
		}

		<#
			.运行后
		#>
		if ($SelectEvent -contains "Functions_Rear_UI") {
			Write-Host "`n`n  $($lang.Import): $($lang.SpecialFunction): $($lang.Functions_Rear)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Functions_Rear_UI -Autopilot $NewTasks.Tasks.PSFunctions.After
		}

	<#
		.导入：API
	#>
		<#
			.运行前
		#>
		if ($SelectEvent -contains "API_Before_UI") {
			Write-Host "`n  $($lang.Import): $($lang.API): $($lang.Functions_Before)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			API_Before_UI -Autopilot $NewTasks.Tasks.API.Before
		}

		<#
			.运行后
		#>
		if ($SelectEvent -contains "API_Rear_UI") {
			Write-Host "`n`n  $($lang.Import): $($lang.API): $($lang.Functions_Rear)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			API_Rear_UI -Autopilot $NewTasks.Tasks.API.After
		}

	<#
		.导入：更多
	#>
	if ($SelectEvent -contains "Feature_More_UI") {
		Write-Host "`n`n  $($lang.Import): $($lang.MoreFeature)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Feature_More_UI -Autopilot $NewTasks.Tasks.More
	}
}