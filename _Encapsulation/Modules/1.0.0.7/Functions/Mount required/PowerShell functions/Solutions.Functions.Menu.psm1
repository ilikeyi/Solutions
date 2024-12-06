<#
	.Menu: Running PowerShell Functions
	.菜单：运行 PowerShell 函数
#>
Function Functions_Menu
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.SpecialFunction
		Write-Host "   $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		Write-Host "   $($lang.MountImageTo): " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host $Global:Mount_To_Route -ForegroundColor Yellow
		}

		Write-Host "   $($lang.MainImageFolder): " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Red
			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.NoInstallImage)" -ForegroundColor Red

			ToWait -wait 2
			Functions_Menu
		}

		Image_Get_Mount_Status
	}

	Write-Host "`n   $($lang.SpecialFunction)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "      1   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Before -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Before -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Before -ForegroundColor Red
	}

	Write-Host "      2   " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host $lang.Functions_Rear -ForegroundColor Green
		} else {
			Write-Host $lang.Functions_Rear -ForegroundColor Red
		}
	} else {
		Write-Host $lang.Functions_Rear -ForegroundColor Red
	}


	Write-Host "`n      F   " -NoNewline -ForegroundColor Yellow
	Write-Host $lang.Function_Unrestricted -ForegroundColor Green

	switch (Read-Host "`n   $($lang.PleaseChoose)")
	{
		'1' {
			Functions_Menu_Shortcuts_PFB
			ToWait -wait 2
			Functions_Menu
		}
		'2' {
			Functions_Menu_Shortcuts_PFA
			ToWait -wait 2
			Functions_Menu
		}
		'F' {
			Functions_Unrestricted_UI
			ToWait -wait 2
			Functions_Menu
		}
		default {
			Mainpage
		}
	}
}

Function Functions_Menu_Shortcuts_PFB
{
	Write-Host "`n   $($lang.SpecialFunction): $($lang.Functions_Before)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green
			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Functions_Before_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}

Function Functions_Menu_Shortcuts_PFA
{
	Write-Host "`n   $($lang.SpecialFunction): $($lang.Functions_Rear)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	if (Image_Is_Select_IAB) {
		Write-Host "   $($lang.Mounted_Status)" -ForegroundColor Yellow
		Write-Host "   $('-' * 80)"

		if (Verify_Is_Current_Same) {
			Write-Host "   $($lang.Mounted)" -ForegroundColor Green
			<#
				.Assign available tasks
				.分配可用的任务
			#>
			Event_Assign -Rule "Functions_Rear_UI" -Run
		} else {
			Write-Host "   $($lang.NotMounted)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.IABSelectNo)" -ForegroundColor Red
	}
}