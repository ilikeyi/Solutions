<#
	.Handle operations that need to be mounted after install.wim or boot.wim
	.处理需要挂载 install.wim 或 boot.wim 后的操作
#>
Function Event_Process_Task_Need_Mount
{
	# 保存
	$IsEjectAfterSave = $False
	if ((Get-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$IsEjectAfterSave = $True
	}
	if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$IsEjectAfterSave = $True
	}

	# 不保存
	$IsEjectAfterSaveNot = $False
	if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$IsEjectAfterSaveNot = $True

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x009000`n  Start"
			Write-Host "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)"
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x009000`n  End"
		}
	}
	if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$IsEjectAfterSaveNot = $True

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x009010`n  Start"
			Write-Host "Queue_Expand_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)"
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x009010`n  End"
		}
	}

	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
		$Temp_Export_SaveTo = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Report"
	} else {
		$Temp_Export_SaveTo = $Temp_Expand_Rule
	}

	<#
		.初始化时间：每任务
	#>
	$Script:SingleTaskTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
	$Script:SingleTaskTime = New-Object System.Diagnostics.Stopwatch
	$Script:SingleTaskTime.Reset()
	$Script:SingleTaskTime.Start()

	Write-Host "`n  $($lang.ProcessingImage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
	Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
	Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

	Write-Host "`n  $($lang.TimeStart)" -NoNewline
	Write-Host " $($Script:SingleTaskTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	<#
		.Start processing all tasks
		.开始处理所有任务
	#>

	<#
		.Running PowerShell Functions: Before Tasks
		.运行 PowerShell 函数：有任务前
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.SpecialFunction): $($lang.Functions_Before)"

	Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_Functions_Before_Task = (Get-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Functions_Before_Task.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Functions_Before_Task) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Functions_Before_Task) {
			Invoke-Expression -Command $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Running API: Before Tasks
		.运行 API：有任务前
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.API): $($lang.Functions_Before)"

	Write-Host "`n  $($lang.API): $($lang.Functions_Before)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_API_Before_Task = (Get-Variable -Scope global -Name "Queue_API_Before_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_API_Before_Task.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_API_Before_Task) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_API_Before_Task) {
			API_Process_Rule_Name -RuleName $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Generate solution
		.生成解决方案
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Solution)"

	Write-Host "`n  $($lang.Solution)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)" -ForegroundColor Green

		<#
			.批量操作，挂载所有映像源，并添加
		#>
		Solutions_Generate_Prerequisite -Mount
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Windows Feature: Enabled, Match
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.WindowsFeature): $($lang.Enable), $($lang.MatchMode)"

	Write-Host "`n  $($lang.WindowsFeature): $($lang.Enable), $($lang.MatchMode)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Enable_Match_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Feature_Enabled_Match_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Windows Feature: Enabled, Match
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.WindowsFeature): $($lang.Disable), $($lang.MatchMode)"

	Write-Host "`n  $($lang.WindowsFeature): $($lang.Disable), $($lang.MatchMode)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Disable_Match_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Feature_Disable_Match_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Windows Feature: Enabled
		.Windows 功能：启用
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.WindowsFeature): $($lang.Enable)"

	Write-Host "`n  $($lang.WindowsFeature): $($lang.Enable)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Enable_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Feature_Enabled_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Windows Feature: Disable
		.Windows 功能：禁用
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.WindowsFeature): $($lang.Disable)"

	Write-Host "`n  $($lang.WindowsFeature): $($lang.Disable)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Disable_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Feature_Disable_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	#-------------------------------- Language Start --------------------------------
	<#
		.Add Language
		.添加语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Language): $($lang.AddTo)"

	Write-Host "`n  $($lang.Language): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:LanguageAddTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LanguageAddTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LanguageAddTasksTime.Reset()
		$Script:LanguageAddTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LanguageAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Language_Add_Process

		<#
			.同步语言包到安装程序
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.BootSyncToISO)"

		Write-Host "`n  $($lang.BootSyncToISO)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green

			Language_Sync_To_ISO_Process
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		<#
			.Rebuild lang.ini
			.重建 lang.ini
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LangIni)"

		Write-Host "`n  $($lang.LangIni)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Language_Refresh_Ini
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		$Script:LanguageAddTasksTime.Stop()

		Write-Host "`n  $($lang.Language): $($lang.AddTo), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LanguageAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LanguageAddTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LanguageAddTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Change the global default language of the image
		.更改映像全局默认语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.SwitchLanguage)"

	Write-Host "`n  $($lang.SwitchLanguage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Change_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)" -ForegroundColor Green

		Language_Change_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Delete Language
		.删除语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Language): $($lang.Del)"

	Write-Host "`n  $($lang.Language): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Del_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:LanguageDelTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LanguageDelTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LanguageDelTasksTime.Reset()
		$Script:LanguageDelTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LanguageDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Language_Delete_Process

		<#
			.同步语言包到安装程序
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.BootSyncToISO)"

		Write-Host "`n  $($lang.BootSyncToISO)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Del_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green

			Language_Sync_To_ISO_Process
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		<#
			.Rebuild lang.ini
			.重建 lang.ini
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LangIni)"

		Write-Host "`n  $($lang.LangIni)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Del_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Language_Refresh_Ini
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		$Script:LanguageDelTasksTime.Stop()

		Write-Host "`n  $($lang.Language): $($lang.Del), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LanguageDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LanguageDelTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LanguageDelTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Change the global default language of the image
		.更改映像全局默认语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.SwitchLanguage)"

	Write-Host "`n  $($lang.SwitchLanguage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Change_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)" -ForegroundColor Green

		Language_Change_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.clean up components: Language
		.清理组件：语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.OnlyLangCleanup)"

	Write-Host "`n  $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:ComponentsClearTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:ComponentsClearTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:ComponentsClearTasksTime.Reset()
		$Script:ComponentsClearTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:ComponentsClearTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Cleanup_Components_Process

		$Script:ComponentsClearTasksTime.Stop()

		Write-Host "`n  $($lang.OnlyLangCleanup), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:ComponentsClearTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:ComponentsClearTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:ComponentsClearTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
	#-------------------------------- Language End --------------------------------


	<#
		.Warning: Do not change the order
		.警告：请勿更改顺序
	#>
	<#
		.Verify whether to remove old pre-installed software
		.验证是否删除旧的预安装软件
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.InboxAppsClear)"

	Write-Host "`n  $($lang.InboxAppsClear)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:InBoxAppsDeletePreTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:InBoxAppsDeletePreTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:InBoxAppsDeletePreTasksTime.Reset()
		$Script:InBoxAppsDeletePreTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:InBoxAppsDeletePreTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_LIPs_Clean_Process

		$Script:InBoxAppsDeletePreTasksTime.Stop()

		Write-Host "`n  $($lang.InboxAppsClear), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:InBoxAppsDeletePreTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:InBoxAppsDeletePreTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:InBoxAppsDeletePreTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 1: Add local language experience packs (LXPs)
		.第一步：添加本地语言体验包 (LXPs)
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)"

	Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:InBoxAppsAddTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:InBoxAppsAddTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:InBoxAppsAddTasksTime.Reset()
		$Script:InBoxAppsAddTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:InBoxAppsAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_LIPs_Add_Mark_Process

		$Script:InBoxAppsAddTasksTime.Stop()

		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:InBoxAppsAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:InBoxAppsAddTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:InBoxAppsAddTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.InBox Apps: Add
		.Inbox Apps: 添加
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.InboxAppsManager): $($lang.AddTo)"

	Write-Host "`n  $($lang.InboxAppsManager): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:InBoxAppsInstallNewTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:InBoxAppsInstallNewTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:InBoxAppsInstallNewTasksTime.Reset()
		$Script:InBoxAppsInstallNewTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:InBoxAppsInstallNewTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_Add_Process

		$Script:InBoxAppsInstallNewTasksTime.Stop()

		Write-Host "`n  $($lang.InboxAppsManager): $($lang.AddTo), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:InBoxAppsInstallNewTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:InBoxAppsInstallNewTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:InBoxAppsInstallNewTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 3: Remove local language experience packs (LXPs)
		.第三步：删除本地语言体验包 (LXPs)
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)"

	Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_LXPs_Delete = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Delete_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_LXPs_Delete.Count -gt 0) {
		$Script:LXPsDelTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LXPsDelTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LXPsDelTasksTime.Reset()
		$Script:LXPsDelTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LXPsDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_LIPs_Delete_Process

		$Script:LXPsDelTasksTime.Stop()

		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LXPsDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LXPsDelTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LXPsDelTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 4: Add only local language experience packs (LXPs)
		.第四步：仅添加本地语言体验包 (LXPs)
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)"

	Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
		$Script:LXPsAddTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LXPsAddTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LXPsAddTasksTime.Reset()
		$Script:LXPsAddTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LXPsAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_LIPs_Add_Process

		$Script:LXPsAddTasksTime.Stop()

		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Update), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LXPsAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LXPsAddTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LXPsAddTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 5: Remove local language experience packs (LXPs)
		.第五步：删除本地语言体验包 (LXPs)
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)"

	Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_LXPs_Delete = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Delete_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_LXPs_Delete.Count -gt 0) {
		$Script:LXPsDeleteOldTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LXPsDeleteOldTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LXPsDeleteOldTasksTime.Reset()
		$Script:LXPsDeleteOldTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LXPsDeleteOldTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_LIPs_Delete_Process

		$Script:LXPsDeleteOldTasksTime.Stop()
		Write-Host "`n  $($lang.LocalExperiencePack) ( LXPs ): $($lang.Del), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOldTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOldTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOldTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 6: Remove selected InBox Apps preinstalled software by rule matching
		.第六步：按规则匹配删除已选择的 InBox Apps 预安装软件
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.InboxAppsMatchDel)"

	Write-Host "`n  $($lang.InboxAppsMatchDel)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_Functions_Before_Task = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Match_Rule_Delete_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Functions_Before_Task.Count -gt 0) {
		$Script:LXPsDeleteMatchTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LXPsDeleteMatchTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LXPsDeleteMatchTasksTime.Reset()
		$Script:LXPsDeleteMatchTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LXPsDeleteMatchTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_Match_Delete_Process

		$Script:LXPsDeleteMatchTasksTime.Stop()

		Write-Host "`n  $($lang.InboxAppsMatchDel), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LXPsDeleteMatchTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LXPsDeleteMatchTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LXPsDeleteMatchTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Step 7: Delete installed InBox Apps apps offline
		.第七步：离线删除已安装的 InBox Apps 应用
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel)"

	Write-Host "`n  $($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Mount_Rule_Delete_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:LXPsDeleteOfflineTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:LXPsDeleteOfflineTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:LXPsDeleteOfflineTasksTime.Reset()
		$Script:LXPsDeleteOfflineTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:LXPsDeleteOfflineTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		InBox_Apps_Offline_Delete_Process

		$Script:LXPsDeleteOfflineTasksTime.Stop()

		Write-Host "`n  $($lang.InboxAppsManager): $($lang.InboxAppsOfflineDel), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOfflineTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOfflineTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:LXPsDeleteOfflineTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Optimize the provisioning of Appx packages by replacing the same files with hard links
		.优化预配 Appx 包，通过用硬链接替换相同的文件
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Optimize_Appx_Package)"

	Write-Host "`n  $($lang.Optimize_Appx_Package)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:InBoxAppsOptimizeTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:InBoxAppsOptimizeTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:InBoxAppsOptimizeTasksTime.Reset()
		$Script:InBoxAppsOptimizeTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:InBoxAppsOptimizeTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Inbox_Apps_Hard_Links_Optimize

		$Script:InBoxAppsOptimizeTasksTime.Stop()

		Write-Host "`n  $($lang.Optimize_Appx_Package), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:InBoxAppsOptimizeTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:InBoxAppsOptimizeTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:InBoxAppsOptimizeTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Cumulative updates: Add
		.累积更新：添加
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.CUpdate): $($lang.AddTo)"

	Write-Host "`n  $($lang.CUpdate): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:OSUpdateAddTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:OSUpdateAddTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:OSUpdateAddTasksTime.Reset()
		$Script:OSUpdateAddTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:OSUpdateAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Update_Add_Process

		$Script:OSUpdateAddTasksTime.Stop()

		Write-Host "  $($lang.CUpdate): $($lang.AddTo), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:OSUpdateAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:OSUpdateAddTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:OSUpdateAddTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Cumulative updates: Delete
		.累积更新：删除
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.CUpdate): $($lang.Del)"

	Write-Host "`n  $($lang.CUpdate): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Del_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:OSUpdateDelTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:OSUpdateDelTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:OSUpdateDelTasksTime.Reset()
		$Script:OSUpdateDelTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:OSUpdateDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Update_Del_Process

		$Script:OSUpdateDelTasksTime.Stop()

		Write-Host "  $($lang.CUpdate): $($lang.Del), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:OSUpdateDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:OSUpdateDelTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:OSUpdateDelTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Drive: Add
		.驱动：添加
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Drive): $($lang.AddTo)"

	Write-Host "`n  $($lang.Drive): $($lang.AddTo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:DriveAddTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:DriveAddTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:DriveAddTasksTime.Reset()
		$Script:DriveAddTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:DriveAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Drive_Add_Process

		$Script:DriveAddTasksTime.Stop()

		Write-Host "`n  $($lang.Drive): $($lang.AddTo), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:DriveAddTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:DriveAddTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:DriveAddTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Drive: Delete
		.驱动: 删除
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Drive): $($lang.Del)"

	Write-Host "`n  $($lang.Drive): $($lang.Del)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Delete_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:DriveDelTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:DriveDelTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:DriveDelTasksTime.Reset()
		$Script:DriveDelTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:DriveDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Drive_Delete_Process

		$Script:DriveDelTasksTime.Stop()

		Write-Host "`n  $($lang.Drive): $($lang.Del), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:DriveDelTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:DriveDelTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:DriveDelTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Curing Update
		.固化更新
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.CuringUpdate)"

	Write-Host "`n  $($lang.CuringUpdate)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:CuringUpdateTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:CuringUpdateTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:CuringUpdateTasksTime.Reset()
		$Script:CuringUpdateTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:CuringUpdateTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 11`n" -ForegroundColor Green
		}

		$test_mount_Sources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

		$arguments = @(
			"/Image:""$($test_mount_Sources)""",
			"/cleanup-image",
			"/StartComponentCleanup"
		)

		write-host "  " -NoNewline
		Write-Host " $($lang.ResetBase) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_ResetBase_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$arguments += "/ResetBase"
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		}

		write-host "  " -NoNewline
		Write-Host " $($lang.Wim_Rule_Optimize) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_Defer_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			$arguments += "/Defer"
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Write-Host "  Dism $($arguments)" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
		}

		Start-Process -FilePath "Dism.exe" -ArgumentList $Arguments -Wait -NoNewWindow

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

		$Script:CuringUpdateTasksTime.Stop()

		Write-Host "`n  $($lang.CuringUpdate), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:CuringUpdateTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:CuringUpdateTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:CuringUpdateTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.清理取代的
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Superseded)"

	Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:SupersededClearTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:SupersededClearTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:SupersededClearTasksTime.Reset()
		$Script:SupersededClearTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:SupersededClearTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Image_Clear_Superseded

		$Script:SupersededClearTasksTime.Stop()

		Write-Host "`n  $($lang.Superseded), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:SupersededClearTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:SupersededClearTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:SupersededClearTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.打印报告
	#>
	<#
		.获取预安装应用 InBox Apps
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.GetInBoxApps)"

	Write-Host "`n  $($lang.GetInBoxApps)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.ExportShow)" -ForegroundColor Yellow

		Image_Get_Apps_Package -Save $Temp_Export_SaveTo -View
	} else {
		Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Image_Get_Apps_Package -Save $Temp_Export_SaveTo
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}

	<#
		.查看安装的所有软件包的列表
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.GetImagePackage)"

	Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.ExportShow)" -ForegroundColor Yellow

		Image_Get_Components_Package -Save $Temp_Export_SaveTo -View
	} else {
		Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Image_Get_Components_Package -Save $Temp_Export_SaveTo
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}

	<#
		.查看已安装的驱动列表
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.ViewDrive)"

	Write-Host "`n  $($lang.ViewDrive)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.ExportShow)" -ForegroundColor Yellow

		Image_Get_Installed_Drive -Save $Temp_Export_SaveTo -View
	} else {
		Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow

		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
			Image_Get_Installed_Drive -Save $Temp_Export_SaveTo
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}

	<#
		.映像语言
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.ImageLanguage)"

	Write-Host "`n  $($lang.ImageLanguage)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow
	if ((Get-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)" -ForegroundColor Green

		$test_mount_Sources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
		if (Test-Path -Path $test_mount_Sources -PathType Container) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 12" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 77)"
				Write-Host "  Dism.exe /Image:""$($test_mount_Sources)"" /Get-Intl" -ForegroundColor Green
				Write-Host "  $('-' * 77)"
			}

			Check_Folder -chkpath $Temp_Export_SaveTo
			$TempSaveTo = "$($Temp_Export_SaveTo)\Index.$(Image_Get_Mount_Index).Language.$(Get-Date -Format "yyyyMMddHHmmss").log"

			Write-Host "`n  $($lang.SaveTo)"
			Write-Host "  $($TempSaveTo)" -ForegroundColor Green

			start-process "Dism.exe" -ArgumentList "/Image:""$($test_mount_Sources)"" /Get-Intl" -wait -WindowStyle Hidden -RedirectStandardOutput $TempSaveTo
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.健康
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.Healthy)"

	Write-Host "`n  $($lang.Healthy)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
		$Script:HealthyTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:HealthyTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:HealthyTasksTime.Reset()
		$Script:HealthyTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:HealthyTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green

		<#
			.触发此事件强制结束
		#>
		$test_mount_Sources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

		if (Healthy_Check_Process -NewPath $test_mount_Sources) {
			
		} else {
			Write-Host "  $($lang.HealthyForceStop)" -ForegroundColor Red
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.Healthy_Save)`n" -ForegroundColor Red
			if ((Get-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
				Write-Host "  $($lang.Operable)`n" -ForegroundColor Green

				$IsEjectAfterSave = $Flase
				Additional_Edition_Reset
				Event_Reset_Variable

				AZ_Error_Page
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}
		}

		$Script:HealthyTasksTime.Stop()
		Write-Host "`n  $($lang.Healthy), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:HealthyTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:HealthyTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:HealthyTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Running PowerShell Functions: After Completing a Task
		.运行 PowerShell 函数：完成任务后
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.SpecialFunction): $($lang.Functions_Rear)"

	Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Rear)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_Functions_Rear_Task = (Get-Variable -Scope global -Name "Queue_Functions_Rear_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Functions_Rear_Task.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Functions_Rear_Task) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Functions_Rear_Task) {
			Invoke-Expression -Command $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Running API: After Completing a Task
		.运行 API：完成任务后
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.API): $($lang.Functions_Rear)"

	Write-Host "`n  $($lang.API): $($lang.Functions_Rear)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$Temp_API_Rear_Task = (Get-Variable -Scope global -Name "Queue_API_Rear_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_API_Rear_Task.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_API_Rear_Task) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_API_Rear_Task) {
			API_Process_Rule_Name -RuleName $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.弹出：保存

		1、获取已预分配的保存规则，来源：Queue_Eject_Expand_Save_*
			条件：优先按规则设置，并操作。

		2、如果没有规则，则根据用户勾选：“未指定映像内卸载动作时，不保存”按钮来操作。
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.UnmountAndSave)"

	Write-Host "`n  $($lang.UnmountAndSave)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.SaveTo)" -ForegroundColor Yellow
	if ($IsEjectAfterSave) {
		$Script:EjectSaveTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:EjectSaveTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:EjectSaveTasksTime.Reset()
		$Script:EjectSaveTasksTime.Start()

		Write-Host "`n  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:EjectSaveTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

		<#
			.优先卸载扩展项
		#>
		<#
			.匹配主要项里，是否挂载映像内的其它映像文件
		#>
		ForEach ($item in $Global:Image_Rule) {
			if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
				if ($item.Expand.Count -gt 0) {
					Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
					Write-Host "  $($lang.Side_quests)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"

					ForEach ($itemExpandNew in $item.Expand) {
						<#
							.初始化变量
						#>
						$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"

						Write-Host "  $($lang.YesWork)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $itemExpandNew.Uid -ForegroundColor Green

						Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $Temp_Do_Not_Save_Path -ForegroundColor Green

						<#
							.Determine if it is mounted
							.判断是否已挂载
						#>
						Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($itemExpandNew.Uid)").Value) {
							Write-Host "  $($lang.Mounted)"

							<#
								.健康
							#>
							Write-Host "`n  $($lang.Healthy)" -ForegroundColor Yellow
							if ((Get-Variable -Scope global -Name "Queue_Expand_Healthy_$($itemExpandNew.Uid)").Value) {
								<#
									.触发此事件强制结束
								#>
								$test_mount_Sources_Expand = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"

								if (Healthy_Check_Process -NewPath $test_mount_Sources_Expand) {
								} else {
									<#
										.强行终止保存功能，不建议强行开启，

										 因为映像内的文件不支持这功能，该功能在特定环境，仅支持 install.wim，
									#>

#									New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($itemExpandNew.Uid)" -Value $False -Force
								}
								Write-Host "  $($lang.Done)" -ForegroundColor Green
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}

							<#
								.保存
							#>
							Write-Host "`n  $($lang.Save)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  $($Temp_Do_Not_Save_Path)" -ForegroundColor Green
							if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($itemExpandNew.Uid)").Value) {
								$test_mount_Sources_Expand = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"

								if ($Global:Developers_Mode) {
									Write-Host "  $($lang.Developers_Mode_Location): 15`n" -ForegroundColor Green
								}

								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Save-WindowsImage -Path ""$($test_mount_Sources_Expand)""" -ForegroundColor Green
									Write-Host "  $('-' * 80)"
								}

								Write-Host
								Write-Host "  " -NoNewline
								Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
								Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_Sources_Expand | Out-Null
								Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}

							<#
								.不保存
								 保存带不保存，优先判断：主映像文件卸载，再判断自定义选择单独项
							#>
							Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"

							<#
								.判断是否主映像卸载
							#>
							$Mark_Is_Unmount_Current_Image = $False
							$IsEjectAfterSaveNot = (Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
							if ($IsEjectAfterSaveNot) {
								$Mark_Is_Unmount_Current_Image = $True
							}

							if ((Get-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($itemExpandNew.Uid)").Value) {
								$Mark_Is_Unmount_Current_Image = $True
							}

							if ($Mark_Is_Unmount_Current_Image) {
								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 16`n" -ForegroundColor Green
								}

								Image_Eject_Abandon -Uid $itemExpandNew.Uid -VerifyPath $Temp_Do_Not_Save_Path
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}

							<#
								.重建
							#>
							Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ((Get-Variable -Scope global -Name "Queue_Expand_Rebuild_$($itemExpandNew.Uid)").Value) {
								Write-Host "  $($lang.Operable)" -ForegroundColor Green

								Write-Host "`n  $($lang.AE_IsCheck)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								write-host "  " -NoNewline
								$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($itemExpandNew.Uid)" -ErrorAction SilentlyContinue).Value
								if ($Temp_Additional_Edition.Count -gt 0) {
									Write-Host " $($lang.AE_IsRuning) " -BackgroundColor DarkGreen -ForegroundColor White
								} else {
									Write-Host " $($lang.AE_NoEvent) " -BackgroundColor DarkRed -ForegroundColor White

									<#
										.没有检查到有可可用的附加版本事件，允许重建
									#>
									Rebuild_Image_File -Filename $itemExpandNew.Path
								}
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}
						} else {
							Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
						}

						Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $itemExpandNew.Uid -ForegroundColor Green
						Write-Host "  $('-' * 80)"
						Write-Host "  $($lang.Done)" -ForegroundColor Green
					}
				}
			}
		}

		Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

		Write-Host "`n  $($lang.Save)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$test_mount_Sources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
		Write-Host "  $($test_mount_Sources)" -ForegroundColor Green

		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 19`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Save-WindowsImage -Path ""$($test_mount_Sources)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
		}

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_Sources | Out-Null
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

		$Script:EjectSaveTasksTime.Stop()

		Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

		Write-Host "`n  $($lang.UnmountAndSave): $($lang.Save), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:EjectSaveTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:EjectSaveTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:EjectSaveTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.弹出：不保存

		 2、获取所有扩展项，判断是否有已挂载，指令：1、不保存，2、卸载。
	#>
	$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $(Image_Get_Mount_Index), $($lang.DoNotSave)"

	Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($IsEjectAfterSaveNot) {
		$Script:EjectDoNotSaveTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
		$Script:EjectDoNotSaveTasksTime = New-Object System.Diagnostics.Stopwatch
		$Script:EjectDoNotSaveTasksTime.Reset()
		$Script:EjectDoNotSaveTasksTime.Start()

		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host " $($Script:EjectDoNotSaveTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

		Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

		<#
			.优先卸载扩展项
		#>
		<#
			.匹配主要项里，是否挂载映像内的其它映像文件
		#>
		Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
		Write-Host "  $($lang.Side_quests)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:Image_Rule) {
			if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
				if ($item.Expand.Count -gt 0) {
					ForEach ($itemExpandNew in $item.Expand) {
						<#
							.初始化变量
						#>
						$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"

						Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $itemExpandNew.Uid -ForegroundColor Green

						Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $Temp_Do_Not_Save_Path -ForegroundColor Green

						<#
							.检查了已挂载后，判断目录是否存在，再次删除。
						#>
						Write-Host "`n  $($lang.Unmount)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						if (Test-Path -Path $Temp_Do_Not_Save_Path -PathType Container) {
							<#
								.Determine if it is mounted
								.判断是否已挂载
							#>
							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($itemExpandNew.Uid)").Value) {
								Write-Host "  $($lang.Mounted), $($lang.DoNotSave)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  $($Temp_Do_Not_Save_Path)" -ForegroundColor Green

								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 20`n" -ForegroundColor Green
								}

								Image_Eject_Abandon -Uid $itemExpandNew.Uid -VerifyPath $Temp_Do_Not_Save_Path
							}

							if (Test-Path -Path $Temp_Do_Not_Save_Path -PathType Container) {
								if ($Global:Developers_Mode) {
									Write-Host "`n  $($lang.Developers_Mode_Location): 21`n" -ForegroundColor Green
								}

								Image_Eject_Abandon -Uid $itemExpandNew.Uid -VerifyPath $Temp_Do_Not_Save_Path
							}

							Write-Host "  $($lang.Done)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Done)" -ForegroundColor Green
						}
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			}
		}

		$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

		Write-Host "`n  $($lang.Event_Assign_Main)" -ForegroundColor Yellow
		Write-Host "  $($lang.Main_quests)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

		Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($Temp_Do_Not_Save_Path)" -ForegroundColor Green

		<#
			.Determine if it is mounted
			.判断是否已挂载
		#>
		Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Global:Primary_Key_Image.Uid)").Value) {
			Write-Host "  $($lang.Mounted)"

			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 22`n" -ForegroundColor Green
			}

			Image_Eject_Abandon -Uid $Global:Primary_Key_Image.Uid -VerifyPath $Temp_Do_Not_Save_Path
		}

		<#
			.检查了已挂载后，判断目录是否存在，再次删除。
		#>
		if (Test-Path -Path $Temp_Do_Not_Save_Path -PathType Container) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 23`n" -ForegroundColor Green
			}

			Image_Eject_Abandon -Uid $Global:Primary_Key_Image.Uid -VerifyPath $Temp_Do_Not_Save_Path
		}

		$Script:EjectDoNotSaveTasksTime.Stop()
		Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
		Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

		Write-Host "`n  $($lang.UnmountAndSave): $($lang.DoNotSave), $($lang.Done)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeStart)" -NoNewline
		Write-Host "$($Script:EjectDoNotSaveTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEnd)" -NoNewline
		Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAll)" -NoNewline
		Write-Host "$($Script:EjectDoNotSaveTasksTime.Elapsed)" -ForegroundColor Yellow

		Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
		Write-Host "$($Script:EjectDoNotSaveTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	} else {
		Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
	}

	$Script:SingleTaskTime.Stop()
	Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
	Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host "$($Script:SingleTaskTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEnd)" -NoNewline
	Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAll)" -NoNewline
	Write-Host "$($Script:SingleTaskTime.Elapsed)" -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
	Write-Host "$($Script:SingleTaskTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-Host "  $($lang.Done)" -ForegroundColor Green
}

<#
	.Events: Handling Allowed Items
	.事件：处理允许的项
#>
Function Event_Processing_Requires_Mounting
{
	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003100`n  Start"
	}

	<#
		.处理：无需挂载项，主键
	#>
	$Temp_Save_Has_Been_Run = @()
	$IsEjectAfterSave = (Get-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	ForEach ($item in $IsEjectAfterSave) {
		$Temp_Save_Has_Been_Run += $item
	}

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003190`n  Start"
	}

	$Temp_Assign_Task = (Get-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))}
	if ($Temp_Assign_Task.Count -gt 0) {
		Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		ForEach ($item in $Temp_Assign_Task) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003111`n  Start"
		}

		ForEach ($item in $Temp_Assign_Task) {
			$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value

			if ($Temp_Assign_Task_Select -Contains $item) {
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003150`n  Start"
				}

				$Temp_Save_Has_Been_Run += $item
				New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value $Temp_Save_Has_Been_Run -Force

				Invoke-Expression -Command $item

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003150`n  End"
				}
			}
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003111`n  End"
		}
	}

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003190`n  End"
	}

	<#
		.扩展项
	#>
	$Temp_Assign_Task = (Get-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))}
	Write-Host "`n  $($lang.User_Interaction): $($lang.AssignNeedMount): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Temp_Assign_Task.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Temp_Assign_Task.Count -gt 0) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003200`n  Start"
		}

		ForEach ($item in $Temp_Assign_Task) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		ForEach ($item in $Temp_Assign_Task) {
			$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
			if ($Temp_Assign_Task_Select -Contains $item) {
				$Temp_Save_Has_Been_Run += $item
				New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value $Temp_Save_Has_Been_Run -Force

				Invoke-Expression -Command $item
			}
		}

		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003200`n  End"
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
	
	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003100`n  End"
	}
}

<#
	.Events: Handling disallowed items
	.事件：分配无需挂载的项
#>
Function Event_Assign_Not_Allowed_UI
{
	<#
		.处理：无需挂载项，主键
	#>
	$Temp_Save_Has_Been_Run = @()
	$IsEjectAfterSave = (Get-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	ForEach ($item in $IsEjectAfterSave) {
		$Temp_Save_Has_Been_Run += $item
	}

	Write-Host "`n  $($lang.User_Interaction): $($lang.Main_quests), $($lang.AssignNoMount): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Global:Queue_Assign_Not_Monuted_Primary.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Global:Queue_Assign_Not_Monuted_Primary.Count -gt 0) {
		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Primary) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Primary) {
			$Temp_Save_Has_Been_Run += $item
			New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value $Temp_Save_Has_Been_Run -Force

			Invoke-Expression -Command $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	Write-Host "`n  $($lang.User_Interaction): $($lang.Side_quests), $($lang.AssignNoMount): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($Global:Queue_Assign_Not_Monuted_Expand_Select.Count) $($lang.EventManagerCount)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	if ($Global:Queue_Assign_Not_Monuted_Expand_Select.Count -gt 0) {
		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Expand_Select) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Expand_Select) {
			if ($Global:Queue_Assign_Not_Monuted_Primary -NotContains $item) {
				if ($Global:Queue_Assign_Not_Monuted_Expand_Select -Contains $item) {
					$Temp_Save_Has_Been_Run += $item
					New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value $Temp_Save_Has_Been_Run -Force

					Invoke-Expression -Command $item
				}
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.Handle events that don't require the image source to be mounted
	.处理不需要挂载映像源的事件
#>
Function Event_Process_Task_Sustainable
{
	<#
		.生成解决方案：ISO
	#>
	Solutions_Quick_Copy_Process_To_ISO

	<#
		.Convert image
		.转换映像
	#>
	Write-Host "`n  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	if ($Global:QueueConvert) {
		<#
			.判断先决条件：没有挂载项时才生效。
		#>
		<#
			.强行弹出所有已挂载项：不保存
		#>
		Eject_Forcibly_All -DontSave

		<#
			.开始转换
		#>
		Image_Convert_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Generate ISO
		.生成 ISO
	#>
	Write-Host "`n  $($lang.UnpackISO)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($Global:Queue_ISO) {
		ISO_Create_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.Associated ISO schemes
		.关联 ISO 方案
	#>
	Write-Host "`n  $($lang.ISO_Associated_Schemes)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($Global:Queue_ISO_Associated) {
		Autopilot_ISO_Associated_Process
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.Events: Handling Allowed Items
	.事件：有可用的事件时
#>
Function Event_Process_Available_UI
{
	Write-Host "`n  $($lang.User_Interaction): $($lang.AfterFinishingNotExecuted)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	if ($Global:Queue_Assign_Available_Select.Count -gt 0) {
		<#
			.分配任务已选择
		#>
		ForEach ($item in $Global:Queue_Assign_Available_Select) {
			if ($Global:Queue_Assign_Available_Select.Count -gt 0) {
				Invoke-Expression -Command $item
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red

		$Init_IsEvent = @(
			"Event_Completion_Setting_UI"
			"Event_Completion_Start_Setting_UI"
		)

		if ($Global:AutopilotMode) {
			$EventMaps = "Queue"
		}
	
		if ($Global:EventQueueMode) {
			$EventMaps = "Assign"
		}
	
		if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
			$EventMaps = "Assign"
		}

		if ($Init_IsEvent -NotContains "Event_Completion_Setting_UI") {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
				"NoProcess" {
					Write-Host "  $($lang.AfterFinishingNoProcess)" -ForegroundColor Green
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				}
				"Pause" {
					Write-Host "  $($lang.AfterFinishingPause)" -ForegroundColor Green
					Get_Next -DevCode "EP 1"
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				}
				"Reboot" {
					Write-Host "  $($lang.AfterFinishingReboot)" -ForegroundColor Green
					start-process "timeout.exe" -argumentlist "/t 10 /nobreak" -wait -nonewwindow
					Restart-Computer -Force -ErrorAction SilentlyContinue
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				}
				"Shutdown" {
					Write-Host "  $($lang.AfterFinishingShutdown)" -ForegroundColor Green
					start-process "timeout.exe" -argumentlist "/t 10 /nobreak" -wait -nonewwindow
					Stop-Computer -Force -ErrorAction SilentlyContinue
					Write-Host "  $($lang.Done)" -ForegroundColor Green
				}
			}
		}

		Write-Host "`n  $($lang.WaitTimeTitle)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.TimeExecute)" -ForegroundColor Green
		if ($Init_IsEvent -NotContains "Event_Completion_Start_Setting_UI") {
			$Global:QueueWaitTime = @{
				IsEnabled = $false
				Sky = 0
				Time = 0
				Minute = 30
			}
		}
	}
}

<#
	.检查健康
#>
Function Healthy_Check_Process
{
	param
	(
		$NewPath
	)

	if (Test-Path -Path $NewPath -PathType Container) {
		if ($Global:Developers_Mode) {
			Write-Host "  $($lang.Developers_Mode_Location): 26`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Repair-WindowsImage -Path ""$($NewPath)"" -ScanHealth).ImageHealthState" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			$Get_Image_Halter = (Repair-WindowsImage -Path $NewPath -ScanHealth -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Repair.log").ImageHealthState
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			write-host
			write-host "  " -NoNewline
			Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
			switch ($Get_Image_Halter) {
				"Healthy" {
					Write-Host " $($lang.Healthy) " -BackgroundColor DarkGreen -ForegroundColor White
					return $True
				}
				"Repairable" {
					Write-Host " $($lang.Repairable) " -BackgroundColor DarkRed -ForegroundColor White
					Logs_Write -Main "[Onekey] index: $(Image_Get_Mount_Index), Mount: $($NewPath)" -Level Error -Tag "Check Halter"
					return $False
				}
				"NonRepairable" {
					Write-Host " $($lang.NonRepairable) " -BackgroundColor DarkRed -ForegroundColor White
					Logs_Write -Main "[Onekey] index: $(Image_Get_Mount_Index), Mount: $($NewPath)" -Level Error -Tag "Check Halter"
					return $False
				}
				default {
					Write-Host " $($lang.SelectFromError) " -BackgroundColor DarkRed -ForegroundColor White
					Logs_Write -Main "[Onekey] index: $(Image_Get_Mount_Index), Mount: $($NewPath)" -Level Error -Tag "Check Halter"
					return $False
				}
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			return $False
		}
	} else {
		Write-Host "  $($lang.NotMounted)`n" -ForegroundColor Red
	}

	return $False
}

Function Eject_Forcibly_All
{
	param
	(
		[switch]$Save,
		[switch]$DontSave,
		[switch]$Quick
	)

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Abandon_Allow) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($Quick) {
		Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "`n  $($lang.Eject)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Expand.Count -gt 0) {
				Write-Host "`n    $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
				Write-Host "    $($lang.Side_quests)" -ForegroundColor Yellow
				Write-Host "    $('-' * 78)"

				ForEach ($Expand in $item.Expand) {
					$Eject_Expand_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($Expand.ImageFileName).$($Expand.Suffix)\Mount"
					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Write-Host "    $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green

					Write-Host "    $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $Eject_Expand_Do_Not_Save_Path -ForegroundColor Green
					Write-Host "    $('-' * 78)"

					Image_Get_Mount_Status_New -Uid $Expand.Uid -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $Expand.ImageFileName -Suffix $Expand.Suffix -ImageFile $test_mount_folder_Current -Silent $True

					if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Expand.Uid)").Value) {
						Write-Host "    $($lang.Mounted)"

						Write-Host "`n    $($lang.YesWork)" -ForegroundColor Yellow
						Write-Host "    $('-' * 78)"

						Write-Host "    $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Uid -ForegroundColor Green

						Write-Host "    $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $Eject_Expand_Do_Not_Save_Path -ForegroundColor Green

						Write-Host "`n    $($lang.Save)" -ForegroundColor Yellow
						Write-Host "    $('-' * 78)"
						if ($Save) {
							if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
								Write-Host "  $($lang.Command)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  Save-WindowsImage -Path ""$($Eject_Expand_Do_Not_Save_Path)""" -ForegroundColor Green
								Write-Host "  $('-' * 80)`n"
							}

							Write-Host "  " -NoNewline
							Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
							Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $Eject_Expand_Do_Not_Save_Path | Out-Null
							Write-Host "    $($lang.Done)" -ForegroundColor Green
						} else {
							Write-Host "    $($lang.NoWork)" -ForegroundColor Red
						}

						Write-Host "`n    $($lang.DoNotSave)" -ForegroundColor Yellow
						Write-Host "    $('-' * 78)"
						if ($DontSave) {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $($lang.Developers_Mode_Location): 90`n" -ForegroundColor Green
							}

							if ($Quick) {
								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Expand.Uid)" -Value $True -Force
							} else {
								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Expand.Uid)" -Value $False -Force
							}

							Image_Eject_Abandon -Uid $Expand.Uid -VerifyPath $Eject_Expand_Do_Not_Save_Path
						}
					} else {
						Write-Host "    $($lang.NotMounted)" -ForegroundColor Red
					}
				}
			}

			$Eject_Main_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"

			Write-Host "`n  $($lang.Event_Assign_Main)" -ForegroundColor Yellow
			Write-Host "  $($lang.Main_quests)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $Eject_Main_Do_Not_Save_Path -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Image_Get_Mount_Status_New -Uid $item.Main.Uid -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $item.Main.ImageFileName -Suffix $item.Main.Suffix -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -Silent $True
			if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($item.Main.Uid)").Value) {
				Write-Host "  $($lang.Mounted)"

				Write-Host "`n  $($lang.Save)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($Save) {
					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Save-WindowsImage -Path ""$($Eject_Main_Do_Not_Save_Path)""" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
					}

					Write-Host
					Write-Host "  " -NoNewline
					Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $Eject_Main_Do_Not_Save_Path | Out-Null
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($DontSave) {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $($lang.Developers_Mode_Location): 99`n" -ForegroundColor Green
					}

					if ($Quick) {
						New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $True -Force
					} else {
						New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($item.Main.Uid)" -Value $False -Force
					}

					Image_Eject_Abandon -Uid $item.Main.Uid -VerifyPath $Eject_Main_Do_Not_Save_Path
				}
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
			}
		}
	}
}