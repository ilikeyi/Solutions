<#
	.Autopilot: Delete update
	.自动驾驶：删除更新
#>
Function Cumulative_updates_Delete_UI_Autopilot
{
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

	Function Refres_Event_Tasks_Update_Del_UI_Autopilot
	{
		<#
			.全局
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
			$GetSelectVer = $GetSelectVer | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

			if ($GetSelectVer.count -gt 0) {
				$UI_Main_Dashboard_Event_Global_Status.Text = "$($lang.Autopilot_Sync_To_Global): $($lang.Enable)"
				$UI_Main_Dashboard_Event_Global_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
			} else {
				$UI_Main_Dashboard_Event_Global_Status.Text = "$($lang.Autopilot_Sync_To_Global): $($lang.EventManagerNo)"
				$UI_Main_Dashboard_Event_Global_Clear.Text = $lang.EventManagerNo
			}
		} else {
			$UI_Main_Dashboard_Event_Global_Status.Text = "$($lang.Autopilot_Sync_To_Global): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Global_Clear.Text = $lang.EventManagerNo
		}

		<#
			.当前
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
			$GetSelectVer = $GetSelectVer | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

			if ($GetSelectVer.Count -gt 0) {
				$UI_Main_Dashboard_Event_Current_Status.Text = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid): $($lang.Enable)"
				$UI_Main_Dashboard_Event_Current_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
			} else {
				$UI_Main_Dashboard_Event_Current_Status.Text = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid): $($lang.Disable)"
				$UI_Main_Dashboard_Event_Current_Clear.Text = $lang.EventManagerNo
			}
		} else {
			$UI_Main_Dashboard_Event_Current_Status.Text = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Current_Clear.Text = $lang.EventManagerNo
		}
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

		Update_Del_Refresh_Sourcs_Autopilot
	}

	Function Update_Del_Refresh_Sourcs_Autopilot
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
							Update_Del_Refresh_Sourcs_Autopilot
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
							Update_Del_Refresh_Sourcs_Autopilot
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

						Update_Del_Refresh_Sources_New_Autopilot -Sources $_.FullName -NewMaster $Global:Primary_Key_Image.Master -ImageName $Global:Primary_Key_Image.ImageFileName

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
							Update_Del_Refresh_Sourcs_Autopilot
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
							Update_Del_Refresh_Sourcs_Autopilot
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

	Function Update_Del_Refresh_Sources_New_Autopilot
	{
		param
		(
			$NewMaster,
			$ImageName,
			$Sources
		)

		$Temp_Assign_Task_Select = @()
		<#
			.全局
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$Temp_Assign_Task_Select = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
		}

		<#
			.当前
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
			$Temp_Assign_Task_Select = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
		}

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
					Update_Del_Refresh_Sourcs_Autopilot
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
					$Get_Temp_Select_Update_Add_Folder = @()
					$UI_Main_Rule.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							$Get_Temp_Select_Update_Add_Folder += $_.Tag
						}
					}

					if ($Get_Temp_Select_Update_Add_Folder -Contains $filename) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.Existed
					} else {
						$Script:Temp_Select_Custom_Folder_Queue += $filename
						Update_Del_Refresh_Sourcs_Autopilot
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
		Text           = "$($lang.CUpdate): $($lang.Del) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
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

	<#
		.全局
	#>
	$UI_Main_Dashboard_Event_Global_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = "$($lang.Autopilot_Sync_To_Global): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Global_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		margin         = "0,0,0,15"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto_Autopilot" -Force -ErrorAction SilentlyContinue | out-null

			Refres_Event_Tasks_Update_Del_UI_Autopilot

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		}
	}

	<#
		.当前
	#>
	$UI_Main_Dashboard_Event_Current_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = "$($lang.Event_Primary_Key): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Current_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -Force -ErrorAction SilentlyContinue | out-null

			Refres_Event_Tasks_Update_Del_UI_Autopilot

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		}
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
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Del_Autopilot" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Del_Autopilot" -value "False" -String
			}

			Update_Del_Refresh_Sourcs_Autopilot
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Del_Autopilot" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Del_Autopilot" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del_Autopilot" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del_Autopilot" -value "False" -String
				}

				Update_Del_Refresh_Sourcs_Autopilot
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del_Autopilot" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Del_Autopilot" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del_Autopilot" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del_Autopilot" -value "False" -String
				}

				Update_Del_Refresh_Sourcs_Autopilot
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del_Autopilot" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Del_Autopilot" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del_Autopilot" -value "True" -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del_Autopilot" -value "False" -String
				}

				Update_Del_Refresh_Sourcs_Autopilot
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del_Autopilot" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Del_Autopilot" -ErrorAction SilentlyContinue) {
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
			Update_Del_Refresh_Sourcs_Autopilot
			Refres_Event_Tasks_Update_Del_UI_Autopilot

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
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Existed
				} else {
					$Script:Temp_Select_Custom_Folder_Queue += $FolderBrowser.SelectedPath
					Update_Del_Refresh_Sourcs_Autopilot
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

	$UI_Main_Event_Sync_To_Global = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Location       = "625,555"
		Text           = "$($lang.SaveTo): $($lang.Autopilot_Sync_To_Global)"
		add_Click      = {
			if ($UI_Main_Event_Sync_To_Global.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_SyncTo_Global_Del_Autopilot" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -name "$(Get_GPS_Location)_Is_Check_SyncTo_Global_Del_Autopilot" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_SyncTo_Global_Del_Autopilot" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update" -Name "$(Get_GPS_Location)_Is_Check_SyncTo_Global_Del_Autopilot" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Event_Sync_To_Global.Checked = $True
			}
			"False" {
				$UI_Main_Event_Sync_To_Global.Checked = $False
			}
		}
	} else {
		$UI_Main_Event_Sync_To_Global.Checked = $True
	}

	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
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
				if ($UI_Main_Event_Sync_To_Global.Checked) {
					Save_Dynamic -regkey "Solutions\Autopilot\Deploy\Update" -name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -value $Temp_Queue_Select_Item -Multi

					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -Force -ErrorAction SilentlyContinue | out-null
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -value $Temp_Queue_Select_Item -Multi
				}

				Refres_Event_Tasks_Update_Del_UI_Autopilot

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
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
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_View_Detailed,
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Sync_To_Global,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Global_Status,
		$UI_Main_Dashboard_Event_Global_Clear,

		$UI_Main_Dashboard_Event_Current_Status,
		$UI_Main_Dashboard_Event_Current_Clear,
		$UI_Main_Adv,
		$UI_Main_Is_Chheck_Mount_Type,
		$UI_Main_Dont_Checke_Is_File,
		$UI_Main_Auto_select_Folder,
			$UI_Main_Dont_Checke_Is_RulePre,
			$UI_Main_Dont_Checke_Is_RuleMultistage,
			$UI_Main_Dont_Checke_Is_RuleOther,

		$UI_Main_Rule_Name,
		$UI_Main_Rule
	))

	Update_Del_Refresh_Sourcs_Autopilot

	$Temp_Assign_Task_Select = @()
	<#
		.全局
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
		$Temp_Assign_Task_Select = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Autopilot\Deploy\Update" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
	}

	<#
		.当前
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue) {
		$Temp_Assign_Task_Select = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Update\Autopilot" -Name "$(Get_GPS_Location)_$(Get_Autopilot_Location)_$($Global:ImageType)_Del_Auto" -ErrorAction SilentlyContinue
	}

	$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	$Get_Temp_Select_Update_Add_Folder = @()
	$UI_Main_Rule.Controls | ForEach-Object {
		if ($_ -is [System.Windows.Forms.CheckBox]) {
			$Get_Temp_Select_Update_Add_Folder += $_.Tag
		}
	}

	if ($Temp_Assign_Task_Select.Count -gt 0) {
		foreach ($item in $Temp_Assign_Task_Select) {
			if ($Get_Temp_Select_Update_Add_Folder -NotContains $item) {
				$Script:Temp_Select_Custom_Folder_Queue += $item
			}
		}
	}

	Update_Del_Refresh_Sourcs_Autopilot
	Refres_Event_Tasks_Update_Del_UI_Autopilot

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

	$UI_Main.ShowDialog() | Out-Null
}