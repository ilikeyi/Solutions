<#
  .Searched directory structure
  .搜索的目录结构
#>
$SearchUnPack = @(
	"Desktop"
	"Server"
)

$UnPackigtype = @(
	"*.iso"
	"*.gho"
)

<#
  .Compressed package name
  .压缩包名称
#>
$UnPackName = "$((Get-Module -Name Solutions).Author)Solutions.$(Get-Date -Format "yyyyMMddHHmmss")"

<#
  .Save the compressed package to
  .压缩包保存到
#>
$UnPackSaveTo = "$(Convert-Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue)\_Unpack"

<#
	.Archive temporary directory
	.压缩包临时目录
#>
$RandomFolderGuid = [guid]::NewGuid()
$TempFolderUnPack = "$(Convert-Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue)\_Unpack\$($RandomFolderGuid)"

<#
	.Exclude files or directories from the compressed package
	.从压缩包中排除文件或目录
#>
$ArchiveExcludeUnPack = @(
	"-xr-!_Unpack"
	"-xr-!_Encapsulation\Logs"
	"-xr-!_Encapsulation\_Custom\Engine\LXPs\Logs"
	"-xr-!_Encapsulation\_Custom\Engine\LXPs\AIO"
	"-xr-!_Encapsulation\_Custom\Engine\LXPs\Download"
	"-xr-!_Encapsulation\_Custom\Engine\Multilingual\Logs"
	"-xr-!_Encapsulation\_Custom\Engine\Multilingual\AIO"
	"-xr-!_Encapsulation\_Custom\Engine\Yi.Suite\Logs"
	"-xr-!_Encapsulation\_Custom\Engine\Yi.Suite\AIO"
	"-xr-!_Encapsulation\_Custom\Office\Setup.exe"
	"-xr-!_Encapsulation\_Custom\Office\2024\amd64\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\2024\x86\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\2021\amd64\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\2021\x86\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\365\amd64\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\365\x86\Office\Data"
	"-xr-!_Encapsulation\_Custom\Office\UWP"
)

<#
	.Generate compressed package format
	 To generate gz, xz, tar must be generated, otherwise it cannot be created.

	.生成压缩包格式
	 生成 gz, xz，需生成 tar，否则无法创建。
#>
$BuildTypeUnpack = @(
	[Archive]::zip
#	[Archive]::tar
#	[Archive]::xz
)

Enum Archive
{
	z7
	zip
	tar
	xz
	gz
}

<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function UnPack_Create_UI
{
	Logo -Title $lang.UpBackup

	Write-Host "  $($lang.UpBackup)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Image_Init_Disk_Sources

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.UpBackup
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$GUIUnPackSources  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 360
		Text           = $lang.UpSources -f $UnPackigtype
		Location       = '15,15'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($GUIUnPackSources.Checked) {
				$GUIUnPackShow.Enabled = $False
			} else {
				$GUIUnPackShow.Enabled = $True
			}
		}
	}
	$GUIUnPackShow     = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 530
		Width          = 360
		autoSizeMode   = 1
		Padding        = "28,0,8,0"
		Location       = "0,45"
		autoScroll     = $True
		Enabled        = $False
	}

	<#
		.创建升级包后需要做些什么
	#>
	$GUIUnPackRearTips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "420,15"
		Height         = 30
		Width          = 510
		Text           = $lang.UpCreateRear
	}
	$GUIUnPackGroupGPG = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 220
		Width          = 520
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '420,40'
	}
	$UI_Main_Create_ASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Text           = "$($lang.UpSources -f "PGP")"
		Location       = '26,0'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
				Save_Dynamic -regkey "Solutions\Unpack" -name "IsPGP_Unpack" -value "True" -String
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
				Save_Dynamic -regkey "Solutions\Unpack" -name "IsPGP_Unpack" -value "False" -String
			}
		}
	}
	$UI_Main_Create_ASC_Panel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 185
		Width          = 480
		autoSizeMode   = 1
		Padding        = "38,0,0,0"
		Location       = "0,35"
	}
	$GUIUnPackCreateASCClean = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.UpCleanOld
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIUnPackCreateASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.UpPgpPwd
	}
	$GUIUnPackCreateASCPWD = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Text           = $Global:secure_password
	}
	$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 410
	}
	$GUIUnPackASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.CreateASCAuthor
	}
	$GUIUnPackASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 400
		Text           = ""
		DropDownStyle  = "DropDownList"
	}

	$GUIUnPackCreateSHA256 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Location       = '426,290'
		Text           = "$($lang.UpSources -f "SHA256")"
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($GUIUnPackCreateSHA256.Checked) {
				$GUIUnPackCreateSHA256Clean.Enabled = $True
			} else {
				$GUIUnPackCreateSHA256Clean.Enabled = $False
			}
		}
	}
	$GUIUnPackCreateSHA256Clean = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 453
		Location       = '443,320'
		Text           = $lang.UpCleanOld
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIUnPackBackupExclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 453
		Text           = $lang.UpBackupExclude
		Location       = '426,380'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIUnPackBackupExcludeView = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 265
		Text           = $lang.Exclude_View
		Location       = "441,410"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UI_Main_View_Detailed.Visible = $True
			$UI_Main_View_Detailed_Show.Text = ""

			$UI_Main_View_Detailed_Show.Text += "   $($lang.ExcludeItem)`n"
			ForEach ($item in $ArchiveExcludeUnPack) {
				$UI_Main_View_Detailed_Show.Text += "       $($item)`n"
			}
		}
	}
	
	$UI_Create_Latest_Zip = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 360
		Text           = $lang.LevelLatest
		Location       = '15,600'
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Create_Latest_Zip.Checked) {
				Save_Dynamic -regkey "Solutions\Unpack" -name "IsLatest" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\Unpack" -name "IsLatest" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "IsLatest" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "IsLatest" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Create_Latest_Zip.Checked = $True
			}
			"False" {
				$UI_Create_Latest_Zip.Checked = $False
			}
		}
	} else {
		$UI_Create_Latest_Zip.Checked = $False
	}

	$GUIUnPackBackup   = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 360
		Text           = $lang.UpBackup
		add_Click      = {
			<#
				.备份时，排除不包含项
			#>
			if ($GUIUnPackBackupExclude.Checked) {
				$Script:BackupSoluionsExclude = $True
			} else {
				$Script:BackupSoluionsExclude = $False
			}

			<#
				.搜索到后生成 PGP
			#>
			$Script:UnPackCreateASC = $False
			$Script:UnPackCreateASCClean = $False
			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
					if ([string]::IsNullOrEmpty($GUIUnPackASCSign.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						return
					} else {
						Save_Dynamic -regkey "Solutions\Unpack" -name "PGP" -value $GUIUnPackASCSign.Text -String
						$Script:UnPackCreateASC = $True
						$Global:secure_password = $GUIUnPackCreateASCPWD.Text
						$Global:SignGpgKeyID = $GUIUnPackASCSign.Text
					}
				}

				if ($GUIUnPackCreateASCClean.Enabled) {
					if ($GUIUnPackCreateASCClean.Checked) {
						$Script:UnPackCreateASCClean = $True
					}
				}
			}

			<#
				.搜索到后生成 SHA256
			#>
			$Script:UnPackCreateSHA256 = $False
			$Script:UnPackCreateSHA256Clean = $False
			if ($GUIUnPackCreateSHA256.Enabled) {
				if ($GUIUnPackCreateSHA256.Checked) {
					$Script:UnPackCreateSHA256 = $True
				}

				if ($GUIUnPackCreateSHA256Clean.Enabled) {
					if ($GUIUnPackCreateSHA256Clean.Checked) {
						$Script:UnPackCreateSHA256Clean = $True
					}
				}
			}

			$RandomTempFileGuid = [guid]::NewGuid()
			Check_Folder -chkpath $TempFolderUnPack
			$test_temp_folder_guid = "$($TempFolderUnPack)\writetest-$($RandomTempFileGuid)"

			Out-File -FilePath $test_temp_folder_guid -Encoding utf8 -ErrorAction SilentlyContinue

			if (Test-Path -Path $test_temp_folder_guid -PathType Leaf) {
				$UI_Main.Hide()
				Remove-Item $test_temp_folder_guid -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

				UnPack_Compression_Process -Path (Convert-Path "$($PSScriptRoot)\..\..\..\..\..\..")
				UnPack_Create_SHA256_GPG -Path $TempFolderUnPack
				UnPack_Move_To -OldPath $TempFolderUnPack -NewPath $UnPackSaveTo
				Update_Create_Version -SaveTo $UnPackSaveTo -buildstring $((Get-Module -Name Solutions).PrivateData.PSData.Buildstring) -CurrentVersion (Get-Module -Name Solutions).Version.ToString() -LowVer $((Get-Module -Name Solutions).PrivateData.PSData.MinimumVersion)

				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.Inoperable): $($TempFolderUnPack)"
			}
		}
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 910
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_View_Detailed_Show = New-Object System.Windows.Forms.RichTextBox -Property @{
		BorderStyle    = 0
		Height         = 595
		Width          = 880
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_View_Detailed_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "662,635"
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main_View_Detailed.Visible = $False
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "415,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "440,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "415,635"
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$Script:SelectFolderList = @()

			<#
				.搜索到后生成 PGP
			#>
			$Script:UnPackCreateASC = $False
			$Script:UnPackCreateASCClean = $False
			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
					if ([string]::IsNullOrEmpty($GUIUnPackASCSign.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						return
					} else {
						Save_Dynamic -regkey "Solutions\Unpack" -name "PGP" -value $GUIUnPackASCSign.Text -String
						$Script:UnPackCreateASC = $True
						$Global:secure_password = $GUIUnPackCreateASCPWD.Text
						$Global:SignGpgKeyID = $GUIUnPackASCSign.Text
					}
				}

				if ($GUIUnPackCreateASCClean.Enabled) {
					if ($GUIUnPackCreateASCClean.Checked) {
						$Script:UnPackCreateASCClean = $True
					}
				}
			}

			<#
				.搜索到后生成 SHA256
			#>
			$Script:UnPackCreateSHA256 = $False
			$Script:UnPackCreateSHA256Clean = $False
			if ($GUIUnPackCreateSHA256.Enabled) {
				if ($GUIUnPackCreateSHA256.Checked) {
					$Script:UnPackCreateSHA256 = $True
				}

				if ($GUIUnPackCreateSHA256Clean.Enabled) {
					if ($GUIUnPackCreateSHA256Clean.Checked) {
						$Script:UnPackCreateSHA256Clean = $True
					}
				}
			}

			if ($GUIUnPackSources.Checked) {
				$UI_Main.Hide()
				ForEach ($item in $SearchUnPack) {
					$Script:SelectFolderList += Join-Path -Path $Global:MainMasterFolder -ChildPath $item
				}

				ForEach ($item in $Script:SelectFolderList) {
					Write-Host "  $($item)"
					UnPack_Create_SHA256_GPG -Path $item
				}
				$UI_Main.Close()
			} else {
				$GUIUnPackShow.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Enabled) {
							if ($_.Checked) {
								$Script:SelectFolderList += $_.Text
							}
						}
					}
				}

				if ($Script:SelectFolderList.Count -gt 0) {
					$UI_Main.Hide()
					ForEach ($item in $Script:SelectFolderList) {
						Write-Host "  $($item)"
						UnPack_Create_SHA256_GPG -Path $item
					}
					$UI_Main.Close()
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.UpdateServerNoSelect
				}
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "662,635"
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_View_Detailed,
		$GUIUnPackSources,
		$GUIUnPackShow,
		$UI_Create_Latest_Zip,
		$GUIUnPackBackup,
		$GUIUnPackBackupTips,
		$GUIUnPackBackupExclude,
		$GUIUnPackBackupExcludeView,
		$GUIUnPackRearTips,
		$GUIUnPackGroupGPG,
		$GUIUnPackCreateSHA256,
		$GUIUnPackCreateSHA256Clean,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$UI_Main_View_Detailed.controls.AddRange((
		$UI_Main_View_Detailed_Show,
		$UI_Main_View_Detailed_Canel
	))

	$GUIUnPackGroupGPG.controls.AddRange((
		$UI_Main_Create_ASC,
		$UI_Main_Create_ASC_Panel
	))

	$UI_Main_Create_ASC_Panel.controls.AddRange((
		$GUIUnPackCreateASCClean,
		$GUIUnPackCreateASCPWDName,
		$GUIUnPackCreateASCPWD,
		$UI_Add_End_Wrap,
		$GUIUnPackASCSignName,
		$GUIUnPackASCSign
	))

	ForEach ($item in $SearchUnPack) {
		$CheckBox         = New-Object System.Windows.Forms.CheckBox -Property @{
			Height        = 40
			Width         = 310
			Text          = Join-Path -Path $Global:MainMasterFolder -ChildPath $item
			Checked       = $True
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}
		$GUIUnPackShow.controls.AddRange($CheckBox)
	}

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIUnPackBackup.Enabled = $True
		$UI_Main_OK.Enabled = $True
	} else {
		$GUIUnPackSources.Enabled = $False
		$GUIUnPackCreateSHA256Clean.Enabled = $False

		$GUIUnPackBackup.Enabled = $False
		$UI_Main_OK.Enabled = $False

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += $lang.ZipStatus
	}

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $Global:GpgKI) {
		$GUIUnPackASCSign.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "PGP" -ErrorAction SilentlyContinue) {
		$GUIUnPackASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "PGP" -ErrorAction SilentlyContinue
	}

	<#
		.初始化复选框：生成 PGP
	#>
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIUnPackGroupGPG.Enabled = $True

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "IsPGP_Unpack" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\Unpack" -Name "IsPGP_Unpack" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Create_ASC.Checked = $True
				}
				"False" {
					$UI_Main_Create_ASC.Checked = $False
				}
			}
		} else {
			$UI_Main_Create_ASC.Checked = $False
		}
	} else {
		$GUIUnPackGroupGPG.Enabled = $False
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text += $lang.ASCStatus
	}

	if ($UI_Main_Create_ASC.Enabled) {
		if ($UI_Main_Create_ASC.Checked) {
			$UI_Main_Create_ASC_Panel.Enabled = $True
		} else {
			$UI_Main_Create_ASC_Panel.Enabled = $False
		}
	} else {
		$UI_Main_Create_ASC_Panel.Enabled = $False
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIUnPackAddMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIUnPackAddMenu.Items.Add($lang.AllSel).add_Click({
		$GUIUnPackShow.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIUnPackAddMenu.Items.Add($lang.AllClear).add_Click({
		$GUIUnPackShow.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GUIUnPackShow.ContextMenuStrip = $GUIUnPackAddMenu

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	$UI_Main.ShowDialog() | Out-Null
}


Function UnPack_Compression_Process
{
	param
	(
		$Path
	)

	ForEach ($item in $BuildTypeUnpack) {
		UnPack_Compression_Create_Format -Path $Path -Type $item
	}
}

Function UnPack_Compression_Create_Format
{
	Param
	(
		$Path,
		$Type
	)

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		Check_Folder -chkpath $TempFolderUnPack
		Push-Location $Path

		switch ($Type) {
			"z7" {
				Write-Host "  * $($UnPackName).7z, 3GB"
				Write-Host "    $($lang.Uping): " -NoNewline
				if ($Script:BackupSoluionsExclude) {
					$arguments = "a", "-m0=lzma2", "-v4096M", "$($TempFolderUnPack)\$($UnPackName).7z", "$($ArchiveExcludeUnPack)", "*.*", "-mcu=on", "-mx9";
				} else {
					$arguments = "a", "-m0=lzma2", "-v4096M", "$($TempFolderUnPack)\$($UnPackName).7z", "*.*", "-mcu=on", "-mx9";
				}
				Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host
			}
			"zip" {
				Write-Host "  * $($UnPackName).zip"
				Write-Host "    $($lang.Uping): " -NoNewline
				if ($Script:BackupSoluionsExclude) {
					$arguments = "a", "-tzip", "$($TempFolderUnPack)\$($UnPackName).zip", "$($ArchiveExcludeUnPack)", "*.*", "-mcu=on", "-r", "-mx9";
				} else {
					$arguments = "a", "-tzip", "$($TempFolderUnPack)\$($UnPackName).zip", "*.*", "-mcu=on", "-r", "-mx9";
				}
				Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host "`n  * latest.zip"
				if ($UI_Create_Latest_Zip.Checked) {
					Write-Host "    $($lang.Uping): " -NoNewline
					Copy-Item "$($TempFolderUnPack)\$($UnPackName).zip" -Destination "$($TempFolderUnPack)\latest.zip" -ErrorAction SilentlyContinue
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					Write-Host "    $($lang.SkipCreate): latest.zip"
				}

				Write-Host
			}
			"tar" {
				Write-Host "  * $($UnPackName).tar"
				Write-Host "    $($lang.Uping): " -NoNewline
				if ($Script:BackupSoluionsExclude) {
					$arguments = "a", "$($TempFolderUnPack)\$($UnPackName).tar", "$($ArchiveExcludeUnPack)", "*.*", "-r";
				} else {
					$arguments = "a", "$($TempFolderUnPack)\$($UnPackName).tar", "*.*", "-r";
				}
				Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host
			}
			"xz" {
				Write-Host "  * $($UnPackName).tar.xz"
				Write-Host "    $($lang.Uping): " -NoNewline
				if (Test-Path -Path "$($TempFolderUnPack)\$($UnPackName).tar") {
					$arguments = "a", "$($TempFolderUnPack)\$($UnPackName).tar.xz", "$($TempFolderUnPack)\$($UnPackName).tar", "-mf=bcj", "-mx9";
					Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					Write-Host "$($lang.SkipCreate): $UnPackName.tar"
				}

				Write-Host
			}
			"gz" {
				Write-Host "  * $($UnPackName).tar.gz"
				Write-Host "    $($lang.Uping): " -NoNewline
				if (Test-Path -Path "$($TempFolderUnPack)\$($UnPackName).tar") {
					$arguments = "a", "-tgzip", "$($TempFolderUnPack)\$($UnPackName).tar.gz", "$($TempFolderUnPack)\$($UnPackName).tar", "-mx9";
					Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					Write-Host "$($lang.SkipCreate): $UnPackName.tar"
				}

				Write-Host
			}
		}
	} else {
		Write-Host "  $($lang.ZipStatus)`n" -ForegroundColor Green
	}
}

Function UnPack_Create_SHA256_GPG
{
	param
	(
		$Path
	)

	remove-item -path "$($path)\*.tar" -force -ErrorAction SilentlyContinue

	$NewBuildTypeUnpack = @()
	ForEach ($item in $BuildTypeUnpack) {
		$NewBuildTypeUnpack += "*.$($item)"
	}

	Get-ChildItem $Path -Recurse -Include ($UnPackigtype + $NewBuildTypeUnpack) -ErrorAction SilentlyContinue | ForEach-Object {
		if (Test-Path -Path $_.FullName -PathType leaf) {
			Write-Host "  $($_.FullName)" -ForegroundColor Green
		}
	}
	Write-Host

	Get-ChildItem $Path -Recurse -Include ($UnPackigtype + $NewBuildTypeUnpack) -ErrorAction SilentlyContinue | ForEach-Object {
		$fullnewpath = $_.FullName
		$fullnewpathasc = "$($_.FullName).asc"
		$shortnameasc = [IO.Path]::GetFileName($_.FullName)
		$fullnewpathsha256 = "$($_.FullName).sha256"
		$shortnamesha256 = [IO.Path]::GetFileName($_.FullName)

		Write-Host "  * $($fullnewpath)"

		if ($Script:UnPackCreateASC) {
			$Verify_Install_Path = Get_ASC -Run "gpg.exe"
			if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
				Write-Host "    $($fullnewpathasc)"
				Write-Host "    $($lang.Uping): " -NoNewline

				if ($Script:UnPackCreateASCClean) {
					Remove-Item -path $fullnewpathasc -Force -ErrorAction SilentlyContinue
				}

				if (Test-Path -Path $fullnewpathasc -PathType leaf) {
					Write-Host $lang.Existed -ForegroundColor Green
				} else {
					Remove-Item -path $fullnewpathasc -Force -ErrorAction SilentlyContinue

					if ([string]::IsNullOrEmpty($Global:secure_password)) {
						Start-Process -FilePath $Verify_Install_Path -argument "--local-user ""$($Global:SignGpgKeyID)"" --output ""$($fullnewpathasc)"" --detach-sign ""$($fullnewpath)""" -Wait -WindowStyle Minimized
					} else {
						Start-Process -FilePath $Verify_Install_Path -argument "--pinentry-mode loopback --passphrase ""$($Global:secure_password)"" --local-user ""$($Global:SignGpgKeyID)"" --output ""$($fullnewpathasc)"" --detach-sign ""$($fullnewpath)""" -Wait -WindowStyle Minimized
					}

					if (Test-Path -Path $fullnewpathasc -PathType Leaf) {
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					} else {
						Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
					}
				}

				Write-Host
			} else {
				Write-Host "    $($lang.ASCStatus)`n" -ForegroundColor Red
			}
		}

		if ($Script:UnPackCreateSHA256) {
			Write-Host "    $($fullnewpath).sha256"
			Write-Host "    $($lang.Uping): " -NoNewline

			if ($Script:UnPackCreateSHA256Clean) {
				Remove-Item -Force -ErrorAction SilentlyContinue $fullnewpathsha256
			}

			if (Test-Path -Path $fullnewpathsha256 -PathType leaf) {
				Write-Host " $($lang.Existed) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Remove-Item -Force -ErrorAction SilentlyContinue $fullnewpathsha256

				$calchash = (Get-FileHash -Path $fullnewpath -Algorithm SHA256)
				"$($calchash.Hash)  $($shortnamesha256)" | Out-File -FilePath $fullnewpathsha256 -Encoding ASCII -ErrorAction SilentlyContinue
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}

			Write-Host
		}
	}
}

Function Update_Create_Version
{
	param
	(
		[string]$SaveTo,
		[string]$Buildstring,
		[string]$CurrentVersion,
		[string]$LowVer
	)

	$New_latest_Json_File = Join-Path -Path $SaveTo -ChildPath "latest.json"

@"
{
	"author": {
		"name": "$((Get-Module -Name Solutions).Author)",
		"url":  "$((Get-Module -Name Solutions).HelpInfoURI)"
	},
	"version": {
		"buildstring": "$($Buildstring)",
		"version":     "$($CurrentVersion)",
		"minau":       "$($LowVer)"
	},
	"changelog": {
		"title": "$((Get-Module -Name Solutions).Author)'s Solutions - Change log",
		"log":   "   - API: Application Programming Interface, Shortcut: (API *) * New\n   - New shortcut commands and dynamic UI * New"
	},
	"url": "$((Get-Module -Name Solutions).HelpInfoURI)/download/solutions/latest.zip"
}
"@ | Out-File -FilePath $New_latest_Json_File -Encoding Ascii

	Write-Host "`n  $($lang.Wim_Rule_Check)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $New_latest_Json_File -ForegroundColor Green

	Write-Host "  $($lang.Wim_Rule_Verify): " -NoNewline

	try {
		$Autopilot = Get-Content -Raw -Path $New_latest_Json_File | ConvertFrom-Json
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} catch {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

Function UnPack_Move_To
{
	param
	(
		$OldPath,
		$NewPath
	)
	Check_Folder -chkpath $NewPath

	Get-ChildItem $OldPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
		Move-Item -Path $_.FullName -Destination $NewPath -ErrorAction SilentlyContinue -force | Out-Null
	}
	remove-item -path $OldPath -Recurse -force -ErrorAction SilentlyContinue
}