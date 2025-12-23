<#
	.API
#>
Function Api_Create_Template
{
	param
	(
		$NewFile
	)

	$ThisFileType = $([System.IO.Path]::GetExtension($NewFile))
	switch -WildCard ($ThisFileType) {
		".psd1" {
			$RandomGuid = [guid]::NewGuid()
			$NewPsmFile = [System.IO.Path]::GetFileNameWithoutExtension($NewFile)
			$NewPsFile = "$([System.IO.Path]::GetDirectoryName($NewFile))\$($NewPsmFile).psm1"
@"
@{
	RootModule        = '$($NewPsmFile).psm1'
	ModuleVersion     = '1.0.0.0'
	GUID              = '$($RandomGuid)'
	Author            = ''
	Copyright         = ''
	Description       = ''
	PowerShellVersion = '5.1'
	NestedModules     = @()
	FunctionsToExport = '*'
	CmdletsToExport   = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'

	PrivateData = @{
		PSData = @{
			# Tags = @()
			LicenseUri   = ''
			ProjectUri   = ''
#			IconUri      = ''
#			ReleaseNotes = ''
		}
	}
	HelpInfoURI = ''
#	DefaultCommandPrefix = ''
}
"@ | Out-File -FilePath $NewFile -Encoding utf8 -ErrorAction SilentlyContinue

@"
Write-Host "  Test $($RandomGuid)"
"@ | Out-File -FilePath $NewPsFile -Encoding utf8 -ErrorAction SilentlyContinue
		}
		default {
@"
Write-Host "  Test"
"@ | Out-File -FilePath $NewFile -Encoding utf8 -ErrorAction SilentlyContinue
		}
	}
}

Function Solutions_API_Command
{
	param
	(
		$Name
	)

	switch ($Name) {
		"List" {
			$GetALlName = @()
			Get-ChildItem -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Custom" -ErrorAction SilentlyContinue | ForEach-Object {
				<#
					.捕捉路径
				#>
				$GetNewPath = $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue) {
					$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue
				} else {
					$GetImportFileName = ""
				}

				$GetALlName += @{
					Name = $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
					Path = $GetImportFileName
				}
			}

			if ($GetALlName.Count -gt 0) {
				ForEach ($item in $GetALlName) {
					Write-Host "  $($lang.Short_Cmd): " -NoNewline
					Write-Host " API $($item.Name) " -BackgroundColor DarkMagenta -ForegroundColor White

					Write-Host "  $($lang.RuleName): " -NoNewline
					Write-Host $item.Name -ForegroundColor Green

					Write-Host "  $($lang.Select_Path): " -NoNewline
					Write-Host $item.Path -ForegroundColor Green

					Write-Host
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
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
			Write-Host "  $($lang.RuleName): " -NoNewline -ForegroundColor Yellow
			Write-Host $Name -ForegroundColor Green

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Custom\$($Name)" -Name "Path" -ErrorAction SilentlyContinue) {
				$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\API\Custom\$($Name)" -Name "Path" -ErrorAction SilentlyContinue

				Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
				
				If ([String]::IsNullOrEmpty($GetImportFileName)) {
					Write-Host "$($lang.Select_Path), $($lang.UpdateUnavailable)" -BackgroundColor DarkRed -ForegroundColor White
				} else {
					Write-Host $GetImportFileName -ForegroundColor Green

					Write-Host "  $($lang.LanguageExtractAddTo): " -NoNewline

					if (Test-Path -Path $GetImportFileName -PathType leaf) {
						Write-Host $lang.UpdateAvailable -BackgroundColor DarkGreen -ForegroundColor White
						Write-Host "  $('-' * 80)"

						Import-Module -Name $GetImportFileName -Scope Global -Force | Out-Null

						Write-Host
						Write-Host "  $('-' * 80)"
						Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
						Write-Host $GetImportFileName -ForegroundColor Green

						Write-Host "  " -NoNewline
						Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

						Get_Next
					} else {
						Write-Host $lang.NoInstallImage -BackgroundColor DarkRed -ForegroundColor White
					}
				}
			} else {
				Write-Host "  $($lang.NoWork)" -ForegroundColor Red
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

	Write-Host "`n  $($lang.API)"
	Write-Host "  $('-' * 80)"
	write-host "  " -NoNewline
	Write-host " API Set " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "  $($lang.Setting), $($lang.API)"

	write-host
	write-host "  " -NoNewline
	Write-host " API List " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host " $($lang.Command)"

	write-host
	write-host "  " -NoNewline
	Write-host " API * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "    $($lang.Running), $($lang.RuleName)"
	Write-host "             API Yi" -ForegroundColor Green

	Get_Next
}