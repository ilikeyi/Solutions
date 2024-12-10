
<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function Solutions_API_Command
{
	param
	(
		$Name
	)

	switch ($Name) {
		"List" {
			$GetALlName = @()
			Get-ChildItem -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Import" -ErrorAction SilentlyContinue | ForEach-Object {
				$GetALlName += $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
			}

			if ($GetALlName.Count -gt 0) {
				ForEach ($item in $GetALlName) {
					Write-Host "   $($item)" -ForegroundColor Green
				}
			} else {
				Write-Host "`n   $($lang.NoWork)" -ForegroundColor Red
			}

			Get_Next
		}
		"Help" {
			Solutions_API_Help
		}
		"Set" {
			Image_Select -Page "API"
		}
		default {
			Write-Host "   $($lang.RuleName): " -NoNewline -ForegroundColor Yellow
			Write-Host $Name -ForegroundColor Green

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Import\$($Name)" -Name "Path" -ErrorAction SilentlyContinue) {
				$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Import\$($Name)" -Name "Path"

				Write-Host "   $($lang.Filename): " -NoNewline -ForegroundColor Yellow
				
				If ([String]::IsNullOrEmpty($GetImportFileName)) {
					Write-Host "$($lang.Select_Path), $($lang.UpdateUnavailable)" -BackgroundColor DarkRed -ForegroundColor White
				} else {
					Write-Host $GetImportFileName -ForegroundColor Green

					Write-Host "   $($lang.LanguageExtractAddTo): " -NoNewline

					if (Test-Path -Path $GetImportFileName -PathType leaf) {
						Write-Host $lang.UpdateAvailable -BackgroundColor DarkGreen -ForegroundColor White
						Write-Host "   $('-' * 80)"

						Import-Module -Name $GetImportFileName -Scope Global -Force | Out-Null

						Write-Host
						Write-Host "   $('-' * 80)"
						Write-Host "   $($lang.Filename): " -NoNewline -ForegroundColor Yellow
						Write-Host $GetImportFileName -ForegroundColor Green
						Write-Host "   $($lang.Running): " -NoNewline -ForegroundColor Yellow
						Write-Host $lang.Done -BackgroundColor DarkGreen -ForegroundColor White

						Get_Next
					} else {
						Write-Host $lang.NoInstallImage -BackgroundColor DarkRed -ForegroundColor White
					}
				}
			} else {
				Write-Host "   $($lang.NoWork)" -ForegroundColor Red
			}
		}
	}
}

<#
	.API Help
	.API 帮助
#>
Function Solutions_API_Help
{
	param
	(
		$Name
	)

	Write-host "   Using:"

	Get_Next
}