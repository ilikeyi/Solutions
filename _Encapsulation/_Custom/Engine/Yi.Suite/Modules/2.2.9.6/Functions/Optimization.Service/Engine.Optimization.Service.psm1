<#
	.Optimize service
	.优化服务
#>
$Services = @(
	"Spooler"
	"DPS"
	"WdiSystemHost"
	"WdiServiceHost"
	"diagnosticshub.standardcollector.service"
	"dmwappushservice"
	"lfsvc"
	"MapsBroker"
	"NetTcpPortSharing"
	"RemoteAccess"
	"RemoteRegistry"
	"SharedAccess"
	"TrkWks"
	"WbioSrvc"
	"WlanSvc"
	"WMPNetworkSvc"
	"WSearch"
	"XblAuthManager"
	"XblGameSave"
	"XboxNetApiSvc"
)

<#
	.Optimize the service user interface
	.优化服务用户界面
#>
Function Optimization_Service_UI
{
	Logo -Title "$($lang.Optimize) $($lang.Service)"
	write-host "  $($lang.Optimize) $($lang.Service)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "$($lang.Optimize) $($lang.Service)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 575
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "8,8,8,8"
		Dock           = 1
	}
	$GUIServerStatus   = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Location       = "11,590"
		Height         = 36
		Width          = 480
		Text           = $lang.Status
		Checked        = $true
	}
	$GUIServerReset    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 255
		Text           = $lang.Enable
		add_Click      = {
			$UI_Main.Hide()
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						write-host "  $($_.Text)"
						write-host "  $($lang.SettingTo -f $lang.Auto)" -ForegroundColor Green
						Get-Service -Name $_.Tag -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
						if ($GUIServerStatus.Checked) {
							write-host "  $($lang.Enable)" -ForegroundColor Green
							Start-Service $_.Tag -ErrorAction SilentlyContinue | Out-Null
						}

						write-host "  $($lang.Done)`n" -ForegroundColor Green
					}
				}
			}
			$UI_Main.Close()
		}
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "268,635"
		Height         = 36
		Width          = 255
		Text           = $lang.Disable
		add_Click      = {
			$UI_Main.Hide()
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						write-host "  $($_.Text)"
						write-host "  $($lang.SettingTo -f $lang.Disable)" -ForegroundColor Green
						Get-Service -Name $_.Tag -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
						if ($GUIServerStatus.Checked) {
							write-host "  $($lang.Close)" -ForegroundColor Green
							Stop-Service $_.Tag -Force -NoWait -ErrorAction SilentlyContinue | Out-Null
						}

						write-host "  $($lang.Done)`n" -ForegroundColor Green
					}
				}
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$GUIServerStatus,
		$GUIServerReset,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$ServiceUncheck = @(
		"Spooler"
		"WbioSrvc"
		"WlanSvc"
		"WSearch"
	)

	Get-Service -ErrorAction SilentlyContinue | ForEach-Object {
		if ($Services -Contains $_.Name) {
			if ($_.Status -eq "Stopped") {
			 	$ServiceUncheck += $_.Name
			}
		}
	}

	for ($i=0; $i -lt $Services.Count; $i++) {
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height  = 35
			Width   = 495
			Text    = $($lang.$($Services[$i]))
			Tag     = $Services[$i]
			Checked = $true
		}

		if ($ServiceUncheck -Contains $Services[$i]) {
			$CheckBox.Checked = $false
		}
		$UI_Main_Menu.controls.AddRange($CheckBox)
	}

	$GUIServerMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIServerMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIServerMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main.ContextMenuStrip = $GUIServerMenu

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$UI_Main.ShowDialog() | Out-Null
}