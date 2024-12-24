<#
	.Add driver
	.添加驱动
#>
Function Drive_Add_UI
{
	param
	(
		[array]$Autopilot
	)

	<#
		.转换架构类型
	#>
	switch ($Global:Architecture) {
		"arm64" { $ArchitectureNew = "arm64" }
		"AMD64" { $ArchitectureNew = "x64" }
		"x86" { $ArchitectureNew = "x86" }
	}

	<#
		.初始化数组：选择新目录
	#>
	$SearchFolderRule = @(
		Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Drive\$($ArchitectureNew)\Add"
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Drive\Add"
		"$($Global:Image_source)_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Drive\Add"
	)
	$SearchFolderRule = $SearchFolderRule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	$Script:Temp_Select_Custom_Folder_Queue = @()

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

	Function Autopilot_Drive_Add_UI_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$Temp_Queue_Select_Item = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Queue_Select_Item += $_.Tag
					}
				}
			}
		}

		if ($Temp_Queue_Select_Item.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			New-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Queue_Select_Item -Force

			Refres_Event_Tasks_Drive_Add_UI

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			return $True
		} else {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			return $False
		}
	}

	Function Refres_Event_Tasks_Drive_Add_UI
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		Refres_Event_Tasks_Drive_Add_UI

		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
	}

	Function Drive_Add_Refresh_Sources
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Rule.controls.Clear()

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

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

		$UI_Main_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 505
			Text           = $lang.AddSources
		}
		$UI_Main_Rule.controls.AddRange($UI_Main_Rule_Name)

		<#
			.预规则，标题
		#>
		if ($SearchFolderRule.Count -gt 0) {
			$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 505
				Padding        = "16,0,0,0"
				Text           = $lang.RulePre
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Pre_Rule)
	
			ForEach ($item in $SearchFolderRule) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }
	
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 470
					Margin    = "35,0,0,10"
					Text      = $item
					Tag       = $item
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}
				$UI_Main_Rule.controls.AddRange($CheckBox)
	
				$AddSourcesPath     = New-Object system.Windows.Forms.LinkLabel -Property @{
					autosize        = 1
					Padding         = "50,0,0,0"
					margin          = "0,0,0,15"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							} else {
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							}
						}
					}
				}
	
				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 30
					Width           = 470
					Padding         = "48,0,0,0"
					Text            = $lang.OpenFolder
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							} else {
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							}
						}
					}
				}
	
				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 30
					Width           = 470
					Padding         = "48,0,0,0"
					Text            = $lang.Paste
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							Set-Clipboard -Value $This.Tag

							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						}
					}
				}
	
				if (Test-Path -Path $item -PathType Container) {
					<#
						.目录可用时，自动选择：预置规则
					#>
					$Is_Dont_Checke_Is_RulePre = $False
					if ($UI_Main_Dont_Checke_Is_RulePre.Enabled) {
						if ($UI_Main_Dont_Checke_Is_RulePre.Checked) {
							$Is_Dont_Checke_Is_RulePre = $True
						}
					}

					if ($Is_Dont_Checke_Is_RulePre) {
						$CheckBox.Checked = $True
					} else {
						if ($Temp_Assign_Task_Select -contains $item) {
							$CheckBox.Checked = $True
						} else {
							$CheckBox.Checked = $False
						}
					}
	
					<#
						.判断目录里，是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include "*.inf" -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
							<#
								.提示，未发现文件
							#>
	
							$UI_Main_Rule.controls.AddRange($AddSourcesPath)
							$CheckBox.Enabled = $False
						} else {
							$CheckBox.Enabled = $True
						}
					}

					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 520
					}
					$UI_Main_Rule.controls.AddRange((
						$AddSourcesPathOpen,
						$AddSourcesPathPaste,
						$AddSourcesPath_Wrap
					))
				} else {
					$CheckBox.Enabled = $False
	
					$AddSourcesPathNoFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize        = 1
						Padding         = "48,0,0,0"
						Text            = $lang.RuleMatchNoFindFolder
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Check_Folder -chkpath $this.Tag
							Drive_Add_Refresh_Sources
						}
					}
					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 520
					}
					$UI_Main_Rule.controls.AddRange((
						$AddSourcesPathNoFolder,
						$AddSourcesPath_Wrap
					))
				}
			}
		}

		<#
			.其它规则
		#>
		$UI_Main_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 505
			Margin         = "0,35,0,0"
			Padding        = "18,0,0,0"
			Text           = $lang.RuleCustomize
		}
		$UI_Main_Rule.controls.AddRange($UI_Main_Other_Rule)
		if ($Script:Temp_Select_Custom_Folder_Queue.count -gt 0) {
			ForEach ($item in $Script:Temp_Select_Custom_Folder_Queue) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 470
					Margin    = "35,0,0,5"
					Text      = $item
					Tag       = $item
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}
				$UI_Main_Rule.controls.AddRange($CheckBox)

				$AddSourcesPath     = New-Object system.Windows.Forms.LinkLabel -Property @{
					autosize        = 1
					Padding         = "50,0,0,0"
					margin          = "0,0,0,10"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							} else {
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							}
						}
					}
				}

				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 30
					Width           = 470
					Padding         = "48,0,0,0"
					Text            = $lang.OpenFolder
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							} else {
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							}
						}
					}
				}

				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 30
					Width           = 470
					Padding         = "48,0,0,0"
					Text            = $lang.Paste
					Tag             = $item
					LinkColor       = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						} else {
							Set-Clipboard -Value $This.Tag

							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						}
					}
				}

				if (Test-Path -Path $item -PathType Container) {
					<#
						.目录可用时，自动选择：其它规则
					#>
					$Is_Dont_Checke_Is_RuleOther = $False
					if ($UI_Main_Dont_Checke_Is_RuleOther.Enabled) {
						if ($UI_Main_Dont_Checke_Is_RuleOther.Checked) {
							$Is_Dont_Checke_Is_RuleOther = $True
						}
					}

					if ($Is_Dont_Checke_Is_RuleOther) {
						$CheckBox.Checked = $True
					} else {
						if ($Temp_Assign_Task_Select -contains $item) {
							$CheckBox.Checked = $True
						} else {
							$CheckBox.Checked = $False
						}
					}
	
					<#
						.判断目录里，是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include "*.inf" -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
							<#
								.提示，未发现文件
							#>
	
							$UI_Main_Rule.controls.AddRange($AddSourcesPath)
							$CheckBox.Enabled = $False
						} else {
							$CheckBox.Enabled = $True
						}
					}

					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 520
					}
					$UI_Main_Rule.controls.AddRange((
						$AddSourcesPathOpen,
						$AddSourcesPathPaste,
						$AddSourcesPath_Wrap
					))
				} else {
					$CheckBox.Enabled = $False

					$AddSourcesPathNoFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize        = 1
						Padding         = "48,0,0,0"
						Text            = $lang.RuleMatchNoFindFolder
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Check_Folder -chkpath $this.Tag
							Drive_Add_Refresh_Sources
						}
					}
					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 520
					}
					$UI_Main_Rule.controls.AddRange((
						$AddSourcesPathNoFolder,
						$AddSourcesPath_Wrap
					))
				}
			}
		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 490
				Padding        = "33,0,0,0"
				Text           = $lang.NoWork
			}
			$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 520
			}
			$UI_Main_Rule.controls.AddRange((
				$UI_Main_Other_Rule_Not_Find,
				$AddSourcesPath_Wrap
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
					$Get_Temp_Select_Update_Add_Folder = @()
					$UI_Main_Rule.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							$Get_Temp_Select_Update_Add_Folder += $_.Tag
						}
					}

					if ($Get_Temp_Select_Update_Add_Folder -Contains $filename) {
						$UI_Main_Error.Text = $lang.Existed
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					} else {
						$Script:Temp_Select_Custom_Folder_Queue += $filename
						Drive_Add_Refresh_Sources
					}
				} else {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SelectFolder)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.Drive): $($lang.AddTo)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
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
		.可选功能
	#>
	$UI_Main_Adv       = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.不再检查目录里是否存在文件
	#>
	$UI_Main_Dont_Checke_Is_File = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = "$($lang.RuleSkipFolderCheck): *.inf"
		add_Click      = {
			if ($UI_Main_Dont_Checke_Is_File.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -value "False" -String
			}

			Drive_Add_Refresh_Sources
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Dont_Checke_Is_File.Checked = $True
			}
			"False" {
				$UI_Main_Dont_Checke_Is_File.Checked = $False
			}
		}
	} else {
		$UI_Main_Dont_Checke_Is_File.Checked = $False
	}

	<#
		.目录可用时，自动选择
	#>
	$UI_Main_Auto_select_Folder = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 512
		margin         = "18,20,0,0"
		Text           = $lang.RuleFindFolder
	}

		<#
			.目录可用时，自动选择：预置规则
		#>
		$UI_Main_Dont_Checke_Is_RulePre = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 530
			Padding        = "36,0,0,0"
			Text           = $lang.RulePre
			add_Click      = {
				if ($UI_Main_Dont_Checke_Is_RulePre.Checked) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -value "False" -String
				}

				Drive_Add_Refresh_Sources
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Dont_Checke_Is_RulePre.Checked = $True
				}
				"False" {
					$UI_Main_Dont_Checke_Is_RulePre.Checked = $False
				}
			}
		} else {
			$UI_Main_Dont_Checke_Is_RulePre.Checked = $True
		}

		<#
			.目录可用时，自动选择：其它规则
		#>
		$UI_Main_Dont_Checke_Is_RuleOther = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 530
			Padding        = "36,0,0,0"
			Text           = $lang.RuleCustomize
			add_Click      = {
				if ($UI_Main_Dont_Checke_Is_RuleOther.Checked) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -value "False" -String
				}
			
				Drive_Add_Refresh_Sources
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Drive" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Dont_Checke_Is_RuleOther.Checked = $True
				}
				"False" {
					$UI_Main_Dont_Checke_Is_RuleOther.Checked = $False
				}
			}
		} else {
			$UI_Main_Dont_Checke_Is_RuleOther.Checked = $True
		}

	$UI_Main_Rule      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		margin         = "0,35,0,0"
	}

	$UI_Main_Refresh_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.Refresh
		add_Click      = {
			Drive_Add_Refresh_Sources
			Refres_Event_Tasks_Drive_Add_UI

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
			$Get_Temp_Select_Update_Add_Folder = @()
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$Get_Temp_Select_Update_Add_Folder += $_.Tag
				}
			}

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if ($Get_Temp_Select_Update_Add_Folder -Contains $FolderBrowser.SelectedPath) {
					$UI_Main_Error.Text = $lang.Existed
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				} else {
					$Script:Temp_Select_Custom_Folder_Queue += $FolderBrowser.SelectedPath
					Drive_Add_Refresh_Sources
				}
			} else {
				$UI_Main_Error.Text = $lang.UserCanel
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			}
		}
	}
	$UI_Main_Select_Folder_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 100
		Width          = 260
		Location       = "628,95"
		Text           = $lang.DropFolder
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
			Event_Need_Mount_Global_Variable -DevQueue "8" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
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

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = '620,523'
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = '645,525'
		Height         = 30
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
			if (Autopilot_Drive_Add_UI_Save) {

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
				$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_Select.count -gt 0) {
					ForEach ($item in $Temp_Assign_Task_Select) {
						Write-Host "  $($item)" -ForegroundColor Green
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
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Adv,
		$UI_Main_Dont_Checke_Is_File,
		$UI_Main_Auto_select_Folder,
			$UI_Main_Dont_Checke_Is_RulePre,
			$UI_Main_Dont_Checke_Is_RuleOther,

		$UI_Main_Rule
	))

	Drive_Add_Refresh_Sources
	Refres_Event_Tasks_Drive_Add_UI

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Rule.ContextMenuStrip = $UI_Main_Menu

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.Drive): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.Drive): $($lang.AddTo)" -ForegroundColor Yellow
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
		New-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		$Temp_Assign_Task_Select_Is = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$Temp_Assign_Task_Select_Is += $_.Tag
			}
		}

		foreach ($item in $Autopilot) {
			if ($Temp_Assign_Task_Select_Is -notcontains $item) {
				$Script:Temp_Select_Custom_Folder_Queue += $item
			}
		}

		Drive_Add_Refresh_Sources

		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($Autopilot -contains $_.Tag) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		Write-Host "  $($lang.Save): " -NoNewline -ForegroundColor Yellow
		if (Autopilot_Drive_Add_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
			foreach ($item in $Temp_Assign_Task_Select) {
				Write-Host "  $($item)" -ForegroundColor Green
			}
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$Temp_Assign_Task_Select_Is = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$Temp_Assign_Task_Select_Is += $_.Tag
			}
		}

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		foreach ($item in $Temp_Assign_Task_Select) {
			if ($Temp_Assign_Task_Select_Is -notcontains $item) {
				$Script:Temp_Select_Custom_Folder_Queue += $item
			}
		}

		Drive_Add_Refresh_Sources

		if ($Temp_Assign_Task_Select.count -gt 0) {
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Temp_Assign_Task_Select -contains $_.Tag) {
						$_.Checked = $true
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
	.Start processing to add Drive
	.开始处理添加驱动
#>
Function Drive_Add_Process
{
	$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Assign_Task_Select.count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Assign_Task_Select) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

		ForEach ($item in $Temp_Assign_Task_Select) {
			if (Test-Path -Path $item -PathType Container) {
				Get-ChildItem -Path $item -Recurse -include "*.inf" | Where-Object {
					if (Test-Path -Path $_.FullName -PathType Leaf) {
						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Add-WindowsDriver -Path ""$($test_mount_folder_Current)"" -Driver ""$($_.FullName)"" -Recurse -ForceUnsigned" -ForegroundColor Green
							Write-Host "  $('-' * 80)`n"
						}

						Write-Host "  $($_.FullName)" -ForegroundColor Green
						Write-Host "  $($lang.AddTo): " -NoNewline
						Add-WindowsDriver -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Add.log" -Path $test_mount_folder_Current -Driver $_.FullName -Recurse -ForceUnsigned -ErrorAction SilentlyContinue | Out-Null
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

						Write-Host
					}
				}
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}


Function Image_Get_Installed_Drive
{
	param
	(
		[Switch]$View,
		$Save
	)

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

	if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
		$custom_array = @()
		try {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 77)"
				Write-Host "  Get-WindowsDriver -Path ""$($test_mount_folder_Current)"" -All" -ForegroundColor Green
				Write-Host "  $('-' * 77)`n"
			}

			Get-WindowsDriver -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current -All | ForEach-Object {
				$custom_array += [PSCustomObject]@{
					Driver              = $_.Driver
					OriginalFileName    = $_.OriginalFileName
					Inbox               = $_.Inbox
					CatalogFile         = $_.CatalogFile
					ClassName           = $_.ClassName
					ClassGuid           = $_.ClassGuid
					ClassDescription    = $_.ClassDescription
					BootCritical        = $_.BootCritical
					DriveSignature      = $_.DriveSignature
					ProviderName        = $_.ProviderName
					Date                = $_.Date
					Version             = $_.Version
				}
			}
			Write-Host "  $($lang.Operable)" -ForegroundColor Green
		} catch {
			Write-Host "  $($_)" -ForegroundColor Yellow
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		$Get_Index_Now = Image_Get_Mount_Index
		Check_Folder -chkpath $Save
		$TempSaveTo = "$($Save)\Index.$($Get_Index_Now).Drive.$(Get-Date -Format "yyyyMMddHHmmss").csv"

		Write-Host "`n  $($lang.SaveTo)"
		Write-Host "  $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.ViewDrive)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "  User Cancel" -ForegroundColor Red
	} else {
		ForEach (`$item in `$multiple_output) {
			`$custom_array_Export += [PSCustomObject]@{
				Driver           = `$item.Driver
				OriginalFileName = `$item.OriginalFileName
				Inbox            = `$item.Inbox
				CatalogFile      = `$item.CatalogFile
				ClassName        = `$item.ClassName
				ClassGuid        = `$item.ClassGuid
				ClassDescription = `$item.ClassDescription
				BootCritical     = `$item.BootCritical
				DriveSignature   = `$item.DriveSignature
				ProviderName     = `$item.ProviderName
				Date             = `$item.Date
				Version          = `$item.Version
			}
		}

		Add-Type -AssemblyName System.Windows.Forms

		`$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
			Filter    = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
			FileName  = "Export.Drive.`$(Get-Date -Format "yyyyMMddHHmmss")"
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

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}
	} else {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
	}
}