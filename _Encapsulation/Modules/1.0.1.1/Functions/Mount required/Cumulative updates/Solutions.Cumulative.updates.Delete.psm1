<#
	.Delete update
	.删除更新
#>
Function Cumulative_updates_Delete_UI
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
		初始化全局变量
	#>
	$SearchFolderRule = @(
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\$($ArchitectureNew)\Del"
		"$($Global:Image_source)_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\Del"
	)
	$SearchFolderRule = $SearchFolderRule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	$Search_Folder_Multistage_Rule = @(
		Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update"
	)
	$Search_Folder_Multistage_Rule = $Search_Folder_Multistage_Rule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

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

	Function Autopilot_Cumulative_updates_Delete_UI_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		
		$Temp_Get_Select_Queue = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Get_Select_Queue += $_.Tag
					}
				}
			}
		}

		if ($Temp_Get_Select_Queue.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_Update_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			New-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Get_Select_Queue -Force

			<#
				.固化更新
			#>
			New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			if ($GUIUpdateAddCuring.Enabled) {
				if ($GUIUpdateAddCuring.Checked) {
					New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				}
			}

			<#
				.清理取代的
			#>
			New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			if ($UI_Main_Superseded_Rule.Enabled) {
				if ($UI_Main_Superseded_Rule.Checked) {
					New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
				}

				if ($UI_Main_Superseded_Rule_Exclude.Enabled) {
					if ($UI_Main_Superseded_Rule_Exclude.Checked) {
						New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					}
				}
			}

			Refres_Event_Tasks_Update_Del_UI

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			return $True
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			return $False
		}
	}

	Function Refres_Event_Tasks_Update_Del_UI
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_Update_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		Refres_Event_Tasks_Update_Del_UI

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	$UI_Main_Create_New_Tempate_Click = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		
		$RandomGuid = "Example_$(Get-RandomHexNumber -length 5).$(Get-RandomHexNumber -length 3)"

		switch ($Global:Architecture) {
			"arm64" { $ArchitectureNew = "arm64" }
			"AMD64" { $ArchitectureNew = "x64" }
			"x86" { $ArchitectureNew = "x86" }
		}
	
		Check_Folder -chkpath "$($this.Tag)\$($RandomGuid)\$($ArchitectureNew)\Add"
		Check_Folder -chkpath "$($this.Tag)\$($RandomGuid)\$($ArchitectureNew)\Del"

		Update_Del_Refresh_Sourcs
	}

	Function Update_Del_Refresh_Sourcs
	{
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
		[int]$InitControlHeight = 40

		<#
			.预规则，标题
		#>
		if ($SearchFolderRule.Count -gt 0) {
			$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 520
				Padding        = "16,0,0,0"
				Text           = $lang.RulePre
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Pre_Rule)
	
			ForEach ($item in $SearchFolderRule) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }
	
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 490
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
					margin          = "0,5,0,15"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
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
	
				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 40
					Width           = 525
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
	
				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 40
					Width           = 525
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
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value $This.Tag
	
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
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
						.不再检查目录里是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
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
							Update_Del_Refresh_Sourcs
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
			.多级目录规则
		#>
		if ($Search_Folder_Multistage_Rule.Count -gt 0) {
			$UI_Main_Multistage_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 520
				Padding        = "16,0,0,0"
				margin         = "0,20,0,0"
				Text           = $lang.RuleMultistage
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Multistage_Rule_Name)
	
			ForEach ($item in $Search_Folder_Multistage_Rule) {
				$MarkIsFolderRule = $False
				if (Test-Path -Path $item -PathType Container) {
					if((Get-ChildItem $item -Directory -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
						$MarkIsFolderRule = $True
					}
				}
	
				if ($MarkIsFolderRule) {
					$No_Find_Multistage_Rule_Create = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 35
						Width          = 525
						Padding         = "33,0,0,0"
						margin          = "0,8,0,0"
						Text            = $lang.RuleMultistageFindCreateNew
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = $UI_Main_Create_New_Tempate_Click
					}
					$UI_Main_Rule.controls.AddRange($No_Find_Multistage_Rule_Create)

					$No_Find_Multistage_Rule_Create_New_Template = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 35
						Width          = 525
						Padding         = "33,0,0,0"
						margin          = "0,8,0,15"
						Text            = $lang.RuleNewTempate
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Create_Template_UI -Auto -NewDel
							Update_Del_Refresh_Sourcs
						}
					}
					$UI_Main_Rule.controls.AddRange($No_Find_Multistage_Rule_Create_New_Template)

					Get-ChildItem -Path $item -Directory -ErrorAction SilentlyContinue | Where-Object {
						<#
							.添加：文字显示路径
						#>
						$AddSourcesPathName = New-Object system.Windows.Forms.LinkLabel -Property @{
							autosize        = 1
							Padding         = "33,0,15,0"
							margin          = "0,0,0,5"
							Text            = $_.FullName
							Tag             = $_.FullName
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
						$UI_Main_Rule.controls.AddRange($AddSourcesPathName)
		
						Update_Del_Refresh_Sources_New -Sources $_.FullName -NewMaster $Global:Primary_Key_Image.Master -ImageName $Global:Primary_Key_Image.ImageFileName
	
						$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 520
						}
						$UI_Main_Rule.controls.AddRange($AddSourcesPath_Wrap)
					}
				} else {
					$No_Find_Multistage_Rule_Create_New_Template = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 35
						Width          = 525
						Padding         = "33,0,0,0"
						margin          = "0,8,0,15"
						Text            = $lang.RuleNewTempate
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Create_Template_UI -Auto -NewDel
							Update_Del_Refresh_Sourcs
						}
					}
					$UI_Main_Rule.controls.AddRange($No_Find_Multistage_Rule_Create_New_Template)

					$InitLength = $item.Length
					if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }
	
					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
						Width     = 465
						Margin    = "35,0,0,5"
						Text      = $item
						Tag       = $item
						Enabled   = $False
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null
						}
					}
	
					$No_Find_Multistage_Rule = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize        = 1
						Padding         = "49,0,0,0"
						Text            = $lang.RuleMultistageFindFailed
						Tag             = $item
						LinkColor       = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior    = "NeverUnderline"
						add_Click       = $UI_Main_Create_New_Tempate_Click
					}
	
					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 520
					}
					$UI_Main_Rule.controls.AddRange((
						$CheckBox,
						$No_Find_Multistage_Rule,
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
			Width          = 520
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
					margin          = "0,5,0,5"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
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

				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 40
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

				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 40
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
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value $This.Tag
	
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
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
						.不再检查目录里是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
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
							Update_Del_Refresh_Sourcs
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
				Width          = 520
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

	Function Update_Del_Refresh_Sources_New
	{
		param
		(
			$NewMaster,
			$ImageName,
			$Sources
		)

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		<#
			.转换架构类型
		#>
		switch ($Global:Architecture) {
			"arm64" { $ArchitectureNew = "arm64" }
			"AMD64" { $ArchitectureNew = "x64" }
			"x86" { $ArchitectureNew = "x86" }
		}

		$MarkNewFolder = "$($Sources)\$($ArchitectureNew)\Del"
		$AddSourcesPathNoFile = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize        = 1
			Padding         = "71,0,0,0"
			margin          = "0,0,0,15"
			Text            = $lang.RuleNoFindFile
			Tag             = $MarkNewFolder
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

		$CheckBoxInstall = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 35
			Width     = 450
			margin    = "55,0,0,0"
			Text      = "$($ArchitectureNew)\Del"
			Tag       = $MarkNewFolder
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}
		$UI_Main_Rule.controls.AddRange($CheckBoxInstall)

		if (Test-Path -Path $MarkNewFolder -PathType Container) {
			<#
				.目录可用时，自动选择：多级目录规则
			#>
			$Is_Dont_Checke_Is_RuleMultistage = $False
			if ($UI_Main_Dont_Checke_Is_RuleMultistage.Enabled) {
				if ($UI_Main_Dont_Checke_Is_RuleMultistage.Checked) {
					$Is_Dont_Checke_Is_RuleMultistage = $True
				}
			}

			if ($Is_Dont_Checke_Is_RuleMultistage) {
				$CheckBoxInstall.Checked = $True
			} else {
				if ($Temp_Assign_Task_Select -contains $MarkNewFolder) {
					$CheckBoxInstall.Checked = $True
				} else {
					$CheckBoxInstall.Checked = $False
				}
			}

			<#
				.不再检查目录里是否存在文件
			#>
			if ($UI_Main_Dont_Checke_Is_File.Checked) {
				$CheckBoxInstall.Enabled = $True
			} else {
				<#
					.从目录里判断是否有文件
				#>
				if((Get-ChildItem $MarkNewFolder -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
					<#
						.提示，未发现文件
					#>
					$UI_Main_Rule.controls.AddRange($AddSourcesPathNoFile)
					$CheckBoxInstall.Enabled = $False
				} else {
					$CheckBoxInstall.Enabled = $True
				}
			}
		} else {
			$CheckBoxInstall.Enabled = $False

			$AddSourcesPathNoFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
				autosize        = 1
				Padding         = "71,0,0,0"
				Text            = $lang.RuleMatchNoFindFolder
				Tag             = $MarkNewFolder
				LinkColor       = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior    = "NeverUnderline"
				add_Click       = {
					Check_Folder -chkpath $this.Tag
					Update_Del_Refresh_Sourcs
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
					$Get_Temp_Select_Update_Del_Folder = @()
					$UI_Main_Rule.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							$Get_Temp_Select_Update_Del_Folder += $_.Tag
						}
					}

					if ($Get_Temp_Select_Update_Del_Folder -Contains $filename) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.Existed
					} else {
						$Script:Temp_Select_Custom_Folder_Queue += $filename
					}
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
		Text           = "$($lang.CUpdate): $($lang.Del)"
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
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
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
		Height         = 35
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = "$($lang.RuleSkipFolderCheck): $($Global:Search_KB_File_Type)"
		add_Click      = {
			if ($UI_Main_Dont_Checke_Is_File.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Del" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Del" -value "False" -String
			}

			Update_Del_Refresh_Sourcs
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Del" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Del" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del" -value "False" -String
				}

				Update_Del_Refresh_Sourcs
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del" -ErrorAction SilentlyContinue) {
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
			.目录可用时，自动选择：多级目录规则
		#>
		$UI_Main_Dont_Checke_Is_RuleMultistage = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 530
			Padding        = "36,0,0,0"
			Text           = $lang.RuleMultistage
			add_Click      = {
				if ($UI_Main_Dont_Checke_Is_RuleMultistage.Checked) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del" -value "False" -String
				}
			
				Update_Del_Refresh_Sourcs
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Dont_Checke_Is_RuleMultistage.Checked = $True
				}
				"False" {
					$UI_Main_Dont_Checke_Is_RuleMultistage.Checked = $False
				}
			}
		} else {
			$UI_Main_Dont_Checke_Is_RuleMultistage.Checked = $False
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del" -value "False" -String
				}
			
				Update_Del_Refresh_Sourcs
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del" -ErrorAction SilentlyContinue) {
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

	<#
		.固化更新
	#>
	$GUIUpdateAddCuring = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 515
		Margin         = "18,15,0,0"
		Text           = $lang.CuringUpdate
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIUpdateAddCuringTips = New-Object System.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "36,0,0,0"
		Text           = $lang.CuringUpdateTips
	}

	<#
		.清理取代的
	#>
	$UI_Main_Superseded_Rule = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 450
		Margin         = "36,20,0,0"
		Text           = $lang.Superseded
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Superseded_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "52,0,0,10"
		Text           = $lang.SupersededTips
	}
	$UI_Main_Superseded_Rule_Exclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 530
		Padding        = "52,0,0,0"
		Text           = $lang.ExcludeItem
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Superseded_Rule_View_Detailed = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 530
		Padding        = "68,0,0,0"
		Text           = $lang.Exclude_View
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_View_Detailed.Visible = $True
			$UI_Main_View_Detailed_Show.Text = ""

			$UI_Main_View_Detailed_Show.Text += "   $($lang.ExcludeItem)`n"
			ForEach ($item in $Global:ExcludeClearSuperseded) {
				$UI_Main_View_Detailed_Show.Text += "       $($item)`n"
			}
		}
	}

	<#
		.Select the rule
		.选择规则
	#>
	$UI_Main_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,40,0,0"
		Text           = $lang.AddSources
	}
	$UI_Main_Rule      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
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
			Update_Del_Refresh_Sourcs
			Refres_Event_Tasks_Update_Del_UI

			$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.选择目录
	#>
	$UI_Main_Select_Folder = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.SelectFolder
		add_Click      = {
			$Get_Temp_Select_Update_Del_Folder = @()
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$Get_Temp_Select_Update_Del_Folder += $_.Tag
				}
			}

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if ($Get_Temp_Select_Update_Del_Folder -Contains $FolderBrowser.SelectedPath) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Existed
				} else {
					$Script:Temp_Select_Custom_Folder_Queue += $FolderBrowser.SelectedPath
					Update_Del_Refresh_Sourcs
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
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
			Event_Need_Mount_Global_Variable -DevQueue "26" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
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
		Height         = 40
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '636,455'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,523"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,525"
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
			if (Autopilot_Cumulative_updates_Delete_UI_Save) {

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
				$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_Select.count -gt 0) {
					ForEach ($item in $Temp_Assign_Task_Select) {
						Write-Host "  $($item)" -ForegroundColor Green
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.固化更新
				#>
				Write-Host "`n  $($lang.CuringUpdate)" -ForegroundColor Yellow
				New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
				if ($GUIUpdateAddCuring.Enabled) {
					if ($GUIUpdateAddCuring.Checked) {
						Write-Host "  $($lang.Operable)" -ForegroundColor Green

						New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					} else {
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.清理取代的
				#>
				New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
				New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
				Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
				if ($UI_Main_Superseded_Rule.Enabled) {
					if ($UI_Main_Superseded_Rule.Checked) {
						Write-Host "  $($lang.Operable)" -ForegroundColor Green

						New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
					} else {
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}

					if ($UI_Main_Superseded_Rule_Exclude.Enabled) {
						if ($UI_Main_Superseded_Rule_Exclude.Checked) {
							New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
						}
					}
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
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
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Adv,
		$UI_Main_Is_Chheck_Mount_Type,
		$UI_Main_Dont_Checke_Is_File,
		$UI_Main_Auto_select_Folder,
			$UI_Main_Dont_Checke_Is_RulePre,
			$UI_Main_Dont_Checke_Is_RuleMultistage,
			$UI_Main_Dont_Checke_Is_RuleOther,

			$GUIUpdateAddCuring,
		$GUIUpdateAddCuringTips,
		$UI_Main_Superseded_Rule,
		$UI_Main_Superseded_Rule_Tips,
		$UI_Main_Superseded_Rule_Exclude,
		$UI_Main_Superseded_Rule_View_Detailed,
		$UI_Main_Rule_Name,
		$UI_Main_Rule
	))

	<#
		.复选框：清理取代的
	#>
	<#
		.判断 boot.wim
	#>
	if (Image_Is_Select_Boot) {
		<#
			.清理取代的
		#>
		$UI_Main_Superseded_Rule.Checked = $False
		$UI_Main_Superseded_Rule.Enabled = $False
		$UI_Main_Superseded_Rule_Exclude.Enabled = $False

		<#
			.固化更新
		#>
		$GUIUpdateAddCuring.Checked = $False
		$GUIUpdateAddCuring.Enabled = $False
	}

	if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Superseded_Rule.Checked = $True
	} else {
		$UI_Main_Superseded_Rule.Checked = $False
	}

	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$GUIUpdateAddCuring.Checked = $True
	} else {
		$GUIUpdateAddCuring.Checked = $False
	}

	if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Superseded_Rule_Exclude.Checked = $True
	} else {
		$UI_Main_Superseded_Rule_Exclude.Checked = $False
	}

	Update_Del_Refresh_Sourcs
	Refres_Event_Tasks_Update_Del_UI

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIUpdateAddMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIUpdateAddMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIUpdateAddMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Rule.ContextMenuStrip = $GUIUpdateAddMenu

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.CUpdate): $($lang.Del)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.CUpdate): $($lang.Del)" -ForegroundColor Yellow
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
		New-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		$Temp_Assign_Task_Select_Is = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$Temp_Assign_Task_Select_Is += $_.Tag
			}
		}

		foreach ($item in $Autopilot.Path) {
			if ($Temp_Assign_Task_Select_Is -notcontains $item) {
				$Script:Temp_Select_Custom_Folder_Queue += $item
			}
		}

		Update_Del_Refresh_Sourcs

		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($Autopilot.Path -contains $_.Tag) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		<#
			.固化更新
		#>
		if ($Autopilot.IsEvent.CuringUpdate) {
			$GUIUpdateAddCuring.Checked = $True
		} else {
			$GUIUpdateAddCuring.Checked = $False
		}

			if ($Autopilot.IsEvent.Superseded.IsSuperseded) {
				$UI_Main_Superseded_Rule.Checked = $True
			} else {
				$UI_Main_Superseded_Rule.Checked = $False
			}

			if ($Autopilot.IsEvent.Superseded.ExcludeRules) {
				$UI_Main_Superseded_Rule_Exclude.Checked = $True
			} else {
				$UI_Main_Superseded_Rule_Exclude.Checked = $False
			}

		Write-Host "  $($lang.Save): " -NoNewline -ForegroundColor Yellow
		if (Autopilot_Cumulative_updates_Delete_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
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

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		foreach ($item in $Temp_Assign_Task_Select) {
			if ($Temp_Assign_Task_Select_Is -notcontains $item) {
				$Script:Temp_Select_Custom_Folder_Queue += $item
			}
		}

		Update_Del_Refresh_Sourcs

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

Function Autopilot_Cumulative_updates_Delete_UI_Import
{
	param
	(
		$Tasks
	)

	<#
		.测试完成后，检查配置文件里是否有事件
	#>
	if ([string]::IsNullOrEmpty($Tasks)) {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	} else {
		switch ($Tasks.Schome) {
			"Auto" {
				Write-Host "  $($lang.Autopilot_Scheme): " -NoNewline -ForegroundColor Yellow

				<#
					.从公共库里导入，顺序：
						1、当前配置；
						2、全局配置。
				#>
				$New_Tasks_Assign_Auto_Schome = @()

				if ($New_Tasks_Assign_Auto_Schome.Count -le 0) {
					<#
						.当前
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
						$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue

						if ($GetSelectVer.Count -gt 0) {
							Write-Host "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid)"
							$New_Tasks_Assign_Auto_Schome = $GetSelectVer

							Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
							foreach ($item in $GetSelectVer) {
								Write-Host "  $($item)" -ForegroundColor Green
							}
						}
					}
				}

				if ($New_Tasks_Assign_Auto_Schome.Count -le 0) {
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
						$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue

						if ($GetSelectVer.Count -gt 0) {
							Write-Host $lang.Autopilot_Sync_To_Global
							$New_Tasks_Assign_Auto_Schome = $GetSelectVer

							Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
							foreach ($item in $GetSelectVer) {
								Write-Host "  $($item)" -ForegroundColor Green
							}
						}
					}
				}

				if ($New_Tasks_Assign_Auto_Schome.Count -gt 0) {
					$Is_Valid_New_Custom_Path = @()

					foreach ($item in $New_Tasks_Assign_Auto_Schome) {
						if (Test-Path -Path $item -PathType Container) {
							if((Get-ChildItem $item -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
								$Is_Valid_New_Custom_Path += $item
							}
						}
					}

					if ($Is_Valid_New_Custom_Path.count -gt 0) {
						$New_Event = @{
							IsEvent = $Tasks.IsEvent
							Path = $Is_Valid_New_Custom_Path
						}

						Cumulative_updates_Delete_UI -Autopilot $New_Event
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			}
			"Custom" {
				Write-Host "`n  $($lang.RuleCustomize)" -ForegroundColor Yellow

				<#
					.转换配置文件变量
				#>
				$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Tasks.Custom

				$Is_Valid_New_Custom_Path = @()

				foreach ($item in $New_Custom_Path) {
					if (Test-Path -Path $item -PathType Container) {
						if((Get-ChildItem $item -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
							$Is_Valid_New_Custom_Path += $item
						}
					}
				}

				if ($Is_Valid_New_Custom_Path.count -gt 0) {
					$New_Event = @{
						IsEvent = $Tasks.IsEvent
						Path = $Is_Valid_New_Custom_Path
					}

					Cumulative_updates_Delete_UI -Autopilot $New_Event
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			}
		}
	}
}

<#
	.Start processing to add updates
	.开始处理添加更新
#>
Function Update_Del_Process
{
	$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
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
			Get-ChildItem $item -Recurse -Include $Global:Search_KB_File_Type -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path -Path $_.FullName -PathType Leaf) {
					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Remove-WindowsPackage -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($_.FullName)""" -ForegroundColor Green
						Write-Host "  $('-' * 80)`n"
					}
		
					Write-Host "  $($lang.FullName): " -NoNewline -ForegroundColor Yellow
					Write-Host $_.FullName -ForegroundColor Green

					Write-Host "  $($lang.Del): " -NoNewline
					try {
						Remove-WindowsPackage -Path $test_mount_folder_Current -PackagePath $_.FullName -ErrorAction SilentlyContinue | Out-Null
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} catch {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						Write-Host "  $($_)" -ForegroundColor Red
					}

					Write-Host
				}
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}