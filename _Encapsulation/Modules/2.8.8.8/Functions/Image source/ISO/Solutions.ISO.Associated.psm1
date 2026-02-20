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
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Container) {
						Start-Process $This.Tag

						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
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
		Width          = 1075
		Text           = $lang.ISO_Associated_Schemes
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
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
	$UI_Main_Create_ASC   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 425
		Location       = '620,15'
		Text           = $lang.CreateASC
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
				Save_Dynamic -regkey "Solutions\ISO" -name "IsPGP" -value "True"
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
				Save_Dynamic -regkey "Solutions\ISO" -name "IsPGP" -value "False"
			}
		}
	}
	$UI_Main_Create_ASC_Panel = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 400
		Width          = 410
		autoSizeMode   = 1
		Location       = '635,55'
		autoScroll     = $False
	}
	$UI_Main_Create_ASCSignName = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.CreateASCAuthor
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Newgpglistkey = Get_gpg_list_secret_keys
			if ($Newgpglistkey.Count -gt 0) {
				$UI_Main_Create_ASCSign.Items.Clear()
				$UI_Main_Create_ASC.Enabled = $True

				<#
					.初始化：PGP KEY-ID
				#>
				ForEach ($item in $Newgpglistkey) {
					$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
				}

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue) {
					$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue
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
		Height         = 30
		Width          = 360
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
	$UI_Main_Create_ASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 380
		Location       = '0,95'
		Text           = $lang.CreateASCPwd
	}
	$UI_Main_Create_ASCPWD = New-Object System.Windows.Forms.MaskedTextBox -Property @{
		Height         = 30
		Width          = 360
		Location       = '15,130'
		Text           = $Global:secure_password
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.证书密码：重新输入
	#>
	$UI_Main_Create_ASCPWDName_Rename = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 380
		Location       = '0,180'
		Text           = $lang.PasswordRenter
	}
	$UI_Main_Create_ASCPWD_Rename = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 360
		PasswordChar   = "*"
		Location       = '15,210'
		Text           = $Global:secure_password
		BackColor      = "#FFFFFF"
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
				$UI_Main_Create_ASCPWDName_Rename.Visible = $False
				$UI_Main_Create_ASCPWD_Rename.Visible = $False
				$UI_Main_Create_ASCPWD.PasswordChar = (New-Object Char) # `0 and [char]0
			} else {
				$UI_Main_Create_ASCPWDName_Rename.Visible = $true
				$UI_Main_Create_ASCPWD_Rename.Visible = $true
				$UI_Main_Create_ASCPWD.PasswordChar = "*"
			}
		}
	}

	<#
		.证书密码：永久保存
	#>
	$UI_Main_Pass_Permanent = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Location       = '0,300'
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

	$UI_Main_Create_ASCPWD_Save = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 380
		Location       = '0,355'
		Text           = "$($lang.Save), $($lang.CreateASC)"
		add_Click      = {
			if ($UI_Main_Create_ASC.Checked) {
				if ([string]::IsNullOrEmpty($UI_Main_Create_ASCSign.Text)) {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					Save_Dynamic -regkey "Solutions\ISO" -name "PGP" -value $UI_Main_Create_ASCSign.Text

					if ($UI_Main_Pass_Show.Checked) {
						$UI_Main_Create_ASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::ExcludePromptAndLiterals
						$Global:secure_password = $UI_Main_Create_ASCPWD.Text
						$UI_Main_Create_ASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::IncludePromptAndLiterals

						$UI_Main_Error.Text = "$($lang.Save): $($lang.CreateASC), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						if ($UI_Main_Create_ASCPWD.Text -eq $UI_Main_Create_ASCPWD_Rename.Text) {
							$UI_Main_Create_ASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::ExcludePromptAndLiterals
							$Global:secure_password = $UI_Main_Create_ASCPWD.Text
							$UI_Main_Create_ASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::IncludePromptAndLiterals

							$UI_Main_Error.Text = "$($lang.Save): $($lang.CreateASC), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						} else {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NewPasswordSome)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							return
						}
					}

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

							if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Unpack" -Name "PGP" -ErrorAction SilentlyContinue) {
							} else {
								Save_Dynamic -regkey "Solutions\Unpack" -name "PGP" -value $UI_Main_Create_ASCSign.Text
							}
						}
					} else {
						Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PwdPermanentKey" -Force -ErrorAction SilentlyContinue | out-null
						Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGPPwd" -Force -ErrorAction SilentlyContinue | out-null
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
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
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
		Location       = "620,600"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,602"
		Height         = 30
		Width          = 400
		Text           = ""
	}

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 210
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "838,635"
		Height         = 36
		Width          = 210
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
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Refresh_Sources,
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,
		$UI_Main_Create_ASC,
		$UI_Main_Create_ASC_Panel,
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
	$UI_Main_Create_ASC_Panel.controls.AddRange((
		$UI_Main_Create_ASCSignName,
		$UI_Main_Create_ASCSign,
		$UI_Main_Create_ASCPWDName,
		$UI_Main_Create_ASCPWD,
		$UI_Main_Create_ASCPWDName_Rename,
		$UI_Main_Create_ASCPWD_Rename,
		$UI_Main_Pass_Show,
		$UI_Main_Pass_Permanent,
		$UI_Main_Create_ASCPWD_Save
	))

	<#
		.初始化复选框：生成 PGP
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Create_ASC.Checked = $True
				$UI_Main_Create_ASC_Panel.Enabled = $True
			}
			"False" {
				$UI_Main_Create_ASC.Checked = $False
				$UI_Main_Create_ASC_Panel.Enabled = $False
			}
		}
	} else {
		$UI_Main_Create_ASC.Checked = $False
		$UI_Main_Create_ASC_Panel.Enabled = $False
	}

	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$Newgpglistkey = Get_gpg_list_secret_keys
		if ($Newgpglistkey.Count -gt 0) {
			$UI_Main_Create_ASC.Enabled = $True

			<#
				.初始化：PGP KEY-ID
			#>
			ForEach ($item in $Newgpglistkey) {
				$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
			}

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue) {
				$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue
			} else {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue) {
					$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\GPG" -Name "PGP" -ErrorAction SilentlyContinue
				}
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
									$UI_Main_Create_ASCPWD_Rename.Text = $finalPass
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
	} else {
		$UI_Main_Create_ASC.Enabled = $False
		$UI_Main_Create_ASC_Panel.Enabled = $False
	}

	if ([string]::IsNullOrEmpty($UI_Main_Create_ASCPWD.Text)) {
		$UI_Main_Pass_Show.Checked = $True
	} else {
		$UI_Main_Pass_Show.Checked = $False
	}

	if ($UI_Main_Pass_Show.Checked) {
		$UI_Main_Create_ASCPWDName_Rename.Visible = $False
		$UI_Main_Create_ASCPWD_Rename.Visible = $False
		$UI_Main_Create_ASCPWD.PasswordChar = (New-Object Char) # `0 and [char]0
	} else {
		$UI_Main_Create_ASCPWDName_Rename.Visible = $true
		$UI_Main_Create_ASCPWD_Rename.Visible = $true
		$UI_Main_Create_ASCPWD.PasswordChar = "*"
	}

	if ($Global:Queue_ISO_Associated_Tasks.count -gt 0) {
		ISO_Associated_Refresh_Sources
		Refres_Event_Tasks_ISO_Associated
	} else {
		$UI_Main_Error.Text = $lang.Inoperable
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")

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
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
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