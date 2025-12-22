<#
	.Reset suggestions
	.重置建议项
#>
Function Event_Reset_Suggest
{
	$Global:EventProcessGuid = [guid]::NewGuid()

	$GroupSuggest = @(
		"Queue_Assign_Has_Been_Run"                  # 分配已运行过的 UI
		"Queue_Is_Mounted_Primary_Assign_Task"       # 需要挂载项，主键
		"Queue_Is_Mounted_Expand_Assign_Task"
		"Queue_Is_Mounted_Expand_Assign_Task_Select"
	)

	foreach ($item in $GroupSuggest) {
		New-Variable -Scope global -Name "$($item)_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
	}
}

<#
	.Reset suggestions: custom
	.重置建议项：自定义
#>
Function Event_Reset_Suggest_Custom
{
	param
	(
		$Uid
	)

	$GroupSuggest = @(
		"Queue_Assign_Has_Been_Run"                  # 分配已运行过的 UI
		"Queue_Is_Mounted_Primary_Assign_Task"       # 需要挂载项，主键
		"Queue_Is_Mounted_Expand_Assign_Task"
		"Queue_Is_Mounted_Expand_Assign_Task_Select"
	)

	foreach ($item in $GroupSuggest) {
		New-Variable -Scope global -Name "$($item)_$($Uid)" -Value @() -Force
	}
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
		$Scope
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

	if ($Scope -contains "NoRefresh") {
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

	Event_Reset_Specified_Variable -Scope "Init"

	if (-not $Silent) {
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	}
}

Function Event_Reset_Specified_Variable
{
	param
	(
		$Tasks,
		$Scope
	)

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			if ($Tasks -notcontains $item.main.Uid) {
				Event_Reset_Suggest_Custom -Uid $item.main.Uid
				Event_Need_Mount_Global_Variable -DevQueue "3999" -Uid $item.main.Uid -Master $item.main.ImageFileName -MasterSuffix $item.main.Suffix -ImageFileName $item.main.ImageFileName -Suffix $item.main.Suffix -Scope $Scope
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($itemExpandNew in $item.Expand) {
					if ($Tasks -notcontains $itemExpandNew.Uid) {
						Event_Reset_Suggest_Custom -Uid $itemExpandNew.Uid
						Event_Need_Mount_Global_Variable -DevQueue "3sss" -Uid $itemExpandNew.Uid -Master $item.main.ImageFileName -MasterSuffix $item.main.Suffix -ImageFileName $itemExpandNew.ImageFileName -Suffix $itemExpandNew.Suffix -Scope $Scope

						<#
							.扩展项：高级功能
						#>
							<#
								.保存，扩展项
							#>
							New-Variable -Scope global -Name "Queue_Eject_Only_Save_$($itemExpandNew.Uid)" -Value $False -Force
							New-Variable -Scope global -Name "Queue_Expand_Eject_Only_Save_$($itemExpandNew.Uid)" -Value $False -Force

							<#
								.不保存，扩展项
							#>
							New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($itemExpandNew.Uid)" -Value $False -Force
							New-Variable -Scope global -Name "Queue_Expand_Eject_Do_Not_Save_$($itemExpandNew.Uid)" -Value $False -Force

							<#
								.重建映像
							#>
							New-Variable -Scope global -Name "Queue_Expand_Rebuild_$($itemExpandNew.Uid)" -Value $False -Force

							<#
								.健康
							#>
							New-Variable -Scope global -Name "Queue_Expand_Healthy_$($itemExpandNew.Uid)" -Value $False -Force

						<#
							。弹出后更新，已过时
						#>
						<#
							.允许更新规则
						#>
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_$($itemExpandNew.Uid)" -Value $False -Force

						<#
							.更新规则同步到所有索引号
						#>
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_To_All_$($itemExpandNew.Uid)" -Value $False -Force
#						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($itemExpandNew.Uid)" -Value @() -Force
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
		$Uid,
		$Master,
		$MasterSuffix,
		$ImageFileName,
		$Suffix,
		$Scope
	)

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n   Event_Need_Mount_Global_Variable, $($Uid), $($lang.Developers_Mode_Location): $($DevQueue)"
	}

	if ($Scope -contains "NoRefresh") {
		<#
			.保存已选择的映像源
		#>
		New-Variable -Scope global -Name "Queue_Process_Image_Select_$($Uid)" -Value @() -Force

		<#
			.待批量处理的映像源
		#>
		New-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Uid)" -Value @() -Force
	}

	<#
		.保存到指定目录
	#>
	if ($Scope -contains "Init") {
		New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Uid)" -Value "$(Get_MainMasterFolder)\$($Master)\$($ImageFileName)\Report" -Force
	}

	$Temp_Expand_Rule = (Get-Variable -Scope global -Name "Queue_Export_SaveTo_$($Uid)" -ErrorAction SilentlyContinue).Value
	if (([string]::IsNullOrEmpty($Temp_Expand_Rule))) {
		New-Variable -Scope global -Name "Queue_Export_SaveTo_$($Uid)" -Value "$(Get_MainMasterFolder)\$($Master)\$($ImageFileName)\Report" -Force
	}

	$GroupSuggest = @(
		@{ Name = "Queue_Is_Solutions";      Setting = $False; } # 生成解决方案

		# 判断是否启用并添加软件包
		@{ Name = "SolutionsSoftwarePacker"; Setting = $False; }
		@{ Name = "DeployFonts";             Setting = $False; }
		@{ Name = "SolutionsUnattend";                                  Setting = $False; } # 开启并添加应预答

		# 打开主引擎总添加方案
		@{ Name = "Queue_Is_Solutions_Engine"; Setting = $False; }
		@{ Name = "DeployOfficeVersion"; Setting = "2024"; }
		@{ Name = "QueueDeployLanguageExclue"; Setting = ""; }
		@{ Name = "QueueDeploySelect"; Setting = ""; }

		@{ Name = "Queue_Is_Feature_Enable";                             Setting = $False; } # Windows 功能启用
		@{ Name = "Queue_Is_Feature_Enable_Custom_Select";               Setting = @(); }    # Windows 功能启用，用户选择
		@{ Name = "Queue_Is_Feature_Enable_Match";                       Setting = $False; } # Windows 功能启用，匹配
		@{ Name = "Queue_Is_Feature_Enable_Match_Custom_Select";         Setting = @(); }    # Windows 功能启用，匹配，用户选择
		@{ Name = "Queue_Is_Feature_Disable";                            Setting = $False; } # Windows 功能禁用
		@{ Name = "Queue_Is_Feature_Disable_Custom_Select";              Setting = @(); }    # Windows 功能禁用，用户选择
		@{ Name = "Queue_Is_Feature_Disable_Match";                      Setting = $False; } # Windows 功能禁用，匹配
		@{ Name = "Queue_Is_Feature_Disable_Match_Custom_Select";        Setting = @(); }    # Windows 功能禁用，匹配，用户选择
		@{ Name = "Queue_Is_LXPs_Region_Add";                            Setting = $False; } # 本地语言体验包（LXPs）,标记
		@{ Name = "Queue_Is_LXPs_Region_Add_Custom_Select";              Setting = @(); }    # 本地语言体验包（LXPs），标记，用户自选项
		@{ Name = "Queue_Is_LXPs_Region_Add_Select_Sources";             Setting = @(); }    # 本地语言体验包（LXPs）,标记, 用户选择主要来源路径
		@{ Name = "Queue_Is_InBox_Apps_Update";                          Setting = @(); }    # 添加本地语言体验包 (LXPs)：更新
#		@{ Name = "Queue_Is_InBox_Apps_Update_Select_Sources";           Setting = @(); }    # 添加本地语言体验包 (LXPs)：更新, 用户选择主要来源路径
		@{ Name = "Queue_Is_LXPs_Delete";                                Setting = @(); }    # 删除本地语言体验包 (LXPs)
		@{ Name = "Queue_Is_InBox_Apps_Match_Rule_Delete";               Setting = @(); }    # 按匹配规则删除 InBox Apps 预安装软件
		@{ Name = "Queue_Is_InBox_Apps_Mount_Rule_Delete";               Setting = $False; } # 离线删除已安装的 InBox Apps 预安装软件
		@{ Name = "Queue_Is_InBox_Apps_Mount_Rule_Delete_Custom_Select"; Setting = @(); }    # 离线删除已安装的 InBox Apps 预安装软件, 用户选择主要来源路径
		@{ Name = "Queue_Is_InBox_Apps_Add";                       Setting = $False; } # InBox Apps: 添加
		@{ Name = "Queue_Is_InBox_Apps_List";                      Setting = @(); }       # 应用程序
		@{ Name = "Queue_Is_InBox_Apps_Add_Select";                Setting = @(); }       # 来源
		@{ Name = "Queue_Is_InBox_Apps_Add_Rule";                  Setting = @(); }       # 规则，读取所有应用程序完整的配置
		@{ Name = "Queue_Is_InBox_Apps_Add_Custom_Select";         Setting = @(); }       # 用户选择的应用程序
#		@{ Name = "Queue_Is_InBox_Apps_Add_Not_Select";            Setting = @(); }       # 未选择的应用程序
		@{ Name = "Queue_Is_InBox_Apps_Add_Group_Install";         Setting = @(); }       # 用户选择的群
		@{ Name = "Queue_Is_InBox_Apps_Add_Dependency";            Setting = @(); }       # 依赖
		@{ Name = "Queue_Is_InBox_Apps_Add_Not_Dependency_Select"; Setting = @(); }       # 未选择依赖
		@{ Name = "Queue_Is_InBox_Apps_IsAllow_Error";             Setting = $True; }     # 遇到错误时不允许保存
		@{ Name = "Queue_Is_InBox_Apps_Auto_Assign_Editions";  Setting = $True; }         # 自动根据映像版本分配应用程序
		@{ Name = "Queue_Is_InBox_Apps_Missing_Packer";        Setting = $True; }         # 自动从所有磁盘搜索缺少的软件包
		@{ Name = "Queue_Is_InBox_Apps_DependencyPackage";     Setting = $True; }         # 安装 InBox Apps 应用时，允许自动组合依赖包
		@{ Name = "Queue_Is_InBox_Apps_Report_Logs";           Setting = $False; }        # 打印 InBox Apps
		@{ Name = "Queue_Is_InBox_Apps_Report_View";           Setting = $False; }        # 打印 InBox Apps 到 当前
		@{ Name = "Queue_Is_InBox_Apps_Optimize";              Setting = $False; }        # 优化预配 Appx 包，通过用硬链接替换相同的文件
		@{ Name = "Queue_Is_InBox_Apps_Clear";                 Setting = $False; }        # 清理旧的所有软件包
		@{ Name = "Queue_Is_InBox_Apps_Clear_Allow_Rule";      Setting = $True; }         # 清理旧的所有软件包，规则
		@{ Name = "Queue_Is_InBox_Apps_Skip_LXPs_Add";         Setting = $False; }        # 跳过本地语言体验包 ( LXPs ) 添加，执行其它
		@{ Name = "Queue_Is_InBox_Apps_Skip_English";          Setting = $True; }         # 安装时跳过 en-US 添加，建议
		@{ Name = "Queue_Is_Drive_Add";                        Setting = $False; }    # 添加驱动
		@{ Name = "Queue_Is_Drive_Add_Custom_Select";          Setting = @(); }       # 添加驱动
		@{ Name = "Queue_Is_Drive_Delete";                     Setting = $False; }    # 删除驱动
		@{ Name = "Queue_Is_Drive_Delete_Custom_Select";       Setting = @(); }       # 删除驱动
		@{ Name = "Queue_Is_Drive_Report_Logs";                Setting = $False; }    # 报告：驱动 到 LOG
		@{ Name = "Queue_Is_Drive_Report_View";                Setting = $False; }    # 报告：驱动 到 当前
		@{ Name = "Queue_Is_Language_Add";                     Setting = $False; }    # 添加语言
		@{ Name = "Queue_Is_Language_Add_Custom_Select";       Setting = @(); }       # 添加语言
		@{ Name = "Queue_Is_Language_Add_Category";            Setting = $True; }     # 按预规则顺序安装语言包
		@{ Name = "Queue_Is_Is_Match_installed";               Setting = $True; }     # 安装语言包时，从已安装列表里通配
		@{ Name = "Queue_Is_Language_Sync_To_ISO_Sources_Add"; Setting = $False; }    # 同步语言包到安装程序：添加
		@{ Name = "Queue_Is_Language_Sync_To_ISO_Sources_Del"; Setting = $False; }    # 同步语言包到安装程序：删除
		@{ Name = "Queue_Is_Language_INI_Rebuild_Add";         Setting = $False; }    # 重建 Lang.ini：添加
		@{ Name = "Queue_Is_Language_INI_Rebuild_Del";         Setting = $False; }    # 重建 Lang.ini：删除
		@{ Name = "Queue_Is_Language_Del";                     Setting = $False; }    # 删除语言
		@{ Name = "Queue_Is_Language_Del_Custom_Select";       Setting = @(); }       # 删除语言
		@{ Name = "Queue_Is_Language_Del_Reverse_Order";       Setting = $True; }     # 删除语言
		@{ Name = "Queue_Is_Language_Change";                  Setting = $False; }    # 语言更改
		@{ Name = "Queue_Is_Language_Components_Clean";        Setting = $False; }    # 清理组件
		@{ Name = "Queue_Is_Language_Components_Clean_Custom_Select"; Setting = @(); } # 清理组件
		@{ Name = "Queue_Is_Language_Report_Image";           Setting = $False; }     # 报告：映像语言
		@{ Name = "Queue_Is_Language_Components_Report_Logs"; Setting = $False; }     # 报告：组件 到 LOG
		@{ Name = "Queue_Is_Language_Components_Report_View"; Setting = $False; }     # 报告：组件 到 当前
		@{ Name = "Queue_Is_Update_Add";                      Setting = $False; }     # 添加更新
		@{ Name = "Queue_Is_Update_Add_Custom_Select";        Setting = @(); }        # 添加更新
		@{ Name = "Queue_Is_Update_Del";                      Setting = $False; }     # 删除更新
		@{ Name = "Queue_Is_Update_Del_Custom_Select";        Setting = @(); }        # 删除更新
		@{ Name = "Queue_Is_Update_Curing";                   Setting = $False; }     # 固化更新
		@{ Name = "Queue_Superseded_Clean";                   Setting = $False; }     # 清理取代的
		@{ Name = "Queue_Superseded_Clean_Allow_Rule";        Setting = $True; }      # 清理取代的，规则
		@{ Name = "Queue_Healthy";                            Setting = $False; }     # 健康
		@{ Name = "Queue_Healthy_Dont_Save";                  Setting = $True; }      # 健康，不保存
		@{ Name = "Queue_Functions_Before_Select";            Setting = @(); }        # 运行 PowerShell 函数 运行前
		@{ Name = "Queue_Functions_Rear_Select";              Setting = @(); }        # 运行 PowerShell 函数 运行后
		@{ Name = "Queue_Rebuild";                            Setting = $False; }     # 重建映像
		@{ Name = "Queue_Process_Image_Select_Is_Type";       Setting = "Auto"; }     # 清除选择索引号类型
		@{ Name = "Queue_Eject_Only_Save";                    Setting = $False; }     # 保存
		@{ Name = "Queue_Expand_Eject_Only_Save";             Setting = $False; }     # 保存
		@{ Name = "Queue_Eject_Do_Not_Save";                  Setting = $False; }     # 不保存
		@{ Name = "Queue_Expand_Eject_Do_Not_Save";           Setting = $False; }     # 不保存
	)

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EF99xx00s`n  Start"
	}

	foreach ($item in $GroupSuggest) {
		New-Variable -Scope global -Name "$($item.Name)_$($Uid)" -Value $item.Setting -Force

		if ($Global:Developers_Mode) {
			Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
			write-host "$($item.Name)_$($Uid)" -ForegroundColor Green

			Write-Host "  $($lang.Setting): " -NoNewline -ForegroundColor Yellow
			write-host $item.Setting -ForegroundColor Green
			Write-Host
		}
	}

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): EF99xx00s`n  End"
	}
}