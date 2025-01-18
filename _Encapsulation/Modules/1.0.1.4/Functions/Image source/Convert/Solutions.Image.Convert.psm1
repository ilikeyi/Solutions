<#
	.Menu: Convert image
	.菜单：转换映像
#>
Function Image_Convert
{
	if (-not $Global:EventQueueMode) {
		Logo -Title "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"
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
			Image_Convert
		}

		Image_Get_Mount_Status

		if (Image_Is_Mount_Specified -Master "Install" -ImageFileName "Install") {
			Write-Host "`n  $($lang.AssignNeedMount)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}
	}

	<#
		.Assign available tasks
		.分配可用的任务
	#>
	Event_Assign -Rule "Image_Convert_UI" -Run
}

<#
	.Convert image user interface
	.转换映像用户界面
#>
Function Image_Convert_UI
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

	Function Autopilot_Image_Convert_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		# 备份
		$Flag_Convert_Backup = $False

		<#
			拆分
		#>
		$Flag_Convert_Split = $False

		# 重建
		$Flag_Convert_Rebuild = $False

		<#
			转换 ESD to WIM
				转换后：
					·重建
					·拆分
		#>
		if ($GUIImageConvertToESD.Checked) {
			$Global:QueueConvert = $False
			$Global:Queue_Convert_Tasks = @()

			<#
				.允许拆分
			#>
			if ($GUIImageConvertSplit.Enabled) {
				if ($GUIImageConvertSplit.Checked) {
					$Flag_Convert_Split = $True
				}
			}

			<#
				.转换前创建备份
			#>
			if ($GUIImageConvertBackup.Enabled) {
				if ($GUIImageConvertBackup.Checked) {
					$Flag_Convert_Backup = $True
				}
			}

			$Global:QueueConvert = $True
			$Global:Queue_Convert_Tasks = @{
				Name        = "ESDtoWIM"
				Compression = $Solutions_Office_Select_New.SelectedItem.CompressionType
				Backup      = $Flag_Convert_Backup
				Rebuild     = $Flag_Convert_Rebuild
				Split       = @{
					IsSplit = $Flag_Convert_Split
					Size    = $GUIImageConvertSplitSelect.Text
				}
			}

			Refres_Event_Tasks_Image_Convert

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			return $True
		}

		<#
			转换 WIM to ESD
				转换前：
					·重建
		#>
		if ($GUIImageConvertToWIM.Checked) {
			$Global:QueueConvert = $False
			$Global:Queue_Convert_Tasks = @()
			<#
				.转换前重建
			#>
			if ($GUIImageConvertRebuld.Enabled) {
				if ($GUIImageConvertRebuld.Checked) {
					$Flag_Convert_Rebuild = $True
				}
			}

			<#
				.转换前创建备份
			#>
			if ($GUIImageConvertBackup.Enabled) {
				if ($GUIImageConvertBackup.Checked) {
					$Flag_Convert_Backup = $True
				}
			}

			$Global:QueueConvert = $True
			$Global:Queue_Convert_Tasks = @{
				Name        = "WIMtoESD"
				Compression = $Flag_Compression_Type
				Backup      = $Flag_Convert_Backup
				Rebuild     = $Flag_Convert_Rebuild
				Split       = @{
					IsSplit = $Flag_Convert_Split
					Size    = $GUIImageConvertSplitSelect.Text
				}
			}

			Refres_Event_Tasks_Image_Convert

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			return $True
		}

		<#
			拆分 WIM 到 SWM
				转换前：
					·重建

				转换后：
					·拆分（大小）
		#>
		if ($GUIImageWimToSWM.Checked) {
			$Global:QueueConvert = $False
			$Global:Queue_Convert_Tasks = @()

			<#
				.转换后重建
			#>
			if ($GUIImageConvertRebuld.Enabled) {
				if ($GUIImageConvertRebuld.Checked) {
					$Flag_Convert_Rebuild = $True
				}
			}

			<#
				.允许拆分
			#>
			if ($GUIImageConvertSplit.Enabled) {
				if ($GUIImageConvertSplit.Checked) {
					$Flag_Convert_Split = $True
				}
			}

			<#
				.转换前创建备份
			#>
			if ($GUIImageConvertBackup.Enabled) {
				if ($GUIImageConvertBackup.Checked) {
					$Flag_Convert_Backup = $True
				}
			}

			$Global:QueueConvert = $True
			$Global:Queue_Convert_Tasks = @{
				Name        = "SplitWim"
				Compression = $Solutions_Office_Select_New.SelectedItem.CompressionType
				Backup      = $Flag_Convert_Backup
				Rebuild     = $Flag_Convert_Rebuild
				Split       = @{
					IsSplit = $Flag_Convert_Split
					Size    = $GUIImageConvertSplitSelect.Text
				}
			}

			Refres_Event_Tasks_Image_Convert

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			return $True
		}

		<#
			合并 install*.swm
		#>
		if ($GUIImageSWM.Checked) {
			$Global:QueueConvert = $False
			$Global:Queue_Convert_Tasks = @()

			<#
				.转换前创建备份
			#>
			if ($GUIImageConvertBackup.Enabled) {
				if ($GUIImageConvertBackup.Checked) {
					$Flag_Convert_Backup = $True
				}
			}

			$Global:QueueConvert = $True
			$Global:Queue_Convert_Tasks = @{
				Name        = "MergedSWM"
				Compression = $Solutions_Office_Select_New.SelectedItem.CompressionType
				Backup      = $Flag_Convert_Backup
				Rebuild     = $Flag_Convert_Rebuild
				Split       = @{
					IsSplit = $Flag_Convert_Split
					Size    = $GUIImageConvertSplitSelect.Text
				}
			}

			Refres_Event_Tasks_Image_Convert

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			return $True
		}

		$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		return $False
	}

	Function Refresh_CompressionType
	{
		param
		(
			$Type
		)

		switch ($Type) {
			"Max" {
				$Solutions_Office_Select_New.SelectedIndex = $Solutions_Office_Select_New.FindString($lang.CompressionType_Max)
			}
			"Fast" {
				$Solutions_Office_Select_New.SelectedIndex = $Solutions_Office_Select_New.FindString($lang.CompressionType_Fast)
			}
			"None" {
				$Solutions_Office_Select_New.SelectedIndex = $Solutions_Office_Select_New.FindString($lang.CompressionType_None)
			}
		}
	}

	Function Refres_Event_Tasks_Image_Convert
	{
		if ($Global:QueueConvert) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}

		if ($Global:Queue_Convert_Tasks) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		$Global:QueueConvert = $False
		$Global:Queue_Convert_Tasks = @()

		Refres_Event_Tasks_Image_Convert

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	<#
		.刷新选择状态
	#>
	Function Image_Convert_Refresh
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUIImageConvertSplit.Enabled = $False       # 拆分：禁用
#		$GUIImageConvertSplit.Checked = $False       # 拆分：不选择
		$GUIImageConvertSplitSelect.Enabled = $False # 拆分：启用
		$GUIImageConvertSplitMB.Enabled = $False     # 拆分：MB
		$GUIImageConvertRebuld.Enabled = $False      # 重建：禁用

		<#
			.ESD to WIM
		#>
		if ($GUIImageConvertToESD.Checked) {
			$GUIImageConvertSplit.Enabled = $True    # 拆分：启用
		}

		<#
			.WIM to ESD
		#>
		if ($GUIImageConvertToWIM.Checked) {
#			$GUIImageConvertRebuld.Checked = $True      # 拆分：选择
			$GUIImageConvertRebuld.Enabled = $True      # 重建：启用
		}

		<#
			.WIM to Swm
		#>
		if ($GUIImageWimToSWM.Checked) {
#			$GUIImageConvertRebuld.Checked = $True      # 拆分：选择
			$GUIImageConvertRebuld.Enabled = $True      # 重建：启用
			$GUIImageConvertSplit.Enabled = $True       # 拆分：启用
#			$GUIImageConvertSplit.Checked = $True       # 拆分：选择
		}

		<#
			.合并 Swm
		#>
		if ($GUIImageSWM.Checked) {
		}

		if ($GUIImageConvertSplit.Checked) {
			$GUIImageConvertSplitSelect.Enabled = $True
			$GUIImageConvertSplitMB.Enabled = $True
		} else {
			$GUIImageConvertSplitSelect.Enabled = $False
			$GUIImageConvertSplitMB.Enabled = $False
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	<#
		.转换
	#>
	$UI_Main_Dictionary = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = "15,15"
		Text           = $lang.Convert_Only
	}
	$GUIImageConvertToESD = New-Object system.Windows.Forms.RadioButton -Property @{
		Height          = 30
		Width           = 436
		Location        = "33,45"
		Text            = $lang.ConvertImageSwitch -f "ESD", "WIM"
#		add_Click       = { Image_Convert_Refresh }
	}
	$GUIImageConvertToWIM = New-Object system.Windows.Forms.RadioButton -Property @{
		Height          = 30
		Width           = 436
		Location        = "33,80"
		Text            = $lang.ConvertImageSwitch -f "WIM", "ESD"
#		add_Click       = { Image_Convert_Refresh }
	}

	<#
		.拆分
	#>
	$UI_Main_Split     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = "15,150"
		Text           = $lang.Conver_Split_To_Swm
	}
	$GUIImageWimToSWM  = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 436
		Location       = "33,175"
		Text           = $lang.Conver_Split_rule -f "Install.Wim", "Install*.Swm"
#		add_Click       = { Image_Convert_Refresh }
	}

	<#
		.合并
	#>
	$UI_Main_Merged = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = "15,245"
		Text           = $lang.Conver_Merged
	}
	$GUIImageSWM       = New-Object system.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 436
		Location       = "33,275"
		Text           = $lang.ConvertSWM
#		add_Click       = { Image_Convert_Refresh }
	}
	$GUIImageSWMTips   = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 421
		Location       = "48,315"
		Text           = $lang.ConvertSWMTips
	}

	<#
		.可选功能
	#>
	$GUIImageConvertAdv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = '48,380'
		Text           = $lang.AdvOption
	}
	$GUIImageConvertRebuld = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 418
		Location       = "70,410"
		Text           = "$($lang.Rebuild): Install.wim"
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.拆分 Install
	#>
	$GUIImageConvertSplit = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 418
		Location       = '70,450'
		Text           = $lang.ConvertSplit
		Enabled        = $False
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($This.Checked) {
				$GUIImageConvertSplitSelect.Enabled = $True
				$GUIImageConvertSplitMB.Enabled = $True
			} else {
				$GUIImageConvertSplitSelect.Enabled = $False
				$GUIImageConvertSplitMB.Enabled = $False
			}
		}
	}
	$GUIImageConvertSplitSelect = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "88,495"
		Text           = "4096"
		value          = 4096
		Minimum        = 1
		Maximum        = 9999
		TextAlign      = 1
	}
	$GUIImageConvertSplitMB = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 265
		Location       = "152,497"
		Text           = "MB"
		Enabled        = 0
	}

	<#
		.压缩类型
	#>
	$UI_Main_CompressionType = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = '48,565'
		Text           = $lang.CompressionType
	}
	$Solutions_Office_Select_New = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 220
		Location       = "70,600"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
		}
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$CompressionType = [Collections.ArrayList]@(
		[pscustomobject]@{ CompressionType = "Max";  Lang = $lang.CompressionType_Max; }
		[pscustomobject]@{ CompressionType = "Fast"; Lang = $lang.CompressionType_Fast; }
		[pscustomobject]@{ CompressionType = "None"; Lang = $lang.CompressionType_None; }
	)

	$Solutions_Office_Select_New.BindingContext = New-Object System.Windows.Forms.BindingContext
	$Solutions_Office_Select_New.Datasource = $CompressionType
	$Solutions_Office_Select_New.ValueMember = "CompressionType"
	$Solutions_Office_Select_New.DisplayMember = "Lang"

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Location       = "570,15"
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Location       = "570,45"
		Padding        = "16,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 530
		Location       = "570,80"
		Padding        = "32,0,0,0"
		Text           = $lang.EventManagerCurrentClear
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	<#
		.创建前备份
	#>
	$GUIImageConvertBackup = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 400
		Location       = "570,140"
		Text           = $lang.ConvertBackup
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIImageConvertBackupTips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 440
		Location       = "586,180"
		Text           = $lang.ConvertBackupTips
	}

	<#
		.Note
		.注意
	#>
	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 240
		Width          = 450
		Location       = "587,225"
		BorderStyle    = 0
		Text           = $lang.ConvertSplitTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '570,495'
		Text           = $lang.AssignSetting
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Not_Mounted = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Location       = '570,525'
		Text           = $lang.AssignEndNoMount
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '570,555'
		Text           = $lang.AssignForceEnd
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
		Location       = '570,490'
		Text           = $lang.SuggestedSkip
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
		Location       = '586,526'
		Text           = $lang.AssignSetting
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '586,555'
		Text           = $lang.AssignForceEnd
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
		Height         = 30
		Width          = 460
		Location       = "585,600"
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
	$UI_Main_Save       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Image_Convert_Save) {

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

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		<#
			.转换
		#>
		$UI_Main_Dictionary,
		$GUIImageConvertToESD,
		$GUIImageConvertToWIM,

		<#
			.拆分
		#>
		$UI_Main_Split,
		$GUIImageWimToSWM,

		<#
			.合并
		#>
		$UI_Main_Merged,
		$GUIImageSWM,
		$GUIImageSWMTips,

		<#
			.可选
		#>
		$GUIImageConvertAdv,
		$GUIImageConvertRebuld,

		<#
			.拆分选项
		#>
		$GUIImageConvertSplit,
		$GUIImageConvertSplitSelect,
		$GUIImageConvertSplitMB,

		<#
			.压缩类型
		#>
		$UI_Main_CompressionType,
		$Solutions_Office_Select_New,

		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,

		<#
			.转换前备份
		#>
		$GUIImageConvertBackup,
		$GUIImageConvertBackupTips,

		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))

	$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
	$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
	$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"

	$GUIImageConvertToESD.Enabled = $False
	if (Test-Path -Path $Install_ESD -PathType Leaf) {
		if (Confirm_File_In_Use -filePath $Install_ESD) {
			$UI_Main_Error.Text = "$($lang.Inoperable): $($Install_ESD)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		} else {
			$GUIImageConvertToESD.Enabled = $True
		}
	}

	$GUIImageConvertToWIM.Enabled = $False
	$GUIImageWimToSWM.Enabled = $False
	if (Test-Path -Path $Install_wim -PathType Leaf) {
		if (Confirm_File_In_Use -filePath $Install_wim) {
			$UI_Main_Error.Text = "$($lang.Inoperable): $($Install_wim)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		} else {
			$GUIImageConvertToWIM.Enabled = $True
			$GUIImageWimToSWM.Enabled = $True
		}
	}

	<#
		.初始化 SWM
	#>
	if (Test-Path -Path $Install_swm -PathType Leaf) {
		$GUIImageSWM.Enabled = $True
		$GUIImageSWMTips.Enabled = $True
	} else {
		$GUIImageSWM.Enabled = $False
		$GUIImageSWMTips.Enabled = $False
	}

	if ($GUIImageConvertSplit.Checked) {
		$GUIImageConvertSplitSelect.Enabled = $True
		$GUIImageConvertSplitMB.Enabled = $True
	} else {
		$GUIImageConvertSplitSelect.Enabled = $False
		$GUIImageConvertSplitMB.Enabled = $False
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Not_Mounted,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

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
		.压缩类型
	#>
	Refresh_CompressionType -Type $Global:Queue_Convert_Tasks.Compression

	<#
		.刷新已保存
	#>
	Refresh_Is_Save_Image_Convert
	Refres_Event_Tasks_Image_Convert

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

		switch ($Autopilot.Schome) {
			"ESDtoWIM" {
				$GUIImageConvertToESD.Checked = $True
				$GUIImageConvertSplit.Enabled = $True       # 拆分：启用

				<#
					.压缩类型
				#>
				Refresh_CompressionType -Type $Autopilot.Config.ESDtoWIM.Compression
			}
			"WIMtoESD" {
				$GUIImageConvertToWIM.Checked = $True
				$GUIImageConvertRebuld.Enabled = $True      # 重建：启用

				<#
					.压缩类型
				#>
				Refresh_CompressionType -Type $Autopilot.Config.WIMtoESD.Compression
			}
			"SplitWim" {
				$GUIImageWimToSWM.Checked = $True
				$GUIImageConvertRebuld.Enabled = $True      # 重建：启用
				$GUIImageConvertSplit.Checked = $True       # 拆分：选择
				$GUIImageConvertSplit.Enabled = $True       # 拆分：启用

				<#
					.压缩类型
				#>
				Refresh_CompressionType -Type $Autopilot.Config.SplitWim.Compression
			}
			"MergedSWM" {
				$GUIImageSWM.Checked = $True

				<#
					.压缩类型
				#>
				Refresh_CompressionType -Type $Autopilot.Config.MergedSWM.Compression
			}
		}

		Refresh_CompressionType

		<#
			.转换前创建备份
		#>
		if ($Autopilot.IsBackup) {
			$GUIImageConvertBackup.Checked = $True
		} else {
			$GUIImageConvertBackup.Checked = $False
		}

		<#
			.其它功能
		#>
			<#
				.转换前重建
			#>
			if ($Autopilot.Config.$($Autopilot.Schome).Rebuild) {
				$GUIImageConvertRebuld.Checked = $True
			} else {
				$GUIImageConvertRebuld.Checked = $False
			}

			<#
				.允许拆分
			#>
			if ($Autopilot.Config.$($Autopilot.Schome).Split.Enabled) {
				$GUIImageConvertSplit.Checked = $True
				$GUIImageConvertSplitSelect.Enabled = $True
				$GUIImageConvertSplitMB.Enabled = $True

				$GUIImageConvertSplitSelect.Text = $Autopilot.Config.$($Autopilot.Schome).Split.Size
			} else {
				$GUIImageConvertSplit.Checked = $False
				$GUIImageConvertSplitSelect.Enabled = $False
				$GUIImageConvertSplitMB.Enabled = $False
			}

		if (Autopilot_Image_Convert_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host "$($lang.SelectFromError): $($lang.NoChoose)" -ForegroundColor Red

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$GUIImageConvertToESD.add_Click({ Image_Convert_Refresh })
		$GUIImageConvertToWIM.add_Click({ Image_Convert_Refresh })
		$GUIImageWimToSWM.add_Click({ Image_Convert_Refresh })
		$GUIImageSWM.add_Click({ Image_Convert_Refresh })

		$UI_Main.ShowDialog() | Out-Null
	}
}

Function Refresh_Is_Save_Image_Convert
{
	if ($Global:QueueConvert) {
		<#
			转换 ESD to WIM
				转换后：
					·重建
					·拆分
		#>
		switch ($Global:Queue_Convert_Tasks.Name) {
			"ESDtoWIM" {
				$GUIImageConvertToESD.Checked = $True
				$GUIImageConvertSplit.Enabled = $True       # 拆分：启用
			}
			"WIMtoESD" {
				$GUIImageConvertToWIM.Checked = $True
				$GUIImageConvertRebuld.Enabled = $True      # 重建：启用
			}
			"SplitWim" {
				$GUIImageWimToSWM.Checked = $True
				$GUIImageConvertRebuld.Enabled = $True      # 重建：启用
				$GUIImageConvertSplit.Checked = $True       # 拆分：选择
				$GUIImageConvertSplit.Enabled = $True       # 拆分：启用
			}
			"MergedSWM" {
				$GUIImageSWM.Checked = $True
			}
		}

		<#
			.转换前创建备份
		#>
		if ($Global:Queue_Convert_Tasks.Backup) {
			$GUIImageConvertBackup.Checked = $True
		} else {
			$GUIImageConvertBackup.Checked = $False
		}

		<#
			.其它功能
		#>
			<#
				.转换前重建
			#>
			if ($Global:Queue_Convert_Tasks.Rebuild) {
				$GUIImageConvertRebuld.Checked = $True
			} else {
				$GUIImageConvertRebuld.Checked = $False
			}

			<#
				.允许拆分
			#>
			if ($Global:Queue_Convert_Tasks.Split.IsSplit) {
				$GUIImageConvertSplit.Checked = $True
				$GUIImageConvertSplitSelect.Enabled = $True
				$GUIImageConvertSplitMB.Enabled = $True

				$GUIImageConvertSplitSelect.Text = $Global:Queue_Convert_Tasks.Split.Size
			} else {
				$GUIImageConvertSplit.Checked = $False
				$GUIImageConvertSplitSelect.Enabled = $False
				$GUIImageConvertSplitMB.Enabled = $False
			}
	}
}
<#
	.Start processing: Convert image
	.开始处理：转换映像
#>
Function Image_Convert_Process
{
	<#
		.初始化时间：所有任务
	#>
	$Script:CovertTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
	$Script:CovertTasksTime = New-Object System.Diagnostics.Stopwatch
	$Script:CovertTasksTime.Reset()
	$Script:CovertTasksTime.Start()

	Write-Host "`n  $('-' * 80)"
	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host " $($Script:CovertTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Solutions).Author)'s Solutions | $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"

	<#
		.Determine the conversion type
		.判断转换类型
	#>
	$RandomGuid = [guid]::NewGuid()

	$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
	$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"
	$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
	$SearchImageSources = Join-Path -Path $Global:Image_source -ChildPath "Sources"

	switch ($Global:Queue_Convert_Tasks.Name)
	{
		<#
			转换 ESD to WIM
				转换后：
					·拆分
		#>
		'ESDtoWIM'
		{
			<#
				.ESD 转换成 WIM
			#>
			Write-Host "`n  $($lang.Converting -f "ESD", "WIM")"
			Write-Host "  $('-' * 80)"
			Write-Host "  $($Install_ESD)"
			if ($Global:Queue_Convert_Tasks.Backup) {
				$SaveFileToEsd = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)\install.esd"

				Write-Host "`n  $($lang.ConvertBackup)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($Install_ESD)"
				Write-Host "  >> "
				Write-Host "  $($SaveFileToEsd)"

				$SaveFileToEsdTemp = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)"
				Check_Folder -chkpath $SaveFileToEsdTemp

				Copy-Item $Install_ESD -Destination $SaveFileToEsd -ErrorAction SilentlyContinue
				Image_Convert_Create_Info_Process -Sources $Install_ESD -SaveTo $SaveFileToEsdTemp
				Write-Host "  $($lang.Done)" -ForegroundColor Green
			}

			Write-Host "`n  $($lang.Del)"
			Write-Host "  $($Install_wim)" -ForegroundColor Green
			if (Test-Path -Path $Install_wim -PathType leaf) {
				Remove_Tree -Path $Install_wim
			}

			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 6`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsImage -ImagePath ""$($Install_ESD)""" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			try {
				Get-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -ImagePath $Install_ESD -ErrorAction SilentlyContinue | ForEach-Object {
					$Host.UI.RawUI.WindowTitle = "$($lang.Converting -f "ESD", "WIM"), $($lang.Wim_Image_Name): $($_.ImageName), $($lang.MountedIndex): $($_.ImageIndex)"

					Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
					Write-Host $_.ImageName -ForegroundColor Yellow

					Write-Host "  $($lang.MountedIndex): " -NoNewline
					Write-Host $_.ImageIndex -ForegroundColor Yellow

					Write-Host "  $($lang.Rebuilding): " -NoNewline
					try {
						Export-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Export.log" -SourceImagePath $Install_ESD -SourceIndex $_.ImageIndex -DestinationImagePath $Install_wim -CompressionType $Global:Queue_Convert_Tasks.Compression -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} catch {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						Write-Host "  $($_)" -ForegroundColor Red
					}

					Write-Host
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_ESD)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
				return
			}

			<#
				转换为 wim 后，判断是否存在新的 install.wim，存在则删除旧的 install.esd
			#>
			if (Test-Path -Path $Install_wim -PathType leaf) {
				Write-Host "`n  $($lang.Del)"
				Write-Host "  $($Install_ESD)" -ForegroundColor Green
				Remove_Tree -Path $Install_ESD

				<#
					.拆分 SWM
				#>
				Write-Host "`n  $($lang.ConvertSplit)"
				if ($Global:Queue_Convert_Tasks.Split.IsSplit) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green

					Get-ChildItem -Path $SearchImageSources -Recurse -include "*.swm" | ForEach-Object {
						Write-Host "  $($lang.Del): $($_.Fullname)`n" -ForegroundColor Green
						Remove-Item -Path $_.Fullname -ErrorAction SilentlyContinue
					}

					Write-Host "`n  $($Install_wim)" -ForegroundColor Green
					if (Test-Path -Path $Install_wim -PathType leaf) {
						Write-Host "  $($lang.Operable)" -ForegroundColor Green

						if ($Global:Developers_Mode) {
							Write-Host "`n  $($lang.Developers_Mode_Location): 7`n" -ForegroundColor Green
						}

						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Split-WindowsImage -ImagePath ""$($Install_wim)"" -SplitImagePath ""$($Install_SWM)"" -FileSize ""$($Global:Queue_Convert_Tasks.Split.Size)"" -CheckIntegrity" -ForegroundColor Green
							Write-Host "  $('-' * 80)`n"
						}

						Write-Host "`n  $($lang.Conver_Split_To_Swm): "
						try {
							Split-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Split.log" -ImagePath "$($Install_wim)" -SplitImagePath "$($Install_SWM)" -FileSize "$($Global:Queue_Convert_Tasks.Split.Size)" -CheckIntegrity
							Write-Host "  $($lang.Done)" -ForegroundColor Green
						} catch {
							Write-Host "  $($lang.ConvertChk)"
							Write-Host "  $($Install_wim)"
							Write-Host "  $($_)" -ForegroundColor Red
							Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
						}

						Write-Host "`n  $($lang.Del)"
						Write-Host "  $($Install_wim)" -ForegroundColor Green
						if (Test-Path -Path $Install_SWM -PathType leaf) {
							Remove_Tree -Path $Install_wim
							Write-Host "  $($lang.Done)" -ForegroundColor Green
						} else {
							Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
						}
					} else {
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}

					Write-Host "  $($lang.Done)" -ForegroundColor Green
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "  $($lang.Converting -f "ESD", "WIM"), $($lang.Done)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}
		}

		<#
			转换 WIM 到 ESD
				转换前：
					·重建
		#>
		'WIMtoESD'
		{
			Write-Host "`n  $($lang.Converting -f "WIM", "ESD")" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($Install_wim)`n"
			if ($Global:Queue_Convert_Tasks.Backup) {
				$SaveFileToWim = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)\install.wim"

				Write-Host "`n  $($lang.ConvertBackup)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($Install_wim)"
				Write-Host "  >> "
				Write-Host "  $($SaveFileToWim)"

				$SaveFileToWimTemp = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)"
				Check_Folder -chkpath $SaveFileToWimTemp

				Copy-Item $Install_wim -Destination $SaveFileToWim -ErrorAction SilentlyContinue
				Image_Convert_Create_Info_Process -Sources $Install_wim -SaveTo $SaveFileToWimTemp
				Write-Host "  $($lang.Done)" -ForegroundColor Green
			}

			<#
				.拆分前重建 install.wim
			#>
			Write-Host "`n  $($lang.Rebuild)"
			if ($Global:Queue_Convert_Tasks.Rebuild) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				Rebuild_Image_File -Filename $Install_wim

				Write-Host "  $($lang.Done)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			Write-Host "  $($lang.Operable)" -ForegroundColor Green

			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 2`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsImage -ImagePath ""$($Install_wim)""" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			try {
				Get-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -ImagePath $Install_wim -ErrorAction SilentlyContinue | ForEach-Object {
					$Host.UI.RawUI.WindowTitle = "$($lang.Converting -f "WIM", "ESD"), $($lang.Wim_Image_Name): $($_.ImageName), $($lang.MountedIndex): $($_.ImageIndex)"

					Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
					Write-Host $_.ImageName -ForegroundColor Yellow

					Write-Host "  $($lang.MountedIndex): " -NoNewline
					Write-Host $_.ImageIndex -ForegroundColor Yellow

					Write-Host "  $($lang.Rebuilding): " -NoNewline

					dism /ScratchDir:"""$(Get_Mount_To_Temp)""" /LogPath:"$(Get_Mount_To_Logs)\Get.log" /export-image /SourceImageFile:"""$($Install_wim)""" /SourceIndex:"""$($_.ImageIndex)""" /DestinationImageFile:""$($Install_ESD)"" /Compress:recovery /CheckIntegrity

					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-host
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_wim)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
				return
			}

			<#
				转换为 ESD 后，判断是否存在新的 install.wim，存在则删除旧的 install.esd
			#>
			Write-Host "`n  $($lang.Del)"
			Write-Host "  $($Install_wim)" -ForegroundColor Green
			if (Test-Path -Path $Install_ESD -PathType leaf) {
				Remove_Tree -Path $Install_wim

				Write-Host "  $($lang.Done)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			Write-Host "`n  $($lang.Converting -f "WIM", "ESD"), $($lang.Done)" -ForegroundColor Green
		}

		<#
			拆分 WIM 到 SWM
				转换前：
					·重建

				转换后：
					·拆分（大小）
		#>
		'SplitWim'
		{
			Write-Host "`n  $($lang.Converting -f "Wim", "Swm")" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($Install_wim)`n"
			
			if ($Global:Queue_Convert_Tasks.Backup) {
				$SaveFileToWim = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)\install.wim"

				Write-Host "`n  $($lang.ConvertBackup)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($Install_wim)"
				Write-Host "  >> "
				Write-Host "  $($SaveFileToWim)"

				$SaveFileToWimTemp = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)"
				Check_Folder -chkpath $SaveFileToWimTemp

				Copy-Item $Install_wim -Destination $SaveFileToWim -ErrorAction SilentlyContinue
				Image_Convert_Create_Info_Process -Sources $Install_wim -SaveTo $SaveFileToWimTemp
				Write-Host "  $($lang.Done)" -ForegroundColor Green
			}

			<#
				.拆分前重建 install.wim
			#>
			Write-Host "`n  $($lang.Rebuild)"
			if ($Global:Queue_Convert_Tasks.Rebuild) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				Rebuild_Image_File -Filename $Install_wim

				Write-Host "  $($lang.Done)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			<#
				.拆分 SWM
			#>
			Write-Host "`n  $($lang.ConvertSplit)"
			if ($Global:Queue_Convert_Tasks.Split.IsSplit) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				Get-ChildItem -Path $SearchImageSources -Recurse -include "*.swm" | ForEach-Object {
					Write-Host "  $($lang.Del): $($_.Fullname)`n" -ForegroundColor Green
					Remove-Item -Path $_.Fullname -ErrorAction SilentlyContinue
				}

				Write-Host "`n  $($Install_wim)" -ForegroundColor Green
				if (Test-Path -Path $Install_wim -PathType leaf) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green

					if ($Global:Developers_Mode) {
						Write-Host "`n  $($lang.Developers_Mode_Location): 7`n" -ForegroundColor Green
					}

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Split-WindowsImage -ImagePath ""$($Install_wim)"" -SplitImagePath ""$($Install_SWM)"" -FileSize ""$($Global:Queue_Convert_Tasks.Split.Size) -CheckIntegrity""" -ForegroundColor Green
						Write-Host "  $('-' * 80)`n"
					}

					try {
						Split-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Split.log" -ImagePath "$($Install_wim)" -SplitImagePath "$($Install_SWM)" -FileSize $Global:Queue_Convert_Tasks.Split.Size -CheckIntegrity
					} catch {
						Write-Host $lang.ConvertChk
						Write-Host "  $($Install_wim)"
						Write-Host "  $($_)" -ForegroundColor Red
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}

					Write-Host "`n  $($lang.Del)"
					Write-Host "  $($Install_SWM)" -ForegroundColor Green
					if (Test-Path -Path $Install_SWM -PathType leaf) {
						Remove_Tree -Path $Install_wim
						Write-Host "  $($lang.Done)" -ForegroundColor Green
					} else {
						Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}
		}

		<#
			合并 install*.swm
		#>
		'MergedSWM'
		{
			Write-Host "`n  $($lang.Converting -f "Swm", "wim")"
			Write-Host "  $('-' * 80)"
			Write-Host "  $($Install_wim)`n"

			$SaveFileToSwm = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)\install*.swm"
			$SaveFileToSwmMatch = Join-Path -Path $Global:Image_source -ChildPath "Sources\*.swm"
			$SaveBackToGuid = Join-Path -Path $Global:MainMasterFolder -ChildPath "Backup\Install.wim\$($RandomGuid)"

			if ($Global:Queue_Convert_Tasks.Backup) {
				Write-Host "`n  $($lang.ConvertBackup)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  $($SaveFileToSwmMatch)"
				Write-Host "  >> "
				Write-Host "  $($SaveFileToSwm)"

				Check_Folder -chkpath $SaveBackToGuid

				Copy-Item $SaveFileToSwmMatch -Destination $SaveBackToGuid -ErrorAction SilentlyContinue
				Image_Convert_Create_Info_Process -Sources $Install_SWM -SaveTo $SaveBackToGuid
				Write-Host "  $($lang.Done)`n" -ForegroundColor Green
			}

			if (Test-Path -Path $Install_wim -PathType leaf) {
				Remove-Item -Path $Install_wim -ErrorAction SilentlyContinue
			}

			Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			try {
				Get-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -ImagePath $Install_SWM -ErrorAction SilentlyContinue | ForEach-Object {
					$Host.UI.RawUI.WindowTitle = "$($lang.Converting -f "Swm", "WIM"), $($lang.Wim_Image_Name): $($_.ImageName), $($lang.MountedIndex): $($_.ImageIndex)"

					Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
					Write-Host $_.ImageName -ForegroundColor Yellow

					Write-Host "  $($lang.MountedIndex): " -NoNewline
					Write-Host $_.ImageIndex -ForegroundColor Yellow

					Write-Host "  $($lang.Rebuilding): " -NoNewline
					$SaveFileToSwmFull = Join-Path -Path $Global:Image_source -ChildPath "Sources\install*.swm"

					dism /ScratchDir:"""$(Get_Mount_To_Temp)""" /LogPath:"$(Get_Mount_To_Logs)\Export.log" /export-image /SourceImageFile:"""$($Install_SWM)""" /swmfile:"""$($SaveFileToSwmFull)""" /SourceIndex:"""$($_.ImageIndex)""" /DestinationImageFile:"""$($Install_wim)""" /Compress:"""$($Global:Queue_Convert_Tasks.Compression)""" /CheckIntegrity

					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					Write-host
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_SWM)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
				return
			}

			if (Test-Path -Path $Install_wim -PathType leaf) {
				Get-ChildItem -Path $SearchImageSources -Recurse -include "*.swm" | ForEach-Object {
					Write-Host "  $($lang.Del): $($_.Fullname)" -ForegroundColor Green
					Remove-Item -Path $_.Fullname -ErrorAction SilentlyContinue
				}
			}
			Write-Host "  $($lang.Converting -f "Swm", "WIM: $($lang.Done)")" -ForegroundColor Green
		}
	}

	$Script:CovertTasksTime.Stop()
	Write-Host "`n  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm), $($lang.Done)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host "$($Script:CovertTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEnd)" -NoNewline
	Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAll)" -NoNewline
	Write-Host "$($Script:CovertTasksTime.Elapsed)" -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
	Write-Host "$($Script:CovertTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
}

Function Confirm_File_In_Use
{
	Param
	(
		[string]$filePath
	)

	try {
		$x = [System.IO.File]::Open($filePath, 'Open', 'Read') # Open file
		$x.Close()    # Opened so now I'm closing
		$x.Dispose()  # Disposing object
		return $false # File not in use
	} catch [System.Management.Automation.MethodException] {
		return $true # Sorry, file in use
	}
}