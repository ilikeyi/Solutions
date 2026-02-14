<#
	.To rebuild the image, please use ReBuild.wim as a temporary file, and the file cannot exist under any circumstances.
	.重建映像，临时文件一定请使用 ReBuild.wim，不管任何情况下，该文件都不能存在。
#>
Function Rebuild_Image_File
{
	param
	(
		$Filename
	)

	$RandomGuid = [guid]::NewGuid()

	Write-Host "`n  $($lang.Rebuilding)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Write-Host "  $($Filename)`n" -ForegroundColor Green
	if (Test-Path -Path $Filename -PathType Leaf) {
		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($Filename)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		Write-Host "  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Get-WindowsImage -ImagePath $Filename -ErrorAction SilentlyContinue | ForEach-Object {
			Write-Host "  $($lang.MountedIndex): " -NoNewline
			Write-Host $_.ImageIndex -ForegroundColor Yellow

			Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
			Write-Host $_.ImageName -ForegroundColor Yellow

			Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
			Write-Host $_.ImageDescription -ForegroundColor Yellow

			Write-Host
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		$Save_To_Temp_Folder_Path = Get_Mount_To_Temp

		Get-WindowsImage -ImagePath $Filename -ErrorAction SilentlyContinue | ForEach-Object {
			Write-Host "  $($lang.MountedIndex): " -NoNewline
			Write-Host $_.ImageIndex -ForegroundColor Yellow

			Write-Host "  $($lang.Wim_Image_Name): " -NoNewline
			Write-Host $_.ImageName -ForegroundColor Yellow

			Write-Host "  $($lang.Wim_Image_Description): " -NoNewline
			Write-Host $_.ImageDescription -ForegroundColor Yellow

			if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
				Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
				Write-Host "  $('-' * 80)"
				Write-Host "  Export-WindowsImage -SourceImagePath ""$($Filename)"" -SourceIndex ""$($_.ImageIndex)"" -DestinationImagePath ""$($Save_To_Temp_Folder_Path)\$($RandomGuid).wim"" -CompressionType Max" -ForegroundColor Green
				Write-Host "  $('-' * 80)"
			}

			Write-Host
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Rebuilding) " -NoNewline -BackgroundColor White -ForegroundColor Black
			try {
				Export-WindowsImage -ScratchDirectory "$(Get_Mount_To_Temp)" -LogPath "$(Get_Mount_To_Logs)\Export.log" -SourceImagePath $Filename -SourceIndex $_.ImageIndex -DestinationImagePath "$($Save_To_Temp_Folder_Path)\$($RandomGuid).wim" -CompressionType Max -ErrorAction SilentlyContinue | Out-Null	
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			} catch {
				Write-Host $lang.ConvertChk
				Write-Host "  $($Filename)"
				Write-Host "  $($_)" -ForegroundColor Red
				Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			Write-Host
		}

		if (Test-Path -Path "$($Save_To_Temp_Folder_Path)\$($RandomGuid).wim" -PathType Leaf) {
			Remove-Item -Path $Filename -ErrorAction SilentlyContinue
			Move-Item -Path "$($Save_To_Temp_Folder_Path)\$($RandomGuid).wim" -Destination $Filename -ErrorAction SilentlyContinue

			if (Test-Path -Path $Filename -PathType Leaf) {
				Write-Host "  $($lang.Done)" -ForegroundColor Green
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.NoInstallImage)"
		Write-Host "  $($Filename)" -ForegroundColor Red
	}
}