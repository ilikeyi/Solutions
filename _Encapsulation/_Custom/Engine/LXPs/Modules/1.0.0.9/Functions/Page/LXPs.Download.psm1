<#
	.Windows system version, version number
	.Windows 系统版本、版本号
#>
$Global:OSCodename = @(
	("Windows Server Preview Build",     "20344"),
	("Windows Server 2022",              "20348"),
	("Windows 11 24H2",                  "26100"),
	("Windows 11 22H2 or 23H2",          "22621"),
	("Windows 11 21h2",                  "22000"),
	("Windows 10 Insider Preview Build", "19645"),
	("Windows 10 20H1 or later",         "19041"),
	("Windows 10 1903 or 1909",          "18362"),
	("Windows 10 1809",                  "17763"),
	("Windows 10 1803",                  "17134")
)

<#
	.Change the global default language user interface of the image package
	.更改映像包全局默认语言用户界面
#>
Function LXPs_Download
{
	write-host "`n  $($lang.LXPs)"
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function LXPs_Refresh_Sources_To_Event
	{
		$GetCurrentDisk = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\" -ErrorAction SilentlyContinue
		$RandomGuid = [guid]::NewGuid()

		if ($UI_Main_Download.Checked) {
			$UI_Main_Sync_Some_Location.Enabled = $False
			$UI_Main_Sync_Some_Location_Tips.Enabled = $False
			$UI_Main_Select_Folder.Enabled = $False
			$UI_Main_Select_Folder_Tips.Enabled = $False
			$UI_Main_Save_To.Text = Join-Path -Path $GetCurrentDisk -ChildPath "Download\Default"
		} else {
			$UI_Main_Sync_Some_Location.Enabled = $True
			$UI_Main_Sync_Some_Location_Tips.Enabled = $True
			if ($UI_Main_Sync_Some_Location.Checked) {
				if ([string]::IsNullOrEmpty($UI_Main_Download_Match_Version_Select.Text)) {
					$UI_Main_Save_To.Text = Join-Path -Path $GetCurrentDisk -ChildPath "Download\$($RandomGuid)"
				} else {
					$UI_Main_Save_To.Text = Join-Path -Path $GetCurrentDisk -ChildPath "Download\$($UI_Main_Download_Match_Version_Select.Text)"
				}
			} else {
				<#
					.Determine if the last selected directory has been saved
					.判断是否有已保存上次选择的目录
				#>
				if ([string]::IsNullOrEmpty($Script:InitalSaveToPath)) {
					$UI_Main_Save_To.Text = Join-Path -Path $GetCurrentDisk -ChildPath "Download\$($RandomGuid)"
				} else {
					$UI_Main_Save_To.Text = $Script:InitalSaveToPath
				}
			}
		}

		if ([string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
			$UI_Main_Save_To_License.Enabled = $False
			$UI_Main_Save_To_License_Tips.Enabled = $False
			$UI_Main_Save_To_Open_Folder.Enabled = $False
			$UI_Main_Save_To_Paste.Enabled = $False
			$UI_Main_Match_No_Select_Item.Enabled = $False
		} else {
			if (Test-Path $UI_Main_Save_To.Text -PathType Container) {
				$UI_Main_Save_To_License.Enabled = $True
				$UI_Main_Save_To_License_Tips.Enabled = $True
				$UI_Main_Save_To_Open_Folder.Enabled = $True
				$UI_Main_Save_To_Paste.Enabled = $True
				$UI_Main_Match_No_Select_Item.Enabled = $True
			} else {
				$UI_Main_Save_To_License.Enabled = $False
				$UI_Main_Save_To_License_Tips.Enabled = $False
				$UI_Main_Save_To_Open_Folder.Enabled = $False
				$UI_Main_Save_To_Paste.Enabled = $False
				$UI_Main_Match_No_Select_Item.Enabled = $False
			}
		}
	}

	<#
		.Event: Download all
		.事件：显示更改已知版本
	#>
	$UI_Main_Download_Match_Filter_Setting_Click = {
		$UI_Main_Download_Match_Version.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
		}
		$UI_Main_Download_Match_Version_Error.Text = ""
		$UI_Main_Download_Match_Version_Error_Icon.Image = $null
		$UI_Main_Download_Match_Version_Menu.Visible = $True
	}

	<#
		.Event: Download all
		.事件：下载全部
	#>
	$UI_Main_Download_Click = {
		if ($UI_Main_Download.Checked) {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "True" -String
			$UI_Main_Download_Menu.Enabled = $False
			$UI_Main_Download_Match_Version.Enabled = $False
			$UI_Main_Sync_Some_Location.Enabled = $False
			$UI_Main_Sync_Some_Location_Tips.Enabled = $False
		} else {
			Save_Dynamic -regkey "LXPs" -name "IsDownloadAll" -value "False" -String
			$UI_Main_Download_Menu.Enabled = $True
			$UI_Main_Download_Match_Version.Enabled = $True
			$UI_Main_Sync_Some_Location.Enabled = $True
			$UI_Main_Sync_Some_Location_Tips.Enabled = $True
		}

		LXPs_Refresh_Sources_To_Event
	}

	Function LXPs_Refresh_Sources_To_Status
	{
		$UI_Main_Mask_Report_Error.Text = ""
		$UI_Main_Mask_Report_Error_Icon.Image = $null

		$RandomGuid = [guid]::NewGuid()
		$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

		if (Test-Path -Path $UI_Main_Mask_Report_Sources_Path.Text -PathType Container) {
			if (Test_Available_Disk -Path $UI_Main_Mask_Report_Sources_Path.Text) {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $True
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $True
				$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
			} else {
				$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
				$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
				$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
			}
		} else {
			$UI_Main_Mask_Report_Sources_Open_Folder.Enabled = $False
			$UI_Main_Mask_Report_Sources_Paste.Enabled = $False
			$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.LXPs
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 530
		Dock           = 3
		Padding        = "15,10,0,0"
		BorderStyle    = 0
		autoScroll     = $True
	}

	<#
		.可用语言
	#>
	$UI_Main_Available_Languages_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 340
		margin         = "0,35,0,0"
		Text           = $lang.AvailableLanguages
	}
	$UI_Main_Languages_Detailed_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 495
		Padding        = "16,0,0,0"
		Text           = $lang.Detailed
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Languages_Detailed_View_Mask.Visible = $True
		}
	}
	$UI_Main_Available_Languages_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "18,0,0,0"
		autoScroll     = $False
	}
	$UI_Main_End_Wrap  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 495
	}

	<#
		.Mask: Displays rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Languages_Detailed_View_Mask = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 950
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Languages_Detailed_View_Mask_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 580
		Width          = 880
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	<#
		.Event, hide show rule details
		.事件，隐藏显示规则详细
	#>
	$UI_Main_Languages_Detailed_View_Mask_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Languages_Detailed_View_Mask.Visible = $False
		}
	}

	<#
		.Group: Select a known version number
		.组：选择已知版本号
	#>
	$UI_Main_Download_Match_Version_Menu = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 950
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Download_Match_Version_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 240
		Location       = "15,10"
		Text           = $lang.OSVersion
	}
	$UI_Main_Download_Match_Version = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 640
		Width          = 340
		Padding        = "8,0,8,0"
		Location       = "15,35"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}

	$UI_Main_Download_Match_Version_Select_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 400
		Location       = "405,15"
		Text           = $lang.LXPsFilter
	}
	$UI_Main_Download_Match_Version_Select = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 35
		Width          = 385
		Location       = "426,55"
		Text           = ""
		add_Click      = {
			$UI_Main_Download_Match_Version_Error.Text = ""
			$UI_Main_Download_Match_Version_Error_Icon.Image = $null
		}
	}
	$UI_Main_Download_Match_Version_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 150
		Width          = 385
		Location       = "425,95"
		Text           = $lang.LXPsDownloadTips
	}

	$UI_Main_Download_Match_Version_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,543"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Download_Match_Version_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,545"
		Height         = 45
		Width          = 255
		Text           = ""
	}
	$UI_Main_Download_Match_Version_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			<#
				.Verify that the custom ISO is saved to the directory name by default
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($UI_Main_Download_Match_Version_Select.Text)) {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '^\s') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				return
			}

			<#
				.Judgment: 3. Suffix cannot contain spaces
				.判断：3. 后缀不能带空格
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '\s$') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				return
			}

			<#
				.Judgment: 4. The suffix cannot contain multiple spaces
				.判断：4. 后缀不能带多空格
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '\s{2,}$') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				return
			}

			<#
				.Judgment: 5. There can be no two spaces in between
				.判断：5. 中间不能含有二个空格
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '\s{1,}') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				return
			}

			<#
				.Judgment: 6. Cannot contain: A-Z
				.判断：6. 不能包含：字母 A-Z
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '[A-Za-z]+') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorAZ)"
				return
			}

			<#
				.Judgment: 7. Cannot contain: \\ /: *? "" <> |
				.判断：7, 不能包含：\\ / : * ? "" < > |
			#>
			if ($UI_Main_Download_Match_Version_Select.Text -match '[~#$@!%&*{}<>?/|+".]') {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				return
			}

			<#
				.Judgment: 8. Can't be less than 5 characters
				.判断：8. 不能小于 5 字符
			#>
			if ($UI_Main_Download_Match_Version_Select.Text.length -lt 5) {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISOShortError -f "5")"
				return
			}

			<#
				.Judgment: 9. No more than 16 characters
				.判断：9. 不能大于 16 字符
			#>
			if ($UI_Main_Download_Match_Version_Select.Text.length -gt 16) {
				$UI_Main_Download_Match_Version_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Download_Match_Version_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "16")"
				return
			}

			$UI_Main_Download_Match_Version_Menu.Visible = $False

			<#
				.Verify that the custom ISO is saved to the directory name by default, ends, and saves the new path
				.验证自定义 ISO 默认保存到目录名，结束并保存新路径
			#>
			Save_Dynamic -regkey "LXPs" -name "LXPsSelect" -value $UI_Main_Download_Match_Version_Select.Text -String
			$UI_Main_Download_Match_Filter_Results.Text = $UI_Main_Download_Match_Version_Select.Text
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Script:Version = $UI_Main_Download_Match_Version_Select.Text

			LXPs_Refresh_Sources_To_Event
		}
	}
	$UI_Main_Download_Match_Version_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Download_Match_Version.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) { $_.Checked = $false }
			}
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Download_Match_Version_Menu.Visible = $False
		}
	}

	<#
		.Download all
		.下载全部
	#>
	$UI_Main_Download = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 385
		Text           = $lang.DownloadAll
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}

	$UI_Main_Download_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Padding        = "16,0,0,0"
		margin         = "0,0,0,30"
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}
	$UI_Main_Download_Match_Filter = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 450
		Text           = $lang.LXPsFilter
	}
	$UI_Main_Download_Match_Filter_Results = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = ""
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Download_Match_Filter_Setting_Click
	}
	$UI_Main_Download_Match_Filter_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 450
		Padding        = "16,0,0,0"
		Text           = $lang.OSVersion
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Download_Match_Filter_Setting_Click
	}
	$UI_Main_Download_Match_Filter_Setting_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,15,5"
		Text           = $lang.LXPsDownloadTips
	}

	$UI_Main_Download_Rename = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		margin         = "22,20,0,0"
		Text           = $lang.LXPsRename
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}
	$UI_Main_Download_Rename_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		Text           = $lang.LXPsRenameTips
	}

	$UI_Main_Download_Licence = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		margin         = "22,20,0,0"
		Text           = $lang.LicenseCreate
		Checked        = $True
		add_Click      = $UI_Main_Download_Click
	}
	$UI_Main_Download_Licence_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		Text           = $lang.LicenseCreateTips
	}

	<#
		.Save to
		.保存到
	#>
	$UI_Main_Save_To_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 455
		Text           = $lang.SaveTo
	}
	$UI_Main_Save_To = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 35
		Width          = 435
		margin         = "24,5,0,15"
		ReadOnly       = $True
		Text           = ""
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				$UI_Main_Mask_Report_Sources_Path.Text = $FolderBrowser.SelectedPath

				if (Test-Path -Path $FolderBrowser.SelectedPath -PathType Container) {
					if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
						$UI_Main_Save_To.Text    = $FolderBrowser.SelectedPath
						$Script:InitalSaveToPath = $FolderBrowser.SelectedPath

						<#
							.After the replacement is successful, turn off the Sync Check Box that matches the download location from location
							.更换成功后，关闭同步来源位置与下载位置一致，复选框
						#>
						$UI_Main_Sync_Some_Location.Checked = $False
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.Inoperable
					}
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Inoperable
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCancel
			}

			LXPs_Refresh_Sources_To_Event
		}
	}
	$UI_Main_Select_Folder_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.SelectFolderTips
	}

	$UI_Main_Sync_Some_Location = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.SaveToSync
		add_Click      = {
			if ($UI_Main_Sync_Some_Location.Checked) {
				Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "True" -String
			} else {
				Save_Dynamic -regkey "LXPs" -name "IsSyncSaveTo" -value "False" -String
			}

			LXPs_Refresh_Sources_To_Event

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.SaveToSync), $($lang.Done)"
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "IsSyncSaveTo" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Sync_Some_Location.Checked = $True
			}
			"False" {
				$UI_Main_Sync_Some_Location.Checked = $False
			}
		}
	} else {
		$UI_Main_Sync_Some_Location.Checked = $True
	}

	$UI_Main_Sync_Some_Location_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.SaveToSyncTips
	}

	<#
		.License
		.证书
	#>
	$UI_Main_Save_To_License = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.LicenseCreate
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			LXPs_Download_Licence_Process -Path $UI_Main_Save_To.Text
			$UI_Main.Close()
		}
	}
	$UI_Main_Save_To_License_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "36,0,15,0"
		margin         = "0,0,0,15"
		Text           = $lang.LicenseCreateTips
	}

	$UI_Main_Save_To_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $UI_Main_Save_To.Text -PathType Container) {
					Start-Process $UI_Main_Save_To.Text

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder): $($UI_Main_Save_To.Text), $($lang.Done)"
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder): $($UI_Main_Save_To.Text), $($lang.Inoperable)"
				}
			}
		}
	}
	$UI_Main_Save_To_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UI_Main_Save_To.Text

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	<#
		.Matches undownloaded items
		.匹配未下载项
	#>
	$UI_Main_Match_No_Select_Item = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		margin         = "22,5,0,0"
		Text           = $lang.MatchNoDownloadItem
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$TestNewFolderPathLep = Join-Path -Path $UI_Main_Save_To.Text -ChildPath "LocalExperiencePack"
			$QueueLXPsMatchNoItemSelect = @()

			if (Test-Path -Path $TestNewFolderPathLep -PathType Container) {
				$FolderDirect = $TestNewFolderPathLep
			} else {
				$FolderDirect = $UI_Main_Save_To.Text
			}

			if (Test-Path -Path $FolderDirect -PathType Container) {
				$Region = Language_Region
				ForEach ($itemRegion in $Region) {
					$TempNewFileFullPath = Join-Path -Path $FolderDirect -ChildPath "$($itemRegion.Region)\LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"

					if (-not (Test-Path -Path $TempNewFileFullPath -PathType Leaf)) {
						$QueueLXPsMatchNoItemSelect += $itemRegion.Region
					}
				}
			}

			if ($QueueLXPsMatchNoItemSelect.count -gt 0) {
				$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($($QueueLXPsMatchNoItemSelect) -contains $_.Tag) {
							$_.Checked = $True
						} else {
							$_.Checked = $False
						}
					}
				}

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.MatchNoDownloadItem), $($lang.Done)"
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.MatchDownloadNoNewitem
			}
		}
	}

	<#
		.Displays the report mask
		.显示报告蒙层
	#>
	$UI_Main_Mask_Report = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1025
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Report_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 665
		Width          = 530
		Padding        = "8,0,8,0"
		Location       = "15,10"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
	}
	$UI_Main_Mask_Report_Sources_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.AdvAppsDetailed
	}
	$UI_Main_Mask_Report_Sources_Name_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "16,0,0,0"
		Text           = $lang.AdvAppsDetailedTips
	}

	$UI_Main_Mask_Report_Sources_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
	}

	$UI_Main_Mask_Report_Sources_Path_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.ProcessSources
	}
	$UI_Main_Mask_Report_Sources_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 450
		margin         = "18,0,0,18"
		Text           = ""
		ReadOnly       = $True
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null
		}
	}
	$UI_Main_Mask_Report_Sources_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$RandomGuid = [guid]::NewGuid()
			$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

			$UI_Main_Mask_Report_Error_Icon.Image = $null
			$UI_Main_Mask_Report_Error.Text = ""

			$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				$UI_Main_Mask_Report_Sources_Path.Text = $FolderBrowser.SelectedPath

				if (Test-Path -Path $FolderBrowser.SelectedPath -PathType Container) {
					if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
						$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $FolderBrowser.SelectedPath -ChildPath "Report.$($RandomGuid).csv"
					} else {
						$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
					}

					LXPs_Refresh_Sources_To_Status

					$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
					$UI_Main_Mask_Report_Error.Text = "$($lang.SelectFolder), $($lang.Done)"
				} else {
					$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
				}
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.UserCancel
			}
		}
	}
	$UI_Main_Mask_Report_Sources_Open_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $UI_Main_Mask_Report_Sources_Path.Text -PathType Container) {
					Start-Process $UI_Main_Mask_Report_Sources_Path.Text

					$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
					$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder): $($UI_Main_Mask_Report_Sources_Path.Text), $($lang.Done)"
				} else {
					$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
					$UI_Main_Mask_Report_Error.Text = "$($lang.OpenFolder): $($UI_Main_Mask_Report_Sources_Path.Text), $($lang.Inoperable)"
				}
			}
		}
	}
	$UI_Main_Mask_Report_Sources_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UI_Main_Mask_Report_Sources_Path.Text

				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	$UI_Main_Mask_Report_Sources_Sync = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SaveToSync
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$RandomGuid = [guid]::NewGuid()
			$DesktopOldpath = [Environment]::GetFolderPath("Desktop")

			if (-not [string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
				$UI_Main_Mask_Report_Sources_Path.Text = $UI_Main_Save_To.Text

				if (Test-Path -Path $UI_Main_Save_To.Text -PathType Container) {
					if (Test_Available_Disk -Path $UI_Main_Save_To.Text) {
						$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $UI_Main_Save_To.Text -ChildPath "Report.$($RandomGuid).csv"
					} else {
						$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
					}
				} else {
					$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $DesktopOldpath -ChildPath "Report.$($RandomGuid).csv"
				}
			}

			LXPs_Refresh_Sources_To_Status

			$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
			$UI_Main_Mask_Report_Error.Text = "$($lang.SaveToSync), $($lang.Done)"
		}
	}

	$UI_Main_Mask_Report_Sources_Path_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
	}

	<#
		.The report is saved to
		.报告保存到
	#>
	$UI_Main_Mask_Report_Save_To_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.SaveTo
	}
	$UI_Main_Mask_Report_Save_To = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 35
		Width          = 450
		margin         = "20,0,0,18"
		Text           = ""
		ReadOnly       = $True
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null
		}
	}
	$UI_Main_Mask_Report_Select_Folder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			$RandomGuid = [guid]::NewGuid()

			$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
				FileName = "Report.$($RandomGuid).csv"
				Filter   = "Export CSV Files (*.CSV;)|*.csv;"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$UI_Main_Mask_Report_Save_To.Text = $FileBrowser.FileName

				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.SelectFolder), $($lang.Done)"
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.UserCancel
			}
		}
	}
	$UI_Main_Mask_Report_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 480
		Padding        = "16,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Mask_Report_Error.Text = ""
			$UI_Main_Mask_Report_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($UI_Main_Mask_Report_Save_To.Text)) {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UI_Main_Mask_Report_Save_To.Text

				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
				$UI_Main_Mask_Report_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	$UI_Main_Mask_Report_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,543"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Mask_Report_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,545"
		Height         = 45
		Width          = 255
		Text           = ""
	}
	$UI_Main_Mask_Report_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.OK
		add_Click      = {
			$MarkVerifyWrite = $False
			if (-not [string]::IsNullOrEmpty($UI_Main_Mask_Report_Sources_Path.Text)) {
				if (Test-Path -Path $UI_Main_Mask_Report_Sources_Path.Text -PathType Container) {
					$MarkVerifyWrite = $True
				}
			}

			if ($MarkVerifyWrite) {
				$UI_Main.Hide()
				LXPs_Download_Report_Process -Path $UI_Main_Mask_Report_Sources_Path.Text -SaveTo $UI_Main_Mask_Report_Save_To.Text
				$UI_Main.Close()
			} else {
				$UI_Main_Mask_Report_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Mask_Report_Error.Text = $lang.Inoperable
			}
		}
	}
	$UI_Main_Mask_Report_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Mask_Report.visible = $False
		}
	}

	<#
		.Displays a hint mask
		.显示提示蒙层
	#>
	$UI_Main_Tips_Mask = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 950
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Tips_Mask_Results = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 580
		Width          = 830
		BorderStyle    = 0
		Location       = "15,15"
		Text           = $lang.LXPsGetSNTips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Tips_Mask_DoNot = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "20,635"
		Height         = 40
		Width          = 440
		Text           = $lang.LXPsAddDelTips
		add_Click      = {
			if ($UI_Main_Tips_Mask_DoNot.Checked) {
				Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "True" -String
			} else {
				Save_Dynamic -regkey "LXPs" -name "LXPsTipsWarning" -value "False" -String
			}
		}
	}
	$UI_Main_Tips_Mask_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Tips_Mask.Visible = $False
		}
	}

	$UI_Main_Report    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,10"
		Height         = 36
		Width          = 280
		Text           = $lang.AdvAppsDetailed
		add_Click      = {
			$UI_Main_Mask_Report_Error_Icon.Image = $null
			$UI_Main_Mask_Report_Error.Text = ""

			$RandomGuid = [guid]::NewGuid()

			<#
				.Determine whether the save to is empty, if not, randomly generate a new save path
				.判断保存到是否为空，如果不为空则随机生成新的保存路径
			#>
			if ([string]::IsNullOrEmpty($UI_Main_Save_To.Text)) {
				$UI_Main_Mask_Report_Save_To.Text = Join-Path -Path $UI_Main_Save_To.Text -ChildPath "Report.$($RandomGuid).csv"
			} else {
				$UI_Main_Mask_Report_Sources_Path.Text = $UI_Main_Save_To.Text
			}

			LXPs_Refresh_Sources_To_Status
			$UI_Main_Mask_Report.visible = $True
		}
	}
	$UI_Main_Tips_Mask_View = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 280
		Text           = $lang.LXPsAddDelTipsView
		Location       = "620,500"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Tips_Mask.Visible = $True
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,543"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,545"
		Height         = 45
		Width          = 255
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,595"
		Height         = 36
		Width          = 280
		Text           = $lang.StartVerify
		add_Click      = {
			$Script:Queue_Language_Download_Select = @()

			$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$Script:Queue_Language_Download_Select += $_.Tag
						}
					}
				}
			}

			if ($Script:Queue_Language_Download_Select.count -gt 0) {
				Save_Dynamic -regkey "LXPs" -name "Select_Download_Language" -value $Script:Queue_Language_Download_Select -Multi
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.Not_Select)"
				return
			}

			$Script:IsDownload = $False
			$Script:IsRename = $False
			$Script:IsLicence = $False

			if ($UI_Main_Download.Checked) {
				$Script:IsDownload = $True
			} else {
				if ([string]::IsNullOrEmpty($Script:Version)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.OSVersion)"
					return
				}

				if ($UI_Main_Download_Rename.Checked) {
					$Script:IsRename = $True
				}

				if ($UI_Main_Download_Licence.Checked) {
					$Script:IsLicence = $True
				}
			}

			$UI_Main.Hide()
			LXPs_Download_Process
			$UI_Main.Close()
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Cancel
		add_Click      = {
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$Script:Queue_Language_Download_Select = @()
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Languages_Detailed_View_Mask,
		$UI_Main_Tips_Mask,
		$UI_Main_Mask_Report,
		$UI_Main_Download_Match_Version_Menu,
		$UI_Main_Menu,
		$UI_Main_Report,
		$UI_Main_Tips_Mask_View,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	<#
		.Mask: Displays language details
		.蒙板：显示语言详细信息
	#>
	$UI_Main_Languages_Detailed_View_Mask.controls.AddRange((
		$UI_Main_Languages_Detailed_View_Mask_Results,
		$UI_Main_Languages_Detailed_View_Mask_Canel
	))

	<#
		.You have new tips
		.你有新的提示
	#>
	$UI_Main_Tips_Mask.controls.AddRange((
		$UI_Main_Tips_Mask_Results,
		$UI_Main_Tips_Mask_DoNot,
		$UI_Main_Tips_Mask_Canel
	))

	<#
		.Mask, report
		.蒙板，报告
	#>
	$UI_Main_Mask_Report.controls.AddRange((
		$UI_Main_Mask_Report_Menu,
		$UI_Main_Mask_Report_Error_Icon,
		$UI_Main_Mask_Report_Error,
		$UI_Main_Mask_Report_OK,
		$UI_Main_Mask_Report_Canel
	))
	$UI_Main_Mask_Report_Menu.controls.AddRange((
		$UI_Main_Mask_Report_Sources_Name,
		$UI_Main_Mask_Report_Sources_Name_Tips,
		$UI_Main_Mask_Report_Sources_Wrap,

		$UI_Main_Mask_Report_Sources_Path_Name,
		$UI_Main_Mask_Report_Sources_Path,
		$UI_Main_Mask_Report_Sources_Select_Folder,
		$UI_Main_Mask_Report_Sources_Open_Folder,
		$UI_Main_Mask_Report_Sources_Paste,
		$UI_Main_Mask_Report_Sources_Sync,

		$UI_Main_Mask_Report_Sources_Path_Wrap,
		$UI_Main_Mask_Report_Save_To_Name,
		$UI_Main_Mask_Report_Save_To,
		$UI_Main_Mask_Report_Select_Folder,
		$UI_Main_Mask_Report_Paste
	))
	$UI_Main_Menu.controls.AddRange((
		<#
			.Select Download All
			.选择全部下载
		#>
		$UI_Main_Download,
		$UI_Main_Download_Menu,

		<#
			.Save to
			.保存到
		#>
		$UI_Main_Save_To_Name,
		$UI_Main_Save_To,

		<#
			.Open the catalog
			.打开目录
		#>
		$UI_Main_Save_To_Open_Folder,

		<#
			.Paste
			.粘贴
		#>
		$UI_Main_Save_To_Paste,

		<#
			.Select a directory
			.选择目录
		#>
		$UI_Main_Select_Folder,
		$UI_Main_Select_Folder_Tips,

		<#
			.The synchronization directory is the same as the version number
			.同步目录与版本号相同
		#>
		$UI_Main_Sync_Some_Location,
		$UI_Main_Sync_Some_Location_Tips,

		<#
			.Create a License .xml
			.创建 License.xml
		#>
		$UI_Main_Save_To_License,
		$UI_Main_Save_To_License_Tips,
		$UI_Main_Match_No_Select_Item,

		<#
			.Available languages
			.可用语言
		#>
		$UI_Main_Available_Languages_Name,
		$UI_Main_Languages_Detailed_View,
		$UI_Main_Available_Languages_Select,
		$UI_Main_End_Wrap
	))
	$UI_Main_Download_Menu.controls.AddRange((
		$UI_Main_Download_Match_Filter,
		$UI_Main_Download_Match_Filter_Results,
		$UI_Main_Download_Match_Filter_Setting,
		$UI_Main_Download_Match_Filter_Setting_Tips,
		$UI_Main_Download_Rename,
		$UI_Main_Download_Rename_Tips,
		$UI_Main_Download_Licence,
		$UI_Main_Download_Licence_Tips
	))
	$UI_Main_Download_Match_Version_Menu.controls.AddRange((
		$UI_Main_Download_Match_Version_Name,
		$UI_Main_Download_Match_Version,
		$UI_Main_Download_Match_Version_Select_Name,
		$UI_Main_Download_Match_Version_Select,
		$UI_Main_Download_Match_Version_Select_Tips,
		$UI_Main_Download_Match_Version_Error_Icon,
		$UI_Main_Download_Match_Version_Error,
		$UI_Main_Download_Match_Version_OK,
		$UI_Main_Download_Match_Version_Canel
	))

	<#
		.Gets the list of languages and initializes the selection
		.获取语言列表并初始化选择
	#>
	if (-not (Get-ItemProperty -Path  "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name 'Select_Download_Language' -ErrorAction SilentlyContinue)) {
		Save_Dynamic -regkey "LXPs" -name "Select_Download_Language" -value "" -Multi
	}
	$GetSelectLXPsLanguageRemove = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "Select_Download_Language"

	$SelectLXPsLanguageRemove = @()
	ForEach ($item in $GetSelectLXPsLanguageRemove) {
		$SelectLXPsLanguageRemove += $item
	}

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		if (-not ([string]::IsNullOrEmpty($itemRegion.LIP))) {
			$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
				Height  = 50
				Width   = 465
				Text    = "$($itemRegion.Region)`n$($itemRegion.Name)"
				Tag     = $itemRegion.Region
			}

			if ($SelectLXPsLanguageRemove -eq $itemRegion.Region) {
				$CheckBox.Checked = $True
			} else {
				$CheckBox.Checked = $False
			}

			$UI_Main_Available_Languages_Select.controls.AddRange($CheckBox)

			$UI_Main_Languages_Detailed_View_Mask_Results.Text += "    $($itemRegion.Name)`n   https://www.microsoft.com/store/productId/$($itemRegion.LIP)`n`n"
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue) {
		$GetLXPsSelect = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "LXPsSelect" -ErrorAction SilentlyContinue
		$UI_Main_Download_Match_Filter_Results.Text = $GetLXPsSelect
		$UI_Main_Download_Match_Version_Select.Text = $GetLXPsSelect
		$Script:Version = $GetLXPsSelect
	} else {
		$UI_Main_Download_Match_Filter_Results.Text = $lang.NoSetLabel
	}

	for ($i=0; $i -lt $Global:OSCodename.Count; $i++) {
		$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
			Height    = 40
			Width     = 310
			Text      = "$($Global:OSCodename[$i][0])`n$($Global:OSCodename[$i][1])"
			Tag       = $Global:OSCodename[$i][1]
			add_Click = {
				$UI_Main_Download_Match_Version_Error.Text = ""
				$UI_Main_Download_Match_Version_Error_Icon.Image = $null

				$UI_Main_Download_Match_Version.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.RadioButton]) {
						if ($_.Checked) {
							$UI_Main_Download_Match_Version_Select.Text = $_.Tag
						}
					}
				}
			}
		}

		$UI_Main_Download_Match_Version.controls.AddRange($CheckBox)
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "IsDownloadAll" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Download.Checked = $True
				$UI_Main_Download_Match_Version.Enabled = $False
				$UI_Main_Download_Menu.Enabled = $False
				$UI_Main_Sync_Some_Location.Enabled = $False
				$UI_Main_Sync_Some_Location_Tips.Enabled = $False
			}
			"False" {
				$UI_Main_Download.Checked = $False
				$UI_Main_Download_Match_Version.Enabled = $True
				$UI_Main_Download_Menu.Enabled = $True
				$UI_Main_Sync_Some_Location.Enabled = $True
				$UI_Main_Sync_Some_Location_Tips.Enabled = $True
			}
		}
	} else {
		$UI_Main_Download.Checked = $True
		$UI_Main_Download_Match_Version.Enabled = $False
		$UI_Main_Download_Menu.Enabled = $False
		$UI_Main_Sync_Some_Location.Enabled = $False
		$UI_Main_Sync_Some_Location_Tips.Enabled = $False
	}

	LXPs_Refresh_Sources_To_Event

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name LXPs).Author)\LXPs" -Name "LXPsTipsWarning" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Tips_Mask.Visible = $False
				$UI_Main_Tips_Mask_DoNot.Checked = $True
			}
			"False" {
				$UI_Main_Tips_Mask.Visible = $True
				$UI_Main_Tips_Mask_DoNot.Checked = $False
			}
		}
	} else {
		$UI_Main_Tips_Mask.Visible = $True
		$UI_Main_Tips_Mask_DoNot.Checked = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIImageSelectFunctionSelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $true }
		}
	})
	$GUIImageSelectFunctionSelectMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Available_Languages_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) { $_.Checked = $false }
		}
	})
	$UI_Main_Available_Languages_Select.ContextMenuStrip = $GUIImageSelectFunctionSelectMenu

	$UI_Main.ShowDialog() | Out-Null
}

Function LXPs_Download_Report_Process
{
	param
	(
		$Path,
		$SaveTo
	)

	$NewFolderLEP = Join-Path -Path $Path -ChildPath "LocalExperiencePack"
	if (Test-Path -Path $NewFolderLEP -PathType Container) {
		$FolderDirect = $NewFolderLEP
	} else {
		$FolderDirect = $Path
	}

	write-host "`n  $($lang.AdvAppsDetailed)"
	$QueueSelectLXPsReport = @()
	$RandomGuid = [guid]::NewGuid()
	$ISOTestFolderMain = Join-Path -Path $env:userprofile -ChildPath "AppData\Local\Temp\$($RandomGuid)"
	Check_Folder -chkpath $ISOTestFolderMain

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$TempNewFileFolderPath = Join-Path -Path $ISOTestFolderMain -ChildPath $itemRegion.Region
		$TempNewFileFullPath = Join-Path -Path $FolderDirect -ChildPath "$($itemRegion.Region)\LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			Check_Folder -chkpath $TempNewFileFolderPath

			Add-Type -AssemblyName System.IO.Compression.FileSystem
			$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
			$zipFile.Entries | where { $_.Name -like 'AppxManifest.xml' } | ForEach {
				[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $(Join-Path -Path $TempNewFileFolderPath -ChildPath $_.Name), $true)
			}
			$zipFile.Dispose()

			$TempNewFileAppxManifest = Join-Path -Path $TempNewFileFolderPath -ChildPath "AppxManifest.xml"
			if (Test-Path -Path $TempNewFileAppxManifest -PathType Leaf) {
				[xml]$xml = Get-Content -Path $TempNewFileAppxManifest

				$QueueSelectLXPsReport += [PSCustomObject]@{
					FileName           = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
					MatchLanguage      = $itemRegion.Region
					LXPsDisplayName    = $Xml.Package.Properties.DisplayName
					LXPsLanguage       = $Xml.Package.Resources.Resource.Language
					LXPsVersion        = $Xml.Package.Identity.Version
					TargetDeviceFamily = $Xml.Package.Dependencies.TargetDeviceFamily.Name
					MinVersion         = $Xml.Package.Dependencies.TargetDeviceFamily.MinVersion
					MaxVersionTested   = $Xml.Package.Dependencies.TargetDeviceFamily.MaxVersionTested
				}
			}
		} else {
			$QueueSelectLXPsReport += [PSCustomObject]@{
				FileName           = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
				MatchLanguage      = $itemRegion.Region
				LXPsDisplayName    = ""
				LXPsLanguage       = ""
				LXPsVersion        = ""
				TargetDeviceFamily = ""
				MinVersion         = ""
				MaxVersionTested   = ""
			}
		}
	}

	$QueueSelectLXPsReport | Export-CSV -NoTypeInformation -Path $SaveTo -Encoding UTF8

	Remove_Tree $ISOTestFolderMain
}

Function LXPs_Download_Licence_Process
{
	param
	(
		$Path
	)

	Add-Type -AssemblyName System.IO.Compression.FileSystem;

	$NewFolderLEP = Join-Path -Path $Path -ChildPath "LocalExperiencePack"
	if (Test-Path -Path $NewFolderLEP -PathType Container) {
		$FolderDirect = $NewFolderLEP
	} else {
		$FolderDirect = $Path
	}

	write-host "`n  $($lang.LicenseCreate)"
	$QueueLXPsLicenceSelect = @()
	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$TempNewFileFolderPath = Join-Path -Path $FolderDirect -ChildPath $itemRegion.Region
		$TempNewFileFullPath = Join-Path -Path $FolderDirect -ChildPath "$($itemRegion.Region)\LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"

		if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
			$QueueLXPsLicenceSelect += @{
				Language = $itemRegion.Region
				FileName = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
				OrgPath  = $TempNewFileFolderPath
			}
		}
	}

	if ($QueueLXPsLicenceSelect.count -gt 0) {
		write-host "  $($lang.YesWork)" -ForegroundColor Green

		write-host "`n  $($lang.ProcessSources)"
		write-host "  $('-' * 80)"
		write-host "  $($Path)"

		write-host "`n  $($lang.AddSources)"
		write-host "  $('-' * 80)"
		ForEach ($item in $QueueLXPsLicenceSelect) {
			write-host "  $($item.Language): ".PadRight(28) -NoNewline
			Write-Host $item.FileName
		}

		write-host "`n  $($lang.AddQueue)"
		write-host "  $('-' * 80)"
		ForEach ($item in $QueueLXPsLicenceSelect) {
			$TempNewFileFullPath = Join-Path -Path $item.OrgPath -ChildPath $item.FileName

			if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
				$Wait_Remove_Temp_File = Join-Path -Path $item.OrgPath -ChildPath "License.xml"

				write-host "  $($item.Language): ".PadRight(28) -NoNewline
				Remove-Item -Path $Wait_Remove_Temp_File -ErrorAction SilentlyContinue

				Add-Type -AssemblyName System.IO.Compression.FileSystem
				$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
				$zipFile.Entries | where { $_.Name -like 'License.xml' } | ForEach {
					[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $(Join-Path -Path $item.OrgPath -ChildPath $_.Name), $true)
				}
				$zipFile.Dispose()

				if (Test-Path -Path $Wait_Remove_Temp_File -PathType Leaf) {
					write-host "  $($lang.Done)" -ForegroundColor Green
				} else {
					write-host "  $($lang.Failed)" -ForegroundColor Red
				}
			}
		}
	} else {
		write-host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

Function LXPs_Download_Process
{
	if ($Script:Queue_Language_Download_Select.Count -gt 0) {
		write-host "  $($lang.YesWork)" -ForegroundColor Green

		write-host "`n  $($lang.AddSources)"
		write-host "  $('-' * 80)"
		ForEach ($item in $Script:Queue_Language_Download_Select) {
			write-host "  $($item)"
		}

		write-host "`n  $($lang.ProcessSources)"
		write-host "  $('-' * 80)"
		$Region = Language_Region
		ForEach ($itemRegion in $Region) {
			if ($Script:Queue_Language_Download_Select -Contains $itemRegion.Region) {
				$NewFolder = Join-Path -Path $UI_Main_Save_To.Text -ChildPath "LocalExperiencePack\$($itemRegion.Region)"
				Check_Folder -chkpath $NewFolder

				write-host "  $($itemRegion.Region): " -NoNewline -ForegroundColor Yellow
				Write-Host $itemRegion.Name -ForegroundColor Green

				write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
				Write-Host $NewFolder -ForegroundColor Green

				if ($Script:IsDownload) {
					LXPs_URL_Download_Process -NewLang $itemRegion.Region -StoreURL $itemRegion.LIP -SaveTo $NewFolder
				} else {
					$NewFilename = "LanguageExperiencePack.$($itemRegion.Region).Neutral.appx"
					write-host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
					Write-Host $NewFilename -ForegroundColor Green

					$test_new_Filename = Join-Path -Path $NewFolder -ChildPath $NewFilename
					if (Test-Path -Path $test_new_Filename -PathType Leaf) {
						write-host "  $($lang.AlreadyExists)`n" -ForegroundColor Green
					} else {
						LXPs_URL_Download_Process -NewLang $itemRegion.Region -StoreURL $itemRegion.LIP -SaveTo $NewFolder
					}
				}
			}
		}
	} else {
		write-host "  $($lang.NoWork)" -ForegroundColor Red
	}
}

function LXPs_URL_Download_Process
{
	param
	(
		$NewLang,
		$StoreURL,
		$SaveTo
	)

	$NewStoreURL = "https://www.microsoft.com/store/productId/$($StoreURL)"

	write-host "  $($lang.UpdateDownloadAddress): " -NoNewline -ForegroundColor Yellow
	Write-Host $NewStoreURL -ForegroundColor Green

	try {
		$wchttp = [System.Net.WebClient]::new()
		$URI = "https://store.rg-adguard.net/api/GetFiles"
		$myParameters = "type=url&url=$($NewStoreURL)"
		#&ring=Retail&lang=sv-SE"

		$wchttp.Headers[[System.Net.HttpRequestHeader]::ContentType]="application/x-www-form-urlencoded"
		$HtmlResult = $wchttp.UploadString($URI, $myParameters)
		$Start = $HtmlResult.IndexOf("<p>The links were successfully received from the Microsoft Store server.</p>")
	} catch {
		write-host "  $($lang.DownloadFailed)`n" -ForegroundColor Red
		return
	}

	if ($Start -eq -1) {
		write-host "  $($lang.Get_Link_Failed)`n"
		return
	}
	$TableEnd=($HtmlResult.LastIndexOf("</table>")+8)

	$SemiCleaned=$HtmlResult.Substring($start,$TableEnd-$start)

#	https://stackoverflow.com/questions/46307976/unable-to-use-ihtmldocument2
	$newHtml = New-Object -ComObject "HTMLFile"
	try {
#		This works in PowerShell with Office installed
		$newHtml.IHTMLDocument2_write($SemiCleaned)
	} catch {
#		This works when Office is not installed
		$src = [System.Text.Encoding]::Unicode.GetBytes($SemiCleaned)
		$newHtml.write($src)
	}

	$ToDownload = $newHtml.getElementsByTagName("a") | Select-Object textContent, href

	$LastFrontSlash = $NewStoreURL.LastIndexOf("/")
	$ProductID = $NewStoreURL.Substring($LastFrontSlash+1, $NewStoreURL.Length-$LastFrontSlash-1)

	if ([regex]::IsMatch($SaveTo, "([,!@?#$%^&*()\[\]]+|\\\.\.|\\\\\.|\.\.\\\|\.\\\|\.\.\/|\.\/|\/\.\.|\/\.|;|(?<![A-Za-z]):)|^\w+:(\w|.*:)")) {
		write-host "  $($lang.Path_Invalid_Failed)" -ForegroundColor Red
		write-host "  $($SaveTo)"
		return
	}

	ForEach ($Download in $ToDownload)
	{
		$InitalSaveToDownload = Join-Path -Path $SaveTo -ChildPath $Download.textContent
	
		if ($Script:IsDownload) {
			write-host "`n  $($lang.DownloadNow)"
			write-host "  $($Download.textContent)" -ForegroundColor Green

			if (Test-Path -Path $InitalSaveToDownload -PathType Leaf) {
				write-host "  $($lang.AlreadyExists)`n" -ForegroundColor Green
			} else {
				$wchttp.DownloadFile($Download.href, $InitalSaveToDownload)

				if (Test-Path -Path $InitalSaveToDownload -PathType Leaf) {
					write-host "  $($lang.Done)`n" -ForegroundColor Green
				} else {
					write-host "  $($lang.DownloadFailed)`n" -ForegroundColor Red
				}
			}
		} else {
			if ($Download.textContent -like "*$($Script:Version)*.appx") {
				write-host "`n  $($lang.DownloadNow)"
				write-host "  $($Download.textContent)"
				try {
					$wchttp.DownloadFile($Download.href, $InitalSaveToDownload)
				} catch {
					write-host "  $($lang.DownloadFailed)`n" -ForegroundColor Red
					return
				}

				if (Test-Path -Path $InitalSaveToDownload -PathType Leaf) {
					$SaveToNewFileLep = Join-Path -Path $SaveTo -ChildPath "LanguageExperiencePack.$($NewLang).Neutral.appx"
					write-host "  $($lang.Done)" -ForegroundColor Green

					<#
						.Renaming
						.改名
					#>
					write-host "`n  $($lang.LXPsRename)"
					if ($Script:IsRename) {
						write-host "  $($lang.UpdateAvailable)" -ForegroundColor Green
						write-host "  LanguageExperiencePack.$($NewLang).Neutral.appx"

						Rename-Item -Path $InitalSaveToDownload -NewName $SaveToNewFileLep -ErrorAction SilentlyContinue

						if (Test-Path -Path $SaveToNewFileLep -PathType Leaf) {
							write-host "  $($lang.Done)" -ForegroundColor Green
						} else {
							write-host "  $($lang.Failed)" -ForegroundColor Red
						}
					} else {
						write-host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
					}

					<#
						.License
						.证书
					#>
					write-host "`n  $($lang.LicenseCreate)"
					if ($Script:IsLicence) {
						$TempNewFileFullPath = $SaveToNewFileLep
						$NewFileLepLicense   = Join-Path -Path $SaveTo -ChildPath "License.xml"

						write-host "  $($lang.UpdateAvailable)" -ForegroundColor Green
						Remove-Item $NewFileLepLicense -ErrorAction SilentlyContinue

						if (Test-Path -Path $TempNewFileFullPath -PathType Leaf) {
							write-host "  $($TempNewFileFullPath)" -ForegroundColor Green

							try {
								Add-Type -AssemblyName System.IO.Compression.FileSystem
								$zipFile = [IO.Compression.ZipFile]::OpenRead($TempNewFileFullPath)
								$zipFile.Entries | where { $_.Name -like 'License.xml' } | ForEach {
									[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $(Join-Path -Path $SaveTo -ChildPath $_.Name), $true)
								}
								$zipFile.Dispose()

								if (Test-Path -Path $NewFileLepLicense -PathType Leaf) {
									write-host "  $($lang.Done)" -ForegroundColor Green
								} else {
									write-host "  $($lang.Failed)" -ForegroundColor Red
								}
							} catch {
								write-host "  $($lang.Failed)" -ForegroundColor Red
							}
						} else {
							write-host "  $($lang.Failed)" -ForegroundColor Red
						}
					} else {
						write-host "  $($lang.UpdateUnavailable)" -ForegroundColor Green
					}
				} else {
					write-host "  $($lang.DownloadFailed)`n" -ForegroundColor Red
				}
			}
		}
	}
}