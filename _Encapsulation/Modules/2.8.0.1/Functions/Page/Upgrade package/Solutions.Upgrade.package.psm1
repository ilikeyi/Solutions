<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function Update_Create_UI
{
	Logo -Title $lang.UpdateCreate

	Write-Host "  $($lang.UpdateCreate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Image_Init_Disk_Sources

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
		MinimizeBox    = $true
		ControlBox     = $true
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
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
		.sig
	#>
	$UI_Main_Create_ASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 468
		Text           = $lang.UpCreateASC
		add_Click      = {
			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
				Save_Dynamic -regkey "Solutions" -name "IsPGP_Up" -value "True"
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
				Save_Dynamic -regkey "Solutions" -name "IsPGP_Up" -value "False"
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

	$UI_Main_Create_ASCSignName = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.CreateASCAuthor
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Create_ASCSign.Items.Clear()

			$Newgpglistkey = Get_gpg_list_secret_keys
			if ($Newgpglistkey.Count -gt 0) {
				$UI_Main_Create_ASC.Enabled = $True

				<#
					.初始化：PGP KEY-ID
				#>
				ForEach ($item in $Newgpglistkey) {
					$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
				}

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Unpack" -Name "PGP" -ErrorAction SilentlyContinue) {
					$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Unpack" -Name "PGP" -ErrorAction SilentlyContinue
				} else {
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue) {
						$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue
					}
				}

				$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			} else {
				$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done) > $($lang.NoPGPKey)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
			}
		}
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

	$UI_Main_Create_ASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.CreateASCPwd
	}
	$UI_Main_Create_ASCPWD = New-Object System.Windows.Forms.MaskedTextBox -Property @{
		Height         = 30
		Width          = 450
		PasswordChar = "*"
		Text           = $Global:secure_password
		BackColor      = "#FFFFFF"
	}

	<#
		.证书密码：显示明文
	#>
	$UI_Main_Pass_Show = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.ShowPassword
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Pass_Show.Checked) {
				$UI_Main_Create_ASCPWD.PasswordChar = (New-Object Char)
			} else {
				$UI_Main_Create_ASCPWD.PasswordChar = "*"
			}
		}
	}

	<#
		.证书密码：永久保存
	#>
	$UI_Main_Pass_Permanent = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.PwdPermanent
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Pass_Permanent.Checked) {
				Save_Dynamic -regkey "Solutions\GPG" -name "PwdPermanent" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\GPG" -name "PwdPermanent" -value "False"
			}
		}
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
		Width          = 515
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$NewConfig = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\..") -ChildPath "_Unpack\update"

			$MarkNewRunAction = @()
			$MarkNewRunAction += "-Silent"

			<#
				.搜索到后生成 PGP
			#>
			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
					if ([string]::IsNullOrEmpty($UI_Main_Create_ASCSign.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")

						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						return
					} else {
						Save_Dynamic -regkey "Solutions\GPG" -name "PGP" -value $UI_Main_Create_ASCSign.Text
						$Global:secure_password = $UI_Main_Create_ASCPWD.Text
						$MarkNewRunAction += "-PGP"
						$MarkNewRunAction += "-PGPKEY $($PGPKEY) ""$($UI_Main_Create_ASCSign.Text)"""
						$MarkNewRunAction += "-PGPPWD ""$($Global:secure_password)"""
					}
				}
			}

			$Script:QueueUpdatePackerSelect = @()
			$UI_Main_Engine_Package.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Script:QueueUpdatePackerSelect += [pscustomobject]@{
								Name   = $_.Text
								PSFile = $_.Tag
							}
						}
					}
				}
			}

			if ($Script:QueueUpdatePackerSelect.Count -gt 0) {
				$UI_Main.Hide()

				if ($UI_Main_Pass_Permanent.Checked) {
					if ([string]::IsNullOrEmpty($UI_Main_Create_ASCPWD.Text)) {
						Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PwdPermanentKey" -Force -ErrorAction SilentlyContinue | out-null
						Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGPPwd" -Force -ErrorAction SilentlyContinue | out-null
					} else {
						$key = (1..32 | ForEach-Object { [byte](Get-Random -Minimum 0 -Maximum 255) })
						Save_Dynamic -regkey "Solutions\GPG" -Name "PwdPermanentKey" -value $key -Type "Binary"

						$secureString = $UI_Main_Create_ASCPWD.Text | ConvertTo-SecureString -AsPlainText -Force
						$encrypted = ConvertFrom-SecureString -SecureString $secureString -Key $key
						Save_Dynamic -regkey "Solutions\GPG" -Name "PGPPwd" -value $encrypted
					}
				} else {
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PwdPermanentKey" -Force -ErrorAction SilentlyContinue | out-null
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGPPwd" -Force -ErrorAction SilentlyContinue | out-null
				}

				if ($GUIUpdateCreateSHA256.Enabled) {
					if ($GUIUpdateCreateSHA256.Checked) {
						$MarkNewRunAction += "-SHA256"
					}
				}

				Remove_Tree $NewConfig

				ForEach ($item in $Script:QueueUpdatePackerSelect) {
					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Name -ForegroundColor Green

					Write-Host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
					Write-Host "$($NewConfig)\$($item.Name)" -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Start-Process powershell -ArgumentList "-File ""$($item.PSFile)"" $($MarkNewRunAction) -SaveTo ""$($NewConfig)\$($item.Name)""" -Wait -WindowStyle Minimized
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

					Write-Host
				}

				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
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
		$UI_Main_Create_ASCSignName,
		$UI_Main_Create_ASCSign,
		$UI_Main_Create_ASCSign_Wrap,
		$UI_Main_Create_ASCPWDName,
		$UI_Main_Create_ASCPWD,
		$UI_Main_Pass_Show,
		$UI_Main_Pass_Permanent
	))

	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\_Custom\Engine" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
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

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += "$($lang.SoftIsInstl -f "7-Zip")"
	}

	<#
		.初始化复选框：生成 PGP
	#>
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$UI_Main_Create_ASC.Enabled = $True

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsPGP_Up" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsPGP_Up" -ErrorAction SilentlyContinue) {
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

		$Newgpglistkey = Get_gpg_list_secret_keys
		if ($Newgpglistkey.Count -gt 0) {
			$UI_Main_Create_ASC.Enabled = $True

			<#
				.初始化：PGP KEY-ID
			#>
			ForEach ($item in $Newgpglistkey) {
				$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
			}

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue) {
				$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue
			}

			<#
				.证书密码：永久保存
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -name "PwdPermanent" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -name "PwdPermanent" -ErrorAction SilentlyContinue) {
					"True" {
						$UI_Main_Pass_Permanent.Checked = $True

						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PwdPermanentKey" -ErrorAction SilentlyContinue) {
							$oldPwdPermanentKey = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PwdPermanentKey" -ErrorAction SilentlyContinue

							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGPPwd" -ErrorAction SilentlyContinue) {
								$OldSavePwd = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGPPwd" -ErrorAction SilentlyContinue

								try {
									[byte[]]$recoveredKey = $oldPwdPermanentKey
									$recoveredEncryptedPass = $OldSavePwd
									$decryptedSS = $recoveredEncryptedPass | ConvertTo-SecureString -Key $recoveredKey
									$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($decryptedSS)
									$finalPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

									$UI_Main_Create_ASCPWD.Text = $finalPass
								} catch {
									$UI_Main_Error.Text = $lang.PwdDecfailed
									$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								}
							}
						}
					}
					"False" {
						$UI_Main_Pass_Permanent.Checked = $False
					}
				}
			} else {
				Save_Dynamic -regkey "Solutions\GPG" -name "PwdPermanent" -value "True"
				$UI_Main_Pass_Permanent.Checked = $True
			}

			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
			}
		} else {
			$UI_Main_Create_ASC.Enabled = $True
			$UI_Main_Create_ASC.Checked = $False
			$UI_Main_Create_ASC_Panel.Enabled = $False

			$UI_Main_Error.Text = $lang.NoPGPKey
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
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

		if ([string]::IsNullOrEmpty($UI_Main_Create_ASCPWD.Text)) {
			$UI_Main_Pass_Show.Checked = $True
		} else {
			$UI_Main_Pass_Show.Checked = $False
		}

		if ($UI_Main_Pass_Show.Checked) {
			$UI_Main_Create_ASCPWD.PasswordChar = (New-Object Char) # `0 and [char]0
		} else {
			$UI_Main_Create_ASCPWD.PasswordChar = "*"
		}
	} else {
		$UI_Main_Create_ASC.Enabled = $False
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += "$($lang.SoftIsInstl -f "gpg4win")"
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
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$UI_Main.ShowDialog() | Out-Null
}