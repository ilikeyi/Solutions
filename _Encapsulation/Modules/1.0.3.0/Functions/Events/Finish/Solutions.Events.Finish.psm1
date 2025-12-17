<#
	.When an event is available
	.如果有可用事件时
#>
Function Event_Completion_Setting_UI
{
	param
	(
		[array]$Autopilot
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_Event_Completion_Setting_UI_Save
	{
		if ($Global:AutopilotMode) {
			$EventMaps = "Queue"
		}

		if ($Global:EventQueueMode) {
			$EventMaps = "Queue"
		}

		if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
			$EventMaps = "Assign"
		}

		<#
			.Reset selected
			.重置已选择
		#>
		$UI_Main_After_Finishing.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value $_.Tag -String
					}
				}
			}
		}

		$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		return $true
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 668
		Text           = $lang.AfterFinishingNotExecuted
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	<#
		.完成后显示区域
	#>
	
	$UI_Main_Not_Executed = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 280
		Location       = '15,15'
		Text           = $lang.Ok_Go_To
	}
	$UI_Main_After_Finishing = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 540
		Width          = 280
		autoSizeMode   = 1
		Padding        = "15,0,0,0"
		Location       = '15,45'
	}

	$UI_Main_After_Finishing_NoProcess = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.AfterFinishingNoProcess
		Tag            = "NoProcess"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_After_Finishing_Pause = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.AfterFinishingPause
		Tag            = "Pause"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_After_Finishing_Reboot = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.AfterFinishingReboot
		Tag            = "Reboot"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_After_Finishing_Shutdown = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.AfterFinishingShutdown
		Tag            = "Shutdown"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Temp      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 65
		Width          = 280
		Location       = '15,600'
		Text           = $lang.AfterFinishCleanupTemp
		Checked        = $True
		add_Click      = {
			if ($UI_Main_Temp.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False" -String
			}
		}
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '360,420'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '360,450'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "2" -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '360,480'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.SuggestedSkip
		Location       = '360,415'
		add_Click      = {
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True" -String
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False" -String
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '376,451'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '376,480'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 320
		Width          = 270
		BorderStyle    = 0
		Location       = "360,20"
		Text           = $lang.WaitTimeTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "360,560"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "385,562"
		Height         = 30
		Width          = 255
		Text           = ""
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "360,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Event_Completion_Setting_UI_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "360,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Tips,
		$UI_Main_Not_Executed,
		$UI_Main_After_Finishing,
		$UI_Main_Temp,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Save,
		$UI_Main_Canel
	))

	$UI_Main_After_Finishing.controls.AddRange((
		$UI_Main_After_Finishing_NoProcess,
		$UI_Main_After_Finishing_Pause,
		$UI_Main_After_Finishing_Reboot,
		$UI_Main_After_Finishing_Shutdown
	))

	if ($Global:AutopilotMode) {
		$EventMaps = "Queue"
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot) ]"
	}

	if ($Global:EventQueueMode) {
		$EventMaps = "Queue"

		Write-Host "`n  $($lang.AfterFinishingNotExecuted)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$EventMaps = "Assign"

		Write-Host "`n  $($lang.AfterFinishingNotExecuted)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		}

		<#
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Suggestion_Not.Checked = $True
					$UI_Main_Suggestion_Setting.Enabled = $False
					$UI_Main_Suggestion_Stop.Enabled = $False
				}
				"False" {
					$UI_Main_Suggestion_Not.Checked = $False
					$UI_Main_Suggestion_Setting.Enabled = $True
					$UI_Main_Suggestion_Stop.Enabled = $True
				}
			}
		} else {
			$UI_Main_Suggestion_Not.Checked = $False
			$UI_Main_Suggestion_Setting.Enabled = $True
			$UI_Main_Suggestion_Stop.Enabled = $True
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
				$UI_Main.controls.AddRange((
					$UI_Main_Suggestion_Not,
					$UI_Main_Suggestion_Setting,
					$UI_Main_Suggestion_Stop
				))
			}
		}
	}

	<#
		.初始化选择：暂停、重启、关机
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
			"NoProcess" { $UI_Main_After_Finishing_NoProcess.Checked = $True }
			"Pause" { $UI_Main_After_Finishing_Pause.Checked = $True }
			"Reboot" { $UI_Main_After_Finishing_Reboot.Checked = $True }
			"Shutdown" { $UI_Main_After_Finishing_Shutdown.Checked = $True }
		}
	} else {
		$UI_Main_After_Finishing_Pause.Checked = $True
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "IsCleanupTemp" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "IsCleanupTemp" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Temp.Checked = $True
			}
			"False" {
				$UI_Main_Temp.Checked = $False
			}
		}
	} else {
		$UI_Main_Temp.Checked = $False
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

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		switch ($Autopilot.Finish) {
			"NoProcess" { $UI_Main_After_Finishing_NoProcess.Checked = $True }
			"Pause" { $UI_Main_After_Finishing_Pause.Checked = $True }
			"Reboot" { $UI_Main_After_Finishing_Reboot.Checked = $True }
			"Shutdown" { $UI_Main_After_Finishing_Shutdown.Checked = $True }
			default {
				$UI_Main_After_Finishing_Pause.Checked = $True
			}
		}

		if ($Autopilot.IsCleanupTemp) {
			$UI_Main_Temp.Checked = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "True" -String
		} else {
			$UI_Main_Temp.Checked = $False
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False" -String
		}

		if (Autopilot_Event_Completion_Setting_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.After event processing is complete
	.事件处理完成后
#>
Function Event_Completion_Process
{
	if ($Global:AutopilotMode) {
		$EventMaps = "Queue"
	}

	if ($Global:EventQueueMode) {
		$EventMaps = "Queue"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$EventMaps = "Assign"
	}

	Write-Host "`n  $($lang.AfterFinishCleanupTemp)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "IsCleanupTemp" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "IsCleanupTemp" -ErrorAction SilentlyContinue) {
			"True" {
				Write-Host "  $($lang.AfterFinishingNotExecuted)" -ForegroundColor Green

				$TempPaths = @(
					$env:Temp
					"$($env:SystemRoot)\Logs\DISM"
				)

				foreach ($TempPath in $TempPaths) {
					Write-Host "  $($TempPath)" -ForegroundColor Green
				
					if (Test-Path -Path $TempPath -PathType Container) {
						Get-ChildItem -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
							try {
								Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
							} catch {
								Write-Host $_ -ForegroundColor Red
							}
						}

						Remove-Item -Path $TempPath -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
					}
				}

				Write-Host "`n  $('-' * 80)"
				Write-Host "  $($lang.Done)" -ForegroundColor Green
			}
			"False" {
				Write-Host "  $($lang.AfterFinishingNoProcess)" -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.AfterFinishingNoProcess)" -ForegroundColor Green
	}
	Write-Host

	Write-Host "`n  $($lang.AfterFinishingNotExecuted)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
			"NoProcess" {
				Write-Host "  $($lang.AfterFinishingNoProcess)" -ForegroundColor Green
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}
			"Pause" {
				Write-Host "  $($lang.AfterFinishingPause)" -ForegroundColor Green
				Get_Next
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}
			"Reboot" {
				Write-Host "  $($lang.AfterFinishingReboot)" -ForegroundColor Green
				start-process "timeout.exe" -argumentlist "/t 10 /nobreak" -wait -nonewwindow
				Restart-Computer -Force -ErrorAction SilentlyContinue
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}
			"Shutdown" {
				Write-Host "  $($lang.AfterFinishingShutdown)" -ForegroundColor Green
				start-process "timeout.exe" -argumentlist "/t 10 /nobreak" -wait -nonewwindow
				Stop-Computer -Force -ErrorAction SilentlyContinue
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}
			default {
				Write-Host "  $($lang.AfterFinishingPause)" -ForegroundColor Green
				Get_Next
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}
		}
	} else {
		Write-Host "  $($lang.AfterFinishingPause)" -ForegroundColor Green
		Get_Next
		Write-Host "  $($lang.Done)`n" -ForegroundColor Green
	}
}