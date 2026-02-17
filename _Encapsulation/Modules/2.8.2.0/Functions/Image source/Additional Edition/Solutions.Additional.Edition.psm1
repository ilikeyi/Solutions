<#
	.Additional Edition
	.附加版本
#>
Function Additional_Edition_UI
{
	param
	(
		[array]$Autopilot
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refres_Event_Tasks_Image_Additional_Edition
	{
		$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Additional_Edition.Count -gt 0) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.AdditionalEdition): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.AdditionalEdition): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}
	}

	function Image_Additional_Edition_Save
	{
		$IsFunction = @{
			Healthy = @{
				isAllow     = $UI_Main_Healthy.Checked
				ErrorNoSave = $UI_Main_Healthy_Save.Checked
			}
			NoSelect = $UI_Main_Import_Adv_Exclude.Checked
			Rebuild = $UI_Main_Rebuild.Checked
			Compression = $UI_Main_Capture_Type_Select.SelectedItem.CompressionType
		}

		[PSCustomObject]$NewCustom = @()
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				$GetGUID = $_.Name
				$Requiredversion = ""
				$EditionId = ""
				$Productkey_Custom = ""
				$NewImageName = ""
				$NewDescription = ""
				$NewDisplayName = ""
				$NewDisplayDescription = ""

				$_.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.Label]) {
						if ($_.Name -eq "Requiredversion") {
							$Requiredversion = $_.Tag
						}

						if ($_.Name -eq "NewEditionId") {
							$EditionId = $_.Tag
						}
					}

					if ($_ -is [System.Windows.Forms.TextBox]) {
						if ($_.Name -eq "Productkey")  { $Productkey_Custom = $_.Text }
						if ($_.Name -eq "ImageName")   { $NewImageName = $_.Text }
						if ($_.Name -eq "Description") { $NewDescription = $_.Text }
						if ($_.Name -eq "DisplayName") { $NewDisplayName = $_.Text }
						if ($_.Name -eq "DisplayDescription") { $NewDisplayDescription = $_.Text }
					}
				}

				$_.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Checked) {
							$NewCustom += [pscustomobject]@{
								GUID = $GetGUID
								Name = $_.Name
								Requiredversion = $Requiredversion
								NewEditionId = $EditionId
								Productkey = $Productkey_Custom
								Detailed = @{
									ImageName = $NewImageName
									Description = $NewDescription
									DisplayName = $NewDisplayName
									DisplayDescription = $NewDisplayDescription
								}
							}
						}
					}
				}
			}
		}

		if ($NewCustom.count -gt 0) {
			$ExcludeNew = @()

			$UI_Main_Select_Function.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						$ExcludeNew += $_.Text
					}
				}
			}

			$NewGroup = @{
				Rule = $NewCustom
				Adv = $IsFunction
				Exclude = $ExcludeNew
				CustomReplace = $UI_Main_Replace_Custom.Text
			}
			New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -Value $NewGroup -Force

			if ($UI_Main_Abandon_Allow.Checked) {
				New-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Global:Primary_Key_Image.Uid)" -Value $True -Force
			}

			$UI_Main_Error.Text = "$($lang.Save), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			return $True
		} else {
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return $False
		}
	}

	Function Refresh_Image_Additional_Edition_To_Order
	{
		$UI_Main_Import_Menu.controls.Clear()
		$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Additional_Edition.Count -gt 0) {
			ForEach ($itemRule in $Temp_Additional_Edition) {
				Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 460
				Padding   = "16,0,0,0"
				Text      = $lang.NoWork
			}
			$UI_Main_Import_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	Function Refresh_Image_Additional_Edition_To_Import
	{
		$UI_Main_Import_Menu.controls.Clear()
		$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Additional_Edition.Count -gt 0) {
			ForEach ($itemRule in $Temp_Additional_Edition) {
				Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 460
				Padding   = "16,0,0,0"
				Text      = $lang.NoWork
			}
			$UI_Main_Import_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	Function Refresh_Image_Additional_Edition_To_Edit
	{
		$UI_Main_Menu.controls.Clear()
		$Script:Additional_Edition_OK = @()
		$Script:Additional_Edition_Failed = @()

		$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Additional_Edition.Count -gt 0) {
			ForEach ($itemRule in $Temp_Additional_Edition.Rule) {
				Image_Additional_Edition_Import_To_Edit -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
			}

			$UI_Main_Error.Text = "$($lang.Import): $($lang.Prerequisite_satisfy) ( $($Script:Additional_Edition_OK.count) ), $($lang.Failed) ( $($Script:Additional_Edition_Failed.count) ), $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 460
				Padding   = "16,0,0,0"
				Text      = $lang.NoWork
			}
			$UI_Main_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	<#
		.添加规则：自定义规则、预规则
	#>
	Function Refresh_Image_Additional_Edition_Custom_Rule
	{
		$UI_Main_Select_Rule.controls.Clear()

		<#
			.添加规则：预置规则
		#>
		$UI_Main_Extract_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 442
			Text           = $lang.RulePre
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Pre_Rule)

		if ($Global:Pre_Config_Rules.count -gt 0) {
			ForEach ($itemPre in $Global:Pre_Config_Rules) {
				$UI_Main_Extract_Group = New-Object system.Windows.Forms.Label -Property @{
					Height    = 30
					Width     = 442
					Padding   = "18,0,0,0"
					Text      = $itemPre.Group
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group)

				ForEach ($item in $itemPre.Version) {
					$CheckBox     = New-Object System.Windows.Forms.Label -Property @{
						Height    = 30
						Width     = 442
						Padding   = "36,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
					}

					$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 442
						Padding        = "54,0,0,0"
						Margin         = "0,0,0,5"
						Text           = $lang.Detailed_View
						Tag            = $item.GUID
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Image_Additional_Edition_Rule_Details_View -GUID $this.Tag
						}
					}
					$UI_Main_Select_Rule.controls.AddRange((
						$CheckBox,
						$UI_Main_Rule_Details_View
					))

					<#
						.导入
					#>
					if ($item.AdditionalEdition.count -gt 0) {
						$UI_Main_Prerequisite_Language_Name = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 442
							Padding        = "54,0,0,0"
							Text           = "$($lang.IsNewScheme): $($item.AdditionalEdition.count) $($lang.EventManagerCount)"
						}
						$UI_Main_Select_Rule.controls.AddRange($UI_Main_Prerequisite_Language_Name)

						foreach ($itemRule in $item.AdditionalEdition) {
							$CheckBox          = New-Object system.Windows.Forms.LinkLabel -Property @{
								Height         = 55
								Width          = 442
								Padding        = "75,0,0,0"
								Margin         = "0,0,0,5"
								Text           = "$($lang.Event_Primary_Key): $($item.AdditionalEdition.Uid)`n$($lang.Autopilot_Scheme): $($item.AdditionalEdition.Scheme)"
								Tag            = $item.GUID
								LinkColor      = "#008000"
								ActiveLinkColor = "#FF0000"
								LinkBehavior   = "NeverUnderline"
								add_Click      = {
									$UI_Main_Error.Text = ""
									$UI_Main_Error_Icon.Image = $null
									$UI_Main_Order_Error.Text = ""
									$UI_Main_Order_Error_Icon.Image = $null
									$UI_Main_Import_Error.Text = ""
									$UI_Main_Import_Error_Icon.Image = $null

									$UI_Main_Order_UI.visible = $True
									Image_Additional_Edition_Refresh_All_Rule_Guid -GUID $this.Tag
								}
							}
							$UI_Main_Select_Rule.controls.AddRange($CheckBox)
						}
					} else {
#						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
#							Height    = 30
#							Width     = 442
#							Padding   = "54,0,0,0"
#							Text      = "$($lang.Import): $($lang.NoWork)"
#						}
#						$UI_Main_Select_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}
				}

				$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 20
					Width          = 442
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group_Wrap)
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 442
				margin    = "0,0,0,35"
				Text      = $lang.NoWork
			}
			$UI_Main_Select_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}

		<#
			.添加规则：其它规则
		#>
		$UI_Main_Extract_Other_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 442
			Text           = $lang.RuleOther
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Other_Rule)
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			$CheckBox     = New-Object System.Windows.Forms.Label -Property @{
				Height    = 30
				Width     = 442
				Padding   = "16,0,0,0"
				Text      = $item.Name
				Tag       = $item.GUID
			}

			$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
				Height         = 30
				Width          = 442
				Padding        = "36,0,0,0"
				Margin         = "0,0,0,5"
				Text           = $lang.Detailed_View
				Tag            = $item.GUID
				LinkColor      = "#008000"
				ActiveLinkColor = "#FF0000"
				LinkBehavior   = "NeverUnderline"
				add_Click      = {
					Image_Additional_Edition_Rule_Details_View -GUID $this.Tag
				}
			}

			$UI_Main_Select_Rule.controls.AddRange((
				$CheckBox,
				$UI_Main_Rule_Details_View
			))
		
				<#
					.导入
				#>
				if ($item.AdditionalEdition.count -gt 0) {
					$UI_Main_Prerequisite_Language_Name = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 442
						Padding        = "34,0,0,0"
						Text           = "$($lang.IsNewScheme): $($item.AdditionalEdition.count) $($lang.EventManagerCount)"
					}
					$UI_Main_Select_Rule.controls.AddRange($UI_Main_Prerequisite_Language_Name)

					foreach ($itemRule in $item.AdditionalEdition) {
						$CheckBox   = New-Object system.Windows.Forms.LinkLabel -Property @{
							Height         = 35
							Width          = 442
							Padding        = "55,0,0,0"
							Margin         = "0,0,0,5"
							Text           = "$($lang.Event_Primary_Key): $($item.AdditionalEdition.Uid)`n$($lang.Autopilot_Scheme): $($item.AdditionalEdition.Scheme)"
							Tag            = $item.GUID
							LinkColor      = "#008000"
							ActiveLinkColor = "#FF0000"
							LinkBehavior   = "NeverUnderline"
							add_Click      = {
								$UI_Main_Error.Text = ""
								$UI_Main_Error_Icon.Image = $null
								$UI_Main_Order_Error.Text = ""
								$UI_Main_Order_Error_Icon.Image = $null
								$UI_Main_Import_Error.Text = ""
								$UI_Main_Import_Error_Icon.Image = $null

								$UI_Main_Order_UI.visible = $True
								Image_Additional_Edition_Refresh_All_Rule_Guid -GUID $this.Tag
							}
						}
						$UI_Main_Select_Rule.controls.AddRange($CheckBox)
					}
				} else {
#					$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
#						Height    = 30
#						Width     = 460
#						Padding   = "34,0,0,0"
#						Text      = "$($lang.Import): $($lang.NoWork)"
#					}
#					$UI_Main_Select_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
				}

			$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
				Height         = 20
				Width          = 442
			}
			$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group_Wrap)
		}

		<#
			.添加规则，自定义
		#>
		$UI_Main_Extract_Customize_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 435
			Margin         = "0,35,0,0"
			Text           = $lang.RuleCustomize
		}
		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule)
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					$CheckBox     = New-Object System.Windows.Forms.Label -Property @{
						Height    = 30
						Width     = 442
						Padding   = "36,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
					}

					$UI_Main_Rule_Details_View = New-Object system.Windows.Forms.LinkLabel -Property @{
						Height         = 30
						Width          = 442
						Padding        = "36,0,0,0"
						Margin         = "0,0,0,5"
						Text           = $lang.Detailed_View
						Tag            = $item.GUID
						LinkColor      = "#008000"
						ActiveLinkColor = "#FF0000"
						LinkBehavior   = "NeverUnderline"
						add_Click      = {
							Image_Additional_Edition_Rule_Details_View -GUID $this.Tag
						}
					}

					$UI_Main_Select_Rule.controls.AddRange((
						$CheckBox,
						$UI_Main_Rule_Details_View
					))
					
						<#
							.导入
						#>
						if ($item.AdditionalEdition.count -gt 0) {
							$UI_Main_Prerequisite_Language_Name = New-Object system.Windows.Forms.Label -Property @{
								Height         = 30
								Width          = 442
								Padding        = "34,0,0,0"
								Text           = "$($lang.Event_Primary_Key): $($item.AdditionalEdition.Uid)`n$($lang.Autopilot_Scheme): $($item.AdditionalEdition.Scheme)"
							}
							$UI_Main_Select_Rule.controls.AddRange($UI_Main_Prerequisite_Language_Name)

							foreach ($itemRule in $item.AdditionalEdition) {
								$CheckBox         = New-Object system.Windows.Forms.LinkLabel -Property @{
									Height         = 35
									Width          = 442
									Padding        = "55,0,0,0"
									Margin         = "0,0,0,5"
									Text           = $itemRule.Uid
									Tag            = $item.GUID
									LinkColor      = "#008000"
									ActiveLinkColor = "#FF0000"
									LinkBehavior   = "NeverUnderline"
									add_Click      = {
										$UI_Main_Error.Text = ""
										$UI_Main_Error_Icon.Image = $null
										$UI_Main_Order_Error.Text = ""
										$UI_Main_Order_Error_Icon.Image = $null
										$UI_Main_Import_Error.Text = ""
										$UI_Main_Import_Error_Icon.Image = $null

										$UI_Main_Order_UI.visible = $True
										Image_Additional_Edition_Refresh_All_Rule_Guid -GUID $this.Tag
									}
								}
								$UI_Main_Select_Rule.controls.AddRange($CheckBox)
							}
						} else {
#							$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
#								Height    = 30
#								Width     = 442
#								Padding   = "34,0,0,0"
#								Text      = "$($lang.Import): $($lang.NoWork)"
#							}
#							$UI_Main_Select_Rule.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
						}

					$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 20
						Width          = 442
					}
					$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Group_Wrap)
				}
			} else {
				$UI_Main_Extract_Customize_Rule_Tips = New-Object system.Windows.Forms.Label -Property @{
					AutoSize       = 1
					Padding        = "18,0,0,0"
					Text           = $lang.RuleCustomizeTips
				}
				$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips)
			}
		} else {
			$UI_Main_Extract_Customize_Rule_Tips_Not = New-Object system.Windows.Forms.Label -Property @{
				AutoSize       = 1
				Padding        = "18,0,0,0"
				Text           = $lang.RuleCustomizeNot
			}
			$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule_Tips_Not)
		}

		$GUIImageSelectInstall_Wrap = New-Object System.Windows.Forms.Label -Property @{
			Height             = 30
			Width              = 442
		}
		$UI_Main_Select_Rule.controls.AddRange($GUIImageSelectInstall_Wrap)
	}

	<#
		.事件：查看规则命名，详细内容
	#>
	Function Image_Additional_Edition_Rule_Details_View
	{
		param
		(
			$GUID
		)

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		$Script:InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$Script:InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$Script:InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$Script:InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		if ($Script:InBox_Apps_Rule_Select_Single.count -gt 0) {
			$UI_Main_Rule_View_Detailed.Visible = $True
			$UI_Main_Rule_View_Detailed_Show.Text = ""

			$UI_Main_Rule_View_Detailed_Show.Text += "$($lang.RuleAuthon)`n"
			$UI_Main_Rule_View_Detailed_Show.Text += "   $($Script:InBox_Apps_Rule_Select_Single.Author)"

			$UI_Main_Rule_View_Detailed_Show.Text += "`n`n$($lang.RuleGUID)`n"
			$UI_Main_Rule_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.GUID)"

			$UI_Main_Rule_View_Detailed_Show.Text += "`n`n$($lang.RuleName)`n"
			$UI_Main_Rule_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.Name)"

			$UI_Main_Rule_View_Detailed_Show.Text += "`n`n$($lang.RuleDescription)`n"
			$UI_Main_Rule_View_Detailed_Show.Text += "     $($Script:InBox_Apps_Rule_Select_Single.Description)"

			$UI_Main_Rule_View_Detailed_Show.Text += "`n`n$($lang.AdditionalEdition)`n"
			if ($Script:InBox_Apps_Rule_Select_Single.AdditionalEdition.Count -gt 0) {
				ForEach ($item in $Script:InBox_Apps_Rule_Select_Single.AdditionalEdition) {
					$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.Event_Group): $($item.Group)`n"
					$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.Event_Primary_Key): $($item.Uid)`n"
					$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.Autopilot_Scheme): $($item.Scheme)`n"
					$UI_Main_Rule_View_Detailed_Show.Text += "     $('-' * 80)`n"
					if ($item.Rule.Count -gt 0) {
						foreach ($itemRule in $item.Rule) {
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.Unique_Name): $($itemRule.GUID)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.AdditionalEdition): $($itemRule.Name)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.AE_Required_EditionID): $($itemRule.Requiredversion)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.AE_New_EditionID): $($itemRule.NewEditionId)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.KMSKey): $($itemRule.Productkey)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.Detailed)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "        $($lang.Wim_Image_Name): $($itemRule.Detailed.ImageName)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "        $($lang.Wim_Image_Description): $($itemRule.Detailed.Description)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "        $($lang.Wim_Display_Name): $($itemRule.Detailed.DisplayName)`n"
							$UI_Main_Rule_View_Detailed_Show.Text += "        $($lang.Wim_Display_Description): $($itemRule.Detailed.DisplayDescription)`n`n`n"
						}
					} else {
						$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.NoWork)`n"
					}
				}
			} else {
				$UI_Main_Rule_View_Detailed_Show.Text += "     $($lang.NoWork)`n"
			}
		} else {
			$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.Detailed_View)"
			$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Image_Additional_Edition_Refresh_All_Rule_Guid
	{
		param
		(
			$GUID
		)

		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null
		$UI_Main_Import_Menu.controls.Clear()	 # 导入界面：清空

		$UI_Main_Order_Error.Text = ""
		$UI_Main_Order_Error_Icon.Image = $null
		$UI_Main_Order_Rule.controls.Clear()	 # 托拽顺序界面：清空
		$Script:InBox_Apps_Rule_Select_Single = @()

		<#
			.从预规则里获取
		#>
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					$Script:InBox_Apps_Rule_Select_Single = $item
					break
				}
			}
		}

		<#
			.从预规则里获取
		#>
		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				$Script:InBox_Apps_Rule_Select_Single = $item
				break
			}
		}

		<#
			.从用户自定义规则里获取
		#>
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						$Script:InBox_Apps_Rule_Select_Single = $item
						break
					}
				}
			}
		}

		$NewCustom = @()
		if ($Script:InBox_Apps_Rule_Select_Single.AdditionalEdition.count -gt 0) {
			foreach ($item in $Script:InBox_Apps_Rule_Select_Single.AdditionalEdition) {
				if ($item.Rule.count -gt 0) {
					foreach ($itemRule in $item.Rule) {
						Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
					}

					$Temp_Get_Select_Order = @()
					$UI_Main_Order_Rule.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.Button]) {
							$Temp_Get_Select_Order += $_.Tag
						}
					}

					foreach ($itemToNew in $Temp_Get_Select_Order) {
						foreach ($itemRule in $item.Rule) {
							if ($itemToNew -eq $itemRule.GUID) {
								$NewCustom += [pscustomobject]@{
									GUID = $itemRule.GUID
									Name = $itemRule.Name
									Requiredversion = $itemRule.Requiredversion
									NewEditionId = $itemRule.NewEditionId
									Productkey = $itemRule.Productkey
									Detailed = @{
										ImageName = $itemRule.Detailed.ImageName
										Description = $itemRule.Detailed.Description
										DisplayName = $itemRule.Detailed.DisplayName
										DisplayDescription = $itemRule.Detailed.DisplayDescription
									}
								}

								Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
							}
						}
					}

					New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force
				} else {
					$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.NoWork)"
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
				}
			}
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				autosize = 1
				Padding  = "16,0,0,0"
				Text     = $lang.NoWork
			}

			$UI_Main_Import_Menu.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
		}
	}

	Function Image_Additional_Edition_Addto_OrderUI
	{
		param (
			$GUID,
			$Name,
			$NewEditionId
		)

		<#
			.添加到拖拽界面
		#>
		$DroupButton = New-Object System.Windows.Forms.Button -Property @{
			UseVisualStyleBackColor = $True
			Height  = 50
			Width   = 460
			Padding = "8,0,0,0"
			Text    = "$($lang.AdditionalEdition): $($Name)`n$($lang.AE_New_EditionID): $($NewEditionId)"
			TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
			Tag     = $GUID
			BackColor = [Drawing.Color]::LightCyan
			Add_MouseDown = {
 				param($sender, $e)
 				if ($e.Button -eq [Windows.Forms.MouseButtons]::Left) {
 					$this.DoDragDrop($this, [Windows.Forms.DragDropEffects]::Move)
 				}
			}
		}

		$UI_Main_Order_Rule.controls.AddRange($DroupButton)
	}


	Function Image_Additional_Edition_AddTo_ImportUI
	{
		param (
			$GUID,
			$Prefix,
			$Name,
			$Requiredversion,
			$NewEditionId,
			$Productkey,
			$NewImageName,
			$NewDescription,
			$NewDisplayName,
			$NewDisplayDescription
		)

		if ([string]::IsNullOrEmpty($Name)) {
			$Name = $lang.ImageCodenameNo
		}

		if ([string]::IsNullOrEmpty($Productkey)) {
			$Productkey = $lang.ImageCodenameNo
		}

		$Region = Language_Region
		$MatchLanguageResult = $Region.Region | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

		$Newlang = Get_SELang -Newlang $Global:MainImageLang -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
		if ($NewImageName -eq "Auto") {
			$NewImageName = $Newlang.Language.ImageName
		} else {
			if ($MatchLanguageResult -contains $NewImageName) {
				$Newlang = Get_SELang -Newlang $NewImageName -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
				$NewImageName = $Newlang.Language.ImageName
			}
		}

		if ($NewDescription -eq "Auto") {
			$NewDescription = $Newlang.Language.Description
		} else {
			if ($MatchLanguageResult -contains $NewImageName) {
				$Newlang = Get_SELang -Newlang $NewDescription -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
				$NewDescription = $Newlang.Language.Description
			}
		}

		if ($NewDisplayName -eq "Auto") {
			$NewDisplayName = $Newlang.Language.DisplayName
		} else {
			if ($MatchLanguageResult -contains $NewImageName) {
				$Newlang = Get_SELang -Newlang $NewDisplayName -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
				$NewDisplayName = $Newlang.Language.DisplayName
			}
		}

		if ($NewDisplayDescription -eq "Auto") {
			$NewDisplayDescription = $Newlang.Language.DisplayDescription
		} else {
			if ($MatchLanguageResult -contains $NewImageName) {
				$Newlang = Get_SELang -Newlang $NewDisplayDescription -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
				$NewDisplayDescription = $Newlang.Language.DisplayDescription
			}
		}

		<#
			.添加到导入界面
		#>
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height  = 35
			Width   = 460
			Text    = "$($lang.AdditionalEdition): $($Name)"
			Tag     = $GUID
			Checked = $true
			add_Click = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null
			}
		}

		if ([string]::IsNullOrEmpty($Requiredversion)) {
			$CheckBox.Enabled = $False
		}

		$Requiredversion_Name = New-Object system.Windows.Forms.Label -Property @{
			Name           = "Requiredversion"
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.AE_Required_EditionID): $($Requiredversion)"
			Tag            = $Requiredversion
		}

		$EditionId_Name    = New-Object system.Windows.Forms.Label -Property @{
			Name           = "NewEditionId"
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.AE_New_EditionID): $($NewEditionId)"
			Tag            = $NewEditionId
		}

		$Productkey_Custom  = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = "$($lang.KMSKey): $($Productkey)"
			Tag            = $Productkey
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}

		$Details           = New-Object System.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
			Padding        = "16,0,0,0"
			Text           = $lang.Detailed
		}

		$NewImageName_Custom = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize       = 1
			Padding        = "26,0,0,0"
			Text           = "$($lang.Wim_Image_Name): $($NewImageName)"
			Tag            = $NewImageName
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}
		$NewImageName_Custom_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}

		$NewImage_Description_Name = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize       = 1
			Padding        = "26,0,0,0"
			Text           = "$($lang.Wim_Image_Description): $($NewDescription)"
			Tag            = $NewDescription
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}
		$NewImage_Description_Name_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}

		$NewDisplayName_Custom = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize       = 1
			Padding        = "26,0,0,0"
			Text           = "$($lang.Wim_Display_Name): $($NewDisplayName)"
			Tag            = $NewDisplayName
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}
		$NewDisplayName_Custom_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}

		$NewDisplayDescription_Custom_Custom = New-Object system.Windows.Forms.LinkLabel -Property @{
			autosize       = 1
			Padding        = "26,0,0,0"
			Text           = "$($lang.Wim_Display_Description): $($NewDisplayDescription)"
			Tag            = $NewDisplayDescription
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null

				if ([string]::IsNullOrEmpty($This.Tag)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
				} else {
					Set-Clipboard -Value $This.Tag

					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Import_Error.Text = "$($lang.Paste), $($lang.Done)"
				}
			}
		}
		$NewDisplayDescription_Custom_Custom_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 10
			Width          = 460
		}

		$UI_Main_Extract_Group_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 460
		}
		$UI_Main_Import_Menu.controls.AddRange((
			$CheckBox,
			$Requiredversion_Name,
			$EditionId_Name,
			$Productkey_Custom,
			$Details,
			$NewImageName_Custom,
			$NewImageName_Custom_Wrap,
			$NewImage_Description_Name,
			$NewImage_Description_Name_Wrap,
			$NewDisplayName_Custom,
			$NewDisplayName_Custom_Wrap,
			$NewDisplayDescription_Custom_Custom,
			$NewDisplayDescription_Custom_Custom_Wrap,
			$UI_Main_Extract_Group_Wrap
		))
	}

	Function Image_Additional_Edition_Import_To_Edit
	{
		param (
			[switch]$NoAuto,
			$GUID,
			$Name,
			$Requiredversion,
			$NewEditionId,
			$Productkey,
			$NewImageName,
			$NewDescription,
			$NewDisplayName,
			$NewDisplayDescription
		)

		if ($NoAuto) {
			$Region = Language_Region
			$MatchLanguageResult = $Region.Region | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique

			$Newlang = Get_SELang -Newlang $Global:MainImageLang -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
			if ($NewImageName -eq "Auto") {
				$NewImageName = $Newlang.Language.ImageName
			} else {
				if ($MatchLanguageResult -contains $NewImageName) {
					$Newlang = Get_SELang -Newlang $NewImageName -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
					$NewImageName = $Newlang.Language.ImageName
				}
			}

			if ($NewDescription -eq "Auto") {
				$NewDescription = $Newlang.Language.Description
			} else {
				if ($MatchLanguageResult -contains $NewImageName) {
					$Newlang = Get_SELang -Newlang $NewDescription -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
					$NewDescription = $Newlang.Language.Description
				}
			}

			if ($NewDisplayName -eq "Auto") {
				$NewDisplayName = $Newlang.Language.DisplayName
			} else {
				if ($MatchLanguageResult -contains $NewImageName) {
					$Newlang = Get_SELang -Newlang $NewDisplayName -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
					$NewDisplayName = $Newlang.Language.DisplayName
				}
			}

			if ($NewDisplayDescription -eq "Auto") {
				$NewDisplayDescription = $Newlang.Language.DisplayDescription
			} else {
				if ($MatchLanguageResult -contains $NewImageName) {
					$Newlang = Get_SELang -Newlang $NewDisplayDescription -Edition $NewEditionId -Name $Name -Replace $UI_Main_Replace_Custom.Text
					$NewDisplayDescription = $Newlang.Language.DisplayDescription
				}
			}
		}

		$CheckboxGroup     = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			Name           = $GUID
			Height         = 650
			Width          = 470
			BorderStyle    = 0
			autoSizeMode   = 0
			autoScroll     = $false
		}
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Name    = $Name
			Height  = 35
			Width   = 435
			Text    = "$($lang.AdditionalEdition): $($Name)"
			Tag     = $GUID
			Checked = $true
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}
		$Requiredversion_Name = New-Object system.Windows.Forms.Label -Property @{
			Name           = "Requiredversion"
			Height         = 30
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = "$($lang.AE_Required_EditionID): $($Requiredversion)"
			Tag            = $Requiredversion
		}

		$EditionId_Name    = New-Object system.Windows.Forms.Label -Property @{
			Name           = "NewEditionId"
			Height         = 30
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = "$($lang.AE_New_EditionID): $($NewEditionId)"
			Tag            = $NewEditionId
		}

		$EditionId_Name_Status = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
			Padding        = "35,0,0,0"
			Text           = "$($lang.LXPsWaitAdd): "
		}

		if ($Script:GetEditionID -contains $Requiredversion) {
			$Script:Additional_Edition_OK += $Guid
			$EditionId_Name_Status.Text += $lang.Prerequisite_satisfy

			$CheckBox.Checked = $True
		} else {
			$Script:Additional_Edition_Failed += $Guid
			$EditionId_Name_Status.Text += $lang.AE_Not_Match

			if ($UI_Main_Import_Adv_Exclude.Checked) {
				$CheckBox.Checked = $False
			} else {
				$CheckBox.Checked = $True
			}
		}

		$EditionId_Add_To_Exclude_Nomount = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 450
			Padding        = "35,0,0,0"
			Text           = $lang.AE_Add_Exclude_Nomount
			Tag            = $NewEditionId
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				$Temp_Get_Select_Function = @()
				$UI_Main_Select_Function.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						$Temp_Get_Select_Function += $_.Text
					}
				}

				if ($Temp_Get_Select_Function -contains $this.Tag) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = "$($lang.Existed): $($This.Tag)"
				} else {
					$CheckBoxNew = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 40
						Width     = 445
						Text      = $this.Tag
						Checked   = $true
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null
						}
					}

					$UI_Main_Select_Function.controls.AddRange($CheckBoxNew)

					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Error.Text = "$($lang.AddTo): $($This.Tag), $($lang.Done)"
				}
			}
		}
		$EditionId_Name_Wrap  = New-Object system.Windows.Forms.Label -Property @{
			Height         = 15
			Width          = 450
		}

		$Productkey_Name   = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 30
			Width          = 450
			Padding        = "16,0,0,0"
			Text           = $lang.KMSKeySelect
			Tag            = $Guid
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null
				$Global:ProductKey = ""

				KMSkeys

				if ([string]::IsNullOrEmpty($Global:ProductKey)) {
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Import_Error.Text = "$($lang.NoChoose): $($lang.KMSKey)"
				} else {
					$UI_Main_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ($_.Name -eq $This.Tag) {
								$_.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.TextBox]) {
										if ($_.Name -eq "Productkey") { $_.Text = $Global:ProductKey }
									}
								}
							}
						}
					}
				}
			}
		}
		$Productkey_Custom = New-Object System.Windows.Forms.TextBox -Property @{
			Name           = "Productkey"
			Height         = 30
			Width          = 410
			Margin         = "35,5,0,20"
			Text           = $Productkey
			BackColor      = "#FFFFFF"
			add_Click      = {
				$UI_Main_Import_Error.Text = ""
				$UI_Main_Import_Error_Icon.Image = $null
			}
		}

		$Details           = New-Object System.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 450
			margin         = "0,15,0,0"
			Padding        = "16,0,0,0"
			Text           = $lang.Detailed
		}
			$NewImageName_Name = New-Object System.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 447
				Padding        = "32,0,0,0"
				Text           = $lang.Wim_Image_Name
			}
			$NewImageName_Custom = New-Object System.Windows.Forms.TextBox -Property @{
				Name           = "ImageName"
				Height         = 30
				Width          = 395
				Margin         = "45,5,0,20"
				Text           = $NewImageName
				BackColor      = "#FFFFFF"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$NewImage_Description_Name = New-Object System.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 447
				Padding        = "32,0,0,0"
				Text           = $lang.Wim_Image_Description
			}
			$NewImage_Description_Custom = New-Object System.Windows.Forms.TextBox -Property @{
				Name           = "Description"
				Height         = 30
				Width          = 395
				Margin         = "45,5,0,20"
				Text           = $NewDescription
				BackColor      = "#FFFFFF"
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$NewDisplayName_Name = New-Object System.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 447
				Padding        = "32,0,0,0"
				Text           = $lang.Wim_Display_Name
			}
			$NewDisplayName_Custom = New-Object System.Windows.Forms.TextBox -Property @{
				Name           = "DisplayName"
				Height         = 30
				Width          = 395
				Margin         = "45,5,0,20"
				BackColor      = "#FFFFFF"
				Text           = $NewDisplayName
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			$NewDisplayDescription_Name = New-Object System.Windows.Forms.Label -Property @{
				Height         = 30
				Width          = 447
				Padding        = "32,0,0,0"
				Text           = $lang.Wim_Display_Description
			}
			$NewDisplayDescription_Custom = New-Object System.Windows.Forms.TextBox -Property @{
				Name           = "DisplayDescription"
				Height         = 30
				Width          = 395
				Margin         = "45,5,0,20"
				BackColor      = "#FFFFFF"
				Text           = $NewDisplayDescription
				add_Click      = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

		$CheckboxGroup.controls.AddRange((
			$CheckBox,
			$Requiredversion_Name,
			$EditionId_Name,
			$EditionId_Name_Status,
			$EditionId_Add_To_Exclude_Nomount,
			$EditionId_Name_Wrap,
			$Productkey_Name,
			$Productkey_Custom,
			$Details,
				$NewImageName_Name,
				$NewImageName_Custom,
				$NewImage_Description_Name,
				$NewImage_Description_Custom,
				$NewDisplayName_Name,
				$NewDisplayName_Custom,
				$NewDisplayDescription_Name,
				$NewDisplayDescription_Custom
		))
		$UI_Main_Menu.controls.AddRange($CheckboxGroup)
	}

	Function Image_Additional_Edition_Import_Save
	{
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		<#
			.判断是否有预规则，先决条件
		#>
		$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
		if ($Temp_Additional_Edition.count -gt 0) {
		} else {
			$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			return
		}

		<#
			.导入前：剪断是否选择了
		#>
		$IsSelectImport = @()
		$UI_Main_Import_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$IsSelectImport += $_.Tag
					}
				}
			}
		}

		if ($IsSelectImport.count -gt 0) {
			$UI_Main_Menu.controls.clear()

			if ($Temp_Additional_Edition.Count -gt 1) {
				$Script:Additional_Edition_OK = @()
				$Script:Additional_Edition_Failed = @()

				ForEach ($itemRule in $Temp_Additional_Edition) {
					if ($IsSelectImport -contains $itemRule.GUID) {
						Image_Additional_Edition_Import_To_Edit -NoAuto -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
					}
				}

				$UI_Main_Import_Detailed.visible = $False
				$UI_Main_Exclude.visible = $False
				$UI_Main_Error.Text = "$($lang.Import): $($lang.Prerequisite_satisfy) ( $($Script:Additional_Edition_OK.count) ), $($lang.Failed) ( $($Script:Additional_Edition_Failed.count) ), $($lang.Done)"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			} else {
				$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.Failed)"
				$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		} else {
			$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
		}
	}

	Function Autopoliot_Additional_Edition_Import
	{
		param (
			$GUID,
			$Schome
		)

		$NewCustom = @()
		ForEach ($itemPre in $Global:Pre_Config_Rules) {
			ForEach ($item in $itemPre.Version) {
				if ($GUID -eq $item.GUID) {
					foreach ($itemNew in $item.AdditionalEdition) {
						if ($itemNew.uid -eq $Global:Primary_Key_Image.Uid) {
							if ($itemNew.Scheme -eq $Schome) {
								if ($itemNew.Rule.count -gt 0) {
									foreach ($itemRule in $itemNew.Rule) {
										$NewCustom += [pscustomobject]@{
											GUID = $itemRule.GUID
											Name = $itemRule.Name
											Requiredversion = $itemRule.Requiredversion
											NewEditionId = $itemRule.NewEditionId
											Productkey = $itemRule.Productkey
											Detailed = @{
												ImageName = $itemRule.Detailed.ImageName
												Description = $itemRule.Detailed.Description
												DisplayName = $itemRule.Detailed.DisplayName
												DisplayDescription = $itemRule.Detailed.DisplayDescription
											}
										}

										Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
										Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
									}

									New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force
								}
							}
						}
					}

					return
				}
			}
		}

		ForEach ($item in $Global:Preconfigured_Rule_Language) {
			if ($GUID -eq $item.GUID) {
				foreach ($itemNew in $item.AdditionalEdition) {
					if ($itemNew.uid -eq $Global:Primary_Key_Image.Uid) {
						if ($itemNew.Scheme -eq $Schome) {
							if ($itemNew.Rule.count -gt 0) {
								foreach ($itemRule in $itemNew.Rule) {
									$NewCustom += [pscustomobject]@{
										GUID = $itemRule.GUID
										Name = $itemRule.Name
										Requiredversion = $itemRule.Requiredversion
										NewEditionId = $itemRule.NewEditionId
										Productkey = $itemRule.Productkey
										Detailed = @{
											ImageName = $itemRule.Detailed.ImageName
											Description = $itemRule.Detailed.Description
											DisplayName = $itemRule.Detailed.DisplayName
											DisplayDescription = $itemRule.Detailed.DisplayDescription
										}
									}

									Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
									Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
								}

								New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force
							}
						}
					}
				}

				return
			}
		}

		$UI_Main_Select_Rule.controls.AddRange($UI_Main_Extract_Customize_Rule)
		if (Is_Find_Modules -Name "Solutions.Custom.Extension") {
			if ($Global:Custom_Rule.count -gt 0) {
				ForEach ($item in $Global:Custom_Rule) {
					if ($GUID -eq $item.GUID) {
						foreach ($itemNew in $item.AdditionalEdition) {
							if ($itemNew.uid -eq $Global:Primary_Key_Image.Uid) {
								if ($itemNew.Scheme -eq $Schome) {
									if ($itemNew.Rule.count -gt 0) {
										foreach ($itemRule in $itemNew.Rule) {
											$NewCustom += [pscustomobject]@{
												GUID = $itemRule.GUID
												Name = $itemRule.Name
												Requiredversion = $itemRule.Requiredversion
												NewEditionId = $itemRule.NewEditionId
												Productkey = $itemRule.Productkey
												Detailed = @{
													ImageName = $itemRule.Detailed.ImageName
													Description = $itemRule.Detailed.Description
													DisplayName = $itemRule.Detailed.DisplayName
													DisplayDescription = $itemRule.Detailed.DisplayDescription
												}
											}

											Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
											Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
										}

										New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force
									}
								}
							}
						}
					
						return
					}
				}
			}
		}
	}

	Function Refresh_Additional_Edition_CompressionType
	{
		param
		(
			$Type
		)

		switch ($Type) {
			"Max" {
				$UI_Main_Capture_Type_Select.SelectedIndex = $UI_Main_Capture_Type_Select.FindString($lang.CompressionType_Max)
			}
			"Fast" {
				$UI_Main_Capture_Type_Select.SelectedIndex = $UI_Main_Capture_Type_Select.FindString($lang.CompressionType_Fast)
			}
			"None" {
				$UI_Main_Capture_Type_Select.SelectedIndex = $UI_Main_Capture_Type_Select.FindString($lang.CompressionType_None)
			}
		}
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -Value @() -Force
		Additional_Edition_Reset
		Event_Reset_Variable
		$UI_Main.Close()
	}

	$UI_Main_Event_Clear_Click = {
		New-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -Value @() -Force

		Refres_Event_Tasks_Image_Additional_Edition

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = $lang.AdditionalEdition
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Add_FormClosed = {
			$UI_Main.Hide()

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}
			$UI_Main.Close()
		}
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}

	$UI_Main_Menu_Name  = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 437
		Location       = "15,15"
		Text           = $lang.AdditionalEdition
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Refresh_Image_Additional_Edition_To_Edit

			$UI_Main_Error.Text = "$($lang.Refresh): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
		}
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 630
		Width          = 500
		Location       = "15,45"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,8,8,8"
	}

	$UI_Main_DAdv      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 360
		Width          = 490
		Location       = "560,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "0,15,0,0"
	}

	<#
		.Mask: Prerequisite
		.蒙板：先决条件
	#>
	$UI_Main_Import_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
	}

	<#
		.选择规则
	#>
	$UI_Main_Import = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 500
		autoSizeMode   = 0
		autoScroll     = $True
	}

	<#
		.选择规则
	#>
	$UI_Main_Import_Adv = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "15,15,0,0"
		margin         = "0,0,0,30"
		autoScroll     = $False
	}

	<#
		.自动替换语言名称
	#>
	$UI_Main_Replace_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AE_Replace_Name
	}
	$UI_Main_Replace_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		margin         = "26,0,0,40"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null
		}
	}
	
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
		$GetSaveLabelGUID = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue
		$UI_Main_Replace_Custom.Text = "Windows $($GetSaveLabelGUID)"
	} else {
		$UI_Main_Replace_Custom.Text = "Windows 11"
	}

	<#
		.可选功能
	#>

	$UI_Main_Import_Adv_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.AdvOption
	}

	<#
		.不选择未匹配的附加版
	#>
	$UI_Main_Import_Adv_Exclude = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 455
		Padding        = "22,0,0,0"
		Text           = $lang.AE_Is_Auto_Sel_Exclude
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null
		}
	}

	<#
		.显示拖拽界面
	#>
	$UI_Main_Order_UI  = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 505
		autoSizeMode   = 1
		Location       = '550,0'
	}

	<#
		.拖拽顺序
	#>
	$UI_Main_Order_Name = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = "0,15"
		Text           = $lang.DropOrder
	}
	$UI_Main_Order_Rule = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 525
		Width          = 485
		Location       = "15,45"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		AllowDrop      = $True
		Add_DragEnter  = {
			param($sender, $e)
			if ($e.Data.GetDataPresent([Windows.Forms.Button])) {
				$e.Effect = [Windows.Forms.DragDropEffects]::Move
			}
		}
		Add_DragOver   = {
			param($sender, $e)
			$draggedButton = $e.Data.GetData([Windows.Forms.Button])

			# 获取当前鼠标在面板中的坐标
			$clientPoint = $UI_Main_Order_Rule.PointToClient([Windows.Forms.Cursor]::Position)

			# 寻找当前鼠标位置下的控件
			$target = $UI_Main_Order_Rule.GetChildAtPoint($clientPoint)

			if ($target -ne $null -and $target -ne $draggedButton) {
				$targetIndex = $UI_Main_Order_Rule.Controls.GetChildIndex($target)
				# 动态调整控件索引实现实时排序效果
				$UI_Main_Order_Rule.Controls.SetChildIndex($draggedButton, $targetIndex)
			}
		}
	}

	$UI_Main_Order_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "5,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Order_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "30,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}

	$UI_Main_Order_Save = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "10,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Save
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			$Temp_Get_Select_Order = @()
			$UI_Main_Order_Rule.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.Button]) {
					$Temp_Get_Select_Order += $_.Tag
				}
			}

			$NewCustom = @()
			if ($Temp_Get_Select_Order.count -gt 0) {
				$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
				if ($Temp_Additional_Edition.count -gt 0) {
					$UI_Main_Import_Menu.controls.clear()

					foreach ($itemToNew in $Temp_Get_Select_Order) {
						foreach ($itemRule in $Temp_Additional_Edition) {
							if ($itemToNew -eq $itemRule.GUID) {
								$NewCustom += [pscustomobject]@{
									GUID = $itemRule.GUID
									Name = $itemRule.Name
									Requiredversion = $itemRule.Requiredversion
									NewEditionId = $itemRule.NewEditionId
									Productkey = $itemRule.Productkey
									Detailed = @{
										ImageName = $itemRule.Detailed.ImageName
										Description = $itemRule.Detailed.Description
										DisplayName = $itemRule.Detailed.DisplayName
										DisplayDescription = $itemRule.Detailed.DisplayDescription
									}
								}
							
								Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
							}
						}
					}

					New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force

					$UI_Main_Order_UI.visible = $False
					$UI_Main_Import_Error.Text = "$($lang.Save): $($lang.DropOrder), $($lang.Done)"
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				} else {
					$UI_Main_Import_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
					$UI_Main_Import_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					return
				}
			} else {
				$UI_Main_Order_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
				$UI_Main_Order_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
			}
		}
	}
	$UI_Main_Order_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "255,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			$UI_Main_Order_UI.visible = $False
		}
	}

	<#
		.导入
	#>
	$UI_Main_Select_Rule = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "15,15,10,10"
	}

	$UI_Main_Import_Name = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,15"
		Height         = 30
		Width          = 455
		Text           = $lang.Import
	}

	<#
		.蒙板：先决条件，显示菜单
	#>
	$UI_Main_Import_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 490
		Width          = 485
		Location       = "560,45"
		autoSizeMode   = 0
		autoScroll     = $True
	}
	
	$UI_Main_Import_Show_Order = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 437
		Location       = "560,560"
		Text           = $lang.DropOrder
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Order_UI.Visible = $True
		}
	}

	$UI_Main_Import_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Import_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "586,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UI_Main_Import_Import = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Import
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			Image_Additional_Edition_Import_Save
			Refres_Event_Tasks_Image_Additional_Edition
		}
	}
	$UI_Main_Import_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "805,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			$UI_Main_Import_Detailed.visible = $False
			$UI_Main_Exclude.visible = $False
		}
	}

	<#
		.蒙板：排除项
	#>
	$UI_Main_Exclude   = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		visible        = $False
	}

	<#
		.待分配
	#>
	$UI_Main_Wait_Assign = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = "15,15"
		Text           = $lang.AE_ExcludeMount
	}
	$UI_Main_Exclude_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 500
		Location       = '0,55'
		Padding        = "31,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
	}

	<#
		.添加后自动勾选新增项
	#>
	$UI_Main_Functions_AutoSelect = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 485
		Location       = '35,620'
		Text           = $lang.Functions_AutoSelect
		add_Click      = {
			$UI_Main_Exclude_Error.Text = ""
			$UI_Main_Exclude_Error_Icon.Image = $null

			if ($UI_Main_Functions_AutoSelect.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\AE" -name "$(Get_GPS_Location)_Is_Check_Auto_Select" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\AE" -name "$(Get_GPS_Location)_Is_Check_Auto_Select" -value "False"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\AE" -Name "$(Get_GPS_Location)_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\AE" -Name "$(Get_GPS_Location)_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Functions_AutoSelect.Checked = $True
			}
			"False" {
				$UI_Main_Functions_AutoSelect.Checked = $False
			}
		}
	} else {
		$UI_Main_Functions_AutoSelect.Checked = $True
	}

	<#
		.选择函数
	#>
	$UI_Main_Select_Function_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 455
		Text           = $lang.Functions_Running_Order
		Location       = '560,15'
	}
	$UI_Main_Select_Function = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 445
		Width          = 485
		Location       = '560,50'
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
	}
	$UI_Main_Select_Function_Tips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,520"
		Height         = 50
		Width          = 480
		Text           = $lang.AE_ExcludeMountTips
	}

	$UI_Main_Exclude_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Exclude_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "586,600"
		Height         = 30
		Width          = 460
		Text           = ""
	}

	$UI_Main_Exclude_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "805,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			$UI_Main_Exclude.visible = $False
			$UI_Main_Import_Detailed.visible = $False
		}
	}

	<#
		.Mask: Displays the rule details
		.蒙板：显示规则详细信息
	#>
	$UI_Main_Rule_View_Detailed = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1072
		autoSizeMode   = 1
		Padding        = "8,8,8,8"
		Location       = '0,0'
		Visible        = $False
	}
	$UI_Main_Rule_View_Detailed_Show = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 600
		Width          = 1030
		BorderStyle    = 0
		Location       = "15,15"
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UI_Main_Rule_View_Detailed_Hide = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "807,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Hide
		add_Click      = {
			$UI_Main_Rule_View_Detailed.Visible = $False
			$UI_Main_Exclude.visible = $False
		}
	}

	<#
		.显示排除项界面
	#>
	$UI_Main_Exclude_UI = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 460
		Location       = "565,530"
		Text           = $lang.AE_ExcludeMount
		Tag            = $item.GUID
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Exclude.visible = $True
		}
	}

	<#
		.显示导入界面
	#>
	$UI_Main_View_Import_UI = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 460
		Location       = "565,560"
		Text           = $lang.Import
		Tag            = $item.GUID
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Order_Error.Text = ""
			$UI_Main_Order_Error_Icon.Image = $null
			$UI_Main_Import_Error.Text = ""
			$UI_Main_Import_Error_Icon.Image = $null

			$UI_Main_Import_Detailed.visible = $True
		}
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '570,400'
		Text           = $lang.AssignSetting
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Not_Mounted = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Location       = '570,430'
		Text           = $lang.AssignEndNoMount
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			$Global:Queue_Assign_Not_Monuted_Expand_Select = @()
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '570,460'
		Text           = $lang.AssignForceEnd
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 280
		Location       = '570,400'
		Text           = $lang.SuggestedSkip
		add_Click      = {
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True"
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False"
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '586,436'
		Text           = $lang.AssignSetting
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Location       = '586,465'
		Text           = $lang.AssignForceEnd
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "565,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "590,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}

	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 240
		Text           = $lang.EventManagerCurrentClear
		add_Click      = $UI_Main_Event_Clear_Click
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "805,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Save
		add_Click      = {
			if (Image_Additional_Edition_Save) {
			}

			Refres_Event_Tasks_Image_Additional_Edition
		}
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Text           = $lang.Dashboard
	}
	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Padding        = "16,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 465
		Padding        = "32,0,0,0"
		Text           = $lang.EventManagerCurrentClear
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Event_Clear_Click
	}

	$UI_Main_AdvOption = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 468
		margin         = "0,25,0,0"
		Text           = $lang.AdvOption
	}

	<#
		.压缩类型
	#>
	$UI_Main_CompressionType = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Padding        = "16,0,0,0"
		Text           = $lang.CompressionType
	}
	$UI_Main_Capture_Type_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 220
		margin         = "32,0,0,0"
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
		.Healthy
		.健康
	#>
	$UI_Main_Healthy   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 468
		Padding        = "18,0,0,0"
		margin         = "0,25,0,0"
		Text           = $lang.Healthy
		add_Click      = {
			if ($This.Checked) {
				$UI_Main_Healthy_Save.Enabled = $True
			} else {
				$UI_Main_Healthy_Save.Enabled = $False
			}
		}
	}
	$UI_Main_Healthy_Save = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 465
		Padding        = "32,0,0,0"
		Text           = $lang.Healthy_Save
	}

	if ($UI_Main_Healthy.Checked) {
		$UI_Main_Healthy_Save.Enabled = $True
	} else {
		$UI_Main_Healthy_Save.Enabled = $False
	}

	<#
		.允许使用快速抛弃方式
	#>
	$UI_Main_Abandon_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 465
		Padding        = "16,0,0,0"
		Text           = $lang.Abandon_Allow
	}

	<#
		.完成后
	#>
	$UI_Main_After = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 468
		margin		   = "0,25,0,0"
		Text           = $lang.Functions_Rear
	}

		<#
			.重建
		#>
		$UI_Main_Rebuild   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height         = 30
			Width          = 465
			Padding        = "16,0,0,0"
			Text           = $lang.Rebuild
		}

	$UI_Main_After_wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 465
	}

	$UI_Main.controls.AddRange((
		$UI_Main_Rule_View_Detailed,
		$UI_Main_Import_Detailed,
		$UI_Main_Exclude,
		$UI_Main_Menu_Name,
		$UI_Main_Menu,
		$UI_Main_DAdv,
		$UI_Main_Error_Icon,
		$UI_Main_Error,

		$UI_Main_Exclude_UI,
		$UI_Main_View_Import_UI,
		$UI_Main_Event_Clear,
		$UI_Main_Save
	))

	$UI_Main_DAdv.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_AdvOption,
		$UI_Main_CompressionType,
		$UI_Main_Capture_Type_Select,
		$UI_Main_Healthy,
		$UI_Main_Healthy_Save,
		$UI_Main_Abandon_Allow,
		$UI_Main_After,
		$UI_Main_Rebuild,
		$UI_Main_After_wrap
	))

	$UI_Main_Rule_View_Detailed.controls.AddRange((
		$UI_Main_Rule_View_Detailed_Show,
		$UI_Main_Rule_View_Detailed_Hide
	))

	$UI_Main_Exclude.controls.AddRange((
		$UI_Main_Wait_Assign,
		$UI_Main_Exclude_Menu,
		$UI_Main_Functions_AutoSelect,
		$UI_Main_Select_Function_Name,
		$UI_Main_Select_Function,
		$UI_Main_Select_Function_Tips,

		$UI_Main_Exclude_Error_Icon,
		$UI_Main_Exclude_Error,
		$UI_Main_Exclude_Hide
	))

	$UI_Main_Import_Detailed.controls.AddRange((
		$UI_Main_Order_UI,                     # 拖拽 UI
		$UI_Main_Import,
		$UI_Main_Import_Name,
		$UI_Main_Import_Menu,
		$UI_Main_Import_Error,
		$UI_Main_Import_Error_Icon,
		$UI_Main_Import_Show_Order,
		$UI_Main_Import_Import,
		$UI_Main_Import_Hide
	))
	$UI_Main_Import.controls.AddRange((
		$UI_Main_Import_Adv,
		$UI_Main_Select_Rule
	))
	$UI_Main_Import_Adv.controls.AddRange((
		$UI_Main_Replace_Name,
		$UI_Main_Replace_Custom,
		$UI_Main_Import_Adv_Name,
		$UI_Main_Import_Adv_Exclude
	))
	$UI_Main_Order_UI.controls.AddRange((
		$UI_Main_Order_Name,
		$UI_Main_Order_Rule,
		$UI_Main_Order_Save,
		$UI_Main_Order_Hide,
		$UI_Main_Order_Error_Icon,
		$UI_Main_Order_Error
	))

	#region Right
	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select_Rule = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select_Rule.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		$UI_Main_Import_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select_Rule.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		$UI_Main_Import_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Import_Menu.ContextMenuStrip = $UI_Main_Menu_Select_Rule

	$UI_Main_Select_Exclde_Rule = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Select_Exclde_Rule.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Select_Exclde_Rule.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Import_Error.Text = ""
		$UI_Main_Import_Error_Icon.Image = $null

		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_Function.ContextMenuStrip = $UI_Main_Select_Exclde_Rule

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				$_.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Enabled) {
							$_.Checked = $true
						}
					}
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				$_.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Enabled) {
							$_.Checked = $false
						}
					}
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select
	#endregion

	<#
		.Allow automatic activation of the quick discard method
		.允许自动开启快速抛弃方式
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\RAMDisk" -Name "RAMDisk" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_Abandon_Allow.Enabled = $True

				if ((Get-Variable -Scope global -Name "Queue_Eject_Do_Not_Save_Abandon_Allow_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value) {
					$UI_Main_Abandon_Allow.Checked = $True
				} else {
					$UI_Main_Abandon_Allow.Checked = $False
				}
			}
			"False" {
				$UI_Main_Abandon_Allow.Checked = $False
				$UI_Main_Abandon_Allow.Enabled = $False
			}
		}
	} else {
		$UI_Main_Abandon_Allow.Checked = $False
		$UI_Main_Abandon_Allow.Enabled = $False
	}

	$Script:GetEditionID = @()
	$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\wimlib")\wimlib-imagex.exe"
	if (Test-Path -Path $wimlib -PathType Leaf) {
		$RandomGuid = [guid]::NewGuid()
		$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
		$Arguments = "info ""$($Global:Primary_Key_Image.FullPath)"" --extract-xml ""$($Export_To_New_Xml)"""
		Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

		if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
			[XML]$empDetails = Get-Content $Export_To_New_Xml

			ForEach ($empDetail in $empDetails.wim.IMAGE) {
				$Script:GetEditionID += $empDetail.FLAGS
			}
			Remove-Item -Path $Export_To_New_Xml
		}
	} else {
		try {
			Get-WindowsImage -ImagePath $Global:Primary_Key_Image.FullPath -ErrorAction SilentlyContinue | ForEach-Object {
				Get-WindowsImage -ImagePath $Global:Primary_Key_Image.FullPath -index $_.ImageIndex -ErrorAction SilentlyContinue | ForEach-Object {
					$Script:GetEditionID += $_.EditionId
				}
			}
		} catch {
			Write-hsot "$($lang.SelectFileFormatError): $($Global:Primary_Key_Image.FullPath)" -ForegroundColor Red
			return
		}
	}

	foreach ($item in $Global:WindowsEdition) {
		$LinkLabel         = New-Object system.Windows.Forms.LinkLabel -Property @{
			Height         = 45
			Width          = 445
			Text           = $item
			LinkColor      = "#008000"
			ActiveLinkColor = "#FF0000"
			LinkBehavior   = "NeverUnderline"
			add_Click      = {
				$UI_Main_Exclude_Error.Text = ""
				$UI_Main_Exclude_Error_Icon.Image = $null

				$Temp_Get_Select_Function = @()
				$UI_Main_Select_Function.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						$Temp_Get_Select_Function += $_.Text
					}
				}

				if ($Temp_Get_Select_Function -contains $this.Text) {
					$UI_Main_Exclude_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Exclude_Error.Text = "$($lang.Existed): $($This.Text)"
				} else {
					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 40
						Width     = 445
						Text      = $this.Text
						add_Click = {
							$UI_Main_Exclude_Error.Text = ""
							$UI_Main_Exclude_Error_Icon.Image = $null
						}
					}

					if ($UI_Main_Functions_AutoSelect.Checked) {
						$CheckBox.Checked = $True
					}

					$UI_Main_Select_Function.controls.AddRange($CheckBox)

					$UI_Main_Exclude_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
					$UI_Main_Exclude_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
				}
			}
		}

		$UI_Main_Exclude_Menu.controls.AddRange($LinkLabel)
	}

	Refresh_Image_Additional_Edition_Custom_Rule

	<#
		.刷新：已保存所有项，输出到 拖拽顺序界面
	#>
	Refresh_Image_Additional_Edition_To_Order

	<#
		.刷新：已保存所有项，输出到 导出界面
	#>
	Refresh_Image_Additional_Edition_To_Import

	<#
		.刷新：用户已自定义选择，输出到 编辑界面
	#>
	Refresh_Image_Additional_Edition_To_Edit

	<#
		.刷新保存状态
	#>
	Refres_Event_Tasks_Image_Additional_Edition

	$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Additional_Edition.Count -gt 0) {
		$UI_Main_Replace_Custom.Text = $Temp_Additional_Edition.CustomReplace

		if ($Temp_Additional_Edition.Adv.NoSelect) {
			$UI_Main_Import_Adv_Exclude.Checked = $True
		} else {
			$UI_Main_Import_Adv_Exclude.Checked = $False
		}

		<#
			.健康
		#>
			if ($Temp_Additional_Edition.Adv.Healthy.isAllow) {
				$UI_Main_Healthy.Checked = $True
			} else {
				$UI_Main_Healthy.Checked = $False
			}

			if ($Temp_Additional_Edition.Adv.Healthy.ErrorNoSave) {
				$UI_Main_Healthy_Save.Checked = $True
			} else {
				$UI_Main_Healthy_Save.Checked = $False
			}

			if ($UI_Main_Healthy.Checked) {
				$UI_Main_Healthy_Save.Enabled = $True
			} else {
				$UI_Main_Healthy_Save.Enabled = $False
			}

		if ($Temp_Additional_Edition.Adv.Rebuild) {
			$UI_Main_Rebuild.Checked = $True
		} else {
			$UI_Main_Rebuild.Checked = $False
		}

		Refresh_Additional_Edition_CompressionType -Type $Temp_Additional_Edition.Adv.Compression

		<#
			.导入排除项
		#>
		if ($Temp_Additional_Edition.Exclude.count -gt 0) {
			foreach ($item in $Temp_Additional_Edition.Exclude) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 445
					Text      = $item
					Checked   = $True
					add_Click = {
						$UI_Main_Exclude_Error.Text = ""
						$UI_Main_Exclude_Error_Icon.Image = $null
					}
				}

				$UI_Main_Select_Function.controls.AddRange($CheckBox)
			}
		}
	}

	<#
		.有待添加的项目时，自动隐藏界面：导入界面、排除界面
	#>
	$Temp_Additional_Edition = (Get-Variable -Scope global -Name "Queue_Additional_Edition_Rule_$($Global:Primary_Key_Image.Uid)" -ErrorAction SilentlyContinue).Value
	if ($Temp_Additional_Edition.Count -gt 0) {
		$UI_Main_Import_Detailed.visible = $False
		$UI_Main_Exclude.visible = $False
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		$UI_Main_DAdv.Height = 500
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		Write-Host "`n  $($lang.AdditionalEdition)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$UI_Main.controls.AddRange((
			$UI_Main_Suggestion_Manage,
			$UI_Main_Suggestion_Stop_Not_Mounted,
			$UI_Main_Event_Assign_Stop
		))
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		Write-Host "`n  $($lang.AdditionalEdition)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		<#
			.初始化复选框：不再建议
		#>
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
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

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
			if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
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
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		<#
			.导入排除挂载项
		#>
		if ($Autopilot.Exclude.count -gt 0) {
			foreach ($item in $Autopilot.Exclude) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 445
					Text      = $item
					Checked   = $True
					add_Click = {
						$UI_Main_Exclude_Error.Text = ""
						$UI_Main_Exclude_Error_Icon.Image = $null
					}
				}

				$UI_Main_Select_Function.controls.AddRange($CheckBox)
			}
		}

		<#
			.不选择未匹配的附加版
		#>
		if ($Autopilot.NoSelMatch) {
			$UI_Main_Import_Adv_Exclude.Checked = $True
		} else {
			$UI_Main_Import_Adv_Exclude.Checked = $False
		}

		<#
			.允许使用快速抛弃方式
		#>
		if ($Autopilot.AbandonAllow) {
			$UI_Main_Abandon_Allow.Checked = $True
		} else {
			$UI_Main_Abandon_Allow.Checked = $False
		}

		<#
			.自动替换语言名称
		#>
		$UI_Main_Replace_Custom.Text = $Autopilot.CustomReplace

		<#
			.健康
		#>
			if ($Autopilot.Healthy.isAllow) {
				$UI_Main_Healthy.Checked = $True
			} else {
				$UI_Main_Healthy.Checked = $False
			}

			if ($Autopilot.Healthy.ErrorNoSave) {
				$UI_Main_Healthy_Save.Checked = $True
			} else {
				$UI_Main_Healthy_Save.Checked = $False
			}

			if ($UI_Main_Healthy.Checked) {
				$UI_Main_Healthy_Save.Enabled = $True
			} else {
				$UI_Main_Healthy_Save.Enabled = $False
			}

		<#
			.重建
		#>
		if ($Autopilot.Rebuild) {
			$UI_Main_Rebuild.Checked = $True
		} else {
			$UI_Main_Rebuild.Checked = $False
		}

		<#
			.压缩类型
		#>
		Refresh_Additional_Edition_CompressionType -Type $Autopilot.Compression

		<#
			.导入到所有菜单
		#>
		switch ($Autopilot.Schome) {
			"Import" {
				Autopoliot_Additional_Edition_Import -Guid $Autopilot.Import.Guid -Schome $Autopilot.Import.Schome

				<#
					.将已保存的保存到 用户选择界面
				#>
				Image_Additional_Edition_Import_Save

				<#
					.刷新：已保存所有项，输出到 导出界面
				#>
				Refresh_Image_Additional_Edition_To_Import
			}
			"Custom" {
				$IsFunction = @{
					Healthy = @{
						isAllow     = $UI_Main_Healthy.Checked
						ErrorNoSave = $UI_Main_Healthy_Save.Checked
					}
					NoSelect = $UI_Main_Import_Adv_Exclude.Checked
					Rebuild = $UI_Main_Rebuild.Checked
					Compression = $UI_Main_Capture_Type_Select.SelectedItem.CompressionType
				}

				if ($Autopilot.Custom.$($Autopilot.Custom.Schome).Count -gt 0) {
					[PSCustomObject]$NewCustom = @()

					foreach ($itemRule in $Autopilot.Custom.$($Autopilot.Custom.Schome)) {
						$NewCustom += [pscustomobject]@{
							GUID = $itemRule.GUID
							Name = $itemRule.Name
							Requiredversion = $itemRule.Requiredversion
							NewEditionId = $itemRule.NewEditionId
							Productkey = $itemRule.Productkey
							Detailed = @{
								ImageName = $itemRule.Detailed.ImageName
								Description = $itemRule.Detailed.Description
								DisplayName = $itemRule.Detailed.DisplayName
								DisplayDescription = $itemRule.Detailed.DisplayDescription
							}
						}

						Image_Additional_Edition_Addto_OrderUI -GUID $itemRule.GUID -Name $itemRule.Name -NewEditionId $itemRule.NewEditionId
						Image_Additional_Edition_AddTo_ImportUI -GUID $itemRule.GUID -Name $itemRule.Name -Requiredversion $itemRule.Requiredversion -NewEditionId $itemRule.NewEditionId -Productkey $itemRule.Productkey -NewImageName $itemRule.Detailed.ImageName -NewDescription $itemRule.Detailed.Description -NewDisplayName $itemRule.Detailed.DisplayName -NewDisplayDescription $itemRule.Detailed.DisplayDescription
					}

					New-Variable -Scope global -Name "Queue_Additional_Edition_$($Global:Primary_Key_Image.Uid)" -Value $NewCustom -Force
				}

				<#
					.将已保存的保存到 用户选择界面
				#>
				Image_Additional_Edition_Import_Save

				<#
					.刷新：已保存所有项，输出到 导出界面
				#>
				Refresh_Image_Additional_Edition_To_Import
			}
		}

		if (Image_Additional_Edition_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.NoChoose) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}