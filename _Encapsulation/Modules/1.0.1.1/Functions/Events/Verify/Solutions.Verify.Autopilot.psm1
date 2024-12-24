Function Verify_Autopilot_Custom_File
{
	$Error_Autopilot_File = @()

	Write-Host "`n  $($lang.Wim_Rule_Verify): $($lang.Autopilot_Select_Config)"
	Write-Host "  $('-' * 80)"

	$test_autopilot_Config_Folder = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..") -ChildPath "_Autopilot" -ErrorAction SilentlyContinue
	if (Test-Path -Path $test_autopilot_Config_Folder -PathType Container) {
		Get-ChildItem -Path $test_autopilot_Config_Folder -Recurse -Include *.json -ErrorAction SilentlyContinue | ForEach-Object {
			$MainFolderFullname = $_.FullName
			Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
			Write-Host $MainFolderFullname -ForegroundColor Green

			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.Wim_Rule_Verify): " -NoNewline
			try {
				$Autopilot = Get-Content -Raw -Path $MainFolderFullname | ConvertFrom-Json
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			} catch {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
				$Error_Autopilot_File += $MainFolderFullname
			}

			Write-Host
		}

		Write-Host "  $($lang.SelectFromError): $($Error_Autopilot_File.Count) $($lang.EventManagerCount)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ($Error_Autopilot_File.count -gt 0) {
			foreach ($item in $Error_Autopilot_File) {
				Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
				Write-Host $item -ForegroundColor Red
			}

			Get_Next
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Green
		}
	} else {
		Write-Host "  $($lang.NoInstallImage)"
		Write-Host "  $($test_autopilot_Config_Folder)" -ForegroundColor Red
	}
}