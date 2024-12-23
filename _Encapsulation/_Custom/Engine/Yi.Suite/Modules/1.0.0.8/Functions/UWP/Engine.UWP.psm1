<#
	.Exclude UWP apps
	.排除 UWP 应用
#>
$AppsExcluded = @(
	"Microsoft.549981C3F5F10"
	"Microsoft.DesktopAppInstaller"
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	"Microsoft.WebMediaExtensions"
	"Microsoft.BioEnrollment"
	"Microsoft.XboxGameCallableUI"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.XboxApp"
	"Microsoft.GamingApp"
	"Microsoft.GamingServices"
	"Microsoft.Xbox.TCUI"
	"Microsoft.XboxSpeechToTextOverlay"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.XboxGameOverlay"
)

<#
	.UWP apps not selected
	.不选择的 UWP 应用
#>
$AppsUncheck = @(
	# default Windows 10 apps
#	"Microsoft.549981C3F5F10"
	"MicrosoftTeams"
	"Microsoft.3DBuilder"
	"Microsoft.Appconnector"
	"Microsoft.BingFinance"
	"Microsoft.BingNews"
	"Microsoft.BingSports"
	"Microsoft.BingTranslator"
	"Microsoft.BingWeather"
#	"Microsoft.FreshPaint"
	"Microsoft.GamingServices"
	"Microsoft.Microsoft3DViewer"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.MicrosoftPowerBIForWindows"
#	"Microsoft.MicrosoftSolitaireCollection"
#	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.MinecraftUWP"
	"Microsoft.NetworkSpeedTest"
	"Microsoft.Office.OneNote"
	"Microsoft.People"
	"Microsoft.Print3D"
	"Microsoft.SkypeApp"
	"Microsoft.Wallet"
#	"Microsoft.Windows.Photos"
#	"Microsoft.WindowsAlarms"
#	"Microsoft.WindowsCalculator"
#	"Microsoft.WindowsCamera"
	"microsoft.windowscommunicationsapps"
	"Microsoft.WindowsMaps"
	"Microsoft.WindowsPhone"
	"Microsoft.WindowsSoundRecorder"
#	"Microsoft.WindowsStore"   # can't be re-installed
	"Microsoft.Xbox.TCUI"
	"Microsoft.XboxApp"
	"Microsoft.XboxGameOverlay"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.XboxSpeechToTextOverlay"
	"Microsoft.YourPhone"
#	"Microsoft.ZuneMusic"
#	"Microsoft.ZuneVideo"

	# Threshold 2 apps
	"Microsoft.CommsPhone"
	"Microsoft.ConnectivityStore"
	"Microsoft.GetHelp"
	"Microsoft.Getstarted"
	"Microsoft.Messaging"
	"Microsoft.Office.Sway"
	"Microsoft.OneConnect"
	"Microsoft.WindowsFeedbackHub"

	# Creators Update apps
	"Microsoft.Microsoft3DViewer"
#	"Microsoft.MSPaint"

	# Redstone apps
	"Microsoft.BingFoodAndDrink"
	"Microsoft.BingHealthAndFitness"
	"Microsoft.BingTravel"
	"Microsoft.WindowsReadingList"

	# Redstone 5 apps
	"Microsoft.MixedReality.Portal"
	"Microsoft.ScreenSketch"
	"Microsoft.XboxGamingOverlay"
	"Microsoft.YourPhone"

	# non-Microsoft
	"2FE3CB00.PicsArt-PhotoStudio"
	"46928bounde.EclipseManager"
	"4DF9E0F8.Netflix"
	"613EBCEA.PolarrPhotoEditorAcademicEdition"
	"6Wunderkinder.Wunderlist"
	"7EE7776C.LinkedInforWindows"
	"89006A2E.AutodeskSketchBook"
	"9E2F88E3.Twitter"
	"A278AB0D.DisneyMagicKingdoms"
	"A278AB0D.MarchofEmpires"
	"ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
	"CAF9E577.Plex"  
	"ClearChannelRadioDigital.iHeartRadio"
	"D52A8D61.FarmVille2CountryEscape"
	"D5EA27B7.Duolingo-LearnLanguagesforFree"
	"DB6EA5DB.CyberLinkMediaSuiteEssentials"
	"DolbyLaboratories.DolbyAccess"
	"DolbyLaboratories.DolbyAccess"
	"Drawboard.DrawboardPDF"
	"Facebook.Facebook"
	"Fitbit.FitbitCoach"
	"Flipboard.Flipboard"
	"GAMELOFTSA.Asphalt8Airborne"
	"KeeperSecurityInc.Keeper"
	"NORDCURRENT.COOKINGFEVER"
	"PandoraMediaInc.29680B314EFC2"
	"Playtika.CaesarsSlotsFreeCasino"
	"ShazamEntertainmentLtd.Shazam"
	"SlingTVLLC.SlingTV"
	"SpotifyAB.SpotifyMusic"
#	"TheNewYorkTimes.NYTCrossword"
	"ThumbmunkeysLtd.PhototasticCollage"
	"TuneIn.TuneInRadio"
	"WinZipComputing.WinZipUniversal"
	"XINGAG.XING"
	"flaregamesGmbH.RoyalRevolt2"
	"king.com.*"
	"king.com.BubbleWitch3Saga"
	"king.com.CandyCrushSaga"
	"king.com.CandyCrushSodaSaga"

	# apps which cannot be removed using Remove-AppxPackage
#	"Microsoft.BioEnrollment"
#	"Microsoft.MicrosoftEdge"
#	"Microsoft.Windows.Cortana"
#	"Microsoft.WindowsFeedback"
#	"Microsoft.XboxGameCallableUI"
#	"Microsoft.XboxIdentityProvider"
#	"Windows.ContactSupport"

	# apps which other apps depend on
	"Microsoft.Advertising.Xaml"
)

<#
	.Uninstall UWP app user interface
	.卸载 UWP 应用用户界面
#>
Function UWP_Uninstall
{

	Logo -Title "$($lang.Del) $($lang.UninstallUWP)"
	write-host "  $($lang.Del) $($lang.UninstallUWP)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function UWP_Refresh_List
	{
		$UI_Main_Refresh_Apps.Enabled = $False
		$UI_Main_Apps_Select.controls.Clear()
		$UI_Main_Depend_Select.controls.Clear()

		switch ((Get-Host).Version.Major) {
			7 {
				Get-AppxProvisionedPackage -Online | ForEach-Object {
					if ($AppsExcluded -notcontains $_.DisplayName) {
						$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
							Height = 35
							Width  = 365
							Text   = $_.DisplayName
							Tag    = $_.DisplayName
						}

						if (($AppsUncheck + $AppsExcluded) -Contains $_.DisplayName) {
							$CheckBox.Checked = $True
						}
						$UI_Main_Apps_Select.controls.AddRange($CheckBox)
					}
				}

				Get-AppxProvisionedPackage -Online | ForEach-Object {
					if ($AppsExcluded -Contains $_.DisplayName) {
						$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
							Height = 35
							Width  = 470
							Text   = $_.DisplayName
							Tag    = $_.DisplayName
						}
		
						if ($AppsUncheck -Contains $_.DisplayName) {
							$CheckBox.Checked = $True
						}
						$UI_Main_Depend_Select.controls.AddRange($CheckBox)
					}
				}
			}
			Default {
				Get-AppxProvisionedPackage -Online | ForEach-Object {
					if ($_.DisplayName -like "MicrosoftTeams") {
						$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
							Height = 35
							Width  = 365
							Text   = "MicrosoftTeams"
							Tag    = "MicrosoftTeams"
						}

						if (($AppsUncheck + $AppsExcluded) -Contains $_.Name) {
							$CheckBox.Checked = $True
						}
						$UI_Main_Apps_Select.controls.AddRange($CheckBox)
					}
				}

				[Windows.Management.Deployment.PackageManager, Windows.Web, ContentType = WindowsRuntime]::new().FindPackages() | Select-Object -ExpandProperty Id -Property DisplayName | Where-Object -FilterScript {
					($_.Name -in (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name) -and ($_.Name -notin $AppsExcluded) -and ($null -ne $_.DisplayName)} | ForEach-Object {
					$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
						Height = 35
						Width  = 365
						Text   = $_.DisplayName
						Tag    = $_.Name
					}
		
					if (($AppsUncheck + $AppsExcluded) -Contains $_.Name) {
						$CheckBox.Checked = $True
					}
					$UI_Main_Apps_Select.controls.AddRange($CheckBox)
				}

				[Windows.Management.Deployment.PackageManager, Windows.Web, ContentType = WindowsRuntime]::new().FindPackages() | Select-Object -ExpandProperty Id -Property DisplayName | Where-Object -FilterScript {
					($_.Name -in (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name) -and ($null -ne $_.DisplayName)} | ForEach-Object {
					if ($AppsExcluded -Contains $_.Name) {
						$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
							Height = 35
							Width  = 470
							Text   = $_.DisplayName
							Tag    = $_.Name
						}

						if ($AppsUncheck -Contains $_.Name) {
							$CheckBox.Checked = $True
						}
						$UI_Main_Depend_Select.controls.AddRange($CheckBox)
					}
				}
			}
		}

		$UI_Main_Refresh_Apps.Enabled = $True
	}

	$UI_Main            = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1015
		Text           = "$($lang.Del) $($lang.UninstallUWP)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Is_Apps   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 290
		Text           = $lang.UninstallUWP
		Location       = '10,10'
		Checked        = $True
		add_click      = {
			if ($UI_Main_Is_Apps.Checked) {
				$UI_Main_Apps_Select.Enabled = $True
			} else {
				$UI_Main_Apps_Select.Enabled = $False
			}
		}
	}
	$UI_Main_Apps_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 642
		Width          = 405
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "14,0,8,0"
		Dock           = 0
		Location       = '10,38'
	}

	<#
		.依赖性
	#>
	$UI_Main_Depend    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 510
		Text           = $lang.UninstallUWPRely
		Location       = '472,10'
		add_click      = {
			if ($UI_Main_Depend.Checked) {
				$UI_Main_Depend_Select.Enabled = $True
			} else {
				$UI_Main_Depend_Select.Enabled = $False
			}
		}
	}
	$UI_Main_Depend_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 255
		Width          = 510
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "18,0,8,0"
		Dock           = 0
		Location       = '472,38'
		Enabled        = $False
	}

	$UI_Main_Adv_Name  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 510
		Text           = $lang.AdvOption
		Location       = '472,320'
	}
	$UI_Main_Adv       = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 225
		Width          = 510
		Padding        = "18,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Location       = '472,350'
	}

	$UI_Main_Suggestions_Prevents_Apps = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Height         = 35
		Width          = 470
		Text           = $lang.PreventsApps
		Checked        = $True
	}
	$UI_Main_Suggestions_Content = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 470
		Text           = "$($lang.Hide) $($lang.TaskbarSuggestedContent)"
		Checked        = $true
	}
	$UI_Main_Close_Store_Auto_Download = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Height         = 35
		Width          = 470
		Text           = $lang.CloseStoreAuto
		Checked        = $True
	}
	$UI_Main_Suggestions_Apps = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Height         = 35
		Width          = 470
		Text           = $lang.PreventsSuggestApps
		Checked        = $True
	}
	$UI_Main_Suggestions_Device = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Height         = 35
		Width          = 470
		Text           = "$($lang.Disable) $($lang.SuggestionsDevice)"
		Checked        = $true
	}

	$UI_Main_Remove_Sync_To_All_User = New-Object System.Windows.Forms.CheckBox -Property @{
		UseVisualStyleBackColor = $True
		Location       = '474,598'
		Height         = 22
		Width          = 510
		Text           = $lang.DelAllUser
		Checked        = $true
	}

	$UI_Main_Refresh_Apps = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "472,635"
		Height         = 36
		Width          = 166
		add_Click      = { UWP_Refresh_List }
		Text           = $lang.Refresh
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "646,635"
		Height         = 36
		Width          = 166
		Text           = $lang.OK
		add_Click      = {
			$UI_Main.Hide()
			if ($UI_Main_Is_Apps.Enabled) {
				if ($UI_Main_Is_Apps.Checked) {
					$UI_Main_Apps_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($_.Checked) {
								write-host "  $($_.Text)"
								write-host "  $($lang.Del)".PadRight(22) -NoNewline
								if ($UI_Main_Remove_Sync_To_All_User.Checked) {
									Get-AppXProvisionedPackage -Online | Where-Object DisplayName -Like "$($_.Tag)" | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
									Get-AppxPackage -Name "$($_.Tag)" | Remove-AppxPackage | Out-Null
									Write-Host "$($lang.Done)`n" -ForegroundColor Green
								} else {
									Get-AppxPackage -Name "$($_.Tag)" | Remove-AppxPackage | Out-Null
									Write-Host "$($lang.Done)`n" -ForegroundColor Green
								}
							}
						}
					}
				}
			}

			if ($UI_Main_Depend.Enabled) {
				if ($UI_Main_Depend.Checked) {
					$UI_Main_Depend_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($_.Checked) {
								write-host "  $($_.Text)"
								write-host "  $($lang.Del)".PadRight(22) -NoNewline
								if ($UI_Main_Remove_Sync_To_All_User.Checked) {
									Get-AppXProvisionedPackage -Online | Where-Object DisplayName -Like "$($_.Tag)" | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
									Get-AppxPackage -Name "$($_.Tag)" | Remove-AppxPackage | Out-Null
									Write-Host "$($lang.Done)`n" -ForegroundColor Green
								} else {
									Get-AppxPackage -Name "$($_.Tag)" | Remove-AppxPackage | Out-Null
									Write-Host "$($lang.Done)`n" -ForegroundColor Green
								}
							}
						}
					}
				}
			}

			write-host "`n  $($lang.PreventsApps)"
			if ($UI_Main_Suggestions_Prevents_Apps.Checked) {
				write-host "  $($lang.Disable)".PadRight(22) -NoNewline
				$cdm = @(
					"ContentDeliveryAllowed"
					"FeatureManagementEnabled"
					"OemPreInstalledAppsEnabled"
					"PreInstalledAppsEnabled"
					"PreInstalledAppsEverEnabled"
					"SilentInstalledAppsEnabled"
				)

				New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force -ErrorAction SilentlyContinue | Out-Null
				ForEach ($item in $cdm) {
					New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name $item -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
				}
				Write-Host "$($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($UI_Main_Suggestions_Content.Checked) {
				Taskbar_Suggested_Content -Hide
			} else {
				write-host "  $($lang.TaskbarSuggestedContent)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.CloseStoreAuto)"
			if ($UI_Main_Close_Store_Auto_Download.Checked) {
				write-host "  $($lang.Disable)".PadRight(22) -NoNewline
				New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force -ErrorAction SilentlyContinue | Out-Null
				New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name 'AutoDownload' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
				Write-Host "$($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.PreventsSuggestApps)"
			if ($UI_Main_Suggestions_Apps.Checked) {
				write-host "  $($lang.Disable)".PadRight(22) -NoNewline
				New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force -ErrorAction SilentlyContinue | Out-Null
				New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
				Write-Host "$($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($UI_Main_Suggestions_Device.Checked) {
				Suggestions_Device -Disable
			}

			$UI_Main.Close()
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "820,635"
		Height         = 36
		Width          = 166
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Is_Apps,
		$UI_Main_Apps_Select,
		$UI_Main_Depend,
		$UI_Main_Depend_Select,
		$UI_Main_Adv_Name,
		$UI_Main_Adv,
		$UI_Main_Remove_Sync_To_All_User,
		$UI_Main_Refresh_Apps,
		$UI_Main_OK,
		$UI_Main_Canel
	))
	$UI_Main_Adv.controls.AddRange((
		$UI_Main_Suggestions_Prevents_Apps,
		$UI_Main_Suggestions_Content,
		$UI_Main_Close_Store_Auto_Download,
		$UI_Main_Suggestions_Apps,
		$UI_Main_Suggestions_Device
	))

	UWP_Refresh_List

	$UI_Main_Apps_Select_Right = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Apps_Select_Right.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Apps_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Apps_Select_Right.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Apps_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Apps_Select.ContextMenuStrip = $UI_Main_Apps_Select_Right

	$UI_Main_Depend_Select_Right = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Depend_Select_Right.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Depend_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Depend_Select_Right.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Depend_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Depend_Select.ContextMenuStrip = $UI_Main_Depend_Select_Right

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$UI_Main.ShowDialog() | Out-Null
}