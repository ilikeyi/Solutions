<#
	.Components: Cleanup
	.组件：清理
#>
Function Language_Cleanup_Components_UI
{
	param
	(
		[array]$Autopilot
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	Function Autopilot_Language_Cleanup_Components_UI_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$Temp_Queue_Is_Language_Components_Clean_Select = @()
		$GUILangCleanupComponentsSelectPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Queue_Is_Language_Components_Clean_Select += $_.Tag
					}
				}
			}
		}

		if ($Temp_Queue_Is_Language_Components_Clean_Select.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Temp_Queue_Is_Language_Components_Clean_Select -Force

			Refres_Event_Tasks_Language_Components

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			return $true
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) $($lang.OnlyLangCleanup)"
			return $false
		}
	}

	Function Refres_Event_Tasks_Language_Components
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		Refres_Event_Tasks_Language_Components

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	Function Language_Del_Refresh_Cleanup_Components
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$GUILangCleanupComponentsSelectPanel.controls.Clear()

		$Temp_Queue_Language_Components_Clean_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

		$GetSelectCleanupComponentsLanguage = @()
		ForEach ($item in $Temp_Queue_Language_Components_Clean_Select) {
			$GetSelectCleanupComponentsLanguage += $item
		}

		$Region = Language_Region
		ForEach ($itemRegion in $Region) {
			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = 55
				Width     = 260
				Text      = "$($itemRegion.Region)`n$($itemRegion.Name)"
				Tag       = $itemRegion.Region
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			if ($Temp_Queue_Language_Components_Clean_Select -Contains $itemRegion.Region) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$GUILangCleanupComponentsSelectPanel.controls.AddRange($CheckBox)
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.OnlyLangCleanup
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 400
		Width          = 555
		autoSizeMode   = 1
		Location       = '375,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	$GUILangCleanupComponentsSelectPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 300
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
		Location       = "8,10"
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '375,455'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '375,485'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "20" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '375,515'
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
		Width          = 430
		Text           = $lang.SuggestedSkip
		Location       = '375,450'
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
		Location       = '391,486'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '391,515'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "375,595"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "400,598"
		Height         = 30
		Width          = 496
		Text           = ""
	}

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "375,635"
		Height         = 36
		Width          = 170
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "552,635"
		Height         = 36
		Width          = 170
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Language_Cleanup_Components_UI_Save) {
	
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "728,635"
		Height         = 36
		Width          = 170
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()

			if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
				Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

				Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Assign_Task_Select.count -gt 0) {
					ForEach ($item in $Temp_Assign_Task_Select) {
						Write-Host "  $($item)" -ForegroundColor Green
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$GUILangCleanupComponentsSelectPanel,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear
	))

	Language_Del_Refresh_Cleanup_Components
	Refres_Event_Tasks_Language_Components

	<#
		.Delete language selection: add right-click menu: select all, clear button
		.删除语言选择：添加右键菜单：全选、清除按钮
	#>
	$GUILangCleanupComponentsMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUILangCleanupComponentsMenu.Items.Add($lang.AllSel).add_Click({
		$GUILangCleanupComponentsSelectPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUILangCleanupComponentsMenu.Items.Add($lang.AllClear).add_Click({
		$GUILangCleanupComponentsSelectPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUILangCleanupComponentsSelectPanel.ContextMenuStrip = $GUILangCleanupComponentsMenu

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

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
		Write-Host "  $($lang.Save): " -NoNewline -ForegroundColor Yellow

		New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		$GUILangCleanupComponentsSelectPanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($Autopilot -contains $_.Tag) {
					$_.Checked = $true
				} else {
					$_.Checked = $false
				}
			}
		}

		if (Autopilot_Language_Cleanup_Components_UI_Save) {
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
	.Cleanup component processing
	.清理组件处理
#>
Function Cleanup_Components_Process
{
	<#
    	.初始化，获取语言
	#>
	$InitlClearLanguagePackage = @()

	$Temp_Queue_Language_Components_Clean_Select = (Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	ForEach ($item in $Temp_Queue_Language_Components_Clean_Select) {
		Write-Host "  $($item)" -ForegroundColor Green
	}

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

	ForEach ($item in $Temp_Queue_Language_Components_Clean_Select) {
		try {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsPackage -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Get-WindowsPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current -ErrorAction SilentlyContinue | ForEach-Object {
				if ($_.PackageName -like "*$($item)*") {
					$InitlClearLanguagePackage += $_.PackageName
				}
			}
		} catch {
			Write-Host "  $($_)" -ForegroundColor Yellow
			Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}
	}

	Write-Host "`n  $($lang.OnlyLangCleanup)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($InitlClearLanguagePackage.count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	
		ForEach ($item in $InitlClearLanguagePackage | Sort-Object -Descending) {
			Write-Host "  $($item)" -ForegroundColor Green

			Write-Host "  $($lang.Del): " -NoNewline
			if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
				try {
					Remove-AppxProvisionedPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Remove-AppxProvisionedPackage.log" -Path $test_mount_folder_Current -PackageName $item -ErrorAction SilentlyContinue | Out-Null
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} catch {
					Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					Write-Host "  $($_)" -ForegroundColor Red
				}
			} else {
				Write-Host $lang.NotMounted -ForegroundColor Red
			}

			Write-Host
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}