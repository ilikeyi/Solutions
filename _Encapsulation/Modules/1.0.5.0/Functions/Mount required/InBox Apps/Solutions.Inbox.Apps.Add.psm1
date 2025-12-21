<#
	.Combination: add InBox Apps
	.组合：添加 InBox Apps
#>
Function InBox_Apps_Add_UI
{
	param
	(
		[array]$Autopilot
	)

	<#
		.According to the system type, set the CD directory location
		.根据系统类型，设置光盘目录位置
	#>
	$NewInBoxAppsFolder = @(
		"packages"
	)
	switch ($Global:Architecture) {
		"arm64" { $NewInBoxAppsFolder += "arm64fre" }
		"AMD64" { $NewInBoxAppsFolder += "amd64fre" }
		"x86"   { $NewInBoxAppsFolder += "x86fre"   }
	}

	<#
		.Search InBox Apps
		.搜索 InBox Apps
	#>
	$SearchTypeInboxApps = @(
		Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\InBox_Apps"
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\InBox_Apps\Add"
	)
	$SearchTypeInboxApps = $SearchTypeInboxApps | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_InBox_Apps_Add_UI_Save
	{
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Dependency_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Dependency_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.Verification mark: check selection status
			.验证标记：检查选择状态
		#>
		if (InBox_Apps_Check_Customize -RuleNaming -SelectApps -AddSources) {
			if ($UI_Main_Dashboard_IsAllowSave.Checked) {
				if ($UI_Main_Dashboard_IsAllowSave.Tag -gt 0) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.InBoxAppsErrorTips -f $UI_Main_Dashboard_IsAllowSave.Tag), $($lang.History_View)"
					return
				}
			}

			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force

			if ($UI_Main_Mask_Dependencies_DoNot_Tips.Checked) {
			} else {
				$Temp_Assign_Task_Custom_Select_Dependency = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Dependency_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_Custom_Select_Dependency.Count -gt 0) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.RuleFindError -f $Temp_Assign_Task_Custom_Select_Dependency.count)"
					return
				}
			}

			<#
				.遇到错误时不允许保存
			#>
			if ($UI_Main_Dashboard_IsAllowSave.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_IsAllow_Error_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_IsAllow_Error_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			}

			<#
				.Automatically assign applications based on image version
				.自动根据映像版本分配应用程序
			#>
			if ($UI_Main_Assign_Editions.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			}

			<#
				.Automatically search for missing packages from all disks
				.自动从所有磁盘搜索缺少的软件包
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			if ($UI_Main_Add_Missing_Apps.Enabled) {
				if ($UI_Main_Add_Missing_Apps.Checked) {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				}
			}

			<#
				.安装 InBox Apps 应用时，允许自动组合依赖包
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			if ($UI_Main_Add_Dependency_Package.Enabled) {
				if ($UI_Main_Add_Dependency_Package.Checked) {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				}
			}

			<#
				.Optimize the provisioning of Appx packages by replacing the same files with hard links
				.优化预配 Appx 包，通过用硬链接替换相同的文件
			#>
			if ($UI_Main_Optimize_Hard_Link.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			}

			Refres_Event_Tasks_InBox_Apps_Add_UI

			$Temp_InBox_Appx_User_No_Select = @()
			$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
					} else {
						$Temp_InBox_Appx_User_No_Select += $_.Text
					}
				}
			}
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_InBox_Appx_User_No_Select -Force

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			return $true
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			return $false
		}
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	Function Insert_InBox_Apps_Add_UI_Add_Sources
	{
		param
		(
			$NewPath
		)
		
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		
		$TempSelectUWPAddFolderQueue = @()

		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$TempSelectUWPAddFolderQueue += $_.Text
			}
		}

		if ($TempSelectUWPAddFolderQueue -Contains $NewPath) {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = $lang.Existed
		} else {
			<#
				.计算公式：
					四舍五入为整数
						(初始化字符长度 * 初始化字符长度）
					/ 控件高度
			#>

			<#
				.初始化字符长度
			#>
			[int]$InitCharacterLength = 78

			<#
				.初始化控件高度
			#>
			[int]$InitControlHeight = 40

			$InitLength = $NewPath.Length
			if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
				Width     = 495
				Text      = $NewPath
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			if (Test-Path -Path $NewPath -PathType Container) {
				$CheckBox.checked = $True
			} else {
				$CheckBox.Enabled = $False
				$CheckBox.checked = $False
			}

			$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 40
				Width          = 495
				Padding        = "16,0,0,0"
				Text           = $lang.OpenFolder
				Tag            = $NewPath
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					if ([string]::IsNullOrEmpty($This.Tag)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					} else {
						if (Test-Path -Path $This.Tag -PathType Container) {
							Start-Process $This.Tag

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
						} else {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
						}
					}
				}
			}

			$CheckBox_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 40
				Width          = 495
				Padding        = "16,0,0,0"
				Text           = $lang.Paste
				Tag            = $NewPath
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					if ([string]::IsNullOrEmpty($This.Tag)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
					} else {
						Set-Clipboard -Value $This.Tag

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
					}
				}
			}

			$CheckBox_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height     = 15
				Width      = 480
			}

			$UI_Main_Select_Sources.controls.AddRange((
				$CheckBox,
				$CheckBox_Open_Folder,
				$CheckBox_Paste,
				$CheckBox_Wrap
			))
		}
	}

	Function Refres_Event_Tasks_InBox_Apps_Add_UI
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_IsAllow_Error_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		Refres_Event_Tasks_InBox_Apps_Add_UI

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	<#
		.事件：查看规则命名，详细内容
	#>
	Function InBox_Apps_Add_Rule_Details_View
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
			.从单条规则里获取
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
			$UI_Main_Mask_Rule_Detailed.Visible = $True
			$UI_Main_Mask_Rule_Detailed_Results.Text = ""

			$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.RuleAuthon)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "   $($InBox_Apps_Rule_Select_Single.Author)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleGUID)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.GUID)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleName)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.Name)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleDescription)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.Description)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleISO)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.ISO.Count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.ISO) {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.FileName): $($item.ISO)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $('.' * 80)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.Alternative): "

					if ($item.AlternativeFilenames.Count -gt 0) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"

						foreach ($ItemAlFile in $item.AlternativeFilenames) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($ItemAlFile)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
					} else {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
					}

					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.ISO_Other): $($item.FileList)`n"

					$UI_Main_Mask_Rule_Detailed_Results.Text += "     SHA-256: $($item.CRCSHA.SHA256)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     SHA-512: $($item.CRCSHA.SHA512)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $('.' * 80)`n`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
			}

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.InboxAppsManager)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "    $($lang.RuleISO)`n"
				if ($InBox_Apps_Rule_Select_Single.InboxApps.ISO.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.ISO) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.FileName): $($item.ISO)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $('.' * 80)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.Alternative): "

						if ($item.AlternativeFilenames.Count -gt 0) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"

							foreach ($ItemAlFile in $item.AlternativeFilenames) {
								$UI_Main_Mask_Rule_Detailed_Results.Text += "          $($ItemAlFile)`n"
							}

							$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
						} else {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.ISO_Other): $($item.FileList)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     SHA-256: $($item.CRCSHA.SHA256)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     SHA-512: $($item.CRCSHA.SHA512)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $('.' * 80)`n`n"
					}
				} else {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
				}

				$UI_Main_Mask_Rule_Detailed_Results.Text += "`n    $($lang.RuleCustomize): $($InBox_Apps_Rule_Select_Single.InboxApps.Edition.Count) $($lang.EventManagerCount)`n"
				$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
				if ($InBox_Apps_Rule_Select_Single.InboxApps.Edition.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Edition) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.Event_Group): $($item.Name.Count) $($lang.EventManagerCount)`n"
						ForEach ($itemNewName in $item.Name) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "               $($itemNewName)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n               $($lang.InboxAppsManager): $($lang.AddTo): $($item.Apps.Count) $($lang.EventManagerCount)`n"
						ForEach ($itemNewName in $item.Apps) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "                    $($itemNewName)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
					}
				} else {
					
				}

				$UI_Main_Mask_Rule_Detailed_Results.Text += "`n$($lang.RuleInBoxApps): $($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count) $($lang.EventManagerCount)`n"
				$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
				if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Rule){
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($item.Name)`n"
					}
				} else {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)"
			}
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
		}
	}

	Function InBox_Apps_Refresh_Rule
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Match_Select_Apps.controls.clear()

		$SelectUWPExclude = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

		$MarkCheckedSelectRuleName = $False
		$UI_Main_Extract_Rule_Select_Sourcest.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$MarkCheckedSelectRuleName = $True
					$Script:InBoxAppsSearchRuleSelected = $_.Tag
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_SelectGUID" -value $_.Tag -String
				}
			}
		}

		if ($MarkCheckedSelectRuleName) {
			<#
				.从预规则里获取
			#>
			ForEach ($itemPre in $Global:Pre_Config_Rules) {
				ForEach ($item in $itemPre.Version) {
					if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
						$InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}

			<#
				.从单条规则里获取
			#>
			ForEach ($item in $Global:Preconfigured_Rule_Language) {
				if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
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
						if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
							$InBox_Apps_Rule_Select_Single = $item
							break
						}
					}
				}
			}

			if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Rule){
					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 35
						Width     = 495
						Text      = $item.Name
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null
						}
					}

					if ($SelectUWPExclude -Contains $item.Name) {
						$CheckBox.Checked = $False
					} else {
						$CheckBox.Checked = $True
					}

					$UI_Main_Match_Select_Apps.controls.AddRange($CheckBox)
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660)"
			}
		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 490
				Text           = $lang.NoWork
			}

			$UI_Main_Match_Select_Apps.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		}
	}

	Function InBox_Apps_Refresh_Sources
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Dashboard_IsAllowSave.Tag = "0"
		$UI_Main_Dashboard_IsAllowSave_Status.Text = $lang.InBoxAppsErrorNo
		$UI_Main_Mask_Error_Results.Text = $lang.InBoxAppsErrorNo

		$UI_Main_Select_Sources.controls.Clear()

		<#
			.计算公式：
				四舍五入为整数
					(初始化字符长度 * 初始化字符长度）
				/ 控件高度
		#>

		<#
			.初始化字符长度
		#>
		[int]$InitCharacterLength = 78

		<#
			.初始化控件高度
		#>
		[int]$InitControlHeight = 40

		$initlSearchTypeInboxApps = @()
		ForEach ($item in $SearchTypeInboxApps) {
			$initlSearchTypeInboxApps += $item
		}

		Get-CimInstance -Class Win32_LogicalDisk -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | ForEach-Object {
			ForEach ($item in $NewInBoxAppsFolder) {
				$SearchTempFolder = Join-Path -Path $_.DeviceID -ChildPath $item

				if (Test-Path -Path $SearchTempFolder -PathType Container) {
					$initlSearchTypeInboxApps += $SearchTempFolder
				}
			}
		}

		$Temp_Queue_Is_InBox_Apps_Add_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Queue_Is_InBox_Apps_Add_Select = $Temp_Queue_Is_InBox_Apps_Add_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		ForEach ($item in $initlSearchTypeInboxApps) {
			$InitLength = $item.Length
			if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
				Width     = 495
				Text      = $item
				Tag       = $item
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			if (Test-Path -Path $item -PathType Container) {
				if ($Temp_Queue_Is_InBox_Apps_Add_Select -contains $item) {
					$CheckBox.Enabled = $true
					$CheckBox.Checked = $True
				} else {
					$CheckBox.Checked = $True
				}
			} else {
				$CheckBox.Enabled = $False
				$CheckBox.Checked = $False
			}

			$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 40
				Width          = 455
				Padding        = "16,0,0,0"
				Text           = $lang.OpenFolder
				Tag            = $item
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					if ([string]::IsNullOrEmpty($This.Tag)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					} else {
						if (Test-Path -Path $This.Tag -PathType Container) {
							Start-Process $This.Tag

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
						} else {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						}
					}
				}
			}

			$CheckBox_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 40
				Width          = 455
				Padding        = "16,0,0,0"
				Text           = $lang.Paste
				Tag            = $item
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					if ([string]::IsNullOrEmpty($This.Tag)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
					} else {
						Set-Clipboard -Value $This.Tag

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
					}
				}
			}

			$CheckBox_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height     = 15
				Width      = 480
			}

			$UI_Main_Select_Sources.controls.AddRange((
				$CheckBox,
				$CheckBox_Open_Folder,
				$CheckBox_Paste,
				$CheckBox_Wrap
			))
		}
	}

	$UI_Main_DragOver = [System.Windows.Forms.DragEventHandler]{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
	
		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			$_.Effect = 'Copy'
		} else {
			$_.Effect = 'None'
		}
	}
	$UI_Main_DragDrop = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
				if (Test-Path -Path $filename -PathType Container) {
					Insert_InBox_Apps_Add_UI_Add_Sources -NewPath $filename
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SelectFolder)"
				}
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.InboxAppsManager): $($lang.AddTo)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
		AllowDrop      = $true
		Add_DragOver   = $UI_Main_DragOver
		Add_DragDrop   = $UI_Main_DragDrop
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

	<#
		.Mask: Error
		.蒙板：错误
	#>
	$UI_Main_Mask_Error = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Error_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $lang.InBoxAppsErrorNo
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Mask_Error_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Mask_Error.Visible = $False
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
	$UI_Main_Mask_Rule_Detailed_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
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
		.显示先决部署蒙层
	#>
	$UI_Main_Mask_Dependencies = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1025
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Dependencies_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 550
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Mask_Dependencies_Fix_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 560
		Text           = $lang.RuleDependenciesFix
		Location       = "20,600"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Temp_Assign_Task_Custom_Select_Dependency = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Dependency_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
			if ($Temp_Assign_Task_Custom_Select_Dependency.Count -gt 0) {
				ForEach ($item in $Temp_Assign_Task_Custom_Select_Dependency) {
					$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($_.Text -eq $item) {
								$_.Checked = $true
							}
						}
					}
				}
			}

			if (InBox_Apps_Check_Customize -RuleNaming -SelectApps) {
				$UI_Main_Mask_Dependencies.Visible = $True
			}
		}
	}

	$UI_Main_Mask_Dependencies_DoNot_Tips = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 30
		Width          = 440
		Text           = $lang.RuleDependenciesNoCheck
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Mask_Dependencies_DoNot_Tips.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_IsCheckDependencies" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_IsCheckDependencies" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_IsCheckDependencies" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_IsCheckDependencies" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Mask_Dependencies_DoNot_Tips.Checked = $True
			}
			"False" {
				$UI_Main_Mask_Dependencies_DoNot_Tips.Checked = $False
			}
		}
	}

	$UI_Main_Mask_Dependencies_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Mask_Dependencies.Visible = $False
		}
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	<#
		.遇到错误时不允许保存
	#>
	$UI_Main_Dashboard_IsAllowSave = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.InBoxAppsErrorNoSave
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_IsAllow_Error_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Dashboard_IsAllowSave.Checked = $True
	} else {
		$UI_Main_Dashboard_IsAllowSave.Checked = $False
	}

	$UI_Main_Dashboard_IsAllowSave_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "32,0,0,0"
		Text           = $lang.InBoxAppsErrorNo
	}
	$UI_Main_Dashboard_IsAllowSave_History = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.History_View
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Error.Visible = $True
		}
	}

	<#
		.其它
	#>
	$UI_Main_Adv       = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.自动根据映像版本分配应用程序
	#>
	$UI_Main_Assign_Editions = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Assign_Editions
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Assign_Editions.Checked = $True
	} else {
		$UI_Main_Assign_Editions.Checked = $False
	}

	<#
		.自动按架构补足其它 Apps
	#>
	$UI_Main_Add_Missing_Apps = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.UWPAutoMissingPacker
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Add_Missing_Apps_Tips = New-Object System.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "37,0,0,0"
		Margin         = "0,0,0,15"
	}

	<#
		.初始化复选框：自动按架构补足其它 Apps
	#>
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Add_Missing_Apps.Checked = $True
	} else {
		$UI_Main_Add_Missing_Apps.Checked = $False
	}

	<#
		.安装 InBox Apps 应用时，允许自动组合依赖包
	#>
	$UI_Main_Add_Dependency_Package = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Instl_Dependency_Package
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Add_Dependency_Package_Tips = New-Object System.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.Instl_Dependency_Package_Tips
		Padding        = "37,0,0,0"
		Margin         = "0,0,0,15"
	}

	<#
		.初始化复选框：安装 InBox Apps 应用时，允许自动组合依赖包
	#>
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Add_Dependency_Package.Checked = $True
	} else {
		$UI_Main_Add_Dependency_Package.Checked = $False
	}

	<#
		.硬链接
	#>
	$UI_Main_Optimize_Hard_Link = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Optimize_Appx_Package
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.初始化复选框：硬链接
	#>
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Optimize_Hard_Link.Checked = $True
	} else {
		$UI_Main_Optimize_Hard_Link.Checked = $False
	}

	<#
		.选择来源
	#>
	$UI_Main_Select_Sources_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 520
		margin         = "0,30,0,0"
		Text           = $lang.AddSources
	}
	$UI_Main_Setting_ISO = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 520
		Padding        = "16,0,0,0"
		Text           = "$($lang.Setting): $($lang.ISO_File)"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Image_Select -Page "ISO"
			InBox_Apps_Refresh_Sources
		}
	}
	$UI_Main_Select_Sources = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 530
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,8,0"
		margin         = "0,0,0,30"
	}

	<#
		.选择规则
	#>
	$UI_Main_Extract_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,30,0,0"
		Text           = $lang.LanguageExtractRuleFilter
	}
	$UI_Main_Extract_Rule_Select_Sourcest = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $true
		Padding        = "16,0,0,0"
	}

	<#
		.匹配的 InBox Apps 应用程序
	#>
	$UI_Main_Match_Select_Apps_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,40,0,0"
		Text           = $lang.InBox_Apps_Match
	}
	$UI_Main_Match_Select_Apps = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autosize       = 1
		autoScroll     = $false
		Padding        = "16,0,8,0"
	}
	$UI_Main_Menu_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
	}

	$UI_Main_Refresh_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.Refresh
		add_Click      = {
			InBox_Apps_Refresh_Sources
			
			$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}
	$UI_Main_Select_Folder = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.SelectFolder
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$TempSelectUWPAddFolderQueue = @()

			$UI_Main_Select_Sources.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$TempSelectUWPAddFolderQueue += $_.Text
				}
			}

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				Insert_InBox_Apps_Add_UI_Add_Sources -NewPath $FolderBrowser.SelectedPath
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}
	$UI_Main_Select_Folder_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 45
		Width          = 260
		Location       = "628,95"
		Text           = $lang.DropFolder
	}

	$UI_Main_Match_Apps = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,150"
		Height         = 36
		Width          = 280
		Text           = $lang.MatchMode
		add_Click      = {
			if (InBox_Apps_Check_Customize -RuleNaming -SelectApps -AddSources) {
				$custom_array = @()

				$Temp_Assign_Task_InBox_Apps = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_List_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_InBox_Apps.Count -gt 0) {
					ForEach ($item in $Temp_Assign_Task_InBox_Apps){
						$custom_array += [PSCustomObject]@{
							Name            = $item.Name
							Search          = $item.Search
							InstallPacker   = $item.InstallPacker
							Certificate     = $item.Certificate
							CertificateRule = $item.CertificateRule
							Depend          = $item.Dependencies
							Region          = $item.Region
						}
					}

					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report\InBox.Apps"

					Check_Folder -chkpath $test_mount_folder_Current
					$TempSaveTo = "$($test_mount_folder_Current)\Index.$(Image_Get_Mount_Index).$(Get-Date -Format "yyyyMMddHHmmss").csv"

					$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.GetInBoxApps)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "  User Cancel" -ForegroundColor Red
	} else {
		ForEach (`$item in `$multiple_output) {
			`$custom_array_Export += [PSCustomObject]@{
				Name            = `$item.Name
				Search          = `$item.Search
				InstallPacker   = `$item.InstallPacker
				Certificate     = `$item.Certificate
				CertificateRule = `$item.CertificateRule
				Depend          = `$item.Depend
			}
		}

		Add-Type -AssemblyName System.Windows.Forms

		`$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
			Filter    = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
			FileName  = "Export.InBox.Apps.`$(Get-Date -Format "yyyyMMddHHmmss")"
		}

		if (`$FileBrowser.ShowDialog() -eq "OK") {
			Write-Host "`n  Save To:"
			Write-Host "  `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "  User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

					powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
				}

				Remove-Item -path "$($TempSaveTo).ps1" -Force -ErrorAction SilentlyContinue
			} else {
				
			}
		}
	}
	$UI_Main_Dependencies = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,190"
		Height         = 36
		Width          = 280
		Text           = $lang.InBox_Apps_Check
		add_Click      = {
			if (InBox_Apps_Check_Customize -RuleNaming -SelectApps) {
				$UI_Main_Mask_Dependencies.Visible = $True
			}
		}
	}
	$UI_Main_Dependencies_Tips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "620,240"
		Height         = 140
		Width          = 280
		Padding        = "8,0,8,0"
		Text           = $lang.InBox_Apps_Check_Tips
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
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '620,425'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "13" -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '620,455'
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
		Location       = '620,390'
		add_Click      = {
			if ($this.Checked) {
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
		Location       = '636,426'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '636,455'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
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

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,555"
		Height         = 36
		Width          = 280
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_InBox_Apps_Add_UI_Save) {

			}
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

				Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				$Temp_Queue_Is_InBox_Apps_Add_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Queue_Is_InBox_Apps_Add_Select.Count -gt 0) {
					ForEach ($item in $Temp_Queue_Is_InBox_Apps_Add_Select) {
						Write-Host "  $($item)"
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}

	$UI_Main.controls.AddRange((
		$UI_Main_Mask_Error,
		$UI_Main_Mask_Rule_Detailed,
		$UI_Main_Mask_Dependencies,
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Match_Apps,
		$UI_Main_Dependencies,
		$UI_Main_Dependencies_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Mask_Dependencies.controls.AddRange((
		$UI_Main_Mask_Dependencies_Results,
		$UI_Main_Mask_Dependencies_Fix_Select,
		$UI_Main_Mask_Dependencies_DoNot_Tips,
		$UI_Main_Mask_Dependencies_Canel
	))
	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_Mask_Rule_Detailed_Canel
	))
	$UI_Main_Mask_Error.controls.AddRange((
		$UI_Main_Mask_Error_Results,
		$UI_Main_Mask_Error_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Dashboard_IsAllowSave,
		$UI_Main_Dashboard_IsAllowSave_Status,
		$UI_Main_Dashboard_IsAllowSave_History,
		$UI_Main_Adv,
		$UI_Main_Assign_Editions,
		$UI_Main_Add_Missing_Apps,
		$UI_Main_Add_Missing_Apps_Tips,
		$UI_Main_Add_Dependency_Package,
		$UI_Main_Add_Dependency_Package_Tips,
		$UI_Main_Optimize_Hard_Link,

		<#
			.选择添加来源
		#>
		$UI_Main_Select_Sources_Name,
		$UI_Main_Setting_ISO,
		$UI_Main_Select_Sources,

		<#
			.选择规则
		#>
		$UI_Main_Extract_Rule_Name,
		$UI_Main_Extract_Rule_Select_Sourcest,

		<#
			.选择应用程序
		#>
		$UI_Main_Match_Select_Apps_Name,
		$UI_Main_Match_Select_Apps,
		$UI_Main_Menu_Wrap
	))

	<#
		.选择全局唯一规则 GUID
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_SelectGUID" -ErrorAction SilentlyContinue) {
		$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_SelectGUID" -ErrorAction SilentlyContinue
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue) {
			$GetDefaultSelectLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue
		} else {
			$GetDefaultSelectLabel = ""
		}
	}

	<#
		.添加规则：预置规则
	#>
	$UI_Main_Extract_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Text           = $lang.RulePre
	}
	$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Pre_Rule)
	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		$UI_Main_Extract_Group = New-Object system.Windows.Forms.Label -Property @{
			Height    = 30
			Width     = 510
			Padding   = "18,0,0,0"
			Text      = $itemPre.Group
		}
		$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Group)

		ForEach ($item in $itemPre.Version) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 30
				Width     = 510
				Padding   = "36,0,0,0"
				Text      = $item.Name
				Tag       = $item.GUID
				add_Click = { InBox_Apps_Refresh_Rule }
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 512
				Padding        = "54,0,0,0"
				Margin         = "0,0,0,5"
				Text           = $lang.Detailed_View
				Tag            = $item.GUID
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					InBox_Apps_Add_Rule_Details_View -GUID $this.Tag
				}
			}

			$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange((
				$CheckBox,
				$UI_Main_Rule_Details_View
			))

			if ($item.InboxApps.Rule.Count -gt 0) {
				if ($GetDefaultSelectLabel -eq $item.GUID) {
					$CheckBox.Checked = $True
				}
			} else {
				$CheckBox.Enabled = $False
			}
		}

		$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 20
			Width          = 510
		}
		$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Group_Wrap)
	}

	<#
		.添加规则：从单条规则里获取
	#>
	$UI_Main_Extract_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Text           = $lang.RuleOther
	}
	$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Other_Rule)
	ForEach ($item in $Global:Preconfigured_Rule_Language) {
		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = 30
			Width     = 510
			Padding   = "18,0,0,0"
			Text      = $item.Name
			Tag       = $item.GUID
			add_Click = { InBox_Apps_Refresh_Rule }
		}

		$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 512
			Padding        = "36,0,0,0"
			Margin         = "0,0,0,5"
			Text           = $lang.Detailed_View
			Tag            = $item.GUID
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				InBox_Apps_Add_Rule_Details_View -GUID $this.Tag
			}
		}

		$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange((
			$CheckBox,
			$UI_Main_Rule_Details_View
		))

		if ($item.InboxApps.Rule.Count -gt 0) {
			if ($GetDefaultSelectLabel -eq $item.GUID) {
				$CheckBox.Checked = $True
			}
		} else {
			$CheckBox.Enabled = $False
		}
	}

	<#
		.添加规则，自定义
	#>
	$UI_Main_Extract_Customize_Rule = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Margin         = "0,35,0,0"
		Text           = $lang.RuleCustomize
	}
	$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Customize_Rule)
	if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
		if ($Global:Custom_Rule.count -gt 0) {
			ForEach ($item in $Global:Custom_Rule) {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 30
					Width     = 460
					Padding   = "18,0,0,0"
					Text      = $item.Name
					Tag       = $item.GUID
					add_Click = { InBox_Apps_Refresh_Rule }
				}

				$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 30
					Width          = 460
					Padding        = "36,0,0,0"
					Margin         = "0,0,0,5"
					Text           = $lang.Detailed_View
					Tag            = $item.GUID
					LinkColor      = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						InBox_Apps_Add_Rule_Details_View -GUID $this.Tag
					}
				}

				$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange((
					$CheckBox,
					$UI_Main_Rule_Details_View
				))

				if ($item.InboxApps.Rule.Count -gt 0) {
					if ($GetDefaultSelectLabel -eq $item.GUID) {
						$CheckBox.Checked = $True
					}
				} else {
					$CheckBox.Enabled = $False
				}
			}
		} else {
			$UI_Main_Extract_Customize_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
				AutoSize       = 1
				Padding        = "18,0,0,0"
				Text           = $lang.RuleCustomizeTips
			}
			$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips)
		}
	} else {
		$UI_Main_Extract_Customize_Rule_Tips_Not = New-Object system.Windows.Forms.Label -Property @{
			AutoSize       = 1
			Padding        = "18,0,0,0"
			Text           = $lang.RuleCustomizeNot
		}
		$UI_Main_Extract_Rule_Select_Sourcest.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips_Not)
	}

	InBox_Apps_Refresh_Rule
	InBox_Apps_Refresh_Sources
	Refres_Event_Tasks_InBox_Apps_Add_UI

	switch ($Global:Architecture) {
		"arm64" {
			$UI_Main_Add_Missing_Apps.Enabled = $False
			$UI_Main_Add_Missing_Apps_Tips.Text = "$($lang.UWPAutoMissingPackerNotSupport)"
		}
		"AMD64" {
			$UI_Main_Add_Missing_Apps_Tips.Text = "$($lang.UWPAutoMissingPackerSupport)"
		}
		"x86" {
			$UI_Main_Add_Missing_Apps.Enabled = $False
			$UI_Main_Add_Missing_Apps_Tips.Text = "$($lang.UWPAutoMissingPackerNotSupport)"
		}
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_InBox_Apps_Group_Add_Menu = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_InBox_Apps_Group_Add_Menu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_InBox_Apps_Group_Add_Menu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Match_Select_Apps.ContextMenuStrip = $UI_InBox_Apps_Group_Add_Menu

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_Sources.ContextMenuStrip = $UI_Main_Menu_Select

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

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

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		switch ($Autopilot.Schome) {
			"Custom" {
				<#
					.Automatically assign applications based on image version
					.自动根据映像版本分配应用程序
				#>
				if ($Autopilot.Custom.IsAllowError) {
					$UI_Main_Dashboard_IsAllowSave.Checked = $False
				} else {
					$UI_Main_Dashboard_IsAllowSave.Checked = $True
				}

				<#
					.Automatically search for missing packages from all disks
					.自动从所有磁盘搜索缺少的软件包
				#>
				if ($Autopilot.Custom.AutoSearch) {
					$UI_Main_Add_Missing_Apps.Checked = $True
				} else {
					$UI_Main_Add_Missing_Apps.Checked = $False
				}

				<#
					.安装 InBox Apps 应用时，允许自动组合依赖包
				#>
				if ($Autopilot.Custom.DependencyPackage) {
					$UI_Main_Add_Dependency_Package.Checked = $True
				} else {
					$UI_Main_Add_Dependency_Package.Checked = $False
				}

				<#
					.Optimize the provisioning of Appx packages by replacing the same files with hard links
					.优化预配 Appx 包，通过用硬链接替换相同的文件
				#>
				if ($Autopilot.Custom.OptimizeHardLink) {
					$UI_Main_Optimize_Hard_Link.Checked = $True
				} else {
					$UI_Main_Optimize_Hard_Link.Checked = $False
				}

				if (-not ([string]::IsNullOrEmpty($Autopilot.Custom.Guid))) {
					$UI_Main_Extract_Rule_Select_Sourcest.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($Autopilot.Custom.Guid -eq $_.Tag) {
								$_.Checked = $True
							}
						}
					}

					InBox_Apps_Refresh_Rule
				}

				if ($Autopilot.Custom.Apps -eq "auto") {
					$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							$_.Checked = $true
						}
					}
				} else {
					$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($Autopilot.Custom.Apps -contains $_.Text) {
								$_.Checked = $true
							} else {
								$_.Checked = $false
							}
						}
					}
				}

				if ($Autopilot.Custom.Source -eq "auto") {

				} else {
					foreach ($item in $Autopilot.Custom.Source) {
						Insert_InBox_Apps_Add_UI_Add_Sources -NewPath $item
					}
				}
			}
		}

		if (Autopilot_InBox_Apps_Add_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$Temp_Queue_Is_InBox_Apps_Add_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Queue_Is_InBox_Apps_Add_Select.count -gt 0) {
			foreach ($item in $Temp_Queue_Is_InBox_Apps_Add_Select) {
				Insert_InBox_Apps_Add_UI_Add_Sources -NewPath $item
			}

			$UI_Main_Select_Sources.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Temp_Queue_Is_InBox_Apps_Add_Select -contains $_.Text) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}
		}

		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.Get Inbox Apps task
	.获取 Inbox Apps 任务
#>
Function InBox_Apps_Add_Process
{
	$Temp_Queue_Is_InBox_Apps_Add_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Queue_Is_InBox_Apps_Add_Select.count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Queue_Is_InBox_Apps_Add_Select) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Queue_Is_InBox_Apps_Add_Select) {
			Write-Host "  $($item)"
			InBox_Apps_Add_To_Process -InboxAppsSources $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.Start adding Inbox Apps
	.开始添加 Inbox Apps
#>
Function InBox_Apps_Add_To_Process
{
	param
	(
		$InboxAppsSources
	)

	<#
		初始化变量
	#>
	$GroupExcludePreInstall = @()
	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	<#
		.匹配到版本后，允许使用“自动从所有磁盘搜索缺少的软件包”功能
	#>
	$IsAllowSearchApps = $False

	<#
		.获取当前离线版本：识别码
	#>
	Write-Host "`n  $($lang.Assign_Editions)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		try {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsEdition -Path ""$($test_mount_folder_Current)"").Edition" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "  $($lang.UpdateCurrent)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			$Current_Edition_Version = (Get-WindowsEdition -Path $test_mount_folder_Current).Edition
			Write-Host "  $($Current_Edition_Version)" -ForegroundColor Green
		} catch {
			Write-Host "  $($lang.UpdateCurrent)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		<#
			.匹配版本识别码，并分配任务
		#>
		Write-Host "`n  $($lang.LXPsWaitAssign)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$Temp_Assign_Task_Select_Rule = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Assign_Task_Select_Rule.Count -gt 0) {
			ForEach ($item in $Temp_Assign_Task_Select_Rule) {
				if ($item.Name -eq $Current_Edition_Version) {
					Write-Host "  $($Current_Edition_Version)" -ForegroundColor Green

					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $item.Apps -Force
					Write-Host "  $($lang.Done)" -ForegroundColor Green

					$IsAllowSearchApps = $True
					break
				}
			}
		} else {
			Write-Host "  $($lang.Failed)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.AfterFinishingNoProcess)" -ForegroundColor Green

		$Temp_Assign_Task_Select_Custom_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Assign_Task_Select_Custom_Select.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Assign_Task_Select_Custom_Select -Force
			Write-Host "  $($lang.Done)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.Failed)" -ForegroundColor Red
		}
	}

	Write-Host "`n  $($lang.LXPsWaitAdd)"
	Write-Host "  $('-' * 80)"
	$Temp_Assign_Task_Select_Group = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Assign_Task_Select_Group.Count -gt 0) {
		ForEach ($item in $Temp_Assign_Task_Select_Group) {
			Write-Host "  $($item)" -ForegroundColor Green
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.开始添加 Appx
	#>
	Write-Host "`n  $($lang.InboxAppsManager)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	$Temp_Assign_Task_InBox_Apps = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_List_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	[int]$SNTasks = "0"

	if ($Temp_Assign_Task_InBox_Apps.Count -gt 0) {
		ForEach ($item in $Temp_Assign_Task_InBox_Apps) {
			$SNTasks++

			InBox_Apps_Add_Match_Process -Name $item.Name -SearchName $item.Search -AppxSource $item.InstallPacker -CertificateSource $item.Certificate -Region $item.Region -DependencyPackage $item.Depend -SNTasks $SNTasks
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.自动从所有磁盘搜索缺少的软件包
	#>
	Write-Host "`n  $($lang.UWPAutoMissingPacker)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($IsAllowSearchApps) {
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			<#
				.Windows 10 x64 删除所有 InBox Apps 预安装后，重新安装需要从 x86fre 里添加的依赖项
			#>
			if ($Global:Architecture -eq "amd64") {
				$SearchInBoxExtract = @(
					"x86fre\Microsoft.Services.Store.Engagement.x86.appx"
				)

				ForEach ($item in $SearchInBoxExtract) {
					Get-CimInstance -Class Win32_LogicalDisk -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | ForEach-Object {
						$SearchTempFile = Join-Path -Path $_.DeviceID -ChildPath $item

						if (Test-Path -Path $SearchTempFile -PathType Leaf) {
							Write-Host "  $($lang.NoLicense), $($SearchTempFile)"

							try {
								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Add-AppxProvisionedPackage -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($SearchTempFile)"" -Region ""$($Region)"" -SkipLicense" -ForegroundColor Green
									Write-Host "  $('-' * 80)`n"
								}

								Add-AppxProvisionedPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Add-AppxProvisionedPackage.log" -Path $test_mount_folder_Current -PackagePath $SearchTempFile -SkipLicense -ErrorAction SilentlyContinue | Out-Null
								Write-Host "  $($lang.Done)" -ForegroundColor Green
							} catch {
								Write-Host "  $($_)" -ForegroundColor Red
								Write-Host "  $($lang.AddTo), $($lang.Failed)" -ForegroundColor Red
							}

							Write-Host
						}
					}
				}
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
	}
}

Function InBox_Apps_Add_Match_Process
{
	param
	(
		$Name,
		$Search,
		$AppxSource,
		$CertificateSource,
		$Region,
		$DependencyPackage,
		$SNTasks
	)

	$IsWaitInstallDependencyPackage = @()
	$CommandIsWaitInstallDependencyPackage = ""

	<#
		.初始化每任务运行时间
	#>
	$InBoxAppsTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
	$InBoxAppsTasksTime = New-Object System.Diagnostics.Stopwatch
	$InBoxAppsTasksTime.Reset()
	$InBoxAppsTasksTime.Start()

	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host "$($InBoxAppsTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
	Write-Host $SNTasks -NoNewline -ForegroundColor Green
	Write-host " $($lang.EventManagerCount)"

	Write-Host "  $($lang.RuleFileType): ".PadRight(25) -NoNewline -ForegroundColor Yellow
	Write-Host $Name -ForegroundColor Green

	$Temp_Assign_Task_Select_Group = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Assign_Task_Select_Group -contains $Name) {
		if (Test-Path -Path $AppxSource -PathType Leaf) {
			Write-Host "  $($lang.LanguageRegionLink): ".PadRight(25) -NoNewline -ForegroundColor Yellow
			if ([string]::IsNullOrEmpty($Region)) {
				Write-Host $lang.UpdateUnavailable -ForegroundColor Red
			} else {
				Write-Host $Region -ForegroundColor Green
			}

			if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
				Write-Host "  $($lang.DependencyPackage): ".PadRight(25) -NoNewline -ForegroundColor Yellow

				if ($DependencyPackage.count -gt 0) {
					Write-Host "$($DependencyPackage.count) $($lang.EventManagerCount)" -ForegroundColor Green
					Write-Host "  $('.' * 80)"
					foreach ($itemdp in $DependencyPackage) {
						Write-Host "  $($itemdp)"
					}

					Write-Host "`n  $($lang.Instl_Dependency_Package_Match)" -ForegroundColor Yellow
					Write-Host "  $('.' * 80)"
					foreach ($itemdp in $DependencyPackage) {
						Write-Host "  $($lang.RuleFileType): ".PadRight(25) -NoNewline -ForegroundColor Yellow
						Write-Host $itemdp -ForegroundColor Yellow
						Write-Host "  $($lang.Instl_Dependency_Package_Group): ".PadRight(25) -NoNewline -ForegroundColor Yellow

						$FlagMatch = $True

						if ($FlagMatch) {
							$Temp_Assign_Task_InBox_Apps = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_List_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
							ForEach ($item in $Temp_Assign_Task_InBox_Apps) {
								if ($item.name -eq $itemdp) {
									Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

									Write-Host "  $($lang.FileName): ".PadRight(25) -NoNewline -ForegroundColor Yellow
									Write-Host $item.InstallPacker -ForegroundColor Green

									Write-Host "  $($lang.ConvertChk): ".PadRight(25) -NoNewline -ForegroundColor Yellow
									if (Test-Path -Path $item.InstallPacker -PathType Leaf) {
										$IsWaitInstallDependencyPackage += $item.InstallPacker
										$FlagMatch = $False

										Write-Host " $($lang.UpdateAvailable) " -BackgroundColor DarkGreen -ForegroundColor White
									} else {
										Write-Host " $($lang.NoInstallImage) " -BackgroundColor DarkRed -ForegroundColor White
									}

									Write-Host
									break
								}
							}

						}

						if ($FlagMatch) {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
							Write-Host
						}
					}

					Write-Host "  $($lang.Instl_Dependency_Package_Match): " -NoNewline
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host "  $('.' * 80)"
				} else {
					Write-Host $lang.NoWork -ForegroundColor Red
				}

				<#
					.重新组合并生成命令行：依赖项
				#>
				if ($IsWaitInstallDependencyPackage.Count -gt 0) {
					$TempAddMh = @()

					foreach ($itemid in $IsWaitInstallDependencyPackage) {
						$TempAddMh += """$($itemid)"""
					}

					$result = [string]::Join(",", $TempAddMh)
					$CommandIsWaitInstallDependencyPackage = "-DependencyPackagePath $($result)"
				}
			} else {
				if ($DependencyPackage.count -gt 0) {
					Write-Host "  $($lang.DependencyPackage): ".PadRight(25) -NoNewline -ForegroundColor Yellow
					Write-Host $lang.UpdateNotExecuted -ForegroundColor Red
					Write-Host "  $('.' * 80)"
					foreach ($itemdp in $DependencyPackage) {
						Write-Host "  $($itemdp)"
					}

					Write-Host
				} else {
					Write-Host "  $($lang.DependencyPackage): ".PadRight(25) -NoNewline -ForegroundColor Yellow
					Write-Host $lang.NoWork -ForegroundColor Red
				}
			}

			<#
				.重新组合并生成命令行：区域
			#>
			$CommandIsWaitInstallRegions = ""
			if ([string]::IsNullOrEmpty($Region)) {
				$CommandIsWaitInstallRegions = ""
			} else {
				$CommandIsWaitInstallRegions = "-Regions ""$($Region)"""
			}

			Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.FileName): ".PadRight(25) -NoNewline -ForegroundColor Yellow
			Write-Host $AppxSource -ForegroundColor Green
			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

			if ([string]::IsNullOrEmpty($CertificateSource)) {
				Write-Host "  $($lang.License): ".PadRight(25) -NoNewline -ForegroundColor Yellow
				Write-Host $lang.NoLicense -ForegroundColor Red

				$CommandNew = @()
				$CommandNewPrint = @()

				# Add-AppxProvisionedPackage
				$CommandNew += "Add-AppxProvisionedPackage"
				$CommandNewPrint += "Add-AppxProvisionedPackage"

				# -ScratchDirectory
				$CommandNew += "-ScratchDirectory ""$(Get_Mount_To_Temp)"""

				# -LogPath
				$CommandNew += "-LogPath ""$(Get_Mount_To_Logs)\Add-AppxProvisionedPackage.log"""

				# -Path
				$CommandNew += "-Path ""$($test_mount_folder_Current)"""
				$CommandNewPrint += "-Path ""$($test_mount_folder_Current)"""

				# -PackagePath
				$CommandNew += "-PackagePath ""$($AppxSource)"""
				$CommandNewPrint += "-PackagePath ""$($AppxSource)"""

				# -DependencyPackagePath
				if ([string]::IsNullOrEmpty($CommandIsWaitInstallDependencyPackage)) {
				} else {
					$CommandNew += $CommandIsWaitInstallDependencyPackage
					$CommandNewPrint += $CommandIsWaitInstallDependencyPackage
				}

				# -Regions
				if ([string]::IsNullOrEmpty($CommandIsWaitInstallRegions)) {
				} else {
					$CommandNew += $CommandIsWaitInstallRegions
					$CommandNewPrint += $CommandIsWaitInstallRegions
				}

				# -SkipLicense
				$CommandNew += "-SkipLicense"
				$CommandNewPrint += "-SkipLicense"

				$CommandNew += "-ErrorAction SilentlyContinue | Out-Null"

				[string]$CommandNew = $CommandNew
				[string]$CommandNewPrint = $CommandNewPrint

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  $($CommandNewPrint)`n" -ForegroundColor Green
				}

				Write-Host "  " -NoNewline
				Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
				try {
					Invoke-Expression -Command $CommandNew
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					Write-Host "  $($_)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.License): ".PadRight(25) -NoNewline -ForegroundColor Yellow
				if (Test-Path -Path $CertificateSource -PathType Leaf) {
					Write-Host $CertificateSource -ForegroundColor Green

					$CommandNew = @()
					$CommandNewPrint = @()

					# Add-AppxProvisionedPackage
					$CommandNew += "Add-AppxProvisionedPackage"
					$CommandNewPrint += "Add-AppxProvisionedPackage"

					# -ScratchDirectory
					$CommandNew += "-ScratchDirectory ""$(Get_Mount_To_Temp)"""

					# -LogPath
					$CommandNew += "-LogPath ""$(Get_Mount_To_Logs)\Add-AppxProvisionedPackage.log"""

					# -Path
					$CommandNew += "-Path ""$($test_mount_folder_Current)"""
					$CommandNewPrint += "-Path ""$($test_mount_folder_Current)"""

					# -PackagePath
					$CommandNew += "-PackagePath ""$($AppxSource)"""
					$CommandNewPrint += "-PackagePath ""$($AppxSource)"""

					# -LicensePath
					$CommandNew += "-LicensePath ""$($CertificateSource)"""
					$CommandNewPrint += "-LicensePath ""$($CertificateSource)"""

					# -DependencyPackagePath
					if ([string]::IsNullOrEmpty($CommandIsWaitInstallDependencyPackage)) {
					} else {
						$CommandNew += $CommandIsWaitInstallDependencyPackage
						$CommandNewPrint += $CommandIsWaitInstallDependencyPackage
					}

					# -Regions
					if ([string]::IsNullOrEmpty($CommandIsWaitInstallRegions)) {
					} else {
						$CommandNew += $CommandIsWaitInstallRegions
						$CommandNewPrint += $CommandIsWaitInstallRegions
					}

					$CommandNew += "-ErrorAction SilentlyContinue | Out-Null"

					[string]$CommandNew = $CommandNew
					[string]$CommandNewPrint = $CommandNewPrint

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  $($CommandNewPrint)`n" -ForegroundColor Green
					}

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					try {
						Invoke-Expression -Command $CommandNew
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} catch {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						Write-Host "  $($_)" -ForegroundColor Red
					}
				} else {
					Write-Host " $($lang.NoLicense) " -BackgroundColor DarkRed -ForegroundColor White

					$CommandNew = @()
					$CommandNewPrint = @()

					# Add-AppxProvisionedPackage
					$CommandNew += "Add-AppxProvisionedPackage"
					$CommandNewPrint += "Add-AppxProvisionedPackage"

					# -ScratchDirectory
					$CommandNew += "-ScratchDirectory ""$(Get_Mount_To_Temp)"""

					# -LogPath
					$CommandNew += "-LogPath ""$(Get_Mount_To_Logs)\Add-AppxProvisionedPackage.log"""

					# -Path
					$CommandNew += "-Path ""$($test_mount_folder_Current)"""
					$CommandNewPrint += "-Path ""$($test_mount_folder_Current)"""

					# -PackagePath
					$CommandNew += "-PackagePath ""$($AppxSource)"""
					$CommandNewPrint += "-PackagePath ""$($AppxSource)"""

					# -DependencyPackagePath
					if ([string]::IsNullOrEmpty($CommandIsWaitInstallDependencyPackage)) {
					} else {
						$CommandNew += $CommandIsWaitInstallDependencyPackage
						$CommandNewPrint += $CommandIsWaitInstallDependencyPackage
					}

					# -Regions
					if ([string]::IsNullOrEmpty($CommandIsWaitInstallRegions)) {
					} else {
						$CommandNew += $CommandIsWaitInstallRegions
						$CommandNewPrint += $CommandIsWaitInstallRegions
					}

					# -SkipLicense
					$CommandNew += "-SkipLicense"
					$CommandNewPrint += "-SkipLicense"

					$CommandNew += "-ErrorAction SilentlyContinue | Out-Null"

					[string]$CommandNew = $CommandNew
					[string]$CommandNewPrint = $CommandNewPrint

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  $($CommandNewPrint)`n" -ForegroundColor Green
					}

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					try {
						Invoke-Expression -Command $CommandNew
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} catch {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						Write-Host "  $($_)" -ForegroundColor Red
					}
				}
			}

			$InBoxAppsTasksTime.Stop()
			Write-Host "`n  $($lang.TimeEnd)" -NoNewline
			Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAll)" -NoNewline
			Write-Host $InBoxAppsTasksTime.Elapsed -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
			Write-Host "$($InBoxAppsTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host
		} else {
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}
}

Function Inbox_Apps_Hard_Links_Optimize
{
	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	if ($Global:Developers_Mode) {
		Write-Host "`n  $($lang.Developers_Mode_Location): 52`n" -ForegroundColor Green
	}

	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  Optimize-AppXProvisionedPackages -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
		Write-Host "  $('-' * 80)`n"
	}

	Write-Host "  $($lang.Optimize_ing): " -NoNewline
	try {
		Optimize-AppXProvisionedPackages -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Opt.log" -Path $test_mount_folder_Current | Out-Null
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} catch {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "  $($_)" -ForegroundColor Red
	}
}

Function InBox_Apps_Check_Customize
{
	param
	(
		[switch]$RuleNaming,
		[switch]$SelectApps,
		[switch]$AddSources
	)

	$UI_Main_Error.Text = ""
	$UI_Main_Error_Icon.Image = $null

	$UI_Main_Dashboard_IsAllowSave.Tag = "0"
	$UI_Main_Dashboard_IsAllowSave_Status.Text = $lang.InBoxAppsErrorNo
	$UI_Main_Mask_Error_Results.Text = $lang.InBoxAppsErrorNo

	$MarkCheckedRuleNaming = $False
	$MarkCheckedSelectApps = $False

	New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

	$InBoxAppx = @()

	<#
		.已选择待安装的软件
	#>
	$InBoxAppxUserSelect = @()

	<#
		.需要的依赖项
	#>
	$DependencyPackageSelect = @()

	<#
		.需要的依赖项，未选择
	#>
	$InitlNoSelectUWPDependency = @()

	<#
		.未选择的应用
	#>
	$InBoxAppxUserNoSelect = @()

	<#
		.检查是否选择规则命名
	#>
	if ($RuleNaming) {
		$UI_Main_Extract_Rule_Select_Sourcest.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$MarkCheckedRuleNaming = $True
					$Script:InBoxAppsSearchRuleSelected = $_.Tag
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_SelectGUID" -value $_.Tag -String
				}
			}
		}

		if ($MarkCheckedRuleNaming) {
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.RulePre) )"
			return
		}
	}

	<#
		.检查是否勾先应用程序
	#>
	if ($SelectApps) {
		$UI_Main_Match_Select_Apps.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Checked) {
					$MarkCheckedSelectApps = $True
					$InBoxAppxUserSelect += $_.Text
				} else {
					$InBoxAppxUserNoSelect += $_.Text
				}
			}
		}

		if ($MarkCheckedSelectApps) {
			<#
				.从预规则里获取首选命名 GUID
			#>
			$InBox_Apps_Rule_Select_Single = @()
			ForEach ($itemPre in $Global:Pre_Config_Rules) {
				ForEach ($item in $itemPre.Version) {
					if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
						$InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}

			<#
				.从单条规则里获取
			#>
			ForEach ($item in $Global:Preconfigured_Rule_Language) {
				if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
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
						if ($Script:InBoxAppsSearchRuleSelected -eq $item.GUID) {
							$InBox_Apps_Rule_Select_Single = $item
							break
						}
					}
				}
			}

			<#
				.依赖关系
			#>
			if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Rule){
					if ($InBoxAppxUserSelect -contains $item.Name) {
						$DependencyPackageSelect += $item.Dependencies
					}
				}
			}
			$DependencyPackageSelect = $DependencyPackageSelect | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

			$UI_Main_Mask_Dependencies_Results.Text = ""

			<#
				.用户已选的应用程序
			#>
			$UI_Main_Mask_Dependencies_Results.Text += "$($lang.RuleSelectApps): $($InBoxAppxUserSelect.Count) $($lang.EventManagerCount)`n"
			if ($InBoxAppxUserSelect.count -gt 0) {
				ForEach ($item in $InBoxAppxUserSelect) {
					$UI_Main_Mask_Dependencies_Results.Text += "   $($item)`n"
				}
			} else {
				$UI_Main_Mask_Dependencies_Results.Text += "   $($lang.NoWork)"
			}

			<#
				.所需要的依赖项
			#>
			$UI_Main_Mask_Dependencies_Results.Text += "`n`n$($lang.RuleDependenciesRequired): $($DependencyPackageSelect.Count) $($lang.EventManagerCount)`n"
			if ($DependencyPackageSelect.count -gt 0) {
				ForEach ($item in $DependencyPackageSelect | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique) {
					$UI_Main_Mask_Dependencies_Results.Text += "   $($item)`n"
				}
				
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Dependency_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $DependencyPackageSelect -Force
			} else {
				$UI_Main_Mask_Dependencies_Results.Text += "   $($lang.NoWork)"
			}

			<#
				.未选择的依赖项
			#>
			ForEach ($Item in $InBoxAppxUserNoSelect) {
				ForEach ($WildCard in $DependencyPackageSelect) {
					if ($item -like $WildCard) {
						$InitlNoSelectUWPDependency += $item
					}
				}
			}

			$UI_Main_Mask_Dependencies_Results.Text += "`n`n$($lang.RuleDependenciesUnselected): $($InitlNoSelectUWPDependency.Count) $($lang.EventManagerCount)`n"
			if ($InitlNoSelectUWPDependency.count -gt 0) {
				ForEach ($Item in $InitlNoSelectUWPDependency) {
					$UI_Main_Mask_Dependencies_Results.Text += "   $($item)`n"
				}

				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Dependency_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $InitlNoSelectUWPDependency -Force
			} else {
				$UI_Main_Mask_Dependencies_Results.Text += "   $($lang.NoWork)"
			}
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.InBox_Apps_Match) )"
			return
		}
	}

	if ($AddSources) {
		$Temp_Custom_Select_Add_Sources = @()
		$IsError_Match_InBox_Apps = @()

		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Custom_Select_Add_Sources += $_.Text
					}
				}
			}
		}

		if ($Temp_Custom_Select_Add_Sources.Count -gt 0) {
			<#
				.转换变量
			#>
			$NewArch  = $Global:Architecture
			$NewArchC = $Global:Architecture.Replace("AMD64", "x64")

			$NewArchCTag = $Global:Architecture.Replace("AMD64", "x64")
			if ($Global:Architecture -eq "arm64") {
				$NewArchCTag = "arm"
			}

			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Custom_Select_Add_Sources -Force
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

			if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
				ForEach ($itemInBoxApps in $InBox_Apps_Rule_Select_Single.InboxApps.Rule){
					if ($InBoxAppxUserSelect -contains $itemInBoxApps.Name) {
						$DependencyPackageSelect += $itemInBoxApps.DependDependencies

						$InstallPacker = ""
						$InstallPackerCert = ""

						<#
							.替换变量
						#>
						$SearchNewStructure = $itemInBoxApps.Match.Replace("{ARCH}", $NewArch).Replace("{ARCHC}", $NewArchC).Replace("{ARCHTag}", $NewArchCTag)
						$SearchNewLicense = $itemInBoxApps.License.Replace("{ARCH}", $NewArch).Replace("{ARCHC}", $NewArchC).Replace("{ARCHTag}", $NewArchCTag)

						$IsMatchTo = $False
						ForEach ($item in $Temp_Custom_Select_Add_Sources) {
							if ($IsMatchTo) {
							} else {
								if (Test-Path -Path $item -PathType Container) {
									Get-ChildItem -Path $item -Filter "*$($SearchNewStructure)*" -Include ("*.appx", "*.appxbundle", "*.msixbundle", "*.msix") -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
										if (Test-Path -Path $_.FullName -PathType Leaf) {
											$InstallPacker = $_.FullName

											Get-ChildItem -Path $item -Filter "*$($SearchNewLicense)*" -Include *.xml -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
												$InstallPackerCert = $_.FullName
											}

											$InBoxAppx += @{
												Name            = $itemInBoxApps.Name
												Region          = $itemInBoxApps.Region
												Depend          = $itemInBoxApps.Dependencies
												Search          = $SearchNewStructure
												InstallPacker   = $InstallPacker
												Certificate     = $InstallPackerCert
												CertificateRule = $SearchNewLicense
											}

											$IsMatchTo = $True
											break
										}
									}
								}
							}
						}

						if ($IsMatchTo) {
							
						} else {
							$IsError_Match_InBox_Apps += $itemInBoxApps.Name
						}
					}
				}

				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_List_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $InBoxAppx -Force
			}

			<#
				.获取 默认 规则
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $InBox_Apps_Rule_Select_Single.InboxApps.Edition -Force

			<#
				.InBox Apps: 添加, 用户选择的应用
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $InBoxAppxUserSelect -Force

			if ($IsError_Match_InBox_Apps.Count -gt 0) {
				$UI_Main_Dashboard_IsAllowSave.Tag = $IsError_Match_InBox_Apps.Count
				$UI_Main_Dashboard_IsAllowSave_Status.Text = $lang.InBoxAppsErrorTips -f $IsError_Match_InBox_Apps.Count
				$UI_Main_Mask_Error_Results.Text = ""
				$UI_Main_Mask_Error_Results.Text += $lang.InBoxAppsErrorTips -f $IsError_Match_InBox_Apps.Count
				$UI_Main_Mask_Error_Results.Text += "`n  $('.' * 80)`n"

				ForEach ($item in $IsError_Match_InBox_Apps) {
					$UI_Main_Mask_Error_Results.Text += "   $($item)`n"
				}
			} else {
				$UI_Main_Dashboard_IsAllowSave.Tag = "0"
				$UI_Main_Mask_Error_Results.Text = $lang.InBoxAppsErrorNo
				$UI_Main_Dashboard_IsAllowSave_Status.Text = $lang.InBoxAppsErrorNo
			}

			return $True
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.AddSources) )"
			return
		}
	}

	<#
		.已选择状态，保存到注册表
	#>
	New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $InBoxAppxUserNoSelect -Force

	return $True
}