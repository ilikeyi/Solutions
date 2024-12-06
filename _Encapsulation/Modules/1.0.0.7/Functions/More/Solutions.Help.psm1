<#
	.Help
	.帮助
#>
Function Solutions_Help
{
	Clear-Host
	Logo -Title $lang.Help

	Write-Host "   $($lang.Short_Cmd)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "     FX *".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SpecialFunction): $($lang.Function_Unrestricted), $($lang.Short_Cmd)" -NoNewline
	Write-Host " { FX Pause } { FX List }" -ForegroundColor Green

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
}

Function Solutions_Help_Command
{
	param
	(
		$Name
	)

	Write-Host "`n   $($lang.Help) *" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	switch ($Name) {
		"FX" {
			Write-Host "   $($lang.Command): " -NoNewline
			Write-host "FX *" -ForegroundColor Green

			Get_Next
		}
		default {
			Write-Host "   $($lang.NoWork)" -ForegroundColor Red
		}
	}
}