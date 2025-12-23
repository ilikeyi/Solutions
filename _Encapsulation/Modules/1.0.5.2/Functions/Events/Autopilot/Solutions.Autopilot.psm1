function Additional_Edition_Reset
{
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			New-Variable -Scope global -Name "Queue_Additional_Edition_$($item.Main.Uid)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($item.Main.Uid)" -Value @() -Force

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					New-Variable -Scope global -Name "Queue_Additional_Edition_$($Expand.Uid)" -Value @() -Force
					New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Expand.Uid)" -Value @() -Force
				}
			}
		}
	}
}

<#
	.触发一键按需事件
#>
Function Event_Assign_Task_Customize_Autopilot
{
	<#
		.记忆首选主键
	#>
	$Global:Save_Current_Default_key = $Global:Primary_Key_Image.Uid

	<#
		.设置模式：批量模式
	#>
	Additional_Edition_Reset
	Event_Reset_Variable -Silent
	$Global:AutopilotMode = $True
	Event_Track -Add

	<#
		.分配任务 UI
	#>
	Image_Assign_Autopilot_Master

	#########################################################################################################
	<#
		.初始化时间：所有任务
	#>
	$Script:AllTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
	$Script:AllTasksTime = New-Object System.Diagnostics.Stopwatch
	$Script:AllTasksTime.Reset()
	$Script:AllTasksTime.Start()
	Write-Host "  $($lang.Event_Process_All)" -ForegroundColor Green
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host " $($Script:AllTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

	<#
		.开始分配用户来源
	#>
	#region 开始分配
	ForEach ($WildCard in $Global:Image_Rule) {
		if ($WildCard.Main.Suffix -eq "wim") {
			$Global:Extension_Has_been_Run = @()

			Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "15"

			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Verify_Is_Current_Same) {
				#region 已挂载主要项
				Write-Host "  $($lang.Mounted)" -ForegroundColor Green
				Write-Host "  $($WildCard.Main.Uid)" -ForegroundColor Green

				#region 处理扩展项任务
				Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($WildCard.Expand.Count -gt 0) {
					ForEach ($ExpandWildcard in $WildCard.Expand) {
						<#
							.判断是否排除运行
						#>
						if ($Global:Extension_Has_been_Run -Contains $ExpandWildcard.Uid) {
							Write-Host "  $($lang.Pri_key_Running)" -ForegroundColor Yellow
						} else {
							<#
								.设置首选主键
							#>
							Image_Set_Global_Primary_Key -Uid $ExpandWildcard.Uid -DevCode "17"

							$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)\Mount\$($ExpandWildcard.Path)\$($ExpandWildcard.ImageFileName).$($ExpandWildcard.Suffix)"
							Run_Expand -Uid $ExpandWildcard.Uid -NewUid $ExpandWildcard.UID -NewMain $WildCard.Main -NewExpand $ExpandWildcard -MountFileName $test_mount_folder_Current
						}
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
				#endregion 处理扩展项任务

				Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "18"
				Event_Process_Task_Need_Mount
				Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "18_End"
				#endregion 已挂载主要项
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

				#region 未挂载
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000330`n  Start" -ForegroundColor Green
				}

				$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.Uid)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002680`n  Start" -ForegroundColor Green
					}

					Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					ForEach ($WildCardBB in $Temp_Queue_Process_Image_Select_Pending) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $WildCardBB.Index -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $WildCardBB.Name -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $WildCardBB.ImageDescription -ForegroundColor Yellow

						Write-Host
					}

					$Temp_Allow_Is_Work = $False
					if (Event_Assign_Task_Verify -Mount) {
						$Temp_Allow_Is_Work = $True
					}

					Write-Host "  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					if ($WildCard.Expand.Count -gt 0) {
						ForEach ($ExpandWildcard in $WildCard.Expand) {
							if ($Global:Extension_Has_been_Run -Contains $ExpandWildcard.Uid) {
								Write-Host "  $($lang.Pri_key_Running)" -ForegroundColor Yellow
							} else {
								Image_Set_Global_Primary_Key -Uid $ExpandWildcard.Uid -DevCode "19"

								if (Run_Expand_Is_New) {
									$Temp_Allow_Is_Work = $True
									break
								}
							}
						}
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}

					Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "20"
					if ($Temp_Allow_Is_Work) {
						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002800`n  Start" -ForegroundColor Green
						}

						Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						ForEach ($WildCardBB in $Temp_Queue_Process_Image_Select_Pending) {
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($WildCard.Main.Uid), $($lang.MountedIndex): $($WildCardBB.Index), $($lang.Wim_Image_Name): $($WildCardBB.Name)"

							Write-Host "  $($lang.MountedIndex): " -NoNewline
							Write-Host $WildCardBB.Index -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
							Write-Host $WildCardBB.Name -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
							Write-Host $WildCardBB.ImageDescription -ForegroundColor Yellow

							Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
							Write-Host $WildCard.Main.Uid -ForegroundColor Yellow

							Write-Host "  $($lang.Select_Path): " -NoNewline
							Write-Host "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -ForegroundColor Green

							Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($WildCard.Main.Uid)").Value) {
								Write-Host "  $($lang.Mounted)"
							} else {
								Write-Host "  $($lang.NotMounted)"

								Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  $($lang.Mount)" -ForegroundColor Yellow

								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($WildCard.Main.Uid)" -Value $True -Force # 不保存
								Write-Host "  $($lang.DoNotSave)`n" -ForegroundColor Yellow

								<#
									.挂载主文件
								#>
								Image_Mount_Check -MountFileName "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -Index $WildCardBB.Index
							}

							#region 处理扩展项任务
							Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ($WildCard.Expand.Count -gt 0) {
								if ($Global:Developers_Mode) {
									Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006030`n  Start"
								}

								Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"

								ForEach ($ExpandWildcard in $WildCard.Expand) {
									<#
										.判断是否排除运行
									#>
									if ($Global:Extension_Has_been_Run -Contains $ExpandWildcard.Uid) {
										Write-Host "  $($lang.Pri_key_Running)" -ForegroundColor Yellow
									} else {
										if ($Global:Developers_Mode) {
											Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006050`n  Start"
										}

										Write-Host "`n  $($lang.Mounted_Status): $($lang.Unmount)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($ExpandWildcard.Uid)" -Value $True -Force # 不保存
										Write-Host "  $($lang.DoNotSave)`n" -ForegroundColor Yellow

										<#
											.设置首选主键
										#>
										Image_Set_Global_Primary_Key -Uid $ExpandWildcard.Uid -DevCode "21"

										$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)\Mount\$($ExpandWildcard.Path)\$($ExpandWildcard.ImageFileName).$($ExpandWildcard.Suffix)"

										Run_Expand -Uid $ExpandWildcard.UID -NewUid $ExpandWildcard.UID -NewMain $WildCard.Main -NewExpand $ExpandWildcard -MountFileName $test_mount_folder_Current

										if ($Global:Developers_Mode) {
											Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006050`n  End"
										}
									}
								}

								if ($Global:Developers_Mode) {
									Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006030`n  End"
								}
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}
							#endregion 处理扩展项任务

							<#
								.处理主要项
							#>
							Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "2233333"
							Event_Process_Task_Need_Mount
							Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "2233333_End"
						}

						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002800`n  End" -ForegroundColor Green
						}
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($WildCard.Main.Uid) )" -ForegroundColor Red
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000330`n  End" -ForegroundColor Green
				}
				#endregion 未挂载
			}

			<#
				.处理扩展项任务，更新映像内的文件
			#>
			Write-Host "`n  $($lang.Event_Allow_Update_Rule)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Image_Get_Mount_Status -Silent

			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($WildCard.Main.Uid)").Value) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000350`n  Start" -ForegroundColor Green
				}

				Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($WildCard.Expand.Count -gt 0) {
					ForEach ($itemExpandNew in $WildCard.Expand) {
						Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
						Write-Host "$($WildCard.Main.ImageFileName);$($itemExpandNew.ImageFileName);" -ForegroundColor Green

						Image_Queue_Wimlib_Process_Wim_Main -Uid $itemExpandNew.Uid -MasterFile "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -DevCode "2"

						<#
							.清除任务
						#>
						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($itemExpandNew.Uid)" -Value @() -Force
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

			<#
					.完成所有后，重建
				#>
				Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($WildCard.Main.Uid)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green

					Write-Host "`n  $($lang.AE_IsCheck): " -NoNewline -ForegroundColor Yellow
					$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($WildCard.Main.Uid)" -ErrorAction SilentlyContinue).Value
					if ($Temp_Additional_Edition.Count -gt 0) {
						Write-Host " $($lang.AE_IsRuning) " -BackgroundColor DarkGreen -ForegroundColor White

						<#
							强行关闭重建
						#>
						New-Variable -Scope global -Name "Queue_Rebuild_$($WildCard.Main.Uid)" -Value $False -Force
					} else {
						Write-Host " $($lang.AE_NoEvent) " -BackgroundColor DarkRed -ForegroundColor White

						<#
							.没有检查到有可可用的附加版本事件，允许重建
						#>
						Rebuild_Image_File -Filename "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)"

						<#
							强行关闭重建
						#>
						New-Variable -Scope global -Name "Queue_Rebuild_$($WildCard.Main.Uid)" -Value $False -Force
					}
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.AdditionalEdition)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Image_Additional_Edition_Process -Uid $WildCard.Main.Uid

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000350`n  End" -ForegroundColor Green
				}
			}
		}
		#endregion 机制：处理主要项：主要项
	}
	#endregion 开始分配

	<#
		.Handle events that don't require the image source to be mounted
		.处理不需要挂载映像源的事件
	#>
	Event_Process_Task_Sustainable

	$Script:AllTasksTime.Stop()
	Write-Host "`n  $('-' * 80)"
	Write-Host "  $($lang.TimeStart)" -NoNewline
	Write-Host $($Script:AllTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEnd)" -NoNewline
	Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAll)" -NoNewline
	Write-Host $Script:AllTasksTime.Elapsed -ForegroundColor Yellow

	Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
	Write-Host "$($Script:AllTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	<#
		.After event processing is complete
		.事件处理完成后
	#>
	Event_Completion_Process

	Additional_Edition_Reset
	Event_Reset_Variable -Silent -IsNoRefresh "Yes"

	if ([string]::IsNullOrEmpty($Global:Save_Current_Default_key)) {
		
	} else {
		Image_Set_Global_Primary_Key -Uid $Global:Save_Current_Default_key -DevCode "23"
	}
}