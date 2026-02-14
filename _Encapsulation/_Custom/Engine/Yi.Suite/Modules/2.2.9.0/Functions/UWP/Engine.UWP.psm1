<#
	.Exclude UWP apps
	.排除 UWP 应用
#>
$AppsExcluded = @(
	"Microsoft.549981C3F5F10"                        # Cortana app (Voice assistant)
	"Microsoft.DesktopAppInstaller"                  # 
	"Microsoft.StorePurchaseApp"                     # 
	"Microsoft.WebMediaExtensions"                   # 
	"Microsoft.BioEnrollment"                        # 
	"Microsoft.XboxGameCallableUI"                   # 
	"Microsoft.XboxApp"                              # Old Xbox Console Companion App, no longer supported
	"Microsoft.GamingServices"                       # 
	"Microsoft.WindowsSoundRecorder"                 # Basic audio recording app

#	"Microsoft.BingSearch"                           # Web Search from Microsoft Bing (Integrates into Windows Search)
#	"Microsoft.Copilot"                              # New Microsoft Copilot app (AI assistant)
#	"Microsoft.Edge"                                 # Edge browser (Can only be uninstalled in European Economic Area)
	"Microsoft.GamingApp"                            # Modern Xbox Gaming App, required for installing some PC games
#	"Microsoft.GetHelp"                              # Required for some Windows 11 Troubleshooters and support interactions
#	"Microsoft.M365Companions"                       # Microsoft 365 (Business) Calendar, Files and People mini-apps, these apps may be reinstalled if enabled by your Microsoft 365 admin
#	"Microsoft.MSPaint"                              # Paint 3D (Modern paint application with 3D features)
#	"Microsoft.OneDrive"                             # OneDrive consumer cloud storage client
#	"Microsoft.OutlookForWindows"                    # New mail app: Outlook for Windows
#	"Microsoft.Paint"                                # Classic Paint (Traditional 2D paint application)
#	"Microsoft.People"                               # Required for & included with Mail & Calendar (Contacts management)
#	"Microsoft.RemoteDesktop"                        # Remote Desktop client app
	"Microsoft.ScreenSketch"                         # Snipping Tool (Screenshot and annotation tool)
#	"Microsoft.StartExperiencesApp"                  # This app powers Windows Widgets My Feed
#	"Microsoft.Whiteboard"                           # Digital collaborative whiteboard app
#	"Microsoft.Windows.Photos"                       # Default photo viewing and basic editing app
#	"Microsoft.WindowsCalculator"                    # Calculator app
#	"Microsoft.WindowsCamera"                        # Camera app for using built-in or connected cameras
#	"Microsoft.windowscommunicationsapps"            # Mail & Calendar app suite
#	"Microsoft.WindowsNotepad"                       # Notepad text editor app
	"Microsoft.WindowsStore"                         # Microsoft Store, WARNING: This app cannot be reinstalled easily if removed!
#	"Microsoft.WindowsTerminal"                      # New default terminal app in windows 11 (Command Prompt, PowerShell, WSL)
	"Microsoft.Xbox.TCUI"                            # UI framework, seems to be required for MS store, photos and certain games
	"Microsoft.XboxGameOverlay"                      # Game overlay, required/useful for some games (Part of Xbox Game Bar)
	"Microsoft.XboxGamingOverlay"                    # Game overlay, required/useful for some games (Part of Xbox Game Bar)
	"Microsoft.XboxIdentityProvider"                 # Xbox sign-in framework, required for some games and Xbox services
	"Microsoft.XboxSpeechToTextOverlay"              # Might be required for some games, WARNING: This app cannot be reinstalled easily! (Accessibility feature)
#	"Microsoft.YourPhone"                            # Phone link (Connects Android/iOS phone to PC)
#	"Microsoft.ZuneMusic"                            # Modern Media Player (Replaced Groove Music, plays local audio/video)
#	"MicrosoftWindows.CrossDevice"                   # Phone integration within File Explorer, Camera and more (Part of Phone Link features)

    "ACGMediaPlayer"                                 # Media player app
    "ActiproSoftwareLLC"                             # Potentially UI controls or software components, often bundled by OEMs
    "AdobeSystemsIncorporated.AdobePhotoshopExpress" # Basic photo editing app from Adobe
    "Amazon.com.Amazon"                              # Amazon shopping app
    "AmazonVideo.PrimeVideo"                         # Amazon Prime Video streaming service app
    "Asphalt8Airborne"                               # Racing game
    "AutodeskSketchBook"                             # Digital drawing and sketching app
    "CaesarsSlotsFreeCasino"                         # Casino slot machine game
    "COOKINGFEVER"                                   # Restaurant simulation game
    "CyberLinkMediaSuiteEssentials"                  # Multimedia software suite (often preinstalled by OEMs)
    "DisneyMagicKingdoms"                            # Disney theme park building game
    "Disney"                                         # General Disney content app (may vary by region/OEM, often Disney+)
    "DrawboardPDF"                                   # PDF viewing and annotation app, often focused on pen input
    "Duolingo-LearnLanguagesforFree"                 # Language learning app
    "EclipseManager"                                 # Often related to specific OEM software or utilities (e.g., for managing screen settings)
    "Facebook"                                       # Facebook social media app
    "FarmVille2CountryEscape"                        # Farming simulation game
    "fitbit"                                         # Fitbit activity tracker companion app
    "Flipboard"                                      # News and social network aggregator styled as a magazine
    "HiddenCity"                                     # Hidden object puzzle adventure game
    "HULULLC.HULUPLUS"                               # Hulu streaming service app
    "iHeartRadio"                                    # Internet radio streaming app
    "Instagram"                                      # Instagram social media app
    "king.com.BubbleWitch3Saga"                      # Puzzle game from King
    "king.com.CandyCrushSaga"                        # Puzzle game from King
    "king.com.CandyCrushSodaSaga"                    # Puzzle game from King
    "LinkedInforWindows"                             # LinkedIn professional networking app
    "MarchofEmpires"                                 # Strategy game
    "Netflix"                                        # Netflix streaming service app
    "NYTCrossword"                                   # New York Times crossword puzzle app
    "OneCalendar"                                    # Calendar aggregation app
    "PandoraMediaInc"                                # Pandora music streaming app
    "PhototasticCollage"                             # Photo collage creation app
    "PicsArt-PhotoStudio"                            # Photo editing and creative app
    "Plex"                                           # Media server and player app
    "PolarrPhotoEditorAcademicEdition"               # Photo editing app (Academic Edition)
    "Royal Revolt"                                   # Tower defense / strategy game
    "Shazam"                                         # Music identification app
    "Sidia.LiveWallpaper"                            # Live wallpaper app
    "SlingTV"                                        # Live TV streaming service app
    "Spotify"                                        # Spotify music streaming app
    "TikTok"                                         # TikTok short-form video app
    "TuneInRadio"                                    # Internet radio streaming app
    "Twitter"                                        # Twitter (now X) social media app
    "Viber"                                          # Messaging and calling app
    "WinZipUniversal"                                # File compression and extraction utility (Universal Windows Platform version)
    "Wunderlist"                                     # To-do list app (Acquired by Microsoft, functionality moved to Microsoft To Do)
    "XING"                                           # Professional networking platform popular in German-speaking countries

	"DolbyLaboratories.DolbyAccess"                  # Dolby Access
	"DTSInc.DTSAudioProcessing"                      # Dolby Sound Unbound
	"#AD2F1837.HPAIExperienceCenter"               # HP OEM software, AI-enhanced features and support
	"#AD2F1837.HPConnectedMusic"                   # HP OEM software for music (Potentially discontinued)
	"#AD2F1837.HPConnectedPhotopoweredbySnapfish"  # HP OEM software for photos, integrated with Snapfish (Potentially discontinued)
	"#AD2F1837.HPDesktopSupportUtilities"          # HP OEM software providing desktop support tools
	"#AD2F1837.HPEasyClean"                        # HP OEM software for system cleaning or optimization
	"#AD2F1837.HPFileViewer"                       # HP OEM software for viewing specific file types
	"#AD2F1837.HPJumpStarts"                       # HP OEM software for tutorials, app discovery, or quick access to HP features
	"#AD2F1837.HPPCHardwareDiagnosticsWindows"     # HP OEM software for PC hardware diagnostics
	"#AD2F1837.HPPowerManager"                     # HP OEM software for managing power settings and battery
	"#AD2F1837.HPPrinterControl"                   # HP OEM software for managing HP printers
	"#AD2F1837.HPPrivacySettings"                  # HP OEM software for managing privacy settings
	"#AD2F1837.HPQuickDrop"                        # HP OEM software for quick file transfer between devices
	"#AD2F1837.HPQuickTouch"                       # HP OEM software, possibly for touch-specific shortcuts or controls
	"#AD2F1837.HPRegistration"                     # HP OEM software for product registration
	"#AD2F1837.HPSupportAssistant"                 # HP OEM software for support, updates, and troubleshooting
	"#AD2F1837.HPSureShieldAI"                     # HP OEM security software, likely AI-based threat protection
	"#AD2F1837.HPSystemInformation"                # HP OEM software for displaying system information
	"#AD2F1837.HPWelcome"                          # HP OEM software providing a welcome experience or initial setup help
	"#AD2F1837.HPWorkWell"                         # HP OEM software focused on well-being, possibly with break reminders or ergonomic tips
	"#AD2F1837.myHP"                               # HP OEM central hub app for device info, support, and services
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
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Is_Apps   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
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
		Location       = '10,38'
	}

	<#
		.依赖性
	#>
	$UI_Main_Depend    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
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
		Height         = 30
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
		Height         = 30
		Width          = 510
		Text           = $lang.DelAllUser
		Checked        = $true
	}

	$UI_Main_Refresh_Apps = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "472,635"
		Height         = 36
		Width          = 255
		add_Click      = { UWP_Refresh_List }
		Text           = $lang.Refresh
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "732,635"
		Height         = 36
		Width          = 255
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
	$UI_Main.controls.AddRange((
		$UI_Main_Is_Apps,
		$UI_Main_Apps_Select,
		$UI_Main_Depend,
		$UI_Main_Depend_Select,
		$UI_Main_Adv_Name,
		$UI_Main_Adv,
		$UI_Main_Remove_Sync_To_All_User,
		$UI_Main_Refresh_Apps,
		$UI_Main_OK
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