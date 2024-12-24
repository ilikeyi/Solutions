<#
	.More features
	.更多功能
#>
Function Setting_Export_To_UI
{
	Write-Host "`n  $($lang.Setting): $($lang.SaveTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$SearchFolderRule = @(
		Join-Path -Path $Global:Image_source -ChildPath "History\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
		"$($Global:Image_source)_Custom\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
	)
	$SearchFolderRule = $SearchFolderRule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.Setting): $($lang.SaveTo)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Path      = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 280
		Location       = "15,15"
		Text           = $lang.Select_Path
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 630
		Width          = 555
		Location       = "15,45"
		Padding        = "22, 0, 0, 0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
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
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 280
		Location       = "620,595"
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Checked) {
						Write-Host "  $($lang.Setting): $($lang.SaveTo)"
						Write-Host "  $($_.Text)"
						New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $_.Text -Force
						Write-Host "  $($lang.Done)" -ForegroundColor Green

						$UI_Main.Close()
					}
				}
			}

			$UI_Main_Error.Text = $lang.NoChoose		
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
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Path,
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	<#
		.计算公式：
			四舍五入为整数
				(初始化字符长度 * 初始化字符长度）
			/ 控件高度
	#>
	<#
		.初始化字符长度
	#>
	[int]$InitCharacterLength = 90

	<#
		.初始化控件高度
	#>
	[int]$InitControlHeight = 35

	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	ForEach ($item in $SearchFolderRule) {
		$InitLength = $item.Length
		if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
			Width     = 515
			Text      = $item
			Tag       = $item
		}

		if ($Temp_Expand_Rule -eq $item) {
			$CheckBox.Checked = $True
		}

		$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 515
			Padding        = "16,0,0,0"
			Text           = $lang.OpenFolder
			Tag            = $item
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				} else {
					if (Test-Path -Path $This.Tag -PathType Container) {
						Start-Process $This.Tag

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
					}
				}
			}
		}

		$CheckBox_Paste    = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 515
			Padding        = "16,0,0,0"
			Text           = $lang.Paste
			Tag            = $item
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}

		$CheckBox_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height     = 15
			Width      = 480
		}

		$UI_Main_Menu.controls.AddRange((
			$CheckBox,
			$CheckBox_Open_Folder,
			$CheckBox_Paste,
			$CheckBox_Wrap
		))
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