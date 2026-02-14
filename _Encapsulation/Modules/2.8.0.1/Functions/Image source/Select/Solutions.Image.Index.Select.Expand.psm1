<#
	.选择索引号，预选、自定义、自动
#>
Function Image_Select_Index_Custom_UI
{
	param
	(
		$ImageFileName
	)

	Write-Host "`n  $($lang.SelectSettingImage) $($lang.MountedIndexSelect)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Image_Select_Index_Refresh_Button_Status
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.处理全部已知索引号
		#>
		if ($UI_Process_All.Checked) {
			$UI_Main_Menu.Enabled = $False
		}

		<#
			.有事件时，弹出选择索引号界面
		#>
		if ($UI_Is_Event_Popup_Select_Index.Checked) {
			$UI_Main_Menu.Enabled = $False
		}

		<#
			.预指定索引号
		#>
		if ($UI_Pre_Custom_Index.Checked) {
			$UI_Main_Menu.Enabled = $True
		}
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
		Width          = 876
		Text           = "$($lang.SelectSettingImage): $($lang.MountedIndexSelect)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	$UI_Process_All = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 475
		Location       = "18,15"
		Text           = $lang.Index_Process_All
		add_Click      = { Image_Select_Index_Refresh_Button_Status }
		Checked        = $True
	}
	$UI_Is_Event_Popup_Select_Index = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 475
		Location       = "18,50"
		Text           = $lang.Index_Is_Event_Select
		add_Click      = { Image_Select_Index_Refresh_Button_Status }
	}
	$UI_Pre_Custom_Index  = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 475
		Location       = "18,85"
		Text           = $lang.Index_Pre_Select
		add_Click      = { Image_Select_Index_Refresh_Button_Status }
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 500
		Location       = "10,125"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "26,0,0,0"
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips   = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 330
		Width          = 265
		BorderStyle    = 0
		Location       = "575,10"
		Text           = $lang.Index_Select_Tips -f $Global:Primary_Key_Image.Master
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '570,395'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "23" -Uid $Global:Primary_Key_Image.Uid -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Additional_Edition_Reset_Uid -Uid $Global:Primary_Key_Image.Uid
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '570,425'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "570,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "595,600"
		Height         = 30
		Width          = 255
		Text           = ""
	}

	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "570,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Save
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			<#
				.处理方式：
				 1、处理全部已知索引号
				 2、有事件时，弹出选择索引号界面
				 3、预指定索引号
			#>
			<#
				.处理全部已知索引号
			#>
			if ($UI_Process_All.Checked) {
				New-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Global:Primary_Key_Image.Uid)" -Value "Auto" -Force
			}

			<#
				.有事件时，弹出选择索引号界面
			#>
			if ($UI_Is_Event_Popup_Select_Index.Checked) {
				New-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Global:Primary_Key_Image.Uid)" -Value "Popup" -Force
			}

			<#
				.预指定索引号
			#>
			if ($UI_Pre_Custom_Index.Checked) {
				<#
					.Reset selected
					.重置已选择
				#>
				$TempQueueProcessImageSelectPending = @()

				$UI_Main_Menu.Controls | ForEach-Object {
					if ($_.Enabled) {
						if ($_.Checked) {
							$TempQueueProcessImageSelectPending += [pscustomobject]@{
								Name   = $_.Tag
								Index  = $_.Tag
							}
						}
					}
				}

				if ($TempQueueProcessImageSelectPending.Count -gt 0) {
					New-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Global:Primary_Key_Image.Uid)" -Value "Pre" -Force
					New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Global:Primary_Key_Image.Uid)" -Value $TempQueueProcessImageSelectPending -Force
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
					return
				}
			}

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Process_All,
		$UI_Is_Event_Popup_Select_Index,
		$UI_Pre_Custom_Index,
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Save
	))

	for($i=1; $i -le 12; $i++) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 38
			Width     = 450
			Text      = "$($lang.MountedIndex): $($i)"
			Tag       = $i
			Checked   = $True
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		$UI_Main_Menu.controls.AddRange($CheckBox)
	}

	$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($Temp_Queue_Process_Image_Select_Pending.Index -contains $_.Tag) {
					$_.Checked = $true
				} else {
					$_.Checked = $False
				}
			}
		}
	}

	$Get_Current_Process_Type_Temp = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	switch ($Get_Current_Process_Type_Temp) {
		"Auto" {
			$UI_Process_All.Checked = $True
		}
		"Popup" {
			$UI_Is_Event_Popup_Select_Index.Checked = $True
		}
		"Pre" {
			$UI_Pre_Custom_Index.Checked = $True
			$UI_Main_Menu.Enabled = $True
		}
	}

	Image_Select_Index_Refresh_Button_Status

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
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

	$UI_Main.ShowDialog() | Out-Null
}