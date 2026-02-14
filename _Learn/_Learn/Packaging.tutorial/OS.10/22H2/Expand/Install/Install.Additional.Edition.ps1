$AdditionalEdition = @{
	Exclude  = @()
	Rule = @(
		@{ Name = "Windows 10 Home";                                        Requiredversion = "Core";          NewEditionId = "Core";                     Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Home N";                                      Requiredversion = "CoreN";         NewEditionId = "CoreN";                    Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Home Single Language";                        Requiredversion = "Core";          NewEditionId = "CoreSingleLanguage";       Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Education";                                   Requiredversion = "Professional";  NewEditionId = "Education";                Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Education N";                                 Requiredversion = "ProfessionalN"; NewEditionId = "EducationN";               Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro";                                         Requiredversion = "Professional";  NewEditionId = "Professional";             Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro N";                                       Requiredversion = "ProfessionalN"; NewEditionId = "ProfessionalN";            Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro Education";                               Requiredversion = "Professional";  NewEditionId = "ProfessionalEducation";    Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro Education N";                             Requiredversion = "Professional";  NewEditionId = "ProfessionalEducationN";   Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro for Workstations";                        Requiredversion = "Professional";  NewEditionId = "ProfessionalWorkstation";  Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Pro N for Workstations";                      Requiredversion = "ProfessionalN"; NewEditionId = "ProfessionalWorkstationN"; Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Enterprise";                                  Requiredversion = "Professional";  NewEditionId = "Enterprise";               Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Enterprise multi-session / Virtual Desktops"; Requiredversion = "Professional";  NewEditionId = "ServerRdsh";               Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Enterprise N";                                Requiredversion = "ProfessionalN"; NewEditionId = "EnterpriseN";              Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 IoT Enterprise";                              Requiredversion = "Professional";  NewEditionId = "IoTEnterprise";            Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 IoT Enterprise Subscription";                 Requiredversion = "Professional";  NewEditionId = "IoTEnterpriseK";           Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Enterprise LTSC";                             Requiredversion = "EnterpriseS";   NewEditionId = "EnterpriseS";              Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 Enterprise N LTSC";                           Requiredversion = "EnterpriseSN";  NewEditionId = "EnterpriseSN";             Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 IoT Enterprise LTSC";                         Requiredversion = "EnterpriseS";   NewEditionId = "IoTEnterpriseS";           Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
		@{ Name = "Windows 10 IoT Enterprise Subscription LTSC";            Requiredversion = "EnterpriseS";   NewEditionId = "IoTEnterpriseSK";          Productkey = ""; Detailed = @{ ImageName = "Auto"; Description = "Auto"; DisplayName = "Auto"; DisplayDescription = "Auto"; }; }
	)
}

$InstallFilename = "D:\ISOTemp\Sources\install.wim"
$TempSaveAEFileTo = "D:\ISOTemp\Sources\install.AE.Temp.wim"
$Mount = "D:\ISOTemp_Custom\Install\Install\Mount"

$RandomGuid = New-Guid
$BackupInstallTo = "D:\ISOTemp_Custom\_Backup\Additional edition\$($RandomGuid)"

if (Test-Path -Path $InstallFilename -PathType Leaf) {
	Write-Host "The main Install.wim file path has been set: " -ForegroundColor Yellow
	Write-host $InstallFilename -ForegroundColor Green
	write-host
} else {
	Write-Host "The file was not found. Path: " -NoNewline
	Write-host $InstallFilename -ForegroundColor Red
	return
}

remove-item -path $TempSaveAEFileTo -force -ErrorAction SilentlyContinue
if (Test-Path $TempSaveAEFileTo -PathType Leaf) {
	$RandomGuid = New-Guid
	$TempSaveAEFileTo = "D:\ISOTemp\Sources\install.AE.Temp.$($RandomGuid).wim"
}

if((Get-ChildItem $Mount -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
	Write-Host "Path: " -NoNewline
	Write-host $Mount -ForegroundColor Green
	write-host "Please clear all the contents of the directory first and then try again." -ForegroundColor Red
	return
} else {
	New-Item -Path $Mount -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
}

Function Get_Arch_Path
{
	param
	(
		[string]$Path
	)

	$CurrentArch = $env:PROCESSOR_ARCHITECTURE
	$ArchPath = Join-Path -Path $Path -ChildPath $CurrentArch

	if (Test-Path -Path $ArchPath -PathType Container) {
		return Convert-Path -Path $ArchPath -ErrorAction SilentlyContinue
	}

	return $Path
}

$wimlib = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\wimlib")\wimlib-imagex.exe"
if (Test-Path -Path $wimlib -PathType Leaf) {
	Write-Host "Wimlib was detected and set as the preferred option: " -ForegroundColor Yellow
	Write-host $wimlib -ForegroundColor Green
} else {
	Write-Host "Path: " -NoNewline
	Write-host $wimlib -ForegroundColor Green
	write-host "Modifying the version ID requires wimlib; please download wimlib and try again." -ForegroundColor Red
	return
}

$GroupImageFileDetailed = @()
$AERequired_EditionID_Not = @()

Write-Host "`n  Add rule: $($AdditionalEdition.Rule.Count) Item" -ForegroundColor Yellow
Write-Host "  $('-' * 80)"
if ($AdditionalEdition.Rule.count -gt 0) {
	ForEach ($itemRule in $AdditionalEdition.Rule) {
		write-host "  Additional edition: " -NoNewline -ForegroundColor Yellow
		write-host $itemRule.Name -ForegroundColor Green

		write-host "  Required edition: " -NoNewline -ForegroundColor Yellow
		write-host $itemRule.Requiredversion -ForegroundColor Green

		write-host "  New Edition ID: " -NoNewline -ForegroundColor Yellow
		write-host $itemRule.NewEditionId -ForegroundColor Green

		write-host "  Serial number: " -NoNewline -ForegroundColor Yellow
		write-host $itemRule.Productkey -ForegroundColor Green

		write-host "  Detailed: "
			write-host "      Image name: " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.ImageName -ForegroundColor Green

			write-host "      Image description: " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.Description -ForegroundColor Green

			write-host "      Display name: " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayName -ForegroundColor Green

			write-host "      Display description: " -NoNewline -ForegroundColor Yellow
			write-host $itemRule.Detailed.DisplayDescription -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
	}
} else {
	write-host "Please configure the rules." -ForegroundColor Red
	return
}

$RandomGuid = New-Guid
$Export_To_New_Xml = Join-Path -Path $env:TEMP -ChildPath "$($RandomGuid).xml"
$Arguments = "info ""$($InstallFilename)"" --extract-xml ""$($Export_To_New_Xml)"""
Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow

if (Test-Path -Path $Export_To_New_Xml -PathType Leaf) {
	[XML]$empDetails = Get-Content $Export_To_New_Xml

	ForEach ($empDetail in $empDetails.wim.IMAGE) {
		$GroupImageFileDetailed += [pscustomobject]@{
			Index              = $empDetail.index
			Name               = $empDetail.NAME
			ImageDescription   = $empDetail.DESCRIPTION
			EditionId          = $empDetail.FLAGS
		}
	}
	Remove-Item -Path $Export_To_New_Xml
}

if ($GroupImageFileDetailed.count -gt 0) {
	foreach ($item in $GroupImageFileDetailed) {
		Write-Host "  Index: " -NoNewline -ForegroundColor Yellow; Write-Host $item.Index -ForegroundColor Yellow
		write-host "  Image name: " -NoNewline -ForegroundColor Yellow; write-host $item.Name -ForegroundColor Green;
		Write-Host "  Display description: " -NoNewline; Write-Host $item.ImageDescription -ForegroundColor Yellow;
		write-host "  Edition: " -NoNewline -ForegroundColor Yellow; write-host $item.EditionId -ForegroundColor Green
		Write-Host
	}
} else {
	Write-hsot "File error: $($InstallFilename)" -ForegroundColor Red
	return
}

Write-Host "`n  Add Queue: $($AdditionalEdition.Rule.Count) item" -ForegroundColor Yellow
Write-Host "  $('-' * 80)"
ForEach ($itemRule in $AdditionalEdition.Rule) {
	write-host "  Additional edition: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Name -ForegroundColor Green;
	write-host "  Required edition: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Requiredversion -ForegroundColor Green;
	write-host "  New Edition ID: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.NewEditionId -ForegroundColor Green;
	write-host "  Serial number: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Productkey -ForegroundColor Green;
	write-host "  Detailed: "
	write-host "      Image name: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Detailed.ImageName -ForegroundColor Green;
	write-host "      Image description: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Detailed.Description -ForegroundColor Green;
	write-host "      Display name: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Detailed.DisplayName -ForegroundColor Green;
	write-host "      Display description: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Detailed.DisplayDescription -ForegroundColor Green;

	if ($GroupImageFileDetailed.EditionId -contains $itemRule.Requiredversion) {
		write-host "`n  Required edition: " -NoNewline -ForegroundColor Yellow; write-host $itemRule.Requiredversion -NoNewline -ForegroundColor Green;
		Write-Host ", Running: " -NoNewline -ForegroundColor Yellow;
		Write-Host " Satisfy " -BackgroundColor White -ForegroundColor Black;

		Write-Host "`n  Export_Image" -ForegroundColor Yellow
		Write-Host "  $('.' * 80)"
		foreach ($ExportOld in $GroupImageFileDetailed) {
			if ($ExportOld.EditionId -eq $itemRule.Requiredversion) {
				Write-Host "  Index: " -NoNewline -ForegroundColor Yellow; Write-Host $ExportOld.Index -ForegroundColor Yellow;
				write-host "  Image name: " -NoNewline -ForegroundColor Yellow; write-host $ExportOld.Name -ForegroundColor Green;
				Write-Host "  Image description: " -NoNewline; Write-Host $ExportOld.ImageDescription -ForegroundColor Yellow;
				write-host "  Edition: " -NoNewline -ForegroundColor Yellow; write-host $ExportOld.EditionId -ForegroundColor Green
				Write-Host "  Image source: " -NoNewline -ForegroundColor Yellow; Write-Host $InstallFilename -ForegroundColor Green;

				Write-Host "  $('.' * 80)";
				write-host "  Save To: " -NoNewline -ForegroundColor Yellow; write-host $TempSaveAEFileTo -ForegroundColor Green;

				Write-Host "  Rebuilding: " -NoNewline
				try {
					Export-WindowsImage -SourceImagePath $InstallFilename -SourceIndex $ExportOld.Index -DestinationImagePath $TempSaveAEFileTo -CompressionType Max -ErrorAction SilentlyContinue | Out-Null	
					Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White

					Write-Host "`n  Setting: Index: " -NoNewline
					$GetLastIndex = @()
					Get-WindowsImage -ImagePath $TempSaveAEFileTo -ErrorAction SilentlyContinue | ForEach-Object {
						$GetLastIndex += $_.ImageIndex
					}
				} catch {
					Write-Host "  $($_)" -ForegroundColor Red
					Write-Host "  Inoperable`n" -ForegroundColor Red
				}

				$GetLastIndex = $GetLastIndex | Select-Object -Last 1
				Write-Host $GetLastIndex -ForegroundColor Yellow

				if (Test-Path -Path $wimlib -PathType Leaf) {
					if ($itemRule.Detailed.ImageName -eq "Auto") {
						$NewImageName = $itemRule.Detailed.ImageName
					} else {
						$NewImageName = $itemRule.Detailed.ImageName
					}

					if ($itemRule.Detailed.Description -eq "Auto") {
						$NewDescription = $itemRule.Detailed.ImageName
					} else {
						$NewDescription = $itemRule.Detailed.Description
					}

					if ($itemRule.Detailed.DisplayName -eq "Auto") {
						$NewDisplayName = $itemRule.Detailed.ImageName
					} else {
						$NewDisplayName = $itemRule.Detailed.DisplayName
					}

					if ($itemRule.Detailed.DisplayDescription -eq "Auto") {
						$NewDisplayDescription = $itemRule.Detailed.ImageName
					} else {
						$NewDisplayDescription = $itemRule.Detailed.DisplayDescription
					}

					$Arguments = "info ""$($TempSaveAEFileTo)"" $($GetLastIndex) --image-property NAME=""$($NewImageName)"" --image-property DESCRIPTION=""$($NewDescription)"" --image-property DISPLAYNAME=""$($NewDisplayName)"" --image-property DISPLAYDESCRIPTION=""$($NewDisplayDescription)"" --image-property FLAGS=""$($itemRule.NewEditionId)"""
					Start-Process -FilePath $wimlib -ArgumentList $Arguments -wait -nonewwindow
				}

				<#
					.排除项：是否排除挂载
				#>
				write-host "`n  Mounted Status: " -NoNewline -ForegroundColor Yellow
				if ($AdditionalEdition.Exclude -contains $itemRule.NewEditionId) {
					Write-Host " Exclude Item " -BackgroundColor DarkRed -ForegroundColor White
				} else {
					Write-Host " Mount " -BackgroundColor DarkGreen -ForegroundColor White
					Write-Host

					Mount-WindowsImage -ImagePath $TempSaveAEFileTo -Index $GetLastIndex -Path $Mount | Out-Null

					<#
						.更改映像版本
					#>
					Write-Host "`n  Editions Change: " -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  New Edition ID: " -NoNewline
					Write-Host " $($itemRule.NewEditionId) " -BackgroundColor DarkGreen -ForegroundColor White

					$GetCurrentEditionVersion = @()
					try {
						$CurrentEdition = (Get-WindowsEdition -Path $Mount).Edition
						$GetCurrentEditionVersion += $CurrentEdition

						Get-WindowsEdition -Path $Mount -Target | ForEach-Object {
							$GetCurrentEditionVersion += $_.Edition
						}

						Write-Host "  Editions Existed: "
						Write-Host "  $('-' * 80)"
						foreach ($itemNV in $GetCurrentEditionVersion) {
							Write-Host "  $($itemNV)"
						}

						Write-Host "`n  Matc hMode: " -NoNewline
						Write-Host " $($itemRule.NewEditionId) " -BackgroundColor DarkGreen -ForegroundColor White
						Write-Host "  $('-' * 80)"
						if ($GetCurrentEditionVersion -contains $itemRule.NewEditionId) {
							write-host "  Available" -ForegroundColor Green

							Write-Host "  " -NoNewline
							Write-Host " Change " -NoNewline -BackgroundColor White -ForegroundColor Black
							try {
								Set-WindowsEdition -Path $Mount -Edition $itemRule.NewEditionId
								Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White
							} catch {
								Write-Host "  $($_)" -ForegroundColor Red
								Write-Host "  Inoperable" -ForegroundColor Red
							}
						} else {
							Write-Host "  Not satisfied" -ForegroundColor Red
						}
					} catch {
						Write-Host "  $($_)" -ForegroundColor Red
						Write-Host "  Inoperable" -ForegroundColor Red
					}

						
					<#
						.更改序列号
					#>
					Write-Host "`n  Editions Product Key Change: " -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					if ([string]::IsNullOrEmpty($itemRule.Productkey)) {
						Write-Host "  Inoperable " -ForegroundColor Red
					} else {
						Write-Host "  Setting Editions Product Key: " -NoNewline
						Write-Host " $($itemRule.Productkey) " -BackgroundColor DarkGreen -ForegroundColor White

						Write-Host "  " -NoNewline
						Write-Host " Change " -NoNewline -BackgroundColor White -ForegroundColor Black
						try {
							Set-WindowsProductKey -Path $Mount -ProductKey $itemRule.Productkey
							Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White
						} catch {
							Write-Host "  $($_)" -ForegroundColor Red
							Write-Host "  Inoperable" -ForegroundColor Red
						}
					}

					<#
						.保存
					#>
					Write-Host "`n  Save" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  $($Mount)" -ForegroundColor Green
					if (Test-Path -Path $Mount -PathType Container) {
						Write-Host
						Write-Host "  " -NoNewline
						Write-Host " Save " -NoNewline -BackgroundColor White -ForegroundColor Black
						Save-WindowsImage -Path $Mount | Out-Null
						Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White
					} else {
						Write-Host "  Inoperable" -ForegroundColor Red
					}

					<#
						.不保存
					#>
					Write-Host "`n  Do not save" -ForegroundColor Yellow
					Write-Host "  $('-' * 80)"
					Write-Host "  $($Mount)" -ForegroundColor Green

					Write-Host "  " -NoNewline
					Write-Host " Unmount " -NoNewline -BackgroundColor White -ForegroundColor Black
					Dismount-WindowsImage -Path $Mount -Discard -ErrorAction SilentlyContinue | Out-Null
					Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White
				}
			}
		}
	}
}

<#
	.重建
#>
Write-Host "`n  Rebuild" -ForegroundColor Yellow
Write-Host "  $('-' * 80)"
Get-WindowsImage -ImagePath $TempSaveAEFileTo -ErrorAction SilentlyContinue | ForEach-Object {
	Write-Host "  Index: " -NoNewline; Write-Host $_.ImageIndex -ForegroundColor Yellow;
	Write-Host "  Image Name: " -NoNewline; Write-Host $_.ImageName -ForegroundColor Yellow;
	Write-Host "  Image Description: " -NoNewline; Write-Host $_.ImageDescription -ForegroundColor Yellow;
	Write-Host
}

Write-Host "`n  Add Queue" -ForegroundColor Yellow
Write-Host "  $('-' * 80)"
$Save_To_Temp_Folder_Path = "D:\ISOTemp\Sources\install.temp.wim"

Get-WindowsImage -ImagePath $TempSaveAEFileTo -ErrorAction SilentlyContinue | ForEach-Object {
	Write-Host "  Index: " -NoNewline; Write-Host $_.ImageIndex -ForegroundColor Yellow;
	Write-Host "  Image Name: " -NoNewline; Write-Host $_.ImageName -ForegroundColor Yellow;
	Write-Host "  Image Description: " -NoNewline; Write-Host $_.ImageDescription -ForegroundColor Yellow
	Write-Host "  Rebuilding: " -NoNewline
	try {
		Export-WindowsImage -SourceImagePath $TempSaveAEFileTo -SourceIndex $_.ImageIndex -DestinationImagePath $Save_To_Temp_Folder_Path -CompressionType Max -ErrorAction SilentlyContinue | Out-Null	
		Write-Host " Done " -BackgroundColor DarkGreen -ForegroundColor White
	} catch {
		Write-Host "  $($_)" -ForegroundColor Red
	}
	Write-Host
}

if (Test-Path -Path $Save_To_Temp_Folder_Path -PathType Leaf) {
	Remove-Item -Path $TempSaveAEFileTo -ErrorAction SilentlyContinue
	Move-Item -Path $Save_To_Temp_Folder_Path -Destination $TempSaveAEFileTo -ErrorAction SilentlyContinue

	if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
		Write-Host "  Done" -ForegroundColor Green
	} else {
		Write-Host "  Inoperable" -ForegroundColor Red
	}
} else {
	Write-Host "  Inoperable" -ForegroundColor Red
}

<#
	.备份当前文件到
#>
Write-Host "`n  Backup" -ForegroundColor Yellow
Write-Host "  $('-' * 80)"
if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
	Write-Host "  Operable" -ForegroundColor Green

	Write-Host "`n  Process the source" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  Path: " -NoNewline
	Write-Host $TempSaveAEFileTo -ForegroundColor Green
	if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
		$SaveToName = [IO.Path]::GetFileName($InstallFilename)
		New-Item -Path $BackupInstallTo -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		Write-Host "`n  Save to" -ForegroundColor Yellow
		Write-Host "     - $($InstallFilename)" -ForegroundColor Green
		Write-Host "     + $($BackupInstallTo)" -ForegroundColor Green

		Write-Host "`n  Calibration: " -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if (Test-Path -Path $BackupInstallTo -PathType Container) {
			Move-Item -Path $InstallFilename -Destination $BackupInstallTo -ErrorAction SilentlyContinue

			$NewFileName = "$($BackupInstallTo)\$($SaveToName)"

			Write-Host "  1. Save to" -ForegroundColor Yellow
			Write-Host "     $($NewFileName)" -ForegroundColor Green
			Write-Host "     $('.' * 77)"
			if (Test-Path -Path "$($BackupInstallTo)\$($SaveToName)" -PathType Leaf) {
				Write-Host "     Done" -ForegroundColor Green

				write-host "`n  2. Check the file" -ForegroundColor Yellow
				Write-Host "     $($InstallFilename)" -ForegroundColor Green
				Write-Host "     $('.' * 77)"
				if (Test-Path -Path $InstallFilename -PathType Leaf) {
					Write-Host "     Existed " -ForegroundColor Red
				} else {
					Write-Host "     Does not exist locally" -ForegroundColor Green

					Rename-Item -Path $TempSaveAEFileTo -NewName $InstallFilename -ErrorAction SilentlyContinue

					write-host "`n  3. Rename" -ForegroundColor Yellow
					Write-Host "     - $($TempSaveAEFileTo)" -ForegroundColor Green
					Write-Host "     + $($InstallFilename)" -ForegroundColor Green
					Write-Host "     $('.' * 77)"
					if (Test-Path -Path $TempSaveAEFileTo -PathType Leaf) {
						Write-Host "     Failed " -ForegroundColor Red
					} else {
						if (Test-Path -Path $InstallFilename -PathType Leaf) {
							Write-Host "     Done " -ForegroundColor Green
						} else {
							Write-Host "     Failed " -ForegroundColor Red
						}
					}
				}
			} else {
				Write-Host "The file was not found. Path: " -NoNewline
				Write-host "$($BackupInstallTo)\$($SaveToName)" -ForegroundColor Red
			}
		} else {
			Write-Host "  Failed to create directory" -ForegroundColor Red
		}
	} else {
		Write-Host "  Does not exist locally" -ForegroundColor Red
	}
} else {
	Write-Host "The file was not found. Path: " -NoNewline
	Write-host $TempSaveAEFileTo -ForegroundColor Red
}