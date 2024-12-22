Function Functions_Before_UI
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

	Function Autopilot_Functions_Before_UI_Save
	{
		<#
			.Mark: Check the selection status
			.标记：检查选择状态
		#>
		$TempSelectFunctionQueue = @()
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$TempSelectFunctionQueue += $_.Text
					}
				}
			}
		}

		if ($TempSelectFunctionQueue.Count -gt 0) {
			New-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $TempSelectFunctionQueue -Force

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			return $True
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			return $False
		}
	}

	Function Refres_Event_Tasks_Functions_Before
	{
		$UI_Main_Select_Function.controls.clear()

		$Temp_Assign_Task_Select = (Get-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

		if ($Temp_Assign_Task_Select.Count -gt 0) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"

			ForEach ($item in $Temp_Assign_Task_Select) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 445
					Text      = $item
					Checked   = $True
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}
	
				$UI_Main_Select_Function.controls.AddRange($CheckBox)
			}
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		Refres_Event_Tasks_Functions_Before

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = "$($lang.SpecialFunction): $($lang.Functions_Before)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	<#
		.待分配
	#>
	$UI_Main_Wait_Assign = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = "15,15"
		Text           = $lang.Functions_Wait_Assign
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 465
		Width          = 500
		Location       = '0,55'
		Padding        = "31,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
	}

	<#
		.可选功能
	#>
	$UI_Main_Adv       = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = '15,555'
		Text           = $lang.AdvOption
	}

	<#
		.有重复时不再添加
	#>
	$UI_Main_Functions_Duplicate = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 485
		Location       = '35,585'
		Text           = $lang.Functions_Duplicate
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Functions_Duplicate.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -name "$(Get_GPS_Location)_Is_Check_Duplicate" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -name "$(Get_GPS_Location)_Is_Check_Duplicate" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -Name "$(Get_GPS_Location)_Is_Check_Duplicate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -Name "$(Get_GPS_Location)_Is_Check_Duplicate" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Functions_Duplicate.Checked = $True
			}
			"False" {
				$UI_Main_Functions_Duplicate.Checked = $False
			}
		}
	} else {
		$UI_Main_Functions_Duplicate.Checked = $True
	}

	<#
		.添加后自动勾选新增项
	#>
	$UI_Main_Functions_AutoSelect = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 485
		Location       = '35,620'
		Text           = $lang.Functions_AutoSelect
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Functions_AutoSelect.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -name "$(Get_GPS_Location)_Is_Check_Auto_Select" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -name "$(Get_GPS_Location)_Is_Check_Auto_Select" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -Name "$(Get_GPS_Location)_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Functions" -Name "$(Get_GPS_Location)_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Functions_AutoSelect.Checked = $True
			}
			"False" {
				$UI_Main_Functions_AutoSelect.Checked = $False
			}
		}
	} else {
		$UI_Main_Functions_AutoSelect.Checked = $True
	}

	<#
		.选择函数
	#>
	$UI_Main_Select_Function_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.Functions_Running_Order
		Location       = '560,15'
	}
	$UI_Main_Select_Function = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 250
		Width          = 485
		Location       = '560,50'
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
	}
	$UI_Main_Select_Function_Tips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,310"
		Height         = 50
		Width          = 480
		Text           = $lang.FunctionTips
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Location       = "560,380"
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "16,0,0,0"
		Location       = "560,415"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Location       = "560,450"
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
		Width          = 485
		Text           = $lang.AssignSetting
		Location       = '560,495'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '560,525'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "12" -Master $Global:Primary_Key_Image.Master -ImageFileName $Global:Primary_Key_Image.ImageFileName
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Text           = $lang.AssignForceEnd
		Location       = '560,555'
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
		Width          = 485
		Text           = $lang.SuggestedSkip
		Location       = '560,490'
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
		Width          = 485
		Text           = $lang.AssignSetting
		Location       = '576,526'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Text           = $lang.AssignForceEnd
		Location       = '576,555'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "585,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}
	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Functions_Before_UI_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()

			if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
				Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

				Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				$Temp_Functions_Before_Task = (Get-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Functions_Before_Task.Count -gt 0) {
					ForEach ($item in $Temp_Functions_Before_Task) {
						Write-Host "  $($item)"
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
		$UI_Main_Select_Function_Name,
		$UI_Main_Select_Function,
		$UI_Main_Select_Function_Tips,
		$UI_Main_Wait_Assign,
		$UI_Main_Menu,
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Adv,
		$UI_Main_Functions_Duplicate,
		$UI_Main_Functions_AutoSelect,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))

	$PowerShell_Function_Tasks = @()
	Get-Command -CommandType Function | ForEach-Object {
		if ($_ -like "Other_Tasks_*") {
			$PowerShell_Function_Tasks += $_.Name
		}
	}

	if ($PowerShell_Function_Tasks.Count -gt 0) {
		foreach ($item in $PowerShell_Function_Tasks) {
			$LinkLabel          = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 445
				Text           = $item
				LinkColor      = "GREEN"
				ActiveLinkColor = "RED"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
					
					if ($UI_Main_Functions_Duplicate.Checked) {
						$Temp_Get_Select_Function = @()
						$UI_Main_Select_Function.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								$Temp_Get_Select_Function += $_.Text
							}
						}

						if ($Temp_Get_Select_Function -contains $this.Text) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.Existed): $($This.Text)"
						} else {
							$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
								Height    = 40
								Width     = 445
								Text      = $this.Text
								add_Click = {
									$UI_Main_Error.Text = ""
									$UI_Main_Error_Icon.Image = $null
								}
							}

							if ($UI_Main_Functions_AutoSelect.Checked) {
								$CheckBox.Checked = $True
							}

							$UI_Main_Select_Function.controls.AddRange($CheckBox)

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
						}
					} else {
						$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
							Height    = 40
							Width     = 445
							Text      = $this.Text
							add_Click = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
							}
						}

						if ($UI_Main_Functions_AutoSelect.Checked) {
							$CheckBox.Checked = $True
						}

						$UI_Main_Select_Function.controls.AddRange($CheckBox)

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
					}
				}
			}

			$LinkLabel_Tips = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "16,0,20,0"
				Text           = $($lang.$($item))
			}

			$LinkLabel_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 445
			}

			$UI_Main_Menu.controls.AddRange((
				$LinkLabel,
				$LinkLabel_Tips,
				$LinkLabel_Wrap
			))
		}
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

			$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"
			if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
				$UI_Main_Menu.Enabled = $True
			} else {
				$UI_Main_Menu.Enabled = $False
			}
		} else {
			$UI_Main_Menu.Enabled = $False
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
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_Function.ContextMenuStrip = $UI_Main_Menu_Select

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

		New-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

		foreach ($item in $Autopilot) {
			if ($PowerShell_Function_Tasks -contains $item) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 445
					Text      = $item
					Checked   = $True
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}
		
				$UI_Main_Select_Function.controls.AddRange($CheckBox)
			}
		}

		if (Autopilot_Functions_Before_UI_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		Refres_Event_Tasks_Functions_Before
	
		$UI_Main.ShowDialog() | Out-Null
	}
}