<#
	.触发一键按需事件
#>
Function Event_Assign_Task_Customize
{
	<#
		.记忆首选主键
	#>
	$Global:Save_Current_Default_key = $Global:Primary_Key_Image.Uid

	<#
		.设置模式：批量模式
	#>
	Event_Reset_Variable -Silent
	$Global:EventQueueMode = $True
	Event_Track -Add

	<#
		.分配任务 UI
	#>
	Image_Assign_Event_Master

	#########################################################################################################
	<#
		.多任务分配
	#>
	#region 循环处理所有挂载的
	ForEach ($WildCard in $Global:Queue_Assign_Full) {
		Write-Host "`n  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
		Write-Host $WildCard.Main.Group -ForegroundColor Green

		if ($Global:Queue_Assign_Full.Count -gt 0) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003000 ]`n   Start"
			}

			Write-Host "`n  $($lang.Event_Assign_Main)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($WildCard.Main.UI.Count -gt 0) {
				if ($Global:Developers_Mode) {
					Write-Host "  $($lang.Developers_Mode_Location): E0x003030 ]`n   Start"
				}

				<#
					.设置首选主键
				#>
				Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "7"

				Write-Host "`n  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
				Write-Host $WildCard.Main.Group -ForegroundColor Green

				Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $WildCard.Main.ImageFileName -ForegroundColor Green

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -ForegroundColor Green

				Write-Host "`n  $($lang.User_Interaction): $($lang.OnDemandPlanTask): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($WildCard.Main.UI.Count) $($lang.EventManagerCount)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				ForEach ($itemMain in $WildCard.Main.UI) {
					Write-Host "  $($itemMain)" -ForegroundColor Green
				}

				Write-Host

				if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)").Value) {
					if ($Global:Developers_Mode) {
						Write-Host "  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003020 ]`n   Start"
					}

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $WildCard.Main.ImageFileName -ForegroundColor Green

					<#
						.设置首选主键
					#>
					Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -Detailed -DevCode "8"

					Event_Assign_Task_Queue_Add_New -Uid $WildCard.Main.Uid -IsMountedExpand $WildCard.Main.UI
					Event_Processing_Requires_Mounting

					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003020 ]`n   End"
					}
				} else {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003010 ]`n   Start"
					}

					<#
						.设置首选主键
					#>
					Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "88"

					<#
						规则 1：选择索引号
					#>
#					Image_Select_Mul_UI -ImageFileName "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)"

					$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value
					if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
						Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $WildCard.Main.ImageFileName -ForegroundColor Green

						Event_Assign_Task_Queue_Add_New -Uid $WildCard.Main.Uid -IsMountedExpand $WildCard.Main.UI
						Event_Processing_Requires_Mounting
					} else {
						Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($WildCard.Main.Uid) )" -ForegroundColor Red
					}

					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003010 ]`n   End"
					}
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003030 ]`n   End"
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}
			<#
				.处理主要项：结束
			#>

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x003000 ]`n   End"
			}
		}

		<#
			.处理扩展项，开始
		#>
		if ($Global:Queue_Assign_Full.Count -gt 0) {
			#region 处理扩展项
			Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($WildCard.Expand.UI.Count -gt 0) {
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002850 ]`n   Start"
				}

				Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				ForEach ($ShowExpandItem in $WildCard.Expand) {
					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $ShowExpandItem.Uid -ForegroundColor Green

					Write-Host "`n    $($lang.Choose): $($ShowExpandItem.UI.Count) $($lang.EventManagerCount)" -ForegroundColor Yellow
					Write-Host "      $('-' * 77)"
					ForEach ($itemUIPrint in $ShowExpandItem.UI) {
						Write-Host "      $($itemUIPrint)" -ForegroundColor Green
					}

					Write-Host
				}

				#region 遍历扩展项任务
				Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				ForEach ($Expand in $WildCard.Expand) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $WildCard.Main.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.ImageFileName -ForegroundColor Green

					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)" -ForegroundColor Green

					Write-Host "`n  $($lang.User_Interaction): $($lang.OnDemandPlanTask): " -NoNewline -ForegroundColor Yellow
					Write-Host "$($Expand.UI.Count) $($lang.EventManagerCount)" -ForegroundColor Green
					Write-Host "  $('-' * 80)"
					ForEach ($itemMain in $Expand.UI) {
						Write-Host "  $($itemMain)" -ForegroundColor Green
					}

					<#
						.设置首选主键
					#>
					Image_Set_Global_Primary_Key -Uid $Expand.Uid -DevCode "9"

					<#
						判断是否已经挂载，并判断文件是否存在。
					#>
					if (Test-Path -Path "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)" -PathType Leaf) {
						#region 文件存在
						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002700 ]`n   Start"
						}

						if (Verify_Is_Current_Same) {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002750 ]`n   Start"
							}

							Event_Assign_Task_Queue_Add_New -Uid $Expand.Uid -IsMountedExpand $Expand.UI
							Event_Processing_Requires_Mounting

							if ($Global:Developers_Mode) {
								Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002750 ]`n   End"
							}
						} else {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002780 ]`n   Start"
							}

#							Image_Select_Mul_UI -ImageFileName "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

							$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($Expand.ImageFileName)" -ErrorAction SilentlyContinue).Value
							if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
								Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $Expand.Uid -ForegroundColor Green

								<#
									.设置首选主键
								#>
								Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "10"

								Event_Assign_Task_Queue_Add_New -Uid $Expand.Uid -IsMountedExpand $Expand.UI
								Event_Processing_Requires_Mounting
							} else {
								Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($Expand.Uid) )" -ForegroundColor Red
							}

							if ($Global:Developers_Mode) {
								Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002780 ]`n   End"
							}
						}

						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002700 ]`n   End"
						}
						#endregion 文件存在
					} else {
						#region 文件不存在
						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002600 ]`n   Start"
						}

						<#
							弹出选择主要项：索引号
						#>
						#region 弹出选择索引号
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							Write-Host "`n  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"

							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $itemBB.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $itemBB.Index -ForegroundColor Yellow

								Write-Host
							}
						} else {
							<#
								.设置首选主键
							#>
							Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "11"
							
							<#
								.弹出选择 Install.wim 索引号
							#>
							Image_Select_Mul_UI -ImageFileName "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)"
						}
						#endregion 弹出选择索引号

						<#
							.设置首选主键
						#>
						Image_Set_Global_Primary_Key -Uid $Expand.Uid -DevCode "12"

						<#
							.判断是否选择主要扩展项索引号，重要。没有索引号，处理个什么？处理了个寂寞。
						#>
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							<#
								.弹出模拟名
							#>
							Image_Select_Index_Custom_UI

							#region 获取用户是否选择了分配事件
							$Get_Current_Process_Type_Temp = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value
							switch ($Get_Current_Process_Type_Temp) {
								"Auto" {
									#region Auto
									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002900 ]`n   Start"
									}

									<#
										.处理全部已知索引号
									#>

									Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
									Write-Host $Expand.Uid -ForegroundColor Green

									<#
										.设置首选主键
									#>
									Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "13"

									Event_Assign_Task_Queue_Add_New -Uid $Expand.Uid -IsMountedExpand $Expand.UI
									Event_Processing_Requires_Mounting

									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002900 ]`n   End"
									}
									#endregion Auto
								}
								"Popup" {
									#region Popup
									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002200 ]`n   Start"
									}

									<#
										.有事件时，弹出选择索引号界面
									#>

									Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
									Write-Host $Expand.Uid -ForegroundColor Green

									<#
										.设置首选主键
									#>
									Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "14"

									Event_Assign_Task_Queue_Add_New -Uid $Expand.Uid -IsMountedExpand $Expand.UI
									Event_Processing_Requires_Mounting

									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002200 ]`n   End"
									}
									#endregion Popup
								}
								"Pre" {
									#region Pre
									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002350 ]`n   Start"
									}

									<#
										.预指定索引号
									#>
									$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($Expand.ImageFileName)" -ErrorAction SilentlyContinue).Value
									if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
										Write-Host "`n  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
										Write-Host $Expand.Uid -ForegroundColor Green

										<#
											.设置首选主键
										#>
										Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "15"

										Event_Assign_Task_Queue_Add_New -Uid $Expand.Uid -IsMountedExpand $Expand.UI
										Event_Processing_Requires_Mounting
									} else {
										Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($Expand.Uid) )" -ForegroundColor Red
									}

									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002350 ]`n   End"
									}
									#endregion Pre
								}
								Default {
									if ($Global:Developers_Mode) {
										Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002400"
									}

									Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
								}
							}
						} else {
							Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($Expand.Uid) )" -ForegroundColor Red
						}

						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002600 ]`n   End"
						}
					}
					#endregion 文件不存在
				}
				#endregion 遍历扩展项任务

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002850 ]`n   End"
				}

			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}
			#endregion 处理扩展项
		}
	}

	<#
		.分配无需挂载项
	#>
	Event_Assign_Not_Allowed_UI

	if (Event_Assign_Task_Verify -Mount -All -EJect) {
		Event_Process_Available_UI
	}

	if ($Global:QueueWaitTime.IsEnabled) {
		Event_Completion_Start_Process
	}

	<#
		.优化处理生成解决方案到 ISO
	#>
	Solutions_Quick_Copy_Process_To_ISO

	#########################################################################################################
	<#
		.多任务分配完成后，处理全部

		 机制

			优先处理扩展项，判断是否有扩展项

				机制：循环所有扩展项
					1、优先判断是否排除运行

					2、可以运行
						已挂载
							继续处理

						未挂载
							检查是否已指定主要索引号，并循环
								设置为弹出并保存

									1、设置首选主键：扩展项
									   验证是否有任务

									   设置主要项为强行保存、并弹出

			机制：处理主要项：
				已挂载
				未挂载

				判断是否主要项挂载，判断是否有主要项任务
	#>
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
	if ($Global:Queue_Assign_Full.Count -gt 0) {
		ForEach ($WildCard in $Global:Queue_Assign_Full) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000300"
			}

			$Global:Extension_Has_been_Run = @()

			Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "15"

			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
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
							Run_Expand -NewUid $ExpandWildcard.UID -NewMain $WildCard.Main -NewExpand $ExpandWildcard
						}
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}
				#endregion 处理扩展项任务

				Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "18"
				Event_Process_Task_Need_Mount
				#endregion 已挂载主要项
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

				#region 未挂载
				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000330 ]`n   Start" -ForegroundColor Green
				}

				$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
					if ($Global:Developers_Mode) {
						Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002680 ]`n   Start" -ForegroundColor Green
					}

					Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					ForEach ($WildCardBB in $Temp_Queue_Process_Image_Select_Pending) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $WildCardBB.Name -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $WildCardBB.Index -ForegroundColor Yellow

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
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002800 ]`n   Start" -ForegroundColor Green
						}

						Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						ForEach ($WildCardBB in $Temp_Queue_Process_Image_Select_Pending) {
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($WildCard.Main.Uid), $($lang.MountedIndex): $($WildCardBB.Index), $($lang.Wim_Image_Name): $($WildCardBB.Name)"

							Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
							Write-Host $WildCardBB.Name -ForegroundColor Yellow

							Write-Host "  $($lang.MountedIndex): " -NoNewline
							Write-Host $WildCardBB.Index -ForegroundColor Yellow

							Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
							Write-Host $WildCard.Main.ImageFileName -ForegroundColor Yellow

							Write-Host "  $($lang.Select_Path): " -NoNewline
							Write-Host "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -ForegroundColor Green

							Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)").Value) {
								Write-Host "  $($lang.Mounted)"
							} else {
								Write-Host "  $($lang.NotMounted)"

								Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  $($lang.Mount)" -ForegroundColor Yellow

								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -Value $True -Force # 不保存
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
									Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006030 ]`n   Start"
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
											Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006050 ]`n   Start"
										}

										Write-Host "`n  $($lang.Mounted_Status): $($lang.Unmount)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_$($WildCard.Main.ImageFileName)_$($ExpandWildcard.ImageFileName)" -Value $True -Force # 不保存
										Write-Host "  $($lang.DoNotSave)`n" -ForegroundColor Yellow

										<#
											.设置首选主键
										#>
										Image_Set_Global_Primary_Key -Uid $ExpandWildcard.Uid -DevCode "21"
										Run_Expand -NewUid $ExpandWildcard.UID -NewMain $WildCard.Main -NewExpand $ExpandWildcard

										if ($Global:Developers_Mode) {
											Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006050 ]`n   End"
										}
									}
								}

								if ($Global:Developers_Mode) {
									Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006030 ]`n   End"
								}
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}
							#endregion 处理扩展项任务

							<#
								.处理主要项
							#>
							Image_Set_Global_Primary_Key -Uid $WildCard.Main.Uid -DevCode "22"
							Event_Process_Task_Need_Mount
						}

						if ($Global:Developers_Mode) {
							Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x002800 ]`n   End" -ForegroundColor Green
						}
					} else {
						Write-Host "  $($lang.NoWork)" -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($WildCard.Main.Uid) )" -ForegroundColor Red
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000330 ]`n   End" -ForegroundColor Green
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
			if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)").Value) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000350 ]`n   Start" -ForegroundColor Green
				}

				Write-Host "`n  $($lang.Event_Assign_Expand)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if ($WildCard.Expand.Count -gt 0) {
					ForEach ($itemExpandNew in $WildCard.Expand) {
						Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
						Write-Host "$($WildCard.Main.ImageFileName);$($itemExpandNew.ImageFileName);" -ForegroundColor Green

						Image_Queue_Wimlib_Process_Wim_Main -NewUid $itemExpandNew.Uid -NewMaster $WildCard.Main.ImageFileName -NewImageFileName $itemExpandNew.ImageFileName -MasterFile "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)" -DevCode "3"

						<#
							.清除任务
						#>
						New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($WildCard.Main.ImageFileName)_$($itemExpandNew.ImageFileName)" -Value @() -Force
					}
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.完成所有后，重建
				#>
				Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
				if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -ErrorAction SilentlyContinue).Value) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green

					Rebuild_Image_File -Filename "$($WildCard.Main.Path)\$($WildCard.Main.ImageFileName).$($WildCard.Main.Suffix)"
					New-Variable -Scope global -Name "Queue_Rebuild_$($WildCard.Main.ImageFileName)_$($WildCard.Main.ImageFileName)" -Value $False -Force
				} else {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				if ($Global:Developers_Mode) {
					Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x000350 ]`n   End" -ForegroundColor Green
				}
			}
		}
		#endregion 机制：处理主要项：主要项

	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
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

	Event_Reset_Variable -Silent

	if ([string]::IsNullOrEmpty($Global:Save_Current_Default_key)) {
		
	} else {
		Image_Set_Global_Primary_Key -Uid $Global:Save_Current_Default_key -DevCode "23"
	}
}

<#
	.扩展项任务
#>
Function Expand_Process_abc
{
	param
	(
		$NewUid,
		$ImageFileMount,
		$MainUid,
		$ExpandUid,
		$NewUpdatePath
	)

	<#
		.分配事件
	#>
	Event_Process_Task_Need_Mount

	<#
		.完成所有后，重建
	#>
	Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
	if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($MainUid)_$($ExpandUid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)" -ForegroundColor Green

		Rebuild_Image_File -Filename $ImageFileMount
		New-Variable -Scope global -Name "Queue_Rebuild_$($MainUid)_$($ExpandUid)" -Value $False -Force
	} else {
		Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	<#
		.完成后所有，将当前文件设置为主键，同步至所有挂载项

		备份制作完成的 WinRE.wim 后备份到 Wimlib 目录里
	#>
	Write-Host "`n  $($lang.Pri_Key_Template)" -ForegroundColor Yellow
	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Rule_$($MainUid)_$($ExpandUid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)`n" -ForegroundColor Green

		<#
			.保存到临时目录
		#>
		$RandomGuid = [guid]::NewGuid()
		
		$Local_Wim_Update_Folder_Sources = "$($Global:Image_source)_Custom\$($MainUid)\$($MainUid)\Update\Wimlib\$($RandomGuid)"

		$Local_Wim_Update_Full_Path = "$($Local_Wim_Update_Folder_Sources)\$($ExpandUid).wim"
		Check_Folder -chkpath $Local_Wim_Update_Folder_Sources

		Copy-Item $ImageFileMount -Destination $Local_Wim_Update_Folder_Sources -ErrorAction SilentlyContinue

		<#
			.判断到文件时，保存到指定任务
		#>
		Write-Host "  $($lang.SaveTo): " -ForegroundColor Yellow
		Write-Host "  $($Local_Wim_Update_Full_Path)" -ForegroundColor Green
		if (Test-Path -Path $Local_Wim_Update_Full_Path -PathType Leaf) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006020 ]`n   Start"
			}

			Write-Host "  $($lang.Done)" -ForegroundColor Green

			$Temp_Queue_Temp_Save_Update_Rule_Task = @{
				Group         = "$($MainUid);$($MainUid);"
				Uid           = $NewUid
				ImageFileName = $ExpandUid
				FileName      = $Local_Wim_Update_Full_Path
				AbsolutePath  = $ImageFileMount
				UpdatePath    = $NewUpdatePath
			}

			New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($MainUid)_$($ExpandUid)" -Value $Temp_Queue_Temp_Save_Update_Rule_Task -Force

			<#
				.清空任务
			#>
			Write-Host "`n  $($lang.EventManagerClear)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($Global:Primary_Key_Image.Master);$($Global:Primary_Key_Image.ImageFileName);" -ForegroundColor Green

			<#
				.添加已执行过的任务，不再执行
			#>
			if ($Global:Extension_Has_been_Run -NotContains $NewUid) {
				$Global:Extension_Has_been_Run += $NewUid
			}

			Write-Host "`n  $($lang.DeDuplication)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($NewUid)`n" -ForegroundColor Red

			Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Extension_Has_been_Run) {
				Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($item)`n" -ForegroundColor Green
			}

			if ($Global:Developers_Mode) {
				Write-Host "  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006020 ]`n   End"
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
	}
}

Function Run_Expand
{
	param
	(
		$NewUid,
		$NewMain,
		$NewExpand
	)

	<#
		.设置首选主键
	#>
	Image_Set_Global_Primary_Key -Uid $NewExpand.Uid -DevCode "24"

	<#
		.验证是否有“扩展项”，需挂载的任务
	#>
	if (Event_Assign_Task_Verify -Mount) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)"
			Write-Host "  $($WildCard.Main.Uid)" -ForegroundColor Green

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006010 ]`n   Start"
			}

			Expand_Process_abc -NewUid $NewUid -MainUid $NewMain.ImageFileName -ExpandUid $NewExpand.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006010 ]`n   End"
			}
		} else {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006000 ]`n   Start"
			}

			#region 检查到主映像文件后，并挂载
			Write-Host "`n  $($lang.ProcessingImage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -ForegroundColor Green

			if (Test-Path -Path "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -PathType Leaf) {
				Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				$TempQueueProcessImageSelect = @()
				try {
					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Get-WindowsImage -ImagePath ""$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)""" -ForegroundColor Green
						Write-Host "  $('-' * 80)`n"
					}

					Get-WindowsImage -ImagePath "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -ErrorAction SilentlyContinue | ForEach-Object {
						$TempQueueProcessImageSelect += @{
							Name   = $_.ImageName
							Index  = $_.ImageIndex
						}
					}
				} catch {
					Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					Write-Host "  $($_)" -ForegroundColor Yellow
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.判断是否已选择分配扩展，索引号
				#>
				$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value
				Write-Host "`n  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
					ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $itemBB.Name -ForegroundColor Yellow

						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $itemBB.Index -ForegroundColor Yellow

						Write-Host
					}

					ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value

						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($NewExpand.UID);, $($lang.MountedIndex): $($itemBB.Index), $($lang.Wim_Image_Name): $($itemBB.Name)"

							Write-Host "  $($lang.Wim_Image_Name): " -noNewline
							Write-Host $itemBB.Name -ForegroundColor Yellow

							Write-Host "  $($lang.MountedIndex): " -noNewline
							Write-Host $itemBB.Index -ForegroundColor Yellow

							if (Event_Assign_Task_Verify -Mount) {
								Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"

								Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $NewExpand.Uid -ForegroundColor Green

								Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
								Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)`n" -ForegroundColor Green

								Image_Mount_Check -MountFileName "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -Index $itemBB.Index
								Expand_Process_abc -NewUid $NewUid -MainUid $NewMain.ImageFileName -ExpandUid $NewExpand.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"
							} else {
								Write-Host "`n  $($lang.NoWork)" -ForegroundColor Red
							}
						} else {
							Write-Host "  $($lang.NoWork)" -ForegroundColor Red
						}
					}

					Write-Host "`n  $($lang.Done)" -ForegroundColor Green
					return
				} else {
					Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($NewMain.ImageFileName);$($NewExpand.ImageFileName); )" -ForegroundColor Red
				}

				<#
					.未检查到用户已选择的分配索引号，继续执行
				#>
				#region 获取用户是否选择了分配事件
				$Get_Current_Process_Type_Temp = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value
				switch ($Get_Current_Process_Type_Temp) {
					"Auto" {
						Write-Host "`n  $($lang.Index_Process_All)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						if ($TempQueueProcessImageSelect.count -gt 0) {
							Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host
							}

							Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($NewExpand.UID), $($lang.MountedIndex): $($item.Index), $($lang.Wim_Image_Name): $($item.Name)"

								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $item.Index -ForegroundColor Yellow

								if (Event_Assign_Task_Verify -Mount) {
									Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"

									Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
									Write-Host $NewExpand.UID -ForegroundColor Green

									Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
									Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)`n" -ForegroundColor Green

									<#
										.挂载主文件
									#>
									Image_Mount_Check -MountFileName "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -Index $item.Index
									Expand_Process_abc -NewUid $NewUid -MainUid $NewMain.ImageFileName -ExpandUid $NewExpand.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"
								} else {
									Write-Host "`n  $($lang.NoWork)" -ForegroundColor Red
								}
							}
						} else {
							Write-Host "  $($lang.NoWork)" -ForegroundColor Red
						}
					}
					"Popup" {
						<#
							.弹出索引选择界面。
						#>
						Write-Host "`n  $($lang.Index_Is_Event_Select)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						<#
							.读取用户自定义设置，默认，未指定时，弹出设置界面
						#>
						Image_Select_Popup_UI -ImageFileName "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"

						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value

						Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $itemBB.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $itemBB.Index -ForegroundColor Yellow

								Write-Host
							}

							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value

								if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
									$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($NewExpand.UID);, $($lang.MountedIndex): $($itemBB.Index), $($lang.Wim_Image_Name): $($itemBB.Name)"

									Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"

									Write-Host "  $($lang.Wim_Image_Name): " -noNewline
									Write-Host $itemBB.Name -ForegroundColor Yellow

									Write-Host "  $($lang.MountedIndex): " -noNewline
									Write-Host $itemBB.Index -ForegroundColor Yellow

									if (Event_Assign_Task_Verify -Mount) {
										Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
										Write-Host $NewExpand.Uid -ForegroundColor Green

										Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
										Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)`n" -ForegroundColor Green

										Image_Mount_Check -MountFileName "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -Index $itemBB.Index
										Expand_Process_abc -NewUid $NewUid -MainUid $NewMain.ImageFileName -ExpandUid $NewExpand.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"
									} else {
										Write-Host "`n  $($lang.NoWork)" -ForegroundColor Red
									}
								} else {
									Write-Host "  $($lang.NoWork)" -ForegroundColor Red
								}
							}
						} else {
							Write-Host "  $($lang.SelectFromError): $($lang.MountedIndexSelect) ( $($NewMain.ImageFileName);$($NewExpand.ImageFileName); )" -ForegroundColor Red
						}
					}
					"Pre" {
						<#
							.预指定索引号
						#>
						Write-Host "`n  $($lang.Index_Pre_Select)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						Write-Host "  $($lang.Choose)" -ForegroundColor Green
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($NewMain.ImageFileName)_$($NewExpand.ImageFileName)" -ErrorAction SilentlyContinue).Value
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $itemBB.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $itemBB.Index -ForegroundColor Yellow

								Write-Host
							}
						}

						<#
							.已安装
						#>
						if ($TempQueueProcessImageSelect.count -gt 0) {
							Write-Host "  $($lang.YesWork)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host
							}

							Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.Index -ForegroundColor Yellow

								if ($Temp_Queue_Process_Image_Select_Pending.Index -Contains $item.Index) {
									if (Event_Assign_Task_Verify -Mount) {
										Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
										Write-Host $NewExpand.Uid -ForegroundColor Green

										Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
										Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)`n" -ForegroundColor Green

										<#
											.挂载主文件
										#>
										Image_Mount_Check -MountFileName "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -Index $item.Index
										Expand_Process_abc -NewUid $NewUid -MainUid $NewMain.ImageFileName -ExpandUid $NewExpand.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount "$($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)"
									} else {
										Write-Host "  $($lang.NoWork)" -ForegroundColor Red
									}
								} else {
									Write-Host "`n  $($lang.MatchMode), $($lang.Failed): $($itemBB.Index)" -ForegroundColor Green
								}
							}
						} else {
							Write-Host "  $($lang.NoWork)" -ForegroundColor Red
						}
					}
					Default {
						Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
					}
				}
				#endregion
			} else {
				Write-Host "`n  $($lang.NoInstallImage)"
				Write-Host "  $($NewExpand.Path)\$($NewExpand.ImageFileName).$($NewExpand.Suffix)" -ForegroundColor Red
			}
			#endregion 检查到主映像文件后，并挂载

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006000 ]`n   End"
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

Function Run_Expand_Is_New
{
	param
	(
		$NewMain,
		$NewExpand
	)

	<#
		.验证是否有“扩展项”，需挂载的任务
	#>
	if (Event_Assign_Task_Verify -Mount) {
		return $True
	}

	return $False
}