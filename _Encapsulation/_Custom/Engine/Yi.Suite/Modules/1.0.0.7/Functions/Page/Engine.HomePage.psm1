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
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($Title)"

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " $((Get-Module -Name Engine).Author)'s Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v$((Get-Module -Name Engine).Version.ToString()) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

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
	Write-Host " $((Get-Module -Name Engine).PrivateData.PSData.ProjectUri) " -BackgroundColor DarkBlue -ForegroundColor White

	Write-Host
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToMainpage
{
	param
	(
		[int]$Wait
	)

	Write-Host
	Write-Host "  $($lang.ToMsg -f $wait)" -ForegroundColor Red
	start-process "timeout.exe" -argumentlist "/t $($wait) /nobreak" -wait -nonewwindow
}

Function Instl_Custom_Software_Config
{
	$DynamicInstl = "$($PSScriptRoot)\..\..\Instl\Instl.ps1"
	if (Test-Path $DynamicInstl -PathType Leaf) {
		$NewConfig = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..") -ChildPath "langpacks\$($Global:IsLang)\App.json"

		if (Test-Path $NewConfig -PathType Leaf) {
			Start-Process powershell -ArgumentList "-File $($DynamicInstl) -Config ""$($NewConfig)"" -Lang ""$($Global:IsLang)""" -NoNewWindow -Wait
		} else {
			Write-Host "     $($lang.UpdateUnavailable)" -ForegroundColor Yellow
			Write-Host "     $($NewConfig)" -ForegroundColor Red
		}
	} else {
		Write-Host "`n   $($lang.InstlNo)$DynamicInstl" -ForegroundColor Red
	}
}

Function Instl_Custom_Software
{
	$DynamicInstl = "$($PSScriptRoot)\..\..\Instl\Instl.ps1"

	if (Test-Path $DynamicInstl -PathType Leaf) {
		Start-Process powershell -ArgumentList "-File $($DynamicInstl) -Lang ""$($Global:IsLang)""" -NoNewWindow -Wait
	} else {
		Write-Host "`n   $($lang.InstlNo)$DynamicInstl" -ForegroundColor Red
	}
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $lang.Mainname -ShowUpdate
	Write-Host "   $($lang.Mainname)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	Write-Host "      " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.ChkUpdate)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.FirstDeployment)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 3 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Del) $($lang.Mainname)" -ForegroundColor Green

	Write-Host

	Write-Host "      " -NoNewline
	Write-Host " 4 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RestorePoint)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 5 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.LocationUserFolder)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 6 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.DeskIcon)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 7 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Optimize) $($lang.System)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 8 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Optimize) $($lang.Service)" -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " 9 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Del) $($lang.UninstallUWP)" -ForegroundColor Green

	Write-Host "     " -NoNewline
	Write-Host " 10 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Instl) $($lang.Necessary)" -ForegroundColor Green

	Write-Host "     " -NoNewline
	Write-Host " 11 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.Instl) $($lang.MostUsedSoftware)" -ForegroundColor Green

	Write-Host

	Write-Host "      " -NoNewline
	Write-Host " C " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

	Write-Host
	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " lang " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.SwitchLanguage) " -ForegroundColor Green

	Write-Host "      " -NoNewline
	Write-Host " R " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RefreshModules) " -ForegroundColor Green

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " " -NoNewline

	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline

	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host ": " -NoNewline

	switch -Wildcard (Read-Host)
	{
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

			ToMainpage -wait 2
			Mainpage
		}
		"Upd" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"Upd *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewType = $PSItem.Remove(0, 4).Replace(' ', '')
			switch ($NewType) {
				"auto" {
					Update -Auto
				}
				default {
					Update
				}
			}

			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"1" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"2" {
			FirstExperience
			ToMainpage -wait 2
			Mainpage
		}
		"3" {
			Uninstall
			ToMainpage -wait 2
			Mainpage
		}
		"4" {
			Restore_Point_Create_UI
			ToMainpage -wait 2
			Mainpage
		}
		"c" {
			$Global:EventQueueMode = $True
			Image_Assign_Event_Master
			Event_Assign_Not_Allowed_UI
			$Global:EventQueueMode = $False

			ToMainpage -wait 2
			Mainpage
		}
		"5" {
			Change_Location
			ToMainpage -wait 2
			Mainpage
		}
		"6" {
			Desktop
			ToMainpage -wait 2
			Mainpage
		}
		"7" {
			Optimization_System_UI
			ToMainpage -wait 2
			Mainpage
		}
		"8" {
			Optimization_Service_UI
			ToMainpage -wait 2
			Mainpage
		}
		"9" {
			UWP_Uninstall
			ToMainpage -wait 2
			Mainpage
		}
		"10" {
			Instl_Custom_Software_Config
			ToMainpage -wait 2
			Mainpage
		}
		"11" {
			Instl_Custom_Software
			ToMainpage -wait 2
			Mainpage
		}
		"lang" {
			Language -Reset
			ToMainpage -wait 2
			Mainpage
		}
		"lang *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewLanguage = $PSItem.Remove(0, 5).Replace(' ', '')
			$Langpacks_Sources = "$($PSScriptRoot)\..\..\langpacks"
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
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Suite" -Name "Language" -ErrorAction SilentlyContinue
					Write-Host "   $($lang.Done)" -ForegroundColor Green
					Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
				}
				default {
					Write-Host "`n   $($lang.SwitchLanguage): " -NoNewline
					Write-Host $NewLanguage -ForegroundColor Green
					Write-Host "   $('-' * 80)"

					if (Test-Path "$($Langpacks_Sources)\$($NewLanguage)\Lang.psd1" -PathType Leaf) {
						Write-Host "   $($lang.Done)" -ForegroundColor Green
						Save_Dynamic -regkey "Suite" -name "Language" -value $NewLanguage -String
						Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
					} else {
						Write-Host "   $($lang.UpdateUnavailable)" -ForegroundColor Red
					}
				}
			}

			ToMainpage -wait 2
			Mainpage
		}
		"r" {
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}

		<#
			.Help
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Engine_Help
			Get_Next
			ToMainpage -wait 2
			Mainpage
		}
		"q" {
			return
		}
		default { Mainpage }

		<#
			.快速测试区域
		#>
		"t" {
			Write-Host "`n   $($lang.Developers_Mode)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"

			# Start






			# End

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Developers_Mode), $($lang.Done)" -ForegroundColor Green

			<#
				.添加 ToMainpage 防止直接退出
			#>
			ToMainpage -wait 2
			Mainpage
		}
	}
}