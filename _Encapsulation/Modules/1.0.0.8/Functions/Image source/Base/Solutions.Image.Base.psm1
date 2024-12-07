<#
	.验证可用磁盘大小
#>
Function Verify_Available_Size
{
	param
	(
		[string]$Disk,
		[int]$Size
	)

	$TempCheckVerify = $false

	Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { ((Join_MainFolder -Path $Disk) -eq $_.Root) } | ForEach-Object {
		if ($_.Free -gt (Convert_Size -From GB -To Bytes $Size)) {
			$TempCheckVerify = $True
		} else {
			$TempCheckVerify = $false
		}
	}

	return $TempCheckVerify
}

Function Convert_Size
{
	param
	(
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$From,
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$To,
		[Parameter(Mandatory=$true)]
		[double]$Value,
		[int]$Precision = 4
	)

	switch($From) {
		"Bytes" { $value = $Value }
		"KB" { $value = $Value * 1024 }
		"MB" { $value = $Value * 1024 * 1024 }
		"GB" { $value = $Value * 1024 * 1024 * 1024 }
		"TB" { $value = $Value * 1024 * 1024 * 1024 * 1024 }
	}

	switch ($To) {
		"Bytes" { return $value }
		"KB" { $Value = $Value/1KB }
		"MB" { $Value = $Value/1MB }
		"GB" { $Value = $Value/1GB }
		"TB" { $Value = $Value/1TB }
	}

	return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
}

<#
	.Mount check
	.挂载检查
#>
Function Image_Mount_Check
{
	param
	(
		$MountFileName,
		$Index
	)

	Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"
	if (Test-Path -Path $test_mount_folder -PathType Container) {
		Write-Host "   $($lang.Mounted)"
	} else {
		Write-Host "   $($lang.NotMounted)"
		if (Test-Path -Path $test_mount_folder -PathType Container) {
			<#
				.强行卸载，不保存
				.Forcibly uninstall, do not save
			#>
			if ($Global:Developers_Mode) {
				Write-Host "`n   $($lang.Developers_Mode_Location): 80`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   Dismount-WindowsImage -Path ""$($test_mount_folder)"" -Discard" -ForegroundColor Green
				Write-Host "   $('-' * 80)`n"
			}

			Dismount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Dismount.log" -Path $test_mount_folder -Discard -ErrorAction SilentlyContinue | Out-Null
			Image_Mount_Force_Del -NewPath $test_mount_folder
			Write-Host "   $($lang.Done)" -ForegroundColor Green
		}
		Check_Folder -chkpath $test_mount_folder

		if (Test-Path -Path $MountFileName -PathType Leaf) {
			if ($Global:Developers_Mode) {
				Write-Host "`n   $($lang.Developers_Mode_Location): 81`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   Mount-WindowsImage -ImagePath ""$($MountFileName)"" -Index ""$($Index)"" -Path "$test_mount_folder"" -ForegroundColor Green
				Write-Host "   $('-' * 80)`n"
			}

			Write-Host "   $($lang.Mount)".PadRight(28) -NoNewline
			try {
				Mount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Mount.log" -ImagePath "$($MountFileName)" -Index $Index -Path $test_mount_folder | Out-Null
				Write-Host $lang.Done -ForegroundColor Green
			} catch {
				Write-Host $_
				Write-Host "   $($lang.Failed)" -ForegroundColor Red
			}
		} else {
			Write-Host "   $($lang.NoInstallImage)"
			Write-Host "   $($MountFileName)" -ForegroundColor Red
		}
	}
}

<#
	.Forcibly clean up mounted
	.强行清理已挂载
#>
Function Image_Mount_Force_Del
{
	param
	(
		$NewPath
	)

	<#
		.再次判断是否存在挂载目录，解决无法卸载问题
		.Determine whether there is a mount directory again, and solve the problem of not being able to unmount
	#>
	if (Test-Path -Path $NewPath -PathType Container) {
		<#
			.For the first time, to clean up the directory task, use the system's own command to clean up the directory instead of using the delete command
			.第一次，清理目录任务，使用系统自带命令清理目录，而不是使用删除命令
		#>
		dism /cleanup-wim | Out-Null
		Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null

		if (Test-Path -Path $NewPath -PathType Container) {
			If ($Null -eq (Get-ChildItem -Force "$($NewPath)")) {
				Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			} else {
				dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
			}
		}

		<#
			.After cleaning, judge whether the cleaning is successful, if it is found that the cleaning is not completed, repair command
			.清理后，判断是否清理成功，如果发现到未清理完成，执行修复命令
		#>
		if (Test-Path -Path $NewPath -PathType Container) {
			If ($Null -eq (Get-ChildItem -Force $NewPath)) {
				Dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
				TakeownFolder -path $NewPath
				Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			} else {
				<#
					.The second time, remount
					.第二次，重新挂载
				#>
				dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
				dism /Unmount-Wim /Mountdir:"""$($NewPath)""" /Discard | Out-Null
	
				if (Test-Path -Path $NewPath -PathType Container) {
					dism /cleanup-wim | Out-Null
					Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null

					dism /Online /Cleanup-Image /RestoreHealth /Source:"""$($NewPath)""" /LimitAccess | Out-Null
					dism /Unmount-Wim /Mountdir:"""$($NewPath)""" /Discard | Out-Null
					dism /Unmount-Image /MountDir:"""$($NewPath)""" /discard | Out-Null
				}
			}
		}
		
		<#
			.For the third time, if it fails, delete it forcibly.
			.第三次，不行就强行删除。
		#>
		if (Test-Path -Path $NewPath -PathType Container) {
			If ($Null -eq (Get-ChildItem -Force $NewPath)) {
				Dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
				TakeownFolder -path $NewPath
				Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			} else {
				Dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
				Dism /ScratchDir:"""$(Get_Mount_To_Temp)""" /LogPath:"$(Get_Mount_To_Logs)\Clear.log" /Unmount-Image /MountDir:"""$($NewPath)""" /discard

				if (Test-Path -Path $NewPath -PathType Container) {
					Remove_Tree $NewPath
				}
			}
		}
		
		<#
			.For the fourth time, four but three, it went on strike.
			.第四次，四不过三，罢工了。
		#>
		if (Test-Path -Path $NewPath -PathType Container) {
			If ($Null -eq (Get-ChildItem -Force $NewPath)) {
				TakeownFolder -path $NewPath
				Remove-Item -Path $NewPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			} else {
				Write-Host "`n   $($lang.UnmountFailed)" -ForegroundColor Red
				start-process "timeout.exe" -argumentlist "/t 6 /nobreak" -wait -nonewwindow
			}
		}
	}
}

<#
	.Read the image source mount status from the system
	.从系统里读取映像源挂载状态
#>
Function Image_Get_Mount_Status
{
	param
	(
		[switch]$IsHotkey,
		[switch]$Silent
	)

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			Image_Get_Mount_Status_New -ImageMaster $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -Shortcuts $item.Main.Shortcuts -Silent $Silent -IsHotkey $IsHotkey

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					Image_Get_Mount_Status_New -ImageMaster $item.Main.ImageFileName -ImageName $Expand.ImageFileName -ImageFile "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)" -Shortcuts $Expand.Shortcuts -Silent $Silent -IsHotkey $IsHotkey
				}
			}
		}
	}
}

Function Image_Get_Mount_Status_New
{
	param
	(
		$ImageMaster,
		$ImageName,
		$ImageFile,
		$Shortcuts,
		$IsHotkey,
		$Silent
	)

	<#
		.标记：全局：匹配的是否已挂载
	#>
	New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $False -Force
 
	<#
		.标记：判断是否合法
	#>
	New-Variable -Name "Mark_Is_Legal_Sources_$($ImageMaster)_$($ImageName)" -Value $False -Force

	<#
		.判断 ISO 主要来源是否存在文件
	#>
	if (Test-Path -Path $ImageFile -PathType leaf) {
		if ($Silent) {
		} else {
			<#
				.自动选择主键
			#>
			if ($Global:Primary_Key_Image.ImageFileName -eq $ImageName) {
				Write-Host "   [*]" -NoNewline -ForegroundColor Green
			} else {
				Write-Host "      " -NoNewline
			}

			If (([String]::IsNullOrEmpty($Shortcuts))) {

			} else {
				if ($IsHotkey) {
					Write-host " " -NoNewline
					Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-host " " -NoNewline

					Write-Host " VW " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-Host " " -NoNewline

					Write-Host " $($Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
					Write-Host " $($ImageName)".PadRight(8) -NoNewline -ForegroundColor Yellow
				} else {
					Write-Host " " -NoNewline
					Write-Host " $($Shortcuts) " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
					Write-Host " $($ImageName)".PadRight(8) -NoNewline -ForegroundColor Yellow
				}
			}
		}

		<#
			.Get all mounted images from the current system that match the current one
			.从当前系统里获取所有已挂载镜像与当前匹配
		#>
		$MarkErrorMounted = $False
		try {
			<#
				.标记是否捕捉到事件
			#>
			Get-WindowsImage -Mounted -ErrorAction SilentlyContinue | ForEach-Object {
				$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($ImageMaster)\$($ImageName)\Mount"

				<#
					.判断文件路径与当前是否一致
				#>
				if ($_.ImagePath -eq $ImageFile) {
					$ImageIndexNew = $_.ImageIndex

					switch ($_.MountStatus) {
						"Invalid" {
							$MarkErrorMounted = $True
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "   $($lang.MountedIndex): $($ImageName)" -NoNewline -ForegroundColor Yellow

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
										Write-Host "      $($lang.MountedIndexError)" -ForegroundColor Red
									} else {
										Write-Host "      $($lang.NotMounted)" -ForegroundColor Red
									}
								} else {
									Write-Host "      $($lang.NotMounted)" -ForegroundColor Red
								}
							}
						}
						"NeedsRemount" {
							$MarkErrorMounted = $True
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "   $($lang.MountedIndex): $($ImageName)" -NoNewline -ForegroundColor Yellow

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
										Write-Host "      $($lang.MountedIndexError)" -ForegroundColor Red
									} else {
										Write-Host "      $($lang.NotMounted)" -ForegroundColor Red
									}
								} else {
									Write-Host "      $($lang.NotMounted)" -ForegroundColor Red
								}
							}
						}
						"Ok" {
							$MarkErrorMounted = $True
							New-Variable -Name "Mark_Is_Legal_Sources_$($ImageMaster)_$($ImageName)" -Value $True -Force
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "   $($lang.MountedIndex): $($ImageIndexNew)" -NoNewline -ForegroundColor Yellow

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									Write-Host "      $($lang.MountedIndexSuccess)" -ForegroundColor Green
								} else {
									Write-Host "      $($lang.NotMounted)" -ForegroundColor Red
								}
							}
						}
						Default {
							$MarkErrorMounted = $True
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "   $($lang.MountedIndexError)" -ForegroundColor Red
							}
						}
					}
				}
			}
		} catch {
			if (-not $Silent) {
				Write-Host "   $($lang.MountedIndexError)" -ForegroundColor Green
			}
		}

		if ($MarkErrorMounted) {

		} else {
			if (-not $Silent) {
				Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
			}
		}
	}
}

<#
	.获取当前是否已挂载后，返回索引号
#>
Function Image_Get_Mount_Index
{
	$MarkErrorMounted = $False
	$Index = ""

	<#
		.判断 ISO 主要来源是否存在文件
	#>
	if (Test-Path -Path $Global:Primary_Key_Image.FullPath -PathType leaf) {
		<#
			.Get all mounted images from the current system that match the current one
			.从当前系统里获取所有已挂载镜像与当前匹配
		#>
		Get-WindowsImage -Mounted -ErrorAction SilentlyContinue | ForEach-Object {
			<#
				.判断文件路径与当前是否一致
			#>
			if ($_.ImagePath -eq $Global:Primary_Key_Image.FullPath) {
				$MarkErrorMounted = $True
				$Index = $_.ImageIndex
			}
		}
	}

	if ($MarkErrorMounted) {
		return $Index
	} else {
		return "Not"
	}
}

function Get_Mount_To_Logs
{
	$Temp_New_Temp_Path = "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"

	if (Test_Available_Disk -Path $Temp_New_Temp_Path) {
		Check_Folder -chkpath $Temp_New_Temp_Path

		return $Temp_New_Temp_Path
	}

	$Local_Temp_Main_Path = "$($env:userprofile)\AppData\Local\Temp\Logs"
	Check_Folder -chkpath $Local_Temp_Main_Path
	return $Local_Temp_Main_Path
}

function Get_Mount_To_Temp
{
	$RandomGuid = [guid]::NewGuid()
	$Temp_New_Temp_Path = Join-Path -Path $Global:Mount_To_RouteTemp -ChildPath $RandomGuid

	if (Test_Available_Disk -Path $Temp_New_Temp_Path) {
		Check_Folder -chkpath $Temp_New_Temp_Path

		return $Temp_New_Temp_Path
	}

	$Local_Temp_Main_Path = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	Check_Folder -chkpath $Local_Temp_Main_Path
	return $Local_Temp_Main_Path
}

function Get-RandomHexNumber
{
	param
	( 
		[int]$length = 20,
		[string]$chars = "0123456789"
	)

	$bytes = new-object "System.Byte[]" $length
	$rnd = new-object System.Security.Cryptography.RNGCryptoServiceProvider
	$rnd.GetBytes($bytes)
	$result = ""

	1..$length | ForEach-Object {
		$result += $chars[ $bytes[$_] % $chars.Length ]	
	}

	return $result
}

Function Image_Set_Primary_Key_Shortcuts
{
	param
	(
		$Name
	)

	Write-Host "`n   $($lang.Command): " -NoNewline
	Write-host "Sel $($Name)" -ForegroundColor Green
	Write-Host "   $('-' * 80)"

	Write-Host "`n   $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "   $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "   $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

			Write-Host "   $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $TestWimFile -ForegroundColor Green

			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				Image_Set_Global_Primary_Key -Uid $item.Main.Uid -Detailed -DevCode "0406"
			} else {
				Write-Host "`n   $($lang.NoInstallImage)"
				Write-Host "   $($TestWimFile)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "   $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "   $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green
					$NewFileFullPathExpand = "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Write-Host "   $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $NewFileFullPathExpand -ForegroundColor Green

					if (Test-Path -Path $NewFileFullPathExpand -PathType Leaf) {
						Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "1208"
					} else {
						Write-Host "`n   $($lang.NoInstallImage)"
						Write-Host "   $($NewFileFullPathExpand)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "   $($lang.NoWork)" -ForegroundColor Red
}

Function Image_Primary_Key_Shortcuts_File_View
{
	param
	(
		$Name
	)

	Write-Host "`n   $($lang.Command): " -NoNewline
	Write-host "VW $($Name)" -ForegroundColor Green
	Write-Host "   $('-' * 80)"

	Write-Host "`n   $($lang.ViewWIMFileInfo) *" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "   $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "   $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

			Write-Host "   $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $TestWimFile -ForegroundColor Green

			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				Image_Get_Detailed -Filename $TestWimFile -View
			} else {
				Write-Host "`n   $($lang.NoInstallImage)"
				Write-Host "   $($TestWimFile)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "   $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "   $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green
					$NewFileFullPathExpand = "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Write-Host "   $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $NewFileFullPathExpand -ForegroundColor Green

					if (Test-Path -Path $NewFileFullPathExpand -PathType Leaf) {
						Image_Get_Detailed -Filename $NewFileFullPathExpand -View
					} else {
						Write-Host "`n   $($lang.NoInstallImage)"
						Write-Host "   $($NewFileFullPathExpand)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "   $($lang.NoWork)" -ForegroundColor Red
}