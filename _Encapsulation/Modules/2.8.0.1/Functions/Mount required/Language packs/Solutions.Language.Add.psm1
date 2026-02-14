<#
	.Add language user interface
	.添加语言用户界面
#>
Function Language_Add_UI
{
	param
	(
		[array]$Autopilot
	)

	<#
		初始化全局变量
	#>
	$Script:Temp_Select_Language_Add_Folder = @()

	$SearchFolderRule = @(
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Language\Add"
		"$(Get_MainMasterFolder)\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Language\Add"
	)
	$SearchFolderRule = $SearchFolderRule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	$Search_Folder_Multistage_Rule = @(
		Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Language"
	)
	$Search_Folder_Multistage_Rule = $Search_Folder_Multistage_Rule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Language_Refresh_Add_Auto_Suggestions
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($UI_Main_Auto_Sync_Suggestions.Enabled) {
			if ($UI_Main_Auto_Sync_Suggestions.Checked) {
				<#
					.Mark: Check the selection status
					.标记：检查选择状态
				#>
				$MarkCheckIsLangSelect = $False

				$UI_Main_Extract_Tips.Text = ""
				$UI_Main_Rule.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Enabled) {
							if ($_.Checked) {
								$MarkCheckIsLangSelect = $True
							}
						}
					}
				}

				if ($MarkCheckIsLangSelect) {
					$UI_Main_Extract_Tips.Text = $lang.LangNewAutoSelectTips
					$UI_Main_Lang_Sync_To_Sources.Checked = $True
					$UI_Main_Lang_Sync_To_Sources.Enabled = $True

					$UI_Main_Language_Ini_Rebuild.Checked = $True
					$UI_Main_Language_Ini_Rebuild.Enabled = $True
				} else {
					$UI_Main_Extract_Tips.Text = $lang.LangNewAutoNoNewSelect
				}
			} else {
				$UI_Main_Extract_Tips.Text = $lang.LangNewAutoNoSelect
			}
		} else {
			New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			$UI_Main_Extract_Tips.Text = ""
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

	Function Autopilot_Language_Add_UI_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$Temp_Select_Add_New_Language_Sources = @()

		<#
			.Mark: Check the selection status
			.标记：检查选择状态
		#>
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Select_Add_New_Language_Sources += $_.Tag
					}
				}
			}
		}

		if ($Temp_Select_Add_New_Language_Sources.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			New-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -Value $Temp_Select_Add_New_Language_Sources -Force

			<#
				.按预规则顺序安装语言包
			#>
			if ($UI_Main_Is_Order_Rule_Lang.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Add_Category_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				$UI_Main_Is_Match_installed_List.Enabled = $True
			} else {
				New-Variable -Scope global -Name "Queue_Is_Language_Add_Category_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				$UI_Main_Is_Match_installed_List.Enabled = $False
			}

			if ($UI_Main_Is_Match_installed_List.Enabled) {
				if ($UI_Main_Is_Match_installed_List.Checked) {
					New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				} else {
					New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				}
			} else {
				New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			}

			<#
				.同步语言包到安装程序
			#>
			New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			if ($UI_Main_Lang_Sync_To_Sources.Enabled) {
			if ($UI_Main_Lang_Sync_To_Sources.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				}
			}

			<#
				.重建 Lang.ini
			#>
			New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			if ($UI_Main_Language_Ini_Rebuild.Enabled) {
				if ($UI_Main_Language_Ini_Rebuild.Checked) {
					New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
				}
			}

			Refres_Event_Tasks_Language_Add_UI

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			return $true
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) $($lang.AddSources)"
			return $false
		}
	}

	Function Refres_Event_Tasks_Language_Add_UI
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force

		Refres_Event_Tasks_Language_Add_UI

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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

		Language_Add_Refresh_Sources
	}

	<#
		.Get pre-configured language settings
		.获取预配置设置的语言
	#>
	Function Language_Add_Refresh_Sources
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Rule.controls.Clear()

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
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

		<#
			.预规则，标题
		#>
		if ($SearchFolderRule.Count -gt 0) {
			$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 525
				Padding        = "16,0,0,0"
				Text           = $lang.RulePre
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Pre_Rule)

			ForEach ($item in $SearchFolderRule) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 493
					Margin    = "35,0,0,10"
					Text      = $item
					Tag       = $item
					add_Click = { Language_Refresh_Add_Auto_Suggestions }
				}
				$UI_Main_Rule.controls.AddRange($CheckBox)

				$AddSourcesPath     = New-Object system.Windows.Forms.LinkLabel -Property @{
					autosize        = 1
					Padding         = "50,0,0,0"
					margin          = "0,0,0,15"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
							} else {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							}
						}
					}
				}

				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 35
					Width           = 525
					Padding         = "47,0,0,0"
					Text            = $lang.OpenFolder
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
							} else {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							}
						}
					}
				}

				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 35
					Width           = 525
					Padding         = "47,0,0,0"
					Text            = $lang.Paste
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value $This.Tag

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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
						.判断目录里，是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
							<#
								.提示，未发现文件
							#>

							$UI_Main_Rule.controls.AddRange($AddSourcesPath)
							$CheckBox.Enabled = $False
						} else {
							$CheckBox.Enabled = $True
						}
					}

					$UI_Main_Rule.controls.AddRange((
						$AddSourcesPathOpen,
						$AddSourcesPathPaste
					))
				} else {
					$CheckBox.Enabled = $False
					$AddSourcesPathNoFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize        = 1
						Padding         = "47,0,0,0"
						Text            = $lang.RuleMatchNoFindFolder
						Tag             = $item
						LinkColor       = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Check_Folder -chkpath $this.Tag
							Language_Add_Refresh_Sources
						}
					}

					$UI_Main_Rule.controls.AddRange($AddSourcesPathNoFolder)
				}

				$Add_Pre_Rule_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 525
				}

				$UI_Main_Rule.controls.AddRange($Add_Pre_Rule_Wrap)
			}
		}

		<#
			.多级目录规则
		#>
		if ($Search_Folder_Multistage_Rule.Count -gt 0) {
			$UI_Main_Multistage_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 525
				Padding        = "16,0,0,0"
				Margin         = "0,20,0,0"
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
						autosize        = 1
						Padding         = "33,0,0,0"
						margin          = "0,8,0,15"
						Text            = $lang.RuleMultistageFindCreateNew
						Tag             = $item
						LinkColor       = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior    = "NeverUnderline"
						add_Click       = $UI_Main_Create_New_Tempate_Click
					}
					$UI_Main_Rule.controls.AddRange($No_Find_Multistage_Rule_Create)

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
							LinkColor       = "#008000"
							ActiveLinkColor = "#FF0000"
							LinkBehavior    = "NeverUnderline"
							add_Click       = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null

								if ([string]::IsNullOrEmpty($This.Tag)) {
									$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
									$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
								} else {
									if (Test-Path -Path $This.Tag -PathType Container) {
										Start-Process $This.Tag

										$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
										$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
									} else {
										$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
										$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
									}
								}
							}
						}
						$UI_Main_Rule.controls.AddRange($AddSourcesPathName)

						Language_Add_Refresh_Sources_New -Sources $_.FullName -ImageMaster $Global:Primary_Key_Image.Master -ImageName $Global:Primary_Key_Image.ImageFileName

						$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 525
						}
						$UI_Main_Rule.controls.AddRange($AddSourcesPath_Wrap)
					}
				} else {
					$InitLength = $item.Length
					if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
						Width     = 493
						Margin    = "35,0,0,5"
						Text      = $item
						Tag       = $item
						Enabled   = $False
						add_Click = { Language_Refresh_Add_Auto_Suggestions }
					}

					$No_Find_Multistage_Rule = New-Object system.Windows.Forms.LinkLabel -Property @{
						autosize        = 1
						Padding         = "47,0,0,0"
						Text            = $lang.RuleMultistageFindFailed
						Tag             = $item
						LinkColor       = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior    = "NeverUnderline"
						add_Click       = $UI_Main_Create_New_Tempate_Click
					}

					$AddSourcesPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 525
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
			Width          = 525
			Padding        = "18,0,0,0"
			Margin         = "0,35,0,0"
			Text           = $lang.RuleCustomize
		}
		$UI_Main_Rule.controls.AddRange($UI_Main_Other_Rule)
		if ($Script:Temp_Select_Language_Add_Folder.count -gt 0) {
			ForEach ($item in $Script:Temp_Select_Language_Add_Folder) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 493
					Margin    = "35,0,0,5"
					Text      = $item
					Tag       = $item
					add_Click = { Language_Refresh_Add_Auto_Suggestions }
				}
				$UI_Main_Rule.controls.AddRange($CheckBox)

				$AddSourcesPath     = New-Object system.Windows.Forms.LinkLabel -Property @{
					autosize        = 1
					Padding         = "50,0,0,0"
					margin          = "0,0,0,15"
					Text            = $lang.RuleNoFindFile
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
							} else {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							}
						}
					}
				}

				$AddSourcesPathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 35
					Width           = 525
					Padding         = "47,0,0,0"
					Text            = $lang.OpenFolder
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						} else {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
							} else {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
							}
						}
					}
				}

				$AddSourcesPathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height          = 35
					Width           = 525
					Padding         = "47,0,0,0"
					Text            = $lang.Paste
					Tag             = $item
					LinkColor       = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior    = "NeverUnderline"
					add_Click       = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value $This.Tag

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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
						.判断目录里，是否存在文件
					#>
					if ($UI_Main_Dont_Checke_Is_File.Checked) {
						$CheckBox.Enabled = $True
					} else {
						<#
							.从目录里判断是否有文件
						#>
						if((Get-ChildItem $item -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
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
						Width          = 525
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
						Padding         = "47,0,0,0"
						Text            = $lang.RuleMatchNoFindFolder
						Tag             = $item
						LinkColor       = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior    = "NeverUnderline"
						add_Click       = {
							Check_Folder -chkpath $this.Tag
							Language_Add_Refresh_Sources
						}
					}
					$UI_Main_Rule.controls.AddRange($AddSourcesPathNoFolder)
				}
			}
		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 525
				Padding        = "33,0,0,0"
				Text           = $lang.NoWork
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		}

		$Add_Other_Rule_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 525
		}
		$UI_Main_Rule.controls.AddRange($Add_Other_Rule_Wrap)

		Language_Refresh_Add_Auto_Suggestions
	}

	Function Language_Add_Refresh_Sources_New
	{
		param
		(
			$ImageMaster,
			$ImageName,
			$Sources
		)

		<#
			.转换架构类型
		#>
		switch ($Global:Architecture) {
			"arm64" { $ArchitectureNew = "arm64" }
			"AMD64" { $ArchitectureNew = "x64" }
			"x86" { $ArchitectureNew = "x86" }
		}

		$MarkNewFolder = "$($Sources)\$($ArchitectureNew)\Add"
		$AddSourcesPathNoFile = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize        = 1
			Padding         = "71,0,0,0"
			margin          = "0,0,0,15"
			Text            = $lang.RuleNoFindFile
			Tag             = $MarkNewFolder
			LinkColor       = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior    = "NeverUnderline"
			add_Click       = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				} else {
					if (Test-Path -Path $This.Tag -PathType Container) {
						Start-Process $This.Tag

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					}
				}
			}
		}

		$CheckBoxInstall = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 35
			Width     = 450
			margin    = "55,0,0,0"
			Text      = "$($ArchitectureNew)\Add"
			Tag       = $MarkNewFolder
			add_Click = { Language_Refresh_Add_Auto_Suggestions }
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
				if((Get-ChildItem $MarkNewFolder -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
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
				LinkColor       = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior    = "NeverUnderline"
				add_Click       = {
					Check_Folder -chkpath $this.Tag
					Language_Add_Refresh_Sources
				}
			}
	
			$UI_Main_Rule.controls.AddRange($AddSourcesPathNoFolder)
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
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.Existed
					} else {
						$Script:Temp_Select_Language_Add_Folder += $filename
						Language_Add_Refresh_Sources
					}
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SelectFolder)"
				}
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.Language): $($lang.AddTo)"
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
		Padding        = "0,20,0,0"
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
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	$UI_Main_Adv       = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.按预规则顺序安装语言包
	#>
	$UI_Main_Is_Order_Rule_Lang = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		ForeColor      = "#008000"
		Padding        = "18,0,0,0"
		Text           = $lang.OrderRuleLang
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Is_Order_Rule_Lang_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "36,0,0,10"
		Text           = $lang.OrderRuleLangTips
	}

	<#
		.安装语言包时，从已安装列表里通配
	#>
	$UI_Main_Is_Match_installed_List = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		ForeColor      = "#008000"
		Padding        = "35,0,0,0"
		Text           = $lang.Match_installed_List
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Is_Match_installed_List.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			}
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Is_Match_installed_List.Checked = $True
	} else {
		$UI_Main_Is_Match_installed_List.Checked = $False
	}

	$UI_Main_Is_Match_installed_List_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "50,0,0,0"
		Text           = $lang.Match_installed_List_Tips
	}

	<#
		.初始化复选框：按预规则顺序安装语言包
	#>
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_Category_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$UI_Main_Is_Order_Rule_Lang.Checked = $True
		$UI_Main_Is_Match_installed_List.Enabled = $True       # 安装语言包时，从已安装列表里通配
	} else {
		$UI_Main_Is_Order_Rule_Lang.Checked = $False
		$UI_Main_Is_Match_installed_List.Enabled = $False      # 安装语言包时，从已安装列表里通配
	}

	$UI_Main_Is_Match_installed_List_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 530
		Padding        = "35,0,0,0"
		margin         = "0,20,0,0"
		Text           = $lang.LXPsAddDelTipsView
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_Mask_Tips.Visible = $True
		}
	}

	<#
		.不再检查目录里是否存在文件
	#>
	$UI_Main_Dont_Checke_Is_File = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = "$($lang.RuleSkipFolderCheck): $($Global:Search_Language_File_Type)"
		add_Click      = {
			if ($UI_Main_Dont_Checke_Is_File.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -value "False"
			}

			Language_Add_Refresh_Sources
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Skip_Check_File_Add" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -value "True"
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -value "False"
				}

				Language_Add_Refresh_Sources
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_Available_Add" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Add" -value "True"
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Add" -value "False"
				}

				Language_Add_Refresh_Sources
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Add" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleMultistage_Add" -ErrorAction SilentlyContinue) {
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
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -value "True"
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -value "False"
				}

				Language_Add_Refresh_Sources
			}
		}
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_Is_Check_Folder_RuleOther_Add" -ErrorAction SilentlyContinue) {
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

	$UI_Main_Extract_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 180
		Width          = 278
		Location       = "622,135"
		Text           = $lang.AddSources
	}

	<#
		.遇到 boot.wim 时
	#>
	$UI_Main_Find_Boot_Mount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Padding        = "18,0,0,0"
		Margin         = "0,25,0,0"
		Text           = $($lang.BootProcess -f "boot")
	}
	$UI_Main_Auto_Sync_Suggestions = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.LangNewAutoSelect
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_AllowAutoSelectSuggestions" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "$(Get_GPS_Location)_AllowAutoSelectSuggestions" -value "False"
			}

			<#
				.刷新通知
			#>
			Language_Refresh_Add_Auto_Suggestions
		}
	}

	<#
		.同步语言包到安装程序
	#>
	$UI_Main_Lang_Sync_To_Sources = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "35,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.BootSyncToISO
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Lang_Sync_To_Sources.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			}
		}
	}
	$UI_Main_Lang_Sync_To_Sources_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "50,0,0,0"
		Text           = $lang.BootSyncToISOTips
	}

	<#
		.重建 Lang.ini
	#>
	$UI_Main_Language_Ini_Rebuild = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "35,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.LangIni
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Language_Ini_Rebuild.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
			}
		}
	}
	$UI_Main_Language_Ini_Rebuild_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "50,0,0,0"
		Text           = $lang.LangIniTips
	}

	<#
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
	$UI_Main_Refresh   = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.Refresh
		add_Click      = {
			Language_Add_Refresh_Sources

			$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Existed
				} else {
					$Script:Temp_Select_Language_Add_Folder += $FolderBrowser.SelectedPath
					Language_Add_Refresh_Sources
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}

	<#
		.提取语言
	#>
	$UI_Main_Extract   = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 280
		Location       = "620,90"
		Text           = $lang.LanguageExtract
		add_Click      = {
			Language_Extract_UI -Add
			Language_Add_Refresh_Sources
		}
	}

	<#
		.显示提示蒙层
	#>
	$UI_Main_Mask_Tips = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 928
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Tips_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 555
		Width          = 885
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Mask_Tips_Global_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,607"
		Height         = 30
		Width          = 550
		Text           = $lang.LXPsAddDelTipsGlobal
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Mask_Tips_Global_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningLanguageGlobal" -value "True"
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningLanguageGlobal" -value "False"
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	$UI_Main_Mask_Tips_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 30
		Width          = 550
		Text           = $lang.LXPsAddDelTips
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Mask_Tips_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "TipsWarningLanguage" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -name "TipsWarningLanguage" -value "False"
			}
		}
	}
	$UI_Main_Mask_Tips_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Mask_Tips.Visible = $False
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
			Event_Need_Mount_Global_Variable -DevQueue "18" -Uid $Global:Primary_Key_Image.Uid -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
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
		Width          = 430
		Text           = $lang.SuggestedSkip
		Location       = '620,390'
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
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
			if (Autopilot_Language_Add_UI_Save) {

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
				$Temp_Language_Add_Custom_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Language_Add_Custom_Select.count -gt 0) {
					ForEach ($item in $Temp_Language_Add_Custom_Select) {
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
		$UI_Main_Mask_Tips,
		$UI_Main_Menu,
		$UI_Main_Select_Folder,
		$UI_Main_Refresh,
		$UI_Main_Extract,
		$UI_Main_Extract_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Mask_Tips.controls.AddRange((
		$UI_Main_Mask_Tips_Results,
		$UI_Main_Mask_Tips_Global_Do_Not,
		$UI_Main_Mask_Tips_Do_Not,
		$UI_Main_Mask_Tips_Hide
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Adv,
		$UI_Main_Is_Order_Rule_Lang,
		$UI_Main_Is_Order_Rule_Lang_Tips,
		$UI_Main_Is_Match_installed_List,
		$UI_Main_Is_Match_installed_List_Tips,
		$UI_Main_Is_Match_installed_List_View,
		$UI_Main_Dont_Checke_Is_File,
		$UI_Main_Auto_select_Folder,
			$UI_Main_Dont_Checke_Is_RulePre,
			$UI_Main_Dont_Checke_Is_RuleMultistage,
			$UI_Main_Dont_Checke_Is_RuleOther,

		<#
			.遇到 boot.wim 时
		#>
		$UI_Main_Find_Boot_Mount,
		$UI_Main_Auto_Sync_Suggestions,
		$UI_Main_Lang_Sync_To_Sources,
		$UI_Main_Lang_Sync_To_Sources_Tips,
		$UI_Main_Language_Ini_Rebuild,
		$UI_Main_Language_Ini_Rebuild_Tips,
		$UI_Main_Rule_Name,
		$UI_Main_Rule
	))

	$UI_Main_Mask_Tips_Results.Text += $lang.RuleLanguageTips

	ForEach ($item in $Global:Search_File_Order) {
		<#
			.1 = 基本
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Basic): $($item.Basic.Count) $($lang.EventManagerCount)`n"
		ForEach ($Basic in $item.Basic) {
			$UI_Main_Mask_Tips_Results.Text += "      $($Basic)`n"
		}

		<#
			.2 = 字体
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Fonts): $($item.Fonts.Count) $($lang.EventManagerCount)`n"
		ForEach ($Fonts in $item.Fonts) {
			$UI_Main_Mask_Tips_Results.Text += "      $($Fonts)`n"
		}

		<#
			.3 = OCR
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.OCR): $($item.OCR.Count) $($lang.EventManagerCount)`n"
		ForEach ($OCR in $item.OCR) {
			$UI_Main_Mask_Tips_Results.Text += "      $($OCR)`n"
		}

		<#
			.4 = 手写内容识别
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Handwriting): $($item.Basic.Count) $($lang.EventManagerCount)`n"
		ForEach ($Handwriting in $item.Handwriting) {
			$UI_Main_Mask_Tips_Results.Text += "      $($Handwriting)`n"
		}

		<#
			.5 = 文本转语音
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.TextToSpeech): $($item.TextToSpeech.Count) $($lang.EventManagerCount)`n"
		ForEach ($TextToSpeech in $item.TextToSpeech) {
			$UI_Main_Mask_Tips_Results.Text += "      $($TextToSpeech)`n"
		}

		<#
			.6 = 语音识别
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Speech): $($item.Speech.Count) $($lang.EventManagerCount)`n"
		ForEach ($Speech in $item.Speech) {
			$UI_Main_Mask_Tips_Results.Text += "      $($Speech)`n"
		}

		<#
			.7 = 零售演示体验
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Retail): $($item.Retail.Count) $($lang.EventManagerCount)`n"
		ForEach ($Retail in $item.Retail) {
			$UI_Main_Mask_Tips_Results.Text += "      $($Retail)`n"
		}

		<#
			.8 = 按需功能
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.Features_On_Demand): $($item.Features_On_Demand.Count) $($lang.EventManagerCount)`n"
		ForEach ($FeaturesOnDemand in $item.Features_On_Demand) {
			$UI_Main_Mask_Tips_Results.Text += "      $($FeaturesOnDemand)`n"
		}

		<#
			.9 = 特定包
		#>
		$UI_Main_Mask_Tips_Results.Text += "`n   $($lang.RegionSpecific): $($item.RegionSpecific.Count) $($lang.EventManagerCount)`n"
		ForEach ($RegionSpecific in $item.RegionSpecific) {
			$UI_Main_Mask_Tips_Results.Text += "      $($RegionSpecific)`n"
		}
	}

	$UI_Main_Mask_Tips_Results.Text += $lang.RuleLanguageTipsExt

	<#
		.判断 boot.wim
	#>
	if (Image_Is_Select_Boot) {
		$UI_Main_Auto_Sync_Suggestions.Enabled = $True
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_AllowAutoSelectSuggestions" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "$(Get_GPS_Location)_AllowAutoSelectSuggestions" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Auto_Sync_Suggestions.Checked = $True
				}
				"False" {
					$UI_Main_Auto_Sync_Suggestions.Checked = $False
				}
			}
		} else {
			$UI_Main_Auto_Sync_Suggestions.Checked = $True
		}

		<#
			.同步语言包到安装程序
		#>
		$UI_Main_Lang_Sync_To_Sources.Enabled = $True
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Lang_Sync_To_Sources.Checked = $True
		} else {
			$UI_Main_Lang_Sync_To_Sources.Checked = $False
		}

		<#
			.重建 Lang.ini
		#>
		$UI_Main_Language_Ini_Rebuild.Enabled = $True
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Language_Ini_Rebuild.Checked = $True
		} else {
			$UI_Main_Language_Ini_Rebuild.Checked = $False
		}
	} else {
		$UI_Main_Auto_Sync_Suggestions.Checked = $False
		$UI_Main_Auto_Sync_Suggestions.Enabled = $False
		$UI_Main_Lang_Sync_To_Sources.Checked = $False
		$UI_Main_Lang_Sync_To_Sources.Enabled = $False
		$UI_Main_Language_Ini_Rebuild.Checked = $False
		$UI_Main_Language_Ini_Rebuild.Enabled = $False
	}

	Language_Add_Refresh_Sources
	Refres_Event_Tasks_Language_Add_UI

	<#
		.提示
	#>
	$MarkShowNewTips = $True
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TipsWarningLanguageGlobal" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TipsWarningLanguageGlobal" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $False
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $True
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			}
			"False" {
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $False
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "TipsWarningLanguage" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Language" -Name "TipsWarningLanguage" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $False
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
	$UI_Main_Menu_Right = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Right.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Right.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Rule.ContextMenuStrip = $UI_Main_Menu_Right

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		Write-Host "`n  $($lang.Language): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.Language): $($lang.AddTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

		<#
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
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		<#
			.按预规则顺序安装语言包
		#>
		if ($Autopilot.Adv.PreRuleOrder) {
			$UI_Main_Is_Order_Rule_Lang.Checked = $true
			$UI_Main_Is_Match_installed_List.Enabled = $True
		} else {
			$UI_Main_Is_Order_Rule_Lang.Checked = $False
			$UI_Main_Is_Match_installed_List.Enabled = $False
		}

		<#
			.安装语言包时，从已安装列表里通配
		#>
		if ($Autopilot.Adv.WildcardList) {
			$UI_Main_Is_Match_installed_List.Checked = $true
		} else {
			$UI_Main_Is_Match_installed_List.Checked = $False
		}

		<#
			.不再检查目录里是否存在文件
		#>
		if ($Autopilot.Adv.NoCheckFileType) {
			$UI_Main_Dont_Checke_Is_File.Checked = $true
		} else {
			$UI_Main_Dont_Checke_Is_File.Checked = $False
		}

		<#
			.有事件时自动选择建议项
		#>
		if ($Autopilot.Adv.AutoSuggestions) {
			$UI_Main_Auto_Sync_Suggestions.Checked = $true
		} else {
			$UI_Main_Auto_Sync_Suggestions.Checked = $False
		}

			<#
				.遇到 boot.wim 时
			#>
				<#
					.同步语言包到安装程序
				#>
				if ($Autopilot.Adv.LangSyncToSources) {
					$UI_Main_Lang_Sync_To_Sources.Checked = $true
				} else {
					$UI_Main_Lang_Sync_To_Sources.Checked = $False
				}

				<#
					.重建 Lang.ini
				#>
				if ($Autopilot.Adv.LangIniRebuild) {
					$UI_Main_Language_Ini_Rebuild.Checked = $true
				} else {
					$UI_Main_Language_Ini_Rebuild.Checked = $False
				}

		Language_Refresh_Add_Auto_Suggestions

		$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.Source

		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($New_Custom_Path -contains $_.Text) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		if (Autopilot_Language_Add_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$Temp_Language_Add_Custom_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value

		if ($Temp_Language_Add_Custom_Select.count -gt 0) {
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Temp_Language_Add_Custom_Select -contains $_.Text) {
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
	.Processing adding languages
	.处理添加语言
#>
Function Language_Add_Process
{
	$Temp_Language_Add_Custom_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Language_Add_Custom_Select.count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Language_Add_Custom_Select) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		<#
			.按预规则顺序安装语言包
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_Category_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$Region = Language_Region
			ForEach ($item in $Temp_Language_Add_Custom_Select) {
				[int]$SNTasks = "0"

				ForEach ($itemRegion in $Region) {
					$FullNewPath = "$($item)\$($itemRegion.Region)"

					if (Test-Path -Path $FullNewPath -PathType Container) {
						$SNTasks++

						<#
							.安装语言包时，从已安装列表里通配
						#>
						if ((Get-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
							Language_Add_Rule_Process -Sources $FullNewPath -NewLang "$($itemRegion.Region)"
						} else {
							Get-ChildItem -Path "$($FullNewPath)\*" -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
								Language_Add_File_Type_Process -FileName $_.FullName -SNTasks $SNTasks -Group $lang.OrderRuleLang
							}
						}
					}
				}

				<#
					.添加根目录下的其它文件
				#>
				Get-ChildItem -Path "$($item)\*" -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
					Language_Add_File_Type_Process -FileName $_.FullName -SNTasks $SNTasks -Group $lang.RuleOther
				}
			}
		} else {
			<#
				.不按预规则顺序安装语言包，直接获取后添加
			#>
			ForEach ($item in $Temp_Language_Add_Custom_Select) {
				[int]$SNTasks = "0"

				Get-ChildItem -Path $item -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
					if (Test-Path -Path $_.FullName -PathType Leaf) {
						$SNTasks++

						Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
						Write-Host $_.FullName -ForegroundColor Green

						Language_Add_File_Type_Process -FileName $_.FullName -SNTasks $SNTasks -Group $lang.RuleOther
					}
				}
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

Function Language_Add_File_Type_Process
{
	param
	(
		$FileName,
		$SNTasks,
		$Group
	)

	if ($Script:Init_Exclude_File -contains $FileName) {
		Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
		Write-Host $FileName -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.ExcludeItem)" -ForegroundColor Red
		Write-Host
	} else {
		<#
			.初始化每任务运行时间
		#>
		$UpdateTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$UpdateTasksTime = New-Object System.Diagnostics.Stopwatch
		$UpdateTasksTime.Reset()
		$UpdateTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($UpdateTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
		Write-Host $SNTasks -NoNewline -ForegroundColor Green
		Write-host " $($lang.EventManagerCount)"

		Write-host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
		Write-Host $Group -ForegroundColor Green

		Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
		Write-Host $FileName -ForegroundColor Green

		$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
		$CommandNew = "Add-WindowsPackage -ScratchDirectory ""$(Get_Mount_To_Temp)"" -LogPath ""$(Get_Mount_To_Logs)\Add.log"" -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($FileName)"" -ErrorAction SilentlyContinue | Out-Null"
		$CommandNewPrint = "Add-WindowsPackage -Path ""$($test_mount_folder_Current)"" -PackagePath ""$($FileName)"""

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($CommandNewPrint)" -ForegroundColor Green
		}

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
		try {
			Invoke-Expression -Command $CommandNew
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} catch {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			Write-Host "  $($_)" -ForegroundColor Red
		}

		$UpdateTasksTime.Stop()
		Write-Host "`n  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host $UpdateTasksTime.Elapsed -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($UpdateTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host
	}
}

Function Language_Add_Rule_Process
{
	param
	(
		$Sources,
		$NewLang
	)

	<#
		.所有文件
	#>
	$Script:Init_Folder_All_File = @()
	Get-ChildItem -Path $Sources -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
		$Script:Init_Folder_All_File += $_.FullName
	}

	<#
		.排除安装的文件
	#>
	$Script:Init_Exclude_File = @()

	<#
		.已匹配成功的文件
	#>
	$Script:Init_Folder_All_File_Match_Done = @()

	<#
		.未匹配到的文件：其它分类
	#>
	$Script:Init_Folder_All_File_Exclude = @()

	<#
		.语言包分类：字体
	#>
	$Script:Init_File_Type_Fonts = @()

	<#
		.语言包分类：基本
	#>
	$Script:Init_File_Type_Basic = @()

	<#
		.语言包分类：光学字符识别
	#>
	$Script:Init_File_Type_OCR = @()

	<#
		.语言包分类：手写内容识别
	#>
	$Script:Init_File_Type_Handwriting = @()

	<#
		.语言包分类：文本转语音
	#>
	$Script:Init_File_Type_TextToSpeech = @()

	<#
		.语音识别
	#>
	$Script:Init_File_Type_Speech = @()

	<#
		.语言包分类：零售演示体验
	#>
	$Script:Init_File_Type_Retail = @()

	<#
		.语言包分类：按需功能
	#>
	$Script:Init_File_Type_Features_On_Demand = @()

	<#
		.语言包分类：其他区域特定的要求
	#>
	$Script:Init_File_Type_Other_Region_Specific = @()

	Write-Host "  $($lang.LanguageCode): " -NoNewline
	Write-Host $NewLang -ForegroundColor Green

	Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($Sources)" -ForegroundColor Green

	if ($Script:Init_Folder_All_File.Count -gt 0) {
		Write-Host "`n  $($lang.LXPsWaitAdd): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($Script:Init_Folder_All_File.Count) $($lang.EventManagerCount)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Script:Init_Folder_All_File) {
			Write-Host "  $([IO.Path]::GetFileName($item))" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.InCategory)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:Search_File_Order) {
			<#
				.1 = 字体
			#>
			ForEach ($Fonts in $item.Fonts) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $Fonts) {
						$Script:Init_File_Type_Fonts += [pscustomobject]@{
							Match    = $item.Fonts
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.2 = 基本
			#>
			ForEach ($Basic in $item.Basic) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $Basic) {
						$Script:Init_File_Type_Basic += [pscustomobject]@{
							Match    = $Basic
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.3 = OCR
			#>
			ForEach ($OCR in $item.OCR) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $OCR) {
						$Script:Init_File_Type_OCR += [pscustomobject]@{
							Match    = $OCR
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done +=$WildCard
					}
				}
			}

			<#
				.4 = 手写内容识别
			#>
			ForEach ($Handwriting in $item.Handwriting) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $Handwriting) {
						$Script:Init_File_Type_Handwriting += [pscustomobject]@{
							Match    = $Handwriting
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.5 = 文本转语音
			#>
			ForEach ($TextToSpeech in $item.TextToSpeech) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $TextToSpeech) {
						$Script:Init_File_Type_TextToSpeech += [pscustomobject]@{
							Match    = $TextToSpeech
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.6 = 语音识别
			#>
			ForEach ($Speech in $item.Speech) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $Speech) {
						$Script:Init_File_Type_Speech += [pscustomobject]@{
							Match    = $Speech
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.7 = 零售演示体验
			#>
			ForEach ($Retail in $item.Retail) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $Retail) {
						$Script:Init_File_Type_Retail += [pscustomobject]@{
							Match    = $Retail
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.8 = 按需功能
			#>
			ForEach ($FeaturesOnDemand in $item.Features_On_Demand) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $FeaturesOnDemand) {
						$Script:Init_File_Type_Features_On_Demand += [pscustomobject]@{
							Match    = $FeaturesOnDemand
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.9 = 其他区域特定的要求
			#>
			ForEach ($RegionSpecific in $item.RegionSpecific) {
				ForEach ($WildCard in $Script:Init_Folder_All_File) {
					if ([IO.Path]::GetFileName($WildCard) -like $RegionSpecific) {
						$Script:Init_File_Type_Other_Region_Specific += [pscustomobject]@{
							Match    = $RegionSpecific
							FileName = $WildCard
						}
						$Script:Init_Folder_All_File_Match_Done += $WildCard
					}
				}
			}

			<#
				.10 = 语言包其它
			#>
			ForEach ($item in $Script:Init_Folder_All_File) {
				if ($Script:Init_Folder_All_File_Match_Done -notcontains $item) {
					$Script:Init_Folder_All_File_Exclude += $item
				}
			}
		}
		Write-Host "  $($lang.Done)" -ForegroundColor Green

		<#
			.获取当前组件状态
		#>
		$Initl_install_Language_Component = @()

		<#
			.初始化复选框：安装语言包时，从已安装列表里通配
		#>
		Write-Host "`n  $($lang.Match_installed_List)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($lang.UpdateAvailable)`n" -ForegroundColor Green

			Language_Rule_Add_group
		} else {
			Write-Host "  $($lang.UpdateUnavailable)`n" -ForegroundColor Red
		}

		Language_Rule_Add_View_And_Process

		Language_Rule_Add_View_And_Process -install
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.分组
#>
Function Language_Rule_Add_group
{
	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	try {
		Get-WindowsPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current | ForEach-Object {
			$Initl_install_Language_Component += $_.PackageName
		}
		Write-Host "  $($lang.Operable)" -ForegroundColor Green
	} catch {
		Write-Host "  $($_)" -ForegroundColor Red
		Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
		Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		return
	}

	Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	foreach ($item in $Initl_install_Language_Component) {
		Write-Host "  $($item)" -ForegroundColor Green
	}

	Write-Host "`n  $($lang.InCategory)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	<#
		.OCR
	#>
	Write-Host "  $($lang.OCR): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_OCR.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_OCR.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_OCR) {
			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
			Write-Host $Fonts.FileName -ForegroundColor Green

			Write-Host
		}

		Write-Host "  $($lang.LanguageExtractSearch)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_OCR) {
			$Mark_Is_Match = $True

			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			ForEach ($WildCard in $Initl_install_Language_Component) {
				if ($WildCard -like $Fonts.Match) {
					$Mark_Is_Match = $false
					Write-Host "  $($lang.Matched_Component_Names)" -NoNewline
					Write-Host $WildCard -ForegroundColor Green

					Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
					Write-Host $Fonts.FileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
					break
				}
			}

			if ($Mark_Is_Match) {
				Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
				Write-Host $Fonts.FileName -ForegroundColor Red

				Write-Host "  " -NoNewline
				Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host

				$Script:Init_Exclude_File += $Fonts.FileName
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Handwriting
	#>
	Write-Host "`n  $($lang.Handwriting): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Handwriting.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Handwriting.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Handwriting) {
			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
			Write-Host $Fonts.FileName -ForegroundColor Green

			Write-Host
		}

		Write-Host "  $($lang.LanguageExtractSearch)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Handwriting) {
			$Mark_Is_Match = $True

			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			ForEach ($WildCard in $Initl_install_Language_Component) {
				if ($WildCard -like $Fonts.Match) {
					$Mark_Is_Match = $false
					Write-Host "  $($lang.Matched_Component_Names)" -NoNewline
					Write-Host $WildCard -ForegroundColor Green

					Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
					Write-Host $Fonts.FileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
					break
				}
			}

			if ($Mark_Is_Match) {
				Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
				Write-Host $Fonts.FileName -ForegroundColor Red

				Write-Host "  " -NoNewline
				Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host

				$Script:Init_Exclude_File += $Fonts.FileName
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.TextToSpeech
	#>
	Write-Host "`n  $($lang.TextToSpeech): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_TextToSpeech.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_TextToSpeech.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_TextToSpeech) {
			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
			Write-Host $Fonts.FileName -ForegroundColor Green

			Write-Host
		}

		Write-Host "  $($lang.LanguageExtractSearch)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_TextToSpeech) {
			$Mark_Is_Match = $True

			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			ForEach ($WildCard in $Initl_install_Language_Component) {
				if ($WildCard -like $Fonts.Match) {
					$Mark_Is_Match = $false
					Write-Host "  $($lang.Matched_Component_Names)" -NoNewline
					Write-Host $WildCard -ForegroundColor Green

					Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
					Write-Host $Fonts.FileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
					break
				}
			}

			if ($Mark_Is_Match) {
				Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
				Write-Host $Fonts.FileName -ForegroundColor Red

				Write-Host "  " -NoNewline
				Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host

				$Script:Init_Exclude_File += $Fonts.FileName
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Speech
	#>
	Write-Host "`n  $($lang.Speech): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Speech.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Speech.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Speech) {
			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
			Write-Host $Fonts.FileName -ForegroundColor Green

			Write-Host
		}

		Write-Host "  $($lang.LanguageExtractSearch)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Speech) {
			$Mark_Is_Match = $True

			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			ForEach ($WildCard in $Initl_install_Language_Component) {
				if ($WildCard -like $Fonts.Match) {
					$Mark_Is_Match = $false
					Write-Host "  $($lang.Matched_Component_Names)" -NoNewline
					Write-Host $WildCard -ForegroundColor Green

					Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
					Write-Host $Fonts.FileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
					break
				}
			}

			if ($Mark_Is_Match) {
				Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
				Write-Host $Fonts.FileName -ForegroundColor Red

				Write-Host "  " -NoNewline
				Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host

				$Script:Init_Exclude_File += $Fonts.FileName
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Features_On_Demand
	#>
	Write-Host "`n  $($lang.Features_On_Demand): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Features_On_Demand.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Features_On_Demand.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Features_On_Demand) {
			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
			Write-Host $Fonts.FileName -ForegroundColor Green

			Write-Host
		}

		Write-Host "  $($lang.LanguageExtractSearch)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		ForEach ($Fonts in $Script:Init_File_Type_Features_On_Demand) {
			$Mark_Is_Match = $True

			Write-Host "  $($lang.RuleName): " -NoNewline
			Write-Host $Fonts.Match -ForegroundColor Green

			ForEach ($WildCard in $Initl_install_Language_Component) {
				if ($WildCard -like $Fonts.Match) {
					$Mark_Is_Match = $false
					Write-Host "  $($lang.Matched_Component_Names)" -NoNewline
					Write-Host $WildCard -ForegroundColor Green

					Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
					Write-Host $Fonts.FileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
					break
				}
			}

			if ($Mark_Is_Match) {
				Write-Host "  $($lang.LXPsWaitAdd): " -NoNewline
				Write-Host $Fonts.FileName -ForegroundColor Red

				Write-Host "  " -NoNewline
				Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host

				$Script:Init_Exclude_File += $Fonts.FileName
			}
		}

		Write-Host "`n  $($lang.ExcludeItem): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($Script:Init_Exclude_File.Count) $($lang.EventManagerCount)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		if ($Script:Init_Exclude_File.Count -gt 0) {
			foreach ($item in $Script:Init_Exclude_File) {
				Write-Host "  $($item)" -ForegroundColor Green
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

Function Language_Rule_Add_View_And_Process
{
	param
	(
		[Switch]$Install
	)

	<#
		.1 = 字体
	#>
	Write-Host "`n  $($lang.Fonts): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Fonts.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Fonts.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Fonts) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Fonts.Count)" -Group $lang.Fonts
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.2 = 基本
	#>
	Write-Host "`n  $($lang.Basic): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Basic.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Basic.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Basic) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Basic.Count)" -Group $lang.Basic
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
	
	<#
		.3 = OCR
	#>
	Write-Host "`n  $($lang.OCR): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_OCR.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_OCR.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_OCR) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_OCR.Count)" -Group $lang.OCR
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.4 = 手写内容识别
	#>
	Write-Host "`n  $($lang.Handwriting): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Handwriting.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Handwriting.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Handwriting) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Handwriting.Count)" -Group $lang.Handwriting
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.5 = 文本转语音
	#>
	Write-Host "`n  $($lang.TextToSpeech): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_TextToSpeech.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_TextToSpeech.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_TextToSpeech) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_TextToSpeech.Count)" -Group $lang.TextToSpeech
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.6 = 语音识别
	#>
	Write-Host "`n  $($lang.Speech): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Speech.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Speech.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Speech) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Speech.Count)" -Group $lang.Speech
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.7 = 零售演示体验
	#>
	Write-Host "`n  $($lang.Retail): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Retail.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Retail.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Retail) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Retail.Count)" -Group $lang.Retail
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.8 = 按需功能
	#>
	Write-Host "`n  $($lang.Features_On_Demand): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Features_On_Demand.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Features_On_Demand.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Features_On_Demand) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Features_On_Demand.Count)" -Group $lang.Features_On_Demand
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.9 = 特定包
	#>
	Write-Host "`n  $($lang.RegionSpecific): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_File_Type_Other_Region_Specific.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_File_Type_Other_Region_Specific.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_File_Type_Other_Region_Specific) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item.FileName -SNTasks "$($SNTasks)/$($Script:Init_File_Type_Other_Region_Specific.Count)" -Group $lang.RegionSpecific
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.FileName -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.10 = 语言包其它
	#>
	Write-Host "`n  $($lang.UnassignedLangFiles): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Script:Init_Folder_All_File_Exclude.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Script:Init_Folder_All_File_Exclude.Count -gt 0) {
		[int]$SNTasks = "0"

		ForEach ($item in $Script:Init_Folder_All_File_Exclude) {
			if ($Install) {
				$SNTasks++

				Language_Add_File_Type_Process -FileName $item -SNTasks "$($SNTasks)/$($Script:Init_Folder_All_File_Exclude.Count)" -Group $lang.UnassignedLangFiles
			} else {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $item -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}