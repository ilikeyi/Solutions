<#
	.Optimize the system user interface
	.优化系统用户界面
#>
Function Optimization_System_UI
{
	Logo -Title "$($lang.Optimize) $($lang.System)"
	write-host "  $($lang.Optimize) $($lang.System)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main_Restore_Click = {
		$GUIOS.Hide()
		if ($UI_Main_Optimiz_Other_Is.Enabled) {
			if ($UI_Main_Optimiz_Other_Is.Checked) {
				if ($GUITPMSetup.Checked) { Win11_TPM_Setup -Restore }
				if ($GUITPMUpdate.Checked) { Win11_TPM_Update -Restore }
				if ($GUIKeepSpace.Checked) { Keep_Space -Enabled }
				if ($GUIHibernation.Checked) { Hibernation -Enabled }
				if ($GUIPowerSupply.Checked) { Power_Supply -Restore }
				if ($GUIAppRestartScreen.Checked) { App_Restart_Screen -Enabled }
				if ($GUINumLock.Checked) { Numlock -Disable }
				if ($GUIUAC.Checked)  { UAC_Never -Enabled }
				if ($GUISmartScreenApps.Checked) { Smart_Screen_Apps -Enabled }
				if ($GUISmartScreenSafe.Checked) { Smart_Screen_Safe -Enabled }
				if ($GUIEasyAccessKeyboard.Checked) { Easy_Access_Keyboard -Enabled }
				if ($GUIMaintain.Checked) { Maintain -Enabled }
				if ($GUIExperience.Checked) { Experience -Enabled }
				if ($GUIDefragmentation.Checked) { Defragmentation -Enabled }
				if ($GUICompatibility.Checked) { Compatibility -Enabled }
				if ($GUIAnimationEffects.Checked) { Animation_Effects -Restore }
				if ($GUIErrorRecovery.Checked) { Error_Recovery -Enabled }
				if ($GUIDEP.Checked) { DEPPAE -Enabled }
				if ($GUIPowerFailure.Checked) { Power_Failure -Enabled }
				if ($GUIPwdUnlimited.Checked) { Password_Unlimited -Enabled }
				if ($GUIRAM.Checked) { RAM -Enabled }
				if ($GUIStorageSense.Checked) { Storage_Sense -Enabled }
				if ($GUIDelivery.Checked) { Delivery -Enabled }
				if ($GUIPhotoPreview.Checked) { Photo_Preview -Disable }
				if ($GUIProtected.Checked) { Protected -Enabled }
				if ($GUIErrorReporting.Checked) { Error_Reporting -Enabled }
				if ($GUIF8BootMenu.Checked) { F8_Boot_Menu -Enabled }
				if ($GUISSD.Checked) { SSD -Enabled }
				if ($GUIMemoryCompression.Checked) { Memory_Compression -Enabled }
				if ($GUIPrelaunch.Checked) { Prelaunch -Enabled }
				if ($GUISSUpdateFirstLogonAnimation.Checked) { First_Logon_Animation -Enabled }
			}
		}

		<#
			.网络优化
		#>
		if ($GUINetwork.Enabled) {
			if ($GUINetwork.Checked) {
				if ($GUIIEProxy.Checked) { IEProxy }
				if ($GUIIEAutoSet.Checked) { Auto_Detect -Enabled }
				if ($GUINetworkDiscovery.Checked) { Network_Discovery -Enabled }
				if ($GUINetworkAdaptersPM.Checked) { Network_Adapters_Save_Power -Enabled }
				if ($GUIIPv6Component.Checked) { IPv6_Component -Enabled }
				if ($GUIQOS.Checked) { QOS -Enabled }
				if ($GUINetworkTuning.Checked) { Network_Tuning -Enabled }
				if ($GUIECN.Checked) { ECN -Enabled }
			}
		}

		<#
			.资源管理器
		#>
		if ($GUIExplorer.Enabled) {
			if ($GUIExplorer.Checked) {
				if ($GUISeparateProcess.Checked) { Separate_Process -Enabled }
				if ($GUIRestartApps.Checked) { Restart_Apps -Enabled }
				if ($GUICheckBoxes.Checked) { Check_Boxes -Enabled }
				if ($GUIThumbnailCache.Checked) { Thumbnail_Cache -Enabled }
				if ($GUIToThisPC.Checked) { Explorer_Open_To -QuickAccess }
				if ($GUIAeroShake.Checked) {
					if ($UI_Main_Sync_To_All_User.Checked) {
						Aero_Shake -Enabled -AllUser
					} else {
						Aero_Shake -Enabled
					}
				}
				if ($GUIFileExtensions.Checked) { File_Extensions -Hide }
				if ($GUISafetyWarnings.Checked) { Safety_Warnings -Enabled }
				if ($GUIFileTransfer.Checked) { File_Transfer_Dialog -Simple }
				if ($GUINavShowAll.Checked) { Nav_Show_All -Disable }
				if ($GUIAutoplay.Checked) { Autoplay -Enabled }
				if ($GUIAutorun.Checked) { Autorun -Enabled }
				if ($GUIQuickAccessFiles.Checked) { Quick_Access_Files -Show }
				if ($GUIQuickAccessFolders.Checked) { Quick_Access_Folders -Show }
				if ($GUIShortcutArrow.Checked) { Shortcut_Arrow -Enabled }
				if ($GUIThisPCDesktop.Checked) { Desktop_Icon_ThisPC -Enabled }
				if ($GUIThisPCDocument.Checked) { Desktop_Icon_Document -Enabled }
				if ($GUIThisPCDownload.Checked) { Desktop_Icon_Download -Enabled }
				if ($GUIThisPCMusic.Checked) { Desktop_Icon_Music -Enabled }
				if ($GUIThisPCPicture.Checked) { Desktop_Icon_Picture -Enabled }
				if ($GUIThisPCVideo.Checked) { Desktop_Icon_Video -Enabled }
				if ($GUIThisPC3D.Checked) { Desktop_Icon_3D -Enabled }
			}
		}

		<#
			.Right click menu
			.右键菜单
		#>
		if ($GUIContextMenu.Enabled) {
			if ($GUIContextMenu.Checked) {
				if ($GUIClassicModern.Checked) { Win11_Context_Menu -Modern }
				if ($GUIOwnership.Checked) { Take_Ownership -Remove }
				if ($GUICopyPath.Checked) { Copy_Path -Remove }
				if ($GUIMultipleIncrease.Checked) { File_Selection_Restrictions -Enabled }
			}
		}

		<#
			.Personalise
			.个性化
		#>
		if ($GUIPersonalise.Enabled) {
			if ($GUIPersonalise.Checked) {
				if ($GUIPersonaliseDarkApps.Checked) { Dark_Mode_To_Apps -Light }
				if ($GUIPersonaliseDarkSystem.Checked) { Dark_Mode_To_System -Light }
				if ($GUIPersonaliseTransparencyEffects.Checked) { Transparency_Effects -Enabled }
				if ($GUIPersonaliseSnapAssistFlyout.Checked) { Snap_Assist_Flyout -Enabled }
			}
		}

		<#
			.Start menu and taskbar
			.开始菜单和任务栏
		#>
		if ($GUIStart.Enabled) {
			if ($GUIStart.Checked) {
				if ($GUITaskbarWidgets.Checked) { Taskbar_Widgets -Show }
				if ($GUITaskbarWidgetsRemove.Checked) { Taskbar_Widgets_Remove -Restore }
				if ($GUITeamsAutostarting.Checked) { Teams_Autostarting -Enabled }
				if ($GUITeamsTaskbarChat.Checked) { Teams_Taskbar_Chat -Show }
				if ($GUIBingSearch.Checked) { Bing_Search -Enabled }
				if ($GUITaskbarSuggestedContent.Checked) { Taskbar_Suggested_Content -Show }
				if ($GUISuggestionsDevice.Checked) { Suggestions_Device -Enabled }
				if ($GUISearchBox.Checked) {
					Search_Box -SearchBox
					Restart_Explorer
				}
				if ($GUIMergeTaskbarNever.Checked) { Merge_Taskbar_Never -Disable }
				if ($GUINotificationAlways.Checked) { Notification_Center_Always -Disable }
				if ($GUICortana.Checked) {
					Cortana -Enabled
					Restart_Explorer
				}
				if ($GUITaskView.Checked) { Task_View -Show }
			}
		}

		<#
			.Game Bar
		#>
		if ($GUIXboxGame.Enabled) {
			if ($GUIXboxGame.Checked) {
				if ($GUIXboxGameBar.Checked) { XboxGameBar -Enabled }
				if ($GUIXboxGameBarTips.Checked) { XboxGameBarTips -Enabled }
				if ($GUIXboxGameMode.Checked) { XboxGameMode -Enabled }
				if ($GUIXboxGameDVR.Checked) { XboxGameDVR -Enabled }
			}
		}

		<#
			.隐私类
		#>
		if ($GUIPrivate.Enabled) {
			if ($GUIPrivate.Checked) {
				if ($GUIScheduledTasks.Checked) { Scheduled_Tasks -Restore }
				if ($GUIPrivacyVoiceTyping.Checked) { Privacy_Voice_Typing -Enabled }
				if ($GUIPrivacyContactsSpeech.Checked) { Privacy_Contacts_Speech -Enabled }
				if ($GUIPrivacyLanguageOptOut.Checked) { Privacy_Language_Opt_Out -Enabled }
				if ($GUIPrivacyAds.Checked) { Privacy_Ads -Enabled }
				if ($GUILocatonAware.Checked) { Privacy_Locaton_Aware -Enabled }
				if ($GUIPrivacySetSync.Checked) { Privacy_Set_Sync -Enabled }
				if ($GUIInkingTyping.Checked) { Privacy_Inking_Typing -Enabled }
				if ($GUIShareUnpairedDevices.Checked) { Privacy_Share_Unpaired_Devices -Enabled }
				if ($GUILocationSensor.Checked) { Privacy_Location_Sensor -Enabled }
				if ($GUIBiometrics.Checked) { Privacy_Biometrics -Enabled }
				if ($GUICompatibleTelemetry.Checked) { Privacy_Compatible_Telemetry -Enabled }
				if ($GUIDiagnosticData.Checked) { Privacy_Diagnostic_Data -Enabled }
				if ($GUITailoredExperiences.Checked) { Privacy_Tailored_Experiences -Enabled }
				if ($GUIFeedbackNotifications.Checked) { Privacy_Feedback_Notifications -Enabled }
				if ($GUILocationTracking.Checked) { Privacy_Location_Tracking -Enabled }
				if ($GUIExperiencesTelemetry.Checked) { Privacy_Experiences_Telemetry -Enabled }
				if ($GUIPrivacyBackgroundAccess.Checked) { Privacy_Background_Access -Enabled }
				if ($GUITimelineTime.Checked) { Timeline_Time -Enabled }
				if ($GUICollectActivity.Checked) { Collect_Activity -Enabled }
			}
		}

		<#
			.系统盘分页大小
		#>
		if ($GUIPagingSize.Enabled) {
			if ($GUIPagingSize.Checked) {
				System_Disk_Page_Size -Disable
			}
		}

		<#
			.通知中心
		#>
		if ($GUINotification.Enabled) {
			if ($GUINotification.Checked) {
				Notification_Center -Restore
			}
		}

		if ($UI_Main_Sync_To_TaskBar.Checked) { Reset_TaskBar }
		if ($UI_Main_Reset_Desktop_Icon.Checked) { Reset_Desktop }

		gpupdate /force | out-null
		Start-Sleep 5
		$Running = Get-Process explorer -ErrorAction SilentlyContinue
		if (-not ($Running)) {
			Start-Process "explorer.exe"
		}
		$GUIOS.Close()
	}
	$UI_Main_OK_Click = {
		$GUIOS.Hide()

		if ($UI_Main_Optimiz_Other_Is.Enabled) {
			if ($UI_Main_Optimiz_Other_Is.Checked) {
				if ($GUITPMSetup.Checked) { Win11_TPM_Setup -Disable }
				if ($GUITPMUpdate.Checked) { Win11_TPM_Update -Disable }
				if ($GUIKeepSpace.Checked) { Keep_Space -Disable }
				if ($GUIHibernation.Checked) { Hibernation -Disable }
				if ($GUIPowerSupply.Checked) { Power_Supply -Optimize }
				if ($GUIAppRestartScreen.Checked) { App_Restart_Screen -Disable }
				if ($GUINumLock.Checked) { Numlock -Enabled }
				if ($GUIUAC.Checked) { UAC_Never -Disable }
				if ($GUISmartScreenApps.Checked) { Smart_Screen_Apps -Disable }
				if ($GUISmartScreenSafe.Checked) { Smart_Screen_Safe -Disable }
				if ($GUIEasyAccessKeyboard.Checked) { Easy_Access_Keyboard -Disable }
				if ($GUIMaintain.Checked) { Maintain -Disable }
				if ($GUIExperience.Checked) { Experience -Disable }
				if ($GUIDefragmentation.Checked) { Defragmentation -Disable }
				if ($GUICompatibility.Checked) { Compatibility -Disable }
				if ($GUIAnimationEffects.Checked) { Animation_Effects -Optimize }
				if ($GUIErrorRecovery.Checked) { Error_Recovery -Disable }
				if ($GUIDEP.Checked) { DEPPAE -Disable }
				if ($GUIPowerFailure.Checked) { Power_Failure -Disable }
				if ($GUIPwdUnlimited.Checked) { Password_Unlimited -Disable }
				if ($GUIRAM.Checked) { RAM -Disable }
				if ($GUIStorageSense.Checked) { Storage_Sense -Disable }
				if ($GUIDelivery.Checked) { Delivery -Disable }
				if ($GUIPhotoPreview.Checked) { Photo_Preview -Enabled }
				if ($GUIProtected.Checked) { Protected -Disable }
				if ($GUIErrorReporting.Checked) { Error_Reporting -Disable }
				if ($GUIF8BootMenu.Checked) { F8_Boot_Menu -Disable }
				if ($GUISSD.Checked) { SSD -Disable }
				if ($GUIMemoryCompression.Checked) { Memory_Compression -Disable }
				if ($GUIPrelaunch.Checked) { Prelaunch -Disable }
				if ($GUISSUpdateFirstLogonAnimation.Checked) { First_Logon_Animation -Disable }
			}
		}

		<#
			.网络优化
		#>
		if ($GUINetwork.Enabled) {
			if ($GUINetwork.Checked) {
				if ($GUIIEProxy.Checked) { IEProxy }
				if ($GUIIEAutoSet.Checked) { Auto_Detect -Disable }
				if ($GUINetworkDiscovery.Checked) { Network_Discovery -Disable }
				if ($GUINetworkAdaptersPM.Checked) { Network_Adapters_Save_Power -Disable }
				if ($GUIIPv6Component.Checked) { IPv6_Component -Disable }
				if ($GUIQOS.Checked) { QOS -Disable }
				if ($GUINetworkTuning.Checked) { Network_Tuning -Disable }
				if ($GUIECN.Checked) { ECN -Disable }
			}
		}

		<#
			.Resource manager
			.资源管理器
		#>
		if ($GUIExplorer.Enabled) {
			if ($GUIExplorer.Checked) {
				if ($GUISeparateProcess.Checked) { Separate_Process -Disable }
				if ($GUIRestartApps.Checked) { Restart_Apps -Disable }
				if ($GUICheckBoxes.Checked) { Check_Boxes -Disable }
				if ($GUIThumbnailCache.Checked) { Thumbnail_Cache -Disable }
				if ($GUIToThisPC.Checked) { Explorer_Open_To -ThisPC }
				if ($GUIAeroShake.Checked) {
					if ($UI_Main_Sync_To_All_User.Checked) {
						Aero_Shake -Disable -AllUser
					} else {
						Aero_Shake -Disable
					}
				}
				if ($GUIFileExtensions.Checked) { File_Extensions -Show }
				if ($GUISafetyWarnings.Checked) { Safety_Warnings -Disable }
				if ($GUIFileTransfer.Checked) { File_Transfer_Dialog -Detailed }
				if ($GUINavShowAll.Checked) { Nav_Show_All -Enabled }
				if ($GUIAutoplay.Checked) { Autoplay -Disable }
				if ($GUIAutorun.Checked) { Autorun -Disable }
				if ($GUIQuickAccessFiles.Checked) { Quick_Access_Files -Hide }
				if ($GUIQuickAccessFolders.Checked) { Quick_Access_Folders -Hide }
				if ($GUIShortcutArrow.Checked) { Shortcut_Arrow -Disable }
				if ($GUIThisPCDesktop.Checked) { Desktop_Icon_ThisPC -Disable }
				if ($GUIThisPCDocument.Checked) { Desktop_Icon_Document -Disable }
				if ($GUIThisPCDownload.Checked) { Desktop_Icon_Download -Disable }
				if ($GUIThisPCMusic.Checked) { Desktop_Icon_Music -Disable }
				if ($GUIThisPCPicture.Checked) { Desktop_Icon_Picture -Disable }
				if ($GUIThisPCVideo.Checked) { Desktop_Icon_Video -Disable }
				if ($GUIThisPC3D.Checked) { Desktop_Icon_3D -Disable }
			}
		}

		<#
			.Right click menu
			.右键菜单
		#>
		if ($GUIContextMenu.Enabled) {
			if ($GUIContextMenu.Checked) {
				if ($GUIClassicModern.Checked) { Win11_Context_Menu -Classic }
				if ($GUIOwnership.Checked) {
					Take_Ownership -Remove
					Take_Ownership -Add
				}
				if ($GUICopyPath.Checked) {
					Copy_Path -Remove
					Copy_Path -Add
				}
				if ($GUIMultipleIncrease.Checked) { File_Selection_Restrictions -Disable }
			}
		}

		<#
			.Personalise
			.个性化
		#>
		if ($GUIPersonalise.Enabled) {
			if ($GUIPersonalise.Checked) {
				if ($GUIPersonaliseDarkApps.Checked) { Dark_Mode_To_Apps -Dark }
				if ($GUIPersonaliseDarkSystem.Checked) { Dark_Mode_To_System -Dark }
				if ($GUIPersonaliseTransparencyEffects.Checked) { Transparency_Effects -Disable }
				if ($GUIPersonaliseSnapAssistFlyout.Checked) { Snap_Assist_Flyout -Disable }
			}
		}
	
		<#
			.开始菜单和任务栏
		#>
		if ($GUIStart.Enabled) {
			if ($GUIStart.Checked) {
				if ($GUITaskbarWidgets.Checked) { Taskbar_Widgets -Hide }
				if ($GUITaskbarWidgetsRemove.Checked) { Taskbar_Widgets_Remove -Remove }
				if ($GUITeamsAutostarting.Checked) { Teams_Autostarting -Disable }
				if ($GUITeamsTaskbarChat.Checked) { Teams_Taskbar_Chat -Hide }
				if ($GUIBingSearch.Checked) { Bing_Search -Disable }
				if ($GUITaskbarSuggestedContent.Checked) { Taskbar_Suggested_Content -Hide }
				if ($GUISuggestionsDevice.Checked) { Suggestions_Device -Disable }
				if ($GUISearchBox.Checked) {
					Search_Box -SearchIcon
					Restart_Explorer
				}
				if ($GUIMergeTaskbarNever.Checked) { Merge_Taskbar_Never -Enabled }
				if ($GUINotificationAlways.Checked) { Notification_Center_Always -Enabled }
				if ($GUICortana.Checked) {
					Cortana -Disable
					Restart_Explorer
				}
				if ($GUITaskView.Checked) { Task_View -Hide }
			}
		}

		<#
			.Game Bar
		#>
		if ($GUIXboxGameBar.Enabled) {
			if ($GUIXboxGameBar.Checked) {
				if ($GUIXboxGameBar.Checked) { XboxGameBar -Disable }
				if ($GUIXboxGameBarTips.Checked) { XboxGameBarTips -Disable }
				if ($GUIXboxGameMode.Checked) { XboxGameMode -Disable }
				if ($GUIXboxGameDVR.Checked) { XboxGameDVR -Disable }
			}
		}

		<#
			.隐私类
		#>
		if ($GUIPrivate.Enabled) {
			if ($GUIPrivate.Checked) {
				if ($GUIScheduledTasks.Checked) { Scheduled_Tasks -Disable }
				if ($GUIPrivacyVoiceTyping.Checked) { Privacy_Voice_Typing -Disable }
				if ($GUIPrivacyContactsSpeech.Checked) { Privacy_Contacts_Speech -Disable }
				if ($GUIPrivacyLanguageOptOut.Checked) { Privacy_Language_Opt_Out -Disable }
				if ($GUIPrivacyAds.Checked) { Privacy_Ads -Disable }
				if ($GUILocatonAware.Checked) { Privacy_Locaton_Aware -Disable }
				if ($GUIPrivacySetSync.Checked) { Privacy_Set_Sync -Disable }
				if ($GUIInkingTyping.Checked) { Privacy_Inking_Typing -Disable }
				if ($GUIShareUnpairedDevices.Checked) { Privacy_Share_Unpaired_Devices -Disable }
				if ($GUILocationSensor.Checked) { Privacy_Location_Sensor -Disable }
				if ($GUIBiometrics.Checked) { Privacy_Biometrics -Disable }
				if ($GUICompatibleTelemetry.Checked) { Privacy_Compatible_Telemetry -Disable }
				if ($GUIDiagnosticData.Checked) { Privacy_Diagnostic_Data -Disable }
				if ($GUITailoredExperiences.Checked) { Privacy_Tailored_Experiences -Disable }
				if ($GUIFeedbackNotifications.Checked) { Privacy_Feedback_Notifications -Disable }
				if ($GUILocationTracking.Checked) { Privacy_Location_Tracking -Disable }
				if ($GUIExperiencesTelemetry.Checked) { Privacy_Experiences_Telemetry -Disable }
				if ($GUIPrivacyBackgroundAccess.Checked) { Privacy_Background_Access -Disable }
				if ($GUITimelineTime.Checked) { Timeline_Time -Disable }
				if ($GUICollectActivity.Checked) { Collect_Activity -Disable }
			}
		}

		<#
			.通知中心
		#>
		if ($GUINotification.Enabled) {
			if ($GUINotification.Checked) {
				if ($GUINotificationFull.Checked) {
					Notification_Center -Restore
					Notification_Center -Full
				}
				if ($GUINotificationPart.Checked) {
					Notification_Center -Restore
					Notification_Center -Part
				}
			}
		}

		<#
			.系统盘分页大小
		#>
		if ($GUIPagingSize.Enabled) {
			if ($GUIPagingSize.Checked) {
				if ($GUIPagingSizeLow.Checked) { System_Disk_Page_Size -enabled -size 8 }
				if ($GUIPagingSizeHigh.Checked) { System_Disk_Page_Size -Enabled -size 16 }
			}
		}

		<#
			.其它类
		#>
		if ($UI_Main_Is_Other.Enabled) {
			if ($UI_Main_Is_Other.Checked) {
				if ($UI_Main_Other_RDS.Checked) { Remote_Desktop }
				if ($UI_Main_Other_SMB.Checked) { SMB_File_Share }
			}
		}

		<#
			.清理类
		#>
		if ($UI_Main_Is_Clear.Enabled) {
			if ($UI_Main_Is_Clear.Checked) {
				if ($UI_Main_Clear_Send_To.Checked) { Send_To }
				if ($UI_Main_Clear_System_Logs.Checked) { Cleanup_System_Log }
				if ($UI_Main_Clear_Disk.Checked) {
					Start-Job -ScriptBlock ${function:Cleanup_Disk} -ErrorAction SilentlyContinue | Out-Null
				}
				if ($UI_Main_Clear_Sxs.Checked) { Cleanup_SxS }
			}
		}

		if ($UI_Main_Sync_To_TaskBar.Checked) { Reset_TaskBar }
		if ($UI_Main_Reset_Desktop_Icon.Checked) { Reset_Desktop }

		gpupdate /force | out-null
		Start-Sleep 5
		$Running = Get-Process explorer -ErrorAction SilentlyContinue
		if (-not ($Running)) {
			Start-Process "explorer.exe"
		}
		$GUIOS.Close()
	}
	$GUIOS             = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1015
		Text           = "$($lang.Optimize) $($lang.System)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 56
		Width          = 480
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "12,12,8,0"
		Dock           = 3
		Location       = '0,0'
	}

	<#
		.优化类
	#>
	$UI_Main_Optimiz_Other_Is = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.Optimize
		Checked        = $True
		Margin         = "2,6,0,0"
		add_click      = {
			if ($UI_Main_Optimiz_Other_Is.Checked) {
				$UI_Main_Optimiz_Other.Enabled = $True
			} else {
				$UI_Main_Optimiz_Other.Enabled = $False
			}
		}
	}
	$UI_Main_Optimiz_Other = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUITPMSetup       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TPMSetup)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUITPMUpdate      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TPMUpdate)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIKeepSpace      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.KeepSpace)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIHibernation    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.Hibernation)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPowerSupply    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.PowerSupply)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIAppRestartScreen = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.AppRestartScreen)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUINumLock        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.NumLock)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIUAC            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.UAC)$($lang.UACNever)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUISmartScreenApps = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.SmartScreenApps)"
		ForeColor      = "#008000"
	}
	$GUISmartScreenSafe = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.SmartScreenSafe)"
		ForeColor      = "#008000"
	}
	$GUIEasyAccessKeyboard = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.EasyAccessKeyboard)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIMaintain       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.Maintain)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIExperience     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.Experience)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIDefragmentation = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.Defragmentation)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUICompatibility  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.Compatibility)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIAnimationEffects = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Optimize) $($lang.AnimationEffects)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIErrorRecovery  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.ErrorRecovery)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIDEP            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.DEP) ( $($lang.Restart) )"
		ForeColor      = "#008000"
	}
	$GUIPowerFailure   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Close) $($lang.PowerFailure)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPwdUnlimited   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.PwdUnlimited)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIRAM            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.RAM)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIStorageSense   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.StorageSense)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIDelivery       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.Delivery)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPhotoPreview   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Enable) $($lang.PhotoPreview)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIProtected      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.Protected)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIErrorReporting = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.ErrorReporting)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIF8BootMenu     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.F8BootMenu)"
		ForeColor      = "#008000"
	}
	$GUISSD            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Optimize) $($lang.OptSSD)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIMemoryCompression = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.MemoryCompression)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrelaunch      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.Prelaunch)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUISSUpdateFirstLogonAnimation = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Hide) $($lang.UpdateFirstLogonAnimation)"
		ForeColor      = "#008000"
		Checked        = $true
	}

	<#
		.Context Menu
		.上下文菜单
	#>
	$GUIContextMenu    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.ContextMenu
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIContextMenu.Checked) {
				$GUIContextMenuPanel.Enabled = $True
			} else {
				$GUIContextMenuPanel.Enabled = $False
			}
		}
	}
	$GUIContextMenuPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIClassicModern  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Enable) $($lang.ClassicMenu)"
		ForeColor      = "#008000"
	}
	$GUIOwnership      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.AddTo) $($lang.TakeOwnership)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUICopyPath       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.AddTo) $($lang.CopyPath)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIMultipleIncrease = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.MultipleIncrease
		Checked        = $true
		ForeColor      = "#008000"
	}

	<#
		.网络优化
	#>
	$GUINetwork        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.NetworkOptimization
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUINetwork.Checked) {
				$GUINetworkPanel.Enabled = $True
			} else {
				$GUINetworkPanel.Enabled = $False
			}
		}
	}
	$GUINetworkPanel   = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIIEProxy        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Restore) $($lang.IEProxy)"
	}
	$GUIIEAutoSet      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.IEAutoSet)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUINetworkDiscovery = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.NetworkDiscovery)"
		ForeColor      = "#008000"
	}
	$GUINetworkDiscoveryTips = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = 1
		Text           = $lang.NetworkDiscoveryTips
		Padding        = "15,0,15,8"
	}
	$GUINetworkAdaptersPM = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.NetworkAdaptersPM)"
		ForeColor      = "#008000"
	}
	$GUIIPv6Component  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.IPv6Component)"
		ForeColor      = "#008000"
	}
	$GUIQOS            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.QOS)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUINetworkTuning  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Optimize) $($lang.NetworkTuning)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIECN            = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.ECN)"
		Checked        = $true
		ForeColor      = "#008000"
	}


	<#
		.资源管理器
	#>
	$GUIExplorer       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.Explorer
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIExplorer.Checked) {
				$GUIExplorerPanel.Enabled = $True
			} else {
				$GUIExplorerPanel.Enabled = $False
			}
		}
	}
	$GUIExplorerPanel  = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUISeparateProcess = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Enable) $($lang.SeparateProcess)"
		ForeColor      = "#008000"
	}
	$GUIRestartApps    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Enable) $($lang.RestartApps)"
		ForeColor      = "#008000"
	}
	$GUIRestartAppsTips = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = 1
		Text           = $lang.RestartAppsTips
		Padding        = "15,0,15,8"
	}

	$GUICheckBoxes     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Enable) $($lang.CheckBoxes)"
		ForeColor      = "#008000"
	}
	$GUIThumbnailCache = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.ThumbnailCache)"
		ForeColor      = "#008000"
	}
	$GUIToThisPC       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ExplorerTo -f $lang.ExplorerToThisPC
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIAeroShake      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.AeroShake)"
		ForeColor      = "#008000"
	}
	$GUIFileExtensions = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Show) $($lang.FileExtensions)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUISafetyWarnings = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.SafetyWarnings)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIFileTransfer   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.FileTransfer)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUINavShowAll     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.NavShowAll
		ForeColor      = "#008000"
	}
	$GUIAutoplay       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.Autoplay)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIAutorun        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Checked        = $true
		Text           = "$($lang.Disable) $($lang.Autorun)"
		ForeColor      = "#008000"
	}
	$GUIQuickAccessFiles = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.QuickAccessFiles)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIQuickAccessFolders = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.QuickAccessFolders)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIShortcutArrow  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Del) $($lang.ShortcutArrow)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCDesktop  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationDesktop
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCDocument = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationDocuments
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCDownload = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationDownloads
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCMusic    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationMusic
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCPicture  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationPictures
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPCVideo    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.LocationVideos
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIThisPC3D       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ThisPCRemove -f $lang.Location3D
		Checked        = $true
		ForeColor      = "#008000"
	}

	<#
		.通知中心
	#>
	$GUINotification   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.Notification
		ForeColor      = "#008000"
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUINotification.Checked) {
				$GUINotificationPanel.Enabled = $True
			} else {
				$GUINotificationPanel.Enabled = $False
			}
		}
	}
	$GUINotificationPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUINotificationFull = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 410
		Text           = "$($lang.Close) $($lang.Notification) ( $($lang.Full) )"
	}
	$GUINotificationPart = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 410
		Text           = "$($lang.Close) $($lang.Notification) ( $($lang.Part) )"
		Checked        = $true
	}

	<#
		.系统盘分页大小
	#>
	$GUIPagingSize     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = "$($lang.PagingSize) ( $($lang.Restart) )"
		ForeColor      = "#008000"
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIPagingSize.Checked) {
				$GUIPagingSizePanel.Enabled = $True
			} else {
				$GUIPagingSizePanel.Enabled = $False
			}
		}
	}
	$GUIPagingSizePanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIPagingSizeLow  = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 410
		Text           = "$($lang.Setting) $($lang.PagingSize) (8G)"
		Checked        = $true
	}
	$GUIPagingSizeHigh = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 410
		Text           = "$($lang.Setting) $($lang.PagingSize) (16G)"
	}

	<#
		.个性化
	#>
	$GUIPersonalise    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = $lang.Personalise
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIPersonalise.Checked) {
				$GUIPersonalisePanel.Enabled = $True
			} else {
				$GUIPersonalisePanel.Enabled = $False
			}
		}
	}
	$GUIPersonalisePanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIPersonaliseDark = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.DarkMode
	}
	$GUIPersonaliseDarkApps = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.DarkApps
		ForeColor      = "#008000"
		Padding        = "16,0,8,0"
	}
	$GUIPersonaliseDarkSystem = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.DarkSystem
		ForeColor      = "#008000"
		Padding        = "16,0,8,0"
	}
	$GUIPersonaliseTransparencyEffects = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TransparencyEffects)"
		ForeColor      = "#008000"
	}
	$GUIPersonaliseSnapAssistFlyout = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.SnapAssistFlyout)"
		ForeColor      = "#008000"
	}
	$GUIPersonaliseSnapAssistFlyoutTips = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = 1
		Text           = $lang.SnapAssistFlyoutTips
		Padding        = "15,0,15,8"
	}

	<#
		.开始菜单和任务栏
	#>
	$GUIStart          = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = $lang.Start
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIStart.Checked) {
				$GUIStartPanel.Enabled = $True
			} else {
				$GUIStartPanel.Enabled = $False
			}
		}
	}
	$GUIStartPanel     = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIStartTaskbarAlignmentPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 85
		Width          = 380
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $true
		Padding        = "0,0,8,0"
	}
	$GUITaskbarAlignment = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.TaskbarAlignment
	}
	$GUIStartTaskbarAlignmentCenter = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.TaskbarAlignmentCentered
		Padding        = "16,0,8,0"
		add_click      = {
			Taskbar_Alignment -Center
		}
	}
	$GUIStartTaskbarAlignmentLeaf = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 380
		Text           = $lang.TaskbarAlignmentLeft
		Padding        = "16,0,8,0"
		add_click      =  {
			Taskbar_Alignment -Left
		}
	}
	$GUITaskbarWidgets = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Hide) $($lang.TaskbarWidgets)"
		ForeColor      = "#008000"
	}
	$GUITaskbarWidgetsRemove = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Del) $($lang.TaskbarWidgetsRemove)"
		ForeColor      = "#008000"
	}
	$GUITeamsAutostarting = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TeamsAutostarting)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUITeamsTaskbarChat = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Hide) $($lang.TeamsTaskbarChat)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIBingSearch     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.BingSearch)"
		ForeColor      = "#008000"
	}
	$GUITaskbarSuggestedContent = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Hide) $($lang.TaskbarSuggestedContent)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUISuggestionsDevice = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.SuggestionsDevice)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUISearchBox      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.SearchBox)"
		ForeColor      = "#008000"
	}
	$GUIMergeTaskbarNever = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.MergeTaskbarNever)"
		ForeColor      = "#008000"
	}
	$GUINotificationAlways = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Setting) $($lang.NotificationAlways)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUICortana        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.Cortana
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUITaskView       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.TaskView
		ForeColor      = "#008000"
	}

	<#
		.Gaming
		.游戏
	#>
	$GUIXboxGame       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.Gaming
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIXboxGame.Checked) {
				$GUIXboxGamePanel.Enabled = $True
			} else {
				$GUIXboxGamePanel.Enabled = $False
			}
		}
	}
	$GUIXboxGamePanel  = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}
	$GUIXboxGameBar    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.XboxGameBar)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIXboxGameBarTips = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.XboxGameBarTips)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIXboxGameMode   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.XboxGameMode)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIXboxGameDVR    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.XboxGameDVR)"
		Checked        = $true
		ForeColor      = "#008000"
	}

	<#
		.隐私类
	#>
	$GUIPrivate        = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.FixPrivacy
		Checked        = $True
		Margin         = "2,22,0,0"
		add_click      = {
			if ($GUIPrivate.Checked) {
				$GUIPrivatePanel.Enabled = $True
			} else {
				$GUIPrivatePanel.Enabled = $False
			}
		}
	}
	$GUIPrivatePanel   = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		autoSize       = 1
		autoScroll     = $False
		Padding        = "12,0,8,0"
	}

	$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 410
	}

	$GUIScheduledTasks = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.ScheduledTasks)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacyVoiceTyping = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyVoiceTyping)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacyContactsSpeech = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyContactsSpeech)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacyLanguageOptOut = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyLanguageOptOut)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacyAds     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyAds)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUILocatonAware   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyLocatonAware)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacySetSync = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacySetSync)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIInkingTyping   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyInkingTyping)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIShareUnpairedDevices = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyShareUnpairedDevices)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUILocationSensor = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyLocationSensor)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIBiometrics     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyBiometrics)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUICompatibleTelemetry = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyCompatibleTelemetry)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIDiagnosticData = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyDiagnosticData)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUITailoredExperiences = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TailoredExperiences)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIFeedbackNotifications = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyFeedbackNotifications)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUILocationTracking = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyLocationTracking)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIExperiencesTelemetry = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.ExperiencesTelemetry)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUIPrivacyBackgroundAccess = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.PrivacyBackgroundAccess)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUITimelineTime = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.TimelineTime)"
		Checked        = $true
		ForeColor      = "#008000"
	}
	$GUICollectActivity = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Disable) $($lang.CollectActivity)"
		Checked        = $true
		ForeColor      = "#008000"
	}

	<#
		.其它类
	#>
	$UI_Main_Is_Other  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 460
		Text           = $lang.Related
		Location       = '530,15'
		Checked        = $True
		add_Click      = {
			if ($UI_Main_Is_Other.Checked) {
				$UI_Main_Other.Enabled = $True
			} else {
				$UI_Main_Other.Enabled = $False
			}
		}
	}
	$UI_Main_Other     = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 110
		Width          = 460
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "18,0,8,0"
		Location       = '530,45'
	}
	$UI_Main_Other_RDS = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 440
		Text           = $lang.StRemote
	}
	$UI_Main_Other_SMB = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 440
		Text           = $lang.StSMB
	}
	$UI_Main_Other_SMB_Tips = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = 1
		Text           = $lang.StSMBTips
		Padding        = "15,0,15,8"
	}

	<#
		.清理类
	#>
	$UI_Main_Is_Clear  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 460
		Text           = $lang.Cleanup
		Location       = '530,175'
		Checked        = $True
		add_Click      = {
			if ($UI_Main_Is_Clear.Checked) {
				$UI_Main_Clear.Enabled = $True
			} else {
				$UI_Main_Clear.Enabled = $False
			}
		}
	}
	$UI_Main_Clear     = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 190
		Width          = 460
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "18,0,8,0"
		Location       = '530,200'
	}
	$UI_Main_Clear_Send_To = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.SendTo
		Checked        = $true
	}
	$UI_Main_Clear_System_Logs = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.Logs
		Checked        = $true
	}
	$UI_Main_Clear_Disk = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.DiskCleanup
		Checked        = $true
	}
	$UI_Main_Clear_Sxs = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.SxS
	}

	<#
		.可用功能
	#>
	$UI_Main_Adv_Name  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 460
		Text           = $lang.AdvOption
		Location       = '530,410'
	}
	$UI_Main_Adv       = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 140
		Width          = 460
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "16,0,8,0"
		Location       = '530,440'
	}
	$UI_Main_Sync_To_All_User = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.SyncAllUser
		Checked        = $true
	}
	$UI_Main_Sync_To_TaskBar = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = "$($lang.Reset) $($lang.TaskBar)"
	}
	$UI_Main_Reset_Desktop_Icon = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 410
		Text           = $lang.ResetDesk
	}

	$UI_Main_Error     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 458
		Text           = ""
		Location       = '530,600'
	}
	$UI_Main_Restore   = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "530,635"
		Height         = 36
		Width          = 148
		add_Click      = $UI_Main_Restore_Click
		Text           = $lang.Restore
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "684,635"
		Height         = 36
		Width          = 148
		Text           = $lang.OK
		add_Click      = $UI_Main_OK_Click
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "839,635"
		Height         = 36
		Width          = 148
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$GUIOS.Close()
		}
	}

	$GUIOS.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Is_Other,
		$UI_Main_Other,
		$UI_Main_Is_Clear,
		$UI_Main_Clear,
		$UI_Main_Adv_Name,
		$UI_Main_Adv,
		$UI_Main_Error,
		$UI_Main_Restore,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Optimiz_Other_Is,
		$UI_Main_Optimiz_Other,
		$GUINetwork,
		$GUINetworkPanel,
		$GUIExplorer,
		$GUIExplorerPanel,
		$GUIContextMenu,
		$GUIContextMenuPanel,
		$GUINotification,
		$GUINotificationPanel,
		$GUIPagingSize,
		$GUIPagingSizePanel,
		$GUIPersonalise,
		$GUIPersonalisePanel,
		$GUIStart,
		$GUIStartPanel,
		$GUIXboxGame,
		$GUIXboxGamePanel,
		$GUIPrivate,
		$GUIPrivatePanel,
		$UI_Add_End_Wrap
	))

	<#
		.通知中心
	#>
	$GUINotificationPanel.controls.AddRange((
		$GUINotificationFull,
		$GUINotificationPart
	))

	$UI_Main_Clear.controls.AddRange((
		$UI_Main_Clear_Send_To,
		$UI_Main_Clear_System_Logs,
		$UI_Main_Clear_Disk,
		$UI_Main_Clear_Sxs
	))

	$UI_Main_Other.controls.AddRange((
		$UI_Main_Other_RDS,
		$UI_Main_Other_SMB,
		$UI_Main_Other_SMB_Tips
	))

	$GUINetworkPanel.controls.AddRange((
		$GUIIEProxy,
		$GUIIEAutoSet,
		$GUINetworkDiscovery,
		$GUINetworkDiscoveryTips,
		$GUINetworkAdaptersPM,
		$GUIIPv6Component,
		$GUIQOS,
		$GUINetworkTuning,
		$GUIECN
	))
	
	if (IsWin11) {
		$UI_Main_Optimiz_Other.controls.AddRange((
			$GUITPMSetup,
			$GUITPMUpdate
		))
	}

	$UI_Main_Optimiz_Other.controls.AddRange((
		$GUIKeepSpace,
		$GUIHibernation,
		$GUIPowerSupply,
		$GUIAppRestartScreen,
		$GUINumLock,
		$GUIUAC,
		$GUISmartScreenApps,
		$GUISmartScreenSafe,
		$GUIEasyAccessKeyboard,
		$GUIMaintain,
		$GUIExperience,
		$GUIDefragmentation,
		$GUICompatibility,
		$GUIAnimationEffects,
		$GUIErrorRecovery,
		$GUIDEP,
		$GUIPowerFailure,
		$GUIPwdUnlimited,
		$GUIRAM,
		$GUIStorageSense,
		$GUIDelivery,
		$GUIPhotoPreview,
		$GUIProtected,
		$GUIErrorReporting,
		$GUIF8BootMenu,
		$GUISSD,
		$GUIMemoryCompression,
		$GUIPrelaunch,
		$GUISSUpdateFirstLogonAnimation
	))

	$GUIPagingSizePanel.controls.AddRange((
		$GUIPagingSizeLow,
		$GUIPagingSizeHigh
	))

	$GUIExplorerPanel.controls.AddRange((
		$GUISeparateProcess,
		$GUIRestartApps,
		$GUIRestartAppsTips,
		$GUICheckBoxes,
		$GUIThumbnailCache,
		$GUIToThisPC,
		$GUIAeroShake,
		$GUIFileExtensions,
		$GUISafetyWarnings,
		$GUIFileTransfer,
		$GUINavShowAll,
		$GUIAutoplay,
		$GUIAutorun,
		$GUIQuickAccessFiles,
		$GUIQuickAccessFolders,
		$GUIShortcutArrow,
		$GUIThisPCDesktop,
		$GUIThisPCDocument,
		$GUIThisPCDownload,
		$GUIThisPCMusic,
		$GUIThisPCPicture,
		$GUIThisPCVideo,
		$GUIThisPC3D
	))

	$GUIContextMenuPanel.controls.AddRange((
		$GUIClassicModern,
		$GUIOwnership,
		$GUICopyPath,
		$GUIMultipleIncrease
	))

	$GUIPersonalisePanel.controls.AddRange((
		$GUIPersonaliseDark,
		$GUIPersonaliseDarkApps,
		$GUIPersonaliseDarkSystem,
		$GUIPersonaliseTransparencyEffects,
		$GUIPersonaliseSnapAssistFlyout,
		$GUIPersonaliseSnapAssistFlyoutTips
	))

	if (IsWin11) {
		$GUIStartPanel.controls.AddRange((
			$GUIStartTaskbarAlignmentPanel
		))

		$GUIStartTaskbarAlignmentPanel.controls.AddRange((
			$GUITaskbarAlignment,
			$GUIStartTaskbarAlignmentCenter,
			$GUIStartTaskbarAlignmentLeaf
		))

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -ErrorAction SilentlyContinue) {
				"0" { $GUIStartTaskbarAlignmentLeaf.Checked = $True }
				"1" { $GUIStartTaskbarAlignmentCenter.Checked = $True }
			}
		} else {
			$GUIStartTaskbarAlignmentCenter.Checked = $True
		}

		$GUIStartPanel.controls.AddRange((
			$GUITaskbarWidgets,
			$GUITaskbarWidgetsRemove
		))
	}

	$GUIStartPanel.controls.AddRange((
		$GUITeamsAutostarting,
		$GUITeamsTaskbarChat,
		$GUIBingSearch,
		$GUITaskbarSuggestedContent,
		$GUISuggestionsDevice,
		$GUISearchBox,
		$GUIMergeTaskbarNever,
		$GUINotificationAlways,
		$GUICortana,
		$GUITaskView
	))
	
	$GUIXboxGamePanel.controls.AddRange((
		$GUIXboxGameBar,
		$GUIXboxGameBarTips,
		$GUIXboxGameMode,
		$GUIXboxGameDVR
	))

	<#
		.添加：隐私类
	#>
	$GUIPrivatePanel.controls.AddRange((
		$GUIScheduledTasks,
		$GUIPrivacyVoiceTyping,
		$GUIPrivacyContactsSpeech,
		$GUIPrivacyLanguageOptOut,
		$GUIPrivacyAds,
		$GUILocatonAware,
		$GUIPrivacySetSync,
		$GUIInkingTyping,
		$GUIShareUnpairedDevices,
		$GUILocationSensor,
		$GUIBiometrics,
		$GUICompatibleTelemetry,
		$GUIDiagnosticData,
		$GUITailoredExperiences,
		$GUIFeedbackNotifications,
		$GUILocationTracking,
		$GUIExperiencesTelemetry,
		$GUIPrivacyBackgroundAccess,
		$GUITimelineTime,
		$GUICollectActivity
	))

	if (IsWin11) {
		$GUIThisPC3D.Checked = $False
		$GUIThisPC3D.Enabled = $False

		$GUITimelineTime.Checked = $False
		$GUITimelineTime.Enabled = $False
		$GUICollectActivity.Checked = $False
		$GUICollectActivity.Enabled = $False
	} else {
		$GUIClassicModern.Checked = $true
		$GUIClassicModern.Enabled = $true

		$GUITimelineTime.Checked = $true
		$GUITimelineTime.Enabled = $true
		$GUICollectActivity.Checked = $true
		$GUICollectActivity.Enabled = $true
	}
	$UI_Main_Adv.controls.AddRange((
		$UI_Main_Sync_To_All_User,
		$UI_Main_Sync_To_TaskBar,
		$UI_Main_Reset_Desktop_Icon
	))

	<#
		.右键菜单：优化类
	#>
	$GUIMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Optimiz_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Optimiz_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Optimiz_Other.ContextMenuStrip = $GUIMenu

	<#
		.右键菜单：网络优化
	#>
	$GUINetworkMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUINetworkMenu.Items.Add($lang.AllSel).add_Click({
		$GUINetworkPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUINetworkMenu.Items.Add($lang.AllClear).add_Click({
		$GUINetworkPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUINetworkPanel.ContextMenuStrip = $GUINetworkMenu

	<#
		.右键菜单：文件资源管理器
	#>
	$GUIFileExplorerMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIFileExplorerMenu.Items.Add($lang.AllSel).add_Click({
		$GUIExplorerPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIFileExplorerMenu.Items.Add($lang.AllClear).add_Click({
		$GUIExplorerPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIExplorerPanel.ContextMenuStrip = $GUIFileExplorerMenu

	<#
		.右键菜单：上下文菜单
	#>
	$GUIContextRightMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIContextRightMenu.Items.Add($lang.AllSel).add_Click({
		$GUIContextMenuPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIContextRightMenu.Items.Add($lang.AllClear).add_Click({
		$GUIContextMenuPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIContextMenuPanel.ContextMenuStrip = $GUIContextRightMenu

	<#
		.右键菜单：个性化
	#>
	$GUIPersonaliseMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIPersonaliseMenu.Items.Add($lang.AllSel).add_Click({
		$GUIPersonalisePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIPersonaliseMenu.Items.Add($lang.AllClear).add_Click({
		$GUIPersonalisePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIPersonalisePanel.ContextMenuStrip = $Personalise

	<#
		.右键菜单：开始菜单和任务栏
	#>
	$GUIStartMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIStartMenu.Items.Add($lang.AllSel).add_Click({
		$GUIStartPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIStartMenu.Items.Add($lang.AllClear).add_Click({
		$GUIStartPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIStartPanel.ContextMenuStrip = $GUIStartMenu

	<#
		.右键菜单：游戏
	#>
	$GUIGamingMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIGamingMenu.Items.Add($lang.AllSel).add_Click({
		$GUIXboxGamePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIGamingMenu.Items.Add($lang.AllClear).add_Click({
		$GUIXboxGamePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIXboxGamePanel.ContextMenuStrip = $GUIGamingMenu

	<#
		.右键菜单：隐私设置
	#>
	$GUIPriavteMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIPriavteMenu.Items.Add($lang.AllSel).add_Click({
		$GUIPrivatePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIPriavteMenu.Items.Add($lang.AllClear).add_Click({
		$GUIPrivatePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIPrivatePanel.ContextMenuStrip = $GUIPriavteMenu

	<#
		.右键菜单：其它
	#>
	$UI_Main_Other_Right = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Other_Right.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Other_Right.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Other.ContextMenuStrip = $UI_Main_Other_Right

	<#
		.右键菜单：清理
	#>
	$GUICleanMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUICleanMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Clear.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUICleanMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Clear.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Clear.ContextMenuStrip = $GUICleanMenu

	<#
		.右键菜单：主界面
	#>
	$GUIMainMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIMainMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Optimiz_Other_Is.Checked = $False
		$UI_Main_Optimiz_Other.Enabled = $False
		$UI_Main_Optimiz_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUINetwork.Checked = $False
		$GUINetworkPanel.Enabled = $False
		$GUINetworkPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUIExplorer.Checked = $False
		$GUIExplorerPanel.Enabled = $False
		$GUIExplorerPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUIContextMenu.Checked = $False
		$GUIContextMenuPanel.Enabled = $False
		$GUIContextMenuPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUINotification.Checked = $False
		$GUINotificationPanel.Enabled = $False

		$GUIPagingSize.Checked = $False
		$GUIPagingSizePanel.Enabled = $False

		$GUIPersonalise.Checked = $False
		$GUIPersonalisePanel.Enabled = $False
		$GUIPersonalisePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUIStart.Checked = $False
		$GUIStartPanel.Enabled = $False
		$GUIStartPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUIXboxGame.Checked = $False
		$GUIXboxGamePanel.Enabled = $False
		$GUIXboxGamePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$GUIPrivate.Checked = $False
		$GUIPrivatePanel.Enabled = $False
		$GUIPrivatePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$UI_Main_Is_Other.Checked = $False
		$UI_Main_Other.Enabled = $False
		$UI_Main_Other.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		$UI_Main_Is_Clear.Checked = $False
		$UI_Main_Clear.Enabled = $False
		$UI_Main_Clear.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIOS.ContextMenuStrip = $GUIMainMenu

	$NoSelectPowerSupply = @(8, 9, 10, 11, 14)
	Get-CimInstance -ClassName Win32_SystemEnclosure | ForEach-Object {
		if ($NoSelectPowerSupply -contains $_.SecurityStatus) {
			$GUIHibernation.Checked = $False
			$GUIPowerSupply.Checked = $False
		}
	}

	if ($Global:EventQueueMode) {
		$GUIOS.Text = "$($GUIOS.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$GUIOS.ShowDialog() | Out-Null
}

<#
	....................................
	Modules
	....................................
#>
<#
	.Take ownership to the right-click menu
	.Windows 11 上下文菜单传统、现代
#>
Function Win11_Context_Menu
{
	param
	(
		[switch]$Classic,
		[switch]$Modern
	)

	if ($Classic) {
		write-host "  $($lang.ClassicMenu)"
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32") -ne $true) {
			New-Item "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Name '(default)' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		RefreshIconCache
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Modern) {
		write-host "  $($lang.ModernMenu)"
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		RefreshIconCache
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Take ownership to the right-click menu
	.取得所有权到右键菜单
#>
Function Take_Ownership
{
	param
	(
		[switch]$Remove,
		[switch]$Add
	)

	if ($Remove) {
		write-host "  $($lang.Del)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\runas" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Drive\shell\runas" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Add) {
		write-host "  $($lang.AddTo)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\runas" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership" -force -ErrorAction SilentlyContinue | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership\command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership\command" -force -ErrorAction SilentlyContinue | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership" -force -ErrorAction SilentlyContinue | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership\command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership\command" -force -ErrorAction SilentlyContinue | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Drive\shell\runas") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\Drive\shell\runas" -force -ErrorAction SilentlyContinue | Out-Null };
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Drive\shell\runas\command") -ne $true) { New-Item "HKLM:\SOFTWARE\Classes\Drive\shell\runas\command" -force -ErrorAction SilentlyContinue | Out-Null };
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership' -Name '(default)' -Value $lang.TakeOwnership -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership' -Name 'Extended' -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership' -Name 'HasLUAShield' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership' -Name 'NoWorkingDirectory' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership' -Name 'NeverDefault' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership\command' -Name '(default)' -Value 'powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList ''/c takeown /f \"%1\" && icacls \"%1\" /grant *S-1-3-4:F /t /c /l & pause'' -Verb runAs"' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\TakeOwnership\command' -Name 'IsolatedCommand' -Value 'powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList ''/c takeown /f \"%1\" && icacls \"%1\" /grant *S-1-3-4:F /t /c /l & pause'' -Verb runAs"' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name '(default)' -Value $lang.TakeOwnership -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name 'AppliesTo' -Value "NOT (System.ItemPathDisplay:=""$($env:SystemDrive)\Users"" OR System.ItemPathDisplay:=""$($env:SystemDrive)\ProgramData"" OR System.ItemPathDisplay:=""$($env:systemroot)"" OR System.ItemPathDisplay:=""$($env:systemroot)\System32"" OR System.ItemPathDisplay:=""$($env:SystemDrive)\Program Files"" OR System.ItemPathDisplay:=""$($env:SystemDrive)\Program Files (x86)"")" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null | Out-Null
		Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name 'Extended' -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name 'HasLUAShield' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name 'NoWorkingDirectory' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership' -Name 'Position' -Value 'middle' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership\command' -Name '(default)' -Value 'powershell -windowstyle hidden -command "$Y = ($null | choice).Substring(1,1); Start-Process cmd -ArgumentList (''/c takeown /f \"%1\" /r /d '' + $Y + '' && icacls \"%1\" /grant *S-1-3-4:F /t /c /l /q & pause'') -Verb runAs"' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\TakeOwnership\command' -Name 'IsolatedCommand' -Value 'powershell -windowstyle hidden -command "$Y = ($null | choice).Substring(1,1); Start-Process cmd -ArgumentList (''/c takeown /f \"%1\" /r /d '' + $Y + '' && icacls \"%1\" /grant *S-1-3-4:F /t /c /l /q & pause'') -Verb runAs"' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name '(default)' -Value $lang.TakeOwnership -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name 'Extended' -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name 'HasLUAShield' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name 'NoWorkingDirectory' -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name 'Position' -Value 'middle' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas' -Name 'AppliesTo' -Value "NOT (System.ItemPathDisplay:=""$($env:SystemDrive)\"")" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas\command' -Name '(default)' -Value 'cmd.exe /c takeown /f "%1\" /r /d y && icacls "%1\" /grant *S-1-3-4:F /t /c & pause' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Drive\shell\runas\command' -Name 'IsolatedCommand' -Value 'cmd.exe /c takeown /f "%1\" /r /d y && icacls "%1\" /grant *S-1-3-4:F /t /c & pause' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null;
		RefreshIconCache
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Always Show Copy Path Context Menu in Windows 10
	.在 Windows 10 中始终显示复制路径上下文菜单
#>
Function Copy_Path
{
	param
	(
		[switch]$Remove,
		[switch]$Add
	)

	write-host "  $($lang.CopyPath)"
	if ($Remove) {
		write-host "  $($lang.Del)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Add) {
		write-host "  $($lang.AddTo)".PadRight(22) -NoNewline
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath") -ne $true) {
			New-Item "HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath" -force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name '(default)' -Value 'Copy &as path' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name 'MUIVerb' -Value '@shell32.dll,-30329' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name 'Icon' -Value 'imageres.dll,-5302' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name 'InvokeCommandOnSelection' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name 'VerbHandler' -Value '{f3d06e7c-1e45-4a26-847e-f9fcdee59be0}' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Allfilesystemobjects\shell\windows.copyaspath' -Name 'VerbName' -Value 'copyaspath' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Windows 11 TPM Setup Check
	.Windows 11 TPM 安装检查
#>
Function Win11_TPM_Setup
{
	param
	(
		[switch]$Restore,
		[switch]$Disable
	)

	write-host "  $($lang.TPMSetup)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\LabConfig" -Name 'BypassCPUCheck' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\LabConfig" -Name 'BypassStorageCheck' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\LabConfig" -Name 'BypassRAMCheck' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\LabConfig" -Name 'BypassTPMCheck' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\LabConfig" -Name 'BypassSecureBootCheck' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\Setup\LabConfig") -ne $true) { New-Item "HKLM:\SYSTEM\Setup\LabConfig" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassCPUCheck' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassStorageCheck' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassRAMCheck' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassTPMCheck' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\LabConfig' -Name 'BypassSecureBootCheck' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Windows 11 Bypass the TPM to prevent you from upgrading the system
	.Windows 11 绕过 TPM 阻止您升级系统
#>
Function Win11_TPM_Update
{
	param
	(
		[switch]$Restore,
		[switch]$Disable
	)

	write-host "  $($lang.TPMUpdate)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SYSTEM\Setup\MoSetup" -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\Setup\MoSetup") -ne $true) { New-Item "HKLM:\SYSTEM\Setup\MoSetup" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\Setup\MoSetup' -Name 'AllowUpgradesWithUnsupportedTPMOrCPU' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.First sign-in animation after the upgrade
	.升级后的首次登录动画
#>
Function First_Logon_Animation
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.UpdateFirstLogonAnimation)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name EnableFirstLogonAnimation -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Keep space
	.保留空间
#>
Function Keep_Space
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.KeepSpace)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		DISM.exe /Online /Set-ReservedStorageState /State:Enabled | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Close)".PadRight(22) -NoNewline
		DISM.exe /Online /Set-ReservedStorageState /State:Disabled | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Hibernation
	.休眠
#>
Function Hibernation
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Hibernation)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Start-Process 'powercfg.exe' -ArgumentList '/h on' -WindowStyle Minimized
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Close)".PadRight(22) -NoNewline
		Start-Process 'powercfg.exe' -Verb runAs -ArgumentList '/h off' -WindowStyle Minimized
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Power supply solution optimized after "high performance"
	.电源方案为“高性能”后优化
#>
Function Power_Supply
{
	param
	(
		[switch]$Restore,
		[switch]$Optimize
	)

	write-host "  $($lang.PowerSupply)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		powercfg -restoredefaultschemes
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Optimize) {
		write-host "  $($lang.Optimize)".PadRight(22) -NoNewline
		powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
		powercfg -change -monitor-timeout-ac 0
		powercfg -change -monitor-timeout-dc 0
		powercfg -change -disk-timeout-ac 0
		powercfg -change -disk-timeout-dc 5
		powercfg -change -standby-timeout-ac 0
		powercfg -change -standby-timeout-dc 60
		powercfg -change -hibernate-timeout-ac 0
		powercfg -change -hibernate-timeout-dc 300
		powercfg /SETACVALUEINDEX 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
		powercfg /SETDCVALUEINDEX 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	."This app is preventing shutdown or restart" screen
	."此应用正在阻止关机或重新启动" 屏幕
#>
Function App_Restart_Screen
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.AppRestartScreen)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value '400' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name 'WaitToKillAppTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name 'HungAppTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name 'AutoEndTasks' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name 'LowLevelHooksTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name 'WaitToKillServiceTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Name 'AutoEndTasks' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Name 'LowLevelHooksTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Remove-ItemProperty -Path "Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Name 'WaitToKillServiceTimeout' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value '0' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'WaitToKillAppTimeout' -Value '5000' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'HungAppTimeout' -Value '4000' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'AutoEndTasks' -Value '1' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'LowLevelHooksTimeout' -Value 4096 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'WaitToKillServiceTimeout' -Value 8192 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop' -Name 'AutoEndTasks' -Value '1' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop' -Name 'LowLevelHooksTimeout' -Value 4096 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'Registry::\HKEY_USERS\.DEFAULT\Control Panel\Desktop' -Name 'WaitToKillServiceTimeout' -Value 8192 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Shortcut small arrow and suffix
	.快捷方式小箭头和后缀
#>
Function Shortcut_Arrow
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ShortcutArrow)"
	if ($Enabled) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\IE.AssocFile.URL' -Name 'IsShortcut' -Value "" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\InternetShortcut' -Name 'IsShortcut' -Value "" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\lnkfile' -Name 'IsShortcut' -Value "" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -Force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name link -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Del)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons") -ne $true) { New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -Value "$($env:systemroot)\system32\imageres.dll,197" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "$($env:USERPROFILE)\AppData\Local\iconcache.db" -ErrorAction SilentlyContinue
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'link' -Value ([byte[]](0x00,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.NumLock key will light up automatically after power on
	.NumLock 键开机后自动亮起
#>
Function Numlock
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Numlock)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force -ErrorAction SilentlyContinue | Out-Null
		Add-Type -AssemblyName System.Windows.Forms
		If (-not ([System.Windows.Forms.Control]::IsKeyLocked('NumLock'))) {
			$wsh = New-Object -ComObject WScript.Shell
			$wsh.SendKeys('{NUMLOCK}')
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force -ErrorAction SilentlyContinue | Out-Null
		Add-Type -AssemblyName System.Windows.Forms
		If ([System.Windows.Forms.Control]::IsKeyLocked('NumLock')) {
			$wsh = New-Object -ComObject WScript.Shell
			$wsh.SendKeys('{NUMLOCK}')
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.文件资源管理器
#>

<#
	.Each uses a separate process after opening
	.打开后每个使用单独进程
#>
Function Separate_Process
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ExplorerProcess)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Restart apps after signing in
	.登录后重启应用
#>
Function Restart_Apps
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.RestartApps)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'RestartApps' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'RestartApps' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Item check boxes
	.项目复选框
#>
Function Check_Boxes
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.CheckBoxes)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Thumbnail cache
	.缩略图缓存
#>
Function Thumbnail_Cache
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThumbnailCache)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 3 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.Show file name extensions
	.显示文件扩展名
#>
Function Explorer_Open_To
{
	param
	(
		[switch]$ThisPC,
		[switch]$QuickAccess
	)

	if ($ThisPC) {
		write-host "  $($lang.ExplorerTo -f $lang.ExplorerToThisPC)"
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($QuickAccess) {
		write-host "  $($lang.ExplorerTo -f $lang.ExplorerToQuickAccess)"
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Aero Shake Shake to the lowest function
	.Aero Shake 摇一摇降到最低功能
#>
Function Aero_Shake
{
	param
	(
		[switch]$AllUser,
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.AeroShake)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DisallowShaking' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -ErrorAction SilentlyContinue | Out-Null

		if ($AllUser) {
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DisallowShaking' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null

		if ($AllUser) {
			New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Show file name extensions
	.显示文件扩展名
#>
Function File_Extensions
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	write-host "  $($lang.FileExtensions)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.个性化
#>
<#
	.暗黑主题应用到：应用程序
#>
Function Dark_Mode_To_Apps
{
	param
	(
		[switch]$Dark,
		[switch]$Light
	)

	write-host "  $($lang.DarkMode)$($lang.DarkApps)"
	if ($Dark) {
		write-host "  $($lang.Dark)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Light) {
		write-host "  $($lang.Light)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.暗黑主题应用到：系统
#>
Function Dark_Mode_To_System
{
	param
	(
		[switch]$Dark,
		[switch]$Light
	)

	write-host "  $($lang.DarkMode)$($lang.DarkSystem)"
	if ($Dark) {
		write-host "  $($lang.Dark)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Light) {
		write-host "  $($lang.Light)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.透明效果
#>
Function Transparency_Effects
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.TransparencyEffects)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name EnableTransparency -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name EnableTransparency -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.最大化按钮，显示布局
#>
Function Snap_Assist_Flyout
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SnapAssistFlyout)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name EnableSnapAssistFlyout -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name EnableSnapAssistFlyout -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.开始菜单和任务栏
#>
<#
	.Taskbar alignment
	.任务栏对齐
#>
Function Taskbar_Alignment
{
	param
	(
		[switch]$Left,
		[switch]$Center
	)

	if ($Left) {
		write-host "  $($lang.TaskbarAlignment)$($lang.TaskbarAlignmentLeft)"
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAl -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Center) {
		write-host "  $($lang.TaskbarAlignment)$($lang.TaskbarAlignmentCentered)"
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarAl -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Taskbar widget icon
	.任务栏小组件图标
#>
Function Taskbar_Widgets
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	$MarkHasBeenInstalled = $False
	Get-AppxProvisionedPackage -Online | ForEach-Object {
		if ($_.DisplayName -like "MicrosoftWindows.Client.WebExperience") {
			$MarkHasBeenInstalled = $True
		}
	}

	write-host "  $($lang.TaskbarWidgets)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		if ($MarkHasBeenInstalled) {
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		if ($MarkHasBeenInstalled) {
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Taskbar widget icon
	.任务栏小组件图标
#>
Function Taskbar_Widgets_Remove
{
	param
	(
		[switch]$Remove,
		[switch]$Restore
	)

	write-host "  $($lang.TaskbarWidgetsRemove)"
	if ($Remove) {
		write-host "  $($lang.Del)".PadRight(22) -NoNewline
		Get-AppXProvisionedPackage -Online | Where-Object DisplayName -Like "MicrosoftWindows.Client.WebExperience*" | Remove-AppxProvisionedPackage -AllUsers -Online -ErrorAction SilentlyContinue | Out-Null
		Get-AppxPackage "MicrosoftWindows.Client.WebExperience*" -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Start-Process "ms-windows-store://pdp/?ProductId=9MSSGKG348SP"
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Microsoft Teams autostarting
	.Microsoft Teams 自动启动
#>
Function Teams_Autostarting
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	$MarkHasBeenInstalled = $False
	Get-AppxProvisionedPackage -Online | ForEach-Object {
		if ($_.DisplayName -like "MicrosoftTeams") {
			$MarkHasBeenInstalled = $True
		}
	}

	write-host "  $($lang.TeamsAutostarting)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if ($MarkHasBeenInstalled) {
			if (-not (Test-Path -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask"))
			{
				New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask" -Force -ErrorAction SilentlyContinue | Out-Null
			}
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask" -Name State -PropertyType DWord -Value 2 -Force -ErrorAction SilentlyContinue | Out-Null
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	if ($Disable) {
		write-host "  $($lang.Close)".PadRight(22) -NoNewline
		if ($MarkHasBeenInstalled) {
			if (-not (Test-Path -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask"))
			{
				New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask" -Force -ErrorAction SilentlyContinue | Out-Null
			}
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MicrosoftTeams_8wekyb3d8bbwe\TeamsStartupTask" -Name State -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}
}

<#
	.Microsoft Chats icons
	.Microsoft Chats 图标
#>
Function Teams_Taskbar_Chat
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	write-host "  $($lang.FileExtensions)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Microsoft Chats icons
	.开始菜单中的必应搜索
#>
Function Bing_Search
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.BingSearch)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name DisableSearchBoxSuggestions -Force -ErrorAction SilentlyContinue | Out-Null
		Restart_Explorer
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if (-not (Test-Path -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"))
		{
			New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force | Out-Null
		Restart_Explorer
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Suggested me content in the Settings app
	.在“设置”应用中向我推荐内容
#>
Function Taskbar_Suggested_Content
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	$cdm = @(
		"SubscribedContent-314559Enabled"
		"SubscribedContent-338388Enabled"
		"SubscribedContent-338389Enabled"
		"SubscribedContent-338393Enabled"  # tips
		"SubscribedContent-353694Enabled"
		"SubscribedContent-353696Enabled"
		"SubscribedContent-338387Enabled"
		"SubscribedContentEnabled"
		"SystemPaneSuggestionsEnabled"
	)

	write-host "  $($lang.TaskbarSuggestedContent)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force -ErrorAction SilentlyContinue | Out-Null
		ForEach ($item in $cdm) {
			New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name $item -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force -ErrorAction SilentlyContinue | Out-Null
		ForEach ($item in $cdm) {
			New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name $item -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Suggested me content in the Settings app
	.在“设置”应用中向我推荐内容
#>
Function Suggestions_Device
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SuggestionsDevice)"
	if ($Enabled) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement") -ne $true) {
			New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 1 -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement") -ne $true) {
			New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Search bar: display search icon
	.搜索栏：显示搜索图标
#>
Function Search_Box
{
	param
	(
		[switch]$Hide,
		[switch]$SearchIcon,
		[switch]$SearchBox
	)

	write-host "  $($lang.SearchBox)"
	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($SearchIcon) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($SearchBox) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.User Account Control (UAC): Never notify me
	.用户账户控制 (UAC)：从不通知我
#>
Function UAC_Never
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.UAC)"
	if ($Enabled) {
		write-host "  $($lang.UACNever)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'PromptOnSecureDesktop' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin' -Value 5 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'PromptOnSecureDesktop' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.File transfer dialog: brief information, detailed information
	.文件传输对话框：简略信息、详细信息
#>
Function File_Transfer_Dialog
{
	param
	(
		[switch]$Detailed,
		[switch]$Simple
	)

	write-host "  $($lang.FileTransfer)"
	if ($Detailed) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Simple) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Smart Screen for Microsoft Store apps
	.适用于 Microsoft Store 应用的 Smart Screen
#>
Function Smart_Screen_Apps
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SmartScreenApps)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -ErrorAction SilentlyContinue
	
		Get-ChildItem -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\*edge*" -Name -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test-Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -PathType Container) {
				Remove-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -ErrorAction SilentlyContinue | Out-Null
				Remove-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -Name "PreventOverride" -ErrorAction SilentlyContinue | Out-Null
			}
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
	
		Get-ChildItem -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\*edge*" -Name -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test-Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -PathType Container) {
				Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 0 | Out-Null
				Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$($_)\MicrosoftEdge\PhishingFilter" -Name "PreventOverride" -Type DWord -Value 0 | Out-Null
			}
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Smart Screen for Microsoft Store apps
	.适用于 Microsoft Store 应用的 Smart Screen
#>
Function Smart_Screen_Safe
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SmartScreenSafe)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments))
		{
			New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Easy access keyboard stuff
	.轻松访问键盘的东西
#>
Function Easy_Access_Keyboard
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.EasyAccessKeyboard)"
	if ($Enabled) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "450" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "126" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "62" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Automatic maintenance plan
	.自动维护计划
#>
Function Maintain
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Maintain)"
	if ($Enabled) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" -Name "MaintenanceDisabled" -ErrorAction SilentlyContinue
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance") -ne $true) { New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance' -Name 'MaintenanceDisabled' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Customer experience improvement plan
	.客户体验改善计划
#>
Function Experience
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Experience)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnabled" -ErrorAction SilentlyContinue
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows") -ne $true) { New-Item "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Common file type safety warnings
	.常见文件类型安全警告
#>
Function Safety_Warnings
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SafetyWarnings)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations") -ne $true) { New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations' -Name 'LowRiskFileTypes' -Value '.exe;.reg;.msi;.bat;.cmd;.com;.vbs;.hta;.scr;.pif;.js;.iso;' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
} 

<#
	.QOS service
	.QOS 服务
#>
Function QOS
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.QOS)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Start-Process -FilePath "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\nvspbind")\nvspbind.exe" -ArgumentList "/e ""*"" ms_pacer" -Wait -WindowStyle Minimized
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Start-Process -FilePath "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\nvspbind")\nvspbind.exe" -ArgumentList "/d ""*"" ms_pacer" -Wait -WindowStyle Minimized
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Network tuning function
	.网络调优功能
#>
Function Network_Tuning
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.NetworkTuning)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		netsh interface tcp set global autotuninglevel=normal | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		netsh interface tcp set global autotuninglevel=disabled | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.ECN function
	.ECN 功能
#>
Function ECN
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ECN)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		netsh int tcp set global ecn=enabled | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		netsh int tcp set global ecn=disable | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Windows error recovery
	.Windows 错误恢复
#>
Function Error_Recovery
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ErrorRecovery)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		bcdedit /set {default} bootstatuspolicy DisplayAllFailures | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} bootstatuspolicy ignoreallfailures | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.DEP and PAE
	.DEP 和 PAE
#>
Function DEPPAE
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.DEP)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		bcdedit /deletevalue `{current`} pae 
		bcdedit /set `{current`} nx OptIn
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} nx AlwaysOff
		bcdedit /set `{current`} pae ForceDisable
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Automatic repair Function after power failure
	.断电后自动修复功能
#>
Function Power_Failure
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PowerFailure)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} Recoveryenabled Yes | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} Recoveryenabled No | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.The diagnostics tracking scheduled tasks
	.诊断跟踪计划任务
#>
Function Scheduled_Tasks
{
	param
	(
		[switch]$Restore,
		[switch]$Disable
	)

	$tasks = @(
		<#
			.Windows base scheduled tasks
		#>
		# Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program
		"\Microsoft\Windows\Application Experience\ProgramDataUpdater"

		# This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program
		"\Microsoft\Windows\Autochk\Proxy"

		# If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft
		"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"

		# The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft
		"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"

		# The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program
		"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"

		# This task shows various Map related toasts
		"\Microsoft\Windows\Maps\MapsToastTask"

		# This task checks for updates to maps which you have downloaded for offline use
		"\Microsoft\Windows\Maps\MapsUpdateTask"

		# Initializes Family Safety monitoring and enforcement
		"\Microsoft\Windows\Shell\FamilySafetyMonitor"

		# Synchronizes the latest settings with the Microsoft family features service
		"\Microsoft\Windows\Shell\FamilySafetyRefreshTask"

		# XblGameSave Standby Task
		"\Microsoft\XblGameSave\XblGameSaveTask"
	)

	write-host "  $($lang.ScheduledTasks)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		ForEach ($task in $tasks) {
			$parts = $task.split('\')
			$name = $parts[-1]
			$path = $parts[0..($parts.length-2)] -join '\'
		
			Enable-ScheduledTask -TaskName $name -TaskPath $path -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Red
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline

		ForEach ($task in $tasks) {
			$parts = $task.split('\')
			$name = $parts[-1]
			$path = $parts[0..($parts.length-2)] -join '\'
		
			Disable-ScheduledTask -TaskName $name -TaskPath $path -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.It is forbidden to send voice, ink and typing samples to MS (so Cortana can learn to recognize you)
	.向 MS 发送语音、墨迹和打字样本 ( 因此 Cortana 可以学习识别您 )
#>
Function Privacy_Voice_Typing
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyVoiceTyping)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" "1" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Send contacts to MS ( so Cortana can compare speech etc samples )
	.向 MS 发送联系人 ( 因此 Cortana 可以比较语音等样本 )
#>
Function Privacy_Contacts_Speech
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyContactsSpeech)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" "1" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.让网站通过访问我的语言列表来提供本地相关内容
	.Let websites provide locally relevant content by accessing my language list
#>
Function Privacy_Language_Opt_Out
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyLanguageOptOut)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Optimize)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Control Panel\International\User Profile" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 0 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Apps use my advertising ID for experiencess across apps
	.让应用使用我的广告 ID 进行跨应用体验
#>
Function Privacy_Ads
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyAds)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Locaton aware printing (changes default based on connected network)
	.位置感知打印 ( 根据连接的网络更改默认值 )
#>
Function Privacy_Locaton_Aware
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyLocatonAware)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKCU:\Printers\Defaults" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Name "Enabled" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Printers\Defaults" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Printers\Defaults" "NetID" "{00000000-0000-0000-0000-000000000000}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Synchronisation of settings
	.设置同步
#>
Function Privacy_Set_Sync
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	$groups = @(
		"Accessibility"
		"AppSync"
		"BrowserSettings"
		"Credentials"
		"DesktopTheme"
		"Language"
		"PackageState"
		"Personalization"
		"StartLayout"
		"Windows"
	)

	write-host "  $($lang.PrivacySetSync)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "BackupPolicy" 0x3c -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "DeviceMetadataUploaded" 0 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "PriorLogons" 1 -ErrorAction SilentlyContinue | Out-Null
		ForEach ($group in $groups) {
			New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" "Enabled" "1" -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "BackupPolicy" 0x3c -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "DeviceMetadataUploaded" 0 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "PriorLogons" 1 -ErrorAction SilentlyContinue | Out-Null
		ForEach ($group in $groups) {
			New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" "Enabled" "0" -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Personalization of inking and typing
	.隐私：墨迹书写和打字个性化
#>
Function Privacy_Inking_Typing
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyInkingTyping)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" "0" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" "1" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" "1" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Share information with unpaired devices
	.隐私：与未配对设备共享信息
#>
Function Privacy_Share_Unpaired_Devices
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyShareUnpairedDevices)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Type" "LooselyCoupled" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "InitialAppValue" "Unspecified" -ErrorAction SilentlyContinue | Out-Null
		ForEach ($key in (Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global")) {
			if ($key.PSChildName -EQ "LooselyCoupled") {
				continue
			}
			Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "Type" "InterfaceClass" -ErrorAction SilentlyContinue | Out-Null
			Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "Value" "Deny" -ErrorAction SilentlyContinue | Out-Null
			Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) "InitialAppValue" "Unspecified" -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Windows Hello Biometrics
	.隐私：Windows Hello 生物识别
#>
Function Privacy_Biometrics
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyLocationSensor)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Biometrics" -Name "Enabled" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Biometrics" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Biometrics" "Enabled" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Compatibility Telemetry
	.隐私：兼容性遥测
#>
Function Privacy_Compatible_Telemetry
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyCompatibleTelemetry)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" -Name "Debugger" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" "Debugger" "%windir%\system32\taskkill.exe" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Diagnostic data
	.隐私：诊断数据
#>
Function Privacy_Diagnostic_Data
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyDiagnosticData)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Get-Service -Name DiagTrack | Set-Service -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
		Get-Service -Name DiagTrack | Start-Service -ErrorAction SilentlyContinue | Out-Null
		Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Allow -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Get-Service -Name DiagTrack | Stop-Service -Force -ErrorAction SilentlyContinue | Out-Null
		Get-Service -Name DiagTrack | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
		Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Tailored experiences
	.隐私：量身定制的体验
#>
Function Privacy_Tailored_Experiences
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.TailoredExperiences)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" "TailoredExperiencesWithDiagnosticDataEnabled" "2" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" "TailoredExperiencesWithDiagnosticDataEnabled" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Feedback notifications
	.隐私：反馈通知
#>
Function Privacy_Feedback_Notifications
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyFeedbackNotifications)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" "0" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "PeriodInNanoSeconds" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Location tracking
	.隐私：位置跟踪
#>
Function Privacy_Location_Tracking
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyLocationTracking)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Allow" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Location sensor
	.隐私：位置传感器
#>
Function Privacy_Location_Sensor
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyLocationSensor)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-45056BFE4B44}" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-45056BFE4B44}" "SensorPermissionState" "1" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-45056BFE4B44}" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-45056BFE4B44}" "SensorPermissionState" "0" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Connected User Experiences and Telemetry
	.隐私：互联用户体验和遥测
#>
Function Privacy_Experiences_Telemetry
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ExperiencesTelemetry)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "3" -ErrorAction SilentlyContinue | Out-Null

		Get-Service -Name DiagTrack | Set-Service -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
		Get-Service -Name DiagTrack | Start-Service -ErrorAction SilentlyContinue | Out-Null
		Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Allow -ErrorAction SilentlyContinue | Out-Null

		Get-Service -Name "dmwappushservice" | Set-Service -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
		Start-Service "dmwappushservice" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "0" -ErrorAction SilentlyContinue | Out-Null

		Get-Service -Name DiagTrack | Stop-Service -Force -ErrorAction SilentlyContinue | Out-Null
		Get-Service -Name DiagTrack | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
		Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block -ErrorAction SilentlyContinue | Out-Null

		Get-Service -Name "dmwappushservice" | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
		Stop-Service "dmwappushservice" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}



<#
	.Privacy: Background access of default apps
	.隐私：默认应用的后台访问
#>
Function Privacy_Background_Access
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PrivacyBackgroundAccess)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		ForEach ($key in (Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications")) {
			Remove-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\" + $key.PSChildName) -Name 'Disabled' -Force -ErrorAction SilentlyContinue | out-null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		ForEach ($key in (Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications")) {
			Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\" + $key.PSChildName) "Disabled" 1 -ErrorAction SilentlyContinue | Out-Null
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Privacy: Timeline time
	.隐私：时间轴时间
#>
Function Timeline_Time
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.TimelineTime)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Privacy: Collect activity history
	.隐私：收集活动历史记录
#>
Function Collect_Activity
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.CollectActivity)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.IE Setting proxy does not take effect
	.IE 设置代理不生效
#>
Function IEProxy
{
	write-host "  $($lang.IEProxy)"
	write-host "  $($lang.Restore)".PadRight(22) -NoNewline
	"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections [1 7 17]" | Out-File -FilePath "$($env:TEMP)\ie_proxy.ini" -Encoding ASCII
	Start-Process "regini" -ArgumentList "$($env:TEMP)\ie_proxy.ini" -WindowStyle Minimized
	Remove-Item -Path "$($env:TEMP)\ie_proxy.ini" -ErrorAction SilentlyContinue
	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.IE automatically detects settings
	.IE 自动检测设置
#>
Function Auto_Detect
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.IEAutoSet)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' -Name 'AutoDetect' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings' -Name 'AutoDetect' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Network Discovery File and Printers Sharing
	.网络发现文件和打印机共享
#>
Function Network_Discovery
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	$FirewallRules = @(
		# File and printer sharing
		"@FirewallAPI.dll,-32752",

		# Network discovery
		"@FirewallAPI.dll,-28502"
	)

	write-host "  $($lang.NetworkDiscovery)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $false)
		{
			Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled True -ErrorAction SilentlyContinue | Out-Null
			Set-NetFirewallRule -Profile Public, Private -Name FPS-SMB-In-TCP -Enabled True -ErrorAction SilentlyContinue | Out-Null
			Set-NetConnectionProfile -NetworkCategory Private
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $false)
		{
			Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled False -ErrorAction SilentlyContinue | Out-Null
			Write-Host "$($lang.Done)`n" -ForegroundColor Green
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}
}

<#
	.Network adapters power management
	.网络适配器电源管理
#>
Function Network_Adapters_Save_Power
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	$Adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement | Where-Object -FilterScript { $_.AllowComputerToTurnOffDevice -ne "Unsupported" }

	write-host "  $($lang.NetworkAdaptersPM)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		ForEach ($item in $Adapters)
		{
			$item.AllowComputerToTurnOffDevice = "Enabled"
			$item | Set-NetAdapterPowerManagement
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		ForEach ($item in $Adapters)
		{
			$item.AllowComputerToTurnOffDevice = "Disabled"
			$item | Set-NetAdapterPowerManagement
		}
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Internet Protocol Version 6 (TCP/IPv6) component
	.Internet 协议版本 6 (TCP/IPv6) 组件
#>
Function IPv6_Component
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.NetworkAdaptersPM)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.Merge taskbar buttons: never
	.合并任务栏按钮：从不
#>
Function Merge_Taskbar_Never
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.MergeTaskbarNever)"
	if ($Enabled) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarGlomLevel -Force -ErrorAction SilentlyContinue
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.Notification area: always show all icons
	.通知区域：始终显示所有图标
#>
Function Notification_Center_Always
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.NotificationAlways)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name EnableAutoTray -Force -ErrorAction SilentlyContinue
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Open "Show all folders" in the navigation pane
	.在导航窗格中打开“显示所有文件夹”
#>
Function Nav_Show_All
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.NavShowAll)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneExpandToCurrentFolder' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneExpandToCurrentFolder" -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Hide the Cortana button on the taskbar
	.在任务栏上隐藏 Cortana 按钮
#>
Function Cortana
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Cortana)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCortanaButton' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Hide the Task View button on the taskbar
	.在任务栏上隐藏 任务视图 按钮
#>
Function Task_View
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	write-host "  $($lang.TaskView)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Hide recently used files in Quick access
	.在快速访问中隐藏最近使用的文件
#>
Function Quick_Access_Files
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	write-host "  $($lang.QuickAccessFiles)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Show frequently used folders in Quick access
	.在快速访问中显示常用文件夹
#>
Function Quick_Access_Folders
{
	param
	(
		[switch]$Show,
		[switch]$Hide
	)

	write-host "  $($lang.QuickAccessFolders)"
	if ($Show) {
		write-host "  $($lang.Show)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Hide) {
		write-host "  $($lang.Hide)".PadRight(22) -NoNewline
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "$($env:appdata)\Microsoft\Windows\Recent\*.*"
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Memory compression
	.内存压缩
#>
Function Memory_Compression
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.MemoryCompression)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-MMAgent -mc
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-MMAgent -mc
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Pre-fetch pre-launch
	.预取预启动
#>
Function Prelaunch
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Prelaunch)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-MMAgent -ApplicationPreLaunch
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name 'EnablePrefetcher' -Value 3 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-MMAgent -ApplicationPreLaunch
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters' -Name 'EnablePrefetcher' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.SSD
#>
Function SSD
{
	param
	(
		[switch]$Restore,
		[switch]$Disable
	)

	write-host "  $($lang.OptSSD)"
	if ($Enabled) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		fsutil behavior set DisableLastAccess 2 | Out-Null
		fsutil behavior set EncryptPagingFile 0 | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Optimize)".PadRight(22) -NoNewline
		fsutil behavior set DisableLastAccess 1 | Out-Null
		fsutil behavior set EncryptPagingFile 0 | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Program Compatibility Assistant
	.程序兼容性助手
#>
Function Compatibility
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Compatibility)"
	if ($Enabled) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat") -ne $true) { New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePCA' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Visual animation effect
	.视觉动画效果
#>
Function Animation_Effects 
{
	param
	(
		[switch]$Restore,
		[switch]$Optimize
	)

	write-host "  $($lang.AnimationEffects)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-Item -LiteralPath "HKCU:\SOFTWARE\Policies\Microsoft\Windows\DWM" -force -Recurse -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'EnableAeroPeek' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'AlwaysHibernateThumbnails' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TurnOffSPIAnimations" -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewShadow' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'IconsOnly' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '1' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x9e,0x1e,0x07,0x80,0x12,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value '1' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value '2' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Red
	}

	if ($Optimize) {
		write-host "  $($lang.Optimize)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKCU:\SOFTWARE\Policies\Microsoft\Windows\DWM") -ne $true) { New-Item "HKCU:\SOFTWARE\Policies\Microsoft\Windows\DWM" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\DWM' -Name 'DisallowAnimations' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'EnableAeroPeek' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'AlwaysHibernateThumbnails' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'TurnOffSPIAnimations' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 3 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewShadow' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'IconsOnly' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x9e,0x1e,0x07,0x80,0x12,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value '1' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value '2' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.Disk Defragmentation Plan
	.磁盘碎片整理计划
#>
Function Defragmentation
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Defragmentation)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\Defrag\" -TaskName "ScheduledDefrag" | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\Defrag\" -TaskName "ScheduledDefrag" | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Photo preview
	.照片预览
#>
Function Photo_Preview
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PhotoPreview)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.jpg") -ne $true) { New-Item "HKCU:\Software\Classes\.jpg" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.jpeg") -ne $true) { New-Item "HKCU:\Software\Classes\.jpeg" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.gif") -ne $true) { New-Item "HKCU:\Software\Classes\.gif" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.png") -ne $true) { New-Item "HKCU:\Software\Classes\.png" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.bmp") -ne $true) { New-Item "HKCU:\Software\Classes\.bmp" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.tiff") -ne $true) { New-Item "HKCU:\Software\Classes\.tiff" -force -ErrorAction SilentlyContinue | Out-Null }
		if ((Test-Path -LiteralPath "HKCU:\Software\Classes\.ico") -ne $true) { New-Item "HKCU:\Software\Classes\.ico" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.jpg' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.jpeg' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.gif' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.png' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.bmp' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.tiff' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Classes\.ico' -Name '(default)' -Value 'PhotoViewer.FileAssoc.Tiff' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKCU:\Software\Classes\.jpg" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.jpeg" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.gif" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.png" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.bmp" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.tiff" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKCU:\Software\Classes\.ico" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Reduce the number of processors using RAM
	.降低 RAM 使用处理器数量
#>
Function RAM
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.RAM)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Value 3670016 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'WaitToKillServiceTimeout' -Value '5000' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value 10 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 20 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -Name 'SearchOrderConfig' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Name "PowerThrottlingOff" -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_FSEBehaviorMode' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'Win32_AutoGameModeDefaultProfile' -Value ([byte[]](0x02,0x00,0x01,0x00,0x00,0x00,0xc4,0x20,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'Win32_GameModeRelatedProcesses' -Value ([byte[]](0x01,0x00,0x01,0x00,0x01,0x00,0x67,0x00,0x61,0x00,0x6d,0x00,0x65,0x00,0x70,0x00,0x61,0x00,0x6e,0x00,0x65,0x00,0x6c,0x00,0x2e,0x00,0x65,0x00,0x78,0x00,0x65,0x00,0x00,0x00,0xc9,0x00,0x4e,0x95,0x67,0x77,0xb0,0xeb,0x1e,0x03,0xd8,0xf1,0x1e,0x03,0x1e,0x00,0x00,0x00,0xb0,0xeb,0x1e,0x03,0x1e,0x00,0x00,0x00,0x0f,0x00,0x00,0x00,0x2c,0xea,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_HonorUserFSEBehaviorMode' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_DXGIHonorFSEWindowsCompatible' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_EFSEFeatureFlags' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabledDefault' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\943c8cb6-6f93-4227-ad87-e9a3feec08d1' -Name 'Attributes' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'ACSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'DCSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -Name 'ACSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'ACSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'DCSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -Name 'ACSettingIndex' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Value 67108864 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'WaitToKillServiceTimeout' -Value '2000' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile") -ne $true) { New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'NetworkThrottlingIndex' -Value -1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -Name 'SearchOrderConfig' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		if((Test-Path -LiteralPath "HKCU:\System\GameConfigStore") -ne $true) { New-Item "HKCU:\System\GameConfigStore" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_FSEBehaviorMode' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'Win32_AutoGameModeDefaultProfile' -Value ([byte[]](0x01,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'Win32_GameModeRelatedProcesses' -Value ([byte[]](0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00)) -PropertyType Binary -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_HonorUserFSEBehaviorMode' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_DXGIHonorFSEWindowsCompatible' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_EFSEFeatureFlags' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabledDefault' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\943c8cb6-6f93-4227-ad87-e9a3feec08d1' -Name 'Attributes' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'ACSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'DCSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -Name 'ACSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'ACSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e' -Name 'DCSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb\DefaultPowerSchemeValues\8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -Name 'ACSettingIndex' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Storage Sense
	.存储感知
#>
Function Storage_Sense
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.StorageSense)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
		{
			New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
		{
			New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Delivery Optimization
	.传递优化
#>
Function Delivery
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Delivery)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 1 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 0 -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Maximum password usage time is unlimited
	.密码最长使用时间为无限
#>
Function Password_Unlimited
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.PwdUnlimited)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		net accounts /maxpwage:42 | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		net accounts /maxpwage:UNLIMITED | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Gamebar
#>
Function XboxGameBar
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.XboxGameBar)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR))
		{
			New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name AudioCaptureEnabled -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name CursorCaptureEnabled -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name MicrophoneCaptureEnabled -Force -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR))
		{
			New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AudioCaptureEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'CursorCaptureEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'MicrophoneCaptureEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Gamebar Tips
#>
Function XboxGameBarTips
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.XboxGameBarTips)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\GameBar))
		{
			New-Item -Path HKCU:\SOFTWARE\Microsoft\GameBar -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name 'ShowStartupPanel' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\GameBar))
		{
			New-Item -Path HKCU:\SOFTWARE\Microsoft\GameBar -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		}
		New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name 'ShowStartupPanel' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Game Mode
	.Game Mode
#>
Function XboxGameMode
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.XboxGameMode)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name CursorCaptureEnabled -Force -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name MicrophoneCaptureEnabled -Force -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'AllowAutoGameMode' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Game DVR
	.游戏 DVR
#>
Function XboxGameDVR
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.XboxGameDVR)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name AllowgameDVR -Force -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name 'AllowgameDVR' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	."Windows protects your PC" dialog
	."Windows 保护了您的 PC" 对话框
#>
Function Protected
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Protected)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments") -ne $true) { New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments' -Name 'SaveZoneInformation' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Add 15 file selection limit to hide context menu items
	.增加 15 个文件选择限制以隐藏上下文菜单项
#>
Function File_Selection_Restrictions
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.MultipleIncrease)"
	if ($Enabled) {
		write-host "  $($lang.Setting)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name MultipleInvokePromptMinimum -Force -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'MultipleInvokePromptMinimum' -Value 999 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Autoplay
	.自动播放
#>
Function Autoplay
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Autoplay)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Run all drives automatically
	.自动运行所有驱动器
#>
Function Autorun
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.Autorun)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		If (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
			New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Error report
	.错误报告
#>
Function Error_Reporting
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ErrorReporting)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -ErrorAction SilentlyContinue

		Set-Service -Name "WerSvc" -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
		Start-Service "WerSvc" -ErrorAction SilentlyContinue | Out-Null

		Enable-ScheduledTask -TaskName "QueueReporting" -TaskPath "\Microsoft\Windows\Windows Error Reporting" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1

		Set-Service -Name "WerSvc" -StartupType Disabled -ErrorAction SilentlyContinue | Out-Null
		Stop-Service "WerSvc" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null

		Disable-ScheduledTask -TaskName "QueueReporting" -TaskPath "\Microsoft\Windows\Windows Error Reporting" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.F8 boot menu option
	.F8 启动菜单选项
#>
Function F8_Boot_Menu
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.F8BootMenu)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Sent to
	.发送到
#>
Function Send_To
{
	write-host "  $($lang.SendTo)"
	write-host "  $($lang.Clean)".PadRight(22) -NoNewline
	Remove-Item -Path "$($env:APPDATA)\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:APPDATA)\Microsoft\Windows\SendTo\邮件收件人.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:APPDATA)\Microsoft\Windows\SendTo\Fax Recipient.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:APPDATA)\Microsoft\Windows\SendTo\传真收件人.lnk" -ErrorAction SilentlyContinue
	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.System logs
	.系统日志
#>
Function Cleanup_System_Log
{
	write-host "  $($lang.Logs)"
	write-host "  $($lang.Clean)".PadRight(22) -NoNewline
	Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }
	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Disk clean-up
	.磁盘清理
#>
Function Cleanup_Disk
{
	$SageSet = "StateFlags0099"
	$Base = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"
	$Locations= @(
		"Active Setup Temp Folders"
		"BranchCache"
		"Downloaded Program Files"
		"GameNewsFiles"
		"GameStatisticsFiles"
		"GameUpdateFiles"
		"Internet Cache Files"
		"Memory Dump Files"
		"Offline Pages Files"
		"Old ChkDsk Files"
		"D3D Shader Cache"
		"Delivery Optimization Files"
		"Diagnostic Data Viewer database files"
		"Previous Installations"
		"Recycle Bin"
		"Service Pack Cleanup"
		"Setup Log Files"
		"System error memory dump files"
		"System error minidump files"
		"Temporary Files"
		"Temporary Setup Files"
		"Temporary Sync Files"
		"Thumbnail Cache"
		"Update Cleanup"
		"Upgrade Discarded Files"
		"User file versions"
		"Windows Defender"
		"Windows Error Reporting Archive Files"
		"Windows Error Reporting Queue Files"
		"Windows Error Reporting System Archive Files"
		"Windows Error Reporting System Queue Files"
		"Windows ESD installation files"
		"Windows Upgrade Log Files"
	)

	ForEach ($item in $Locations) {
		Set-ItemProperty -Path $($Base+$item) -Name $SageSet -Type DWORD -Value 2 -ErrorAction SilentlyContinue | Out-Null
	}

	<#
		.Do the clean-up. Have to convert the SageSet number
		.进行清理。 必须转换 SageSet 编号
	#>
	$Args = "/sagerun:$([string]([int]$SageSet.Substring($SageSet.Length-4)))"
	Start-Process -Wait "$($env:SystemRoot)\System32\cleanmgr.exe" -ArgumentList $Args

	<#
		.Remove the Stateflags
		.删除状态标志
	#>
	ForEach ($item in $Locations) {
		Remove-ItemProperty -Path $($Base+$item) -Name $SageSet -force -ErrorAction SilentlyContinue | Out-Null
	}
}

<#
	.WinSxS slimming
	.WinSxS 瘦身
#>
Function Cleanup_SxS
{
	write-host "  $($lang.SxS)"
	write-host "  $($lang.Clean)".PadRight(22) -NoNewline

	# 清理组件
	Dism.exe /online /Cleanup-Image /StartComponentCleanup

	# 重置替代组件的基础
	Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
	
	# 删除备份文件
	Dism.exe /online /Cleanup-Image /SPSuperseded
	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Notification Center
	.通知中心
#>
Function Notification_Center
{
	param
	(
		[switch]$Restore,
		[switch]$Full,
		[switch]$Part
	)

	$Notifications = @(
#		"windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" # Settings
		"microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar"    # Calendar
		"microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail"        # Mail
		"Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"                                 # Edge
		"Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI"                                   # Cortana
		"Windows.SystemToast.AudioTroubleshooter"                                             # Audio
		"Windows.SystemToast.Suggested"                                                       # Suggested
		"Microsoft.WindowsStore_8wekyb3d8bbwe!App"                                            # Store
		"Windows.SystemToast.SecurityAndMaintenance"                                          # Security and Maintenance
		"Windows.SystemToast.WiFiNetworkManager"                                              # Wireless
		"Windows.SystemToast.HelloFace"                                                       # Windows Hello
		"Windows.SystemToast.RasToastNotifier"                                                # VPN
		"Windows.System.Continuum"                                                            # Tablet
		"Microsoft.BingNews_8wekyb3d8bbwe!AppexNews"                                          # News
		"Windows.SystemToast.BdeUnlock"                                                       # Bitlocker
		"Windows.SystemToast.BackgroundAccess"                                                # Battery Saver
		"Windows.Defender.SecurityCenter"                                                     # Security Center
		"Microsoft.Windows.Photos_8wekyb3d8bbwe!App"                                          # Photos
		"Microsoft.SkyDrive.Desktop"                                                          # OneDrive
#		"Windows.SystemToast.AutoPlay"                                                        # Autoplay
	)

	write-host "  $($lang.Notification)"
	if ($Restore) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		Remove-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" -Name "PastIconsStream" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" -Name "IconStreams" -ErrorAction SilentlyContinue
		
		Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Name "DisableEnhancedNotifications" -ErrorAction SilentlyContinue
		Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		
		ForEach ($Name in $Notifications) {
			New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$Name" -Name Enabled -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		}
	
		netsh firewall set notifications mode=enable profile=all | Out-Null
		netsh firewall set opmode exceptions=enable | Out-Null
	}

	if ($Full) {
		write-host "  $($lang.Full)".PadRight(22) -NoNewline
		If (-not (Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
			New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
		}
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
	}

	if ($Part) {
		write-host "  $($lang.Part)".PadRight(22) -NoNewline
		if ((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications") -ne $true) { New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -force -ErrorAction SilentlyContinue | Out-Null }
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications' -Name 'DisableEnhancedNotifications' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

		ForEach ($Name in $Notifications)
		{
			if ((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$Name") -ne $true) {
				New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$Name" -force -ErrorAction SilentlyContinue | Out-Null
			}

			New-ItemProperty -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$Name" -Name Enabled -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		}

		# 关闭 防火墙通知
		New-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -Name DisableNotifications -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" -Name DisableNotifications -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -Name DisableNotifications -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	}

	Restart_Explorer

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.System disk paging size
	.系统盘分页大小
#>
Function System_Disk_Page_Size
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable,
		[string]$size
	)

	write-host "  $($lang.PagingSize)"
	if ($Enabled) {
		write-host "  $($lang.Setting) $($size)G".PadRight(22) -NoNewline
		switch ($size)
		{
			8 {
				New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value @("$($env:SystemDrive)\pagefile.sys 8192 8192") -PropertyType MultiString -force -ErrorAction SilentlyContinue | Out-Null
			}
			16 {
				New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value @("$($env:SystemDrive)\pagefile.sys 16384 16384") -PropertyType MultiString -force -ErrorAction SilentlyContinue | Out-Null
			}
		}
	}

	if ($Disable) {
		write-host "  $($lang.Restore)".PadRight(22) -NoNewline
		New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value @("?:\pagefile.sys") -PropertyType MultiString -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Enabled 3389 remote desktop
	.启用 3389 远程桌面
#>
Function Remote_Desktop
{
	write-host "  $($lang.StRemote)"
	write-host "  $($lang.Enable)".PadRight(22) -NoNewline
	if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

	if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\TermService") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\TermService" -force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\TermService' -Name 'Start' -Value 2 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

	if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\MpsSvc") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\MpsSvc" -force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\MpsSvc' -Name 'Start' -Value 4 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null
	Stop-Service "MpsSvc" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null

	netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389 | Out-Null
	Start-Service "TermService" -ErrorAction SilentlyContinue | Out-Null

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}


<#
	.Turn on SMB file sharing
	.打开 SMB 文件共享
#>
Function SMB_File_Share
{
	write-host "  $($lang.StSMB)"
	write-host "  $($lang.Enable)".PadRight(22) -NoNewline
	<#
		.Add 'firewall rules'
		.添加 '防火墙规则'
	#>
	netsh advfirewall firewall add rule name="NetBIOS UDP Port 137" dir=in action=allow protocol=UDP localport=137 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS UDP Port 137" dir=out action=allow protocol=UDP localport=137 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS UDP Port 138" dir=in action=allow protocol=UDP localport=138 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS UDP Port 138" dir=out action=allow protocol=UDP localport=138 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS TCP Port 139" dir=in action=allow protocol=TCP localport=139 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS TCP Port 139" dir=out action=allow protocol=TCP localport=139 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS TCP Port 445" dir=in action=allow protocol=TCP localport=445 | Out-Null
	netsh advfirewall firewall add rule name="NetBIOS TCP Port 445" dir=out action=allow protocol=TCP localport=445 | Out-Null

	<#
		.Enabled 'Guest User'
		.启用 'Guest 用户'
	#>
	Net User Guest /Active:yes | Out-Null

	<#
		.Set the group policy 'Deny guest users in this computer from accessing the network'
		.设置组策略 '拒绝从网络访问此计算机中的 Guest 用户'
	#>
	if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'forceguest' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

	if ((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet001\Control\Lsa") -ne $true) { New-Item "HKLM:\SYSTEM\CurrentControlSet001\Control\Lsa" -force -ErrorAction SilentlyContinue | Out-Null }
	New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet001\Control\Lsa' -Name 'forceguest' -Value 1 -PropertyType DWord -force -ErrorAction SilentlyContinue | Out-Null

	<#
		.Group Policy 'Guests Only-Authenticate local users as guests'
		.组策略 '仅来宾 - 对本地用户进行身份验证，其身份为来宾'
	#>
	Remove-Item -Path "$($env:TEMP)\share.inf" -ErrorAction SilentlyContinue
@"
[Version] 
signature="`$CHICAGO$" 
Revision=1 

[Privilege Rights] 
SeDenyNetworkLogonRight = 
"@ | Out-File -FilePath "$($env:TEMP)\share.inf" -Encoding Ascii
	secedit /configure /db "$($env:TEMP)\share.sdb" /cfg "$($env:TEMP)\share.inf"
	Remove-Item -Path "$($env:TEMP)\share.inf" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:TEMP)\share.sdb" -ErrorAction SilentlyContinue

	<#
		.Disable the 'Psec Policy Agent (IP security policy) service'
		.禁用 'Psec Policy Agent（IP安全策略）服务'
	#>
	Set-Service -Name "PolicyAgent" -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
	Stop-Service "PolicyAgent" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null

	<#
		.Disable the 'Server (Shared Service)'
		.禁用 'Server（共享服务）'
	#>
	Set-Service -Name "ShareAccess" -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
	Stop-Service "ShareAccess" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null

	<#
		.Enabled 'Computer Browser (browsing service)'
		.启用 'Computer Browser（浏览服务）'
	#>
	Set-Service -Name "Browser" -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
	Start-Service "Browser" -ErrorAction SilentlyContinue | Out-Null

	<#
		.Disable the 'MpsSvc Service'
		.禁用 'MpsSvc 服务'
	#>
	Set-Service -Name "MpsSvc" -StartupType Manual -ErrorAction SilentlyContinue | Out-Null
	Stop-Service "MpsSvc" -Force -NoWait -ErrorAction SilentlyContinue | Out-Null

	<#
		.Enabled 'LanmanServer service'
		.启用 'LanmanServer 服务'
	#>
	Set-Service -Name "LanmanServer" -StartupType Automatic -ErrorAction SilentlyContinue | Out-Null
	Start-Service "LanmanServer" -ErrorAction SilentlyContinue | Out-Null
	gpupdate /force | out-null

	Write-Host "$($lang.Done)`n" -ForegroundColor Green
}

<#
	.Remove Desktop from This PC
	.从这台电脑上删除桌面
#>
Function Desktop_Icon_ThisPC
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationDesktop)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Remove Documents from This PC
	.从这台电脑上删除文档
#>
Function Desktop_Icon_Document
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationDocuments)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.Remove Downloads from This PC
	.从这台 PC 中删除下载
#>
Function Desktop_Icon_Download
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationDownloads)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Remove Music from This PC
	.从这台电脑中删除音乐
#>
Function Desktop_Icon_Music
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationMusic)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Remove Pictures from This PC
	.从这台电脑中删除图片
#>
Function Desktop_Icon_Picture
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationPictures)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Remove Videos from This PC
	.从这台 PC 中删除视频
#>
Function Desktop_Icon_Video
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.LocationVideos)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Remove Videos from This PC
	.从这台 PC 中删除视频
#>
Function Desktop_Icon_3D
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.ThisPCRemove -f $lang.Location3D)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -ErrorAction SilentlyContinue | Out-Null
		New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}


<#
	.All icons in the taskbar
	.任务栏所有图标
#>
Function Reset_TaskBar
{
	write-host "  $($lang.Reset) $($lang.TaskBar)" -ForegroundColor Green
	write-host "  $($lang.Del) $($lang.TaskBar)"
	Remove-Item -Path "$($env:AppData)\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.*" -ErrorAction SilentlyContinue | Out-Null
	Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	if (Test-Path "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\syspin")\syspin.exe" -PathType Leaf) {
		Start-Process -FilePath "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\syspin")\syspin.exe" -ArgumentList """$($env:systemroot)\explorer.exe"" ""5386""" -Wait -WindowStyle Hidden
	}
	Restart_Explorer

	write-host "  $($lang.ResetExplorer)`n"
}

<#
	.Rearrange the desktop icons by name
	.重新按名称排列桌面图标
#>
Function Reset_Desktop
{
	$ResetDesktopReg = @(
		'HKCU:\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
	)

	write-host "  $($lang.ResetDesk)" -ForegroundColor Green
	write-host "  $($lang.ResetFolder)"
	ForEach ($item in $ResetDesktopReg) {
		Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	Restart_Explorer

	write-host "  $($lang.ResetExplorer)`n"
	RefreshIconCache
}


<#
	.Refresh icon cache
	.刷新图标缓存
#>
Function RefreshIconCache
{
	$code = @'
	private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
	private const int WM_SETTINGCHANGE = 0x1a;
	private const int SMTO_ABORTIFHUNG = 0x0002;

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
private static extern IntPtr SendMessageTimeout ( IntPtr hWnd, int Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult );

[System.Runtime.InteropServices.DllImport("Shell32.dll")] 
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

public static void Refresh() {
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);
}
'@

	Add-Type -MemberDefinition $code -Namespace MyWinAPI -Name Explorer
	[MyWinAPI.Explorer]::Refresh()
}