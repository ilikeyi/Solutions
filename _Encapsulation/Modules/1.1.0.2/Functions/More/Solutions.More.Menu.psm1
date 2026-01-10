<#
	.Help
	.帮助
#>
Function Solutions_Menu_Shortcut
{
	Write-Host
	Write-host "  $($lang.Shortcut)"
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.SelectSettingImage): " -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.Mount) " -NoNewline -ForegroundColor Green
	Write-Host " MT * "-BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  $($lang.Mounted_Status): " -NoNewline -ForegroundColor Yellow
	if (Image_Is_Select_IAB) {
		if (Verify_Is_Current_Same) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Se * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host " -Dns " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", "

			Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
		} else {
			if (Image_Is_Mount) {
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " Se * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

				Write-Host " -Dns " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host ", "

				Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
				Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
				Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
				Write-Host ", " -NoNewline

				Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
				Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
				Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
			} else {
				Write-Host "$($lang.NotMounted) " -ForegroundColor Red
			}
		}
	} else {
		if (Image_Is_Mount) {
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " Se * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

			Write-Host " -Dns " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.UnmountAndSave) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " Unmt * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", "

			Write-Host "  $($lang.Image_Unmount_After): " -NoNewline -ForegroundColor Yellow
			Write-Host "$($lang.Save) " -NoNewline -ForegroundColor Green
			Write-Host " ESE " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host ", " -NoNewline

			Write-Host "$($lang.DoNotSave) " -NoNewline -ForegroundColor Green
			Write-Host " EDNS " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
			Write-Host " -Q " -BackgroundColor White -ForegroundColor Black
		} else {
			Write-Host "$($lang.NotMounted) " -ForegroundColor Red
		}
	}
}

Function Solutions_Input_Menu
{
	param (
		[switch]$PS
	)

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.RefreshModules) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " R'R " -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor Green -ForegroundColor Black

	if ($ps) {
		Write-Host " PS * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host ": " -NoNewline
}