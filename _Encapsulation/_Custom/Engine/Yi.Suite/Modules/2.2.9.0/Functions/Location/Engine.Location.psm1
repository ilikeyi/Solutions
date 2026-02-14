Function Change_Location
{
	Logo -Title $lang.LocationUserFolder
	write-host "  $($lang.LocationUserFolder)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	<#
		.初始化：获取当前位置
	#>
	$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
	if ([string]::IsNullOrEmpty($DesktopOldpath)) {
		$DesktopOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."Desktop"
	}

	$MyDocumentsOldpath = [Environment]::GetFolderPath("MyDocuments")
	if ([string]::IsNullOrEmpty($MyDocumentsOldpath)) {
		$MyDocumentsOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."Personal"
	}

	$DownloadsOldpath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
	$MusicOldpath = [Environment]::GetFolderPath("MyMusic")
	if ([string]::IsNullOrEmpty($MusicOldpath)) {
		$MusicOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Music"
	}

	$PicturesOldpath = [Environment]::GetFolderPath("MyPictures")
	if ([string]::IsNullOrEmpty($PicturesOldpath)) {
		$PicturesOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Pictures"
	}

	$VideoOldpath = [Environment]::GetFolderPath("MyVideos")
	if ([string]::IsNullOrEmpty($VideoOldpath)) {
		$VideoOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Videos"
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Change_Location_New_Path
	{
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateSet('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')]
			[string]$KnownFolder
		)

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			RootFolder   = "MyComputer"
		}
	
		if ($FolderBrowser.ShowDialog() -eq "OK") {
			if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
				switch ($KnownFolder) {
					"Desktop"   { $GUILocationItemDesktopShow.Text   = $FolderBrowser.SelectedPath }
					"Documents" { $GUILocationItemDocumentsShow.Text = $FolderBrowser.SelectedPath }
					"Downloads" { $GUILocationItemDownloadsShow.Text = $FolderBrowser.SelectedPath }
					"Music"     { $GUILocationItemMusicShow.Text     = $FolderBrowser.SelectedPath }
					"Pictures"  { $GUILocationItemPicturesShow.Text  = $FolderBrowser.SelectedPath }
					"Videos"    { $GUILocationItemVideosShow.Text    = $FolderBrowser.SelectedPath }
				}
			} else {
				$UI_Main_Error.Text = $lang.LocationFolderError
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	Function Change_Location_Refresh_Mount_Disk
	{
		$GUILocationPane1.controls.Clear()
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test_Available_Disk -Path $_.Root) {
				$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 35
					Width     = 345
					Text      = $_.Root
					Tag       = $_.Description
					add_Click = { Change_Location_Refresh }
				}
				if ($GUILocationLowSize.Checked) {
					if (-not (Verify_Available_Size -Disk $_.Root -Size $SelectLowSize.Text)) {
						$RadioButton.Enabled = $False
					}
				}
				$GUILocationPane1.controls.AddRange($RadioButton)
			}
		}
	}

	Function Change_Location_Refresh
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$FlagCheckDiskSelect = $False
		$GUILocationPane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$FlagCheckDiskSelect = $True
					$FlagsNewLabelSpecify = $_.Text

					if ($GUILocationCustomize.Checked) {
						<#
							.Mark: Determine the directory prefix
							.标记：判断目录前缀
						#>
						$FlagCheckFolderPrefix = $False

						<#
							.Necessary judgment
							.必备判断
						#>
						<#
							.Judgment: 1. Null value
							.判断：1. 空值
						#>
						if ([string]::IsNullOrEmpty($GUILocationCustomizeShow.Text)) {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoSetFolderLabel)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}

						<#
							.Judgment: 2. The prefix cannot contain spaces
							.判断：2. 前缀不能带空格
						#>
						if ($GUILocationCustomizeShow.Text -match '^\s') {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}

						<#
							.Judgment: 3. No spaces at the end
							.判断：3. 前缀不能带空格
						#>
						if ($GUILocationCustomizeShow.Text -match '\s$') {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}

						<#
							.Judgment: 4. There can be no two spaces in between
							.判断：4. 中间不能含有二个空格
						#>
						if ($GUILocationCustomizeShow.Text -match '\s{2,}') {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}

						<#
							.Judgment: 5. Cannot contain: \\ /: *? "" <> |
							.判断：5, 不能包含：\\ / : * ? "" < > |
						#>
						if ($GUILocationCustomizeShow.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}
						<#
							.Judgment: 6. No more than 260 characters
							.判断：6. 不能大于 260 字符
						#>
						if ($GUILocationCustomizeShow.Text.length -gt 128) {
							$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							return
						}

						$FlagsNewLabelSpecify += "$($GUILocationCustomizeShow.Text)\"
						Save_Dynamic -regkey "Suite\UserFolder" -name "Folder" -value "$($GUILocationCustomizeShow.Text)"
					}

					if ($GUILocationComputer.Checked) {
						$FlagsNewLabelSpecify += "$($env:COMPUTERNAME)\"
					}

					if ($GUILocationUsers.Checked) {
						$FlagsNewLabelSpecify += "Users\"
					}

					if ($GUILocationUserName.Checked) {
						$FlagsNewLabelSpecify += "$($env:UserName)\"
					}

					if ($GUILocationItemDesktop.Checked) {
						$GUILocationItemDesktopShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Desktop"
					}

					if ($GUILocationItemDocuments.Checked) {
						$GUILocationItemDocumentsShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Documents"
					}

					if ($GUILocationItemDownloads.Checked) {
						$GUILocationItemDownloadsShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Downloads"
					}

					if ($GUILocationItemMusic.Checked) {
						$GUILocationItemMusicShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Music"
					}

					if ($GUILocationItemPictures.Checked) {
						$GUILocationItemPicturesShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Pictures"
					}

					if ($GUILocationItemVideos.Checked) {
						$GUILocationItemVideosShow.Text = Join-Path -Path $FlagsNewLabelSpecify -ChildPath "Videos"
					}
				}
			}
		}
		if (-not ($FlagCheckDiskSelect)) {
			$GUILocationItemDesktopShow.Text = $DesktopOldpath
			$GUILocationItemDocumentsShow.Text = $MyDocumentsOldpath
			$GUILocationItemDownloadsShow.Text = $DownloadsOldpath
			$GUILocationItemMusicShow.Text = $MusicOldpath
			$GUILocationItemPicturesShow.Text = $PicturesOldpath
			$GUILocationItemVideosShow.Text = $VideoOldpath
		}
	}

	$GUILocation       = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1015
		Text           = $lang.LocationUserFolder
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\Assets\icon\Yi.ico")
	}

	<#
		.可选功能
	#>
	$GUILocationAdv    = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 410
		Text           = $lang.AdvOption
		Location       = '10,10'
	}
	$GUILocationStructure = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 396
		Text           = $lang.LocationStructure
		Location       = '24,38'
	}
	$GUILocationCustomize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.FolderLabel
		Location       = '40,66'
		add_Click      = {
			if ($GUILocationCustomize.Checked) {
				$GUILocationCustomizeShow.Enabled = $True
				Save_Dynamic -regkey "Suite\UserFolder" -name "AllowCustomize" -value "True"
			} else {
				$GUILocationCustomizeShow.Enabled = $False
				Save_Dynamic -regkey "Suite\UserFolder" -name "AllowCustomize" -value "False"
			}
			Change_Location_Refresh
		}
	}
	$GUILocationCustomizeShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 350
		Text           = ""
		Location       = '56,94'
		BackColor      = "#FFFFFF"
		add_Click      = { Change_Location_Refresh }
	}
	$GUILocationCustomizeTips = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 80
		Width          = 355
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Padding        = 0
		Dock           = 0
		Location       = '52,125'
	}
	$GUILocationVerifyErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.VerifyNameTips
	}
	$GUILocationComputer = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.LocationComputer
		Location       = '40,215'
		add_Click      = { Change_Location_Refresh }
	}
	$GUILocationUsers  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 380
		Text           = "Users"
		Location       = '40,250'
		add_Click      = { Change_Location_Refresh }
	}
	$GUILocationUserName = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.LocationUserName
		Location       = '40,285'
		Checked        = $True
		add_Click      = { Change_Location_Refresh }
	}

	$GUILocationSize   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 410
		Text           = $lang.SelectAutoAvailable
		Location       = '10,330'
	}
	$GUILocationLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.SelectCheckAvailable
		Location       = '26,360'
		Checked        = $True
		add_Click      = {
			if ($GUILocationLowSize.Checked) {
				$SelectLowSize.Enabled = $True
			} else {
				$SelectLowSize.Enabled = $False
			}
			Change_Location_Refresh_Mount_Disk
		}
	}
	$SelectLowSize     = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 22
		Width          = 60
		Location       = "45,390"
		Value          = 1
		Minimum        = 1
		Maximum        = 999999
		TextAlign      = 1
		add_Click      = { Change_Location_Refresh_Mount_Disk }
	}
	$SelectLowUnit     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 80
		Text           = "GB"
		Location       = "115,394"
	}
	$GUILocationTitle  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 380
		Text           = $lang.ChangeInstallDisk
		Location       = '24,440'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Change_Location_Refresh_Mount_Disk }
	}
	$GUILocationPane1  = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 115
		Width          = 385
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "8,8,8,8"
		Dock           = 0
		Location       = '30,463'
	}

	$GUILocationCurrent = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 385
		Text           = $lang.LocationCurrent
		Location       = '30,605'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUILocationItemDesktopShow.Text = $DesktopOldpath
			$GUILocationItemDocumentsShow.Text = $MyDocumentsOldpath
			$GUILocationItemDownloadsShow.Text = $DownloadsOldpath
			$GUILocationItemMusicShow.Text = $MusicOldpath
			$GUILocationItemPicturesShow.Text = $PicturesOldpath
			$GUILocationItemVideosShow.Text = $VideoOldpath
		}
	}
	$GUILocationInitial = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 385
		Text           = $lang.LocationInitial
		Location       = '30,635'
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUILocationItemDesktopShow.Text   = Join-Path -Path $env:USERPROFILE -ChildPath "Desktop"
			$GUILocationItemDocumentsShow.Text = Join-Path -Path $env:USERPROFILE -ChildPath "Documents"
			$GUILocationItemDownloadsShow.Text = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads"
			$GUILocationItemMusicShow.Text     = Join-Path -Path $env:USERPROFILE -ChildPath "Music"
			$GUILocationItemPicturesShow.Text  = Join-Path -Path $env:USERPROFILE -ChildPath "Pictures"
			$GUILocationItemVideosShow.Text    = Join-Path -Path $env:USERPROFILE -ChildPath "Videos"
		}
	}

	<#
		.迁移的项目
	#>
	$GUILocationItem   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 430
		Text           = $lang.LocationUserFolderTips
		Location       = '472,15'
	}
	$GUILocationItemPanel = New-Object System.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 355
		Width          = 500
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '490,45'
		autoScroll     = $True
	}
	$GUILocationItemDesktop = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationDesktop
		Location       = '0,0'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemDesktop.Checked) {
				$GUILocationItemDesktopSelect.Enabled = $True
			} else {
				$GUILocationItemDesktopSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemDesktopShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,25'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemDesktopSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,25'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Desktop" }
		Text           = "..."
	}
	$GUILocationItemDocuments = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationDocuments
		Location       = '0,85'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemDocuments.Checked) {
				$GUILocationItemDocumentsSelect.Enabled = $True
			} else {
				$GUILocationItemDocumentsSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemDocumentsShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,110'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemDocumentsSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,110'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Documents" }
		Text           = "..."
	}

	$GUILocationItemDownloads = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationDownloads
		Location       = '0,170'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemDownloads.Checked) {
				$GUILocationItemDownloadsSelect.Enabled = $True
			} else {
				$GUILocationItemDownloadsSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemDownloadsShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,195'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemDownloadsSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,195'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Downloads" }
		Text           = "..."
	}

	$GUILocationItemMusic = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationMusic
		Location       = '0,255'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemMusic.Checked) {
				$GUILocationItemMusicSelect.Enabled = $True
			} else {
				$GUILocationItemMusicSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemMusicShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,280'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemMusicSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,280'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Music" }
		Text           = "..."
	}

	$GUILocationItemPictures = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationPictures
		Location       = '0,340'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemPictures.Checked) {
				$GUILocationItemPicturesSelect.Enabled = $True
			} else {
				$GUILocationItemPicturesSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemPicturesShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,365'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemPicturesSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,365'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Pictures" }
		Text           = "..."
	}

	$GUILocationItemVideos = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 475
		Text           = $lang.LocationVideos
		Location       = '0,425'
		Checked        = $True
		add_Click      = {
			if ($GUILocationItemVideos.Checked) {
				$GUILocationItemVideosSelect.Enabled = $True
			} else {
				$GUILocationItemVideosSelect.Enabled = $False
			}
		}
	}
	$GUILocationItemVideosShow = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 425
		Text           = ""
		Location       = '18,450'
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUILocationItemVideosSelect = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = '450,450'
		Height         = 22
		Width          = 25
		add_Click      = { Change_Location_New_Path -KnownFolder "Videos" }
		Text           = "..."
	}

	<#
		.更改完成后
	#>
	$GUILocationFinish = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 430
		Text           = $lang.LocationDone
		Location       = '472,440'
	}
	$GUILocationFinishSync = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 490
		Text           = $lang.LocationDoneSync
		Location       = '492,470'
		Checked        = $True
	}
	$GUILocationFinishClear = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 490
		Text           = $lang.LocationDoneClean
		Location       = '492,505'
		ForeColor      = "#0000FF"
	}
	$GUILocationFinishClearTips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 38
		Width          = 475
		Text           = $lang.LocationDoneCleanTips
		Location       = '508,530'
	}
	
	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "492,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "517,600"
		Height         = 30
		Width          = 470
		Text           = ""
	}
	$GUILocationOK     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "492,635"
		Height         = 36
		Width          = 495
		Text           = $lang.OK
		add_Click      = {
			$GUILocation.Hide()
			if ($GUILocationFinishSync.Checked) {
				$Global:LocationFinishSync = $True
			} else {
				$Global:LocationFinishSync = $False
			}

			if ($GUILocationFinishClear.Checked) {
				$Global:LocationFinishClear = $True
			} else {
				$Global:LocationFinishClear = $False
			}

			if ($GUILocationItemDesktop.Checked) {
				Change_Location_Set_Path -KnownFolder "Desktop" -NewFolder $GUILocationItemDesktopShow.Text
			}

			if ($GUILocationItemDocuments.Checked) {
				Change_Location_Set_Path -KnownFolder "Documents" -NewFolder $GUILocationItemDocumentsShow.Text
			}

			if ($GUILocationItemDownloads.Checked) {
				Change_Location_Set_Path -KnownFolder "Downloads" -NewFolder $GUILocationItemDownloadsShow.Text
			}

			if ($GUILocationItemMusic.Checked) {
				Change_Location_Set_Path -KnownFolder "Music" -NewFolder $GUILocationItemMusicShow.Text
			}

			if ($GUILocationItemPictures.Checked) {
				Change_Location_Set_Path -KnownFolder "Pictures" -NewFolder $GUILocationItemPicturesShow.Text
			}

			if ($GUILocationItemVideos.Checked) {
				Change_Location_Set_Path -KnownFolder "Videos" -NewFolder $GUILocationItemVideosShow.Text
			}
			$GUILocation.Close()
		}
	}
	$GUILocation.controls.AddRange((
		$GUILocationSize,
		$GUILocationLowSize,
		$SelectLowSize,
		$SelectLowUnit,
		$GUILocationTitle,
		$GUILocationPane1,
		$GUILocationAdv,
		$GUILocationCustomize,
		$GUILocationCustomizeShow,
		$GUILocationCustomizeTips,
		$GUILocationStructure,
		$GUILocationComputer,
		$GUILocationUsers,
		$GUILocationUserName,
		$GUILocationFinish,
		$GUILocationFinishSync,
		$GUILocationFinishClear,
		$GUILocationFinishClearTips,
		$GUILocationItem,
		$GUILocationItemPanel,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$GUILocationCurrent,
		$GUILocationInitial,
		$GUILocationOK
	))
	$GUILocationItemPanel.controls.AddRange((
		$GUILocationItemDesktop,
		$GUILocationItemDesktopShow,
		$GUILocationItemDesktopSelect,
		$GUILocationItemDocuments,
		$GUILocationItemDocumentsShow,
		$GUILocationItemDocumentsSelect,
		$GUILocationItemDownloads,
		$GUILocationItemDownloadsShow,
		$GUILocationItemDownloadsSelect,
		$GUILocationItemMusic,
		$GUILocationItemMusicShow,
		$GUILocationItemMusicSelect,
		$GUILocationItemPictures,
		$GUILocationItemPicturesShow,
		$GUILocationItemPicturesSelect,
		$GUILocationItemVideos,
		$GUILocationItemVideosShow,
		$GUILocationItemVideosSelect
	))
	$GUILocationCustomizeTips.controls.AddRange((
		$GUILocationVerifyErrorMsg
	))

	<#
		.Checkbox: Customize the new directory
		.复选框：自定义新的目录
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Suite\UserFolder" -Name "AllowCustomize" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Suite\UserFolder" -Name "AllowCustomize" -ErrorAction SilentlyContinue) {
			"True" {
				$GUILocationCustomize.Checked = $True
				$GUILocationCustomizeShow.Enabled = $True
			}
			"False" {
				$GUILocationCustomize.Checked = $False
				$GUILocationCustomizeShow.Enabled = $False
			}
		}
	} else {
		$GUILocationCustomize.Checked = $False
		$GUILocationCustomizeShow.Enabled = $False
		Save_Dynamic -regkey "Suite\UserFolder" -name "AllowCustomize" -value "False"
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Suite\UserFolder" -Name "Folder" -ErrorAction SilentlyContinue) {
		$GetNewFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Suite\UserFolder" -Name "Folder" -ErrorAction SilentlyContinue
		$GUILocationCustomizeShow.Text = $GetNewFolder
	} else {
		$GUILocationCustomizeShow.Text = $Global:MainImageLang
	}

	Change_Location_Refresh
	Change_Location_Refresh_Mount_Disk

	if ($Global:EventQueueMode) {
		$GUILocation.Text = "$($GUILocation.Text) [ $($lang.QueueMode) ]"
	} else {
	}

	$GUILocation.ShowDialog() | Out-Null
}

Function Change_Location_Set_Path
{
	Param
	(
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]$KnownFolder,
		
		[Parameter(Mandatory = $true)]
		[string]$NewFolder
	)

	$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
	if ([string]::IsNullOrEmpty($DesktopOldpath)) {
		$DesktopOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."Desktop"
	}

	$MyDocumentsOldpath = [Environment]::GetFolderPath("MyDocuments")
	if ([string]::IsNullOrEmpty($MyDocumentsOldpath)) {
		$MyDocumentsOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."Personal"
	}

	$DownloadsOldpath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
	$MusicOldpath = [Environment]::GetFolderPath("MyMusic")
	if ([string]::IsNullOrEmpty($MusicOldpath)) {
		$MusicOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Music"
	}

	$PicturesOldpath = [Environment]::GetFolderPath("MyPictures")
	if ([string]::IsNullOrEmpty($PicturesOldpath)) {
		$PicturesOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Pictures"
	}

	$VideoOldpath = [Environment]::GetFolderPath("MyVideos")
	if ([string]::IsNullOrEmpty($VideoOldpath)) {
		$VideoOldpath = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")."My Videos"
	}

	# Define known folder GUIDs
	$KnownFoldersGuids = @{
		"Desktop"   = @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
		"Documents" = @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
		"Downloads" = @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
		"Music"     = @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
		"Pictures"  = @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
		"Videos"    = @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
	}

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "KnownFolders"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
	}
	if (-not ("WinAPI.KnownFolders" -as [type]))
	{
		Add-Type @Signature
	}

	ForEach ($GUID in $KnownFoldersGuids[$KnownFolder])
	{
		[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$GUID, 0, 0, $NewFolder)
	}

	$UserShellFoldersGUIDs = @{
		"Desktop"   = "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}"
		"Documents" = "{F42EE2D3-909F-4907-8871-4C22FC0BF756}"
		"Downloads" = "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}"
		"Music"     = "{A0C69A99-21C8-4671-8703-7934162FCF1D}"
		"Pictures"  = "{0DDD015D-B06C-45D5-8C4C-F59713854639}"
		"Videos"    = "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}"
	}

	switch ($KnownFolder) {
		"Desktop" {
			$MarkNewFolderPath = $DesktopOldpath
			write-host "  $($lang.LocationDesktop)" -ForegroundColor Green
		}
		"Documents" {
			$MarkNewFolderPath = $MyDocumentsOldpath
			write-host "  $($lang.LocationDocuments)" -ForegroundColor Green
		}
		"Downloads" {
			$MarkNewFolderPath = $DownloadsOldpath
			write-host "  $($lang.LocationDownloads)" -ForegroundColor Green
		}
		"Music" {
			$MarkNewFolderPath = $MusicOldpath
			write-host "  $($lang.LocationMusic)" -ForegroundColor Green
		}
		"Pictures" {
			$MarkNewFolderPath = $PicturesOldpath
			write-host "  $($lang.LocationPictures)" -ForegroundColor Green
		}
		"Videos" {
			$MarkNewFolderPath = $VideoOldpath
			write-host "  $($lang.LocationVideos)" -ForegroundColor Green
		}
		default {
			write-host "   $($KnownFolder)" -ForegroundColor Red
		}
	}
	
	write-host "  $($lang.LocationFolderOld): " -NoNewline
	Write-host $MarkNewFolderPath

	write-host "  $($lang.LocationFolderNew): " -NoNewline
	Write-host $NewFolder

	if ($MarkNewFolderPath -eq $NewFolder) {
		write-host "  $($lang.LocationFolderSame)`n" -ForegroundColor Red
		return
	} else {
		Check_Folder -chkpath $NewFolder

		if (Test_Available_Disk -Path $NewFolder) {
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersGUIDs[$KnownFolder] -PropertyType ExpandString -Value $NewFolder -Force -ErrorAction SilentlyContinue | Out-Null

			write-host "  $($lang.LocationDoneSync)"
			if ($Global:LocationFinishSync) {
				start-process "robocopy.exe" -argumentlist "`"$($MarkNewFolderPath)`" `"$($NewFolder)`" /E /XO /W:1 /R:1" -wait -WindowStyle Minimized
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.LocationDoneClean)"
			if ($Global:LocationFinishClear) {
				Remove-Item -Path $MarkNewFolderPath -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		} else {
			write-host "  $($lang.FailedCreateFolder)"
			write-host "  $NewFolder)`n" -ForegroundColor Red
		}
	}
}