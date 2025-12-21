<#
	.Wimlib: Update
	.Wimlib: 提取，更新映像内的文件
#>
Function Wimlib_Extract_And_Update
{
	<#
		.初始化：用户手动选择文件
	#>
	$Script:Wimlib_Extract_And_Update_User_Select_Custom_File = @()

	$Search_Folder_Multistage_Rule = @(
		"$(Get_MainMasterFolder)\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\Wimlib"
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\Wimlib"
		Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\Wimlib"
	)
	$Search_Folder_Multistage_Rule = $Search_Folder_Multistage_Rule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	Write-Host "`n  $($lang.Wim_Rule_Update)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refresh_Wimlib_Update_Mul_Sources
	{
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

		$AutoSelect_Path_Rule = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Update\Wimlib"

		foreach ($item in $Search_Folder_Multistage_Rule) {
			$InitLength = $item.Length
			if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

			$UI_Main_Folder_Flow_Custom = New-Object system.Windows.Forms.RadioButton -Property @{
				Height         = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
				Width          = 458
				margin         = "22,0,0,0"
				Text           = $item
				Tag            = $item
				add_Click      = {
					$UI_Main_Mask_Report_Error.Text = ""
					$UI_Main_Mask_Report_Error_Icon.Image = $null
					$UI_Main_Mask_Report_Save_To.Text = $This.Tag
				}
			}

			if ($item -eq $AutoSelect_Path_Rule) {
				$UI_Main_Folder_Flow_Custom.Checked = $True
				$UI_Main_Mask_Report_Save_To.Text = $item
			} else {
				$UI_Main_Folder_Flow_Custom.Checked = $False
			}

			$UI_Main_Mask_Report_Sources_Name_Tips.controls.AddRange($UI_Main_Folder_Flow_Custom)
		}
	}
	<#
		.验证
	#>

	Function Wimlib_Extract_And_Update_Check_Customize
	{
		param
		(
			[switch]$RuleNaming,
			[switch]$ImageIndex,
			[switch]$AddSources
		)

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		
		$MarkCheckedRuleNaming = $False
		$MarkCheckedImageIndex = $False
		$MarkCheckedAddSources = $False

		<#
			.初始化：已选择的规则命名
		#>
		$Script:Wimlib_Select_Rules_Naming = ""

		<#
			.初始化：已选择
		#>
		$Script:Wimlib_Select_File = ""

		<#
			.初始化：选择的索引号
		#>
		$Script:Wimlib_Select_Index = @()

		<#
			.检查是否选择规则命名
		#>
		if ($RuleNaming) {
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($_.Name -eq "Rule") {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($_.Checked) {
									$MarkCheckedRuleNaming = $True
									$Script:Wimlib_Select_Rules_Naming = $_.Tag
								}
							}
						}
					}
				}
			}

			if ($MarkCheckedRuleNaming) {
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.Select_Path) )"
				return
			}
		}

		if ($AddSources) {
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ($_.Name -eq "SelectFile") {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($_.Enabled) {
									if ($_.Checked) {
										$MarkCheckedAddSources = $True
										$Script:Wimlib_Select_File = $_.Tag
									}
								}
							}
						}
					}
				}
			}

			if ($MarkCheckedAddSources) {
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.SelFile) )"
				return
			}
		}

		if ($ImageIndex) {
			$UI_Main_Sync_To_Wim.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$MarkCheckedImageIndex = $True
							$Script:Wimlib_Select_Index += $_.Tag
						}
					}
				}
			}

			if ($MarkCheckedImageIndex) {
				$UI_Main_Tips.Text = "$($lang.AddQueue)`n------------------`n"
				ForEach ($item in $Global:Primary_Key_Image.Index) {
					if ($Script:Wimlib_Select_Index -Contains $item.ImageIndex) {
						$UI_Main_Tips.Text += "$($lang.MountedIndex): $($item.ImageIndex)`n"
						$UI_Main_Tips.Text += "$($lang.Wim_Image_Name): $($item.ImageName)`n"
						$UI_Main_Tips.Text += "$($lang.Wim_Image_Description): $($item.ImageDescription)`n"
						$UI_Main_Tips.Text += "$($lang.Wim_Display_Name): $($item.DISPLAYNAME)`n"
						$UI_Main_Tips.Text += "$($lang.Wim_Display_Description): $($item.DISPLAYDESCRIPTION)`n`n"
					}
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.MountedIndexSelect)"
				return
			}
		}

		return $True
	}

	<#
		.刷新
	#>
	Function Wimlib_Image_Refresh_Sources_Rule
	{
		param
		(
			$Guid
		)

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Extract_Rule_Select_Apps.controls.clear()

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

		# 3333333333333333333333333333333333333333333333333333333333333
		foreach ($item in $Search_Folder_Multistage_Rule) {
			$InitLength = $item.Length
			if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

			if (Test-Path -Path $item -PathType Container) {
				$Local_Wim_Update_Folder_Sources_Name = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width          = 480
					Text           = $item
					Tag            = $item
					LinkColor      = "GREEN"
					ActiveLinkColor = "RED"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						if (Test-Path -Path $This.Tag -PathType Container) {
							Start-Process $This.Tag
						}
					}
				}
				$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($Local_Wim_Update_Folder_Sources_Name)

				Get-ChildItem -Path $item -Directory -ErrorAction SilentlyContinue | Where-Object {
					$Main_Folder_Level_A = $_.FullName

					<#
						分组
					#>
					$UI_Main_Folder_Flow = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 480
						Text           = [IO.Path]::GetFileName($Main_Folder_Level_A)
						Tag            = $Main_Folder_Level_A
						LinkColor      = "GREEN"
						ActiveLinkColor = "RED"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							if (Test-Path -Path $This.Tag -PathType Container) {
								Start-Process $This.Tag
							}
						}
					}
					$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Folder_Flow)

					Get-ChildItem -Path "$($Main_Folder_Level_A)\*.wim" | ForEach-Object {
						$UI_Main_Folder_Flow_QQ_BBB = New-Object system.Windows.Forms.RadioButton -Property @{
							Height         = 30
							Width          = 440
							margin         = "25,0,0,10"
							Text           = [IO.Path]::GetFileName($_.FullName)
							Tag            = $_.FullName
							add_Click      = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
							}
						}

						if ($Guid -eq [IO.Path]::GetFileName($Main_Folder_Level_A)) {
							$UI_Main_Folder_Flow_QQ_BBB.Checked = $True
						}
						$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Folder_Flow_QQ_BBB)
					}

					$UI_Main_Folder_Flow_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 440
					}
					$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Folder_Flow_Wrap)
				}
			} else {
				$Local_Wim_Update_Folder_Sources_Name = New-Object system.Windows.Forms.Label -Property @{
					Height         = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width          = 480
					Text           = $item
				}
				$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($Local_Wim_Update_Folder_Sources_Name)

				$UI_Main_No_Update_Folder = New-Object system.Windows.Forms.Label -Property @{
					Height         = 40
					Width          = 460
					Text           = $lang.RuleNoFindFile
				}
				$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_No_Update_Folder)

				$UI_Main_Folder_Flow_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 440
				}
				$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Folder_Flow_Wrap)
			}
		}
		# 3333333333333333333333333333333333333333333333333333333333333

		<#
			.用户手动选择文件
		#>
		<#
			.选择规则
		#>
		$UI_Main_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 480
			Text           = $lang.RuleOther
		}
		$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Other_Rule)
		if ($Script:Wimlib_Extract_And_Update_User_Select_Custom_File.count -gt 0) {
			ForEach ($item in $Script:Wimlib_Extract_And_Update_User_Select_Custom_File) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$UI_Main_Folder_Flow_Custom = New-Object system.Windows.Forms.RadioButton -Property @{
					Height         = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width          = 458
					margin         = "22,0,0,0"
					Text           = $item
					Tag            = $item
					add_Click      = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Folder_Flow_Custom)
			}

		} else {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 40
				Width          = 480
				Padding        = "25,0,0,0"
				Text           = $lang.NoWork
			}
			$UI_Main_Extract_Rule_Select_Apps.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.Wim_Rule_Update
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
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
		Padding        = "20,20,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$UI_Main_Mask_Report_Sources_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.Select_Path
	}
	$UI_Main_Mask_Report_Sources_Name_Tips = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $True
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

	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 500
		Width          = 270
		BorderStyle    = 0
		Location       = "620,20"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Mask_Report_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,558"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Mask_Report_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,560"
		Height         = 30
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

			$InitalReportSources = "$($UI_Main_Mask_Report_Save_To.Text)\$($GUIISOSelectRandomName.Text)"
			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Save_To.Text)) {
				$UI_Main_Mask_Report_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.Select_Path) )"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			} else {
				$UI_Main_Mask_Report.Visible = $False
				
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.SaveTo): $($InitalReportSources)"

				$WimLib_SplieNew_Rule_path = $Script:Wimlib_Select_Rules_Naming -split ';'

				Write-Host "`n  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
				Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

				Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host $WimLib_SplieNew_Rule_path[2] -ForegroundColor Green

				Write-Host "`n  $($lang.MountedIndexSelect)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				ForEach ($item in $Global:Primary_Key_Image.Index) {
					if ($Script:Wimlib_Select_Index -Contains $item.ImageIndex) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $item.ImageDescription -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
						Write-Host $item.DISPLAYNAME -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
						Write-Host $item.DISPLAYDESCRIPTION -ForegroundColor Yellow

						$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
						if (Test-Path -Path $wimlib -PathType Leaf) {
							<#
								.创建保存到位置目录
							#>
							$RandomGuid = [guid]::NewGuid()

							$Local_Wim_Update_Folder_Sources = "$($UI_Main_Mask_Report_Save_To.Text)\$($RandomGuid)"
							Check_Folder -chkpath $Local_Wim_Update_Folder_Sources

							Start-Process -FilePath $wimlib -ArgumentList "extract ""$($Global:Primary_Key_Image.FullPath)"" $($item.ImageIndex) ""$($WimLib_SplieNew_Rule_path[2])"" --dest-dir=""$($Local_Wim_Update_Folder_Sources)""" -wait -WindowStyle Minimized

							$FullFilePath = "$($Local_Wim_Update_Folder_Sources)\WinRE.wim"
							if (Test-Path -Path $FullFilePath -PathType Leaf) {
								Rename-Item -Path "$($Local_Wim_Update_Folder_Sources)\WinRE.wim" -NewName "$($Local_Wim_Update_Folder_Sources)\Index.$($item.ImageIndex).$($item.ImageName).WinRe.wim" -ErrorAction SilentlyContinue
							}

							<#
								.刷新
							#>
							Wimlib_Image_Refresh_Sources_Rule -Guid $RandomGuid
						} else {
							Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
						}
					}
				}
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
		add_Click      = { Wimlib_Image_Refresh_Sources_Rule }
		Text           = $lang.Refresh
	}

	<#
		.选择文件
	#>
	$UI_Main_Select_Custom_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.SelFile
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "Image Files (*.WIM)|*.wim;"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				if ($Script:Wimlib_Extract_And_Update_User_Select_Custom_File -Contains $FileBrowser.FileName) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Existed
				} else {
					$Script:Wimlib_Extract_And_Update_User_Select_Custom_File += $FileBrowser.FileName
					Wimlib_Image_Refresh_Sources_Rule
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}

	<#
		.提取
	#>
	$UI_Main_Extract_File = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,90"
		Height         = 36
		Width          = 280
		Text           = $lang.Wim_Rule_Extract
		add_Click      = {
			if (Wimlib_Extract_And_Update_Check_Customize -RuleNaming -ImageIndex) {
				$UI_Main_Mask_Report.Visible = $True

				$UI_Main_Mask_Report_Error.Text = ""
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}
	}

	$UI_Main_Extract_File_Tips = New-Object system.Windows.Forms.Label -Property @{
		Location       = '630,145'
		Height         = 80
		Width          = 260
		Text           = $lang.Wim_Rule_Extract_Tips
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = '620,298'
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = '645,300'
		Height         = 280
		Width          = 255
		Text           = ""
	}
	$UI_Main_Update    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Update
		add_Click      = {
			if (Wimlib_Extract_And_Update_Check_Customize -RuleNaming -ImageIndex -AddSources) {
				$UI_Main.Hide()
				Write-Host "`n  $($lang.Select_Path)"
				Write-Host "  $($Script:Wimlib_Select_Rules_Naming)" -ForegroundColor Green

				Write-Host "`n  $($lang.SelFile)"
				Write-Host "  $($Script:Wimlib_Select_File)" -ForegroundColor Green

				Write-Host "`n  $($lang.MountedIndexSelect)"
				ForEach ($item in $Global:Primary_Key_Image.Index) {
					if ($Script:Wimlib_Select_Index -Contains $item.ImageIndex) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $item.ImageDescription -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Display_Name): " -NoNewline
						Write-Host $item.DISPLAYNAME -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Display_Description): " -NoNewline
						Write-Host $item.DISPLAYDESCRIPTION -ForegroundColor Yellow

						$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
						if (Test-Path -Path $wimlib -PathType Leaf) {
							Write-Host "`n  $($wimlib)" -ForegroundColor Yellow

							$WimLib_SplieNew_Rule_path = $Script:Wimlib_Select_Rules_Naming -split ';'
							$Arguments = "update ""$($Global:Primary_Key_Image.FullPath)"" $($item.ImageIndex) --command=""add '$($Script:Wimlib_Select_File)' '$($WimLib_SplieNew_Rule_path[2])'"""

							if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
								Write-Host "  $($lang.Command)" -ForegroundColor Green
								Write-Host "  $('-' * 80)"
								Write-Host "  Start-Process -FilePath ""$($wimlib)"" -ArgumentList ""update """"$($Global:Primary_Key_Image.FullPath)"""" $($item.ImageIndex) --command=""""add '$($Script:Wimlib_Select_File)' '$($WimLib_SplieNew_Rule_path[2])'""""""" -ForegroundColor Green
								Write-Host "  $('-' * 80)`n"
							}

							Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
						} else {
							Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
						}
					}
				}
				$UI_Main.Close()
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
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Mask_Report,
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Custom_Sources,
		$UI_Main_Extract_File,
		$UI_Main_Extract_File_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Update,
		$UI_Main_Canel
	))
	$UI_Main_Mask_Report.controls.AddRange((
		$UI_Main_Mask_Report_Menu,
		$UI_Main_Tips,
		$UI_Main_Mask_Report_Error_Icon,
		$UI_Main_Mask_Report_Error,
		$UI_Main_Mask_Report_OK,
		$UI_Main_Mask_Report_Canel
	))
	$UI_Main_Mask_Report_Menu.controls.AddRange((
		$UI_Main_Mask_Report_Sources_Name,
		$UI_Main_Mask_Report_Sources_Name_Tips,
		$UI_Main_Mask_Report_Save_To_Name,
		$UI_Main_Mask_Report_Save_To,
		$UI_Main_Mask_Report_Paste
	))

	Refresh_Wimlib_Update_Mul_Sources

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			<#
				.匹配当前主键，开始
			#>
			if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
				<#
					.控件
				#>
				$UI_Main_Rule_NO_New = New-Object system.Windows.Forms.Label -Property @{
					Height         = 55
					Width          = 510
					Text           = "$($lang.Unique_Name): $($item.Main.Uid)`n$($lang.Event_Group): $($item.Main.Group)"
				}
				$UI_Main_Rule_Available = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 510
					Text           = $lang.Event_Assign_Expand
				}
				$UI_Main_Rule_Select = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
					BorderStyle    = 0
					autosize       = 1
					autoSizeMode   = 1
					Margin         = "0,0,0,35"
					autoScroll     = $False
					Name           = "Rule"
				}

				$UI_Main_Menu.controls.AddRange((
					$UI_Main_Rule_NO_New,
					$UI_Main_Rule_Available,
					$UI_Main_Rule_Select
				))

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Expand.Group -eq $Global:Primary_Key_Image.Group) {
							$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = 35
								Width     = 500
								Padding   = "18,0,0,0"
								Text      = $Expand.UpdatePath
								Tag       = "$($item.Main.ImageFileName);$($Expand.ImageFileName);$($Expand.UpdatePath);"
								add_Click = {
									$UI_Main_Error.Text = ""
									$UI_Main_Error_Icon.Image = $null
								}
							}

							$UI_Main_Rule_Select.controls.AddRange($CheckBox)
						}
					}

					<#
						.选择一个 *.wim 文件
					#>
					$UI_Main_Select_Apps_Name = New-Object system.Windows.Forms.Label -Property @{
						Height         = 40
						Width          = 530
						Text           = $lang.Setting_Pri_Key
					}
					$UI_Main_Extract_Rule_Select_Apps = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
						BorderStyle    = 0
						autosize       = 1
						autoSizeMode   = 1
						autoScroll     = $False
						Padding        = "16,0,8,0"
						Name           = "SelectFile"
					}

					# 2222222222222222222222222222222222222222222222222222222222222
					<#
						.请选择需要同步的索引号
					#> 
					$UI_Main_Sync_To_Wim_Name = New-Object system.Windows.Forms.Label -Property @{
						Height         = 40
						Width          = 530
						margin         = "0,40,0,0"
						Text           = $lang.Pri_Key_Update_To
					}
					$UI_Main_Sync_To_Wim = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
						BorderStyle    = 0
						autosize       = 1
						autoSizeMode   = 1
						autoScroll     = $False
						Padding        = "22,0,8,0"
						margin         = "0,0,0,20"
					}

					<#
						.将当前选择的 *.wim 的所有详细信息显示在 UI 里
					#>
					ForEach ($item in $Global:Primary_Key_Image.Index) {
						$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
							Height    = 105
							Width     = 500
							Text      = "$($lang.MountedIndex): $($item.ImageIndex)`n$($lang.Wim_Image_Name): $($item.ImageName)`n$($lang.Wim_Image_Description): $($item.ImageDescription)`n$($lang.Wim_Display_Name): $($item.DISPLAYNAME)`n$($lang.Wim_Display_Description): $($item.DISPLAYDESCRIPTION)"
							Tag       = $item.ImageIndex
							margin    = "0,0,0,15"
							add_Click = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
							}
						}

						$UI_Main_Sync_To_Wim.controls.AddRange($CheckBox)
					}

					<#
						.Add right-click menu: select all, clear button
						.添加右键菜单：全选、清除按钮
					#>
					$UI_InBox_Apps_Group_Add_Menu = New-Object System.Windows.Forms.ContextMenuStrip
					$UI_InBox_Apps_Group_Add_Menu.Items.Add($lang.AllSel).add_Click({
						$UI_Main_Sync_To_Wim.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($_.Enabled) {
									$_.Checked = $true
								}
							}
						}
					})
					$UI_InBox_Apps_Group_Add_Menu.Items.Add($lang.AllClear).add_Click({
						$UI_Main_Sync_To_Wim.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($_.Enabled) {
									$_.Checked = $false
								}
							}
						}
					})
					$UI_Main_Sync_To_Wim.ContextMenuStrip = $UI_InBox_Apps_Group_Add_Menu
					# 2222222222222222222222222222222222222222222222222222222222222

					$UI_Main_Menu.controls.AddRange((
						$UI_Main_Select_Apps_Name,
						$UI_Main_Extract_Rule_Select_Apps,
						$UI_Main_Sync_To_Wim_Name,
						$UI_Main_Sync_To_Wim
					))

					Wimlib_Image_Refresh_Sources_Rule
				} else {
					$UI_Main_Rule_Available_No = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 510
						Padding        = "18,0,0,0"
						Text           = $lang.NoWork
					}
					$UI_Main_Menu.controls.AddRange($UI_Main_Rule_Available_No)
				}

				break
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

<#
	.处理更新：更新映像内的文件
#>
Function Image_Queue_Wimlib_Process_Wim_Main
{
	param
	(
		$NewUid,
		$NewMaster,
		$NewImageFileName,
		$MasterFile,
		$DevCode
	)

	<#
		.开始处理更新任务，WimLib
	#>
	#region 开始处理更新任务，WimLib
	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($NewMaster)_$($NewImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Expand_Rule.Count -gt 0) {
		Write-Host "`n  $($lang.Event_Allow_Update_Rule): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($Temp_Expand_Rule.Count) $($lang.EventManagerCount)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
		if (Test-Path -Path $wimlib -PathType Leaf) {
			Write-Host "  $($lang.Operable)"
		} else {
			Write-Host "  $($lang.NoInstallImage)"
			Write-Host "  $($wimlib)" -ForegroundColor Red
			return
		}

		<#
			.判断是否允许更新
		#>
		$Temp_Queue_Is_Update_Rule = (Get-Variable -Scope global -Name "Queue_Is_Update_Rule_$($NewMaster)_$($NewImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Queue_Is_Update_Rule) {
			Write-Host "`n  $($lang.Event_Assign_Expand): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($Temp_Expand_Rule.Count) $($lang.EventManagerCount)" -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $Temp_Expand_Rule.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $Temp_Expand_Rule.Uid -ForegroundColor Green

			Write-Host "  $($lang.Setting_Pri_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $Temp_Expand_Rule.FileName -ForegroundColor Green

			Write-Host "  $($lang.Pri_Key_Update_To): " -NoNewline -ForegroundColor Yellow
			Write-Host $MasterFile -ForegroundColor Green

			<#
				.判断是否处理全部，重新读取
			#>
			Write-Host "`n  $($lang.Event_Allow_Update_Rule)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Queue_Is_Update_Rule_Expand_To_All_$($NewMaster)_$($NewImageFileName)"
			if ((Get-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_To_All_$($NewMaster)_$($NewImageFileName)" -ErrorAction SilentlyContinue).Value) {
				Write-Host "  $($lang.Event_Allow_Update_To_All)" -ForegroundColor Green

				$TempQueueProcessImageSelect = @()
				try {
					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Get-WindowsImage -ImagePath ""$($MasterFile)""" -ForegroundColor Green
						Write-Host "  $('-' * 80)`n"
					}

					Get-WindowsImage -ImagePath $MasterFile -ErrorAction SilentlyContinue | ForEach-Object {
						$TempQueueProcessImageSelect += @{
							Name   = $_.ImageName
							Index  = $_.ImageIndex
						}
					}
				} catch {
					Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					Write-Host "  $($_)" -ForegroundColor Red
					Write-Host "  $($lang.Failed)" -ForegroundColor Red
				}

				if ($TempQueueProcessImageSelect.count -gt 0) {
					Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"

					ForEach ($item in $TempQueueProcessImageSelect) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.Index -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.Name -ForegroundColor Yellow

						Write-Host
					}

					Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					ForEach ($item in $TempQueueProcessImageSelect) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.Index -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.Name -ForegroundColor Yellow

						$Arguments = "update ""$($MasterFile)"" $($item.Index) --command=""add '$($Temp_Expand_Rule.FileName)' '$($Temp_Expand_Rule.UpdatePath)'"""
						Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

						Write-Host
						Write-Host "  " -NoNewline
						Write-Host " $($lang.LXPsWaitAddUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						Write-Host
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.Event_Allow_Update_Rule_Only)" -ForegroundColor Green

				Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
				Write-Host "  $($lang.Developers_Mode_Location): Queue_Process_Image_Select_Pending_$($NewMaster)_$($NewMaster)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				ForEach ($wimlib_item_Mount in (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($NewMaster)_$($NewMaster)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.MountedIndex): " -noNewline
					Write-Host $wimlib_item_Mount.Index -ForegroundColor Yellow

					Write-Host "  $($lang.Wim_Image_Name): " -noNewline
					Write-Host $wimlib_item_Mount.IName -ForegroundColor Yellow

					Write-Host
				}

				Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				ForEach ($wimlib_item_Mount in (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($NewMaster)_$($NewMaster)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.MountedIndex): " -noNewline
					Write-Host $wimlib_item_Mount.Index -ForegroundColor Yellow

					Write-Host "  $($lang.Wim_Image_Name): " -noNewline
					Write-Host $wimlib_item_Mount.IName -ForegroundColor Yellow

					$Arguments = "update ""$($MasterFile)"" $($wimlib_item_Mount.Index) --command=""add '$($Temp_Expand_Rule.FileName)' '$($Temp_Expand_Rule.UpdatePath)'"""
					Write-Host " $($lang.LXPsWaitAddUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black

					Write-Host
					Write-Host "  " -NoNewline
					Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
				}
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.添加已执行过的任务，不再执行
		#>
		if ($Global:Extension_Has_been_Run -NotContains $NewUid) {
			$Global:Extension_Has_been_Run += $NewUid
		}

		Write-Host "`n  $($lang.DeDuplication)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($NewUid)`n" -ForegroundColor Red

		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:Extension_Has_been_Run) {
			Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
			Write-Host $item -ForegroundColor Green

			Write-Host
		}
	} else {
		Write-Host "`n  $($lang.Event_Allow_Update_Rule): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($Temp_Expand_Rule.Count) $($lang.EventManagerCount)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}