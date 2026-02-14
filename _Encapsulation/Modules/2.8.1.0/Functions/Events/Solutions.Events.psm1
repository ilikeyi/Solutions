<#
	.Assign available event preconfigurations
	.分配可用事件预配置

	1、需要挂载后才能操作
	   -----------------------------------------------------------------
		Solutions_Create_UI                   # 解决方案：创建
		Cumulative_updates_Add_UI             # 累积更新：添加
		Cumulative_updates_Delete_UI          # 累积更新：删除
		Language_Add_UI                       # 语言：添加
		Language_Delete_UI                    # 语言：删除
		Language_Change_UI                    # 语言：更改
		Language_Cleanup_Components_UI        # 语言：清理组件
		LXPs_Region_Add                       # 本地语言体验包 ( LXPs ): 添加
		InBox_Apps_Add_UI                     # InBox Apps：添加
		LXPs_Update_UI                        # 本地语言体验包 ( LXPs )：更新或删除
		InBox_Apps_Offline_Delete_UI          # InBox Apps：添加
		InBox_Apps_Match_Delete_UI            # InBox Apps：添加
		Drive_Add_UI                          # 驱动：添加
		Drive_Delete_UI                       # 驱动：删除
		Feature_Disable_UI                    # Windows 功能：禁用
		Feature_Enabled_UI                    # Windows 功能：开户
		Functions_Before_UI                   # 函数：有任务运行前
		Functions_Rear_UI                     # 函数：完成任务后

	2、无需挂载项
	   -----------------------------------------------------------------
		Solutions_Create_UI                   # 解决方案：创建
		Image_Convert_UI                      # 映像转换
		ISO_Create_UI                         # 生成 ISO

	3、有任务，完成后事件
	   -----------------------------------------------------------------
		Event_Completion_Setting_UI           # 完成后关机
		Event_Completion_Start_Setting_UI     # 从什么时候开始

	4、其它
	   -----------------------------------------------------------------
		Image_Eject_UI                        # 弹出：保存、不保存（支持扩展项）

#>
Function Event_Assign
{
	param
	(
		[switch]$Run,
		$Rule
	)

	$Global:Temp_Set_Need_Mounted_Primary = @(
		@{
			Uid         = "Additional_Edition_UI"
			IsMounted   = @{
				Primary = ""
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = "Additional_Edition_UI"
				Expand  = @(
					"Image_Convert_UI"
					"ISO_Create_UI"
				)
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Current"
			IsMounted   = @{
				Primary = "Solutions_Create_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Solutions_Create_UI"
			IsMounted   = @{
				Primary = "Solutions_Create_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @(
					"ISO_Create_UI"
				)
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Cumulative_updates_Add_UI"
			IsMounted   = @{
				Primary = "Cumulative_updates_Add_UI"
				Expand  = @(
					"Cumulative_updates_Delete_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Cumulative_updates_Delete_UI"
			IsMounted   = @{
				Primary = "Cumulative_updates_Delete_UI"
				Expand  = @(
					"Cumulative_updates_Add_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Language_Cleanup_Components_UI"
			IsMounted   = @{
				Primary = "Language_Cleanup_Components_UI"
				Expand  = @(
					"Language_Add_UI"
					"Language_Delete_UI"
					"Language_Change_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Language_Add_UI"
			IsMounted   = @{
				Primary = "Language_Add_UI"
				Expand  = @(
					"Language_Delete_UI"
					"Language_Change_UI"
					"Language_Cleanup_Components_UI"
					"Cumulative_updates_Add_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Language_Delete_UI"
			IsMounted   = @{
				Primary = "Language_Delete_UI"
				Expand  = @(
					"Language_Add_UI"
					"Language_Change_UI"
					"Language_Cleanup_Components_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Language_Change_UI"
			IsMounted   = @{
				Primary = "Language_Change_UI"
				Expand  = @(
					"Language_Add_UI"
					"Language_Delete_UI"
					"Language_Cleanup_Components_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Drive_Add_UI"
			IsMounted   = @{
				Primary = "Drive_Add_UI"
				Expand  = @(
					"Drive_Delete_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Drive_Delete_UI"
			IsMounted   = @{
				Primary = "Drive_Delete_UI"
				Expand  = @(
					"Drive_Add_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Feature_Enabled_UI"
			IsMounted   = @{
				Primary = "Feature_Enabled_UI"
				Expand  = @(
					"Feature_Disable_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Feature_Disable_UI"
			IsMounted   = @{
				Primary = "Feature_Disable_UI"
				Expand  = @(
					"Feature_Enabled_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "LXPs_Region_Add"
			IsMounted   = @{
				Primary = "LXPs_Region_Add"
				Expand  = @(
					"InBox_Apps_Add_UI"
					"LXPs_Update_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "InBox_Apps_Add_UI"
			IsMounted   = @{
				Primary = "InBox_Apps_Add_UI"
				Expand  = @(
					"LXPs_Update_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"ISO_Create_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "LXPs_Update_UI"
			IsMounted   = @{
				Primary = "LXPs_Update_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "LXPs_Remove_UI"
			IsMounted   = @{
				Primary = "LXPs_Remove_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "InBox_Apps_Offline_Delete_UI"
			IsMounted   = @{
				Primary = "InBox_Apps_Offline_Delete_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "InBox_Apps_Match_Delete_UI"
			IsMounted   = @{
				Primary = "InBox_Apps_Match_Delete_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Image_Eject_UI"
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Eject"
			IsMounted   = @{
				Primary = "Image_Eject_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Image_Convert_UI"
			IsMounted   = @{
				Primary = ""
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = "Image_Convert_UI"
				Expand  = @(
					"ISO_Create_UI"
				)
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "ISO_Create_UI"
			IsMounted   = @{
				Primary = ""
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = "ISO_Create_UI"
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Feature_More_UI"
			IsMounted   = @{
				Primary = "Feature_More_UI"
				Expand  = @()
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Functions_Before_UI"
			IsMounted   = @{
				Primary = "Functions_Before_UI"
				Expand  = @(
					"Functions_Rear_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "Functions_Rear_UI"
			IsMounted   = @{
				Primary = "Functions_Rear_UI"
				Expand  = @(
					"Functions_Before_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "API_Before_UI"
			IsMounted   = @{
				Primary = "API_Before_UI"
				Expand  = @(
					"API_Rear_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
		@{
			Uid         = "API_Rear_UI"
			IsMounted   = @{
				Primary = "API_Rear_UI"
				Expand  = @(
					"API_Before_UI"
				)
			}
			NotMonuted  = @{
				Primary = ""
				Expand  = @()
			}
			IsEvent = @(
				"Event_Completion_Setting_UI"
				"Event_Completion_Start_Setting_UI"
			)
		}
	)

	if ($Run) {
		ForEach ($item in $Global:Temp_Set_Need_Mounted_Primary) {
			if ($item.Uid -eq $Rule) {
				Event_Assign_Task_Queue_Add -Uid $Rule -IsMountedPrimary $item.IsMounted.Primary -IsMountedExpand $item.IsMounted.Expand -NotMonutedPrimary $item.NotMonuted.Primary -NotMonutedExpand $item.NotMonuted.Expand -IsEvent $item.IsEvent
			}
		}

		Event_Assign_Task
	} else {
		ForEach ($item in $Global:Temp_Set_Need_Mounted_Primary) {
			if ($item.Uid -eq $Rule) {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Rule)" -Name "NotMonutedExpand_Select" -ErrorAction SilentlyContinue) {
				} else {
					Save_Dynamic -regkey "Solutions\Suggested\$($Rule)" -name "NotMonutedExpand_Select" -value $item.NotMonuted.Expand -Type "MultiString"
				}

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Rule)" -Name "IsMountedExpand_Select" -ErrorAction SilentlyContinue) {
				} else {
					Save_Dynamic -regkey "Solutions\Suggested\$($Rule)" -name "IsMountedExpand_Select" -value $item.IsMounted.Expand -Type "MultiString"
				}

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Rule)" -Name "IsEvent_Select" -ErrorAction SilentlyContinue) {
				} else {
					Save_Dynamic -regkey "Solutions\Suggested\$($Rule)" -name "IsEvent_Select" -value $item.IsEvent -Type "MultiString"
				}
			}
		}
	}
}

<#
	.Event assignment add
	.事件分配添加
#>
Function Event_Assign_Task_Queue_Add
{
	param
	(
		$Uid,

		<#
			.需要挂载项
		#>
		$IsMountedPrimary,
		$IsMountedExpand,

		<#
			.无需挂载项
		#>
		$NotMonutedPrimary,
		$NotMonutedExpand,

		<#
			.有事件触发时
		#>
		$IsEvent
	)

	<#
		.分配到全局唯一识别
	#>
	$Global:EventProcessGuid = [guid]::NewGuid()
	$Global:Event_Guid = $Uid

	<#
		.分配已运行过的 UI
	#>
	New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value @() -Force

	# ------------------------------11111111111111111111111---------------------------
	<#
		.分配 1 ：需要挂载项
	#>
		<#
			.主要项
		#>
		New-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($Global:Primary_Key_Image.Uid)" -Value $IsMountedPrimary -Force

		<#
			.扩展项
		#>
		if ([string]::IsNullOrWhitespace($IsMountedExpand)) {
			New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
		} else {
			New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_$($Global:Primary_Key_Image.Uid)" -Value $IsMountedExpand -Force

			<#
				.不再建议项
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
					"True" {
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "IsMountedExpand_Select" -ErrorAction SilentlyContinue) {
							$SchemeVerSingle = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "IsMountedExpand_Select" -ErrorAction SilentlyContinue
							New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value $SchemeVerSingle -Force
						} else {
							Save_Dynamic -regkey "Solutions\Suggested\$($Uid)" -name "IsMountedExpand_Select" -value $IsMountedExpand -Type "MultiString"
							New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value $IsMountedExpand -Force
						}
					}
					"False" {
						New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
					}
				}
			}
		}


	# ------------------------------222222222222222222222222---------------------------
	<#
		.分配 2 ：无需要挂载项
	#>
		<#
			.主要项
		#>
		if ([string]::IsNullOrWhitespace($NotMonutedPrimary)) {
			$Global:Queue_Assign_Not_Monuted_Primary = @()
		} else {
			$Global:Queue_Assign_Not_Monuted_Primary = $NotMonutedPrimary
		}

		<#
			.扩展项，分配全部
		#>
		if ([string]::IsNullOrWhitespace($NotMonutedExpand)) {
			$Global:Queue_Assign_Not_Monuted_Expand = @()
			$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
		} else {
			$Global:Queue_Assign_Not_Monuted_Expand = $NotMonutedExpand

			<#
				.不再建议项
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
					"True" {
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "NotMonutedExpand_Select" -ErrorAction SilentlyContinue) {
							$SchemeVerSingle = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "NotMonutedExpand_Select" -ErrorAction SilentlyContinue

							$Global:Queue_Assign_Not_Monuted_Expand_Select = $SchemeVerSingle | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))}
						} else {
							Save_Dynamic -regkey "Solutions\Suggested\$($Uid)" -name "NotMonutedExpand_Select" -value $NotMonutedExpand -Type "MultiString"
							$Global:Queue_Assign_Not_Monuted_Expand_Select = $NotMonutedExpand
						}
					}
					"False" {
						$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
					}
				}
			}
		}


	# ------------------------------33333333333333333333333---------------------------
	<#
		.分配 3：分配有事件时
	#>
	if ([string]::IsNullOrWhitespace($IsEvent)) {
		$Global:Queue_Assign_Available = @()
	} else {
		$Global:Queue_Assign_Available = $IsEvent
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "IsEvent_Select" -ErrorAction SilentlyContinue) {
		$SchemeVerSingle = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested\$($Uid)" -Name "IsEvent_Select" -ErrorAction SilentlyContinue
		$Global:Queue_Assign_Available_Select = $SchemeVerSingle | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))}
	} else {
		Save_Dynamic -regkey "Solutions\Suggested\$($Uid)" -name "IsEvent_Select" -value $IsEvent -Type "MultiString"

		if ([string]::IsNullOrWhitespace($IsEvent)) {
			$Global:Queue_Assign_Available_Select = @()
		} else {
			$Global:Queue_Assign_Available_Select = $IsEvent
		}
	}
}

<#
	.Event assignment add
	.事件分配添加，自定义
#>
Function Event_Assign_Task_Queue_Add_New
{
	param
	(
		$Uid,

		<#
			.需要挂载项
		#>
		$IsMountedPrimary,
		$IsMountedExpand,

		<#
			.无需挂载项
		#>
		$NotMonutedPrimary,
		$NotMonutedExpand,

		<#
			.有事件触发时
		#>

		$IsEvent
	)

	<#
		.分配到全局唯一识别
	#>
	$Global:EventProcessGuid = [guid]::NewGuid()
	$Global:Event_Guid = $Uid

	<#
		.分配已运行过的 UI
	#>
	New-Variable -Scope global -Name "Queue_Assign_Has_Been_Run_$($Global:Primary_Key_Image.Uid)" -Value @() -Force

	# ------------------------------11111111111111111111111---------------------------
	<#
		.分配 1 ：需要挂载项
	#>
		<#
			.主要项。
		#>
		New-Variable -Scope global -Name "Queue_Is_Mounted_Primary_Assign_Task_$($Global:Primary_Key_Image.Uid)" -Value @() -Force

		<#
			扩展项
		#>
		New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_$($Global:Primary_Key_Image.Uid)" -Value $IsMountedExpand -Force
		New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value $IsMountedExpand -Force
}

Function Event_Track
{
	param
	(
		[switch]$Reset,
		[switch]$Add,
		[switch]$Del
	)

	if ($Reset) {
		$Global:EventProcessGuid = [guid]::NewGuid()
	}

	if ($Global:AutopilotMode) {
		$EventMaps = "Queue"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "Pause"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
	}

	if ($Global:EventQueueMode) {
		$EventMaps = "Assign"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "Pause"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$EventMaps = "Assign"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "Pause"
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
	}

	if ($Add) {
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "GUID" -value $Global:EventProcessGuid
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "Time" -value $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt")
	}

	if ($Del) {
		Remove-Item "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
	}
}

<#
	.One-click production, on-demand planning
	.一键制作，按需计划
#>
Function Event_Assign_Task
{
	<#
		.生成唯一事件：GUID
	#>
	Additional_Edition_Reset
	Event_Track -Add
	Event_Processing_Requires_Mounting

	<#
		.Events: Handling disallowed items
		.事件：分配无需挂载的项
	#>
	Event_Assign_Not_Allowed_UI

	if (Event_Assign_Task_Verify -Mount -Eject -All) {
		<#
			.Events: Handling Allowed Items
			.事件：有可用的事件时
		#>
		Event_Process_Available_UI

		if ($Global:QueueWaitTime.IsEnabled) {
			Write-Host "`n  $($lang.WaitTimeTitle)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Event_Completion_Start_Process
		}

		<#
			.如果等待时间完成后，优化处理生成解决方案到 ISO
		#>
		Solutions_Quick_Copy_Process_To_ISO

		<#
			.Handle operations that need to be mounted after install.wim or boot.wim
			.处理需要挂载 install.wim 或 boot.wim 后的操作
		#>
		Event_Process_Task_Need_Mount
	}

	if ($Global:Primary_Key_Image.Count -gt 0) {
		<#
			.处理扩展项任务，更新映像内的文件
		#>
		Write-Host "`n  $($lang.Event_Allow_Update_Rule)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Image_Get_Mount_Status -Silent

		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($Global:Primary_Key_Image.Uid)").Value) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Green
		} else {
			Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					if ($item.Main.Uid -eq $Global:Primary_Key_Image.Uid) {
						if ($item.Expand.Count -gt 0) {
							ForEach ($itemExpandNew in $item.Expand) {
								Write-Host "`n  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
								Write-Host $item.Main.Uid -ForegroundColor Green

								Image_Queue_Wimlib_Process_Wim_Main -Uid $itemExpandNew.Uid -MasterFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -DevCode "1"

								New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($itemExpandNew.Uid)" -Value @() -Force
							}
						}
					}
				}
			}

			<#
				.完成所有后，重建
			#>
			Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green

				Write-Host "`n  $($lang.AE_IsCheck)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline
				$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Additional_Edition.Count -gt 0) {
					Write-Host " $($lang.AE_IsRuning) " -BackgroundColor DarkGreen -ForegroundColor White

					<#
						强行关闭重建
					#>
					New-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				} else {
					Write-Host " $($lang.AE_NoEvent) " -BackgroundColor DarkRed -ForegroundColor White

					<#
						.没有检查到有可可用的附加版本事件，允许重建
					#>
					Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath

					<#
						强行关闭重建
					#>
					New-Variable -Scope global -Name "Queue_Rebuild_$($Global:Primary_Key_Image.Uid)" -Value $False -Force
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}
		}

		<#
			.附加版
		#>
		Write-Host "`n  $($lang.AdditionalEdition)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Image_Additional_Edition_Process -Uid $Global:Primary_Key_Image.Uid
	}

	<#
		.Handle events that don't require the image source to be mounted
		.处理不需要挂载映像源的事件
	#>
	Event_Process_Task_Sustainable

	Write-Host "`n  $($lang.SpecialFunction): $($lang.Function_Unrestricted)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($Global:Function_Unrestricted.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:Function_Unrestricted) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:Function_Unrestricted) {
			Invoke-Expression -Command $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	Write-Host "`n  $($lang.API): $($lang.Function_Unrestricted)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($Global:API_Unrestricted.Count -gt 0) {
		Write-Host "  $($lang.Choose)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:API_Unrestricted) {
			Write-Host "  $($item)"
		}

		Write-Host "`n  $($lang.LXPsWaitAdd)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:API_Unrestricted) {
			API_Process_Rule_Name -RuleName $item
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}

	<#
		.After event processing is complete
		.事件处理完成后
	#>
	Event_Completion_Process
}

Function Init_Canel_Event
{
	param
	(
		[switch]$All
	)

	New-Variable -Scope global -Name "Queue_Is_Mounted_Expand_Assign_Task_Select_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
	$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
	$Global:Queue_Assign_Available_Select = @()

	if ($All) {
		<#
			.未设置有任务时，初始化默认出厂值
		#>
		<#
			.初始化：等待时间
		#>
		$Global:QueueWaitTime = @{
			IsEnabled = $false
			Sky = 0
			Time = 0
			Minute = 30
		}

		if ($Global:AutopilotMode) {
			$EventMaps = "Queue"

			<#
				.初始化：完成后事件
			#>
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "NoProcess"
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
		}

		if ($Global:EventQueueMode) {
			$EventMaps = "Assign"

			<#
				.初始化：完成后事件
			#>
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "Pause"
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
		}

		if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
			$EventMaps = "Assign"

			<#
				.初始化：完成后事件
			#>
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "AfterFinishing" -value "NoProcess"
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($EventMaps)\$($Global:EventProcessGuid)" -name "IsCleanupTemp" -value "False"
		}
	}
}

Function AZ_Error_Page
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "$($lang.SelectFromError): $($lang.Healthy), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $true
		ControlBox     = $true
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 645
		Width          = 500
		BorderStyle    = 0
		Location       = "15,20"
		Text           = $lang.HealthyForceStop
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main.controls.AddRange($UI_Main_Tips)
	$UI_Main.ShowDialog() | Out-Null
}