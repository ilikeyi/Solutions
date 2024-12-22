<#
	.Local language experience pack ( LXPs ): Add
	.本地语言体验包 ( LXPs ): 添加
#>
Function LXPs_Update_UI
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

	Function Refres_Event_Tasks_LXPs_Update_UI
	{
		$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		Refres_Event_Tasks_LXPs_Update_UI

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	Function Autopilot_LXPs_Update_UI_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$TempSelectLXPsLanguage = @()

		<#
			.等待添加本地语言体验包（LXPs）
		#>
		$UI_Main_Is_Wait_Add.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$TempSelectLXPsLanguage += $_.Tag
					}
				}
			}
		}

		<#
			.Verification mark: check selection status
			.验证标记：检查选择状态
		#>
		if ($TempSelectLXPsLanguage.count -gt 0) {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempSelectLXPsLanguage -Force

			Refres_Event_Tasks_LXPs_Update_UI

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"

			return $true
		} else {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.LXPsWaitAddUpdate) )"

			return $False
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
        Height         = 720
        Width          = 928
		Text           = "$($lang.LocalExperiencePack): $($lang.Update)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	<#
		.显示提示蒙层
	#>
	$UI_Main_Mask_Tips = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 928
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Tips_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 555
		Width          = 885
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $lang.Remove_Appx_Tips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Mask_Tips_Global_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,607"
		Height         = 30
		Width          = 550
		Text           = $lang.LXPsAddDelTipsGlobal
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Mask_Tips_Global_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningUWPGlobal" -value "True" -String
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions" -name "TipsWarningUWPGlobal" -value "False" -String
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	$UI_Main_Mask_Tips_Do_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 30
		Width          = 550
		Text           = $lang.LXPsAddDelTips
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Mask_Tips_Do_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "TipsWarningUWP" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "TipsWarningUWP" -value "False" -String
			}
		}
	}
	$UI_Main_Mask_Tips_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Mask_Tips.Visible = $False
		}
	}

	<#
		.待添加
	#>
	$UI_Main_Wait_Add  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		margin         = "0,35,0,0"
		Text           = $lang.LXPsWaitAddUpdate
	}
	$UI_Main_Is_Wait_Add = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Padding        = "16,0,0,0"
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	$UI_Main_Tips_New  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 470
		Text           = $lang.LXPsAddDelTipsView
		Location       = "620,60"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_Mask_Tips.Visible = $True
		}
	}

	$UI_Main_Select_Folder = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.SelectFolder
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			<#
				.Initial browse directory
				.初始浏览目录
			#>
			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			<#
				.Browse catalog: confirm
				.浏览目录：确认
			#>
			if ($FolderBrowser.ShowDialog() -eq "OK") {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $FolderBrowser.SelectedPath -Force
				Refresh_Add_InBox_Apps_New_Sources
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}

	Function Refresh_Add_InBox_Apps_New_Sources
	{
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if (([string]::IsNullOrEmpty($Temp_Assign_Task_Select))) {
			$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 505
				Text           = $lang.NoWork
			}
	
			$UI_Main_Is_Wait_Add.controls.AddRange($UI_Main_Other_Rule_Not_Find)
		} else {
			$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
			if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
				$GetSelectLXPsLanguage = $Temp_Queue_Is_InBox_Apps_Update
			} else {
				if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_SelectLXPsLanguage" -ErrorAction SilentlyContinue)) {
					$DeployinboxGetSourcesOnly = @()
	
					$Region = Language_Region
					ForEach ($itemRegion in $Region) {
						$TestFolderRegion = Join-Path -Path $Global:Image_source -ChildPath "Sources\$($itemRegion.Region)"

						if (Test-Path -Path $TestFolderRegion -PathType Container) {
							if((Get-ChildItem $TestFolderRegion -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
								$DeployinboxGetSourcesOnly += $itemRegion.Region
							}
						}
					}
	
					if ($DeployinboxGetSourcesOnly.count -gt 0) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_SelectLXPsLanguage" -value $DeployinboxGetSourcesOnly -Multi
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -name "$(Get_GPS_Location)_SelectLXPsLanguage" -value "" -Multi
					}
				}
				$GetSelectLXPsLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "$(Get_GPS_Location)_SelectLXPsLanguage"
			}

			<#
				.Clear display area
				.清除显示区域
			#>
			$UI_Main_Is_Wait_Add.controls.Clear()
	
			<#
				.Search whether the selected directory has: LanguageExperiencePack.*.appx
				.搜索已选择的目录是否有：LanguageExperiencePack.*.appx
			#>
			if (Test-Path -Path "$($Temp_Assign_Task_Select)\LocalExperiencePack" -PathType Container) {
				Get-ChildItem "$($Temp_Assign_Task_Select)\LocalExperiencePack" -directory -ErrorAction SilentlyContinue | ForEach-Object {
					if (Test-Path -Path "$($_.FullName)\LanguageExperiencePack.*.appx" -PathType Leaf) {
						$CheckBox     = New-Object System.Windows.Forms.CheckBox  -Property @{
							Height    = 30
							Width     = 505
							Text      = $_.BaseName
							Tag       = $_.FullName
						}
	
						if ($GetSelectLXPsLanguage -contains $_.BaseName) {
							$CheckBox.Checked = $True
						} else {
							$CheckBox.Checked = $False
						}
	
						$UI_Main_Is_Wait_Add.controls.AddRange($CheckBox)
					}
				}
			} else {
				if (Test-Path -Path $Temp_Assign_Task_Select -PathType Container) {
					Get-ChildItem $Temp_Assign_Task_Select -directory -ErrorAction SilentlyContinue | ForEach-Object {
						if (Test-Path -Path "$($_.FullName)\LanguageExperiencePack.*.appx" -PathType Leaf) {
							$CheckBox     = New-Object System.Windows.Forms.CheckBox  -Property @{
								Height    = 30
								Width     = 505
								Text      = $_.BaseName
								Tag       = $_.FullName
							}
						
							if ($GetSelectLXPsLanguage -contains $_.BaseName) {
								$CheckBox.Checked = $True
							} else {
								$CheckBox.Checked = $False
							}
						
							$UI_Main_Is_Wait_Add.controls.AddRange($CheckBox)
						}
					}
				}
			}
		}
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Location       = "620,230"
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Location       = "620,265"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Location       = "620,300"
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '620,395'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '620,425'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "822" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '620,455'
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
		Location       = '620,390'
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
		Location       = '636,426'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '636,455'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = '620,503'
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = '645,505'
		Height         = 45
		Width          = 255
		Text           = ""
	}

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,555"
		Height         = 36
		Width          = 280
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_LXPs_Update_UI_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()

			if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
				Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

				Write-Host "`n  $($lang.LXPsWaitAddUpdate)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
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
		$UI_Main_Mask_Tips,
		$UI_Main_Menu,

		$UI_Main_Select_Folder,
		$UI_Main_Tips_New,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,

		$UI_Main_Wait_Add,
		$UI_Main_Is_Wait_Add
	))

	$UI_Main_Mask_Tips.controls.AddRange((
		$UI_Main_Mask_Tips_Results,
		$UI_Main_Mask_Tips_Global_Do_Not,
		$UI_Main_Mask_Tips_Do_Not,
		$UI_Main_Mask_Tips_Canel
	))

	<#
		.提示
	#>
	$MarkShowNewTips = $False
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TipsWarningUWPGlobal" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TipsWarningUWPGlobal" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $True
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $True
				$UI_Main_Mask_Tips_Do_Not.Enabled = $False
			}
			"False" {
				$UI_Main_Mask_Tips_Global_Do_Not.Checked = $False
				$UI_Main_Mask_Tips_Do_Not.Enabled = $True
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "TipsWarningUWP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\InBox" -Name "TipsWarningUWP" -ErrorAction SilentlyContinue) {
			"True" {
				$MarkShowNewTips = $True
				$UI_Main_Mask_Tips_Do_Not.Checked = $True
			}
			"False" {
				$UI_Main_Mask_Tips_Do_Not.Checked = $False
			}
		}
	}
	if ($MarkShowNewTips) {
		$UI_Main_Mask_Tips.Visible = $True
	} else {
		$UI_Main_Mask_Tips.Visible = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUILXPsOnlySelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUILXPsOnlySelectMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Is_Wait_Add.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUILXPsOnlySelectMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Is_Wait_Add.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				$_.Checked = $false
			}
		}
	})
	$UI_Main_Is_Wait_Add.ContextMenuStrip = $GUILXPsOnlySelectMenu

	Refresh_Add_InBox_Apps_New_Sources
	Refres_Event_Tasks_LXPs_Update_UI

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.LocalExperiencePack): $($lang.Update)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.LocalExperiencePack): $($lang.Update)" -ForegroundColor Yellow
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

		if (Test-Path -Path $Autopilot.Sources -PathType Container) {
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_Select_Sources_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $Autopilot.Sources -Force
			Refresh_Add_InBox_Apps_New_Sources

			$UI_Main_Is_Wait_Add.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Autopilot.Region -contains $_.Text) {
						$_.Checked = $true
					} else {
						$_.Checked = $False
					}
				}
			}
		}

		if (Autopilot_LXPs_Update_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		$Temp_Assign_Task_Select = $Temp_Assign_Task_Select | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$UI_Main_Is_Wait_Add.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($Temp_Assign_Task_Select -contains $_.Tag) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.添加本地语言体验包
#>
Function InBox_Apps_LIPs_Add_Process
{
	$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Queue_Is_InBox_Apps_Update) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Temp_Queue_Is_InBox_Apps_Update) {
			InBox_Apps_Add_Mark_Process -Path $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}