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

	Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"
	if (Test-Path -Path $test_mount_folder -PathType Container) {
		Write-Host "  $($lang.Mounted)"
	} else {
		Write-Host "  $($lang.NotMounted)"

		if (Test-Path -Path $test_mount_folder -PathType Container) {
			<#
				.强行卸载，不保存
				.Forcibly uninstall, do not save
			#>
			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 80`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "   Dismount-WindowsImage -Path ""$($test_mount_folder)"" -Discard" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Dismount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Dismount.log" -Path $test_mount_folder -Discard -ErrorAction SilentlyContinue | Out-Null
			Image_Mount_Force_Del -NewPath $test_mount_folder
			Write-Host "  $($lang.Done)" -ForegroundColor Green
		}
		Check_Folder -chkpath $test_mount_folder

		if (Test-Path -Path $MountFileName -PathType Leaf) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 81`n" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "   Mount-WindowsImage -ImagePath ""$($MountFileName)"" -Index ""$($Index)"" -Path "$test_mount_folder"" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Write-Host "  $($lang.Mount)".PadRight(28) -NoNewline
			try {
				Mount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Mount.log" -ImagePath "$($MountFileName)" -Index $Index -Path $test_mount_folder | Out-Null
				Write-Host $lang.Done -ForegroundColor Green
			} catch {
				Write-Host $_
				Write-Host "  $($lang.Failed)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.NoInstallImage)"
			Write-Host "  $($MountFileName)" -ForegroundColor Red
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
				Write-Host "`n  $($lang.UnmountFailed)" -ForegroundColor Red
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
		[switch]$IsHotkeyShort,
		[switch]$Silent
	)

	if ($Silent) {

	} else {
		Write-host "  " -NoNewline
		if ($IsHotkeyShort) {
			Write-host "$($lang.Short_Cmd): " -NoNewline
			Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host " " -NoNewline
			Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host ", " -NoNewline
		}

		if ($IsHotkey) {
			Write-host "$($lang.Short_Cmd): " -NoNewline

			if (Image_Is_Mount) {
				Write-Host " Esa " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-host " " -NoNewline
				Write-Host " Edns " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-host " " -NoNewline
			}

			Write-Host " MT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host " " -NoNewline
			Write-Host " Save " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host " " -NoNewline
			Write-Host " Unmount " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host " " -NoNewline
			Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host " " -NoNewline
			Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host ", " -NoNewline
		}

		Write-host "$($lang.Event_Primary_Key): "
	}

	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			Image_Get_Mount_Status_New -ImageMaster $item.Main.ImageFileName -ImageName $item.Main.ImageFileName -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -Shortcuts $item.Main.Shortcuts -Silent $Silent

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					Image_Get_Mount_Status_New -ImageMaster $item.Main.ImageFileName -ImageName $Expand.ImageFileName -ImageFile "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)" -Shortcuts $Expand.Shortcuts -Silent $Silent
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
				Write-Host "  [*]" -NoNewline -ForegroundColor Green
			} else {
				Write-Host "     " -NoNewline
			}

			If (([String]::IsNullOrEmpty($Shortcuts))) {
				Write-Host " $($ImageName)".PadRight(8) -NoNewline -ForegroundColor Yellow
			} else {
				Write-host " " -NoNewline
				Write-Host " $($Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
				Write-Host " $($ImageName)".PadRight(8) -NoNewline -ForegroundColor Yellow
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
								Write-Host "  $($lang.MountedIndex): $($ImageIndexNew) " -NoNewline -ForegroundColor Yellow
								Write-host "  " -NoNewline

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
										Write-Host " $($lang.MountedIndexError)" -BackgroundColor Darkred -ForegroundColor White
									} else {
										Write-host " " -NoNewline
										Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
									}
								} else {
									Write-host " " -NoNewline
									Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
								}
							}
						}
						"NeedsRemount" {
							$MarkErrorMounted = $True
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "  $($lang.MountedIndex): $($ImageIndexNew) " -NoNewline -ForegroundColor Yellow
								Write-host "  " -NoNewline

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
										Write-Host " $($lang.MountedIndexError)" -BackgroundColor Darkred -ForegroundColor White
									} else {
										Write-host " " -NoNewline
										Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
									}
								} else {
									Write-host " " -NoNewline
									Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
								}
							}
						}
						"Ok" {
							$MarkErrorMounted = $True
							New-Variable -Name "Mark_Is_Legal_Sources_$($ImageMaster)_$($ImageName)" -Value $True -Force
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "  $($lang.MountedIndex): $($ImageIndexNew) " -NoNewline -ForegroundColor Yellow
								Write-host "  " -NoNewline

								if (Test-Path -Path $test_mount_folder -PathType Container) {
									Write-Host " $($lang.Mounted) " -NoNewline -ForegroundColor Green
									Write-Host " $($lang.Healthy) " -BackgroundColor Darkgreen -ForegroundColor Black
								} else {
									Write-host " " -NoNewline
									Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
								}
							}
						}
						Default {
							$MarkErrorMounted = $True
							New-Variable -Scope global -Name "Mark_Is_Mount_$($ImageMaster)_$($ImageName)" -Value $True -Force

							if (-not $Silent) {
								Write-Host "  $($lang.MountedIndexError)" -BackgroundColor Darkred -ForegroundColor White
							}
						}
					}
				}
			}
		} catch {
			if (-not $Silent) {
				Write-Host "  $($lang.MountedIndexError)" -ForegroundColor Green
			}
		}

		if ($MarkErrorMounted) {

		} else {
			if (-not $Silent) {
				Write-host " " -NoNewline
				Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
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

Function Image_Select_Mount_Shortcuts
{
	Write-Host "`n  $($lang.Mount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
			Image_Select_Index_UI
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

Function Image_Set_Primary_Key_Shortcuts
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Sel" -ForegroundColor Green

	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Write-Host "`n  $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			if ($item.Main.Shortcuts -eq $Name) {
				Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Group -ForegroundColor Green

				Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Uid -ForegroundColor Green

				$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host $TestWimFile -ForegroundColor Green

				if (Test-Path -Path $TestWimFile -PathType Leaf) {
					Image_Set_Global_Primary_Key -Uid $item.Main.Uid -Detailed -DevCode "0406"
				} else {
					Write-Host "`n  $($lang.NoInstallImage)"
					Write-Host "  $($TestWimFile)" -ForegroundColor Red
				}

				return
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Shortcuts -eq $Name) {
						Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Group -ForegroundColor Green

						Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Uid -ForegroundColor Green
						$NewFileFullPathExpand = "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

						Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $NewFileFullPathExpand -ForegroundColor Green

						if (Test-Path -Path $NewFileFullPathExpand -PathType Leaf) {
							Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "1208"
						} else {
							Write-Host "`n  $($lang.NoInstallImage)"
							Write-Host "  $($NewFileFullPathExpand)" -ForegroundColor Red
						}

						return
					}
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

Function Image_Primary_Key_Shortcuts_File_View
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "View" -ForegroundColor Green

	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Write-Host "`n  $($lang.ViewWIMFileInfo) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

			Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $TestWimFile -ForegroundColor Green

			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				Image_Get_Detailed -Filename $TestWimFile -View
			} else {
				Write-Host "`n  $($lang.NoInstallImage)"
				Write-Host "  $($TestWimFile)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green
					$NewFileFullPathExpand = "$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $NewFileFullPathExpand -ForegroundColor Green

					if (Test-Path -Path $NewFileFullPathExpand -PathType Leaf) {
						Image_Get_Detailed -Filename $NewFileFullPathExpand -View
					} else {
						Write-Host "`n  $($lang.NoInstallImage)"
						Write-Host "  $($NewFileFullPathExpand)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

<#
	.快捷指令，添加
#>
Function Menu_Shortcuts_Image_Sources_Add
{
	Write-Host "`n  $($lang.AddTo)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429"
			Image_Select_Add_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429e"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，添加 + 主键
#>
Function Menu_Shortcuts_Image_Sources_Add_IAB
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Suffix -eq "wim") {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
		$Global:Primary_Key_Image = @()
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	if (Image_Is_Select_IAB) {
		Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
			Image_Select_Add_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令：删除
#>
Function Menu_Shortcuts_Remove
{
	Write-Host "`n  $($lang.Del)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
			Image_Select_Del_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令：删除 + 索引号
#>
Function Menu_Shortcuts_Remove_Index
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Suffix -eq "wim") {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	<#
		.判断主键范围
	#>
	Write-Host "`n  $($lang.MountedIndexSelect): " -NoNewline
	Write-Host $NewRuleName -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	$IsNumber = [int]::TryParse($NewRuleName, [ref]$null)
	if ($IsNumber) {
		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Verify_Is_Current_Same) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Red
			} else {
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
				Image_Select_Del_UI -AutoSelectIndex $NewRuleName
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

			ToWait -wait 2
			Image_Assign_Event_Master
		}
	} else {
		Write-Host "  $($lang.VerifyNumberFailed)" -ForegroundColor Red
		
		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Del)" -ForegroundColor Green

			ToWait -wait 2
			Image_Select_Del_UI
		}
	}
}

<#
	.快捷指令：挂载
#>
Function Menu_Shortcuts_Mount
{
	Write-Host "`n  $($lang.Mount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
			Image_Select_Index_UI
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，挂载 + 主键 + 索引号
#>
Function Menu_Shortcuts_Mount_Index
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 3).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Suffix -eq "wim") {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	<#
		.判断主键范围
	#>
	Write-Host "`n  $($lang.MountedIndexSelect): " -NoNewline
	Write-Host $NewRuleName -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	$IsNumber = [int]::TryParse($NewRuleName, [ref]$null)
	if ($IsNumber) {
		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Verify_Is_Current_Same) {
				Write-Host "  $($lang.Mounted)" -ForegroundColor Red
			} else {
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
				Image_Select_Index_UI -AutoSelectIndex $NewRuleName
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

			ToWait -wait 2
			Image_Assign_Event_Master
		}
	} else {
		Write-Host "  $($lang.VerifyNumberFailed)" -ForegroundColor Red

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

			ToWait -wait 2
			Image_Select_Index_UI
		}
	}
}

<#
	.快捷指令，映像内文件：提取、更新
#>
Function Menu_Shortcuts_Euwl
{
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "euwl" -ForegroundColor Green

	Write-Host "`n  $($lang.Wim_Rule_Update)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "9846"
		Wimlib_Extract_And_Update
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，导出
#>
Function Menu_Shortcuts_Export
{
	Write-Host "`n  $($lang.Export_Image)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1"
			Image_Select_Export_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1end"
			Get_Next
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，导出 + 主键
#>
Function Menu_Shortcuts_Export_Key
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		$Scope += $item.Main.Shortcuts

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				$Scope += $Expand.Shortcuts
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	if (Image_Is_Select_IAB) {
		Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1"
			Image_Select_Export_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1end"
			Get_Next
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，重建映像文件
#>
Function Menu_Shortcuts_Rebuild
{
	Write-Host "`n  $($lang.Rebuild)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，重建映像文件 + 主键
#>
Function Menu_Shortcuts_Rebuild_Key
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Suffix -eq "wim") {
			$Scope += $item.Main.Shortcuts
		
			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Suffix -eq "wim") {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
		$Global:Primary_Key_Image = @()
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	Write-Host "`n  $($lang.Rebuild)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "  $($lang.Mounted)" -ForegroundColor Red
		} else {
			Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，应用
#>
Function Menu_Shortcuts_Apply
{
	Write-Host "`n  $($lang.Apply)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Image_Select_Index_UI
		Get_Next
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，应用
#>
Function Menu_Shortcuts_Apply_Key
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		$Scope += $item.Main.Shortcuts

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				$Scope += $Expand.Shortcuts
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Image_Set_Primary_Key_Shortcuts -Name $NewImageIndex
	}

	Write-Host "`n  $($lang.Apply)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Image_Select_Index_UI
		Get_Next
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令：组：InBox Apps
#>
Function Menu_Shortcuts_InBox_Apps_IA
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "IA" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			InBox_Apps_Menu_Shortcuts_Add
		}
		"d" {
			InBox_Apps_Menu_Shortcuts_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：本地语言体验包（LXPs）
#>
Function Menu_Shortcuts_LXPs_EP
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "EP" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			InBox_Apps_Menu_Shortcuts_LXPs_Add
		}
		"d" {
			InBox_Apps_Menu_Shortcuts_LXPs_Delete
		}
		"u" {
			InBox_Apps_Menu_Shortcuts_LXPs_Update
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：累积更新
#>
Function Menu_Shortcuts_Cumulative_updates_CU
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "CU" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"c" {
			Create_Template_UI
		}
		"a" {
			Update_Menu_Shortcuts_Add
		}
		"d" {
			Update_Menu_Shortcuts_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：驱动
#>
Function Menu_Shortcuts_Drive
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "DD" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			Drive_Menu_Shortcuts_Add
		}
		"d" {
			Drive_Menu_Shortcuts_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：组：映像版本
#>
Function Menu_Shortcuts_Image_version
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "IV" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"c" {
			Editions_GUI
		}
		"k" {
			Editions_GUI
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：组：Windows 功能
#>
Function Menu_Shortcuts_Windows_features
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "WF" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"e" {
			Feature_Menu_Shortcuts_Enabled
		}
		"d" {
			Feature_Menu_Shortcuts_Disabled
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：PowerShell Functions 函数功能
#>
Function Menu_Shortcuts_PowerShell_functions
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "PF" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"b" {
			Functions_Menu_Shortcuts_PFB
		}
		"a" {
			Functions_Menu_Shortcuts_PFA
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：PowerShell Functions 函数功能：不受限制
#>
Function Menu_Shortcuts_PowerShell_functions_Unrestricted
{
	param
	(
		$Command
	)

	$Global:Function_Unrestricted = @()
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "FX" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"list" {
			Functions_Tasks_List
			Get_Next
		}
		default {
			if ([string]::IsNullOrEmpty($NewRuleName)) {
				Functions_Unrestricted_UI
			} else {
				Functions_Unrestricted_UI -Custom "Other_Tasks_$($NewRuleName)"
			}
		}
	}
}

<#
	.快捷指令：检查更新
#>
Function Menu_Shortcuts_Update
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Upd" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"auto" {
			Update -Auto
		}
		default {
			Update
		}
	}
}

<#
	.快捷指令：修复
#>
Function Menu_Shortcuts_Fix
{
	Write-Host "`n  $($lang.Repair)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-Host "   * $($lang.HistoryClearDismSave)" -ForegroundColor Green
	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "   Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*"" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null" -ForegroundColor Green
		Write-Host "  $('-' * 80)`n"
	}
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   * $($lang.Clear_Bad_Mount)" -ForegroundColor Green
	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "   dism /cleanup-wim" -ForegroundColor Green
		Write-Host "   Clear-WindowsCorruptMountPoint" -ForegroundColor Green
		Write-Host "  $('-' * 80)`n"
	}

	dism /cleanup-wim | Out-Null
	Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
}

<#
	.快捷指令：语言 + 映像
#>
Function Menu_Shortcuts_Image_Language
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "LP" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"e" {
			Language_Extract_UI
		}
		"a" {
			Language_Menu_Shortcuts_LA
		}
		"d" {
			Language_Menu_Shortcuts_LD
		}
		"s" {
			Language_Menu_Shortcuts_LS
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：语言 + 映像
#>
Function Menu_Shortcuts_Lang
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "lang" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	$Langpacks_Sources = "$($PSScriptRoot)\..\..\..\langpacks"
	switch ($NewRuleName) {
		"list" {
			Write-Host "`n  $($lang.AvailableLanguages)"
			Write-Host "  $('-' * 80)"

			$Match_Available_Languages = @()
			Get-ChildItem -Path $Langpacks_Sources -Directory -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path "$($_.FullName)\Lang.psd1" -PathType Leaf) {
					$Match_Available_Languages += $_.Basename
				}
			}

			if ($Match_Available_Languages.count -gt 0) {
				ForEach ($item in $Global:Languages_Available) {
					if ($Match_Available_Languages -contains $item.Region) {
						Write-Host "  $($item.Region)".PadRight(20) -NoNewline -ForegroundColor Green
						Write-Host $item.Name -ForegroundColor Yellow
					}
				}

				Get_Next
			} else {

			}
		}
		"auto" {
			Write-Host "`n  $($lang.SwitchLanguage): "
			Write-Host "  $('-' * 80)"
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "Language" -ErrorAction SilentlyContinue
			Write-Host "  $($lang.Done)" -ForegroundColor Green
			Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
		}
		default {
			Write-Host "`n  $($lang.SwitchLanguage): " -NoNewline
			Write-Host $NewRuleName -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			if (Test-Path "$($Langpacks_Sources)\$($NewRuleName)\Lang.psd1" -PathType Leaf) {
				Write-Host "  $($lang.Done)" -ForegroundColor Green
				Save_Dynamic -regkey "Solutions" -name "Language" -value $NewRuleName -String
				Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
			} else {
				Write-Host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
			}
		}
	}
}

<#
	.快捷指令：打开目录
#>
Function Menu_Shortcuts_OpenFolder
{
	param
	(
		$Command
	)

	if ($Command -like "O'D *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "O'D" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}

	if ($Command -like "OD *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "OD" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}

	if ($Command -like "O *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "O" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}
}


<#
	.快捷指令：设置
#>
Function Menu_Shortcuts_Setting
{
	param
	(
		$Command
	)

	if ($Command -like "s'et *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "S'et" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}

	if ($Command -like "set *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "Set" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}

	if ($Command -like "s *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "S" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}
}

<#
	.快捷指令：帮助
#>
Function Menu_Shortcuts_Help
{
	param
	(
		$Command
	)

	if ($Command -like "H'elp *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "H'elp" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 6).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}

	if ($Command -like "Help *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "Help" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}

	if ($Command -like "H *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "H" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}
}