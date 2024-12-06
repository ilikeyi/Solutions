<#
	.More features
	.更多功能
#>
Function Feature_More
{
	Clear-Host
	Logo -Title $lang.MoreFeature -ShowUpdate

	Write-Host "   $($lang.Menu)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "      M   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.MoreFeature -ForegroundColor Green

	if ($Global:Developers_Mode) {
		Write-Host "      S   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Developers_Mode -ForegroundColor Green
	} else {
		Write-Host "      S   " -NoNewline -ForegroundColor Yellow
		Write-Host $lang.Developers_Mode -ForegroundColor Red
	}

	Write-Host "      A   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.ViewMounted -ForegroundColor Green

	Write-Host "      B   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.UpBackup -ForegroundColor Green

	Write-Host "      Z   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.ConvertToArchive -ForegroundColor Green

	Write-Host "      C   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.UpdateCreate -ForegroundColor Green

	Write-Host "`n   $($lang.ViewWIMFileInfo)" -ForegroundColor Green
	Write-Host "   $('-' * 80)"
	$TestWIMFile = Join-Path -Path $Global:Image_source -ChildPath "Sources"
	Write-Host "   $($TestWIMFile)" -ForegroundColor Yellow

	$TestWIMFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\Boot.wim"
	Write-host "    " -NoNewline
	if (Test-Path -Path $TestWIMFile -PathType Leaf) {
		Write-Host " 1 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View BW " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Boot.wim " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " 1 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View BW " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Boot.wim " -BackgroundColor DarkRed -ForegroundColor White
	}


	$TestWIMFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\Install.wim"
	Write-host "    " -NoNewline
	if (Test-Path -Path $TestWIMFile -PathType Leaf) {
		Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IW " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.wim " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " 2 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IW " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.wim " -BackgroundColor DarkRed -ForegroundColor White
	}

	$TestWIMFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\Install.swm"
	Write-host "    " -NoNewline
	if (Test-Path -Path $TestWIMFile -PathType Leaf) {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.swm " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IS " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.swm " -BackgroundColor DarkRed -ForegroundColor White
	}

	$TestWIMFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\Install.esd"
	Write-host "    " -NoNewline
	if (Test-Path -Path $TestWIMFile -PathType Leaf) {
		Write-Host " 4 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.esd " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " 4 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " View IE " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
		Write-Host " Install.esd " -BackgroundColor DarkRed -ForegroundColor White
	}

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			$TestNewPathMount = Join-Path -Path $Global:Mount_To_Route -ChildPath "Install\Install\Mount"
			$TestNewPathMountRouter = Join-Path -Path $Global:Mount_To_Route -ChildPath "Install\Install\Mount\Windows\System32\Recovery\WinRE.wim"
			Write-Host "`n   $($TestNewPathMount)" -ForegroundColor Yellow
			Write-host "    " -NoNewline
			if (Test-Path -Path $TestNewPathMountRouter -PathType Leaf) {
				Write-Host " 5 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-host " " -NoNewline

				Write-Host " View WR " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
				Write-Host " Windows\System32\Recovery\WinRE.wim " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " 5 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
				Write-host " " -NoNewline

				Write-Host " View WR " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
				Write-Host "    $($lang.ViewWIMFileInfo): " -NoNewline -ForegroundColor Green
				Write-Host " Windows\System32\Recovery\WinRE.wim " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	}

	Write-Host "`n   $($lang.OpenFolder)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	$SaveToLogsPath = "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"

	Write-host "   " -NoNewline
	if (Test-Path -Path $SaveToLogsPath -PathType Container) {
		Write-Host " 11 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open Log " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "   $($lang.Logging)" -ForegroundColor Green
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $SaveToLogsPath -ForegroundColor Green
	} else {
		Write-Host " 11 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open Log " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "   $($lang.Logging)" -ForegroundColor Red
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $SaveToLogsPath -ForegroundColor Red
	}

	Write-Host
	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Image_source -PathType Container) {
		Write-Host " 12 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.MainImageFolder)" -ForegroundColor Green
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Image_source -ForegroundColor Green
	} else {
		Write-Host " 12 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.MainImageFolder)" -ForegroundColor Red
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Image_source -ForegroundColor Red
	}

	Write-Host
	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
		Write-Host " 13 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "    $($lang.MountImageTo), $($lang.MainImageFolder)" -ForegroundColor Green
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Mount_To_Route -ForegroundColor Green
	} else {
		Write-Host " 13 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "    $($lang.MountImageTo), $($lang.MainImageFolder)" -ForegroundColor Red
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Mount_To_Route -ForegroundColor Red
	}

	Write-Host
	Write-host "   " -NoNewline
	if (Test-Path -Path $Global:Mount_To_RouteTemp -PathType Container) {
		Write-Host " 14 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open Temp " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "  $($lang.SettingImageTempFolder)" -ForegroundColor Green
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Green
	} else {
		Write-Host " 14 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-host " " -NoNewline

		Write-Host " Open Temp " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "  $($lang.SettingImageTempFolder)" -ForegroundColor Red
		Write-Host "         $($lang.Select_Path): " -NoNewline
		Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Red
	}

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"Update" {
			Update
			Modules_Refresh -Function "ToWait -wait 2"
			Feature_More
		}
		"m" {
			Write-Host "`n   $($lang.MoreFeature)"
			Write-Host "   $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Green
					Feature_More_UI_Menu
				} else {
					Write-Host "   $($lang.Mounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red

				Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   $($lang.OnDemandPlanTask)" -ForegroundColor Green

				ToWait -wait 2
				Image_Assign_Event_Master
			}
		}
		"a" {
			Clear-Host
			Write-Host "`n   $($lang.ViewMounted)" -ForegroundColor Green

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   Get-WindowsImage -Mounted" -ForegroundColor Green
				Write-Host "   $('-' * 80)`n"
			}
	
			Get-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Mounted | ForEach-Object {
				Write-Host "   $('-' * 80)"
				Write-Host "   $($lang.Select_Path)".PadRight(18) -NoNewline
				Write-Host $_.Path -ForegroundColor Green

				Write-Host "   $($lang.Image_Path)".PadRight(18) -NoNewline
				Write-Host $_.ImagePath -ForegroundColor Green

				Write-Host "   $($lang.MountedIndex)".PadRight(18) -NoNewline
				Write-Host $_.ImageIndex -ForegroundColor Green

				Write-Host "   $($lang.Mounted_Mode)".PadRight(18) -NoNewline
				Write-Host $_.MountMode -ForegroundColor Green

				Write-Host "   $($lang.Mounted_Status)".PadRight(18) -NoNewline
				Write-Host $_.MountStatus -ForegroundColor Green
				Write-Host "   $('-' * 80)`n"
			}

			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"b" {
			UnPack_Create_UI
			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"c" {
			Update_Create_UI
			ToWait -wait 2
			Feature_More
		}
		"s" {
			if ($Global:Developers_Mode) {
				$Global:Developers_Mode = $False
			} else {
				$Global:Developers_Mode = $True
			}
			
			ToWait -wait 2
			Feature_More
		}

		<#
			.帮助
		#>
		"h" {
			Solutions_Help

			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '')
			ToWait -wait 2
			Feature_More
		}

		"z" {
			Covert_Software_Package_Unpack

			ToWait -wait 2
			Feature_More
		}
		"1" {
			Image_Primary_Key_Shortcuts_File_View -Name "BW"
			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"2" {
			Image_Primary_Key_Shortcuts_File_View -Name "IW"
			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"3" {
			Image_Primary_Key_Shortcuts_File_View -Name "IS"
			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"4" {
			Image_Primary_Key_Shortcuts_File_View -Name "IE"
			Get_Next
			ToWait -wait 2
			Feature_More
		}
		"5" {
			if (Image_Is_Select_Install) {
				Image_Primary_Key_Shortcuts_File_View -Name "WR"
				Get_Next
			} else {
				Write-Host "   $($lang.BootProcess -f "install")" -ForegroundColor Red
			}

			ToWait -wait 2
			Feature_More
		}
		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Feature_More
		}
		"11" {
			Solutions_Open_Command -Name "Log"
			ToWait -wait 2
			Feature_More
		}
		"12" {
			Solutions_Open_Command -Name "MN"
			ToWait -wait 2
			Feature_More
		}
		"13" {
			Solutions_Open_Command -Name "RT"
			ToWait -wait 2
			Feature_More
		}
		"14" {
			Solutions_Open_Command -Name "Temp"
			ToWait -wait 2
			Feature_More
		}
		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Feature_More
		}
		default { Mainpage }
	}
}

Function Image_Get_Apps_Package
{
	param
	(
		[Switch]$View,
		$Save
	)

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

	if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
		$custom_array = @()
		try {
			Write-Host "   $($lang.Operable)" -ForegroundColor Green
			Get-AppxProvisionedPackage -Path $test_mount_folder_Current | ForEach-Object {
				$custom_array += [PSCustomObject]@{
					DisplayName  = $_.DisplayName
					PackageName  = $_.PackageName
					Version      = $_.Version
					Architecture = $_.Architecture
					ResourceId   = $_.ResourceId
					Regions      = $_.Regions
				}
			}
		} catch {
			Write-Host "   $($_)" -ForegroundColor Yellow
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		$Get_Index_Now = Image_Get_Mount_Index
		Check_Folder -chkpath $Save
		$TempSaveTo = "$($Save)\Index.$($Get_Index_Now).InBox.Apps.$(Get-Date -Format "yyyyMMddHHmmss").csv"

		Write-Host "`n   $($lang.SaveTo)"
		Write-Host "   $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.GetInBoxApps)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "   User Cancel" -ForegroundColor Red
	} else {
		ForEach (`$item in `$multiple_output) {
			`$custom_array_Export += [PSCustomObject]@{
				DisplayName  = `$item.DisplayName
				PackageName  = `$item.PackageName
				Version      = `$item.Version
				Architecture = `$item.Architecture
				ResourceId   = `$item.ResourceId
				Regions      = `$item.Regions
			}
		}

		Add-Type -AssemblyName System.Windows.Forms

		`$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
			Filter    = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
			FileName  = "Export.InBox.Apps.`$(Get-Date -Format "yyyyMMddHHmmss")"
		}

		if (`$FileBrowser.ShowDialog() -eq "OK") {
			Write-Host "`n   Save To:"
			Write-Host "   `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "   User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}
	} else {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"
		Write-Host "   $($lang.NotMounted)`n" -ForegroundColor Red
	}
}

Function Image_Get_Detailed
{
	param
	(
		$Filename,
		[Switch]$View
	)

	Write-Host "`n   $($lang.ViewWIMFileInfo)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "   $($Filename)`n" -ForegroundColor Green

	if (Test-Path -Path $Filename -PathType Leaf) {
		$custom_array = @()

		try {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   Get-WindowsImage -ImagePath ""$($Filename)""" -ForegroundColor Green
			}
	
			Get-WindowsImage -ImagePath $Filename -ErrorAction SilentlyContinue | ForEach-Object {
				$SetCurreltIndex = $_.ImageIndex

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   Get-WindowsImage -ImagePath ""$($Filename)"" -index ""$($SetCurreltIndex)""" -ForegroundColor Green
				}
		
				Get-WindowsImage -ImagePath $Filename -index $SetCurreltIndex -ErrorAction SilentlyContinue | ForEach-Object {
					$custom_array += [PSCustomObject]@{
						ImageIndex       = $_.ImageIndex
						ImageName        = $_.ImageName
						ImageDescription = $_.ImageDescription
						ImageSize        = $_.ImageSize
						WIMBoot          = $_.WIMBoot
						Architecture     = $_.Architecture
						Hal              = $_.Hal
						Version          = $_.Version
						SPBuild          = $_.SPBuild
						SPLevel          = $_.SPLevel
						EditionId        = $_.EditionId
						InstallationType = $_.InstallationType
						ProductType      = $_.ProductType
						ProductSuite     = $_.ProductSuite
						SystemRoot       = $_.SystemRoot
						DirectoryCount   = $_.DirectoryCount
						FileCount        = $_.FileCount
						CreatedTime      = $_.CreatedTime
						ModifiedTime     = $_.ModifiedTime
						Languages        = $_.Languages
					}
				}
			}
		} catch {
			Write-Host "   $($_)" -ForegroundColor Yellow
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		$test_create_report_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Report"
		$test_create_report_folder_route = Join-Path -Path $Global:Mount_To_Route -ChildPath "Report"

		if (Image_Is_Select_IAB) {
			if (Verify_Is_Current_Same) {
				$Get_Index_Now = Image_Get_Mount_Index

				Check_Folder -chkpath $test_create_report_folder_Current
				$TempSaveTo = "$($test_create_report_folder_Current)\Index.$($Get_Index_Now).Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
			} else {
				Check_Folder -chkpath $test_create_report_folder_route
				$TempSaveTo = "$($test_create_report_folder_route)\Index.Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
			}
		} else {
			Check_Folder -chkpath $test_create_report_folder_route
			$TempSaveTo = "$($test_create_report_folder_route)\Index.Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
		}

		Write-Host "`n   $($lang.SaveTo)"
		Write-Host "   $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.ViewWIMFileInfo): $($Filename)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "   User Cancel" -ForegroundColor Red
	} else {
		ForEach (`$item in `$multiple_output) {
			`$custom_array_Export += [PSCustomObject]@{
				ImageIndex       = `$item.ImageIndex
				ImageName        = `$item.ImageName
				ImageDescription = `$item.ImageDescription
				ImageSize        = `$item.ImageSize
				WIMBoot          = `$item.WIMBoot
				Architecture     = `$item.Architecture
				Hal              = `$item.Hal
				Version          = `$item.Version
				SPBuild          = `$item.SPBuild
				SPLevel          = `$item.SPLevel
				EditionId        = `$item.EditionId
				InstallationType = `$item.InstallationType
				ProductType      = `$item.ProductType
				ProductSuite     = `$item.ProductSuite
				SystemRoot       = `$item.SystemRoot
				DirectoryCount   = `$item.DirectoryCount
				FileCount        = `$item.FileCount
				CreatedTime      = `$item.CreatedTime
				ModifiedTime     = `$item.ModifiedTime
				Languages        = `$item.Languages
			}
		}

		Add-Type -AssemblyName System.Windows.Forms

		`$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
			Filter    = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
			FileName  = "Export.Image.`$(Get-Date -Format "yyyyMMddHHmmss")"
		}

		if (`$FileBrowser.ShowDialog() -eq "OK") {
			Write-Host "`n   Save To:"
			Write-Host "   `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "   User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}
	} else {
		Write-Host "   $($lang.NoInstallImage)"
		Write-Host "   $($Filename)" -ForegroundColor Red
	}
}

Function Image_Get_Components_Package
{
	param
	(
		[Switch]$View,
		$Save
	)

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master)\$($Global:Primary_Key_Image.ImageFileName)\Mount"

	$custom_array = @()
	if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
		try {
			Get-WindowsPackage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Path $test_mount_folder_Current | ForEach-Object {
				$custom_array += [PSCustomObject]@{
					PackageName  = $_.PackageName
					PackageState = $_.PackageState
					ReleaseType  = $_.ReleaseType
					InstallTime  = $_.InstallTime
				}
			}

			Write-Host "   $($lang.Operable)" -ForegroundColor Green
		} catch {
			Write-Host "   $($_)" -ForegroundColor Yellow
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		$Get_Index_Now = Image_Get_Mount_Index
		Check_Folder -chkpath $Save
		$TempSaveTo = "$($Save)\Index.$($Get_Index_Now).Components.$(Get-Date -Format "yyyyMMddHHmmss").csv"

		Write-Host "`n   $($lang.SaveTo)"
		Write-Host "   $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.GetImagePackage)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "   User Cancel" -ForegroundColor Red
	} else {
		ForEach (`$item in `$multiple_output) {
			`$custom_array_Export += [PSCustomObject]@{
				PackageName  = `$item.PackageName
				PackageState = `$item.PackageState
				ReleaseType  = `$item.ReleaseType
				InstallTime  = `$item.InstallTime
			}
		}

		Add-Type -AssemblyName System.Windows.Forms

		`$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
			Filter    = "CSV Files (*.csv)|*.csv|Text Files (*.txt)|*.txt|All Files (*.*)|*.*"
			FileName  = "Export_Package_`$(Get-Date -Format "yyyyMMddHHmmss")"
		}

		if (`$FileBrowser.ShowDialog() -eq "OK") {
			Write-Host "`n   Save To:"
			Write-Host "   `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "   User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}
	} else {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"
		Write-Host "   $($lang.NotMounted)`n" -ForegroundColor Red
	}
}

Function Solutions_Open_Command
{
	param
	(
		$Name
	)

	Write-Host "`n   $($lang.Command): " -NoNewline
	Write-host "lang $($Name)" -ForegroundColor Green
	Write-Host "   $('-' * 80)"

	Write-Host "`n   $($lang.OpenFolder) *" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "   $($lang.Select_Path): " -NoNewline
	switch ($Name) {
		"Log" {
			$SaveToLogsPath = "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"
			Write-Host $SaveToLogsPath -ForegroundColor Green

			if (Test-Path -Path $SaveToLogsPath -PathType Container) {
				Write-Host "   $($lang.OpenFolder)".PadRight(28) -NoNewline
				Start-Process $SaveToLogsPath
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"MN" {
			Write-Host $Global:Image_source -ForegroundColor Green

			if (Test-Path -Path $Global:Image_source -PathType Container) {
				Write-Host "   $($lang.OpenFolder)".PadRight(28) -NoNewline
				Start-Process $Global:Image_source
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"RT" {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green

			if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
				Write-Host "   $($lang.OpenFolder)".PadRight(28) -NoNewline
				Start-Process $Global:Mount_To_Route
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"Temp" {
			Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Green

			if (Test-Path -Path $Global:Mount_To_RouteTemp -PathType Container) {
				Write-Host "   $($lang.OpenFolder)".PadRight(28) -NoNewline
				Start-Process $Global:Mount_To_RouteTemp
				Write-Host $lang.Done -ForegroundColor Green
			} else {
				Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		default {
			Write-Host "   $($lang.NoWork)" -ForegroundColor Red
		}
	}
}