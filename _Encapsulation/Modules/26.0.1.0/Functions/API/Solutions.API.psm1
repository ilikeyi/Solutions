<#
	.API
#>
Function Api_Create_Template
{
	param
	(
		[ValidateSet("Mini", "Update")]
		[string]$Type = "Mini",
		$NewFile
	)

	$PropertyType = switch ($Type) {
		"Update" { "Update" }
		Default { "Mini" }
	}

	$RandomGuid = [guid]::NewGuid()
	$ThisFileType = $([System.IO.Path]::GetExtension($NewFile))
	switch -WildCard ($ThisFileType) {
		".psd1" {
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

	switch ($PropertyType) {
		"Update" {
@"
Write-Host "fengyi.tel" -ForegroundColor Cyan
`$winscpPath = "${env:ProgramFiles(x86)}\WinSCP\WinSCP.com" 

`$commands = @(
	"option batch continue",
	"option confirm off",
	"open root@fengyi.tel"
)

`$filesToUpload = @(
	@{ Command = "put"; Local = "D:\_Site\sha.sh"; Remote = "/Yi/" }
	@{ Command = "put"; Local = "D:\_Site\git.sh"; Remote = "/Yi/" }
)

foreach (`$item in `$filesToUpload) {
	if (Test-Path `$item.Local) {
		`$commands += "`$(`$item.Command) `$(`$item.Local) `$(`$item.Remote)"
	} else {
		Write-Warning "The local file does not exist; skipping upload: `$(`$item.Local)"
	}
}

# Add subsequent execution instructions.
`$commands += "call bash /Yi/git.sh"
`$commands += "exit"

& `$winscpPath /command `$commands

Start-Sleep -Seconds 10
"@ | Out-File -FilePath $NewPsFile -Encoding utf8 -ErrorAction SilentlyContinue
		}
		default {
@"
Write-Host "  Test $($NewPsmFile).psm1 $($RandomGuid)"
"@ | Out-File -FilePath $NewPsFile -Encoding utf8 -ErrorAction SilentlyContinue
		}
	}

		}
		default {
			switch ($PropertyType) {
				"Update" {
@"
Write-Host "fengyi.tel" -ForegroundColor Cyan
`$winscpPath = "${env:ProgramFiles(x86)}\WinSCP\WinSCP.com" 

`$commands = @(
	"option batch continue",
	"option confirm off",
	"open root@fengyi.tel"
)

`$filesToUpload = @(
	@{ Command = "put"; Local = "D:\_Site\sha.sh"; Remote = "/Yi/" }
	@{ Command = "put"; Local = "D:\_Site\git.sh"; Remote = "/Yi/" }
)

foreach (`$item in `$filesToUpload) {
	if (Test-Path `$item.Local) {
		`$commands += "`$(`$item.Command) `$(`$item.Local) `$(`$item.Remote)"
	} else {
		Write-Warning "The local file does not exist; skipping upload: `$(`$item.Local)"
	}
}

# Add subsequent execution instructions.
`$commands += "call bash /Yi/git.sh"
`$commands += "exit"

& `$winscpPath /command `$commands

Start-Sleep -Seconds 10
"@ | Out-File -FilePath $NewFile -Encoding utf8 -ErrorAction SilentlyContinue
				}
				default {
@"
Write-Host "  Test $($NewFile) $($RandomGuid)"
"@ | Out-File -FilePath $NewFile -Encoding utf8 -ErrorAction SilentlyContinue
				}
			}

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
			Get-ChildItem -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom" -ErrorAction SilentlyContinue | ForEach-Object {
				<#
					.捕捉路径
				#>
				$GetNewPath = $([System.IO.Path]::GetFileNameWithoutExtension($_.Name))

				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue) {
					$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($GetNewPath)" -Name "Path" -ErrorAction SilentlyContinue
				} else {
					$GetImportFileName = ""
				}

				$GetALlName += [pscustomobject]@{
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

			Get_Next -DevCode "g1"
		}
		"Help" {
			Solutions_API_Help
		}
		"Set" {
			Image_Select -Page "API"
		}
		"A" {
			API_Menu_Shortcuts_PFB
		}
		"B" {
			API_Menu_Shortcuts_PFA
		}
		default {
			API_Process_Rule_Name -RuleName $Name
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
	Write-host " API B " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "    $($lang.Functions_Before)"

	write-host
	write-host "  " -NoNewline
	Write-host " API A " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "    $($lang.Functions_Rear)"

	write-host
	write-host "  " -NoNewline
	Write-host " API * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-host "    $($lang.Running), $($lang.RuleName)"
	Write-host "             API Yi" -ForegroundColor Green

	Get_Next -DevCode "g2"
}

Function API_Process_Rule_Name
{
	param (
		$RuleName
	)
	
	Write-Host "  $($lang.RuleName): " -NoNewline -ForegroundColor Yellow
	Write-Host $RuleName -ForegroundColor Green

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($RuleName)" -Name "Path" -ErrorAction SilentlyContinue) {
		$GetImportFileName = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($RuleName)" -Name "Path" -ErrorAction SilentlyContinue

		Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		
		If ([String]::IsNullOrEmpty($GetImportFileName)) {
			Write-Host "$($lang.Select_Path), $($lang.UpdateUnavailable)" -BackgroundColor DarkRed -ForegroundColor White
		} else {
			Write-Host $GetImportFileName -ForegroundColor Green

			write-host
			write-host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (Test-Path -Path $GetImportFileName -PathType leaf) {
				Write-Host " $($lang.UpdateAvailable) " -BackgroundColor DarkGreen -ForegroundColor White

				Write-Host "`n  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
				Write-Host $GetImportFileName -ForegroundColor Green
				Write-Host "  $('-' * 80)"

				$RunRule = $True
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($RuleName)" -Name "NoImport" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions\API\Custom\$($RuleName)" -Name "NoImport" -ErrorAction SilentlyContinue) {
						"True" { $RunRule = $False }
					}
				}

				Write-Host "  $($lang.RuleNoImport)" -ForegroundColor Yellow

				if ($RunRule) {
					write-host "  $($lang.Enable)" -ForegroundColor Green

					Write-Host
					Write-Host "  " -NoNewline
					Write-Host " $($lang.Running) " -BackgroundColor White -ForegroundColor Black
					Write-Host "  $('-' * 80)"

					Import-Module -Name $GetImportFileName -Force | Out-Null
					Remove-Module -Name $GetImportFileName -Force -ErrorAction Ignore | Out-Null

					Write-Host
					Write-Host "  $('-' * 80)"
					Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
					Write-Host $GetImportFileName -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				} else {
					write-host "  $($lang.Disable)" -ForegroundColor Red

					$arguments = @(
						"-ExecutionPolicy",
						"ByPass",
						"-File",
						"""$($GetImportFileName)"""
					)

					if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
						Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
						Write-Host "  $('-' * 80)"
						Write-Host "  Start-Process -FilePath 'powershell' -ArgumentList '$($Arguments)'" -ForegroundColor Green
						Write-Host "  $('-' * 80)"
					}

					Write-Host
					Write-Host "  " -NoNewline
					Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
					Start-Process "powershell" -ArgumentList $arguments -Verb RunAs -Wait
					Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
				}
			} else {
				Write-Host " $($lang.NoInstallImage) " -BackgroundColor DarkRed -ForegroundColor White
			}
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	}
}