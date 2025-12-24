<#
	.Desktop icon user interface
	.桌面图标用户界面
#>
Function Desktop
{
	Logo -Title $lang.DeskIcon
	write-host "  $($lang.DeskIcon)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$GUIDesktop        = New-Object system.Windows.Forms.Form -Property @{
		AutoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.DeskIcon
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$GUIDesktopPanel   = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 425
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		WrapContents   = $true
		Padding        = "8,0,8,0"
		Dock           = 1
	}
	$GUIDesktopThisPC  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.ThisPC
		Checked        = $true
	}
	$GUIDesktopRecycleBin = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.RecycleBin
	}
	$GUIDesktopUser    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.User
		Checked        = $true
	}
	$GUIDesktopControlPanel = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.ControlPanel
	}
	$GUIDesktopNetwork = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.Network
	}
	$GUIDesktopIE      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.IE
	}
	$GUIDesktopGodMode = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.GodMode
	}

	<#
		.Other
		.其它
	#>
	$GUIDesktopSortName = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 512
		Text           = $lang.AdvOption
		Location       = '10,450'
	}
	$GUIDesktopSortPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 90
		Width          = 528
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		WrapContents   = $true
		Padding        = "22,0,8,0"
		Location       = "0,480"
	}
	$GUIDesktopTaskBar = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 480
		Text           = "$($lang.Reset) $($lang.TaskBar)"
	}
	$GUIDesktopReset   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.ResetDesk
		Checked        = $true
	}
	$GUIDesktopAddToDesktop = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 30
		Width          = 510
		Text           = $lang.DesktopAllUsers
		Location       = "10,585"
		Checked        = $True
	}
	$GUIDesktopOK      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$GUIDesktop.Hide()

			<#
				.Add to: All users and current users
				.添加到：全部用户和当前用户
			#>
			if ($GUIDesktopAddToDesktop.Checked) {
				if ($GUIDesktopThisPC.Checked) { Desktop_ICON_ThisPC -AllUsers }
				if ($GUIDesktopRecycleBin.Checked) { Desktop_ICON_Recycle_Bin -AllUsers }
				if ($GUIDesktopUser.Checked) { Desktop_ICON_User -AllUsers }
				if ($GUIDesktopControlPanel.Checked) { Desktop_ICON_Control_Panel -AllUsers }
				if ($GUIDesktopNetwork.Checked) { Desktop_ICON_Network -AllUsers }
				if ($GUIDesktopIE.Checked) { Desktop_ICON_IE -AllUsers }
				if ($GUIDesktopGodMode.Checked) { Desktop_ICON_God_Mode -AllUsers }
			} else {
				if ($GUIDesktopThisPC.Checked) { Desktop_ICON_ThisPC }
				if ($GUIDesktopRecycleBin.Checked) { Desktop_ICON_Recycle_Bin }
				if ($GUIDesktopUser.Checked) { Desktop_ICON_User }
				if ($GUIDesktopControlPanel.Checked) { Desktop_ICON_Control_Panel }
				if ($GUIDesktopNetwork.Checked) { Desktop_ICON_Network }
				if ($GUIDesktopIE.Checked) { Desktop_ICON_IE }
				if ($GUIDesktopGodMode.Checked) { Desktop_ICON_God_Mode }
			}
			if ($GUIDesktopTaskBar.Checked) { Reset_TaskBar }
			if ($GUIDesktopReset.Checked) { Reset_Desktop }
			$GUIDesktop.Close()
		}
	}
	$GUIDesktopCanel   = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "268,635"
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$GUIDesktop.Close()
		}
	}
	$GUIDesktop.controls.AddRange((
		$GUIDesktopPanel,
		$GUIDesktopAddToDesktop,
		$GUIDesktopSortName,
		$GUIDesktopSortPanel,
		$GUIDesktopOK,
		$GUIDesktopCanel
	))
	$GUIDesktopPanel.controls.AddRange((
		$GUIDesktopThisPC,
		$GUIDesktopRecycleBin,
		$GUIDesktopUser,
		$GUIDesktopControlPanel,
		$GUIDesktopNetwork,
		$GUIDesktopIE,
		$GUIDesktopGodMode
	))

	if (IsWin11) {
		$GUIDesktopIE.Enabled = $False
	}

	$GUIDesktopSortPanel.controls.AddRange((
		$GUIDesktopTaskBar,
		$GUIDesktopReset
	))

	$GUIDesktopMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIDesktopMenu.Items.Add($lang.AllSel).add_Click({
		$GUIDesktopPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIDesktopMenu.Items.Add($lang.AllClear).add_Click({
		$GUIDesktopPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIDesktopPanel.ContextMenuStrip = $GUIDesktopMenu

	if ($Global:EventQueueMode) {
		$GUIDesktop.Text = "$($GUIDesktop.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$GUIDesktop.ShowDialog() | Out-Null
}

<#
	.This PC
	.此电脑
#>
Function Desktop_ICON_ThisPC
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.ThisPC)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.ThisPC)"
	}

	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Recycle bin
	.回收站
#>
Function Desktop_ICON_Recycle_Bin
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.RecycleBin)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.RecycleBin)"
	}

	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 0
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Users's files
	.用户的文件夹
#>
Function Desktop_ICON_User
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.User)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.User)"
	}

	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 0
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Control Panel
	.控制面板
#>
Function Desktop_ICON_Control_Panel
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.ControlPanel)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.ControlPanel)"
	}

	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 0
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Network
	.网络
#>
Function Desktop_ICON_Network
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.Network)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.Network)"
	}

	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.God Mode
	.上帝模式
#>
Function Desktop_ICON_God_Mode
{
	param
	(
		[switch]$AllUsers
	)

	write-host "  $($lang.DesktopCurrentUsers), $($lang.GodMode)"
	$DesktopPath = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
	New-Item -Path $DesktopPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}

<#
	.Internet Explorer
#>
Function Desktop_ICON_IE
{
	param
	(
		[switch]$AllUsers
	)

	if ($AllUsers) {
		write-host "  $($lang.DesktopAllUsers), $($lang.IE)"
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 0
	} else {
		write-host "  $($lang.DesktopCurrentUsers), $($lang.IE)"
	}


	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null }
	If (-not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel")) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null }
	Remove-Item -Recurse -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}" -Force -ErrorAction SilentlyContinue | Out-Null
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\DefaultIcon") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\DefaultIcon" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\InProcServer32") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\InProcServer32" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private\Command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private\Command" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns\Command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns\Command" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage\Command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage\Command" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties\command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties\command" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\ContextMenuHandlers\ieframe") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\ContextMenuHandlers\ieframe" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\MayChangeDefaultMenu") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\MayChangeDefaultMenu" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu") -ne $true) { New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Force -ErrorAction SilentlyContinue | Out-Null }
	if ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel") -ne $true) { New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Force -ErrorAction SilentlyContinue | Out-Null }
	Remove-Item -Recurse -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{871C5380-42A0-1069-A2EA-08002B30301D}" -Force -ErrorAction SilentlyContinue | Out-Null
    if ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{871C5380-42A0-1069-A2EA-08002B30301D}") -ne $true) { New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{871C5380-42A0-1069-A2EA-08002B30301D}" -Force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}' -Name '(default)' -Value 'Internet Explorer' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}' -Name 'InfoTip' -Value "@$env:SystemDrive\Windows\System32\ieframe.dll,-881" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\DefaultIcon' -Name '(default)' -Value "$($env:SystemDrive)\Windows\System32\ieframe.dll,-190" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\InProcServer32' -Name '(default)' -Value "$($env:SystemDrive)\Windows\System32\ieframe.dll" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\InProcServer32' -Name 'ThreadingModel' -Value 'Apartment' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell' -Name '(default)' -Value 'OpenHomePage' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private' -Name '(default)' -Value $($lang.IEPrivate) -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Private\Command' -Name '(default)' -Value """$($env:SystemDrive)\Program Files\Internet Explorer\iexplore.exe"" -private" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns' -Name '(default)' -Value $($lang.IENoAddOns) -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\NoAddOns\Command' -Name '(default)' -Value """$($env:SystemDrive)\Program Files\Internet Explorer\iexplore.exe"" -extoff" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage' -Name '(default)' -Value $($lang.IEOpenHomePage) -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\OpenHomePage\Command' -Name '(default)' -Value """$($env:SystemDrive)\Program Files\Internet Explorer\iexplore.exe""" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties' -Name '(default)' -Value $($lang.IEProperties) -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
    New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties' -Name "Position" -Value 'bottom' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\shell\Properties\command' -Name '(default)' -Value 'control.exe inetcpl.cpl' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\ContextMenuHandlers\ieframe' -Name '(default)' -Value '{871C5380-42A0-1069-A2EA-08002B30309D}' -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\Shellex\MayChangeDefaultMenu' -Name '(default)' -Value "" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name '(default)' -Value "$($env:SystemDrive)\Windows\System32\ieframe.dll,-190" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name 'HideAsDeletePerUser' -Value "" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name 'Attributes' -Value 36 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name 'HideFolderVerbs' -Value "" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name 'WantsParseDisplayName' -Value "" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\CLSID\{871C5380-42A0-1069-A2EA-08002B30301D}\ShellFolder' -Name 'HideOnDesktopPerUser' -Value "" -PropertyType String -Force -ErrorAction SilentlyContinue | Out-Null
	Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{871C5380-42A0-1069-A2EA-08002B30301D}' -Force -ErrorAction SilentlyContinue | Out-Null
	Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{871C5380-42A0-1069-A2EA-08002B30301D}' -Force -ErrorAction SilentlyContinue | Out-Null
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}