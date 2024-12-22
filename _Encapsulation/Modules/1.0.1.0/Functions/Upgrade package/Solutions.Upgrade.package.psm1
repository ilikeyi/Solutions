<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function Update_Create_UI
{
	Logo -Title $lang.UpdateCreate

	Write-Host "  $($lang.UpdateCreate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.UpdateCreate
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 570
		Width          = 550
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 15
		Location       = '15,10'
		Dock           = 1
	}

	$UI_Main_Engine_Package_name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.UpdateCreate
	}
	$UI_Main_Engine_Package = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "15,0,0,0"
	}

	$UI_Main_Engine_Package_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 490
	}

	<#
		.创建升级包后需要做些什么
	#>
	$GUIUpdateRearTips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.UpCreateRear
	}
	$GUIUpdateGroupASC = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "15,0,0,0"
	}

	$GUIUpdateCreateSHA256 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 468
		Text           = $lang.UpCreateSHA256
		Location       = '26,515'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.asc
	#>
	$UI_Main_Create_ASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 468
		Text           = $lang.UpCreateASC
		add_Click      = {
			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
				Save_Dynamic -regkey "Solutions" -name "IsPGP_Up" -value "True" -String
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
				Save_Dynamic -regkey "Solutions" -name "IsPGP_Up" -value "False" -String
			}
		}
	}
	$UI_Main_Create_ASC_Panel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "10,0,0,0"
		autoScroll     = $False
	}
	$UI_Main_Create_ASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.UpPgpPwd
	}
	$UI_Main_Create_ASCPWD = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 450
		Text           = $Global:secure_password
	}
	$UI_Main_Create_ASCPWD_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
	}

	$UI_Main_Create_ASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.CreateASCAuthor
	}
	$UI_Main_Create_ASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 55
		Width          = 450
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Create_ASCSign_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 450
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "15,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "40,600"
		Height         = 30
		Width          = 480
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$NewConfig = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..") -ChildPath "_Unpack\update"

			$MarkNewRunAction = "-Silent"

			<#
				.搜索到后生成 PGP
			#>
			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
					if ([string]::IsNullOrEmpty($UI_Main_Create_ASCSign.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")

						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						return
					} else {
						Save_Dynamic -regkey "Solutions" -name "PGP" -value $UI_Main_Create_ASCSign.Text -String
						$Global:secure_password = $UI_Main_Create_ASCPWD.Text
						$Global:SignGpgKeyID = $UI_Main_Create_ASCSign.Text

						$MarkNewRunAction += " -PGP -PGPKEY $PGPKEY ""$($Global:SignGpgKeyID)"" -PGPPWD ""$($Global:secure_password)"""
					}
				}
			}

			$Script:QueueUpdatePackerSelect = @()
			$UI_Main_Engine_Package.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Script:QueueUpdatePackerSelect += @{
								Name   = $_.Text
								PSFile = $_.Tag
							}
						}
					}
				}
			}

			if ($Script:QueueUpdatePackerSelect.Count -gt 0) {
				$UI_Main.Hide()

				if ($GUIUpdateCreateSHA256.Enabled) {
					if ($GUIUpdateCreateSHA256.Checked) {
						$MarkNewRunAction += " -SHA256"
					}
				}

				Remove_Tree $NewConfig

				ForEach ($item in $Script:QueueUpdatePackerSelect) {
					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Name -ForegroundColor Green

					Write-Host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
					Write-Host "$($NewConfig)\$($item.Name)" -ForegroundColor Green

					Write-Host "  $($lang.AddTo): " -NoNewline

					Start-Process powershell -ArgumentList "-File ""$($item.PSFile)"" $($MarkNewRunAction) -SaveTo ""$($NewConfig)\$($item.Name)""" -Wait -WindowStyle Minimized
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

					Write-Host
				}

				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "268,635"
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Engine_Package_name,
		$UI_Main_Engine_Package,
		$UI_Main_Engine_Package_Wrap,
		$GUIUpdateRearTips,
		$GUIUpdateGroupASC
	))

	$GUIUpdateGroupASC.controls.AddRange((
		$GUIUpdateCreateSHA256,
		$UI_Main_Create_ASC,
		$UI_Main_Create_ASC_Panel
	))

	$UI_Main_Create_ASC_Panel.controls.AddRange((
		$UI_Main_Create_ASCPWDName,
		$UI_Main_Create_ASCPWD,
		$UI_Main_Create_ASCPWD_Wrap,
		$UI_Main_Create_ASCSignName,
		$UI_Main_Create_ASCSign,
		$UI_Main_Create_ASCSign_Wrap
	))

	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Engine" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
		if (Test-Path -Path "$($_.Fullname)\_Create.Upgrade.Package.ps1" -PathType Leaf) {
			$CheckBox      = New-Object System.Windows.Forms.CheckBox -Property @{
				Height     = 35
				Width      = 468
				Text       = $_.BaseName
				Tag        = "$($_.Fullname)\_Create.Upgrade.Package.ps1"
				Checked    = $True
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$UI_Main_Engine_Package.controls.AddRange($CheckBox)
		}
	}

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$UI_Main_OK.Enabled = $True
	} else {
		$UI_Main_Engine_Package.Enabled = $False
		$GUIUpdateGroupASC.Enabled = $False
		$UI_Main_OK.Enabled = $False

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += $lang.ZipStatus
	}

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $Global:GpgKI) {
		$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "PGP" -ErrorAction SilentlyContinue) {
		$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "PGP" -ErrorAction SilentlyContinue
	}

	<#
		.初始化复选框：生成 PGP
	#>
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$UI_Main_Create_ASC.Enabled = $True

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsPGP_Up" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsPGP_Up" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Create_ASC.Checked = $True
				}
				"False" {
					$UI_Main_Create_ASC.Checked = $False
				}
			}
		} else {
			$UI_Main_Create_ASC.Checked = $False
		}
	} else {
		$UI_Main_Create_ASC.Enabled = $False
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += $lang.ASCStatus
	}

	if ($UI_Main_Create_ASC.Enabled) {
		if ($UI_Main_Create_ASC.Checked) {
			$UI_Main_Create_ASC_Panel.Enabled = $True
		} else {
			$UI_Main_Create_ASC_Panel.Enabled = $False
		}
	} else {
		$UI_Main_Create_ASC_Panel.Enabled = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Engine_Package_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Engine_Package_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Engine_Package.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Engine_Package_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Engine_Package.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Engine_Package.ContextMenuStrip = $UI_Main_Engine_Package_Select

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