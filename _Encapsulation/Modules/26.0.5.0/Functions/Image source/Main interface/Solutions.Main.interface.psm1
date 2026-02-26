<#
   .Search image source: directory structure
   .搜索映像源: 目录结构
#>
$Init_Search_Image_Folder_Structure = "OS"

<#
	.Search Image Source: Directory structure, search for ISO home directory name
	.搜索映像源: 目录结构, 搜索 ISO 主目录名称
#>
$Global:Init_Search_ISO_Folder_Name = "_ISO"

<#
	.RAMDISK initializes the volume name
	.RAMDISK 初始化卷标名
#>
$Global:Init_RAMDISK_Volume_Label = "RAMDISK"

<#
	.Initialize selects the minimum disk size: 20GB
	.初始化选择磁盘最低大小: 20GB
#>
$InitSearchDiskMinSize = 20

<#
	.Search image source: exclude directories
	.搜索映像源: 排除目录
#>
$ExcludeDirectory = @(
	"Server"
	"Desktop"
	"_ISO"
)

<#
	.搜索目录里的文件格式
#>
$Global:SearchISOType = @(
	"*.iso"
)

$Global:SMExt = GetSupportTypes

$Global:Support_PS_Filename = @(
	".ps1"
	".psd1"
	".psm1"
)

<#
	.已知 MVS (MSDN) 版本
#>
$Script:Known_MSDN = @()

<#
	.已知语言包, 功能包
#>
$Script:Exclude_Fod_Or_Language = @()

<#
	.InBox Apps
#>
$Script:Exclude_InBox_Apps = @()

<#
	.从默认规则, 自定义规则里获取已知 ISO
#>
Function Refresh_Rule_ISO
{
	$Temp_Exclude_Fod_Or_Language = @()
	$Temp_Exclude_InBox_Apps = @()
	$Temp_Known_MSDN = @()

	<#
		.从预规则里获取 (MVS (MSDN))
	#>
	ForEach ($itemPre in $Global:Pre_Config_Rules) {
		ForEach ($item in $itemPre.Version) {
			<#
				.ISO
			#>
			ForEach ($itemmsdn in $item.ISO) {
				$Temp_Known_MSDN += [pscustomobject]@{
					ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
					CRCSHA = @{
						SHA256 = $itemmsdn.CRCSHA.SHA256
						SHA512 = $itemmsdn.CRCSHA.SHA512
					}
				}

				if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
					foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
						$Temp_Known_MSDN += [pscustomobject]@{
							ISO    = [System.IO.Path]::GetFileName($itemAlternative)
							CRCSHA = @{
								SHA256 = $itemmsdn.CRCSHA.SHA256
								SHA512 = $itemmsdn.CRCSHA.SHA512
							}
						}
					}
				}
			}

			<#
				.从预规则里获取 (语言包, 功能包)
			#>
			ForEach ($itemmsdn in $item.Language.ISO) {
				$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
					ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
					CRCSHA = @{
						SHA256 = $itemmsdn.CRCSHA.SHA256
						SHA512 = $itemmsdn.CRCSHA.SHA512
					}
				}

				if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
					foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
						$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
							ISO    = [System.IO.Path]::GetFileName($itemAlternative)
							CRCSHA = @{
								SHA256 = $itemmsdn.CRCSHA.SHA256
								SHA512 = $itemmsdn.CRCSHA.SHA512
							}
						}
					}
				}
			}

			<#
				.从自定义获取 ( InBox Apps )
			#>
			ForEach ($itemmsdn in $item.InboxApps.ISO) {
				$Temp_Exclude_InBox_Apps += [pscustomobject]@{
					ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
					CRCSHA = @{
						SHA256 = $itemmsdn.CRCSHA.SHA256
						SHA512 = $itemmsdn.CRCSHA.SHA512
					}
				}

				if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
					foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
						$Temp_Exclude_InBox_Apps += [pscustomobject]@{
							ISO    = [System.IO.Path]::GetFileName($itemAlternative)
							CRCSHA = @{
								SHA256 = $itemmsdn.CRCSHA.SHA256
								SHA512 = $itemmsdn.CRCSHA.SHA512
							}
						}
					}
				}
			}
		}
	}

	<#
		.从单条规则里获取
	#>
	ForEach ($item in $Global:Preconfigured_Rule_Language) {
		ForEach ($itemmsdn in $item.ISO) {
			$Temp_Known_MSDN += [pscustomobject]@{
				ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
				CRCSHA = @{
					SHA256 = $itemmsdn.CRCSHA.SHA256
					SHA512 = $itemmsdn.CRCSHA.SHA512
				}
			}

			if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
				foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
					$Temp_Known_MSDN += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemAlternative)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}
				}
			}
		}

		<#
			.从预规则里获取 (语言包, 功能包)
		#>
		ForEach ($itemmsdn in $item.Language.ISO) {
			$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
				ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
				CRCSHA = @{
					SHA256 = $itemmsdn.CRCSHA.SHA256
					SHA512 = $itemmsdn.CRCSHA.SHA512
				}
			}

			if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
				foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
					$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemAlternative)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}
				}
			}
		}

		<#
			.从自定义获取 ( InBox Apps )
		#>
		ForEach ($itemmsdn in $item.InboxApps.ISO) {
			$Temp_Exclude_InBox_Apps += [pscustomobject]@{
				ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
				CRCSHA = @{
					SHA256 = $itemmsdn.CRCSHA.SHA256
					SHA512 = $itemmsdn.CRCSHA.SHA512
				}
			}

			if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
				foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
					$Temp_Exclude_InBox_Apps += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemAlternative)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}
				}
			}
		}
	}

	<#
		.从用户自定义规则里获取 (MVS (MSDN))
	#>
	if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
		if ($Global:Custom_Rule.count -gt 0) {
			ForEach ($item in $Global:Custom_Rule) {
				ForEach ($itemmsdn in $item.ISO) {
					$Temp_Known_MSDN += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}

					if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
							$Temp_Known_MSDN += [pscustomobject]@{
								ISO    = [System.IO.Path]::GetFileName($itemAlternative)
								CRCSHA = @{
									SHA256 = $itemmsdn.CRCSHA.SHA256
									SHA512 = $itemmsdn.CRCSHA.SHA512
								}
							}
						}
					}
				}

				<#
					.从用户自定义规则里获取 (语言包, 功能包)
				#>
				ForEach ($itemmsdn in $item.Language.ISO) {
					$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}

					if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
							$Temp_Exclude_Fod_Or_Language += [pscustomobject]@{
								ISO    = [System.IO.Path]::GetFileName($itemAlternative)
								CRCSHA = @{
									SHA256 = $itemmsdn.CRCSHA.SHA256
									SHA512 = $itemmsdn.CRCSHA.SHA512
								}
							}
						}
					}
				}

				<#
					.从用户自定义规则里获取 ( InBox Apps )
				#>
				ForEach ($itemmsdn in $item.InboxApps.ISO) {
					$Temp_Exclude_InBox_Apps += [pscustomobject]@{
						ISO    = [System.IO.Path]::GetFileName($itemmsdn.ISO)
						CRCSHA = @{
							SHA256 = $itemmsdn.CRCSHA.SHA256
							SHA512 = $itemmsdn.CRCSHA.SHA512
						}
					}

					if ($itemmsdn.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $itemmsdn.AlternativeFilenames) {
							$Temp_Exclude_InBox_Apps += [pscustomobject]@{
								ISO    = [System.IO.Path]::GetFileName($itemAlternative)
								CRCSHA = @{
									SHA256 = $itemmsdn.CRCSHA.SHA256
									SHA512 = $itemmsdn.CRCSHA.SHA512
								}
							}
						}
					}
				}
			}
		}
	}

	<#
		.已知 MVS (MSDN) 版本
	#>
	$Script:Known_MSDN = @()
	foreach ($item in $Temp_Known_MSDN) {
		if ($Script:Known_MSDN.ISO -contains $item.ISO) {

		} else {
			$Script:Known_MSDN += [pscustomobject]@{
				ISO    = $item.ISO
				CRCSHA = @{
					SHA256 = $item.CRCSHA.SHA256
					SHA512 = $item.CRCSHA.SHA512
				}
			}
		}
	}

	<#
		.已知语言包, 功能包
	#>
	$Script:Exclude_Fod_Or_Language = @()
	foreach ($item in $Temp_Exclude_Fod_Or_Language) {
		if ($Script:Exclude_Fod_Or_Language.ISO -contains $item.ISO) {

		} else {
			$Script:Exclude_Fod_Or_Language += [pscustomobject]@{
				ISO    = $item.ISO
				CRCSHA = @{
					SHA256 = $item.CRCSHA.SHA256
					SHA512 = $item.CRCSHA.SHA512
				}
			}
		}
	}

	<#
		.InBox Apps
	#>
	$Script:Exclude_InBox_Apps = @()
	foreach ($item in $Temp_Exclude_InBox_Apps) {
		if ($Script:Exclude_InBox_Apps.ISO -contains $item.ISO) {

		} else {
			$Script:Exclude_InBox_Apps += [pscustomobject]@{
				ISO    = $item.ISO
				CRCSHA = @{
					SHA256 = $item.CRCSHA.SHA256
					SHA512 = $item.CRCSHA.SHA512
				}
			}
		}
	}
}

<#
	.Initialization: Disk source
	.初始化: 磁盘来源
#>
Function Image_Init_Disk_Sources
{
	<#
		.Mark the registry location
		.标记注册表位置
	#>
	$Path = "HKCU:\SOFTWARE\$($Global:Author)\Solutions"

	<#
		.Set the validation disk tag
		.设置验证磁盘标记
	#>
	$MarkGetDiskTo = $False
	if (Get-ItemProperty -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue) {
		$GetDiskTo = Get-ItemPropertyValue -Path $Path -Name "DiskTo" -ErrorAction SilentlyContinue
		if (Test_Available_Disk -Path $GetDiskTo) {
			$MarkGetDiskTo = $True
			$Global:MainMasterFolder = $GetDiskTo
			Save_Dynamic -regkey "Solutions" -name "DiskTo" -value $GetDiskTo
		}
	}

	if (-not ($MarkGetDiskTo)) {
		$GetCurrentDisk = (Join_MainFolder -Path (Split-Path -Path $PSScriptRoot -Qualifier))
		if (Test_Available_Disk -Path $GetCurrentDisk) {
			$MarkGetDiskTo = $True
			$Global:MainMasterFolder = Join-Path -Path $GetCurrentDisk -ChildPath $Init_Search_Image_Folder_Structure
			Save_Dynamic -regkey "Solutions" -name "DiskTo" -value $Global:MainMasterFolder
		}
	}

	if (-not ($MarkGetDiskTo)) {
		$ExcludeDisk = @(
			Join_MainFolder -Path $env:SystemDrive
			"A:\"
			"B:\"
		)

		$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Where-Object { $ExcludeDisk -notcontains $_.Root } | Select-Object -ExpandProperty 'Root'
		ForEach ($item in $drives) {
			if ($ExcludeDisk -notcontains $item) {
				if (Test_Available_Disk -Path $item) {
					Image_Set_Disk_Sources -Disk $(Join_MainFolder -Path $item)
					return
				}
			}
		}

		Image_Set_Disk_Sources -Disk (Join_MainFolder -Path $env:SystemDrive)
	}
}

<#
	.Setting: Disk source
	.设置: 磁盘来源
#>
Function Image_Set_Disk_Sources
{
	param
	(
		[string]$Disk
	)

	Save_Dynamic -regkey "Solutions" -name "DiskTo" -value $Disk
	$Global:MainMasterFolder = $Disk
}

<#
	.Select the image source user interface
	.选择映像源用户界面
#>
Function Image_Select
{
	param (
		$Page
	)

	<#
		.Mark the registry location
		.标记注册表位置
	#>
	$Path = "HKCU:\SOFTWARE\$($Global:Author)\Solutions"
	if (Test-Path -Path $Path) {

	} else {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	<#
		.Initialization: Disk
		.初始化: 磁盘
	#>
	Image_Init_Disk_Sources

	<#
		.初始化: API
	#>
	If (Test-Path -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom") {
	} else {
		$InitPath = Join-Path -Path $([Environment]::GetFolderPath("Desktop")) -ChildPath "$($Global:Author).ps1"
		Save_Dynamic -regkey "Solutions\API\Custom\$($Global:Author)" -name "Path" -value $InitPath
	}

	if ($Page) {

	} else {
		Logo -Title $lang.SelectSettingImage
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.Logging): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)" -ForegroundColor Green

		Write-Host "`n  $($lang.SelectSettingImage)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	}

	<#
		.Create an array of languages and use them for later comparison
		.创建语言数组, 后期对比使用
	#>
	$Global:LanguageFull = @()
	$Global:LanguageShort = @()
	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$Global:LanguageFull += $itemRegion.Region
		$Global:LanguageShort += $itemRegion.Tag
	}

	Add-Type -AssemblyName System.Windows.Forms, System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Exclude_Add_DiskTo
	{
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
			$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue

			$GetAddFolderExclude = @()
			foreach ($item in $GetDiskTo) {
				$GetAddFolderExclude += $item
			}

			if ($GetAddFolderExclude.count -gt 0) {
				$isExclude = @()
				
				try {
					$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
					foreach ($exclusion in $extensionExclusion.ExclusionPath) {
						if ($GetAddFolderExclude -contains $exclusion) {
							$isExclude += $exclusion
						}
					}
				} catch {
					
				}

				$WaitAddExclude = @()

				<#
					.Windows Defender 已添加排除项
				#>
				$ExcludeAdded = @()
				if ($isExclude.Count -gt 0) {
					foreach ($item in $GetAddFolderExclude) {
						if ($item -NotContains $isExclude) {
							$ExcludeAdded += $item
						}
					}

					foreach ($item in $GetAddFolderExclude) {
						if ($item -contains $ExcludeAdded) {
							$WaitAddExclude += $item
						}
					}
				} else {
					foreach ($AddRAMDISK in $GetAddFolderExclude) {
						$WaitAddExclude += $AddRAMDISK
					}
				}

				if ($GetAddFolderExclude.Count -gt 0) {
					foreach ($item in $GetAddFolderExclude) {
						if ($WaitAddExclude -contains $item) {
							Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
							$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.Done)"
						} else {
							$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.Existed)"
						}
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.NoWork)"
				}
			} else {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
			}
		} else {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
		}
	}

	Function Exclude_Add_Custom
	{
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue) {
			$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue

			$GetAddFolderExclude = @()
			foreach ($item in $GetDiskTo) {
				$GetAddFolderExclude += $item
			}

			if ($GetAddFolderExclude.count -gt 0) {
				$isExclude = @()

				try {
					$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
					foreach ($exclusion in $extensionExclusion.ExclusionPath) {
						if ($GetAddFolderExclude -contains $exclusion) {
							$isExclude += $exclusion
						}
					}
				} catch {
					
				}

				$WaitAddExclude = @()

				<#
					.Windows Defender 已添加排除项
				#>
				$ExcludeAdded = @()
				if ($isExclude.Count -gt 0) {
					foreach ($item in $GetAddFolderExclude) {
						if ($item -NotContains $isExclude) {
							$ExcludeAdded += $item
						}
					}

					foreach ($item in $GetAddFolderExclude) {
						if ($item -contains $ExcludeAdded) {
							$WaitAddExclude += $item
						}
					}
				} else {
					foreach ($AddRAMDISK in $GetAddFolderExclude) {
						$WaitAddExclude += $AddRAMDISK
					}
				}

				foreach ($item in $GetAddFolderExclude) {
					if ($WaitAddExclude -contains $item) {
						Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.Done)"
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.Existed)"
					}
				}
			} else {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
			}
		} else {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
		}
	}

	Function Exclude_Add_Ramdisk
	{
		<#
			.获取 RAMDISK 卷标名
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
			<#
				.从注册表获取卷标名
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
				$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue

				$GetRAMDISK = @()
				Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
					if ($_.Label -eq $CustomRAMDISKLabel) {
						$GetRAMDISK += (Join_MainFolder -Path $_.DriveLetter)
					}
				}

				if ($GetRAMDISK.count -gt 0) {
					$isExclude = @()
					try {
						$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
						foreach ($exclusion in $extensionExclusion.ExclusionPath) {
							if ($GetRAMDISK -contains $exclusion) {
								$isExclude += $exclusion
							}
						}
					} catch {

					}

					$WaitAddExclude = @()
					if ($isExclude.Count -gt 0) {
						foreach ($item in $GetRAMDISK) {
							if ($item -NotContains $isExclude) {
								$WaitAddExclude += $item
							}
						}
					} else {
						foreach ($AddRAMDISK in $GetRAMDISK) {
							$WaitAddExclude += $AddRAMDISK
						}
					}

					if ($WaitAddExclude.Count -gt 0) {
						foreach ($item in $WaitAddExclude) {
							Add-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
						}

						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.Done)"
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AddTo), $($lang.NoWork)"
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
				}
			} else {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed), $($lang.SelectFromError)"
			}
		} else {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
		}
	}

	Function Solutions_API_Backup
	{
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

		$GetALlName = @()
		Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom" -ErrorAction SilentlyContinue | ForEach-Object {
			$GetNewPath = $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue) {
				$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue
			} else {
				$GetImportFileName = ""
			}


			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "NoImport" -ErrorAction SilentlyContinue) {
				$GetImportNoImport = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "NoImport" -ErrorAction SilentlyContinue
			} else {
				$GetImportNoImport = "False"
			}

			$GetALlName += [pscustomobject]@{
				Name = $GetNewPath
				Path = $GetImportFileName
				NoImport = $GetImportNoImport
			}
		}

		if ($GetALlName.Count -gt 0) {
			$NewTempFileNameGUID = "API.Backup.$(Get-Date -Format "yyyyMMddHHmmss").json"

			$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
				FileName         = $NewTempFileNameGUID
				Filter           = "API Backup Files (*.json;)|*.json;"
				InitialDirectory = $InitialPath
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$GroupBackupNew = [PSCustomObject]@{
					Name = "$($Global:Author)'s Soultions"
					Url = "$((Get-Module -Name Solutions).HelpInfoURI)"
					Description = "API Backup"
					version = $((Get-Module -Name Solutions).PrivateData.PSData.API.MinimumVersion)
					API = $GetALlName
				}
				$GroupBackupNew | ConvertTo-Json | Out-File -FilePath $FileBrowser.FileName -Encoding utf8 -ErrorAction SilentlyContinue

				if (Test-Path -Path $FileBrowser.FileName -PathType leaf) {
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Backup): $($FileBrowser.FileName), $($lang.Done)"
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Backup): $($FileBrowser.FileName), $($lang.Failed)"
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			} else {
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupAPIErrorMsg.Text = $lang.UserCanel
			}
		} else {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = $lang.NoWork
		}
	}

	Function Solutions_API_Restore
	{
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

		$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
			Filter = "json Files (*.json)|*.json"
		}

		if ($FileBrowser.ShowDialog() -eq "OK") {
			try {
				$ReadBackupJson = Get-Content -Raw -Path $FileBrowser.FileName | ConvertFrom-Json

				if ($ReadBackupJson.Version.Replace('.', '') -ge $((Get-Module -Name Solutions).PrivateData.PSData.API.MinimumVersion).Replace('.', '')) {
					if ($ReadBackupJson.API.Count -gt 0) {
						foreach ($item in $ReadBackupJson.API) {
							Save_Dynamic -regkey "Solutions\API\Custom\$($item.Name)" -name "Path" -value $item.Path
							Save_Dynamic -regkey "Solutions\API\Custom\$($item.Name)" -name "NoImport" -value $item.NoImport
						}

						Refresh_Rule_Shortcuts
						$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Restore), $($lang.Done)"
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$GUIImageSourceGroupAPIErrorMsg.Text = $lang.NoWork
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\info.ico")
					}
				} else {
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Autopilot_Config_File_Low): $($FileBrowser.FileName)"
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			} catch {
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFileFormatError): $($FileBrowser.FileName)"
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		} else {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = $lang.UserCanel
		}
	}

	Function System_Env_Test_Order
	{
		$Current_Folder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Router" -ErrorAction SilentlyContinue
		$GetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue
		$windows_path = $GetVarPath -split ';'

		$RandomGuid = [guid]::NewGuid()
		$newFileName = Join-Path -Path $env:Temp -ChildPath $RandomGuid

		$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
		[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")
		Invoke-Expression -Command "Yi -Guid $($newFileName)"

		if (Test-Path -Path $newFileName -PathType leaf) {
			remove-item -path $newFileName -force -ErrorAction SilentlyContinue
			return
		}
		remove-item -path $newFileName -force -ErrorAction SilentlyContinue

		for ($i = 1; $i -le $windows_path.Count; $i++) {
			$RefreshGetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue
			$windows_path = $RefreshGetVarPath -split ';'

			<#
				.Configure the system variables from the registry and delete the routing directory
				.从注册表里系统变量配置, 并删除路由目录
			#>
			$NewGroupPathNotOldPath = @()
			Foreach ($item in $windows_path) {
				if ($item -ne $Current_Folder) {
					$NewGroupPathNotOldPath += $item
				}
			}

			$CalcCurrentPath = @()
			$CalcCurrentValue = 0
			Foreach ($item in $windows_path) {
				$CalcCurrentValue++

				$CalcCurrentPath += [pscustomobject]@{
					SN = $CalcCurrentValue
					OldPath = $item
				}
			}

			<#
				.Get the path number
				.获取路径所在序号
			#>
			$FlagOrage = ""
			Foreach ($item in $CalcCurrentPath) {
				if ($item.OldPath -eq $Current_Folder) {
					$FlagOrage = $item.SN
					break
				}
			}

			$NewGroupAll = @()
			$FalgRunCalcCurrentValue = 0
			Foreach ($item in $NewGroupPathNotOldPath) {
				$FalgRunCalcCurrentValue++

				$FlagOragefs = $FlagOrage -1

				if ($FalgRunCalcCurrentValue -eq $FlagOragefs) {
					$NewGroupAll += $Current_Folder
				}

				$NewGroupAll += $item
			}

			$result = [string]::Join(";", $NewGroupAll)
			$result = $result.TrimEnd(';')

			Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $result
			$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
			[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")
			Invoke-Expression -Command "Yi -Guid $($newFileName)"

			if (Test-Path -Path $newFileName -PathType leaf) {
				remove-item -path $newFileName -force -ErrorAction SilentlyContinue
				return
			}
		}

		$GetVarPath = "$($GetVarPath);$($Current_Folder)"
		Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $GetVarPath
		remove-item -path $newFileName -force -ErrorAction SilentlyContinue
	}

	Function Solutions_API_Add_New_Rule_Name
	{
		param
		(
			[switch]$IsForce
		)

		$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
		$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"

		if (Solutions_API_Verify_New_RuleName) {
			if ($IsForce) {
				If (Test-Path -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GUIImageSourceGroupAPI_Rule_Path.Text)") {
				} else {
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.NoInstallImage), $($lang.PleaseChoose): $($lang.AddTo)"
					$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
					return
				}
			} else {
				<#
					.添加前, 验证是否有旧的规则名存在
				#>
				If (Test-Path -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GUIImageSourceGroupAPI_Rule_Path.Text)") {
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Existed): $($GUIImageSourceGroupAPI_Rule_Path.Text)"
					$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
					return
				}
			}

			if ($GUIImageSourceGroupAPI_New_Path_IsCheck.Checked) {
				If ([String]::IsNullOrEmpty($GUIImageSourceGroupAPI_New_Path.Text)) {
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.SelFile)"
					$GUIImageSourceGroupAPI_New_Path.BackColor = "LightPink"
					return
				} else {
					if (Test-Path -Path $GUIImageSourceGroupAPI_New_Path.Text -PathType leaf) {
						if ($Global:Support_PS_Filename -Contains $([System.IO.Path]::GetExtension($GUIImageSourceGroupAPI_New_Path.Text))) {
							
						} else {
							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.RuleNameFormat): $($Global:Support_PS_Filename)"
							$GUIImageSourceGroupAPI_New_Path.BackColor = "LightPink"
							return
						}
					} else {
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoInstallImage)"
						$GUIImageSourceGroupAPI_New_Path.BackColor = "LightPink"
						return
					}
				}
			}

			Save_Dynamic -regkey "Solutions\API\Custom\$($GUIImageSourceGroupAPI_Rule_Path.Text)" -name "Path" -value $GUIImageSourceGroupAPI_New_Path.Text
			Save_Dynamic -regkey "Solutions\API\Custom\$($GUIImageSourceGroupAPI_Rule_Path.Text)" -name "NoImport" -value $GUIImageSourceGroupAPI_New_No_Import.Checked

			Refresh_Rule_Shortcuts

			if ($IsForce) {
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Change): $($GUIImageSourceGroupAPI_Rule_Path.Text), $($lang.Done)"
			} else {
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.AddTo): $($GUIImageSourceGroupAPI_Rule_Path.Text), $($lang.Done)"
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Change): $($GUIImageSourceGroupAPI_Rule_Path.Text), $($lang.Done)"
			}

			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$GUIImageSourceGroupAPI_Rule_Path.Text = ""
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPI_New_Path.Text = ""
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
		}
	}

	<#
		.API: Validation rule name
		.API: 验证规则名
	#>
	Function Solutions_API_Verify_New_RuleName
	{
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
		$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"

		<#
			.Judgment: 1. Null value
			.判断: 1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUIImageSourceGroupAPI_Rule_Path.Text)) {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.RuleNameNotInput)"
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断: 2. 前缀不能带空格
		#>
		if ($GUIImageSourceGroupAPI_Rule_Path.Text -match '^\s') {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. No spaces at the end
			.判断: 3. 后缀不能带空格
		#>
		if ($GUIImageSourceGroupAPI_Rule_Path.Text -match '\s$') {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. There can be no two spaces in between
			.判断: 4. 中间不能含有二个空格
		#>
		if ($GUIImageSourceGroupAPI_Rule_Path.Text -match '\s{2,}') {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. Cannot contain: \\ /: *? "" <> |
			.判断: 5, 不能包含: \\ / : * ? "" < > |
		#>
		if ($GUIImageSourceGroupAPI_Rule_Path.Text -match '[~#$@!%&*{}<>?/|+"]') {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. No more than 260 characters
			.判断: 6. 不能大于 260 字符
		#>
		if ($UIUnzip_Search_Sift_Custon.Text.length -gt 6) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "6")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
			return
		}

		return $True
	}

	<#
		.Event: Click Event and select the image source
		.事件: 点击了事件, 选择映像源
	#>
	Function Refresh_Rule_Shortcuts
	{
		$GUIImageSourceGroupAPI_Shortcut_Panel.controls.Clear()
		$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
		$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

		$GetALlName = @()
		Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom" -ErrorAction SilentlyContinue | ForEach-Object {
			$GetALlName += $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
		}

		if ($GetALlName.Count -gt 0) {
			ForEach ($item in $GetALlName) {
				<#
					.捕捉路径
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($item)" -Name "Path" -ErrorAction SilentlyContinue) {
					$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($item)" -Name "Path" -ErrorAction SilentlyContinue
				} else {
					$GetImportFileName = ""
				}

				$ShortcutsShortName = $([System.IO.Path]::GetFileNameWithoutExtension($item))
				$Checkbox      = New-Object System.Windows.Forms.CheckBox -Property @{
					Height     = 35
					Width      = 425
					Text       = "$($lang.RuleName): $($item)"
					Name       = $ShortcutsShortName
					Tag        = $GetImportFileName
					add_Click      = {
						$GUIImageSourceGroupAPIErrorMsg.Text = ""
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
					}
				}

				$CheckboxNameCopy  = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = "$($lang.Copy): API $($item)"
					Tag            = $item
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$GUIImageSourceGroupAPIErrorMsg.Text = ""
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Copy): API $($This.Tag), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value "API $($This.Tag)"

							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Copy): API $($This.Tag), $($lang.Done)"
						}
					}
				}

				$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange((
					$Checkbox,
					$CheckboxNameCopy
				))

				$CheckboxCreate    = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = $lang.RuleNewTempate
					Name           = $ShortcutsShortName
					Tag            = $GetImportFileName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						if ([string]::IsNullOrEmpty($This.Tag)) {
							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.RuleNewTempate): $($This.Name), $($lang.Failed)"
						} else {
							Api_Create_Template -NewFile $This.Tag
							Refresh_Rule_Shortcuts
							if (Test-Path -Path $This.Tag -PathType leaf) {
								$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.RuleNewTempate): $($This.Name), $($lang.Done)"
								$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							}  else {
								$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.RuleNewTempate): $($This.Name), $($lang.Failed)"
								$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							}
						}

						$GUIImageSourceGroupAPI_Rule_Path.Text = ""
						$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
						$GUIImageSourceGroupAPI_New_Path.Text = ""
						$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
					}
				}

				if ([string]::IsNullOrEmpty($GetImportFileName)) {
					$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange($CheckboxCreate)
				} else {
					if (Test-Path -Path $GetImportFileName -PathType leaf) {
					} else {
						$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange($CheckboxCreate)
					}
				}

				$CheckboxPath  = New-Object system.Windows.Forms.Label -Property @{
					autoSize   = 1
					Text       = ""
					Padding    = "16,5,0,15"
				}

				$Checkbox_Path_OpenFile = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = $lang.OpenFile
					Tag            = $GetImportFileName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$GUIImageSourceGroupAPIErrorMsg.Text = ""
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
					
						if ([string]::IsNullOrEmpty($This.Tag)) {
							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
						} else {
							if (Test-Path -Path $This.Tag -PathType Leaf) {
								Start-Process -FilePath $This.Tag
							
								$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile): $($UI_Main_Save_To.Text), $($lang.Done)"
							} else {
								$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile): $($UI_Main_Save_To.Text), $($lang.Inoperable)"
							}
						}
					}
				}

				$CheckboxPathCopy  = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = $lang.Paste
					Tag            = $GetImportFileName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$GUIImageSourceGroupAPIErrorMsg.Text = ""
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

						if ([string]::IsNullOrEmpty($This.Tag)) {
							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
						} else {
							Set-Clipboard -Value $This.Tag

							$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
						}
					}
				}

				$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange((
					$CheckboxPath,
					$Checkbox_Path_OpenFile,
					$CheckboxPathCopy
				))

				$CheckboxChange    = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = $lang.Change
					Name           = $ShortcutsShortName
					Tag            = $GetImportFileName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
						$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
						$GUIImageSourceGroupAPIErrorMsg.Text = ""
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

						$GUIImageSourceGroupAPI_Rule_Path.Text = $this.Name
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($this.Name)" -Name "Path" -ErrorAction SilentlyContinue) {
							$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Unpack\API\Custom\$($this.Name)" -Name "Path" -ErrorAction SilentlyContinue
							$GUIImageSourceGroupAPI_New_Path.Text = $GetImportFileName
						} else {
							$GUIImageSourceGroupAPI_New_Path.Text = ""
						}

						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($this.Name)" -Name "NoImport" -ErrorAction SilentlyContinue) {
							switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($this.Name)" -Name "NoImport" -ErrorAction SilentlyContinue) {
								"True" {
									$GUIImageSourceGroupAPI_New_No_Import.Checked = $True
								}
								"False" {
									$GUIImageSourceGroupAPI_New_No_Import.Checked = $False
								}
							}
						} else {
							$GUIImageSourceGroupAPI_New_No_Import.Checked = $False
						}
					}
				}

				$CheckboxDel       = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 35
					Width          = 425
					Padding        = "16,0,0,0"
					Text           = $lang.Del
					Name           = $ShortcutsShortName
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						Remove-Item "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($This.Name)" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
						Refresh_Rule_Shortcuts

						$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Del): $($This.Name), $($lang.Done)"
						$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")

						$GUIImageSourceGroupAPI_Rule_Path.Text = ""
						$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
						$GUIImageSourceGroupAPI_New_Path.Text = ""
						$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
					}
				}

				$Checkbox_Wrap     = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 410
				}

				If ([String]::IsNullOrEmpty($GetImportFileName)) {
					$CheckboxPath.Text = "$($lang.Select_Path): $($lang.Failed)"
				} else {
					$CheckboxPath.Text = "$($lang.Select_Path): $($GetImportFileName)"
				}

				$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange((
					$CheckboxChange,
					$CheckboxDel,
					$Checkbox_Wrap
				))
			}
		} else {
			$UI_Main_Pre_Rule_NoWork = New-Object system.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 425
				Text           = $lang.NoWork
			}
			$GUIImageSourceGroupAPI_Shortcut_Panel.controls.AddRange($UI_Main_Pre_Rule_NoWork)
		}
	}

	<#
		.从规则里验证 MVS (MSDN)
	#>
	Function Match_Images_MSDN_MVS
	{
		param
		(
			$ISO
		)

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				foreach ($itemISO in $item.ISO) {
					$Flag_Is_Match_To = $False
					$Temp_Save_ISO = [System.IO.Path]::GetFileNameWithoutExtension($itemISO.ISO)

					<#
						.精准匹配
					#>
					if ($ISO -eq $Temp_Save_ISO) {
						$Flag_Is_Match_To = $True
					}

					<#
						.包含匹配
					#>
					if ($Flag_Is_Match_To) {
					} else {
						if ($ISO -match $Temp_Save_ISO) {
							$Flag_Is_Match_To = $True
						}
					}

					if ($Flag_Is_Match_To) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "Name" -value $item.Name
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "GUID" -value $item.GUID
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "ISO" -value $Temp_Save_ISO
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA256" -value $itemISO.CRCSHA.SHA256
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA512" -value $itemISO.CRCSHA.SHA512

						return @{
							Name = $item.Name
							GUID = $item.GUID
							ISO  = $itemISO.ISO
							CRCSHA = @{
								SHA256 = $itemISO.CRCSHA.SHA256
								SHA512 = $itemISO.CRCSHA.SHA512
							}
						}
					}
				}
			}
		}

		<#
			.从预规则里获取: 不包含 InBox Apps 规则
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			foreach ($itemISO in $item.ISO) {
				$Flag_Is_Match_To = $False
				$Temp_Save_ISO = [System.IO.Path]::GetFileNameWithoutExtension($itemISO.ISO)

				<#
					.精准匹配
				#>
				if ($ISO -eq $Temp_Save_ISO) {
					$Flag_Is_Match_To = $True
				}

				<#
					.包含匹配
				#>
				if ($Flag_Is_Match_To) {
				} else {
					if ($ISO -match $Temp_Save_ISO) {
						$Flag_Is_Match_To = $True
					}
				}

				if ($Flag_Is_Match_To) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "Name" -value $item.Name
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "GUID" -value $item.GUID
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "ISO" -value $Temp_Save_ISO
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA256" -value $itemISO.CRCSHA.SHA256
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA512" -value $itemISO.CRCSHA.SHA512

					return @{
						Name = $item.Name
						GUID = $item.GUID
						ISO  = $itemISO.ISO
						CRCSHA = @{
							SHA256 = $itemISO.CRCSHA.SHA256
							SHA512 = $itemISO.CRCSHA.SHA512
						}
					}
				}
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					foreach ($itemISO in $item.ISO) {
						$Flag_Is_Match_To = $False
						$Temp_Save_ISO = [System.IO.Path]::GetFileNameWithoutExtension($itemISO.ISO)

						<#
							.精准匹配
						#>
						if ($ISO -eq $Temp_Save_ISO) {
							$Flag_Is_Match_To = $True
						}

						<#
							.包含匹配
						#>
						if ($Flag_Is_Match_To) {
						} else {
							if ($ISO -match $Temp_Save_ISO) {
								$Flag_Is_Match_To = $True
							}
						}

						if ($Flag_Is_Match_To) {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "Name" -value $item.Name
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "GUID" -value $item.GUID
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "ISO" -value $Temp_Save_ISO
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA256" -value $itemISO.CRCSHA.SHA256
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS\CRC SHA" -name "SHA512" -value $itemISO.CRCSHA.SHA512

							return @{
								Name   = $item.Name
								GUID   = $item.GUID
								ISO    = $itemISO.ISO
								CRCSHA = @{
									SHA256 = $itemISO.CRCSHA.SHA256
									SHA512 = $itemISO.CRCSHA.SHA512
								}
							}
						}
					}
				}
			}
		}

		return $False
	}

	<#
		.事件: 查看规则命名, 设置为主要
	#>
	Function Unzip_Custom_Rule_Setting_Default
	{
		$GUID = ""

		$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$GUID = $_.Tag
						Save_Dynamic -regkey "Solutions\ISO" -name "GUID" -value $_.Tag
					}
				}
			}
		}

		if ([string]::IsNullOrEmpty($GUID)) {
			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.RuleName) )"
			return $False
		}

		$Script:User_Custom_Select_Rule = @()
		$Temp_Save_ISO = @()
		$Temp_Save_Language_ISO = @()
		$Temp_Save_InBox = @()

		$InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		if ($InBox_Apps_Rule_Select_Single.count -gt 0) {
			# ISO
			if ($InBox_Apps_Rule_Select_Single.ISO.count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.ISO) {
					$Temp_Save_ISO += [System.IO.Path]::GetFileName($item.ISO)

					if ($item.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $item.AlternativeFilenames) {
							$Temp_Save_ISO += [System.IO.Path]::GetFileName($itemAlternative)
						}
					}
				}
			}

			# Language
			if ($InBox_Apps_Rule_Select_Single.Language.ISO.count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.Language.ISO) {
					$Temp_Save_Language_ISO += [System.IO.Path]::GetFileName($item.ISO)

					if ($item.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $item.AlternativeFilenames) {
							$Temp_Save_Language_ISO += [System.IO.Path]::GetFileName($itemAlternative)
						}
					}
				}
			}

			if ($InBox_Apps_Rule_Select_Single.InboxApps.ISO.count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.ISO) {
					$Temp_Save_InBox += [System.IO.Path]::GetFileName($item.ISO)

					if ($item.AlternativeFilenames.Count -gt 0) {
						foreach ($itemAlternative in $item.AlternativeFilenames) {
							$Temp_Save_InBox += [System.IO.Path]::GetFileName($itemAlternative)
						}
					}
				}
			}

			$Script:User_Custom_Select_Rule += [pscustomobject]@{
				ISO       = $Temp_Save_ISO | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
				Language  = $Temp_Save_Language_ISO | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
				InboxApps = $Temp_Save_InBox | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			}

			return $True
		} else {
			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
			return $False
		}
	}

	<#
		.事件: 查看规则命名, 详细内容
	#>
	Function Unzip_Custom_Rule_Details_View
	{
		param
		(
			$GUID
		)

		$InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		if ($InBox_Apps_Rule_Select_Single.count -gt 0) {
			$UI_Main.Text = $lang.Detailed_View
			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $True               # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			$UI_Main_Mask_Rule_Detailed_Results.Text = ""
			$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.RuleAuthon)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "   $($InBox_Apps_Rule_Select_Single.Author)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleGUID)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.GUID)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleName)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.Name)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleDescription)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($InBox_Apps_Rule_Select_Single.Description)"

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.RuleISO)`n$('*' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.ISO.Count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.ISO) {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.FileName): $($item.ISO)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.Alternative): "

					if ($item.AlternativeFilenames.Count -gt 0) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"

						foreach ($ItemAlFile in $item.AlternativeFilenames) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "    $($ItemAlFile)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
					} else {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
					}

					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.ISO_Other): $($item.FileList)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-256: $($item.CRCSHA.SHA256)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-512: $($item.CRCSHA.SHA512)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
			}

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.Unzip_Language), $($lang.Unzip_Fod)`n$('*' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.Language.ISO.Count -gt 0) {
				ForEach ($item in $InBox_Apps_Rule_Select_Single.Language.ISO) {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.FileName): $($item.ISO)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.Alternative): "

					if ($item.AlternativeFilenames.Count -gt 0) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"

						foreach ($ItemAlFile in $item.AlternativeFilenames) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "    $($ItemAlFile)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
					} else {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
					}

					$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.ISO_Other): $($item.FileList)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-256: $($item.CRCSHA.SHA256)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-512: $($item.CRCSHA.SHA512)`n"
					$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
			}

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.Language)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.Language.Rule.Count -gt 0) {
				ForEach ($PrintExpandRule in $InBox_Apps_Rule_Select_Single.Language.Rule) {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.Event_Group): $($PrintExpandRule.Uid): $($PrintExpandRule.Rule.Count) $($lang.EventManagerCount)`n     $('-' * 77)`n"

					if ($PrintExpandRule.Rule.Count -gt 0) {
						ForEach ($item in $PrintExpandRule.Rule) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "           $($lang.Architecture): $($item.Architecture)`n           $('-' * 74)`n"

							Foreach ($itemMatchNewfile in $item.Rule) {
								$UI_Main_Mask_Rule_Detailed_Results.Text += "               $($itemMatchNewfile.Match)`n"
							}

							$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
						}
					} else {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($lang.NoWork)`n"
					}

					$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += $lang.NoWork
			}

			$UI_Main_Mask_Rule_Detailed_Results.Text += "`n`n$($lang.InboxAppsManager)`n"
			$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
			if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
				if ($InBox_Apps_Rule_Select_Single.InboxApps.ISO.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.ISO) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.FileName): $($item.ISO)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.Alternative): "

						if ($item.AlternativeFilenames.Count -gt 0) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"

							foreach ($ItemAlFile in $item.AlternativeFilenames) {
								$UI_Main_Mask_Rule_Detailed_Results.Text += "    $($ItemAlFile)`n"
							}

							$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
						} else {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.NoWork)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "$($lang.ISO_Other): $($item.FileList)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-256: $($item.CRCSHA.SHA256)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "SHA-512: $($item.CRCSHA.SHA512)`n"
						$UI_Main_Mask_Rule_Detailed_Results.Text += "$('.' * 80)`n`n"
					}
				} else {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
				}

				$UI_Main_Mask_Rule_Detailed_Results.Text += "`n    $($lang.RuleCustomize): $($InBox_Apps_Rule_Select_Single.InboxApps.Edition.Count) $($lang.EventManagerCount)`n"
				if ($InBox_Apps_Rule_Select_Single.InboxApps.Edition.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Edition) {
						$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.Event_Group): $($item.Name.Count) $($lang.EventManagerCount)`n"
						ForEach ($itemNewName in $item.Name) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "               $($itemNewName)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n               $($lang.InboxAppsManager): $($lang.AddTo): $($item.Apps.Count) $($lang.EventManagerCount)`n"
						ForEach ($itemNewName in $item.Apps) {
							$UI_Main_Mask_Rule_Detailed_Results.Text += "                    $($itemNewName)`n"
						}

						$UI_Main_Mask_Rule_Detailed_Results.Text += "`n"
					}
				} else {
					
				}

				$UI_Main_Mask_Rule_Detailed_Results.Text += "`n$($lang.RuleInBoxApps): $($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count) $($lang.EventManagerCount)`n"
				if ($InBox_Apps_Rule_Select_Single.InboxApps.Rule.Count -gt 0) {
					ForEach ($item in $InBox_Apps_Rule_Select_Single.InboxApps.Rule){
						$UI_Main_Mask_Rule_Detailed_Results.Text += "     $($item.Name)`n"
					}
				} else {
					$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)`n"
				}
			} else {
				$UI_Main_Mask_Rule_Detailed_Results.Text += "         $($lang.NoWork)"
			}
		} else {
			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
		}
	}

	<#
		.Event: Add directory structure
		.事件: 添加目录结构
	#>
	Function RefreshNewPath
	{
		<#
			.Judgment: 1. Null value
			.判断: 1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUIImageSourceGroupSettingCustomizeShow.Text)) {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
			$GUIImageSourceGroupSettingCustomizeShow.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断: 2. 前缀不能带空格
		#>
		if ($GUIImageSourceGroupSettingCustomizeShow.Text -match '^\s') {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupSettingCustomizeShow.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. No spaces at the end
			.判断: 3. 后缀不能带空格
		#>
		if ($GUIImageSourceGroupSettingCustomizeShow.Text -match '\s$') {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupSettingCustomizeShow.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. There can be no two spaces in between
			.判断: 4. 中间不能含有二个空格
		#>
		if ($GUIImageSourceGroupSettingCustomizeShow.Text -match '\s{2,}') {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUIImageSourceGroupSettingCustomizeShow.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. Cannot contain: \\ /: *? "" <> |
			.判断: 5, 不能包含: \\ / : * ? "" < > |
		#>
		if ($GUIImageSourceGroupSettingCustomizeShow.Text -match '[~#$@!%&*{}<>?/|+"]') {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$GUIImageSourceGroupSettingCustomizeShow.BackColor = "LightPink"
			return $False
		}

		return $True
	}

	<#
		.选择映像来源, 例如 D:\OS

		.设置界面, 选择来源
	#>
	Function Image_Select_Refresh_Disk_Local
	{
		$GUIImageSourceGroupSettingCustomizeShow.BackColor = "#FFFFFF"
		$GUIImageSourceGroupSettingErrorMsg.Text = ""
		$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null

		Save_Dynamic -regkey "Solutions" -name "SearchDiskMinSize" -value $GUIImageSourceGroupSettingLowSize.Text

		$GUIImageSourceGroupSettingDisk.controls.Clear()
		$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsFolderStructure" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsFolderStructure" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceGroupSettingStructure.Checked = $True }
				"False" { $GUIImageSourceGroupSettingStructure.Checked = $False }
			}
		} else {
			$GUIImageSourceGroupSettingStructure.Checked = $True
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceGroupSettingDefenderAdd.Checked = $True }
				"False" { $GUIImageSourceGroupSettingDefenderAdd.Checked = $False }
			}
		} else {
			Save_Dynamic -regkey "Solutions" -name "IsDefenderExclude" -value "True"

			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceGroupSettingDefenderAdd.Checked = $True }
				"False" { $GUIImageSourceGroupSettingDefenderAdd.Checked = $False }
			}
		}

		$AddImageDisk = @()
		try {
			$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
			foreach ($exclusion in $extensionExclusion.ExclusionPath) {
				$AddImageDisk += $exclusion
			}
		} catch {
			
		}

		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test_Available_Disk -Path $_.Root) {
				$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 40
					Width     = 420
					add_Click = $GUIImageSourceGroupSettingDiskClick
				}

				$MarkCheckedSearchStructure = $False
				if ($GUIImageSourceGroupSettingStructure.Checked) {
					if (RefreshNewPath) {
						$MarkCheckedSearchStructure = $True
					} else {
						$MarkCheckedSearchStructure = $False
					}
				}

				if ($MarkCheckedSearchStructure) {
					$NewFolderName = Join-Path -Path $_.Root -ChildPath $GUIImageSourceGroupSettingCustomizeShow.Text -ErrorAction SilentlyContinue

					$RadioButton.Text = $NewFolderName
					$RadioButton.Tag = $NewFolderName
				} else {
					$RadioButton.Text = $_.Root
					$RadioButton.Tag = $_.Root
				}

				if ($AddImageDisk.count -gt 0) {
					if ($AddImageDisk -contains $RadioButton.Tag) {
						$RadioButton.Height = 55
						$RadioButton.Text += "`n$($lang.DefenderIsAdd)"
					}
				}

				if ($GetDiskTo -eq $RadioButton.Tag) {
					$RadioButton.Checked = $True
				}

				if ($GUIImageSourceGroupSettingSize.Checked) {
					$NewPath = Join_MainFolder -Path $_.Root

					if (-not (Verify_Available_Size -Disk $NewPath -Size $GUIImageSourceGroupSettingLowSize.Text)) {
						$RadioButton.Enabled = $False
						$RadioButton.Height = 55
						$RadioButton.Text += ", $($lang.Disable)`n$($lang.Disk_Not_satisfied_Exclude)"
					}
				}

				$GUIImageSourceGroupSettingDisk.controls.AddRange($RadioButton)
			}
		}

		Get-CimInstance -Class Win32_NetworkConnection -ErrorAction SilentlyContinue | ForEach-Object {
			$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 40
				Width     = 420
				Text      = $_.RemoteName
				Tag       = $_.RemoteName
				add_Click = $GUIImageSourceGroupSettingDiskClick
			}

			$GUIImageSourceGroupSettingDisk.controls.AddRange($RadioButton)
		}
	}

	<#
		.响应设置界面
	#>
	Function Image_Setting_UI
	{
		ForEach ($itemRegion in $Region) {
			if ($itemRegion.Region -eq $Global:IsLang) {
				$GUIImageSourceSettingLP_Change.Text = $itemRegion.Name
				break
			}
		}

		<#
			.Initialize checkbox
			.初始化复选框
		#>
		$GUIImageSourceSettingSuggested.Checked = $False
		$GUIImageSourceSettingRAMDISK.Checked = $False
		$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $False
		$GUIImageSource_Setting_RAMDISK_Change.Enabled = $False
		$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $False
		$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $False
		$GUIImageSource_Setting_Abandon_Agreement.Enabled = $False
		$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $False
		$GUIImageSourceGroupSettingErrorMsg.Text = ""
		$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Search disk directory structure name
			.搜索磁盘目录结构名
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskSearchStructure" -ErrorAction SilentlyContinue) {
			$GUIImageSourceGroupSettingCustomizeShow.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskSearchStructure" -ErrorAction SilentlyContinue
		} else {
			$GUIImageSourceGroupSettingCustomizeShow.Text = $Init_Search_Image_Folder_Structure
		}

		<#
			.Check disk minimum size
			.检查磁盘最低大小
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckLowDiskSize" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckLowDiskSize" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSourceGroupSettingSize.Checked = $True
					$GUIImageSourceGroupSettingLowSize.Enabled = $True
				}
				"False" {
					$GUIImageSourceGroupSettingSize.Checked = $False
					$GUIImageSourceGroupSettingLowSize.Enabled = $False
				}
			}
		} else {
			$GUIImageSourceGroupSettingSize.Checked = $True
			$GUIImageSourceGroupSettingLowSize.Enabled = $True
		}

		<#
			.Allow suggested items
			.允许建议的项目
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSourceSettingSuggested.Checked = $True
					$GUIImageSourceSettingSuggestedPanel.Enabled = $True
				}
				"False" {
					$GUIImageSourceSettingSuggested.Checked = $False
					$GUIImageSourceSettingSuggestedPanel.Enabled = $False
				}
			}
		} else {
			Save_Dynamic -regkey "Solutions" -name "IsSuggested" -value "True"
			$GUIImageSourceSettingSuggested.Checked = $True
			$GUIImageSourceSettingSuggestedPanel.Enabled = $True
		}

		<#
			.Automatically select RAMDISK
			.自动选择 RAMDISK
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSourceSettingRAMDISK.Checked = $True
					$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $True
					$GUIImageSource_Setting_RAMDISK_Change.Enabled = $True
					$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $True
					$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $True
					$GUIImageSource_Setting_Abandon_Agreement.Enabled = $True
					$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $True
					$GUIImageSourceISOCacheCustomizeName.Enabled = $False
					$GUIImageSourceISOCacheCustomize.Enabled = $False
				}
				"False" {
					$GUIImageSourceSettingRAMDISK.Checked = $False
					$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $False
					$GUIImageSource_Setting_RAMDISK_Change.Enabled = $False
					$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $False
					$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $False
					$GUIImageSource_Setting_Abandon_Agreement.Enabled = $False
					$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $False
					$GUIImageSourceISOCacheCustomizeName.Enabled = $True
					$GUIImageSourceISOCacheCustomize.Enabled = $True
				}
			}
		} else {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk" -value "True"
			$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Change.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $True
			$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $True
			$GUIImageSource_Setting_Abandon_Agreement.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $True
			$GUIImageSourceISOCacheCustomizeName.Enabled = $False
			$GUIImageSourceISOCacheCustomize.Enabled = $False
		}

		<#
			.Allow automatic activation of the quick discard method
			.允许自动开启快速抛弃方式
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSource_Setting_Abandon_Allow_Auto.Checked = $True
				}
				"False" {
					$GUIImageSource_Setting_Abandon_Allow_Auto.Checked = $False
				}
			}
		} else {
			$GUIImageSource_Setting_Abandon_Allow_Auto.Checked = $True
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "Abandon_Allow_Auto" -value "True"
		}

		<#
			.Windows Defender Exclude
			.Windows Defender 排除项
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSource_Setting_RAMDISK_Exclude.Checked = $True
				}
				"False" {
					$GUIImageSource_Setting_RAMDISK_Exclude.Checked = $False
				}
			}
		} else {
			$GUIImageSource_Setting_RAMDISK_Exclude.Checked = $True
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Exclude" -value "True"
		}

		<#
			.获取 RAMDISK 卷标名
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
			$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
			$GUIImageSourceSetting_RAMDISK_Volume_Label.Text = $CustomRAMDISKLabel
			$GUIImageSourceSettingRAMDISK.Text = "$($lang.AutoSelectRAMDISK): $($CustomRAMDISKLabel)"
		} else {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Volume_Label" -value $Global:Init_RAMDISK_Volume_Label
			$GUIImageSourceSettingRAMDISK.Text = "$($lang.AutoSelectRAMDISK): $($Global:Init_RAMDISK_Volume_Label)"
			$GUIImageSourceSetting_RAMDISK_Volume_Label.Text = $Global:Init_RAMDISK_Volume_Label
		}

		<#
			.初始化: 选择, 自定义磁盘缓存路径
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIImageSourceISOCacheCustomizeName.Checked = $True
					$GUIImageSourceISOCacheCustomize.Enabled = $True
				}
				"False" {
					$GUIImageSourceISOCacheCustomizeName.Checked = $False
					$GUIImageSourceISOCacheCustomize.Enabled = $False
				}
			}
		} else {
			$GUIImageSourceISOCacheCustomizeName.Checked = $False
			$GUIImageSourceISOCacheCustomize.Enabled = $False
		}

		<#
			.初始化: 自定义缓存路径
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue) {
			$GUIImageSourceISOCacheCustomizePath.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "SearchDiskMinSize" -ErrorAction SilentlyContinue) {
			$GUIImageSourceGroupSettingLowSize.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "SearchDiskMinSize" -ErrorAction SilentlyContinue
		} else {
			Save_Dynamic -regkey "Solutions" -name "SearchDiskMinSize" -value $InitSearchDiskMinSize
		}

		Image_Select_Refresh_Disk_Local

		<#
			.验证目录名称, ISO 保存位置
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckWrite" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckWrite" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceISOWrite.Checked = $True }
				"False" { $GUIImageSourceISOWrite.Checked = $False }
			}
		} else {
			$GUIImageSourceISOWrite.Checked = $True
		}

		<#
			.同步新位置, ISO 保存位置
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSearchSyncPath" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSearchSyncPath" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceISOSync.Checked = $True }
				"False" { $GUIImageSourceISOSync.Checked = $False }
			}
		} else {
			$GUIImageSourceISOSync.Checked = $True
		}

		<#
			.验证目录名称, ISO 保存位置
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckISOToFolderName" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsCheckISOToFolderName" -ErrorAction SilentlyContinue) {
				"True" { $GUIImageSourceISOSaveToCheckISO9660.Checked = $True }
				"False" { $GUIImageSourceISOSaveToCheckISO9660.Checked = $False }
			}
		} else {
			$GUIImageSourceISOSaveToCheckISO9660.Checked = $True
		}

		<#
			.初始化: ISO 默认保存位置
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue) {
			$GUIImageSourceISOCustomizePath.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue
		} else {
			$GUIImageSourceISOCustomizePath.Text = $Global:MainMasterFolder
		}
	}

	<#
		.事件: ISO 默认保存位置, 验证目录名称
	#>
	$GUIImageSourceGroupSettingDiskClick = {
		$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		$GUIImageSourceGroupSettingErrorMsg.Text = ""

		if ($GUIImageSourceISOSync.Checked) {
			$GUIImageSourceGroupSettingDisk.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$GUIImageSourceISOCustomizePath.Text = $_.Tag
						}
					}
				}
			}
		}
	}

	Function Image_Select_Refresh_Sources_Setting
	{
		<#
			.事件: 允许自动选择磁盘卷标: RAMDISK
		#>
		if ($GUIImageSourceSettingRAMDISK.Checked) {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk" -value "True"
			Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "False"

			$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Change.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $True
			$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $True
			$GUIImageSource_Setting_Abandon_Agreement.Enabled = $True
			$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $True
			$GUIImageSourceISOCacheCustomizeName.Enabled = $False
			$GUIImageSourceISOCacheCustomize.Enabled = $False
		} else {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk" -value "False"
			$GUIImageSourceSetting_RAMDISK_Volume_Label.Enabled = $False
			$GUIImageSource_Setting_RAMDISK_Change.Enabled = $False
			$GUIImageSource_Setting_RAMDISK_Restore.Enabled = $False
			$GUIImageSource_Setting_Abandon_Allow_Auto.Enabled = $False
			$GUIImageSource_Setting_Abandon_Agreement.Enabled = $False
			$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $False
			$GUIImageSourceISOCacheCustomizeName.Enabled = $True
			if ($GUIImageSourceISOCacheCustomizeName.Checked) {
				$GUIImageSourceISOCacheCustomize.Enabled = $True
			} else {
				$GUIImageSourceISOCacheCustomize.Enabled = $False
			}
		}


		<#
			.完成后刷新: 来源
		#>
		Image_Select_Refresh_Sources_List

		<#
			.完成后刷新: 挂载状态
		#>
		Image_Select_Refresh_Mount_Disk
	}

	Function Image_Select_Refresh_Sources_List
	{
		<#
			.重置: 映像源显示区域
		#>
		$UI_Main_Select_Sources.controls.Clear()
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单
		$UI_Main_Ok.Visible = $False                    # 隐藏: 确定按钮
		$GUIImageSourceGroupMount.Visible = $False      # 动态显示: 挂载到
		$GUIImageSourceGroupLang.Visible = $False       # 动态显示: 更改语言
		$GUIImageSourceGroupOther.Visible = $False      # 动态显示: 详细

		<#
			.清除选择主键
		#>
		$UI_Primary_Key_Select.controls.Clear()
		$UI_Primary_Key_Group.Visible = $False

		<#
			.前往到
		#>
		#region GoTo
		$UI_Main_To.Visible = $False                    # 隐藏: 前往到
		$UI_Main_To.DataSource = $null                  # 清除旧内容
		$GoTo = [Collections.ArrayList]@()
		$GoToGroup = @{
			GroupA = @(
				@{ Path = "";                                                  Lang = $lang.Ok_Go_To_No; }
				@{ Path = "Event_Assign_Task_Customize_Autopilot";             Lang = $lang.Autopilot; }
				@{ Path = "Event_Assign_Task_Customize";                       Lang = $lang.OnDemandPlanTask; }
				@{ Path = "Image_Capture_UI";                                  Lang = $lang.Wim_Capture }
			)
			GroupB = @(
				@{ Path = "";                                                  Lang = "$($lang.Image_Unmount_After)"; }
				@{ Path = "Eject_Forcibly_All -Save -DontSave";                Lang = "    | $($lang.Save)"; }
				@{ Path = "Eject_Forcibly_All -Save -DontSave -Quick";         Lang = "    | $($lang.Save) [ $($lang.Abandon_Allow) ]"; }
				@{ Path = "Eject_Forcibly_All -DontSave";                      Lang = "    | $($lang.DoNotSave)"; }
				@{ Path = "Eject_Forcibly_All -DontSave -Quick";               Lang = "    | $($lang.DoNotSave) [ $($lang.Abandon_Allow) ]"; }
				@{ Path = "Language_Extract_UI";                               Lang = "$($lang.Language): $($lang.LanguageExtract)"; }
				@{ Path = "Solutions";                                         Lang = "$($lang.Solution): $($lang.IsCreate)"; }
				@{ Path = "Image_Convert";                                     Lang = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"; }
				@{ Path = "Shortcuts_Euwl";                                    Lang = $lang.Wim_Rule_Update; }
				@{ Path = "ISO_Create";                                        Lang = $lang.UnpackISO; }
			)
			GroupPK = @(
				@{ Path = "";                                                  Lang = "$($lang.Sel_Primary_Key)"; }
				@{ Path = "Event_Assign -Rule ""Additional_Edition_UI"" -Run"; Lang = "    | $($lang.AdditionalEdition)"; }
				@{ Path = "Shortcuts_Append";                                  Lang = "    | $($lang.Wim_Append)"; }
				@{ Path = "Shortcuts_Apply";                                   Lang = "    | $($lang.Apply)"; }
				@{ Path = "Shortcuts_Remove";                                  Lang = "    | $($lang.Del)"; }
				@{ Path = "Shortcuts_Go_Select_Index";                         Lang = "    | $($lang.Mount)"; }
				@{ Path = "Shortcuts_Save_Current";                            Lang = "    | $($lang.Save)"; }
				@{ Path = "Shortcuts_Dont_Save_Current_Go";                    Lang = "    | $($lang.Unmount)"; }
				@{ Path = "Shortcuts_Dont_Save_Current_Go -Quick";             Lang = "    | $($lang.Unmount) [ $($lang.Abandon_Allow) ]"; }
			)
		}

		<#
			.可前往: 添加群组 A
		#>
		foreach ($item in $GoToGroup.GroupA) {
			$GoTo.Add([pscustomobject]@{ Path = $item.Path; Lang = $item.Lang; }) | Out-Null
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
				"True" {
					foreach ($item in $GoToGroup.GroupPK) {
						$GoTo.Add([pscustomobject]@{ Path = $item.Path; Lang = $item.Lang; }) | Out-Null
					}
				}
			}
		}

		<#
			.前往到: 添加群组 B
		#>
		foreach ($item in $GoToGroup.GroupB) {
			$GoTo.Add([pscustomobject]@{ Path = $item.Path; Lang = $item.Lang; }) | Out-Null
		}

		$UI_Main_To.BindingContext = New-Object System.Windows.Forms.BindingContext
		$UI_Main_To.Datasource = $GoTo
		$UI_Main_To.ValueMember = "Path"
		$UI_Main_To.DisplayMember = "Lang"
		#endregion

		<#
			.初始化字符长度
		#>
		[int]$InitCharacterLength = 95

		<#
			.初始化控件高度
		#>
		[int]$InitControlHeight = 30


		$GUIImageSourceMountInfo.Text = $lang.SelectImageMountStatus
		$GUIImageSourceOtherImageErrorMsg.Text = $lang.ImageSouresNoSelect
		$GUISelectGroupAfterFinishing.Enabled = $False

		<#
			.重置: 重新选择语言界面
		#>
		$UI_Mask_Image_Language_Error.Text = ""
		$GUIImageSourceLanguageInfo.Text = $lang.LanguageNoSelect

		<#
			预规则
		#>
		$Pre_Search_Folder_ISO = @(
			$Global:MainMasterFolder
		)

		$UI_Main_Pre_Rule = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 658
			Text           = "$($lang.RulePre): $($Pre_Search_Folder_ISO.Count) $($lang.EventManagerCount)"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Select_Refresh_Sources_List

				$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		}
		$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

		foreach ($itemISO in $Pre_Search_Folder_ISO) {
			$TempSelectAraayPreRule = @()
			Get-ChildItem $itemISO -Directory -Exclude ($ExcludeDirectory) -ErrorAction SilentlyContinue | ForEach-Object {
				if ((Test-Path -Path "$($_.FullName)\sources\boot.wim" -PathType Leaf) -or
					(Test-Path -Path "$($_.FullName)\sources\install.*" -PathType Leaf))
				{
					$TempSelectAraayPreRule += $_.FullName
				}
			}

			$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.LinkLabel -Property @{
				TabIndex       = 6
				Height         = 30
				Width          = 658
				Padding        = "25,0,0,0"
				Text           = "$($itemISO): $($TempSelectAraayPreRule.Count) $($lang.EventManagerCount)"
				Tag            = $itemISO
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					if ([string]::IsNullOrEmpty($This.Tag)) {
						$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					} else {
						if (Test-Path -Path $This.Tag -PathType Container) {
							Start-Process $This.Tag

							$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						} else {
							$UI_Main_Error.Text = "$($lang.OpenFolder): $($This.Tag), $($lang.Inoperable)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						}
					}
				}
			}
			$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

			if ($TempSelectAraayPreRule.count -gt 0) {
				ForEach ($item in $TempSelectAraayPreRule) {
					$InitLength = $item.Length
					if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						Name      = $item
						Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
						Width     = 658
						Padding   = "50,0,0,0"
						Text      = [IO.Path]::GetFileName($item)
						Tag       = [IO.Path]::GetFileName($item)
						add_Click = {
							Refresh_Click_Image_Sources
						}
					}

					if (Test_Available_Disk -Path $item) {
						$CheckBox.Enabled = $True
					} else {
						$CheckBox.Text = "$($item), $($lang.SelectFromError): $($lang.Inoperable)"
						$CheckBox.Enabled = $False
					}

					$UI_Main_Pre_Rule_Wrap_RadioButton_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height       = 5
						Width        = 658
					}

					$UI_Main_Select_Sources.controls.AddRange((
						$CheckBox,
						$UI_Main_Pre_Rule_Wrap_RadioButton_Wrap
					))
				}
			} else {
				$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					autosize = 1
					Padding  = "50,0,0,0"
					margin   = "0,5,0,5"
					Text     = "$($lang.NoImagePreSource -f $itemISO)"
				}
				$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
			}

			$UI_Main_Pre_Rule_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height       = 30
				Width        = 658
			}
			$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Wrap)
		}

		<#
			.其它位置
		#>
		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name 'Sources_Other_Directory' -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value "" -Type "MultiString"
		}
		$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name "Sources_Other_Directory" -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$TempSelectAraayOtherRule = @()
		ForEach ($item in $GetExcludeSoftware) {
			$TempSelectAraayOtherRule += $item
		}

		$UI_Main_Other_Rule = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 658
			Text           = "$($lang.RuleOther): $($TempSelectAraayOtherRule.Count) $($lang.EventManagerCount)"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				Image_Select_Refresh_Sources_List

				$UI_Main_Error.Text = "$($lang.Refresh), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		}
		$UI_Main_Select_Sources.controls.AddRange($UI_Main_Other_Rule)

		if ($TempSelectAraayOtherRule.count -gt 0) {
			ForEach ($item in $TempSelectAraayOtherRule) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$NewOtherRuleName = [IO.Path]::GetFileName($item)
				if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
					$NewOtherRuleName = [System.IO.Path]::GetPathRoot($item).Substring(0,1)
				}

				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Name      = $item
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 658
					Padding   = "25,0,0,0"
					Text      = $item
					Tag       = $NewOtherRuleName
					add_Click = {
						Refresh_Click_Image_Sources
					}
				}

				$UI_Main_Other_Rule_RadioButton_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height       = 5
					Width        = 658
				}

				if ((Test-Path -Path "$($item)\Sources\boot.wim" -PathType Leaf) -or
					(Test-Path -Path "$($item)\Sources\install.*" -PathType Leaf))
				{
					if (Test_Available_Disk -Path $item) {
						$CheckBox.Enabled = $True
					} else {
						$CheckBox.Text = "$($item), $($lang.SelectFromError): $($lang.Inoperable)"
						$CheckBox.Enabled = $False
					}
				} else {
					$CheckBox.Enabled = $False
				}

				$UI_Main_Select_Sources.controls.AddRange((
					$CheckBox,
					$UI_Main_Other_Rule_RadioButton_Wrap
				))
			}

			$UI_Main_Pre_Rule_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height       = 20
				Width        = 658
			}
			$UI_Main_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Wrap)
		}
		
		$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.LinkLabel -Property @{
			TabIndex       = 7
			Height         = 35
			Width          = 658
			Padding        = "23,0,0,0"
			Text           = $lang.NoImageOtherSource
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = $UI_Other_Path_Add_Click
		}
		$UI_Main_Select_Sources.controls.AddRange($UI_Main_Other_Rule_Not_Find)
	}

	Function Image_Select_Refresh_Language
	{
		$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单
		$FlagChangeLanguage = $False
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$FlagChangeLanguage = $True
				}
			}
		}

		if ($FlagChangeLanguage) {
			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $True              # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)
		} else {
			$UI_Main_Error.Text = $lang.NoSelectImageSource
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Image_Select_Refresh_MountTo
	{
		$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单

		$FlagChangeLanguage = $False
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$FlagChangeLanguage = $True
					}
				}
			}
		}

		if ($FlagChangeLanguage) {
			<#
				.添加托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)

			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $True              # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			Image_Select_Refresh_Mount_Disk
		} else {
			$UI_Main_Error.Text = $lang.NoSelectImageSource
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	<#
		.刷新挂载磁盘
	#>
	Function Image_Select_Refresh_Mount_Disk
	{
		if ($Global:Developers_Mode) {
			Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): E0x006000"
		}

		$GUIImageSourceGroupMountChangeDiSKPane1.controls.Clear()
		$UI_Mask_Image_Mount_To_Tips.Text = ""
		Save_Dynamic -regkey "Solutions" -name "DiskMinSize" -value $GUIImageSourceGroupMountChangeLowSize.Text

		$MarkRAMDISK_Is_Check = $False
		$MarkRAMDISK_Match_Done = $False
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
				"True" {
					<#
						.从注册表获取卷标名
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
						$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue
					} else {
						$CustomRAMDISKLabel = $Global:Init_RAMDISK_Volume_Label
					}

					$MarkRAMDISK_Is_Check = $True
				}
			}
		}

		Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
			if (Test_Available_Disk -Path $_.DriveLetter) {
				$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 40
					Width     = 415
					Text      = "$($_.Label) ($($_.DriveLetter))"
					Tag       = $_.DriveLetter
					add_Click = { Image_Select_Refresh_Sources_Event }
				}

				if ($MarkRAMDISK_Is_Check) {
					if ($_.Label -eq $CustomRAMDISKLabel) {
						$MarkRAMDISK_Match_Done = $True
						$RadioButton.Checked = $True
						$RadioButton.ForeColor = "#008000"
						$UI_Mask_Image_Mount_To_Tips.Text = "$($lang.AutoSelectRAMDISK): $($Global:Init_RAMDISK_Volume_Label) ($($_.DriveLetter))"
					}
				}

				if ($GUIImageSourceGroupMountChangeExclude.Checked) {
					if ($_.FileSystem -eq "ReFS") {
						$RadioButton.Height = 55
						$RadioButton.Text = "$($_.Label) ($($_.DriveLetter)), $($lang.Disable)`n$($lang.ReFS_Exclude)"
						$RadioButton.Enabled = $False
						$RadioButton.Checked = $False
					}
				} 

				if ($GUIImageSourceGroupMountChangeDiSKLowSize.Checked) {
					if (-not (Verify_Available_Size -Disk $_.DriveLetter -Size $GUIImageSourceGroupMountChangeLowSize.Text)) {
						$RadioButton.Enabled = $False
						$RadioButton.Height = 55
						$RadioButton.Text += ", $($lang.Disable)`n$($lang.Disk_Not_satisfied_Exclude)"
					}
				}

				$GUIImageSourceGroupMountChangeDiSKPane1.controls.AddRange($RadioButton)
			}
		}

		if ($MarkRAMDISK_Is_Check) {
			if ($MarkRAMDISK_Match_Done) {
			} else {
				$UI_Mask_Image_Mount_To_Tips.Text = "$($lang.AutoSelectRAMDISKFailed): $($Global:Init_RAMDISK_Volume_Label)"
			}
		} else {
			$UI_Mask_Image_Mount_To_Tips.Text = "$($lang.AutoSelectRAMDISKFailed): $($lang.NoWork)"
		}

		<#
			.初始化: 自定义缓存路径
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
				"True" {
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\" -Name "DiskCache" -ErrorAction SilentlyContinue) {
						$GetRegeditDiskCache = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue

						if (Test_Available_Disk -Path $GetRegeditDiskCache) {
							$RadioButton = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = 35
								Width     = 340
								Text      = $GetRegeditDiskCache
								Tag       = $GetRegeditDiskCache
								add_Click = { Image_Select_Refresh_Sources_Event }
							}

							if ($RadioButton.Tag -eq $GetRegeditDiskCache) {
								$RadioButton.Checked = $True
								$RadioButton.ForeColor = "#008000"
							}

							$UI_Mask_Image_Mount_To_Tips.Text = "$($lang.AutoSelectRAMDISK): $($GetRegeditDiskCache)"
							$GUIImageSourceGroupMountChangeDiSKPane1.controls.AddRange($RadioButton)
						}
					}
				}
			}
		}
	}

	<#
		.事件: 选择挂载磁盘
	#>
	Function Image_Select_Refresh_Sources_Event
	{
		$UI_Mask_Image_Mount_To_Error.Text = ""
		$UI_Mask_Image_Mount_To_Error_Icon.Image = $null
		$Match_Done_And_Failed = $False

		<#
			.标记获取磁盘
		#>
		$GUIImageSourceGroupMountChangeDiSKPane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
#				if ($_.Enabled) {
					if ($_.Checked) {
						$Match_Done_And_Failed = $True
						$MarkNewLabelMountTo = (Join_MainFolder -Path $_.Tag)
						$MarkNewLabelMountToTemp = (Join_MainFolder -Path $_.Tag)
						$FullNewPath = [IO.Path]::GetFileName($GUIImageSourceGroupMountFromPath.Text)

						if ([string]::IsNullOrEmpty($FullNewPath)) {
							$NewOtherRuleName = [System.IO.Path]::GetPathRoot($GUIImageSourceGroupMountFromPath.Text).Substring(0,1)

							$MarkNewLabelMountTo += "$($NewOtherRuleName)_Custom"
							$MarkNewLabelMountToTemp += "$($NewOtherRuleName)_Custom\Temp"
						} else {
							$MarkNewLabelMountTo += "$($FullNewPath)_Custom"
							$MarkNewLabelMountToTemp += "$($FullNewPath)_Custom\Temp"
						}

						if ($GUIImageSourceGroupMountChangeTemp.Checked) {
							$MarkNewLabelMountTo += "\Temp"
							$MarkNewLabelMountToTemp += "\Temp"
						}

						$GUIImageSourceGroupMountToShow.Text = $MarkNewLabelMountTo
						if ($GUIImageSourceGroupMountToTemp.Checked) {
							$GUIImageSourceGroupMountToTempShow.Text = $MarkNewLabelMountToTemp
						} else {
							$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
						}

						Save_Dynamic -regkey "Solutions" -name "DiskMinSize" -value $($GUIImageSourceGroupMountChangeLowSize.Text)
					}
#				}
			}
		}

		if ($Match_Done_And_Failed) {
		} else {
			$FullNewPath = $GUIImageSourceGroupMountFromPath.Text

			$NewOtherRuleName = [IO.Path]::GetFileName($FullNewPath)
			if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
				$NewOtherRuleName = [System.IO.Path]::GetPathRoot($FullNewPath).Substring(0,1)

				$MarkNewLabelMountTo += Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
				$MarkNewLabelMountToTemp += Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)\Temp"

				if ($GUIImageSourceGroupMountChangeTemp.Checked) {
					$MarkNewLabelMountTo += "\Temp"
					$MarkNewLabelMountToTemp += "\Temp"
				}

				$GUIImageSourceGroupMountToShow.Text = $MarkNewLabelMountTo
				if ($GUIImageSourceGroupMountToTemp.Checked) {
					$GUIImageSourceGroupMountToTempShow.Text = $MarkNewLabelMountToTemp
				} else {
					$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
				}
			} else {
				$MarkNewLabelMountTo += "$($FullNewPath)_Custom"
				$MarkNewLabelMountToTemp += "$($FullNewPath)_Custom\Temp"

				if ($GUIImageSourceGroupMountChangeTemp.Checked) {
					$MarkNewLabelMountTo += "\Temp"
					$MarkNewLabelMountToTemp += "\Temp"
				}

				$GUIImageSourceGroupMountToShow.Text = $MarkNewLabelMountTo
				if ($GUIImageSourceGroupMountToTemp.Checked) {
					$GUIImageSourceGroupMountToTempShow.Text = $MarkNewLabelMountToTemp
				} else {
					$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
				}
			}
		}

		<#
			.重置打开目录
		#>
		Image_Select_Refresh_Sources
	}

	$GetDiskAvailableClick = {
		$UI_Mask_Image_Mount_To_Error.Text = ""
		$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

		if ($GUIImageSourceGroupMountChangeDiSKLowSize.Checked) {
			$GUIImageSourceGroupMountChangeLowSize.Enabled = $True
		} else {
			$GUIImageSourceGroupMountChangeLowSize.Enabled = $False
		}

		Image_Select_Refresh_Mount_Disk
		Image_Select_Refresh_Sources_Event
	}

	Function Image_Select_Other_Path_Refresh
	{
		$UI_Other_Path_Show.controls.Clear()

		<#
			.初始化字符长度
		#>
		[int]$InitCharacterLength = 65

		<#
			.初始化控件高度
		#>
		[int]$InitControlHeight = 45

		<#
			.其它位置
		#>
		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name 'Sources_Other_Directory' -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value "" -Type "MultiString"
		}
		$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name "Sources_Other_Directory" -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$TempSelectAraayOtherRule = @()
		ForEach ($item in $GetExcludeSoftware) {
			$TempSelectAraayOtherRule += $item
		}

		if ($TempSelectAraayOtherRule.count -gt 0) {
			ForEach ($item in $TempSelectAraayOtherRule) {
				$InitLength = $item.Length
				if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
					Width     = 415
					Text      = $item
				}

				$UI_Other_Path_Show.controls.AddRange($CheckBox)
			}
		}
	}

	Function Image_Select_Refresh_Detailed
	{
		$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单
		$FlagChangeLanguage = $False
		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$FlagChangeLanguage = $True
					}
				}
			}
		}

		if ($FlagChangeLanguage) {
			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $True       # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			<#
				.添加托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)
		} else {
			$UI_Main_Error.Text = $lang.NoSelectImageSource
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Image_Select_Refresh_Event
	{
		$GUISelectOtherSettingSaveModeErrorMsg.Text = ""
		$GUISelectOtherSettingSaveModeErrorMsg_Icon.Image = $null

		$GUISelectGroupAfterFinishing.Enabled = $False
		$GUIImageSourceGroupSettingEventSelect.controls.Clear()

		$UI_Main_Event_Select_OnDemandPlanTask = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Text           = $lang.OnDemandPlanTask
		}
		$GUIImageSourceGroupSettingEventSelect.controls.AddRange($UI_Main_Event_Select_OnDemandPlanTask)
		$CakeGroup = @()
		Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Assign" -ErrorAction SilentlyContinue | ForEach-Object {
			$CakeGroup += Split-Path -Path $_.Name -Leaf
		}

		if ($CakeGroup.Count -gt 0) {
			Foreach ($item in $CakeGroup) {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Name      = "Assign"
					Height    = 30
					Width     = 435
					Padding   = "16,0,0,0"
					Text      = $item
					add_Click = {
						$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($_.Enabled) {
									if ($_.Checked) {
										$GUISelectGroupAfterFinishing.Enabled = $True

										if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Assign\$($_.Text)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
											switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Assign\$($_.Text)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
												"NoProcess" { $GUISelectAfterFinishingNoProcess.Checked = $True }
												"Pause" { $GUISelectAfterFinishingPause.Checked = $True }
												"Reboot" { $GUISelectAfterFinishingReboot.Checked = $True }
												"Shutdown" { $GUISelectAfterFinishingShutdown.Checked = $True }
											}
										} else {
											$GUISelectAfterFinishingNOProcess.Checked = $True
										}
									}
								}
							}
						}
					}
				}

				$GUIImageSourceGroupSettingEventSelect.controls.AddRange($CheckBox)
			}
		} else {
			$UI_Main_Event_Select_NoEvent = New-Object system.Windows.Forms.Label -Property @{
				Height  = 30
				Width   = 435
				Padding = "16,0,0,0"
				Text    = $lang.NoWork
			}
			$GUIImageSourceGroupSettingEventSelect.controls.AddRange($UI_Main_Event_Select_NoEvent)
		}

		$UI_Main_Event_Select_Wrap  = New-Object system.Windows.Forms.Label -Property @{
			Height         = 35
			Width          = 435
		}
		$UI_Main_Event_Select_Autopilot = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Text           = $lang.Autopilot
		}
		$GUIImageSourceGroupSettingEventSelect.controls.AddRange((
			$UI_Main_Event_Select_Wrap,
			$UI_Main_Event_Select_Autopilot
		))

		$CakeGroup = @()
		Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Queue" -ErrorAction SilentlyContinue | ForEach-Object {
			$CakeGroup += Split-Path -Path $_.Name -Leaf
		}
		if ($CakeGroup.Count -gt 0) {
			Foreach ($item in $CakeGroup) {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Name      = "Queue"
					Height    = 30
					Width     = 435
					Padding   = "16,0,0,0"
					Text      = $item
					add_Click = {
						$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($_.Enabled) {
									if ($_.Checked) {
										$GUISelectGroupAfterFinishing.Enabled = $True

										if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Queue\$($_.Text)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
											switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Queue\$($_.Text)" -Name "AfterFinishing" -ErrorAction SilentlyContinue) {
												"NoProcess" { $GUISelectAfterFinishingNoProcess.Checked = $True }
												"Pause" { $GUISelectAfterFinishingPause.Checked = $True }
												"Reboot" { $GUISelectAfterFinishingReboot.Checked = $True }
												"Shutdown" { $GUISelectAfterFinishingShutdown.Checked = $True }
											}
										} else {
											$GUISelectAfterFinishingNOProcess.Checked = $True
										}
									}
								}
							}
						}
					}
				}

				$GUIImageSourceGroupSettingEventSelect.controls.AddRange($CheckBox)
			}
		} else {
			$UI_Main_Event_Select_NoEvent = New-Object system.Windows.Forms.Label -Property @{
				Height  = 30
				Width   = 435
				Padding = "16,0,0,0"
				Text    = $lang.NoWork
			}
			$GUIImageSourceGroupSettingEventSelect.controls.AddRange($UI_Main_Event_Select_NoEvent)
		}
	}

	<#
		.Event: Click Event and select the image source
		.事件: 点击了事件, 选择映像源
	#>
	Function Refresh_Click_Image_Sources
	{
		$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单
		$UI_Main_Ok.Visible = $False                    # 隐藏: 确定按钮
		$UI_Main_To.Visible = $False                    # 显示: 前往到

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Mask_Image_Mount_To_Error.Text = ""
		$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

		$GUISelectOtherSettingSaveModeErrorMsg.Text = ""
		$GUISelectOtherSettingSaveModeErrorMsg_Icon.Image = $null

		$GUIImageSourceOtherImageErrorMsg.Text = ""

		$UI_Mask_Image_Language_Error.Text = ""
		$GUIImageSourceGroupSettingEventClear.Enabled = $True
		$GUISelectOtherSettingSaveModeClear.Enabled = $True

		<#
			.清除选择主键
		#>
		$UI_Primary_Key_Select.controls.Clear()
		$UI_Primary_Key_Group.Visible = $False

		$UI_Main_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					<#
						1. 优先判断文件是否存在, 不存在时, 强行重新刷新一次
					#>
					if ((Test-Path -Path "$($_.Name)\sources\boot.wim" -PathType Leaf) -or
						(Test-Path -Path "$($_.Name)\sources\install.*" -PathType Leaf))
					{
					} else {
						Image_Select_Refresh_Sources_List
						return
					}

					$Global:Image_source = $_.Name
					$Global:MainImage = $_.Tag

					$GUIImageSourceGroupMountFromPath.Text = $_.Name
					$UI_ImageSources_Del_Path.Text = $_.Name

					$Current_Image_Sources_Save_To_Reg_Path = "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)"

					<#
						.从注册表获取完成后事件: 
						2: 暂停; 3: 重启计算机; 4: 关闭计算机
					#>
					$GUISelectGroupAfterFinishing.Enabled = $False

					Image_Select_Refresh_Mount_Disk
					Image_Select_Refresh_Sources_Event

					$Global:Mount_To_Route = $GUIImageSourceGroupMountToShow.Text
					$Global:Mount_To_RouteTemp = $GUIImageSourceGroupMountToTempShow.Text
					$GUIImageSourceGroupMountFromRename_New_Path.Name = $_.Tag
					$GUIImageSourceGroupMountFromRename_New_Path.Text = $_.Tag

					$Script:Mark_Is_Legal_Sources_init = $False

					<#
						.刷新全局规则
					#>
					Image_Refresh_Init_GLobal_Rule

					<#
						从注册表获取是否临时目录与挂载到位置相同
					#>
					if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "TempFolderSync" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "TempFolderSync" -ErrorAction SilentlyContinue) {
							"True" { $GUIImageSourceGroupMountToTemp.Checked = $True }
							"False" { $GUIImageSourceGroupMountToTemp.Checked = $False }
						}
					}

					<#
						从注册表获取是否使用临时目录
					#>
					if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "UseTempFolder" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "UseTempFolder" -ErrorAction SilentlyContinue) {
							"True" { $GUIImageSourceGroupMountChangeTemp.Checked = $True }
							"False" { $GUIImageSourceGroupMountChangeTemp.Checked = $False }
						}
					} else {
						$GUIImageSourceGroupMountChangeTemp.Checked = $False
					}

					<#
						从注册表获取挂载目录
					#>
					if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRouting" -ErrorAction SilentlyContinue) {
						$GUIImageSourceGroupMountToShow.Text = Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRouting"
					} else {
						$GUIImageSourceGroupMountToShow.Text = $(Get_MainMasterFolder)
					}

					<#
						删除
					#>
						<#
							.主目录: 自定义规则
						#>
						$GUIImageSourceGroupMountFromDelete_Custom_Path.Text = $(Get_MainMasterFolder)

						if (Test-Path -Path $GUIImageSourceGroupMountFromDelete_Custom_Path.Text -PathType Container) {
							$GUIImageSourceGroupMountFromDelete_Custom.Enabled = $true
							$GUIImageSourceGroupMountFromDelete_Custom.Checked = $true
						} else {
							$GUIImageSourceGroupMountFromDelete_Custom.Checked = $False
							$GUIImageSourceGroupMountFromDelete_Custom.Enabled = $False
						}

						<#
							.注册表: 已保存所有配置
						#>
						$GUIImageSourceGroupMountFromDelete_Clear_Path.Text = $Current_Image_Sources_Save_To_Reg_Path
						if (Test-Path -Path $Current_Image_Sources_Save_To_Reg_Path -PathType Container) {
							$GUIImageSourceGroupMountFromDelete_Clear.Enabled = $true
							$GUIImageSourceGroupMountFromDelete_Clear.Checked = $true
						} else {
							$GUIImageSourceGroupMountFromDelete_Clear.Enabled = $False
							$GUIImageSourceGroupMountFromDelete_Clear.Checked = $False
						}

					<#
						从注册表获取挂载临时目录
					#>
					if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRoutingTemp" -ErrorAction SilentlyContinue) {
						$GetDiskMinSize = Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRoutingTemp"
						$GUIImageSourceGroupMountToTempShow.Text = $GetDiskMinSize
					} else {
						$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
					}

					<#
						从注册表获取保存的映像默认语言
					#>
					ISO_Verify_Sources_Language

					<#
						.重置: 重新选择语言界面
					#>
					$UI_Mask_Image_Language_Select.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($Global:MainImageLang -eq $_.Tag) {
								$_.Checked = $True
							} else {
								$_.Checked = $False
							}
						}
					}

					<#
						.Get the matched or saved tag name
						.匹配 MVS (MSDN) 版本
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue) {
						$GetSaveLabelName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Name" -ErrorAction SilentlyContinue
						$GetSaveLabelGUID = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue

						$GUIImageSourceOtherImageErrorMsg.Text += "$($lang.Editions) ( $($GetSaveLabelName), $($GetSaveLabelGUID) )"
					} else {
						$Verify_Language_New_Path = Match_Images_MSDN_MVS -ISO $Global:MainImage
						if ($Verify_Language_New_Path) {
							$GUIImageSourceOtherImageErrorMsg.Text += "$($lang.Editions) ( $($Verify_Language_New_Path.Name), $($Verify_Language_New_Path.GUID) )"
						} else {
							$GUIImageSourceOtherImageErrorMsg.Text += "$($lang.Editions) ( $($lang.ImageCodenameNo) )"
						}
					}

					$EICfgPath = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
					if (Test-Path -Path $EICfgPath -PathType leaf) {
						$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.InstlMode) ( $($lang.Business) )"
					} else {
						$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.InstlMode) ( $($lang.Consumer) )"
					}

					<#
						判断内核
					#>
					ISO_Verify_Kernel

					<#
						判断架构
					#>
					ISO_Verify_Arch

					<#
						.判断安装类型
					#>
					ISO_Verify_Install_Type

					<#
						.Get the matched or saved tag name
						.获取匹配到, 或已保存的标签名
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Label" -ErrorAction SilentlyContinue) {
						$GetSaveLabelSelect = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Label" -ErrorAction SilentlyContinue
						$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageCodename) ( $($GetSaveLabelSelect), $($lang.Save) )"
					} else {
						$MarkCodename = $False
						ForEach ($item in $Global:OSCodename) {
							if ($Global:MainImage -like "*$($item)*") {
								$MarkCodename = $True
								Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Label" -value $item
								$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageCodename) ( $($item), $($lang.MatchMode) )"
								break
							}
						}

						if (-not $MarkCodename) {
							$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageCodename) ( $($lang.ImageCodenameNo) )"
						}
					}

					<#
						.从注册表获取完成后事件: 
						2: 暂停; 3: 重启计算机; 4: 关闭计算机
					#>
					[int]$MarkInitLanguage = 0
					Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Queue" -ErrorAction SilentlyContinue | ForEach-Object {
						$MarkInitLanguage++
					}
					Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Assign" -ErrorAction SilentlyContinue | ForEach-Object {
						$MarkInitLanguage++
					}
					Image_Select_Refresh_Event

					if ($MarkInitLanguage -ge "1") {
						$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.EventManager): $($MarkInitLanguage) $($lang.EventManagerCount)"
					} else {
						$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.EventManager): $($lang.EventManagerNo)"
					}

					$UI_Main_Select_Sources.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($_.Tag)" -Name "language" -ErrorAction SilentlyContinue) {
										$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.SaveModeTipsClear)"
									}
								}
							}
						}
					}

					<#
						.Tag: match from the current operating system mounted list
						.标记: 从当前操作系统已挂载列表匹配
					#>
					ForEach ($item in $Global:Image_Rule) {
						if ($Global:SMExt -contains $item.Main.Suffix) {
							Image_Select_New_Sources -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $item.Main.ImageFileName -Suffix $item.Main.Suffix -ImageFile "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)" -ImageUid $item.Main.Uid

							if ($item.Expand.Count -gt 0) {
								ForEach ($Expand in $item.Expand) {
									$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

									Image_Select_New_Sources -Master $item.Main.ImageFileName -MasterSuffix $item.Main.Suffix -ImageName $Expand.ImageFileName -Suffix $Expand.Suffix -ImageFile $test_mount_folder_Current -ImageUid $Expand.Uid -Expand
								}
							}
						}
					}

					<#
						.刷新挂载状态
					#>
					<#
						.未挂载, 再次重新获取是否 自动匹配 RAMDISK 盘符
					#>
					Image_Select_Refresh_Sources_Event

					if ($Script:Mark_Is_Legal_Sources_init) {
						<#
							从注册表获取挂载目录
						#>
						if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRouting" -ErrorAction SilentlyContinue) {
							$GUIImageSourceGroupMountToShow.Text = Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRouting"
						} else {
#							$GUIImageSourceGroupMountToShow.Text = "$($Global:Image_source)_Custom"
						}

						<#
							从注册表获取挂载临时目录
						#>
						if (Get-ItemProperty -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRoutingTemp" -ErrorAction SilentlyContinue) {
							$GetDiskMinSize = Get-ItemPropertyValue -Path $Current_Image_Sources_Save_To_Reg_Path -Name "MountToRoutingTemp"
							$GUIImageSourceGroupMountToTempShow.Text = $GetDiskMinSize
						} else {
							$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
						}

						$GUIImageSourceGroupMountChangePanel.Enabled = $False
						$GUIImageSourceGroupMountToTemp.Enabled = $False
						$UI_Mask_Image_Mount_To_Reset.Enabled = $False
						$GUIImageSourceGroupSettingEventClear.Enabled = $False
						$GUISelectOtherSettingSaveModeClear.Enabled = $False
						$GUIImageSourceGroupMountFromDelete.Enabled = $False
						$GUIImageSourceGroupMountFromRename.Enabled = $False
						$GUIImageSourceMountInfo.Text = "$($lang.Mounted), $($lang.Detailed_View)"

						$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Mounted), $($lang.Function_Limited)"
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					} else  {
						$GUIImageSourceGroupMountChangePanel.Enabled = $True
						$GUIImageSourceGroupMountToTemp.Enabled = $True
						$UI_Mask_Image_Mount_To_Reset.Enabled = $True
						$GUIImageSourceGroupSettingEventClear = $True
						$GUISelectOtherSettingSaveModeClear.Enabled = $True
						$GUIImageSourceGroupMountFromDelete.Enabled = $True
						$GUIImageSourceGroupMountFromRename.Enabled = $True
						$GUIImageSourceMountInfo.Text = $lang.NotMountedSpecify

						$UI_Mask_Image_Mount_To_Error.Text = $lang.NotMountedSpecify
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
					}

					<#
						.重置: 刷新到, 默认选择（不前往）
					#>
					$UI_Main_To.SelectedIndex = $UI_Main_To.FindString($lang.Ok_Go_To_No)
				}

				$UI_Main_Image_Sources_Menu_Show.visible = $False # 隐藏：菜单
				$UI_Main_Ok.Visible = $True                    # 显示: 确定按钮
				$UI_Main_To.Visible = $True                    # 显示: 前往到
				$GUIImageSourceGroupMount.Visible = $True      # 动态显示: 挂载到
				$GUIImageSourceGroupLang.Visible = $True       # 动态显示: 更改语言
				$GUIImageSourceGroupOther.Visible = $True      # 动态显示: 详细

				$UI_Main_Error.Text = "$($lang.Ok_Go_To): $($lang.Autopilot), $($lang.OnDemandPlanTask), $($lang.MoreFeature)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
			}
		}
	}

	Function Image_Select_New_Sources
	{
		param
		(
			$Master,
			$MasterSuffix,
			$ImageName,
			$Suffix,
			$ImageFile,
			$ImageUid,
			[switch]$Expand
		)

		<#
			.判断 ISO 主要来源是否存在文件
		#>
		if (Test-Path -Path $ImageFile -PathType leaf) {
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "IsSelectPKY" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "IsSelectPKY" -ErrorAction SilentlyContinue) {
					"True" {
						$UI_Primary_Key_Name.Checked = $True
						$UI_Primary_Key_Select.Enabled = $True
					}
					"False" {
						$UI_Primary_Key_Name.Checked = $False
						$UI_Primary_Key_Select.Enabled = $False
					}
				}
			} else {
				$UI_Primary_Key_Name.Checked = $False
				$UI_Primary_Key_Select.Enabled = $False
			}

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
					"True" {
						$UI_Primary_Key_Group.Visible = $True

						$GUIImageSelectInstall = New-Object System.Windows.Forms.RadioButton -Property @{
							Height             = 30
							Width              = 245
							Text               = "$($ImageName).$($Suffix)"
							Tag                = $ImageUid
						}

						if ($Global:Primary_Key_Image.ImageSources -eq $Global:Image_source) {
							if ($Global:Primary_Key_Image.Uid -eq $ImageUid) {
								$GUIImageSelectInstall.Checked = $True
							}
						}

						$GUIImageSelectInstallTips = New-Object System.Windows.Forms.Label -Property @{
							autosize           = 1
							Padding            = "15,0,0,0"
							Text               = ""
						}
					
						$GUIImageSelectInstall_Wrap = New-Object System.Windows.Forms.Label -Property @{
							Height             = 18
							Width              = 245
						}
						$UI_Primary_Key_Select.controls.AddRange($GUIImageSelectInstall)
					
						$Verify_New_WIM = @()
						try {
							Get-WindowsImage -ImagePath $ImageFile -ErrorAction SilentlyContinue | ForEach-Object {
								$Verify_New_WIM += [pscustomobject]@{
									Index            = $_.ImageIndex
									Name             = $_.ImageName
									ImageDescription = $_.ImageDescription
								}
							}
						} catch {
							$GUIImageSelectInstall.Text = "$($ImageName).$($Suffix), $($lang.SelectFileFormatError)"
							$GUIImageSelectInstall.Enabled = $False
							$GUIImageSelectInstall.ForeColor = "#FF0000"
						}
					
						if ($Verify_New_WIM.Count -gt 0) {
							$UI_Primary_Key_Select.controls.AddRange((
								$GUIImageSelectInstallTips,
								$GUIImageSelectInstall_Wrap
							))
						}
					
						if ($Expand) {
							$GUIImageSelectInstall.Padding = "20,0,0,0"
							$GUIImageSelectInstallTips.Padding = "36,0,0,0"
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
								<#
									.判断文件路径与当前是否一致
								#>
								if ($_.ImagePath -eq $ImageFile) {
									$MarkErrorMounted = $True
									$Script:Mark_Is_Legal_Sources_init = $True

									switch ($_.MountStatus) {
										<#
											.不合法和损坏
										#>
										"Invalid" {
											$GUIImageSelectInstall.ForeColor = "#FF0000"
											$GUIImageSelectInstallTips.Text = $lang.Invalid
										}
										"NeedsRemount" {
											$GUIImageSelectInstall.ForeColor = "#FF0000"
											$GUIImageSelectInstallTips.Text = $lang.NeedsRemount
										}
										"Ok" {
											$GUIImageSelectInstall.ForeColor = "#008000"
											$GUIImageSelectInstallTips.Text = "$($lang.Mounted), $($lang.Healthy)"
										}
										Default {
											$GUIImageSelectInstallTips.Text = $lang.ImageCodenameNo
										}
									}
								}
							}

							if ($MarkErrorMounted) {
								return
							} else {
								$test_mount_folder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Master).$($MasterSuffix)\$($ImageName).$($Suffix)\Mount"
							
								if (Test-Path -Path $test_mount_folder -PathType Container) {
									if((Get-ChildItem $test_mount_folder -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
										$GUIImageSelectInstallTips.Text = $lang.MountedIndexError
									} else {
										$GUIImageSelectInstallTips.Text = $lang.NotMounted
									}
								} else {
									$GUIImageSelectInstallTips.Text = $lang.NotMounted
								}
							}
						} catch {
							$GUIImageSelectInstallTips.Text = $lang.MountedIndexError
						}
					}
				}
			}
		}
	}

	<#
		.重置打开目录
	#>
	Function Image_Select_Refresh_Sources
	{
		<#
			.映像源
		#>
		if (Test-Path -Path $GUIImageSourceGroupMountFromPath.Text -PathType Container) {
			$GUIImageSourceGroupMountFromOpenFolder.Enabled = $True
			$GUIImageSourceGroupMountFromPaste.Enabled = $True
		} else {
			$GUIImageSourceGroupMountFromOpenFolder.Enabled = $False
			$GUIImageSourceGroupMountFromPaste.Enabled = $False
		}

		<#
			.挂载到
		#>
		if (Test-Path -Path $GUIImageSourceGroupMountToShow.Text -PathType Container) {
			$GUIImageSourceGroupMountToOpenFolder.Enabled = $True
			$GUIImageSourceGroupMountToPaste.Enabled = $True
		} else {
			$GUIImageSourceGroupMountToOpenFolder.Enabled = $False
			$GUIImageSourceGroupMountToPaste.Enabled = $False
		}

		<#
			.临时目录
		#>
		if (Test-Path -Path $GUIImageSourceGroupMountToTempShow.Text -PathType Container) {
			$GUIImageSourceGroupMountToTempOpenFolder.Enabled = $True
			$GUIImageSourceGroupMountToTempPaste.Enabled = $True
		} else {
			$GUIImageSourceGroupMountToTempOpenFolder.Enabled = $False
			$GUIImageSourceGroupMountToTempPaste.Enabled = $False
		}
	}

	<#
		.选择了新的 ISO 文件
	#>
	$UISelectISOClick = {
		$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
		$UIUnzipPanel_To_New_Path.BackColor = "#FFFFFF"
		$UIUnzipPanelErrorMsg.Text = ""
		$UIUnzipPanelErrorMsg_Icon.Image = $null
		$UIUnzipPanelErrorMsg.ForeColor = "#000000"

		$UIUnzip_Select_Sources.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$UIUnzipPanel_To_Path.Text = $_.Text
						$UIUnzipPanel_To_New_Path.Text = [System.IO.Path]::GetFileNameWithoutExtension($_.Text)

						Refresh_ISO_CRC_SHA
					}
				}
			}
		}
	}

	Function Refresh_ISO_CRC_SHA
	{
		$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA256_Calibration.Name = ""

		$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA512_Calibration.Name = ""

		$MatchFile = [System.IO.Path]::GetFileName($UIUnzipPanel_To_Path.Text)
		foreach ($item in $Script:Known_MSDN) {
			if ($item.ISO -eq $MatchFile) {
				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA256)) {
				} else {
					$UIUnzipPanel_SHA256_Calibration.Name = $item.CRCSHA.SHA256
					$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($item.CRCSHA.SHA256)"
				}

				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA512)) {
				} else {
					$UIUnzipPanel_SHA512_Calibration.Name = $item.CRCSHA.SHA512
					$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($item.CRCSHA.SHA512)"
				}
				return
			}
		}

		foreach ($item in $Script:Exclude_Fod_Or_Language) {
			if ($item.ISO -eq $MatchFile) {
				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA256)) {
				} else {
					$UIUnzipPanel_SHA256_Calibration.Name = $item.CRCSHA.SHA256
					$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($item.CRCSHA.SHA256)"
				}

				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA512)) {
				} else {
					$UIUnzipPanel_SHA512_Calibration.Name = $item.CRCSHA.SHA512
					$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($item.CRCSHA.SHA512)"
				}
				return
			}
		}

		foreach ($item in $Script:Exclude_InBox_Apps) {
			if ($item.ISO -eq $MatchFile) {
				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA256)) {
				} else {
					$UIUnzipPanel_SHA256_Calibration.Name = $item.CRCSHA.SHA256
					$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($item.CRCSHA.SHA256)"
				}

				if ([string]::IsNullOrEmpty($item.CRCSHA.SHA512)) {
				} else {
					$UIUnzipPanel_SHA512_Calibration.Name = $item.CRCSHA.SHA512
					$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($item.CRCSHA.SHA512)"
				}
				return
			}
		}
	}

	Function ISO_Select_Refresh_Sources_List
	{
		$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
		$UIUnzipPanel_To_New_Path.BackColor = "#FFFFFF"
		$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA256_Calibration.Name = ""

		$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA512_Calibration.Name = ""

		if ($UIUnzip_Search_Show_Select.Checked) {
			$UIUnzip_Search_Rule_Show.Enabled = $False
		}

		if ($UIUnzip_Search_Rule_Select.Checked) {
			$UIUnzip_Search_Rule_Show.Enabled = $True
		}

		<#
			.初始化: 从默认规则, 自定义规则里获取已知 ISO
		#>
		Refresh_Rule_ISO

		<#
			.计算公式: 
				四舍五入为整数
					(初始化字符长度 * 初始化字符长度）
				/ 控件高度
		#>

		<#
			.初始化字符长度
		#>
		[int]$InitCharacterLength = 175

		<#
			.初始化控件高度
		#>
		[int]$InitControlHeight = 55

		<#
			.重置: 映像源显示区域
		#>
		$UIUnzip_Select_Sources.controls.Clear()
		$UIUnzipPanel_To_Path.Text = ""
		$UIUnzipPanel_To_New_Path.Text = ""
		$UIUnzipPanelErrorMsg.Text = ""
		$UIUnzipPanelErrorMsg_Icon.Image = $null
		$UIUnzipPanelErrorMsg.ForeColor = "#000000"

		<#
			.所有文件
		#>
		$Script:Init_Folder_All_File = @()
		$Script:Init_Folder_All_File_Show = @()

		<#
			.已匹配成功的文件
		#>
		$Script:Init_Folder_All_File_Match_Done = @()

		<#
			.未匹配到的文件: 其它
		#>
		$Script:Init_Folder_All_File_Exclude = @()

		<#
			.语言包分类: InBox Apps
		#>
		$Script:Init_File_Type_InBox_Apps = @()
		$Init_File_Type_InBox_Apps_Match = @(
			"*InboxApps*"
		)

		<#
			.语言包分类: 已知语言包, 功能包
		#>
		$Script:Init_File_Type_Fod_And_Lang = @()
		$Init_File_Type_Fod_And_Lang_Match = @(
			"*CLIENTLANGPACKDVD*"
			"*CLIENT_LOF_PACKAGES*"
			"*CLIENT_LOF_PACKAGES_OEM*"
			"*FOD-PACKAGES*"
			"*LangPack*"
			"*Languages*"
			"*optional_Fuature*"
		)

		if (Test-Path -Path $UIUnzipPanel_Menu_Sources_Path.Text -PathType Container) {
			$UIUnzipPanel_Menu_Sources_Path.Enabled = $True

			Get-ChildItem -Path $UIUnzipPanel_Menu_Sources_Path.Text -Recurse -Include ($Global:SearchISOType) -ErrorAction SilentlyContinue | ForEach-Object {
				$Script:Init_Folder_All_File += $_.FullName
			}

			<#
				.显示全部
			#>
			if ($UIUnzip_Search_Show_Select.Checked) {
				Save_Dynamic -regkey "Solutions\ISO" -name "Is_Unzip_Rule" -value "ShowAll"

				<#
					.搜索功能
				#>
				<#
					.判断是否空白
				#>
				if ([string]::IsNullOrEmpty($UIUnzip_Search_Sift_Custon.Text)) {
					$Script:Init_Folder_All_File_Show = $Script:Init_Folder_All_File

					<#
						分类: 功能包, 语言包
					#>
					ForEach ($WildCard in $Script:Init_Folder_All_File_Show) {
						$SaveToName = [IO.Path]::GetFileName($WildCard)

						if ($Script:Exclude_Fod_Or_Language.ISO -contains $SaveToName) {
							$Script:Init_File_Type_Fod_And_Lang += $WildCard
							$Script:Init_Folder_All_File_Match_Done += $WildCard
						}

						ForEach ($NewMatch in $Init_File_Type_Fod_And_Lang_Match) {
							if ($SaveToName -like $NewMatch) {
								if ($Script:Init_File_Type_Fod_And_Lang -notcontains $WildCard) {
									$Script:Init_File_Type_Fod_And_Lang += $WildCard
									$Script:Init_Folder_All_File_Match_Done += $WildCard
								}
							}
						}
					}

					<#
						.分类: InBox Apps
					#>
					ForEach ($WildCard in $Script:Init_Folder_All_File_Show) {
						$SaveToName = [IO.Path]::GetFileName($WildCard)

						if ($Script:Exclude_InBox_Apps.ISO -contains $SaveToName) {
							$Script:Init_File_Type_InBox_Apps += $WildCard
							$Script:Init_Folder_All_File_Match_Done += $WildCard
						}

						ForEach ($NewMatch in $Init_File_Type_InBox_Apps_Match) {
							if ($SaveToName -like $NewMatch) {
								if ($Script:Init_File_Type_InBox_Apps -notcontains $WildCard) {
									$Script:Init_File_Type_InBox_Apps += $WildCard
									$Script:Init_Folder_All_File_Match_Done += $WildCard
								}
							}
						}
					}

					<#
						.9 = 语言包其它
					#>
					ForEach ($item in $Script:Init_Folder_All_File_Show) {
						if ($Script:Init_Folder_All_File_Match_Done -notcontains $item) {
							$Script:Init_Folder_All_File_Exclude += $item
						}
					}

					<#
						.添加控件: 其它
					#>
					if ($Script:Init_Folder_All_File_Show.count -gt 0) {
						$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Text           = "$($lang.ISO_Other): $($Script:Init_Folder_All_File_Exclude.Count) $($lang.EventManagerCount)"
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

						if ($Script:Init_Folder_All_File_Exclude.count -gt 0) {
							ForEach ($item in $Script:Init_Folder_All_File_Exclude) {
								$InitLength = $item.Length
								if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

								$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
									Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
									Width     = 645
									Padding   = "25,0,0,0"
									Text      = $item
									add_Click = $UISelectISOClick
								}

								if ($Script:Known_MSDN.ISO -contains [IO.Path]::GetFileName($item)) {
									$CheckBox.ForeColor = "#008000"
								}

								$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
							}
						} else {
							$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
								autosize = 1
								Padding  = "18,0,0,0"
								margin   = "0,5,0,5"
								Text     = "$($lang.NoImagePreSource -f $Global:MainMasterFolder)"
							}
							$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
						}
						$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height       = 30
							Width        = 645
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Add_End_Wrap)

						<#
							.添加控件: 功能包, 语言包
						#>
						$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Text           = "$($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:Init_File_Type_Fod_And_Lang.Count) $($lang.EventManagerCount)"
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

						if ($Script:Init_File_Type_Fod_And_Lang.count -gt 0) {
							ForEach ($item in $Script:Init_File_Type_Fod_And_Lang) {
								$InitLength = $item.Length
								if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

								$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
									Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
									Width     = 645
									Padding   = "25,0,0,0"
									Text      = $item
									add_Click = $UISelectISOClick
								}

								if ($Script:Exclude_Fod_Or_Language.ISO -contains [IO.Path]::GetFileName($item)) {
									$CheckBox.ForeColor = "#008000"
								}

								$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
							}
						} else {
							$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 645
								Padding        = "22,0,0,0"
								Text           = $lang.NoWork
							}
							$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
						}
						$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height       = 30
							Width        = 645
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Add_End_Wrap)

						<#
							.添加控件: InBox Apps
						#>
						$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Text           = "InBox Apps: $($Script:Init_File_Type_InBox_Apps.Count) $($lang.EventManagerCount)"
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

						if ($Script:Init_File_Type_InBox_Apps.count -gt 0) {
							ForEach ($item in $Script:Init_File_Type_InBox_Apps) {
								$InitLength = $item.Length
								if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

								$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
									Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
									Width     = 645
									Padding   = "25,0,0,0"
									Text      = $item
									add_Click = $UISelectISOClick
								}

								if ($Script:Exclude_InBox_Apps.ISO -contains [IO.Path]::GetFileName($item)) {
									$CheckBox.ForeColor = "#008000"
								}

								$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
							}
						} else {
							$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 645
								Padding        = "22,0,0,0"
								Text           = $lang.NoWork
							}
							$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
						}
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							autoSize = 1
							Text     = $lang.RuleNoFindFile
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}

					<#
						.未指定筛选内容, 结束
					#>
				} else {
					$Temp_Match = @()

					<#
						.验证自定义筛选规则
					#>
					<#
						.Judgment: 1. Null value
						.判断: 1. 空值
					#>
					if ([string]::IsNullOrEmpty($UIUnzip_Search_Sift_Custon.Text)) {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 2. The prefix cannot contain spaces
						.判断: 2. 前缀不能带空格
					#>
					if ($UIUnzip_Search_Sift_Custon.Text -match '^\s') {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 3. Suffix cannot contain spaces
						.判断: 3. 后缀不能带空格
					#>
					if ($UIUnzip_Search_Sift_Custon.Text -match '\s$') {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 4. The suffix cannot contain multiple spaces
						.判断: 4. 后缀不能带多空格
					#>
					if ($UIUnzip_Search_Sift_Custon.Text -match '\s{2,}$') {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 5. There can be no two spaces in between
						.判断: 5. 中间不能含有二个空格
					#>
					if ($UIUnzip_Search_Sift_Custon.Text -match '\s{2,}') {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 6. Cannot contain: \\ /: *? "" <> |
						.判断: 6, 不能包含: \\ / : * ? "" < > |
					#>
					if ($UIUnzip_Search_Sift_Custon.Text -match '[~#$@!%&*{}<>?/|+"]') {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.Judgment: 7. No more than 260 characters
						.判断: 7. 不能大于 260 字符
					#>
					if ($UIUnzip_Search_Sift_Custon.Text.length -gt 260) {
						$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzip_Search_Sift_Custon.BackColor = "LightPink"
						return
					}

					<#
						.1. 自定义筛选
					#>
					ForEach ($WildCard in $Script:Init_Folder_All_File) {
						$NewFileName = [IO.Path]::GetFileName($WildCard)

						if ($NewFileName -like "*$($UIUnzip_Search_Sift_Custon.Text)*") {
							$Temp_Match += $WildCard
						}
					}

					$Script:Init_Folder_All_File_Show = $Temp_Match

					<#
						.添加控件: 搜索结果
					#>
					if ($Script:Init_Folder_All_File_Show.count -gt 0) {
						$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Text           = "$($lang.LanguageExtractSearchResult): $($Script:Init_Folder_All_File_Show.Count) $($lang.EventManagerCount)"
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

						ForEach ($item in $Script:Init_Folder_All_File_Show) {
							$InitLength = $item.Length
							if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

							$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
								Width     = 645
								Padding   = "25,0,0,0"
								Text      = $item
								add_Click = $UISelectISOClick
							}

							if ($Script:Known_MSDN.ISO -contains [IO.Path]::GetFileName($item)) {
								$CheckBox.ForeColor = "#008000"
							}

							$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
						}
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							autoSize = 1
							Text     = $lang.RuleNoFindFile
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}
				}
			}

			<#
				.按规则搜索
			#>
			if ($UIUnzip_Search_Rule_Select.Checked) {
				$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 645
				}

				Save_Dynamic -regkey "Solutions\ISO" -name "Is_Unzip_Rule" -value "Select"

				if ($Script:User_Custom_Select_Rule.Count -gt 0) {
				} else {
					$UIUnzipPanelErrorMsg.Text += "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.RuleName) )"
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					return
				}

				$Script:Init_Folder_All_File_Show = $Script:Init_Folder_All_File

				if ($Script:Init_Folder_All_File_Show.count -gt 0) {
					ForEach ($WildCard in $Script:Init_Folder_All_File_Show) {
						$NewFileName = [IO.Path]::GetFileName($WildCard)

						if ($Script:User_Custom_Select_Rule.ISO -contains $NewFileName) {
							if ($UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked) {
								if ([string]::IsNullOrEmpty($UIUnzip_Search_Sift_Custon.Text)) {
									$Script:Init_Folder_All_File_Exclude += $WildCard
								} else {
									if ($NewFileName -like "*$($UIUnzip_Search_Sift_Custon.Text)*") {
										$Script:Init_Folder_All_File_Exclude += $WildCard
									}
								}
							} else {
								$Script:Init_Folder_All_File_Exclude += $WildCard
							}
						}
					}

					$UI_Main_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
						Height        = 40
						Width         = 645
						Text          = "$($lang.ISO_Other): $($Script:Init_Folder_All_File_Exclude.Count) $($lang.EventManagerCount)"
					}
					if ($UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked) {
						$UI_Main_Pre_Rule.Text= "$($lang.LanguageExtractRuleFilter) > $($lang.ISO_Other): $($Script:Init_Folder_All_File_Exclude.Count) $($lang.EventManagerCount)"
					} else {
						$UI_Main_Pre_Rule.Text= "$($lang.ISO_Other): $($Script:Init_Folder_All_File_Exclude.Count) $($lang.EventManagerCount)"
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

					if ($Script:Init_Folder_All_File_Exclude.count -gt 0) {
						$UI_Main_Pre_Rule_EjectCdrom= New-Object system.Windows.Forms.LinkLabel -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.MountCategory
							LinkColor      = "#008000"
							ActiveLinkColor = "#FF0000"
							LinkBehavior   = "NeverUnderline"
							add_Click      = {
								$GetDiskImageCurrent = @()
								Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
									Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
										$GetDiskImageCurrent += $_.ImagePath
									}
								}

								foreach ($WaitEject in $Script:Init_Folder_All_File_Exclude) {
									if ($GetDiskImageCurrent -notcontains $WaitEject) {
										Mount-DiskImage -ImagePath $WaitEject -StorageType ISO
									}
								}

								$UIUnzipPanelErrorMsg.Text = "$($lang.MountCategory), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							}
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_EjectCdrom)

						ForEach ($item in $Script:Init_Folder_All_File_Exclude) {
							$InitLength = $item.Length
							if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

							$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
								Width     = 645
								Padding   = "25,0,0,0"
								Text      = $item
								add_Click = $UISelectISOClick
							}

							if ($Script:Known_MSDN.ISO -contains [IO.Path]::GetFileName($item)) {
								$CheckBox.ForeColor = "#008000"
							}

							$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
						}
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.NoWork
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}
					$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height       = 30
						Width        = 645
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Add_End_Wrap)

					<#
						分类: 功能包, 语言包
					#>
					ForEach ($WildCard in $Script:Init_Folder_All_File_Show) {
						$NewFileName = [IO.Path]::GetFileName($WildCard)

						if ($Script:User_Custom_Select_Rule.Language -contains $NewFileName) {
							if ($UIUnzip_Search_RuleFilter_Apply_Language.Checked) {
								if ([string]::IsNullOrEmpty($UIUnzip_Search_Sift_Custon.Text)) {
									$Script:Init_File_Type_Fod_And_Lang += $WildCard
									$Script:Init_Folder_All_File_Match_Done += $WildCard
								} else {
									if ($NewFileName -like "*$($UIUnzip_Search_Sift_Custon.Text)*") {
										$Script:Init_File_Type_Fod_And_Lang += $WildCard
										$Script:Init_Folder_All_File_Match_Done += $WildCard
									}
								}
							} else {
								$Script:Init_File_Type_Fod_And_Lang += $WildCard
								$Script:Init_Folder_All_File_Match_Done += $WildCard
							}
						}
					}

					<#
						.添加控件: 功能包, 语言包
					#>
					$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
						Height         = 40
						Width          = 645
						Text           = ""
					}
					if ($UIUnzip_Search_RuleFilter_Apply_Language.Checked) {
						$UI_Main_Pre_Rule.Text= "$($lang.LanguageExtractRuleFilter) > $($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:Init_File_Type_Fod_And_Lang.Count) $($lang.EventManagerCount)"
					} else {
						$UI_Main_Pre_Rule.Text= "$($lang.Unzip_Language), $($lang.Unzip_Fod): $($Script:Init_File_Type_Fod_And_Lang.Count) $($lang.EventManagerCount)"
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

					if ($Script:Init_File_Type_Fod_And_Lang.count -gt 0) {
						$UI_Main_Pre_Rule_EjectCdrom= New-Object system.Windows.Forms.LinkLabel -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.MountCategory
							LinkColor      = "#008000"
							ActiveLinkColor = "#FF0000"
							LinkBehavior   = "NeverUnderline"
							add_Click      = {
								$GetDiskImageCurrent = @()
								Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
									Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
										$GetDiskImageCurrent += $_.ImagePath
									}
								}

								foreach ($WaitEject in $Script:Init_File_Type_Fod_And_Lang) {
									if ($GetDiskImageCurrent -notcontains $WaitEject) {
										Mount-DiskImage -ImagePath $WaitEject -StorageType ISO
									}
								}

								$UIUnzipPanelErrorMsg.Text = "$($lang.MountCategory), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							}
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_EjectCdrom)

						ForEach ($item in $Script:Init_File_Type_Fod_And_Lang) {
							$InitLength = $item.Length
							if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

							$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
								Width     = 645
								Padding   = "25,0,0,0"
								Text      = $item
								add_Click = $UISelectISOClick
							}

							if ($Script:Exclude_Fod_Or_Language.ISO -contains [IO.Path]::GetFileName($item)) {
								$CheckBox.ForeColor = "#008000"
							}

							$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
						}
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.NoWork
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}
					$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height       = 30
						Width        = 645
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Add_End_Wrap)

					<#
						.分类: InBox Apps
					#>
					ForEach ($WildCard in $Script:Init_Folder_All_File_Show) {
						$NewFileName = [IO.Path]::GetFileName($WildCard)

						if ($Script:User_Custom_Select_Rule.InboxApps -contains $NewFileName) {
							if ($UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked) {
								if ([string]::IsNullOrEmpty($UIUnzip_Search_Sift_Custon.Text)) {
									$Script:Init_File_Type_InBox_Apps += $WildCard
									$Script:Init_Folder_All_File_Match_Done += $WildCard
								} else {
									if ($NewFileName -like "*$($UIUnzip_Search_Sift_Custon.Text)*") {
										$Script:Init_File_Type_InBox_Apps += $WildCard
										$Script:Init_Folder_All_File_Match_Done += $WildCard
									}
								}
							} else {
								$Script:Init_File_Type_InBox_Apps += $WildCard
								$Script:Init_Folder_All_File_Match_Done += $WildCard
							}
						}
					}

					<#
						.添加控件: InBox Apps
					#>
					$UI_Main_Pre_Rule  = New-Object system.Windows.Forms.Label -Property @{
						Height         = 40
						Width          = 645
						Text           = ""
					}
					if ($UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked) {
						$UI_Main_Pre_Rule.Text= "$($lang.LanguageExtractRuleFilter) > InBox Apps: $($Script:Init_File_Type_InBox_Apps.Count) $($lang.EventManagerCount)"
					} else {
						$UI_Main_Pre_Rule.Text= "InBox Apps: $($Script:Init_File_Type_InBox_Apps.Count) $($lang.EventManagerCount)"
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule)

					if ($Script:Init_File_Type_InBox_Apps.count -gt 0) {
						$UI_Main_Pre_Rule_EjectCdrom= New-Object system.Windows.Forms.LinkLabel -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.MountCategory
							LinkColor      = "#008000"
							ActiveLinkColor = "#FF0000"
							LinkBehavior   = "NeverUnderline"
							add_Click      = {
								$GetDiskImageCurrent = @()
								Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
									Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
										$GetDiskImageCurrent += $_.ImagePath
									}
								}

								foreach ($WaitEject in $Script:Init_File_Type_InBox_Apps) {
									if ($GetDiskImageCurrent -notcontains $WaitEject) {
										Mount-DiskImage -ImagePath $WaitEject -StorageType ISO
									}
								}

								$UIUnzipPanelErrorMsg.Text = "$($lang.MountCategory), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
							}
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_EjectCdrom)

						ForEach ($item in $Script:Init_File_Type_InBox_Apps) {
							$InitLength = $item.Length
							if ($InitLength -lt $InitCharacterLength) { $InitLength = $InitCharacterLength }

							$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
								Height    = $([math]::Ceiling($InitLength / $InitCharacterLength) * $InitControlHeight)
								Width     = 645
								Padding   = "25,0,0,0"
								Text      = $item
								add_Click = $UISelectISOClick
							}

							if ($Script:Exclude_InBox_Apps.ISO -contains [IO.Path]::GetFileName($item)) {
								$CheckBox.ForeColor = "#008000"
							}

							$UIUnzip_Select_Sources.controls.AddRange($CheckBox)
						}
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 645
							Padding        = "22,0,0,0"
							Text           = $lang.NoWork
						}
						$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}

					$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height       = 30
						Width        = 645
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Add_End_Wrap)
				} else {
					$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
						autoSize = 1
						Text     = $lang.RuleNoFindFile
					}
					$UIUnzip_Select_Sources.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
				}
			}

			$UIUnzipPanelErrorMsg.Text = "$($lang.LanguageExtractSearch), $($lang.Done)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		} else {
			$UIUnzipPanel_Menu_Sources_Path.Enabled = $False
			$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($UIUnzipPanel_Menu_Sources_Path.Text)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	$UI_Main_DragOver = [System.Windows.Forms.DragEventHandler]{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			$_.Effect = 'Copy'
		} else {
			$_.Effect = 'None'
		}
	}
	$UI_Main_DragDrop = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
				if (Test-Path -Path $filename -PathType Container) {
					<#
						.已添加的所有项
					#>
					$Queue_In_Add_All_Sources = @()
					$UI_Main_Select_Sources.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							$Queue_In_Add_All_Sources += $_.Name
						}
					}
					$Queue_In_Add_All_Sources += $Global:MainMasterFolder
					$Queue_In_Add_All_Sources = $Queue_In_Add_All_Sources | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

					if ($Queue_In_Add_All_Sources -Contains $filename) {
						$UI_Main_Error.Text = "$($lang.AddTo): $($filename), $($lang.Existed)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					} else {
						if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name 'Sources_Other_Directory' -ErrorAction SilentlyContinue)) {
							Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value "" -Type "MultiString"
						}
						$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name "Sources_Other_Directory" -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

						<#
							.注册表里已保存其它路径
						#>
						$TempSelectAraayOtherRule = @()
						ForEach ($item in $GetExcludeSoftware) {
							$TempSelectAraayOtherRule += $item
						}

						$TempSelectAraayOtherRule += $filename
						Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value $TempSelectAraayOtherRule -Type "MultiString"

						Image_Select_Refresh_Sources_List
						Image_Select_Other_Path_Refresh

						$UI_Main_Error.Text = "$($lang.AddTo): $($filename), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					}
				} else {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SelectFolder)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1072
		Text           = $lang.SelectSettingImage
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		AllowDrop      = $True
		Add_DragOver   = $UI_Main_DragOver
		Add_DragDrop   = $UI_Main_DragDrop
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	<#
		.组: 蒙板: 设置界面
	#>
	$UI_Main_Image_Sources = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}

	<#
		.动态显示映像来源: 磁盘
	#>
	$UI_Main_Select_Sources = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 455
		Width          = 695
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Location       = '0,0'
		Padding        = 15
	}

	<#
		.组: 设置 API
	#>
	$GUIImageSourceGroupAPI = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}

	$GUIImageSourceGroupAPI_Shortcut_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 428
		Text           = $lang.Short_Cmd
		Location       = '15,15'
	}
	$GUIImageSourceGroupAPI_Shortcut_Panel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 515
		Width          = 475
		Location       = '15,45'
		Padding        = "15,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}

	$UI_Main_List_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_List_Select.Items.Add($lang.AllSel).add_Click({
		$GUIImageSourceGroupAPI_Shortcut_Panel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_List_Select.Items.Add($lang.AllClear).add_Click({
		$GUIImageSourceGroupAPI_Shortcut_Panel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIImageSourceGroupAPI_Shortcut_Panel.ContextMenuStrip = $UI_Main_List_Select

	<#
		备份 API
	#>
	$GUIImageSourceGroupAPI_Shortcut_Panel_Backup = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 160
		Location       = '20,590'
		Text           = $lang.Backup
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_API_Backup }
	}

	<#
		还原 API
	#>
	$GUIImageSourceGroupAPI_Shortcut_Panel_Restore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 160
		Location       = '20,630'
		Text           = $lang.Restore
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_API_Restore }
	}

	<#
		从注册表读取保存的命名规则: 刷新
	#>
	$GUIImageSourceGroupAPI_Shortcut_Panel_Refresh = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 160
		Location       = '190,590'
		Text           = $lang.Refresh
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Refresh_Rule_Shortcuts

			$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Refresh), $($lang.Done)"
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.API: 删除已选
	#>
	$GUIImageSourceGroupAPI_Shortcut_Clear_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 160
		Location       = '190,630'
		Text           = "$($lang.Del), $($lang.Choose)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Temp_Save_Select_Path = @()

			$GUIImageSourceGroupAPI_Shortcut_Panel.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						$Temp_Save_Select_Path += $_.Name
					}
				}
			}

			if ($Temp_Save_Select_Path.Count -gt 0) {
				Foreach ($item in $Temp_Save_Select_Path) {
					Remove-Item "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($item)" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
				}

				Refresh_Rule_Shortcuts
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Del), $($lang.Choose), $($lang.Done)"
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			} else {
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Del), $($lang.Failed), $($lang.NoWork)"
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
			}
		}
	}

	$GUIImageSourceGroupAPISetting_Learn = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 160
		Location       = '360,590'
		Text           = $lang.Learn
	}

	$GUIImageSourceGroupAPISettingPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 540
		Width          = 475
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Location       = '575,20'
	}

	$GUIImageSourceGroupAPI_Adv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 428
		Text           = $lang.AdvOption
	}
	$GUIImageSourceGroupAPI_New_No_Import = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Padding        = "25,0,0,0"
		Text           = $lang.RuleNoImport
		add_Click      = {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
		}
	}
	$GUIImageSourceGroupAPI_New_Path_IsCheck = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Padding        = "25,0,0,0"
		Text           = $lang.RuleNewPathISCheck
		Checked        = $True
		add_Click      = {
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
		}
	}

	$GUIImageSourceGroupAPI_Adv_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height       = 20
		Width        = 428
	}

	<#
		.名称
	#>
	$GUIImageSourceGroupAPI_New_Rule_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 428
		Text           = $lang.RuleName
	}
	$GUIImageSourceGroupAPI_Rule_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 420
		margin         = "25,0,0,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
		}
	}

	$GUIImageSourceGroupAPI_Rule_Path_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "22,0,0,0"
		Text           = $lang.RuleNewNameTips -f "6"
	}

	$GUIImageSourceGroupAPI_New_Rule_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height       = 20
		Width        = 428
	}

	<#
		.路径
	#>
	$GUIImageSourceGroupAPI_New_Path_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 428
		Text           = $lang.Select_Path
	}
	$GUIImageSourceGroupAPI_New_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 420
		margin         = "25,0,0,20"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$GUIImageSourceGroupAPI_Rule_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
		}
	}
	$GUIImageSourceGroupAPI_New_Path_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "22,0,0,20"
		Text           = "$($lang.RuleNameFormat): $($Global:Support_PS_Filename)"
	}

	$UI_Main_API_DragOver = [System.Windows.Forms.DragEventHandler]{
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			$_.Effect = 'Copy'
		} else {
			$_.Effect = 'None'
		}
	}
	$UI_Main_API_DragDrop = {
		$GUIImageSourceGroupAPIErrorMsg.Text = ""
		$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
				$types = [IO.Path]::GetExtension($filename)
				if ($Global:Support_PS_Filename -contains $types) {
					$GUIImageSourceGroupAPI_New_Path.Text = $filename

					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Choose): $($filename), $($lang.Done)"
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelectFromError): $($lang.PleaseChoose) ( $($Global:Support_PS_Filename) )"
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	$GUIImageSourceGroupAPI_New_Path_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 428
		Padding        = "22,0,0,0"
		Text           = $lang.SelFile
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupAPI_New_Path.BackColor = "#FFFFFF"
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "PowerShell Files (*.ps1;*.psd1;*.psm1;)|*.ps1;*.psd1;*.psm1;"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$GUIImageSourceGroupAPI_New_Path.Text = $FileBrowser.FileName

				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.SelFile), $($lang.Done)"
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			} else {
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupAPIErrorMsg.Text = $lang.UserCancel
			}
		}
	}

	$GUIImageSourceGroupAPI_New_Path_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "41,0,0,20"
		Text           = $lang.DropFile
	}

	$GUIImageSourceGroupAPI_New_Path_OpenFile = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 428
		margin         = "22,5,0,0"
		Text           = $lang.OpenFile
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupAPI_New_Path.Text)) {
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $GUIImageSourceGroupAPI_New_Path.Text -PathType Leaf) {
					Start-Process -FilePath $GUIImageSourceGroupAPI_New_Path.Text

					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile): $($UI_Main_Save_To.Text), $($lang.Done)"
				} else {
					$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.OpenFile): $($UI_Main_Save_To.Text), $($lang.Inoperable)"
				}
			}
		}
	}

	$GUIImageSourceGroupAPI_New_Path_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 428
		Padding        = "20,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupAPIErrorMsg.Text = ""
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupAPI_New_Path.Text)) {
				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
				$GUIImageSourceGroupAPI_New_Path.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $GUIImageSourceGroupAPI_New_Path.Text

				$GUIImageSourceGroupAPIErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupAPIErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	$GUIImageSourceGroupAPIErrorMsg_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "575,583"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$GUIImageSourceGroupAPIErrorMsg = New-Object System.Windows.Forms.Label -Property @{
		Location       = "600,585"
		Height         = 40
		Width          = 443
		Text           = ""
	}

	<#
		.API: 修改
	#>
	$GUIImageSourceGroupAPI_Change_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "575,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Edit.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = { Solutions_API_Add_New_Rule_Name -IsForce }
	}
	$GUIImageSourceGroupAPI_Change = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 125
		Location       = "601,638"
		Text           = $lang.Change
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_API_Add_New_Rule_Name -IsForce }
	}

	<#
		.API: 添加
	#>
	$GUIImageSourceGroupAPI_Add_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "733,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Add.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = { Solutions_API_Add_New_Rule_Name }
	}
	$GUIImageSourceGroupAPI_Add = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 125
		Location       = "759,638"
		Text           = $lang.AddTo
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_API_Add_New_Rule_Name }
	}

	$GUIImageSourceGroupAPI_Hide_Click = {
		if ($Page) {
			$UI_Main.Close()
		} else {
			$UI_Main.Text = $lang.Setting
			$GUIImageSourceGroupAPIErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupAPIErrorMsg.Text = ""

			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $True          # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_API_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)
		}
	}
	$GUIImageSourceGroupAPI_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "890,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceGroupAPI_Hide_Click
	}
	$GUIImageSourceGroupAPI_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 125
		Location       = "916,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIImageSourceGroupAPI_Hide_Click
	}

	<#
		.组: 设置界面
	#>
	$GUIImageSourceGroupSetting = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}

	$GUIImageSourceSettingGroupAll = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 675
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "0,10,0,0"
		Location       = '20,0'
	}

	<#
		.语言, 更改, 显示当前首选语言
	#>
	$GUIImageSourceSettingLP = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 478
		Margin         = "0,10,0,0"
		Text           = $lang.Language
	}

	$GUIImageSourceSettingLP_Change = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = "English (United States)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Language -Reset
			Image_Select
			$UI_Main.Close()
		}
	}

	$GUIImageSourceSettingUP = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 478
		margin         = "0,30,0,0"
		Text           = $lang.ChkUpdate
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Update
			$UI_Main.Close()

			Modules_Refresh -Function "Image_Select"
		}
	}
	$GUIImageSourceSettingUPCurrentVersion = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = "$($lang.UpdateCurrent): $((Get-Module -Name Solutions).Version.ToString())"
	}

	$GUIImageSourceSettingUP_Auto = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Padding        = "20,0,0,0"
		Text           = $lang.Auto_Update_Allow
		Checked        = $True
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupSettingErrorMsg.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdate" -value "True"
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Auto_Update_Allow), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdate" -value "False"
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $False
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Auto_Update_Allow), $($lang.Disable), $($lang.Done)"
			}
		}
	}

	$GUIImageSourceSettingUP_Auto_Adv = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 140
		Width          = 475
		autoSizeMode   = 1
	}
	$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting = New-Object system.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 45
		Location       = '38,5'
		Minimum        = 1
		Maximum        = 365
		Value          = 6
		add_ValueChanged = {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupSettingErrorMsg.Text = ""

			Save_Dynamic -regkey "Solutions\Update" -name "AutoCheckUpdate_Hours" -value $This.Value
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Setting): $($This.Value) $($lang.Auto_Check_Time), $($lang.Done)"
		}
	}

	$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Time = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 420
		Location       = '95,8'
		Text           = $lang.Auto_Check_Time
	}

	$GUIImageSourceSettingUP_Auto_Update_New_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Location       = '35,55'
		Text           = $lang.Auto_Update_New_Allow
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupSettingErrorMsg.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdateNew" -value "True"
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Auto_Update_New_Allow), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdateNew" -value "False"
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Auto_Update_New_Allow), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	$GUIImageSourceSettingUP_Auto_Update_Clean = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Location       = '35,95'
		Text           = $lang.UpdateClean
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupSettingErrorMsg.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\Update" -name "IsUpdate_Clean_Allow" -value "True"
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.UpdateClean), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions\Update" -name "IsUpdate_Clean_Allow" -value "False"
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.UpdateClean), $($lang.Disable), $($lang.Done)"
			}
		}
	}

	<#
		.Developer Mode
		.开发者模式
	#>
	$GUIImageSourceSettingDev = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 478
		Margin         = "0,30,0,0"
		Text           = $lang.Developers_Mode
	}

	<#
		.Allows you to always use developer mode
		.允许一直使用开发者模式
	#>
	$GUIImageSourceSettingIsAllowDevMode = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.IsAllowDevMode
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsAllowDevMode" -value "True"
				$Global:Developers_Mode = $True

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.IsAllowDevMode), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsAllowDevMode" -value "False"
				$Global:Developers_Mode = $False

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.IsAllowDevMode), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAllowDevMode" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAllowDevMode" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceSettingIsAllowDevMode.Checked = $True }
			"False" { $GUIImageSourceSettingIsAllowDevMode.Checked = $False }
		}
	} else {
		Save_Dynamic -regkey "Solutions" -name "IsAllowDevMode" -value "False"
		$GUIImageSourceSettingIsAllowDevMode.Checked = $False
	}

	$GUIImageSourceSettingAPI = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 475
		Margin         = "0,30,0,0"
		Text           = $lang.API
	}

	$GUIImageSourceSettingAPI_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.Setting
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Text = $lang.API
			Refresh_Rule_Shortcuts

			$GUIImageSourceGroupAPI.visible = $True              # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			<#
				.添加托动和事件
			#>
			$UI_Main.Add_DragOver($UI_Main_API_DragOver)
			$UI_Main.Add_DragDrop($UI_Main_API_DragDrop)
		}
	}

	$GUIImageSourceSettingAPI_Learn = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.Learn
	}

	<#
		.可选功能
	#>
	$GUIImageSourceSettingAdv = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 478
		Margin         = "0,30,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.事件: 添加到系统变量
	#>
	$GUIImageSourceSettingEnv = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.AddEnv
		add_Click      = {
			$Current_Folder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Router" -ErrorAction SilentlyContinue
			$GetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue

			if ($This.Checked) {
				<#
					.添加模式
				#>
				$windows_path = $GetVarPath -split ';'
				if ($windows_path -Contains $Current_Folder) {
					System_Env_Test_Order

					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AddEnv), $($lang.Existed)"
				} else {
					$GetVarPath = "$($GetVarPath);$($Current_Folder)"
					Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $GetVarPath
					System_Env_Test_Order

					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AddEnv), $($lang.AddTo), $($lang.Done)"
				}
			} else {
				<#
					.删除模式
				#>
				$GetVarPath = ($GetVarPath.Split(';') | Where-Object { $_ -ne $Current_Folder }) -join ';'
				$GetVarPath = $GetVarPath.TrimEnd(';')
				Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $GetVarPath
				$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
				[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AddEnv), $($lang.Del), $($lang.Done)"
			}
		}
	}

	<#
		.Added to system variables
		.添加到系统变量
	#>
	if (Test-path -path "$($PSScriptRoot)\..\..\..\..\Router\Yi.ps1" -PathType Leaf) {
		$GUIImageSourceSettingEnv.Enabled = $True

		$Current_Folder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Router" -ErrorAction SilentlyContinue
		$GetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue
		$windows_path = $GetVarPath -split ';'

		if ($windows_path -Contains $Current_Folder) {
			$GUIImageSourceSettingEnv.Checked = $True
		} else {
			$GUIImageSourceSettingEnv.Checked = $False
		}
	} else {
		$GUIImageSourceSettingEnv.Enabled = $False
	}

	$GUIImageSourceSettingEnvTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "34,5,20,20"
		Text           = $lang.AddEnvTips
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	$GUIImageSourceSettingTopMost = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.AllowTopMost
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "TopMost" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AllowTopMost), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "TopMost" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.AllowTopMost), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceSettingTopMost.Checked = $True }
		}
	}

	<#
		.Clean up the logs 7 days ago
		.清理 7 天前的日志
	#>
	$GUIImageSourceSettingClearHistoryLog = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.HistoryLog
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsLogsClear" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.HistoryLog), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsLogsClear" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.HistoryLog), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsLogsClear" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsLogsClear" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceSettingClearHistoryLog.Checked = $True }
		}
	} else {
		Save_Dynamic -regkey "Solutions" -name "IsLogsClear" -value "True"
		$GUIImageSourceSettingClearHistoryLog.Checked = $True
	}

	<#
		.显示命令行
	#>
	$UI_Main_Adv_Cmd   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.ShowCommand
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "ShowCommand" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.UI_Main_Adv_Cmd), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "ShowCommand" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.UI_Main_Adv_Cmd), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "ShowCommand" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "ShowCommand" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main_Adv_Cmd.Checked = $True }
		}
	} else {
		Save_Dynamic -regkey "Solutions" -name "ShowCommand" -value "True"
		$UI_Main_Adv_Cmd.Checked = $True
	}

	<#
		.允许显示选择主键菜单
	#>
	$UI_Main_Adv_Sel_ImageSources_Show_Key = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.ImageSourcesClickShowKey
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsShowSelectKey" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.ImageSourcesClickShowKey), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsShowSelectKey" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.ImageSourcesClickShowKey), $($lang.Disable), $($lang.Done)"
			}

			Image_Select_Refresh_Sources_List
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsShowSelectKey" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main_Adv_Sel_ImageSources_Show_Key.Checked = $True }
		}
	} else {
		Save_Dynamic -regkey "Solutions" -name "IsShowSelectKey" -value "True"
		$UI_Main_Adv_Sel_ImageSources_Show_Key.Checked = $True
	}

	$UI_Main_Adv_Sel_ImageSources_Show_Key_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "34,5,20,20"
		Text           = $lang.ImageSourcesClickShowKeyTips
	}

	<#
		.Do not check Boot.wim file size ≥ 520MB
		.不再检查 Boot.wim 文件大小 ≥ 520MB
	#>
	$GUIImageSourceSettingBootSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.DoNotCheckBoot
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "DoNotCheckBootSize" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DoNotCheckBoot), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "DoNotCheckBootSize" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DoNotCheckBoot), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceSettingBootSize.Checked = $True }
		}
	}

	<#
		.修复
	#>
	$GUIImageSourceSettingRepair = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 478
		Margin         = "0,40,0,0"
		Text           = $lang.Repair
	}

	<#
		.空闲时自动修复
	#>
	$GUIImageSourceSetting_Is_Auto_Repair = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.IsAuto_Repair
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsAuto_Repair" -value "True"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.IsAuto_Repair), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsAuto_Repair" -value "False"

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.IsAuto_Repair), $($lang.Disable), $($lang.Done)"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAuto_Repair" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsAuto_Repair" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceSetting_Is_Auto_Repair.Checked = $True }
			"False" { $GUIImageSourceSetting_Is_Auto_Repair.Checked = $False }
		}
	} else {
		$GUIImageSourceSetting_Is_Auto_Repair.Checked = $True
		Save_Dynamic -regkey "Solutions" -name "IsAuto_Repair" -value "True"
	}

	$GUIImageSourceSetting_Is_Auto_Repair_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "35,5,20,35"
		Text           = $lang.IsAuto_Repair_Tips
	}

	$GUIImageSourceSettingClearHistory = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.History
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click     = {
			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
			Image_Select_Refresh_Sources_List

			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.History), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIImageSourceSettingClearAppxStage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.HistoryClearappxStage
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click     = {
			Remove-Item -Path "$($env:TEMP)\appxStage-*" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
			Image_Select_Refresh_Sources_List

			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.HistoryClearappxStage), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIImageSourceSettingHistoryDism = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.HistoryClearDismSave
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click     = {
			Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
			Image_Select_Refresh_Sources_List

			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.HistoryClearDismSave), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIImageSourceSettingHistoryBadMount = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = $lang.Clear_Bad_Mount
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click     = {
			dism /cleanup-wim | Out-Null
			Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Clear_Bad_Mount), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIImageSourceSettingRepairTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "20,0,0,35"
		Text           = $lang.History_Del_Tips
	}

	<#
		.磁盘缓存
	#>
	$GUIImageSourceISOCache = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 478
		Margin         = "0,40,0,0"
		Text           = $lang.CacheDisk
	}
	$GUIImageSourceSettingRAMDISK = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 460
		Margin         = "17,0,0,0"
		Text           = $lang.AutoSelectRAMDISK
		add_Click      = { Image_Select_Refresh_Sources_Setting }
	}
	$GUIImageSourceSetting_RAMDISK_Volume_Label = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 428
		Margin         = "31,5,0,30"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		}
	}
	$GUIImageSource_Setting_RAMDISK_Change = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "27,0,0,0"
		Text           = $lang.RAMDISK_Change
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {

			<#
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断: 1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIImageSourceSetting_RAMDISK_Volume_Label.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断: 2. 前缀不能带空格
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text -match '^\s') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 3. Suffix cannot contain spaces
				.判断: 3. 后缀不能带空格
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text -match '\s$') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 4. The suffix cannot contain multiple spaces
				.判断: 4. 后缀不能带多空格
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text -match '\s{2,}$') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 5. There can be no two spaces in between
				.判断: 5. 中间不能含有二个空格
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text -match '\s{2,}') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 6. Cannot contain: \\ /: *? "" <> |
				.判断: 6, 不能包含: \\ / : * ? "" < > |
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 7. No more than 260 characters
				.判断: 7. 不能大于 32 字符
			#>
			if ($GUIImageSourceSetting_RAMDISK_Volume_Label.Text.length -gt 32) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "32")"
				$GUIImageSourceSetting_RAMDISK_Volume_Label.BackColor = "LightPink"
				return
			}

			<#
				.验证自定义 ISO 默认保存到目录名, 结束并保存新路径
			#>
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Volume_Label" -value $GUIImageSourceSetting_RAMDISK_Volume_Label.Text
			$GUIImageSourceSettingRAMDISK.Text = "$($lang.AutoSelectRAMDISK): $($GUIImageSourceSetting_RAMDISK_Volume_Label.Text)"
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.RAMDISK_Change) ( $($lang.Done) )"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.事件: 恢复初始化 RAMDISK 卷标
	#>
	$GUIImageSource_Setting_RAMDISK_Restore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "27,0,0,0"
		Text           = $lang.RAMDISK_Restore -f $Global:Init_RAMDISK_Volume_Label
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Volume_Label" -value $Global:Init_RAMDISK_Volume_Label
			$GUIImageSourceSettingRAMDISK.Text = "$($lang.AutoSelectRAMDISK): $($Global:Init_RAMDISK_Volume_Label)"
			$GUIImageSourceSetting_RAMDISK_Volume_Label.Text = $Global:Init_RAMDISK_Volume_Label
			$GUIImageSourceGroupSettingErrorMsg.Text = $lang.RAMDISK_Restore -f $Global:Init_RAMDISK_Volume_Label
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.允许自动开启快速抛弃方式
	#>
	$GUIImageSource_Setting_Abandon_Allow_Auto = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 475
		Padding        = "30,0,0,0"
		Text           = $lang.Abandon_Allow_Auto
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "Abandon_Allow_Auto" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "Abandon_Allow_Auto" -value "False"
			}
		}
	}

	<#
		.允许自动开启快速抛弃方式: 协议
	#>
	$GUIImageSource_Setting_Abandon_Agreement = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 475
		Padding        = "45,0,0,0"
		Text           = $lang.Abandon_Agreement
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Eject_Abandon_Agreement }
	}

	$GUIImageSource_Setting_Abandon_Allow_Auto_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "49,5,20,40"
		Text           = $lang.Abandon_Allow_Auto_Tips
	}

	<#
		.Windows Defender 排除项: RAMDISK
	#>
	$GUIImageSource_Setting_RAMDISK_Exclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 475
		Padding        = "30,0,0,0"
		Text           = $lang.DefenderExclude
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Exclude" -value "True"
				Exclude_Add_Ramdisk
			} else {
				Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Exclude" -value "False"

				<#
					.获取 RAMDISK 卷标名
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
					<#
						.从注册表获取卷标名
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue) {
						$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Volume_Label" -ErrorAction SilentlyContinue

						$GetRAMDISK = @()
						Get-CimInstance -ClassName Win32_Volume -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_.DriveLetter) -or [string]::IsNullOrWhiteSpace($_.DriveLetter))} | ForEach-Object {
							if ($_.Label -eq $CustomRAMDISKLabel) {
								$GetRAMDISK += (Join_MainFolder -Path $_.DriveLetter)
							}
						}

						if ($GetRAMDISK.count -gt 0) {
							$isExclude = @()
							try {
								$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
								foreach ($exclusion in $extensionExclusion.ExclusionPath) {
									if ($exclusion -contains $GetRAMDISK) {
										$isExclude += $exclusion
									}
								}
							} catch {
								Save_Dynamic -regkey "Solutions\RAMDisk" -name "RAMDisk_Exclude" -value "False"
								$GUIImageSource_Setting_RAMDISK_Exclude.Enabled = $False
							}

							$WaitAddExclude = @()
							if ($isExclude.Count -gt 0) {
								foreach ($item in $GetRAMDISK) {
									if ($item -Contains $isExclude) {
										$WaitAddExclude += $item
									}
								}
							} else {
								foreach ($AddRAMDISK in $GetRAMDISK) {
									$WaitAddExclude += $AddRAMDISK
								}
							}

							if ($WaitAddExclude.Count -gt 0) {
								foreach ($item in $WaitAddExclude) {
									Remove-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
								}

								$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.Done)"
							} else {
								$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.NoWork)"
							}
						} else {
							$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
						}
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed), $($lang.SelectFromError)"
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
				}
			}

			Image_Select_Refresh_Disk_Local
		}
	}

	$GUIImageSource_Setting_RAMDISK_ExcludeTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "49,5,20,40"
		Text           = $lang.DefenderVolume
	}

	<#
		.事件: 自定义缓存路径
	#>
	$GUIImageSourceISOCacheCustomizeName = New-Object system.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 460
		Margin         = "16,0,0,0"
		Text           = $lang.CacheDiskCustomize
		add_Click      = {
			if ($This.Checked) {
				$GUIImageSourceISOCacheCustomize.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "False"
				$GUIImageSourceISOCacheCustomize.Enabled = $False
			}
		}
	}
	$GUIImageSourceISOCacheCustomize = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "0,0,8,0"
	}
	$GUIImageSourceISOCacheCustomizePath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 428
		Margin         = "30,5,0,25"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		}
	}

	<#
		.事件: 自定义缓存路径, 选择目录
	#>
	$GUIImageSourceISOCacheCustomizePathSelect = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "26,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$GUIImageSourceISOCacheCustomizePath.Text = $FolderBrowser.SelectedPath

					if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
						Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "True"
						Save_Dynamic -regkey "Solutions" -name "DiskCache" -value $FolderBrowser.SelectedPath

						if ($GUIImageSource_Setting_Custom_Exclude.Checked) {
							Exclude_Add_Custom
						}

						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.CacheDiskCustomize): $($lang.Setting), $($lang.Done)"
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.FailedCreateFolder)"
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg.Text = $lang.FailedCreateFolder
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			} else {
				$GUIImageSourceGroupSettingErrorMsg.Text = $lang.UserCancel
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	<#
		.事件: 磁盘缓存, 打开目录
	#>
	$GUIImageSourceISOCacheCustomizePathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "26,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCacheCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $GUIImageSourceISOCacheCustomizePath.Text -PathType Container) {
					Start-Process $GUIImageSourceISOCacheCustomizePath.Text

					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder): $($GUIImageSourceISOCacheCustomizePath.Text), $($lang.Done)"
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder): $($GUIImageSourceISOCacheCustomizePath.Text), $($lang.Inoperable)"
				}
			}
		}
	}

	<#
		.事件: 磁盘缓存, 复制路径
	#>
	$GUIImageSourceISOCacheCustomizePathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "26,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCacheCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $GUIImageSourceISOCacheCustomizePath.Text

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.Windows Defender 排除项: 自定义目录
	#>
	$GUIImageSource_Setting_Custom_Exclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "26,0,0,0"
		Text           = $lang.DefenderExclude
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "Custom_Exclude" -value "True"
				Exclude_Add_Custom
			} else {
				Save_Dynamic -regkey "Solutions" -name "Custom_Exclude" -value "False"

				<#
					.获取自定义目录
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue) {
					<#
						.从注册表获取卷标名
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue) {
						$CustomRAMDISKLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskCache" -ErrorAction SilentlyContinue

						$GetCustomPath = @()
						foreach ($item in $CustomRAMDISKLabel) {
							$GetCustomPath += $item
						}

						if ($GetCustomPath.count -gt 0) {
							$isExclude = @()
							try {
								$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
								foreach ($exclusion in $extensionExclusion.ExclusionPath) {
									if ($exclusion -contains $GetCustomPath) {
										$isExclude += $exclusion
									}
								}
							} catch {
								Save_Dynamic -regkey "Solutions" -name "Custom_Exclude" -value "False"
								$GUIImageSource_Setting_Custom_Exclude.Enabled = $False
							}

							$WaitAddExclude = @()
							if ($isExclude.Count -gt 0) {
								foreach ($item in $GetCustomPath) {
									if ($item -Contains $isExclude) {
										$WaitAddExclude += $item
									}
								}
							} else {
								foreach ($AddRAMDISK in $GetCustomPath) {
									$WaitAddExclude += $AddRAMDISK
								}
							}

							if ($WaitAddExclude.Count -gt 0) {
								foreach ($item in $WaitAddExclude) {
									Remove-MpPreference -ExclusionPath $item -ErrorAction SilentlyContinue | Out-Null
								}

								$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.Done)"
							} else {
								$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
								$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.NoWork)"
							}
						} else {
							$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
							$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed): $($CustomRAMDISKLabel)"
						}
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.AutoSelectRAMDISKFailed), $($lang.SelectFromError)"
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
				}
			}

			Image_Select_Refresh_Disk_Local
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSource_Setting_Custom_Exclude.Checked = $True }
			"False" { $GUIImageSource_Setting_Custom_Exclude.Checked = $False }
		}
	} else {
		Save_Dynamic -regkey "Solutions" -name "Custom_Exclude" -value "False"
		$GUIImageSource_Setting_Custom_Exclude.Checked = $False
	}

	$GUIImageSource_Setting_Custom_ExcludeTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "45,5,20,40"
		Text           = $lang.DefenderFolder
	}

	<#
		.ISO: 保存位置
	#>
	$GUIImageSourceISOSaveTo = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 475
		Margin         = "0,40,0,0"
		Text           = $lang.ISOSaveTo
	}
	$GUIImageSourceISOCustomizePath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 445
		Margin         = "18,0,0,25"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		}
	}

	<#
		.事件: ISO 默认保存位置, 选择目录
	#>
	$GUIImageSourceISOCustomizePathSelect = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$GUIImageSourceISOCustomizePath.Text = $FolderBrowser.SelectedPath
					Save_Dynamic -regkey "Solutions" -name "ISOTo" -value $FolderBrowser.SelectedPath
				} else {
					$GUIImageSourceGroupSettingErrorMsg.Text = $lang.FailedCreateFolder
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			} else {
				$GUIImageSourceGroupSettingErrorMsg.Text = $lang.UserCanel
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	<#
		.事件: ISO 默认保存位置, 打开目录
	#>
	$GUIImageSourceISOCustomizePathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $GUIImageSourceISOCustomizePath.Text -PathType Container) {
					Start-Process $GUIImageSourceISOCustomizePath.Text

					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder): $($GUIImageSourceISOCustomizePath.Text), $($lang.Done)"
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFolder): $($GUIImageSourceISOCustomizePath.Text), $($lang.Inoperable)"
				}
			}
		}
	}

	<#
		.事件: ISO 默认保存位置, 复制路径
	#>
	$GUIImageSourceISOCustomizePathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingErrorMsg.Text = ""
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $GUIImageSourceISOCustomizePath.Text

				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.事件: 恢复为映像源搜索盘同一位置
	#>
	$GUIImageSourceISOCustomizePathRestore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 475
		Padding        = "14,0,0,0"
		Text           = $lang.ISOSaveSame
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIImageSourceGroupSettingDisk.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$GUIImageSourceISOCustomizePath.Text = $_.Tag
						}
					}
				}
			}

			Save_Dynamic -regkey "Solutions" -name "ISOTo" -value $Global:MainMasterFolder

			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.ISOSaveSame), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.事件: ISO 默认保存位置, 同步新位置
	#>
	$GUIImageSourceISOSync = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 450
		Margin         = "22,15,0,0"
		Text           = $lang.ISOSaveSync
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsSearchSyncPath" -value "True"

				$GUIImageSourceGroupSettingDisk.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.RadioButton]) {
						if ($_.Enabled) {
							if ($_.Checked) {
								$GUIImageSourceISOCustomizePath.Text = $_.Tag
							}
						}
					}
				}
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsSearchSyncPath" -value "False"
			}
		}
	}

	<#
		.事件: ISO 默认保存位置, 验证目录是否可读写
	#>
	$GUIImageSourceISOWrite = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 450
		Margin         = "22,0,0,0"
		Text           = $lang.ISOFolderWrite
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsCheckWrite" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsCheckWrite" -value "False"
			}
		}
	}

	<#
		.事件: ISO 默认保存位置, 验证目录名称
	#>
	$GUIImageSourceISOSaveToCheckISO9660 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 450
		Margin         = "22,0,0,0"
		Text           = $lang.ISO9660
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsCheckISOToFolderName" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsCheckISOToFolderName" -value "False"
			}
		}
	}
	$GUIImageSourceISOSaveToCheckISO9660Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "36,0,0,35"
		Text           = $lang.ISO9660Tips
	}

	<#
		.建议的项目
	#>
	$GUIImageSourceSettingSuggested = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 475
		Margin         = "0,35,0,8"
		Text           = $lang.SuggestedAllow
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsSuggested" -value "True"
				$GUIImageSourceSettingSuggestedPanel.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsSuggested" -value "False"
				$GUIImageSourceSettingSuggestedPanel.Enabled = $False
			}
		}
	}
	$GUIImageSourceSettingSuggestedPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $True
	}

	<#
		.生成解决方案
	#>
	$GUIImageSourceSettingSuggestedSoltions = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 465
		Padding        = "12,0,0,0"
		Text           = "$($lang.Solution): $($lang.IsCreate)"
		Tag            = "Solutions_Create_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 语言
	#>
	$GUIImageSourceSettingSuggestedLang = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.Language
	}
	$GUIImageSourceSettingSuggestedLangAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.AddTo
		Tag            = "Language_Add_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedLangDel = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Del
		Tag            = "Language_Delete_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedLangChange = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.SwitchLanguage
		Tag            = "Language_Change_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedLangClean = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.OnlyLangCleanup
		Tag            = "Language_Cleanup_Components_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, InBox Apps
	#>
	$UI_Suggested_InBox_Apps = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Text           = $lang.InboxAppsManager
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
	}
	$UI_Suggested_InBox_AppsOne = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.AddTo)"
		Tag            = "LXPs_Region_Add"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$UI_Suggested_InBox_AppsTwo = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = "$($lang.InboxAppsManager): $($lang.AddTo)"
		Tag            = "InBox_Apps_Add_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$UI_Suggested_InBox_AppsThere = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = "$($lang.LocalExperiencePack) ( LXPs ): $($lang.Update)"
		Tag            = "LXPs_Update_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$UI_Suggested_InBox_AppsDelete = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.InboxAppsMatchDel
		Tag            = "InBox_Apps_Match_Delete_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 累积更新
	#>
	$GUIImageSourceSettingSuggestedUpdate = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.CUpdate
	}
	$GUIImageSourceSettingSuggestedUpdateAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.AddTo
		Tag            = "Cumulative_updates_Add_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedUpdateDel = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Del
		Tag            = "Cumulative_updates_Delete_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 驱动
	#>
	$GUIImageSourceSettingSuggestedDrive = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.Drive
	}
	$GUIImageSourceSettingSuggestedDriveAdd = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.AddTo
		Tag            = "Drive_Add_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedDriveDel = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Del
		Tag            = "Drive_Delete_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, Windows 功能
	#>
	$GUIImageSourceSettingSuggestedWinFeature = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.WindowsFeature
	}
	$GUIImageSourceSettingSuggestedWinFeatureEnabled = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Enable
		Tag            = "Feature_Enabled_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedWinFeatureDisable = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Disable
		Tag            = "Feature_Disable_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 运行 PowerShell 函数
	#>
	$GUIImage_Special_Function = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.SpecialFunction
	}
	$GUIImage_Functions_Before = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Functions_Before
		Tag            = "Functions_Before_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImage_Functions_Rear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Functions_Rear
		Tag            = "Functions_Rear_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 运行 API
	#>
	$GUIImage_API_Function = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 468
		Padding        = "16,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.API
	}
	$GUIImage_API_Before = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Functions_Before
		Tag            = "API_Before_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImage_API_Rear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.Functions_Rear
		Tag            = "API_Rear_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	<#
		.组, 无挂载时可用事件
	#>
	$GUIImageSourceSettingSuggestedNeedMount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 452
		margin         = "16,25,0,0"
		Text           = $lang.AssignNoMount
	}

	<#
		.附加版
	#>
	$GUIImageSourceSettingSuggestedAdditionalEdition = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.AdditionalEdition
		Tag            = "Additional_Edition_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	$GUIImageSourceSettingSuggestedConvert = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = "$($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)"
		Tag            = "Image_Convert_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}
	$GUIImageSourceSettingSuggestedISO = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = $lang.UnpackISO
		Tag            = "ISO_Create_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Event_Assign -Rule $This.Tag
			Event_Assign_Setting -Setting -RuleName $This.Tag
		}
	}

	$GUIImageSourceSettingSuggestedISO_Associated = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 465
		Padding        = "26,0,0,0"
		Text           = "$($lang.ISO_Associated_Schemes), $($lang.Setting): $($lang.CreateASCAuthor)"
		Tag            = "ISO_Create_UI"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			ISO_Associated_UI
		}
	}

	<#
		.重置所有建议
	#>
	$GUIImageSourceSettingSuggestedReset = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 445
		Padding        = "14,0,0,0"
		margin         = "0,20,0,0"
		Text           = $lang.SuggestedReset
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Suggested" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SuggestedReset), $($lang.Done)"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.设置搜索映像来源
	#>
	$GUIImageSourceGroupSettingPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 540
		Width          = 475
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Location       = '575,15'
	}
	$GUIImageSourceGroupSettingDiskTips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.SearchImageSource
	}

	<#
		.新目录结构
	#>
	$GUIImageSourceGroupSettingStructure = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = $lang.ISOStructure
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsFolderStructure" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsFolderStructure" -value "False"
			}

			Image_Select_Refresh_Disk_Local
		}
	}
	$GUIImageSourceGroupSettingCustomizeShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 390
		margin         = "34,5,0,0"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			if (RefreshNewPath) {
				Image_Select_Refresh_Disk_Local
			}
		}
	}
	$GUIImageSourceGroupSettingCustomizeTips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 80
		Width          = 420
		Text           = $lang.ISO9660Tips
		margin         = "34,15,0,0"
	}

	<#
		.Windows Defender 排除项: 映像来源
	#>
	$GUIImageSourceGroupSettingDefenderAdd = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = $lang.DefenderExclude
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions" -name "IsDefenderExclude" -value "True"
				Exclude_Add_DiskTo
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsDefenderExclude" -value "False"

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
					$isExclude = $False
					$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue

					try {
						$extensionExclusion = Get-MpPreference -ErrorAction SilentlyContinue | Select-Object -Property ExclusionPath
						foreach ($exclusion in $extensionExclusion.ExclusionPath) {
							if ($exclusion -eq $GetDiskTo) {
								$isExclude = $True
							}
						}
					} catch {
						Save_Dynamic -regkey "Solutions" -name "IsDefenderExclude" -value "False"
						$GUIImageSourceGroupSettingDefenderAdd.enabled = $False
					}

					if ($isExclude) {
						Remove-MpPreference -ExclusionPath $GetDiskTo -ErrorAction SilentlyContinue | Out-Null
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.Done)"
					} else {
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.Del), $($lang.NoWork)"
					}
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.DefenderExclude): $($lang.UpdateUnavailable)"
				}
			}

			Image_Select_Refresh_Disk_Local
		}
	}

	$GUIImageSourceGroupSettingDefenderAddTips = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = $True
		Text           = $lang.DefenderFolder
		margin         = "34,0,0,35"
	}

	<#
		.自动选择可用磁盘时
	#>
	$GUIImageSourceGroupSettingSelectDISK = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.SelectAutoAvailable
	}

	<#
		.Event: Check the minimum free disk space
		.事件: 检查最低可用磁盘剩余空间
	#>
	$GUIImageSourceGroupSettingSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = $lang.SelectCheckAvailable
		Checked        = $True
		add_Click      = {
			if ($This.Checked) {
				$GUIImageSourceGroupSettingLowSize.Enabled = $True
				Save_Dynamic -regkey "Solutions" -name "IsCheckLowDiskSize" -value "True"
				$GUIImageSourceGroupSettingLowSize
			} else {
				$GUIImageSourceGroupSettingLowSize.Enabled = $False
				Save_Dynamic -regkey "Solutions" -name "IsCheckLowDiskSize" -value "False"
			}

			Image_Select_Refresh_Disk_Local
		}
	}
	$GUIImageSourceGroupSettingSizeChange = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 60
		Width          = 450
	}
	$GUIImageSourceGroupSettingLowSize = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "34,2"
		Value          = 1
		Minimum        = 1
		Maximum        = 999999
		TextAlign      = 1
		add_Click      = { Image_Select_Refresh_Disk_Local }
	}
	$GUIImageSourceGroupSettingLowUnit = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 80
		Text           = "GB"
		Location       = "106,6"
	}

	$GUIImageSourceGroupSettingDiskSelect = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.ChangeInstallDisk
		Location       = '606,235'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Image_Select_Refresh_Disk_Local }
	}
	$GUIImageSourceGroupSettingDisk = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 485
		Width          = 450
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,8,8,8"
	}

	<#
		.其它映像源路径
	#>
	$UI_Other_Path     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 453
		margin         = "0,35,0,0"
		Text           = $lang.HistorySaveFolder
	}

	<#
		.事件: 选择其它目录
	#>
	$UI_Other_Path_Add_Click = {
		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name 'Sources_Other_Directory' -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value "" -Type "MultiString"
		}
		$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources" -Name "Sources_Other_Directory" -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$TempSelectAraayOtherRule = @()
		ForEach ($item in $GetExcludeSoftware) {
			$TempSelectAraayOtherRule += $item
		}

		$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder   = "MyComputer"
		}

		if ($FolderBrowser.ShowDialog() -eq "OK") {
			if ($TempSelectAraayOtherRule -Contains $FolderBrowser.SelectedPath) {
				$UI_Main_Error.Text = "$($lang.AddTo): $($FolderBrowser.SelectedPath), $($lang.Existed)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$TempSelectAraayOtherRule += $FolderBrowser.SelectedPath
					Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value $TempSelectAraayOtherRule -Type "MultiString"

					Image_Select_Refresh_Sources_List
					Image_Select_Other_Path_Refresh

					$UI_Main_Error.Text = "$($lang.AddTo): $($FolderBrowser.SelectedPath), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.AddTo): $($FolderBrowser.SelectedPath), $($lang.ISOCreateFailed)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		} else {
			$GUIImageSourceGroupSettingErrorMsg.Text = $lang.UserCanel
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")

			$UI_Main_Error.Text = $lang.UserCanel
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}
	$UI_Other_Path_Add = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Other_Path_Add_Click
	}
	$UI_Other_Path_Clear_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = "$($lang.Del), $($lang.Choose)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Temp_Save_Select_Path = @()

			$UI_Other_Path_Show.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
					} else {
						$Temp_Save_Select_Path += $_.Text
					}
				}
			}

			Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value $Temp_Save_Select_Path -Type "MultiString"
			Image_Select_Refresh_Sources_List
			Image_Select_Other_Path_Refresh
		}
	}
	$UI_Other_Path_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 450
		Padding        = "14,0,0,0"
		Text           = $lang.AllClear
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources" -name "Sources_Other_Directory" -value "" -Type "MultiString"
			Image_Select_Refresh_Sources_List
			Image_Select_Other_Path_Refresh
		}
	}

	$UI_Other_Path_Show = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 335
		Width          = 453
		autoScroll     = $True
		Padding        = "16,0,0,0"
		margin         = "0,0,0,15"
	}

	$UI_Expand_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 475
	}

	$GUIImageSourceGroupSettingErrorMsg_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "575,583"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$GUIImageSourceGroupSettingErrorMsg = New-Object System.Windows.Forms.RichTextBox -Property @{
		Location       = "600,585"
		Height         = 40
		Width          = 443
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$GUIImageSourceGroupSetting_Save_Click = {
		$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		$GUIImageSourceGroupSettingErrorMsg.Text = ""

		if ($GUIImageSourceGroupSettingSize.Checked) {
			Save_Dynamic -regkey "Solutions" -name "SearchDiskMinSize" -value $($GUIImageSourceGroupSettingLowSize.Text)
		}

		Image_Select_Refresh_Sources_List

		if ($GUIImageSourceISOCacheCustomizeName.Enabled) {
			if ($GUIImageSourceISOCacheCustomizeName.Checked) {
				<#
					.验证自定义 ISO 默认保存到目录名
				#>
				<#
					.Judgment: 1. Null value
					.判断: 1. 空值
				#>
				if ([string]::IsNullOrEmpty($GUIImageSourceISOCacheCustomizePath.Text)) {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.CacheDiskCustomize)"
					$GUIImageSourceISOCacheCustomizePath.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 2. The prefix cannot contain spaces
					.判断: 2. 前缀不能带空格
				#>
				if ($GUIImageSourceISOCacheCustomizePath.Text -match '^\s') {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$GUIImageSourceISOCacheCustomizePath.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 3. No spaces at the end
					.判断: 3. 后缀不能带空格
				#>
				if ($GUIImageSourceISOCacheCustomizePath.Text -match '\s$') {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$GUIImageSourceISOCacheCustomizePath.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 4. There can be no two spaces in between
					.判断: 4. 中间不能含有二个空格
				#>
				if ($GUIImageSourceISOCacheCustomizePath.Text -match '\s{2,}') {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$GUIImageSourceISOCacheCustomizePath.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 5. Cannot contain: \\ /: *? "" <> |
					.判断: 5, 不能包含: \\ / : * ? "" < > |
				#>
				if ($GUIImageSourceISOCacheCustomizePath.Text -match '[~#$@!%&*{}<>?/|+"]') {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
					$GUIImageSourceISOCacheCustomizePath.BackColor = "LightPink"
					return
				}

				if (Test_Available_Disk -Path $GUIImageSourceISOCacheCustomizePath.Text) {
					Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "True"
					Save_Dynamic -regkey "Solutions" -name "DiskCache" -value $GUIImageSourceISOCacheCustomizePath.Text

					Exclude_Add_Custom
				} else {
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.FailedCreateFolder)"
					return
				}
			} else {
				Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "False"
			}
		} else {
			Save_Dynamic -regkey "Solutions" -name "IsDiskCache" -value "False"
		}

		if ($GUIImageSourceISOSaveToCheckISO9660.Checked) {
			<#
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断: 1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIImageSourceISOCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断: 2. 前缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '^\s') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 3. No spaces at the end
				.判断: 3. 后缀不能带空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s$') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 4. There can be no two spaces in between
				.判断: 4. 中间不能含有二个空格
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '\s{2,}') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 5. Cannot contain: \\ /: *? "" <> |
				.判断: 5, 不能包含: \\ / : * ? "" < > |
			#>
			if ($GUIImageSourceISOCustomizePath.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}
		}

		$MarkCheckSelectSearchDisk = $False
		$GUIImageSourceGroupSettingDisk.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$MarkCheckSelectSearchDisk = $True
						Image_Set_Disk_Sources -Disk $_.Tag

						if ($GUIImageSourceGroupSettingDefenderAdd.Checked) {
							Exclude_Add_DiskTo
						}
					}
				}
			}
		}

		if ($MarkCheckSelectSearchDisk) {
			Image_Select_Refresh_Sources_List
		} else {
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.SearchImageSource)"
			return
		}

		if ($GUIImageSourceISOWrite.Checked) {
			if (-not (Test_Available_Disk -Path $GUIImageSourceISOCustomizePath.Text)) {
				$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.FailedCreateFolder)"
				$GUIImageSourceISOCustomizePath.BackColor = "LightPink"
				return
			}
		}

		<#
			.验证自定义 ISO 默认保存到目录名, 结束并保存新路径
		#>
		if ($GUIImageSourceGroupSettingStructure.Checked) {
			if (RefreshNewPath) {
				Save_Dynamic -regkey "Solutions" -name "DiskSearchStructure" -value $GUIImageSourceGroupSettingCustomizeShow.Text
			}
		}

		Save_Dynamic -regkey "Solutions" -name "ISOTo" -value $GUIImageSourceISOCustomizePath.Text

		$UI_Main.Text = $lang.SelectSettingImage
		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $True               # 设置主界面

		<#
			.添加托动和事件
		#>
		$UI_Main.Add_DragOver($UI_Main_DragOver)
		$UI_Main.Add_DragDrop($UI_Main_DragDrop)
	}
	$GUIImageSourceGroupSetting_Save_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "575,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Save.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceGroupSetting_Save_Click
	}
	$GUIImageSourceGroupSetting_Save = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "601,638"
		Text           = $lang.Save
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIImageSourceGroupSetting_Save_Click
	}

	$GUIImageSourceGroupSetting_Hide_Click = {
		$UI_Main.Text = $lang.SelectSettingImage
		$GUIImageSourceGroupSettingErrorMsg_Icon.Image = $null
		$GUIImageSourceGroupSettingErrorMsg.Text = ""

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $True               # 设置主界面

		<#
			.添加托动和事件
		#>
		$UI_Main.Add_DragOver($UI_Main_DragOver)
		$UI_Main.Add_DragDrop($UI_Main_DragDrop)
	}
	$GUIImageSourceGroupSetting_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "820,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceGroupSetting_Hide_Click
	}
	$GUIImageSourceGroupSetting_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 200
		Location       = "846,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIImageSourceGroupSetting_Hide_Click
	}

	<#
		.组: 更改 ISO 挂载的映像主语言
	#>
	$UI_Mask_Image_Language = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Mask_Image_Language_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 340
		Location       = '15,15'
		Text           = $lang.AvailableLanguages
	}
	$UI_Mask_Image_Language_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 340
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,8,8,8"
		Location       = '15,50'
	}
	$UI_Mask_Image_Language_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "400,555"
		Height         = 30
		Width          = 643
		Text           = ""
	}

	$UI_Mask_Image_Language_Save_Click = {
		$Region = Language_Region
		$UI_Mask_Image_Language_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$FlagTag = $_.Tag

					if ($Global:LanguageFull -Contains $FlagTag) {
						ForEach ($itemRegion in $Region) {
							if ($itemRegion.Region -eq $FlagTag) {
								$Global:MainImageLang = $itemRegion.Region
								$Global:MainImageLangShort = $itemRegion.Tag
								$Global:MainImageLangName = $itemRegion.Name

								$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) )"

								$UI_Main.Text = $lang.SelectSettingImage
								$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
								$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
								$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
								$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
								$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
								$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
								$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
								$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
								$UI_Main_Image_Sources.visible = $True               # 设置主界面
								
								$UI_Main_Error.Text = "$($lang.Save): $($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.Done)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")

								<#
									.添加托动和事件
								#>
								$UI_Main.Add_DragOver($UI_Main_DragOver)
								$UI_Main.Add_DragDrop($UI_Main_DragDrop)
								break
							}
						}
					}
				} else {
					$UI_Mask_Image_Language_Error.Text = $lang.NoChoose
				}
			}
		}
	}
	$UI_Mask_Image_Language_Save_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,600"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Save.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Mask_Image_Language_Save_Click
	}
	$UI_Mask_Image_Language_Save = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,602"
		Text           = $lang.Save
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Mask_Image_Language_Save_Click
	}

	$UI_Mask_Image_Language_Hide_Click = {
		$UI_Main.Text = $lang.SelectSettingImage
		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $True               # 设置主界面

		<#
			.添加托动和事件
		#>
		$UI_Main.Add_DragOver($UI_Main_DragOver)
		$UI_Main.Add_DragDrop($UI_Main_DragDrop)
	}
	$UI_Mask_Image_Language_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Mask_Image_Language_Hide_Click
	}
	$UI_Mask_Image_Language_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Mask_Image_Language_Hide_Click
	}

	<#
		.挂载到更改
	#>
	$UI_Mask_Image_Mount_To = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Mask_Image_Mount_ToGroupAll = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		Dock           = 3
		autoScroll     = $True
		Padding        = 15
	}
	$GUIImageSourceGroupMountFrom = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Text           = $lang.SelectSettingImage
	}
	$GUIImageSourceGroupMountFromPath = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "19,8,0,15"
		ForeColor      = "#008000"
		Text           = ""
	}

	<#
		.事件: 映像源, 打开目录
	#>
	$GUIImageSourceGroupMountFromOpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromPath.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test-Path -Path $GUIImageSourceGroupMountFromPath.Text -PathType Container) {
					Start-Process $GUIImageSourceGroupMountFromPath.Text

					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromPath.Text), $($lang.Done)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromPath.Text), $($lang.Inoperable)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	<#
		.事件: 映像源, 复制路径
	#>
	$GUIImageSourceGroupMountFromPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromPath.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				Set-Clipboard -Value $GUIImageSourceGroupMountFromPath.Text

				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Done)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		}
	}

	$GUIImageSourceGroupMountFromDelete = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 460
		Padding        = "18,0,0,0"
		margin         = "0,8,0,0"
		Text           = $lang.Del
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			if (-not [string]::IsNullOrEmpty($GUIImageSourceGroupMountFromPath.Text)) {
				if (Test-Path -Path $GUIImageSourceGroupMountFromPath.Text -PathType Container) {
					if ($GUIImageSourceGroupMountFromDelete_Custom.Enabled) {
						if ($GUIImageSourceGroupMountFromDelete_Custom.Checked) {
							if (Test-Path -Path $GUIImageSourceGroupMountFromDelete_Custom_Path.Text -PathType Container) {
								Remove_Tree -Path $GUIImageSourceGroupMountFromDelete_Custom_Path.Text
							}
						}
					}

					if ($GUIImageSourceGroupMountFromDelete_Clear.Checked) {
						$UI_Main_Select_Sources.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($_.Enabled) {
									if ($_.Checked) {
										Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($_.Tag)" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
									}
								}
							}
						}
					}

					$UI_Main.Text = $lang.SelectSettingImage
					$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
					$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
					$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
					$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
					$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
					$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
					$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
					$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
					$UI_Main_Image_Sources.visible = $True               # 设置主界面

					if ($UI_ImageSources_Del.Checked) {
						Remove_Tree -Path $GUIImageSourceGroupMountFromPath.Text
						Image_Select_Refresh_Sources_List

						if (Test-Path -Path $GUIImageSourceGroupMountFromPath.Text -PathType Container) {
							$UI_Main_Error.Text = "$($lang.Del), $($lang.Failed): $($GUIImageSourceGroupMountFromPath.Text)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						} else {
							$UI_Main_Error.Text = "$($lang.Del): $($GUIImageSourceGroupMountFromPath.Text), $($lang.Done)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						}
					} else {
						$UI_Main_Error.Text = "$($lang.Del): $($lang.RuleOther), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					}
				}
			}
		}
	}

		<#
			.事件: 映像源, 主目录
		#>
		$UI_ImageSources_Del = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 475
			Padding        = "35,0,0,0"
			Checked        = $True
			Text           = $lang.SelectSettingImage
		}
		$UI_ImageSources_Del_Path = New-Object system.Windows.Forms.LinkLabel -Property @{
			autoSize       = 1
			Text           = ""
			Padding        = "53,0,0,0"
			Margin         = "0,0,0,20"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Mask_Image_Mount_To_Error.Text = ""
				$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromPath.Text)) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($lang.Inoperable)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $GUIImageSourceGroupMountFromPath.Text -PathType Container) {
						Start-Process $GUIImageSourceGroupMountFromPath.Text

						$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromPath.Text), $($lang.Done)"
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromPath.Text), $($lang.Inoperable)"
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}

		<#
			.事件: 映像源, 删除后清除自定义目录
		#>
		$GUIImageSourceGroupMountFromDelete_Custom = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 475
			Padding        = "35,0,0,0"
			Text           = $lang.RuleCustomize
		}
		$GUIImageSourceGroupMountFromDelete_Custom_Path = New-Object system.Windows.Forms.LinkLabel -Property @{
			autoSize       = 1
			Text           = ""
			Padding        = "53,0,0,0"
			Margin         = "0,0,0,20"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Mask_Image_Mount_To_Error.Text = ""
				$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromDelete_Custom_Path.Text)) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($lang.Inoperable)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $GUIImageSourceGroupMountFromDelete_Custom_Path.Text -PathType Container) {
						Start-Process $GUIImageSourceGroupMountFromDelete_Custom_Path.Text

						$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromDelete_Custom_Path.Text), $($lang.Done)"
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountFromDelete_Custom_Path.Text), $($lang.Inoperable)"
						$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}

		<#
			.事件: 映像源, 删除后清除历史记录
		#>
		$GUIImageSourceGroupMountFromDelete_Clear = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 475
			Padding        = "35,0,0,0"
			Text           = $lang.History
		}
		$GUIImageSourceGroupMountFromDelete_Clear_Path = New-Object system.Windows.Forms.Label -Property @{
			autoSize       = 1
			Text           = ""
			Padding        = "53,0,0,0"
			Margin         = "0,0,0,20"
		}

		$GUIImageSourceGroupMountFromRename_Path = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			margin         = "0,30,0,0"
			Text           = $lang.ISOStructure
		}
		$GUIImageSourceGroupMountFromRename_New_Path = New-Object System.Windows.Forms.TextBox -Property @{
			Height         = 30
			Width          = 420
			Margin         = "40,0,0,15"
			Text           = ""
			BackColor      = "#FFFFFF"
			add_Click      = {
				$This.BackColor = "#FFFFFF"
				$UI_Mask_Image_Mount_To_Error.Text = ""
				$UI_Mask_Image_Mount_To_Error_Icon.Image = $null
			}
		}
	
		<#
			.重命名
		#>
		$GUIImageSourceGroupMountFromRename = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 460
			Padding        = "35,0,0,0"
			Text           = $lang.Rename
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			Enabled        = $False
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				$UI_Mask_Image_Mount_To_Error.Text = ""
				$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

				<#
					.Judgment: 1. Null value
					.判断: 1. 空值
				#>
				if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromRename_New_Path.Text)) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 2. The prefix cannot contain spaces
					.判断: 2. 前缀不能带空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '^\s') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 3. Suffix cannot contain spaces
					.判断: 3. 后缀不能带空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s$') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 4. The suffix cannot contain multiple spaces
					.判断: 4. 后缀不能带多空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s{2,}$') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 5. There can be no two spaces in between
					.判断: 5. 中间不能含有二个空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s{2,}') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 6. Cannot contain: \\ /: *? "" <> |
					.判断: 6, 不能包含: \\ / : * ? "" < > |
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '[~#$@!%&*{}<>?/|+"]') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 7. No more than 260 characters
					.判断: 7. 不能大于 260 字符
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text.length -gt 260) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 8. Cannot be the same as the old directory name
					.判断: 8. 不能与旧目录名相同
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Name -eq $GUIImageSourceGroupMountFromRename_New_Path.Text) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.RenameFailed)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 9. Cannot be the same as the old directory name
					.判断: 9. 已存在
				#>
				$Verify_New_Rename_Folder_Some = Join-Path -Path $Global:MainMasterFolder -ChildPath $GUIImageSourceGroupMountFromRename_New_Path.Text
				if (Test-Path -Path $Verify_New_Rename_Folder_Some -PathType Container) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.Existed)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				Rename-Item -Path $GUIImageSourceGroupMountFromPath.Text -NewName $GUIImageSourceGroupMountFromRename_New_Path.Text

				$UI_Main.Text = $lang.SelectSettingImage
				$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
				$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
				$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
				$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
				$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
				$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
				$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
				$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
				$UI_Main_Image_Sources.visible = $True               # 设置主界面

				Image_Select_Refresh_Sources_List

				$Verify_New_Rename_Folder = Join-Path -Path $Global:MainMasterFolder -ChildPath $GUIImageSourceGroupMountFromRename_New_Path.Text
				if (Test-Path -Path $Verify_New_Rename_Folder -PathType Container) {
					$UI_Main_Error.Text = "$($lang.Rename): $($GUIImageSourceGroupMountFromRename_New_Path.Text), $($lang.Done), "
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.Rename), $($lang.Failed)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}

		<#
			.复制
		#>
		$GUIImageSourceGroupMountFromCopy = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 460
			Padding        = "35,0,0,0"
			Text           = $lang.Copy
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				$UI_Mask_Image_Mount_To_Error.Text = ""
				$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

				<#
					.Judgment: 1. Null value
					.判断: 1. 空值
				#>
				if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountFromRename_New_Path.Text)) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 2. The prefix cannot contain spaces
					.判断: 2. 前缀不能带空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '^\s') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 3. Suffix cannot contain spaces
					.判断: 3. 后缀不能带空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s$') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 4. The suffix cannot contain multiple spaces
					.判断: 4. 后缀不能带多空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s{2,}$') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 5. There can be no two spaces in between
					.判断: 5. 中间不能含有二个空格
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '\s{2,}') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 6. Cannot contain: \\ /: *? "" <> |
					.判断: 6, 不能包含: \\ / : * ? "" < > |
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text -match '[~#$@!%&*{}<>?/|+"]') {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 7. No more than 260 characters
					.判断: 7. 不能大于 260 字符
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Text.length -gt 260) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 8. Cannot be the same as the old directory name
					.判断: 8. 不能与旧目录名相同
				#>
				if ($GUIImageSourceGroupMountFromRename_New_Path.Name -eq $GUIImageSourceGroupMountFromRename_New_Path.Text) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.RenameFailed)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				<#
					.Judgment: 9. Cannot be the same as the old directory name
					.判断: 9. 已存在
				#>
				$Verify_New_Rename_Folder_Some = Join-Path -Path $Global:MainMasterFolder -ChildPath $GUIImageSourceGroupMountFromRename_New_Path.Text
				if (Test-Path -Path $Verify_New_Rename_Folder_Some -PathType Container) {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SelectFromError): $($lang.Existed)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$GUIImageSourceGroupMountFromRename_New_Path.BackColor = "LightPink"
					return
				}

				Copy-Item -Path $GUIImageSourceGroupMountFromPath.Text -Destination $Verify_New_Rename_Folder_Some -Recurse

				$UI_Main.Text = $lang.SelectSettingImage
				$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
				$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
				$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
				$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
				$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
				$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
				$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
				$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
				$UI_Main_Image_Sources.visible = $True               # 设置主界面

				Image_Select_Refresh_Sources_List

				$Verify_New_Rename_Folder = Join-Path -Path $Global:MainMasterFolder -ChildPath $GUIImageSourceGroupMountFromRename_New_Path.Text
				if (Test-Path -Path $Verify_New_Rename_Folder -PathType Container) {
					$UI_Main_Error.Text = "$($lang.Copy): $($GUIImageSourceGroupMountFromRename_New_Path.Text), $($lang.Done), "
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.Copy), $($lang.Failed)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}

		$GUIImageSourceGroupMountFromPath_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height       = 40
		Width        = 460
	}

	<#
		.挂载到
	#>
	$GUIImageSourceGroupMountTo = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Text           = "$($lang.MountImageTo), $($lang.MainImageFolder)"
	}
	$GUIImageSourceGroupMountChangeTipsErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "19,8,0,15"
		Text           = $lang.SettingImageNewPathTips
	}
	$GUIImageSourceGroupMountToShow = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "19,8,0,15"
		ForeColor      = "#008000"
		Text           = ""
	}

	<#
		.事件: 挂载到, 打开目录
	#>
	$GUIImageSourceGroupMountToOpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountToShow.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test-Path -Path $GUIImageSourceGroupMountToShow.Text -PathType Container) {
					Start-Process $GUIImageSourceGroupMountToShow.Text

					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountToShow.Text), $($lang.Done)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountToShow.Text), $($lang.Inoperable)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	<#
		.事件: 挂载到, 复制路径
	#>
	$GUIImageSourceGroupMountToPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountToShow.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				Set-Clipboard -Value $GUIImageSourceGroupMountToShow.Text

				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Done)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		}
	}
	$GUIImageSourceGroupMountTo_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height       = 40
		Width        = 460
	}

	<#
		.Event: The temporary directory is the same as mounted to the location
		.事件: 临时目录与挂载到位置相同
	#>
	$GUIImageSourceGroupMountToTemp = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 463
		Text           = $lang.SettingImageToTemp
		Location       = '15,125'
		add_Click      = {
			$NewOtherRuleName = [IO.Path]::GetFileName($Global:Image_source)
			if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
				$NewOtherRuleName = [System.IO.Path]::GetPathRoot($Global:Image_source).Substring(0,1)
				$GUIImageSourceGroupMountToShow.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
			} else {
				$GUIImageSourceGroupMountToShow.Text = "$($Global:Image_source)_Custom"
			}

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "TempFolderSync" -value "True"

				if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
					$NewOtherRuleName = [System.IO.Path]::GetPathRoot($Global:Image_source).Substring(0,1)
					$GUIImageSourceGroupMountToTempShow.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
				} else {
					$GUIImageSourceGroupMountToTempShow.Text = "$($Global:Image_source)_Custom\Temp"
				}
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "TempFolderSync" -value "False"
				$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
			}

			Image_Select_Refresh_Sources_Event
		}
	}
	$GUIImageSourceGroupMountToTempShow = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "19,8,0,15"
		ForeColor      = "#008000"
		Text           = ""
	}

	<#
		.事件: 临时目录, 打开目录
	#>
	$GUIImageSourceGroupMountToTempOpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountToTempShow.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test-Path -Path $GUIImageSourceGroupMountToTempShow.Text -PathType Container) {
					Start-Process $GUIImageSourceGroupMountToTempShow.Text

					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountToTempShow.Text), $($lang.Done)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Mask_Image_Mount_To_Error.Text = "$($lang.OpenFolder): $($GUIImageSourceGroupMountToTempShow.Text), $($lang.Inoperable)"
					$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	<#
		.事件: 临时目录, 复制路径
	#>
	$GUIImageSourceGroupMountToTempPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		Enabled        = $False
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIImageSourceGroupMountToTempShow.Text)) {
				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				Set-Clipboard -Value $GUIImageSourceGroupMountToTempShow.Text

				$UI_Mask_Image_Mount_To_Error.Text = "$($lang.Paste), $($lang.Done)"
				$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		}
	}
	$UI_Mask_Image_Mount_ToGroupAll_Wrap = New-Object System.Windows.Forms.Label -Property @{
		Height             = 30
		Width              = 460
	}

	<#
		.更改映像源挂载位置
	#>
	$GUIImageSourceGroupMountChangePanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 550
		Width          = 500
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 15
		Location       = '550,15'
	}
	$GUIImageSourceGroupMountChangeTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Text           = $lang.SettingImage
	}

	<#
		.Event: Use Temp directory
		.事件: 使用 Temp 目录
	#>
	$GUIImageSourceGroupMountChangeTemp = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.SettingImagePathTemp
		add_Click      = {
			$UI_Mask_Image_Mount_To_Error.Text = ""
			$UI_Mask_Image_Mount_To_Error_Icon.Image = $null

			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "UseTempFolder" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "UseTempFolder" -value "False"
			}

			Image_Select_Refresh_Sources_Event
		}
	}
	$GUIImageSourceGroupMountChangeDiSKLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.SettingImageLow
		Checked        = $True
		add_Click      = $GetDiskAvailableClick
	}

	$GUIImageSourceGroupMountChangeLowSize_Show = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 70
		Width          = 460
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}
	$GUIImageSourceGroupMountChangeLowSize = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "33,5"
		Value          = 1
		Minimum        = 1
		Maximum        = 999999
		TextAlign      = 1
		add_Click      = $GetDiskAvailableClick
	}
	$GUIImageSourceGroupMountChangeLowUnit = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 80
		Text           = "GB"
		Location       = "100,8"
	}

	<#
		.选择可用磁盘: 挂载
	#>
	
	$GUIImageSourceGroupMountChangeSelect = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Padding        = "16,0,0,0"
		Text           = $lang.SettingImageNewPath
	}

	<#
		遇到磁盘格式 REFS 时, 排除
	#>
	$GUIImageSourceGroupMountChangeExclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 460
		Padding        = "35,0,0,0"
		Text           = $lang.ReFS_Find_Volume
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "Exclude_REFS" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "Exclude_REFS" -value "False"
			}

			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)

			Refresh_Click_Image_Sources
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "Exclude_REFS" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "Exclude_REFS" -ErrorAction SilentlyContinue) {
			"True" { $GUIImageSourceGroupMountChangeExclude.Checked = $True }
		}
	} else {
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "Exclude_REFS" -value "True"
		$GUIImageSourceGroupMountChangeExclude.Checked = $True
	}

	<#
		选择可用磁盘: 刷新
	#>
	$GUIImageSourceGroupMountChangeRefresh = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 460
		Text           = $lang.Refresh
		Padding        = "35,0,0,0"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)

			Refresh_Click_Image_Sources
		}
	}
	$UI_Mask_Image_Mount_To_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "35,0,0,0"
		Text           = ""
	}
	$GUIImageSourceGroupMountChangeDiSKPane1 = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "35,0,0,0"
	}
	$GUIImageSourceGroupMount_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height       = 20
		Width        = 425
	}

	$UI_Mask_Image_Mount_To_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "550,583"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Mask_Image_Mount_To_Error = New-Object System.Windows.Forms.RichTextBox -Property @{
		Location       = "575,585"
		Height         = 35
		Width          = 468
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.Event: Restore the default mount location
		.事件: 恢复默认挂载位置
	#>
	$UI_Mask_Image_Mount_To_Reset = {
		$NewOtherRuleName = [IO.Path]::GetFileName($Global:Image_source)
		if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
			$NewOtherRuleName = [System.IO.Path]::GetPathRoot($Global:Image_source).Substring(0,1)
			$GUIImageSourceGroupMountToShow.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
		} else {
			$GUIImageSourceGroupMountToShow.Text = "$($Global:Image_source)_Custom"
		}

		if ($GUIImageSourceGroupMountToTemp.Checked) {
			if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
				$NewOtherRuleName = [System.IO.Path]::GetPathRoot($Global:Image_source).Substring(0,1)
				$GUIImageSourceGroupMountToShow.Text = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Custom\$($NewOtherRuleName)"
			} else {
				$GUIImageSourceGroupMountToTempShow.Text = "$($Global:Image_source)_Custom\Temp"
			}
		} else {
			$GUIImageSourceGroupMountToTempShow.Text = "$($env:userprofile)\AppData\Local\Temp"
		}

		Image_Select_Refresh_Mount_Disk

		$UI_Mask_Image_Mount_To_Error.Text = "$($lang.SettingImageRestore), $($lang.Done)"
		$UI_Mask_Image_Mount_To_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
	}
	$UI_Mask_Image_Mount_To_Reset_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "550,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\restore.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Mask_Image_Mount_To_Reset
	}
	$UI_Mask_Image_Mount_To_Reset = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "576,638"
		Text           = $lang.SettingImageRestore
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Mask_Image_Mount_To_Reset
	}

	$UI_Mask_Image_Mount_To_Hide_Click = {
		$UI_Main.Text = $lang.SelectSettingImage

		<#
			.添加托动和事件
		#>
		$UI_Main.Add_DragOver($UI_Main_DragOver)
		$UI_Main.Add_DragDrop($UI_Main_DragDrop)

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $True               # 设置主界面
	}

	$UI_Mask_Image_Mount_To_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "800,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Mask_Image_Mount_To_Hide_Click
	}
	$UI_Mask_Image_Mount_To_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 220
		Location       = "826,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Mask_Image_Mount_To_Hide_Click
	}

	<#
		.动态显示: 挂载到
	#>
	$GUIImageSourceGroupMount = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 35
		Width          = 695
		autoSizeMode   = 1
		Padding        = "0,0,8,0"
		Location       = '0,485'
		Visible        = $False
	}
	$GUIImageSourceMountTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 95
		Text           = $lang.MountImageTo
		Location       = '0,8'
		RightToLeft    = 1
	}
	$GUIImageSourceMountInfo = New-Object System.Windows.Forms.LinkLabel -Property @{
		TabIndex       = 8
		Height         = 35
		Width          = 570
		Text           = $lang.SelectImageMountStatus
		Location       = '100,8'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)

			Image_Select_Refresh_MountTo
		}
	}

	<#
		.动态显示: 更改语言
	#>
	$GUIImageSourceGroupLang = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 35
		Width          = 695
		autoSizeMode   = 1
		Padding        = "0,0,8,0"
		Location       = '0,520'
		Visible        = $False
	}
	$GUIImageSourceLangTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 95
		Text           = $lang.Language
		Location       = '0,8'
		RightToLeft    = 1
	}
	$GUIImageSourceLanguageInfo = New-Object System.Windows.Forms.LinkLabel -Property @{
		TabIndex       = 9
		Height         = 35
		Width          = 570
		Text           = $lang.LanguageNoSelect
		Location       = '100,8'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			<#
				.释放托动和事件
			#>
			$UI_Main.remove_DragOver($UI_Main_DragOver)
			$UI_Main.remove_DragDrop($UI_Main_DragDrop)

			Image_Select_Refresh_Language
		}
	}

	<#
		显示其它信息: 详细
	#>
	$GUIImageSourceGroupOther = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 75
		Width          = 695
		autoSizeMode   = 1
		Padding        = "0,0,8,0"
		Location       = '0,555'
		Visible        = $False
	}
	$GUIImageSourceOtherTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 95
		Text           = $lang.Detailed
		Location       = '0,8'
		RightToLeft    = 1
	}
	$GUIImageSourceOtherImageErrorMsg = New-Object System.Windows.Forms.LinkLabel -Property @{
		TabIndex       = 10
		Height         = 68
		Width          = 573
		Text           = $lang.ImageSouresNoSelect
		Location       = '100,8'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Image_Select_Refresh_Detailed
		}
	}

	<#
		显示其它信息: 面板
	#>
	$GUIImageSourceGroupOtherPanel = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}

	<#
		.事件管理
	#>
	$GUIImageSourceGroupSettingEvent = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 320
		Text           = $lang.EventManager
		Location       = '15,15'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Image_Select_Refresh_Event

			$GUISelectOtherSettingSaveModeErrorMsg.Text = "$($lang.Refresh): $($lang.Done)"
			$GUISelectOtherSettingSaveModeErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIImageSourceGroupSettingEventSelect = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 395
		Width          = 465
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,8,8,8"
		Location       = '15,45'
	}

	$GUISelectNotExecuted = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 320
		Text           = $lang.AfterFinishingNotExecuted
		Location       = '15,485'
	}
	$GUISelectGroupAfterFinishing = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 155
		Width          = 450
		autoSizeMode   = 1
		Padding        = 14
		Location       = '31,515'
		Enabled        = $False
	}
	$GUISelectAfterFinishingNoProcess = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.AfterFinishingNoProcess
		Location       = '0,0'
		add_Click      = {
			$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($_.Name)\$($_.Text)" -name "AfterFinishing" -value "NoProcess"
						}
					}
				}
			}
		}
	}
	$GUISelectAfterFinishingPause = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.AfterFinishingPause
		Location       = '0,35'
		add_Click      = {
			$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($_.Name)\$($_.Text)" -name "AfterFinishing" -value "Pause"
						}
					}
				}
			}
		}
	}
	$GUISelectAfterFinishingReboot = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.AfterFinishingReboot
		Location       = '0,70'
		add_Click      = {
			$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($_.Name)\$($_.Text)" -name "AfterFinishing" -value "Reboot"
						}
					}
				}
			}
		}
	}
	$GUISelectAfterFinishingShutdown = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.AfterFinishingShutdown
		Location       = '0,105'
		add_Click      = {
			$GUIImageSourceGroupSettingEventSelect.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\$($_.Name)\$($_.Text)" -name "AfterFinishing" -value "Shutdown"
						}
					}
				}
			}
		}
	}

	$GUIImageSourceGroupOtherPanel_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 560
		Width          = 485
		Location       = '560,5'
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,15,8,0"
	}

	$GUISelectGroupArchitecture = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		autoSize       = 1
		BorderStyle    = 0
		autoSizeMode   = 1
		margin         = "0,0,0,35"
		autoScroll     = $False
	}
	$GUIImageSourceArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 440
		Text           = $lang.Architecture
	}
	$GUIImageSourceArchitectureARM64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 440
		Padding        = "25,0,0,0"
		Text           = "arm64"
	}
	$GUIImageSourceArchitectureAMD64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 440
		Padding        = "25,0,0,0"
		Text           = "x64"
	}
	$GUIImageSourceArchitectureX86 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 440
		Padding        = "25,0,0,0"
		Text           = "x86"
		Checked        = $True
	}

	$GUIImageSourceGroupType = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		autoSize       = 1
		BorderStyle    = 0
		autoSizeMode   = 1
		margin         = "0,0,0,45"
		autoScroll     = $False
	}
	$GUISelectTypeTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 440
		Text           = $lang.ImageLevel
	}
	$GUISelectTypeDesktop = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 440
		Padding        = "25,0,0,0"
		Text           = $lang.LevelDesktop
		Checked        = $True
	}
	$GUISelectTypeServer = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 440
		Padding        = "25,0,0,0"
		Text           = $lang.LevelServer
	}

	<#
		.可选功能
	#>
	$GUIImageSourceGroupSettingAdv = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 445
		Text           = $lang.AdvOption
	}

	<#
		.清除所有事件
	#>
	$GUIImageSourceGroupSettingEventClear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 445
		Padding        = "25,0,0,0"
		Text           = $lang.EventManagerClear
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUISelectOtherSettingSaveModeErrorMsg.Text = ""
			$GUISelectOtherSettingSaveModeErrorMsg_Icon.Image = $null

			$GUIImageSourceGroupSettingEventSelect.controls.Clear()
			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Queue" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
			Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Event\Assign" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

			$GUISelectGroupAfterFinishing.Enabled = $False

			Image_Select_Refresh_Event

			$GUISelectOtherSettingSaveModeErrorMsg.Text = "$($lang.EventManagerClear), $($lang.Done)"
			$GUISelectOtherSettingSaveModeErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.清除所选
	#>
	$GUISelectOtherSettingSaveModeClear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 445
		Padding        = "25,0,0,0"
		Text           = $lang.SaveModeClear
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Select_Sources.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Remove-Item -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($_.Tag)" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
						}
					}
				}
			}

			$UI_Main.Text = $lang.SelectSettingImage
			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $True               # 设置主界面

			Image_Select_Refresh_Sources_List

			$UI_Main_Error.Text = "$($lang.SaveModeClear), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	$GUISelectOtherSettingSaveModeErrorMsg_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,593"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$GUISelectOtherSettingSaveModeErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 628
		Text           = ""
		Location       = "585,595"
	}

	$GUIImageSourceGroupOther_Hide_Click = {
		$UI_Main.Text = $lang.SelectSettingImage
		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $True               # 设置主界面
	}
	$GUIImageSourceGroupOther_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceGroupOther_Hide_Click
	}
	$GUIImageSourceGroupOther_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 250
		Location       = "790,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIImageSourceGroupOther_Hide_Click
	}

	<#
		.主界面
	#>
	<#
		.菜单
	#>
	$UI_Main_Image_Sources_Menu = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "1010,15"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
		Image          = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\menu.ico")
		Cursor         = [System.Windows.Forms.Cursors]::Hand
		add_Click      = {
			$UI_Main_Image_Sources_Menu_Show.visible = $True
		}
	}
	$UI_Main_Image_Sources_Menu_Hide = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "250,15"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
		Image          = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\hide.ico")
		Cursor         = [System.Windows.Forms.Cursors]::Hand
		add_Click      = {
			$UI_Main_Image_Sources_Menu_Show.visible = $False
		}
	}

	$UI_Main_Image_Sources_Menu_Show = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 290
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '760,0'
		Visible        = $False
	}

	$GUIImageSourceSetting_Menu_Ico = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "4,15"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Menu.ico")
	}

	$GUIImageSourceSetting_Menu = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 200
		Text           = $lang.Menu
		Location       = "30,17"
	}

		$GUIImageSourceSetting_Menu_Capture = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 250
			Location       = "30,60"
			Text           = $lang.Wim_Capture
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Hide()
				Image_Capture_UI
				Image_Select -Page "Menu"
				$UI_Main.Close()
			}
		}

		$GUIImageSourceSetting_Menu_Tempate = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 250
			Location       = "30,100"
			Text           = $lang.RuleNewTempate
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Hide()
				Create_Template_UI
				Image_Select -Page "Menu"
				$UI_Main.Close()
			}
		}

		$GUIImageSourceSetting_Menu_Unpack = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 40
			Width          = 250
			Location       = "30,140"
			Text           = $lang.Backup
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main.Hide()
				UnPack_Create_UI
				Image_Select -Page "Menu"
				$UI_Main.Close()
			}
		}

	<#
		.设置按钮
	#>
	$GUIImageSourceSetting_Click = {
		$UI_Main.Text = $lang.Setting

		<#
			.释放托动和事件
		#>
		$UI_Main.remove_DragOver($UI_Main_DragOver)
		$UI_Main.remove_DragDrop($UI_Main_DragDrop)

		Image_Select_Other_Path_Refresh
		Image_Setting_UI

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $True          # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $False              # 设置主界面
	}
	$GUIImageSourceSetting_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,15"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Setting.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceSetting_Click
	}
	$GUIImageSourceSetting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "790,17"
		Text           = $lang.Setting
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $GUIImageSourceSetting_Click
	}

	<#
		.解压 ISO
	#>
	$UIUnzip_Click = {
		$UI_Main.Text = $lang.ISO_File

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
			$itemISO = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue
			$UIUnzipPanel_Menu_Sources_Path.Text = Join-Path -Path $itemISO -ChildPath $Global:Init_Search_ISO_Folder_Name
		}

		$UI_Main.remove_DragDrop($UI_Main_DragDrop)
		$UI_Main.Add_DragDrop($UI_Main_Unzip_DragDrop)

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $True                        # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $False              # 设置主界面

		ISO_Select_Refresh_Sources_List
	}
	$UIUnzip_ICO       = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,50"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\iso.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UIUnzip_Click
	}
	$UIUnzip           = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "790,52"
		Text           = "ISO"
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UIUnzip_Click
	}

	<#
		.Mask: Displays the rule details
		.蒙板: 显示规则详细信息
	#>
	$UI_Main_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Rule_Detailed_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 1025
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UI_Main_View_Detailed_Hide_Click = {
		$UI_Main.Text = $lang.Rule_Show_Only_Select

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $True            # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $False              # 设置主界面
	}
	$UI_Main_View_Detailed_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "820,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Main_View_Detailed_Hide_Click
	}
	$UI_Main_View_Detailed_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "846,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_View_Detailed_Hide_Click
	}

	<#
		蒙板: 提取 ISO, 选择规则
	#>
	$UIUnzipPanel_Select_Rule = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Location       = '0,0'
		Visible        = $False
	}

	<#
		.搜索 ISO 来源, 显示菜单
	#>
	$UIUnzipPanel_Select_Rule_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 650
		Width          = 500
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Dock           = 3
		Padding        = "15,15,10,10"
	}
	
	$UIUnzipPanel_Select_Rule_Filter = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 428
		Location       = "560,20"
		Text           = $lang.LanguageExtractRuleFilter
	}

	$UIUnzipPanel_Select_Rule_Filter_arm64 = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 428
		Location       = "575,55"
		Text           = "arm64"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzip_Search_Sift_Custon.Text = "arm64"
			ISO_Select_Refresh_Sources_List

			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.Setting) > $($lang.LanguageExtractRuleFilter) ( arm64 ) $($lang.Done)"
		}
	}

	$UIUnzipPanel_Select_Rule_Filter_x64 = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 428
		Location       = "575,95"
		Text           = "x64"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzip_Search_Sift_Custon.Text = "x64"
			ISO_Select_Refresh_Sources_List

			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.Setting) > $($lang.LanguageExtractRuleFilter) ( x64 ) $($lang.Done)"
		}
	}

	$UIUnzipPanel_Select_Rule_Filter_x86 = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 428
		Location       = "575,135"
		Text           = "x86"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzip_Search_Sift_Custon.Text = "x86"
			ISO_Select_Refresh_Sources_List

			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.Setting) > $($lang.LanguageExtractRuleFilter) ( x86 ) $($lang.Done)"
		}
	}

	$UIUnzipPanel_Select_Rule_MenuMsg_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UIUnzipPanel_Select_Rule_MenuMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "586,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UIUnzipPanel_Select_Rule_Menu_Save_Click = {
		$UI_Main.Text = $lang.ISO_File

		if (Unzip_Custom_Rule_Setting_Default) {
			ISO_Select_Refresh_Sources_List
		} else {
			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = "$($lang.SelectFromError): $($lang.NoChoose) ( $($lang.RuleName) )"
			return
		}

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $True                        # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $False              # 设置主界面
	}
	$UIUnzipPanel_Select_Rule_Menu_Save_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "575,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Save.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UIUnzipPanel_Select_Rule_Menu_Save_Click
	}
	$UIUnzipPanel_Select_Rule_Menu_Save = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "601,638"
		Text           = $lang.Save
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UIUnzipPanel_Select_Rule_Menu_Save_Click
	}

	$UIUnzipPanel_Select_Rule_Menu_Hide_Click = {
		$UI_Main.Text = $lang.ISO_File

		$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
		$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
		$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
		$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
		$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
		$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
		$UIUnzipPanel.visible = $True                        # 蒙板: 解压 ISO
		$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
		$UI_Main_Image_Sources.visible = $False              # 设置主界面
	}
	$UIUnzipPanel_Select_Rule_Menu_Hide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "820,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UIUnzipPanel_Select_Rule_Menu_Hide_Click
	}
	$UIUnzipPanel_Select_Rule_Menu_Hide = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "846,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UIUnzipPanel_Select_Rule_Menu_Hide_Click
	}

	Function Refresh_Unzip_Custom_Rule
	{
		$UIUnzipPanel_Select_Rule_Menu.controls.Clear()

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "GUID" -ErrorAction SilentlyContinue) {
			$GetDefaultSelectGuid = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "GUID" -ErrorAction SilentlyContinue
		} else {
			$GetDefaultSelectGuid = ""
		}

		<#
			.添加规则: 预置规则
		#>
		$UI_Main_Extract_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Text           = $lang.RulePre
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Pre_Rule)
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			$UI_Main_Extract_Group = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 460
				Padding   = "18,0,0,0"
				Text      = $itemPre.Group
			}
			$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Group)

			ForEach ($item in $itemPre.Version) {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 30
					Width     = 460
					Padding   = "36,0,0,0"
					Text      = $item.Name
					Tag       = $item.GUID
					add_Click = {
						$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = $null
						$UIUnzipPanel_Select_Rule_MenuMsg.Text = ""
					}
				}

				if ($GetDefaultSelectGuid -eq $item.GUID) {
					$CheckBox.Checked = $True
				} else {
					$CheckBox.Checked = $False
				}

				$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 30
					Width          = 460
					Padding        = "54,0,0,0"
					Margin         = "0,0,0,5"
					Text           = $lang.Detailed_View
					Tag            = $item.GUID
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						Unzip_Custom_Rule_Details_View -GUID $this.Tag
					}
				}

				$UIUnzipPanel_Select_Rule_Menu.controls.AddRange((
					$CheckBox,
					$UI_Main_Rule_Details_View
				))
			}

			$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 20
				Width          = 460
			}
			$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Group_Wrap)
		}

		<#
			.添加规则: 其它规则
		#>
		$UI_Main_Extract_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Text           = $lang.RuleOther
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Other_Rule)
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 30
				Width     = 460
				Padding   = "18,0,0,0"
				Text      = $item.Name
				Tag       = $item.GUID
				add_Click = {
					$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = $null
					$UIUnzipPanel_Select_Rule_MenuMsg.Text = ""
				}
			}

			if ($GetDefaultSelectGuid -eq $item.GUID) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 460
				Padding        = "36,0,0,0"
				Margin         = "0,0,0,5"
				Text           = $lang.Detailed_View
				Tag            = $item.GUID
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					Unzip_Custom_Rule_Details_View -GUID $this.Tag
				}
			}

			$UIUnzipPanel_Select_Rule_Menu.controls.AddRange((
				$CheckBox,
				$UI_Main_Rule_Details_View
			))
		}

		<#
			.添加规则, 自定义
		#>
		$UI_Main_Extract_Customize_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			margin         = "0,35,0,0"
			Text           = $lang.RuleCustomize
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Customize_Rule)
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
						Height    = 30
						Width     = 435
						Padding   = "18,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
						add_Click = {
							$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = $null
							$UIUnzipPanel_Select_Rule_MenuMsg.Text = ""
						}
					}

					if ($GetDefaultSelectGuid -eq $item.GUID) {
						$CheckBox.Checked = $True
					} else {
						$CheckBox.Checked = $False
					}

					$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 435
						Padding        = "36,0,0,0"
						Margin         = "0,0,0,5"
						Text           = $lang.Detailed_View
						Tag            = $item.GUID
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Unzip_Custom_Rule_Details_View -GUID $this.Tag
						}
					}

					$UIUnzipPanel_Select_Rule_Menu.controls.AddRange((
						$CheckBox,
						$UI_Main_Rule_Details_View
					))
				}
			} else {
				$UI_Main_Extract_Customize_Rule_Tips_Not = New-Object system.Windows.Forms.Label -Property @{
					autosize       = 1
					Padding        = "18,0,0,0"
					Text           = $lang.RuleCustomizeNot
				}
				$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips_Not)
			}
		} else {
			$UI_Main_Extract_Customize_Rule_Tips_Not = New-Object system.Windows.Forms.Label -Property @{
				autosize       = 1
				Padding        = "18,0,0,0"
				Text           = $lang.RuleCustomizeNot
			}
			$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips_Not)
		}

		$GUIImageSelectInstall_Wrap = New-Object System.Windows.Forms.Label -Property @{
			Height             = 40
			Width              = 460
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($GUIImageSelectInstall_Wrap)
	}

	<#
		蒙板: 提取 ISO
	#>
	$UIUnzipPanel      = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Location       = '0,0'
		Visible        = $False
	}

	<#
		.搜索或匹配
	#>
	$UIUnzipPanelRefresh_ico = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,15"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\search.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = { ISO_Select_Refresh_Sources_List }
	}
	$UIUnzipPanelRefresh = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 210
		Location       = "790,17"
		Text           = $lang.LanguageExtractSearch
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { ISO_Select_Refresh_Sources_List }
	}

	<#
		.功能组
	#>
	$UIUnzip_Search_Show_FULL_Group = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 230
		Width          = 280
		Location       = "764,65"
		autoScroll     = $False
	}

	$UIUnzip_Search_RuleFilter_Show = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 290
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '760,0'
		Visible        = $False
	}
	$UIUnzip_Search_RuleFilter_Hide = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "260,12"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
		Image          = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\hide.ico")
		Cursor         = [System.Windows.Forms.Cursors]::Hand
		add_Click      = {
			$UIUnzip_Search_RuleFilter_Show.visible = $False
		}
	}

	<#
		.筛选规则
	#>
	$UIUnzip_Search_RuleFilter_Label = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 235
		Text           = $lang.LanguageExtractRuleFilter
		Location       = "15,20"
	}
	$UIUnzip_Search_RuleFilter_Apply = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 235
		Text           = $lang.Options
		Location       = "15,80"
	}
	$UIUnzip_Search_RuleFilter_Apply_OtherFile = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 270
		Location       = "35,120"
		Text           = $lang.ISO_Other
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_OtherFile" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_OtherFile" -value "False"
			}

			ISO_Select_Refresh_Sources_List
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_OtherFile" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_OtherFile" -ErrorAction SilentlyContinue) {
			"True" { $UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked = $True }
			"False" { $UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked = $False }
			default {
				$UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked = $True 
			}
		}
	} else {
		Save_Dynamic -regkey "Solutions\ISO" -name "Filter_OtherFile" -value "True"
		$UIUnzip_Search_RuleFilter_Apply_OtherFile.Checked = $True 
	}

	$UIUnzip_Search_RuleFilter_Apply_Language = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 55
		Width          = 240
		Location       = "35,155"
		Text           = "$($lang.Unzip_Language)`n$($lang.Unzip_Fod)"
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_Language" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_Language" -value "False"
			}

			ISO_Select_Refresh_Sources_List
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_Language" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_Language" -ErrorAction SilentlyContinue) {
			"True" { $UIUnzip_Search_RuleFilter_Apply_Language.Checked = $True }
			"False" { $UIUnzip_Search_RuleFilter_Apply_Language.Checked = $False }
			default {
				$UIUnzip_Search_RuleFilter_Apply_Language.Checked = $True 
			}
		}
	} else {
		Save_Dynamic -regkey "Solutions\ISO" -name "Filter_Language" -value "True"
		$UIUnzip_Search_RuleFilter_Apply_Language.Checked = $True 
	}

	$UIUnzip_Search_RuleFilter_Apply_InBoxApps = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 240
		Location       = "35,215"
		Text           = "InBox Apps"
		add_Click      = {
			if ($This.Checked) {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_InBoxApps" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ISO" -name "Filter_InBoxApps" -value "False"
			}

			ISO_Select_Refresh_Sources_List
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_InBoxApps" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Filter_InBoxApps" -ErrorAction SilentlyContinue) {
			"True" { $UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked = $True }
			"False" { $UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked = $False }
			default {
				$UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked = $True 
			}
		}
	} else {
		Save_Dynamic -regkey "Solutions\ISO" -name "Filter_InBoxApps" -value "True"
		$UIUnzip_Search_RuleFilter_Apply_InBoxApps.Checked = $True 
	}

	$UIUnzip_Search_Sift = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 240
		Location       = "30,55"
		Text           = $lang.LanguageExtractRuleFilter
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzip_Search_RuleFilter_Show.visible = $True
		}
	}
	$UIUnzip_Search_Sift_Custon = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 215
		Margin         = "22,0,0,20"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"
		}
	}

	<#
		.显示全部
	#>
	$UIUnzip_Search_Show_Select = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 280
		Text           = $lang.Rule_Show_Full
		add_Click      = { ISO_Select_Refresh_Sources_List }
	}

	<#
		.按规则搜索
	#>
	$UIUnzip_Search_Rule_Select = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 280
		Text           = $lang.Rule_Show_Only
		add_Click      = { ISO_Select_Refresh_Sources_List }
	}
	$UIUnzip_Search_Rule_Show = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "13,0,0,0"
	}
	$UIUnzip_Search_Rule_Show_Select_Custom = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 280
		Text           = $lang.Rule_Show_Only_Select
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Text = $lang.Rule_Show_Only_Select
			$UIUnzipPanel_Select_Rule_MenuMsg_Icon.Image = $null
			$UIUnzipPanel_Select_Rule_MenuMsg.Text = ""

			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $True            # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面
		}
	}

	<#
		.初始化选择
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Is_Unzip_Rule" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ISO" -Name "Is_Unzip_Rule" -ErrorAction SilentlyContinue) {
			"ShowAll" { $UIUnzip_Search_Show_Select.Checked = $True }
			"Select" { $UIUnzip_Search_Rule_Select.Checked = $True }
			default {
				$UIUnzip_Search_Show_Select.Checked = $True 
			}
		}
	} else {
		$UIUnzip_Search_Show_Select.Checked = $True 
	}

	$UIUnzipPanelErrorMsg_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,308"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UIUnzipPanelErrorMsg = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 140
		Width          = 250
		Location       = "789,310"
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.弹出所有已挂载 Iso
	#>
	$UI_Main_Eject_Cdrom_Click = {
		$UIUnzipPanelErrorMsg.Text = ""
		$UIUnzipPanelErrorMsg_Icon.Image = $null
		$UIUnzipPanelErrorMsg.ForeColor = "#000000"

		Get-Volume | Where-Object DriveType -eq 'CD-ROM' | ForEach-Object {
			Get-DiskImage -DevicePath $_.Path.trimend('\') -ErrorAction SilentlyContinue | ForEach-Object {
				DisMount-DiskImage -ImagePath $_.ImagePath
			}
		}

		$UIUnzipPanelErrorMsg.Text = "$($lang.Eject_Cdrom), $($lang.Done)"
		$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
	}
	$UI_Main_Eject_Cdrom_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,480"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Eject.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Main_Eject_Cdrom_Click
	}
	$UI_Main_Eject_Cdrom = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,482"
		Text           = $lang.Eject_Cdrom
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Eject_Cdrom_Click
	}

	$UI_Main_Eject_Click = {
			<#
				.判断是否选择文件, 空白
			#>
			if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
				$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				return
			}

			<#
				.判断文件是否存在
			#>
			if (Test-Path -Path $UIUnzipPanel_To_Path.Text -PathType leaf) {
				<#
					.判断是否已挂载
				#>
				$ImagePath = $UIUnzipPanel_To_Path.Text

				<#
					.判断是否已挂载
				#>
				$ISODrive = (Get-DiskImage -ImagePath $ImagePath -ErrorAction SilentlyContinue | Get-Volume).DriveLetter
				if ($ISODrive) {
					$ISODrive = (Get-DiskImage -ImagePath $ImagePath | Get-Volume).DriveLetter
					$UIUnzipPanelErrorMsg.Text = "$($lang.Done): $($lang.Eject), $($ISODrive):\"
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")

					DisMount-DiskImage -ImagePath $ImagePath
				} else {
					$UIUnzipPanelErrorMsg.Text = $lang.NotMounted
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			} else {
				$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($UIUnzipPanel_To_Path.Text)"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				return
			}
		}
	$UI_Main_Eject_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,520"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Eject.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Main_Eject_Click
	}
	$UI_Main_Eject     = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,522"
		Text           = $lang.Eject
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Eject_Click
	}

	$UI_Main_Mount_Click = {
		<#
			.判断是否选择文件, 空白
		#>
		if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.判断文件是否存在
		#>
		if (Test-Path -Path $UIUnzipPanel_To_Path.Text -PathType leaf) {
			<#
				.判断是否已挂载
			#>
			$ImagePath = $UIUnzipPanel_To_Path.Text

			<#
				.判断是否已挂载
			#>
			$ISODrive = (Get-DiskImage -ImagePath $ImagePath -ErrorAction SilentlyContinue | Get-Volume).DriveLetter
			if ($ISODrive) {
				$UIUnzipPanelErrorMsg.Text = $lang.Mounted
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				Mount-DiskImage -ImagePath $ImagePath -StorageType ISO

				$ISODrive = (Get-DiskImage -ImagePath $ImagePath | Get-Volume).DriveLetter
				$UIUnzipPanelErrorMsg.Text = "$($lang.Mounted_Status): $($lang.Mounted)`n`n$($lang.MountImageTo): $($ISODrive):\"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			}
		} else {
			$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($UIUnzipPanel_To_Path.Text)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}
	}
	$UI_Main_Mount_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,560"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\iso.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UI_Main_Mount_Click
	}
	$UI_Main_Mount     = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,562"
		Text           = $lang.Mount
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Mount_Click
	}

	$UIUnzipPanelOK_Click = {
		$UIUnzipPanelErrorMsg.Text = ""
		$UIUnzipPanelErrorMsg_Icon.Image = $null
		$UIUnzipPanelErrorMsg.ForeColor = "#000000"
		$UIUnzipPanel_To_New_Path.BackColor = "#FFFFFF"

		$Full_New_Path = Join-Path -Path $UIUnzipPanel_To_New_Sources.Text -ChildPath $UIUnzipPanel_To_New_Path.Text

		<#
			.优先判断目录是否可读写
		#>
		if (Test_Available_Disk -Path $UIUnzipPanel_To_New_Sources.Text) {
		} else {
			$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.Inoperable) ( $($UIUnzipPanel_To_New_Sources.Text) )"
			$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.判断是否选择文件, 空白
		#>
		if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.判断文件是否存在
		#>
		if (Test-Path -Path $UIUnzipPanel_To_Path.Text -PathType leaf) {

		} else {
			$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($UIUnzipPanel_To_Path.Text)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.判断目录
		#>
		<#
			.Judgment: 1. Null value
			.判断: 1. 空值
		#>
		if ([string]::IsNullOrEmpty($UIUnzipPanel_To_New_Path.Text)) {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断: 2. 前缀不能带空格
		#>
		if ($UIUnzipPanel_To_New_Path.Text -match '^\s') {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		}

		<#
			.Judgment: 3. No spaces at the end
			.判断: 3. 后缀不能带空格
		#>
		if ($UIUnzipPanel_To_New_Path.Text -match '\s$') {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		}

		<#
			.Judgment: 4. There can be no two spaces in between
			.判断: 4. 中间不能含有二个空格
		#>
		if ($UIUnzipPanel_To_New_Path.Text -match '\s{2,}') {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		}

		<#
			.Judgment: 5. Cannot contain: \\ /: *? "" <> |
			.判断: 5, 不能包含: \\ / : * ? "" < > |
		#>
		if ($UIUnzipPanel_To_New_Path.Text -match '[~#$@!%&*{}<>?/|+"]') {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		}

		<#
			.判断是否有旧目录
		#>
		if (Test-Path -Path $Full_New_Path -PathType Container) {
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			$UIUnzipPanelErrorMsg.Text = "$($lang.Existed): $($Full_New_Path)"
			$UIUnzipPanel_To_New_Path.BackColor = "LightPink"
			return
		} else {
			<#
				.开始解压 ISO
			#>
			$Verify_Install_Path = Get_Zip -Run "7zG.exe"
			if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
				$UIUnzipPanelErrorMsg.Text = "$($lang.UpdateUnpacking): `n$($UIUnzipPanel_To_Path.Text)`n`n$($lang.SaveTo): `n$($Full_New_Path)`n`n$($lang.UpdateUnpacking)"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")

				$Arguments = @(
					"x",
					"""$($UIUnzipPanel_To_Path.Text)""",
					"-o""$($Full_New_Path)""",
					"-y"
				)

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Start-Process -FilePath '$($Verify_Install_Path)' -ArgumentList '$($Arguments)'" -ForegroundColor Green
					Write-Host "  $('-' * 80)"
				}

				Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -WindowStyle Minimized
			} else {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.SoftIsInstl -f "7-Zip")"
			}
		}
	}
	$UIUnzipPanelOK_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,600"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\extract.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $UIUnzipPanelOK_Click
	}
	$UIUnzipPanelOK    = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,602"
		Text           = $lang.Unzip_ISO
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UIUnzipPanelOK_Click
	}

	$UI_Main_Unzip_DragDrop = {
		$UIUnzipPanelErrorMsg.Text = ""
		$UIUnzipPanelErrorMsg_Icon.Image = $null
		$UIUnzipPanelErrorMsg.ForeColor = "#000000"
		$UIUnzipPanel_SHA256_Calibration.Text = "SHA-256: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA256_Calibration.Name = ""

		$UIUnzipPanel_SHA512_Calibration.Text = "SHA-512: $($lang.ImageCodenameNo)"
		$UIUnzipPanel_SHA512_Calibration.Name = ""

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
				$types = [IO.Path]::GetExtension($filename)
				if ($Global:SearchISOType -contains "*$($types)") {
					$UIUnzipPanel_To_Path.Text = $filename
					$UIUnzipPanel_To_New_Path.Text = [System.IO.Path]::GetFileNameWithoutExtension($filename)
					Refresh_ISO_CRC_SHA

					$UIUnzipPanelErrorMsg.Text = "$($lang.Choose): $($filename), $($lang.Done)"
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.PleaseChoose) ( $($Global:SearchISOType) )"
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	$UIUnzipPanelHide_ICO = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "764,635"
		Height         = 22
		Width          = 22
		SizeMode       = "StretchImage"
		Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Hide.ico")
		Cursor = [System.Windows.Forms.Cursors]::Hand
		add_Click      = $GUIImageSourceSetting_Click
	}
	$UIUnzipPanelHide  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 255
		Location       = "790,638"
		Text           = $lang.Hide
		LinkColor      = "#000000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if ($Page) {
				$UI_Main.Close()
			} else {
				$UI_Main.Text = $lang.SelectSettingImage
				Image_Select_Refresh_Sources_List

				$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
				$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
				$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
				$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
				$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
				$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
				$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
				$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
				$UI_Main_Image_Sources.visible = $True               # 设置主界面

				$UI_Main.remove_DragDrop($UI_Main_Unzip_DragDrop)
				$UI_Main.Add_DragDrop($UI_Main_DragDrop)
			}
		}
	}

	<#
		.搜索 ISO 来源, 显示菜单
	#>
	$UIUnzipPanel_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 650
		Width          = 695
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Dock           = 3
		Padding        = 15
	}

	$UIUnzipPanel_Menu_Sources = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 655
		Text           = $lang.Unzip_Search_Type -f $SearchISOType
	}

	$UIUnzipPanel_Menu_Sources_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 620
		Margin         = "25,0,0,20"
		Text           = ""
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanel_To_New_Path.BackColor = "#FFFFFF"
		}
	}

	<#
		.事件: 搜索 ISO 来源, 选择目录
	#>
	$UIUnzipPanel_Menu_Sources_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 655
		Padding        = "20,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				$UIUnzipPanel_Menu_Sources_Path.Text = $FolderBrowser.SelectedPath

				if (Test-Path -Path $UIUnzipPanel_Menu_Sources_Path.Text -PathType Container) {
					$UIUnzipPanel_Menu_Sources_Path.Enabled = $True
				} else {
					$UIUnzipPanel_Menu_Sources_Path.Enabled = $False
				}

				ISO_Select_Refresh_Sources_List
			} else {
				$UIUnzipPanelErrorMsg.Text = $lang.UserCanel
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	<#
		.事件: 搜索 ISO 来源, 打开目录
	#>
	$UIUnzipPanel_Menu_Sources_Open = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 655
		Padding        = "20,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null


			if ([string]::IsNullOrEmpty($UIUnzipPanel_Menu_Sources_Path.Text)) {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.OpenFolder): $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $UIUnzipPanel_Menu_Sources_Path.Text -PathType Container) {
					Start-Process $UIUnzipPanel_Menu_Sources_Path.Text

					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UIUnzipPanelErrorMsg.Text = "$($lang.OpenFolder): $($UIUnzipPanel_Menu_Sources_Path.Text), $($lang.Done)"
				} else {
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UIUnzipPanelErrorMsg.Text = "$($lang.OpenFolder): $($UIUnzipPanel_Menu_Sources_Path.Text), $($lang.Inoperable)"
				}
			}
		}
	}

	<#
		.事件: 搜索 ISO 来源, 打开目录
	#>
	$UIUnzipPanel_Menu_Sources_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 655
		Padding        = "20,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($UIUnzipPanel_Menu_Sources_Path.Text)) {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UIUnzipPanel_Menu_Sources_Path.Text

				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.事件: 搜索 ISO 来源, 恢复默认
	#>
	$UIUnzipPanel_Menu_Sources_Reset = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 655
		Padding        = "20,0,0,0"
		Text           = $lang.Image_Restore_Default
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			ISO_Select_Refresh_Sources_List

			$UIUnzipPanelErrorMsg.Text = "$($lang.Image_Restore_Default), $($lang.Done)"
			$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	<#
		.选择源文件
	#>
	$UIUnzipPanel_To = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 658
		margin          = "0,30,0,0"
		Text           = $lang.SelFile
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "ISO Files (*.iso)|*.iso"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$UIUnzipPanel_To_Path.Text = $FileBrowser.FileName
				$UIUnzipPanel_To_New_Path.Text = [System.IO.Path]::GetFileNameWithoutExtension($FileBrowser.FileName)
				Refresh_ISO_CRC_SHA
			} else {
				$UIUnzipPanelErrorMsg.Text = $lang.UserCanel
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	<#
		.托动文件: 提示
	#>
	$UIUnzipPanel_To_Path_Select_Tips = New-Object System.Windows.Forms.Label -Property @{
		Height          = 35
		Width           = 660
		Text            = $lang.DropFile
		Padding         = "16,0,0,0"
	}

	$UIUnzipPanel_To_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 620
		Margin         = "20,0,0,20"
		Text           = ""
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
		}
	}

	$UIUnzipPanel_To_Path_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height          = 40
		Width           = 655
		Padding         = "16,0,0,0"
		Text            = $lang.Paste
		LinkColor       = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior    = "NeverUnderline"
		add_Click       = {
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"

			if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UIUnzipPanel_To_Path.Text

				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.稀哈
	#>
	$UIUnzipPanel_Sparse = New-Object System.Windows.Forms.Label -Property @{
		Height          = 40
		Width           = 655
		Padding        = "16,0,0,0"
		Text            = $lang.Sparse
	}

	<#
		.校验
	#>
	$UIUnzipPanel_SHA256_Calibration = New-Object system.Windows.Forms.LinkLabel -Property @{
		Name           = ""
		autosize       = 1
		Padding        = "35,0,0,0"
		Text           = "SHA-256: $($lang.ImageCodenameNo)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanel_SHA256_Calibration.Enabled = $False
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"

			if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
				$UIUnzipPanel_To_Path.BackColor = "LightPink"
				$UIUnzipPanel_SHA256_Calibration.Enabled = $True
				return
			}

			if (Test-Path -Path $UIUnzipPanel_To_Path.Text -PathType leaf) {
				$calchash = (Get-FileHash -Path $UIUnzipPanel_To_Path.Text -Algorithm SHA256)

				if ([string]::IsNullOrEmpty($UIUnzipPanel_SHA256_Calibration.Name)) {
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
					$UIUnzipPanelErrorMsg.Text += "SHA-256: $($calchash.Hash)`n`n"

					<#
						.已知 SHA256 未获取到, 从所有已知列表里获取
					#>
					foreach ($item in $Script:Known_MSDN) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA256 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA256_Calibration.Enabled = $True
								return
							}
						}
					}

					foreach ($item in $Script:Exclude_Fod_Or_Language) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA256 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA256_Calibration.Enabled = $True
								return
							}
						}
					}

					foreach ($item in $Script:Exclude_InBox_Apps) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA256 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA256_Calibration.Enabled = $True
								return
							}
						}
					}

					$UIUnzipPanelErrorMsg.Text += "$($lang.CRCSHA), $($lang.Done)`n"
				} else {
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UIUnzipPanelErrorMsg.Text += "$($lang.CRCSHA): SHA-256: $($UIUnzipPanel_SHA256_Calibration.Name)`n`nSHA256: $($calchash.Hash)`n`n"

					<#
						.快速匹配已知和当前获取的新 SHA-256
					#>
					if ($calchash.Hash -eq $UIUnzipPanel_SHA256_Calibration.Name) {
						$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$UIUnzipPanelErrorMsg.ForeColor = "#008000"
					} else {
						<#
							.快速匹配失败, 从所有已知列表里获取
						#>
						foreach ($item in $Script:Known_MSDN) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA256 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA256_Calibration.Enabled = $True
									return
								}
							}
						}

						foreach ($item in $Script:Exclude_Fod_Or_Language) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA256 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA256_Calibration.Enabled = $True
									return
								}
							}
						}

						foreach ($item in $Script:Exclude_InBox_Apps) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA256 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA256_Calibration.Enabled = $True
									return
								}
							}
						}

						$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Failed)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzipPanelErrorMsg.ForeColor = "#FF0000"
					}
				}
			} else {
				$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($calchash.Hash)"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}

			$UIUnzipPanel_SHA256_Calibration.Enabled = $True
		}
	}
	$UIUnzipPanel_SHA256_Calibration_Wrap = New-Object System.Windows.Forms.Label -Property @{
		Height             = 25
		Width              = 655
	}

	<#
		.校验
	#>
	$UIUnzipPanel_SHA512_Calibration = New-Object system.Windows.Forms.LinkLabel -Property @{
		Name           = ""
		autoSize       = 1
		Padding        = "35,0,0,0"
		Text           = "SHA-512: $($lang.ImageCodenameNo)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanel_SHA512_Calibration.Enabled = $False
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"

			if ([string]::IsNullOrEmpty($UIUnzipPanel_To_Path.Text)) {
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UIUnzipPanelErrorMsg.Text = "$($lang.SelectFromError): $($lang.SelFile)"
				$UIUnzipPanel_To_Path.BackColor = "LightPink"
				$UIUnzipPanel_SHA512_Calibration.Enabled = $True
				return
			}

			if (Test-Path -Path $UIUnzipPanel_To_Path.Text -PathType leaf) {
				$calchash = (Get-FileHash -Path $UIUnzipPanel_To_Path.Text -Algorithm SHA512)

				if ([string]::IsNullOrEmpty($UIUnzipPanel_SHA512_Calibration.Name)) {
					$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Info.ico")
					$UIUnzipPanelErrorMsg.Text += "SHA-512: $($calchash.Hash)`n`n"

					<#
						.已知 SHA512 未获取到, 从所有已知列表里获取
					#>
					foreach ($item in $Script:Known_MSDN) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA512 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA512_Calibration.Enabled = $True
								return
							}
						}
					}

					foreach ($item in $Script:Exclude_Fod_Or_Language) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA512 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA512_Calibration.Enabled = $True
								return
							}
						}
					}
					
					foreach ($item in $Script:Exclude_InBox_Apps) {
						foreach ($CRCSHA in $item.CRCSHA) {
							if ($CRCSHA.SHA512 -eq $calchash.Hash) {
								$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
								$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
								$UIUnzipPanelErrorMsg.ForeColor = "#008000"
								$UIUnzipPanel_SHA512_Calibration.Enabled = $True
								return
							}
						}
					}

					$UIUnzipPanelErrorMsg.Text += "$($lang.CRCSHA), $($lang.Done)`n"
				} else {
					$UIUnzipPanelErrorMsg.Text += "$($lang.CRCSHA): SHA-512: $($UIUnzipPanel_SHA512_Calibration.Name)`n`nSHA512: $($calchash.Hash)`n`n"

					<#
						.快速匹配已知和当前获取的新 SHA-512
					#>
					if ($calchash.Hash -eq $UIUnzipPanel_SHA512_Calibration.Name) {
						$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
						$UIUnzipPanelErrorMsg.ForeColor = "#008000"
					} else {
						<#
							.快速匹配失败, 从所有已知列表里获取
						#>
						foreach ($item in $Script:Known_MSDN) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA512 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA512_Calibration.Enabled = $True
									return
								}
							}
						}

						foreach ($item in $Script:Exclude_Fod_Or_Language) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA512 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA512_Calibration.Enabled = $True
									return
								}
							}
						}

						foreach ($item in $Script:Exclude_InBox_Apps) {
							foreach ($CRCSHA in $item.CRCSHA) {
								if ($CRCSHA.SHA512 -eq $calchash.Hash) {
									$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Done)"
									$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
									$UIUnzipPanelErrorMsg.ForeColor = "#008000"
									$UIUnzipPanel_SHA512_Calibration.Enabled = $True
									return
								}
							}
						}

						$UIUnzipPanelErrorMsg.Text += "$($lang.MatchMode), $($lang.Failed)"
						$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UIUnzipPanelErrorMsg.ForeColor = "#FF0000"
					}
				}
			} else {
				$UIUnzipPanelErrorMsg.Text = "$($lang.NoInstallImage): $($calchash.Hash)"
				$UIUnzipPanelErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}

			$UIUnzipPanel_SHA512_Calibration.Enabled = $True
		}
	}
	$UIUnzipPanel_SHA512_Calibration_Wrap = New-Object System.Windows.Forms.Label -Property @{
		Height             = 25
		Width              = 655
	}

	<#
		.解压已选择的文件到
	#>
	$UIUnzipPanel_To_New = New-Object System.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 658
		Text           = $lang.SaveTo
		margin         = "0,30,0,0"
	}
	$UIUnzipPanel_To_New_Sources = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 655
		Padding        = "20,0,5,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			if ([string]::IsNullOrEmpty($this.Text)) {

			} else {
				if (Test-Path -Path $this.Text -PathType Container) {
					Start-Process $this.Text
				}
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
		$UIUnzipPanel_To_New_Sources.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue
	}
	$UIUnzipPanel_To_New_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 620
		Margin         = "25,0,0,20"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UIUnzipPanel_To_New_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.Text = ""
			$UIUnzipPanelErrorMsg_Icon.Image = $null
			$UIUnzipPanel_To_Path.BackColor = "#FFFFFF"
			$UIUnzipPanelErrorMsg.ForeColor = "#000000"
		}
	}
	$UIUnzipPanel_To_New_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.VerifyNameTips
		Padding        = "22,0,0,0"
	}

	<#
		.搜索 ISO 来源, 选择来源
	#>
	$UIUnzip_Select_Sources = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "0,15,0,15"
		margin         = "0,35,0,0"
	}
	$UIUnzipPanel_Menu_Wrap = New-Object System.Windows.Forms.Label -Property @{
		Height             = 30
		Width              = 645
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "15,640"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "40,642"
		Height         = 30
		Width          = 655
		Text           = ""
	}

	$UI_Main_Ok        = New-Object system.Windows.Forms.Button -Property @{
		TabIndex       = 4
		UseVisualStyleBackColor = $True
		Location       = "764,180"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		Visible        = $False
		add_Click      = {
			$UI_Main_Select_Sources.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					#region 已选择
					if ($_.Checked) {
						$UI_Main.Hide()

						$Global:Image_source = $_.Name
						$Global:MainImage = $_.Tag

						$Global:Mount_To_Route = $GUIImageSourceGroupMountToShow.Text
						Write-Host "`n  $($lang.MountImageTo), $($lang.MainImageFolder)"
						Write-Host "  $($Global:Mount_To_Route)" -ForegroundColor Yellow

						<#
							.刷新全局规则
						#>
						Image_Refresh_Init_GLobal_Rule

						Write-Host "`n  $($lang.MainImageFolder)"
						Write-Host "  $($Global:Image_source)" -ForegroundColor Yellow

						$Verify_Select_Key_New = ""
						if ($UI_Primary_Key_Name.Checked) {
							$UI_Primary_Key_Select.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.RadioButton]) {
									if ($_.Enabled) {
										if ($_.Checked) {
											$Verify_Select_Key_New = $_.Tag
										}
									}
								}
							}

							if ([string]::IsNullOrEmpty($Verify_Select_Key_New)) {
								$Global:Primary_Key_Image = @()
								$Global:Save_Current_Default_key = ""
							} else {
								Image_Set_Global_Primary_Key -Uid $Verify_Select_Key_New -Silent -Detailed -DevCode "26"
							}
						} else {
							$Global:Primary_Key_Image = @()
							$Global:Save_Current_Default_key = ""
						}

						Write-Host
						Image_Get_Mount_Status

						$Global:Mount_To_RouteTemp = $GUIImageSourceGroupMountToTempShow.Text
						Write-Host "`n  $($lang.SettingImageTempFolder): " -NoNewline -ForegroundColor Yellow
						Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Green

						Write-Host 
						Write-Host "  $($lang.Detailed)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"

						Save_Dynamic -regkey "Solutions\ImageSources\$($_.Tag)" -name "language" -value $Global:MainImageLang
						Write-Host "  $($lang.Language): " -NoNewline -ForegroundColor Yellow
						Write-Host " $($Global:MainImageLang) " -BackgroundColor DarkGreen -ForegroundColor White

						Write-Host "  $($lang.SelLabel): " -NoNewline -ForegroundColor Yellow
						if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($_.Tag)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
							$Get_Version_MVS = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($_.Tag)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue
							Write-Host " $($Get_Version_MVS) " -BackgroundColor DarkGreen -ForegroundColor White
						} else {
							Write-Host " $($lang.ImageCodenameNo) " -BackgroundColor DarkRed -ForegroundColor White
						}

						Write-Host "  $($lang.ImageLevel): " -NoNewline -ForegroundColor Yellow
						if ($GUISelectTypeDesktop.Checked) {
							$Global:ImageType = "Desktop"
							Write-Host " $($GUISelectTypeDesktop.Text) " -BackgroundColor DarkGreen -ForegroundColor White
						}
						if ($GUISelectTypeServer.Checked) {
							$Global:ImageType  = "Server"
							Write-Host " $($GUISelectTypeServer.Text) " -BackgroundColor DarkGreen -ForegroundColor White
						}
						Save_Dynamic -regkey "Solutions\ImageSources\$($_.Tag)" -name "ImageType" -value $Global:ImageType

						if ($GUIImageSourceArchitectureARM64.Checked) { $Global:Architecture = "arm64" }
						if ($GUIImageSourceArchitectureAMD64.Checked)   { $Global:Architecture  = "AMD64" }
						if ($GUIImageSourceArchitectureX86.Checked)   { $Global:Architecture  = "x86" }
						Save_Dynamic -regkey "Solutions\ImageSources\$($_.Tag)" -name "Architecture" -value $Global:Architecture

						Write-Host "  $($lang.Architecture): " -NoNewline -ForegroundColor Yellow
						Write-Host " $($Global:Architecture) " -BackgroundColor DarkGreen -ForegroundColor White

						Write-Host
						Write-Host "  $($lang.IsAllowDevMode): " -NoNewline -ForegroundColor Yellow
						if ($GUIImageSourceSettingIsAllowDevMode.Checked) {
							$Global:Developers_Mode = $True
							Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White
						} else {
							$Global:Developers_Mode = $False
							Write-Host " $($lang.AfterFinishingNoProcess) " -BackgroundColor DarkRed -ForegroundColor White
						}

						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "MountToRouting" -value $Global:Mount_To_Route
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "MountToRoutingTemp" -value $Global:Mount_To_RouteTemp

						Additional_Edition_Reset
						Event_Reset_Variable -Init "Yes"

						$UI_Main.Close()

						Refresh_Eject_Abandon_Compatibility

						Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						if ([string]::IsNullOrEmpty($UI_Main_To.SelectedItem.Path)) {
							Write-Host "  $($lang.Ok_Go_To_No)" -ForegroundColor Red
						} else {
							Write-Host "  $($UI_Main_To.SelectedItem.Lang)" -ForegroundColor Green

							Foreach ($item in $UI_Main_To.SelectedItem.Path) {
								Invoke-Expression -Command $item
							}
						}

						ToWait -wait 2
						Mainpage
					}
					#endregion 已选择
				}
			}

			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoSelectImageSource)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	$UI_Main_To        = New-Object system.Windows.Forms.ComboBox -Property @{
		TabIndex       = 5
		Height         = 30
		Width          = 278
		Location       = "765,225"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Visible        = $False
		Add_SelectedValueChanged = {
		}
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.主键项
	#>
	$UI_Primary_Key_Group = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 415
		Width          = 280
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Location       = "764,260"
		Visible        = $False
	}
	$UI_Primary_Key_Name = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 270
		Text           = $lang.Sel_Primary_Key
		add_Click      = {
			if ($This.Checked) {
				$UI_Primary_Key_Select.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "IsSelectPKY" -value "True"
			} else {
				$UI_Primary_Key_Select.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)" -name "IsSelectPKY" -value "False"
			}
		}
	}

	$UI_Primary_Key_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "14,0,0,0"
	}

	$UI_Main.controls.AddRange((
		<#
			.蒙板: 设置 API
		#>
		$GUIImageSourceGroupAPI,

		<#
			.蒙板: 设置界面
		#>
		$GUIImageSourceGroupSetting,

		<#
			.蒙板: 更改挂载到
		#>
		$UI_Mask_Image_Mount_To,

		<#
			.蒙板: 更改 ISO 挂载的映像主语言
		#>
		$UI_Mask_Image_Language,

		<#
			.蒙板: 解压 ISO, 显示详细规则
		#>
		$UI_Main_View_Detailed,

		<#
			.蒙板: 解压 ISO, 选择规则
		#>
		$UIUnzipPanel_Select_Rule,

		<#
			.蒙板: 解压 ISO
		#>
		$UIUnzipPanel,

		<#
			.蒙板: 其它信息
		#>
		$GUIImageSourceGroupOtherPanel,

		$UI_Main_Image_Sources
	))

	<#
		.主界面蒙板
	#>
	$UI_Main_Image_Sources.controls.AddRange((
		$UI_Main_Image_Sources_Menu_Show,
		$UI_Main_Image_Sources_Menu,

		<#
			.按钮: 解压 ISO
		#>
		$UIUnzip_ICO,
		$UIUnzip,

		<#
			.按钮: 设置
		#>
		$GUIImageSourceSetting_ICO,
		$GUIImageSourceSetting,

		<#
			.动态显示: 选择 ISO 来源
		#>
		$UI_Main_Select_Sources,

		<#

			.动态显示: 挂载到
		#>
		$GUIImageSourceGroupMount,

		<#
			.动态显示: 更改语言
		#>
		$GUIImageSourceGroupLang,

		<#
			.动态显示: 详细
		#>
		$GUIImageSourceGroupOther,

		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Ok,
		$UI_Main_To,

		<#
			.动态显示: ISO 目录下的 Install, Boot
		#>
		$UI_Primary_Key_Group

	))
	$UI_Main_Image_Sources_Menu_Show.controls.AddRange((
		$UI_Main_Image_Sources_Menu_Hide,
		$GUIImageSourceSetting_Menu_Ico,
		$GUIImageSourceSetting_Menu,
			$GUIImageSourceSetting_Menu_Capture,      # 捕获
			$GUIImageSourceSetting_Menu_Tempate,      # 创建模板
			$GUIImageSourceSetting_Menu_Unpack       # 打包
	))

	$GUIImageSourceGroupAPI.controls.AddRange((
		$GUIImageSourceGroupAPI_Shortcut_Name,
		$GUIImageSourceGroupAPI_Shortcut_Panel,
		$GUIImageSourceGroupAPI_Shortcut_Panel_Backup,
		$GUIImageSourceGroupAPI_Shortcut_Panel_Restore,
		$GUIImageSourceGroupAPI_Shortcut_Panel_Refresh,
		$GUIImageSourceGroupAPI_Shortcut_Clear_Select,
		$GUIImageSourceGroupAPISetting_Learn,
		$GUIImageSourceGroupAPISettingPanel,
		$GUIImageSourceGroupAPIErrorMsg_Icon,
		$GUIImageSourceGroupAPIErrorMsg,
		$GUIImageSourceGroupAPI_Change_ICO,
		$GUIImageSourceGroupAPI_Change,
		$GUIImageSourceGroupAPI_Add_ICO,
		$GUIImageSourceGroupAPI_Add,
		$GUIImageSourceGroupAPI_Hide_ICO,
		$GUIImageSourceGroupAPI_Hide
	))
	$GUIImageSourceGroupAPISettingPanel.controls.AddRange((
		$GUIImageSourceGroupAPI_Adv,
		$GUIImageSourceGroupAPI_New_No_Import,
		$GUIImageSourceGroupAPI_New_Path_IsCheck,
		$GUIImageSourceGroupAPI_Adv_Wrap,
		$GUIImageSourceGroupAPI_New_Rule_Name,
		$GUIImageSourceGroupAPI_Rule_Path,
		$GUIImageSourceGroupAPI_Rule_Path_Tips,
		$GUIImageSourceGroupAPI_New_Rule_Name_Wrap,
		$GUIImageSourceGroupAPI_New_Path_Name,
		$GUIImageSourceGroupAPI_New_Path,
		$GUIImageSourceGroupAPI_New_Path_Tips,
		$GUIImageSourceGroupAPI_New_Path_Select,
		$GUIImageSourceGroupAPI_New_Path_Select_Tips,
		$GUIImageSourceGroupAPI_New_Path_OpenFile,
		$GUIImageSourceGroupAPI_New_Path_Paste
	))

	$UI_Primary_Key_Group.controls.AddRange((
		$UI_Primary_Key_Name,
		$UI_Primary_Key_Select
	))
	$GUIImageSourceGroupSetting.controls.AddRange((
		$GUIImageSourceGroupSettingPanel,
		$GUIImageSourceSettingGroupAll,
		$GUIImageSourceGroupSettingErrorMsg_Icon,
		$GUIImageSourceGroupSettingErrorMsg,
		$GUIImageSourceGroupSetting_Save_ICO,
		$GUIImageSourceGroupSetting_Save,
		$GUIImageSourceGroupSetting_Hide_ICO,
		$GUIImageSourceGroupSetting_Hide
	))
	$GUIImageSourceGroupSettingPanel.controls.AddRange((
		$GUIImageSourceGroupSettingDiskTips,
		$GUIImageSourceGroupSettingStructure,
		$GUIImageSourceGroupSettingCustomizeShow,
		$GUIImageSourceGroupSettingCustomizeTips,
		$GUIImageSourceGroupSettingDefenderAdd,
		$GUIImageSourceGroupSettingDefenderAddTips,
		$GUIImageSourceGroupSettingSelectDISK,
		$GUIImageSourceGroupSettingSize,
		$GUIImageSourceGroupSettingSizeChange,
		$GUIImageSourceGroupSettingDiskSelect,
		$GUIImageSourceGroupSettingDisk,
		$UI_Other_Path,
		$UI_Other_Path_Add,
		$UI_Other_Path_Clear_Select,
		$UI_Other_Path_Clear,
		$UI_Other_Path_Show
	))
	$GUIImageSourceGroupSettingSizeChange.controls.AddRange((
		$GUIImageSourceGroupSettingLowSize,
		$GUIImageSourceGroupSettingLowUnit
	))
	$GUIImageSourceSettingGroupAll.controls.AddRange((
		<#
			.语言, 更改, 显示当前首选语言
		#>
		$GUIImageSourceSettingLP,
		$GUIImageSourceSettingLP_Change,

		<#
			.当前版本
		#>
		$GUIImageSourceSettingUP,
		$GUIImageSourceSettingUPCurrentVersion,
		$GUIImageSourceSettingUP_Auto,
		$GUIImageSourceSettingUP_Auto_Adv,

		<#
			.显示 API 设置界面
		#>
		$GUIImageSourceSettingDev,
		$GUIImageSourceSettingIsAllowDevMode,         # 允许一直使用开发者模式

		$GUIImageSourceSettingAPI,
			$GUIImageSourceSettingAPI_Setting,        # 设置 API
			$GUIImageSourceSettingAPI_Learn
	))

	#region Allow Auto Update
	$GUIImageSourceSettingUP_Auto_Adv.controls.AddRange((
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting,
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Time,
		$GUIImageSourceSettingUP_Auto_Update_New_Allow,
		$GUIImageSourceSettingUP_Auto_Update_Clean
	))

	<#
		.允许自动更新
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
			"True"  {
				$GUIImageSourceSettingUP_Auto.Checked = $True
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
			}
			"False" {
				$GUIImageSourceSettingUP_Auto.Checked = $False
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $False
			}
		}
	} else {
		Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdate" -value "True"
		$GUIImageSourceSettingUP_Auto.Checked = $True
		$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
	}

	<#
		.允许自动清理旧版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
			"True"  { $GUIImageSourceSettingUP_Auto_Update_Clean.Checked = $True }
			"False" { $GUIImageSourceSettingUP_Auto_Update_Clean.Checked = $False }
		}
	} else {
		$GUIImageSourceSettingUP_Auto_Update_Clean.Checked = $True
		Save_Dynamic -regkey "Solutions\Update" -name "IsUpdate_Clean_Allow" -value "True"
	}

	<#
		.允许自动更新新版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
			"True"  { $GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $True }
			"False" { $GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $False }
		}
	} else {
		$GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $True
		Save_Dynamic -regkey "Solutions\Update" -name "IsAutoUpdateNew" -value "True"
	}

	<#
		.自动检查更新间隔小时
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue) {
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting.Value = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue
	} else {
		Save_Dynamic -regkey "Solutions\Update" -name "AutoCheckUpdate_Hours" -value "2"
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting.Value = 2
	}
	#endregion

	$API_Learn_Path = "$($PSScriptRoot)\..\..\..\..\..\..\_Learn\API"
	$ApiDocx = "$($API_Learn_Path)\Api.docx"
	if (Test-Path -Path $ApiDocx -PathType leaf) {
		$ApiDocx = Convert-Path -Path $ApiDocx -ErrorAction SilentlyContinue
		$NewApiDocx        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 435
			Padding        = "35,0,0,0"
			Text           = "Api.docx"
			Tag            = $ApiDocx
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Leaf) {
						Start-Process $This.Tag

						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Inoperable)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}
		$GUIImageSourceSettingGroupAll.controls.AddRange($NewApiDocx)

		$NewApiDocx        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 75
			Location       = '380,620'
			Text           = "Api.docx"
			Tag            = $ApiDocx
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Leaf) {
						Start-Process $This.Tag

						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Inoperable)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}
		$GUIImageSourceGroupAPI.controls.AddRange($NewApiDocx)
	} else {
		$NewApiDocx        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 435
			Padding        = "35,0,0,0"
			Text           = "Api.docx"
			Tag            = "https://github.com/ilikeyi/Solutions/blob/main/_Learn/API/API.docx"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					Start-Process $This.Tag
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
		$GUIImageSourceSettingGroupAll.controls.AddRange($NewApiDocx)

		$NewApiDocx        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 75
			Location       = '380,620'
			Text           = "Api.docx"
			Tag            = "https://github.com/ilikeyi/Solutions/blob/main/_Learn/API/API.docx"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					Start-Process $This.Tag
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
		$GUIImageSourceGroupAPI.controls.AddRange($NewApiDocx)
	}

	$ApiPdf = "$($API_Learn_Path)\Api.pdf"
	if (Test-Path -Path $ApiPdf -PathType leaf) {
		$ApiPdf = Convert-Path -Path $ApiPdf -ErrorAction SilentlyContinue
		$NewApiPdf        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 435
			Padding        = "35,0,0,0"
			Text           = "Api.pdf"
			Tag            = $ApiPdf
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Leaf) {
						Start-Process $This.Tag

						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Inoperable)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}
		$GUIImageSourceSettingGroupAll.controls.AddRange($NewApiPdf)

		$NewApiPdf        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 75
			Location       = '460,620'
			Text           = "Api.pdf"
			Tag            = $ApiPdf
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					if (Test-Path -Path $This.Tag -PathType Leaf) {
						Start-Process $This.Tag

						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Inoperable)"
						$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}
			}
		}
		$GUIImageSourceGroupAPI.controls.AddRange($NewApiPdf)
	} else {
		$NewApiPdf        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 435
			Padding        = "35,0,0,0"
			Text           = "Api.pdf"
			Tag            = "https://github.com/ilikeyi/Solutions/blob/main/_Learn/API/API.pdf"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					Start-Process $This.Tag
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
		$GUIImageSourceSettingGroupAll.controls.AddRange($NewApiPdf)

		$NewApiPdf        = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 35
			Width          = 75
			Location       = '460,620'
			Text           = "Api.pdf"
			Tag            = "https://github.com/ilikeyi/Solutions/blob/main/_Learn/API/API.pdf"
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				if ([string]::IsNullOrEmpty($This.Tag)) {
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				} else {
					Start-Process $This.Tag
					$GUIImageSourceGroupSettingErrorMsg.Text = "$($lang.OpenFile): $($This.Tag), $($lang.Done)"
					$GUIImageSourceGroupSettingErrorMsg_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
		$GUIImageSourceGroupAPI.controls.AddRange($NewApiPdf)
	}
	$GUIImageSourceSettingGroupAll.controls.AddRange((
		$GUIImageSourceSettingAdv,                    # 可选功能
		$GUIImageSourceSettingEnv,                    # 将路由功能添加到系统变量
		$GUIImageSourceSettingEnvTips,
		$GUIImageSourceSettingTopMost,                # 允许打开的窗口后置顶
		$GUIImageSourceSettingClearHistoryLog,        # 允许自动清理超过 7 天的日志
		$UI_Main_Adv_Cmd,                             # 显示运行的完整命令行
		$UI_Main_Adv_Sel_ImageSources_Show_Key,       # 允许显示选择主键菜单
		$UI_Main_Adv_Sel_ImageSources_Show_Key_Tips,
		$GUIImageSourceSettingBootSize,               # Boot.wim 文件大小超过 520MB后, 选择重建

		<#
			.清理
		#>
		$GUIImageSourceSettingRepair,                 # 修复
		$GUIImageSourceSetting_Is_Auto_Repair,        # 空闲时自动修复
		$GUIImageSourceSetting_Is_Auto_Repair_Tips,   # 空闲时自动修复提示
		$GUIImageSourceSettingClearHistory,           # 清除历史记录
		$GUIImageSourceSettingClearAppxStage,         # InBox Apps: 删除安装时产生的临时文件
		$GUIImageSourceSettingHistoryDism,            # 删除保存在注册表里的 DISM 挂载记录
		$GUIImageSourceSettingHistoryBadMount,        # 删除与已损坏的已装载映像关联的所有资源
		$GUIImageSourceSettingRepairTips,

		$GUIImageSourceISOCache,
		$GUIImageSourceSettingRAMDISK,
		$GUIImageSourceSetting_RAMDISK_Volume_Label,
		$GUIImageSource_Setting_RAMDISK_Change,
		$GUIImageSource_Setting_RAMDISK_Restore,
		$GUIImageSource_Setting_Abandon_Allow_Auto,
		$GUIImageSource_Setting_Abandon_Agreement,
		$GUIImageSource_Setting_Abandon_Allow_Auto_Tips,
		$GUIImageSource_Setting_RAMDISK_Exclude,
		$GUIImageSource_Setting_RAMDISK_ExcludeTips,
		$GUIImageSourceISOCacheCustomizeName,
		$GUIImageSourceISOCacheCustomize,
		$GUIImageSourceISOSaveTo,
		$GUIImageSourceISOCustomizePath,
		$GUIImageSourceISOCustomizePathSelect,
		$GUIImageSourceISOCustomizePathOpen,
		$GUIImageSourceISOCustomizePathPaste,
		$GUIImageSourceISOCustomizePathRestore,
		$GUIImageSourceISOSync,
		$GUIImageSourceISOWrite,
		$GUIImageSourceISOSaveToCheckISO9660,
		$GUIImageSourceISOSaveToCheckISO9660Tips,
		$GUIImageSourceSettingSuggested,
		$GUIImageSourceSettingSuggestedPanel,
		$UI_Expand_Wrap
	))

	$GUIImageSourceSettingSuggestedPanel.controls.AddRange((
		$GUIImageSourceSettingSuggestedSoltions,

		$GUIImageSourceSettingSuggestedLang,
		$GUIImageSourceSettingSuggestedLangAdd,
		$GUIImageSourceSettingSuggestedLangDel,
		$GUIImageSourceSettingSuggestedLangChange,
		$GUIImageSourceSettingSuggestedLangClean,

		$UI_Suggested_InBox_Apps,
		$UI_Suggested_InBox_AppsOne,
		$UI_Suggested_InBox_AppsTwo,
		$UI_Suggested_InBox_AppsThere,
		$UI_Suggested_InBox_AppsDelete,

		$GUIImageSourceSettingSuggestedUpdate,
		$GUIImageSourceSettingSuggestedUpdateAdd,
		$GUIImageSourceSettingSuggestedUpdateDel,

		$GUIImageSourceSettingSuggestedDrive,
		$GUIImageSourceSettingSuggestedDriveAdd,
		$GUIImageSourceSettingSuggestedDriveDel,

		$GUIImageSourceSettingSuggestedWinFeature,
		$GUIImageSourceSettingSuggestedWinFeatureEnabled,
		$GUIImageSourceSettingSuggestedWinFeatureDisable,

		$GUIImage_Special_Function,
		$GUIImage_Functions_Before,
		$GUIImage_Functions_Rear,

		$GUIImage_API_Function,
		$GUIImage_API_Before,
		$GUIImage_API_Rear,

		$GUIImageSourceSettingSuggestedNeedMount,
		$GUIImageSourceSettingSuggestedAdditionalEdition,
		$GUIImageSourceSettingSuggestedConvert,
		$GUIImageSourceSettingSuggestedISO,
		$GUIImageSourceSettingSuggestedISO_Associated,

		$GUIImageSourceSettingSuggestedReset
	))

	$GUIImageSourceISOCacheCustomize.controls.AddRange((
		$GUIImageSourceISOCacheCustomizePath,
		$GUIImageSourceISOCacheCustomizePathSelect,
		$GUIImageSourceISOCacheCustomizePathOpen,
		$GUIImageSourceISOCacheCustomizePathPaste,
		$GUIImageSource_Setting_Custom_Exclude,
		$GUIImageSource_Setting_Custom_ExcludeTips
	))

	$GUIImageSourceGroupOtherPanel.controls.AddRange((
		$GUIImageSourceGroupOtherPanel_Menu,
		$GUIImageSourceGroupSettingEvent,
		$GUIImageSourceGroupSettingEventSelect,
		$GUISelectNotExecuted,
		$GUISelectGroupAfterFinishing,
		$GUISelectOtherSettingSaveModeErrorMsg_Icon,
		$GUISelectOtherSettingSaveModeErrorMsg,
		$GUIImageSourceGroupOther_Hide_ICO,
		$GUIImageSourceGroupOther_Hide
	))
	$GUIImageSourceGroupOtherPanel_Menu.controls.AddRange((
		$GUISelectGroupArchitecture,
		$GUIImageSourceGroupType,
		$GUIImageSourceGroupSettingAdv,
		$GUIImageSourceGroupSettingEventClear,
		$GUISelectOtherSettingSaveModeClear
	))
	$GUIImageSourceGroupMount.controls.AddRange((
		$GUIImageSourceMountTitle,
		$GUIImageSourceMountInfo
	))
	$GUIImageSourceGroupLang.controls.AddRange((
		$GUIImageSourceLangTitle,
		$GUIImageSourceLanguageInfo
	))
	$GUIImageSourceGroupOther.controls.AddRange((
		$GUIImageSourceOtherTitle,
		$GUIImageSourceOtherImageErrorMsg
	))
	$UI_Mask_Image_Mount_To.controls.AddRange((
		$UI_Mask_Image_Mount_ToGroupAll,
		$GUIImageSourceGroupMountChangePanel,
		$UI_Mask_Image_Mount_To_Error_Icon,
		$UI_Mask_Image_Mount_To_Error,
		$UI_Mask_Image_Mount_To_Reset_ICO,
		$UI_Mask_Image_Mount_To_Reset,
		$UI_Mask_Image_Mount_To_Hide_ICO,
		$UI_Mask_Image_Mount_To_Hide
	))
	$UI_Mask_Image_Mount_ToGroupAll.controls.AddRange((
		$GUIImageSourceGroupMountFrom,
		$GUIImageSourceGroupMountFromPath,
		$GUIImageSourceGroupMountFromOpenFolder,
		$GUIImageSourceGroupMountFromPaste,
		$GUIImageSourceGroupMountFromDelete,
		$UI_ImageSources_Del,
		$UI_ImageSources_Del_Path,
		$GUIImageSourceGroupMountFromDelete_Custom,
		$GUIImageSourceGroupMountFromDelete_Custom_Path,
		$GUIImageSourceGroupMountFromDelete_Clear,
		$GUIImageSourceGroupMountFromDelete_Clear_Path,
		$GUIImageSourceGroupMountFromRename_Path,
		$GUIImageSourceGroupMountFromRename_New_Path,
		$GUIImageSourceGroupMountFromRename,
		$GUIImageSourceGroupMountFromCopy,
		$GUIImageSourceGroupMountFromPath_Wrap,

		$GUIImageSourceGroupMountTo,
		$GUIImageSourceGroupMountChangeTipsErrorMsg,
		$GUIImageSourceGroupMountToShow,
		$GUIImageSourceGroupMountToOpenFolder,
		$GUIImageSourceGroupMountToPaste,
		$GUIImageSourceGroupMountTo_Wrap,

		$GUIImageSourceGroupMountToTemp,
		$GUIImageSourceGroupMountToTempShow,
		$GUIImageSourceGroupMountToTempOpenFolder,
		$GUIImageSourceGroupMountToTempPaste,
		$UI_Mask_Image_Mount_ToGroupAll_Wrap
	))
	$GUIImageSourceGroupMountChangePanel.controls.AddRange((
		$GUIImageSourceGroupMountChangeTitle,
		$GUIImageSourceGroupMountChangeTemp,
		$GUIImageSourceGroupMountChangeDiSKLowSize,
		$GUIImageSourceGroupMountChangeLowSize_Show,
		$GUIImageSourceGroupMountChangeSelect,
		$GUIImageSourceGroupMountChangeExclude,
		$GUIImageSourceGroupMountChangeRefresh,
		$UI_Mask_Image_Mount_To_Tips,
		$GUIImageSourceGroupMountChangeDiSKPane1,
		$GUIImageSourceGroupMount_Wrap
	))
	$GUIImageSourceGroupMountChangeLowSize_Show.controls.AddRange((
		$GUIImageSourceGroupMountChangeLowSize,
		$GUIImageSourceGroupMountChangeLowUnit
	))

	$UI_Mask_Image_Language.controls.AddRange((
		$UI_Mask_Image_Language_Name,
		$UI_Mask_Image_Language_Select,
		$UI_Mask_Image_Language_Error,
		$UI_Mask_Image_Language_Save_ICO,
		$UI_Mask_Image_Language_Save,
		$UI_Mask_Image_Language_Hide_ICO,
		$UI_Mask_Image_Language_Hide
	))
	$GUISelectGroupArchitecture.controls.AddRange((
		$GUIImageSourceArchitectureTitle,
		$GUIImageSourceArchitectureARM64,
		$GUIImageSourceArchitectureAMD64,
		$GUIImageSourceArchitectureX86
	))
	$GUIImageSourceGroupType.controls.AddRange((
		$GUISelectTypeTitle,
		$GUISelectTypeDesktop,
		$GUISelectTypeServer
	))
	$GUISelectGroupAfterFinishing.controls.AddRange((
		$GUISelectAfterFinishingNoProcess,
		$GUISelectAfterFinishingPause,
		$GUISelectAfterFinishingReboot,
		$GUISelectAfterFinishingShutdown
	))

	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_View_Detailed_Hide_ICO,
		$UI_Main_View_Detailed_Hide
	))

	<#
		.蒙板: 解压 ISO, 选择规则
	#>
	$UIUnzipPanel_Select_Rule.controls.AddRange((
		$UIUnzipPanel_Select_Rule_Menu,
		$UIUnzipPanel_Select_Rule_Filter,
		$UIUnzipPanel_Select_Rule_Filter_arm64,
		$UIUnzipPanel_Select_Rule_Filter_x64,
		$UIUnzipPanel_Select_Rule_Filter_x86,
		$UIUnzipPanel_Select_Rule_MenuMsg_Icon,
		$UIUnzipPanel_Select_Rule_MenuMsg,
		$UIUnzipPanel_Select_Rule_Menu_Save_ICO,
		$UIUnzipPanel_Select_Rule_Menu_Save,
		$UIUnzipPanel_Select_Rule_Menu_Hide_ICO,
		$UIUnzipPanel_Select_Rule_Menu_Hide
	))

	<#
		.蒙板: 解压 ISO, 添加控件区域
	#>
	$UIUnzipPanel.controls.AddRange((
		$UIUnzip_Search_RuleFilter_Show,
		$UIUnzipPanel_Menu,
		<#
			搜索按钮
		#>
		$UIUnzipPanelRefresh_ico,
		$UIUnzipPanelRefresh,
		$UIUnzip_Search_Show_FULL_Group,
		$UIUnzipPanelErrorMsg_Icon,
		$UIUnzipPanelErrorMsg,
		$UI_Main_Eject_ICO,
		$UI_Main_Eject,
		$UI_Main_Eject_Cdrom_ICO,
		$UI_Main_Eject_Cdrom,
		$UI_Main_Mount_ICO,
		$UI_Main_Mount,
		$UIUnzipPanelOK_ICO,
		$UIUnzipPanelOK,
		$UIUnzipPanelHide_ICO,
		$UIUnzipPanelHide
	))
	$UIUnzip_Search_RuleFilter_Show.controls.AddRange((
		$UIUnzip_Search_RuleFilter_Hide,
		$UIUnzip_Search_RuleFilter_Label,
		$UIUnzip_Search_RuleFilter_Apply,
		$UIUnzip_Search_RuleFilter_Apply_OtherFile,
		$UIUnzip_Search_RuleFilter_Apply_Language,
		$UIUnzip_Search_RuleFilter_Apply_InBoxApps
	))
	$UIUnzip_Search_Show_FULL_Group.controls.AddRange((
		$UIUnzip_Search_Sift,
		$UIUnzip_Search_Sift_Custon,
		$UIUnzip_Search_Show_Select,
		$UIUnzip_Search_Rule_Select,
		$UIUnzip_Search_Rule_Show
	))
	$UIUnzip_Search_Rule_Show.controls.AddRange((
		$UIUnzip_Search_Rule_Show_Select_Custom
	))
	$UIUnzipPanel_Menu.controls.AddRange((
		$UIUnzipPanel_Menu_Sources,
		$UIUnzipPanel_Menu_Sources_Path,
		$UIUnzipPanel_Menu_Sources_Select,
		$UIUnzipPanel_Menu_Sources_Open,
		$UIUnzipPanel_Menu_Sources_Paste,
		$UIUnzipPanel_Menu_Sources_Reset,
		$UIUnzipPanel_To,
		$UIUnzipPanel_To_Path_Select_Tips,
		$UIUnzipPanel_To_Path,
		$UIUnzipPanel_To_Path_Paste,
		$UIUnzipPanel_Sparse,
		$UIUnzipPanel_SHA256_Calibration,
		$UIUnzipPanel_SHA256_Calibration_Wrap,

		$UIUnzipPanel_SHA512_Calibration,
		$UIUnzipPanel_SHA512_Calibration_Wrap,

		$UIUnzipPanel_To_New,
		$UIUnzipPanel_To_New_Sources,
		$UIUnzipPanel_To_New_Path,
		$UIUnzipPanel_To_New_Tips,
		$UIUnzip_Select_Sources,
		$UIUnzipPanel_Menu_Wrap
	))

	<#
		.初始化设置界面
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "SearchDiskMinSize" -ErrorAction SilentlyContinue) {
		$GUIImageSourceGroupSettingLowSize.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "SearchDiskMinSize" -ErrorAction SilentlyContinue
	} else {
		Save_Dynamic -regkey "Solutions" -name "SearchDiskMinSize" -value $InitSearchDiskMinSize
	}

	Image_Setting_UI

	<#
		.初始化设置语言界面
	#>
	Image_Select_Refresh_Sources_List

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
			Height  = 55
			Width   = 305
			Text    = "$($itemRegion.Name)`n$($itemRegion.Region)"
			Tag     = $itemRegion.Region
		}

		$UI_Mask_Image_Language_Select.controls.AddRange($CheckBox)
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskMinSize" -ErrorAction SilentlyContinue) {
		$GUIImageSourceGroupMountChangeLowSize.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskMinSize" -ErrorAction SilentlyContinue
	} else {
		Save_Dynamic -regkey "Solutions" -name "DiskMinSize" -value $InitSearchDiskMinSize
		$GUIImageSourceGroupMountChangeLowSize.Text = $InitSearchDiskMinSize
	}
	Image_Select_Refresh_Mount_Disk

	Refresh_Unzip_Custom_Rule
	if (Unzip_Custom_Rule_Setting_Default) {

	}

	$UI_Main_Select_Sources.Controls | ForEach-Object {
		if ($_ -is [System.Windows.Forms.RadioButton]) {
			if ($Global:Image_source -eq $_.Name) {
				$_.Checked = $True
				Refresh_Click_Image_Sources
			}
		}
	}

	<#
		.刷新 Windows Defender 规则
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDefenderExclude" -ErrorAction SilentlyContinue) {
			"True" {
				Exclude_Add_DiskTo
			}
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk_Exclude" -ErrorAction SilentlyContinue) {
						"True" {
							Exclude_Add_Ramdisk
						}
					}
				}
			}
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsDiskCache" -ErrorAction SilentlyContinue) {
			"True" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Custom_Exclude" -ErrorAction SilentlyContinue) {
						"True" {
							Exclude_Add_Custom
						}
					}
				}
			}
		}
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	switch ($Global:IsLang) {
		'de-DE' {
			$GUIImageSourceISOSync.Height = "35"
		}
	}

	switch ($Page) {
		"ISO" {
			$UI_Main.Text = $lang.ISO_File

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue) {
				$itemISO = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "DiskTo" -ErrorAction SilentlyContinue
				$UIUnzipPanel_Menu_Sources_Path.Text = Join-Path -Path $itemISO -ChildPath $Global:Init_Search_ISO_Folder_Name
			}

			$UI_Main.remove_DragDrop($UI_Main_DragDrop)
			$UI_Main.Add_DragDrop($UI_Main_Unzip_DragDrop)

			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $True                        # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			ISO_Select_Refresh_Sources_List

			$UI_Main.ShowDialog() | Out-Null
		}
		"API" {
			$UI_Main.Text = $lang.API
			Write-Host "`n  $($lang.API)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Refresh_Rule_Shortcuts

			$GUIImageSourceGroupAPI.visible = $True              # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $False         # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			<#
				.添加托动和事件
			#>
			$UI_Main.Add_DragOver($UI_Main_API_DragOver)
			$UI_Main.Add_DragDrop($UI_Main_API_DragDrop)
			$UI_Main.ShowDialog() | Out-Null
		}
		"Set" {
			$UI_Main.Text = $lang.Setting
			Write-Host "`n  $($lang.Setting)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			$GUIImageSourceGroupAPI.visible = $False             # 蒙板: 设置 API
			$GUIImageSourceGroupSetting.visible = $True          # 蒙板: 设置界面
			$UI_Mask_Image_Mount_To.visible = $False             # 蒙板: 更改挂载到
			$UI_Mask_Image_Language.visible = $False             # 蒙板: 更改 ISO 挂载的映像主语言
			$UI_Main_View_Detailed.visible = $False              # 蒙板: 解压 ISO, 显示详细规则
			$UIUnzipPanel_Select_Rule.visible = $False           # 蒙板: 解压 ISO, 选择规则
			$UIUnzipPanel.visible = $False                       # 蒙板: 解压 ISO
			$GUIImageSourceGroupOtherPanel.visible = $False      # 蒙板: 其它信息
			$UI_Main_Image_Sources.visible = $False              # 设置主界面

			$UI_Main.ShowDialog() | Out-Null
		}
		"menu" {
			$UI_Main_Image_Sources_Menu_Show.visible = $True
			$UI_Main.ShowDialog() | Out-Null
		}
		default {
			$UI_Main.ShowDialog() | Out-Null
		}
	}
}

<#
	判断内核
#>
Function ISO_Verify_Kernel
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
		$TempSelectAraayKernelRegedit = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue
		$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.SelLabel) ( $($TempSelectAraayKernelRegedit), $($lang.Save) )"
		return
	}

	if ($Global:OSVersion.Count -gt 0) {
		ForEach ($item in $Global:OSVersion) {
			$SearchNT10 = @(
				"*_$($item)_*"
				"*$($item)_*"
			)

			ForEach ($NewItem in $SearchNT10) {
				if ($Global:MainImage -like $NewItem) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\MVS" -name "Kernel" -value $item
					$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.SelLabel) ( $($item), $($lang.MatchMode) )"
					return
				}
			}
		}

		$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.SelLabel) ( $($lang.ImageCodenameNo) )"
	} else {
		$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.SelLabel) ( $($lang.UpdateUnavailable) )"
	}
}

<#
	判断架构
#>
Function ISO_Verify_Arch
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "Architecture" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "Architecture" -ErrorAction SilentlyContinue) {
			"arm64" {
				$GUIImageSourceArchitectureARM64.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( Arm64, $($lang.Save) )"
			}
			"AMD64" {
				$GUIImageSourceArchitectureAMD64.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( x64, $($lang.Save) )"
			}
			"x86" {
				$GUIImageSourceArchitectureX86.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( x86, $($lang.Save) )"
			}
		}
	} else {
		$SearchArchitectureARM64 = @(
			"*_arm_*"
			"*_arm64_*"
			"*_64arm_*"
			"*A64FRE*"
		)
		$SearchArchitectureAMD64 = @(
			"*x64*"
			"*x64FRE*"
		)
		$SearchArchitecturex86 = @(
			"*x86*"
			"*x86FRE*"
		)

		ForEach ($item in $SearchArchitectureARM64) {
			if ($Global:MainImage -like $item) {
				$GUIImageSourceArchitectureARM64.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( Arm64, $($lang.MatchMode) )" 
				return
			}
		}

		ForEach ($item in $SearchArchitectureAMD64) {
			if ($Global:MainImage -like $item) {
				$GUIImageSourceArchitectureAMD64.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( x64, $($lang.MatchMode) )"
				return
			}
		}

		ForEach ($item in $SearchArchitecturex86) {
			if ($Global:MainImage -like $item) {
				$GUIImageSourceArchitectureX86.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( x86, $($lang.MatchMode) )"
				return
			}
		}

		$GUIImageSourceArchitectureAMD64.Checked = $True
		$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.Architecture) ( x64, $($lang.RandomSelect) )"
	}
}

<#
	.判断安装类型
#>
Function ISO_Verify_Install_Type
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "ImageType" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "ImageType" -ErrorAction SilentlyContinue) {
			"Desktop" {
				$GUISelectTypeDesktop.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageLevel) ( $($lang.LevelDesktop), $($lang.Save) )"
			}
			"Server" {
				$GUISelectTypeServer.Checked  = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageLevel) ( $($lang.LevelServer), $($lang.Save) )"
			}
		}
	} else {
		$SearchDesktop = @(
			"*_consumer_*"
			"*_business_*"
			"*_desktop_*"
			"*_client_*"
		)
		$SearchServer = @(
			"*Server*"
			"vNext"
		)

		ForEach ($item in $SearchDesktop) {
			if ($Global:MainImage -like $item) {
				$GUISelectTypeDesktop.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageLevel) ( $($lang.LevelDesktop), $($lang.MatchMode) )"
				return
			}
		}

		ForEach ($item in $SearchServer) {
			if ($Global:MainImage -like $item) {
				$GUISelectTypeServer.Checked = $True
				$GUIImageSourceArchitectureAMD64.Checked = $True
				$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageLevel) ( $($lang.LevelServer), $($lang.MatchMode) )"
				return
			}
		}

		$GUISelectTypeDesktop.Checked = $True
		$GUIImageSourceOtherImageErrorMsg.Text += ", $($lang.ImageLevel) ( $($lang.LevelDesktop), $($lang.RandomSelect) )"
	}
}

Function ISO_Verify_Sources_Language
{
	$Region = Language_Region
	<#
		从注册表获取保存的映像默认语言
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "language" -ErrorAction SilentlyContinue) {
		$GetRegeditlanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)" -Name "language" -ErrorAction SilentlyContinue
		if ($Global:LanguageFull -Contains $GetRegeditlanguage) {
			ForEach ($itemRegion in $Region) {
				if ($itemRegion.Region -eq $GetRegeditlanguage) {
					$Global:MainImageLang      = $itemRegion.Region
					$Global:MainImageLangShort = $itemRegion.Tag
					$Global:MainImageLangName  = $itemRegion.Name
					$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.Save)"
					
					return
				}
			}
		}
	}

	<#
		继续判断语言: 判断 mul_ 开头, 多语标签设置为默认英文
	#>
	if ($Global:MainImage -like "*mul_*") {
		$DefaultLanguage = "en-us"
		ForEach ($itemRegion in $Region) {
			if ($itemRegion.Region -eq $DefaultLanguage) {
				$UI_Main_Error.Text = $lang.LanguageMatchError
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")

				$Global:MainImageLang      = $itemRegion.Region
				$Global:MainImageLangShort = $itemRegion.Tag
				$Global:MainImageLangName  = $itemRegion.Name
				$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.MatchMode)"

				return
			}
		}
	}

	<#
		继续判断语言: 按国家语言标记, 例如: en-US, zh-CN
	#>
	ForEach ($item in $Global:LanguageFull) {
		if ($Global:MainImage -like "*$($item)*") {
			ForEach ($itemRegion in $Region) {
				if ($itemRegion.Region -eq $item) {
					$Global:MainImageLang      = $itemRegion.Region
					$Global:MainImageLangShort = $itemRegion.Tag
					$Global:MainImageLangName  = $itemRegion.Name
					$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.MatchMode)"

					return
				}
			}
		}
	}

	<#
		继续判断语言: 短名称, 例如 en, cn 开头的
	#>
	ForEach ($item in $Global:LanguageShort) {
		if ($Global:MainImage -like "$($item)_*") {
			ForEach ($itemRegion in $Region) {
				if ($itemRegion.Tag -eq $item) {
					$Global:MainImageLang      = $itemRegion.Region
					$Global:MainImageLangShort = $itemRegion.Tag
					$Global:MainImageLangName  = $itemRegion.Name
					$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.MatchMode)"
					return
				}
			}
		}
	}

	<#
		条件: 
			1. 从注册表里获取保存的失败; 
			2. 判断短名称失败; 
			3. 按国家语言判断失败
			设置为主语: en-US
	#>
	ForEach ($itemRegion in $Region) {
		if ($itemRegion.Region -eq "en-us") {
			$UI_Main_Error.Text = $lang.LanguageMatchError
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")

			$Global:MainImageLang      = $itemRegion.Region
			$Global:MainImageLangShort = $itemRegion.Tag
			$Global:MainImageLangName  = $itemRegion.Name
			$GUIImageSourceLanguageInfo.Text = "$($Global:MainImageLangName), $($lang.LanguageCode) ( $($Global:MainImageLang) ), $($lang.LanguageShort) ( $($Global:MainImageLangShort) ), $($lang.MatchMode)"
			return
		}
	}
}

<#
	.快捷指令: 选择映像来源页面
#>
Function Image_Select_Page_Shortcuts
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.SelectSettingImage) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	switch ($Name) {
		"ISO" {
			Image_Select -Page $Name
		}
		"API" {
			Image_Select -Page $Name
		}
		"Set" {
			Image_Select -Page $Name
		}
		"menu" {
			Image_Select -Page $Name
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.初始化主要项, 扩展项文件
#>
Function Image_Refresh_Init_GLobal_Rule
{
	if (([string]::IsNullOrEmpty($Global:Image_source))) {
		$InitNewImageSources = "Sources"
	} else {
		$InitNewImageSources = Join-Path -Path $Global:Image_source -ChildPath "Sources"
	}

	<#
		.搜索映像文件类型
	#>
	$Global:Image_Rule = @(
		@{
			Main = @(
				@{
					Group         = "Install;Install;"
					Uid           = "Install;Wim;Install;Wim;"
					ImageFileName = "Install"
					Suffix        = "wim"
					Shortcuts     = "WI"
					Path          = $InitNewImageSources
				}
			)
			Expand = @(
				@{
					Group         = "Install;Install;"
					Uid           = "Install;Wim;WinRE;Wim;"
					ImageFileName = "WinRe"
					Suffix        = "wim"
					Shortcuts     = "WR"
					Path          = "Windows\System32\Recovery"
					UpdatePath    = "\Windows\System32\Recovery\WinRe.wim"
				}
			)
		}
		@{
			Main = @(
				@{
					Group         = "Install;Install;"
					Uid           = "Install;esd;Install;Esd;"
					ImageFileName = "Install"
					Suffix        = "esd"
					Shortcuts     = "EI"
					Path          = $InitNewImageSources
				}
			)
			Expand = @(
				@{
					Group         = "Install;Install;"
					Uid           = "Install;esd;WinRE;Wim;"
					ImageFileName = "WinRe"
					Suffix        = "wim"
					Shortcuts     = "ER"
					Path          = "Windows\System32\Recovery"
					UpdatePath    = "\Windows\System32\Recovery\WinRe.wim"
				}
			)
		}
		@{
			Main = @(
				@{
					Group         = "Install;Install;"
					Uid           = "Install;Swm;Install;Swm;"
					ImageFileName = "Install"
					Suffix        = "swm"
					Shortcuts     = "IS"
					Path          = $InitNewImageSources
				}
			)
		}
		@{
			Main = @(
				@{
					Group         = "Boot;Boot;"
					Uid           = "Boot;Wim;Boot;Wim;"
					ImageFileName = "Boot"
					Suffix        = "wim"
					Shortcuts     = "BW"
					Path          = $InitNewImageSources
				}
			)
			Expand = @()
		}
	)
}