
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
	$IsEjectAfterSave = (Get-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_Engine" -ErrorAction SilentlyContinue).Value
	ForEach ($item in $IsEjectAfterSave) {
		$Temp_Save_Has_Been_Run += $item
	}

	write-host "`n  $($lang.AssignTask)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"
	if ($Global:Queue_Assign_Not_Monuted_Expand_Select.Count -gt 0) {
		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Expand_Select) {
			write-host "  $($item)" -ForegroundColor Green
		}

		ForEach ($item in $Global:Queue_Assign_Not_Monuted_Expand_Select) {
			if ($Global:Queue_Assign_Not_Monuted_Primary -NotContains $item) {
				if ($Global:Queue_Assign_Not_Monuted_Expand_Select -Contains $item) {
					$Temp_Save_Has_Been_Run += $item
					New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_Engine" -Value $Temp_Save_Has_Been_Run -Force

					Invoke-Expression -Command $item
				}
			}
		}
	} else {
		write-host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

<#
	.Select the image source user interface, select install.wim or boot.wim
	.选择映像源用户界面，选择 install.wim 或 boot.wim
#>
Function Image_Assign_Event_Master
{
	Logo -Title $lang.AssignTask
	write-host "  $($lang.AssignTask)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	<#
		.重置变量
	#>
	$Global:Queue_Assign_Not_Monuted_Expand = @()
	$Global:Queue_Assign_Not_Monuted_Expand_Select = @()

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refresh_Assign_Select
	{
		<#
			.系统类
		#>
		$UI_Group_Class_System = New-Object System.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
			Text           = $lang.Group_Class_System
		}
		$UI_Restore_Point = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.RestorePoint
			Tag            = "Restore_Point_Create_UI"
		}

		<#
			.个性化
		#>
		$UI_Group_Personalise = New-Object System.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
			margin         = "0,25,0,0"
			Text           = $lang.Group_Personalise
		}
		$UI_Change_Location = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.LocationUserFolder
			Tag            = "Change_Location"
			Checked        = $True
		}
		$UI_Desktop_UI     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.DeskIcon
			Tag            = "Desktop"
			Checked        = $True
		}

		<#
			.优化类
		#>
		$UI_Group_Class_Opt = New-Object System.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
			margin         = "0,25,0,0"
			Text           = $lang.Group_Class_Opt
		}
		$UI_Optimization_System_UI = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.Optimize) $($lang.System)"
			Tag            = "Optimization_System_UI"
			Checked        = $True
		}
		$UI_Optimization_Service_UI = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.Optimize) $($lang.Service)"
			Tag            = "Optimization_Service_UI"
			Checked        = $True
		}

		<#
			.应用管理
		#>
		$UI_Group_App_Manager = New-Object System.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
			margin         = "0,25,0,0"
			Text           = $lang.Group_App_Manager
		}
		$UI_UWP_Uninstall = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.Del) $($lang.UninstallUWP)"
			Tag            = "UWP_Uninstall"
			Checked        = $True
		}

		<#
			.应用管理
		#>
		$UI_Group_Instl_Soft = New-Object System.Windows.Forms.Label -Property @{
			Height         = 25
			Width          = 460
			margin         = "0,25,0,0"
			Text           = $lang.Group_Instl_Soft
		}
		$UI_Necessary      = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.Necessary
			Tag            = "Instl_Custom_Software_Config"
			Checked        = $True
		}
		$UI_MostUsedSoftware = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.MostUsedSoftware
			Tag            = "Instl_Custom_Software"
			Checked        = $True
		}
		$UI_Main_Select_Assign_Multitasking.controls.AddRange((
			$UI_Group_Class_System,
			$UI_Restore_Point,

			$UI_Group_Personalise,
			$UI_Change_Location,
			$UI_Desktop_UI,

			$UI_Group_Class_Opt,
			$UI_Optimization_System_UI,
			$UI_Optimization_Service_UI,

			$UI_Group_App_Manager,
			$UI_UWP_Uninstall,

			$UI_Group_Instl_Soft,
			$UI_Necessary,
			$UI_MostUsedSoftware
		))

	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 828
		Text           = $lang.AssignTask
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_AssignTips     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 460
		Location       = "15,15"
		Text           = $lang.AssignTips
	}

	$UI_Main_Select_Assign_Multitasking = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 630
		Width          = 500
		Location       = "10,45"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,0,10,10"
	}

	$UI_Main_Tips      = New-Object System.Windows.Forms.Label -Property @{
		Height         = 300
		Width          = 240
		Text           = $lang.AssignMulTask
		Location       = '560,15'
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,555"
		Height         = 22
		Width          = 240
		Text           = ""
	}
	$UI_Main_Ok        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,595"
		Height         = 36
		Width          = 240
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""

			<#
				.初始化变量
			#>
			<#
				.全局多任务分配
			#>
			$Global:Queue_Assign_Full = @()

			<#
				.分配无需挂载项
			#>
			$Global:Queue_Assign_Not_Monuted_Expand = @()
			$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
			$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$Global:Queue_Assign_Not_Monuted_Expand += $_.Tag

					if ($_.Enabled) {
						if ($_.Checked) {
							$Global:Queue_Assign_Not_Monuted_Expand_Select += $_.Tag
						}
					}
				}
			}

			if ($Global:Queue_Assign_Not_Monuted_Expand_Select.Count -gt 0) {
				$UI_Main.Close()
			} else {
				$UI_Main_Error.Text = $lang.NoWork
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_AssignTips,
		$UI_Main_Select_Assign_Multitasking,

		$UI_Main_Tips,
		$UI_Main_Error,
		$UI_Main_Ok,
		$UI_Main_Canel
	))

	Refresh_Assign_Select

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIImageSelectEventHaveAddMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIImageSelectEventHaveAddMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIImageSelectEventHaveAddMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Select_Assign_Multitasking.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_Assign_Multitasking.ContextMenuStrip = $GUIImageSelectEventHaveAddMenu

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$UI_Main.ShowDialog() | Out-Null
}