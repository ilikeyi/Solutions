<#
	.Reset suggestions
	.重置建议项
#>
Function Event_Reset_Suggest
{
	$Global:EventProcessGuid = [guid]::NewGuid()

	<#
		.分配已运行过的 UI
	#>
	New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force

	<#
		.分配 1 ：需要挂载项，主键
	#>
	New-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
	New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
	New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -Value @() -Force
}

<#
	.Reset suggestions: custom
	.重置建议项：自定义
#>
Function Event_Reset_Suggest_Custom
{
	param
	(
		$NewMaster,
		$NewImageFileName
	)

	<#
		.分配已运行过的 UI
	#>
	New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($NewMaster)_$($NewImageFileName)" -Value @() -Force

	<#
		.分配 1 ：需要挂载项，主键
	#>
	New-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($NewMaster)_$($NewImageFileName)" -Value @() -Force
	New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_$($NewMaster)_$($NewImageFileName)" -Value @() -Force
	New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($NewMaster)_$($NewImageFileName)" -Value @() -Force
}

<#
	.Reset variables
	.重置变量
#>
Function Event_Reset_Variable
{
	param
	(
		[switch]$Silent,
		$IsNoRefresh,
		$Init
	)

	if (-not $Silent) {
		Write-Host "`n  $($lang.EventManagerClear)"
		Write-Host "  $($lang.AllClear): " -NoNewline
	}


	if ($Global:AutopilotMode) {
		$EventMaps = "Queue"

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "NoProcess" -String
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False" -String
	}

	if ($Global:EventQueueMode) {
		$EventMaps = "Queue"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$EventMaps = "Assign"
	}

	if ($IsNoRefresh -eq "Yes") {
		<#
			.Reset all suggested content
			.重置所有建议内容
		#>
		Event_Track -Del
		Event_Reset_Suggest

		<#
			.On-demand batch mode
			.按需批量模式
		#>
		$Global:EventQueueMode = $False
		$Global:AutopilotMode = $False
	}

	<#
		.Create a multitasking dynamic variable group
		.创建多任务动态变量组
	#>
	New-Variable -Scope global -Name "Queue_Is_Solutions_ISO" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_ISO" -Value $False -Force
	New-Variable -Scope global -Name "SolutionsSoftwarePacker_ISO" -Value $False -Force
	New-Variable -Scope global -Name "SolutionsUnattend_ISO" -Value $False -Force

	$Global:Function_Unrestricted = @()

	<#
		.分配 2 ：无需要挂载项
	#>
	$Global:Queue_Assign_Not_Monuted_Primary = @()
	$Global:Queue_Assign_Not_Monuted_Expand = @()
	$Global:Queue_Assign_Not_Monuted_Expand_Select = @()

	<#
		.清除有可用事件时
	#>
	$Global:Queue_Assign_Available = @()
	$Global:Queue_Assign_Available_Select = @()

	<#
		.清除全部主任务
	#>
	$Global:Queue_Assign_Full = @()

	$Global:QueueConvert = $False                              # 转换映像
	$Global:Queue_Convert_Tasks = @()                          # 转换映像

	# 等待时间
	$Global:QueueWaitTime = @{
		IsEnabled = $false
		Sky = 0
		Time = 0
		Minute = 30
	}

	# Print
	$Global:Queue_ISO = $False                                 # 生成 ISO
	$Global:Queue_ISO_Associated = $False                      # 关联 ISO 方案
	$Global:Queue_ISO_Associated_Tasks = @()

	Event_Reset_Specified_Variable -Init $init

	if (-not $Silent) {
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	}
}

Function Event_Reset_Specified_Variable
{
	param
	(
		$Tasks,
		$IsNoRefresh,
		$Init
	)

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			if ($Tasks -notcontains $item.main.Uid) {
				Event_Reset_Suggest_Custom -NewMaster $item.main.ImageFileName -NewImageFileName $item.main.ImageFileName
				Event_Need_Mount_Global_Variable -DevQueue "3" -Master $item.main.ImageFileName -ImageFileName $item.main.ImageFileName -IsNoRefresh $IsNoRefresh -Init $Init
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($itemExpandNew in $item.Expand) {
					if ($Tasks -notcontains $itemExpandNew.Uid) {
						Event_Reset_Suggest_Custom -NewMaster $item.main.ImageFileName -NewImageFileName $itemExpandNew.ImageFileName
						Event_Need_Mount_Global_Variable -DevQueue "3" -Master $item.main.ImageFileName -ImageFileName $itemExpandNew.ImageFileName -IsNoRefresh $IsNoRefresh -Init $Init

						<#
							.扩展项：高级功能
						#>
							<#
								.保存，扩展项
							#>
							New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force
							New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force

							<#
								.不保存，扩展项
							#>
							New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force
							New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force

							<#
								.重建映像
							#>
							New-Variable -Scope global -Name "Queue_Expand_Rebuild_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force

							<#
								.健康
							#>
							New-Variable -Scope global -Name "Queue_Expand_Healthy_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force

						<#
							。弹出后更新，已过时
						#>
						<#
							.允许更新规则
						#>
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force

						<#
							.更新规则同步到所有索引号
						#>
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_To_All_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value $False -Force
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($item.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value @() -Force
					}
				}
			}
		}
	}
}


Function Event_Need_Mount_Global_Variable
{
	param
	(
		$DevQueue,
		$Master,
		$ImageFileName,
		$IsNoRefresh,
		$Init
	)

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n   Event_Need_Mount_Global_Variable, $($Master)_$($ImageFileName), $($lang.Developers_Mode_Location): $($DevQueue)"
	}

	if ($IsNoRefresh -eq "Yes") {
		<#
			.保存已选择的映像源
		#>
		New-Variable -Scope global -Name "Queue_Process_Image_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.待批量处理的映像源
		#>
		New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Master)_$($ImageFileName)" -Value @() -Force
	}

	<#
		.保存到指定目录
	#>
	if ($Init -eq "Yes") {
		New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Master)_$($ImageFileName)" -Value "$($Global:Image_source)_Custom\$($Master)\$($ImageFileName)\Report" -Force
	}

	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Master)_$($ImageFileName)" -ErrorAction SilentlyContinue).Value
	if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
		New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Master)_$($ImageFileName)" -Value "$($Global:Image_source)_Custom\$($Master)\$($ImageFileName)\Report" -Force
	}

	<#
		.Build the solution
		.生成解决方案
	#>
	New-Variable -Scope global -Name "Queue_Is_Solutions_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			判断是否启用并添加软件包
		#>
		New-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "DeployFonts_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			开启并添加应预答
		#>
		New-Variable -Scope global -Name "SolutionsUnattend_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			打开主引擎总添加方案
		#>
		New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "DeployOfficeVersion_$($Master)_$($ImageFileName)" -Value "2024" -Force
		New-Variable -Scope global -Name "QueueDeployLanguageExclue_$($Master)_$($ImageFileName)" -Value "" -Force
		New-Variable -Scope global -Name "QueueDeployLanguageExclueFull_$($Master)_$($ImageFileName)" -Value "" -Force
		New-Variable -Scope global -Name "QueueDeploySelect_$($Master)_$($ImageFileName)" -Value "" -Force

	<#
		.主要：Windows 功能
	#>
	New-Variable -Scope global -Name "Queue_Is_Feature_Enable_Match_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Feature_Enable_Match_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	New-Variable -Scope global -Name "Queue_Is_Feature_Enable_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Feature_Enable_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	New-Variable -Scope global -Name "Queue_Is_Feature_Disable_Match_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Is_Feature_Disable_Match_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		New-Variable -Scope global -Name "Queue_Is_Feature_Disable_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Feature_Disable_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force
 
	<#
		.InBox Apps
	#>
		<#
			.本地语言体验包（LXPs）,标记
		#>
		New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.本地语言体验包（LXPs），标记，用户自选项
		#>
		New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.本地语言体验包（LXPs）,标记, 用户选择主要来源路径
		#>
#		New-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_Select_Sources_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.添加本地语言体验包 (LXPs)：更新
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.添加本地语言体验包 (LXPs)：更新, 用户选择主要来源路径
			#>
#			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_Select_Sources_$($Master)_$($ImageFileName)" -Value "" -Force

		<#
			.删除本地语言体验包 (LXPs)
		#>
		New-Variable -Scope global -Name "Queue_Is_LXPs_Delete_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.按匹配规则删除 InBox Apps 预安装软件
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Match_Rule_Delete_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.离线删除已安装的 InBox Apps 预安装软件
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Mount_Rule_Delete_$($Master)_$($ImageFileName)" -Value $False -Force

			<#
				.离线删除已安装的 InBox Apps 预安装软件, 用户选择主要来源路径
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Mount_Rule_Delete_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.InBox Apps: 添加
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Master)_$($ImageFileName)" -Value $False -Force

			<#
				.InBox Apps: 添加, 应用程序
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_List_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 来源
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Select_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 规则，读取所有应用程序完整的配置
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Rule_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 用户选择的应用程序
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 未选择的应用程序
			#>
#			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Select_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 用户选择的群
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Group_Install_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 依赖
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Dependency_$($Master)_$($ImageFileName)" -Value @() -Force

			<#
				.InBox Apps: 添加, 未选择依赖
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_Not_Dependency_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			InBox Apps: 添加，可选功能	
		#>
			<#
				.遇到错误时不允许保存
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_IsAllow_Error_$($Master)_$($ImageFileName)" -Value $true -Force

			<#
				.自动根据映像版本分配应用程序
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Auto_Assign_Editions_$($Master)_$($ImageFileName)" -Value $true -Force

			<#
				.自动从所有磁盘搜索缺少的软件包
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Missing_Packer_$($Master)_$($ImageFileName)" -Value $true -Force

			<#
				.安装 InBox Apps 应用时，允许自动组合依赖包
			#>
			New-Variable -Scope global -Name "Queue_Is_InBox_Apps_DependencyPackage_$($Master)_$($ImageFileName)" -Value $true -Force

		<#
			.打印 InBox Apps
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.打印 InBox Apps 到 当前
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.优化预配 Appx 包，通过用硬链接替换相同的文件
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.清理旧的所有软件包
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.清理旧的所有软件包，规则
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_Allow_Rule_$($Master)_$($ImageFileName)" -Value $True -Force

		<#
			.跳过本地语言体验包 ( LXPs ) 添加，执行其它
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_LXPs_Add_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.安装时跳过 en-US 添加，建议
		#>
		New-Variable -Scope global -Name "Queue_Is_InBox_Apps_Skip_English_$($Master)_$($ImageFileName)" -Value $True -Force

	<#
		.添加驱动
	#>
	New-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Drive_Add_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.删除驱动
	#>
	New-Variable -Scope global -Name "Queue_Is_Drive_Delete_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Drive_Delete_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.报告：驱动 到 LOG
	#>
	New-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.报告：驱动 到 当前
	#>
	New-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.添加语言
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Add_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Add_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

		<#
			.按预规则顺序安装语言包
		#>
		New-Variable -Scope global -Name "Queue_Is_Language_Add_Category_$($Master)_$($ImageFileName)" -Value $True -Force

		<#
			.安装语言包时，从已安装列表里通配
		#>
		New-Variable -Scope global -Name "Queue_Is_Is_Match_installed_$($Master)_$($ImageFileName)" -Value $True -Force

	<#
		.同步语言包到安装程序
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Del_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.重建 Lang.ini
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Del_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.删除语言
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Del_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Del_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Del_Reverse_Order_$($Master)_$($ImageFileName)" -Value $true -Force

	<#
		.语言更改
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Change_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.清理组件
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.报告：映像语言
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.报告：组件 到 LOG
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.报告：组件 到 当前
	#>
	New-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.添加更新
	#>
	New-Variable -Scope global -Name "Queue_Is_Update_Add_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Is_Update_Add_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.删除更新
	#>
	New-Variable -Scope global -Name "Queue_Is_Update_Del_$($Master)_$($ImageFileName)" -Value $False -Force
		New-Variable -Scope global -Name "Queue_Is_Update_Del_Custom_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.固化更新
	#>
	New-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.清理取代的
	#>
	New-Variable -Scope global -Name "Queue_Superseded_Clean_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.清理取代的，规则
	#>
	New-Variable -Scope global -Name "Queue_Superseded_Clean_Allow_Rule_$($Master)_$($ImageFileName)" -Value $True -Force

	<#
		.健康
	#>
	New-Variable -Scope global -Name "Queue_Healthy_$($Master)_$($ImageFileName)" -Value $False -Force

		<#
			.健康，不保存
		#>
#		New-Variable -Scope global -Name "Queue_Healthy_Dont_Save_$($Master)_$($ImageFileName)" -Value $True -Force

	<#
		.运行 PowerShell 函数
	#>
	# 运行前
	New-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	# 运行后
	New-Variable -Scope global -Name "Queue_Functions_Rear_Select_$($Master)_$($ImageFileName)" -Value @() -Force

	<#
		.重建映像
	#>
#	New-Variable -Scope global -Name "Queue_Rebuild_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.清除选择索引号类型
	#>
	New-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Master)_$($ImageFileName)" -Value "Auto" -Force

	<#
		.保存
	#>
	New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($Master)_$($ImageFileName)" -Value $False -Force

	<#
		.不保存
	#>
	New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Master)_$($ImageFileName)" -Value $False -Force
	New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($Master)_$($ImageFileName)" -Value $False -Force
}