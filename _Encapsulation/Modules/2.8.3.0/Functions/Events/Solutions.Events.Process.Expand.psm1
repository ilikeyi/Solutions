<#
	.扩展项任务
#>
Function Expand_Process_abc
{
	param
	(
		$Uid,
		$ImageFileMount,
		$Master,
		$NewUpdatePath
	)

	<#
		.分配事件
	#>
	Event_Process_Task_Need_Mount

	<#
		.完成所有后，重建
	#>
	Write-Host "`n  $($lang.Rebuilding): " -NoNewline -ForegroundColor Yellow
	if ((Get-Variable -Scope global -Name "Queue_Rebuild_$($Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host " $($lang.Operable) " -NoNewline -BackgroundColor White -ForegroundColor Black

		Rebuild_Image_File -Filename $ImageFileMount
		New-Variable -Scope global -Name "Queue_Rebuild_$($Uid)" -Value $False -Force
	} else {
		Write-Host " $($lang.NoWork) " -BackgroundColor DarkRed -ForegroundColor White
	}

	<#
		.完成后所有，将当前文件设置为主键，同步至所有挂载项

		备份制作完成的 WinRE.wim 后备份到 Wimlib 目录里
	#>
	Write-Host "`n  $($lang.Pri_Key_Template)" -ForegroundColor Yellow
	if ((Get-Variable -Scope global -Name "Queue_Is_Update_Rule_$($Uid)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.Operable)`n" -ForegroundColor Green

		<#
			.保存到临时目录
		#>
		$RandomGuid = [guid]::NewGuid()
		$Local_Wim_Update_Folder_Sources = "$(Get_MainMasterFolder)\$($Master)\$($Master)\Update\Wimlib\$($RandomGuid)"

		$NewFileName = [IO.Path]::GetFileName($ImageFileMount)
		$Local_Wim_Update_Full_Path = "$($Local_Wim_Update_Folder_Sources)\$($NewFileName)"
		Check_Folder -chkpath $Local_Wim_Update_Folder_Sources

		Copy-Item $ImageFileMount -Destination $Local_Wim_Update_Folder_Sources -ErrorAction SilentlyContinue

		<#
			.判断到文件时，保存到指定任务
		#>
		Write-Host "  $($lang.SaveTo): " -ForegroundColor Yellow
		Write-Host "  $($Local_Wim_Update_Full_Path)" -ForegroundColor Green
		if (Test-Path -Path $Local_Wim_Update_Full_Path -PathType Leaf) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006020`n  Start"
			}

			Write-Host "  $($lang.Done)" -ForegroundColor Green

			$Temp_Queue_Temp_Save_Update_Rule_Task = @{
				Group         = "$($Master);$($Master);"
				Uid           = $Uid
				ImageFileName = "$($RandomGuid).wim"
				FileName      = $Local_Wim_Update_Full_Path
				AbsolutePath  = $ImageFileMount
				UpdatePath    = $NewUpdatePath
			}

			New-Variable -Scope global -Name "Queue_Is_Update_Rule_Expand_Rule_$($Uid)" -Value $Temp_Queue_Temp_Save_Update_Rule_Task -Force

			<#
				.清空任务
			#>
			Write-Host "`n  $($lang.EventManagerClear)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Primary_Key_Image.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Primary_Key_Image.Uid -ForegroundColor Green

			<#
				.添加已执行过的任务，不再执行
			#>
			if ($Global:Extension_Has_been_Run -NotContains $Uid) {
				$Global:Extension_Has_been_Run += $Uid
			}

			Write-Host "`n  $($lang.DeDuplication)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($Uid)`n" -ForegroundColor Red

			Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Extension_Has_been_Run) {
				Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($item)`n" -ForegroundColor Green
			}

			if ($Global:Developers_Mode) {
				Write-Host "  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006020`n  End"
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

Function Run_Expand
{
	param
	(
		$Uid,
		$NewMain,
		$NewExpand,
		$MountFileName
	)

	<#
		.设置首选主键
	#>
	Image_Set_Global_Primary_Key -Uid $Uid -DevCode "24"

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
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006010`n  Start"
			}

			Expand_Process_abc -Uid $Uid -Master $NewMain.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount $MountFileName

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006010`n  End"
			}
		} else {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006000`n  Start"
			}

			#region 检查到主映像文件后，并挂载
			Write-Host "`n  $($lang.ProcessingImage)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($MountFileName)" -ForegroundColor Green

			if (Test-Path -Path $MountFileName -PathType Leaf) {
				Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				$TempQueueProcessImageSelect = @()
				if ($Global:Developers_Mode) {
					Write-Host "`n  $($lang.Developers_Mode_Location): 28`n"
				}

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Get-WindowsImage -ImagePath ""$($MountFileName)""" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				try {
					Get-WindowsImage -ImagePath $MountFileName -ErrorAction SilentlyContinue | ForEach-Object {
						$TempQueueProcessImageSelect += [pscustomobject]@{
							Index            = $_.ImageIndex
							Name             = $_.ImageName
							ImageDescription = $_.ImageDescription
						}
					}
				} catch {
					Write-Host $_ -ForegroundColor Red
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}

				<#
					.判断是否已选择分配扩展，索引号
				#>
				$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Uid)" -ErrorAction SilentlyContinue).Value
				Write-Host "`n  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
					ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $itemBB.Index -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $itemBB.Name -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $itemBB.ImageDescription -ForegroundColor Yellow

						Write-Host
					}

					ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Uid)" -ErrorAction SilentlyContinue).Value

						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Uid);, $($lang.MountedIndex): $($itemBB.Index), $($lang.Wim_Image_Name): $($itemBB.Name)"

							Write-Host "  $($lang.MountedIndex): " -noNewline
							Write-Host $itemBB.Index -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Name): " -noNewline
							Write-Host $itemBB.Name -ForegroundColor Yellow

							Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
							Write-Host $itemBB.ImageDescription -ForegroundColor Yellow

							if (Event_Assign_Task_Verify -Mount) {
								Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"

								Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $Uid -ForegroundColor Green

								Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
								Write-Host "  $($MountFileName)`n" -ForegroundColor Green

								Image_Mount_Check -MountFileName $MountFileName -Index $itemBB.Index
								Expand_Process_abc -Uid $Uid -Master $NewMain.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount $MountFileName
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
				$Get_Current_Process_Type_Temp = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Is_Type_$($Uid)" -ErrorAction SilentlyContinue).Value
				switch ($Get_Current_Process_Type_Temp) {
					"Auto" {
						Write-Host "`n  $($lang.Index_Process_All)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						$TempQueueProcessImageSelect = @()
						try {
							if ($Global:Developers_Mode) {
								Write-Host "`n  $($lang.Developers_Mode_Location): 28"
							}

							if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
								Write-Host "  $($lang.Command)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  Get-WindowsImage -ImagePath ""$($MountFileName)""" -ForegroundColor Green
								Write-Host "  $('-' * 80)`n"
							}

							Get-WindowsImage -ImagePath $MountFileName -ErrorAction SilentlyContinue | ForEach-Object {
								$TempQueueProcessImageSelect += [pscustomobject]@{
									Index            = $_.ImageIndex
									Name             = $_.ImageName
									ImageDescription = $_.ImageDescription
								}
							}
						} catch {
							Write-Host "  $($_)" -ForegroundColor Red
							Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
						}

						if ($TempQueueProcessImageSelect.count -gt 0) {
							Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $item.ImageDescription -ForegroundColor Yellow

								Write-Host
							}

							Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Uid), $($lang.MountedIndex): $($item.Index), $($lang.Wim_Image_Name): $($item.Name)"

								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $item.ImageDescription -ForegroundColor Yellow

								if (Event_Assign_Task_Verify -Mount) {
									Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"

									Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
									Write-Host $Uid -ForegroundColor Green

									Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
									Write-Host "  $($MountFileName)`n" -ForegroundColor Green

									<#
										.挂载主文件
									#>
									Image_Mount_Check -MountFileName $MountFileName -Index $item.Index
									Expand_Process_abc -Uid $Uid -Master $NewMain.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount $MountFileName
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
						Image_Select_Popup_UI

						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($Uid)" -ErrorAction SilentlyContinue).Value

						Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $itemBB.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $itemBB.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $itemBB.ImageDescription -ForegroundColor Yellow

								Write-Host
							}

							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Popup_Pending_$($Uid)" -ErrorAction SilentlyContinue).Value

								if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
									$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Uid);, $($lang.MountedIndex): $($itemBB.Index), $($lang.Wim_Image_Name): $($itemBB.Name)"

									Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"

									Write-Host "  $($lang.MountedIndex): " -noNewline
									Write-Host $itemBB.Index -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Image_Name): " -noNewline
									Write-Host $itemBB.Name -ForegroundColor Yellow

									Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
									Write-Host $itemBB.ImageDescription -ForegroundColor Yellow

									if (Event_Assign_Task_Verify -Mount) {
										Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
										Write-Host $Uid -ForegroundColor Green

										Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
										Write-Host "  $($MountFileName)`n" -ForegroundColor Green

										<#
											.挂载主文件
										#>
										Image_Mount_Check -MountFileName $MountFileName -Index $itemBB.Index
										Expand_Process_abc -Uid $Uid -Master $NewMain.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount $MountFileName
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
						$Temp_Queue_Process_Image_Select_Pending = (Get-Variable -Scope global -Name "Queue_Process_Image_Select_Pending_$($Uid)" -ErrorAction SilentlyContinue).Value
						if ($Temp_Queue_Process_Image_Select_Pending.Count -gt 0) {
							ForEach ($itemBB in $Temp_Queue_Process_Image_Select_Pending) {
								Write-Host "  $($lang.MountedIndex): " -noNewline
								Write-Host $itemBB.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -noNewline
								Write-Host $itemBB.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $itemBB.ImageDescription -ForegroundColor Yellow

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
								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $item.ImageDescription -ForegroundColor Yellow

								Write-Host
							}

							Write-Host "  $($lang.AddQueue)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							ForEach ($item in $TempQueueProcessImageSelect) {
								Write-Host "  $($lang.MountedIndex): " -NoNewline
								Write-Host $item.Index -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
								Write-Host $item.Name -ForegroundColor Yellow

								Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
								Write-Host $item.ImageDescription -ForegroundColor Yellow

								if ($Temp_Queue_Process_Image_Select_Pending.Index -Contains $item.Index) {
									if (Event_Assign_Task_Verify -Mount) {
										Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"

										Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
										Write-Host $Uid -ForegroundColor Green

										Write-Host "  $($lang.Select_Path)" -ForegroundColor Yellow
										Write-Host "  $($MountFileName)`n" -ForegroundColor Green

										<#
											.挂载主文件
										#>
										Image_Mount_Check -MountFileName $MountFileName -Index $item.Index
										Expand_Process_abc -Uid $Uid -Master $NewMain.ImageFileName -NewUpdatePath $NewExpand.UpdatePath -ImageFileMount $MountFileName
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
				Write-Host "  $($MountFileName)" -ForegroundColor Red
			}
			#endregion 检查到主映像文件后，并挂载

			if ($Global:Developers_Mode) {
				Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006000`n  End"
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