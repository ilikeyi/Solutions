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
		if ($_.Free -gt (Convert_Size -From GB -To Bytes -Size $Size)) {
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
		[double]$Size,
		[int]$Precision = 4
	)

	switch($From) {
		"Bytes" { $Size = $Size }
		"KB" { $Size = $Size * 1024 }
		"MB" { $Size = $Size * 1024 * 1024 }
		"GB" { $Size = $Size * 1024 * 1024 * 1024 }
		"TB" { $Size = $Size * 1024 * 1024 * 1024 * 1024 }
	}

	switch ($To) {
		"Bytes" { return $Size }
		"KB" { $Size = $Size/1KB }
		"MB" { $Size = $Size/1MB }
		"GB" { $Size = $Size/1GB }
		"TB" { $Size = $Size/1TB }
	}

	return [Math]::Round($Size, $Precision, [MidPointRounding]::AwayFromZero)
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
	$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
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

			Image_Eject_Abandon -Uid $Global:Primary_Key_Image.Uid -VerifyPath $test_mount_folder
		}
		Check_Folder -chkpath $test_mount_folder

		if (Test-Path -Path $MountFileName -PathType Leaf) {
			if ($Global:Developers_Mode) {
				Write-Host "`n  $($lang.Developers_Mode_Location): 81" -ForegroundColor Green
			}

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Mount-WindowsImage -ImagePath ""$($MountFileName)"" -Index ""$($Index)"" -Path ""$($test_mount_folder)""" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
			}

			Write-Host
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Mount) " -NoNewline -BackgroundColor White -ForegroundColor Black
			try {
				Mount-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Mount.log" -ImagePath $MountFileName -Index $Index -Path $test_mount_folder | Out-Null
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} catch {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host "  $($_)" -ForegroundColor Red
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
		[switch]$Silent
	)

	if ($Silent) {

	} else {
		if ($IsHotkey) {
			Write-host "  " -NoNewline
			Write-host "$($lang.Short_Cmd): " -NoNewline -ForegroundColor Yellow

			Write-Host "$($lang.ViewWIMFileInfo) " -NoNewline
			Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host ", $($lang.Sel_Primary_Key) " -NoNewline
			Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host "." -NoNewline
		}
	}

	if ($Silent) {

	} else {
		Write-Host "  $($lang.Event_Primary_Key): " -ForegroundColor Yellow
	}

	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			Image_Get_Mount_Status_New -Uid $item.Main.Uid -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $item.Main.ImageFileName -Suffix $item.Main.Suffix -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -Shortcuts $item.Main.Shortcuts -Silent $Silent

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Image_Get_Mount_Status_New -Uid $Expand.Uid -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $Expand.ImageFileName -Suffix $Expand.Suffix -ImageFile $test_mount_folder_Current -Shortcuts $Expand.Shortcuts -Silent $Silent
				}
			}
		}
	}
}

Function Image_Get_Mount_Status_New
{
	param
	(
		$Uid,
		$Master,
		$MasterSuffix,
		$ImageName,
		$Suffix,
		$ImageFile,
		$Shortcuts,
		$Silent
	)

	<#
		.标记：全局：匹配的是否已挂载
	#>
	New-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)" -Value $False -Force
 
	<#
		.标记：判断是否合法
	#>
	New-Variable -Name "Mark_Is_Legal_Sources_$($Uid)" -Value $False -Force

	<#
		.判断 ISO 主要来源是否存在文件
	#>
	if (Test-Path -Path $ImageFile -PathType leaf) {
		if ($Silent) {
		} else {
			<#
				.自动选择主键
			#>
			if ($Global:Primary_Key_Image.Uid -eq $Uid) {
				Write-Host "  [*]" -NoNewline -ForegroundColor Green
			} else {
				Write-Host "     " -NoNewline
			}

			If (([String]::IsNullOrEmpty($Shortcuts))) {
				Write-Host " $($ImageName).$($Suffix)".PadRight(13) -NoNewline -ForegroundColor Yellow
			} else {
				Write-host " " -NoNewline
				Write-Host " $($Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
				Write-Host " $($ImageName).$($Suffix)".PadRight(13) -NoNewline -ForegroundColor Yellow
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
				$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Master).$($MasterSuffix)\$($ImageName).$($Suffix)\Mount"

				<#
					.判断文件路径与当前是否一致
				#>
				if ($_.ImagePath -eq $ImageFile) {
					$ImageIndexNew = $_.ImageIndex

					if ($_.Path -eq $test_mount_folder) {
						switch ($_.MountStatus) {
							"Invalid" {
								$MarkErrorMounted = $True
								New-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)" -Value $True -Force

								if (-not $Silent) {
									Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black

									if (Test-Path -Path $test_mount_folder -PathType Container) {
										Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

										if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
											Write-Host " $($lang.MountedIndex) " -NoNewline -BackgroundColor White -ForegroundColor Black
											Write-Host " $($ImageIndexNew) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

											Write-Host " $($lang.Healthy) " -NoNewline -BackgroundColor White -ForegroundColor Black
											Write-Host " $($lang.Invalid) " -BackgroundColor Darkred -ForegroundColor White
										} else {
											Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
										}
									} else {
										Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
									}
								}
							}
							"NeedsRemount" {
								$MarkErrorMounted = $True
								New-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)" -Value $True -Force

								if (-not $Silent) {
									Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black

									if (Test-Path -Path $test_mount_folder -PathType Container) {
										Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

										if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
											Write-Host " $($lang.MountedIndex) " -NoNewline -BackgroundColor White -ForegroundColor Black
											Write-Host " $($ImageIndexNew) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

											Write-Host " $($lang.Healthy) " -NoNewline -BackgroundColor White -ForegroundColor Black
											Write-Host " $($lang.NeedsRemount) " -BackgroundColor Darkred -ForegroundColor White
										} else {
											Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
										}
									} else {
										Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
									}
								}
							}
							"Ok" {
								$MarkErrorMounted = $True
								New-Variable -Name "Mark_Is_Legal_Sources_$($Uid)" -Value $True -Force
								New-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)" -Value $True -Force

								if (-not $Silent) {
									Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black

									if (Test-Path -Path $test_mount_folder -PathType Container) {
										Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

										Write-Host " $($lang.MountedIndex) " -NoNewline -BackgroundColor White -ForegroundColor Black
										Write-Host " $($ImageIndexNew) " -NoNewline -BackgroundColor Darkgreen -ForegroundColor Black

										Write-Host " $($lang.Healthy) " -NoNewline -BackgroundColor White -ForegroundColor Black
										Write-Host " $($lang.Healthy) " -BackgroundColor Darkgreen -ForegroundColor Black
									} else {
										Write-Host " $($lang.NotMounted) " -BackgroundColor Darkred -ForegroundColor White
									}
								}
							}
							Default {
								$MarkErrorMounted = $True
								New-Variable -Scope global -Name "Mark_Is_Mount_$($Uid)" -Value $True -Force

								if (-not $Silent) {
									Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black
									Write-Host " $($lang.ImageCodenameNo) " -BackgroundColor Darkred -ForegroundColor White
								}
							}
						}
					}
				}
			}
		} catch {
			if (-not $Silent) {
				Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host "  $($lang.MountedIndexError)" -BackgroundColor Darkred -ForegroundColor White
			}
		}

		if ($MarkErrorMounted) {

		} else {
			if (-not $Silent) {
				Write-Host " $($lang.Status) " -NoNewline -BackgroundColor White -ForegroundColor Black
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
	$MarkErrorMounted = $True
	$Index = ""

	<#
		.判断 ISO 主要来源是否存在文件
	#>
	if (([string]::IsNullOrEmpty($Global:Primary_Key_Image.FullPath))) {

	} else {
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
					$MarkErrorMounted = $False
					return $_.ImageIndex
				}
			}
		}
	}

	if ($MarkErrorMounted) {
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

function ConvertFrom-Bytes
{
	param (
		[Parameter(Mandatory = $true)]
		[long]$Bytes
	)
 
	switch ($Bytes) {
		{$_ -ge 1TB} { "{0:N2} TB" -f ($Bytes / 1TB); break }
		{$_ -ge 1GB} { "{0:N2} GB" -f ($Bytes / 1GB); break }
		{$_ -ge 1MB} { "{0:N2} MB" -f ($Bytes / 1MB); break }
		{$_ -ge 1KB} { "{0:N2} KB" -f ($Bytes / 1KB); break }
		default { "$($Bytes) Bytes" }
	}
}

Function ConvertToDate
{
	param(
		[uint32]$lowpart,
		[uint32]$highpart
	)

	$ft64 = ([UInt64]$highpart -shl 32) -bor $lowpart
	[datetime]::FromFileTime( $ft64 )
}

Function Get_MainMasterFolder
{
	$NewOtherRuleName = [IO.Path]::GetFileName($Global:Image_source)

	if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
		$NewOtherRuleName = [System.IO.Path]::GetPathRoot($Global:Image_source).Substring(0,1)
		return Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
	} else {
		return "$($Global:Image_source)_Custom"
	}
}