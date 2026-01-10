<#
	.Associated ISO schemes
	.关联 ISO 方案
#>
Function ISO_Associated_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refres_Event_Tasks_ISO_Associated
	{
		if ($Global:Queue_ISO_Associated) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"

			if ($Global:Queue_ISO_Associated_Tasks.count -gt 0) {
				$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
			} else {
				$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
			}
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		$Global:Queue_ISO_Associated = $False
		$SavePath = $Global:Queue_ISO_Associated_Tasks.Sources

		$Global:Queue_ISO_Associated_Tasks = @{
			Sources = $SavePath
			Rule = @()
		}

		Refres_Event_Tasks_ISO_Associated

		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
	}

	Function ISO_Associated_Refresh_Sources
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Rule.controls.Clear()

		$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 443
			Text           = "$($Global:Queue_ISO_Associated_Tasks.Sources)\_ISO"
			Tag            = "$($Global:Queue_ISO_Associated_Tasks.Sources)\_ISO"
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
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
		$UI_Main_Rule.controls.AddRange($UI_Main_Pre_Rule)

		Get-ChildItem -Path "$($Global:Queue_ISO_Associated_Tasks.Sources)\_ISO" -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
			$FileA = [IO.Path]::GetFileNameWithoutExtension($_.FullName)

			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = 30
				Width     = 400
				Text      = $FileA
				Tag       = $_.FullName
			}

			if ($Global:Queue_ISO_Associated_Tasks.Rule -contains $_.FullName) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$UI_Main_Rule.controls.AddRange($CheckBox)

			$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 20
				Width          = 435
			}
			$UI_Main_Rule.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
		}

		<#
			.关联 ISO 多级目录
		#>
		Get-ChildItem -Path "$($Global:Queue_ISO_Associated_Tasks.Sources)\_ISO" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			$NewGroupName = [IO.Path]::GetFileName($_.FullName)
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 435
				Text      = $NewGroupName
			}
			$UI_Main_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)

			Foreach ($item in $_.FullName) {
				Get-ChildItem -Path $item -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
					$FileA = [IO.Path]::GetFileName($_.FullName)

					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 30
						Width     = 400
						Padding   = "16,0,0,0"
						Text      = $FileA
						Tag       = $_.FullName
					}

					if ($Global:Queue_ISO_Associated_Tasks.Rule -contains $_.FullName) {
						$CheckBox.Checked = $True
					} else {
						$CheckBox.Checked = $False
					}

					$UI_Main_Rule.controls.AddRange($CheckBox)
				}

				$GUIImageSelectFunctionLang_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 435
				}
				$UI_Main_Rule.controls.AddRange($GUIImageSelectFunctionLang_Wrap)
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.ISO_Associated_Schemes
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
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
		.签名密码
	#>
	$GUIISOCreateASC   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Location       = '620,15'
		Text           = $lang.CreateASC
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($GUIISOCreateASC.Checked) {
				$GUIISOCreateASCPanel.Enabled = $True
				Save_Dynamic -regkey "Solutions\ISO" -name "IsPGP" -value "True" -String
			} else {
				$GUIISOCreateASCPanel.Enabled = $False
				Save_Dynamic -regkey "Solutions\ISO" -name "IsPGP" -value "False" -String
			}
		}
	}
	$GUIISOCreateASCPanel = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 400
		Width          = 270
		autoSizeMode   = 1
		Location       = '635,55'
		autoScroll     = $False
	}
	$GUIISOCreateASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 240
		Location       = '0,0'
		Text           = $lang.CreateASCAuthor
	}
	$GUIISOCreateASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 220
		Location       = '15,35'
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.证书密码
	#>
	$GUIISOCreateASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 240
		Location       = '0,95'
		Text           = $lang.CreateASCPwd
	}
	$GUIISOCreateASCPWD = New-Object System.Windows.Forms.MaskedTextBox -Property @{
		Height         = 30
		Width          = 220
		Location       = '15,130'
		Text           = $Global:secure_password
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.证书密码：重新输入
	#>
	$GUIISOCreateASCPWDName_Rename = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 240
		Location       = '0,180'
		Text           = $lang.PasswordRenter
	}
	$GUIISOCreateASCPWD_Rename = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 220
		PasswordChar   = "*"
		Location       = '15,210'
		Text           = $Global:secure_password
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.证书密码：显示明文
	#>
	$UI_Main_Pass_Show = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Location       = '0,255'
		Text           = $lang.ShowPassword
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Pass_Show.Checked) {
				$GUIISOCreateASCPWDName_Rename.Visible = $False
				$GUIISOCreateASCPWD_Rename.Visible = $False
				$GUIISOCreateASCPWD.PasswordChar = (New-Object Char) # `0 and [char]0
			} else {
				$GUIISOCreateASCPWDName_Rename.Visible = $true
				$GUIISOCreateASCPWD_Rename.Visible = $true
				$GUIISOCreateASCPWD.PasswordChar = "*"
			}
		}
	}

	if ([string]::IsNullOrEmpty($Global:secure_password)) {
		$UI_Main_Pass_Show.Checked = $True
	} else {
		$UI_Main_Pass_Show.Checked = $False
	}

	if ($UI_Main_Pass_Show.Checked) {
		$GUIISOCreateASCPWDName_Rename.Visible = $False
		$GUIISOCreateASCPWD_Rename.Visible = $False
		$GUIISOCreateASCPWD.PasswordChar = (New-Object Char)
	} else {
		$GUIISOCreateASCPWDName_Rename.Visible = $true
		$GUIISOCreateASCPWD_Rename.Visible = $true
		$GUIISOCreateASCPWD.PasswordChar = "*"
	}

	$GUIISOCreateASCPWD_Save = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Location       = '0,305'
		Text           = $lang.Save
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if ($GUIISOCreateASC.Checked) {
				if ([string]::IsNullOrEmpty($GUIISOCreateASCSign.Text)) {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				} else {
					Save_Dynamic -regkey "Solutions\ISO" -name "PGP" -value $GUIISOCreateASCSign.Text -String

					if ($UI_Main_Pass_Show.Checked) {
						$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::ExcludePromptAndLiterals
						$Global:secure_password = $GUIISOCreateASCPWD.Text
						$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::IncludePromptAndLiterals

						$UI_Main_Error.Text = "$($lang.Save): $($lang.CreateASC), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					} else {
						if ($GUIISOCreateASCPWD.Text -eq $GUIISOCreateASCPWD_Rename.Text) {
							$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::ExcludePromptAndLiterals
							$Global:secure_password = $GUIISOCreateASCPWD.Text
							$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::IncludePromptAndLiterals

							$UI_Main_Error.Text = "$($lang.Save): $($lang.CreateASC), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						} else {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NewPasswordSome)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						}
					}
				}
			}
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
		.自动驾驶配置文件
	#>
	$UI_Main_Select_Sources_Config = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		margin         = "0,35,0,0"
		Text           = $lang.Autopilot_Select_Config
	}

	$UI_Main_Rule      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "15,0,0,0"
		autoScroll     = $False
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
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Temp_Queue_Drive_Add_Select = @()
			$UI_Main_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Temp_Queue_Drive_Add_Select += $_.Tag
						}
					}
				}
			}

			$SavePath = $Global:Queue_ISO_Associated_Tasks.Sources
			if ($Temp_Queue_Drive_Add_Select.Count -gt 0) {
				$Global:Queue_ISO_Associated = $true

				$Global:Queue_ISO_Associated_Tasks = @{
					Sources = $SavePath
					Rule = $Temp_Queue_Drive_Add_Select
				}
			} else {
				$Global:Queue_ISO_Associated = $false

				$Global:Queue_ISO_Associated_Tasks = @{
					Sources = $SavePath
					Rule = @()
				}
			}

			Refres_Event_Tasks_ISO_Associated

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$GUIISOCreateASC,
		$GUIISOCreateASCPanel,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Select_Sources_Config,
		$UI_Main_Rule
	))
	$GUIISOCreateASCPanel.controls.AddRange((
		$GUIISOCreateASCSignName,
		$GUIISOCreateASCSign,
		$GUIISOCreateASCPWDName,
		$GUIISOCreateASCPWD,
		$GUIISOCreateASCPWDName_Rename,
		$GUIISOCreateASCPWD_Rename,
		$UI_Main_Pass_Show,
		$GUIISOCreateASCPWD_Save
	))

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $Global:GpgKI) {
		$GUIISOCreateASCSign.Items.Add($item) | Out-Null
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue) {
		$GUIISOCreateASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue
	}

	<#
		.初始化复选框：生成 PGP
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOCreateASC.Checked = $True
				$GUIISOCreateASCPanel.Enabled = $True
				$GUIISOCreateASCPanel.Visible = $True
			}
			"False" {
				$GUIISOCreateASC.Checked = $False
				$GUIISOCreateASCPanel.Enabled = $False
				$GUIISOCreateASCPanel.Visible = $False
			}
		}
	} else {
		$GUIISOCreateASC.Checked = $False
		$GUIISOCreateASCPanel.Enabled = $False
		$GUIISOCreateASCPanel.Visible = $False
	}

	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIISOCreateASCPanel.Visible = $True
		if ($GUIISOCreateASC.Checked) {
			$GUIISOCreateASCPanel.Enabled = $True
		} else {
			$GUIISOCreateASCPanel.Enabled = $False
		}
	} else {
		$GUIISOCreateASC.Enabled = $False
		$GUIISOCreateASCPanel.Enabled = $False
		$GUIISOCreateASCPanel.Visible = $False
	}

	if ($Global:Queue_ISO_Associated_Tasks.count -gt 0) {
		ISO_Associated_Refresh_Sources
		Refres_Event_Tasks_ISO_Associated
	} else {
		$UI_Main_Error.Text = $lang.Inoperable
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")

		$UI_Main_Event_Clear.Enabled = $False
		$UI_Main_Save.Enabled = $False
	}

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
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask) ]"
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

function Autopilot_ISO_Associated_Process
{
	if ($Global:Queue_ISO_Associated_Tasks.count -gt 0) {
		foreach ($item in $Global:Queue_ISO_Associated_Tasks) {
			foreach ($itemrule in $item.Rule) {
				Remove-Item -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\\Create" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

				Autopilot_iso_Import -FileName $itemrule

				Write-Host "`n  $($lang.UnpackISO)"
				Write-Host "  $('-' * 80)"
				ISO_Create_Process
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}