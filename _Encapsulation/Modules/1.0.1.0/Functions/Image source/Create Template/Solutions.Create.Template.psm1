<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function Create_Template_UI
{
	param
	(
		[Switch]$Auto,
		[Switch]$NewAdd,
		[Switch]$NewDel
	)

	Write-Host "`n  $($lang.RuleNewTempate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Create_Template_Verify_Rule_Name
	{
		$UI_Public_Name_CustomizeName.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($UI_Public_Name_CustomizeName.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($UI_Public_Name_CustomizeName.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($UI_Public_Name_CustomizeName.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($UI_Public_Name_CustomizeName.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($UI_Public_Name_CustomizeName.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($UI_Public_Name_CustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($UI_Public_Name_CustomizeName.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Public_Name_CustomizeName.BackColor = "LightPink"
			return $False
		}

		return $True
	}

	Function Create_Template_Verify_Install
	{
		$GUISelectTypeInstallCustomizeName.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUISelectTypeInstallCustomizeName.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUISelectTypeInstallCustomizeName.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUISelectTypeInstallCustomizeName.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUISelectTypeInstallCustomizeName.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUISelectTypeInstallCustomizeName.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUISelectTypeInstallCustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUISelectTypeInstallCustomizeName.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeInstallCustomizeName.BackColor = "LightPink"
			return $False
		}

		return $True
	}

	Function Create_Template_Verify_WinRE
	{
		$GUISelectTypeWinRECustomizeName.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUISelectTypeWinRECustomizeName.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUISelectTypeWinRECustomizeName.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUISelectTypeWinRECustomizeName.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUISelectTypeWinRECustomizeName.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUISelectTypeWinRECustomizeName.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUISelectTypeWinRECustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUISelectTypeWinRECustomizeName.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeWinRECustomizeName.BackColor = "LightPink"
			return $False
		}

		return $True
	}

	Function Create_Template_Verify_Boot
	{
		$GUISelectTypeBootCustomizeName.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUISelectTypeBootCustomizeName.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUISelectTypeBootCustomizeName.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUISelectTypeBootCustomizeName.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUISelectTypeBootCustomizeName.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUISelectTypeBootCustomizeName.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUISelectTypeBootCustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUISelectTypeBootCustomizeName.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUISelectTypeBootCustomizeName.BackColor = "LightPink"
			return $False
		}

		return $True
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.RuleNewTempate
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
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

	<#
		.公共名称
	#>
	$UI_Public_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Location       = "620,15"
		Text           = $lang.RuleName
	}
	$UI_Public_Name_CustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 250
		Location       = "640,45"
		Text           = ""
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Public_Name_Sync_To.Checked) {
				$UI_Public_Name_Sync_To_Install.Enabled = $True
				$UI_Public_Name_Sync_To_Boot.Enabled = $True

				if ($UI_Public_Name_Sync_To_Install.Checked) {
					$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_WinRE.Checked) {
					$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_Boot.Checked) {
					$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}
			}
		}
	}

	<#
		.重新生成规则名
	#>
	$UI_Public_Name_CustomizeName_NewGUID = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 280
		Location       = "638,85"
		Text           = $lang.GenerateRandom
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$RandomGuid = "Example_$(Get-RandomHexNumber -length 5).$(Get-RandomHexNumber -length 3)"
			$UI_Public_Name_CustomizeName.Text = $RandomGuid

			if (Create_Template_Verify_Rule_Name) {
				if ($UI_Public_Name_Sync_To_Install.Enabled) {
					if ($UI_Public_Name_Sync_To_Install.Checked) {
						$GUISelectTypeInstallCustomizeName.Text = $RandomGuid
					}
				}

				if ($UI_Public_Name_Sync_To_WinRE.Enabled) {
					if ($UI_Public_Name_Sync_To_WinRE.Checked) {
						$GUISelectTypeWinRECustomizeName.Text = $RandomGuid
					}
				}

				if ($UI_Public_Name_Sync_To_Boot.Enabled) {
					if ($UI_Public_Name_Sync_To_Boot.Checked) {
						$GUISelectTypeBootCustomizeName.Text = $RandomGuid
					}
				}

				$UI_Main_Error.Text = "$($lang.GenerateRandom), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}
	
	<#
		.同步规则名到所有
	#>
	$UI_Public_Name_Sync_To_All = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 280
		Location       = "638,120"
		Text           = $lang.RuleNameUse -f $lang.AllSel
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if (Create_Template_Verify_Rule_Name) {
				$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text

				$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text

				$UI_Main_Error.Text = "$($lang.RuleNameUse -f $lang.AllSel), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}

	<#
		.将名称同步到
	#>
	$UI_Public_Name_Sync_To = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Location       = "638,170"
		Text           = $lang.RuleNameNewChange
		Checked        = $True
		add_Click      = {
			if ($UI_Public_Name_Sync_To.Checked) {
				$UI_Public_Name_Sync_To_Install.Enabled = $True
				$UI_Public_Name_Sync_To_Boot.Enabled = $True

				if ($UI_Public_Name_Sync_To_Install.Checked) {
					$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_WinRE.Checked) {
					$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_Boot.Checked) {
					$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}
			} else {
				$UI_Public_Name_Sync_To_Install.Enabled = $False
				$UI_Public_Name_Sync_To_WinRE.Enabled = $False
				$UI_Public_Name_Sync_To_Boot.Enabled = $False
			}
		}
	}
	$UI_Public_Name_Sync_To_Install = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Location       = "655,205"
		Text           = "Install"
		Checked        = $True
		add_Click      = {
			if (Create_Template_Verify_Rule_Name) {
				if ($UI_Public_Name_Sync_To_Install.Checked) {
					$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_WinRE.Checked) {
					$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_Boot.Checked) {
					$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				$UI_Main_Error.Text = "$($lang.RuleNameUse -f "Install"), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}

	$GUISelectTypeInstallCustomizeName_Use = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 280
		Location       = "670,240"
		Text           = $lang.RuleNameUse -f "Install"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if (Create_Template_Verify_Rule_Name) {
				$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
			}
		}
	}

		$UI_Public_Name_Sync_To_WinRE = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 510
			Location       = "675,285"
			Text           = "WinRE"
			Checked        = $True
			add_Click      = {
				if (Create_Template_Verify_Rule_Name) {
					if ($UI_Public_Name_Sync_To_Install.Checked) {
						$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
					}

					if ($UI_Public_Name_Sync_To_WinRE.Checked) {
						$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
					}

					if ($UI_Public_Name_Sync_To_Boot.Checked) {
						$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
					}

					$UI_Main_Error.Text = "$($lang.RuleNameUse -f "Boot"), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
		$GUISelectTypeWinRECustomizeName_Use = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 280
			Location       = "690,320"
			Text           = $lang.RuleNameUse -f "WinRE"
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if (Create_Template_Verify_Rule_Name) {
					$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}
			}
		}

	$UI_Public_Name_Sync_To_Boot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Location       = "655,380"
		Text           = "Boot"
		Checked        = $True
		add_Click      = {
			if (Create_Template_Verify_Rule_Name) {
				if ($UI_Public_Name_Sync_To_Install.Checked) {
					$GUISelectTypeInstallCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_WinRE.Checked) {
					$GUISelectTypeWinRECustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				if ($UI_Public_Name_Sync_To_Boot.Checked) {
					$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
				}

				$UI_Main_Error.Text = "$($lang.RuleNameUse -f "Boot"), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}

	$GUISelectTypeBootCustomizeName_Use = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 280
		Location       = "670,415"
		Text           = $lang.RuleNameUse -f "Boot"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if (Create_Template_Verify_Rule_Name) {
				$GUISelectTypeBootCustomizeName.Text = $UI_Public_Name_CustomizeName.Text
			}
		}
	}

	<#
		.刷新复选框状态
	#>
	if ($UI_Public_Name_Sync_To.Checked) {
		$UI_Public_Name_Sync_To_Install.Enabled = $True
		$UI_Public_Name_Sync_To_WinRE.Enabled = $True
		$UI_Public_Name_Sync_To_Boot.Enabled = $True
	} else {
		$UI_Public_Name_Sync_To_Install.Enabled = $False
		$UI_Public_Name_Sync_To_WinRE.Enabled = $False
		$UI_Public_Name_Sync_To_Boot.Enabled = $False
	}

	<#
		.类型
	#>
	$GUISelectTypeTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Text           = $lang.RuleName
	}
	$GUISelectTypeInstall = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = "Install"
		Checked        = $True
		add_Click      = {
			if ($GUISelectTypeInstall.Checked) {
				$GUISelectTypeInstallCustomizeName.Enabled = $True
			} else {
				$GUISelectTypeInstallCustomizeName.Enabled = $False
			}
		}
	}
	$GUISelectTypeInstallCustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 390
		Text           = ""
		margin         = "45,5,0,15"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	if ($GUISelectTypeInstall.Checked) {
		$GUISelectTypeInstallCustomizeName.Enabled = $True
	} else {
		$GUISelectTypeInstallCustomizeName.Enabled = $False
	}

	<#
		WinRE
	#>
		$GUISelectTypeWinRE = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 510
			Padding        = "45,0,0,0"
			Text           = "WinRE"
			add_Click      = {
				if ($GUISelectTypeWinRE.Checked) {
					$GUISelectTypeWinRECustomizeName.Enabled = $True
				} else {
					$GUISelectTypeWinRECustomizeName.Enabled = $False
				}
			}
		}
		$GUISelectTypeWinRECustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
			Height         = 30
			Width          = 370
			Text           = ""
			margin         = "65,5,0,15"
			add_Click      = {
				$This.BackColor = "#FFFFFF"
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		if ($GUISelectTypeWinRE.Checked) {
			$GUISelectTypeWinRECustomizeName.Enabled = $True
		} else {
			$GUISelectTypeWinRECustomizeName.Enabled = $False
		}


	$GUISelectTypeBoot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = "Boot"
		add_Click      = {
			if ($GUISelectTypeBoot.Checked) {
				$GUISelectTypeBootCustomizeName.Enabled = $True
			} else {
				$GUISelectTypeBootCustomizeName.Enabled = $False
			}
		}
	}
	$GUISelectTypeBootCustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 390
		Text           = ""
		margin         = "45,5,0,15"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	if ($GUISelectTypeBoot.Checked) {
		$GUISelectTypeBootCustomizeName.Enabled = $True
	} else {
		$GUISelectTypeBootCustomizeName.Enabled = $False
	}

	<#
		.类型
	#>
	$UI_Main_Type_Path = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		margin         = "0,35,0,0"
		Text           = $lang.ImageLevel
	}
	$UI_Main_Type_Path_Desktop = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = $lang.LevelDesktop
		Checked        = $True
	}

	$UI_Main_Type_Path_Server = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = $lang.LevelServer
	}

	<#
		.架构
	#>
	$GUIImageSourceArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		margin         = "0,35,0,0"
		Text           = $lang.Architecture
	}
	$GUIImageSourceArchitectureARM64 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = "arm64"
	}
	$GUIImageSourceArchitectureAMD64 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = "x64"
		Checked        = $True
	}
	$GUIImageSourceArchitectureX86 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 510
		Padding        = "25,0,0,0"
		Text           = "x86"
	}

	<#
		.添加或删除
	#>
	$UI_Main_Extract_Save_To_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.LanguageExtractAddTo
	}
	$UI_Main_Extract_Save_To_Add = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 500
		Padding        = "25,0,0,0"
		Checked        = $True
		Text           = $lang.AddTo
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Extract_Save_To_Del = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 500
		Padding        = "25,0,0,0"
		Text           = $lang.Del
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_End_Wrap  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 425
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
	$UI_Main_View_Detailed_History = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = "620,485"
		Text           = $lang.History_View
		Visible        = $False
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $True
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
	$UI_Main_Ok        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			<#
				.验证是否选择：Install, WinRE, Boot
			#>
			$Mask_Install_WinRE_Boot = @()
			if ($GUISelectTypeInstall.Checked) {
				if (Create_Template_Verify_Install) {
					$Mask_Install_WinRE_Boot += @{
						Uid  = "Install;install;wim;";
						Flag = $GUISelectTypeInstallCustomizeName.Text
					}
				} else {
					return
				}
			}

			if ($GUISelectTypeWinRE.Checked) {
				if (Create_Template_Verify_WinRE) {
					$Mask_Install_WinRE_Boot += @{
						Uid  = "Install;WinRE;wim;";
						Flag = $GUISelectTypeWinRECustomizeName.Text
					}
				} else {
					return
				}
			}

			if ($GUISelectTypeBoot.Checked) {
				if (Create_Template_Verify_Boot) {
					$Mask_Install_WinRE_Boot += @{
						Uid  = "Boot;Boot;wim;";
						Flag = $GUISelectTypeBootCustomizeName.Text
					}
				} else {
					return
				}
			}

			if ($Mask_Install_WinRE_Boot.Count -gt 0) {
			} else {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): Install, WinRE, Boot"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				return
			}

			<#
				.验证是否选择：类型：桌面、服务器
			#>
			$Mask_Desktop_Server = @()
			if ($UI_Main_Type_Path_Desktop.Checked) {
				$Mask_Desktop_Server += "Desktop"
			}

			if ($UI_Main_Type_Path_Server.Checked) {
				$Mask_Desktop_Server += "Server"
			}

			if ($Mask_Desktop_Server.Count -gt 0) {
			} else {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.ImageLevel): $($lang.LevelDesktop), $($lang.LevelServer)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				return
			}


			<#
				.验证是否选择：架构：arm64, x64, x86
			#>
			$Mask_Arch = @()
			if ($GUIImageSourceArchitectureARM64.Checked) {
				$Mask_Arch += "Arm64"
			}

			if ($GUIImageSourceArchitectureAMD64.Checked) {
				$Mask_Arch += "x64"
			}

			if ($GUIImageSourceArchitectureX86.Checked) {
				$Mask_Arch += "x86"
			}

			if ($Mask_Arch.Count -gt 0) {
			} else {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.Architecture): Arm64, x64, x86"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				return
			}

			<#
				.验证是否选择：类型：添加、删除
			#>
			$Mask_Add_Del = @()
			if ($UI_Main_Extract_Save_To_Add.Checked) {
				$Mask_Add_Del += "Add"
			}

			if ($UI_Main_Extract_Save_To_Del.Checked) {
				$Mask_Add_Del += "Del"
			}

			if ($Mask_Add_Del.Count -gt 0) {
			} else {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.LanguageExtractAddTo): $($lang.AddTo), $($lang.Del)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				return
			}

			<#
				.清除旧内容
			#>
			$UI_Main_View_Detailed_Show.Text = ""

			$Path = "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions"
			if (Get-ItemProperty -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue) {
				$GetDiskTo = Get-ItemPropertyValue -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue
			} else {
				<#
					.创建模板时未检查到未初始化磁盘到，强行运行初始化磁盘
				#>
				Image_Init_Disk_Sources

				if (Get-ItemProperty -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue) {
					$GetDiskTo = Get-ItemPropertyValue -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue
				} else {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.Setting): $($lang.SaveTo), $($lang.Failed)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					return
				}
			}

			<#
				.刷新映像规则
			#>
			Image_Refresh_Init_GLobal_Rule

			ForEach ($item in $Global:Image_Rule) {
				if ($item.Main.Suffix -eq "wim") {
					ForEach ($AIWB in $Mask_Install_WinRE_Boot) {
						if ($AIWB.Uid -eq $item.main.Uid) {
							ForEach ($DSType in $Mask_Desktop_Server) {
								ForEach ($ArchitectureNew in $Mask_Arch) {
									ForEach ($itemAR in $Mask_Add_Del) {
										$SaveFileTo = Join-Path -Path $GetDiskTo -ChildPath "$($DSType)\_Custom\$($item.main.ImageFileName)\$($item.main.ImageFileName)\Update\$($AIWB.Flag)\$($ArchitectureNew)\$($itemAR)"

										Create_Template_New_Path -NewPath $SaveFileTo
									}
								}
							}
						}
					}

					if ($item.Expand.Count -gt 0) {
						ForEach ($itemExpandNew in $item.Expand) {
							ForEach ($AIWB in $Mask_Install_WinRE_Boot) {
								if ($AIWB.Uid -eq $itemExpandNew.Uid) {
									ForEach ($DSType in $Mask_Desktop_Server) {
										ForEach ($ArchitectureNew in $Mask_Arch) {
											ForEach ($itemAR in $Mask_Add_Del) {
												$SaveFileTo = Join-Path -Path $GetDiskTo -ChildPath "$($DSType)\_Custom\$($item.main.ImageFileName)\$($itemExpandNew.ImageFileName)\Update\$($AIWB.Flag)\$($ArchitectureNew)\$($itemAR)"

												Create_Template_New_Path -NewPath $SaveFileTo
											}
										}
									}
								}
							}
						}
					}
				}
			}

			$UI_Main_View_Detailed_History.Visible = $True
			$UI_Main_View_Detailed.Visible = $True
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
		$UI_Main_View_Detailed,
		$UI_Public_Name,
		$UI_Public_Name_CustomizeName,
		$UI_Public_Name_CustomizeName_NewGUID,

		$UI_Public_Name_Sync_To_All,

		$UI_Public_Name_Sync_To,
		$UI_Public_Name_Sync_To_Install,
		$GUISelectTypeInstallCustomizeName_Use,

			$UI_Public_Name_Sync_To_WinRE,
			$GUISelectTypeWinRECustomizeName_Use,

		$UI_Public_Name_Sync_To_Boot,
		$GUISelectTypeBootCustomizeName_Use,

		$UI_Main_Menu,
		$UI_Main_View_Detailed_History,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Ok,
		$UI_Main_Canel
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		<#
			.类型
		#>
		$GUISelectTypeTitle,
		$GUISelectTypeInstall,
		$GUISelectTypeInstallCustomizeName,
			$GUISelectTypeWinRE,
			$GUISelectTypeWinRECustomizeName,
		$GUISelectTypeBoot,
		$GUISelectTypeBootCustomizeName,

		$UI_Main_Type_Path,
		$UI_Main_Type_Path_Desktop,
		$UI_Main_Type_Path_Server,

		$GUIImageSourceArchitectureTitle,
		$GUIImageSourceArchitectureARM64,
		$GUIImageSourceArchitectureAMD64,
		$GUIImageSourceArchitectureX86,
		$UI_Main_Extract_Save_To_Name,
		$UI_Main_Extract_Save_To_Add,
		$UI_Main_Extract_Save_To_Del,
		$UI_Main_End_Wrap
	))
	
	$RandomGuid = "Example_$(Get-RandomHexNumber -length 5).$(Get-RandomHexNumber -length 3)"
	$UI_Public_Name_CustomizeName.Text = $RandomGuid
	$GUISelectTypeInstallCustomizeName.Text = $RandomGuid
		$GUISelectTypeWinReCustomizeName.Text = $RandomGuid
	$GUISelectTypeBootCustomizeName.Text = $RandomGuid

	if ($Auto) {
		if ($Global:ImageType -eq "Desktop") {
			$UI_Main_Type_Path_Desktop.Checked = $True
		} else {
			$UI_Main_Type_Path_Desktop.Checked = $False
		}

		if ($Global:ImageType -eq "Server") {
			$UI_Main_Type_Path_Server.Checked = $True
		} else {
			$UI_Main_Type_Path_Server.Checked = $False
		}

		switch ($Global:Architecture) {
			"arm64" {
				$GUIImageSourceArchitectureARM64.Checked = $True
			}
			"AMD64" {
				$GUIImageSourceArchitectureAMD64.Checked = $True
			}
			"x86" {
				$GUIImageSourceArchitectureX86.Checked = $True
			}
		}

		if ($NewAdd) {
			$UI_Main_Extract_Save_To_Add.Checked = $True
		} else {
			$UI_Main_Extract_Save_To_Add.Checked = $False
		}

		if ($NewDel) {
			$UI_Main_Extract_Save_To_Del.Checked = $True
		} else {
			$UI_Main_Extract_Save_To_Del.Checked = $False
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

Function Create_Template_New_Path
{
	param
	(
		$NewPath
	)

	$UI_Main_View_Detailed_Show.Text += $NewPath
	if (Test-Path -Path $NewPath -PathType Container) {
		$UI_Main_View_Detailed_Show.Text += "`n$($lang.Existed)`n`n"
	} else {
		$UI_Main_View_Detailed_Show.Text += "`n$($lang.IsCreate)         "

		New-Item -Path $NewPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		if (Test-Path -Path $NewPath -PathType Container) {
			$UI_Main_View_Detailed_Show.Text += "$($lang.Done)`n`n"
		} else {
			$UI_Main_View_Detailed_Show.Text += "$($lang.Failed)`n`n"
		}
	}
}