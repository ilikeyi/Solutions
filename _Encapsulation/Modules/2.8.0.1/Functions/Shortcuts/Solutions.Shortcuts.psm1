Function Shortcuts_Show_Available
{
	Write-Host "`n  $($lang.Event_Primary_Key)"
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		Write-Host "  $($lang.Unique_Name): " -NoNewline -ForegroundColor Yellow
		Write-Host $item.Main.Uid -ForegroundColor Green
		Write-Host "  $('.' * 80)"

		Write-Host "  $($lang.Short_Cmd): " -NoNewline -ForegroundColor Yellow
		Write-Host " $($item.Main.Shortcuts) " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

		$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
		if (Test-Path -Path $TestWimFile -PathType Leaf) {
			Write-Host " $($lang.UpdateAvailable) " -BackgroundColor Green -ForegroundColor Black
		} else {
			Write-Host " $($lang.UpdateUnavailable)" -BackgroundColor DarkRed -ForegroundColor White
		}

		Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
		Write-Host $TestWimFile -ForegroundColor Green
		Write-Host

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				Write-Host "  $($lang.Short_Cmd): " -NoNewline -ForegroundColor Yellow
				Write-Host " $($Expand.Shortcuts) " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

				$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"
				if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
					Write-Host " $($lang.UpdateAvailable) " -BackgroundColor Green -ForegroundColor Black
				} else {
					Write-Host " $($lang.UpdateUnavailable)" -BackgroundColor DarkRed -ForegroundColor White
				}

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host $test_mount_folder_Current -ForegroundColor Green

				Write-Host
			}
		}
	}
}

<#
	.封装菜单主界面，选择前往菜单：挂载
#>
Function Shortcuts_Go_Select_Index
{
	Write-Host "`n  $($lang.Mount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
			Image_Select_Index_UI
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
	}
}

<#
	.快捷指令调用组
#>
Function Shortcuts_Select
{
	param
	(
		$Name
	)

	$Name = $Name.ToLower().Replace('sel ', '').Replace('sel', '')

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Sel" -ForegroundColor Green

	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "`n  $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $Name) {
				Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Group -ForegroundColor Green

				Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Uid -ForegroundColor Green

				$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host $TestWimFile -ForegroundColor Green

				if (Test-Path -Path $TestWimFile -PathType Leaf) {
					Image_Set_Global_Primary_Key -Uid $item.Main.Uid -Detailed -DevCode "0406"
				} else {
					Write-Host "`n  $($lang.NoInstallImage)"
					Write-Host "  $($TestWimFile)" -ForegroundColor Red
				}

				return
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Shortcuts -eq $Name) {
						Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Group -ForegroundColor Green

						Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Uid -ForegroundColor Green
						$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

						Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $test_mount_folder_Current -ForegroundColor Green

						if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
							Image_Set_Global_Primary_Key -Uid $Expand.Uid -Detailed -DevCode "1208"
						} else {
							Write-Host "`n  $($lang.NoInstallImage)"
							Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Red
						}

						return
					}
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

Function Shortcuts_View
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "View" -ForegroundColor Green

	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "`n  $($lang.ViewWIMFileInfo) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($item.Main.Shortcuts -eq $Name) {
			Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Group -ForegroundColor Green

			Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
			Write-Host $item.Main.Uid -ForegroundColor Green

			$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"

			Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
			Write-Host $TestWimFile -ForegroundColor Green

			if (Test-Path -Path $TestWimFile -PathType Leaf) {
				Image_Get_Detailed -Filename $TestWimFile -View
			} else {
				Write-Host "`n  $($lang.NoInstallImage)"
				Write-Host "  $($TestWimFile)" -ForegroundColor Red
			}

			return
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Expand.Shortcuts -eq $Name) {
					Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Group -ForegroundColor Green

					Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
					Write-Host $Expand.Uid -ForegroundColor Green
					$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

					Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
					Write-Host $test_mount_folder_Current -ForegroundColor Green

					if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
						Image_Get_Detailed -Filename $test_mount_folder_Current -View
					} else {
						Write-Host "`n  $($lang.NoInstallImage)"
						Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Red
					}

					return
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

<#
	.快捷指令，追加
#>
Function Shortcuts_Append
{
	Write-Host "`n  $($lang.Wim_Append)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429"
			Image_Select_Append_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0429e"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.Wim_Append)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Append_UI"
	}
}

<#
	.快捷指令，追加 + 主键
#>
Function Shortcuts_Append_IAB
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	$NewRuleName = $Name.Remove(0, 4).split(" ").ToLower()
	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	Write-host $NewRuleName

	$NewUid = ""
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $NewRuleName) {
				$NewUid = $item.Main.Uid
				break
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						if ($Expand.Shortcuts -eq $NewRuleName) {
							$NewUid = $Expand.Uid
							break
						}
					}
				}
			}
		}
	}

	if ([string]::IsNullOrEmpty($NewUid)) {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.Wim_Append)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Append_UI"
	} else {
		Image_Set_Global_Primary_Key -Uid $NewUid -Detailed -DevCode "0601" -Silent

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
				Image_Select_Append_UI
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Wim_Append)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Image_Select_Append_UI"
		}
	}
}

<#
	.快捷指令：删除
#>
Function Shortcuts_Remove
{
	Write-Host "`n  $($lang.Del)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
			Image_Select_Del_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.Del)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Del_UI"
	}
}

<#
	.快捷指令：删除 + 索引号
#>
Function Shortcuts_Remove_Index
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 4).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Shortcuts_Select -Name $NewImageIndex
	}

	<#
		.判断主键范围
	#>
	Write-Host "`n  $($lang.MountedIndexSelect): " -NoNewline
	Write-Host $NewRuleName -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	$IsNumber = [int]::TryParse($NewRuleName, [ref]$null)
	if ($IsNumber) {
		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818"
				Image_Select_Del_UI -AutoSelectIndex $NewRuleName
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "0818e"
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Del)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Image_Select_Del_UI"
		}
	} else {
		Write-Host "  $($lang.VerifyNumberFailed)" -ForegroundColor Red

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Del)" -ForegroundColor Green

			Image_Select_Del_UI
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Del)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Image_Select_Del_UI"
		}
	}
}

<#
	.快捷指令：挂载
#>
Function Shortcuts_Mount
{
	Write-Host "`n  $($lang.Mount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
			Image_Select_Index_UI
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
	}
}

<#
	.快捷指令：重新挂载
#>
Function Shortcuts_ReMount
{
	Write-Host "`n  $($lang.Mount)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Sources_ReMount -Uid $Global:Primary_Key_Image.Uid -VerifyFile $Global:Primary_Key_Image.Fullpath -DevCode "1206"
		} else {
			Write-Host " $($lang.NotMounted) " -BackgroundColor White -ForegroundColor Black
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
			Image_Select_Index_UI
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
	}
}

<#
	.快捷指令，挂载 + 主键 + 索引号
#>
Function Shortcuts_Mount_Key_and_Index
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Command -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Command.Remove(0, 3).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Shortcuts_Select -Name $NewImageIndex
	}

	<#
		.判断主键范围
	#>
	Write-Host "`n  $($lang.MountedIndexSelect): " -NoNewline
	Write-Host $NewRuleName -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	$IsNumber = [int]::TryParse($NewRuleName, [ref]$null)
	if ($IsNumber) {
		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "1026"
				Image_Select_Index_UI -AutoSelectIndex $NewRuleName
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
		}
	} else {
		Write-Host "  $($lang.VerifyNumberFailed)" -ForegroundColor Red

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Image_Select_Index_UI
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
		}
	}
}

<#
	.快捷指令，重新挂载 + 主键
#>
Function Shortcuts_ReMount_Key
{
	param
	(
		$Name
	)

	$Name = $Name.ToLower().Replace('rmt ', '').Replace('rmt', '')

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "rmt" -ForegroundColor Green

	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "`n  $($lang.Event_Primary_Key) *" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $Name) {
				Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Group -ForegroundColor Green

				Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
				Write-Host $item.Main.Uid -ForegroundColor Green

				$TestWimFile = Join-Path -Path $item.Main.Path -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)"
				$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

				Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
				Write-Host $TestWimFile -ForegroundColor Green

				Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				write-host "  " -NoNewline
				if (Test-Path -Path $TestWimFile -PathType Leaf) {
					Image_Set_Global_Primary_Key -Uid $item.Main.Uid -Detailed -DevCode "1026"
					if (Verify_Is_Current_Same) {
						Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

						Image_Sources_ReMount -Uid $item.Main.Uid -VerifyFile $TestWimFile -DevCode "1206"
					} else {
						Write-Host " $($lang.NotMounted) " -BackgroundColor White -ForegroundColor Black
						Image_Select_Index_UI
					}
				} else {
					Write-Host "`n  $($lang.NoInstallImage)"
					Write-Host "  $($TestWimFile)" -ForegroundColor Red
				}

				return
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Expand.Shortcuts -eq $Name) {
						Write-Host "  $($lang.Event_Group): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Group -ForegroundColor Green

						Write-Host "  $($lang.Event_Primary_Key): " -NoNewline -ForegroundColor Yellow
						Write-Host $Expand.Uid -ForegroundColor Green

						$test_mount_folder_Current = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($item.Main.ImageFileName).$($item.Main.Suffix)\$($item.Main.ImageFileName).$($item.Main.Suffix)\Mount\$($Expand.Path)\$($Expand.ImageFileName).$($Expand.Suffix)"

						Write-Host "  $($lang.Select_Path): " -NoNewline -ForegroundColor Yellow
						Write-Host $test_mount_folder_Current -ForegroundColor Green

						Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						write-host "  " -NoNewline
						if (Test-Path -Path $test_mount_folder_Current -PathType Leaf) {
							Image_Set_Global_Primary_Key -Uid $item.Main.Uid -Detailed -DevCode "1026"
							if (Verify_Is_Current_Same) {
								Write-Host " $($lang.Mounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
								Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White
		
								Image_Sources_ReMount -Uid $Expand.Uid -VerifyFile $test_mount_folder_Current -DevCode "1206"
							} else {
								Write-Host " $($lang.NotMounted) " -BackgroundColor White -ForegroundColor Black
								Image_Select_Index_UI
							}
						} else {
							Write-Host "`n  $($lang.NoInstallImage)"
							Write-Host "  $($test_mount_folder_Current)" -ForegroundColor Red
						}

						return
					}
				}
			}
		}
	}

	Write-Host "  $($lang.NoWork)" -ForegroundColor Red
}

Function Image_Sources_ReMount
{
	param
	(
		$Uid,
		$VerifyFile,
		$devCode
	)

	if ($Global:Developers_Mode) {
		Write-Host "  $($lang.Developers_Mode_Location): $($DevCode)" -ForegroundColor Green
	}

	Write-Host "`n  $($lang.Detailed)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	$IsMountImageGet = $null
	Get-WindowsImage -Mounted | ForEach-Object {
		if ($_.ImagePath -eq $VerifyFile) {
			$IsMountImageGet = [pscustomobject]@{
				Uid        = $Uid
				Path       = $_.Path
				ImagePath  = $_.ImagePath
				ImageIndex = $_.ImageIndex
			}

			Write-Host "  $($lang.SelFile): " -NoNewline
			Write-Host $_.ImagePath -ForegroundColor Green

			Write-Host "  $($lang.Select_Path): " -NoNewline
			Write-Host $_.Path -ForegroundColor Green

			Write-Host "  $($lang.MountedIndex): " -NoNewline
			Write-Host $_.ImageIndex -ForegroundColor Green

			return
		}
	}

	Write-Host "`n  $($lang.DoNotSave)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($null -ne $IsMountImageGet) {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
				"True" {
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
						switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "Abandon_Allow_Auto" -ErrorAction SilentlyContinue) {
							"True" {
								New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($IsMountImageGet.Uid)" -Value $True -Force
							}
						}
					}
				}
			}
		}

		Image_Eject_Abandon -Uid $IsMountImageGet.Uid -VerifyPath $IsMountImageGet.Path
		Image_Select_Index_UI -AutoSelectIndex $IsMountImageGet.ImageIndex
	} else {
		Write-Host "  $($lang.SelectSettingImage): $($lang.Failed)" -ForegroundColor Green
	}
}

<#
	.快捷指令，映像内文件：提取、更新
#>
Function Shortcuts_Euwl
{
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "euwl" -ForegroundColor Green

	Write-Host "`n  $($lang.Wim_Rule_Update)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "9846"
		Wimlib_Extract_And_Update
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Wim_Rule_Update)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Wimlib_Extract_And_Update"
	}
}

<#
	.快捷指令，映像内文件：提取、更新
#>
Function Shortcuts_Euwl_Primary_Key
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	$NewRuleName = $Name.Remove(0, 5).split(" ").ToLower()
	$NewImageIndex = ""
	$Scope = @()
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			$Scope += $item.Main.Shortcuts

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						$Scope += $Expand.Shortcuts
					}
				}
			}
		}
	}

	ForEach ($Item in $Scope) {
		if ($NewRuleName -like $Item.ToLower()) {
			$NewRuleName = $NewRuleName.replace($item.ToLower(), '') | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			$NewImageIndex = $Item
			$Global:Primary_Key_Image = @()
			break
		}
	}

	if ([string]::IsNullOrEmpty($NewImageIndex)) {
		Write-host $lang.NoChoose -ForegroundColor Red
		$Global:Primary_Key_Image = @()
	} else {
		Write-Host $NewImageIndex -ForegroundColor Green
		Shortcuts_Select -Name $NewImageIndex
	}

	Write-Host "`n  $($lang.LanguageExtract)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Wimlib_Extract_And_Update
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Wim_Rule_Update)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Wimlib_Extract_And_Update"
	}
}

<#
	.快捷指令，导出
#>
Function Shortcuts_Export
{
	Write-Host "`n  $($lang.Export_Image)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1"
			Image_Select_Export_UI
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1end"
			Get_Next -DevCode "S 1"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.Export_Image)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Export_UI"
	}
}

<#
	.快捷指令，导出 + 主键
#>
Function Shortcuts_Export_Key
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	$NewRuleName = $Name.Remove(0, 4).split(" ").ToLower()
	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	Write-host $NewRuleName

	$NewUid = ""
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $NewRuleName) {
				$NewUid = $item.Main.Uid
				break
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						if ($Expand.Shortcuts -eq $NewRuleName) {
							$NewUid = $Expand.Uid
							break
						}
					}
				}
			}
		}
	}

	if ([string]::IsNullOrEmpty($NewUid)) {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.Export_Image)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Export_UI"
	} else {
		Image_Set_Global_Primary_Key -Uid $NewUid -Detailed -DevCode "0601" -Silent

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1"
				Image_Select_Export_UI
				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1end"
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.Export_Image)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Image_Select_Export_UI"
		}
	}
}

<#
	.快捷指令，重建映像文件
#>
Function Shortcuts_Rebuild
{
	Write-Host "`n  $($lang.Rebuild)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.OnDemandPlanTask)" -ForegroundColor Green

		ToWait -wait 2
		Image_Assign_Event_Master
	}
}

<#
	.快捷指令，重建映像文件 + 主键
#>
Function Shortcuts_Rebuild_Key
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	$NewRuleName = $Name.Remove(0, 4).split(" ").ToLower()
	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	Write-host $NewRuleName

	$NewUid = ""
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $NewRuleName) {
				$NewUid = $item.Main.Uid
				break
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						if ($Expand.Shortcuts -eq $NewRuleName) {
							$NewUid = $Expand.Uid
							break
						}
					}
				}
			}
		}
	}

	if ([string]::IsNullOrEmpty($NewUid)) {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Rebuild)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Rebuild_Image_File"
	} else {
		Image_Set_Global_Primary_Key -Uid $NewUid -Detailed -DevCode "0601" -Silent

		Write-Host "`n  $($lang.Rebuild)"
		Write-Host "  $('-' * 80)"
		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Rebuild_Image_File -Filename $Global:Primary_Key_Image.FullPath
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Rebuild)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Rebuild_Image_File"
		}
	}
}

<#
	.快捷指令，应用
#>
Function Shortcuts_Apply
{
	Write-Host "`n  $($lang.Apply)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Image_Select_Index_UI
		Get_Next -DevCode "S 2"
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
	}
}

<#
	.快捷指令，应用
#>
Function Shortcuts_Apply_Key
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	$NewRuleName = $Name.Remove(0, 4).split(" ").ToLower()
	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	Write-host $NewRuleName

	$NewUid = ""
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $NewRuleName) {
				$NewUid = $item.Main.Uid
				break
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						if ($Expand.Shortcuts -eq $NewRuleName) {
							$NewUid = $Expand.Uid
							break
						}
					}
				}
			}
		}
	}

	if ([string]::IsNullOrEmpty($NewUid)) {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
	} else {
		Image_Set_Global_Primary_Key -Uid $NewUid -Detailed -DevCode "0601" -Silent

		if (Image_Is_Select_IAB) {
			Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			Image_Select_Index_UI
			Get_Next -DevCode "S 3"
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.SelectSettingImage): $($lang.MountedIndexSelect)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Image_Select_Index_UI"
		}
	}
}

<#
	.快捷指令：组：InBox Apps
#>
Function Shortcuts_InBox_Apps_IA
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "IA" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			InBox_Apps_Menu_Shortcuts_Add
		}
		"d" {
			InBox_Apps_Menu_Shortcuts_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：本地语言体验包（LXPs）
#>
Function Shortcuts_LXPs_EP
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "EP" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			InBox_Apps_Menu_Shortcuts_LXPs_Add
		}
		"d" {
			InBox_Apps_Menu_Shortcuts_LXPs_Delete
		}
		"u" {
			InBox_Apps_Menu_Shortcuts_LXPs_Update
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：累积更新
#>
Function Shortcuts_Cumulative_updates_CU
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "CU" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			Shortcuts_Cumulative_updates_Add
		}
		"d" {
			Shortcuts_Cumulative_updates_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：驱动
#>
Function Shortcuts_Drive
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "DD" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"a" {
			Drive_Menu_Shortcuts_Add
		}
		"d" {
			Drive_Menu_Shortcuts_Delete
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：组：映像版本
#>
Function Shortcuts_Image_version
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "IV" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"c" {
			Editions_GUI
		}
		"k" {
			Editions_GUI
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：组：映像版本
#>
Function Shortcuts_EI_Switch
{
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Ei" -ForegroundColor Green

	$EICfgPath = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
	Write-Host "`n  $($lang.InstlMode)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-host "  $($lang.Select_Path): " -NoNewline
	Write-host $EICfgPath -ForegroundColor Yellow

	Write-Host "`n  $($lang.Change)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Test-Path -Path $EICfgPath -PathType leaf) {
		Write-Host "  $($lang.Consumer) "
		Write-Host "  $($lang.ConsumerTips)" -ForegroundColor Yellow

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Setting) " -NoNewline -BackgroundColor White -ForegroundColor Black

		if (Test-Path -Path $EICfgPath -PathType leaf) {
			remove-item -path $EICfgPath -force -ErrorAction SilentlyContinue

			if (Test-Path -Path $EICfgPath -PathType leaf) {
				Write-Host " $($lang.Failed) " -NoNewline -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.Done) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			}
		} else {
			Write-Host " $($lang.NoInstallImage)" -NoNewline -BackgroundColor DarkRed -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.Business) "
		Write-Host "  $($lang.BusinessTips)" -ForegroundColor Yellow

		Write-Host
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Setting) " -NoNewline -BackgroundColor White -ForegroundColor Black
@"
[Channel]
volume

[VL]
1
"@ | Out-File -FilePath $EICfgPath -Encoding Ascii -ErrorAction SilentlyContinue

		if (Test-Path -Path $EICfgPath -PathType leaf) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
	}

	Write-Host
}

<#
	.快捷指令：组：Windows 功能
#>
Function Shortcuts_Windows_features
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "WF" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"e" {
			Windows_Feature_Menu_Shortcuts_Enabled
		}
		"d" {
			Windows_Feature_Menu_Shortcuts_Disabled
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：PowerShell Functions 函数功能
#>
Function Shortcuts_PowerShell_Functions
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "PF" -ForegroundColor Green

	$NewRuleName = $Command.Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"b" {
			PowerShell_Functions_Menu_Shortcuts_PFB
		}
		"a" {
			PowerShell_Functions_Menu_Shortcuts_PFA
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：PowerShell Functions 函数功能：不受限制
#>
Function Shortcuts_PowerShell_Functions_Unrestricted
{
	param
	(
		$Command
	)

	$Global:Function_Unrestricted = @()
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "FX" -ForegroundColor Green

	$NewRuleName = $Command.Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"list" {
			Functions_Tasks_List
			Get_Next -DevCode "S 4"
		}
		default {
			if ([string]::IsNullOrEmpty($NewRuleName)) {
				Functions_Unrestricted_UI
			} else {
				Functions_Unrestricted_UI -Custom $NewRuleName
			}
		}
	}

	$Global:Function_Unrestricted = @()
}

<#
	.快捷指令：检查更新
#>
Function Shortcuts_Update
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "Upd" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"auto" {
			Update -Auto
		}
		default {
			Update
		}
	}
}

<#
	.快捷指令：修复
#>
Function Shortcuts_Fix
{
	Write-Host "`n  $($lang.Repair)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-Host "  * $($lang.HistoryClearDismSave)" -ForegroundColor Green
	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  Remove-Item -Path ""HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*"" -Force -Recurse" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
	}
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

	Write-Host "  * $($lang.Clear_Bad_Mount)" -ForegroundColor Green
	if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
		Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  dism /cleanup-wim" -ForegroundColor Green
		Write-Host "  Clear-WindowsCorruptMountPoint" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
	}

	dism /cleanup-wim | Out-Null
	Clear-WindowsCorruptMountPoint -LogPath "$(Get_Mount_To_Logs)\Clear.log" -ErrorAction SilentlyContinue | Out-Null
}

<#
	.快捷指令：语言 + 映像
#>
Function Shortcuts_Image_Language
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "LP" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	switch ($NewRuleName) {
		"e" {
			Language_Extract_UI
		}
		"a" {
			Language_Menu_Shortcuts_LA
		}
		"d" {
			Language_Menu_Shortcuts_LD
		}
		"s" {
			Language_Menu_Shortcuts_LS
		}
		default {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}
	}
}

<#
	.快捷指令：语言 + 映像
#>
Function Shortcuts_Lang
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "lang" -ForegroundColor Green

	$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
	Write-Host "  $($lang.RuleName): " -NoNewline
	Write-host $NewRuleName -ForegroundColor Green

	$Langpacks_Sources = "$($PSScriptRoot)\..\..\langpacks"
	switch ($NewRuleName) {
		"list" {
			Write-Host "`n  $($lang.AvailableLanguages)"
			Write-Host "  $('-' * 80)"

			$Match_Available_Languages = @()
			Get-ChildItem -Path $Langpacks_Sources -Directory -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path "$($_.FullName)\Lang.psd1" -PathType Leaf) {
					$Match_Available_Languages += $_.Basename
				}
			}

			if ($Match_Available_Languages.count -gt 0) {
				ForEach ($item in $Global:Languages_Available) {
					if ($Match_Available_Languages -contains $item.Region) {
						Write-Host "  $($item.Region)".PadRight(20) -NoNewline -ForegroundColor Green
						Write-Host $item.Name -ForegroundColor Yellow
					}

					if ($item.Expand.Count -gt 0) {
						ForEach ($itemExpand in $item.Expand) {
							if ($Match_Available_Languages -contains $itemExpand.Region) {
								Write-Host "  $($itemExpand.Region)".PadRight(20) -NoNewline -ForegroundColor Green
								Write-Host $itemExpand.Name -ForegroundColor Yellow
							}
						}
					}
				}

				Get_Next -DevCode "S 5"
			} else {

			}
		}
		"auto" {
			Write-Host "`n  $($lang.SwitchLanguage): "
			Write-Host "  $('-' * 80)"
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "Language" -ErrorAction SilentlyContinue
			Write-Host "  $($lang.Done)" -ForegroundColor Green
			Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
		}
		default {
			Write-Host "`n  $($lang.SwitchLanguage): " -NoNewline
			Write-Host $NewRuleName -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			if (Test-Path "$($Langpacks_Sources)\$($NewRuleName)\Lang.psd1" -PathType Leaf) {
				Write-Host "  $($lang.Done)" -ForegroundColor Green
				Save_Dynamic -regkey "Solutions" -name "Language" -value $NewRuleName
				Modules_Refresh -Function "ToWait -wait 2", "Mainpage"
			} else {
				Write-Host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
			}
		}
	}
}

<#
	.快捷指令：打开目录
#>
Function Shortcuts_OpenFolder
{
	param
	(
		$Command
	)

	if ($Command -like "O'D *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "O'D" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}

	if ($Command -like "OD *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "OD" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 3).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}

	if ($Command -like "O *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "O" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Open_Command -Name $NewRuleName
	}
}


<#
	.快捷指令：设置
#>
Function Shortcuts_Setting
{
	param
	(
		$Command
	)

	if ($Command -like "s'et *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "S'et" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}

	if ($Command -like "set *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "Set" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 4).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}

	if ($Command -like "s *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "S" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Image_Select_Page_Shortcuts -Name $NewRuleName
	}
}

<#
	.快捷指令：帮助
#>
Function Shortcuts_Help
{
	param
	(
		$Command
	)

	if ($Command -like "H'elp *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "H'elp" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 6).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}

	if ($Command -like "Help *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "Help" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 5).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}

	if ($Command -like "H *") {
		Write-Host "  $($lang.Command): " -NoNewline
		Write-host "H" -ForegroundColor Green

		$NewRuleName = $Command.Remove(0, 2).Replace(' ', '')
		Write-Host "  $($lang.RuleName): " -NoNewline
		Write-host $NewRuleName -ForegroundColor Green
		Solutions_Help_Command -Name $NewRuleName
	}
}

<#
	.开发者模式：启用、禁用
#>
Function Shortcuts_Developers_Mode
{
	Write-Host "`n  $($lang.Developers_Mode)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Setting) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if ($Global:Developers_Mode) {
		$Global:Developers_Mode = $False
		Write-Host " $($lang.Disable) " -BackgroundColor DarkRed -ForegroundColor White
	} else {
		$Global:Developers_Mode = $True
		Write-Host " $($lang.Enable) " -BackgroundColor DarkGreen -ForegroundColor White
	}
}

<#
	.快捷指令：PS *
#>
Function Shortcuts_PS_Cmd
{
	param
	(
		$Command
	)

	$Command = $Command.Remove(0, 3)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "PS" -ForegroundColor Green

	Write-Host "  $($lang.SpecialFunction): " -NoNewline
	Write-host $Command -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	<#
		.拆分
	#>
	$Command = $Command -split ';' | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
	$IsFunction = @()
	Get-Command -CommandType Function | ForEach-Object {
		if ($Command -Contains $_) {
			$IsFunction += $_.name
		}
	}

	Write-Host "`n  $($lang.LXPsWaitAssign)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($IsFunction.Count -gt 0) {
		ForEach ($item in $IsFunction) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $IsFunction) {
			write-host "  $($lang.Running): " -NoNewline
			Write-Host $item -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Invoke-Expression -Command $item

			Write-Host "  $('-' * 80)"
			write-host "  $($lang.Command): " -NoNewline
			Write-Host $item -ForegroundColor Green

			Write-Host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red

		Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Command) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Command) {
			write-host "  $($lang.Running): " -NoNewline
			Write-Host $item -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Invoke-Expression $item

			Write-Host "  $('-' * 80)"
			write-host "  $($lang.Command): " -NoNewline
			Write-Host $item -ForegroundColor Green

			Write-Host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		}
	}
}

<#
	.LXPs
#>
Function Shortcuts_Engine_LXPs
{
	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "LXPs" -ForegroundColor Green

	$RunFilePath = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\..\_Custom\Engine\LXPs\LXPs.ps1" -ErrorAction SilentlyContinue
	if (Test-Path -Path $RunFilePath -PathType Leaf) {
		$Newfilename = Convert-Path -Path $RunFilePath -ErrorAction SilentlyContinue

		Write-Host "  $($lang.Filename): " -NoNewline
		Write-host $Newfilename -ForegroundColor Green

		Write-Host "  " -NoNewline
		Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black

		$arguments = @(
			"-ExecutionPolicy",
			"ByPass",
			"-File",
			"""$($Newfilename)"""
		)

		Start-Process "powershell" -ArgumentList $arguments -Verb RunAs

		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

<#
	.快捷指令，附加版本
#>
Function Shortcuts_Additional_Edition
{
	param
	(
		$Command
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "iAE" -ForegroundColor Green

	Shortcuts_Show_Available

	Write-Host "`n  $($lang.AdditionalEdition)"
	Write-Host "  $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "  $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		write-host "  " -NoNewline

		if (Verify_Is_Current_Same) {
			Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1"
			Event_Assign -Rule "Additional_Edition_UI" -Run
			Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "eq1end"
		}
	} else {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.AdditionalEdition)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Additional_Edition_UI" -IsEvent
	}
}

<#
	.快捷指令，附加版本 + 主键
#>
Function Shortcuts_Additional_Edition_Key
{
	param
	(
		$Name
	)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host $Name -ForegroundColor Green

	Shortcuts_Show_Available

	$NewRuleName = $Name.Remove(0, 4).split(" ").ToLower()
	Write-Host "  $($lang.Event_Primary_Key): " -NoNewline
	Write-host $NewRuleName

	$NewUid = ""
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:SMExt -contains $item.Main.Suffix) {
			if ($item.Main.Shortcuts -eq $NewRuleName) {
				$NewUid = $item.Main.Uid
				break
			}

			if ($item.Expand.Count -gt 0) {
				ForEach ($Expand in $item.Expand) {
					if ($Global:SMExt -contains $Expand.Suffix) {
						if ($Expand.Shortcuts -eq $NewRuleName) {
							$NewUid = $Expand.Uid
							break
						}
					}
				}
			}
		}
	}

	if ([string]::IsNullOrEmpty($NewUid)) {
		Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

		Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.AdditionalEdition)" -ForegroundColor Green

		Image_Select_Tasks_UI -Go "Additional_Edition_UI" -IsEvent
	} else {
		Image_Set_Global_Primary_Key -Uid $NewUid -Detailed -DevCode "0601" -Silent

		if (Image_Is_Select_IAB) {
			Write-Host "`n  $($lang.Mounted_Status)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			write-host "  " -NoNewline

			if (Verify_Is_Current_Same) {
				Write-Host " $($lang.Mounted) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Write-Host " $($lang.NotMounted) " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.Prerequisite_satisfy) " -BackgroundColor DarkGreen -ForegroundColor White

				Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1"
				if (Test-Path -Path $Global:Primary_Key_Image.FullPath -PathType Leaf) {
					Event_Assign -Rule "Additional_Edition_UI" -Run
					Image_Set_Global_Primary_Key -Uid $Global:Primary_Key_Image.Uid -Detailed -DevCode "e1end"
				} else {
					Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
				}
			}
		} else {
			Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red

			Write-Host "`n  $($lang.Ok_Go_To)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.AdditionalEdition)" -ForegroundColor Green

			Image_Select_Tasks_UI -Go "Additional_Edition_UI" -IsEvent
		}
	}
}
