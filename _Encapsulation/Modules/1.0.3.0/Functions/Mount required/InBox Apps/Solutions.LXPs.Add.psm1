<#
	.Language Experience Pack ( LXPs ): Add
	.本地语言体验包 ( LXPs ): 添加
#>
Function LXPs_Region_Add
{
	param
	(
		[array]$Autopilot
	)

	$Script:Temp_Select_Language_Add_Folder = @()

	$Search_Folder_Multistage_Rule = @(
		@{ Path = "_Custom\Engine\LXPs"; Engine = "LXPs.ps1"; }
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_LXPs_Region_Add_Save
	{
		$Temp_Select_Experience_Pack_Queue = @()

		<#
			.Mark: Check the selection status
			.标记：检查选择状态
		#>
		if ($UI_Main_Is_Install_LXPs.Checked) {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_LXPs_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force

			New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

			<#
				.安装时跳过 en-US 添加，建议
			#>
			if ($UI_Main_Skip_English.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			}

			<#
				.强行删除已安装的所有预应用程序 ( InBox Apps )
			#>
			if ($UI_Main_InBox_Apps_Clear.Checked) {
				<#
					.启用添加主要事件
				#>
				New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force

			} else {
				New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
			}

				<#
					.按规则排除
				#>
				if ($UI_Main_InBox_Apps_Clear_Rule.Checked) {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				} else {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
				}

			Refres_Event_Tasks_InBox_Apps_Region_Add_UI

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"

			Return $true
		} else {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_LXPs_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

			$Get_Temp_Select_Update_Add_Folder = @()
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Get_Temp_Select_Update_Add_Folder += $_.Text
						}
					}
				}
			}

			if ($Get_Temp_Select_Update_Add_Folder.count -gt 0) {

			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.AddSources): $($lang.NoChoose)"
				return $false
			}

			$UI_Main_Select_LXPs.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Temp_Select_Experience_Pack_Queue += @{
								Language = $_.Name
								Path     = $_.Tag
							}
						}
					}
				}
			}

			<#
				.Verification mark: check selection status
				.验证标记：检查选择状态
			#>
			if ($Temp_Select_Experience_Pack_Queue.count -gt 0) {
				New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Select_Experience_Pack_Queue -Force
				New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Get_Temp_Select_Update_Add_Folder -Force

				<#
					.强行删除已安装的所有预应用程序 ( InBox Apps )
				#>
				if ($UI_Main_InBox_Apps_Clear.Checked) {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force

					if ($UI_Main_InBox_Apps_Clear_Rule.Checked) {
						New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					} else {
						New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
					}
				} else {
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
					New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $false -Force
				}

				Refres_Event_Tasks_InBox_Apps_Region_Add_UI

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"

				Return $true
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"

				Return $false
			}
		}
	}

	Function Refres_Event_Tasks_InBox_Apps_Region_Add_UI
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		$Verify_Is_NewTasks = $False
		if ((Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$Verify_Is_NewTasks = $True
		}

		<#
			.验证是否有任务：强行删除已安装的所有预应用程序 ( InBox Apps )
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_InBox_Apps_Clear_Status.Text = "$($lang.InboxAppsClear): $($lang.Enable)"
			$UI_Main_Dashboard_Event_InBox_Apps_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_InBox_Apps_Clear_Status.Text = "$($lang.InboxAppsClear): $($lang.Disable)"
			$UI_Main_Dashboard_Event_InBox_Apps_Clear.Text = $lang.EventManagerNo
		}

		if ($Verify_Is_NewTasks) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		Refres_Event_Tasks_InBox_Apps_Region_Add_UI

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	Function Refresh_LXPs_Engine_Local_Sources
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Rule.controls.Clear()

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
		[int]$InitControlHeight = 45

		<#
			.多级目录规则
		#>
		$UI_Main_Multistage_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 520
			Padding        = "16,0,0,0"
			Text           = $lang.RuleMultistage
		}
		$UI_Main_Rule.controls.AddRange($UI_Main_Multistage_Rule_Name)

		ForEach ($itemMain in $Search_Folder_Multistage_Rule) {
			$TruePath = Convert-Path "$($PSScriptRoot)\..\..\..\..\.." -ErrorAction SilentlyContinue
			$item = "$($TruePath)\$($itemMain.Path)\Download"

			$MarkIsFolderRule = $False
			if (Test-Path -Path $item -PathType Container) {
				if((Get-ChildItem $item -Directory -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
					$MarkIsFolderRule = $True
				}
			}

			if ($MarkIsFolderRule) {
				Get-ChildItem -Path $item -Directory -ErrorAction SilentlyContinue | Where-Object {
					$InitLength = $item.Length
					if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

					$CheckBox    = New-Object System.Windows.Forms.RadioButton -Property @{
						Name     = [System.IO.Path]::GetFileNameWithoutExtension($_.FullName)
						Height   = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
						Width    = 465
						Padding  = "33,0,0,0"
						Text     = $_.FullName
						Tag      = $_.FullName
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null

							$UI_Main_Mask_Report_Sources_Path.Text = $_.FullName

							Refresh_Sources_New_LXPs
						}
					}

					if ($Temp_Assign_Task_Select -eq $_.FullName) {
						$CheckBox.Checked = $True
					}

					$UI_Main_Rule.controls.AddRange($CheckBox)

					$FileA = [IO.Path]::GetFileNameWithoutExtension("$($TruePath)\$($itemMain.Path)")
					$FileName = "$($FileA).ps1"
					$EnginePath = "$($TruePath)\$($itemMain.Path)\$($FileName)"

					if (Test-Path -Path $EnginePath -PathType Leaf) {
						$UI_Multilevel_Open_Engine = New-Object system.Windows.Forms.LinkLabel -Property @{
							Height         = 40
							Width          = 525
							Padding        = "48,0,0,0"
							Text           = "$($lang.Running): $($FileName)"
							Tag            = $EnginePath
							LinkColor      = "GREEN"
							ActiveLinkColor = "RED"
							LinkBehavior   = "NeverUnderline"
							add_Click      = {
								Start-Process powershell -ArgumentList "-file $($this.Tag)" -Verb RunAs
							}
						}

						$UI_Main_Rule.controls.AddRange($UI_Multilevel_Open_Engine)
					}

					$MultilevelPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height          = 40
						Width           = 525
						Padding         = "48,0,0,0"
						Text            = $lang.OpenFolder
						Tag             = "$($TruePath)\$($itemMain.Path)"
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
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

					$GUIImageSelectFunctionUpdate_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 20
						Width          = 525
					}
					$UI_Main_Rule.controls.AddRange((
						$MultilevelPathOpen,
						$GUIImageSelectFunctionUpdate_Wrap
					))
				}
			} else {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 465
					Margin    = "35,0,0,0"
					Text      = $item
					Tag       = $item
					Enabled   = $False
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Temp_Assign_Task_Select -eq $item) {
					$CheckBox.Checked = $True
				}

				$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 40
					Width          = 455
					Padding        = "45,0,0,0"
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
					Width          = 455
					Padding        = "45,0,0,0"
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

				$UI_Main_Rule.controls.AddRange((
					$CheckBox,
					$CheckBox_Open_Folder,
					$CheckBox_Paste,
					$CheckBox_Wrap
				))

				$FileA = [IO.Path]::GetFileNameWithoutExtension("$($TruePath)\$($itemMain.Path)")
				$FileName = "$($FileA).ps1"
				$EnginePath = "$($TruePath)\$($itemMain.Path)\$($FileName)"

				if (Test-Path -Path $EnginePath -PathType Leaf) {
					$UI_Multilevel_Open_Engine = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 40
						Width          = 525
						Padding        = "45,0,0,0"
						Text           = "$($lang.Running): $($FileName)"
						Tag            = $EnginePath
						LinkColor      = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Start-Process powershell -ArgumentList "-file $($this.Tag)" -Verb RunAs
						}
					}

					$UI_Main_Rule.controls.AddRange($UI_Multilevel_Open_Engine)
				}
			}
		}

		<#
			.其它规则
		#>
		$UI_Main_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 520
			Margin         = "0,35,0,0"
			Padding        = "18,0,0,0"
			Text           = $lang.RuleOther
		}
		$UI_Main_Rule.controls.AddRange($UI_Main_Other_Rule)
		if ($Script:Temp_Select_Language_Add_Folder.count -gt 0) {
			ForEach ($item in $Script:Temp_Select_Language_Add_Folder) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox    = New-Object System.Windows.Forms.RadioButton -Property @{
					Height   = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width    = 470
					Margin   = "35,0,0,5"
					Text     = $item
					Tag      = $item
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						Refresh_Sources_New_LXPs
					}
				}

				if ($Temp_Assign_Task_Select -eq $item) {
					$CheckBox.Checked = $True
				}

				$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 40
					Width          = 455
					Padding        = "45,0,0,0"
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
					Width          = 455
					Padding        = "45,0,0,0"
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

				$UI_Main_Rule.controls.AddRange((
					$CheckBox,
					$CheckBox_Open_Folder,
					$CheckBox_Paste,
					$CheckBox_Wrap
				))
			}
		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 520
				Padding        = "33,0,0,0"
				Text           = $lang.NoWork
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		}

		Refresh_Sources_New_LXPs
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

	Function Refresh_Sources_New_LXPs
	{
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$GUIISOCustomizeName.Text = $_.Text
					}
				}
			}
		}

		if ([string]::IsNullOrEmpty($GUIISOCustomizeName.Text)) {
			$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Mask_Report_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.ProcessSources)"
		} else {
			if (Test-Path -Path "$($GUIISOCustomizeName.Text)\Download" -PathType Container) {
				Refresh_Sources_New_LXPs_New -NewPath "$($GUIISOCustomizeName.Text)\LocalExperiencePack"
			} else {
				Refresh_Sources_New_LXPs_New -NewPath $GUIISOCustomizeName.Text
			}
		}
	}

	Function Refresh_Sources_New_LXPs_New
	{
		param
		(
			$NewPath
		)

		$UI_Main_Select_LXPs.controls.Clear()

		$FlagCheckSelectStatus = @()

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

		<#
			.Search whether the selected directory has: LanguageExperiencePack.*.appx
			.搜索已选择的目录是否有：LanguageExperiencePack.*.appx
		#>
		if (Test-Path -Path "$($NewPath)\LocalExperiencePack" -PathType Container) {
			Get-ChildItem "$($NewPath)\LocalExperiencePack" -directory -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path -Path "$($_.FullName)\LanguageExperiencePack.*.appx" -PathType Leaf) {
					$FlagCheckSelectStatus += @{
						Region = $_.BaseName
						File   = $_.FullName
					}
				}
			}
		} else {
			Get-ChildItem "$($NewPath)" -directory -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path -Path "$($_.FullName)\LanguageExperiencePack.*.appx" -PathType Leaf) {
					$FlagCheckSelectStatus += @{
						Region = $_.BaseName
						File   = $_.FullName
					}
				}
			}
		}

		if ($FlagCheckSelectStatus.Count -gt 0) {
			$Region = Language_Region

			foreach ($NewRegion in $FlagCheckSelectStatus) {
				ForEach ($itemRegion in $Region) {
					if ($NewRegion.Region -eq $itemRegion.Region) {
						$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
							Name      = $itemRegion.Region
							Height    = 55
							Width     = 510
							Text      = "$($itemRegion.Name)`n$($itemRegion.Region)"
							Tag       = $NewRegion.File
							add_Click = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
							}
						}

						if ($Temp_Assign_Task_Select.Language -contains $itemRegion.Region) {
							$CheckBox.Checked = $True
						} else {
							$CheckBox.Checked = $False
						}

						$UI_Main_Select_LXPs.controls.AddRange($CheckBox)

						break
					}
				}
			}
		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 510
				Padding        = "16,0,0,0"
				Text           = $lang.NoWork
			}
			$UI_Main_Select_LXPs.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		}
	}

	Function LXPs_Refresh_Sources_To_Status
	{
		$UI_Main_Mask_Report_Error_Icon.Image = $null
		$UI_Main_Mask_Report_Error.Text = ""

		$RandomGuid = [guid]::NewGuid()
		$InitalReportSources = $UI_Main_Mask_Report_Sources_Path.Text
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

		if (Test-Path -Path $InitalReportSources -PathType Container) {
			if (Test_Available_Disk -Path $InitalReportSources) {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $True
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $True
				$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)\Report.$($RandomGuid).csv"
			} else {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
				$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
			}
		} else {
			$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
			$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
			$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
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
					Refresh_Sources_New_LXPs
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
		Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)"
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
		.Select the rule
		.选择规则
	#>
	$UI_Main_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		margin         = "0,40,0,0"
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
			Refresh_LXPs_Engine_Local_Sources
			Refres_Event_Tasks_InBox_Apps_Region_Add_UI
		}
	}
	$UI_Main_Rule      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.选择来源
	#>
	$UI_Main_Select_Sources_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 525
		margin         = "0,30,0,0"
		Text           = $lang.ProcessSources
	}
	$GUIISOCustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 40
		Width          = 490
		Text           = ""
		margin         = "30,0,0,15"
		ReadOnly       = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	<#
		.事件：磁盘缓存，打开目录
	#>
	$GUIImageSourceISOCacheCustomizePathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 525
		Padding        = "26,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIISOCustomizeName.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $GUIISOCustomizeName.Text -PathType Container) {
					Start-Process $GUIISOCustomizeName.Text

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				}
			}
		}
	}

	<#
		.事件：磁盘缓存，复制路径
	#>
	$GUIImageSourceISOCacheCustomizePathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 525
		Padding        = "26,0,0,0"
		Text           = $lang.Paste
		Tag            = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIISOCustomizeName.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $GUIISOCustomizeName.Text

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.显示目录所匹配出来的语言
	#>
	$UI_Main_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 525
		margin         = "0,35,0,0"
		Text           = $lang.LanguageCode
	}
	$UI_Main_Select_LXPs = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Padding        = "16,0,0,0"
		margin         = "0,0,0,5"
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.显示提示蒙层
	#>
	$UI_Main_Mask_Tips = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 928
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Tips_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 555
		Width          = 885
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $lang.Remove_Appx_Tips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Mask_Tips_Global_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,607"
		Height         = 40
		Width          = 550
		Text           = $lang.LXPsAddDelTipsGlobal
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Mask_Tips_Global_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningUWPGlobal" -value "True" -String
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningUWPGlobal" -value "False" -String
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	$UI_Main_Mask_Tips_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 40
		Width          = 550
		Text           = $lang.LXPsAddDelTips
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Mask_Tips_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "TipsWarningUWP" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "TipsWarningUWP" -value "False" -String
			}
		}
	}
	$UI_Main_Mask_Tips_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Mask_Tips.Visible = $False
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
		add_Click      = {
			New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

			Refres_Event_Tasks_InBox_Apps_Region_Add_UI

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		}
	}

	$UI_Main_Dashboard_Event_InBox_Apps_Clear_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = "$($lang.InboxAppsClear): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_InBox_Apps_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
	
			Refres_Event_Tasks_InBox_Apps_Region_Add_UI
	
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		}
	}

	$UI_Main_Is_Install_LXPs_Adv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 500
		margin         = "0,35,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.跳过本地语言体验包 ( LXPs ) 添加，执行其它
	#>
	$UI_Main_Is_Install_LXPs = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 500
		Padding        = "18,0,8,0"
		Text           = $lang.ForceRemovaAllUWP
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($this.Checked) {
				$UI_Main_Select_LXPs.Enabled = $False
				$UI_Main_Select_Folder.Enabled = $False
				$UI_Main_Rule.Enabled = $False
			} else {
				$UI_Main_Select_LXPs.Enabled = $True
				$UI_Main_Select_Folder.Enabled = $True
				$UI_Main_Rule.Enabled = $True
			}
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_LXPs_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Is_Install_LXPs.Checked = $True
	} else {
		$UI_Main_Is_Install_LXPs.Checked = $False
	}

	<#
		.安装时跳过 en-US 添加，建议
	#>
	$UI_Main_Skip_English = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 500
		Padding        = "18,0,8,0"
		Text           = $lang.LEPSkipAddEnglish
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($This.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			}
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Skip_English.Checked = $True
	} else {
		$UI_Main_Skip_English.Checked = $False
	}
	$UI_Main_Skip_English_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "35,0,8,0"
		Text           = $lang.LEPSkipAddEnglishTips
	}

	<#
		.安装前的方式
	#>
	$UI_Main_InBox_Apps_Install_Type = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 500
		Margin         = "0,50,0,0"
		Text           = $lang.LEPBrandNew
	}
	$UI_Main_InBox_Apps_Clear = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 500
		Padding        = "18,0,0,0"
		Text           = $lang.InboxAppsClear
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_InBox_Apps_Clear.Checked = $True
	} else {
		$UI_Main_InBox_Apps_Clear.Checked = $False
	}

	$UI_Main_InBox_Apps_Clear_Rule = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 500
		Padding        = "35,0,0,0"
		Text           = $lang.ExcludeItem
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_InBox_Apps_Clear_Rule.Checked = $True
	} else {
		$UI_Main_InBox_Apps_Clear_Rule.Checked = $False
	}

	$UI_Main_InBox_Apps_Clear_Rule_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 500
		Padding        = "52,0,0,0"
		Text           = $lang.Exclude_View
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $True
			$UI_Main_View_Detailed_Show.Text = ""

			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$UI_Main_View_Detailed_Show.Text += "   $($lang.ExcludeItem)`n"
			ForEach ($item in $Global:Exclude_InBox_Apps_Delete) {
				$UI_Main_View_Detailed_Show.Text += "       $($item)`n"
			}
		}
	}
	$UI_Main_Menu_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 500
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
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
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $False
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
			Event_Need_Mount_Global_Variable -DevQueue "15" -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
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
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
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

	<#
		.Displays the report mask
		.显示报告蒙层
	#>
	$UI_Main_Mask_Report = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1025
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Report_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 530
		Padding        = "8,0,8,0"
		Location       = "15,10"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$UI_Main_Mask_Report_Sources_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 480
		Text           = $lang.AdvAppsDetailed
	}
	$UI_Main_Mask_Report_Sources_Name_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,35"
		Text           = $lang.AdvAppsDetailedTips
	}

	$UI_Main_Mask_Report_Sources_Path_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 480
		Text           = $lang.ProcessSources
	}
	$UI_Main_Mask_Report_Sources_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 40
		Width          = 450
		margin         = "18,5,0,25"
		Text           = ""
		ReadOnly       = $True
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null
		}
	}
	$UI_Main_Mask_Report_Sources_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$RandomGuid = [guid]::NewGuid()
			$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

			$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				$InitalReportSources = (Join_MainFolder -Path $FolderBrowser.SelectedPath)
				$UI_Main_Mask_Report_Sources_Path.Text = $InitalReportSources
				$GUIISOCustomizeName.Text = $FolderBrowser.SelectedPath

				if (Test-Path -Path $InitalReportSources -PathType Container) {
					if (Test_Available_Disk -Path $InitalReportSources) {
						$UI_Main_Mask_Report_Save_To.Text = "$($InitalReportSources)Report.$($RandomGuid).csv"
					} else {
						$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
					}

					LXPs_Refresh_Sources_To_Status
				} else {
					$UI_Main_Mask_Report_Save_To.Text = "$($DesktopOldpath)\Report.$($RandomGuid).csv"
				}
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.UserCancel
			}
		}
	}
	$UI_Main_Mask_Report_Sources_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Main_Mask_Report_Sources_Path.BackColor = "LightPink"
			} else {
				if (Test-Path -Path $UI_Main_Mask_Report_Sources_Path.Text -PathType Container) {
					Start-Process $UI_Main_Mask_Report_Sources_Path.Text

					$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
				} else {
					$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					$UI_Main_Mask_Report_Sources_Path.BackColor = "LightPink"
				}
			}
		}
	}
	$UI_Main_Mask_Report_Sources_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Main_Mask_Report_Sources_Path.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $UI_Main_Mask_Report_Sources_Path.Text

				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.The report is saved to
		.报告保存到
	#>
	$UI_Main_Mask_Report_Save_To_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 480
		margin         = "0,30,0,0"
		Text           = $lang.SaveTo
	}
	$UI_Main_Mask_Report_Save_To = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 40
		Width          = 450
		margin         = "20,5,0,25"
		Text           = ""
		ReadOnly       = $True
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null
		}
	}
	$UI_Main_Mask_Report_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$RandomGuid = [guid]::NewGuid()

			$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
				FileName = "Report.$($RandomGuid).csv"
				Filter   = "Export CSV Files (*.CSV;)|*.csv;"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$UI_Main_Mask_Report_Save_To.Text = $FileBrowser.FileName
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.UserCancel
			}
		}
	}
	$UI_Main_Mask_Report_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Save_To.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UI_Main_Mask_Report_Save_To.Text

				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	$UI_Main_Tips_New  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.LXPsAddDelTipsView
		Location       = "620,515"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$UI_Main_Mask_Tips.Visible = $True
		}
	}

	$UI_Main_Mask_Report_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,503"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Mask_Report_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,505"
		Height         = 85
		Width          = 255
		Text           = ""
	}
	$UI_Main_Mask_Report_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$MarkVerifyWrite = $False
			$InitalReportSources = $UI_Main_Mask_Report_Sources_Path.Text
			if (-not [string]::IsNullOrEmpty($InitalReportSources)) {
				if (Test-Path -Path $InitalReportSources -PathType Container) {
					$MarkVerifyWrite = $True
				}
			}

			if ($MarkVerifyWrite) {
				LXPs_Save_Report_Process -Path $UI_Main_Mask_Report_Sources_Path.Text -SaveTo $UI_Main_Mask_Report_Save_To.Text
				$UI_Main_Mask_Report.Visible = $False
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.Inoperable
			}
		}
	}
	$UI_Main_Mask_Report_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Mask_Report.visible = $False
		}
	}

	<#
		.刷新
	#>
	$UI_Main_Refresh_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.Refresh
		add_Click      = {
			Refresh_LXPs_Engine_Local_Sources
			Refres_Event_Tasks_InBox_Apps_Region_Add_UI

			$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}

	$UI_Main_Report    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.AdvAppsDetailed
		add_Click      = {
			$RandomGuid = [guid]::NewGuid()
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			<#
				.Determine whether the save to is empty, if not, randomly generate a new save path
				.判断保存到是否为空，如果不为空则随机生成新的保存路径
			#>
			if ([string]::IsNullOrEmpty($GUIISOCustomizeName.Text)) {
				$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\InBox_Apps\Report.$($RandomGuid).csv"
				$UI_Main_Mask_Report_Sources_Path.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\InBox_Apps"
			} else {
				<#
					.获取是否有添加源
				#>
				$UI_Main_Mask_Report_Sources_Path.Text = $GUIISOCustomizeName.Text
			}

			LXPs_Refresh_Sources_To_Status
			$UI_Main_Mask_Report.visible = $True
		}
	}
	$UI_Main_Select_Folder = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,90"
		Height         = 36
		Width          = 280
		Text           = $lang.SelectFolder
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Get_Temp_Select_Update_Add_Folder = @()
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					$Get_Temp_Select_Update_Add_Folder += $_.Text
				}
			}

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if ($Get_Temp_Select_Update_Add_Folder -Contains $FolderBrowser.SelectedPath) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Existed
				} else {
					$Script:Temp_Select_Language_Add_Folder += $FolderBrowser.SelectedPath
					New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $FolderBrowser.SelectedPath -Force
					Refresh_LXPs_Engine_Local_Sources
					Refres_Event_Tasks_InBox_Apps_Region_Add_UI

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.AddTo): $($FolderBrowser.SelectedPath), $($lang.Done)"
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}
	$UI_Main_Select_Folder_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 80
		Width          = 260
		Location       = "628,135"
		Text           = $lang.DropFolder
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,240"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = '645,242'
		Height         = 80
		Width          = 250
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
			if (Autopilot_LXPs_Region_Add_Save) {
				
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
				$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_Select.count -gt 0) {
					ForEach ($item in $Temp_Assign_Task_Select) {
						Write-Host "  $($item.Language)" -ForegroundColor Green
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
		$UI_Main_View_Detailed,
		$UI_Main_Mask_Report,
		$UI_Main_Mask_Tips,
		$UI_Main_Menu,
		$UI_Main_Tips_New,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Refresh_Sources,
		$UI_Main_Report,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Mask_Tips.controls.AddRange((
		$UI_Main_Mask_Tips_Results,
		$UI_Main_Mask_Tips_Global_Do_Not,
		$UI_Main_Mask_Tips_Do_Not,
		$UI_Main_Mask_Tips_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,

		$UI_Main_Dashboard_Event_InBox_Apps_Clear_Status,
		$UI_Main_Dashboard_Event_InBox_Apps_Clear,
		$UI_Main_Is_Install_LXPs_Adv,
		$UI_Main_Is_Install_LXPs,
		$UI_Main_Skip_English,
		$UI_Main_Skip_English_Tips,

		$UI_Main_InBox_Apps_Install_Type,
		$UI_Main_InBox_Apps_Clear,
		$UI_Main_InBox_Apps_Clear_Rule,
		$UI_Main_InBox_Apps_Clear_Rule_View,

		$UI_Main_Rule_Name,
		$UI_Main_Setting_ISO,
		$UI_Main_Rule,

		$UI_Main_Select_Sources_Name,
		$GUIISOCustomizeName,
		$GUIImageSourceISOCacheCustomizePathOpen,
		$GUIImageSourceISOCacheCustomizePathPaste,
		$UI_Main_Other_Rule,
		$UI_Main_Select_LXPs,
		$UI_Main_Menu_Wrap
	))
	<#
		.Mask, report
		.蒙板，报告
	#>
	$UI_Main_Mask_Report.controls.AddRange((
		$UI_Main_Mask_Report_Menu,
		$UI_Main_Mask_Report_Error_Icon,
		$UI_Main_Mask_Report_Error,
		$UI_Main_Mask_Report_OK,
		$UI_Main_Mask_Report_Canel
	))
	$UI_Main_Mask_Report_Menu.controls.AddRange((
		$UI_Main_Mask_Report_Sources_Name,
		$UI_Main_Mask_Report_Sources_Name_Tips,
		$UI_Main_Mask_Report_Sources_Path_Name,
		$UI_Main_Mask_Report_Sources_Path,
		$UI_Main_Mask_Report_Sources_Select_Folder,
		$UI_Main_Mask_Report_Sources_Open_Folder,
		$UI_Main_Mask_Report_Sources_Paste,
		$UI_Main_Mask_Report_Save_To_Name,
		$UI_Main_Mask_Report_Save_To,
		$UI_Main_Mask_Report_Select_Folder,
		$UI_Main_Mask_Report_Paste
	))

	<#
		.遇到 映像源 类型为服务器级别时，不勾选：安装前强行删除已安装的所有预应用程序 ( InBox Apps )
	#>
	if ($Global:ImageType -eq "Server") {
		$UI_Main_InBox_Apps_Clear.Checked = $False
	}

	<#
		.提示
	#>
	$MarkShowNewTips = $False
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TipsWarningUWPGlobal" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TipsWarningUWPGlobal" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $True
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $True
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			}
			"False" {
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $False
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "TipsWarningUWP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "TipsWarningUWP" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $True
				$UI_Main_Mask_Tips_Do_Not.Checked = $True
			}
			"False" {
				$UI_Main_Mask_Tips_Do_Not.Checked = $False
			}
		}
	}
	if ($MarkShowNewTips) {
		$UI_Main_Mask_Tips.Visible = $True
	} else {
		$UI_Main_Mask_Tips.Visible = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUILXPsSelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUILXPsSelectMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Select_LXPs.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { 
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUILXPsSelectMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Select_LXPs.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_LXPs.ContextMenuStrip = $GUILXPsSelectMenu

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ) $($lang.AddTo)" -ForegroundColor Yellow
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

	Refresh_LXPs_Engine_Local_Sources
	Refres_Event_Tasks_InBox_Apps_Region_Add_UI

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	switch ($Global:IsLang) {
		'de-DE' {
			$UI_Main_Is_Install_LXPs.Height = "35"
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		switch ($Autopilot.Schome) {
			"Skip" {
				$UI_Main_Is_Install_LXPs.Checked = $True
					$UI_Main_Select_LXPs.Enabled = $False
					$UI_Main_Select_Folder.Enabled = $False
					$UI_Main_Rule.Enabled = $False

				if ($Autopilot.Skip.RemoveAll.IsDel) {
					$UI_Main_InBox_Apps_Clear.Checked = $True
				} else {
					$UI_Main_InBox_Apps_Clear.Checked = $False
				}

				if ($Autopilot.Skip.RemoveAll.IsExclude) {
					$UI_Main_InBox_Apps_Clear_Rule.Checked = $True
				} else {
					$UI_Main_InBox_Apps_Clear_Rule.Checked = $False
				}
			}
			"Custom" {
				$UI_Main_Is_Install_LXPs.Checked = $False
					$UI_Main_Select_LXPs.Enabled = $True
					$UI_Main_Select_Folder.Enabled = $True
					$UI_Main_Rule.Enabled = $True

				if ($Autopilot.Custom.SkipenUS) {
					$UI_Main_Skip_English.Checked = $True
				} else {
					$UI_Main_Skip_English.Checked = $False
				}

				if ($Autopilot.Custom.RemoveAll.IsDel) {
					$UI_Main_InBox_Apps_Clear.Checked = $True
				} else {
					$UI_Main_InBox_Apps_Clear.Checked = $False
				}

				if ($Autopilot.Custom.RemoveAll.IsExclude) {
					$UI_Main_InBox_Apps_Clear_Rule.Checked = $True
				} else {
					$UI_Main_InBox_Apps_Clear_Rule.Checked = $False
				}

				if (-not ([string]::IsNullOrEmpty($Autopilot.Custom.Version))) {
					$UI_Main_Rule.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($Autopilot.Custom.Version -eq $_.Name) {
								$_.Checked = $True
							}
						}
					}

					Refresh_Sources_New_LXPs
				}
				
				if (-not ([string]::IsNullOrEmpty($Autopilot.Custom.Region))) {
					$UI_Main_Select_LXPs.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($Autopilot.Custom.Region -contains $_.Name) {
								$_.Checked = $True
							}
						}
					}
				}
			}
		}

		if (Autopilot_LXPs_Region_Add_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.Clear all pre-installed applications in the image package
	.清除映像包里的所有预安装应用
#>
Function InBox_Apps_LIPs_Clean_Process
{
	
	<#
		.初始化，获取预安装 InBox Apps 应用
	#>
	$InitlUWPPrePakcage = @()
	$InitlUWPPrePakcageExclude = @()
	$InitlUWPPrePakcageDelete = @()

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	<#
		.判断挂载目录是否存在
	#>
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Green

			if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
				<#
					.从设置里判断是否允许排除规则
				#>
				if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					ForEach ($item in $Global:Exclude_InBox_Apps_Delete) {
						$InitlUWPPrePakcageDelete += $item
					}
				}

				<#
					.输出当前所有排除规则
				#>
				Write-Host "`n  $($lang.ExcludeItem)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($InitlUWPPrePakcageDelete.count -gt 0) {
					ForEach ($item in $InitlUWPPrePakcageDelete) {
						Write-Host "  $($item)" -ForegroundColor Green
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.获取所有已安装的 InBox Apps 应用，并输出到数组
				#>
				Write-Host "`n  $($lang.GetInBoxApps)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				try {
					Get-AppXProvisionedPackage -path $test_mount_folder_Current -ErrorAction SilentlyContinue | ForEach-Object {
						$InitlUWPPrePakcage += $_.PackageName
						Write-Host "  $($_.PackageName)" -ForegroundColor Green
					}
				} catch {
					Write-Host "  $($_)" -ForegroundColor Red
					Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					Write-Host "  $($lang.GetInBoxApps), $($lang.Inoperable)" -ForegroundColor Red
					return
				}

				<#
					.从排除规则获取需要排除的项目
				#>
				if ($InitlUWPPrePakcage.count -gt 0) {
					ForEach ($Item in $InitlUWPPrePakcage) {
						ForEach ($WildCard in $InitlUWPPrePakcageDelete) {
							if ($item -like $WildCard) {
								$InitlUWPPrePakcageExclude += $item
							}
						}
					}

					Write-Host "`n  $($lang.ExcludeItem): " -NoNewline -ForegroundColor Yellow
					Write-Host "$($InitlUWPPrePakcageExclude.count) $($lang.EventManagerCount)" -ForegroundColor Green
					Write-Host "  $('-' * 80)"
					if ($InitlUWPPrePakcageExclude.count -gt 0) {
						ForEach ($item in $InitlUWPPrePakcageExclude) {
							Write-Host "  $($item)" -ForegroundColor Green
						}
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}

					Write-Host "`n  $($lang.LXPsWaitRemove)" -ForegroundColor Green
					Write-Host "  $('-' * 80)"

					[int]$SNTasks = "0"
					ForEach ($item in $InitlUWPPrePakcage) {
						if ($InitlUWPPrePakcageExclude -notContains $item) {
							<#
								.初始化每任务运行时间
							#>
							$InBoxAppsTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
							$InBoxAppsTasksTime = New-Object System.Diagnostics.Stopwatch
							$InBoxAppsTasksTime.Reset()
							$InBoxAppsTasksTime.Start()
							$SNTasks++

							Write-Host "  $($lang.TimeStart)" -NoNewline
							Write-Host "$($InBoxAppsTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
							Write-Host "  $('-' * 80)"
							Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
							Write-Host $SNTasks -NoNewline -ForegroundColor Green
							Write-host " $($lang.EventManagerCount)"

							Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
							Write-Host $item -ForegroundColor Green

							if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
								Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  Remove-AppxProvisionedPackage -Path ""$($test_mount_folder_Current)"" -PackageName ""$($item)""`n" -ForegroundColor Green
							}

							Write-Host "  " -NoNewline
							Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
							try {
								Remove-AppxProvisionedPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Remove-AppxProvisionedPackage.log" -Path $test_mount_folder_Current -PackageName $item -ErrorAction SilentlyContinue | Out-Null
								Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
							} catch {
								Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
								Write-Host "  $($_)" -ForegroundColor Red
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
						}
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function InBox_Apps_LIPs_Add_Mark_Process
{
	$Temp_Select_Queue_LXPs_Add_Custom_Select = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Select_Queue_LXPs_Add_Custom_Select.count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Select_Queue_LXPs_Add_Custom_Select) {
			Write-Host "  $($item.Language): " -NoNewline
			Write-Host $item.Path -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Select_Queue_LXPs_Add_Custom_Select) {
			Write-Host "  $($item.Path)"

			if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
				$shortname = [IO.Path]::GetFileName($item.Path)
				if ($shortname -eq "en-US") {
					Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
				} else {
					InBox_Apps_Add_Mark_Process -Path $item.Path
				}
			} else {
				InBox_Apps_Add_Mark_Process -Path $item.Path
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.Add local language experience packs (LXPs)
	.开始添加本地语言体验包 ( LXPs )
#>
Function InBox_Apps_Add_Mark_Process
{
	param
	(
		[string]$Path
	)

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  Get-ChildItem ""$($Path)\LanguageExperiencePack.*.appx""" -ForegroundColor Green
		Write-Host "  $('-' * 80)`n"
	}

	Get-ChildItem "$($Path)\LanguageExperiencePack.*.appx" -ErrorAction SilentlyContinue | ForEach-Object {
		Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
		Write-Host $_.FullName -ForegroundColor Green

		if (Test-Path -Path "$($Path)\License.xml" -PathType Leaf) {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Add-AppxProvisionedPackage -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($_.FullName)"" -LicensePath ""$($Path)\License.xml""" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "  $($lang.License): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($Path)\License.xml" -ForegroundColor Green

			Write-Host "  " -NoNewline
			Write-Host " $($lang.IsLicense) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Add-AppxProvisionedPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\AppxProvisionedPackage.log" -Path $test_mount_folder_Current -PackagePath $_.FullName -LicensePath "$($Path)\License.xml" -Regions "All" -ErrorAction SilentlyContinue | Out-Null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			Write-Host
		} else {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Add-AppxProvisionedPackage -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($_.FullName)"" -SkipLicense" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "  $($lang.NoLicense): " -NoNewline
			Add-AppxProvisionedPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Add-AppxProvisionedPackage.log" -Path $test_mount_folder_Current -PackagePath $_.FullName -SkipLicense -Regions "All" -ErrorAction SilentlyContinue | Out-Null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			Write-Host
		}
	}
}

Function LXPs_Save_Report_Process
{
	param
	(
		$Path,
		$SaveTo
	)

	if (Test-Path -Path "$($Path)\LocalExperiencePack" -PathType Container) {
		$FolderDirect = (Join_MainFolder -Path "$($Path)\LocalExperiencePack")
	} else {
		$FolderDirect = (Join_MainFolder -Path $Path)
	}

	Write-Host "`n  $($lang.AdvAppsDetailed)"
	$QueueSelectLXPsReport = @()
	$RandomGuid = [guid]::NewGuid()
	$ISOTestFolderMain = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	Check_Folder -chkpath $ISOTestFolderMain

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$TempNewFileFolderPath = "$($ISOTestFolderMain)\$($itemRegion.Region)"
		$TempNewFileFullPath = "$($FolderDirect)$($itemRegion.Region)\LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			Check_Folder -chkpath $TempNewFileFolderPath

			Add-Type -AssemblyName System.IO.Compression.FileSystem
			$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
			$zipFile.Entries | where { $_.Name -like 'AppxManifest.xml' } | ForEach {
				[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($TempNewFileFolderPath)\$($_.Name)", $true)
			}
			$zipFile.Dispose()

			if (Test-Path -Path "$($TempNewFileFolderPath)\AppxManifest.xml" -PathType Leaf) {
				[xml]$xml = Get-Content -Path "$($TempNewFileFolderPath)\AppxManifest.xml"

				$QueueSelectLXPsReport += [PSCustomObject]@{
					FileName           = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
					MatchLanguage      = $itemRegion.Region
					LXPsDisplayName    = $Xml.Package.Properties.DisplayName
					LXPsLanguage       = $Xml.Package.Resources.Resource.Language
					LXPsVersion        = $Xml.Package.Identity.Version
					TargetDeviceFamily = $Xml.Package.Dependencies.TargetDeviceFamily.Name
					MinVersion         = $Xml.Package.Dependencies.TargetDeviceFamily.MinVersion
					MaxVersionTested   = $Xml.Package.Dependencies.TargetDeviceFamily.MaxVersionTested
				}
			}
		} else {
			$QueueSelectLXPsReport += [PSCustomObject]@{
				FileName           = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
				MatchLanguage      = $itemRegion.Region
				LXPsDisplayName    = ""
				LXPsLanguage       = ""
				LXPsVersion        = ""
				TargetDeviceFamily = ""
				MinVersion         = ""
				MaxVersionTested   = ""
			}
		}
	}

	$QueueSelectLXPsReport | Export-CSV -NoTypeInformation -Path $SaveTo -Encoding UTF8

	Remove_Tree $ISOTestFolderMain
}