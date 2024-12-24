<#
	.Add image source user interface
	.添加映像源用户界面
#>
Function Image_Select_Add_UI
{
	Write-Host "`n  $($lang.SelectSettingImage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$Script:TempSourcesFile = ""

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = "$($lang.SelectSettingImage): $($lang.AddTo)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,0,8,0"
		Dock           = 3
	}
	$UI_Main_Select_Custom_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,10"
		Height         = 36
		Width          = 280
		Text           = $lang.SelFile
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "Image Files (*.WIM;*.ESD;*.SWM)|*.wim;*.esd;*.swm;|WIM Image (*.WIM)|*.wim|ESD Image (*.esd)|*.ESD|SWM Split Image (*.swm)|*.swm"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$Script:Temp_Save_Select_WIMFile = @()

				$UI_Main_Menu.controls.Clear()
				$Script:TempSourcesFile = $FileBrowser.FileName
				$UI_Main_Select_Custom_File.Text = "$($lang.SelFile): `n`n$($FileBrowser.FileName)"

				if ($Global:Developers_Mode) {
					Write-Host "`n  $($lang.Developers_Mode_Location): 82" -ForegroundColor Green
				}

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Get-WindowsImage -ImagePath ""$($FileBrowser.FileName)""" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				Get-WindowsImage -ImagePath $FileBrowser.FileName | Foreach-Object {
					Get-WindowsImage -ImagePath $FileBrowser.FileName -index $_.ImageIndex | ForEach-Object {

						$CheckBox     = New-Object System.Windows.Forms.CheckBox  -Property @{
							Height    = 55
							Width     = 450
							Text      = "$($lang.Wim_Image_Name): $($_.ImageName)`n$($lang.MountedIndex): $($_.ImageIndex)"
							Tag       = $_.ImageIndex
							Checked   = $True
							add_Click = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
							}
						}

						if ($UI_Main_Duplication.checked) {
							if ($Global:Primary_Key_Image.Index.EditionId -contains $_.EditionId) {
								$CheckBox.Enabled = $False
							}
						}
						$UI_Main_Menu.controls.AddRange($CheckBox)

						$Script:Temp_Save_Select_WIMFile += @{
							ImageIndex         = $_.ImageIndex
							ImageName          = $_.ImageName
							ImageDescription   = $_.ImageDescription
							DISPLAYNAME        = ""
							DISPLAYDESCRIPTION = ""
							EditionId          = $_.EditionId
							Architecture       = $_.Architecture
							CreatedTime        = $_.CreatedTime
							ImageSize          = $_.ImageSize
							Version            = $_.Version
						}
					}
				}

				$UI_Main_Error.Text = "$($lang.SelFile), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCancel
			}
		}
	}
	$UI_Main_Duplication = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.DeDuplication
		Location       = '572,55'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Duplication_Unlock = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 260
		Location       = "588,95"
		Text           = $lang.DeDuplication_Unlock
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$_.Enabled = $true
				}
			}

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.DeDuplication_Unlock), $($lang.Done)"
		}
	}

	$UI_Main_Select_Custom_File = New-Object System.Windows.Forms.RichTextBox -Property @{
		BorderStyle    = 0
		Height         = 320
		Width          = 255
		Location       = "586,155"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "570,498"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "595,500"
		Height         = 55
		Width          = 255
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,595"
		Height         = 36
		Width          = 280
		Text           = $lang.AddTo
		add_Click      = {
			$SelectTempTag = @()
			<#
				.获取已选择
			#>
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$SelectTempTag += $_.Tag
						}
					}
				}
			}

			if ($SelectTempTag.Count -gt 0) {
				$UI_Main.Hide()

				Write-Host "`n  $($lang.AddTo)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				foreach ($item in $Script:Temp_Save_Select_WIMFile) {
					if ($SelectTempTag -contains $item.ImageIndex) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host
					}
				}

				Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				foreach ($item in $Script:Temp_Save_Select_WIMFile) {
					if ($SelectTempTag -contains $item.ImageIndex) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host "  $($lang.Export_Image): " -NoNewline
						try {
							Export-WindowsImage -SourceImagePath $Script:TempSourcesFile -SourceIndex $item.ImageIndex -DestinationImagePath $Global:Primary_Key_Image.FullPath -CompressionType max -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} catch {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
							Write-Host "  $($_)" -ForegroundColor Red
						}

						Write-Host
					}
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
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Select_Custom_Sources,
		$UI_Main_Duplication,
		$UI_Main_Duplication_Unlock,
		$UI_Main_Select_Custom_File,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

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

	$UI_Main.ShowDialog() | Out-Null
}