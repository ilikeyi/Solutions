Function Image_Convert_Create_Info_Process
{
	param
	(
		[string]$Sources,
		[string]$SaveTo
	)

@"
{
	"author": {
		"name": "$((Get-Module -Name Solutions).Author)",
		"url":  "$((Get-Module -Name Solutions).HelpInfoURI)"
	},
	"Sources": {
		"OriginalName": "$($sources)",
		"CopyTo":       "$($SaveTo)"
	},
	"Backup": {
		"Time": "$(Get-Date -Format "MM/dd/yyyy hh:mm:ss")"
	}
}
"@ | Out-File -FilePath "$($SaveTo)\install.json" -Encoding Ascii -ErrorAction SilentlyContinue

	Write-Host "`n  $($lang.Wim_Rule_Check)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($SaveTo)\install.json"
	Write-Host "  $($lang.Wim_Rule_Verify): " -NoNewline

	try {
		$Autopilot = Get-Content -Raw -Path "$($SaveTo)\install.json" | ConvertFrom-Json
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} catch {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

<#
	.Convert package to compressed package
	.转换软件包为压缩包
#>
Function Covert_Software_Package_Unpack
{
	Write-Host "`n  $($lang.ConvertToArchive)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$Script:CompressedPackage = @()
	$ExcludeCompressedPackageSoftware = @(
		"dControl"
	)

	$SearchArch = @(
		"arm64"
		"AMD64"
		"x86"
	)

	$Region = Language_Region
	$CompressedPackageOptional = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\_Custom\Software" -ErrorAction SilentlyContinue
	Get-ChildItem $CompressedPackageOptional -directory -ErrorAction SilentlyContinue | ForEach-Object {
		Get-ChildItem $_.FullName -directory -ErrorAction SilentlyContinue | ForEach-Object {
			$SaveToName = [IO.Path]::GetDirectoryName($_.FullName)

			if ($ExcludeCompressedPackageSoftware -Contains $_.BaseName) {
#				Write-Host "  $($lang.ExcludeItem) ( $($_.BaseName) )"
			} else {
				ForEach ($item in $SearchArch) {
					ForEach ($itemRegion in $Region) {
						if (Test-Path -Path "$($SaveToName)\$($_.BaseName)\$($item)\$($itemRegion.Region)" -PathType Container) {
							Write-Host "  $($SaveToName)\$($_.BaseName)\$($item)\$($itemRegion.Region)\$($_.BaseName).zip"

							if (Test-Path -Path "$($SaveToName)\$($_.BaseName)\$($item)\$($itemRegion.Region)\$($_.BaseName).zip" -PathType Leaf) {
								Write-Host "  $($lang.Existed)`n"
							} else {
								Write-Host "  $($lang.AddQueue): " -NoNewline
								$Script:CompressedPackage += @{
									Name   = $_.BaseName
									Folder = "$($_.FullName)\$($item)\$($itemRegion.Region)"
								}

								Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
								Write-Host
							}
						}
					}
				}
			}
		}
	}

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Green
		ForEach ($item in $Script:CompressedPackage) {
			$fullnewpathsha256 = "$($item.Folder)\$($item.Name).zip.sha256"

			$WYGuid = [guid]::NewGuid()
			$TempFolderUpdate = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "Temp.$($WYGuid)"

			Check_Folder -chkpath $TempFolderUpdate
			Push-Location $item.Folder

			Write-Host "   * $($item.Folder)\$($item.Name).zip"
			Write-Host "  $($lang.Uping): " -NoNewline

			$arguments = "a", "-tzip", """$($TempFolderUpdate)\$($item.Name).zip""", "*.*", "-mcu=on", "-r", "-mx9";
			Start-Process $Verify_Install_Path $arguments -Wait -WindowStyle Minimized
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			Write-Host "`n  $($fullnewpathsha256)"
			Write-Host "  $($lang.Uping): " -NoNewline
			Remove-Item -Path $fullnewpathsha256 -Force -ErrorAction SilentlyContinue

			$calchash = (Get-FileHash "$($TempFolderUpdate)\$($item.Name).zip" -Algorithm SHA256)
			"$($calchash.Hash)  $($item.Name).zip" | Out-File -FilePath "$($TempFolderUpdate)\$($item.Name).zip.sha256" -Encoding ASCII -ErrorAction SilentlyContinue
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

			Remove_Tree $item.Folder

			Copy-Item -Path "$($TempFolderUpdate)\*" -Destination $item.Folder -Recurse -Force -ErrorAction SilentlyContinue

			Remove_Tree $TempFolderUpdate

			Write-Host "  $($lang.Done)" -ForegroundColor Green
		}
	} else {
		Write-Host "  $($lang.ZipStatus)" -ForegroundColor Green
	}
}