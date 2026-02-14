<#
	.Additional Edition process
	.附加版本处理

	 1. 循环所有映像版本
		2. 检查是否有可用的事件
		   3. 如果检查到有，则强行卸载：规则：按群组

		      4. 卸载完成后，开始执行处理事件。

			     a. 先判断扩展事件，有的话先处理版本转换
				 b. 处理主要事件，如果有则强行弹出所有事件。
#>

Function Image_Additional_Edition_Process
{
	param
	(
		$Uid
	)

	$isForceStop = $False
	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): [ Image_Additional_Edition_Process ] E7x004060`n  End"
	}

	Image_Set_Global_Primary_Key -Silent -Uid $Uid -DevCode "Autopilot - 9000"

	Write-Host "  $($lang.AE_IsCheck)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	write-host "  " -NoNewline
	$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Additional_Edition.Count -gt 0) {
		Write-Host " $($lang.AE_IsRuning) " -BackgroundColor DarkGreen -ForegroundColor White

		<#
			.全局变量
		#>
		$GroupImageFileDetailed = @()

		<#
			.AE 生成的临时文件
		#>
		$TempSaveAEFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.AE.Temp.wim"
		remove-item -path $TempSaveAEFileTo -force -ErrorAction SilentlyContinue
		if (Test-Path $TempSaveAEFileTo -PathType Leaf) {
			$RandomGuid = [guid]::NewGuid()
			$TempSaveAEFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.AE.Temp.$($RandomGuid).wim"
		}

		<#
			1. 强行弹出已挂载
		#>
		Write-Host "`n  $($lang.Image_Unmount_After)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Additional_Edition_Force_Eject_Mount -Uid $Uid

		Write-Host "`n  $($lang.AddSources) $($Temp_Additional_Edition.Rule.Count) $($lang.EventManagerCount)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		[int]$SNTasks = "0"
		ForEach ($itemRule in $Temp_Additional_Edition.Rule) {
			$SNTasks++
			Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($SNTasks)/$($Temp_Additional_Edition.Rule.count)" -NoNewline -ForegroundColor Green
			Write-host " $($lang.EventManagerCount)"

			write-host "  $($lang.AdditionalEdition): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Name -ForegroundColor Green

			write-host "  $($lang.AE_Required_EditionID): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Requiredversion -ForegroundColor Green

			write-host "  $($lang.AE_New_EditionID): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.NewEditionId -ForegroundColor Green

			write-host "  $($lang.KMSKey): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Productkey -ForegroundColor Green

			write-host "  $($lang.Detailed): "
			write-host "    $($lang.Wim_Image_Name): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.ImageName -ForegroundColor Green

			write-host "    $($lang.Wim_Image_Description): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.Description -ForegroundColor Green

			write-host "    $($lang.Wim_Display_Name): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayName -ForegroundColor Green

			write-host "    $($lang.Wim_Display_Description): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayDescription -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			write-host
		}

		<#
			.获取旧文件的所有详细信息
		#>
		Write-Host "`n  $($lang.Detailed)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
		if (Test-Path -Path $wimlib -PathType Leaf) {
			$RandomGuid = [guid]::NewGuid()
			$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
			$Arguments = "info ""$($Global:Primary_Key_Image.FullPath)"" --extract-xml ""$($Export_To_New_Xml)"""
			Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

			if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
				[XML]$empDetails = Get-Content $Export_To_New_Xml

				ForEach ($empDetail in $empDetails.wim.IMAGE) {
					$GroupImageFileDetailed += [pscustomobject]@{
						Index              = $empDetail.index
						Name               = $empDetail.NAME
						ImageDescription   = $empDetail.DESCRIPTION
						EditionId          = $empDetail.FLAGS
					}
				}
				Remove-Item -Path $Export_To_New_Xml
			}
		} else {
			try {
				Get-WindowsImage -ImagePath $Global:Primary_Key_Image.FullPath -ErrorAction SilentlyContinue | ForEach-Object {
					Get-WindowsImage -ImagePath $Global:Primary_Key_Image.FullPath -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
						$GroupImageFileDetailed += [pscustomobject]@{
							Index            = $_.ImageIndex
							Name             = $_.ImageName
							ImageDescription = $_.ImageDescription
							EditionId        = $_.EditionId
						}
					}
				}
			} catch {
				Write-hsot "$($lang.SelectFileFormatError): $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Red
				return
			}
		}

		if ($GroupImageFileDetailed.count -gt 0) {
			foreach ($item in $GroupImageFileDetailed) {
				Write-Host "  $($lang.MountedIndex): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Index -ForegroundColor Yellow

				write-host "  $($lang.Wim_Image_Name): " -NoNewline -ForegroundColor Yellow
				write-host $item.Name -ForegroundColor Green

				Write-Host "  $($lang.Wim_Image_Description): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.ImageDescription -ForegroundColor Green

				write-host "  $($lang.Wim_Edition): " -NoNewline -ForegroundColor Yellow
				write-host $item.EditionId -ForegroundColor Green
				Write-Host
			}
		} else {
			Write-hsot "$($lang.SelectFileFormatError): $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Red
			return
		}

		<#
			.开始处理
		#>
		Write-Host "`n  $($lang.AddQueue) $($Temp_Additional_Edition.Rule.Count) $($lang.EventManagerCount)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		[int]$SNTasks = "0"
		ForEach ($itemRule in $Temp_Additional_Edition.Rule) {
			$SNTasks++
			$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.AdditionalEdition): $($itemRule.Name), $($lang.EventManager): $($SNTasks)/$($Temp_Additional_Edition.Rule.Count)"

			$SingleTaskTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
			$SingleTaskTime = New-Object System.Diagnostics.Stopwatch
			$SingleTaskTime.Reset()
			$SingleTaskTime.Start()

			Write-Host "  $($lang.TimeStart)" -NoNewline
			Write-Host " $($SingleTaskTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			#region Showinfo
			Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($SNTasks)/$($Temp_Additional_Edition.Rule.Count)" -NoNewline -ForegroundColor Green
			Write-host " $($lang.EventManagerCount)"

			write-host "  $($lang.AdditionalEdition): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Name -ForegroundColor Green

			write-host "  $($lang.AE_Required_EditionID): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Requiredversion -ForegroundColor Green

			write-host "  $($lang.AE_New_EditionID): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.NewEditionId -ForegroundColor Green

			write-host "  $($lang.KMSKey): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Productkey -ForegroundColor Green

			write-host "  $($lang.Detailed): "
			write-host "    $($lang.Wim_Image_Name): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.ImageName -ForegroundColor Green

			write-host "    $($lang.Wim_Image_Description): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.Description -ForegroundColor Green

			write-host "    $($lang.Wim_Display_Name): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayName -ForegroundColor Green

			write-host "    $($lang.Wim_Display_Description): " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayDescription -ForegroundColor Green
			#endregion

			<#
				.判断所需版本是否存在
			#>
			if ($GroupImageFileDetailed.EditionId -contains $itemRule.Requiredversion) {
				write-host "`n  $($lang.AE_Required_EditionID): " -NoNewline -ForegroundColor Yellow
				write-host $itemRule.Requiredversion -NoNewline -ForegroundColor Green

				Write-Host ", $($lang.Running): " -NoNewline -ForegroundColor Yellow
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor White -ForegroundColor Black

				Write-Host "`n  $($lang.Export_Image)" -ForegroundColor Yellow
				Write-Host "  $('.' * 80)"
				foreach ($ExportOld in $GroupImageFileDetailed) {
					if ($ExportOld.EditionId -eq $itemRule.Requiredversion) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline -ForegroundColor Yellow
						Write-Host $ExportOld.Index -ForegroundColor Yellow

						write-host "  $($lang.Wim_Image_Name): " -NoNewline -ForegroundColor Yellow
						write-host $ExportOld.Name -ForegroundColor Green

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline -ForegroundColor Yellow
						Write-Host $ExportOld.ImageDescription -ForegroundColor Green

						write-host "  $($lang.Wim_Edition): " -NoNewline -ForegroundColor Yellow
						write-host $ExportOld.EditionId -ForegroundColor Green

						Write-Host "  $($lang.SelectSettingImage): " -NoNewline -ForegroundColor Yellow
						Write-Host $Global:Primary_Key_Image.FullPath -ForegroundColor Green

						Write-Host "  $('.' * 80)"
						write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
						write-host $TempSaveAEFileTo -ForegroundColor Green

						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Export-WindowsImage -SourceImagePath ""$($Global:Primary_Key_Image.FullPath)"" -SourceIndex ""$($ExportOld.Index)"" -DestinationImagePath ""$($TempSaveAEFileTo)"" -CompressionType $($Temp_Additional_Edition.Adv.Compression)" -ForegroundColor Green
							Write-Host "  $('-' * 80)"
						}

						#region Rebuild
						$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($ExportOld.Index), $($lang.Export_Image)"
						Write-Host
						Write-Host "  " -NoNewline
						Write-Host " $($lang.Export_Image) " -NoNewline -BackgroundColor White -ForegroundColor Black
						try {
							Export-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\AE.log" -SourceImagePath $Global:Primary_Key_Image.FullPath -SourceIndex $ExportOld.Index -DestinationImagePath $TempSaveAEFileTo -CompressionType Max -ErrorAction SilentlyContinue | Out-Null	
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

							Write-Host "`n  $($lang.Setting): $($lang.MountedIndex): " -NoNewline
							$GetLastIndex = @()
							Get-WindowsImage -ImagePath $TempSaveAEFileTo -ErrorAction SilentlyContinue | ForEach-Object {
								$GetLastIndex += $_.ImageIndex
							}
						} catch {
							Write-Host "  $($_)" -ForegroundColor Red
							Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
						}
						#endregion

						#region Get last index
						$GetLastIndex = $GetLastIndex | Select-Object -Last 1
						Write-Host $GetLastIndex -ForegroundColor Yellow
						if (Test-Path -Path $wimlib -PathType Leaf) {
							$Arguments = "info ""$($TempSaveAEFileTo)"" $($GetLastIndex) --image-property NAME=""$($itemRule.Detailed.ImageName)"" --image-property DESCRIPTION=""$($itemRule.Detailed.Description)"" --image-property DISPLAYNAME=""$($itemRule.Detailed.DisplayName)"" --image-property DISPLAYDESCRIPTION=""$($itemRule.Detailed.DisplayDescription)"" --image-property FLAGS=""$($itemRule.NewEditionId)"""
							Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
						}
						#endregion

						<#
							.排除项：是否排除挂载
						#>
						#region Exclude mount
						write-host "`n  $($lang.Mounted_Status): " -NoNewline -ForegroundColor Yellow
						if ($Temp_Additional_Edition.Exclude -contains $itemRule.NewEditionId) {
							Write-Host " $($lang.ExcludeItem) " -BackgroundColor DarkRed -ForegroundColor White
						} else {
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.Mount)"

							Write-Host " $($lang.Mount) " -BackgroundColor DarkGreen -ForegroundColor White
							Write-Host

							Image_Mount_Check -MountFileName $TempSaveAEFileTo -Index $GetLastIndex
							$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

							<#
								.更改映像版本
							#>
							#region Editions change
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.Editions), $($lang.Change)"

							Write-Host "`n  $($lang.Editions), $($lang.Change): " -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
  							Write-Host "  " -NoNewline
  							Write-Host " $($lang.AE_New_EditionID) " -NoNewline -BackgroundColor White -ForegroundColor Black
							Write-Host " $($itemRule.NewEditionId) " -BackgroundColor DarkGreen -ForegroundColor White

							$GetCurrentEditionVersion = @()
							try {
								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  (Get-WindowsEdition -Path $($test_mount_folder_Current)).Edition" -ForegroundColor Green
									Write-Host "  $('-' * 80)"
								}

								$CurrentEdition = (Get-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current).Edition
								$GetCurrentEditionVersion += $CurrentEdition
								
								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Get-WindowsEdition -Path ""$($test_mount_folder_Current)"" -Target" -ForegroundColor Green
									Write-Host "  $('-' * 80)"
								}

								Get-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current -Target | ForEach-Object {
									$GetCurrentEditionVersion += $_.Edition
								}

								Write-Host
								Write-Host "  $($lang.Editions), $($lang.Existed): "
								Write-Host "  $('-' * 80)"
								foreach ($itemNV in $GetCurrentEditionVersion) {
									if ($CurrentEdition -eq $itemNV) {
										Write-Host "  $($itemNV)" -ForegroundColor Green
									} else {
										Write-Host "  $($itemNV)"
									}
								}

  								Write-Host
  								Write-Host "  " -NoNewline
  								Write-Host " $($lang.MatchMode) " -NoNewline -BackgroundColor White -ForegroundColor Black
								Write-Host " $($itemRule.NewEditionId) " -BackgroundColor DarkGreen -ForegroundColor White
								Write-Host "  $('-' * 80)"
								if ($GetCurrentEditionVersion -contains $itemRule.NewEditionId) {
									write-host "  $($lang.UpdateAvailable)" -ForegroundColor Green

									if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
										Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"
										Write-Host "  Set-WindowsEdition -Path ""$($test_mount_folder_Current)"" -Edition ""$($itemRule.NewEditionId)""" -ForegroundColor Green
										Write-Host "  $('-' * 80)"
									}

									Write-Host
									Write-Host "  " -NoNewline
									Write-Host " $($lang.Change) " -NoNewline -BackgroundColor White -ForegroundColor Black
									try {
										Set-WindowsEdition -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Set.log" -Path $test_mount_folder_Current -Edition $itemRule.NewEditionId
										Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
									} catch {
										Write-Host "  $($_)" -ForegroundColor Red
										Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
										Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
									}
								} else {
									Write-Host "  $($lang.MatchDownloadNoNewitem)" -ForegroundColor Red
								}
							} catch {
								Write-Host "  $($_)" -ForegroundColor Red
								Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
								Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
							}
							#endregion

							<#
								.更改序列号
							#>
							#region product key
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.OOBEProductKey), $($lang.Change)"

							Write-Host "`n  $($lang.OOBEProductKey), $($lang.Change): " -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ([string]::IsNullOrEmpty($itemRule.Productkey)) {
								Write-Host "  $($lang.NoWork) " -ForegroundColor Red
							} else {
								Write-Host "  $($lang.Setting): $($lang.OOBEProductKey): " -NoNewline
								Write-Host " $($itemRule.Productkey) " -BackgroundColor DarkGreen -ForegroundColor White

								if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
									Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
									Write-Host "  $('-' * 80)"
									Write-Host "  Set-WindowsProductKey -Path ""$($test_mount_folder_Current)"" -ProductKey ""$($itemRule.Productkey)""" -ForegroundColor Green
									Write-Host "  $('-' * 80)"
								}

								Write-Host
								Write-Host "  " -NoNewline
								Write-Host " $($lang.Change) " -NoNewline -BackgroundColor White -ForegroundColor Black
								try {
									Set-WindowsProductKey -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Set.log" -Path $test_mount_folder_Current -ProductKey $itemRule.Productkey
									Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
								} catch {
									Write-Host "  $($_)" -ForegroundColor Red
									Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
									Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
								}
							}
							#endregion

							<#
								.默认允许保存，除非在健康检查中触发不保存
							#>
							$IsEjectAfterSave = $True

							<#
								.健康
							#>
							#region Healthy
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.Healthy)"

							Write-Host "`n  $($lang.Healthy)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							if ($Temp_Additional_Edition.Adv.Healthy.isAllow) {
								$HealthyTasksTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
								$HealthyTasksTime = New-Object System.Diagnostics.Stopwatch
								$HealthyTasksTime.Reset()
								$HealthyTasksTime.Start()

								Write-Host "  $($lang.TimeStart)" -NoNewline
								Write-Host " $($HealthyTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green

								<#
									.触发此事件强制结束
								#>
								if (Healthy_Check_Process -NewPath $test_mount_folder_Current) {
									
								} else {
									Write-Host "  $($lang.HealthyForceStop)" -ForegroundColor Red
									Write-Host "  $('-' * 80)"

									Write-Host "  $($lang.Healthy_Save)`n" -ForegroundColor Red
									if ($Temp_Additional_Edition.Adv.Healthy.ErrorNoSave) {
										Write-Host "  $($lang.Operable)`n" -ForegroundColor Green

										$IsEjectAfterSave = $Flase
										$isForceStop = $True
										Additional_Edition_Reset
										Event_Reset_Variable

										AZ_Error_Page
									} else {
										Write-Host "  $($lang.NoWork)" -ForegroundColor Red
									}
								}

								$HealthyTasksTime.Stop()
								Write-Host "`n  $($lang.Healthy), $($lang.Done)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
								Write-Host "  $($lang.TimeStart)" -NoNewline
								Write-Host "$($HealthyTasksTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

								Write-Host "  $($lang.TimeEnd)" -NoNewline
								Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

								Write-Host "  $($lang.TimeEndAll)" -NoNewline
								Write-Host "$($HealthyTasksTime.Elapsed)" -ForegroundColor Yellow

								Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
								Write-Host "$($HealthyTasksTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
								Write-Host "  $('-' * 80)"
							} else {
								Write-Host "  $($lang.NoWork)" -ForegroundColor Red
							}
							#endregion

							<#
								.保存
							#>
							#region Save
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.Save)"

							Write-Host "`n  $($lang.Save)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Green
							if ($IsEjectAfterSave) {
								if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
									if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
										Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
										Write-Host "  $('-' * 80)"
										Write-Host "  Save-WindowsImage -Path ""$($test_mount_folder_Current)""" -ForegroundColor Green
										Write-Host "  $('-' * 80)"
									}

									Write-Host
									Write-Host "  " -NoNewline
									Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black
									Save-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Save.log" -Path $test_mount_folder_Current | Out-Null
									Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
								} else {
									Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
								}
							} else {
								Write-Host "  $($lang.Healthy_Save)" -ForegroundColor Red
							}
							#endregion

							<#
								.不保存
							#>
							#region Do not save
							$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.MountedIndex): $($GetLastIndex), $($lang.DoNotSave)"

							Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Green
							if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
								Image_Eject_Abandon -Uid $Global:Primary_Key_Image.Uid -VerifyPath $test_mount_folder_Current
							} else {
								Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
							}
							#endregion
						}
						#endregion
					}
				}
			} else {
				write-host "`n  $($lang.AE_Required_EditionID): " -NoNewline -ForegroundColor Yellow
				write-host $itemRule.Requiredversion -NoNewline -ForegroundColor Green

				Write-Host ", $($lang.SelectFromError): " -NoNewline -ForegroundColor Yellow
				Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
			}

			$SingleTaskTime.Stop()
			Write-Host "`n  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($SNTasks)/$($Temp_Additional_Edition.Rule.Count)" -NoNewline -ForegroundColor Green
			Write-host " $($lang.EventManagerCount)"

			Write-Host "  $('.' * 80)"
			Write-Host "  $($lang.TimeStart)" -NoNewline
			Write-Host "$($SingleTaskTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEnd)" -NoNewline
			Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAll)" -NoNewline
			Write-Host "$($SingleTaskTime.Elapsed)" -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
			Write-Host "$($SingleTaskTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host

			if ($isForceStop) {
				write-host "  $($lang.AssignForceEnd)" -ForegroundColor Red
				Get_Next -DevCode "ae 1"
				return
			}
		}

		<#
			.重建
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.AdditionalEdition), $($lang.Rebuild)"

		Write-Host "`n  $($lang.Rebuild)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ($Temp_Additional_Edition.Adv.Rebuild) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green
			Rebuild_Image_File -Filename $TempSaveAEFileTo
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		<#
			.备份当前文件到
		#>
		$Host.UI.RawUI.WindowTitle = "$($lang.Event_Primary_Key): $($Global:Primary_Key_Image.UID), $($lang.AdditionalEdition), $($lang.Backup)"

		Write-Host "`n  $($lang.Backup)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green

			Write-Host "`n  $($lang.ProcessSources)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Select_Path): " -NoNewline
			Write-Host $TempSaveAEFileTo -ForegroundColor Green
			if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
				$RandomGuid = [guid]::NewGuid()
				$SaveToName = [IO.Path]::GetFileName($Global:Primary_Key_Image.FullPath)
				$SaveFileToEsdTemp = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Backup\Additional edition\$($RandomGuid)"
				Check_Folder -chkpath $SaveFileToEsdTemp

				Write-Host "`n  $($lang.SaveTo)" -ForegroundColor Yellow
				Write-Host "     - $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Green
				Write-Host "     + $($SaveFileToEsdTemp)" -ForegroundColor Green

				Write-Host "`n  $($lang.CRCSHA): " -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				if (Test-Path -Path $SaveFileToEsdTemp -PathType Container) {
					Move-Item -Path $Global:Primary_Key_Image.FullPath -Destination $SaveFileToEsdTemp -ErrorAction SilentlyContinue

					$NewFileName = "$($SaveFileToEsdTemp)\$($SaveToName)"

					Write-Host "  1. $($lang.SaveTo)" -ForegroundColor Yellow
					Write-Host "     $($NewFileName)" -ForegroundColor Green
					Write-Host "     $('.' * 77)"
					if (Test-Path -Path "$($SaveFileToEsdTemp)\$($SaveToName)" -PathType Leaf) {
						Write-Host "     $($lang.Done)" -ForegroundColor Green

						write-host "`n  2. $($lang.ConvertChk)" -ForegroundColor Yellow
						Write-Host "     $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Green
						Write-Host "     $('.' * 77)"
						if (Test-Path -Path $Global:Primary_Key_Image.FullPath -PathType Leaf) {
							Write-Host "     $($lang.Existed) " -ForegroundColor Red
						} else {
							Write-Host "     $($lang.NoInstallImage)" -ForegroundColor Green

							write-host "`n  3. $($lang.Rename)" -ForegroundColor Yellow
							Write-Host "     - $($TempSaveAEFileTo)" -ForegroundColor Green
							Write-Host "     + $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Green
							Write-Host "     $('.' * 77)"

							Rename-Item -Path $TempSaveAEFileTo -NewName $Global:Primary_Key_Image.FullPath -ErrorAction SilentlyContinue
							if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
								Write-Host "     $($lang.Failed) " -ForegroundColor Red
							} else {
								if (Test-Path -Path $Global:Primary_Key_Image.FullPath -PathType Leaf) {
									Write-Host "     $($lang.Done) " -ForegroundColor Green
								} else {
									Write-Host "     $($lang.Failed) " -ForegroundColor Red
								}
							}
						}
					} else {
						Write-Host "     $($lang.Failed) " -ForegroundColor Red
					}
				} else {
					Write-Host "  $($lang.FailedCreateFolder)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.Failed)" -ForegroundColor Red
		}
	} else {
		Write-Host $lang.AE_NoEvent -ForegroundColor Red
	}
}

Function Additional_Edition_Force_Eject_Mount
{
	param (
		$Uid
	)

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Expand.Count -gt 0) {
			ForEach ($itemExpandNew in $item.Expand) {
				if ($itemExpandNew.Uid -eq $Uid) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $itemExpandNew.Uid -ForegroundColor Green

					if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($itemExpandNew.Uid)").Value) {
						Write-Host "  $($lang.Mounted)"

						$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"
						Image_Eject_Abandon -Uid $itemExpandNew.Uid -VerifyPath $Temp_Do_Not_Save_Path
					} else {
						Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
					}
				}
			}
		}

		if ($item.Main.Uid -eq $Uid) {
			if ($item.Expand.Count -gt 0) {
				ForEach ($itemExpandNew in $item.Expand) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $itemExpandNew.Uid -ForegroundColor Green

					if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($itemExpandNew.Uid)").Value) {
						Write-Host "  $($lang.Mounted)"

						$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($itemExpandNew.ImageFileName).$($itemExpandNew.Suffix)\Mount"
						Image_Eject_Abandon -Uid $itemExpandNew.Uid -VerifyPath $Temp_Do_Not_Save_Path
					} else {
						Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
					}

					Write-Host
				}
			}

			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			if ((Get-Variable -Scope global -Name "Mark_Is_Mount_$($item.Main.Uid)").Value) {
				Write-Host "  $($lang.Mounted)"

				$Temp_Do_Not_Save_Path = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"
				Image_Eject_Abandon -Uid $item.Main.Uid -VerifyPath $Temp_Do_Not_Save_Path
			} else {
				Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
			}
		}
	}
}

function Additional_Edition_Reset
{
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
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

function Additional_Edition_Reset_Uid
{
	param
	(
		$Uid
	)

	ForEach ($item in $Global:Image_Rule) {
		if ($Uid -eq $item.Main.Uid) {
			New-Variable -Scope global -Name "Queue_Additional_Edition_$($item.Main.Uid)" -Value @() -Force
			New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($item.Main.Uid)" -Value @() -Force

		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Uid -eq $Expand.Uid) {
					New-Variable -Scope global -Name "Queue_Additional_Edition_$($Expand.Uid)" -Value @() -Force
					New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Expand.Uid)" -Value @() -Force
				}
			}
		}
	}
}