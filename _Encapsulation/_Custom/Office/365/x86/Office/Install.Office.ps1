<#
	.Summary
	 Office silent installation

	.Description
	 Office silent installation, automatic framework recognition

	.Version
	 v1.0

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS >

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

<#
	.Available languages
	.可用语言
#>
$Global:Languages_Available = @(
	@{
		RegionID = "1033"
		Region   = "en-US"
		Tag      = "en"
		Name     = "English (United States)"
		Timezone = "Pacific Standard Time"
		LIP      = "9PDSCC711RVF"
		Expand   = @()
	}
	@{
		RegionID = "1025"
		Region   = "ar-SA"
		Tag      = "ar"
		Name     = "Arabic (Saudi Arabia)"
		Timezone = "Argentina Standard Time"
		LIP      = "9N4S78P86PKX"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
			@{
				RegionID = "3073"
				Region   = "ar-EG"
				Tag      = "ar"
				Name     = "Arabic (Egypt)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1026"
		Region   = "bg-BG"
		Tag      = "bg"
		Name     = "Bulgarian (Bulgaria)"
		Timezone = "FLE Standard Time"
		LIP      = "9MX54588434F"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "1029"
		Region   = "cs-CZ"
		Tag      = "dz"
		Name     = "Czech (Czech Republic)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9P3WXZ1KTM7C"
		Expand   = @()
	}
	@{
		RegionID = "1030"
		Region   = "da-DK"
		Tag      = "dk"
		Name     = "Danish (Denmark)"
		Timezone = "Romance Standard Time"
		LIP      = "9NDMT2VKSNL1"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "1031"
		Region   = "de-DE"
		Tag      = "de"
		Name     = "German (Germany)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P6CT0SLW589"
		Expand   = @()
	}
	@{
		RegionID = "1032"
		Region   = "el-GR"
		Tag      = "gr"
		Name     = "Greek (Greece)"
		Timezone = "GTB Standard Time"
		LIP      = "9N586B13PBLD"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "2057"
		Region   = "en-gb"
		Tag      = "gb"
		Name     = "English (United Kingdom)"
		Timezone = "GMT Standard Time"
		LIP      = "9NT52VQ39BVN"
		Expand   = @()
	}
	@{
		RegionID = "3082"
		Region   = "es-ES"
		Tag      = "es-ES"
		Name     = "Spanish (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9NWVGWLHPB1Z"
		Expand   = @()
	}
	@{
		RegionID = "2058"
		Region   = "es-MX"
		Tag      = "mx"
		Name     = "Spanish (Mexico)"
		Timezone = "Central Standard Time (Mexico)"
		LIP      = "9N8MCM1X3928"
		Expand   = @()
	}
	@{
		RegionID = "1061"
		Region   = "et-EE"
		Tag      = "ee"
		Name     = "Estonian (Estonia)"
		Timezone = "FLE Standard Time"
		LIP      = "9NFBHFMCR30L"
		Expand   = @()
	}
	@{
		RegionID = "1035"
		Region   = "fi-FI"
		Tag      = "fi"
		Name     = "Finnish (Finland)"
		Timezone = "FLE Standard Time"
		LIP      = "9MW3PQ7SD3QK"
		Expand   = @()
	}
	@{
		RegionID = "3084"
		Region   = "fr-CA"
		Tag      = "ca"
		Name     = "French (Canada)"
		Timezone = "Eastern Standard Time"
		LIP      = "9MTP2VP0VL92"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
			@{
				RegionID = "1036"
				Region   = "fr-FR"
				Tag      = "fr"
				Name     = "French (France)"
				Timezone = "Central European Time"
				LIP      = "9NHMG4BJKMDG"
			}
		)
	}
	@{
		RegionID = "1036"
		Region   = "fr-FR"
		Tag      = "fr"
		Name     = "French (France)"
		Timezone = "Central European Time"
		LIP      = "9NHMG4BJKMDG"
		Expand   = @()
	}
	@{
		RegionID = "1037"
		Region   = "he-IL"
		Tag      = "il"
		Name     = "Hebrew (Israel)"
		Timezone = "Israel Standard Time"
		LIP      = "9NB6ZFND5HCQ"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "1050"
		Region   = "hr-HR"
		Tag      = "hr"
		Name     = "Croatian (Croatia)"
		Timezone = "Central European Standard Time"
		LIP      = "9NW01VND4LTW"
		Expand   = @()
	}
	@{
		RegionID = "1038"
		Region   = "hu-HU"
		Tag      = "hu"
		Name     = "Hungarian (Hungary)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9MWN3C58HL87"
		Expand   = @()
	}
	@{
		RegionID = "1040"
		Region   = "it-IT"
		Tag      = "it"
		Name     = "Italian (Italy)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P8PQWNS6VJX"
		Expand   = @()
	}
	@{
		RegionID = "1041"
		Region   = "ja-JP"
		Tag      = "jp"
		Name     = "Japanese (Japan)"
		Timezone = "Tokyo Standard Time"
		LIP      = "9N1W692FV4S1"
		Expand   = @()
	}
	@{
		RegionID = "1042"
		Region   = "ko-KR"
		Tag      = "kr"
		Name     = "Korean (Korea)"
		Timezone = "Korea Standard Time"
		LIP      = "9N4TXPCVRNGF"
		Expand   = @()
	}
	@{
		RegionID = "1063"
		Region   = "lt-LT"
		Tag      = "lt"
		Name     = "Lithuanian (Lithuania)"
		Timezone = "FLE Standard Time"
		LIP      = "9NWWD891H6HN"
		Expand   = @()
	}
	@{
		RegionID = "1062"
		Region   = "lv-LV"
		Tag      = "lv"
		Name     = "Latvian (Latvia)"
		Timezone = "FLE Standard Time"
		LIP      = "9N5CQDPH6SQT"
		Expand   = @()
	}
	@{
		RegionID = "1044"
		Region   = "nb-NO"
		Tag      = "no"
		Name     = "Norwegian, Bokmål (Norway)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9N6J0M5DHCK0"
		Expand   = @()
	}
	@{
		RegionID = "1043"
		Region   = "nl-NL"
		Tag      = "nl"
		Name     = "Dutch (Netherlands)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PF1C9NB5PRV"
		Expand   = @()
	}
	@{
		RegionID = "1045"
		Region   = "pl-PL"
		Tag      = "pl"
		Name     = "Polish (Poland)"
		Timezone = "Central European Standard Time"
		LIP      = "9NC5HW94R0LD"
		Expand   = @()
	}
	@{
		RegionID = "1046"
		Region   = "pt-BR"
		Tag      = "br"
		Name     = "Portuguese (Brazil)"
		Timezone = "E. South America Standard Time"
		LIP      = "9P8LBDM4FW35"
		Expand   = @()
	}
	@{
		RegionID = "2070"
		Region   = "pt-PT"
		Tag      = "pt"
		Name     = "Portuguese (Portugal)"
		Timezone = "GMT Standard Time"
		LIP      = "9P7X8QJ7FL0X"
		Expand   = @()
	}
	@{
		RegionID = "1048"
		Region   = "ro-RO"
		Tag      = "ro"
		Name     = "Romanian (Romania)"
		Timezone = "GTB Standard Time"
		LIP      = "9MWXGPJ5PJ3H"
		Expand   = @()
	}
	@{
		RegionID = "1049"
		Region   = "ru-RU"
		Tag      = "ru"
		Name     = "Russian (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = "9NMJCX77QKPX"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "1051"
		Region   = "sk-SK"
		Tag      = "sk"
		Name     = "Slovak (Slovakia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9N7LSNN099WB"
		Expand   = @()
	}
	@{
		RegionID = "1060"
		Region   = "sl-SI"
		Tag      = "si"
		Name     = "Slovenian (Slovenia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NV27L34J4ST"
		Expand   = @()
	}
	@{
		RegionID = "9242"
		Region   = "sr-latn-rs"
		Tag      = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NBZ0SJDPPVT"
		Expand   = @()
	}
	@{
		RegionID = "1053"
		Region   = "sv-SE"
		Tag      = "se"
		Name     = "Swedish (Sweden)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P0HSNX08177"
		Expand   = @()
	}
	@{
		RegionID = "1054"
		Region   = "th-TH"
		Tag      = "th"
		Name     = "Thai (Thailand)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9MSTWFRL0LR4"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "1055"
		Region   = "tr-TR"
		Tag      = "tr"
		Name     = "Turkish (Turkey)"
		Timezone = "Turkey Standard Time"
		LIP      = "9NL1D3T5HG9R"
		Expand   = @()
	}
	@{
		RegionID = "1058"
		Region   = "uk-UA"
		Tag      = "ua"
		Name     = "Ukrainian (Ukraine)"
		Timezone = "FLE Standard Time"
		LIP      = "9PPPMZRSGHR8"
		Expand   = @(
			@{
				RegionID = "1033"	
				Region   = "en-US"
				Tag      = "en"
				Name     = "English (United States)"
				Timezone = "Pacific Standard Time"
				LIP      = "9PDSCC711RVF"
			}
		)
	}
	@{
		RegionID = "2052"
		Region   = "zh-CN"
		Tag      = "cn"
		Name     = "Chinese (Simplified, China)"
		Timezone = "China Standard Time"
		LIP      = "9NRMNT6GMZ70"
		Expand   = @()
	}
	@{
		RegionID = "1028"
		Region   = "zh-TW"
		Tag      = "tw"
		Name     = "Chinese (Traditional, Taiwan)"
		Timezone = "Taipei Standard Time"
		LIP      = "9PCJ4DHCQ1JQ"
		Expand   = @(
			@{
				RegionID = "3076"
				Region   = "zh-HK"
				Tag      = "hk"
				Name     = "Chinese (Traditional, Hong Kong SAR)"
				Timezone = "China Standard Time"
				LIP      = ""
			}
		)
	}
)

Function Language_Region
{
	$ResultList = [System.Collections.Generic.List[PSCustomObject]]::new()
	$SeenRegions = [System.Collections.Generic.HashSet[string]]::new()

	function AddUniqueRegion($Item) {
		if ($null -ne $Item.Region -and $SeenRegions.Add($Item.Region)) {
			$ResultList.Add([PSCustomObject]@{
				RegionID = $Item.RegionID
				Region   = $Item.Region
				Tag      = $Item.Tag
				Name     = $Item.Name
				Timezone = $Item.Timezone
				LIP      = $Item.LIP
			})
		}
	}

	foreach ($item in $Global:Languages_Available) {
		AddUniqueRegion $item

		if ($item.Expand -and $item.Expand.Count -gt 0) {
			foreach ($subItem in $item.Expand) {
				AddUniqueRegion $subItem
			}
		}
	}

	return $ResultList | Sort-Object -Property Region
}

<#
	.Installation processing
	.安装处理
#>
Function Install-Process
{
	param
	(
		[string]$Version,
		[switch]$Activation,
		[switch]$Cleanup,
		[switch]$Force
	)

	<#
		1. 判断是否存在 Setup.exe
		1. Determine if a Setup .exe exists
	#>
	$Init_Setup = "$($PSScriptRoot)\Setup.exe"

	if (-not (Test-Path $Init_Setup -PathType Leaf)) {
		Write-Host "   - No ODT tool found" -ForegroundColor Red

		$start_time = Get-Date
		Invoke-WebRequest -Uri "https://officecdn.microsoft.com/pr/wsus/setup.exe" -OutFile $Init_Setup -UseBasicParsing -TimeoutSec 30 -DisableKeepAlive -ErrorAction SilentlyContinue | Out-Null
		Write-Host "`n   Time Used: $((Get-Date).Subtract($start_time).Seconds) (s)`n"
	}

	if (Test-Path $Init_Setup -PathType Leaf) {
		Write-Host "`n   Discover the ODT tool`n   $($Init_Setup)" -ForegroundColor Green
	} else {
		Write-Host "   - No ODT tool found" -ForegroundColor Red
		return
	}

	$Global:UILanguage = (Get-Culture).Name
	$Global:OfficeSP = Convert-Path "$($PSScriptRoot)" -ErrorAction SilentlyContinue

	<#
		.部署前，获取已知语言并同步至配置文件

		.获取已安装的语言包
	#>
	$GetKnownLanguages = @()
	$GetAddedLanguage = @()
	$TempOfficeLanguage = @()
	Get-ChildItem "$($PSScriptRoot)\Data" -directory -ErrorAction SilentlyContinue | Foreach-Object {
		ForEach ($itemRegion in $Region) {
			Get-ChildItem -Path $_.FullName -Filter "*$($itemRegion.Region)*" -Include *.dat -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path -Path $_.FullName -PathType Leaf) {
					$GetKnownLanguages += $itemRegion.Region
				}
			}
		}
	}

	<#
		.Get the default language of the current operating system
		.获取当前操作系统默认语言
	#>
	Write-Host "`n   Main language: $($Global:UILanguage)"
	if ($GetKnownLanguages -Contains $Global:UILanguage) {
		$GetAddedLanguage += $Global:UILanguage
		$TempOfficeLanguage += "			<Language ID=""$($Global:UILanguage)"" />`n"
	} else {
		if ($GetKnownLanguages -Contains "en-US") {
			$GetAddedLanguage += "en-US"
			$TempOfficeLanguage += "			<Language ID=""en-US"" />`n"
		}
	}

	foreach ($item in $GetKnownLanguages) {
		if ($GetAddedLanguage -notcontains $item) {
			$GetAddedLanguage += $item
			$TempOfficeLanguage += "			<Language ID=""$($item)"" />`n"
		}
	}

	$RandomGuid = [guid]::NewGuid()
	$TempGuidConfiguration = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	CheckCatalog -chkpath $TempGuidConfiguration
	Write-Host "`n   Configuration temp folder: $($TempGuidConfiguration)"

	Copy-Item -Path "$($PSScriptRoot)\Configuration\*.xml" -Destination $TempGuidConfiguration -Force -ErrorAction SilentlyContinue
	Get-ChildItem $TempGuidConfiguration -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }

	<#
		.Replace xml
		.替换 xml
	#>
	Get-ChildItem –Path "$($TempGuidConfiguration)\*.xml" | Where-Object {
		(Get-Content $_.FullName) | Foreach-Object {
			$_ -replace "--REPLACELANGUAGE--", $TempOfficeLanguage `
			   -replace "--REPLACESourcePath--", $Global:OfficeSP
		} | Set-Content -Path $_.FullName -ErrorAction SilentlyContinue
	}

	<#
		.Determine whether there is Setup.exe
		.判断是否存在 Setup.exe

		https://www.microsoft.com/en-us/download/details.aspx?id=49117
	#>
	Write-Host "`n   Sources: $($Global:OfficeSP)"

	<#
		.Convert the architecture type, configure according to the architecture settings
		.转换架构类型，按架构设置配置
	#>
	$XmlConfiguration = "Default"
	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\Arm64.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).arm64.xml"
			} else {
				if (Test-Path -Path "$($Global:OfficeSP)\Data\v64.cab" -PathType Leaf) {
					$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x64.xml"
				} else {
					if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
						$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\v64.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x64.xml"
			} else {
				if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
					$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
				}
			}
		}
		"x86" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
			}
		}
	}

	<#
		.Determine the configuration file
		.判断配置文件
	#>
	$FlagsClean = $False
	if (Test-Path $XmlConfiguration -PathType Leaf) {
		Write-Host "`n   Install`n   Sources: $($XmlConfiguration)"
		Start-Process -FilePath $Init_Setup -ArgumentList "/configure $($XmlConfiguration)" -wait -WindowStyle Minimized

		Write-Host "`n   Installation status" -ForegroundColor Red
		if (Install-StatusCheck) {
			Write-Host "   - It has been installed`n" -ForegroundColor Green

			<#
				.After passing the installation status check, get whether to clear the installation package after success
				.通过安装状态检查后，成功后获取是否清除安装包
			#>
			if ($Cleanup) {
				$FlagsClean = $True
			}

			<#
				.Activation method
				.激活方式
			#>
			if ($Activation) {
				if (Test-Path "$($Global:OfficeSP)\Tools.exe" -PathType Leaf) {
					<#
						.Add to Defend rule
						.添加到 Defend 规则
					#>
					Add-MpPreference -ExclusionPath "$($Global:OfficeSP)\Tools.exe" -ErrorAction SilentlyContinue | Out-Null
					Start-Process -FilePath "$($Global:OfficeSP)\Tools.exe" -ArgumentList "*" -Wait
					Remove-MpPreference -ExclusionPath "$($Global:OfficeSP)\Tools.exe"
				}
			}
		} else {
			Write-Host "   - Not Installed`n" -ForegroundColor Red
		}
	} else {
		Write-Host "   - The installation configuration file was not found.`n" -ForegroundColor Red
		return
	}

	if ($Force) {
		$FlagsClean = $True
	}

	if ($FlagsClean) {
		$RandomTempGuid = [guid]::NewGuid()
		$test_tmp_filename = "$($Global:OfficeSP)\writetest-$($RandomTempGuid)"
		Out-File -FilePath $test_tmp_filename -Encoding utf8 -ErrorAction SilentlyContinue

		if (Test-Path $test_tmp_filename -PathType Leaf) {
			Remove-Item -Path $test_tmp_filename -Force -ErrorAction SilentlyContinue
			RemoveTree "$($Global:OfficeSP)"

			<#
				.In order to prevent the installation package from being unable to be cleaned up, the next time you log in, execute it again
				.为了防止无法清理安装包，下次登录时，再次执行
			#>
			Write-Host "   After logging in next time, Clear Office Install Folder`n" -ForegroundColor Green
			$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
			$regKey = "Clear Office Install Folder"
			$regValue = "cmd.exe /c rd /s /q ""$($Global:OfficeSP)"""
			if (Test-Path $regPath) {
				New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
			} else {
				New-Item -Path $regPath -Force | Out-Null
				New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
			}
		} else {
			Write-Host "   - Unable to clear Office installation package directory.`n" -ForegroundColor Red
		}
	}

	<#
		.Clean up the temporary configuration directory
		.清理临时配置目录
	#>
	RemoveTree $TempGuidConfiguration

	<#
		.Rearrange the desktop icons by name
		.重新按名称排列桌面图标
	#>
	ResetDesktop
}

Function Install-StatusCheck
{
	$OfficeProduct = @(
		"Word"
		"Access"
		"Excel"
		"Lync"
		"OneDrive"
		"OneNote"
		"Outlook"
		"PowerPoint"
		"Publisher"
		"Teams"
	)

	foreach ($item in $OfficeProduct) {
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Office\16.0\$($item)" -ErrorAction SilentlyContinue) {
			return $True
		}
	}

	if (Test-Path "${env:ProgramFiles}\Microsoft Office\Office16\OSPP.VBS" -PathType Leaf) {
		return $True
	}

	if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\Office16\OSPP.VBS" -PathType Leaf) {
		return $True
	}

	# Check if Office 365 suite was installed correctly.
	$RegLocations = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
					  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
					)
	foreach ($Key in (Get-ChildItem $RegLocations) ) {
		if ($Key.GetValue('DisplayName') -like '*Microsoft 365*') {
			$OfficeVersionInstalled = $Key.GetValue('DisplayName')
			return $True
		}
	}

	return $False
}

<#
	.Create a directory
	.创建目录
#>
Function CheckCatalog
{
	Param
	(
		[string]$chkpath
	)

	if (-not (Test-Path $chkpath -PathType Container)) {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (-not (Test-Path $chkpath -PathType Container)) {
			Write-Host "   - Create Folder Failed $($chkpath)`n" -ForegroundColor Red
			return
		}
	}
}

<#
	.Try to delete the directory
	.尝试删除目录
#>
Function RemoveTree
{
	Param
	(
		[string]$Path
	)

	Remove-Item -Path $Path -force -Recurse -ErrorAction silentlycontinue -Confirm:$false | Out-Null

	if (Test-Path "$($Path)\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -Path $_.FullName -force -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			RemoveTree -Path $_.FullName
		}

		if (Test-Path "$($Path)\" -ErrorAction silentlycontinue) {
			Remove-Item -Path $Path -force -Recurse -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
		}
	}
}

<#
	.Refresh icon cache
	.刷新图标缓存
#>
Function RefreshIconCache
{
	$code = @'
	private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
	private const int WM_SETTINGCHANGE = 0x1a;
	private const int SMTO_ABORTIFHUNG = 0x0002;

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
private static extern IntPtr SendMessageTimeout ( IntPtr hWnd, int Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult );

[System.Runtime.InteropServices.DllImport("Shell32.dll")] 
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

public static void Refresh() {
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);
}
'@

	Add-Type -MemberDefinition $code -Namespace MyWinAPI -Name Explorer
	[MyWinAPI.Explorer]::Refresh()
}

Function RestartExplorer
{
	Stop-Process -ProcessName explorer -force -ErrorAction SilentlyContinue
	Start-Sleep 5
	$Running = Get-Process explorer -ErrorAction SilentlyContinue
	if (-not ($Running)) {
		Start-Process "explorer.exe"
	}
}

<#
	.Rearrange the desktop icons by name
	.重新按名称排列桌面图标
#>
Function ResetDesktop
{
	$ResetDesktopReg = @(
		'HKCU:\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
	)

	foreach ($item in $ResetDesktopReg) {
		Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	RestartExplorer
	RefreshIconCache
}

<#
	.Install Office version
	.安装 Office 版本

	Usage:
	用法：

	-Version
		"365"
			| O365ProPlusRetail        = Office 365 Apps for Enterprise
			| O365BusinessRetail       = Office 365 Apps for business
			| O365SmallBusPremRetail   = Office 365 Small Business Premium
			| O365HomePremRetail       = Office 365 Home

		"2021"
			| ProPlus2021Volume        = Office Professional Plus 2021 Volume


	-Activation  | After the installation is successful, try the activation method
                   安装成功后，尝试激活方式
	-Cleanup     | After the installation is successful, clear the Office installation package directory
                   安装成功后，清除 Office 安装包目录
	-Force       | Regardless of whether the installation succeeds or fails, the installation package directory is forcibly cleared
                   无论安装成功和失败时，强制清除 Office 安装包目录

#>

Install-Process -Version "O365ProPlusRetail" -Activation