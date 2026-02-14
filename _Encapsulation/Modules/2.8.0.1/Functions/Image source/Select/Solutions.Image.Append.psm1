<#
	.Add image source user interface
	.添加映像源用户界面
#>
Function Image_Select_Append_UI
{
	Write-Host "`n  $($lang.SelectSettingImage): $($lang.Wim_Append)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$Script:Temp_Save_Select_WIMFile = @()

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.事件：查看详细内容
	#>
	Function Image_Select_Append_Index_Detial
	{
		param
		(
			$Index
		)

		<#
			.清除所有旧的信息
		#>
		$UI_Main_Mask_Rule_Wim_Image_Index.Text = ""
		$UI_Main_Mask_Rule_Wim_Image_Name_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Image_Description_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Display_Name_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Display_Description_Edit.Text = ""
		$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = ""

		$UI_Main_Mask_Rule_Wim_Architecture.Text = $lang.Architecture
		$UI_Main_Mask_Rule_Wim_Language.Text = $lang.Language
		$UI_Main_Mask_Rule_Wim_CreatedTime.Text = $lang.Wim_CreatedTime
		$UI_Main_Mask_Rule_Wim_ModifiedTime.Text = $lang.Wim_ModifiedTime
		$UI_Main_Mask_Rule_Wim_FileCount.Text = $lang.Wim_FileCount
		$UI_Main_Mask_Rule_Wim_DirectoryCount.Text = $lang.Wim_DirectoryCount
		$UI_Main_Mask_Rule_Wim_Expander_Space.Text = $lang.Wim_Expander_Space
		$UI_Main_Mask_Rule_Wim_System_Version.Text = ""

		ForEach ($item in $Script:Temp_Save_Select_WIMFile) {
			if ($item.GUID -eq $index) {
				<#
					.映像路径
				#>
				$UI_Main_Mask_Rule_Wim_Image_Path.Text = $item.FilePath

				<#
					.索引号
				#>
				$UI_Main_Mask_Rule_Wim_Image_Index.Text = $item.ImageIndex

				<#
					.映像名称
				#>
				$UI_Main_Mask_Rule_Wim_Image_Name_Edit.Text = $item.ImageName

				<#
					.映像说明
				#>
				$UI_Main_Mask_Rule_Wim_Image_Description_Edit.Text = $item.ImageDescription

				<#
					.显示名称
				#>
				$UI_Main_Mask_Rule_Wim_Display_Name_Edit.Text = $item.DISPLAYNAME

				<#
					.显示说明
				#>
				$UI_Main_Mask_Rule_Wim_Display_Description_Edit.Text = $item.DISPLAYDESCRIPTION

				<#
					.映像标志
				#>
				$UI_Main_Mask_Rule_Wim_Edition_Edit.Text = $item.EditionId

				<#
					.架构
				#>
				switch ($item.Architecture) {
					0 {
						$New_Architecture = "x86"
					}
					9 {
						$New_Architecture = "x64"
					}
					Default 
					{
						$New_Architecture = "arm64"
					}
				}
				$UI_Main_Mask_Rule_Wim_Architecture.Text = "$($lang.Architecture): $($New_Architecture)"

				<#
					.语言
				#>
				$UI_Main_Mask_Rule_Wim_Language.Text = "$($lang.Language): $($item.Language)"

				<#
					.创建日期
				#>
				$UI_Main_Mask_Rule_Wim_CreatedTime.Text = "$($lang.Wim_CreatedTime): $($item.CreatedTime)"

				<#
					.上次修改时间
				#>
				$UI_Main_Mask_Rule_Wim_ModifiedTime.Text = "$($lang.Wim_ModifiedTime): $($item.LastModifiTime)"

				<#
					.文件数目
				#>
				$UI_Main_Mask_Rule_Wim_FileCount.Text = "$($lang.Wim_FileCount): $($item.FILECOUNT)"

				<#
					.目录数目
				#>
				$UI_Main_Mask_Rule_Wim_DirectoryCount.Text = "$($lang.Wim_DirectoryCount): $($item.DirectoryCount)"

				<#
					.展开空间
				#>

				$UI_Main_Mask_Rule_Wim_Expander_Space.Text = "$($lang.Wim_Expander_Space): $(ConvertFrom-Bytes -Bytes $item.ImageSize)"

				<#
					.系统版本
				#>
				$UI_Main_Mask_Rule_Wim_System_Version.Text = "$($lang.Editions): $($item.Version)"
			}
		}

		$UI_Main_Mask_Rule_Detailed.Visible = $True
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 928
		Text           = "$($lang.SelectSettingImage): $($lang.Wim_Append)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 675
		Width          = 550
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,20,8,8"
		Dock           = 3
	}

	$UI_Main_Setting_ISO = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 280
		Location       = "620,10"
		Text           = $lang.ISO_File
		add_Click      = {
			Image_Select -Page "ISO"
		}
	}

	$UI_Main_Select_Custom_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,50"
		Height         = 36
		Width          = 280
		Text           = $lang.SelFile
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
				Filter = "Image Files (*.WIM;*.ESD;*.SWM)|*.wim;*.esd;*.swm;|WIM Image (*.WIM)|*.wim|ESD Image (*.esd)|*.ESD|SWM Split Image (*.swm)|*.swm"
			}

			if ($FileBrowser.ShowDialog() -eq "OK") {
				$Script:Temp_Save_Select_WIMFile = @()
				foreach ($item in $Global:Primary_Key_Image.Index.EditionId) {
					$Script:AddKnowVersion += $item
				}

				$UI_Main_Menu.controls.Clear()

				if ($Global:Developers_Mode) {
					Write-Host "`n  $($lang.Developers_Mode_Location): 82" -ForegroundColor Green
				}

				$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
				if (Test-Path -Path $wimlib -PathType Leaf) {
					$LabelNewFilename = New-Object system.Windows.Forms.Label -Property @{
						AutoSize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.FileName): $($FileBrowser.FileName)"
					}
					$LabelNewFilename_Warp = New-Object system.Windows.Forms.Label -Property @{
						Height         = 10
						Width          = 525
					}
					$UI_Main_Menu.controls.AddRange((
						$LabelNewFilename,
						$LabelNewFilename_Warp
					))

					$RandomGuid = [guid]::NewGuid()
					$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
					$Arguments = "info ""$($FileBrowser.FileName)"" --extract-xml ""$($Export_To_New_Xml)"""
					Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

					if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
						[XML]$empDetails = Get-Content $Export_To_New_Xml

						ForEach ($empDetail in $empDetails.wim.IMAGE) {
							$RandomGuid = [guid]::NewGuid()
							$NewLASTMODIFICATIONTIME = ConvertToDate -lowpart $empDetail.CREATIONTIME.LOWPART -highpart $empDetail.CREATIONTIME.HIGHPART
							$NewLastModifiTime = ConvertToDate -lowpart $empDetail.LASTMODIFICATIONTIME.LOWPART -highpart $empDetail.LASTMODIFICATIONTIME.HIGHPART

							$Script:Temp_Save_Select_WIMFile += [pscustomobject]@{
								GUID               = $RandomGuid
								ImageIndex         = $empDetail.index
								ImageName          = $empDetail.NAME
								ImageDescription   = $empDetail.DESCRIPTION
								DISPLAYNAME        = $empDetail.DISPLAYNAME
								DISPLAYDESCRIPTION = $empDetail.DISPLAYDESCRIPTION
								EditionId          = $empDetail.WINDOWS.EDITIONID
								Architecture       = $empDetail.WINDOWS.ARCH
								CreatedTime        = $(Get-Date $NewLASTMODIFICATIONTIME -Format "MM/dd/yyyy HH:mm:ss tt")
								LastModifiTime     = $(Get-Date $NewLastModifiTime -Format "MM/dd/yyyy HH:mm:ss tt")
								FileCount          = $empDetail.FILECOUNT
								DirectoryCount     = $empDetail.DIRCOUNT
								ImageSize          = $empDetail.TOTALBYTES
								Language           = [string]$empDetail.WINDOWS.LANGUAGES.LANGUAGE
								Version            = "$($empDetail.WINDOWS.VERSION.BUILD).$($empDetail.WINDOWS.VERSION.SPBUILD)"
								FilePath           = $FileBrowser.FileName
							}

							$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
								Name      = $RandomGuid
								Height    = 35
								Width     = 470
								Padding   = "16,0,0,0"
								Text      = "$($lang.MountedIndex): $($empDetail.index)"
								Tag       = $empDetail.index
								checked   = $true
							}

							if ($UI_Main_Duplication.checked) {
								if ($Script:AddKnowVersion -contains $empDetail.WINDOWS.EDITIONID) {
									$CheckBox.Enabled = $False
								}
							}

							$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Edition): $($empDetail.FLAGS)"
							}
							$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 18
								Width          = 525
							}
							$UI_Main_Menu.controls.AddRange((
								$CheckBox,
								$New_Wim_Edition,
								$New_Wim_Edition_Wrap
							))

							if ($empDetail.FLAGS -eq $empDetail.WINDOWS.EDITIONID) {
							} else {
								$New_Wim_Edition_Error = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.AE_New_EditionID): $($empDetail.WINDOWS.EDITIONID) < $($lang.Prerequisite_Not_satisfied)"
								}
								$New_Wim_Edition_Error_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}

								$UI_Main_Menu.controls.AddRange((
									$New_Wim_Edition_Error,
									$New_Wim_Edition_Error_Wrap
								))
							}

							$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Image_Name): $($empDetail.NAME)"
							}
							$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 18
								Width          = 525
							}
							$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Image_Description): $($empDetail.DESCRIPTION)"
							}
							$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 18
								Width          = 525
							}
							$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Display_Name): $($empDetail.DISPLAYNAME)"
							}
							$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 18
								Width          = 525
							}
							$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
								autosize       = 1
								Padding        = "31,0,0,0"
								Text           = "$($lang.Wim_Display_Description): $($empDetail.DISPLAYDESCRIPTION)"
							}
							$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
								Height         = 18
								Width          = 525
							}
							$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 30
								Width          = 525
								Padding        = "31,0,0,0"
								Text           = $lang.Detailed_View
								Tag            = $RandomGuid
								LinkColor      = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									Image_Select_Append_Index_Detial -Index $this.Tag
								}
							}
							$New_End_Wrap      = New-Object system.Windows.Forms.Label -Property @{
								Height         = 25
								Width          = 525
							}

							$UI_Main_Menu.controls.AddRange((
								$New_Wim_Image_Name,
								$New_Wim_Image_Name_Wrap,
								$New_Wim_Image_Description,
								$New_Wim_Image_Description_Wrap,
								$New_Wim_Display_Name,
								$New_Wim_Display_Name_Wrap,
								$New_Wim_Display_Description,
								$New_Wim_Display_Description_Wrap,
								$UI_Main_Rule_Details_View,
								$New_End_Wrap
							))
						}

						Remove-Item -Path $Export_To_New_Xml
					}
				} else {
					try {
						Get-WindowsImage -ImagePath $FileBrowser.FileName -ErrorAction SilentlyContinue | ForEach-Object {
							Get-WindowsImage -ImagePath $FileBrowser.FileName -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
								$RandomGuid = [guid]::NewGuid()
								$Script:Temp_Save_Select_WIMFile += [pscustomobject]@{
									GUID               = $RandomGuid
									ImageIndex         = $_.ImageIndex
									ImageName          = $_.ImageName
									ImageDescription   = $_.ImageDescription
									DISPLAYNAME        = ""
									DISPLAYDESCRIPTION = ""
									EditionId          = $_.EditionId
									Architecture       = $_.Architecture
									CreatedTime        = $(Get-Date $_.CreatedTime -Format "MM/dd/yyyy HH:mm:ss tt")
									LastModifiTime     = $(Get-Date $_.ModifiedTime -Format "MM/dd/yyyy HH:mm:ss tt")
									FileCount          = $_.FileCount
									DirectoryCount     = $_.DirectoryCount
									ImageSize          = $_.ImageSize
									Language           = $_.Languages
									Version            = $_.Version
									FilePath           = $FileBrowser.FileName
								}

								$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
									Name      = $RandomGuid
									Height    = 35
									Width     = 470
									Padding   = "16,0,0,0"
									Text      = "$($lang.MountedIndex): $($_.ImageIndex)"
									Tag       = $_.ImageIndex
									checked   = $true
								}

								if ($UI_Main_Duplication.checked) {
									if ($Script:AddKnowVersion -contains $_.EditionId) {
										$CheckBox.Enabled = $False
									}

									$Script:AddKnowVersion += $_.EditionId
								}

								$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Name): $($_.ImageName)"
								}
								$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Description): $($_.ImageDescription)"
								}
								$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
									Height         = 30
									Width          = 525
									Padding        = "31,0,0,0"
									Text           = $lang.Detailed_View
									Tag            = $RandomGuid
									LinkColor      = "#008000"
									ActiveLinkColor = "#FF0000"
									LinkBehavior   = "NeverUnderline"
									add_Click      = {
										Image_Select_Append_Index_Detial -Index $this.Tag
									}
								}
								$New_End_Wrap      = New-Object system.Windows.Forms.Label -Property @{
									Height         = 25
									Width          = 525
								}

								$UI_Main_Menu.controls.AddRange((
									$CheckBox,
									$New_Wim_Image_Name,
									$New_Wim_Image_Name_Wrap,
									$New_Wim_Image_Description,
									$New_Wim_Image_Description_Wrap,
									$UI_Main_Rule_Details_View,
									$New_End_Wrap
								))
							}
						}
					} catch {
						$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height         = 40
							Width          = 448
							margin         = "16,0,0,0"
							Text           = "$($lang.SelectFromError): $($lang.UpdateUnavailable)"
						}

						$UI_Main_Menu.controls.AddRange($UI_Main_Other_Rule_Not_Find)
					}
				}

				$LabelNewFilename_Warp = New-Object system.Windows.Forms.Label -Property @{
					Height         = 50
					Width          = 525
				}
				$UI_Main_Menu.controls.AddRange($LabelNewFilename_Warp)

				$UI_Main_Error.Text = "$($lang.SelFile), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.UserCancel
			}
		}
	}

	$UI_Main_SearchAllDrive = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,90"
		Height         = 36
		Width          = 280
		Text           = $lang.SearchAllDrives
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Script:Temp_Save_Select_WIMFile = @()
			$Script:AddKnowVersion = @()
			foreach ($item in $Global:Primary_Key_Image.Index.EditionId) {
				$Script:AddKnowVersion += $item
			}

			$UI_Main_Menu.controls.Clear()

			<#
				.获取匹配到的文件名
			#>
			$MatchToFilename = @()

			<#
				.已选择搜索的文件
			#>
			$IsSelectFileType = @()
			$UI_Main_SearchAllDrive_Select.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						$IsSelectFileType += $_.Tag
					}
				}
			}

			if ($IsSelectFileType.Count -gt 0) {
				$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -ExpandProperty 'Root'
				ForEach ($item in $drives) {
					foreach ($newfilename in $IsSelectFileType) {
						$NewGroupFilename = Join-Path -Path $item -ChildPath "Sources\$($newfilename)"

						if (Test-Path -Path $NewGroupFilename -PathType leaf) {
							$MatchToFilename += $NewGroupFilename
						}
					}
				}
			} else {
				$UI_Main_Error.Text = "$($lang.NoChoose), $($lang.SearchAllDrives)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				return
			}

			if ($MatchToFilename.Count -gt 0) {
				foreach ($item in $MatchToFilename) {
					$LabelNewFilename = New-Object system.Windows.Forms.Label -Property @{
						AutoSize       = 1
						Padding        = "16,0,0,0"
						Text           = "$($lang.FileName): $($item)"
					}
					$LabelNewFilename_Warp = New-Object system.Windows.Forms.Label -Property @{
						Height         = 10
						Width          = 525
					}
					$UI_Main_Menu.controls.AddRange((
						$LabelNewFilename,
						$LabelNewFilename_Warp
					))

					$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
					if (Test-Path -Path $wimlib -PathType Leaf) {
						$RandomGuid = [guid]::NewGuid()
						$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
						$Arguments = "info ""$($item)"" --extract-xml ""$($Export_To_New_Xml)"""
						Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

						if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
							[XML]$empDetails = Get-Content $Export_To_New_Xml

							ForEach ($empDetail in $empDetails.wim.IMAGE) {
								$RandomGuid = [guid]::NewGuid()
								$NewLASTMODIFICATIONTIME = ConvertToDate -lowpart $empDetail.CREATIONTIME.LOWPART -highpart $empDetail.CREATIONTIME.HIGHPART
								$NewLastModifiTime = ConvertToDate -lowpart $empDetail.LASTMODIFICATIONTIME.LOWPART -highpart $empDetail.LASTMODIFICATIONTIME.HIGHPART

								$Script:Temp_Save_Select_WIMFile += [pscustomobject]@{
									GUID               = $RandomGuid
									ImageIndex         = $empDetail.index
									ImageName          = $empDetail.NAME
									ImageDescription   = $empDetail.DESCRIPTION
									DISPLAYNAME        = $empDetail.DISPLAYNAME
									DISPLAYDESCRIPTION = $empDetail.DISPLAYDESCRIPTION
									EditionId          = $empDetail.WINDOWS.EDITIONID
									Architecture       = $empDetail.WINDOWS.ARCH
									CreatedTime        = $(Get-Date $NewLASTMODIFICATIONTIME -Format "MM/dd/yyyy HH:mm:ss tt")
									LastModifiTime     = $(Get-Date $NewLastModifiTime -Format "MM/dd/yyyy HH:mm:ss tt")
									FileCount          = $empDetail.FILECOUNT
									DirectoryCount     = $empDetail.DIRCOUNT
									ImageSize          = $empDetail.TOTALBYTES
									Language           = [string]$empDetail.WINDOWS.LANGUAGES.LANGUAGE
									Version            = "$($empDetail.WINDOWS.VERSION.BUILD).$($empDetail.WINDOWS.VERSION.SPBUILD)"
									FilePath           = $item
								}

								$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
									Name      = $RandomGuid
									Height    = 35
									Width     = 470
									Padding   = "16,0,0,0"
									Text      = "$($lang.MountedIndex): $($empDetail.index)"
									Tag       = $empDetail.index
									checked   = $true
								}

								if ($UI_Main_Duplication.checked) {
									if ($Script:AddKnowVersion -contains $empDetail.WINDOWS.EDITIONID) {
										$CheckBox.Enabled = $False
									}

									$Script:AddKnowVersion += $empDetail.WINDOWS.EDITIONID
								}

								$New_Wim_Edition   = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Edition): $($empDetail.FLAGS)"
								}
								$New_Wim_Edition_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$UI_Main_Menu.controls.AddRange((
									$CheckBox,
									$New_Wim_Edition,
									$New_Wim_Edition_Wrap
								))

								if ($empDetail.FLAGS -eq $empDetail.WINDOWS.EDITIONID) {
								} else {
									$New_Wim_Edition_Error = New-Object system.Windows.Forms.Label -Property @{
										autosize       = 1
										Padding        = "31,0,0,0"
										Text           = "$($lang.AE_New_EditionID): $($empDetail.WINDOWS.EDITIONID) < $($lang.Prerequisite_Not_satisfied)"
									}
									$New_Wim_Edition_Error_Wrap = New-Object system.Windows.Forms.Label -Property @{
										Height         = 18
										Width          = 525
									}

									$UI_Main_Menu.controls.AddRange((
										$New_Wim_Edition_Error,
										$New_Wim_Edition_Error_Wrap
									))
								}

								#region Detail
								$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Name): $($empDetail.NAME)"
								}
								$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Image_Description): $($empDetail.DESCRIPTION)"
								}
								$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$New_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Display_Name): $($empDetail.DISPLAYNAME)"
								}
								$New_Wim_Display_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}
								$New_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
									autosize       = 1
									Padding        = "31,0,0,0"
									Text           = "$($lang.Wim_Display_Description): $($empDetail.DISPLAYDESCRIPTION)"
								}
								$New_Wim_Display_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
									Height         = 18
									Width          = 525
								}

								$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
									Height         = 30
									Width          = 525
									Padding        = "31,0,0,0"
									Text           = $lang.Detailed_View
									Tag            = $RandomGuid
									LinkColor      = "#008000"
									ActiveLinkColor = "#FF0000"
									LinkBehavior   = "NeverUnderline"
									add_Click      = {
										Image_Select_Append_Index_Detial -Index $this.Tag
									}
								}
								$New_End_Wrap      = New-Object system.Windows.Forms.Label -Property @{
									Height         = 25
									Width          = 525
								}
								#endregion

								$UI_Main_Menu.controls.AddRange((
									$New_Wim_Image_Name,
									$New_Wim_Image_Name_Wrap,
									$New_Wim_Image_Description,
									$New_Wim_Image_Description_Wrap,
									$New_Wim_Display_Name,
									$New_Wim_Display_Name_Wrap,
									$New_Wim_Display_Description,
									$New_Wim_Display_Description_Wrap,
									$UI_Main_Rule_Details_View,
									$New_End_Wrap
								))
							}

							Remove-Item -Path $Export_To_New_Xml
						}
					} else {
						try {
							Get-WindowsImage -ImagePath $item -ErrorAction SilentlyContinue | ForEach-Object {
								Get-WindowsImage -ImagePath $item -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
									$RandomGuid = [guid]::NewGuid()

									$Script:Temp_Save_Select_WIMFile += [pscustomobject]@{
										GUID               = $RandomGuid
										ImageIndex         = $_.ImageIndex
										ImageName          = $_.ImageName
										ImageDescription   = $_.ImageDescription
										DISPLAYNAME        = ""
										DISPLAYDESCRIPTION = ""
										EditionId          = $_.EditionId
										Architecture       = $_.Architecture
										CreatedTime        = $(Get-Date $_.CreatedTime -Format "MM/dd/yyyy HH:mm:ss tt")
										LastModifiTime     = $(Get-Date $_.ModifiedTime -Format "MM/dd/yyyy HH:mm:ss tt")
										FileCount          = $_.FileCount
										DirectoryCount     = $_.DirectoryCount
										ImageSize          = $_.ImageSize
										Language           = $_.Languages
										Version            = $_.Version
										FilePath           = $item
									}

									$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
										Name      = $RandomGuid
										Height    = 35
										Width     = 470
										Padding   = "16,0,0,0"
										Text      = "$($lang.MountedIndex): $($_.ImageIndex)"
										Tag       = $_.ImageIndex
										checked   = $true
									}

									if ($UI_Main_Duplication.checked) {
										if ($Script:AddKnowVersion -contains $_.EditionId) {
											$CheckBox.Enabled = $False
										}
									}

									$New_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
										autosize       = 1
										Padding        = "31,0,0,0"
										Text           = "$($lang.Wim_Image_Name): $($_.ImageName)"
									}
									$New_Wim_Image_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
										Height         = 18
										Width          = 525
									}
									$New_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
										autosize       = 1
										Padding        = "31,0,0,0"
										Text           = "$($lang.Wim_Image_Description): $($_.ImageDescription)"
									}
									$New_Wim_Image_Description_Wrap = New-Object system.Windows.Forms.Label -Property @{
										Height         = 18
										Width          = 525
									}
									$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
										Height         = 30
										Width          = 525
										Padding        = "31,0,0,0"
										Text           = $lang.Detailed_View
										Tag            = $RandomGuid
										LinkColor      = "#008000"
										ActiveLinkColor = "#FF0000"
										LinkBehavior   = "NeverUnderline"
										add_Click      = {
											Image_Select_Append_Index_Detial -Index $this.Tag
										}
									}
									$New_End_Wrap      = New-Object system.Windows.Forms.Label -Property @{
										Height         = 25
										Width          = 525
									}

									$UI_Main_Menu.controls.AddRange((
										$CheckBox,
										$New_Wim_Image_Name,
										$New_Wim_Image_Name_Wrap,
										$New_Wim_Image_Description,
										$New_Wim_Image_Description_Wrap,
										$UI_Main_Rule_Details_View,
										$New_End_Wrap
									))
								}
							}
						} catch {
							$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
								Height         = 40
								Width          = 448
								margin         = "16,0,0,0"
								Text           = "$($lang.SelectFromError): $($lang.UpdateUnavailable)"
							}

							$UI_Main_Menu.controls.AddRange($UI_Main_Other_Rule_Not_Find)
						}
					}

					$LabelNewFilename_Warp = New-Object system.Windows.Forms.Label -Property @{
						Height         = 50
						Width          = 525
					}
					$UI_Main_Menu.controls.AddRange($LabelNewFilename_Warp)

					$UI_Main_Error.Text = "$($lang.SearchAllDrives), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				}
			} else {
				$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height         = 40
					Width          = 448
					margin         = "16,0,0,0"
					Text           = $lang.NoWork
				}

				$UI_Main_Menu.controls.AddRange($UI_Main_Other_Rule_Not_Find)
				return
			}
		}
	}

	$UI_Main_SearchAllDrive_Select = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 255
		Width          = 280
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
		Location       = '620,130'
		autoScroll     = $True
	}

	$UI_Main_Duplication = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.DeDuplication
		Location       = '622,415'
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_Duplication_Unlock = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 260
		Location       = "638,450"
		Text           = $lang.DeDuplication_Unlock
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					$_.Enabled = $true
				}
			}

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.DeDuplication_Unlock), $($lang.Done)"
		}
	}

	<#
		.Add right-click menu: select all, clear button
	#>
	$UI_Main_List_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_List_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_SearchAllDrive_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_List_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_SearchAllDrive_Select.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_SearchAllDrive_Select.ContextMenuStrip = $UI_Main_List_Select

	<#
		.自动选择文件名
	#>
	$IsAutoselectFile = @(
		"install.wim"
		"install.esd"
		"install.swm"
	)

	ForEach ($item in $Global:Image_Rule) {
		$NewFilename = "$($item.main.ImageFileName).$($item.main.Suffix)"

		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Name    = $item.Main.Uid
			Height  = 35
			Width   = 240
			Text    = $NewFilename
			Tag     = $NewFilename
		}

		if ($IsAutoselectFile -contains $NewFilename) {
			$CheckBox.Checked = $True
		} else {
			$CheckBox.Checked = $False
		}

		$UI_Main_SearchAllDrive_Select.controls.AddRange($CheckBox)
	}

	#region View Details
	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Mask_Rule_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Mask_Rule_Detailed_Results = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 555
		autoSizeMode   = 1
		Location       = '20,0'
		Padding        = "0,15,0,0"
		autoScroll     = $True
	}

	<#
		.显示详细信息，控件
	#>
	<#
		.映像路径
	#>
	$UI_Main_Mask_Rule_Wim_Image_Path_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 530
		Text           = $lang.SelectSettingImage
	}
	$UI_Main_Mask_Rule_Wim_Image_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Margin         = "22,0,0,35"
		Text           = ""
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.索引号
	#>
	$UI_Main_Mask_Rule_Wim_Image_Index_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.MountedIndex
	}
	$UI_Main_Mask_Rule_Wim_Image_Index = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.映像名称
	#>
	$UI_Main_Mask_Rule_Wim_Image_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Image_Name
	}
	$UI_Main_Mask_Rule_Wim_Image_Name_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.映像说明
	#>
	$UI_Main_Mask_Rule_Wim_Image_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Image_Description
	}
	$UI_Main_Mask_Rule_Wim_Image_Description_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.显示名称
	#>
	$UI_Main_Mask_Rule_Wim_Display_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Display_Name
	}
	$UI_Main_Mask_Rule_Wim_Display_Name_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.显示说明
	#>
	$UI_Main_Mask_Rule_Wim_Display_Description = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_Display_Description
	}
	$UI_Main_Mask_Rule_Wim_Display_Description_Edit = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 500
		Text           = ""
		margin         = "22,0,0,30"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
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
		Width          = 500
		Text           = ""
		margin         = "22,0,0,25"
		ReadOnly       = $True
		BackColor      = "#FFFFFF"
	}

	<#
		.架构
	#>
	$UI_Main_Mask_Rule_Wim_Architecture = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,12,0,12"
		Text           = $lang.Architecture
	}

	<#
		.语言
	#>
	$UI_Main_Mask_Rule_Wim_Language = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Language
	}

	<#
		.创建日期
	#>
	$UI_Main_Mask_Rule_Wim_CreatedTime = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_CreatedTime
	}

	<#
		.上次修改时间
	#>
	$UI_Main_Mask_Rule_Wim_ModifiedTime = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_ModifiedTime
	}

	<#
		.文件数目
	#>
	$UI_Main_Mask_Rule_Wim_FileCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_FileCount
		margin         = "2,0,0,12"
	}

	<#
		.目录数目
	#>
	$UI_Main_Mask_Rule_Wim_DirectoryCount = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		Text           = $lang.Wim_DirectoryCount
		margin         = "2,0,0,12"
	}

	<#
		.展开空间
	#>
	$UI_Main_Mask_Rule_Wim_Expander_Space = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Wim_Expander_Space
	}

	<#
		.系统版本
	#>
	$UI_Main_Mask_Rule_Wim_System_Version = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 530
		margin         = "2,0,0,12"
		Text           = $lang.Editions
	}

	$UI_Main_Mask_Rule_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Mask_Rule_Detailed.Visible = $False
		}
	}
	#endregion

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "620,528"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "645,530"
		Height         = 55
		Width          = 255
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "620,635"
		Height         = 36
		Width          = 280
		Text           = $lang.Wim_Append
		add_Click      = {
			$SelectTempTag = @()
			<#
				.获取已选择
			#>
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$SelectTempTag += $_.Name
						}
					}
				}
			}

			if ($SelectTempTag.Count -gt 0) {
				$UI_Main.Hide()

				Write-Host "`n  $($lang.Wim_Append)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
				foreach ($item in $Script:Temp_Save_Select_WIMFile) {
					if ($SelectTempTag -contains $item.GUID) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Edition): " -NoNewline
						Write-Host $item.EditionId -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $item.ImageDescription -ForegroundColor Yellow

						write-host "  $($lang.Wim_Display_Name): " -NoNewline
						write-host $item.DisplayName -ForegroundColor Yellow

						write-host "  $($lang.Wim_Display_Description): " -NoNewline
						write-host $item.DisplayDescription -ForegroundColor Yellow

						Write-host "  $($lang.Select_Path): " -NoNewline
						Write-Host $item.FilePath -ForegroundColor Yellow
						Write-Host
					}
				}

				Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				foreach ($item in $Script:Temp_Save_Select_WIMFile) {
					if ($SelectTempTag -contains $item.GUID) {
						Write-Host "  $($lang.MountedIndex): " -NoNewline
						Write-Host $item.ImageIndex -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Edition): " -NoNewline
						Write-Host $item.EditionId -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
						Write-Host $item.ImageName -ForegroundColor Yellow

						Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
						Write-Host $item.ImageDescription -ForegroundColor Yellow

						write-host "  $($lang.Wim_Display_Name): " -NoNewline
						write-host $item.DisplayName -ForegroundColor Yellow

						write-host "  $($lang.Wim_Display_Description): " -NoNewline
						write-host $item.DisplayDescription -ForegroundColor Yellow

						Write-host "  $($lang.Select_Path): " -NoNewline
						Write-Host $item.FilePath -ForegroundColor Yellow
						write-host

						write-host "  " -NoNewline
						write-host " $($lang.Wim_Append) " -NoNewline -BackgroundColor White -ForegroundColor Black
						try {
							Export-WindowsImage -SourceImagePath $item.FilePath -SourceIndex $item.ImageIndex -DestinationImagePath $Global:Primary_Key_Image.FullPath -CompressionType Max -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} catch {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
							Write-Host "  $($_)" -ForegroundColor Red
						}

						Write-Host
					}
				}

				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			}
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed,
		$UI_Main_Menu,
		$UI_Main_Duplication,
		$UI_Main_Duplication_Unlock,
		$UI_Main_Setting_ISO,
		$UI_Main_Select_Custom_Sources,
		$UI_Main_SearchAllDrive,
		$UI_Main_SearchAllDrive_Select,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
	))
	$UI_Main_Mask_Rule_Detailed.controls.AddRange((
		$UI_Main_Mask_Rule_Detailed_Results,
		$UI_Main_Mask_Rule_Detailed_Hide
	))
	$UI_Main_Mask_Rule_Detailed_Results.controls.AddRange((
		$UI_Main_Mask_Rule_Wim_Image_Path_Name,
		$UI_Main_Mask_Rule_Wim_Image_Path,
		$UI_Main_Mask_Rule_Wim_Image_Index_Name,
		$UI_Main_Mask_Rule_Wim_Image_Index,
		$UI_Main_Mask_Rule_Wim_Image_Name,
		$UI_Main_Mask_Rule_Wim_Image_Name_Edit,
		$UI_Main_Mask_Rule_Wim_Image_Description,
		$UI_Main_Mask_Rule_Wim_Image_Description_Edit,
		$UI_Main_Mask_Rule_Wim_Display_Name,
		$UI_Main_Mask_Rule_Wim_Display_Name_Edit,
		$UI_Main_Mask_Rule_Wim_Display_Description,
		$UI_Main_Mask_Rule_Wim_Display_Description_Edit,
		$UI_Main_Mask_Rule_Wim_Edition,
		$UI_Main_Mask_Rule_Wim_Edition_Edit,
		$UI_Main_Mask_Rule_Wim_Architecture,
		$UI_Main_Mask_Rule_Wim_Language,
		$UI_Main_Mask_Rule_Wim_CreatedTime,
		$UI_Main_Mask_Rule_Wim_ModifiedTime,
		$UI_Main_Mask_Rule_Wim_FileCount,
		$UI_Main_Mask_Rule_Wim_DirectoryCount,
		$UI_Main_Mask_Rule_Wim_Expander_Space,
		$UI_Main_Mask_Rule_Wim_System_Version
	))

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
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