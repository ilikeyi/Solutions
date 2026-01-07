<#
	.Windows Version
	.Windows 版本号
#>
$Global:OSVersion = @(
	"2025"
	"2022"
	"2019"
	"11"
	"10"
)

<#
	.Label name
	.标签名
#>
$Global:OSCodename = @(
	"26H2"
	"26H1"
	"25H2"
	"24H2"
	"23H2"
	"22h2"
	"21h2"
	"21h1"
	"20h2"
	"20h1"
	"19h2"
	"19h1"
	"ltsc"
	"ltsb"
)

<#
	.Create ISO user interface
	.创建 ISO 用户界面
#>

Function ISO_Create
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.UnpackISO
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.MountImageTo): " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host $Global:Mount_To_Route -ForegroundColor Yellow
		}

		Write-Host "  $($lang.MainImageFolder): " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Red
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
		}
	}

	<#
		.Assign available tasks
		.分配可用的任务
	#>
	Event_Assign -Rule "ISO_Create_UI" -Run
}

Function ISO_Create_UI
{
	param
	(
		[array]$Autopilot,
		[switch]$Quick,
		[switch]$ISO,
		[switch]$mount
	)

	if ($ISO) {
		$Script:init_To_GPS = "ISO"
	} else {
		if (Image_Is_Select_IAB) {
			$Script:init_To_GPS = $Global:Primary_Key_Image.Uid
		} else {
			$Script:init_To_GPS = "ISO"
		}
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	Function Refres_Event_Tasks_ISO_Create
	{
		if ($Global:Queue_ISO) {
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
		} else {
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
		}
	}

	$UI_Main_Event_Clear_Click = {
		$Global:Queue_ISO = $False
		$Global:EmptyDirectory = $False
		$Global:BypassTPM = $False
		$Global:CreateASC = $False
		$Global:ISOSparseAllow = $False
		$Global:ISOSparseType = ""
		$Global:ISOSparseRename = $False

		Refres_Event_Tasks_ISO_Create

		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
	}

	<#
		.Refresh tab
		.刷新标签
	#>
	Function ISO_Create_Refresh_Every_Time_Label
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabel" -ErrorAction SilentlyContinue) {
			$GetSaveLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabel" -ErrorAction SilentlyContinue
			$GUIISOCustomizeName.Text = $GetSaveLabel
			
			ISO_Create_Refresh_Label
		} else {
			ISO_Create_Refresh_Label
		}
	}

	Function ISO_Create_Not_Refresh_Label
	{
		$GUIISOCustomizeName.BackColor = "#FFFFFF"
		$GUIISOFolderName.BackColor = "#FFFFFF"
		$GUIISO_Engline_Name_Custom.BackColor = "#FFFFFF"
		$GUIISOSelectOSVersion_Select.BackColor = "#FFFFFF"
		$GUIISOSelectManual_Select.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($GUIISORefreshAuto.Checked) {
			ISO_Create_Refresh_Label
		} else {
			$TestNewFolderStructure = (Join_MainFolder -Path $GUIISOSaveCustomizePath.Text)

			if ($GUIISOOSLevel.Checked) {
				$TestNewFolderStructure += (Join_MainFolder -Path $Global:ImageType)
			}

			if ($GUIISOUniqueNameDirectory.Checked) {
				$TestNewFolderStructure += (Join_MainFolder -Path $GUIISOFolderName.Text)
			}

			$GUIISOSaveShow.Text = "$($TestNewFolderStructure)$($GUIISOFolderName.Text).iso"
		}
	}

	Function ISO_Create_Refresh_Custom_Engine_Name
	{
		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUIISO_Engline_Name_Custom.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUIISO_Engline_Name_Custom.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUIISO_Engline_Name_Custom.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUIISO_Engline_Name_Custom.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUIISO_Engline_Name_Custom.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUIISO_Engline_Name_Custom.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUIISO_Engline_Name_Custom.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Engline_Name_Custom.BackColor = "LightPink"
			return $False
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "EngineName" -value $GUIISO_Engline_Name_Custom.Text -String
		return $True
	}

	Function ISO_Create_Refresh_Custom_Group_Name
	{
		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUIISO_Group_Name_Custom.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUIISO_Group_Name_Custom.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUIISO_Group_Name_Custom.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUIISO_Group_Name_Custom.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUIISO_Group_Name_Custom.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUIISO_Group_Name_Custom.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUIISO_Group_Name_Custom.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Group_Name_Custom.BackColor = "LightPink"
			return $False
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "GroupName" -value $GUIISO_Group_Name_Custom.Text -String
		return $True
	}

	Function ISO_Create_Refresh_Custom_Events_Name
	{
		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUIISO_Event_Name_Custom.Text)) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUIISO_Event_Name_Custom.Text -match '^\s') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. Suffix cannot contain spaces
			.判断：3. 后缀不能带空格
		#>
		if ($GUIISO_Event_Name_Custom.Text -match '\s$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. The suffix cannot contain multiple spaces
			.判断：4. 后缀不能带多空格
		#>
		if ($GUIISO_Event_Name_Custom.Text -match '\s{2,}$') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. There can be no two spaces in between
			.判断：5. 中间不能含有二个空格
		#>
		if ($GUIISO_Event_Name_Custom.Text -match '\s{2,}') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. Cannot contain: \\ /: *? "" <> |
			.判断：6, 不能包含：\\ / : * ? "" < > |
		#>
		if ($GUIISO_Event_Name_Custom.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 7. No more than 260 characters
			.判断：7. 不能大于 260 字符
		#>
		if ($GUIISO_Event_Name_Custom.Text.length -gt 260) {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			$GUIISO_Event_Name_Custom.BackColor = "LightPink"
			return $False
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "EventsName" -value $GUIISO_Event_Name_Custom.Text -String
		return $True
	}

	Function ISO_Create_Refresh_Label
	{
		$GUIISOCustomizeName.BackColor = "#FFFFFF"
		$GUIISOFolderName.BackColor = "#FFFFFF"
		$GUIISOSelectOSVersion_Select.BackColor = "#FFFFFF"
		$GUIISOSelectManual_Select.BackColor = "#FFFFFF"
		$GUIISO_Group_Name_Custom.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$MarkISOLabel = ""
		$MarkFolderLabel = ""

		<#
			.添加语言标签
		#>
		if ($GUIISOLabelMulti.Checked) {
			$MarkISOLabel += "mul"
			$MarkFolderLabel += "mul"
		} else {
			if ($SchemeLangSingle.Text -eq "") {
			} else {
				$MarkSelectISOLanguage = $False
				
				$Region = Language_Region
				ForEach ($itemRegion in $Region) {
					if ($itemRegion.Region -eq "$($GUIISOLabelSingleISO.Text)") {
						$MarkSelectISOLanguage = $True
						$TempMainImageLangShort = $itemRegion.Tag
						break
					}
				}

				if ($MarkSelectISOLanguage) {
					$MarkISOLabel += $TempMainImageLangShort
				} else {
					$MarkISOLabel += "$($GUIISOLabelSingleISO.Text.ToLower())"
				}
				$MarkFolderLabel += "$($GUIISOLabelSingleISO.Text.ToLower())"
			}
		}

		<#
			.添加目录名（作者）
		#>
		$MarkFolderLabel += "_$((Get-Module -Name Solutions).Author)"

		if ($GUIISOSelectOSVersion.Enabled) {
			if ($GUIISOSelectOSVersion.Checked) {
				if ([string]::IsNullOrEmpty($GUIISOSelectOSVersion_Select.Text)) {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$GUIISOSelectOSVersion_Select.BackColor = "LightPink"
					return
				} else {
					if ($Global:ImageType -ne "Desktop") {
						$MarkFolderLabel += "_Windows_Server_$($GUIISOSelectOSVersion_Select.Text)"
					}

					if ($Global:ImageType -ne "Server") {
						$MarkFolderLabel += "_Windows_$($GUIISOSelectOSVersion_Select.Text)"
					}
				}
			}
		}

		<#
			.添加消费者版、商业版标记
		#>
		if ($GUIISOEiCFG.Enabled) {
			if ($GUIISOEiCFG.Checked) {
				$SaveFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"

				if (Test-Path -Path $SaveFileTo -PathType Leaf -ErrorAction SilentlyContinue) {
					$MarkFolderLabel += "_business_editions"
				} else {
					$MarkFolderLabel += "_consumer_editions"
				}
			}
		}

		<#
			.添加 Windows 代号
		#>
		if ($GUIISOSelectManual.Enabled) {
			if ($GUIISOSelectManual.Checked) {
				if ([string]::IsNullOrEmpty($GUIISOSelectManual_Select.Text)) {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$GUIISOSelectManual_Select.BackColor = "LightPink"
					return
				} else {
					$MarkFolderLabel += "_$($GUIISOSelectManual_Select.Text)"
					$MarkISOLabel += "_$($GUIISOSelectManual_Select.Text)"
				}
			}
		}

		<#
			.添加 Office 标签
		#>
		if ($GUIISOSelectOffice.Enabled) {
			if ($GUIISOSelectOffice.Checked) {
				if ([string]::IsNullOrEmpty($Solutions_Office_Select.Text)) {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose): $($lang.SolutionsDeployOfficeVersion -f "Office")"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				} else {
					$MarkFolderLabel += "_With_Office_$($Solutions_Office_Select.Text)"
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_PreOfficeVersion" -value $Solutions_Office_Select.Text -String
				}
			}
		}

		switch ($Global:Architecture) {
			"arm64" { $MarkNewLabelArch = "_arm64" }
			"AMD64" { $MarkNewLabelArch = "_x64" }
			"x86" { $MarkNewLabelArch = "_x86" }
		}
#		$MarkISOLabel += $MarkNewLabelArch
		$MarkFolderLabel += $MarkNewLabelArch

		<#
			.添加有多少个语言标签
		#>
		if ($GUIISOSetLang.Enabled) {
			$MarkFolderLabel += "_$($GUIISOSetLang.Text)l1"
		}

		<#
			.添加映像有多少合集
		#>
		if ($GUIISOSetVer.Enabled) {
			$MarkFolderLabel += "_$($GUIISOSetVer.Text)in1"
		}

		<#
			.添加随机数
		#>
		if ($GUIISOSelectRandom.Enabled) {
			if ($GUIISOSelectRandom.Checked) {
				$MarkFolderLabel += "_$($GUIISOSelectRandomName.Text)"
			}
		}

		$GroupISOMonth_Short = ""
		$GroupISOMonth_Full = ""
		$NewGroupISO_A_Month = ""
		$NewGroupISO_B_Month = ""
		if ($GUIISOMonthTitle.Checked) {
			switch ($GUIISOMonthSel.Text) {
				1 {  $GroupISOMonth_Short = "jan";  $GroupISOMonth_Full = "january";   }
				2 {  $GroupISOMonth_Short = "feb";  $GroupISOMonth_Full = "february";  }
				3 {  $GroupISOMonth_Short = "mar";  $GroupISOMonth_Full = "march";     }
				4 {  $GroupISOMonth_Short = "apr";  $GroupISOMonth_Full = "april";     }
				5 {  $GroupISOMonth_Short = "may";  $GroupISOMonth_Full = "may";       }
				6 {  $GroupISOMonth_Short = "jun";  $GroupISOMonth_Full = "june";      }
				7 {  $GroupISOMonth_Short = "jul";  $GroupISOMonth_Full = "july";      }
				8 {  $GroupISOMonth_Short = "aug";  $GroupISOMonth_Full = "august";    }
				9 {  $GroupISOMonth_Short = "sep";  $GroupISOMonth_Full = "september"; }
				10 { $GroupISOMonth_Short = "oct";  $GroupISOMonth_Full = "october";   }
				11 { $GroupISOMonth_Short = "nov";  $GroupISOMonth_Full = "november";  }
				12 { $GroupISOMonth_Short = "dec";  $GroupISOMonth_Full = "december";  }
			}

			if ($UI_ISO_A_Month_Number.Checked) {
				$NewGroupISO_A_Month = $GUIISOMonthSel.Text
			} else {
				$NewGroupISO_A_Month = $GroupISOMonth_Short
			}

			if ($UI_ISO_B_Month_Number.Checked) {
				$NewGroupISO_B_Month = $GUIISOMonthSel.Text
			} else {
				if ($UI_ISO_B_Month_UseShortname.Checked) {
					$NewGroupISO_B_Month = $GroupISOMonth_Short
				} else {
					$NewGroupISO_B_Month = $GroupISOMonth_Full
				}
				
			}
		}

		$GroupISOYear_Short = $([DateTime]::ParseExact($GUIISOYearsSel.Text, 'yyyy', $null).ToString("yy"))
		$GroupISOYear_Full = $GUIISOYearsSel.Text
		$NewGroupISO_A_Year = ""
		$NewGroupISO_B_Year = ""
		if ($GUIISOYearTitle.Checked) {
			if ($UI_ISO_A_Year_ShortNames.Checked) {
				$NewGroupISO_A_Year = $GroupISOYear_Short
			} else {
				$NewGroupISO_A_Year = $GroupISOYear_Full
			}

			if ($UI_ISO_B_Year_ShortNames.Checked) {
				$NewGroupISO_B_Year = $GroupISOYear_Short
			} else {
				$NewGroupISO_B_Year = $GroupISOYear_Full
			}
		}

		<#
			.组合年月顺序
			判断 $UI_ISO_A_Sorting 是否选择
		#>
		$GroupA_NewYearSorting = ""
		if ($UI_ISO_A_Sorting.Checked) {
			# 年月
			if (([string]::IsNullOrEmpty($NewGroupISO_A_Year))) {
			} else {
				$GroupA_NewYearSorting += "_$($NewGroupISO_A_Year)"
			}

			if (([string]::IsNullOrEmpty($NewGroupISO_A_Month))) {
			} else {
				if ($UI_ISO_A_Month_Number.Checked) {
					$GroupA_NewYearSorting += $NewGroupISO_A_Month
				} else {
					$GroupA_NewYearSorting += "_$($NewGroupISO_A_Month)"
				}
			}
		} else {
			# 月年

			if (([string]::IsNullOrEmpty($NewGroupISO_A_Month))) {
			} else {
				if ($UI_ISO_A_Month_Number.Checked) {
					$GroupA_NewYearSorting += "_$($NewGroupISO_A_Month)"
				} else {
					$GroupA_NewYearSorting += "_$($NewGroupISO_A_Month)"
				}
			}

			if (([string]::IsNullOrEmpty($NewGroupISO_A_Year))) {
			} else {
				$GroupA_NewYearSorting += "_$($NewGroupISO_A_Year)"
			}
		}

		$GroupB_NewYearSorting = ""
		if ($UI_ISO_B_Sorting.Checked) {
			# 年月
			if (([string]::IsNullOrEmpty($NewGroupISO_B_Year))) {
			} else {
				$GroupB_NewYearSorting += "_$($NewGroupISO_B_Year)"
			}

			if (([string]::IsNullOrEmpty($NewGroupISO_B_Month))) {
			} else {
				if ($UI_ISO_B_Month_Number.Checked) {
					$GroupB_NewYearSorting += $NewGroupISO_B_Month
				} else {
					$GroupB_NewYearSorting += "_$($NewGroupISO_B_Month)"
				}
			}
		} else {
			# 月年

			if (([string]::IsNullOrEmpty($NewGroupISO_B_Month))) {
			} else {
				if ($UI_ISO_B_Month_Number.Checked) {
					$GroupB_NewYearSorting += "_$($NewGroupISO_B_Month)"
				} else {
					$GroupB_NewYearSorting += "_$($NewGroupISO_B_Month)"
				}
			}

			if (([string]::IsNullOrEmpty($NewGroupISO_B_Year))) {
			} else {
				$GroupB_NewYearSorting += "_$($NewGroupISO_B_Year)"
			}
		}

		$MarkISOLabel += $GroupA_NewYearSorting
		$MarkFolderLabel += $GroupB_NewYearSorting

		$GUIISOCustomizeName.Text = $MarkISOLabel
		$GUIISOFolderName.Text = $MarkFolderLabel

		$TestNewFolderStructure = (Join_MainFolder -Path $GUIISOSaveCustomizePath.Text)

		if ($GUIISOOSLevel.Checked) {
			$TestNewFolderStructure += (Join_MainFolder -Path $Global:ImageType)
		}

		<#
			.添加：群组
		#>
		if ($GUIISO_Group_Name.Checked) {
			if (ISO_Create_Refresh_Custom_Group_Name) {
				$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Group_Name_Custom.Text)
			}
		}

		<#
			.添加：部署引擎
		#>
		if ($GUIISO_Engline_Name.Checked) {
			if (ISO_Create_Refresh_Custom_Engine_Name) {
				$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Engline_Name_Custom.Text)
			}
		}

		<#
			.添加：多语言标记
		#>
		if ($IsISOAddLanguageFlag.Checked) {
			$TestNewFolderStructure += (Join_MainFolder -Path $GUIISOSetLang.Text)
		}

		<#
			.添加：多版本标记
		#>
		if ($GUIISO_Engline_Language_Know_Group.Checked) {
			$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Engline_Language_Know_Group_Get.Tag)
		}

		<#
			.添加：事件
		#>
		if ($GUIISO_Event_Name.Enabled) {
			if ($GUIISO_Event_Name.Checked) {
				if (ISO_Create_Refresh_Custom_Events_Name) {
					$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Event_Name_Custom.Text)
				}
			}
		}

		if ($GUIISOUniqueNameDirectory.Checked) {
			$TestNewFolderStructure += (Join_MainFolder -Path $GUIISOFolderName.Text)
		}

		$GUIISOSaveShow.Text = "$($TestNewFolderStructure)$($GUIISOFolderName.Text).iso"

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "LanguageISO" -value $GUIISOLabelSingleISO.Text -String
	}

	<#
		.事件：选择 Windows 版本
	#>
	$GUIISOSelectOSVersionClick = {
		if ($GUIISOSelectOSVersion.Checked) {
			$GUIISOSelectOSVersion_Select.Enabled = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddFlagsWindowsVersion" -value "True" -String
		} else {
			$GUIISOSelectOSVersion_Select.Enabled = $False
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddFlagsWindowsVersion" -value "False" -String
		}

		if ([string]::IsNullOrEmpty($GUIISOSelectOSVersion_Select.Text)) {
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "PreWindowsVersion" -value $GUIISOSelectOSVersion_Select.Text -String
		}

		ISO_Create_Refresh_Label
	}


	<#
		.事件：选择 Windows 版本
	#>
	$GUIISOSelectManualClick = {
		if ($GUIISOSelectManual.Checked) {
			$GUIISOSelectManual_Select.Enabled = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddFlagsCodeVersion" -value "True" -String
		} else {
			$GUIISOSelectManual_Select.Enabled = $False
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddFlagsCodeVersion" -value "False" -String
		}

		if ([string]::IsNullOrEmpty($GUIISOSelectManual_Select.Text)) {
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Label" -value $GUIISOSelectManual_Select.Text -String
		}

		ISO_Create_Refresh_Label
	}

	<#
		.Event: Create ISO
		.事件：创建 ISO
	#>
	Function ISO_Create_Refresh_Event_Status
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($UI_Main_Is_Create_ISO.Enabled) {
			if ($UI_Main_Is_Create_ISO.Checked) {
				$GUIISOGroupISOAll.Enabled = $True
				$GUIISOBypassTPM.Enabled = $True
				$UI_ISO_Is_Sparse.Enabled = $True
				$UI_ISO_Sparse_Rename.Enabled = $True
				$UI_ISO_Sparse_Type_Select.Enabled = $True
				$GUIISOEmptyDirectory.Enabled = $True
			} else {
				$GUIISOGroupISOAll.Enabled = $False
				$GUIISOBypassTPM.Enabled = $False
				$UI_ISO_Is_Sparse.Enabled = $False
				$UI_ISO_Sparse_Rename.Enabled = $False
				$UI_ISO_Sparse_Type_Select.Enabled = $False
				$GUIISOEmptyDirectory.Enabled = $False
			}
		} else {
			$GUIISOGroupISOAll.Enabled = $False
			$GUIISOBypassTPM.Enabled = $False
			$UI_ISO_Is_Sparse.Enabled = $False
			$UI_ISO_Sparse_Rename.Enabled = $False
			$UI_ISO_Sparse_Type_Select.Enabled = $False
			$GUIISOEmptyDirectory.Enabled = $False
		}
	}

	Function ISO_Create_Refresh_Mul_Version
	{
		[int]$MarkInitVer = 0

		$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
		$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
		$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"

		if (Test-Path -Path $Install_wim -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_wim -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkInitVer++
				}

				return $MarkInitVer
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_wim)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}

		if (Test-Path -Path $Install_ESD -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_ESD -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkInitVer++
				}

				return $MarkInitVer
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_ESD)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}

		if (Test-Path -Path $Install_SWM -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_SWM -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkInitVer++
				}

				return $MarkInitVer
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_SWM)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = $lang.UnpackISO
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Is_Create_ISO = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 485
		Text           = $lang.SelCreateISO
		Location       = '15,10'
		add_Click      = { ISO_Create_Refresh_Event_Status }
		Checked        = $True
	}

	<#
		显示其它项
	#>
	$GUIISOGroupISOAll = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 630
		Width          = 485
		autoSizeMode   = 1
		Padding        = "0,0,8,0"
		Location       = '15,45'
		autoScroll     = $True
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 455
		Padding        = "16,0,0,0"
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 455
		Text           = $lang.EventManagerCurrentClear
		Padding        = "48,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	$GUIISORefreshAuto = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "16,0,0,0"
		margin         = "0,35,0,0"
		Text           = $lang.ISORefreshAuto
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($GUIISORefreshAuto.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsRefreshLabel" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsRefreshLabel" -value "False" -String
			}
			ISO_Create_Refresh_Label
		}
	}

	<#
		.ISO 卷标名
	#>
	$GUIISOCustomizeNameTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = "A: $($lang.ISOCustomize)"
	}
	$GUIISOCustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Text           = ""
		margin         = "55,0,0,30"
		add_Click      = {
			ISO_Create_Not_Refresh_Label
		}
	}

	<#
		.自定义唯一命名
	#>
	$GUIISOFolderNameTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = "B: $($lang.ISOFolderName)"
	}
	$GUIISOFolderName  = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Text           = ""
		margin         = "55,0,0,15"
		add_Click      = {
			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabelSpecify" -ErrorAction SilentlyContinue) {
		$GUIISOFolderName.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabelSpecify" -ErrorAction SilentlyContinue
	}

	$GUIISOCheckISO9660 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.ISO9660
		Padding        = "52,0,0,0"
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIISOCheckISO9660Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "67,5,0,0"
		Text           = $lang.ISO9660Tips
	}

	<#
		.选择发行日期
	#>
	$GUIISOPublicDate  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.PublicDate
		Padding        = "16,0,0,0"
		margin         = "0,55,0,0"
	}
	$GUIISOGroupPublicDate = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 460
		Width          = 455
		autoSizeMode   = 1
	}
	$GUIISOPublicDateGetCurrent = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 265
		Text           = $lang.PublicDateGetCurrent
		Location       = "32,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIISOYearsSel.Text = (Get-Date).ToString("yyyy")
			$GUIISOMonthSel.Text = (Get-Date).ToString("MM")
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateYear" -value $GUIISOYearsSel.Text -String
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateMonth" -value $GUIISOMonthSel.Text -String
			ISO_Create_Refresh_Label
		}
	}

	<#
		.年月排序
	#>
	$UI_ISO_YM_Sorting = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 400
		Location       = "32,35"
		Text           = $lang.PublicYMSorting
	}
	$UI_ISO_A_Sorting = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "A"
		Location       = "55,70"
		add_Click      = {
			if ($UI_ISO_A_Sorting.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_Year_Sorting" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_Year_Sorting" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_Year_Sorting" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_Year_Sorting" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_A_Sorting.Checked = $True
			}
			"False" {
				$UI_ISO_A_Sorting.Checked = $False
			}
		}
	} else {
		$UI_ISO_A_Sorting.Checked = $True
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_Year_Sorting" -value "True" -String
	}

	$UI_ISO_B_Sorting = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "B"
		Location       = "100,70"
		add_Click      = {
			if ($UI_ISO_B_Sorting.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_Month_Sorting" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_Month_Sorting" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_Month_Sorting" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_Month_Sorting" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_B_Sorting.Checked = $True
			}
			"False" {
				$UI_ISO_B_Sorting.Checked = $False
			}
		}
	}
	$UI_ISO_YM_Sorting_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 400
		Location       = "52,110"
		Text           = $lang.PublicYMSortingTips
	}

	<#
		.群组：年
	#>
	$GUIISOYearTitle   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 80
		Text           = $lang.PublicYear
		Location       = "35,170"
		Checked        = $True
		add_Click      = {
			if ($GUIISOYearTitle.Checked) {
				$GUIISOYearsSel.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowDateYear" -value "True" -String
			} else {
				$GUIISOYearsSel.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowDateYear" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	$GUIISOYearsSel    = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "120,175"
		Text           = "2023"
		Minimum        = 1
		Maximum        = 2099
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateYear" -value $GUIISOYearsSel.Text -String
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateMonth" -value $GUIISOMonthSel.Text -String
			ISO_Create_Refresh_Label
		}
	}

	<#
		.年：A：使用短名称
	#>
	$UI_ISO_A_Year_ShortNames = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "A"
		Location       = "52,210"
		add_Click      = {
			if ($UI_ISO_A_Year_ShortNames.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Year_ShortNames" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Year_ShortNames" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_A_Year_ShortNames" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_A_Year_ShortNames" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_A_Year_ShortNames.Checked = $True
			}
			"False" {
				$UI_ISO_A_Year_ShortNames.Checked = $False
			}
		}
	} else {
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Year_ShortNames" -value "True" -String
		$UI_ISO_A_Year_ShortNames.Checked = $True
	}

	<#
		.年：B：使用短名称
	#>
	$UI_ISO_B_Year_ShortNames = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "B"
		Location       = "100,210"
		add_Click      = {
			if ($UI_ISO_B_Year_ShortNames.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Year_ShortNames" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Year_ShortNames" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Year_ShortNames" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Year_ShortNames" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_B_Year_ShortNames.Checked = $True
			}
			"False" {
				$UI_ISO_B_Year_ShortNames.Checked = $False
			}
		}
	}
	$UI_ISO_Year_ShortNames_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 400
		Location       = "150,215"
		Text           = $lang.PublicYMUseShortNames
	}

	<#
		.群组：月
	#>
	$GUIISOMonthTitle  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 80
		Text           = $lang.PublicMonth
		Location       = "35,275"
		Checked        = $True
		add_Click      = {
			if ($GUIISOMonthTitle.Checked) {
				$GUIISOMonthSel.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowDateMonth" -value "True" -String
			} else {
				$GUIISOMonthSel.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowDateMonth" -value "False" -String
			}
			ISO_Create_Refresh_Label
		}
	}
	$GUIISOMonthSel    = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "120,280"
		Value          = 1
		Minimum        = 1
		Maximum        = 12
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateYear" -value $GUIISOYearsSel.Text -String
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveDateMonth" -value $GUIISOMonthSel.Text -String
			ISO_Create_Refresh_Label
		}
	}

	<#
		.月：B：使用短名称
	#>
	$UI_ISO_B_Month_UseShortname = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "B"
		Location       = "100,355"
		add_Click      = {
			if ($UI_ISO_B_Month_UseShortname.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Month_UseShortname" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Month_UseShortname" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Month_UseShortname" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Month_UseShortname" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_B_Month_UseShortname.Checked = $True
			}
			"False" {
				$UI_ISO_B_Month_UseShortname.Checked = $False
			}
		}
	}
	$UI_ISO_Month_UseShortname_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 400
		Location       = "150,360"
		Text           = $lang.PublicYMUseShortNames
	}

	<#
		.月：A：使用数字
	#>
	$UI_ISO_A_Month_Number = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "A"
		Location       = "52,315"
		add_Click      = {
			if ($UI_ISO_A_Month_Number.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Month_Number" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Month_Number" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_A_Month_Number" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_A_Month_Number" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_A_Month_Number.Checked = $True
			}
			"False" {
				$UI_ISO_A_Month_Number.Checked = $False
			}
		}
	} else {
		$UI_ISO_A_Month_Number.Checked = $True
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_A_Month_Number" -value "True" -String
	}

	<#
		.月：B：使用数字
	#>
	$UI_ISO_B_Month_Number = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 40
		Text           = "B"
		Location       = "100,315"
		add_Click      = {
			if ($UI_ISO_B_Month_Number.Checked) {
				$UI_ISO_B_Month_UseShortname.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Month_Number" -value "True" -String
			} else {
				$UI_ISO_B_Month_UseShortname.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_B_Month_Number" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Month_Number" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_B_Month_Number" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_ISO_B_Month_Number.Checked = $True
				$UI_ISO_B_Month_UseShortname.Enabled = $False
			}
			"False" {
				$UI_ISO_B_Month_Number.Checked = $False
				$UI_ISO_B_Month_UseShortname.Enabled = $true
			}
		}
	} else {
		$UI_ISO_B_Month_UseShortname.Enabled = $False
	}
	$UI_ISO_Month_Number_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 400
		Location       = "150,320"
		Text           = $lang.PublicYMUseNumbers
	}

	<#
		.可选功能
	#>
	$GUIISOAdv         = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AdvOption
		Padding        = "16,0,0,0"
	}

	<#
		.选择 Windows 版本号
	#>
	$GUIISOSelectOSVersion = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = $lang.SolutionsDeployOfficeVersion -f "Windows"
		Checked        = $True
		add_Click      = $GUIISOSelectOSVersionClick
	}
	$GUIISOSelectOSVersion_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 398
		Margin         = "51,5,0,45"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = $GUIISOSelectOSVersionClick
	}

	<#
		.选择代号、卷标
	#>
	$GUIISOSelectManual = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = $lang.SelLabel
		Checked        = $True
		add_Click      = $GUIISOSelectManualClick
	}
	$GUIISOSelectManual_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 398
		Margin         = "51,5,0,45"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = $GUIISOSelectManualClick
	}

	<#
		.选择 随机数
	#>
	$GUIISOSelectRandom = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = $lang.GenerateRandom
		add_Click      = {
			if ($GUIISOSelectRandom.Checked) {
				$GUIISOSelectRandomShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddRandom" -value "True" -String
			} else {
				$GUIISOSelectRandomShow.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AddRandom" -value "False" -String
			}
			ISO_Create_Refresh_Label
		}
	}
	$GUIISOSelectRandomShow = New-Object System.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 60
		Width          = 455
		autoSizeMode   = 1
		autoScroll     = $False
	}
	$GUIISOSelectRandomName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 80
		Text           = New_Password
		Location       = '49,2'
		ReadOnly       = $True
	}
	$GUIISOSelectRandomNameReset = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 140
		Text           = $lang.RandomNumberReset
		Location       = "140,4"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUIISOSelectRandomName.Text = New_Password
			ISO_Create_Refresh_Label
		}
	}

	<#
		.选择 Office 版本
	#>
	$GUIISOSelectOffice = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = $lang.SolutionsDeployOfficeVersion -f "Office"
		Checked        = $True
		add_Click      = {
			if ($GUIISOSelectOffice.Checked) {
				$Solutions_Office_Select.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "True" -String
			} else {
				$Solutions_Office_Select.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	$Solutions_Office_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 398
		Margin         = "51,5,0,45"
		Text           = ""
		DropDownStyle  = "DropDownList"
#		Add_SelectedIndexChanged
		Add_SelectedValueChanged = {
			ISO_Create_Refresh_Label
		}
	}

	<#
		.语言混合
	#>
	$GUIISOLabelTitle  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.SelOSver
		Padding        = "32,0,0,0"
	}
	$GUIISOLabelMulti  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.UnattendSelectMulti
		add_Click      = {
			if ($GUIISOLabelMulti.Checked) {
				$GUIISOLabelSingleISO.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsLanguageISO" -value "True" -String
			} else {
				$GUIISOLabelSingleISO.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsLanguageISO" -value "False" -String
			}
		}
	}
	$GUIISOLabelSingleTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "65,0,0,0"
		Text           = $lang.SwitchLanguage
	}
	$GUIISOLabelSingleISO = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 200
		Margin         = "70,5,0,20"
		Padding        = "0,0,0,10"
		Text           = ""
		DropDownStyle  = "DropDownList"
		Add_SelectedValueChanged = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "LanguageISO" -value $GUIISOLabelSingleISO.Text -String
			ISO_Create_Refresh_Label
		}
	}

	<#
		.添加多语言标记
	#>
	$GUIISOSetLangOK   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Margin         = "0,20,0,0"
		Padding        = "32,0,0,0"
		Text           = $lang.ISOAddFlagsLang
		Checked        = $False
		add_Click      = {
			if ($GUIISOSetLangOK.Checked) {
				$GUIISOSetLangShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkLang" -value "True" -String
			} else {
				$GUIISOSetLangShow.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkLang" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	$GUIISOSetLangShow = New-Object System.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 50
		Width          = 455
		autoSizeMode   = 1
		autoScroll     = $False
	}
	$GUIISOSetLang     = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = '49,0'
		Value          = 1
		Minimum        = 1
		Maximum        = 256
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkLangSave" -value $GUIISOSetLang.Text -String
			ISO_Create_Refresh_Label
		}
	}
	$GUIISOSetLangGet  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 265
		Location       = "118,2"
		Text           = $lang.ISOAddFlagsLangGet
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$Verify_Language_New_Path = ISO_Local_Language_Calc -Other

			$GUIISOSetLang.Text = $Verify_Language_New_Path.Count
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkLangSave" -value $GUIISOSetLang.Text -String
			ISO_Create_Refresh_Label
		}
	}

	<#
		.选择多版本标记
	#>
	$GUIISOSetVerOK    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "32,0,0,0"
		Text           = $lang.ISOAddFlagsVer
		Checked        = $False
		add_Click      = {
			if ($GUIISOSetVerOK.Checked) {
				$GUIISOSetVerShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkVersion" -value "True" -String
			} else {
				$GUIISOSetVerShow.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkVersion" -value "False" -String
			}

			ISO_Create_Refresh_Label
		}
	}
	$GUIISOSetVerShow  = New-Object System.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 50
		Width          = 455
		autoSizeMode   = 1
		autoScroll     = $False
	}
	$GUIISOSetVer      = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 60
		Location       = "49,0"
		Value          = 1
		Minimum        = 1
		Maximum        = 256
		add_Click      = {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkVersionSave" -value $GUIISOSetVer.Text -String
			ISO_Create_Refresh_Label
		}
	}
	$GUIISOSetVerGet  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 265
		Location       = "118,2"
		Text           = $lang.ISOAddFlagsVerGet
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$NewGetMulver = ISO_Create_Refresh_Mul_Version

			if ($NewGetMulver.Count -gt 0) {
				$GUIISOSetVer.Text = $NewGetMulver
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkVersionSave" -value $GUIISOSetVer.Text -String
			} else {
				$UI_Main_Error.Text = "$($lang.NoInstallImage): install.wim, install.swm, install.esd"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			}

			ISO_Create_Refresh_Label
		}
	}

	<#
		.添加消费者版、商业版标记
	#>
	$GUIISOEiCFG       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 450
		Padding        = "32,0,0,0"
		Text           = $lang.ISOAddEICFG
		Checked        = $False
		add_Click      = {
			if ($GUIISOEiCFG.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkEI" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkEI" -value "False" -String
			}
			ISO_Create_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkEI" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkEI" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOEiCFG.Checked = $True
			}
			"False" {
				$GUIISOEiCFG.Checked = $False
			}
		}
	} else {
		$GUIISOEiCFG.Checked = $False
	}

	$GUIISOEiCFGTips   = New-Object System.Windows.Forms.Label -Property @{
		Padding        = "47,0,0,0"
		Text           = $lang.ISOAddEICFGTips
		AutoSize       = 1
	}

	<#
		.ISO 保存到
	#>
	$GUIISOGroupTitle  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "16,0,0,0"
		margin         = "0,55,0,0"
		Text           = $lang.UnpackISO
	}
	$GUIISOStructure   = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "34,0,0,0"
		Text           = $lang.ISOStructure
	}

	<#
		.初始化：添加安装类型
	#>
	$GUIISOOSLevel     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.ISOOSLevel
		add_Click      = {
			if ($GUIISOOSLevel.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOLevel" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOLevel" -value "False" -String
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOLevel" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOLevel" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOOSLevel.Checked = $True
			}
			"False" {
				$GUIISOOSLevel.Checked = $False
			}
		}
	} else {
		$GUIISOOSLevel.Checked = $True
	}

	<#
		.添加：群组
	#>
	$GUIISO_Group_Name = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.Event_Group
		add_Click      = {
			if ($GUIISO_Group_Name.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_ISO_Group_Name" -value "True" -String
				$GUIISO_Group_Name_Custom.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_ISO_Group_Name" -value "False" -String
				$GUIISO_Group_Name_Custom.Enabled = $False
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	$GUIISO_Group_Name_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 380
		Text           = ""
		margin         = "70,0,0,25"
		add_Click      = {
			ISO_Create_Not_Refresh_Label
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_ISO_Group_Name" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_ISO_Group_Name" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISO_Group_Name.Checked = $True
				$GUIISO_Group_Name_Custom.Enabled = $True
			}
			"False" {
				$GUIISO_Group_Name.Checked = $False
				$GUIISO_Group_Name_Custom.Enabled = $False
			}
		}
	} else {
		$GUIISO_Group_Name.Checked = $False
		$GUIISO_Group_Name_Custom.Enabled = $False
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "GroupName" -ErrorAction SilentlyContinue) {
		$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "GroupName" -ErrorAction SilentlyContinue
		$GUIISO_Group_Name_Custom.Text = $GetSelectVer
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue) {
			$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "GUID" -ErrorAction SilentlyContinue
			$GUIISO_Group_Name_Custom.Text = $GetSelectVer

			$GUIISO_Group_Name.Checked = $False
			$GUIISO_Group_Name_Custom.Enabled = $False
		} else {
			$GUIISO_Group_Name.Checked = $False
			$GUIISO_Group_Name_Custom.Enabled = $False
		}
	}

	<#
		.添加：事件
	#>
	$GUIISO_Event_Name = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.EventManager
		add_Click      = {
			if ($GUIISO_Event_Name.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_ISO_Event_Name" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "Is_ISO_Event_Name" -value "False" -String
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	$GUIISO_Event_Name_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 380
		Text           = ""
		margin         = "70,0,0,25"
		Enabled        = $False
		add_Click      = {
			ISO_Create_Not_Refresh_Label
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_ISO_Event_Name" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Is_ISO_Event_Name" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISO_Event_Name.Checked = $True
			}
			"False" {
				$GUIISO_Event_Name.Checked = $False
			}
		}
	} else {
		$GUIISO_Event_Name.Checked = $False
	}

	if ([string]::IsNullOrEmpty($GUIISO_Event_Name_Custom.Text)) {
		$GUIISO_Event_Name.Enabled = $False
		$GUIISO_Event_Name.Checked = $False
	} else {
		$GUIISO_Event_Name_Custom.Text = $Global:EventProcessGuid
	}

	<#
		.添加：引擎名称
	#>
	$GUIISO_Engline_Name = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.SolutionsScript
		add_Click      = {
			if ($GUIISO_Engline_Name.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOEngineName" -value "True" -String
				$GUIISO_Engline_Name_Custom.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOEngineName" -value "False" -String
				$GUIISO_Engline_Name_Custom.Enabled = $False
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	$GUIISO_Engline_Name_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 380
		Text           = ""
		margin         = "70,0,0,25"
		add_Click      = {
			ISO_Create_Not_Refresh_Label
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOEngineName" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOEngineName" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISO_Engline_Name.Checked = $True
				$GUIISO_Engline_Name_Custom.Enabled = $True
			}
			"False" {
				$GUIISO_Engline_Name.Checked = $False
				$GUIISO_Engline_Name_Custom.Enabled = $False
			}
		}
	} else {
		$GUIISO_Engline_Name.Checked = $False
		$GUIISO_Engline_Name_Custom.Enabled = $False
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "EngineName" -ErrorAction SilentlyContinue) {
		$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "EngineName" -ErrorAction SilentlyContinue
		$GUIISO_Engline_Name_Custom.Text = $GetSelectVer
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_SelectSolutionVersion" -ErrorAction SilentlyContinue) {
			$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_SelectSolutionVersion" -ErrorAction SilentlyContinue
			$GUIISO_Engline_Name_Custom.Text = $GetSelectVer
		}
	}

	<#
		.添加多语言标记
	#>
	$IsISOAddLanguageFlag = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.ISOAddFlagsLang
		add_Click      = {
			if ($IsISOAddLanguageFlag.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOAddLangFlag" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOAddLangFlag" -value "False" -String
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOAddLangFlag" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOAddLangFlag" -ErrorAction SilentlyContinue) {
			"True" {
				$IsISOAddLanguageFlag.Checked = $True
			}
			"False" {
				$IsISOAddLanguageFlag.Checked = $False
			}
		}
	} else {
		$IsISOAddLanguageFlag.Checked = $False
	}

	<#
		.添加多版本标记
	#>
	$GUIISO_Engline_Language_Know_Group = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.ISOAddFlagsVer
		add_Click      = {
			if ($GUIISO_Engline_Language_Know_Group.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOLangGroup" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOLangGroup" -value "False" -String
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOLangGroup" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOLangGroup" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISO_Engline_Language_Know_Group.Checked = $True
			}
			"False" {
				$GUIISO_Engline_Language_Know_Group.Checked = $False
			}
		}
	} else {
		$GUIISO_Engline_Language_Know_Group.Checked = $False
	}

	$GroupGetKnownLanguage = @()
	$NewSearchFileRule = @(
		"setup.exe.mui"
		"dism.exe.mui"
		"winsetup.dll.mui"
	)

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$TestFolderRegion = Join-Path -Path $Global:Image_source -ChildPath "Sources\$($itemRegion.Region)"

		if (Test-Path -Path $TestFolderRegion -PathType Container) {
			foreach ($NewSearchItem in $NewSearchFileRule) {
				$TestFolderRegionNewItem = Join-Path -Path $TestFolderRegion -ChildPath $NewSearchItem

				if (Test-Path -Path $TestFolderRegionNewItem -PathType leaf) {
					$GroupGetKnownLanguage += $itemRegion.Region
					break
				}
			}
		}
	}

	$GUIISO_Engline_Language_Know_Group_Get = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "70,0,0,25"
		Tag            = $GroupGetKnownLanguage
		Text           = "$($lang.Language): $($GroupGetKnownLanguage)"
	}

	<#
		.添加唯一名称目录
	#>
	$GUIISOUniqueNameDirectory = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "50,0,0,0"
		Text           = $lang.ISOUniqueNameDirectory
		add_Click      = {
			if ($GUIISOUniqueNameDirectory.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOUniqueName" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsISOUniqueName" -value "False" -String
			}

			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOUniqueName" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsISOUniqueName" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOUniqueNameDirectory.Checked = $True
			}
			"False" {
				$GUIISOUniqueNameDirectory.Checked = $False
			}
		}
	} else {
		$GUIISOUniqueNameDirectory.Checked = $True
	}

	<#
		.保存到
	#>
	$GUIISOSaveTo      = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "16,0,0,0"
		margin         = "0,55,0,0"
		Text           = $lang.ISOSaveTo
	}

	<#
		.初始化：ISO 默认保存位置
	#>
	$GUIISOSaveCustomizePath = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 410
		margin         = "40,5,5,25"
		Text           = ""
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			ISO_Create_Not_Refresh_Label
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "ISOTo" -ErrorAction SilentlyContinue) {
		$GUIISOSaveCustomizePath.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "ISOTo" -ErrorAction SilentlyContinue
	} else {
		<#
			.1、获取注册表保存的 ISO 默认旧保存路径，并判断是否可读写
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue) {
			$GUIISOSaveCustomizePath.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue
		} else {
			$GUIISOSaveCustomizePath.Text = $Global:MainMasterFolder
		}
	}

	$GUIISOSaveCustomizePathSelect = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$GUIISOSaveCustomizePath.Text = $FolderBrowser.SelectedPath
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "ISOTo" -value $FolderBrowser.SelectedPath -String
					ISO_Create_Refresh_Label
				} else {
					$UI_Main_Error.Text = $lang.FailedCreateFolder
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				}
			} else {
				$UI_Main_Error.Text = $lang.UserCanel
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			}
		}
	}

	$GUIISOSaveCustomizeOpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ([string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
				$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
			} else {
				if (Test-Path -Path $GUIISOSaveCustomizePath.Text -PathType Container) {
					Start-Process $GUIISOSaveCustomizePath.Text

					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$GUIISOSaveCustomizePath.BackColor = "LightPink"
				}
			}
		}
	}
	$GUIISOSaveCustomizePaste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $GUIISOSaveCustomizePath.Text

				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}
	$GUIISOSaveCustomizePathRestoreGlobal = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.ISOSaveSameGlobal
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue) {
				$GUIISOSaveCustomizePath.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "ISOTo" -ErrorAction SilentlyContinue
			} else {
				$GUIISOSaveCustomizePath.Text = $Global:MainMasterFolder
			}

			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "ISOTo" -value $GUIISOSaveCustomizePath.Text -String
			ISO_Create_Not_Refresh_Label

			$UI_Main_Error.Text = "$($lang.ISOSaveSameGlobal), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}
	$GUIISOSaveCustomizePathRestore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 45
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.ISOSaveSame
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$GUIISOSaveCustomizePath.Text = $Global:MainMasterFolder
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "ISOTo" -value $Global:MainMasterFolder -String
			ISO_Create_Not_Refresh_Label

			$UI_Main_Error.Text = "$($lang.ISOSaveSame), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
		}
	}

	$GUIISOSaveTitle   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Padding        = "16,0,0,0"
		margin         = "0,55,0,0"
		Text           = $lang.SaveTo
	}
	$GUIISOSaveShow    = New-Object System.Windows.Forms.RichTextBox -Property @{
		BorderStyle    = 0
		Height         = 80
		Width          = 410
		margin         = "40,5,0,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$GUIISOSavePaste   = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($GUIISOSaveShow.Text)) {
				$UI_Main_Apply_Detailed_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveShow.BackColor = "LightPink"
			} else {
				Set-Clipboard -Value $GUIISOSaveShow.Text

				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
			}
		}
	}
	$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
	}

	<#
		.扩展：更多高级功能
	#>
	$UI_Main_Adv_Expand_Panel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 435
		Width          = 485
		autoSizeMode   = 1
		Padding        = "0,0,8,0"
		Location       = '560,40'
		autoScroll     = $True
	}

	<#
		.创建 ISO 前需要做些什么
	#>
	$GUIISOAfterTips   = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.ISOCreateAfter
	}

	<#
		.重建 boot.wim
	#>
	$GUIISORebuldBoot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "20,0,0,0"
		Text           = $lang.Reconstruction -f "boot"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($GUIISORebuldBoot.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "DoNotCheckBootSize" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "DoNotCheckBootSize" -value "False" -String
			}
		}
	}
	$GUIISORebuldBootTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "34,0,0,0"
		Text           = ""
	}

	<#
		.重建 install.wim
	#>
	$GUIISORebuldInstall = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "20,0,0,0"
		margin         = "0,20,0,0"
		Text           = $lang.Reconstruction -f "install"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIISORebuldInstallTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Padding        = "34,0,0,0"
		Text           = ""
	}

	<#
		.创建 ISO 后需要做些什么
	#>
	$GUIISOAfterRearTips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		margin         = "0,50,0,0"
		Text           = $lang.ISOCreateRear
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.初始化复选框：绕过 TPM
	#>
	$GUIISOBypassTPM   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "20,0,0,0"
		Text           = $lang.Bypass_TPM
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($GUIISOBypassTPM.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsBypassTPM" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsBypassTPM" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsBypassTPM" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsBypassTPM" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOBypassTPM.Checked = $True
			}
			"False" {
				$GUIISOBypassTPM.Checked = $False
			}
		}
	} else {
#		if ($Global:ImageType -eq "Desktop") {
#			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
#				$GetSaveLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue
#
#				if ($GetSaveLabel -eq "11") {
#					$GUIISOBypassTPM.Checked = $True
#				}
#			}
#		}
	}
	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\bypass11\Quick_11_iso_esd_wim_TPM_toggle.bat" -PathType Leaf -ErrorAction SilentlyContinue) {
		$GUIISOBypassTPM.Enabled = $True
	} else {
		$GUIISOBypassTPM.Enabled = $False
	}

	$UI_ISO_Is_Sparse = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 455
		Padding        = "20,0,0,0"
		Text           = $lang.Sparse
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_ISO_Is_Sparse.Checked) {
				$UI_ISO_Sparse_Rename.Enabled = $True
				$UI_ISO_Sparse_Type_Select.Enabled = $True
			} else {
				$UI_ISO_Sparse_Rename.Enabled = $False
				$UI_ISO_Sparse_Type_Select.Enabled = $False
			}
		}
	}
	$UI_ISO_Sparse_Type_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 220
		margin         = "40,5,0,10"
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
		[pscustomobject]@{ CompressionType = "SHA256"; Lang = "SHA256"; }
		[pscustomobject]@{ CompressionType = "SHA384"; Lang = "SHA384"; }
		[pscustomobject]@{ CompressionType = "SHA512"; Lang = "SHA512"; }
		[pscustomobject]@{ CompressionType = "SHA1";   Lang = "SHA1"; }
		[pscustomobject]@{ CompressionType = "MD5";    Lang = "MD5"; }
	)

	$UI_ISO_Sparse_Type_Select.BindingContext = New-Object System.Windows.Forms.BindingContext
	$UI_ISO_Sparse_Type_Select.Datasource = $CompressionType
	$UI_ISO_Sparse_Type_Select.ValueMember = "CompressionType"
	$UI_ISO_Sparse_Type_Select.DisplayMember = "Lang"

	$UI_ISO_Sparse_Rename = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 455
		Padding        = "36,0,0,0"
		Text           = $lang.ISO_Sparse_Rename
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if ($UI_ISO_Is_Sparse.Checked) {
		$UI_ISO_Sparse_Rename.Enabled = $True
		$UI_ISO_Sparse_Type_Select.Enabled = $True
	} else {
		$UI_ISO_Sparse_Rename.Enabled = $False
		$UI_ISO_Sparse_Type_Select.Enabled = $False
	}

	$UI_ISO_Is_Sparse_Warp = New-Object system.Windows.Forms.Label -Property @{
		Height         = 15
		Width          = 455
	}

	$GUIISOCreateASC   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "20,0,0,0"
		Text           = $lang.CreateASC
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($GUIISOCreateASC.Checked) {
				$GUIISOCreateASCPanel.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsPGP" -value "True" -String
			} else {
				$GUIISOCreateASCPanel.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "IsPGP" -value "False" -String
			}
		}
	}
	$GUIISOCreateASCPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		Padding        = "35,0,0,20"
		autoScroll     = $False
	}
	$GUIISOCreateASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.CreateASCAuthor
	}
	$GUIISOCreateASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 395
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$GUIISOCreateASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 415
		margin         = "0,25,0,0"
		Text           = $lang.CreateASCPwd
	}
	$GUIISOCreateASCPWD = New-Object System.Windows.Forms.MaskedTextBox -Property @{
		Height         = 30
		Width          = 395
		PasswordChar = "*"
		Text           = $Global:secure_password
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.证书密码：显示明文
	#>
	$UI_Main_Pass_Show = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 395
		Location       = '0,255'
		Text           = $lang.ShowPassword
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Pass_Show.Checked) {
				$GUIISOCreateASCPWD.PasswordChar = (New-Object Char)
			} else {
				$GUIISOCreateASCPWD.PasswordChar = "*"
			}
		}
	}

	if ([string]::IsNullOrEmpty($Global:secure_password)) {
		$UI_Main_Pass_Show.Checked = $True
	} else {
		$UI_Main_Pass_Show.Checked = $False
	}

	$GUIISOEmptyDirectory = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 455
		Padding        = "20,0,0,0"
		Text           = "$($lang.Del): $($lang.SelectSettingImage)"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$GUIISOEmptyDirectory_Path = New-Object system.Windows.Forms.LinkLabel -Property @{
		autoSize       = 1
		Text           = $Global:Image_source
		Padding        = "38,0,0,0"
		Margin         = "0,0,0,20"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ([string]::IsNullOrEmpty($This.Text)) {
				$UI_Main_Error.Text = "$($lang.OpenFolder): $($lang.Inoperable)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
			} else {
				if (Test-Path -Path $This.Text -PathType Container) {
					Start-Process $This.Text

					$UI_Main_Error.Text = "$($lang.OpenFolder): $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Error.Text = "$($lang.OpenFolder): $($lang.Inoperable)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				}
			}
		}
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AssignSetting
		Location       = '560,500'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Not_Mounted = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AssignEndNoMount
		Location       = '560,530'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor RED
			$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AssignForceEnd
		Location       = '560,560'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.SuggestedSkip
		Location       = '560,495'
		add_Click      = {
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True" -String
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False" -String
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AssignSetting
		Location       = '576,530'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AssignForceEnd
		Location       = '576,560'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "585,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	Function Autopilot_ISO_Save
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.Creating ISO
			.创建 ISO
		#>
		$Global:Queue_ISO = $False
		if ($UI_Main_Is_Create_ISO.Checked) {
			<#
				.验证自定义 ISO 默认保存到目录名
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIISOSaveCustomizePath.Text)) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoSetLabel)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($GUIISOSaveCustomizePath.Text -match '^\s') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 3. Suffix cannot contain spaces
				.判断：3. 后缀不能带空格
			#>
			if ($GUIISOSaveCustomizePath.Text -match '\s$') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 4. The suffix cannot contain multiple spaces
				.判断：4. 后缀不能带多空格
			#>
			if ($GUIISOSaveCustomizePath.Text -match '\s{2,}$') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 5. There can be no two spaces in between
				.判断：5. 中间不能含有二个空格
			#>
			if ($GUIISOSaveCustomizePath.Text -match '\s{2,}') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 6. Cannot contain: \\ /: *? "" <> |
				.判断：6, 不能包含：\\ / : * ? "" < > |
			#>
			if ($GUIISOSaveCustomizePath.Text -match '[~#$@!%&*{}<>?/|+"]') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 7. No more than 260 characters
				.判断：7. 不能大于 260 字符
			#>
			if ($GUIISOSaveCustomizePath.Text.length -gt 260) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOSaveCustomizePath.BackColor = "LightPink"
				return $False
			}

			<#
				.验证自定义 ISO 默认保存到目录名，结束并保存新路径
			#>
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "ISOTo" -value $GUIISOSaveCustomizePath.Text -String

			<#
				.Mark: Judgment ISO
				.标记：判断 ISO
			#>
			$FlagCheckISOName = $False

			<#
				.Necessary judgment
				.必备判断
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIISOFolderName.Text)) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOFolderName)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($GUIISOFolderName.Text -match '^\s') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 3. Suffix cannot contain spaces
				.判断：3. 后缀不能带空格
			#>
			if ($GUIISOFolderName.Text -match '\s$') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 4. The suffix cannot contain multiple spaces
				.判断：4. 后缀不能带多空格
			#>
			if ($GUIISOFolderName.Text -match '\s{2,}$') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 5. There can be no two spaces in between
				.判断：5. 中间不能含有二个空格
			#>
			if ($GUIISOFolderName.Text -match '\s{2,}') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 6. Cannot contain: \\ /: *? "" <> |
				.判断：6, 不能包含：\\ / : * ? "" < > |
			#>
			if ($GUIISOFolderName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 7. No more than 260 characters
				.判断：7. 不能大于 260 字符
			#>
			if ($GUIISOFolderName.Text.length -gt 260) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "260")"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOFolderName.BackColor = "LightPink"
				return $False
			}

			<#
				.Necessary judgment
				.必备判断
			#>
			<#
				.Judgment: 1. Null value
				.判断：1. 空值
			#>
			if ([string]::IsNullOrEmpty($GUIISOCustomizeName.Text)) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOCustomize)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOCustomizeName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 2. The prefix cannot contain spaces
				.判断：2. 前缀不能带空格
			#>
			if ($GUIISOCustomizeName.Text -match '^\s') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOCustomizeName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 3. Cannot contain: \\ /: *? "" <> |
				.判断：3, 不能包含：\\ / : * ? "" < > |
			#>
			if ($GUIISOCustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOCustomizeName.BackColor = "LightPink"
				return $False
			}

			<#
				.Judgment: 4. No more than 16 characters
				.判断：4. 不能大于 16 字符
			#>
			if ($GUIISOCustomizeName.Text.length -gt 16) {
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "16")"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
				$GUIISOCustomizeName.BackColor = "LightPink"
				return $False
			}

			<#
				.Conditional judgment
				.按条件判断
			#>
			<#
				.判断是否选择 PGP KEY-ID
			#>
			if ($GUIISOCreateASC.Enabled) {
				if ($GUIISOCreateASC.Checked) {
					if ([string]::IsNullOrEmpty($GUIISOCreateASCSign.Text)) {
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						return $False
					}
				}
			}

			<#
				.判断是否选择 Office 版本
			#>
			if ($GUIISOSelectOffice.Enabled) {
				if ($GUIISOSelectOffice.Checked) {
					if ([string]::IsNullOrEmpty($Solutions_Office_Select.Text)) {
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SolutionsDeployOfficeVersion -f "Office")"
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
						return $False
					}
				}
			}

			<#
				.Verify file name rules
				.验证文件名规则
			#>
			if ($GUIISOCheckISO9660.Checked) {
				<#
					.Judgment: 6. No spaces allowed
					.判断：6. 不允许空格
				#>
				if ($GUIISOCustomizeName.Text -match '\s') {
					$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					$GUIISOCustomizeName.BackColor = "LightPink"
					return $False
				}
				<#
					.Done: mark passed
					.完成：标记已通过
				#>
				$FlagCheckISOName = $True
			} else {
				$FlagCheckISOName = $True
			}

			<#
				.Processing tag
				.处理标记
			#>
			if ($FlagCheckISOName) {
				<#
					.Tag: test ISO generation
					.标记：测试 ISO 生成
				#>
				$FlagCreateISOTest = $False

				<#
					.Generate the corresponding directory structure
					.生成对应的目录结构
				#>
				$TestNewFolderStructure = (Join_MainFolder -Path $GUIISOSaveCustomizePath.Text)
				if ($GUIISOOSLevel.Checked) {
					$TestNewFolderStructure += (Join_MainFolder -Path $Global:ImageType)
				}

				<#
					.添加：群组
				#>
				if ($GUIISO_Group_Name.Checked) {
					if (ISO_Create_Refresh_Custom_Group_Name) {
						$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Group_Name_Custom.Text)
					}
				}

				<#
					.添加：引擎名称
				#>
				if ($GUIISO_Engline_Name.Checked) {
					if (ISO_Create_Refresh_Custom_Engine_Name) {
						$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Engline_Name_Custom.Text)
					}
				}

				<#
					.添加：多语言标记
				#>
				if ($IsISOAddLanguageFlag.Checked) {
					$TestNewFolderStructure += (Join_MainFolder -Path $GUIISOSetLang.Text)
				}

				<#
					.添加：多版本标记
				#>
				if ($GUIISO_Engline_Language_Know_Group.Checked) {
					$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Engline_Language_Know_Group_Get.Tag)
				}

				<#
					.添加：事件
				#>
				if ($GUIISO_Event_Name.Enabled) {
					if ($GUIISO_Event_Name.Checked) {
						if (ISO_Create_Refresh_Custom_Events_Name) {
							$TestNewFolderStructure += (Join_MainFolder -Path $GUIISO_Event_Name_Custom.Text)
						}
					}
				}

				if ($GUIISOUniqueNameDirectory.Checked) {
					$TestNewFolderStructure += (Join_MainFolder -Path $GUIISOFolderName.Text)
				}

				<#
					.ISO 保存到：主目录位置
				#>
				$Global:ISOSaveToFolder = $TestNewFolderStructure

				<#
					.ISO 文件名
				#>
				$Global:ISOSaveToFileName = "$($GUIISOFolderName.Text).iso"

				<#
					.保存 ISO 完整路径
				#>
				$Global:ISOSaveToFullName = "$($Global:ISOSaveToFolder)$($Global:ISOSaveToFileName)"

				<#
					.测试 ISO 生成临时目录
				#>
				$RandomGuid = [guid]::NewGuid()
				$ISOTestFolderMain = Join-Path -Path $Global:ISOSaveToFolder -ChildPath $RandomGuid
				Check_Folder -chkpath $ISOTestFolderMain

				<#
					.Delete old ISO
					.删除旧 ISO
				#>
				Remove-Item -Path $Global:ISOSaveToFullName -Force -ErrorAction SilentlyContinue | Out-Null
				if (Test-Path -Path $Global:ISOSaveToFullName -PathType Leaf) {
					<#
						.清除 ISO 临时测试文件
					#>
					Remove_Tree $ISOTestFolderMain
					Remove-Item -Path $Global:ISOSaveToFullName -Force -ErrorAction SilentlyContinue

					$UI_Main_Error.Text = $lang.ISOCreateFailed
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					return $False
				}

				<#
					.Start creating ISO temporary test files
					.开始创建 ISO 临时测试文件
				#>
				if (Test-Path -Path $ISOTestFolderMain -PathType Container) {
					<#
						.The directory is created successfully, an empty file is created
						.创建目录成功，创建一个空文件
					#>
					$test_iso_Save_Temp = Join-Path -Path $Global:ISOSaveToFolder -ChildPath "$($RandomGuid)\writetest-$($RandomGuid)"

					Out-File -FilePath $test_iso_Save_Temp -Encoding utf8 -ErrorAction SilentlyContinue

					$OscdimgArch = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\Oscdimg")\oscdimg.exe"
					if (Test-Path -Path $OscdimgArch -PathType Leaf) {
						$test_iso_Save_Temp_Create = Join-Path -Path $Global:ISOSaveToFolder -ChildPath $RandomGuid

						$arguments = @(
							"-n",
							"-d",
							"-m",
							"""$($test_iso_Save_Temp_Create)""",
							"""$($Global:ISOSaveToFullName)""";
						)

						Start-Process -FilePath $OscdimgArch -ArgumentList $Arguments -Wait -WindowStyle Minimized
					}

					<#
						.oscdimg.exe has been executed to create ISO command to determine whether the file exists.
						.已执行 oscdimg.exe 创建 ISO 命令，判断文件是否存在。
					#>
					if (Test-Path -Path $Global:ISOSaveToFullName -PathType Leaf) {
						$FlagCreateISOTest = $True
					}
				}

				<#
					.清除 ISO 临时测试文件
				#>
				Remove_Tree $ISOTestFolderMain
				Remove-Item -Path $Global:ISOSaveToFullName -Force -ErrorAction SilentlyContinue

				if ($FlagCreateISOTest) {
					$Global:Queue_ISO = $True
					Refres_Event_Tasks_ISO_Create

					<#
						.Rebuild: boot.wim
						.重建：boot.wim
					#>
					if ($GUIISORebuldBoot.Enabled) {
						if ($GUIISORebuldBoot.Checked) {
							$Global:ActionRebuldBoot = $True
						} else {
							$Global:ActionRebuldBoot = $False
						}
					} else {
						$Global:ActionRebuldBoot = $False
					}

					<#
						.Rebuild: install.wim
						.install.wim
					#>
					if ($GUIISORebuldInstall.Enabled) {
						if ($GUIISORebuldInstall.Checked) {
							$Global:ActionRebuldBoot = $True
						} else {
							$Global:ActionRebuldBoot = $False
						}
					} else {
						$Global:ActionRebuldBoot = $False
					}

					<#
						.Processing: Create ASC
						.处理：绕过 TPM
					#>
					$Global:BypassTPM = $False
					if ($GUIISOBypassTPM.Enabled) {
						if ($GUIISOBypassTPM.Checked) {
							$Global:BypassTPM = $True
						}
					}

					<#
						.Processing: Create ASC
						.处理：创建 ASC
					#>
					$Global:CreateASC = $False
					if ($GUIISOCreateASC.Enabled) {
						if ($GUIISOCreateASC.Checked) {
							if ([string]::IsNullOrEmpty($GUIISOCreateASCSign.Text)) {
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
							} else {
								Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "PGP" -value $GUIISOCreateASCSign.Text -String
								$Global:CreateASC = $True
								$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::ExcludePromptAndLiterals
								$Global:secure_password = $GUIISOCreateASCPWD.Text
								$GUIISOCreateASCPWD.TextMaskFormat = [System.Windows.Forms.MaskFormat]::IncludePromptAndLiterals
								$Global:SignGpgKeyID = $GUIISOCreateASCSign.Text
							}
						}
					}

					<#
						.Processing: Create SHA256
						.处理：创建 SHA256
					#>
					if ($UI_ISO_Is_Sparse.Checked) {
						$Global:ISOSparseAllow = $True
					} else {
						$Global:ISOSparseAllow = $False
					}

					$Global:ISOSparseRename = $False
					if ($UI_ISO_Sparse_Rename.Enabled) {
						if ($UI_ISO_Sparse_Rename.Checked) {
							$Global:ISOSparseRename = $True
						}
					}

					$Global:ISOSparseType = $UI_ISO_Sparse_Type_Select.Text

					<#
						.Processing: Empty the main directory
						.处理：清空主目录
					#>
					if ($GUIISOEmptyDirectory.Checked) {
						$Global:EmptyDirectory = $True
					}

					$Global:ISOISOCustomLabel = $GUIISOCustomizeName.Text

					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveLabelSpecify" -value $GUIISOFolderName.Text -String
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "SaveLabel" -value $GUIISOCustomizeName.Text -String

					Refres_Event_Tasks_ISO_Create

					$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Success.ico")

					return $True
				} else {
					$UI_Main_Error.Text = $lang.ISOCreateFailed
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
					return $False
				}
			}
		} else {
			$UI_Main.Hide()
			Write-Host " $($lang.NextDoOperate) " -BackgroundColor DarkRed -ForegroundColor White
			$UI_Main.Close()

			return $True
		}
	}

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_ISO_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red

			<#
				.Rebuild: boot.wim
				.重建：boot.wim
			#>
			if ($GUIISORebuldBoot.Enabled) {
				if ($GUIISORebuldBoot.Checked) {
					$Global:ActionRebuldBoot = $True
					Write-Host "  $($lang.Reconstruction -f "boot")`n" -ForegroundColor Green
				} else {
					$Global:ActionRebuldBoot = $False
				}
			} else {
				$Global:ActionRebuldBoot = $False
			}

			<#
				.Rebuild: install.wim
				.install.wim
			#>
			if ($GUIISORebuldInstall.Enabled) {
				if ($GUIISORebuldInstall.Checked) {
					$Global:ActionRebuldBoot = $True
					Write-Host "  $($lang.Reconstruction -f "install")`n" -ForegroundColor Green
				} else {
					$Global:ActionRebuldBoot = $False
				}
			} else {
				$Global:ActionRebuldBoot = $False
			}

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
	}

	$UI_Main.controls.AddRange((
		$UI_Main_Is_Create_ISO,
		$GUIISOGroupShowADV,
		$GUIISOGroupISOAll,
		$UI_Main_Adv_Expand_Panel,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))
	$UI_Main_Adv_Expand_Panel.controls.AddRange((
		$GUIISOAfterTips,
		$GUIISORebuldBoot,
		$GUIISORebuldBootTips,
		$GUIISORebuldInstall,
		$GUIISORebuldInstallTips,
		$GUIISOAfterRearTips,
		$GUIISOBypassTPM,
		$UI_ISO_Is_Sparse,
		$UI_ISO_Sparse_Type_Select,
		$UI_ISO_Sparse_Rename,
		$UI_ISO_Is_Sparse_Warp,
		$GUIISOCreateASC,
		$GUIISOCreateASCPanel,
		$GUIISOEmptyDirectory,
		$GUIISOEmptyDirectory_Path
	))

	$GUIISOGroupPublicDate.controls.AddRange((
		$GUIISOPublicDateGetCurrent,
		$UI_ISO_YM_Sorting,
		$UI_ISO_A_Sorting,
		$UI_ISO_B_Sorting,
		$UI_ISO_YM_Sorting_Tips,
		$GUIISOYearTitle,
		$GUIISOYearsSel,
		$UI_ISO_A_Year_ShortNames,
		$UI_ISO_B_Year_ShortNames,
		$UI_ISO_Year_ShortNames_Name,

		$GUIISOMonthTitle,
		$GUIISOMonthSel,
		$UI_ISO_A_Month_Number,
		$UI_ISO_B_Month_Number,
		$UI_ISO_Month_Number_Name,
		$UI_ISO_B_Month_UseShortname,
		$UI_ISO_Month_UseShortname_Name
	))

	$GUIISOGroupISOAll.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$GUIISORefreshAuto,
		$GUIISOSelectCustomize,
		$GUIISOCustomizeNameTitle,
		$GUIISOCustomizeName,
		$GUIISOFolderNameTitle,
		$GUIISOFolderName,
		$GUIISOCheckISO9660,
		$GUIISOCheckISO9660Tips,

		# 发行日期
		$GUIISOPublicDate,
		$GUIISOGroupPublicDate,

		$GUIISOAdv,

		$GUIISOSelectOSVersion,
		$GUIISOSelectOSVersion_Select,
		$GUIISOSelectManual,
		$GUIISOSelectManual_Select,

		$GUIISOSelectRandom,
		$GUIISOSelectRandomShow,
		$GUIISOSelectOffice,
		$Solutions_Office_Select,
		$GUIISOLabelTitle,
		$GUIISOLabelMulti,
		$GUIISOLabelSingleTitle,
		$GUIISOLabelSingleISO,
		$GUIISOSetLangOK,
		$GUIISOSetLangShow,
		$GUIISOSetVerOK,
		$GUIISOSetVerShow,
		$GUIISOEiCFG,
		$GUIISOEiCFGTips,

		$GUIISOGroupTitle,
		$GUIISOStructure,
		$GUIISOOSLevel,
		$GUIISO_Group_Name,
		$GUIISO_Group_Name_Custom,
		$GUIISO_Event_Name,
		$GUIISO_Event_Name_Custom,
		$GUIISO_Engline_Name,
		$GUIISO_Engline_Name_Custom,
		$GUIISO_Engline_NewLanguageFlag,
		$IsISOAddLanguageFlag,
		$GUIISO_Engline_Language_Know_Group,
		$GUIISO_Engline_Language_Know_Group_Get,
		$GUIISOUniqueNameDirectory,
		$GUIISOSaveTo,
		$GUIISOSaveCustomizePath,
		$GUIISOSaveCustomizePathSelect,
		$GUIISOSaveCustomizeOpenFolder,
		$GUIISOSaveCustomizePaste,
		$GUIISOSaveCustomizePathRestoreGlobal,
		$GUIISOSaveCustomizePathRestore,
		$GUIISOSaveTitle,
		$GUIISOSaveShow,
		$GUIISOSavePaste,
		$UI_Add_End_Wrap
	))
	$GUIISOSetVerShow.controls.AddRange((
		$GUIISOSetVer,
		$GUIISOSetVerGet
	))
	$GUIISOSelectRandomShow.controls.AddRange((
		$GUIISOSelectRandomName,
		$GUIISOSelectRandomNameReset
	))
	$GUIISOSetLangShow.controls.AddRange((
		$GUIISOSetLang,
		$GUIISOSetLangGet
	))

	$GUIISOCreateASCPanel.controls.AddRange((
		$GUIISOCreateASCSignName,
		$GUIISOCreateASCSign,
		$GUIISOCreateASCPWDName,
		$GUIISOCreateASCPWD,
		$UI_Main_Pass_Show
	))

	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\_Custom\Office" -directory -ErrorAction SilentlyContinue | ForEach-Object {
		$NewFolderPath = $_.FullName

		if ((Test-Path -Path "$($NewFolderPath)\amd64\Office\Data\v64.cab" -PathType Leaf) -or
			(Test-Path -Path "$($NewFolderPath)\x86\Office\Data\v32.cab" -PathType Leaf))
		{
			$Solutions_Office_Select.Items.Add($_.BaseName) | Out-Null
		}
	}

	<#
		.Check Boot.wim file size ≥ 520MB
		.检查 Boot.wim 文件大小 ≥ 520MB

		 检查前，优先检查是否已挂载 boot，已挂载强行关闭该功能
	#>
	#region 检查是否已挂载 boot
	if ((Get-Variable -Scope global -Name "Mark_Is_Mount_Boot;wim;Boot;wim;").Value) {
		$GUIISORebuldBootTips.Text = "$($lang.Inoperable), $($lang.Mounted)"

		<#
			.禁用重建 boot 选择
		#>
		$GUIISORebuldBoot.Enabled = $False
		$GUIISORebuldBoot.Checked = $False
	} else {
		$MarkCheckedBootSize = $False
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) -eq "True") {
				$MarkCheckedBootSize = $True
			}
		} else {
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) {
				if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "DoNotCheckBootSize" -ErrorAction SilentlyContinue) -eq "True") {
					$MarkCheckedBootSize = $True
				}
			}
		}

		$TestWimFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\boot.wim"
		if ($MarkCheckedBootSize) {
			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				if ((Get-Item $TestWimFile).length -gt 520MB) {
					$GUIISORebuldBoot.Checked = $True
					$GUIISORebuldBootTips.Text = $lang.ReconstructionTips
				} else {
					$GUIISORebuldBootTips.Text = $lang.Operable
				}
			} else {
				$GUIISORebuldBoot.Enabled = $False
				$GUIISORebuldBootTips.Text = $lang.Inoperable
			}
		} else {
			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				if ((Get-Item $TestWimFile).length -gt 520MB) {
					$GUIISORebuldBootTips.Text = $lang.ReconstructionTips
				} else {
					$GUIISORebuldBootTips.Text = $lang.Operable
				}
			} else {
				$GUIISORebuldBoot.Enabled = $False
				$GUIISORebuldBootTips.Text = $lang.Inoperable
			}
		}

		<#
			.Initial variable: add the selected image file type
			.初始变量：添加选择的映像文件类型
		#>
		if (Image_Is_Select_Boot) {
			if ((Get-Variable -Scope global -Name "Queue_Is_Language_Add_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
				$GUIISORebuldBoot.Checked = $True
			}
		}
	}
    #endregion 检查是否已挂载 boot

	<#
		.Verification: install.wim
		.验证：install.wim
	#>
	$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"

	if (Test-Path -Path $Install_swm -PathType Leaf) {
		if (((Get-Variable -Scope global -Name "Mark_Is_Mount_install;wim;install;wim;").Value) -or
			((Get-Variable -Scope global -Name "Mark_Is_Mount_install;esd;install;esd;").Value)) {
			$GUIISORebuldInstallTips.Text = "$($lang.Inoperable), $($lang.Mounted)"

			<#
				.禁用重建 boot 选择
			#>
			$GUIISORebuldInstall.Enabled = $False
			$GUIISORebuldInstall.Checked = $False
		} else {
			$GUIISORebuldInstall.Enabled = $True
			$GUIISORebuldInstallTips.Text = $lang.Operable
		}
	} else {
		$GUIISORebuldInstall.Enabled = $False
		$GUIISORebuldInstallTips.Text = $lang.Inoperable
	}

	<#
		.Verification: Determine whether to turn on the conversion function
		.验证：判断是否开启转换功能
	#>
	if ($Global:QueueConvert) {
		$GUIISORebuldInstall.Enabled = $False
		$GUIISORebuldInstallTips.Text = $lang.ConvertOpen
	}

	<#
		.Verification: whether the home directory exists
		.验证：是否存在主目录
	#>
	if (Test-Path -Path $Global:Image_source -PathType Container) {
		$GUIISOEmptyDirectory.Enabled = $True
	} else {
		$GUIISOEmptyDirectory.Enabled = $False
	}

	<#
		.获取目录里的已知语言，输出到：语言
	#>
	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$GUIISOLabelSingleISO.Items.Add($itemRegion.Region) | Out-Null
	}

	$GUIISOLabelSingleISO.controls.Clear()
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "LanguageISO" -ErrorAction SilentlyContinue) {
		$GUIISOLabelSingleISO.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "LanguageISO" -ErrorAction SilentlyContinue
	} else {
		$GUIISOLabelSingleISO.Text = $Global:MainImageLang
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsLanguageISO" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsLanguageISO" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOLabelMulti.Checked = $True
				$GUIISOLabelSingleISO.Enabled = $False
			}
			"False" {
				$GUIISOLabelMulti.Checked = $False
				$GUIISOLabelSingleISO.Enabled = $True
			}
		}
	} else {
		<#
			.获取当前 ISO 是否多语言系列
		#>
		$Verify_Language_New_Path = ISO_Local_Language_Calc -Other

		if ($Verify_Language_New_Path.Count -ge 2) {
			$GUIISOLabelMulti.Checked = $True
			$GUIISOLabelSingleISO.Enabled = $False
		} else {
			$GUIISOLabelMulti.Checked = $False
			$GUIISOLabelSingleISO.Enabled = $True
		}
	}

	<#
		.初始化：已设置多语言值
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkLangSave" -ErrorAction SilentlyContinue) {
		$GUIISOSetLang.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkLangSave" -ErrorAction SilentlyContinue
	} else {
		$Verify_Language_New_Path = ISO_Local_Language_Calc -Other

		$GUIISOSetLang.Text = $Verify_Language_New_Path.Count
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkLangSave" -value $GUIISOSetLang.Text -String
	}

	<#
		.Initialization check: multi-language tag status
		.初始化复选：多语言标记状态
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkLang" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkLang" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSetLangOK.Checked = $True
				$GUIISOSetLangShow.Enabled = $True
			}
			"False" {
				$GUIISOSetLangOK.Checked = $False
				$GUIISOSetLangShow.Enabled = $False
			}
		}
	} else {
		$GUIISOSetLangOK.Checked = $False
		$GUIISOSetLangShow.Enabled = $False
	}

	<#
		.初始化：已设置多语言值
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkVersionSave" -ErrorAction SilentlyContinue) {
		$GUIISOSetVer.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkVersionSave" -ErrorAction SilentlyContinue
	} else {
		[int]$MarkInitVer = 0

		$MarkGetInstallFile = $False

		$Install_swm = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
		$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
		$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"

		if (Test-Path -Path $Install_wim -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_wim -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkGetInstallFile = $True
					$MarkInitVer++
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_SWM)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}

		if (Test-Path -Path $Install_ESD -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_ESD -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkGetInstallFile = $True
					$MarkInitVer++
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_ESD)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}

		if (Test-Path -Path $Install_SWM -PathType Leaf) {
			try {
				Get-WindowsImage -ImagePath $Install_SWM -ErrorAction SilentlyContinue | ForEach-Object {
					$MarkGetInstallFile = $True
					$MarkInitVer++
				}
			} catch {
				Write-Host "  $($lang.ConvertChk)"
				Write-Host "  $($Install_SWM)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
		}

		if ($MarkGetInstallFile) {
			$GUIISOSetVer.Text = $MarkInitVer
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "AllowMarkVersionSave" -value $GUIISOSetVer.Text -String
		} else {
			$UI_Main_Error.Text = "$($lang.NoInstallImage): install.wim, install.swm, install.esd"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
		}
	}

	<#
		.初始化复选：发行时间，年
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowDateYear" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowDateYear" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOYearsSel.Enabled = $True
				$GUIISOYearTitle.Checked = $True
			}
			"False" {
				$GUIISOYearsSel.Enabled = $False
				$GUIISOYearTitle.Checked = $False
			}
		}
	}
	<#
		.初始值：发行时间，年
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveDateYear" -ErrorAction SilentlyContinue) {
		$GUIISOYearsSel.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveDateYear" -ErrorAction SilentlyContinue
	} else {
		$GUIISOYearsSel.Text = (Get-Date).ToString("yyyy")
	}

	<#
		.初始化复选：发行时间，月
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowDateMonth" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowDateMonth" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOMonthSel.Enabled = $True
				$GUIISOMonthTitle.Checked = $True
			}
			"False" {
				$GUIISOMonthSel.Enabled = $False
				$GUIISOMonthTitle.Checked = $False
			}
		}
	}
	<#
		.初始值：发行时间，月
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveDateMonth" -ErrorAction SilentlyContinue) {
		$GUIISOMonthSel.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveDateMonth" -ErrorAction SilentlyContinue
	} else {
		$GUIISOMonthSel.Text = (Get-Date).ToString("MM")
	}

	<#
		.Initialization check: Multi-version marker status
		.初始化复选：多版本标记状态
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkVersion" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AllowMarkVersion" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSetVerOK.Checked = $True
				$GUIISOSetVerShow.Enabled = $True
			}
			"False" {
				$GUIISOSetVerOK.Checked = $False
				$GUIISOSetVerShow.Enabled = $False
			}
		}
	} else {
		$GUIISOSetVerOK.Checked = $False
		$GUIISOSetVerShow.Enabled = $False
	}

	<#
		.Add Windows Version
		.添加 Windows 版本号
	#>
	foreach ($item in $Global:OSVersion) {
		$GUIISOSelectOSVersion_Select.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddFlagsWindowsVersion" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddFlagsWindowsVersion" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSelectOSVersion.Checked = $True
				$GUIISOSelectOSVersion_Select.Enabled = $True
			}
			"False" {
				$GUIISOSelectOSVersion.Checked = $False
				$GUIISOSelectOSVersion_Select.Enabled = $False
			}
		}
	} else {
		$GUIISOSelectOSVersion.Checked = $True
		$GUIISOSelectOSVersion_Select.Enabled = $True
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "PreWindowsVersion" -ErrorAction SilentlyContinue) {
		$GUIISOSelectOSVersion_Select.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "PreWindowsVersion" -ErrorAction SilentlyContinue
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
			$GetSaveLabel = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue

			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -name "PreWindowsVersion" -value $GetSaveLabel -String
			$GUIISOSelectOSVersion_Select.Text = $GetSaveLabel
		} else {
			$GUIISOSelectOSVersion_Select.Text = ""
			$GUIISOSelectOSVersion_Select.Enabled = $False
			$GUIISOSelectOSVersion.Checked = $False
		}
	}

	<#
		.add tag
		.添加标签
	#>
	foreach ($item in $Global:OSCodename) {
		$GUIISOSelectManual_Select.Items.Add($item) | Out-Null
	}

	<#
		.Get the matched or saved tag name
		.获取匹配到，或已保存的标签名
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddFlagsCodeVersion" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddFlagsCodeVersion" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSelectManual.Checked = $True
				$GUIISOSelectManual_Select.Enabled = $True
			}
			"False" {
				$GUIISOSelectManual.Checked = $False
				$GUIISOSelectManual_Select.Enabled = $False
			}
		}
	} else {
		$GUIISOSelectManual.Checked = $False
		$GUIISOSelectManual_Select.Enabled = $False
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Label" -ErrorAction SilentlyContinue) {
		$GUIISOSelectManual_Select.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "Label" -ErrorAction SilentlyContinue
		$GUIISOSelectManual.Checked = $True
		$GUIISOSelectManual_Select.Enabled = $True
	} else {
		$GUIISOSelectManual_Select.Text = ""
		$GUIISOSelectManual_Select.Enabled = $False
		$GUIISOSelectManual.Checked = $False
	}

	<#
		.Initialization check: Select Office Version
		.初始化复选：选择 Office 版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowDeploy" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowDeploy" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSelectOffice.Checked = $True
				$Solutions_Office_Select.Enabled = $True
			}
			"False" {
				$GUIISOSelectOffice.Checked = $False
				$Solutions_Office_Select.Enabled = $False
			}
		}
	} else {
		$GUIISOSelectOffice.Checked = $False
		$Solutions_Office_Select.Enabled = $False
	}

	<#
		.Initialization check: Random
		.初始化复选：随机数
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddRandom" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "AddRandom" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOSelectRandom.Checked = $True
				$GUIISOSelectRandomShow.Enabled = $True
			}
			"False" {
				$GUIISOSelectRandom.Checked = $False
				$GUIISOSelectRandomShow.Enabled = $False
			}
		}
	} else {
		$GUIISOSelectRandom.Checked = $False
		$GUIISOSelectRandomShow.Enabled = $False
	}

	<#
		.add Office tag
		.添加 Office 标签
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_PreOfficeVersion" -ErrorAction SilentlyContinue) {
		$Solutions_Office_Select.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_PreOfficeVersion" -ErrorAction SilentlyContinue
	}

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $Global:GpgKI) {
		$GUIISOCreateASCSign.Items.Add($item) | Out-Null
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "PGP" -ErrorAction SilentlyContinue) {
		$GUIISOCreateASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "PGP" -ErrorAction SilentlyContinue
	}

	<#
		.初始化复选框：生成 PGP
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISOCreateASC.Checked = $True
				$GUIISOCreateASCPanel.Enabled = $True
				$GUIISOCreateASCPanel.Visible = $True
			}
			"False" {
				$GUIISOCreateASC.Checked = $False
				$GUIISOCreateASCPanel.Enabled = $False
				$GUIISOCreateASCPanel.Visible = $False
			}
		}
	} else {
		$GUIISOCreateASC.Checked = $False
		$GUIISOCreateASCPanel.Enabled = $False
		$GUIISOCreateASCPanel.Visible = $False
	}

	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIISOCreateASCPanel.Visible = $True
		if ($GUIISOCreateASC.Checked) {
			$GUIISOCreateASCPanel.Enabled = $True
		} else {
			$GUIISOCreateASCPanel.Enabled = $False
		}
	} else {
		$GUIISOCreateASC.Enabled = $False
		$GUIISOCreateASCPanel.Enabled = $False
		$GUIISOCreateASCPanel.Visible = $False
	}

	<#
		.每次刷新标签
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsRefreshLabel" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "IsRefreshLabel" -ErrorAction SilentlyContinue) {
			"True" {
				$GUIISORefreshAuto.Checked = $True
				ISO_Create_Refresh_Label
			}
			"False" {
				$GUIISORefreshAuto.Checked = $False

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabel" -ErrorAction SilentlyContinue) {
					$GUIISOCustomizeName.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabel" -ErrorAction SilentlyContinue
				}

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabelSpecify" -ErrorAction SilentlyContinue) {
					$GUIISOFolderName.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\ISO" -Name "SaveLabelSpecify" -ErrorAction SilentlyContinue
				}
			}
		}
	} else {
		$GUIISORefreshAuto.Checked = $True
		ISO_Create_Refresh_Label
	}

	$OscdimgArch = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\Oscdimg")\oscdimg.exe"
	if (Test-Path -Path $OscdimgArch -PathType Leaf) {
		$NewOtherRuleName = [IO.Path]::GetFileName($Global:Image_source)
		if ([string]::IsNullOrEmpty($NewOtherRuleName)) {
			$UI_Main_Save.Enabled = $False
			$UI_Main_Is_Create_ISO.Enabled = $False
			$UI_Main_Is_Create_ISO.Checked = $False

				$GUIISOGroupISOAll.Enabled = $False
				$GUIISOBypassTPM.Enabled = $False
				$UI_ISO_Is_Sparse.Enabled = $False
				$UI_ISO_Sparse_Rename.Enabled = $False
				$UI_ISO_Sparse_Type_Select.Enabled = $False
				$GUIISOEmptyDirectory.Enabled = $False
		}
	} else {
		$UI_Main_Is_Create_ISO.Enabled = $False
		$UI_Main_Is_Create_ISO.Checked = $False
		ISO_Create_Refresh_Event_Status

		$UI_Main_Error.Text = "$($lang.NoInstallImage): \AIO\Oscdimg\x86\oscdimg.exe"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\Assets\icon\Error.ico")
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot) ]"
	}

	if ($Global:EventQueueMode) {
		Write-Host "`n  $($lang.UnpackISO)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask) ]"
		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Not_Mounted,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		Write-Host "`n  $($lang.UnpackISO)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		<#
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Suggestion_Not.Checked = $True
					$UI_Main_Suggestion_Setting.Enabled = $False
					$UI_Main_Suggestion_Stop.Enabled = $False
				}
				"False" {
					$UI_Main_Suggestion_Not.Checked = $False
					$UI_Main_Suggestion_Setting.Enabled = $True
					$UI_Main_Suggestion_Stop.Enabled = $True
				}
			}
		} else {
			$UI_Main_Suggestion_Not.Checked = $False
			$UI_Main_Suggestion_Setting.Enabled = $True
			$UI_Main_Suggestion_Stop.Enabled = $True
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
				$UI_Main.controls.AddRange((
					$UI_Main_Suggestion_Not,
					$UI_Main_Suggestion_Setting,
					$UI_Main_Suggestion_Stop
				))
			}
		}
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -BackgroundColor White -ForegroundColor Black

		<#
			.发行日期：排序
		#>
		if ($Autopilot.PublicDate.Sorting.GroupA) {
			$UI_ISO_A_Sorting.Checked = $True
		} else {
			$UI_ISO_A_Sorting.Checked = $False
		}

		if ($Autopilot.PublicDate.Sorting.GroupB) {
			$UI_ISO_B_Sorting.Checked = $True
		} else {
			$UI_ISO_B_Sorting.Checked = $False
		}

		<#
			.选择发行日期：年
		#>
		if ($Autopilot.PublicDate.Year.IsAllow) {
			$GUIISOYearTitle.Checked = $True
			$GUIISOYearsSel.Enabled = $True
		} else {
			$GUIISOYearTitle.Checked = $False
			$GUIISOYearsSel.Enabled = $False
		}

			<#
				.选择发行日期：年，使用短名称，A
			#>
			if ($Autopilot.PublicDate.Year.UseShortnames.GroupA) {
				$UI_ISO_A_Year_ShortNames.Checked = $true
			} else {
				$UI_ISO_A_Year_ShortNames.Checked = $False
			}

			<#
				.选择发行日期：年，使用短名称，B
			#>
			if ($Autopilot.PublicDate.Year.UseShortnames.GroupB) {
				$UI_ISO_B_Year_ShortNames.Checked = $true
			} else {
				$UI_ISO_B_Year_ShortNames.Checked = $False
			}

		<#
			.选择发行日期：月
		#>
		if ($Autopilot.PublicDate.Month.IsAllow) {
			$GUIISOMonthTitle.Checked = $True
			$GUIISOMonthSel.Enabled = $True
		} else {
			$GUIISOMonthTitle.Checked = $False
			$GUIISOMonthSel.Enabled = $False
		}

			<#
				.选择发行日期：月，月份使用数字 A
			#>
			if ($Autopilot.PublicDate.Month.UseNumber.GroupA) {
				$UI_ISO_A_Month_Number.Checked = $True
			} else {
				$UI_ISO_A_Month_Number.Checked = $False
			}

			<#
				.选择发行日期：月，月份使用数字 B
			#>
			if ($Autopilot.PublicDate.Month.UseNumber.GroupB) {
				$UI_ISO_B_Month_Number.Checked = $True
				$UI_ISO_B_Month_UseShortname.Enabled = $False
			} else {
				$UI_ISO_B_Month_Number.Checked = $False
				$UI_ISO_B_Month_UseShortname.Enabled = $true
			}

			<#
				.选择发行日期：月，月份使用短名称 B
			#>
			if ($Autopilot.PublicDate.Month.UseShortnames.GroupB) {
				$UI_ISO_B_Month_UseShortname.Checked = $True
			} else {
				$UI_ISO_B_Month_UseShortname.Checked = $False
			}

		<#
			.选择 Windows 版本号
		#>
		if ($Autopilot.WindowsVersion.Enable) {
			$GUIISOSelectOSVersion.Checked = $True
			$GUIISOSelectOSVersion_Select.Enabled = $True

			if ($Autopilot.WindowsVersion.Code -eq "Auto") {
				if ([string]::IsNullOrEmpty($GUIISOSelectOSVersion_Select.Text)) {
					$GUIISOSelectOSVersion_Select.Items.Add($Autopilot.WindowsVersion.InitialRelease) | Out-Null
					$GUIISOSelectOSVersion_Select.Text = $Autopilot.WindowsVersion.InitialRelease
				}
			} else {
				if ([string]::IsNullOrEmpty($Autopilot.WindowsVersion.InitialRelease)) {
				} else {
					$GUIISOSelectOSVersion_Select.Items.Add($Autopilot.WindowsVersion.InitialRelease) | Out-Null
					$GUIISOSelectOSVersion_Select.Text = $Autopilot.WindowsVersion.InitialRelease
				}
			}

			if ([string]::IsNullOrEmpty($GUIISOSelectOSVersion_Select.Text)) {
				$GUIISOSelectOSVersion.Checked = $False
				$GUIISOSelectOSVersion_Select.Enabled = $False
			} else {
				$GUIISOSelectOSVersion.Checked = $True
				$GUIISOSelectOSVersion_Select.Enabled = $True
			}
		} else {
			$GUIISOSelectOSVersion.Checked = $False
			$GUIISOSelectOSVersion_Select.Enabled = $False
		}

		<#
			.选择 Windows 代码
		#>
		if ($Autopilot.WindowsCode.Enable) {
			$GUIISOSelectManual.Checked = $True
			$GUIISOSelectManual_Select.Enabled = $True

			if ($Autopilot.WindowsCode.Code -eq "Auto") {
				if ([string]::IsNullOrEmpty($GUIISOSelectManual_Select.Text)) {
					$GUIISOSelectManual_Select.Items.Add($Autopilot.WindowsCode.Code) | Out-Null
					$GUIISOSelectManual_Select.Text = $Autopilot.WindowsCode.Code
				}
			} else {
				$GUIISOSelectManual_Select.Items.Add($Autopilot.WindowsCode.Code) | Out-Null
				$GUIISOSelectManual_Select.Text = $Autopilot.WindowsCode.Code
			}

			if ([string]::IsNullOrEmpty($GUIISOSelectManual_Select.Text)) {
				$GUIISOSelectManual.Checked = $False
				$GUIISOSelectManual_Select.Enabled = $False
			} else {
				$GUIISOSelectManual.Checked = $True
				$GUIISOSelectManual_Select.Enabled = $True
			}
		} else {
			$GUIISOSelectManual.Checked = $False
			$GUIISOSelectManual_Select.Enabled = $False
		}

		<#
			.选择 随机数
		#>
		if ($Autopilot.Random) {
			$GUIISOSelectRandom.Checked = $True
		} else {
			$GUIISOSelectRandom.Checked = $False
		}

		<#
			.映像语言合集
		#>
		if ($Autopilot.ImageLanguage) {
			$GUIISOSetLangOK.Checked = $True
			$GUIISOSetLangShow.Enabled = $True

			$Verify_Language_New_Path = ISO_Local_Language_Calc -Other
			$GUIISOSetLang.Text = $Verify_Language_New_Path.Count
		} else {
			$GUIISOSetLangOK.Checked = $False
			$GUIISOSetLangShow.Enabled = $False
		}

		<#
			.映像版本合集
		#>
		if ($Autopilot.imageVersions) {
			$GUIISOSetVerOK.Checked = $True
			$GUIISOSetVerShow.Enabled = $True
			
			$NewGetMulver = ISO_Create_Refresh_Mul_Version
			if ($NewGetMulver.Count -gt 0) {
				$GUIISOSetVer.Text = $NewGetMulver
			}
		} else {
			$GUIISOSetVerOK.Checked = $False
			$GUIISOSetVerShow.Enabled = $False
		}

		<#
			.映像版本类型
		#>
		if ($Autopilot.imageVersionsType) {
			$GUIISOEiCFG.Checked = $True
		} else {
			$GUIISOEiCFG.Checked = $False
		}

		<#
			.目录结构：添加安装类型
		#>
		if ($Autopilot.Structure.InstallType) {
			$GUIISOOSLevel.Checked = $True
		} else {
			$GUIISOOSLevel.Checked = $False
		}

		<#
			.分组：群组
		#>
		if ([string]::IsNullOrEmpty($Autopilot.Structure.Group)) {
			$GUIISO_Group_Name.Checked = $False
			$GUIISO_Group_Name_Custom.Enabled = $False
		} else {
			$GUIISO_Group_Name_Custom.Text = $Autopilot.Structure.Group

			$GUIISO_Group_Name.Checked = $True
			$GUIISO_Group_Name_Custom.Enabled = $True
		}

		<#
			.分组：事件
		#>
		if ([string]::IsNullOrEmpty($Autopilot.Structure.Group)) {
			$GUIISO_Event_Name.Checked = $False
		} else {
			$GUIISO_Event_Name.Checked = $True
		}

		<#
			.目录结构：添加多语言标记
		#>
		if ($Autopilot.Structure.MulTags) {
			$IsISOAddLanguageFlag.Checked = $True
		} else {
			$IsISOAddLanguageFlag.Checked = $False
		}

		<#
			.目录结构：添加多版本标记
		#>
		if ($Autopilot.Structure.VerTags) {
			$GUIISO_Engline_Language_Know_Group.Checked = $True
		} else {
			$GUIISO_Engline_Language_Know_Group.Checked = $False
		}

		<#
			.目录结构：添加唯一名称目录
		#>
		if ($Autopilot.Structure.UniqueName) {
			$GUIISOUniqueNameDirectory.Checked = $True
		} else {
			$GUIISOUniqueNameDirectory.Checked = $False
		}

		<#
			.分组：引擎版本
		#>
		if ([string]::IsNullOrEmpty($Autopilot.Structure.EngineVersion)) {
			$GUIISO_Engline_Name.Checked = $False
			$GUIISO_Engline_Name_Custom.Enabled = $False
		} else {
			$GUIISO_Engline_Name_Custom.Text = $Autopilot.Structure.EngineVersion

			$GUIISO_Engline_Name.Checked = $True
			$GUIISO_Engline_Name_Custom.Enabled = $True
		}

		<#
			.保存到
		#>
		if ([string]::IsNullOrEmpty($Autopilot.SaveTo)) {

		} else {
			if (Test_Available_Disk -Path $Autopilot.SaveTo) {
				$GUIISOSaveCustomizePath.Text = $Autopilot.SaveTo
			}
		}

		<#
			.处理前
		#>

			<#
				.Rebuild: boot.wim
				.重建：boot.wim
			#>
			if ($Autopilot.Before.Rebuild.Boot) {
				$GUIISORebuldBoot.Checked = $true
			} else {
				$GUIISORebuldBoot.Checked = $False
			}

			<#
				.Rebuild: install.wim
				.install.wim
			#>
			if ($Autopilot.Before.Rebuild.Install) {
				$GUIISORebuldInstall.Checked = $true
			} else {
				$GUIISORebuldInstall.Checked = $False
			}

		<#
			.完成后
		#>

			<#
				.Processing: Create ASC
				.处理：绕过 TPM
			#>
			if ($Autopilot.After.TPM) {
				$GUIISOBypassTPM.Checked = $true
			} else {
				$GUIISOBypassTPM.Checked = $False
			}

			<#
				.Processing: Create SHA256
				.处理：创建 哈稀
			#>
			if ([string]::IsNullOrEmpty($Autopilot.After.CRCSHA.Schome)) {
				$UI_ISO_Is_Sparse.Checked = $False
				$UI_ISO_Sparse_Type_Select.Enabled = $False
				$UI_ISO_Sparse_Rename.Enabled = $False
			} else {
				$UI_ISO_Sparse_Type_Select.SelectedIndex = $UI_ISO_Sparse_Type_Select.FindString($Autopilot.After.CRCSHA.Schome)

				$UI_ISO_Is_Sparse.Checked = $true
				$UI_ISO_Sparse_Type_Select.Enabled = $True
				$UI_ISO_Sparse_Rename.Enabled = $True
			}

			if ($Autopilot.After.CRCSHA.Rename) {
				$UI_ISO_Sparse_Rename.Checked = $true
			} else {
				$UI_ISO_Sparse_Rename.Checked = $False
			}

			<#
				.Processing: Empty the main directory
				.处理：清空主目录
			#>
			if ($Autopilot.After.RemoveImage) {
				$GUIISOEmptyDirectory.Checked = $true
			} else {
				$GUIISOEmptyDirectory.Checked = $False
			}

			<#
				.Processing: Create ASC
				.处理：创建 ASC
			#>
			Write-Host "`n  $($lang.CreateASC)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Autopilot_Scheme) " -NoNewline -BackgroundColor White -ForegroundColor Black
			switch ($Autopilot.After.PGP.Schome) {
				"Auto" {
					<#
						.初始化复选框：生成 PGP 全局设置
					#>
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "IsPGP" -ErrorAction SilentlyContinue) {
							"True" {
								$GUIISOCreateASC.Checked = $True
								$GUIISOCreateASCPanel.Enabled = $True
								$GUIISOCreateASCPanel.Visible = $True
							}
							"False" {
								$GUIISOCreateASC.Checked = $False
								$GUIISOCreateASCPanel.Enabled = $False
								$GUIISOCreateASCPanel.Visible = $False
							}
						}
					} else {
						$GUIISOCreateASC.Checked = $False
						$GUIISOCreateASCPanel.Enabled = $False
						$GUIISOCreateASCPanel.Visible = $False
					}

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue) {
						$GUIISOCreateASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ISO" -Name "PGP" -ErrorAction SilentlyContinue
					}

					Write-Host " $($lang.RuleCustomize) " -BackgroundColor DarkGreen -ForegroundColor White
					write-host
				}
				"Custom" {
					Write-Host " $($lang.RuleCustomize) " -BackgroundColor DarkGreen -ForegroundColor White

					if ($Autopilot.After.PGP.Custom.IsAllow) {
						write-host "    $($lang.UpdateAvailable)" -ForegroundColor Green

						$GUIISOCreateASC.Checked = $true
						$GUIISOCreateASCPanel.Enabled = $True
						$GUIISOCreateASCPanel.Visible = $True

						$GUIISOCreateASCPWD.Text = $Autopilot.After.PGP.Custom.Pwd

						if ($Global:GpgKI -contains $Autopilot.After.PGP.Custom.KeyID) {
							$GUIISOCreateASCSign.Text = $Autopilot.After.PGP.Custom.KeyID
						} else {
							$GUIISOCreateASCSign.Items.Add($Autopilot.After.PGP.Custom.KeyID) | Out-Null
							$GUIISOCreateASCSign.Text = $Autopilot.After.PGP.Custom.KeyID
						}
					} else {
						write-host "    $($lang.UpdateUnavailable)" -ForegroundColor Red

						$GUIISOCreateASC.Checked = $False
						$GUIISOCreateASCPanel.Enabled = $False
						$GUIISOCreateASCPanel.Visible = $False
					}

					write-host
				}
			}

		ISO_Create_Refresh_Every_Time_Label
		Refres_Event_Tasks_ISO_Create

		if (Autopilot_ISO_Save) {
			
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		ISO_Create_Refresh_Every_Time_Label
		Refres_Event_Tasks_ISO_Create

		if ($Quick) {
			Write-host "  " -NoNewline
			Write-Host " $($lang.Setting) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Autopilot_ISO_Save) {

			} else {
				Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

				$UI_Main.ShowDialog() | Out-Null
			}
		} else {
			$UI_Main.ShowDialog() | Out-Null
		}
	}
}

Function Autopilot_ISO_Import
{
	param
	(
		$FileName
	)

	Write-Host "`n  $($FileName)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.CRCSHA): " -NoNewline

	<#
		.判断配置文件是否存在
	#>
	if (Test-Path -Path $FileName -PathType Leaf) {
		<#
			.测试：转换 JSON
		#>
		try {
			$Autopilot = Get-Content -Raw -Path $FileName | ConvertFrom-Json
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "`n  $($lang.Solution): $($lang.IsCreate)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.ImageSource.Tasks.Solutions)) {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			} else {
				Write-Host "  $($lang.YesWork)" -ForegroundColor Yellow

				Solutions_Create_UI -Autopilot $Autopilot.Deploy.ImageSource.Tasks.Solutions -ISO
				Solutions_Generate_Prerequisite -ISO
			}

			<#
				.测试完成后，检查配置文件里是否有 生成 ISO 事件
			#>
			Write-Host "`n  $($lang.UnpackISO)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ([string]::IsNullOrEmpty($Autopilot.Deploy.ImageSource.Tasks.ISO)) {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			} else {
				Write-Host "  $($lang.YesWork)" -ForegroundColor Yellow

				ISO_Create_UI -Autopilot $Autopilot.Deploy.ImageSource.Tasks.ISO -ISO
			}
		} catch {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host " $($lang.NoInstallImage) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

<#
	.Process to create ISO
	.处理创建 ISO
#>
Function ISO_Local_Language_Calc
{
	param
	(
		[switch]$Other
	)

	<#
		.初始化：ISO 里的语言
	#>
	$Language_Sources_ISO = @()

	<#
		.ISO 目录里已有语言
	#>
	$Region = Language_Region
	$Search_Language_File_Custom = @(
		"*Windows-Server-Language-Pack*"
		"*Windows-Client-Language-Pack*"
	)

	$NewSearchFileRule = @(
		"setup.exe.mui"
		"dism.exe.mui"
		"winsetup.dll.mui"
	)

	ForEach ($itemRegion in $Region) {
		$TestFolderRegion = Join-Path -Path $Global:Image_source -ChildPath "Sources\$($itemRegion.Region)"

		if (Test-Path -Path $TestFolderRegion -PathType Container) {
			foreach ($NewSearchItem in $NewSearchFileRule) {
				$TestFolderRegionNewItem = Join-Path -Path $TestFolderRegion -ChildPath $NewSearchItem

				if (Test-Path -Path $TestFolderRegionNewItem -PathType leaf) {
					$Language_Sources_ISO += $itemRegion.Region
					break
				}
			}
		}
	}

	<#
		.优先从主规则里搜索，仅搜索主项，不匹配扩展项，例如 WinRE
	#>
	if ($Other) {
	} else {
		ForEach ($item in $Global:Image_Rule) {
			if ($Global:SMExt -contains $item.Main.Suffix) {
				$SearchMainPath = @(
					Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName)\$($item.Main.ImageFileName)\Language\Add"
					"$(Get_MainMasterFolder)\$($item.Main.ImageFileName)\$($item.Main.ImageFileName)\Language\Add"
					Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($item.Main.ImageFileName)\$($item.Main.ImageFileName)\Language"
				)
				$SearchMainPath = $SearchMainPath | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

				ForEach ($itemRegion in $Region) {
					ForEach ($ItemSearchMain in $SearchMainPath) {
						if (Test-Path -Path "$($ItemSearchMain)\$($itemRegion.Region)" -PathType Container) {
							$Init_Folder_All_File = @()
							Get-ChildItem -Path "$($ItemSearchMain)\$($itemRegion.Region)" -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
								$Init_Folder_All_File += $_.FullName
							}

							ForEach ($Basic in $Search_Language_File_Custom) {
								ForEach ($WildCard in $Init_Folder_All_File) {
									if ([IO.Path]::GetFileName($WildCard) -like $Basic) {
										$Language_Sources_ISO += $itemRegion.Region
									}
								}
							}
						}
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						$SearchExpandPath = @(
							Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName)\$($Expand.ImageFileName)\Language\Add"
							"$(Get_MainMasterFolder)\$($item.Main.ImageFileName)\$($Expand.ImageFileName)\Language\Add"
							Join-Path -Path $Global:MainMasterFolder -ChildPath "$($Global:ImageType)\_Custom\$($item.Main.ImageFileName)\$($Expand.ImageFileName)\Language"
						)
						$SearchExpandPath = $SearchExpandPath | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

						ForEach ($itemRegion in $Region) {
							ForEach ($ItemSearchExpand in $SearchExpandPath) {
								if (Test-Path -Path "$($ItemSearchExpand)\$($itemRegion.Region)" -PathType Container) {
									$Init_Folder_All_File = @()
									Get-ChildItem -Path "$($ItemSearchExpand)\$($itemRegion.Region)" -Recurse -Include ($Global:Search_Language_File_Type) -ErrorAction SilentlyContinue | ForEach-Object {
										$Init_Folder_All_File += $_.FullName
									}

									ForEach ($Basic in $Search_Language_File_Custom) {
										ForEach ($WildCard in $Init_Folder_All_File) {
											if ([IO.Path]::GetFileName($WildCard) -like $Basic) {
												$Language_Sources_ISO += $itemRegion.Region
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	$Calc_All_Language_Group = $Language_Sources_ISO | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

	if ($Global:Developers_Mode) {
		Write-Host "`n  $('-' * 80)`n  $($lang.Developers_Mode_Location): ISO_Dev_1"

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ($Calc_All_Language_Group.Count -gt 0) {
			ForEach ($item in $Calc_All_Language_Group) {
				Write-Host "  $($lang.LanguageCode): " -NoNewline
				Write-Host $item -ForegroundColor Green
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}

	return @{
		Lang  = $Calc_All_Language_Group
		Count = $Calc_All_Language_Group.Count
	}
}

<#
	.Process to create ISO
	.处理创建 ISO
#>
Function ISO_Create_Process
{
	<#
		.Before generating ISO: whether to rebuild boot.wim
		.生成 ISO 前：是否重建 boot.wim
	#>
	if ($Global:ActionRebuldBoot) {
		$TestWimFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\boot.wim"

		Rebuild_Image_File -Filename $TestWimFile
	}

	<#
		.Before generating ISO: whether to rebuild install.wim
		.生成 ISO 前：是否重建 install.wim
	#>
	if ($Global:ActionRebuldBoot) {
		$TestWimFile = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"

		Rebuild_Image_File -Filename $TestWimFile
	}

	<#
		.处理生成 ISO
		.Process to generate ISO
	#>
	if ($Global:Queue_ISO) {
		Write-Host "  $($lang.Operable)`n" -ForegroundColor Green

		<#
			.Clean up old files
			.清理旧文件
		#>
		Remove-Item "$($Global:ISOSaveToFullName)" -force -ErrorAction SilentlyContinue | Out-Null
		Remove-Item "$($Global:ISOSaveToFullName).asc" -force -ErrorAction SilentlyContinue | Out-Null
		Remove-Item "$($Global:ISOSaveToFullName).sha1" -force -ErrorAction SilentlyContinue | Out-Null
		Remove-Item "$($Global:ISOSaveToFullName).sha256" -force -ErrorAction SilentlyContinue | Out-Null

		Write-Host "  $($lang.SaveTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($Global:ISOSaveToFullName)" -ForegroundColor Green

		<#
			.Create the corresponding directory
			.创建对应的目录
		#>
		Check_Folder -chkpath $Global:ISOSaveToFolder
		if (Test-Path -Path $Global:ISOSaveToFolder -PathType Container) {
			if (Test-Path -Path $Global:ISOSaveToFullName -PathType Leaf) {
				Write-Host "  $($lang.FailedCreateFile)" -ForegroundColor Red
				return
			}

			<#
				.Execute the generate ISO command
				.执行生成 ISO 命令
			#>
			$OscdimgArch = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\Oscdimg")\oscdimg.exe"

			Write-Host "`n  $($lang.Running)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if (Test-Path -Path $OscdimgArch -PathType Leaf) {
				Write-Host "  $($OscdimgArch)"
				$ISOBootetfsboot = Join-Path -Path $Global:Image_source -ChildPath "boot\etfsboot.com"
				$ISOBootefisys = Join-Path -Path $Global:Image_source -ChildPath "efi\microsoft\boot\efisys.bin"

				$arguments = @(
					"-m",
					"-o",
					"-u2",
					"-udfver102",
					"-l""$($Global:ISOISOCustomLabel)""",
					"-bootdata:2#p0,e,b""$($ISOBootetfsboot)""#pEF,e,b""$($ISOBootefisys)""",
					"""$($Global:Image_source)""",
					"""$($Global:ISOSaveToFullName)""";
				)

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Start-Process -FilePath '$($OscdimgArch)' -ArgumentList '$($Arguments)'" -ForegroundColor Green
					Write-Host "  $('-' * 80)"
				}

				Start-Process -FilePath $OscdimgArch -ArgumentList $Arguments -Wait -NoNewWindow
			}

			Write-Host
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Uping) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $Global:ISOSaveToFullName -PathType Leaf) {
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White
				return
			}

			<#
				.Processing: Create ASC
				.处理：绕过 TPM
			#>
			$BypassTPMCmd = Join-Path -Path $(Convert-Path "$($PSScriptRoot)\..\..\..\..") -ChildPath "AIO\bypass11\Quick_11_iso_esd_wim_TPM_toggle.bat"

			Write-Host "`n  $($lang.Bypass_TPM)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($Global:BypassTPM) {
				$arguments = @(
					"""$(Join-Path -Path $Global:ISOSaveToFolder -ChildPath $Global:ISOSaveToFileName)"""
				)

				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "  $($lang.Command)" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  Start-Process -FilePath '$($BypassTPMCmd)' -ArgumentList '$($Arguments)'" -ForegroundColor Green
					Write-Host "  $('-' * 80)`n"
				}

				Write-Host "  " -NoNewline
				Write-Host " $($lang.LXPsWaitAddUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Start-Process -FilePath $BypassTPMCmd -ArgumentList $Arguments -wait -WindowStyle Minimized
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host "  " -NoNewline
				Write-Host " $($lang.UpdateUnavailable) " -BackgroundColor DarkRed -ForegroundColor White
			}

			<#
				.Processing: Generate SHA256
				.处理：生成 SHA256
			#>
			Write-Host "`n  $($lang.Sparse)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			$RenameNewISOFile = $Global:ISOSaveToFullName
			if ($Global:ISOSparseAllow) {
				Write-Host "  $($RenameNewISOFile).sha256" -ForegroundColor Green

				Write-Host "  " -NoNewline
				Write-Host " $($lang.Uping) " -NoNewline -BackgroundColor White -ForegroundColor Black

				<#
					.删除旧文件 .sha256
				#>
				$CustomNewSparseName = "$($RenameNewISOFile).$($Global:ISOSparseType)"
				Remove-Item -path "$($RenameNewISOFile).asc" -Force -ErrorAction SilentlyContinue
				Remove-Item -path "$($RenameNewISOFile).sha1" -Force -ErrorAction SilentlyContinue
				Remove-Item -path "$($RenameNewISOFile).sha256" -Force -ErrorAction SilentlyContinue

				<#
					.开始生成
				#>
				$calchash = (Get-FileHash -Path $RenameNewISOFile -Algorithm $Global:ISOSparseType)
				"$($calchash.Hash)  $($Global:ISOSaveToFileName)" | Out-File -FilePath $CustomNewSparseName -Encoding ASCII -ErrorAction SilentlyContinue | Out-Null

				if (Test-Path -Path $CustomNewSparseName -PathType Leaf) {
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					Write-Host "$($lang.FailedCreateFile): $($RenameNewISOFile).sha256" -ForegroundColor Red
				}

				Write-Host "`n  $($lang.ISO_Sparse_Rename)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline 
				write-host " $($lang.Rename) " -NoNewline -BackgroundColor White -ForegroundColor Black
				if ($Global:ISOSparseRename) {
					Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

					$CustomSha256_Folder = [IO.Path]::GetDirectoryName($RenameNewISOFile)
					$CustomSha256_Filename = [IO.Path]::GetFileNameWithoutExtension($RenameNewISOFile)
					$CustomSha256_Suffix =  [IO.Path]::GetExtension($RenameNewISOFile)

					$CustomSHA256SUffix = Join-Path -Path $CustomSha256_Folder -ChildPath "$($CustomSha256_Filename)_$($calchash.Hash)$($CustomSha256_Suffix)"
					write-host "`n  1. $($lang.Rename)" -ForegroundColor Yellow
					Write-Host "     - $($RenameNewISOFile)" -ForegroundColor Green
					Write-Host "     + $($CustomSHA256SUffix)" -ForegroundColor Green
					Write-Host "     $('.' * 77)"

					<#
						.删除旧文件
					#>
					Remove-Item -path $CustomSHA256SUffix -Force -ErrorAction SilentlyContinue

					<#
						.重命名
					#>
					Rename-Item -Path $RenameNewISOFile -NewName $CustomSHA256SUffix -ErrorAction SilentlyContinue
					if (Test-Path -Path $RenameNewISOFile -PathType Leaf) {
						Write-Host "     $($lang.Failed) " -ForegroundColor Red
					} else {
						if (Test-Path -Path $CustomSHA256SUffix -PathType Leaf) {
							Write-Host "     $($lang.Done) " -ForegroundColor Green

							write-host "`n  2. $($lang.Del)" -ForegroundColor Yellow
							Write-Host "     - $($CustomNewSparseName)" -ForegroundColor Green
							Write-Host "     $('.' * 77)"
							Remove-Item -path $CustomNewSparseName -Force -ErrorAction SilentlyContinue
							if (Test-Path -Path $CustomNewSparseName -PathType Leaf) {
								Write-Host "     $($lang.Failed) " -ForegroundColor Red
							} else {
								$RenameNewISOFile = $CustomSHA256SUffix
								Write-Host "     $($lang.Done) " -ForegroundColor Green
							}
						} else {
							Write-Host "     $($lang.Failed) " -ForegroundColor Red
						}
					}
				} else {
					Write-Host " $($lang.Prerequisite_Not_satisfied) " -BackgroundColor DarkRed -ForegroundColor White
				}
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}

			<#
				.Processing: Generate ASC
				.处理：生成 ASC
			#>
			Write-Host "`n  $($lang.CreateASC)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			if ($Global:CreateASC) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green

				$Verify_Install_Path = Get_ASC -Run "gpg.exe"
				if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
					if (Test-Path -Path $RenameNewISOFile -PathType Leaf) {
						Remove-Item -path "$($RenameNewISOFile).asc" -Force -ErrorAction SilentlyContinue

						Write-Host "  * $($RenameNewISOFile).asc"
						if ([string]::IsNullOrEmpty($Global:secure_password)) {
							$argumentsPrint = @(
								"--local-user",
								"""$($Global:SignGpgKeyID)""",
								"--output",
								"""$($RenameNewISOFile).asc""",
								"--detach-sign",
								"""$($RenameNewISOFile)"""
							)

							$arguments = @(
								"--local-user",
								"""$($Global:SignGpgKeyID)""",
								"--output",
								"""$($RenameNewISOFile).asc""",
								"--detach-sign",
								"""$($RenameNewISOFile)"""
							)
						} else {
							$argumentsPrint = @(
								"--pinentry-mode",
								"loopback",
								"--passphrase",
								"*",
								"--local-user",
								"""$($Global:SignGpgKeyID)""",
								"--output",
								"""$($RenameNewISOFile).asc""",
								"--detach-sign",
								"""$($RenameNewISOFile)"""
							)

							$arguments = @(
								"--pinentry-mode",
								"loopback",
								"--passphrase",
								"""$($Global:secure_password)""",
								"--local-user",
								"""$($Global:SignGpgKeyID)""",
								"--output",
								"""$($RenameNewISOFile).asc""",
								"--detach-sign",
								"""$($RenameNewISOFile)"""
							)
						}

						if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
							Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
							Write-Host "  $('-' * 80)"
							Write-Host "  Start-Process -FilePath '$($Verify_Install_Path)' -argument '$($argumentsPrint)'" -ForegroundColor Green
							Write-Host "  $('-' * 80)"
						}

						Write-Host "  " -NoNewline
						Write-Host " $($lang.Uping) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
						if (Test-Path -Path "$($RenameNewISOFile).asc" -PathType Leaf) {
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} else {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						}
					} else {
						Write-Host "  $($lang.FailedCreateFile)"
					}
				} else {
					Write-Host "  $($lang.ASCStatus)" -ForegroundColor Red
				}

			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
			}

			<#
				.Processing: Empty the main directory
				.处理：清空主目录
			#>
			Write-Host "`n  $($lang.Del): $($lang.SelectSettingImage)" -ForegroundColor Yellow
			Write-Host "  $($lang.Select_Path): " -NoNewline
			Write-Host $Global:Image_source -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if ($Global:EmptyDirectory) {
				Remove_Tree $Global:Image_source
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
				Write-Host " $($lang.NoWork) " -BackgroundColor DarkRed -ForegroundColor White
			}
		} else {
			Write-Host "  $($lang.FailedCreateFolder)"
			Write-Host "  $($Global:ISOSaveToFolder)" -ForegroundColor Red
			return
		}
	} else {
		Write-Host "  $($lang.UserCanel)" -ForegroundColor Red
	}
}

Function New_Password
{
	[OutputType([String])]
	param
	(
		# The length of the password which should be created.
		[Parameter(ValueFromPipeline)]        
		[ValidateRange(8, 255)]
		[Int32]$Length = 8,

		# The character sets the password may contain. A password will contain at least one of each of the characters.
		[String[]]$CharacterSet = ('abcdefghijklmnopqrstuvwxyz',
								   '0123456789'),

		# The number of characters to select from each character set.
		[Int32[]]$CharacterSetCount = (@(1) * $CharacterSet.Count)
	)

	begin {
		$bytes = [Byte[]]::new(4)
		$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
		$rng.GetBytes($bytes)

		$seed = [System.BitConverter]::ToInt32($bytes, 0)
		$rnd = [Random]::new($seed)

		if ($CharacterSet.Count -ne $CharacterSetCount.Count) {
			throw "The number of items in -CharacterSet needs to match the number of items in -CharacterSetCount"
		}

		$allCharacterSets = [String]::Concat($CharacterSet)
	}

	process {
		try {
			$requiredCharLength = 0
			ForEach ($i in $CharacterSetCount) {
				$requiredCharLength += $i
			}

			if ($requiredCharLength -gt $Length) {
				throw "The sum of characters specified by CharacterSetCount is higher than the desired password length"
			}

			$password = [Char[]]::new($Length)
			$index = 0

			for ($i = 0; $i -lt $CharacterSet.Count; $i++) {
				for ($j = 0; $j -lt $CharacterSetCount[$i]; $j++) {
					$password[$index++] = $CharacterSet[$i][$rnd.Next($CharacterSet[$i].Length)]
				}
			}

			for ($i = $index; $i -lt $Length; $i++) {
				$password[$index++] = $allCharacterSets[$rnd.Next($allCharacterSets.Length)]
			}

			# Fisher-Yates shuffle
			for ($i = $Length; $i -gt 0; $i--) {
				$n = $i - 1
				$m = $rnd.Next($i)
				$j = $password[$m]
				$password[$m] = $password[$n]
				$password[$n] = $j
			}

			[String]::new($password)
		} catch {
			Write-Error -ErrorRecord $_
		}
	}
}