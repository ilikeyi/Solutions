<#
	.LOGO
#>
Function Logo
{
	param
	(
		$Title,
		[switch]$ShowUpdate
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Solutions).Author)'s Solutions | $($Title)"

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " $((Get-Module -Name Solutions).Author)'s Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v$((Get-Module -Name Solutions).Version.ToString()) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

	if ($ShowUpdate) {
		Write-Host " $($lang.ChkUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Update " -BackgroundColor DarkMagenta -ForegroundColor White
	} else {
		Write-Host
	}

	Write-Host "   " -NoNewline
	Write-Host " $($lang.Learn) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $((Get-Module -Name Solutions).PrivateData.PSData.ProjectUri) " -BackgroundColor DarkBlue -ForegroundColor White

	Write-Host
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToWait
{
	param
	(
		[int]$Wait
	)

	Write-Host "   $($lang.ToMsg -f $wait)" -ForegroundColor Red
	start-process "timeout.exe" -argumentlist "/t $($wait) /nobreak" -wait -nonewwindow
}

Function Mainpage
{
	$Global:EventQueueMode = $False
	$Global:AutopilotMode = $False

	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.Menu -ShowUpdate
		Write-Host "   $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		Write-host "   " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host " Open RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Green
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host " Open RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Red
			Write-Host $Global:Mount_To_Route -ForegroundColor Red
		}

		Write-host "   " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host " Open MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Green
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host " Open MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Red
			Write-Host $Global:Image_source -ForegroundColor Red

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 6
			Mainpage
		}

		Image_Get_Mount_Status -IsHotkey
	}

	Write-Host "`n   $($lang.EventManager)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-host "     " -NoNewline
	Write-Host " A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Autopilot)" -ForegroundColor Green

	Write-host "     " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

	Write-Host
	Write-host "   " -NoNewline
	Write-Host " S " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Setting)" -NoNewline
	Write-Host ", $($lang.SelectSettingImage)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "      1   " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mount) " -NoNewline -ForegroundColor Green
	Write-Host " Mount * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Rebuild) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " Rebuild " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " Rebuild " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " Rebuild " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
	Write-Host " ISA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
	Write-Host " ISD * " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "          " -NoNewline

	Write-Host "$($lang.Export_Image) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " Export " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " Export " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " Export " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.Apply) " -NoNewline -ForegroundColor Green
	Write-Host " Apply " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host " Euwl " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ": $($lang.LanguageExtract)" -NoNewline -ForegroundColor Green
	Write-Host ", " -NoNewline

	Write-Host $lang.Update -ForegroundColor Green

	Write-host "     " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.UnpackISO)" -ForegroundColor Yellow

	Write-host "     " -NoNewline
	if (Image_Is_Mount_Specified -Master "Install" -ImageFileName "Install") {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Red
	} else {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Green
	}

	Write-Host "      4   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.MoreFeature -ForegroundColor Yellow

	Write-Host "`n   $($lang.AssignNeedMount)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "     11   " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mounted_Status): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Save * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmount * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.Image_Unmount_After): " -NoNewline
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " ESA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " EDNS " -BackgroundColor DarkMagenta -ForegroundColor White
			} else {
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Red
				Write-Host " Save * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Red
				Write-Host " Unmount * " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		if (Image_Is_Mount) {
			Write-Host "$($lang.Image_Unmount_After): " -NoNewline
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Red
			Write-Host " Save * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Red
			Write-Host " Unmount * " -BackgroundColor DarkRed -ForegroundColor White
		}
	}

	Write-Host "     12   $($lang.Solution): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.IsCreate) " -NoNewline -ForegroundColor Green
	Write-Host " SC " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if ((Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Autounattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\Unattend.xml") -PathType Leaf) -or
		(Test-Path -Path $(Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$") -PathType Container))
	{
		Write-Host $lang.Del -ForegroundColor Green
	} else {
		Write-Host $lang.Del -ForegroundColor Red
	}

	Write-Host "     13   $($lang.Language): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.LanguageExtract) " -NoNewline -ForegroundColor Green
	Write-Host " LE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " LA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " LD " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Green
			Write-Host " LS " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " LA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " LD " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
			Write-Host " LS " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " LA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " LD " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
		Write-Host " LS " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     14   $($lang.InboxAppsManager): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " IAA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " IAD " -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host "          $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " LEPA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " LEPD " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Green
			Write-Host " LEPU " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " IAA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " IAD " -BackgroundColor DarkRed -ForegroundColor White

			Write-Host "          $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " LEPA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " LEPD " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Red
			Write-Host " LEPU " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " IAA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " IAD " -BackgroundColor DarkRed -ForegroundColor White

			Write-Host "          $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " LEPA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " LEPD " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Red
			Write-Host " LEPU " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     15   $($lang.CUpdate): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.RuleNewTempate) " -NoNewline -ForegroundColor Green
	Write-Host " CUCT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " CUA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " CUD " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " CUA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " CUD " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " CUA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " CUD " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     16   $($lang.Drive): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " DA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " DD " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " DA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " DD " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " DA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " DD " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     17   $($lang.Editions): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Green
			Write-Host " IVC " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Green
			Write-Host " IVK " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
			Write-Host " IVC " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Red
			Write-Host " IVK " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
		Write-Host " IVC " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Red
		Write-Host " IVK " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     18   $($lang.WindowsFeature): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Green
			Write-Host " WFE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Green
			Write-Host " WFD " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
			Write-Host " WFE " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
			Write-Host " WFD " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
		Write-Host " WFE " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
		Write-Host " WFD " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "     19   $($lang.SpecialFunction): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Green
			Write-Host " PFB " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Green
			Write-Host " PFA " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
			Write-Host " PFB " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
			Write-Host " PFA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
		Write-Host " PFB " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
		Write-Host " PFA " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
		Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host
	Write-host "   " -NoNewline
	Write-Host " RR " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host " " -NoNewline
	Write-Host " R " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RefreshModules)"

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"1" {
			Image_Assign_Event_Master
			ToWait -wait 2
			Mainpage
		}
		"2" {
			ISO_Create
			ToWait -wait 2
			Mainpage
		}
		"3" {
			Image_Convert
			ToWait -wait 2
			Mainpage
		}
		"4" {
			Feature_More
			ToWait -wait 2
			Mainpage
		}
		"11" {
			Image_Eject
			ToWait -wait 2
			Mainpage
		}
		"12" {
			Solutions_Menu
			ToWait -wait 2
			Mainpage
		}
		"13" {
			Language_Menu
			ToWait -wait 2
			Mainpage
		}
		"14" {
			InBox_Apps_Menu
			ToWait -wait 2
			Mainpage
		}
		"15" {
			Update_Menu
			ToWait -wait 2
			Mainpage
		}
		"16" {
			Drive_Menu
			ToWait -wait 2
			Mainpage
		}
		"17" {
			Editions_GUI
			ToWait -wait 2
			Mainpage
		}
		"18" {
			Feature_Menu
			ToWait -wait 2
			Mainpage
		}
		"19" {
			Functions_Menu
			ToWait -wait 2
			Mainpage
		}
		"a" {
			Event_Assign_Task_Customize_Autopilot

			ToWait -wait 2
			Mainpage
		}
		"c" {
			Event_Assign_Task_Customize

			ToWait -wait 2
			Mainpage
		}

		<#
			设置、选择映像源
		#>
		"s" {
			Image_Select
			ToWait -wait 2
			Mainpage
		}

		<#
			热刷新：快速
		#>
		"r" {
			Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
		}

		<#
			热刷新：先决条件
		#>
		"rr" {
			Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.RefreshModules): " -NoNewline
			Write-host $lang.Prerequisites -ForegroundColor Yellow

			Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
		}

		<#
			快捷指令
		#>
			<#
				.快捷指令：校验所有自动驾驶配置文件
			#>
			"va" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Verify_Autopilot_Custom_File
				ToWait -wait 2
				Mainpage
			}

			"vu" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Verify_Unattend_Custom_File
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：挂载
			#>
			"mount" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Mount)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
						Image_Select_Index_UI
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red

					Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   $($lang.OnDemandPlanTask)" -ForegroundColor Green

					ToWait -wait 2
					Image_Assign_Event_Master
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：挂载 + 索引号
			#>
			"Mount *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				$NewIndex = $PSItem.Remove(0, 6).Replace(' ', '')

				Write-Host "`n   $($lang.Mount), $($lang.MountedIndexSelect): " -NoNewline
				Write-Host $NewIndex -ForegroundColor Green
				Write-Host "   $('-' * 80)"

				if ($NewIndex -match '^\d+$') {
					if (Image_Is_Select_IAB) {
						Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
						Write-Host "   $('-' * 80)"

						if (Verify_Is_Current_Same) {
							Write-Host "   $($lang.Mounted)" -ForegroundColor Red
						} else {
							Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
							Image_Select_Index_UI -AutoSelectIndex $NewIndex
						}
					} else {
						Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red

						Write-Host "`n   $($lang.Ok_Go_To)" -ForegroundColor Yellow
						Write-Host "   $('-' * 80)"
						Write-Host "   $($lang.OnDemandPlanTask)" -ForegroundColor Green

						ToWait -wait 2
						Image_Assign_Event_Master
					}
				} else {
					Write-Host "   $($lang.VerifyNumberFailed)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重新选择映像来源：挂载
			#>
			"remount" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Mount)"
				Write-Host "   $('-' * 80)"
				Image_Assign_Event_Master

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：保存当前映像
			#>
			"Save" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Image_Eject_Save_Current
				ToWait -wait 2
				Mainpage
			}
			"Save *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Image_Save_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 5).Replace(' ', '')
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：卸载，默认不保存
			#>
			"unmount" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Image_Eject_Dont_Save_Current
				ToWait -wait 2
				Mainpage
			}
			"unmount *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Image_Unmount_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 7).Replace(' ', '')
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：强行卸载所有已挂载前：保存
			#>
			"ESA" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Image_Unmount_After): " -NoNewline
				Write-Host $lang.Save -ForegroundColor Green
				Write-Host "   $('-' * 80)"
				Eject_Forcibly_All -Save -DontSave

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：强行卸载所有已挂载前：不保存
			#>
			"EDNS" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Image_Unmount_After): " -NoNewline
				Write-Host $lang.DoNotSave -ForegroundColor Green
				Write-Host "   $('-' * 80)"
				Eject_Forcibly_All -DontSave

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：添加
			#>
			"isa" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.AddTo)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429"
						Image_Select_Add_UI
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429e"
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除
			#>
			"isd" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Del)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
						Image_Select_Del_UI
						Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除 + 索引号
			#>
			"isd *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				$NewIndex = $PSItem.Remove(0, 4).Replace(' ', '')

				Write-Host "`n   $($lang.Del), $($lang.MountedIndexSelect): " -NoNewline
				Write-Host $NewIndex -ForegroundColor Green
				Write-Host "   $('-' * 80)"

				if ($NewIndex -match '^\d+$') {
					if (Image_Is_Select_IAB) {
						Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
						Write-Host "   $('-' * 80)"

						if (Verify_Is_Current_Same) {
							Write-Host "   $($lang.Mounted)" -ForegroundColor Red
						} else {
							Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
							Image_Select_Del_UI -AutoSelectIndex $NewIndex
							Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
						}
					} else {
						Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
					}
				} else {
					Write-Host "   $($lang.VerifyNumberFailed)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：提取、更新映像内里的文件
			#>
			"euwl" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				Write-Host "`n   $($lang.Wim_Rule_Update)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "9846"
					Wimlib_Extract_And_Update
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"Export" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Export_Image)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Image_Select_Export_UI
						Get_Next
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重建映像文件
			#>
			"Rebuild" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Rebuild)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					if (Verify_Is_Current_Same) {
						Write-Host "   $($lang.Mounted)" -ForegroundColor Red
					} else {
						Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
					}
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"Apply" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				Write-Host "`n   $($lang.Apply)"
				Write-Host "   $('-' * 80)"
				if (Image_Is_Select_IAB) {
					Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
	
					Image_Select_Index_UI
					Get_Next
				} else {
					Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：解决方案：创建
			#>
			"sc" {
				Solutions
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：组：语言包
			#>
				<#
					.快捷指令：语言包：提取
				#>
				"LE" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

					Write-Host "`n   $($lang.LanguageExtract)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Language_Extract_UI

					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：语言包：添加
				#>
				"LA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Language_Menu_Shortcuts_LA
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：语言包：添加
				#>
				"LD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Language_Menu_Shortcuts_LD
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：语言包：添加
				#>
				"LS" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Language_Menu_Shortcuts_LS
					ToWait -wait 2
					Mainpage
				}

			<#
				.快捷指令：组：InBox Apps
			#>
				<#
					.快捷指令：InBox Apps：添加
				#>
				"IAA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					InBox_Apps_Menu_Shortcuts_Add
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：InBox Apps：删除
				#>
				"IAD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					InBox_Apps_Menu_Shortcuts_Delete
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：本地语言体验包：添加
				#>
				"LEPA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					InBox_Apps_Menu_Shortcuts_LXPs_Add
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：本地语言体验包：更新
				#>
				"LEPU" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					InBox_Apps_Menu_Shortcuts_LXPs_Update
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：本地语言体验包：删除
				#>
				"LEPD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					InBox_Apps_Menu_Shortcuts_LXPs_Delete
					ToWait -wait 2
					Mainpage
				}

			<#
				.快捷指令：组：累积更新
			#>
				<#
					.快捷指令：累积更新：添加
				#>
				"CUCT" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

					Write-Host "`n   $($lang.RuleNewTempate)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Create_Template_UI
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：累积更新：添加
				#>
				"CUA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Update_Menu_Shortcuts_Add
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：累积更新：删除
				#>
				"CUD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Update_Menu_Shortcuts_Delete
					ToWait -wait 2
					Mainpage
				}

			<#
				.快捷指令：组：驱动
			#>
				<#
					.快捷指令：驱动：添加
				#>
				"DA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Drive_Menu_Shortcuts_Add
					ToWait -wait 2
					Mainpage
				}

				<#
					.快捷指令：驱动：删除
				#>
				"DD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Drive_Menu_Shortcuts_Delete
					ToWait -wait 2
					Mainpage
				}

			<#
				.Shortcut: Group: Image Version
				.快捷指令：组：映像版本
			#>
				<#
					.Shortcut: Image Version: Change
					.快捷指令：映像版本：更改
				#>
				"IVC" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Editions_GUI
					ToWait -wait 2
					Mainpage
				}

				<#
					.Shortcut: Image Version: Product Serial Number
					.快捷指令：映像版本：产品序列号
				#>
				"IVK" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Editions_GUI
					ToWait -wait 2
					Mainpage
				}

			<#
				.Shortcut: Group: Windows Function
				.快捷指令：组：Windows 功能
			#>
				<#
					.Shortcut:Windows Features:Enable
					.快捷指令：Windows 功能：启用
				#>
				"WFE" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Feature_Menu_Shortcuts_Enabled
					ToWait -wait 2
					Mainpage
				}

				<#
					.Shortcut:Windows Features:Disable
					.快捷指令：Windows 功能：禁用
				#>
				"WFD" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Feature_Menu_Shortcuts_Disabled
					ToWait -wait 2
					Mainpage
				}

			<#
				.Shortcut: Group: PowerShell Functions
				.快捷指令：组：PowerShell Functions 函数功能
			#>
				<#
					.Shortcut command: PowerShell Functions Function: When there is an event, before running
					.快捷指令：PowerShell Functions 函数功能：有事件时，运行前
				#>
				"PFB" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Functions_Menu_Shortcuts_PFB
					ToWait -wait 2
					Mainpage
				}

				<#
					.Shortcut command: PowerShell Functions Function function: When there is an event, run
					.快捷指令：PowerShell Functions 函数功能：有事件时，运行后
				#>
				"PFA" {
					Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
					Functions_Menu_Shortcuts_PFA
					ToWait -wait 2
					Mainpage
				}

				<#
					.Shortcut: PowerShell Functions Function: Unlimited
					.快捷指令：PowerShell Functions 函数功能：不受限制
				#>
					"FX" {
						Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
						Functions_Unrestricted_UI
						ToWait -wait 2
						Mainpage
					}
					"FX *" {
						Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

						$NewType = $PSItem.Remove(0, 3).Replace(' ', '')
						switch ($NewType) {
							"list" {
								Functions_Tasks_List
								Get_Next
							}
							default {
								if ([string]::IsNullOrEmpty($NewType)) {
									Functions_Unrestricted_UI
								} else {
									Functions_Unrestricted_UI -Custom "Other_Tasks_$($NewType)"
								}
							}
						}

						ToWait -wait 2
						Mainpage
					}

			<#
				.快捷指令：在线更新
			#>
			"Update" {
				Update
				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：在线更新，静默更新
			#>
			"Update *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

				$NewType = $PSItem.Remove(0, 7).Replace(' ', '')
				switch ($NewType) {
					"auto" {
						Update -Auto
					}
					default {
						Update
					}
				}

				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：修复 DISM 挂载
			#>
			"Fix" {
				Write-Host "`n   $($lang.Repair)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				Write-Host "   * $($lang.HistoryClearDismSave)" -ForegroundColor Green
				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*"" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null" -ForegroundColor Green
					Write-Host "   $('-' * 80)`n"
				}
				Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

				Write-Host "   * $($lang.Clear_Bad_Mount)" -ForegroundColor Green
				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
					Write-Host "`n   $($lang.Command)" -ForegroundColor Yellow
					Write-Host "   $('-' * 80)"
					Write-Host "   dism /cleanup-wim" -ForegroundColor Green
					Write-Host "   Clear-WindowsCorruptMountPoint" -ForegroundColor Green
					Write-Host "   $('-' * 80)`n"
				}

				dism /cleanup-wim | Out-Null
				Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：清除并释放已选择主键: Install, WimRE, Boot
			#>
			"CPK" {
				Write-Host "`n   $($lang.Event_Primary_Key_CPK)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				$Global:Primary_Key_Image = @()
				$Global:Save_Current_Default_key = ""

				Write-Host "   $($lang.Done)" -ForegroundColor Green

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：清除变量
			#>
			"Reset" {
				Event_Reset_Variable
				ToWait -wait 2
				Mainpage
			}

		<#
			.切换语言
		#>
		"lang" {
			Language -Reset
			ToWait -wait 2
			Mainpage
		}

		"lang *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewLanguage = $PSItem.Remove(0, 5).Replace(' ', '')
			$Langpacks_Sources = "$($PSScriptRoot)\..\..\..\langpacks"
			switch ($NewLanguage) {
				"list" {
					Write-Host "`n   $($lang.AvailableLanguages)"
					Write-Host "   $('-' * 80)"

					$Match_Available_Languages = @()
					Get-ChildItem -Path $Langpacks_Sources -Directory -ErrorAction SilentlyContinue | ForEach-Object {
						if (Test-Path "$($_.FullName)\Lang.psd1" -PathType Leaf) {
							$Match_Available_Languages += $_.Basename
						}
					}

					if ($Match_Available_Languages.count -gt 0) {
						ForEach ($item in $Global:Languages_Available) {
							if ($Match_Available_Languages -contains $item.Region) {
								Write-Host "   $($item.Region)".PadRight(20) -NoNewline -ForegroundColor Green
								Write-Host $item.Name -ForegroundColor Yellow
							}
						}

						Get_Next
					} else {

					}
				}
				"auto" {
					Write-Host "`n   $($lang.SwitchLanguage): "
					Write-Host "   $('-' * 80)"
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "Language" -ErrorAction SilentlyContinue
					Write-Host "   $($lang.Done)" -ForegroundColor Green
					Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
				}
				default {
					Write-Host "`n   $($lang.SwitchLanguage): " -NoNewline
					Write-Host $NewLanguage -ForegroundColor Green
					Write-Host "   $('-' * 80)"

					if (Test-Path "$($Langpacks_Sources)\$($NewLanguage)\Lang.psd1" -PathType Leaf) {
						Write-Host "   $($lang.Done)" -ForegroundColor Green
						Save_Dynamic -regkey "Solutions" -name "Language" -value $NewLanguage -String
						Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
					} else {
						Write-Host "   $($lang.UpdateUnavailable)" -ForegroundColor Red
					}
				}
			}

			ToWait -wait 2
			Mainpage
		}

		"open *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Open_Command -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Mainpage
		}

		"View *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Primary_Key_Shortcuts_File_View -Name $PSItem.Remove(0, 5).Replace(' ', '')
			ToWait -wait 2
			Mainpage
		}

		"Sel *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Image_Set_Primary_Key_Shortcuts -Name $PSItem.Remove(0, 4).Replace(' ', '')
			ToWait -wait 2
			Mainpage
		}

		<#
			.帮助
		#>
		"hf" {
			Solutions_Help -Full
			Get_Next
			ToWait -wait 2
			Mainpage
		}
		"h" {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Mainpage
		}
		"h *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Solutions_Help_Command -Name $PSItem.Remove(0, 2).Replace(' ', '') -Pause
			ToWait -wait 2
			Mainpage
		}

		<#
			.退出
		#>
		"q" {
			return
		}
		default {
			Mainpage
		}

		<#
			.快速测试区域
		#>
		"t" {
			Write-Host "`n   $($lang.Developers_Mode)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"

			# Start
			$Global:EventQueueMode = $True
			$Global:AutopilotMode = $True

#			$Autopilot = Get-Content -Raw -Path "$($PSScriptRoot)\..\..\..\..\..\_Autopilot\Microsoft Windows 11\24H2\1.zh-CN.json" | ConvertFrom-Json
#			ISO_Create_UI -Autopilot $Autopilot.Deploy.ImageSource.Tasks.ISO -ISO

#			Event_Assign_Task







			$Global:EventQueueMode = $False
			$Global:AutopilotMode = $False
			# End

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Developers_Mode), $($lang.Done)" -ForegroundColor Green

			<#
				.暂停
			#>
#			Get_Next

			<#
				.添加 ToWait 防止直接退出
			#>
			ToWait -wait 2
			Mainpage
		}
	}
}