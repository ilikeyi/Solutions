Function API_Unrestricted_UI
{
	param
	(
		[String[]]$Custom
	)

	Write-Host "`n  $($lang.API): $($lang.Function_Unrestricted)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refresh_API_Unrestricated_UI
	{
		$UI_Main_Menu.controls.Clear()

		$API_Function_Tasks = @()
		Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom" -ErrorAction SilentlyContinue | ForEach-Object {
			$API_Function_Tasks += $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
		}

		if ($API_Function_Tasks.Count -gt 0) {
			foreach ($item in $API_Function_Tasks) {
				$LinkLabel          = New-Object system.Windows.Forms.LinkLabel -Property @{
					Height         = 30
					Width          = 445
					Text           = $item
					LinkColor      = "#008000"
					ActiveLinkColor = "#FF0000"
					LinkBehavior   = "NeverUnderline"
					add_Click      = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						if ($UI_Main_API_Duplicate.Checked) {
							$Temp_Get_Select_Function = @()
							$UI_Main_Select_Function.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.CheckBox]) {
									$Temp_Get_Select_Function += $_.Text
								}
							}

							if ($Temp_Get_Select_Function -contains $this.Text) {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.Existed): $($This.Text)"
							} else {
								$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
									Height    = 40
									Width     = 445
									Text      = $this.Text
									add_Click = {
										$UI_Main_Error.Text = ""
										$UI_Main_Error_Icon.Image = $null
									}
								}

								if ($UI_Main_API_AutoSelect.Checked) {
									$CheckBox.Checked = $True
								}

								$UI_Main_Select_Function.controls.AddRange($CheckBox)

								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\..\Assets\icon\Success.ico")
								$UI_Main_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
							}
						} else {
							$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
								Height    = 40
								Width     = 445
								Text      = $this.Text
								add_Click = {
									$UI_Main_Error.Text = ""
									$UI_Main_Error_Icon.Image = $null
								}
							}

							if ($UI_Main_API_AutoSelect.Checked) {
								$CheckBox.Checked = $True
							}

							$UI_Main_Select_Function.controls.AddRange($CheckBox)

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\..\Assets\icon\Success.ico")
							$UI_Main_Error.Text = "$($lang.AddTo): $($This.Text), $($lang.Done)"
						}
					}
				}

				$LinkLabel_Wrap = New-Object system.Windows.Forms.Label -Property @{
					Height         = 15
					Width          = 445
				}

				$UI_Main_Menu.controls.AddRange((
					$LinkLabel,
					$LinkLabel_Wrap
				))
			}
		}

	}

	Function Custom_API_Unrestricted_UI_Save
	{
		<#
			.Reset selected
			.重置已选择
		#>
		$Global:API_Unrestricted = @()

		<#
			.Mark: Check the selection status
			.标记：检查选择状态
		#>
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Global:API_Unrestricted += $_.Text
					}
				}
			}
		}

		if ($Global:API_Unrestricted.Count -gt 0) {
			return $True
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
			return $False
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = "$($lang.API): $($lang.Function_Unrestricted)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}

	<#
		.待分配
	#>
	$UI_Main_Wait_Assign = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 485
		Location       = "15,15"
		Text           = $lang.LXPsWaitAssign
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			Refresh_API_Unrestricated_UI

			$UI_Main_Error.Text = "$($lang.Refresh): $($lang.Done)"
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\..\Assets\icon\Success.ico")
		}
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 435
		Width          = 500
		Location       = '0,55'
		Padding        = "31,0,0,0"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
	}

	<#
		.可选功能
	#>
	$UI_Main_Adv       = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = '15,525'
		Text           = $lang.AdvOption
	}

	<#
		.有重复时不再添加
	#>
	$UI_Main_API_Duplicate = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 485
		Location       = '35,555'
		Text           = $lang.Functions_Duplicate
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_API_Duplicate.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -name "Now_Is_Check_Duplicate" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -name "Now_Is_Check_Duplicate" -value "False"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -Name "Now_Is_Check_Duplicate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -Name "Now_Is_Check_Duplicate" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_API_Duplicate.Checked = $True
			}
			"False" {
				$UI_Main_API_Duplicate.Checked = $False
			}
		}
	} else {
		$UI_Main_API_Duplicate.Checked = $True
	}

	<#
		.添加后自动勾选新增项
	#>
	$UI_Main_API_AutoSelect = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 35
		Width          = 485
		Location       = '35,585'
		Text           = $lang.Functions_AutoSelect
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_API_AutoSelect.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -name "Now_Is_Check_Auto_Select" -value "True"
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -name "Now_Is_Check_Auto_Select" -value "False"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -Name "Now_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\API" -Name "Now_Is_Check_Auto_Select" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Main_API_AutoSelect.Checked = $True
			}
			"False" {
				$UI_Main_API_AutoSelect.Checked = $False
			}
		}
	} else {
		$UI_Main_API_AutoSelect.Checked = $True
	}

	$UI_Main_Setting_API = New-Object system.Windows.Forms.LinkLabel -Property @{
		Location       = "35,630"
		Height         = 35
		Width          = 480
		Text           = "$($lang.Setting): $($lang.API)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			Image_Select -Page "API"
			Refresh_API_Unrestricated_UI
		}
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
		Height         = 525
		Width          = 485
		Location       = '560,50'
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
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
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 240
		Text           = $lang.OK
		add_Click      = {
			if (Custom_API_Unrestricted_UI_Save) {
				$UI_Main.Hide()
				API_Unrestricted_Process_Tasks
				$UI_Main.Close()
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "807,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$Global:API_Unrestricted = @()

			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Select_Function_Name,
		$UI_Main_Select_Function,
		$UI_Main_Wait_Assign,
		$UI_Main_Menu,
		$UI_Main_Adv,
		$UI_Main_API_Duplicate,
		$UI_Main_API_AutoSelect,
		$UI_Main_Setting_API,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	Refresh_API_Unrestricated_UI

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Select_Function.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Select_Function.ContextMenuStrip = $UI_Main_Menu_Select

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Custom) {
		Write-Host "  $($lang.RuleCustomize)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$Custom = $Custom -split ';'

		foreach ($item in $Custom) {
			if ($API_Function_Tasks -contains "Other_Tasks_$($item)") {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 445
					Text      = "Other_Tasks_$($item)"
					Checked   = $True
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				$UI_Main_Select_Function.controls.AddRange($CheckBox)
			}
		}

		if (Custom_API_Unrestricted_UI_Save) {
			API_Unrestricted_Process_Tasks
		} else {
			$UI_Main_Error.Text = "$($lang.AddTo): $($Custom), $($lang.Failed)"
			$UI_Main.ShowDialog() | Out-Null
		}

		return
	}

	$UI_Main.ShowDialog() | Out-Null
}

Function API_Unrestricted_Process_Tasks
{
	$Host.UI.RawUI.WindowTitle = "$($lang.API): $($lang.Function_Unrestricted)"
	if ($Global:API_Unrestricted.Count -gt 0) {
		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Global:API_Unrestricted) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		[int]$SNTasks = "0"
		ForEach ($item in $Global:API_Unrestricted) {
			$TasksFXTimeStart = Get-Date -Format "yyyy/MM/dd HH:mm:ss tt"
			$TasksFXTime = New-Object System.Diagnostics.Stopwatch
			$TasksFXTime.Reset()
			$TasksFXTime.Start()
			$SNTasks++

			Write-Host "  $($lang.TimeStart)" -NoNewline
			Write-Host " $($TasksFXTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Green
			Write-Host "  $('-' * 80)"
			Write-host "  $($lang.EventManager): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($SNTasks)/$($Global:API_Unrestricted.Count)" -NoNewline -ForegroundColor Green
			Write-host " $($lang.EventManagerCount)"

			API_Process_Rule_Name -RuleName $item

			$TasksFXTime.Stop()
			Write-Host "`n  $($lang.Running): $($item), $($lang.Done)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.TimeStart)" -NoNewline
			Write-Host "$($TasksFXTimeStart -f "yyyy/MM/dd HH:mm:ss tt")" -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEnd)" -NoNewline
			Write-Host $(Get-Date -Format "yyyy/MM/dd HH:mm:ss tt") -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAll)" -NoNewline
			Write-Host "$($TasksFXTime.Elapsed)" -ForegroundColor Yellow

			Write-Host "  $($lang.TimeEndAllseconds)" -NoNewline
			Write-Host "$($TasksFXTime.ElapsedMilliseconds) $($lang.TimeMillisecond)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}