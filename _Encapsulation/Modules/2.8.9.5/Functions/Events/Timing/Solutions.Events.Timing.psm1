<#
	.等待时间设置界面
	.Waiting time setting interface
#>
Function Event_Completion_Start_Setting_UI
{
	param
	(
		[array]$Autopilot
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_Event_Completion_Save
	{
		if ($UI_Main_Time_Execute.Checked) {
			$Global:QueueWaitTime = @{
				IsEnabled = $False
				Sky = 0
				Time = 0
				Minute = 30
			}
		} else {
			$Global:QueueWaitTime = @{
				IsEnabled = $True
				Sky    = $UI_Time_Sky.Text
				Time   = $UI_Time_Time.Text
				Minute = $UI_Time_Minute.Text
			}
		}

		$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Additional_Edition_Reset
		Event_Reset_Variable
		$UI_Main.Close()
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 668
		Text           = $lang.WaitTimeTitle
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $true
		ControlBox     = $true
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	<#
		.立即执行
	#>
	$UI_Main_Time_Execute = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.TimeExecute
		Location       = '15,15'
		add_Click      = {
			if ($this.Checked) {
				$UI_Main_Menu.Enabled = $False
			} else {
				$UI_Main_Menu.Enabled = $True
			}
		}
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 620
		Width          = 280
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "17,0,8,0"
		Location       = '10,50'
	}

	<#
		.天
	#>
	$UI_Time_Sky_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.Time_Sky
	}
	$UI_Time_Sky       = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Value          = $Global:QueueWaitTime.Sky
		Minimum        = 0
		Maximum        = 99
		Margin         = "5,0,0,30"
	}


	<#
		.小时
	#>
	$UI_Time_Time_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.Time_Hour
	}
	$UI_Time_Time    = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Value          = $Global:QueueWaitTime.Time
		Minimum        = 0
		Maximum        = 24
		Margin         = "5,0,0,30"
	}

	<#
		.分钟
	#>
	$UI_Time_Minute_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 235
		Text           = $lang.Time_Minute
	}
	$UI_Time_Minute    = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Value          = $Global:QueueWaitTime.Minute
		Minimum        = 0
		Maximum        = 60
		Margin         = "5,0,0,40"
	}

	<#
		.保存为默认
	#>
	$UI_Main_Save_Default = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 235
		Text           = $lang.Image_Popup_Default
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Time_Sky.Text = "0"
			$UI_Time_Time.Text = "0"
			$UI_Time_Minute.Text = "30"

			Autopilot_Event_Completion_Save

			$UI_Main_Error.Text = "$($lang.Image_Popup_Default), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.恢复为默认
	#>
	$UI_Main_Restore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 235
		Text           = $lang.Image_Restore_Default
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Time_Sky.Text = "0"
			$UI_Time_Time.Text = "0"
			$UI_Time_Minute.Text = "30"

			$UI_Main_Error.Text = "$($lang.Image_Restore_Default), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
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
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '360,450'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "5" -Uid $Global:Primary_Key_Image.Uid -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Additional_Edition_Reset_Uid -Uid $Global:Primary_Key_Image.Uid
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '360,480'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
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
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True"
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False"
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '376,453'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '376,480'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 320
		Width          = 265
		BorderStyle    = 0
		Location       = "360,20"
		Text           = $lang.WaitTimeTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "360,593"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 255
		Location       = "385,595"
		Text           = ""
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "360,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = { Autopilot_Event_Completion_Save }
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Time_Execute,
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Save
	))
	
	$UI_Main_Menu.controls.AddRange((
		$UI_Time_Sky_Name,
		$UI_Time_Sky,
		$UI_Time_Time_Name,
		$UI_Time_Time,
		$UI_Time_Minute_Name,
		$UI_Time_Minute,
		$UI_Main_Save_Default,
		$UI_Main_Restore
	))

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Time" -Name "Minute" -ErrorAction SilentlyContinue) {
		$UI_Time_Minute.Text = Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Time" -Name "Minute" -ErrorAction SilentlyContinue
	}

	if ($Global:QueueWaitTime.IsEnabled) {
		$UI_Main_Time_Execute.Checked = $False
	} else {
		$UI_Main_Time_Execute.Checked = $True
	}

	if ($UI_Main_Time_Execute.Checked) {
		$UI_Main_Menu.Enabled = $False
	} else {
		$UI_Main_Menu.Enabled = $True
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.WaitTimeTitle)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.WaitTimeTitle)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		}

		<#
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
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

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
				$UI_Main.controls.AddRange((
					$UI_Main_Suggestion_Not,
					$UI_Main_Suggestion_Setting,
					$UI_Main_Suggestion_Stop
				))
			}
		}
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green

		switch ($Autopilot.Schome) {
			"Instantly" {
				$UI_Main_Time_Execute.Checked = $True
				$UI_Main_Menu.Enabled = $False
			}
			"Custom" {
				$UI_Main_Time_Execute.Checked = $False
				$UI_Main_Menu.Enabled = $True

				<#
					.天
				#>
				$UI_Time_Sky.Text = $Autopilot.Custom.Sky

				<#
					.小时
				#>
				$UI_Time_Time.Text = $Autopilot.Custom.Hour

				<#
					.分钟
				#>
				$UI_Time_Minute.Text = $Autopilot.Custom.Minute
			}
		}

		Autopilot_Event_Completion_Save
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.执行等待时间
	.Execution wait time
#>
Function Event_Completion_Start_Process
{
	$Init_Time_Sky    = $([math]::Ceiling($Global:QueueWaitTime.Sky) * 86400)
	$Init_Time_Time   = $([math]::Ceiling($Global:QueueWaitTime.Time) * 60 * 60)
	$Init_Time_Minute = $([math]::Ceiling($Global:QueueWaitTime.Minute) * 60)

	$sum_all = $Init_Time_Sky + $Init_Time_Time + $Init_Time_Minute

	$NowTime       = Get-Date -format "yyyy/MM/dd HH:mm:ss tt"
	$GUITimeOKTime = (Get-Date).AddSeconds($sum_all)

	Write-Host "  $($lang.TimeWait)" -NoNewline
	Write-Host "$($sum_all) $($lang.TimeSeconds)" -ForegroundColor Yellow

	Write-Host "  $($lang.NowTime)" -NoNewline
	Write-Host $NowTime -ForegroundColor Yellow

	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host "$($GUITimeOKTime.ToString('yyyy/MM/dd HH:mm:ss'))" -ForegroundColor Yellow

	Write-Host "`n  $($lang.TimeMsg)"

	if ($sum_all -gt 99999) {
		Start-Sleep -s $sum_all
	} else {
		start-process "timeout.exe" -argumentlist "/t $($sum_all) /nobreak" -wait -nonewwindow
	}
}