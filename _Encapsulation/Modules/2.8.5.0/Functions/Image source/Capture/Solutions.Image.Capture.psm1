<#
	.Select the image source index number user interface
	.选择映像源索引号用户界面
#>
Function Image_Capture_UI
{
	Write-Host "`n  $($lang.Wim_Capture)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

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

		$SearchINIType = @(
			"*.ini"
		)

		if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
			foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
				if (Test-Path $filename -PathType Leaf) {
					$types = [IO.Path]::GetExtension($filename)
					if ($SearchINIType -contains "*$($types)") {
						$UI_Main_Capture_Config_Path.Text = $filename

						$UI_Main_Error.Text = "$($lang.Choose): $($filename), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.PleaseChoose) ( $($SearchINIType) )"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					}
				}

				if (Test-Path $filename -PathType Container) {
					$UI_Main_Capture_Sources_Path.Text = $filename
					$UI_Main_Error.Text = "$($lang.Choose) ( $($lang.Wim_Capture_Sources) ): $($filename), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			}
		}
	}
	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = $lang.Wim_Capture
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		AllowDrop      = $true
		Add_DragOver   = $UI_Main_DragOver
		Add_DragDrop   = $UI_Main_DragDrop
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	<#
		.捕捉来源
	#>
	$UI_Main_Capture_Sources = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.Wim_Capture_Sources
	}
	$UI_Main_Capture_Sources_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "18,0,0,25"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$UI_Main_Capture_Sources_Path_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "14,0,0,20"
		Text           = $lang.Wim_Capture_Sources_Tips
	}

	<#
		.事件：捕捉来源，选择目录
	#>
	$UI_Main_Capture_Sources_Path_Sel = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 530
		Padding        = "14,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$UI_Main_Capture_Sources_Path.Text = $FolderBrowser.SelectedPath

					try {
						$Current_Edition_Version = (Get-WindowsEdition -Path $FolderBrowser.SelectedPath).Edition
						$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $Current_Edition_Version
					} catch {

					}
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.FailedCreateFolder
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}
	$UI_Main_Capture_Sources_Path_Sel_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 55
		Width          = 530
		Padding        = "36,0,0,0"
		Text           = $lang.DropFolder
	}

	<#
		.事件：捕捉来源，打开目录
	#>
	$UI_Main_Capture_Sources_PathOpen = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 530
		Padding        = "14,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($UI_Main_Capture_Sources_Path.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
			} else {
				if (Test-Path -Path $UI_Main_Capture_Sources_Path.Text -PathType Container) {
					Start-Process $UI_Main_Capture_Sources_Path.Text

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				}
			}
		}
	}

	<#
		.事件：捕捉来源，复制路径
	#>
	$UI_Main_Capture_Sources_PathPaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 530
		Padding        = "14,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			if ([string]::IsNullOrEmpty($UI_Main_Capture_Sources_Path.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $UI_Main_Capture_Sources_Path.Text

				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}


	Function Solution_Capture_Refresh_Config
	{
		if ($UI_Main_Capture_Config.Checked) {
			$UI_Main_Capture_Config_Path.Enabled = $True
			$UI_Main_Capture_Config_Edit.Enabled = $True
			$UI_Main_Capture_Config_Select.Enabled = $True
		} else {
			$UI_Main_Capture_Config_Path.Enabled = $false
			$UI_Main_Capture_Config_Edit.Enabled = $false
			$UI_Main_Capture_Config_Select.Enabled = $false
		}
	}

	<#
		.配置文件路径（排除项）
	#>
	$UI_Main_Capture_Config = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 45
		Width          = 530
		margin         = "0,30,0,0"
		Text           = $lang.Wim_Config_File
		Checked        = $True
		add_Click      = { Solution_Capture_Refresh_Config }
	}

	<#
		.学习
	#>
	$UI_Main_Capture_Config_Learn = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 530
		Padding        = "14,0,0,0"
		Text           = $lang.Wim_Config_Learn
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.ForeColor = "#000000"

			$OpenWebsiteLink1 = "https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/hh825006(v=win.10)"
			Write-Host "  $($OpenWebsiteLink1)"
			Start-Process $OpenWebsiteLink1
		}
	}

	$UI_Main_Capture_Config_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "18,0,0,0"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Config_Path.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$TempWinScriptTemplatesFolder = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "Custom Captpure Templates"
	$TempWinScriptFilename = "WimScript.ini"
	$TempWinScriptFullFilename = Join-Path -Path $TempWinScriptTemplatesFolder -ChildPath $TempWinScriptFilename

	if (-not (Test-Path -Path $TempWinScriptFullFilename -PathType Leaf)) {
		New-Item -Path $TempWinScriptTemplatesFolder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (Test-Path -Path $TempWinScriptTemplatesFolder -PathType Container) {
@"
[ExclusionList]
\`$NTFS.LOG
\`$Recycle.Bin
\`$Windows.~bt
\`$Windows.~ls
\Hiberfil.SYS
\PageFile.SYS
\Swapfile.sys
\Recycled
\Recycler
\System Volume Information
\Windows\CSC
\Winpepge.SYS

[ExclusionException]

[CompressionExclusionList]
*.7Z
*.CAB
*.MP3
*.PNF
*.RAR
*.WIM
*.ZIP

[AlignmentList]

"@ | Out-File -FilePath $TempWinScriptFullFilename -Encoding utf8 -ErrorAction SilentlyContinue
		} else {
			$UI_Main_Capture_Config.Checked = $False
		}
	}

	if (Test-Path -Path $TempWinScriptFullFilename -PathType Leaf) {
		$UI_Main_Capture_Config_Path.Text = $TempWinScriptFullFilename
	} else {
		$UI_Main_Capture_Config_Path.Checked = $False
	}

	<#
		.编辑
	#>
	$UI_Main_Capture_Config_Edit = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 515
		margin          = "18,25,0,0"
		Text           = $lang.Wim_Config_Edit
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.ForeColor = "#000000"

			if ([string]::IsNullOrEmpty($UI_Main_Capture_Config_Path.Text)) {
				$UI_Main_Error.Text = "$($lang.Wim_Config_Edit), $($lang.Inoperable)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test-Path -Path $UI_Main_Capture_Config_Path.Text -PathType Leaf) {
					Start-Process $UI_Main_Capture_Config_Path.Text

					$UI_Main_Error.Text = "$($lang.OpenFile), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.OpenFile), $($lang.Inoperable)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	<#
		.选择源文件
	#>
	$UI_Main_Capture_Config_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 515
		margin          = "18,10,0,0"
		Text           = $lang.SelFile
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Capture_Config_Path.BackColor = "#FFFFFF"
			$UI_Main_Error.ForeColor = "#000000"

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "Ini Files (*.Ini)|*.Ini"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$UI_Main_Capture_Config_Path.Text = $FileBrowser.FileName
			} else {
				$UI_Main_Error.Text = $lang.UserCanel
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	<#
		.托动文件：提示
	#>
	$UI_Main_Capture_Config_Tips = New-Object System.Windows.Forms.Label -Property @{
		Height          = 35
		Width           = 530
		Text            = $lang.DropFile
		Padding         = "32,0,0,0"
	}
	Solution_Capture_Refresh_Config

	<#
		.详细
	#>
	$UI_Main_Capture_WIM_Detailed = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 533
		margin         = "0,35,0,0"
		Text           = $lang.Detailed
	}

	<#
		.映像名称
	#>
	$UI_Main_Capture_Image_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Wim_Image_Name
		Padding        = "18,0,0,0"
	}
	$UI_Main_Capture_Image_Name_New = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 475
		Margin         = "45,0,0,30"
		Text           = "New Image name"
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Image_Name_New.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.映像说明
	#>
	$UI_Main_Capture_Image_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Wim_Image_Description
		Padding        = "18,0,0,0"
	}
	$UI_Main_Capture_Image_Description_New = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 475
		Margin         = "45,0,0,30"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Image_Description_New.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.显示名称
	#>
	$UI_Main_Capture_Image_Display_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Wim_Display_Name
		Padding        = "18,0,0,0"
	}
	$UI_Main_Capture_Image_Display_Name_New = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 475
		Margin         = "45,0,0,30"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Image_Display_Name_New.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.显示说明
	#>
	$UI_Main_Capture_Image_Display_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Text           = $lang.Wim_Display_Description
		Padding        = "18,0,0,0"
	}
	$UI_Main_Capture_Image_Display_Description_New = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 475
		Margin         = "45,0,0,30"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Image_Display_Description_New.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.映像标志
	#>
	$UI_Main_Mask_Rule_Wim_Edition = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Edition
	}
	$UI_Main_Mask_Rule_Wim_Edition_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 498
		Text           = ""
		margin         = "22,0,0,25"
		BackColor      = "#FFFFFF"
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 530
		Padding        = "18,0,0,0"
		Text           = $lang.Wim_Edition_Select_Know
	}
	$UI_Main_Mask_Rule_Wim_Edition_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 482
		Margin         = "40,0,0,0"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
			$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $this.Text
		}
	}
	foreach ($item in $Global:WindowsEdition) {
		$UI_Main_Mask_Rule_Wim_Edition_Select.Items.Add($item) | Out-Null
	}

	<#
		.压缩类型
	#>
	$UI_Main_CompressionType = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 533
		Margin         = "0,35,0,0"
		Text           = $lang.CompressionType
		Checked        = $True
		add_Click      = {
			if ($UI_Main_CompressionType.Checked) {
				$UI_Main_Capture_Type_Select.Enabled = $True
			} else {
				$UI_Main_Capture_Type_Select.Enabled = $False
			}
		}
	}
	$UI_Main_Capture_Type_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 220
		Margin         = "30,0,0,0"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
		}
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$CompressionType = [Collections.ArrayList]@(
		[pscustomobject]@{ CompressionType = "Max";  Lang = $lang.CompressionType_Max; }
		[pscustomobject]@{ CompressionType = "Fast"; Lang = $lang.CompressionType_Fast; }
		[pscustomobject]@{ CompressionType = "None"; Lang = $lang.CompressionType_None; }
	)

	$UI_Main_Capture_Type_Select.BindingContext = New-Object System.Windows.Forms.BindingContext
	$UI_Main_Capture_Type_Select.Datasource = $CompressionType
	$UI_Main_Capture_Type_Select.ValueMember = "CompressionType"
	$UI_Main_Capture_Type_Select.DisplayMember = "Lang"

	<#
		.可选功能
	#>
	$UI_Main_Capture_Adv = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 533
		Margin         = "0,45,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.验证
	#>
	$UI_Main_Capture_Verify = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_Check
		add_Click      = {
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.检查完整性
	#>
	$UI_Main_Capture_CheckIntegrity = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_CheckIntegrity
		add_Click      = {
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.WIMBoot
	#>
	$UI_Main_Capture_WIMBoot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Wim_Rule_WIMBoot
		add_Click      = {
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.Setbootable
	#>
	$UI_Main_Capture_Bootable = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 530
		Padding        = "16,0,0,0"
		Text           = $lang.Win_Rule_Setbootable
		add_Click      = {
			$UI_Main_Capture_Sources_Path.BackColor = "#FFFFFF"

			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Capture_Bootable_Tips = New-Object system.Windows.Forms.Label -Property @{
		autoSize       = 1
		Padding        = "32,0,0,20"
		Text           = $lang.Win_Rule_Setbootable_Tips
	}

	<#
		.保存到
	#>
	$UI_Main_Capture_Save = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Margin         = "0,45,0,0"
		Text           = $lang.SaveTo
	}
	$UI_Main_Capture_Save_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "20,0,0,30"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$UI_Main_Capture_Save_Path.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$SaveFileToCapture = Join-Path -Path $Global:MainMasterFolder -ChildPath "_Backup\Capture\Capture.$(Get-Date -Format "yyyyMMddHHmmss").wim"
	$UI_Main_Capture_Save_Path.Text = $SaveFileToCapture

	$UI_Main_Capture_Save_Path_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 530
		Padding        = "14,0,0,0"
		Text           = $lang.SelFile
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Capture_Save_Path.BackColor = "#FFFFFF"

			$NewTempFileNameGUID = "Capture.$(Get-Date -Format "yyyyMMddHHmmss").wim"

			$FileBrowser = New-Object System.Windows.Forms.SaveFileDialog -Property @{
				FileName         = $NewTempFileNameGUID
				Filter           = "Export WIM Files (*.wim;)|*.wim;"
				InitialDirectory = $InitialPath
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				if (Test-Path -Path $FileBrowser.FileName -PathType leaf) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.Existed): $($FileBrowser.FileName)"
				} else {
					$SaveToName = [IO.Path]::GetDirectoryName($FileBrowser.FileName)
					if (Test_Available_Disk -Path $SaveToName) {
						$UI_Main_Capture_Save_Path.Text = $FileBrowser.FileName
						$UI_Main_Error.Text = "$($lang.Choose): $($FileBrowser.FileName), $($lang.Done)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.FailedCreateFolder
					}
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCanel
			}
		}
	}

	$UI_Main_Menu_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
	}

	$UI_Main_Tips      = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 280
		Width          = 270
		BorderStyle    = 0
		Location       = "625,15"
		Text           = $lang.Wim_Capture_Tips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,318"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,320"
		Height         = 260
		Width          = 255
		Text           = ""
	}

	$UI_Main_Capture_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Wim_Capture
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Arguments = @(
				"-ImagePath"
				"""$($UI_Main_Capture_Save_Path.Text)""",
				"-CapturePath",
				"""$($UI_Main_Capture_Sources_Path.Text)""",
				"-Name",
				"""$($UI_Main_Capture_Image_Name_New.Text)"""
			)

			<#
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($UI_Main_Capture_Sources_Path.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.Wim_Capture_Sources)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($UI_Main_Capture_Sources_Path.Text -match '^\s') {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 3. No spaces at the end
				.判断：3. 后缀不能带空格
			#>
			if ($UI_Main_Capture_Sources_Path.Text -match '\s$') {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 4. There can be no two spaces in between
				.判断：4. 中间不能含有二个空格
			#>
			if ($UI_Main_Capture_Sources_Path.Text -match '\s{2,}') {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			<#
				.Judgment: 5. Cannot contain: \\ /: *? "" <> |
				.判断：5, 不能包含：\\ / : * ? "" < > |
			#>
			if ($UI_Main_Capture_Sources_Path.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			if (Test-Path -Path $UI_Main_Capture_Sources_Path.Text -PathType Container) {
				if((Get-ChildItem $UI_Main_Capture_Sources_Path.Text -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {

				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.Wim_Capture_Sources_Tips
					$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
					return
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoInstallImage)"
				$UI_Main_Capture_Sources_Path.BackColor = "LightPink"
				return
			}

			<#
				.判断配置文件
			#>
			if ($UI_Main_Capture_Config.Checked) {
				if (Test-Path -Path $UI_Main_Capture_Config_Path.Text -PathType Leaf) {
					$Arguments += "-ConfigFilePath ""$($UI_Main_Capture_Config_Path.Text)"""
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.NoInstallImage): $($UI_Main_Capture_Config_Path.Text)"
					$UI_Main_Capture_Config_Path.BackColor = "LightPink"
					return
				}
			}

			<#
				.映像名称：1. 空值
			#>
			if ([string]::IsNullOrEmpty($UI_Main_Capture_Image_Name_New.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.Wim_Image_Name)"
				$UI_Main_Capture_Image_Name_New.BackColor = "LightPink"
				return
			}

			<#
				.判断保存到新的 WIM 文件
			#>
			if (Test-Path -Path $UI_Main_Capture_Save_Path.Text -PathType leaf) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.Existed): $($UI_Main_Capture_Save_Path.Text)"
				$UI_Main_Capture_Save_Path.BackColor = "LightPink"
				return
			} else {
				$SaveToName = [IO.Path]::GetDirectoryName($UI_Main_Capture_Save_Path.Text)
				if (Test_Available_Disk -Path $SaveToName) {
					
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.FailedCreateFolder
					return
				}
			}

			<#
				.通过后
			#>
			$UI_Main.Hide()

			<#
				.不判断：压缩类型
			#>
			Write-Host "`n  $($lang.CompressionType)" -ForegroundColor Yellow
			if ($UI_Main_CompressionType.Checked) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				$Arguments += "-CompressionType ""$($UI_Main_Capture_Type_Select.SelectedItem.CompressionType)"""
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			<#
				.可选项
			#>
				<#
					.验证
				#>
				Write-Host "`n  $($lang.Wim_Rule_Verify)" -ForegroundColor Yellow
				if ($UI_Main_Capture_Verify.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-Verify"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.检查完整性
				#>
				Write-Host "`n  $($lang.Wim_Rule_CheckIntegrity)" -ForegroundColor Yellow
				if ($UI_Main_Capture_CheckIntegrity.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-CheckIntegrity"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.可启动
				#>
				Write-Host "`n  $($lang.Wim_Rule_WIMBoot)" -ForegroundColor Yellow
				if ($UI_Main_Apply_WIMBoot.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-WIMBoot"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}

				<#
					.将卷映像标记为可启动映像
				#>
				Write-Host "`n  $($lang.Win_Rule_Setbootable)" -ForegroundColor Yellow
				if ($UI_Main_Capture_Bootable.Checked) {
					Write-Host "  $($lang.Operable)" -ForegroundColor Green
					$Arguments += "-Setbootable"
				} else {
					Write-Host "  $($lang.NoWork)" -ForegroundColor Red
				}


			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  New-WindowsImage $($Arguments)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
			}

			Write-Host
			write-host "  " -NoNewline 
			write-host " $($lang.Wim_Capture) " -NoNewline -BackgroundColor White -ForegroundColor Black
			try {
				Invoke-Expression -Command "New-WindowsImage -ScratchDirectory ""$(Get_Mount_To_Temp)"" -LogPath ""$(Get_Mount_To_Logs)\Capture.log"" $($Arguments)"
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

				<#
					.重命名详细
				#>
				Write-Host "`n  $($lang.Rename): " -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
				if (Test-Path -Path $wimlib -PathType Leaf) {
					$Arguments = "info ""$($UI_Main_Capture_Save_Path.Text)"" ""1"" --image-property NAME=""$($UI_Main_Capture_Image_Name_New.Text)"" --image-property DESCRIPTION=""$($UI_Main_Capture_Image_Description_New.Text)"" --image-property DISPLAYNAME=""$($UI_Main_Capture_Image_Display_Name_New.Text)"" --image-property DISPLAYDESCRIPTION=""$($UI_Main_Capture_Image_Display_Description_New.Text)"" --image-property FLAGS=""$($UI_Main_Mask_Rule_Wim_Edition_Edit.Text)"""

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Start-Process -FilePath ""$($wimlib)"" -ArgumentList '$($Arguments)'" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
					}

					Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
				}
			} catch {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				Write-Host "  $($_)" -ForegroundColor Red
			}

			$UI_Main.Close()
			Get_Next -DevCode "ic 1"
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Capture_OK
	))
	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Capture_Sources,
		$UI_Main_Capture_Sources_Path,
		$UI_Main_Capture_Sources_Path_Tips,
		$UI_Main_Capture_Sources_Path_Sel,
		$UI_Main_Capture_Sources_Path_Sel_Tips,
		$UI_Main_Capture_Sources_PathOpen,
		$UI_Main_Capture_Sources_PathPaste,
		$UI_Main_Capture_Config,
		$UI_Main_Capture_Config_Learn,
		$UI_Main_Capture_Config_Path,
		$UI_Main_Capture_Config_Edit,
		$UI_Main_Capture_Config_Select,
		$UI_Main_Capture_Config_Tips,

		$UI_Main_Capture_WIM_Detailed,
		$UI_Main_Capture_Image_Index_Name,
		$UI_Main_Capture_Image_Name,
		$UI_Main_Capture_Image_Name_New,
		$UI_Main_Capture_Image_Description,
		$UI_Main_Capture_Image_Description_New,
		$UI_Main_Capture_Image_Display_Name,
		$UI_Main_Capture_Image_Display_Name_New,
		$UI_Main_Capture_Image_Display_Description,
		$UI_Main_Capture_Image_Display_Description_New,

		$UI_Main_Mask_Rule_Wim_Edition,
		$UI_Main_Mask_Rule_Wim_Edition_Edit,
		$UI_Main_Mask_Rule_Wim_Edition_Select_Tips,
		$UI_Main_Mask_Rule_Wim_Edition_Select,

		$UI_Main_CompressionType,
		$UI_Main_Capture_Type_Select,

		$UI_Main_Capture_Adv,
		$UI_Main_Capture_Verify,
		$UI_Main_Capture_CheckIntegrity,
		$UI_Main_Capture_WIMBoot,
		$UI_Main_Capture_Bootable,
		$UI_Main_Capture_Bootable_Tips,

		$UI_Main_Capture_Save,
		$UI_Main_Capture_Save_Path,
		$UI_Main_Capture_Save_Path_Select,
		$UI_Main_Menu_Warp
	))

	if (Image_Is_Select_IAB) {
		$NewPathFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
		$UI_Main_Capture_Sources_Path.Text = $NewPathFolder

		try {
			$Current_Edition_Version = (Get-WindowsEdition -Path $NewPathFolder).Edition
			$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $Current_Edition_Version
		} catch {

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

	$UI_Main.ShowDialog() | Out-Null
}