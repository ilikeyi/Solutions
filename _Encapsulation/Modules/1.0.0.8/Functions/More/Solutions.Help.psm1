<#
	.Help
	.帮助
#>
Function Solutions_Help
{
	param
	(
		[Switch]$Full
	)

	Clear-Host
	Logo -Title $lang.Help

	Write-Host "   $($lang.Short_Cmd)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	if ($Full) {
		Solutions_Help_Command -Name "Sel" -Silent
	} else {
		Write-host "     " -NoNewline
		Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline
		Write-Host "         $($lang.Event_Primary_Key), $($lang.Command), $($lang.Help) " -NoNewline -ForegroundColor Yellow
		Write-Host " H Sel " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	if ($Full) {
		Solutions_Help_Command -Name "View" -Silent
	} else {
		Write-host "     " -NoNewline
		Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline
		Write-Host "        $($lang.ViewWIMFileInfo), $($lang.Command), $($lang.Help) " -NoNewline -ForegroundColor Yellow
		Write-Host " H View " -BackgroundColor DarkMagenta -ForegroundColor White
	}

	if ($Full) {
		Solutions_Help_Command -Name "FX" -Silent
	} else {
		Write-Host "      FX *".PadRight(20) -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.SpecialFunction): $($lang.Function_Unrestricted), $($lang.Short_Cmd)" -NoNewline
		Write-Host " { FX Pause } { FX List }" -ForegroundColor Green
	}

	Write-Host
	Write-Host "     CPK".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Event_Primary_Key_CPK

	Write-Host "     Reset".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.EventManagerClear

	Write-Host "`n   $($lang.SelectSettingImage)"
	Write-Host "     ISD".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Del -NoNewline
	Write-Host " { $($lang.MountedIndex) }" -ForegroundColor Green

	Write-Host "     Mount".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Mount -NoNewline
	Write-Host " { $($lang.MountedIndex) }" -ForegroundColor Green

	Write-Host "     Remount".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mount), $($lang.PleaseChoose)"

	Write-Host "`n   $($lang.Mounted_Status)"
	Write-Host "     ESA".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Image_Unmount_After): " -NoNewline
	Write-Host $lang.Save -ForegroundColor Green

	Write-Host "     EDNS".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Image_Unmount_After): " -NoNewline
	Write-Host $lang.DoNotSave -ForegroundColor Green

	Write-Host "`n   $($lang.RuleOther)"
	Write-Host "     CUCT".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.RuleNewTempate

	Write-Host "     VA".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Wim_Rule_Verify): $($lang.Autopilot_Select_Config)"

	Write-Host "     VU".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Wim_Rule_Verify): $($lang.EnabledUnattend)"

	Write-Host "     Fix".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Repair): $($lang.HistoryClearDismSave)" -ForegroundColor Green
	Write-Host "                    $($lang.Repair): $($lang.Clear_Bad_Mount)" -ForegroundColor Green

	Write-Host
	Write-Host "     RR".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.RefreshModules): " -NoNewline
	Write-host $lang.Prerequisites -ForegroundColor Yellow

	Write-Host
	Write-Host "     lang".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.SwitchLanguage

	Write-Host "     lang list".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.AvailableLanguages

	Write-Host "     lang auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageReset)"

	Write-Host "     lang *".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageCode) " -NoNewline
	Write-Host "{ lang zh-CN }" -ForegroundColor Green

	Write-Host
	Write-Host "     Update".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.ChkUpdate

	Write-Host "     Update auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.ChkUpdate), $($lang.UpdateSilent)"

	Write-Host
	Write-Host "   $($lang.Help)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-host "     " -NoNewline
	Write-Host " H'elp All " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "    $($lang.Rule_Show_Full), $($lang.Help)"

	Write-host "     " -NoNewline
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "      $($lang.ShowCommand)"
}

Function Solutions_Help_Command
{
	param
	(
		$Name,
		[Switch]$Pause,
		[Switch]$Silent,
		[Switch]$IsVerify,
		[Switch]$NoShowFile
	)

	if (-not $Silent) {
		Write-Host "`n   $($lang.Help) *" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"
	}

	switch ($Name) {
		"lang" {
			Write-Host "   $($lang.Command): " -NoNewline
			Write-host "lang *" -ForegroundColor Green

			Write-Host
			Write-Host "     lang".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.SwitchLanguage
		
			Write-Host "     lang list".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.AvailableLanguages
		
			Write-Host "     lang auto".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.SwitchLanguage), $($lang.LanguageReset)"
		
			Write-Host "     lang *".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.SwitchLanguage), $($lang.LanguageCode) " -NoNewline
			Write-Host "{ lang zh-CN }" -ForegroundColor Green

			if ($Pause) {
				Get_Next
			}
		}
		"update" {
			Write-Host "   $($lang.Command): " -NoNewline
			Write-host "update *" -ForegroundColor Green

			Write-Host
			Write-Host "     Update".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.ChkUpdate

			Write-Host "     Update auto".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.ChkUpdate), $($lang.UpdateSilent)"

			if ($Pause) {
				Get_Next
			}
		}
		"FX" {
			Write-Host "   $($lang.Command): " -NoNewline
			Write-host "FX *" -ForegroundColor Green

			Functions_Tasks_List
			if ($Pause) {
				Get_Next
			}
		}
		"Open" {
			Write-Host "   $($lang.Command): " -NoNewline
			Write-host "Open *" -ForegroundColor Green

			Solutions_Open_Command -Help

			if ($Pause) {
				Get_Next
			}
		}
		"Sel" {
			Write-host "   " -NoNewline
			Write-Host " H Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host "  $($lang.Setting): $($lang.Event_Primary_Key)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				Write-host "   " -NoNewline
				Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-host " " -NoNewline
				Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
				Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Uid -ForegroundColor Green

				if (-not $NoShowFile) {
					$TestWIMFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
					Write-Host "   $($lang.Select_Path): " -NoNewline
					Write-Host $TestWIMFile -ForegroundColor Green
					Write-Host
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						Write-host "   " -NoNewline
						Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
						Write-host " " -NoNewline
						Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
						Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Uid -ForegroundColor Green

						if (-not $NoShowFile) {
							$TestWIMFileExpand = Join-Path -Path $Expand.Path -ChildPath "$($Expand.ImageFileName).$($Expand.Suffix)"
							Write-Host "   $($lang.Select_Path): " -NoNewline
							Write-Host $TestWIMFileExpand -ForegroundColor Green
							Write-Host
						}
					}
				}
			}

			if ($Pause) {
				Get_Next
			}
		}
		"View" {
			Write-host "   " -NoNewline
			Write-Host " H View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host "  $($lang.ViewWIMFileInfo)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				$TestWIMFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
				if ($IsVerify) {
					if (Test-Path -Path $TestWIMFile -PathType leaf) {
						Write-host "   " -NoNewline
						Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
						Write-host " " -NoNewline
						Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
						Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $item.Main.Uid -ForegroundColor Green

						Write-Host "   $($lang.Select_Path): " -NoNewline
						Write-Host $TestWIMFile -ForegroundColor Green
						Write-Host
					}
				} else {
					Write-host "   " -NoNewline
					Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-host " " -NoNewline
					Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
					Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Uid -ForegroundColor Green

					Write-Host "   $($lang.Select_Path): " -NoNewline
					if (Test-Path -Path $TestWIMFile -PathType leaf) {
						Write-Host $TestWIMFile -ForegroundColor Green
					} else {
						Write-Host $TestWIMFile -ForegroundColor Red
					}
					Write-Host
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						$TestWIMFileExpand = Join-Path -Path $Expand.Path -ChildPath "$($Expand.ImageFileName).$($Expand.Suffix)"
						if ($IsVerify) {
							if (Test-Path -Path $TestWIMFileExpand -PathType leaf) {
								Write-host "   " -NoNewline
								Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
								Write-host " " -NoNewline
								Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
								Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $Expand.Uid -ForegroundColor Green

								Write-Host "   $($lang.Select_Path): " -NoNewline
								Write-Host $TestWIMFileExpand -ForegroundColor Green
								Write-Host
							}
						} else {
							Write-host "   " -NoNewline
							Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
							Write-host " " -NoNewline
							Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
							Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
							Write-Host $Expand.Uid -ForegroundColor Green

							Write-Host "   $($lang.Select_Path): " -NoNewline
							if (Test-Path -Path $TestWIMFileExpand -PathType leaf) {
								Write-Host $TestWIMFileExpand -ForegroundColor Green
							} else {
								Write-Host $TestWIMFileExpand -ForegroundColor Red
							}
							Write-Host
						}
					}
				}
			}

			if ($Pause) {
				Get_Next
			}
		}
		"ALL" {
			Solutions_Help -Full
			Get_Next
		}
		default {
			Write-Host "   $($lang.NoWork)" -ForegroundColor Red
		}
	}
}