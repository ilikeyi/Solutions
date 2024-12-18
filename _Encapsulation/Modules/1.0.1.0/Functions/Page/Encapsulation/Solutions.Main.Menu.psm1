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
		Write-Host " Upd " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	if ($Global:Developers_Mode) {
		$Host.UI.RawUI.WindowTitle += " | $($lang.Developers_Mode)"
		Write-Host " $($lang.Developers_Mode) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Dev " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host
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
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host " O'D RT " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MountImageTo): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Mount_To_Route -ForegroundColor Red
		}

		Write-host "   " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host " O'D MN " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host " O'D MN " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host " $($lang.MainImageFolder): " -NoNewline -ForegroundColor Yellow
			Write-Host $Global:Image_source -ForegroundColor Red

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 6
			Mainpage
		}

		Image_Get_Mount_Status -IsHotkeyShort
	}

	Write-Host "`n   $($lang.EventManager)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-host "    " -NoNewline
	Write-Host " A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Autopilot)" -ForegroundColor Green

	Write-host "    " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

	Write-Host
	Write-Host "   $($lang.Setting) " -NoNewline
	Write-Host " S'et * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", $($lang.SelectSettingImage)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-host "    " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Mount) " -NoNewline -ForegroundColor Green
	Write-Host " Mt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Rebuild) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " Rbd * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " Rbd * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " Rbd * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
	Write-Host " ISA * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
	Write-Host " ISD * " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "        " -NoNewline

	Write-Host " $($lang.Export_Image) " -NoNewline -ForegroundColor Green
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host " Exp * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " Exp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host " Exp * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host ", " -NoNewline

	Write-Host "$($lang.Apply) " -NoNewline -ForegroundColor Green
	Write-Host " App * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	Write-Host " Euwl " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ": $($lang.LanguageExtract)" -NoNewline -ForegroundColor Green
	Write-Host ", " -NoNewline

	Write-Host $lang.Update -ForegroundColor Green

	Write-host "    " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.UnpackISO)" -ForegroundColor Yellow

	Write-host "    " -NoNewline
	if (Image_Is_Mount_Specified -Master "Install" -ImageFileName "Install") {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host "  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Red
	} else {
		Write-Host " 3 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-Host "  $($lang.Convert_Only), $($lang.Conver_Merged), $($lang.Conver_Split_To_Swm)" -ForegroundColor Green
	}

	Write-Host "     4   " -NoNewline -ForegroundColor Green
	Write-Host $lang.MoreFeature -ForegroundColor Yellow

	Write-Host "`n   $($lang.AssignNeedMount)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "    11  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.Mounted_Status): " -ForegroundColor Yellow -NoNewline
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
				Write-Host " Esa " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " Edns " -BackgroundColor DarkMagenta -ForegroundColor White
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
			Write-Host " Esa " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Edns " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Red
			Write-Host " Save * " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Red
			Write-Host " Unmount * " -BackgroundColor DarkRed -ForegroundColor White
		}
	}

	Write-Host "    12  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.Solution): " -ForegroundColor Yellow -NoNewline
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

	Write-Host "    13  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.Language): " -ForegroundColor Yellow -NoNewline
	Write-Host "$($lang.LanguageExtract) " -NoNewline -ForegroundColor Green
	Write-Host " LP E " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " LP A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " LP D " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Green
			Write-Host " LP S " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " LP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " LP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
			Write-Host " LP S " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " LP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " LP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.SwitchLanguage) " -NoNewline -ForegroundColor Red
		Write-Host " LP S " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    14  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.InboxAppsManager): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " IA A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " IA D " -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host "         $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " EP A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " EP D " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Green
			Write-Host " EP U " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " IA A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " IA D " -BackgroundColor DarkRed -ForegroundColor White

			Write-Host "         $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " EP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " EP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Red
			Write-Host " EP U " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " IA A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " IA D " -BackgroundColor DarkRed -ForegroundColor White

		Write-Host "         $($lang.LocalExperiencePack): " -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " EP A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " EP D " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Update) " -NoNewline -ForegroundColor Red
		Write-Host " EP U " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    15  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.CUpdate): " -ForegroundColor Yellow -NoNewline
	Write-Host "$($lang.RuleNewTempate) " -NoNewline -ForegroundColor Green
	Write-Host " CU C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ", " -NoNewline

	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " CU A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " CU D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " CU A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " CU D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " CU A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " CU D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    16  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.Drive): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Green
			Write-Host " DD A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Green
			Write-Host " DD D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
			Write-Host " DD A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
			Write-Host " DD D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.AddTo) " -NoNewline -ForegroundColor Red
		Write-Host " DD A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Del) " -NoNewline -ForegroundColor Red
		Write-Host " DD D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    17  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.Editions): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Green
			Write-Host " IV C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Green
			Write-Host " IV K " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
			Write-Host " IV C " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Red
			Write-Host " IV K " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Change) " -NoNewline -ForegroundColor Red
		Write-Host " IV C " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.EditionsProductKey) " -NoNewline -ForegroundColor Red
		Write-Host " IV K " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    18  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.WindowsFeature): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Green
			Write-Host " WF E " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Green
			Write-Host " WF D " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
			Write-Host " WF E " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
			Write-Host " WF D " -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Enable) " -NoNewline -ForegroundColor Red
		Write-Host " WF E " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Disable) " -NoNewline -ForegroundColor Red
		Write-Host " WF D " -BackgroundColor DarkRed -ForegroundColor White
	}

	Write-Host "    19  " -NoNewline -ForegroundColor Green
	Write-Host " $($lang.SpecialFunction): " -ForegroundColor Yellow -NoNewline
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Green
			Write-Host " PF B " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Green
			Write-Host " PF A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		} else {
			Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
			Write-Host " PF B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
			Write-Host " PF A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			Write-Host ", " -NoNewline

			Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
			Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
		}
	} else {
		Write-Host "$($lang.Functions_Before) " -NoNewline -ForegroundColor Red
		Write-Host " PF B " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Functions_Rear) " -NoNewline -ForegroundColor Red
		Write-Host " PF A " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		Write-Host ", " -NoNewline

		Write-Host "$($lang.Function_Unrestricted) " -NoNewline -ForegroundColor Green
		Write-Host " FX * " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host
	Write-host "   " -NoNewline
	Write-Host " R'R " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.RefreshModules)"

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
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
			Feature_More_Menu
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
		{ "s", "Set", "S'et" -eq $_ } {
			Image_Select
			ToWait -wait 2
			Mainpage
		}
		{ $_ -like "s *" -or $_ -like "set *" -or $_ -like "s'et *" } {
			Write-Host "`n   $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Setting -Command $PSItem
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
		{ "RR", "r'r" -eq $_ } {
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
			"mt" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Mount
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：挂载 + 索引号
			#>
			"mt *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Mount_Index -Command $PSItem
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
				Menu_Shortcuts_Image_Sources_Add
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除 + 索引号
			#>
			"isa *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Image_Sources_Add_IAB -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除
			#>
			"isd" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Remove
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：删除 + 索引号
			#>
			"isd *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Remove_Index -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：提取、更新映像内里的文件
			#>
			"euwl" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Euwl
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"Exp" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Export
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出 + 主键
			#>
			"Exp *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Export_Key -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重建映像文件
			#>
			"Rbd" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Rebuild
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：重建映像文件 + 主键
			#>
			"Rbd *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Rebuild_Key -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出
			#>
			"App" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Apply
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：导出 + 主键
			#>
			"App *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Apply_Key -Command $PSItem
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
				.快捷指令：组：InBox Apps
			#>

			"IA *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_InBox_Apps_IA -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			"EP *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_LXPs_EP -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：组：累积更新
			#>
			"CU *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Cumulative_updates_CU -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：驱动
			#>
			"DD *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Drive -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: Image Version
				.快捷指令：组：映像版本
			#>
			"IV *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Image_version -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: Windows Function
				.快捷指令：组：Windows 功能
			#>
			"WF *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Windows_features -Command $PSItem
				ToWait -wait 2
				Mainpage
			}

			<#
				.Shortcut: Group: PowerShell Functions
				.快捷指令：组：PowerShell Functions 函数功能
			#>
			"PF *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_PowerShell_functions -Command $PSItem
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
						Menu_Shortcuts_PowerShell_functions_Unrestricted -Command $PSItem
						ToWait -wait 2
						Mainpage
					}

			<#
				.开发者模式
			#>
			"Dev" {
				Write-Host "`n   $($lang.Developers_Mode)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"
				Write-Host "   $($lang.Setting)".PadRight(28) -NoNewline
				if ($Global:Developers_Mode) {
					$Global:Developers_Mode = $False
					Write-Host $lang.Disable -ForegroundColor Green
				} else {
					$Global:Developers_Mode = $True
					Write-Host $lang.Enable -ForegroundColor Green
				}

				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：在线更新
			#>
			"Upd" {
				Update
				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：在线更新，静默更新
			#>
			"Upd *" {
				Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
				Menu_Shortcuts_Update -Command $PSItem
				Modules_Refresh -Function "ToWait -wait 2", "Prerequisite", "Mainpage"
				Mainpage
			}

			<#
				.快捷指令：转换所有软件包为压缩包
			#>
			"zip" {
				Write-Host "`n   $($lang.ConvertToArchive)" -ForegroundColor Yellow
				Write-Host "   $('-' * 80)"

				Covert_Software_Package_Unpack
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：打包
			#>
			"Unpk" {
				UnPack_Create_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：创建部署引擎升级包
			#>
			"Ceup" {
				Update_Create_UI
				ToWait -wait 2
				Mainpage
			}

			<#
				.快捷指令：修复 DISM 挂载
			#>
			"Fix" {
				Menu_Shortcuts_Fix
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

		"lp *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Image_Language -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		"lang *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Menu_Shortcuts_Lang -Command $PSItem
			ToWait -wait 2
			Mainpage
		}

		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Help_Command -Name "OD" -Pause
			Mainpage
		}
		{ $_ -like "O'D *" -or $_ -like "Od *" -or $_ -like "O *" } {
			Write-Host "`n   $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_OpenFolder -Command $PSItem
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
		{ "H", "Help", "H'elp" -eq $_ } {
			Solutions_Help
			Get_Next
			ToWait -wait 2
			Mainpage
		}
		{ $_ -like "H'elp *" -or  $_ -like "Help *" -or $_ -like "H *" } {
			Write-Host "`n   $($lang.Short_Cmd)`n" -ForegroundColor Yellow
			Menu_Shortcuts_Help -Command $PSItem
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

		"API" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow
			Solutions_API_Help
			ToWait -wait 2
			Mainpage
		}
		"API *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			Write-Host "`n   $($lang.Developers_Mode): $($lang.API)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"

			Solutions_API_Command -Name $PSItem.Remove(0, 4)

			Write-Host "   $('-' * 80)"
			Write-Host "   API: $($lang.API), $($lang.Done)" -ForegroundColor Green
			ToWait -wait 2
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