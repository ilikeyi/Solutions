<#
	.Select other task user interface
	.选择其它任务用户界面
#>
Function Feature_More_UI_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.MoreFeature
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.MountImageTo): " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host $Global:Mount_To_Route -ForegroundColor Yellow
		}

		Write-Host "  $($lang.MainImageFolder): " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Red
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 2
			Functions_Assign
		}

		Image_Get_Mount_Status
	}


	<#
		.Assign available tasks
		.分配可用的任务
	#>
	Event_Assign -Rule "Feature_More_UI" -Run
}

Function Feature_More_UI
{
	param
	(
		[array]$Autopilot
	)

	$SearchFolderRule = @(
		Join-Path -Path $Global:Image_source -ChildPath "History\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
		Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Report"
		"$(Get_MainMasterFolder)\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
	)
	$SearchFolderRule = $SearchFolderRule | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Autopilot_Feature_More_UI_Save
	{
		$Temp_Queue_Update_Add_Select = @()
		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_Queue_Update_Add_Select += $_.Tag
						New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $_.Tag -Force
					}
				}
			}
		}

		if ($Temp_Queue_Update_Add_Select.Count -gt 0) {
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SaveTo)"
			return $false
		}

		<#
			.固化更新
		#>
		New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Curing_Update.Enabled) {
			if ($UI_Main_Curing_Update.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		<#
			.清理取代的
		#>
		New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Superseded_Rule.Enabled) {
			if ($UI_Main_Superseded_Rule.Checked) {
				New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}

			if ($UI_Main_Superseded_Rule_Exclude.Checked) {
				New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		<#
			.健康
		#>
		New-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Healthy.Enabled) {
			if ($UI_Main_Healthy.Checked) {
				New-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		<#
			.获取预安装应用 UWP
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_UWP_To_Log.Enabled) {
			if ($UI_Main_UWP_To_Log.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		if ($UI_Main_UWP_To_View.Enabled) {
			if ($UI_Main_UWP_To_View.Checked) {
				New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		<#
			.查看安装的所有软件包的列表
		#>
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Package_To_Log.Enabled) {
			if ($UI_Main_Package_To_Log.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		if ($UI_Main_Package_To_View.Enabled) {
			if ($UI_Main_Package_To_View.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}


		<#
			.查看已安装的驱动列表
		#>
		New-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Drive_To_Log.Enabled) {
			if ($UI_Main_Drive_To_Log.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		if ($UI_Main_Drive_To_View.Enabled) {
			if ($UI_Main_Drive_To_View.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		<#
			.映像语言
		#>
		New-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		if ($UI_Main_Language.Enabled) {
			if ($UI_Main_Language.Checked) {
				New-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $True -Force
			}
		}

		Refres_Event_Tasks_Feature_More

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"

		return $true
	}

	Function Refres_Event_Tasks_Feature_More
	{
		<#
			.固化更新
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Curing_Update.Checked = $True
			$UI_Main_Curing_Update.ForeColor = "Green"
			$UI_Main_Curing_Update.Text = "$($lang.CuringUpdate): $($lang.Enable)"
		} else {
			$UI_Main_Curing_Update.Checked = $False
			$UI_Main_Curing_Update.ForeColor = "Red"
			$UI_Main_Curing_Update.Text = "$($lang.CuringUpdate): $($lang.Disable)"
		}

		<#
			.清理过期的组件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Superseded_Rule.Checked = $True
			$UI_Main_Superseded_Rule.ForeColor = "Green"
			$UI_Main_Superseded_Rule.Text = "$($lang.Superseded): $($lang.Enable)"
		} else {
			$UI_Main_Superseded_Rule.Checked = $false
			$UI_Main_Superseded_Rule.ForeColor = "Red"
			$UI_Main_Superseded_Rule.Text = "$($lang.Superseded): $($lang.Disable)"
		}

		if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Superseded_Rule_Exclude.Checked = $True
			$UI_Main_Superseded_Rule_Exclude.ForeColor = "Green"
			$UI_Main_Superseded_Rule_Exclude.Text = "$($lang.ExcludeItem): $($lang.Enable)"
		} else {
			$UI_Main_Superseded_Rule_Exclude.Checked = $False
			$UI_Main_Superseded_Rule_Exclude.ForeColor = "Red"
			$UI_Main_Superseded_Rule_Exclude.Text = "$($lang.ExcludeItem): $($lang.Disable)"
		}

		<#
			.健康
		#>
		if ((Get-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Healthy.Checked = $True
			$UI_Main_Healthy.ForeColor = "Green"
			$UI_Main_Healthy.Text = "$($lang.Healthy): $($lang.Enable)"
		} else {
			$UI_Main_Healthy.Checked = $False
			$UI_Main_Healthy.ForeColor = "Red"
			$UI_Main_Healthy.Text = "$($lang.Healthy): $($lang.Disable)"
		}

		<#
			.获取预安装应用 UWP
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_UWP_To_Log.Checked = $True
			$UI_Main_UWP_To_Log.ForeColor = "Green"
			$UI_Main_UWP_To_Log.Text = "$($lang.ExportToLogs): $($lang.Enable)"
		} else {
			$UI_Main_UWP_To_Log.Checked = $False
			$UI_Main_UWP_To_Log.ForeColor = "Red"
			$UI_Main_UWP_To_Log.Text = "$($lang.ExportToLogs): $($lang.Disable)"
		}
		<#
			.获取预安装应用 UWP
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_UWP_To_View.Checked = $True
			$UI_Main_UWP_To_View.ForeColor = "Green"
			$UI_Main_UWP_To_View.Text = "$($lang.ExportShow): $($lang.Enable)"
		} else {
			$UI_Main_UWP_To_View.Checked = $False
			$UI_Main_UWP_To_View.ForeColor = "Red"
			$UI_Main_UWP_To_View.Text = "$($lang.ExportShow): $($lang.Disable)"
		}

		<#
			.查看安装的所有软件包的列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Package_To_Log.Checked = $True
			$UI_Main_Package_To_Log.ForeColor = "Green"
			$UI_Main_Package_To_Log.Text = "$($lang.ExportToLogs): $($lang.Enable)"
		} else {
			$UI_Main_Package_To_Log.Checked = $False
			$UI_Main_Package_To_Log.ForeColor = "Red"
			$UI_Main_Package_To_Log.Text = "$($lang.ExportToLogs): $($lang.Disable)"
		}
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Package_To_View.Checked = $True
			$UI_Main_Package_To_View.ForeColor = "Green"
			$UI_Main_Package_To_View.Text = "$($lang.ExportShow): $($lang.Enable)"
		} else {
			$UI_Main_Package_To_View.Checked = $False
			$UI_Main_Package_To_View.ForeColor = "Red"
			$UI_Main_Package_To_View.Text = "$($lang.ExportShow): $($lang.Disable)"
		}

		<#
			.查看已安装的驱动列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Drive_To_Log.Checked = $True
			$UI_Main_Drive_To_Log.ForeColor = "Green"
			$UI_Main_Drive_To_Log.Text = "$($lang.ExportToLogs): $($lang.Enable)"
		} else {
			$UI_Main_Drive_To_Log.Checked = $False
			$UI_Main_Drive_To_Log.ForeColor = "Red"
			$UI_Main_Drive_To_Log.Text = "$($lang.ExportToLogs): $($lang.Disable)"
		}
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Drive_To_View.Checked = $True
			$UI_Main_Drive_To_View.ForeColor = "Green"
			$UI_Main_Drive_To_View.Text = "$($lang.ExportShow): $($lang.Enable)"
		} else {
			$UI_Main_Drive_To_View.Checked = $False
			$UI_Main_Drive_To_View.ForeColor = "Red"
			$UI_Main_Drive_To_View.Text = "$($lang.ExportShow): $($lang.Disable)"
		}

		<#
			.映像语言
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Language.Checked = $True
			$UI_Main_Language.ForeColor = "Green"
			$UI_Main_Language.Text = "$($lang.ExportToLogs): $($lang.Enable)"
		} else {
			$UI_Main_Language.Checked = $False
			$UI_Main_Language.ForeColor = "Red"
			$UI_Main_Language.Text = "$($lang.ExportToLogs): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		<#
			.固化更新
		#>
		New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

			<#
				.清理取代的
			#>
			New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.健康
		#>
		New-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.获取预安装应用 UWP
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.查看安装的所有软件包的列表
		#>
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.查看已安装的驱动列表
		#>
		New-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		<#
			.映像语言
		#>
		New-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value $False -Force

		Refres_Event_Tasks_Feature_More

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
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
		Width          = 928
		Text           = $lang.MoreFeature
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 555
		Padding        = "25,15,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		Dock           = 3
		autoScroll     = $true
	}

	$UI_Main_Rule      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.固化更新
	#>
	$UI_Main_Curing_Update = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 450
		Text           = $lang.CuringUpdate
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Curing_Update_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "18,0,0,0"
		Text           = $lang.CuringUpdateTips
	}

	<#
		.清理取代的
	#>
	$UI_Main_Superseded_Rule = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 450
		Margin         = "18,20,0,0"
		Text           = $lang.Superseded
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Superseded_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "36,0,0,10"
		Text           = $lang.SupersededTips
	}
	$UI_Main_Superseded_Rule_Exclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 450
		Padding        = "32,0,0,0"
		Text           = $lang.ExcludeItem
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Superseded_Rule_View_Detailed = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Padding        = "48,0,0,0"
		Text           = $lang.Exclude_View
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_View_Detailed.Visible = $True
			$UI_Main_View_Detailed_Show.Text = ""

			$UI_Main_View_Detailed_Show.Text += "   $($lang.ExcludeItem)`n"
			ForEach ($item in $Global:ExcludeClearSuperseded) {
				$UI_Main_View_Detailed_Show.Text += "       $($item)`n"
			}
		}
	}

	<#
		.健康
	#>
	$UI_Main_Healthy   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.Healthy
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Healthy_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "18,0,0,0"
		Text           = $lang.HealthyTips
	}

	<#
		.打印报告到日志里
	#>
	$UI_Main_UWP_Name  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.GetInBoxApps
	}
	$UI_Main_UWP_To_Log = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportToLogs
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_UWP_To_View = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportShow
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Package_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.GetImagePackage
	}
	$UI_Main_Package_To_Log = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportToLogs
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Package_To_View = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportShow
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.驱动
	#>
	$UI_Main_Drive_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.ViewDrive
	}
	$UI_Main_Drive_To_Log = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportToLogs
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Drive_To_View = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportShow
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Language_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.ImageLanguage
	}
	$UI_Main_Language  = New-Object System.Windows.Forms.CheckBox -Property @{
		Padding        = "15,0,0,0"
		Height         = 35
		Width          = 450
		Text           = $lang.ExportToLogs
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_SaveTo  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Margin         = "0,35,0,0"
		Text           = $lang.SaveTo
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_View_Detailed_Show = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_View_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $False
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
			Event_Need_Mount_Global_Variable -DevQueue "12" -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
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
		Location       = "620,228"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 120
		Width          = 250
		Location       = "645,230"
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
		Height         = 36
		Width          = 280
		Location       = "620,595"
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Feature_More_UI_Save) {
				
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

				<#
					.固化更新
				#>
				Write-Host "`n  $($lang.CuringUpdate)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.清理取代的
				#>
				Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green

					Write-Host "`n  $($lang.ExcludeItem)" -ForegroundColor Yellow
					if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
						Write-Host "  $($lang.Operable)" -ForegroundColor Green
					} else {
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.健康
				#>
				Write-Host "`n  $($lang.Healthy)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.获取预安装应用 UWP
				#>
				Write-Host "`n  $($lang.GetInBoxApps)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.ExportShow)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.查看安装的所有软件包的列表
				#>
				Write-Host "`n  $($lang.GetImagePackage)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.ExportShow)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.查看已安装的驱动列表
				#>
				Write-Host "`n  $($lang.ViewDrive)"
				Write-Host "  $($lang.ExportToLogs)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.ExportShow)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.映像语言
				#>
				Write-Host "`n  $($lang.ImageLanguage)"
				if ((Get-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_View_Detailed,
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Curing_Update,
		$UI_Main_Curing_Update_Tips,
		$UI_Main_Superseded_Rule,
		$UI_Main_Superseded_Rule_Tips,
		$UI_Main_Superseded_Rule_Exclude,
		$UI_Main_Superseded_Rule_View_Detailed,
		$UI_Main_Healthy,
		$UI_Main_Healthy_Tips,
		$UI_Main_UWP_Name,
		$UI_Main_UWP_To_Log,
		$UI_Main_UWP_To_View,
		$UI_Main_Package_Name,
		$UI_Main_Package_To_Log,
		$UI_Main_Package_To_View,
		$UI_Main_Drive_Name,
		$UI_Main_Drive_To_Log,
		$UI_Main_Drive_To_View,
		$UI_Main_Language_Name,
		$UI_Main_Language,
		$UI_Main_SaveTo,
		$UI_Main_Rule
	))

	<#
		.计算公式：
			四舍五入为整数
				(初始化字符长度 * 初始化字符长度）
			/ 控件高度
	#>
	<#
		.初始化字符长度
	#>
	[int]$InitCharacterLength = 85

	<#
		.初始化控件高度
	#>
	[int]$InitControlHeight = 35

	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
		New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value "$(Get_MainMasterFolder)\$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report" -Force
		$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
	}

	ForEach ($item in $SearchFolderRule) {
		$InitLength = $item.Length
		if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
			Width     = 495
			Text      = $item
			Tag       = $item
			Margin    = "16,0,0,0"
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}

		if ($Temp_Expand_Rule -eq $item) {
			$CheckBox.Checked = $True
		} else {
			$CheckBox.Checked = $false
		}

		$CheckBox_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 495
			Padding        = "25,0,0,0"
			Text           = $lang.OpenFolder
			Tag            = $item
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				} else {
					if (Test-Path -Path $This.Tag -PathType Container) {
						Start-Process $This.Tag

						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
					}
				}
			}
		}

		$CheckBox_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 495
			Padding        = "25,0,0,0"
			Text           = $lang.Paste
			Tag            = $item
			LinkColor      = "GREEN"
			ActiveLinkColor = "RED"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}
		$CheckBox_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height     = 15
			Width      = 495
		}

		$UI_Main_Rule.controls.AddRange((
			$CheckBox,
			$CheckBox_Open_Folder,
			$CheckBox_Paste,
			$CheckBox_Wrap
		))
	}

	$UI_Main_Need_Mount_Lang_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
	}
	$UI_Main_Menu.controls.AddRange($UI_Main_Need_Mount_Lang_Wrap)

	<#
		.判断 boot.wim，关闭部分不可用的选项
	#>
	switch ("$($Global:Primary_Key_Image.Master);$($Global:Primary_Key_Image.ImageFileName);") {
		"Install;Install;wim;" {

		}
			"Install;WinRE;wim;" {
				$UI_Main_Curing_Update.Enabled = $False                 # 固化更新
				$UI_Main_Superseded_Rule.Enabled = $False               # 清理取代的
				$UI_Main_Superseded_Rule_Exclude.Enabled = $False       # 清理过时的，排除规则
				$UI_Main_Healthy.Enabled = $False                       # 健康
				$UI_Main_UWP_To_Log.Enabled = $False                    # 获取预安装应用 UWP
			}

		"boot;boot;wim;" {
			$UI_Main_Curing_Update.Enabled = $False                 # 固化更新
			$UI_Main_Superseded_Rule.Enabled = $False               # 清理取代的
			$UI_Main_Superseded_Rule_Exclude.Enabled = $False       # 清理过时的，排除规则
			$UI_Main_Healthy.Enabled = $False                       # 健康
			$UI_Main_UWP_To_Log.Enabled = $False                    # 获取预安装应用 UWP
		}
	}

	Refres_Event_Tasks_Feature_More

	if ($Global:AutopilotMode) {
		$UI_Main_UWP_To_Log.Enabled = $True
		$UI_Main_Package_To_Log.Enabled = $True
		$UI_Main_Drive_To_Log.Enabled = $True
		$UI_Main_Language.Enabled = $True

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.MoreFeature)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main_UWP_To_Log.Enabled = $True
		$UI_Main_Package_To_Log.Enabled = $True
		$UI_Main_Drive_To_Log.Enabled = $True
		$UI_Main_Language.Enabled = $True

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Current,
			$UI_Main_Event_Assign_Stop
		))
	}

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.MoreFeature)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

			if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
				if (Image_Is_Select_Install) {
					$UI_Main_UWP_To_Log.Enabled = $True
					$UI_Main_UWP_To_View.Enabled = $True
				}

				$UI_Main_Drive_To_Log.Enabled = $True
				$UI_Main_Drive_To_View.Enabled = $True
				$UI_Main_Package_To_Log.Enabled = $True
				$UI_Main_Package_To_View.Enabled = $True
				$UI_Main_Language.Enabled = $True
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

		<#
			.固化更新
		#>
		if ($Autopilot.CuringUpdate) {
			$UI_Main_Curing_Update.Checked = $True
		}

			if ($Autopilot.Superseded.IsSuperseded) {
				$UI_Main_Superseded_Rule.Checked = $True
			}

			if ($Autopilot.Superseded.ExcludeRules) {
				$UI_Main_Superseded_Rule_Exclude.Checked = $True
			}

		<#
			.健康
		#>
		if ($Autopilot.Healthy) {
			$UI_Main_Healthy.Checked = $True
		}

		<#
			.打印报告到日志里
		#>
			<#
				.InBox Apps：已安装的应用程序包
			#>
			if ($Autopilot.Report.InboxApps) {
				$UI_Main_UWP_To_Log.Checked = $True
			}

			<#
				.组件：映像中已安装的所有包
			#>
			if ($Autopilot.Report.Components) {
				$UI_Main_Package_To_Log.Checked = $True
			}

			<#
				.组件：查看已安装驱动
			#>
			if ($Autopilot.Report.Drive) {
				$UI_Main_Drive_To_Log.Checked = $True
			}

			<#
				.查看映像语言设置
			#>
			if ($Autopilot.Report.ImageLangue) {
				$UI_Main_Language.Checked = $True
			}
			
		<#
			.选择保存到
		#>
		$New_Custom_Path = Autopilot_Custom_Replace_Variable -var $Autopilot.SaveTo

		$UI_Main_Rule.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($New_Custom_Path -eq $_.Text) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
		}

		if (Autopilot_Feature_More_UI_Save) {
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
	.Clean up expired and replaced
	.清理过期被取代的
#>
Function Image_Clear_Superseded
{
	<#
		.初始化，获取预安装 InBox Apps 应用
	#>
	$InitlClearSuperseded = @()
	$InitlClearSupersededExclude = @()
	$InitlClearSupersededDelete = @()
	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	<#
		.判断挂载目录是否存在
	#>
	if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
		<#
			.从设置里判断是否允许排除规则
		#>
		if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			ForEach ($item in $Global:ExcludeClearSuperseded) {
				$InitlClearSupersededDelete += $item
			}
		}

		<#
			.输出当前所有排除规则
		#>
		Write-Host "`n  $($lang.ExcludeItem)" -ForegroundColor Yellow
		if ($InitlClearSupersededDelete.count -gt 0) {
			ForEach ($item in $InitlClearSupersededDelete) {
				Write-Host "  $($item)" -ForegroundColor Green
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		<#
			.获取所有已安装的应用，并输出到数组
		#>
		Write-Host "`n  $($lang.Superseded)" -ForegroundColor Yellow
		try {
			Get-WindowsPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current -ErrorAction SilentlyContinue | ForEach-Object {
				if ($_.PackageState -eq "Superseded") {
					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
					Write-Host $_.PackageName -ForegroundColor Green

					Write-Host "  $($lang.RuleDescription): " -NoNewline -ForegroundColor Yellow
					Write-Host "Superseded" -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					$InitlClearSuperseded += $_.PackageName
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
				}

#				if ($_.PackageState -eq "Staged") {
#					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
#					Write-Host $_.PackageName -ForegroundColor Green
#
#					Write-Host "  $($lang.RuleDescription): " -NoNewline -ForegroundColor Yellow
#					Write-Host "Staged" -ForegroundColor Green
#
#					Write-Host "  " -NoNewline
#					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
#					$InitlClearSuperseded += $_.PackageName
#					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
#					Write-Host
#				}

				if ($_.PackageState -eq "UninstallPending") {
					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
					Write-Host $_.PackageName -ForegroundColor Green

					Write-Host "  $($lang.RuleDescription): " -NoNewline -ForegroundColor Yellow
					Write-Host "UninstallPending" -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
					$InitlClearSuperseded += $_.PackageName
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host
				}
			}
		} catch {
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
			Write-Host "  $($lang.Superseded), $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.从排除规则获取需要排除的项目
		#>
		if ($InitlClearSuperseded.count -gt 0) {
			ForEach ($Item in $InitlClearSuperseded) {
				ForEach ($WildCard in $InitlClearSupersededDelete) {
					if ($item -like $WildCard) {
						$InitlClearSupersededExclude += $item
					}
				}
			}

			Write-Host "`n  $($lang.LXPsWaitRemove)" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			ForEach ($item in $InitlClearSuperseded) {
				if ($InitlClearSupersededExclude -notContains $item) {
					Write-Host "  $($lang.RuleFileType): " -NoNewline -ForegroundColor Yellow
					Write-Host $item -ForegroundColor Red

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Remove-WindowsPackage -Path ""$($test_mount_folder_Current)"" -PackageName ""$($item)""" -ForegroundColor Green
						Write-Host "  $('-' * 80)`n"
					}

					Write-Host "  " -NoNewline
					Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
					try {
						Remove-WindowsPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Remove.log" -Path $test_mount_folder_Current -PackageName $item -ErrorAction SilentlyContinue | Out-Null
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} catch {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						Write-Host "  $($_)" -ForegroundColor Red
					}

					Write-Host
				}
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
	}
}