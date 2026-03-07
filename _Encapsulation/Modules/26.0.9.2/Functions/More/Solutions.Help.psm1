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

	Write-Host "  $($lang.SelectSettingImage)"
	Write-Host "  $('-' * 80)"
	if ($Full) {
		Solutions_Help_Command -Name "View" -Silent
	} else {
		Write-host "     " -NoNewline
		Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline
		Write-Host "        $($lang.ViewWIMFileInfo), $($lang.Command), $($lang.Help)"
	}

	if ($Full) {
		Solutions_Help_Command -Name "Save" -Silent
	} else {
		Write-host "     " -NoNewline
		Write-Host " Se " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline
		Write-Host "          $($lang.Event_Primary_Key), $($lang.Command), $($lang.Help) "
	}

	if ($Full) {
		Solutions_Help_Command -Name "Sel" -Silent
	} else {
		Write-host "     " -NoNewline
		Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
		Write-host " " -NoNewline
		Write-Host "         $($lang.Event_Primary_Key), $($lang.Command), $($lang.Help) "
	}

	Write-Host "     ISA".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.AddTo -NoNewline
	Write-Host " { WI WR EI ER }" -ForegroundColor Green

	Write-Host "     ISD".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Del -NoNewline
	Write-Host " { WI WR EI ER } { $($lang.MountedIndex) }" -ForegroundColor Green

	Write-Host "     rMT".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mount), $($lang.PleaseChoose)"

	Write-Host "     CPK".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Event_Primary_Key_CPK

	Write-Host "     Reset".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.EventManagerClear

	Write-Host "`n  $($lang.Mounted_Status)"
	Write-Host "  $('-' * 80)"
	Write-Host "     Mt".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Mount -NoNewline
	Write-Host " { WI WR EI ER } { $($lang.MountedIndex) }" -ForegroundColor Green

	Write-Host "     ESE".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Image_Unmount_After): " -NoNewline
	Write-Host $lang.Save -ForegroundColor Green

	Write-Host "     EDNS".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Image_Unmount_After): " -NoNewline
	Write-Host $lang.DoNotSave -ForegroundColor Green

	Write-Host "`n  $($lang.RuleOther)"
	Write-Host "  $('-' * 80)"
	if ($Full) {
		Solutions_Help_Command -Name "FX" -Silent
	} else {
		Write-Host "     FX *".PadRight(20) -NoNewline -ForegroundColor Yellow
		Write-Host "$($lang.SpecialFunction): $($lang.Function_Unrestricted), $($lang.Short_Cmd)" -NoNewline
		Write-Host " { FX Pause } { FX List }" -ForegroundColor Green
	}

	Write-Host "     VA".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Wim_Rule_Verify): $($lang.Autopilot_Select_Config)"

	Write-Host "     VU".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Wim_Rule_Verify): $($lang.EnabledUnattend)"

	Write-Host "     Fix".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Repair): $($lang.HistoryClearDismSave)" -ForegroundColor Green
	Write-Host "                    $($lang.Repair): $($lang.Clear_Bad_Mount)" -ForegroundColor Green

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
	Write-Host "  $($lang.API) "
	Write-Host "  $('-' * 80)"
	Write-host "     " -NoNewline
	Write-Host " Set API " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "      $($lang.Setting), $($lang.API)"
	Write-host "     " -NoNewline
	Write-Host " API Set " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "      $($lang.Setting), $($lang.API)"

	Write-host "     " -NoNewline
	Write-Host " Api List " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "     $($lang.ShowCommand)"

	Write-Host
	Write-Host "  $($lang.Help) "
	Write-Host "  $('-' * 80)"
	Write-host "     " -NoNewline
	Write-Host " Help All " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "     $($lang.Rule_Show_Full), $($lang.Help)"

	Write-host "     " -NoNewline
	Write-Host " Help * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "       $($lang.ShowCommand)"

	write-host
	Write-Host "   R'R".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.RefreshModules): " -NoNewline
	Write-host $lang.Prerequisites -ForegroundColor Yellow
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
		Write-Host "`n  $($lang.Help) *" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
	}

	switch ($Name) {
		"LP" {
			Write-Host "  $($lang.Command): " -NoNewline
			Write-host "lp *" -ForegroundColor Green

			Write-Host "`n  $($lang.AssignNeedMount)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "     lp E".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.LanguageExtract

			Write-Host "     lp A".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.AddTo

			Write-Host "     lp D".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.Del

			Write-Host "     lp S".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.SwitchLanguage

			Get_Next -DevCode "Hp 1"
		}
		"lang" {
			Write-Host "  $($lang.Command): " -NoNewline
			Write-host "Lang *" -ForegroundColor Green

			Write-Host "`n  $($lang.User_Interaction)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "     Lang".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.SwitchLanguage

			Write-Host "     Lang list".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.AvailableLanguages

			Write-Host "     Lang auto".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.SwitchLanguage), $($lang.LanguageReset)"

			Write-Host "     Lang *".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.SwitchLanguage), $($lang.LanguageCode) " -NoNewline
			Write-Host "{ Lang zh-CN }" -ForegroundColor Green

			Get_Next -DevCode "Hp 2"
		}
		"Upd" {
			Write-Host "  $($lang.Command): " -NoNewline
			Write-host "Upd *" -ForegroundColor Green

			Write-Host
			Write-Host "     Upd".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host $lang.ChkUpdate

			Write-Host "     Upd auto".PadRight(20) -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.ChkUpdate), $($lang.UpdateSilent)"

			Get_Next -DevCode "Hp 3"
		}
		"FX" {
			Write-Host "  $($lang.Command): " -NoNewline
			Write-host "FX *" -ForegroundColor Green

			Functions_Tasks_List

			if (-not $Silent) {
				Get_Next -DevCode "Hp 4"
			}
		}
		{ "O", "Od", "O'D" -eq $_ } {
			Solutions_Open_Command -Help
			Get_Next -DevCode "Hp 5"
		}
		"Save" {
			Write-Host $(' ' * 2) -NoNewline
			Write-Host " Help Save " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.Save)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					$NewFileFullPathMain = "$($item.Main.Path)\$($item.Main.ImageFileName).$($item.Main.Suffix)"
					if (Test-Path -Path $NewFileFullPathMain -PathType leaf) {
						Write-Host $(' ' * 7) -NoNewline
						Write-Host " Save " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
						Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
						Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $item.Main.Uid -ForegroundColor Green

						Write-Host "        $($lang.Select_Path): " -NoNewline
						$InitNewImageSources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"
						Write-Host $InitNewImageSources -ForegroundColor Green
						Write-Host
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Global:SMExt -contains $Expand.Suffix) {
							$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

							if (Test-Path -Path $test_mount_folder_Current -PathType leaf) {
								Write-Host $(' ' * 7) -NoNewline
								Write-Host " Se " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
								Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
								Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $Expand.Uid -ForegroundColor Green

								Write-Host "        $($lang.Select_Path): " -NoNewline
								$InitNewImageMountToRouteRecovery = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($Expand.ImageFileName).$($Expand.Suffix)\Mount"
								Write-Host $InitNewImageMountToRouteRecovery -ForegroundColor Green
								Write-Host
							}
						}
					}
				}
			}

			if (-not $Silent) {
				Get_Next -DevCode "Hp 6"
			}
		}
		"Unmt" {
			Write-Host $(' ' * 2) -NoNewline
			Write-Host " Help Unmt " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.Setting): $($lang.Event_Primary_Key)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					Write-Host $(' ' * 2) -NoNewline
					Write-Host " Unmt " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
					Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Uid -ForegroundColor Green

					$InitNewImageSources = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount"

					Write-Host "    $($lang.Select_Path): " -NoNewline
					Write-Host $InitNewImageSources -ForegroundColor Green
					Write-Host
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Global:SMExt -contains $Expand.Suffix) {
							Write-Host $(' ' * 2) -NoNewline
							Write-Host " Unmt " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
							Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
							Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
							Write-Host $Expand.Uid -ForegroundColor Green

							$InitNewImageMountToRouteRecovery = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($Expand.ImageFileName).$($Expand.Suffix)\Mount"
							Write-Host "    $($lang.Select_Path): " -NoNewline
							Write-Host $InitNewImageMountToRouteRecovery -ForegroundColor Green
							Write-Host
						}
					}
				}
			}

			Get_Next -DevCode "Hp 7"
		}
		"Set" {
			Write-Host "`n  $($lang.API)"
			Write-Host "  $('-' * 80)"
			Write-Host $(' ' * 2) -NoNewline
			Write-host " Set API " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host "     $($lang.Setting), $($lang.API)"

			write-host
			Write-Host $(' ' * 2) -NoNewline
			Write-host " Set ISO " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-host "     $($lang.Setting), $($lang.Iso_File)"

			Get_Next -DevCode "Hp 8"
		}
		"Sel" {
			Write-Host $(' ' * 2) -NoNewline
			Write-Host " Help Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.PleaseChoose): $($lang.Event_Primary_Key)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				if ($Global:SMExt -contains $item.Main.Suffix) {
					Write-Host $(' ' * 7) -NoNewline
					Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
					Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Uid -ForegroundColor Green

					if (-not $NoShowFile) {
						$TestWIMFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
						Write-Host "       $($lang.Select_Path): " -NoNewline
						Write-Host $TestWIMFile -ForegroundColor Green
						Write-Host
					}
				}

				if ($item.Expand.Count -gt 0) {
					ForEach ($Expand in $item.Expand) {
						if ($Global:SMExt -contains $Expand.Suffix) {
							Write-Host $(' ' * 7) -NoNewline
							Write-Host " Sel " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
							Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
							Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
							Write-Host $Expand.Uid -ForegroundColor Green

							if (-not $NoShowFile) {
								$TestWIMFileExpand = Join-Path -Path $Expand.Path -ChildPath "$($Expand.ImageFileName).$($Expand.Suffix)"
								Write-Host "       $($lang.Select_Path): " -NoNewline
								Write-Host $TestWIMFileExpand -ForegroundColor Green
								Write-Host
							}
						}
					}
				}
			}

			if ($Pause) {
				Get_Next -DevCode "Hp 9"
			}
		}
		"View" {
			Write-Host $(' ' * 2) -NoNewline
			Write-Host " Help View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " $($lang.ViewWIMFileInfo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			ForEach ($item in $Global:Image_Rule) {
				$TestWIMFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
				if ($IsVerify) {
					if (Test-Path -Path $TestWIMFile -PathType leaf) {
						Write-Host $(' ' * 7) -NoNewline
						Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
						Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
						Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $item.Main.Uid -ForegroundColor Green

						Write-Host "        $($lang.Select_Path): " -NoNewline
						Write-Host $TestWIMFile -ForegroundColor Green
						Write-Host
					}
				} else {
					Write-Host $(' ' * 7) -NoNewline
					Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
					Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
					Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $item.Main.Uid -ForegroundColor Green

					Write-Host "        $($lang.Select_Path): " -NoNewline
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
								Write-Host $(' ' * 7) -NoNewline
								Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
								Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
								Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
								Write-Host $Expand.Uid -ForegroundColor Green

								Write-Host "        $($lang.Select_Path): " -NoNewline
								Write-Host $TestWIMFileExpand -ForegroundColor Green
								Write-Host
							}
						} else {
							Write-Host $(' ' * 7) -NoNewline
							Write-Host " View " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
							Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor Green -ForegroundColor Black
							Write-Host " $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
							Write-Host $Expand.Uid -ForegroundColor Green

							Write-Host "        $($lang.Select_Path): " -NoNewline
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
				Get_Next -DevCode "Hp 10"
			}
		}
		"ALL" {
			Solutions_Help -Full
			Get_Next -DevCode "Hp 11"
		}
		"API" {
			Solutions_API_Help
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}