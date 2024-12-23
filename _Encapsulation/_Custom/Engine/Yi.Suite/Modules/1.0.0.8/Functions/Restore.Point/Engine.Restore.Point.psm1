<#
	.Restore point user interface
	.还原点用户界面
#>
Function Restore_Point_Create_UI
{
	Logo -Title $lang.RestorePoint
	write-host "  $($lang.RestorePoint)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	$Path = "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Suite"
	if (-not (Test-Path $Path)) {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		AutoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.RestorePoint
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 508
		Text           = $lang.RestorePointCreate
		Location       = "12,10"
		Checked        = $true
	}
	$UI_Main_Tips      = New-Object System.Windows.Forms.Label -Property @{
		Height         = 100
		Width          = 492
		Text           = $lang.RestorePointCreateTips
		Location       = '27,38'
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$UI_Main.Hide()
			if ($UI_Main_Menu.Checked) { Restore_Point_Create }
			$UI_Main.Close()
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "268,635"
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$UI_Main.ShowDialog() | Out-Null
}

<#
	.Create a system restore
	.创建系统还原
#>
Function Restore_Point_Create
{
	Enable-ComputerRestore -drive $env:SystemDrive -ErrorAction SilentlyContinue
	New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name 'SystemRestorePointCreationFrequency' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	Checkpoint-Computer -description "$((Get-Module -Name Engine).Author)" -restorepointtype "Modify_Settings" -ErrorAction SilentlyContinue
	New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name 'SystemRestorePointCreationFrequency' -Value 1440 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	Disable-ComputerRestore -Drive $env:SystemDrive -ErrorAction SilentlyContinue
	write-host "  $($lang.Done)`n" -ForegroundColor Green
}