<#
	.Change image version
	.更改映像版本
#>
Function Editions_GUI
{
	Write-Host "`n  $($lang.Editions): $($lang.Change), $($lang.OOBEProductKey)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor DarkRed -ForegroundColor White
			return
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
		return
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 986
		Text           = "$($lang.Editions): $($lang.Change), $($lang.OOBEProductKey)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	$UI_Main_Change_Version = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Location       = "15,10"
		Text           = "$($lang.Editions): $($lang.Change)"
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($this.Checked) {
				$UI_Main_Change_Version_Select.Enabled = $True
			} else {
				$UI_Main_Change_Version_Select.Enabled = $False
			}
		}
	}
	$UI_Main_Change_Version_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 630
		Width          = 400
		Location       = "15,45"
		Padding        = "16,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.更改序列号
	#>
	$UI_Main_Change_Key_Select = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Location       = "500,15"
		Text           = "$($lang.Editions): $($lang.OOBEProductKey)"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($this.Checked) {
				$UI_Main_Menu_Change_Key.Enabled = $True
			} else {
				$UI_Main_Menu_Change_Key.Enabled = $False
			}
		}
	}
	$UI_Main_Menu_Change_Key = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 525
		Width          = 450
		Location       = "500,45"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "12,0,8,0"
	}
	$UI_Main_Change_Key_Custom_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 400
		Text           = $lang.ManualKey
	}
	$UI_Main_Change_Key_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 380
		margin         = "16,10,0,5"
		Text           = $Global:ProductKey
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Change_Key_Custom_Tips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 36
		Width          = 385
		margin         = "15,10,0,35"
		Text           = $lang.ManualKeyTips
	}
	$UI_Main_Get_MS_KMS = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 400
		margin         = "16,0,0,0"
		Text           = $lang.KMSLink1
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$OpenWebsiteLink1 = "https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys"
			Write-Host "  $($OpenWebsiteLink1)"
			Start-Process $OpenWebsiteLink1
		}
	}
	$UI_Main_Select_Know_Key = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 400
		margin         = "16,0,0,0"
		Text           = $lang.KMSKeySelect
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			KMSkeys

			if ([string]::IsNullOrEmpty($Global:ProductKey)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.KMSKey) )"
				$UI_Main_Change_Key_Custom.BackColor = "LightPink"
			} else {
				$UI_Main_Change_Key_Custom.Text = $Global:ProductKey
				$UI_Main_Change_Key_Custom.BackColor = "#FFFFFF"
			}
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "500,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "525,600"
		Height         = 30
		Width          = 365
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "500,635"
		Height         = 36
		Width          = 458
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$MarkVerifyVersion = $False
			$MarkVerifyVersionSelect = ""

			if ($UI_Main_Change_Version.Enabled) {
				if ($UI_Main_Change_Version.Checked) {
					$UI_Main_Change_Version_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									$MarkVerifyVersion = $True
									$MarkVerifyVersionSelect = $_.Tag
								}
							}
						}
					}

					if (-not $MarkVerifyVersion) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
						return
					}
				}
			}

			$MarkVerifyKey = $False
			if ($UI_Main_Change_Key_Select.Enabled) {
				if ($UI_Main_Change_Key_Select.Checked) {
					If ($UI_Main_Change_Key_Custom.Text -Match '^([A-Z0-9]{5}-){4}[A-Z0-9]{5}$') {
						$MarkVerifyKey = $True
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.ManualKeyError
						$UI_Main_Change_Key_Custom.BackColor = "LightPink"
						return
					}
				}
			}

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

			$UI_Main.Hide()
			Write-Host "  $($lang.Editions): $($lang.Change): " -NoNewline
			if ($MarkVerifyVersion) {
				Write-Host " $($MarkVerifyVersionSelect) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host "  " -NoNewline
				Write-Host " $($lang.Change) " -NoNewline -BackgroundColor White -ForegroundColor Black
				try {
					Set-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Set.log" -Path $test_mount_folder_Current -Edition $MarkVerifyVersionSelect
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host "  $($_)" -ForegroundColor Red
					Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}
			} else {
				Write-Host " $($lang.Inoperable) " -BackgroundColor DarkRed -ForegroundColor White
			}

			Write-Host "`n  $($lang.OOBEProductKey): $($lang.Change): " -NoNewline
			if ($MarkVerifyKey) {
				Write-Host " $($UI_Main_Change_Key_Custom.Text) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host "  " -NoNewline
				Write-Host " $($lang.Change) " -NoNewline -BackgroundColor White -ForegroundColor Black
				try {
					Set-WindowsProductKey -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Set.log" -Path $test_mount_folder_Current -ProductKey $UI_Main_Change_Key_Custom.Text
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host "  $($_)" -ForegroundColor Red
					Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}
			} else {
				Write-Host " $($lang.Inoperable) " -BackgroundColor DarkRed -ForegroundColor White
			}
			$UI_Main.Close()
		}
	}

	$UI_Main.controls.AddRange((
		$UI_Main_Change_Version,
		$UI_Main_Change_Version_Select,
		$UI_Main_Change_Key_Select,
		$UI_Main_Menu_Change_Key,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
	))

	$UI_Main_Menu_Change_Key.controls.AddRange((
		$UI_Main_Change_Key_Custom_Name,
		$UI_Main_Change_Key_Custom,
		$UI_Main_Change_Key_Custom_Tips,
		$UI_Main_Get_MS_KMS,
		$UI_Main_Select_Know_Key
	))

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	try {
		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  (Get-WindowsEdition -Path $($test_mount_folder_Current)).Edition" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
		}

		$CurrentEdition = (Get-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current).Edition
		$UI_Main_Error.Text = "$($lang.Editions): $($CurrentEdition)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")

		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = 35
			Width     = 375
			Text      = $CurrentEdition
			Tag       = $CurrentEdition
			Checked   = $True
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		$UI_Main_Change_Version_Select.controls.AddRange($CheckBox)

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsEdition -Path ""$($test_mount_folder_Current)"" -Target" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
		}

		Get-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current -Target | ForEach-Object {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 35
				Width     = 375
				Text      = $_.Edition
				Tag       = $_.Edition
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$UI_Main_Change_Version_Select.controls.AddRange($CheckBox)
		}
	} catch {
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text = $lang.Failed

		$UI_Main_Change_Version.Enabled = $False
		$UI_Main_Change_Version_Select.Enabled = $False
		
		$UI_Main_Change_Key_Select.Enabled = $False
		$UI_Main_Menu_Change_Key.Enabled = $False
	}

	if ($UI_Main_Change_Version.Enabled) {
		if ($UI_Main_Change_Version.Checked) {
			$UI_Main_Change_Version_Select.Enabled = $True
		} else {
			$UI_Main_Change_Version_Select.Enabled = $False
		}
	}

	if ($UI_Main_Change_Key_Select.Enabled) {
		if ($UI_Main_Change_Key_Select.Checked) {
			$UI_Main_Menu_Change_Key.Enabled = $True
		} else {
			$UI_Main_Menu_Change_Key.Enabled = $False
		}
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
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
 
	$UI_Main.ShowDialog() | Out-Null
}