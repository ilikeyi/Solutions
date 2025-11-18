<#
	.判断已分配的事件，是否有需要执行的
#>
Function Event_Assign_Task_Verify
{
	param
	(
		[switch]$Mount,
		[switch]$Eject,
		[switch]$ALL
	)

	$FlagIsWait = $False

	if ($Mount) {
		<#
			.生成解决方案
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.语言添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.语言删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.更改映像语言
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Change_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.清理组件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.自动修复安装程序缺少项：已挂载
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Setup_Fix_Missing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.同步语言包到安装程序：添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.同步语言包到安装程序：删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Sync_To_ISO_Sources_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.重建 lang.ini：添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.重建 lang.ini：删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_INI_Rebuild_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.打印：软件列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.查看：软件列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Components_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.打印：映像语言
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Language_Report_Image_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.Windows 功能：启用，匹配
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Enable_Match_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.Windows 功能：启用
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Enable_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.Windows 功能：禁用，匹配
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Disable_Match_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.Windows 功能：禁用
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Feature_Disable_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.本地语言体验包：标记
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_LXPs_Region_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True

			<#
				.强行删除已安装的所有预应用程序 ( InBox Apps )
			#>
			if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Clear_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
				$FlagIsWait = $True
			}
		}

		<#
			.本地语言体验（LXPs），添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.本地语言体验（LXPs），更新
		#>
		$Temp_Queue_Is_InBox_Apps_Update = (Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Update_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Queue_Is_InBox_Apps_Update.Count -gt 0) {
			$FlagIsWait = $True
		}

		<#
			.本地语言体验（LXPs），删除
		#>
		$Temp_LXPs_Delete = (Get-Variable -Scope global -Name "Queue_Is_LXPs_Delete_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_LXPs_Delete.Count -gt 0) {
			$FlagIsWait = $true
		}

		<#
			.按匹配规则删除 InBox Apps 预安装软件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Match_Rule_Delete_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.离线删除已安装的 InBox Apps 预安装软件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Mount_Rule_Delete_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.打印：InBox Apps 预安装应用列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.查看：InBox Apps 预安装应用列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.优化预配 Appx 包，通过用硬链接替换相同的文件
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_InBox_Apps_Optimize_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.更新添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.更新删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Del_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.固化更新
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Update_Curing_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True 
		}

		<#
			.驱动添加
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Add_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.驱动删除
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Delete_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.报告：打印：驱动列表
		#>
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_Logs_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}
		if ((Get-Variable -Scope global -Name "Queue_Is_Drive_Report_View_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.运行 PowerShell 函数：有任务前
		#>
		$Temp_Functions_Before_Task = (Get-Variable -Scope global -Name "Queue_Functions_Before_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Functions_Before_Task.Count -gt 0) {
			$FlagIsWait = $True
		}

		<#
			.运行 PowerShell 函数：完成任务后
		#>
		$Temp_Functions_Rear_Task = (Get-Variable -Scope global -Name "Queue_Functions_Rear_Select_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Functions_Rear_Task.Count -gt 0) {
			$FlagIsWait = $True
		}

		<#
			.清理取代的
		#>
		if ((Get-Variable -Scope global -Name "Queue_Superseded_Clean_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		<#
			.健康
		#>
		if ((Get-Variable -Scope global -Name "Queue_Healthy_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}
	}

	if ($Eject) {
		# 保存
		if ((Get-Variable -Scope global -Name "Queue_Eject_Only_Save_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}

		# 不保存后弹出
		if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			$FlagIsWait = $True
		}
	}

	if ($All) {
		if ($Global:QueueConvert) { $FlagIsWait = $True }
		if ($Global:Queue_ISO) { $FlagIsWait = $True }
		if ($Global:Queue_ISO_Associated) { $FlagIsWait = $True }
	}

	return $FlagIsWait
}


<#
	1、判断当前是否已选择 Install，boot, WinRE

	2、判断是否与当前选择的匹配，已挂载
#>
Function Verify_Is_Current_Same
{
	<#
		.判断是否选择 Install，Boot
	#>
	if ([string]::IsNullOrEmpty($Global:Primary_Key_Image.ImageFileName)) {
	} else {
		if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			return $True
		}
	}

	return $False
}

<#
	判断是否有挂载任务：其中一项。
#>
Function Image_Is_Mount
{
	ForEach ($item in $Global:Image_Rule) {
		if ((Get-Variable -Name "Mark_Is_Mount_$($item.Main.ImageFileName)_$($item.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
			return $True
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ((Get-Variable -Name "Mark_Is_Mount_$($item.Main.ImageFileName)_$($Expand.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					return $True
				}
			}
		}
	}

	return $False
}

<#
	判断是否有挂载任务：指定
#>
Function Image_Is_Mount_Specified
{
	param
	(
		$Master,
		$ImageFileName
	)

	if ((Get-Variable -Name "Mark_Is_Mount_$($Master)_$($ImageFileName)" -ErrorAction SilentlyContinue).Value) {
		return $True
	}

	return $False
}

<#
	.检查是否选择映像：install，boot, WinRE
#>
Function Image_Is_Select_IAB
{
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:Primary_Key_Image.Uid -eq $item.Main.Uid) {
			return $True
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Global:Primary_Key_Image.Uid -eq $Expand.Uid) {
					return $True
				}
			}
		}
	}

	return $False
}

Function Image_Is_Select_Boot
{
	if ($Global:Primary_Key_Image.Uid -eq "boot;boot;wim;") {
		return $True
	}

	return $False
}

Function Image_Is_Select_Install
{
	if ($Global:Primary_Key_Image.Uid -eq "install;install;wim;") {
		return $True
	}

	return $False
}