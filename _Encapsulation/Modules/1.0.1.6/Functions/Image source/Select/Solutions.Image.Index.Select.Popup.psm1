<#
	.选择索引号，弹出
#>
Function Image_Select_Popup_UI
{
	param
	(
		$ImageFileName
	)

	Write-Host "`n  $($lang.Index_Is_Event_Select)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = $lang.Index_Is_Event_Select
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 580
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,8,0,0"
		Dock           = 3
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips   = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 300
		Width          = 270
		BorderStyle    = 0
		Location       = "575,10"
		Text           = $lang.Image_Popup_Tips -f "$($Global:Primary_Key_Image.Master);$($Global:Primary_Key_Image.ImageFileName);"
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.Save as default
		.设置为默认
	#>
	$UI_Main_Index_Default = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.Image_Popup_Default
		Location       = '570,556'
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "568,518"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "593,520"
		Height         = 30
		Width          = 255
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			<#
				.Reset selected
				.重置已选择
			#>
			$TempQueueProcessImageSelectPending = @()
			$MarkSelectIndexin = @()

			<#
				.Mark: Check the selection status
				.标记：检查选择状态
			#>

			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_.Enabled) {
					if ($_.Checked) {
						$MarkSelectIndexin += $_.Tag
					}
				}
			}

			if ($MarkSelectIndexin.Count -gt 0) {
				$UI_Main.Hide()

				ForEach ($item in $MarkSelectIndexin) {
					ForEach ($WildCard in $Script:TempQueueProcessImageSelect) {
						if ($item -eq $WildCard.Index) {
							$TempQueueProcessImageSelectPending += @{
								Name   = $WildCard.Name
								Index  = $WildCard.Index
							}
						}
					}
				}
				New-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempQueueProcessImageSelectPending -Force

				Write-Host "`n  $($lang.Image_Popup_Default)"
				if ($UI_Main_Index_Default.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempQueueProcessImageSelectPending -Force
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.Choose)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				ForEach ($item in $TempQueueProcessImageSelectPending) {
					Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
					Write-Host $item.Name -ForegroundColor Yellow

					Write-Host "  $($lang.MountedIndex): " -NoNewline
					Write-Host $item.Index -ForegroundColor Yellow

					Write-Host
				}
				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			New-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Index_Default,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$Script:TempQueueProcessImageSelect = @()
	if (Test-Path -Path $ImageFileName -PathType Leaf) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 88`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($ImageFileName)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Get-WindowsImage -ImagePath $ImageFileName -ErrorAction SilentlyContinue | ForEach-Object {
				$Script:TempQueueProcessImageSelect += @{
					Name   = $_.ImageName
					Index  = $_.ImageIndex
				}

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 55
					Width     = 450
					margin    = "0,0,0,18"
					Text      = "$($lang.Wim_Image_Name): $($_.ImageName)`n$($lang.MountedIndex): $($_.ImageIndex)"
					Tag       = $_.ImageIndex
					Checked   = $True
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($ImageFileName)"
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			return
		}
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
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