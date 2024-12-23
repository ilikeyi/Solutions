<#
	.Delete image source user interface
	.删除映像源用户界面
#>
Function Image_Select_Del_UI
{
	param
	(
		$AutoSelectIndex
	)

	Write-Host "`n  $($lang.SelectSettingImage) $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Verify_Is_Select_New_Remove_Index
	{
		<#
			.Reset selected
			.重置已选择
		#>
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

			Write-Host "`n  $($lang.LXPsWaitRemove)" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			ForEach ($item in $MarkSelectIndexin) {
				ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
					if ($item -eq $itemDetail.ImageIndex) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $itemDetail.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

						Write-Host
					}
				}
			}

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $MarkSelectIndexin | Sort-Object { [int]$_ } -Descending) {
				ForEach ($itemDetail in $Global:Primary_Key_Image.Index) {
					if ($item -eq $itemDetail.ImageIndex) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $itemDetail.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $itemDetail.ImageIndex -ForegroundColor Yellow

						if ($Global:Developers_Mode) {
							Write-Host "`n  $($lang.Developers_Mode_Location): 86`n" -ForegroundColor Green
						}

						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Remove-WindowsImage -ImagePath ""$($Global:Primary_Key_Image.FullPath)"" -Index ""$($item)"" -CheckIntegrity" -ForegroundColor Green
							Write-Host "  $('-' * 80)`n"
						}

						Write-Host "  $($lang.Del): " -NoNewline
						try {
							Remove-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Remove.log" -ImagePath "$($Global:Primary_Key_Image.FullPath)" -Index $item -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} catch {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
							Write-Host "  $($_)" -ForegroundColor Red
						}

						Write-Host
					}
				}
			}
			$UI_Main.Close()
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = "$($lang.SelectSettingImage): $($lang.Del)"
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
		Location       = "575,15"
		Text           = $lang.SelectTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "570,523"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "595,525"
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
		add_Click      = { Verify_Is_Select_New_Remove_Index }
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	
	ForEach ($item in $Global:Primary_Key_Image.Index) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 55
			Width     = 450
			margin    = "0,0,0,18"
			Text      = "$($lang.Wim_Image_Name): $($item.ImageName)`n$($lang.MountedIndex): $($item.ImageIndex)"
			Tag       = $item.ImageIndex
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		$UI_Main_Menu.controls.AddRange($CheckBox)
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

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$IsNumber = [int]::TryParse($AutoSelectIndex, [ref]$null)
	if ($IsNumber) {
		$Get_Current_All_Index = @()
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$Get_Current_All_Index += $_.Tag

				if ($_.Tag -eq $AutoSelectIndex) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		if ($Get_Current_All_Index -contains $AutoSelectIndex) {
			Verify_Is_Select_New_Remove_Index
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = $lang.AutoSelectIndexFailed -f $AutoSelectIndex

			$UI_Main.ShowDialog() | Out-Null
		}

		return
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}