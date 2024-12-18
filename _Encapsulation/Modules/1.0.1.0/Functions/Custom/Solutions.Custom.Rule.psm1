<#
	.Language packs, search for file types
	.语言包，搜索文件类型
#>
$Global:Search_Language_File_Type = @(
	"*.esd"
	"*.cab"
)
<#
	.Exclusions when removing all InBox apps
	.删除所有 InBox Apps  应用时排除项
#>
$Global:Exclude_InBox_Apps_Delete = @(
	"*DesktopAppInstaller*"
	"*SecHealthUI*"
)

<#
	.Search order for language pack files
	.搜索语言包文件顺序
#>
$Global:Search_File_Order = @{
	<#
		.字体
	#>
	Fonts = @(
		"*LanguageFeatures-Fonts*"
		"*WinPE-FontSupport*"

		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~x64~*"
		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~amd64~*"
		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~wow64~*"
		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~arm64.x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~arm64~*"

		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~x64~*"
		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~amd64~*"
		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~wow64~*"
		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~arm64.x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~arm64~*"

		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~x64~*"
		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~amd64~*"
		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~wow64~*"
		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~arm64.x86~*"
		"*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~arm64~*"
	)

	<#
		.基本
	#>
	Basic = @(
		<#
			.新版文件名称
		#>
		"*Windows-Server-Language-Pack*"
		"*Windows-Client-Language-Pack*"
		"*Windows-Lip-Language-Pack*"

		<#
			.过时的，旧版
		#>
		"*LanguageFeatures-Basic*"
		"*WinPE-Setup*"
		"*lp.cab*"
	)

	<#
		.特定包
		 https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-language-fod?view=windows-11#other-region-specific-Prerequisite
	#>
	RegionSpecific = @(
		"*InternationalFeatures*"
	)

	<#
		.光学字符识别
	#>
	OCR = @(
		"*LanguageFeatures-OCR*"
	)

	<#
		.手写内容识别
	#>
	Handwriting = @(
		"*LanguageFeatures-Handwriting*"
	)

	<#
		.文本转语音
	#>
	TextToSpeech = @(
		"*LanguageFeatures-TextToSpeech*"
	)

	<#
		.语音识别
	#>
	Speech = @(
		"*LanguageFeatures-Speech*"
	)

	<#
		.按需功能
	#>
	Features_On_Demand = @(
		<#
			.Install
		#>
		"*InternetExplorer*~x86~*"
		"*InternetExplorer*~x64~*"
		"*InternetExplorer*~amd64~*"
		"*InternetExplorer*~wow64~*"
		"*InternetExplorer*~arm64.x86~*"
		"*InternetExplorer*~arm64~*"

		"*MSPaint*~x86~*"
		"*MSPaint*~x64~*"
		"*MSPaint*~amd64~*"
		"*MSPaint*~wow64~*"
		"*MSPaint*~arm64.x86~*"
		"*MSPaint*~arm64~*"

		"*Notepad-FoD-Package*~x86~*"
		"*Notepad-FoD-Package*~x64~*"
		"*Notepad-FoD-Package*~amd64~*"
		"*Notepad-FoD-Package*~wow64~*"
		"*Notepad-FoD-Package*~arm64.x86~*"
		"*Notepad-FoD-Package*~arm64~*"

		"*Notepad-System-FoD-Package*~x86~*"
		"*Notepad-System-FoD-Package*~x64~*"
		"*Notepad-System-FoD-Package*~amd64~*"
		"*Notepad-System-FoD-Package*~wow64~*"
		"*Notepad-System-FoD-Package*~arm64.x86~*"
		"*Notepad-System-FoD-Package*~arm64~*"

		"*MediaPlayer*~x86~*"
		"*MediaPlayer*~x64~*"
		"*MediaPlayer*~amd64~*"
		"*MediaPlayer*~wow64~*"
		"*MediaPlayer*~arm64.x86~*"
		"*MediaPlayer*~arm64~*"

		"*PowerShell*ISE*~x86~*"
		"*PowerShell*ISE*~x64~*"
		"*PowerShell*ISE*~amd64~*"
		"*PowerShell*ISE*~wow64~*"
		"*PowerShell*ISE*~arm64.x86~*"
		"*PowerShell*ISE*~arm64~*"

		"*StepsRecorder*~x86~*"
		"*StepsRecorder*~x64~*"
		"*StepsRecorder*~amd64~*"
		"*StepsRecorder*~wow64~*"
		"*StepsRecorder*~arm64.x86~*"
		"*StepsRecorder*~arm64~*"

		"*SnippingTool*~x86~*"
		"*SnippingTool*~x64~*"
		"*SnippingTool*~amd64~*"
		"*SnippingTool*~wow64~*"
		"*SnippingTool*~arm64.x86~*"
		"*SnippingTool*~arm64~*"

		"*WMIC*~x86~*"
		"*WMIC*~x64~*"
		"*WMIC*~amd64~*"
		"*WMIC*~wow64~*"
		"*WMIC*~arm64.x86~*"
		"*WMIC*~arm64~*"

		"*WordPad*~x86~*"
		"*WordPad*~x64~*"
		"*WordPad*~amd64~*"
		"*WordPad*~wow64~*"
		"*WordPad*~arm64.x86~*"
		"*WordPad*~arm64~*"

		"*Printing-WFS*~x86~*"
		"*Printing-WFS*~x64~*"
		"*Printing-WFS*~amd64~*"
		"*Printing-WFS*~wow64~*"
		"*Printing-WFS*~arm64.x86~*"
		"*Printing-WFS*~arm64~*"

		"*Printing-PMCPPC*~x86~*"
		"*Printing-PMCPPC*~x64~*"
		"*Printing-PMCPPC*~amd64~*"
		"*Printing-PMCPPC*~wow64~*"
		"*Printing-PMCPPC*~arm64.x86~*"
		"*Printing-PMCPPC*~arm64~*"

		"*Telnet-Client*~x86~*"
		"*Telnet-Client*~x64~*"
		"*Telnet-Client*~amd64~*"
		"*Telnet-Client*~wow64~*"
		"*Telnet-Client*~arm64.x86~*"
		"*Telnet-Client*~arm64~*"

		"*TFTP-Client*~x86~*"
		"*TFTP-Client*~x64~*"
		"*TFTP-Client*~amd64~*"
		"*TFTP-Client*~wow64~*"
		"*TFTP-Client*~arm64.x86~*"
		"*TFTP-Client*~arm64~*"

		"*VBSCRIPT*~x86~*"
		"*VBSCRIPT*~x64~*"
		"*VBSCRIPT*~amd64~*"
		"*VBSCRIPT*~wow64~*"
		"*VBSCRIPT*~arm64.x86~*"
		"*VBSCRIPT*~arm64~*"

		"*WinOcr-FOD-Package*~x86~*"
		"*WinOcr-FOD-Package*~x64~*"
		"*WinOcr-FOD-Package*~amd64~*"
		"*WinOcr-FOD-Package*~wow64~*"
		"*WinOcr-FOD-Package*~arm64.x86~*"
		"*WinOcr-FOD-Package*~arm64~*"

		"*ProjFS-OptionalFeature-FOD-Package*~x86~*"
		"*ProjFS-OptionalFeature-FOD-Package*~x64~*"
		"*ProjFS-OptionalFeature-FOD-Package*~amd64~*"
		"*ProjFS-OptionalFeature-FOD-Package*~wow64~*"
		"*ProjFS-OptionalFeature-FOD-Package*~arm64.x86~*"
		"*ProjFS-OptionalFeature-FOD-Package*~arm64~*"

		"*SimpleTCP-FOD-Package*~x86~*"
		"*SimpleTCP-FOD-Package*~x64~*"
		"*SimpleTCP-FOD-Package*~amd64~*"
		"*SimpleTCP-FOD-Package*~wow64~*"
		"*SimpleTCP-FOD-Package*~arm64.x86~*"
		"*SimpleTCP-FOD-Package*~arm64~*"

		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~x86~*"
		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~x64~*"
		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~amd64~*"
		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~wow64~*"
		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~arm64.x86~*"
		"*VirtualMachinePlatform-Client-Disabled-FOD-Package*~arm64~*"

		"*DirectoryServices-ADAM-Client-FOD-Package*~x86~*"
		"*DirectoryServices-ADAM-Client-FOD-Package*~x64~*"
		"*DirectoryServices-ADAM-Client-FOD-Package*~amd64~*"
		"*DirectoryServices-ADAM-Client-FOD-Package*~wow64~*"
		"*DirectoryServices-ADAM-Client-FOD-Package*~arm64.x86~*"
		"*DirectoryServices-ADAM-Client-FOD-Package*~arm64~*"

		"*EnterpriseClientSync-Host-FOD-Package*~x86~*"
		"*EnterpriseClientSync-Host-FOD-Package*~x64~*"
		"*EnterpriseClientSync-Host-FOD-Package*~amd64~*"
		"*EnterpriseClientSync-Host-FOD-Package*~wow64~*"
		"*EnterpriseClientSync-Host-FOD-Package*~arm64.x86~*"
		"*EnterpriseClientSync-Host-FOD-Package*~arm64~*"

		"*SenseClient-FoD-Package*~x86~*"
		"*SenseClient-FoD-Package*~x64~*"
		"*SenseClient-FoD-Package*~amd64~*"
		"*SenseClient-FoD-Package*~wow64~*"
		"*SenseClient-FoD-Package*~arm64.x86~*"
		"*SenseClient-FoD-Package*~arm64~*"

		"*SmbDirect-FOD-Package*~x86~*"
		"*SmbDirect-FOD-Package*~x64~*"
		"*SmbDirect-FOD-Package*~amd64~*"
		"*SmbDirect-FOD-Package*~wow64~*"
		"*SmbDirect-FOD-Package*~arm64.x86~*"
		"*SmbDirect-FOD-Package*~arm64~*"

		"*TerminalServices-AppServer-Client-FOD-Package*~x86~*"
		"*TerminalServices-AppServer-Client-FOD-Package*~x64~*"
		"*TerminalServices-AppServer-Client-FOD-Package*~amd64~*"
		"*TerminalServices-AppServer-Client-FOD-Package*~wow64~*"
		"*TerminalServices-AppServer-Client-FOD-Package*~arm64.x86~*"
		"*TerminalServices-AppServer-Client-FOD-Package*~arm64~*"

			<#	
				.WinRE
			#>
			"*winpe-appxdeployment*"
			"*winpe-appxpackaging*"
			"*winpe-storagewmi*"
			"*winpe-wifi*"
			"*winpe-windowsupdate*"
			"*winpe-rejuv*"
			"*winpe-opcservices*"
			"*winpe-hta*"

		<#
			.Boot
		#>
		"*winpe-securestartup*"
		"*winpe-atbroker*"
		"*winpe-audiocore*"
		"*winpe-audiodrivers*"
		"*winpe-enhancedstorage*"
		"*winpe-narrator*"
		"*winpe-scripting*"
		"*winpe-speech-tts*"
		"*winpe-srh*"
		"*winpe-srt*"
		"*winpe-wds*"
		"*winpe-wmi*"
		"*winpe-connectivity*"
		"*winpe-x86ec-support*"
		"*winpe-x64ec-support*"
		"*winpe-arm64ec-support*"
	)

	<#
		.零售演示体验
	#>
	Retail = @(
		"*RetailDemo*"
	)
}

<#
	.Signed GPG KEY-ID
	.签名 GPG KEY-ID
#>
$Global:GpgKI = @(
	"0FEBF674EAD23E05"
	"2499B7924675A12B"
)

<#
	.Update, search for file types
	.更新，搜索文件类型
#>
$Global:Search_KB_File_Type = @(
	"*.esd"
	"*.cab"
	"*.msu"
	"*.mum"
)

<#
	.Exclude items that are not cleaned up
	.排除不清理的项目
#>
$Global:ExcludeClearSuperseded = @(
	"*Microsoft-Windows-UserExperience-Desktop-Package*"
)