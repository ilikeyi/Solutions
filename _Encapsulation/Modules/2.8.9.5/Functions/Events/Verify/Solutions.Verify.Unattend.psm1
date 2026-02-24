Function Verify_Unattend_Custom_File
{
	$Error_Autopilot_File = @()

	Write-Host "`n  $($lang.Wim_Rule_Verify): $($lang.Autopilot_Select_Config)"
	Write-Host "  $('-' * 80)"

	$test_autopilot_Config_Folder = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..") -ChildPath "_Custom\Unattend" -ErrorAction SilentlyContinue
	if (Test-Path -Path $test_autopilot_Config_Folder -PathType Container) {
		Get-ChildItem -Path $test_autopilot_Config_Folder -Recurse -Include *.xml -ErrorAction SilentlyContinue | ForEach-Object {
			$MainFolderFullname = $_.FullName
			Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
			Write-Host $MainFolderFullname -ForegroundColor Green

			Write-Host "  $('-' * 80)"
			Write-Host "  " -NoNewline
			Write-Host " $($lang.Wim_Rule_Verify) " -NoNewline -BackgroundColor White -ForegroundColor Black
			if (TestXMLFile -path $MainFolderFullname) {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			} else {
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

			Get_Next -DevCode "vu 1"
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Green
		}
	} else {
		Write-Host "  $($lang.NoInstallImage)"
		Write-Host "  $($test_autopilot_Config_Folder)" -ForegroundColor Red
	}
}

Function TestXMLFile
{
	param (
		[string]$path
	)

	try {
		$XmlFile = Get-Item $path
		
		# Perform the XSD Validation
		$ErrorCount = 0
		$ReaderSettings = New-Object -TypeName System.Xml.XmlReaderSettings
		$ReaderSettings.ValidationType = [System.Xml.ValidationType]::Schema
		$ReaderSettings.ValidationFlags = [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessInlineSchema -bor [System.Xml.Schema.XmlSchemaValidationFlags]::ProcessSchemaLocation
		$ReaderSettings.add_ValidationEventHandler({ $ErrorCount++ })
		$ReaderSettings.DtdProcessing = [System.Xml.DtdProcessing]::Parse
		$Reader = [System.Xml.XmlReader]::Create($XmlFile.FullName, $ReaderSettings)
		while ($Reader.Read()) { }
		$Reader.Close()

		if ($ErrorCount -gt 0) {
			return $false
		}

		return $true
	} catch {
		return $false
	}
}