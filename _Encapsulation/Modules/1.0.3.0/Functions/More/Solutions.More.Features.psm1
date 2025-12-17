<#
	.More features
	.更多功能
#>
Function Feature_More_Menu
{
	Clear-Host
	Logo -Title $lang.MoreFeature -ShowUpdate

	Write-Host "  $($lang.Menu)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-host "     " -NoNewline
	Write-Host " M " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.MoreFeature)" -ForegroundColor Green

	Write-host "     " -NoNewline
	Write-Host " A " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.ViewMounted)" -ForegroundColor Green

	Write-Host $(' ' * 3) -NoNewline
	Write-Host " Dev " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  " -NoNewline
	if ($Global:Developers_Mode) {
		Write-Host $lang.Developers_Mode -ForegroundColor Green
	} else {
		Write-Host $lang.Developers_Mode -ForegroundColor Red
	}

	Write-Host $(' ' * 2) -NoNewline
	Write-Host " Unpack " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  " -NoNewline
	Write-Host $lang.UpBackup -ForegroundColor Green

	Write-Host $(' ' * 3) -NoNewline
	Write-Host " Zip " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  " -NoNewline
	Write-Host $lang.ConvertToArchive -ForegroundColor Green

	Write-Host $(' ' * 2) -NoNewline
	Write-Host " Ceup " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  " -NoNewline
	Write-Host $lang.UpdateCreate -ForegroundColor Green

	Write-Host
	Solutions_Help_Command -Name "View" -Silent -IsVerify

	Solutions_Help_Command -Name "Se" -Silent

	Solutions_Help_Command -Name "Sel" -Silent -NoShowFile

	Solutions_Open_Command -Help -Silent

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.RefreshModules) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " R'R " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host ": " -NoNewline

	$NewEnter = Read-Host

	<#
		.The prefix cannot contain spaces
		.前缀不能带空格
	#>
	while ($true) {
		if ($NewEnter -match '^\s') {
			$NewEnter = $NewEnter.Remove(0, 1)
		} else {
			break
		}
	}

	switch -Wildcard ($NewEnter)
	{
		"Upd" {
			Update
			Modules_Refresh -Function "ToWait -wait 2"
			Feature_More_Menu
		}
		"m" {
			Write-Host "`n  $($lang.MoreFeature)"
			Write-Host "  $('-' * 80)"
			if (Image_Is_Select_IAB) {
				Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"

				if (Verify_Is_Current_Same) {
					Write-Host "  $($lang.Mounted)" -ForegroundColor Green
					Feature_More_UI_Menu
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
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
		"a" {
			Clear-Host
			Write-Host "`n  $($lang.ViewMounted)" -ForegroundColor Green

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsImage -Mounted" -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Get-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Get.log" -Mounted | ForEach-Object {
				Write-Host "  $('-' * 80)"
				Write-Host "  $($lang.Select_Path)".PadRight(18) -NoNewline
				Write-Host $_.Path -ForegroundColor Green

				Write-Host "  $($lang.Image_Path)".PadRight(18) -NoNewline
				Write-Host $_.ImagePath -ForegroundColor Green

				Write-Host "  $($lang.MountedIndex)".PadRight(18) -NoNewline
				Write-Host $_.ImageIndex -ForegroundColor Green

				Write-Host "  $($lang.Mounted_Mode)".PadRight(18) -NoNewline
				Write-Host $_.MountMode -ForegroundColor Green

				Write-Host "  $($lang.Mounted_Status)".PadRight(18) -NoNewline
				Write-Host $_.MountStatus -ForegroundColor Green
				Write-Host "  $('-' * 80)`n"
			}

			Get_Next
			ToWait -wait 2
			Feature_More_Menu
		}
		"Unpack" {
			UnPack_Create_UI
			Get_Next
			ToWait -wait 2
			Feature_More_Menu
		}
		"Ceup" {
			Update_Create_UI
			ToWait -wait 2
			Feature_More_Menu
		}
		"View *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Feature_More_Menu
		}

		"Sel *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Feature_More_Menu
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Help -Command $PSItem
			ToWait -wait 2
			Feature_More_Menu
		}

		"zip" {
			Covert_Software_Package_Unpack

			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：挂载
		#>
		"mt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：挂载 + 索引号
		#>
		"mt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Mount_Index -Command $PSItem
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：保存当前映像
		#>
		"Se" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current
			ToWait -wait 2
			Feature_More_Menu
		}
		"Se -dns" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Save_Current -Dns
			ToWait -wait 2
			Feature_More_Menu
		}
		"Se *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Save_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：卸载，默认不保存
		#>
		"Unmt" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Eject_Dont_Save_Current
			ToWait -wait 2
			Feature_More_Menu
		}
		"Unmt *" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow
			Image_Unmount_Primary_Key_Shortcuts -Name $PSItem
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：保存
		#>
		"ESE" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.Save -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Eject_Forcibly_All -Save -DontSave

			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.快捷指令：强行卸载所有已挂载前：不保存
		#>
		"EDNS" {
			Write-Host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n  $($lang.Image_Unmount_After): " -NoNewline
			Write-Host $lang.DoNotSave -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Eject_Forcibly_All -DontSave

			ToWait -wait 2
			Feature_More_Menu
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Feature_More_Menu
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n  $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_OpenFolder -Command $PSItem
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			.开发者模式
		#>
		"Dev" {
			Menu_Shortcuts_Developers_Mode
			ToWait -wait 2
			Feature_More_Menu
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Feature_More_Menu"
		}

		<#
			热刷新：先决条件
		#>
		{ "RR", "r'r" -eq $_ } {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Feature_More_Menu"
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

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

	if (Test-Path -Path $test_mount_folder_Current -PathType Container) {
		$custom_array = @()
		try {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green
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
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		Check_Folder -chkpath $Save
		$TempSaveTo = "$($Save)\Index.$(Image_Get_Mount_Index).InBox.Apps.$(Get-Date -Format "yyyyMMddHHmmss").csv"

		Write-Host "`n  $($lang.SaveTo)"
		Write-Host "  $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.GetInBoxApps)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "  User Cancel" -ForegroundColor Red
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
			Write-Host "`n  Save To:"
			Write-Host "  `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "  User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}

		Remove-Item -path "$($TempSaveTo).ps1" -Force -ErrorAction SilentlyContinue
	} else {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.NotMounted)`n" -ForegroundColor Red
	}
}

Function Image_Get_Detailed
{
	param
	(
		$Filename,
		[Switch]$View
	)

	Write-Host "`n  $($lang.ViewWIMFileInfo)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($Filename)`n" -ForegroundColor Green

	if (Test-Path -Path $Filename -PathType Leaf) {
		$custom_array = @()

		try {
			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Get-WindowsImage -ImagePath ""$($Filename)""" -ForegroundColor Green
			}
	
			Get-WindowsImage -ImagePath $Filename -ErrorAction SilentlyContinue | ForEach-Object {
				$SetCurreltIndex = $_.ImageIndex

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Get-WindowsImage -ImagePath ""$($Filename)"" -index ""$($SetCurreltIndex)""" -ForegroundColor Green
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
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		$test_create_report_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Report"
		$test_create_report_folder_route = Join-Path -Path $Global:Mount_To_Route -ChildPath "Report"

		if (Image_Is_Select_IAB) {
			if (Verify_Is_Current_Same) {
				Check_Folder -chkpath $test_create_report_folder_Current
				$TempSaveTo = "$($test_create_report_folder_Current)\Index.$(Image_Get_Mount_Index).Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
			} else {
				Check_Folder -chkpath $test_create_report_folder_route
				$TempSaveTo = "$($test_create_report_folder_route)\Index.Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
			}
		} else {
			Check_Folder -chkpath $test_create_report_folder_route
			$TempSaveTo = "$($test_create_report_folder_route)\Index.Image.$(Get-Date -Format "yyyyMMddHHmmss").csv"
		}

		Write-Host "`n  $($lang.SaveTo)"
		Write-Host "  $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.ViewWIMFileInfo): $($Filename)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "  User Cancel" -ForegroundColor Red
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
			Write-Host "`n  Save To:"
			Write-Host "  `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "  User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}

		Remove-Item -path "$($TempSaveTo).ps1" -Force -ErrorAction SilentlyContinue
	} else {
		Write-Host "  $($lang.NoInstallImage)"
		Write-Host "  $($Filename)" -ForegroundColor Red
	}
}

Function Image_Get_Components_Package
{
	param
	(
		[Switch]$View,
		$Save
	)

	$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

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

			Write-Host "  $($lang.Operable)" -ForegroundColor Green
		} catch {
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			return
		}

		Check_Folder -chkpath $Save
		$TempSaveTo = "$($Save)\Index.$(Image_Get_Mount_Index).Components.$(Get-Date -Format "yyyyMMddHHmmss").csv"

		Write-Host "`n  $($lang.SaveTo)"
		Write-Host "  $($TempSaveTo)" -ForegroundColor Green
		$custom_array | Export-CSV -NoType -Path $TempSaveTo

@"
	`$custom_array_Export = @()
	`$multiple_output = Import-Csv "`$(`$PSScriptRoot)\$([IO.Path]::GetFileName($TempSaveTo))" | Out-GridView -Title "$($lang.GetImagePackage)" -passthru

	if (`$null -eq `$multiple_output) {
		Write-Host "  User Cancel" -ForegroundColor Red
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
			Write-Host "`n  Save To:"
			Write-Host "  `$(`$FileBrowser.FileName)" -ForegroundColor Green
			`$custom_array_Export | Export-CSV -NoType -Path `$FileBrowser.FileName
		} else {
			Write-Host "  User Cancel" -ForegroundColor Red
		}
	}
"@ | Out-File -FilePath "$($TempSaveTo).ps1" -Encoding UTF8 -ErrorAction SilentlyContinue

		if ($View) {
			powershell -NoLogo -NonInteractive -file "$($TempSaveTo).ps1" -wait
		}

		Remove-Item -path "$($TempSaveTo).ps1" -Force -ErrorAction SilentlyContinue
	} else {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.NotMounted)`n" -ForegroundColor Red
	}
}

Function Solutions_Open_Command
{
	param
	(
		$Name,
		[Switch]$Help = $False
	)

	if ($Help) {
		Write-Host
		Write-Host $(' ' * 2) -NoNewline
		Write-Host " Help O'D " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host " $($lang.OpenFolder)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$SaveToLogsPath = "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"

		Write-Host $(' ' * 7) -NoNewline
		if (Test-Path -Path $SaveToLogsPath -PathType Container) {
			Write-Host " O'D Log " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host "  $($lang.Logging)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $SaveToLogsPath -ForegroundColor Green
		} else {
			Write-Host " O'D Log " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host "  $($lang.Logging)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $SaveToLogsPath -ForegroundColor Red
		}

		Write-Host
		Write-Host $(' ' * 7) -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host " O'D MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host "   $($lang.MainImageFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host " O'D MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host "  $($lang.MainImageFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Image_source -ForegroundColor Red
		}

		Write-Host
		Write-Host $(' ' * 7) -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host "   $($lang.MountImageTo), $($lang.MainImageFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host "   $($lang.MountImageTo), $($lang.MainImageFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_Route -ForegroundColor Red
		}

		Write-Host
		Write-Host $(' ' * 7) -NoNewline
		if (Test-Path -Path $Global:Mount_To_RouteTemp -PathType Container) {
			Write-Host " O'D Temp " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.SettingImageTempFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Green
		} else {
			Write-Host " O'D Temp " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.SettingImageTempFolder)" -ForegroundColor Yellow
			Write-Host "        $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Red
		}

		return
	}

	Write-Host "`n  $($lang.OpenFolder) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	switch ($Name) {
		"Log" {
			Write-Host "  $($lang.Logging)" -ForegroundColor Green

			Write-Host "`n  $($lang.Select_Path): " -NoNewline
			$SaveToLogsPath = "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"
			Write-Host $SaveToLogsPath -ForegroundColor Green

			if (Test-Path -Path $SaveToLogsPath -PathType Container) {
				Write-Host "  $($lang.OpenFolder): " -NoNewline
				Start-Process $SaveToLogsPath
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"MN" {
			Write-Host "  $($lang.MainImageFolder)" -ForegroundColor Green

			Write-Host "`n  $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Image_source -ForegroundColor Green

			if (Test-Path -Path $Global:Image_source -PathType Container) {
				Write-Host "  $($lang.OpenFolder): " -NoNewline
				Start-Process $Global:Image_source
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"RT" {
			Write-Host "  $($lang.MountImageTo), $($lang.MainImageFolder)" -ForegroundColor Green

			Write-Host "`n  $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_Route -ForegroundColor Green

			if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
				Write-Host "  $($lang.OpenFolder): " -NoNewline
				Start-Process $Global:Mount_To_Route
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		"Temp" {
			Write-Host "  $($lang.SettingImageTempFolder)" -ForegroundColor Green

			Write-Host "`n  $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Mount_To_RouteTemp -ForegroundColor Green

			if (Test-Path -Path $Global:Mount_To_RouteTemp -PathType Container) {
				Write-Host "  $($lang.OpenFolder): " -NoNewline
				Start-Process $Global:Mount_To_RouteTemp
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			}
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}