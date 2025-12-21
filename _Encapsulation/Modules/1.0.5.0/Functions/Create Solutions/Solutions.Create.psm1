<#
	.添加部署时，必选项
#>
$Script:Init_Pre_Select_Command = @(
	"a94cc882-a451-494d-8d94-523e06470f68"
	"f6ba749e-3a36-4a2e-bc28-674073cb973b"
)

<#
	.命令行规则
#>
$Global:Pre_Config_Command_Rules = @(
	@{
		GUID    = "a94cc882-a451-494d-8d94-523e06470f68"
		Name    = $lang.PowerShell_Unrestricted
		Apply   = @(
			"Microsoft-Windows-Shell-Setup"
		)
		Command = @(
			"powershell -Command ""Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'LocalMachine' -Force"""
		)
	}
	@{
		GUID    = "f6ba749e-3a36-4a2e-bc28-674073cb973b"
		Name    = $lang.Allow_Running_Deploy_Engine
		Apply   = @(
			"Microsoft-Windows-Shell-Setup"
		)
		Command = @(
			"PowerShell -ExecutionPolicy Bypass -File ""%SystemDrive%\{UniqueID}\Engine\Engine.ps1"" -Force"
		)
	}
	@{
		GUID    = "9709d822-2ffc-45a9-86c4-0cf48a66f499"
		Name    = $lang.Bypass_TPM
		Apply   = @(
			"Microsoft-Windows-Setup"
		)
		Command = @(
			"reg.exe add ""HKLM\SYSTEM\Setup\LabConfig"" /v BypassTPMCheck /t REG_DWORD /d 1 /f"
			"reg.exe add ""HKLM\SYSTEM\Setup\LabConfig"" /v BypassSecureBootCheck /t REG_DWORD /d 1 /f"
			"reg.exe add ""HKLM\SYSTEM\Setup\LabConfig"" /v BypassStorageCheck /t REG_DWORD /d 1 /f"
			"reg.exe add ""HKLM\SYSTEM\Setup\LabConfig"" /v BypassRAMCheck /t REG_DWORD /d 1 /f"
		)
	}
	@{
		GUID    = "36b16b3f-b539-44aa-b340-9c8b1b7e3f56"
		Name    = $lang.Disable_BitLocker
		Apply   = @(
			"Microsoft-Windows-Setup"
		)
		Command = @(
			"reg.exe add ""HKLM\SYSTEM\CurrentControlSet\Control\BitLocker"" /v PreventDeviceEncryption /t REG_DWORD /d 1 /f"
		)
	}
)

<#
	.KMS 产品序列号
	 https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys

	.排序：内核、系统类型、系统名称、序列号
#>
$SearchKMS = @(
	# Windows 11
	@{ Type = "Desktop"; ProductKey = "TX9XD-98N7V-6WMQ6-BX7FG-H8Q99"; Name = "Windows 11 Home"; }
	@{ Type = "Desktop"; ProductKey = "3KHY7-WNT83-DGQKR-F7HPR-844BM"; Name = "Windows 11 Home N"; }
	@{ Type = "Desktop"; ProductKey = "7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"; Name = "Windows 11 Home Single Language"; }
	@{ Type = "Desktop"; ProductKey = "PVMJN-6DFY6-9CCP6-7BKTT-D3WVR"; Name = "Windows 11 Home Country Specific"; }
	@{ Type = "Desktop"; ProductKey = "W269N-WFGWX-YVC9B-4J6C9-T83GX"; Name = "Windows 11 Professional"; }
	@{ Type = "Desktop"; ProductKey = "MH37W-N47XK-V7XM9-C7227-GCQG9"; Name = "Windows 11 Professional N"; }
	@{ Type = "Desktop"; ProductKey = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"; Name = "Windows 11 Education"; }
	@{ Type = "Desktop"; ProductKey = "2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"; Name = "Windows 11 Education N"; }
	@{ Type = "Desktop"; ProductKey = "NPPR9-FWDCX-D2C8J-H872K-2YT43"; Name = "Windows 11 Enterprise"; }
	@{ Type = "Desktop"; ProductKey = "DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4"; Name = "Windows 11 Enterprise N"; }

	@{ Type = "Desktop"; ProductKey = "4KRN2-9B6KQ-PT2K3-Y7QJC-76G6R"; Name = "Windows 11 IoT Enterprise LTSC 2024 OEM Activation 3.0 (OA3.0)"; }
	@{ Type = "Desktop"; ProductKey = "XQQYW-NFFMW-XJPBH-K8732-CKFFD"; Name = "Windows 11 IoT Enterprise OEM Activation 3.0 (OA3.0)"; }

	@{ Type = "Desktop"; ProductKey = "6283C-4NH4W-GD3CJ-8JBCV-8HYP3"; Name = "Windows 11 IoT Enterprise LTSC 2024 Product Key Entry Activation (PKEA / ePKEA)"; }
	@{ Type = "Desktop"; ProductKey = "CHCDD-NBFKY-M8DJM-MHYBQ-T6RFF"; Name = "Windows 11 IoT Enterprise Product Key Entry Activation (PKEA / ePKEA)"; }

	# Windows Server 2025
	@{ Type = "Server";  ProductKey = "D764K-2NDRG-47T6Q-P8T8W-YP6DF"; Name = "Windows Server vNext and 2025 Datacenter"; }
	@{ Type = "Server";  ProductKey = "TVRH6-WHNXV-R9WG3-9XRFY-MY832"; Name = "Windows Server vnext and 2025 Standard"; }

	# Windows Server vNext
	@{ Type = "Server";  ProductKey = "2KNJJ-33Y9H-2GXGX-KMQWH-G6H67"; Name = "Windows Server vNext and 2025 Datacenter"; }
	@{ Type = "Server";  ProductKey = "MFY9F-XBN2F-TYFMP-CCV49-RMYVH"; Name = "Windows Server vnext and 2025 Standard"; }

	# Windows Server 2022
	@{ Type = "Server";  ProductKey = "WX4NM-KYWYW-QJJR4-XV3QB-6VM33"; Name = "Windows Server 2022 Datacenter"; }
	@{ Type = "Server";  ProductKey = "VDYBN-27WPP-V4HQT-9VMD4-VMK7H"; Name = "Windows Server 2022 Standard"; }

	# Windows 10, all supported Semi-Annual Channel versions
	@{ Type = "Desktop"; ProductKey = "W269N-WFGWX-YVC9B-4J6C9-T83GX"; Name = "Windows 10 Pro"; }
	@{ Type = "Desktop"; ProductKey = "MH37W-N47XK-V7XM9-C7227-GCQG9"; Name = "Windows 10 Pro N"; }
	@{ Type = "Desktop"; ProductKey = "NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"; Name = "Windows 10 Pro for Workstations"; }
	@{ Type = "Desktop"; ProductKey = "9FNHH-K3HBT-3W4TD-6383H-6XYWF"; Name = "Windows 10 Pro for Workstations N"; }
	@{ Type = "Desktop"; ProductKey = "6TP4R-GNPTD-KYYHQ-7B7DP-J447Y"; Name = "Windows 10 Pro Education"; }
	@{ Type = "Desktop"; ProductKey = "YVWGF-BXNMC-HTQYQ-CPQ99-66QFC"; Name = "Windows 10 Pro Education N"; }
	@{ Type = "Desktop"; ProductKey = "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"; Name = "Windows 10 Education"; }
	@{ Type = "Desktop"; ProductKey = "2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"; Name = "Windows 10 Education N"; }
	@{ Type = "Desktop"; ProductKey = "NPPR9-FWDCX-D2C8J-H872K-2YT43"; Name = "Windows 10 Enterprise"; }
	@{ Type = "Desktop"; ProductKey = "DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4"; Name = "Windows 10 Enterprise N"; }
	@{ Type = "Desktop"; ProductKey = "YYVX9-NTFWV-6MDM3-9PT4T-4M68B"; Name = "Windows 10 Enterprise G"; }
	@{ Type = "Desktop"; ProductKey = "44RPN-FTY23-9VTTB-MP9BX-T84FV"; Name = "Windows 10 Enterprise G N"; }

	# Windows 10 LTSC 2019
	@{ Type = "Desktop"; ProductKey = "M7XTQ-FN8P6-TTKYV-9D4CC-J462D"; Name = "Windows 10 Enterprise LTSC 2019"; }
	@{ Type = "Desktop"; ProductKey = "92NFX-8DJQP-P6BBQ-THF9C-7CG2H"; Name = "Windows 10 Enterprise N LTSC 2019"; }

	# Windows 10 LTSB 2016
	@{ Type = "Desktop"; ProductKey = "DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ"; Name = "Windows 10 Enterprise LTSB 2016"; }
	@{ Type = "Desktop"; ProductKey = "QFFDN-GRT3P-VKWWX-X7T3R-8B639"; Name = "Windows 10 Enterprise N LTSB 2016"; }

	# Windows 10 LTSB 2015
	@{ Type = "Desktop"; ProductKey = "WNMTR-4C88C-JK8YV-HQ7T2-76DF9"; Name = "Windows 10 Enterprise 2015 LTSB"; }
	@{ Type = "Desktop"; ProductKey = "2F77B-TNFGY-69QQF-B8YKP-D69TJ"; Name = "Windows 10 Enterprise 2015 LTSB N"; }

	# Windows Server 2019
	@{ Type = "Server";  ProductKey = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"; Name = "Windows Server 2019 Datacenter"; }
	@{ Type = "Server";  ProductKey = "N69G4-B89J2-4G8F4-WWYCC-J464C"; Name = "Windows Server 2019 Standard"; }
	@{ Type = "Server";  ProductKey = "WVDHN-86M7X-466P6-VHXV7-YY726"; Name = "Windows Server 2019 Essentials"; }

	# Windows Server 2016
	@{ Type = "Server";  ProductKey = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"; Name = "Windows Server 2016 Datacenter"; }
	@{ Type = "Server";  ProductKey = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"; Name = "Windows Server 2016 Standard"; }
	@{ Type = "Server";  ProductKey = "JCKRF-N37P4-C2D82-9YXRT-4M63B"; Name = "Windows Server 2016 Essentials"; }
	
	# Windows Server, version 1909, 1903
	@{ Type = "Server";  ProductKey = "6NMRW-2C8FM-D24W7-TQWMY-CWH2D"; Name = "Windows Server 1909, 1903 Datacenter"; }
	@{ Type = "Server";  ProductKey = "N2KJX-J94YW-TQVFB-DG9YT-724CC"; Name = "Windows Server 1909, 1903 Standard"; }

	# Windows Server, version 1803
	@{ Type = "Server";  ProductKey = "2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG"; Name = "Windows Server 1803 Datacenter"; }
	@{ Type = "Server";  ProductKey = "PTXN8-JFHJM-4WC78-MPCBR-9W4KR"; Name = "Windows Server 1803 Standard"; }

	# Windows Server, version 1709
	@{ Type = "Server";  ProductKey = "6Y6KB-N82V8-D8CQV-23MJW-BWTG6"; Name = "Windows Server 1709 Datacenter"; }
	@{ Type = "Server";  ProductKey = "DPCNP-XQFKJ-BJF7R-FRC8D-GF6G4"; Name = "Windows Server 1709 Standard"; }

	# Windows 7
	@{ Type = "Desktop"; ProductKey = "D4F6K-QK3RD-TMVMJ-BBMRX-3MBMV"; Name = "Windows 7 Ultimate"; }
	@{ Type = "Desktop"; ProductKey = "FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4"; Name = "Windows 7 Professional"; }
	@{ Type = "Desktop"; ProductKey = "MRPKT-YTG23-K7D7T-X2JMM-QY7MG"; Name = "Windows 7 Professional N"; }
	@{ Type = "Desktop"; ProductKey = "W82YF-2Q76Y-63HXB-FGJG9-GF7QX"; Name = "Windows 7 Professional E"; }
	@{ Type = "Desktop"; ProductKey = "33PXH-7Y6KF-2VJC9-XBBR8-HVTHH"; Name = "Windows 7 Enterprise"; }
	@{ Type = "Desktop"; ProductKey = "YDRBP-3D83W-TY26F-D46B2-XCKRJ"; Name = "Windows 7 Enterprise N"; }
	@{ Type = "Desktop"; ProductKey = "C29WB-22CC8-VJ326-GHFJW-H9DH4"; Name = "Windows 7 Enterprise E"; }

	# Windows 8
	@{ Type = "Desktop"; ProductKey = "GCRJD-8NW9H-F2CDX-CCM8D-9D6T9"; Name = "Windows 8.1 Pro"; }
	@{ Type = "Desktop"; ProductKey = "HMCNV-VVBFX-7HMBH-CTY9B-B4FXY"; Name = "Windows 8.1 Pro N"; }
	@{ Type = "Desktop"; ProductKey = "MHF9N-XY6XB-WVXMC-BTDCT-MKKG7"; Name = "Windows 8.1 Enterprise"; }
	@{ Type = "Desktop"; ProductKey = "TT4HM-HN7YT-62K67-RGRQJ-JFFXW"; Name = "Windows 8.1 Enterprise N"; }
	@{ Type = "Desktop"; ProductKey = "NG4HW-VH26C-733KW-K6F98-J8CK4"; Name = "Windows 8 Pro"; }
	@{ Type = "Desktop"; ProductKey = "XCVCF-2NXM9-723PB-MHCB7-2RYQQ"; Name = "Windows 8 Pro N"; }
	@{ Type = "Desktop"; ProductKey = "32JNW-9KQ84-P47T8-D8GGY-CWCK7"; Name = "Windows 8 Enterprise"; }
	@{ Type = "Desktop"; ProductKey = "JMNMF-RHW7P-DMY6X-RF3DR-X2BQT"; Name = "Windows 8 Enterprise N"; }

	# Windows Server 2012 R2
	@{ Type = "Server";  ProductKey = "D2N9P-3P6X9-2R39C-7RTCD-MDVJX"; Name = "Windows Server 2012 R2 Server Standard"; }
	@{ Type = "Server";  ProductKey = "W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9"; Name = "Windows Server 2012 R2 Datacenter"; }
	@{ Type = "Server";  ProductKey = "KNC87-3J2TX-XB4WP-VCPJV-M4FWM"; Name = "Windows Server 2012 R2 Essentials"; }

	# Windows Server 2012
	@{ Type = "Server";  ProductKey = "BN3D2-R7TKB-3YPBD-8DRP2-27GG4"; Name = "Windows Server 2012"; }
	@{ Type = "Server";  ProductKey = "8N2M2-HWPGY-7PGT9-HGDD8-GVGGY"; Name = "Windows Server 2012 N"; }
	@{ Type = "Server";  ProductKey = "2WN2H-YGCQR-KFX6K-CD6TF-84YXQ"; Name = "Windows Server 2012 Single Language"; }
	@{ Type = "Server";  ProductKey = "4K36P-JN4VD-GDC6V-KDT89-DYFKP"; Name = "Windows Server 2012 Country Specific"; }
	@{ Type = "Server";  ProductKey = "XC9B7-NBPP2-83J2H-RHMBY-92BT4"; Name = "Windows Server 2012 Server Standard"; }
	@{ Type = "Server";  ProductKey = "HM7DN-YVMH3-46JC3-XYTG7-CYQJJ"; Name = "Windows Server 2012 MultiPoint Standard"; }
	@{ Type = "Server";  ProductKey = "XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G"; Name = "Windows Server 2012 MultiPoint Premium"; }
	@{ Type = "Server";  ProductKey = "48HP8-DN98B-MYWDG-T2DCC-8W83P"; Name = "Windows Server 2012 Datacenter"; }

	# Windows Server 2008 R2
	@{ Type = "Server";  ProductKey = "6TPJF-RBVHG-WBW2R-86QPH-6RTM4"; Name = "Windows Server 2008 R2 Web"; }
	@{ Type = "Server";  ProductKey = "TT8MH-CG224-D3D7Q-498W2-9QCTX"; Name = "Windows Server 2008 R2 HPC edition"; }
	@{ Type = "Server";  ProductKey = "YC6KT-GKW9T-YTKYR-T4X34-R7VHC"; Name = "Windows Server 2008 R2 Standard"; }
	@{ Type = "Server";  ProductKey = "489J6-VHDMP-X63PK-3K798-CPX3Y"; Name = "Windows Server 2008 R2 Enterprise"; }
	@{ Type = "Server";  ProductKey = "74YFP-3QFB3-KQT8W-PMXWJ-7M648"; Name = "Windows Server 2008 R2 Datacenter"; }
	@{ Type = "Server";  ProductKey = "GT63C-RJFQ3-4GMB6-BRFB9-CB83V"; Name = "Windows Server 2008 R2 for Itanium-based Systems"; }

	# Windows Server 2008
	@{ Type = "Server";  ProductKey = "WYR28-R7TFJ-3X2YQ-YCY4H-M249D"; Name = "Windows Web Server 2008"; }
	@{ Type = "Server";  ProductKey = "TM24T-X9RMF-VWXK6-X8JC9-BFGM2"; Name = "Windows Server 2008 Standard"; }
	@{ Type = "Server";  ProductKey = "W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ"; Name = "Windows Server 2008 Standard without Hyper-V"; }
	@{ Type = "Server";  ProductKey = "YQGMW-MPWTJ-34KDK-48M3W-X4Q6V"; Name = "Windows Server 2008 Enterprise"; }
	@{ Type = "Server";  ProductKey = "39BXF-X8Q23-P2WWT-38T2F-G3FPG"; Name = "Windows Server 2008 Enterprise without Hyper-V"; }
	@{ Type = "Server";  ProductKey = "RCTX3-KWVHP-BR6TB-RB6DM-6X7HP"; Name = "Windows Server 2008 HPC"; }
	@{ Type = "Server";  ProductKey = "7M67G-PC374-GR742-YH8V4-TCBY3"; Name = "Windows Server 2008 Datacenter"; }
	@{ Type = "Server";  ProductKey = "22XQ2-VRXRG-P8D42-K34TD-G3QQC"; Name = "Windows Server 2008 Datacenter without Hyper-V"; }
	@{ Type = "Server";  ProductKey = "4DWFP-JF3DJ-B7DTH-78FJB-PDRHK"; Name = "Windows Server 2008 for Itanium-Based Systems"; }
)

<#
	.Generate solution user interface
	.生成解决方案用户界面
#>
Function Solutions
{
	if (-not $Global:EventQueueMode) {
		Logo -Title $lang.Solution
		Write-Host "  $($lang.Dashboard)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		Write-Host "  $($lang.MountImageTo): " -NoNewline
		if (Test-Path -Path $Global:Mount_To_Route -PathType Container) {
			Write-Host $Global:Mount_To_Route -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Yellow
		}

		Write-Host "  $($lang.MainImageFolder): " -NoNewline
		if (Test-Path -Path $Global:Image_source -PathType Container) {
			Write-Host $Global:Image_source -ForegroundColor Green
		} else {
			Write-Host $Global:Image_source -ForegroundColor Red
			Write-Host "  $('-' * 80)"
			Write-Host "  $($lang.NoInstallImage)" -ForegroundColor Red
			ToWait -wait 2
		}

		Image_Get_Mount_Status
	}

	<#
		.Assign available tasks
		.分配可用的任务
	#>
	Event_Assign -Rule "Solutions_Create_UI" -Run
}

Function Solutions_Create_UI
{
	param
	(
		[array]$Autopilot,
		[switch]$ISO,
		[switch]$mount
	)

	if ($ISO) {
		$Script:init_To_GPS = "ISO"
	} else {
		if (Image_Is_Select_IAB) {
			$Script:init_To_GPS = "$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)"
		} else {
			$Script:init_To_GPS = "ISO"
		}
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Refres_Event_Tasks_Solutions_Add
	{
		$Falg_Event = $False

		if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$Falg_Event = $true
			$UI_Main_Dashboard_Event_Engine_Status.Text = "$($lang.EnabledEnglish): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Engine_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Engine_Status.Text = "$($lang.EnabledEnglish): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Engine_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$Falg_Event = $true
			$UI_Main_Dashboard_Event_Unattend_Status.Text = "$($lang.EnabledUnattend): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Unattend_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Unattend_Status.Text = "$($lang.EnabledUnattend): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Unattend_Clear.Text = $lang.EventManagerNo
		}

		if ((Get-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$Falg_Event = $true
			$UI_Main_Dashboard_Event_Collection_Status.Text = "$($lang.EnabledSoftwarePacker): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Collection_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Collection_Status.Text = "$($lang.EnabledSoftwarePacker): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Collection_Clear.Text = $lang.EventManagerNo
		}

		if ($Falg_Event) {
		} else {
			New-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -Value $False -Force
		}
		
		if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Enable)"
			$UI_Main_Dashboard_Event_Clear.Text = "$($lang.YesWork), $($lang.EventManagerCurrentClear)"
		} else {
			$UI_Main_Dashboard_Event_Status.Text = "$($lang.EventManager): $($lang.Disable)"
			$UI_Main_Dashboard_Event_Clear.Text = $lang.EventManagerNo
		}
	}

	Function Solutions_Event_Clear
	{
		param
		(
			[switch]$All,
			[switch]$Engine,
			[switch]$Unattend,
			[switch]$Collection
		)

		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($SolutionsToMount.Enabled) {
			if ($SolutionsToMount.Checked) {
				$Script:init_To_GPS = "$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)"
			}
		}

		if ($SolutionsToSources.Enabled) {
			if ($SolutionsToSources.Checked) {
				$Script:init_To_GPS = "ISO"
			}
		}

		if ($All) {
			New-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -Value $False -Force
		}

		if ($Engine) {
			New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -Value $False -Force
		}

		if ($Unattend) {
			New-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -Value $False -Force
		}

		if ($Collection) {
			New-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -Value $False -Force
		}

		Refres_Event_Tasks_Solutions_Add

		$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
	}

	Function Solutions_Create_Refresh_Regional
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue) {
			$GetNewSaveLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue
			$EngineRegionalShow.Text = $($lang.SolutionsEngineRegionalTips -f $Global:MainImageLang, $GetNewSaveLanguage)
		} else {
			$EngineRegionalShow.Text = $($lang.SolutionsEngineRegionalTips -f $Global:MainImageLang, $Global:MainImageLang)
		}
	}

	<#
		.事件：强行结束按需任务
	#>
	$UI_Main_Suggestion_Stop_Click = {
		$UI_Main.Hide()
		Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
		Event_Reset_Variable
		$UI_Main.Close()
	}

	Function Save_User_Select_Command_To_Regedit
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		<#
			.保存已选择的 Windows 安装项
		#>
		$Temp_Save_Windows_Setup = @()
		$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				if ("WinSetup" -eq $_.Name) {
					$_.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($_.Checked) {
								$Temp_Save_Windows_Setup += $_.Tag
							}
						}
					}
				}
			}
		}

		$Temp_Save_Windows_PE = @()
		$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
				if ("WinPE" -eq $_.Name) {
					$_.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.CheckBox]) {
							if ($_.Checked) {
								$Temp_Save_Windows_PE += $_.Tag
							}
						}
					}
				}
			}
		}

		<#
			.保存到注册表
		#>
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Save_Command_WinSetup" -value $Temp_Save_Windows_Setup -Multi
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Save_Command_WinSPE" -value $Temp_Save_Windows_PE -Multi
	}


	Function Solutions_Create_Refresh_Software_List
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$GroupSoftwareList.controls.Clear()

		switch ($Global:Architecture) {
			"arm64" {
				$ArchitectureARM64.Enabled = $True
				$ArchitectureAMD64.Enabled = $True
				$ArchitectureX86.Enabled = $True
			}
			"AMD64" {
				$ArchitectureARM64.Enabled = $False
				$ArchitectureAMD64.Enabled = $True
				$ArchitectureX86.Enabled = $True
			}
			"x86" {
				$ArchitectureARM64.Enabled = $False
				$ArchitectureAMD64.Enabled = $False
			}
		}

		switch ($Global:ArchitecturePack) {
			"arm64" {
				$ArchitectureARM64.Checked = $True
				$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsArm64
			}
			"AMD64" {
				$ArchitectureAMD64.Checked = $True
				$ArchitectureX86.Enabled = $True
				$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsAMD64
			}
			"x86" {
				$ArchitectureX86.Checked = $True
				$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsX86
			}
		}

		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Exclude_Software" -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Exclude_Software" -value "" -Multi
		}
		$GetExcludeSoftware = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Exclude_Software" -ErrorAction SilentlyContinue

		$ExcludeSoftware = @()
		ForEach ($item in $GetExcludeSoftware) {
			$ExcludeSoftware += $item
		}

		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Exclude_Fonts" -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Exclude_Fonts" -value "" -Multi
		}
		$GetExcludeFonts = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Exclude_Fonts" -ErrorAction SilentlyContinue

		$ExcludeFonts = @()
		ForEach ($item in $GetExcludeFonts) {
			$ExcludeFonts += $item
		}

		Get-ChildItem "$($PSScriptRoot)\..\..\..\..\_Custom\Software" -directory -ErrorAction SilentlyContinue | ForEach-Object {
			$Mark_Main_Folder = $_.BaseName

			Get-ChildItem $_.FullName -directory -ErrorAction SilentlyContinue | ForEach-Object {
				$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
					Height  = 35
					Width   = 412
					Text    = $_.BaseName
					Tag     = "$($Mark_Main_Folder)\$($_.BaseName)"
					add_Click      = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($ExcludeSoftware -Contains $_.BaseName) {
					$CheckBox.Checked = $False
				} else {
					$CheckBox.Checked = $True
				}

				$GroupSoftwareList.controls.AddRange($CheckBox)
			}
		}

		<#
			.Search font: file type
			.搜索字体：文件类型
		#>
		$SearchFontsType = @(
			"*.otf"
			"*.ttf"
		)

		Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Fonts" -Recurse -Include ($SearchFontsType) -ErrorAction SilentlyContinue | ForEach-Object {
			$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
				Height    = 35
				Width     = 412
				Text      = $_.BaseName
				Tag       = $_.FullName
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
				}
			}

			if ($ExcludeFonts -Contains $_.BaseName) {
				$CheckBox.Checked = $False
			} else {
				$CheckBox.Checked = $True
			}
			$GroupFontsList.controls.AddRange($CheckBox)
		}

		Solutions_Create_Refresh_Office_Status

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_PreOfficeVersion" -ErrorAction SilentlyContinue) {
			$GetTempSelectPacker = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_PreOfficeVersion" -ErrorAction SilentlyContinue
			$Solutions_Office_Select.Text = $GetTempSelectPacker
		}
	}

	Function Solutions_Create_Refresh_Office_Status
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$Solutions_Office_Select.Text = ""
		$Solutions_Office_Select.Items.Clear()

		if ($ArchitectureARM64.Checked) {
			Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office" -directory -ErrorAction SilentlyContinue | ForEach-Object {
				$NewFolderPath = $_.FullName

				$NewFolderFullPath = "$($NewFolderPath)\amd64\Office\Data\v64.cab"
				if (Test-Path -Path $NewFolderFullPath -PathType Leaf) {
					$Solutions_Office_Select.Items.Add($_.BaseName) | Out-Null
				}
			}
		}

		if ($ArchitectureAMD64.Checked) {
			Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office" -directory -ErrorAction SilentlyContinue | ForEach-Object {
				$NewFolderPath = $_.FullName

				$NewFolderFullPath = "$($NewFolderPath)\amd64\Office\Data\v64.cab"
				if (Test-Path -Path $NewFolderFullPath -PathType Leaf) {
					$Solutions_Office_Select.Items.Add($_.BaseName) | Out-Null
				}
			}
		}

		if ($ArchitectureX86.Checked) {
			Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office" -directory -ErrorAction SilentlyContinue | ForEach-Object {
				$NewFolderPath = $_.FullName

				$NewFolderFullPath = "$($NewFolderPath)\x86\Office\Data\v32.cab"
				if (Test-Path -Path $NewFolderFullPath -PathType Leaf) {
					$Solutions_Office_Select.Items.Add($_.BaseName) | Out-Null
				}
			}
		}
	}

	Function Solutions_Create_Refresh_Engine_Version
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null
		$GroupMainVerList.controls.Clear()

		Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Engine" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test-Path -Path "$($_.Fullname)\Engine.ps1" -PathType Leaf) {
				$GroupMainVerList.Items.Add($_.BaseName) | Out-Null
			}
		}

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_SelectSolutionVersion" -ErrorAction SilentlyContinue) {
			$GetSelectVer = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_SelectSolutionVersion" -ErrorAction SilentlyContinue
			$GroupMainVerList.Text = $GetSelectVer
		}
	}

	Function Solutions_Unattend_Refresh_Status
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$SaveFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"

		if ($InstlModebusiness.Checked) {
@"
[Channel]
volume

[VL]
1
"@ | Out-File -FilePath $SaveFileTo -Encoding Ascii -ErrorAction SilentlyContinue

			if ($Global:ImageType -eq "Desktop") {
				$SchemeDiskSpecifiedIndex.Enabled = $False        # 索引号按钮
				$SchemeDiskSpecifiedIndexPanel.Enabled = $False   # 索引号面板
			}

			if ($Global:ImageType -eq "Server") {
				$SchemeDiskSpecifiedIndex.Enabled = $True         # 索引号按钮
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True    # 索引号面板
			}
			$SchemeDiskSpecifiedKEY.Enabled = $True               # 序列号按钮
			$SchemeDiskSpecifiedKEYPanel.Enabled = $True          # 序列号面板
			$InstlModeTipsErrorMsg.Text = $lang.BusinessTips
		}

		if ($InstlModeconsumer.Checked) {
			Remove_Tree $SaveFileTo

			if ($Global:ImageType -eq "Desktop") {
				$SchemeDiskSpecifiedIndex.Enabled = $True         # 索引号按钮
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True    # 索引号面板
				$SchemeDiskSpecifiedKEY.Enabled = $False          # 序列号按钮
				$SchemeDiskSpecifiedKEYPanel.Enabled = $False     # 序列号面板
			}

			if ($Global:ImageType -eq "Server") {
				$SchemeDiskSpecifiedIndex.Enabled = $True         # 索引号按钮
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True    # 索引号面板
				$SchemeDiskSpecifiedKEY.Enabled = $True           # 序列号按钮
				$SchemeDiskSpecifiedKEYPanel.Enabled = $True      # 序列号面板
			}
			$InstlModeTipsErrorMsg.Text = $lang.ConsumerTips
		}

		if ($SchemeDiskHalf.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_UnattendMode" -value "1" -String
			$SchemeDiskSpecifiedPanel.Enabled = $False
			if ($SchemeVerMulti.Checked) {
				$SchemeVerMulti.Enabled = $True
				$SchemeVerSingle.Enabled = $False
			} else {
				$SchemeVerMulti.Enabled = $True
				$SchemeVerSingle.Enabled = $True
			}
		}

		if ($SchemeDiskUefi.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_UnattendMode" -value "2" -String
			$SchemeDiskSpecifiedPanel.Enabled = $True
			$SchemeVerMulti.Enabled = $True
			$SchemeVerSingle.Enabled = $True
		}

		if ($SchemeDiskLegacy.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_UnattendMode" -value "3" -String
			$SchemeDiskSpecifiedPanel.Enabled = $True
			$SchemeVerMulti.Enabled = $True
			$SchemeVerSingle.Enabled = $True
		}

		if ($SchemeDiskSpecifiedIndex.Enabled) {
			if ($SchemeDiskSpecifiedIndex.Checked) {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $False
			}
		}

		if ($SchemeDiskSpecifiedKEY.Enabled) {
			if ($SchemeDiskSpecifiedKEY.Checked) {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $False
			}
		}
	}

	$CreateUnattendISOClick = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($CreateUnattendISO.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISO" -value "True" -String
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISO" -value "False" -String
		}

		if ($CreateUnattendISOSources.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISOSources" -value "True" -String
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISOSources" -value "False" -String
		}

		if ($CreateUnattendISOSourcesOEM.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISOSourcesOEM" -value "True" -String
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendISOSourcesOEM" -value "False" -String
		}

		if ($CreateUnattendPanther.Checked) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendPather" -value "True" -String
		} else {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_AllowUnattendPather" -value "False" -String
		}
	}

	Function Solutions_Create_Refresh_Add_To_Path
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($SolutionsToMount.Enabled) {
			if ($SolutionsToMount.Checked) {
				$Script:init_To_GPS = "$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)"
				$CreateUnattendISO.Enabled = $False
				$CreateUnattendISOSources.Enabled = $False
				$CreateUnattendISOSourcesOEM.Enabled = $False
				$CreateUnattendPanther.Enabled = $True
			}
		}

		if ($SolutionsToSources.Enabled) {
			if ($SolutionsToSources.Checked) {
				$Script:init_To_GPS = "ISO"
				$CreateUnattendISO.Enabled = $True
				$CreateUnattendISOSources.Enabled = $True
				$CreateUnattendISOSourcesOEM.Enabled = $True
				$CreateUnattendPanther.Enabled = $True
			}
		}
	}

	$SchemeVerMultiClick = {
		$SchemeVerMulti.BackColor = "#FFFFFF"
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if ($SchemeVerMulti.Checked) {
			$SchemeVerSingle.Enabled = $False
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsLanguageUnattend" -value "True" -String
		} else {
			$SchemeVerSingle.Enabled = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsLanguageUnattend" -value "False" -String
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_LanguageUnattend" -value $SchemeVerSingle.Text -String
	}

	$SchemeLangMultiClick = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$GUISolutionsOfficeChange_Error.Text = ""
		$GUISolutionsOfficeChange_Error_Icon.Image = $null

		if ($SchemeLangMulti.Checked) {
			$SchemeLangSingle.Enabled = $False
			$SolutionsCollectionKeep.Enabled = $True
			$SolutionsCollectionKeepChange.Enabled = $True
			$SolutionsCollectionKeepShow.Enabled = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsLanguageCollection" -value "True" -String
		} else {
			$SchemeLangSingle.Enabled = $True
			$SolutionsCollectionKeep.Enabled = $False
			$SolutionsCollectionKeepChange.Enabled = $False
			$SolutionsCollectionKeepShow.Enabled = $False
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsLanguageCollection" -value "False" -String
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_LanguageCollection" -value $SchemeLangSingle.Text -String
	}

	$SolutionsOfficeChangeCfgClick = {
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$GUISolutionsOfficeChange_Error.Text = ""
		$GUISolutionsOfficeChange_Error_Icon.Image = $null

		$OfficePathNew = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$\`$1\$($GUISolutionsCustomizeName.Text)"
		$GUISolutionsOfficeToMain_Path.Text = $OfficePathNew

		$GUISolutionsOfficeChange.visible = $True
	}

	Function Solutions_Create_Refresh_Collection_Language
	{
		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$Temp_DeployCollectionLanguageOnly = @()
		$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Temp_DeployCollectionLanguageOnly += $_.Tag
					}
				}
			}
		}

		New-Variable -Scope global -Name "DeployCollectionLanguageOnly_$($Script:init_To_GPS)" -Value $Temp_DeployCollectionLanguageOnly -Force
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Collection_Reserved_Language" -value $Temp_DeployCollectionLanguageOnly -Multi
		$SolutionsCollectionKeepShow.Text = $Temp_DeployCollectionLanguageOnly
	}

	Function Solutions_Create_Refresh_Office_Language
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$GUISolutionsOfficeChange_Error.Text = ""
		$GUISolutionsOfficeChange_Error_Icon.Image = $null

		$TempDeployOfficeLanguageOnly = @()
		$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$TempDeployOfficeLanguageOnly += $_.Tag
					}
				}
			}
		}

		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_Reserved_Language" -value $TempDeployOfficeLanguageOnly -Multi
		$SolutionsOfficeKeepShow.Text = $TempDeployOfficeLanguageOnly
	}

	Function Refresh_Command_Rule_Select_Group
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$GUISolutionsOfficeChange_Error.Text = ""
		$GUISolutionsOfficeChange_Error_Icon.Image = $null

		$UIUnzipPanel_Select_Rule_Menu.controls.clear()

		<#
			.Windows 安装初始化选择
		#>
		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Save_Command_WinSetup" -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Save_Command_WinSetup" -value $Script:Init_Pre_Select_Command -Multi
		}
		$Get_Init_Select_Guid_Command = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Save_Command_WinSetup" -ErrorAction SilentlyContinue

		$Group_Get_Init_Select_Guid_Command = @()
		ForEach ($item in $Get_Init_Select_Guid_Command) {
			$Group_Get_Init_Select_Guid_Command += $item
		}

		<#
			.Windows PE
		#>
		if (-not (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Save_Command_WinSPE" -ErrorAction SilentlyContinue)) {
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Save_Command_WinSPE" -value "" -Multi
		}
		$Get_Init_Select_Guid_PE_Command = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Save_Command_WinSPE" -ErrorAction SilentlyContinue

		$Group_Get_Init_Select_PE_Guid_Command = @()
		ForEach ($item in $Get_Init_Select_Guid_PE_Command) {
			$Group_Get_Init_Select_PE_Guid_Command += $item
		}

		$UI_Main_Extract_Pre_Rule = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 425
			Text           = $lang.Command_WinSetup
		}
		$Group_Add_Command_Windows_Setup = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			autosize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Name           = "WinSetup"
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange((
			$UI_Main_Extract_Pre_Rule,
			$Group_Add_Command_Windows_Setup
		))

		ForEach ($item in $Global:Pre_Config_Command_Rules) {
			if ($UI_Command_Not_Class.Checked) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 425
					Padding   = "18,0,0,0"
					Text      = $item.Name
					Tag       = $item.GUID
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Group_Get_Init_Select_Guid_Command -Contains $item.GUID) {
					$CheckBox.Checked = $True
				}

				$Group_Add_Command_Windows_Setup.controls.AddRange($CheckBox)
			} else {
				$Filet = "Microsoft-Windows-Shell-Setup"

				if ($item.Apply -Contains $Filet) {
					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 40
						Width     = 425
						Padding   = "18,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null
						}
					}

					if ($Group_Get_Init_Select_Guid_Command -Contains $item.GUID) {
						$CheckBox.Checked = $True
					}

					$Group_Add_Command_Windows_Setup.controls.AddRange($CheckBox)
				}
			}
		}
		$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 425
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Add_End_Wrap)

		$UI_Main_Extract_Command_WinPE = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 425
			Text           = $lang.Command_WinPE
		}
		$Group_Add_Command_Windows_PE = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
			BorderStyle    = 0
			autosize       = 1
			autoSizeMode   = 1
			autoScroll     = $False
			Name           = "WinPE"
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange((
			$UI_Main_Extract_Command_WinPE,
			$Group_Add_Command_Windows_PE
		))


		ForEach ($item in $Global:Pre_Config_Command_Rules) {
			if ($UI_Command_Not_Class.Checked) {
				$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
					Height    = 40
					Width     = 425
					Padding   = "18,0,0,0"
					Text      = $item.Name
					Tag       = $item.GUID
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Group_Get_Init_Select_PE_Guid_Command -Contains $item.GUID) {
					$CheckBox.Checked = $True
				}

				$Group_Add_Command_Windows_PE.controls.AddRange($CheckBox)
			} else {
				$Filet = "Microsoft-Windows-Setup"

				if ($item.Apply -Contains $Filet) {
					$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
						Height    = 30
						Width     = 425
						Padding   = "18,0,0,0"
						Text      = $item.Name
						Tag       = $item.GUID
						add_Click = {
							$UI_Main_Error.Text = ""
							$UI_Main_Error_Icon.Image = $null
						}
					}

					if ($Group_Get_Init_Select_PE_Guid_Command -Contains $item.GUID) {
						$CheckBox.Checked = $True
					}

					$Group_Add_Command_Windows_PE.controls.AddRange($CheckBox)
				}
			}
		}
		$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
			Height         = 30
			Width          = 425
		}
		$UIUnzipPanel_Select_Rule_Menu.controls.AddRange($UI_Add_End_Wrap)
	}

	<#
		.Event: Ok
		.事件：确认
	#>
	Function Autopilot_Solutions_Save
	{
		<#
			.初始化变量
		#>
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$GUISolutionsCollectionChange_Error.Text = ""
		$GUISolutionsCollectionChange_Error_Icon.Image = $null

		$GUISolutionsOfficeChange_Error.Text = ""
		$GUISolutionsOfficeChange_Error_Icon.Image = $null

		$Temp_QueueFontsSelect = @()
		$Temp_QueueFontsNoSelect = @()
		$QueueDeploySelect = @()

		<#
			.Necessary judgment
			.必备判断
		#>
		<#
			.选择添加到：当前、队列、ISO 目录里
		#>
		$init_Is_Select_Add_To = $False

		if ($SolutionsToMount.Enabled) {
			if ($SolutionsToMount.Checked) {
				$Script:init_To_GPS = "$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)"
				$init_Is_Select_Add_To = $True
			}
		}

		if ($SolutionsToSources.Enabled) {
			if ($SolutionsToSources.Checked) {
				$Script:init_To_GPS = "ISO"
				$init_Is_Select_Add_To = $True
			}
		}

		Solutions_Event_Clear -All

		<#
			.多重初始变量
		#>
		New-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -Value $GUISolutionsCustomizeName.Text -Force

		New-Variable -Scope global -Name "QueueDeploySelect_$($Script:init_To_GPS)" -Value "" -Force
		New-Variable -Scope global -Name "DeployOfficeSyncConfig_$($Script:init_To_GPS)" -Value $False -Force
		New-Variable -Scope global -Name "DeployOfficeTo_$($Script:init_To_GPS)" -Value "0" -Force
		New-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -Value "0" -Force

		<#
			.添加软件
		#>
		New-Variable -Scope global -Name "QueueSoftwareSelect_$($Script:init_To_GPS)" -Value @() -Force
		New-Variable -Scope global -Name "QueueSoftwareNoSelect_$($Script:init_To_GPS)" -Value @() -Force

		New-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -Value $False -Force
		New-Variable -Scope global -Name "SolutionsInstallMode_$($Script:init_To_GPS)" -Value "0" -Force
		New-Variable -Scope global -Name "SolutionsReport_$($Script:init_To_GPS)" -Value $False -Force

		<#
			.添加字体
		#>
		New-Variable -Scope global -Name "QueueFontsSelect_$($Script:init_To_GPS)" -Value @() -Force
		New-Variable -Scope global -Name "QueueFontsNoSelect_$($Script:init_To_GPS)" -Value @() -Force

		<#
			.部署 Office
		#>
		New-Variable -Scope global -Name "SolutionsDeployOfficeInstall_$($Script:init_To_GPS)" -Value $False -Force
		New-Variable -Scope global -Name "SolutionsDeployPackageInstall_$($Script:init_To_GPS)" -Value $False -Force

		<#
			.初始化命令行
		#>
		New-Variable -Scope global -Name "Queue_Command_WinSetup_$($Script:init_To_GPS)" -Value @() -Force
		New-Variable -Scope global -Name "Queue_Command_WinPE_$($Script:init_To_GPS)" -Value @() -Force

		<#
			.重新验证时刷新事件状态
		#>
		Refres_Event_Tasks_Solutions_Add

		if ($init_Is_Select_Add_To) {

		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.SolutionsTo)"
			return $False
		}

		<#
			.Judgment: 1. Null value
			.判断：1. 空值
		#>
		if ([string]::IsNullOrEmpty($GUISolutionsCustomizeName.Text)) {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.VerifyName)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 2. The prefix cannot contain spaces
			.判断：2. 前缀不能带空格
		#>
		if ($GUISolutionsCustomizeName.Text -match '^\s') {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 3. No spaces at the end
			.判断：3. 后缀不能带空格
		#>
		if ($GUISolutionsCustomizeName.Text -match '\s$') {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 4. There can be no two spaces in between
			.判断：4. 中间不能含有二个空格
		#>
		if ($GUISolutionsCustomizeName.Text -match '\s{2,}') {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 5. Cannot contain: \\ / : * ? & @ ! "" < > |
			.判断：5, 不能包含：\\ / : * ? & @ ! "" < > |
		#>
		if ($GUISolutionsCustomizeName.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.Judgment: 6. No more than 16 characters
			.判断：6. 不能大于 16 字符
		#>
		if ($GUISolutionsCustomizeName.Text.length -gt 16) {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "16")"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		if ($GUISolutionsCustomizeName.Text -match '\s') {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
			$GUISolutionsCustomizeName.BackColor = "LightPink"
			return $False
		}

		<#
			.判断：开箱体验时初始化账号
		#>
			<#
				.判断是否选择：自定义、指定账号
			#>
			$Is_Init_Select_Custom_Specified = $False

			<#
				.判断：自定义创建账号
			#>
			if ($SolutionsOther_Custom.Enabled) {
				if ($SolutionsOther_Custom.Checked) {
					$Is_Init_Select_Custom_Specified = $True
				}
			}

			<#
				.判断：指定账号
			#>
			if ($SolutionsOther_Specified.Enabled) {
				if ($SolutionsOther_Specified.Checked) {
					$Is_Init_Select_Custom_Specified = $True
				}
			}

			<#
				.初始化变量
			#>
			New-Variable -Scope global -Name "Queue_Is_OOBE_Account_AutoLogon_$($Script:init_To_GPS)" -Value $False -Force

			if ($Is_Init_Select_Custom_Specified) {
				<#
					.判断复选框：自动登录
				#>
				if ($SolutionsOther_Specified_Expand_UserName_Autorun.Enabled) {
					if ($SolutionsOther_Specified_Expand_UserName_Autorun.Checked) {
						<#
							.设置初始化账号类型：用户自定义
						#>
						New-Variable -Scope global -Name "Queue_Is_OOBE_Account_AutoLogon_$($Script:init_To_GPS)" -Value $True -Force
					}
				}

				<#
					.判断必选项：自定义
				#>
				if ($SolutionsOther_Custom.Enabled) {
					if ($SolutionsOther_Custom.Checked) {
						<#
							.设置初始化账号类型：用户自定义
						#>
						New-Variable -Scope global -Name "Queue_Is_OOBE_Account_$($Script:init_To_GPS)" -Value "Custom" -Force
					}
				}

				<#
					.判断必选项：指定
				#>
				if ($SolutionsOther_Specified.Enabled) {
					if ($SolutionsOther_Specified.Checked) {
						<#
							.判断是否选择：将目录名设置为主用户名
						#>
						if ($GUISolutionsVerifySync.Checked) {
							New-Variable -Scope global -Name "Name_Unattend_$($Script:init_To_GPS)" -Value $GUISolutionsCustomizeName.Text -Force
						} else {
							<#
								.验证用户名是否正确
							#>

							<#
								.Judgment: 1. Null value
								.判断：1. 空值
							#>
							if ([string]::IsNullOrEmpty($SolutionsOther_Specified_Expand_UserName_Custom.Text)) {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.OOBE_init_Specified)"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							<#
								.Judgment: 2. The prefix cannot contain spaces
								.判断：2. 前缀不能带空格
							#>
							if ($SolutionsOther_Specified_Expand_UserName_Custom.Text -match '^\s') {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							<#
								.Judgment: 3. No spaces at the end
								.判断：3. 后缀不能带空格
							#>
							if ($SolutionsOther_Specified_Expand_UserName_Custom.Text -match '\s$') {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							<#
								.Judgment: 4. There can be no two spaces in between
								.判断：4. 中间不能含有二个空格
							#>
							if ($SolutionsOther_Specified_Expand_UserName_Custom.Text -match '\s{2,}') {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorSpace)"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							<#
								.Judgment: 5. Cannot contain: \\ / : * ? & @ ! "" < > |
								.判断：5, 不能包含：\\ / : * ? & @ ! "" < > |
							#>
							if ($SolutionsOther_Specified_Expand_UserName_Custom.Text -match '[~#$@!%&*{}\\:<>?/|+"]') {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISO9660TipsErrorOther)"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							<#
								.Judgment: 6. No more than 20 characters
								.判断：6. 不能大于 20 字符
							#>
							if ($SolutionsOther_Specified_Expand_UserName_Custom.Text.length -gt 20) {
								$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
								$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOLengthError -f "20")"
								$SolutionsOther_Specified_Expand_UserName_Custom.BackColor = "LightPink"

								Refres_Event_Tasks_Solutions_Add
								return $False
							}

							New-Variable -Scope global -Name "Name_Unattend_$($Script:init_To_GPS)" -Value $SolutionsOther_Specified_Expand_UserName_Custom.Text -Force
						}

						<#
							.设置初始化账号类型：指定
						#>
						New-Variable -Scope global -Name "Queue_Is_OOBE_Account_$($Script:init_To_GPS)" -Value "Specified" -Force
					}
				}
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.OOBE_init_Create), $($lang.OOBE_init_Specified)"
				Refres_Event_Tasks_Solutions_Add
				return $False
			}


		<#
			.Conditional judgment
			.按条件判断
		#>
		<#
			.Verify file name rules
			.验证文件名规则
		#>
		$MarkolutionsCustomizeName = $False
		if ($GUISolutionsVerify.Checked) {
			<#
				.Done: mark passed
				.完成：标记已通过
			#>
			$MarkolutionsCustomizeName = $True
		} else {
			$MarkolutionsCustomizeName = $True
		}

		<#
			.Requirementsing tag
			.处理标记
		#>
		if ($MarkolutionsCustomizeName) {
			<#
				.Requirementsing: after completion
				.处理：完成后
			#>
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_SaveEngine" -value $GUISolutionsCustomizeName.Text -String
		}

		if ($InstlModebusiness.Enabled) {
			if ($InstlModebusiness.Checked) {
				New-Variable -Scope global -Name "SolutionsInstallMode_$($Script:init_To_GPS)" -Value "1" -Force
			}
			if ($InstlModeconsumer.Checked) {
				New-Variable -Scope global -Name "SolutionsInstallMode_$($Script:init_To_GPS)" -Value "2" -Force
			}

			<#
				判断是否启用并添加软件包
			#>
			if ($SolutionsSoftwarePacker.Checked) {
				<#
					.刷新一次列表
				#>
				Solutions_Create_Refresh_Collection_Language

				<#
					打开队列功能
				#>
				New-Variable -Scope global -Name "QueueDeployLanguageExclue_$($Script:init_To_GPS)" -Value "" -Force

				$QueueDeployLanguageExclue = @()

				if ($CreateReport.Checked) {
					New-Variable -Scope global -Name "SolutionsReport_$($Script:init_To_GPS)" -Value $True -Force
				}

				if ($SchemeLangMulti.Checked) {
					New-Variable -Scope global -Name "SolutionsLang_$($Script:init_To_GPS)" -Value "Mul" -Force

					if ([string]::IsNullOrEmpty($SolutionsCollectionKeepShow.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.UnattendLangPack

						$GUISolutionsCollectionChange_Error.Text = ""
						$GUISolutionsCollectionChange_Error_Icon.Image = $null
						$GUISolutionsCollectionChange.visible = $True

						Refres_Event_Tasks_Solutions_Add
						return $False
					}
				} else {
					if ([string]::IsNullOrEmpty($SchemeLangSingle.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.UnattendLangPack

						Refres_Event_Tasks_Solutions_Add
						return $False
					}

					New-Variable -Scope global -Name "SolutionsLang_$($Script:init_To_GPS)" -Value "Single" -Force
				}

				New-Variable -Scope global -Name "SolutionsLangDefault_$($Script:init_To_GPS)" -Value $SchemeLangSingle.Text -Force
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_LanguageCollection" -value $SchemeLangSingle.Text -String

				if ($ArchitectureARM64.Checked) { $Global:ArchitecturePack = "arm64" }
				if ($ArchitectureAMD64.Checked) { $Global:ArchitecturePack  = "AMD64" }
				if ($ArchitectureX86.Checked) { $Global:ArchitecturePack = "x86" }

				if ($SolutionsOffice.Checked) {
					if ([string]::IsNullOrEmpty($Solutions_Office_Select.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.SolutionsDeployOfficeNoSelect

						Refres_Event_Tasks_Solutions_Add
						return $False
					} else {
						New-Variable -Scope global -Name "DeployOfficeVersion_$($Script:init_To_GPS)" -Value $Solutions_Office_Select.Text -Force
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_PreOfficeVersion" -value $Solutions_Office_Select.Text -String
					}

					if ([string]::IsNullOrEmpty($SolutionsOfficeKeepShow.Text)) {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = $lang.SolutionsDeployOfficeInstall
						$GUISolutionsCollectionChange_Error.Text = ""
						$GUISolutionsCollectionChange_Error_Icon.Image = $null
						$GUISolutionsOfficeChange.visible = $True

						Refres_Event_Tasks_Solutions_Add
						return $False
					}

					if ($GUISolutionsOfficeToPublic.Checked) {
						New-Variable -Scope global -Name "DeployOfficeTo_$($Script:init_To_GPS)" -Value "1" -Force
					}
					if ($GUISolutionsOfficeToMain.Checked) {
						New-Variable -Scope global -Name "DeployOfficeTo_$($Script:init_To_GPS)" -Value "2" -Force
					}

					if ($SolutionsOfficeOnly.Checked) {
						New-Variable -Scope global -Name "DeployOfficeSyncConfig_$($Script:init_To_GPS)" -Value $True -Force
					}

					$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
						if ($_.Enabled) {
							if ($_.Checked) {
								$QueueDeployLanguageExclue += $_.Tag
							}
						}
					}

					New-Variable -Scope global -Name "SolutionsDeployOfficeInstall_$($Script:init_To_GPS)" -Value $True -Force
					New-Variable -Scope global -Name "QueueDeployLanguageExclue_$($Script:init_To_GPS)" -Value $QueueDeployLanguageExclue -Force
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String
				}

				if ($SolutionsPackage.Checked) {
					if ($SolutionsPackageToRoot.Checked) {
						New-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -Value "1" -Force
					}

					if ($SolutionsPackageToSolutions.Checked) {
						New-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -Value "2" -Force
					}

					if ($SolutionsPackageToPublish.Checked) {
						New-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -Value "3" -Force
					}

					<#
						.获取部署合集
					#>
					$MarkCheckPackageSel = $False
					$SolutionsPackageSelList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									$MarkCheckPackageSel = $True
									New-Variable -Scope global -Name "DeployPackerVersion_$($Script:init_To_GPS)" -Value $_.Tag -Force
									Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_SolutionsPacker" -value $_.Text -String
								}
							}
						}
					}

					if ($MarkCheckPackageSel) {
						New-Variable -Scope global -Name "SolutionsDeployPackageInstall_$($Script:init_To_GPS)" -Value $True -Force
					} else {
						$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
						$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.DeployPackageSelect)"
						Refres_Event_Tasks_Solutions_Add
						return $False
					}
				}

				$Temp_QueueSoftwareSelect = @()
				$Temp_QueueSoftwareNoSelect = @()
				if ($GroupSoftwareListTitle.Checked) {
					$GroupSoftwareList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.Checkbox]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									$Temp_QueueSoftwareSelect += @{
										Name = $_.Text;
										Path = $_.Tag
									}
								} else {
									$Temp_QueueSoftwareNoSelect += $_.Text
								}
							}
						}

						New-Variable -Scope global -Name "QueueSoftwareSelect_$($Script:init_To_GPS)" -Value $Temp_QueueSoftwareSelect -Force
						New-Variable -Scope global -Name "QueueSoftwareNoSelect_$($Script:init_To_GPS)" -Value $Temp_QueueSoftwareNoSelect -Force
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Exclude_Software" -value $Temp_QueueSoftwareNoSelect -Multi
					}
				} else {
					New-Variable -Scope global -Name "QueueSoftwareSelect_$($Script:init_To_GPS)" -Value @() -Force
					New-Variable -Scope global -Name "QueueSoftwareNoSelect_$($Script:init_To_GPS)" -Value @() -Force
				}

				if ($GroupFontsListTitle.Checked) {
					New-Variable -Scope global -Name "DeployFonts_$($Script:init_To_GPS)" -Value $True -Force

					$GroupFontsList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.Checkbox]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									$Temp_QueueFontsSelect += @{
										Name = $_.Text;
										Path = $_.Tag
									}
								} else {
									$Temp_QueueFontsNoSelect += "$($_.Text)"
								}
							}
						}

						New-Variable -Scope global -Name "QueueFontsSelect_$($Script:init_To_GPS)" -Value $Temp_QueueFontsSelect -Force
						New-Variable -Scope global -Name "QueueFontsNoSelect_$($Script:init_To_GPS)" -Value $Temp_QueueFontsNoSelect -Force
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Exclude_Fonts" -value $Temp_QueueFontsNoSelect -Multi
					}
				} else {
					New-Variable -Scope global -Name "QueueFontsSelect_$($Script:init_To_GPS)" -Value @() -Force
					New-Variable -Scope global -Name "QueueFontsNoSelect_$($Script:init_To_GPS)" -Value @() -Force
				}

				New-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -Value $True -Force
				New-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "DeployFonts_$($Script:init_To_GPS)" -Value $False -Force
			}
		}

		<#
			开启并添加应预答
		#>
		if ($SolutionsUnattend.Checked) {
			<#
				.判断是否选择版本
			#>
			if ([string]::IsNullOrEmpty($Unattend_Version_Select.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.ISOAddEICFG)"
				Refres_Event_Tasks_Solutions_Add
				return $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_Scheme" -value $Unattend_Version_Select.Text -Multi
				New-Variable -Scope global -Name "Queue_Unattend_Scheme_$($Script:init_To_GPS)" -Value $Unattend_Version_Select.Text -Force
			}

			<#
				.添加应预答前，判断是否添加“部署引擎”，如果是需要添加部署引擎，需要启用 2 项才能正常运行
			#>
			if ($SolutionsEngine.Checked) {
				if ($Engine_Unattend_Auto_Fix.Checked) {
					$Temp_Save_Windows_Setup = @()
					$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("WinSetup" -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.CheckBox]) {
										if ($Script:Init_Pre_Select_Command -contains $_.Tag) {
											$Temp_Save_Windows_Setup += $_.Tag
											$_.Checked = $True
										}
									}
								}
							}
						}
					}

					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Save_Command_WinSetup" -value $Temp_Save_Windows_Setup -Multi
					New-Variable -Scope global -Name "Queue_Command_WinSetup_$($Script:init_To_GPS)" -Value $Temp_Save_Windows_Setup -Force
				} else {
					$Temp_Save_Windows_Setup = @()
					$Mark_Not_Select_Rule = $False
					$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
							if ("WinSetup" -eq $_.Name) {
								$_.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.CheckBox]) {
										if ($_.Checked) {
											$Temp_Save_Windows_Setup += $_.Tag
										}
									}
								}
							}
						}
					}

					ForEach ($item in $Script:Init_Pre_Select_Command) {
						if ($Temp_Save_Windows_Setup -contains $item) {

						} else {
							$Mark_Not_Select_Rule = $True
						}
					}

					if ($Mark_Not_Select_Rule) {
						$UIUnzipPanel_Error_Tips.visible = $True
						$UIUnzipPanel_Select_Rule.visible = $True
						return $False
					}
				}
			}

			<#
				.获取最终选择的命令行并保存到当前数组里
			#>
			<#
				.保存已选择的 Windows 安装项
			#>
			$Temp_Save_Windows_Setup = @()
			$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ("WinSetup" -eq $_.Name) {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($_.Checked) {
									$Temp_Save_Windows_Setup += $_.Tag
								}
							}
						}
					}
				}
			}

			$Temp_Save_Windows_PE = @()
			$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ("WinPE" -eq $_.Name) {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($_.Checked) {
									$Temp_Save_Windows_PE += $_.Tag
								}
							}
						}
					}
				}
			}

			New-Variable -Scope global -Name "Queue_Command_WinSetup_$($Script:init_To_GPS)" -Value $Temp_Save_Windows_Setup -Force
			New-Variable -Scope global -Name "Queue_Command_WinPE_$($Script:init_To_GPS)" -Value $Temp_Save_Windows_PE -Force

			if ($GUISolutionsVerifySync.Enabled) {
				if ($GUISolutionsVerifySync.Checked) {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_OSAccountName" -value 1 -String
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_OSAccountName" -value 2 -String
				}
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_OSAccountName" -value 2 -String
			}

			New-Variable -Scope global -Name "SolutionsCreateUnattendISO_$($Script:init_To_GPS)" -Value $False -Force
			if ($CreateUnattendISO.Enabled) {
				if ($CreateUnattendISO.Checked) {
					New-Variable -Scope global -Name "SolutionsCreateUnattendISO_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			New-Variable -Scope global -Name "SolutionsCreateUnattendISOSources_$($Script:init_To_GPS)" -Value $False -Force
			if ($CreateUnattendISOSources.Enabled) {
				if ($CreateUnattendISOSources.Checked) {
					New-Variable -Scope global -Name "SolutionsCreateUnattendISOSources_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			New-Variable -Scope global -Name "SolutionsCreateUnattendISOSourcesOEM_$($Script:init_To_GPS)" -Value $False -Force
			if ($CreateUnattendISOSourcesOEM.Enabled) {
				if ($CreateUnattendISOSourcesOEM.Checked) {
					New-Variable -Scope global -Name "SolutionsCreateUnattendISOSourcesOEM_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			New-Variable -Scope global -Name "SolutionsCreateUnattendPanther_$($Script:init_To_GPS)" -Value $False -Force
			if ($CreateUnattendPanther.Enabled) {
				if ($CreateUnattendPanther.Checked) {
					New-Variable -Scope global -Name "SolutionsCreateUnattendPanther_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			if ($SchemeVerMulti.Checked) {
				New-Variable -Scope global -Name "UnattendLang_$($Script:init_To_GPS)" -Value "Multi" -Force
			} else {
				New-Variable -Scope global -Name "UnattendLang_$($Script:init_To_GPS)" -Value "Single" -Force

				if ([string]::IsNullOrEmpty($SchemeVerSingle.Text)) {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.UnattendSelectVer
					$SchemeVerSingle.BackColor = "LightPink"
					return $False
				}
			}
			New-Variable -Scope global -Name "UnattendLangDefault_$($Script:init_To_GPS)" -Value $SchemeVerSingle.Text -Force
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_LanguageUnattend" -value $SchemeVerSingle.Text -String

			$MarkVerifyIndexProductKey = $False
			if ($SchemeDiskHalf.Checked) {
				New-Variable -Scope global -Name "Autounattend_$($Script:init_To_GPS)" -Value "1" -Force
			}
			if ($SchemeDiskUefi.Checked) {
				New-Variable -Scope global -Name "Autounattend_$($Script:init_To_GPS)" -Value "2" -Force
				$MarkVerifyIndexProductKey = $True
			}
			if ($SchemeDiskLegacy.Checked) {
				New-Variable -Scope global -Name "Autounattend_$($Script:init_To_GPS)" -Value "3" -Force
				$MarkVerifyIndexProductKey = $True
			}

			New-Variable -Scope global -Name "AllowUnattendIndex_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "AllowUnattendProductKey_$($Script:init_To_GPS)" -Value $False -Force

			if ($MarkVerifyIndexProductKey) {
				if ($SchemeDiskSpecifiedIndex.Enabled) {
					if ($SchemeDiskSpecifiedIndex.Checked) {
						if ([string]::IsNullOrEmpty($Global:UnattendSelectIndex)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.MountedIndex)"
#							Solutions_Index_UI
							return $False
						} else {
							New-Variable -Scope global -Name "AllowUnattendIndex_$($Script:init_To_GPS)" -Value $True -Force
						}
					}

				}

				if ($SchemeDiskSpecifiedKEY.Enabled) {
					if ($SchemeDiskSpecifiedKEY.Checked) {
						if ([string]::IsNullOrEmpty($Global:ProductKey)) {
							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.KMSKey)"
#							KMSkeys
							return $False
						} else {
							New-Variable -Scope global -Name "AllowUnattendProductKey_$($Script:init_To_GPS)" -Value $True -Force
						}
					}
				}
			}

			New-Variable -Scope global -Name "OOBEActivate_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendOOBEActivate.Checked) {
				New-Variable -Scope global -Name "OOBEActivate_$($Script:init_To_GPS)" -Value $True -Force
			}

			New-Variable -Scope global -Name "OOBEOSImage_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendSetupOSUI.Checked) {
				New-Variable -Scope global -Name "OOBEOSImage_$($Script:init_To_GPS)" -Value $True -Force
			}

			New-Variable -Scope global -Name "OOBEAccectEula_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendAccectEula.Checked) {
				New-Variable -Scope global -Name "OOBEAccectEula_$($Script:init_To_GPS)" -Value $True -Force
			}

			New-Variable -Scope global -Name "OOBEServerManager_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendDoNotServerManager.Enabled) {
				if ($SolutionsUnattendDoNotServerManager.Checked) {
					New-Variable -Scope global -Name "OOBEServerManager_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			New-Variable -Scope global -Name "OOBEIEAdmin_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendIEAdmin.Enabled) {
				if ($SolutionsUnattendIEAdmin.Checked) {
					New-Variable -Scope global -Name "OOBEIEAdmin_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			New-Variable -Scope global -Name "OOBEIEUser_$($Script:init_To_GPS)" -Value $False -Force
			if ($SolutionsUnattendIEUser.Enabled) {
				if ($SolutionsUnattendIEUser.Checked) {
					New-Variable -Scope global -Name "OOBEIEUser_$($Script:init_To_GPS)" -Value $True -Force
				}
			}

			if ($SchemeTimeZoneSelect.Checked) {
				New-Variable -Scope global -Name "OOBETimZone_$($Script:init_To_GPS)" -Value $True -Force
			} else {
				New-Variable -Scope global -Name "OOBETimZone_$($Script:init_To_GPS)" -Value $False -Force
			}

			New-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -Value $True -Force
			New-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -Value $True -Force
		} else {
			New-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsCreateUnattendISO_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsCreateUnattendISOSources_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsCreateUnattendISOSourcesOEM_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "SolutionsCreateUnattendPanther_$($Script:init_To_GPS)" -Value $False -Force
			New-Variable -Scope global -Name "Queue_Unattend_Scheme_$($Script:init_To_GPS)" -Value "" -Force
		}

		<#
			开启并添加主引擎
		#>
		$MarkolutionsEngine = $False
		if ($SolutionsEngine.Checked) {
			if ([string]::IsNullOrEmpty($GroupMainVerList.Text)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SolutionsScript)"

				Refres_Event_Tasks_Solutions_Add
				return $False
			} else {
				<#
					获得用户选择的版本
				#>
				New-Variable -Scope global -Name "SelectSolutionVersion_$($Script:init_To_GPS)" -Value $GroupMainVerList.Text -Force
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_SelectSolutionVersion" -value $GroupMainVerList.Text -String

				<#
					.允许全盘搜索并同步部署标记
				#>
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Is_Mark_Sync" -value "False" -String
				if ($EngineChkSyncMark.Enabled) {
					if ($EngineChkSyncMark.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Is_Mark_Sync" -value "True" -String
						$QueueDeploySelect += "Is_Mark_Sync"
					}
				}

				<#
					.允许首次自动更新
				#>
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Auto_Update" -value "False" -String
				if ($EngineChkUpdate.Enabled) {
					if ($EngineChkUpdate.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Auto_Update" -value "True" -String
						$QueueDeploySelect += "Auto_Update"
					}
				}

				# 判断是否主目录添加 Defender 排除目录
				if ($EngineDefender.Enabled) {
					if ($EngineDefender.Checked) {
						$QueueDeploySelect += "Exclude_Defender"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Defender" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Defender" -value "False" -String
					}
				}

				# 网络位置向导
				if ($EngineNetworkLocationWizard.Enabled) {
					if ($EngineNetworkLocationWizard.Checked) {
						$QueueDeploySelect += "Disable_Network_Location_Wizard"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Network_Location_Wizard" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Network_Location_Wizard" -value "False" -String
					}
				}

				<#
					.系统盘卷标名与主目录相同
				#>
				if ($GUISolutionsVolume.Enabled) {
					if ($GUISolutionsVolume.Checked) {
						$QueueDeploySelect += "Sync_Volume_Name"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Sync_Volume_Name" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Sync_Volume_Name" -value "False" -String
					}
				}

				<#
					.阻止 Appx 清理维护任务
				#>
				if ($GUIPreAppxCleanup.Enabled) {
					if ($GUIPreAppxCleanup.Checked) {
						$QueueDeploySelect += "Disable_Cleanup_Appx_Tasks"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PreAppxCleanup" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PreAppxCleanup" -value "False" -String
					}
				}

				<#
					.阻止清理未使用的按需功能语言包
				#>
				if ($GUILanguageComponents.Enabled) {
					if ($GUILanguageComponents.Checked) {
						$QueueDeploySelect += "Disable_Cleanup_On_Demand_Language"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_LanguageComponents" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_LanguageComponents" -value "False" -String
					}
				}

				<#
					.阻止清理未使用的语言包
				#>
				if ($GUIPreventCleaningUnusedLP.Enabled) {
					if ($GUIPreventCleaningUnusedLP.Checked) {
						$QueueDeploySelect += "Disable_Cleanup_Unsed_Language"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PreventCleaningUnusedLP" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PreventCleaningUnusedLP" -value "False" -String
					}
				}

				# 判断添加右键菜单
				if ($EngineDeskMenu.Enabled) {
					if ($EngineDeskMenu.Checked) {
						$QueueDeploySelect += "Desktop_Menu"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Desktop_Menu" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Desktop_Menu" -value "False" -String
					}
				}
				if ($EngineDeskMenuShift.Enabled) {
					if ($EngineDeskMenuShift.Checked) {
						$QueueDeploySelect += "Desktop_Menu_Shift"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Desktop_Menu_Shift" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Desktop_Menu_Shift" -value "False" -String
					}
				}

				# 首次体验：先决条件重启
				if ($EnginePrerequisitesReboot.Enabled) {
					if ($EnginePrerequisitesReboot.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Prerequisites_Reboot" -value "True" -String
						$QueueDeploySelect += "Prerequisites_Reboot"
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Prerequisites_Reboot" -value "False" -String
					}
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Prerequisites_Reboot" -value "False" -String
				}

				<#
					.首次体验，完成先决条件部署后
				#>
				# 判断：首次部署后，弹出主界面
				if ($EnginePopsupEngine.Enabled) {
					if ($EnginePopsupEngine.Checked) {
						$QueueDeploySelect += "Popup_Engine"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PopupEngine" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_PopupEngine" -value "False" -String
					}
				}

				# 判断：首次部署，按需计划
				if ($EngineFirstExp.Enabled) {
					if ($EngineFirstExp.Checked) {
						$QueueDeploySelect += "Allow_First_Pre_Experience"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Allow_First_Pre_Experience" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Allow_First_Pre_Experience" -value "False" -String
					}
				}

				# 判断是否恢复 Powershell 执行策略：受限
				if ($EngineRestricted.Enabled) {
					if ($EngineRestricted.Checked) {
						$QueueDeploySelect += "Reset_Execution_Policy"
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Restricted" -value "True" -String
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Restricted" -value "False" -String
					}
				}

				<#
					判断删除整个解决方案
				#>
				if ($EngineDoneClearFull.Enabled) {
					if ($EngineDoneClearFull.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_ClearFull" -value "True" -String
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "False" -String
						$QueueDeploySelect += "Clear_Solutions"
						$QueueDeploySelect += "Clear_Engine"
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_ClearFull" -value "False" -String
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "False" -String
					}
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_ClearFull" -value "False" -String
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "False" -String
				}

				if ($EngineDoneClear.Enabled) {
					if ($EngineDoneClear.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "True" -String
						$QueueDeploySelect += "Clear_Engine"
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "False" -String
					}
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Clear" -value "False" -String
				}

				if ($FirstExpFinishReboot.Enabled) {
					if ($FirstExpFinishReboot.Checked) {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_First_Experience_Reboot" -value "True" -String
						$QueueDeploySelect += "First_Experience_Reboot"
					} else {
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_First_Experience_Reboot" -value "False" -String
					}
				} else {
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_First_Experience_Reboot" -value "False" -String
				}

				if ($GUISolutionsShowLanguageUTF8.Enabled) {
					if ($GUISolutionsShowLanguageUTF8.Checked) {
						$QueueDeploySelect += "Use_UTF8"
					}
				}

				New-Variable -Scope global -Name "QueueDeploySelect_$($Script:init_To_GPS)" -Value $QueueDeploySelect -Force

				$MarkolutionsEngine = $True
				
				<#
					打开队列功能
				#>
				New-Variable -Scope global -Name "Queue_Is_Solutions_$($Script:init_To_GPS)" -Value $True -Force

				<#
					打开主引擎总添加方案
				#>
				New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -Value $True -Force
			}
		} else {
			New-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -Value $False -Force
			$MarkolutionsEngine = $True
		}

		<#
			判断完成后，解决方案生成到那里
		#>
		if ($MarkolutionsEngine) {
			Refres_Event_Tasks_Solutions_Add

			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.EventManagerCurrentClear), $($lang.Done)"
			return $True
		} else {
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
			$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.SolutionsScript)"

			Refres_Event_Tasks_Solutions_Add
			return $False
		}
	}
	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 1075
		Text           = "$($lang.Solution): $($lang.IsCreate)"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$GUISolutionsShowGlobal = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 665
		Width          = 500
		Padding        = "10,15,0,0"
		autoScroll     = $True
		Dock           = 3
	}

	<#
		.显示更改区域设置蒙层
	#>
	$GUISolutionsRegional = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1055
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Visible        = $False
	}
	$GUISolutionsShowLanguage = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 340
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		autoScroll     = $True
	}
	$GUISolutionsShowLanguageUTF8Title = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 485
		Location       = '560,15'
		Text           = $lang.AdvOption
	}
	$GUISolutionsShowLanguageUTF8 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 440
		Location       = '580,45'
		Text           = $lang.SolutionsEngineRegionaUTF8
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($GUISolutionsShowLanguageUTF8.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Region_UTF8" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Region_UTF8" -value "False" -String
			}
		}
	}
	$GUISolutionsShowLanguageUTF8Tips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 36
		Width          = 440
		Location       = '597,75'
		Text           = $lang.SolutionsEngineRegionaUTF8Tips
	}
	$GUISolutionsShowLanguageTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 440
		Location       = '580,130'
		Text           = $lang.SolutionsEngineRegionaling
	}

	$GUISolutionsShowNewLanguage = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Location       = '600,160'
		Text           = ""
		ReadOnly       = $True
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue) {
		$GetNewSaveLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue
		$GUISolutionsShowNewLanguage.Text = $GetNewSaveLanguage
	} else {
		$GUISolutionsShowNewLanguage.Text = $Global:MainImageLang
	}

	$GUISolutionsRegionalChangeTips = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 260
		Width          = 400
		Location       = "597,190"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Padding        = "8,0,8,0"
	}
	$GUISolutionsRegionalChangeTipsErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.SolutionsEngineRegionalingTips
	}
	$GUISolutionsRegionalCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "807,635"
		Text           = $lang.Cancel
		add_Click      = {
			$GUISolutionsRegional.visible = $False
		}
	}

	<#
		添加合集
		
		解决方案软件包
	#>
	$SolutionsSoftwarePacker = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Text           = $lang.EnabledSoftwarePacker
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($SolutionsSoftwarePacker.Checked) {
				$GroupSolutionsSoftwarePacker.Enabled = $True
			} else {
				$GroupSolutionsSoftwarePacker.Enabled = $False
			}
		}
	}
	$GroupSolutionsSoftwarePacker = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "13,0,0,0"
	}

	<#
		显示软件包其它功能区域
	#>
	$GroupSoftwarePackerAdvTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 435
		Text           = $lang.AdvOption
	}
	$GroupSoftwarePackerADV = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "20,0,0,0"
		margin         = "0,0,0,35"
	}
	$CreateReport      = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 410
		Text           = $lang.SolutionsReport
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	# 1 解决方案语言
	$SchemeLangTitle   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Text           = $lang.UnattendLangPack
	}
	$GroupSchemeLang  = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "0,0,0,35"
	}
	$SchemeLangMulti   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 432
		Padding        = "15,0,0,0"
		Text           = $lang.UnattendSelectMulti
		add_Click      = $SchemeLangMultiClick
	}

	<#
		.保留指定的语言包
	#>
	$SolutionsCollectionKeep = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 432
		Padding        = "30,0,0,0"
		Text           = $lang.SolutionsDeployOfficeOnly
	}
	$SolutionsCollectionKeepChange = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 390
		Margin         = "45,5,0,0"
		Text           = $lang.SolutionsDeployOfficeChange
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$GUISolutionsCollectionChange_Error.Text = ""
			$GUISolutionsCollectionChange_Error_Icon.Image = $null

			$GUISolutionsCollectionChange.visible = $True
		}
	}
	$SolutionsCollectionKeepShow = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 30
		Width          = 385
		Margin         = "48,5,0,35"
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$SchemeLangSingleTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 432
		Padding        = "29,0,0,0"
		Text           = $lang.SwitchLanguage
	}
	$SchemeLangSingle  = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 398
		Margin         = "34,0,0,15"
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = $SchemeLangMultiClick
	}

	# 软件包体系结构
	$ArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 437
		Location       = '0,0'
		Text           = $lang.ArchitecturePack
	}
	$GroupArchitecture = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		margin         = "0,0,0,35"
	}
	$ArchitectureARM64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 35
		Width          = 70
		Text           = "arm64"
		add_Click      = {
			$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsArm64
			Solutions_Create_Refresh_Office_Status
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_SolutionsSoftwareArch" -value "arm64" -String
		}
	}
	$ArchitectureAMD64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 35
		Width          = 60
		Text           = "x64"
		Checked        = $True
		add_Click      = {
			$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsAMD64
			Solutions_Create_Refresh_Office_Status
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_SolutionsSoftwareArch" -value "amd64" -String
		}
	}
	$ArchitectureX86    = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 35
		Width          = 60
		Text           = "x86"
		add_Click      = {
			$SoftwareTipsErrorMsg.Text = $lang.SolutionsTipsX86
			Solutions_Create_Refresh_Office_Status
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_SolutionsSoftwareArch" -value "x86" -String
		}
	}
	$SoftwareTips      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 60
		Width          = 416
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
	}
	$SoftwareTipsErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = ""
	}

	<#
		.添加合集，更改语言

		.显示更改区域设置蒙层
	#>
	$GUISolutionsCollectionChange = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1055
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Visible        = $False
	}
	$GUISolutionsCollectionChangeShowLanguage = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 340
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		autoScroll     = $True
	}
	$GUISolutionsCollectionChangeAdv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 560
		Location       = '400,15'
		Text           = $lang.AdvOption
	}
	$GUISolutionsCollectionLangGet = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 560
		Location       = "423,55"
		Text           = $lang.ISOAddFlagsLangGet
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$Verify_Language_New_Path = ISO_Local_Language_Calc

			$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Verify_Language_New_Path.Lang -contains $_.Tag) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}

			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -name "$($Script:init_To_GPS)_Collection_Reserved_Language" -value $Verify_Language_New_Path.Lang -Multi
			$SolutionsCollectionKeepShow.Text = $Verify_Language_New_Path.Lang

			$GUISolutionsCollectionChange_Error.Text = "$($Lang.ISOAddFlagsLangGet), $($lang.Done)"
			$GUISolutionsCollectionChange_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
		}
	}
	$GUISolutionsCollectionLangSync = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 560
		Location       = "423,95"
		Text           = $lang.DeploySyncMainLanguage
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
				if ($Global:MainImageLang -eq $_.Tag) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}

			Solutions_Create_Refresh_Collection_Language

			$GUISolutionsCollectionChange_Error.Text = "$($Lang.DeploySyncMainLanguage), $($lang.Done)"
			$GUISolutionsCollectionChange_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
		}
	}

	$GUISolutionsCollectionChange_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "400,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$GUISolutionsCollectionChange_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "425,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}
	$GUISolutionsCollectionChangeCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "807,635"
		Text           = $lang.Cancel
		add_Click      = {
			$GUISolutionsCollectionChange.visible = $False
		}
	}

	<#
		.部署 Microsoft Office 安装包

		.显示更改区域设置蒙层
	#>
	$GUISolutionsOfficeChange = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1055
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Visible        = $False
	}
	$GUISolutionsOfficeChangeShowLanguage = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 340
		Location       = '0,0'
		autoSizeMode   = 1
		Padding        = 15
		autoScroll     = $True
	}
	$GUISolutionsOfficeChangeAdv = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 560
		Location       = '400,10'
		Text           = $lang.AdvOption
	}

	<#
		.部署 Microsoft Office
	#>
	$SolutionsOfficeOnly = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 560
		Location       = '423,40'
		Text           = $lang.SolutionsDeployOfficeSync
		add_Click      = {
			$GUISolutionsOfficeChange_Error.Text = ""
			$GUISolutionsOfficeChange_Error_Icon.Image = $null

			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowSyncConfig" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowSyncConfig" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowSyncConfig" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowSyncConfig" -ErrorAction SilentlyContinue) {
			"True" {
				$SolutionsOfficeOnly.Checked = $True
			}
			"False" {
				$SolutionsOfficeOnly.Checked = $False
			}
		}
	}

	$SolutionsOfficeOnlyTips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 45
		Width          = 540
		Location       = '439,75'
		Text           = $lang.SolutionsDeployOfficeSyncTips
	}

	$GUISolutionsOfficeLangGet = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 560
		Location       = "423,135"
		Text           = $lang.ISOAddFlagsLangGet
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUISolutionsOfficeChange_Error.Text = ""
			$GUISolutionsOfficeChange_Error_Icon.Image = $null
			
			$Verify_Language_New_Path = ISO_Local_Language_Calc

			$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Verify_Language_New_Path.Lang -contains $_.Tag) {
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}

			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_Reserved_Language" -value $Verify_Language_New_Path.Lang -Multi
			$SolutionsOfficeKeepShow.Text = $Verify_Language_New_Path.Lang

			$GUISolutionsOfficeChange_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
			$GUISolutionsOfficeChange_Error.Text = "$($Lang.ISOAddFlagsLangGet), $($lang.Done)"
		}
	}
	$GUISolutionsOfficeLangSync = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 560
		Location       = "423,170"
		Text           = $lang.DeploySyncMainLanguage
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
				if ($Global:MainImageLang -eq $_.Tag) {
					$_.Checked = $True
				} else {
					$_.Checked = $False
				}
			}
			Solutions_Create_Refresh_Office_Language

			$GUISolutionsOfficeChange_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Success.ico")
			$GUISolutionsOfficeChange_Error.Text = "$($Lang.DeploySyncMainLanguage), $($lang.Done)"
		}
	}

	$GUISolutionsGroupOfficeTo = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 280
		Width          = 550
		Location       = '420,240'
		autoSizeMode   = 1
	}
	$GUISolutionsGroupOfficeToTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 520
		Text           = $lang.DeployPackage
	}
	$GUISolutionsOfficeToPublic = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 520
		Padding        = "18,0,0,0"
		Text           = $lang.SolutionsDeployOfficeToPublic
		add_Click      = {
			$GUISolutionsOfficeChange_Error.Text = ""
			$GUISolutionsOfficeChange_Error_Icon.Image = $null
			
			$SolutionsOfficeToShow.Text = $lang.SolutionsDeployOfficeToPublic
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_CopyTo" -value 1 -String
		}
	}
	$GUISolutionsOfficeToPublicShow = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 520
		Padding        = "35,0,0,0"
		margin         = "0,0,0,10"
		Text           = "C:\Users\Public\Desktop\Office"
	}
	$GUISolutionsOfficeToMain = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 520
		Padding        = "18,0,0,0"
		Text           = $lang.MainImageFolder
		add_Click      = {
			$GUISolutionsOfficeChange_Error.Text = ""
			$GUISolutionsOfficeChange_Error_Icon.Image = $null

			$SolutionsOfficeToShow.Text = $lang.MainImageFolder
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_CopyTo" -value 2 -String
		}
	}
	$GUISolutionsOfficeToMain_Path = New-Object System.Windows.Forms.Label -Property @{
		autosize       = 1
		Padding        = "35,0,0,0"
		Text           = ""
	}

	$GUISolutionsOfficeChange_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "400,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$GUISolutionsOfficeChange_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "425,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}
	$GUISolutionsOfficeChangeCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 240
		Location       = "807,635"
		Text           = $lang.Cancel
		add_Click      = {
			$GUISolutionsOfficeChange.visible = $False
		}
	}

	<#
		.Office 功能选项，主显示界面显示区域
	#>
	$SolutionsOffice   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 437
		Text           = $lang.SolutionsDeployOfficeInstall
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsOffice.Checked) {
				$SolutionsOfficeShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "True" -String
			} else {
				$SolutionsOfficeShow.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String
			}
		}
	}
	$SolutionsOfficeShow = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "15,0,0,0"
		margin         = "0,0,0,25"
		autoScroll     = $True
	}

	<#
		.选择预 Office 安装包
	#>
	$SolutionsOfficePre = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 416
		Text           = $lang.SolutionsDeployOfficePre
	}
	$Solutions_Office_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 381
		Margin         = "25,5,0,45"
		Text           = ""
		DropDownStyle  = "DropDownList"
	}

	<#
		.保留指定的语言包
	#>
	$SolutionsOfficeKeep = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 416
		Text           = $lang.SolutionsDeployOfficeOnly
	}
	$SolutionsOfficeKeepChange = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 416
		Padding        = "25,0,0,0"
		Text           = $lang.SolutionsDeployOfficeChange
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $SolutionsOfficeChangeCfgClick
	}
	$SolutionsOfficeKeepShow = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 40
		Width          = 382
		Margin         = "29,0,0,25"
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_Reserved_Language" -ErrorAction SilentlyContinue) {
		$SolutionsOfficeKeepShow.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_Reserved_Language" -ErrorAction SilentlyContinue
	} else {
		$Verify_Language_New_Path = ISO_Local_Language_Calc
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_Reserved_Language" -value $Verify_Language_New_Path.Lang -Multi
		$SolutionsOfficeKeepShow.Text = $Verify_Language_New_Path.Lang
	}

	<#
		.部署 Office 到
	#>
	$SolutionsOfficeTo = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 416
		Text           = $lang.SolutionsDeployOfficeTo
	}
	$SolutionsOfficeToShow = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 95
		Width          = 416
		Padding        = "25,0,0,0"
		Text           = $lang.SolutionsDeployOfficeToPublic
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $SolutionsOfficeChangeCfgClick
	}

	<#
		.部署自定义合集包
	#>
	$SolutionsPackage  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 438
		Text           = $lang.DeployPackage
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($SolutionsPackage.Checked) {
				$SolutionsPackageShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_AllowDeployCollection" -value "True" -String
			} else {
				$SolutionsPackageShow.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_AllowDeployCollection" -value "False" -String
			}
		}
	}
	$SolutionsPackageShow = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "15,15,0,0"
		margin         = "0,0,0,35"
		autoScroll     = $false
	}

	<#
		.部署自定义合集包：部署到
	#>
	$SolutionsPackageTo = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 418
		Text           = $lang.DeployPackageTo
	}
	$SolutionsPackageToRoot = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 418
		Padding        = "18,0,0,0"
		Text           = $lang.DeployPackageToRoot
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_DeployCollectionSelect" -value "1" -String
		}
	}
	$SolutionsPackageToSolutions = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 418
		Padding        = "18,0,0,0"
		Text           = $lang.DeployPackageToSolutions
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_DeployCollectionSelect" -value "2" -String
		}
	}
	$SolutionsPackageToPublish = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 418
		Padding        = "18,0,0,0"
		Text           = $lang.SolutionsDeployOfficeToPublic
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_DeployCollectionSelect" -value "3" -String
		}
	}

	<#
		.部署自定义合集包：选择
	#>
	$SolutionsPackageSel = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 421
		margin         = "0,30,0,0"
		Text           = $lang.DeployPackageSelect
	}
	$SolutionsPackageSelList = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "15,0,8,0"
	}

	<#
		.加入的软件列表
	#>
	$GroupSoftwareListTitle = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 435
		Text           = $lang.RuleFileType
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($GroupSoftwareListTitle.Checked) {
				$GroupSoftwareList.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsSoftware" -value "True" -String
			} else {
				$GroupSoftwareList.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsSoftware" -value "False" -String
			}
		}
	}
	$GroupSoftwareList = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "18,0,0,0"
		margin         = "0,0,0,25"
	}

	<#
		.加入的字体列表
	#>
	$GroupFontsListTitle = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 435
		Text           = $lang.Fonts
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($GroupFontsListTitle.Checked) {
				$GroupFontsList.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsFonts" -value "True" -String
			} else {
				$GroupFontsList.Enabled = $False
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsFonts" -value "False" -String
			}
		}
	}
	$GroupFontsList    = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $false
		Padding        = "18,0,0,0"
		margin         = "0,0,0,10"
	}

	<#
		.选择应预答解决方案
	#>
	$SolutionsUnattend = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 470
		Text           = $lang.EnabledUnattend
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($SolutionsUnattend.Checked) {
				$GroupSolutionsUnattend.Enabled = $True
				$GUISolutionsVerifySync.Enabled = $True
				$GUISolutionsVerifySyncTips.Enabled = $True
			} else {
				$GroupSolutionsUnattend.Enabled = $False
				$GUISolutionsVerifySync.Enabled = $False
				$GUISolutionsVerifySyncTips.Enabled = $False
			}
		}
	}
	$GroupSolutionsUnattend = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		AutoSize       = 1
		BorderStyle    = 0
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "14,0,0,0"
		margin         = "2,0,0,25"
	}

	<#
		.选择应预答语言
	#>
	$GroupUnattendVer  = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $True
	}

	<#
		.指定应预答版本
	#>
	$Unattend_Version  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.ISOAddEICFG
	}
	$Unattend_Version_Select = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 415
		Margin         = "22,5,0,15"
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = $SchemeLangMultiClick
	}
	$Know_Version_Unattend = @()
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend" -directory -ErrorAction SilentlyContinue | ForEach-Object {
		$Know_Version_Unattend += $_.BaseName
		$Unattend_Version_Select.Items.Add($_.BaseName) | Out-Null
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_Scheme" -ErrorAction SilentlyContinue) {
		$GetSaveEngine = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_Scheme" -ErrorAction SilentlyContinue
		$Unattend_Version_Select.Text = $GetSaveEngine
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
			$GetSaveEngine = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue
			if ($Know_Version_Unattend -contains $GetSaveEngine) {
				$Unattend_Version_Select.Text = $GetSaveEngine
			} else {
				if ($Know_Version_Unattend -contains "11") {
					$Unattend_Version_Select.Text = "11"
				} else {
					$Unattend_Version_Select.Text = ""
				}
			}
		} else {
			$Unattend_Version_Select.Text = ""
		}
	}

	$Unattend_Version_Tips = New-Object System.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Margin         = "22,0,0,35"
		Text           = $lang.Unattend_Version_Tips
	}

	Function Refresh_Select_OOBE_Init_User
	{
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$init_Select_Default = ""

		if ($SchemeDiskHalf.Enabled) {
			if ($SchemeDiskHalf.Checked) {
				$init_Select_Default = "Custom"
			}
		}

		if ($SchemeDiskUefi.Enabled) {
			if ($SchemeDiskUefi.Checked) {
				$init_Select_Default = "Specified"
			}
		}

		if ($SchemeDiskLegacy.Enabled) {
			if ($SchemeDiskLegacy.Checked) {
				$init_Select_Default = "Specified"
			}
		}

		<#
			.选择“自定义创建帐号”或“指定默认帐号”
		#>
		switch ($init_Select_Default) {
			"Custom" {
				$SolutionsOther_Custom.Enabled = $True
				$SolutionsOther_Specified.Enabled = $True

			}
			"Specified" {
				$SolutionsOther_Custom.Enabled = $False
				$SolutionsOther_Specified.Enabled = $True
			}
		}

		if ($SolutionsOther_Specified.Enabled) {
			if ($SolutionsOther_Specified.Checked) {
				$SolutionsOther_Specified_Expand.Enabled = $True
			} else {
				$SolutionsOther_Specified_Expand.Enabled = $False
			}
		} else {
			$SolutionsOther_Specified_Expand.Enabled = $False
		}

		<#
			.判断是否选择：将目录名设置为主用户名
		#>
		if ($GUISolutionsVerifySync.Checked) {
			$SolutionsOther_Specified_Expand_UserName_Custom.Enabled = $False
		} else {
			$SolutionsOther_Specified_Expand_UserName_Custom.Enabled = $True
		}
	}

	$SolutionsOtherSelectUserGroup = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
		margin         = "0,0,0,30"
		autoScroll     = $False
	}
	$SolutionsOther_Initl = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 450
		Text           = $lang.OOBE_Init_User
	}

	$SolutionsOther_Custom = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.OOBE_init_Create
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_OOBE_Select_Init_User" -value "Custom" -String
			}

			Refresh_Select_OOBE_Init_User
		}
	}
	$SolutionsOther_Specified = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.OOBE_init_Specified
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_OOBE_Select_Init_User" -value "Specified" -String
			}

			Refresh_Select_OOBE_Init_User
		}
	}

	$SolutionsOther_Specified_Expand = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		Padding        = "16,0,0,0"
		autoScroll     = $False
	}
	$SolutionsOther_Specified_Expand_UserName_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 360
		Text           = "Administrator"
		margin         = "0,5,0,15"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	<#
		.初始化复选框：将目录名设置为主用户名
	#>
	$GUISolutionsVerifySync = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 405
		Text           = $lang.VerifyNameSync
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_Is_Sync_Folder_Name" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_Is_Sync_Folder_Name" -value "False" -String
			}

			Refresh_Select_OOBE_Init_User
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_Is_Sync_Folder_Name" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_Is_Sync_Folder_Name" -ErrorAction SilentlyContinue) {
			"True" {
				$GUISolutionsVerifySync.Checked = $True
			}
			"False" {
				$GUISolutionsVerifySync.Checked = $False
			}
		}
	} else {
		$GUISolutionsVerifySync.Checked = $False
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_OSAccountName" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_OSAccountName" -ErrorAction SilentlyContinue) {
			1 { $GUISolutionsVerifySync.Checked = $True }
			2 { $GUISolutionsVerifySync.Checked = $False }
		}
	}

	$GUISolutionsVerifySyncTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.VerifyNameSyncTips
		Padding        = "19,0,0,0"
		Margin         = "0,0,0,25"
	}

	<#
		.初始化复选框：自动登录
	#>
	$SolutionsOther_Specified_Expand_UserName_Autorun = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 405
		Text           = $lang.OOBE_Init_Autologin
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_Is_Autorun" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -name "$($Script:init_To_GPS)_Is_Autorun" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_Is_Autorun" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_Is_Autorun" -ErrorAction SilentlyContinue) {
			"True" {
				$SolutionsOther_Specified_Expand_UserName_Autorun.Checked = $True
			}
			"False" {
				$SolutionsOther_Specified_Expand_UserName_Autorun.Checked = $False
			}
		}
	} else {
		$SolutionsOther_Specified_Expand_UserName_Autorun.Checked = $True
	}

	<#
		.选择应预答：命令行
	#>
	$First_Command_Title = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.First_Run_Commmand
	}
	$First_Command_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 390
		margin         = "22,0,0,20"
		Text           = $lang.First_Run_Commmand_Setting
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$UIUnzipPanel_Error_Tips.visible = $False
			$UIUnzipPanel_Select_Rule.visible = $True
		}
	}

	<#
		.选择应预答：语言
	#>
	$SchemeVerTitle    = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.UnattendSelectVer
	}
	$SchemeVerMulti    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 425
		Padding        = "15,0,0,0"
		Text           = $lang.UnattendSelectSingleInstl
		add_Click      = $SchemeVerMultiClick
	}
	$SchemeVerSingleTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Padding        = "33,0,0,0"
		margin         = "0,10,0,0"
		Text           = $lang.SwitchLanguage
	}
	$SchemeVerSingle   = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 398
		Margin         = "35,5,0,35"
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = $SchemeVerMultiClick
	}

	# 安装方式
	$InstlModeTitle    = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.InstlMode
	}
	$GroupInstlMode    = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "20,0,0,35"
		autoScroll     = $True
	}
	$InstlModeBusiness = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 412
		Text           = $lang.Business
		add_Click      = { Solutions_Unattend_Refresh_Status }
	}
	$InstlModeConsumer = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 412
		Text           = $lang.Consumer
		add_Click      = { Solutions_Unattend_Refresh_Status }
	}
	$InstlModeTipsErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = ""
		Padding        = "16,0,0,0"
	}

	# 2 autounattend.xml
	$SchemeDiskTitle   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.UnattendSelectDisk
	}
	$GroupSchemeDisk   = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "20,0,0,30"
		autoScroll     = $True
	}
	$SchemeDiskHalf    = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.UnattendSelectSemi
		Checked        = $True
		add_Click      = {
			Solutions_Unattend_Refresh_Status
			Refresh_Select_OOBE_Init_User
		}
	}
	$SchemeDiskUefi    = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.UnattendSelectUefi
		ForeColor      = "#0000FF"
		add_Click      = {
			Solutions_Unattend_Refresh_Status
			Refresh_Select_OOBE_Init_User
		}
	}
	$SchemeDiskLegacy  = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.UnattendSelectLegacy
		ForeColor      = "#0000FF"
		add_Click      = {
			Solutions_Unattend_Refresh_Status
			Refresh_Select_OOBE_Init_User
		}
	}

	<#
		.指定序列号、索引号
	#>
	$SchemeDiskSpecifiedPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "0,25,0,0"
		autoScroll     = $True
		Enabled        = $False
	}
	$SchemeDiskSpecified = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 408
		Text           = $lang.NeedSpecified
	}

	<#
		.选择索引号
	#>
	$SchemeDiskSpecifiedIndex = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 408
		Text           = $lang.MountedIndex
		Padding        = "16,0,0,0"
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SchemeDiskSpecifiedIndex.Checked) {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $False
			}
		}
	}
	$SchemeDiskSpecifiedIndexUnlock = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 408
		Padding        = "33,0,0,0"
		Text           = $lang.UnlockBoot
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$SchemeDiskSpecifiedIndex.Enabled = $True

			if ($SchemeDiskSpecifiedIndex.Checked) {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedIndexPanel.Enabled = $False
			}
		}
	}
	$SchemeDiskSpecifiedIndexPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "0,0,0,25"
		autoScroll     = $False
	}
	$SchemeDiskSpecifiedIndexShow = New-Object System.Windows.Forms.Label -Property @{
		Height         = 55
		Width          = 408
		Padding        = "33,0,0,0"
		Text           = ""
	}
	$SchemeDiskSpecifiedIndexChange = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 390
		Padding        = "33,0,0,0"
		Text           = $lang.MountedIndexSelect
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			Solutions_Index_UI

			if ([string]::IsNullOrEmpty($Global:UnattendSelectIndex)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.MountedIndex)"
			} else {
				$SchemeDiskSpecifiedIndexShow.Text = $Global:UnattendSelectIndex.Name
			}
		}
	}

	<#
		.序列号
	#>
	$SchemeDiskSpecifiedKEY = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 408
		Text           = $lang.KMSKey
		Padding        = "16,0,0,0"
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SchemeDiskSpecifiedKEY.Checked) {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $False
			}
		}
	}
	$SchemeDiskSpecifiedKEYUnlock = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 408
		Padding        = "33,0,0,0"
		Text           = $lang.UnlockBoot
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$SchemeDiskSpecifiedKEY.Enabled = $True

			if ($SchemeDiskSpecifiedKEY.Checked) {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $True
			} else {
				$SchemeDiskSpecifiedKEYPanel.Enabled = $False
			}
		}
	}
	$SchemeDiskSpecifiedKEYPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "0,0,0,15"
		autoScroll     = $True
	}
	$SchemeDiskSpecifiedKEYShow = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 405
		Padding        = "33,0,0,0"
		Text           = ""
	}
	$SchemeDiskSpecifiedKEYChange = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 390
		Padding        = "33,0,0,0"
		Text           = $lang.KMSKeySelect
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			KMSkeys

			if ([string]::IsNullOrEmpty($Global:ProductKey)) {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = "$($lang.NoChoose): $($lang.KMSKey)"
			} else {
				$SchemeDiskSpecifiedKEYShow.Text = $Global:ProductKey
			}
		}
	}

	<#
		.显示应预答高级选项
	#>
	$GroupUnattendAdvTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.AddTo
	}

	<#
		.可选功能
	#>
	$GroupShowUnattendADV = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		margin         = "20,0,0,25"
		autoScroll     = $True
	}

	$CreateUnattendISO = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = $lang.CreateUnattendISO
		Checked        = $True
		add_Click      = $CreateUnattendISOClick
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISO" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISO" -ErrorAction SilentlyContinue) {
			"True" { $CreateUnattendISO.Checked = $True }
			"False" { $CreateUnattendISO.Checked = $False }
		}
	}

	$CreateUnattendISOSources = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = $lang.CreateUnattendISOSources
		Checked        = $True
		add_Click      = $CreateUnattendISOClick
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISOSources" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISOSources" -ErrorAction SilentlyContinue) {
			"True" { $CreateUnattendISOSources.Checked = $True }
			"False" { $CreateUnattendISOSources.Checked = $False }
		}
	}

	$CreateUnattendISOSourcesOEM = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = $lang.CreateUnattendISOSourcesOEM
		Checked        = $True
		add_Click      = $CreateUnattendISOClick
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISOSourcesOEM" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendISOSourcesOEM" -ErrorAction SilentlyContinue) {
			"True" { $CreateUnattendISOSourcesOEM.Checked = $True }
			"False" { $CreateUnattendISOSourcesOEM.Checked = $False }
		}
	}

	$CreateUnattendPanther = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = $lang.CreateUnattendPanther
		Checked        = $True
		add_Click      = $CreateUnattendISOClick
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendPather" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_AllowUnattendPather" -ErrorAction SilentlyContinue) {
			"True" { $CreateUnattendPanther.Checked = $True }
			"False" { $CreateUnattendPanther.Checked = $False }
		}
	}

	<#
		.安装界面
	#>
	$SolutionsUnattendSetupUI = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.OOBESetupOS
	}
	$GroupUnattendSetupUI = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		AutoSize       = 1
		Width          = 415
		BorderStyle    = 0
		autoSizeMode   = 1
		autoScroll     = $True
		margin         = "20,0,0,30"
	}

	<#
		.复选框：隐藏 激活 Windows
	#>
	$SolutionsUnattendOOBEActivate = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = "$($lang.Hide) $($lang.OOBEProductKey)"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendOOBEActivate.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsOOBEActivate" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsOOBEActivate" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsOOBEActivate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsOOBEActivate" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendOOBEActivate.Checked = $True }
			"False" { $SolutionsUnattendOOBEActivate.Checked = $False }
		}
	}

	<#
		.复选框：隐藏 选择要安装的操作系统
	#>
	$SolutionsUnattendSetupOSUI = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = "$($lang.Hide) $($lang.OOBEOSImage)"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendSetupOSUI.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsSetupUI" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsSetupUI" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsSetupUI" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsSetupUI" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendSetupOSUI.Checked = $True }
			"False" { $SolutionsUnattendSetupOSUI.Checked = $False }
		}
	}

	<#
		.复选框：隐藏 接受许可条款
	#>
	$SolutionsUnattendAccectEula = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 415
		Text           = "$($lang.Hide) $($lang.OOBEEula)"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendAccectEula.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsAccectEula" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsAccectEula" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsAccectEula" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsAccectEula" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendAccectEula.Checked = $True }
			"False" { $SolutionsUnattendAccectEula.Checked = $False }
		}
	} else {
		$SolutionsUnattendAccectEula.Checked = $True
	}

	<#
		.服务器选项
	#>
	$GroupUnattendServerUI = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 350
		Text           = $lang.LevelServer
	}

	<#
		.判断映像版本规则：服务器、桌面
	#>
	$GroupUnattendServer = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $True
		Padding        = "20,0,0,0"
		margin         = "0,0,0,30"
		Enabled        = $False
	}
	if ($Global:ImageType -eq "Server") {
		$GroupUnattendServer.Enabled = $True
	}

	<#
		.复选框：登录时不自动启动服务器管理器
	#>
	$SolutionsUnattendDoNotServerManager = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.OOBEDoNotServerManager
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendDoNotServerManager.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsDoNotServerManager" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsDoNotServerManager" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsDoNotServerManager" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsDoNotServerManager" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendDoNotServerManager.Checked = $True }
			"False" { $SolutionsUnattendDoNotServerManager.Checked = $False }
		}
	} else {
		$SolutionsUnattendDoNotServerManager.Checked = $True
	}

	$SolutionsUnattendIE = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.OOBEIE
		margin         = "0,20,0,0"
	}

	<#
		.Internet Explorer 增强的安全配置，关闭“管理员”
	#>
	$SolutionsUnattendIEAdmin = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 415
		Padding        = "15,0,0,0"
		Text           = $lang.OOBEIEAdmin
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendIEAdmin.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsIEAdmin" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsIEAdmin" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsIEAdmin" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsIEAdmin" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendIEAdmin.Checked = $True }
			"False" { $SolutionsUnattendIEAdmin.Checked = $False }
		}
	} else {
		$SolutionsUnattendIEAdmin.Checked = $True
	}

	<#
		.复选框：Internet Explorer 增强的安全配置，关闭“用户”
	#>
	$SolutionsUnattendIEUser = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 415
		Padding        = "15,0,0,0"
		Text           = $lang.OObeIEUser
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SolutionsUnattendIEUser.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsIEUser" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsIEUser" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsIEUser" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsIEUser" -ErrorAction SilentlyContinue) {
			"True" { $SolutionsUnattendIEUser.Checked = $True }
			"False" { $SolutionsUnattendIEUser.Checked = $False }
		}
	} else {
		$SolutionsUnattendIEUser.Checked = $True
	}

	<#
		.时间区域
	#>
	$GroupTimeZoneSelect = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $True
	}
	$SchemeTimeZoneSelect = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 425
		Text           = $lang.DeployTimeZone
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($SchemeTimeZoneSelect.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsTimeZone" -value "True" -String
				$SchemeTimezoneDynamicButton.Enabled = $True
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_IsTimeZone" -value "False" -String
				$SchemeTimezoneDynamicButton.Enabled = $False
			}
		}
	}
	$SchemeTimezoneDynamicNow = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 425
		Padding        = "14,0,0,0"
		Text           = ""
	}
	$SchemeTimezoneDynamicButton = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 425
		Padding        = "14,0,0,0"
		Text           = $lang.DeployTimeZoneChange
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$GUISolutionsUnattendChange.visible = $True
		}
	}

	<#
		蒙板：选择命令行
	#>
	$UIUnzipPanel_Select_Rule = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1055
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}

	<#
		.筛选时不再自动分类
	#>
	$UI_Command_Not_Class = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 500
		Location       = "15,15"
		Text           = $lang.Command_Not_Class
		add_Click      = {
			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Allow_Command_Not_Class" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Allow_Command_Not_Class" -value "False" -String
			}

			Refresh_Command_Rule_Select_Group
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Allow_Command_Not_Class" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Allow_Command_Not_Class" -ErrorAction SilentlyContinue) {
			"True" {
				$UI_Command_Not_Class.Checked = $True
			}
			"False" {
				$UI_Command_Not_Class.Checked = $False
			}
		}
	}

	<#
		.选择命令行，显示菜单
	#>
	$UIUnzipPanel_Select_Rule_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 610
		Width          = 500
		Location       = "15,60"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,0,8,0"
	}

	<#
		.错误提示框
	#>
	$UIUnzipPanel_Error_Tips = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 300
		Width          = 480
		Location       = "560,200"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "15,15,15,15"
		Visible        = $False
	}

	$UIUnzipPanel_Error_Tips_Msg = New-Object System.Windows.Forms.Label -Property @{
		AutoSize       = 1
		margin         = "0,0,0,25"
		Text           = $lang.Waring_Not_Select_Command
	}
	$UIUnzipPanel_Error_Tips_Quick_Select = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.Quic_Fix_Not_Select_Command
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
					if ("WinSetup" -eq $_.Name) {
						$_.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($Script:Init_Pre_Select_Command -contains $_.Tag) {
									$_.Checked = $True
								}
							}
						}
					}
				}
			}

			Save_User_Select_Command_To_Regedit
		}
	}
	$UIUnzipPanel_Error_Unattend_Auto_Fix_Next = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 425
		Text           = $lang.Unattend_Auto_Fix_Next
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			<#
				.选择复选框：未选择必备项时自动修复
			#>
			$Engine_Unattend_Auto_Fix.Checked = $True
			Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Is_Auto_Fix_Command" -value "True" -String

			$UIUnzipPanel_Error_Unattend_Auto_Fix_Next.Visible = $False
			$UIUnzipPanel_Error.Text = "$($lang.Choose): $($lang.Unattend_Auto_Fix)"
		}
	}

	$UIUnzipPanel_Tips = New-Object System.Windows.Forms.RichTextBox -Property @{
		BorderStyle    = 0
		Height         = 150
		Width          = 480
		Location       = "560,15"
		Text           = $lang.Command_Tips
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}

	$UIUnzipPanel_Error = New-Object system.Windows.Forms.Label -Property @{
		Location       = "560,600"
		Height         = 30
		Width          = 455
		Text           = ""
	}
	$UIUnzipPanel_Select_Rule_Menu_OK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 240
		Text           = $lang.OK
		add_Click      = {
			Save_User_Select_Command_To_Regedit
			$UIUnzipPanel_Select_Rule.visible = $False
		}
	}
	$UIUnzipPanel_Select_Rule_Menu_Canel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "807,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Cancel
		add_Click      = {
			$UIUnzipPanel_Select_Rule.visible = $False
		}
	}

	<#
		.蒙板：更改应预答其它配置
	#>
	$GUISolutionsUnattendChange = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 760
		Width          = 1055
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	$GUISolutionsUnattendChangeShowTimeZone = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 675
		Width          = 415
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		autoScroll     = $True
	}
	$GUISolutionsUnattendChangeCustomize = New-Object System.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 400
		Text           = $lang.DeployTimeZoneChange
		Location       = '470,15'
	}
	$GUISolutionsUnattendChangeCustomizeInput = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 395
		Text           = $Global:ProductKey
		Location       = '486,55'
	}
	$GUISolutionsUnattendChangeInputTips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 36
		Width          = 425
		Text           = $lang.DeployTimeZoneChangeTips
		Location       = "485,95"
	}
	$GUISolutionsUnattendChangeCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "807,635"
		Height         = 36
		Width          = 240
		Text           = $lang.Cancel
		add_Click      = {
			$GUISolutionsUnattendChange.visible = $False
		}
	}

	# 解决方案拷贝到
	$SolutionsCopyToTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.SolutionsTo
	}
	$GroupSolutionsCopyTo = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.到已挂载目录
	#>
	$SolutionsToMount  = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 445
		Text           = $lang.SolutionsToMount
		Padding        = "15,0,0,0"
		add_Click      = { Solutions_Create_Refresh_Add_To_Path }
	}

	<#
		.到 OEM
	#>
	$SolutionsToSources = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 30
		Width          = 445
		Text           = $lang.SolutionsToSources
		Padding        = "15,0,0,0"
		add_Click      = { Solutions_Create_Refresh_Add_To_Path }
	}

	if ($ISO) {
		$SolutionsToSources.Checked = $True
	} else {
		$SolutionsToMount.Checked = $True
	}

	# 4 选择主引擎
	$SolutionsEngine   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Margin         = "0,35,0,0"
		Text           = $lang.EnabledEnglish
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($this.Checked) {
				$GroupSolutionsEngine.Enabled = $True
			} else {
				$GroupSolutionsEngine.Enabled = $False
			}
		}
	}
	$GroupSolutionsEngine = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		AutoSize       = 1
		autoSizeMode   = 1
		Padding        = "10,10,0,30"
		autoScroll     = $False
	}

	<#
		选择主引擎版本
	#>
	$GroupMainVerTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 435
		Text           = $lang.SolutionsScript
	}

	<#
		.获取已选择的部署引擎版本
	#>
	$GroupMainVerList  = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 420
		Margin         = "22,5,0,40"
		Text           = ""
		DropDownStyle  = "DropDownList"
	}

	$GroupShowEngineADV = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
	}

	<#
		.其它
	#>
	$EngineFirstAdvTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.AdvOption
	}

	<#
		.未选择必备项时自动修复
	#>
	$Engine_Unattend_Auto_Fix = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 430
		Padding        = "15,0,0,0"
		Text           = $lang.Unattend_Auto_Fix
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($this.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Is_Auto_Fix_Command" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_Is_Auto_Fix_Command" -value "False" -String
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Is_Auto_Fix_Command" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Is_Auto_Fix_Command" -ErrorAction SilentlyContinue) {
			"True" { $Engine_Unattend_Auto_Fix.Checked = $True }
			"False" { $Engine_Unattend_Auto_Fix.Checked = $False }
		}
	} else {
		$Engine_Unattend_Auto_Fix.Checked = $True
	}

	$Engine_Unattend_Auto_Fix_Tips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.Unattend_Auto_Fix_Tips
		Padding        = "33,0,0,0"
		margin         = "0,0,0,25"
	}

	$EngineFirstExpRequirements = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 433
		margin         = "0,25,0,0"
		Text           = $lang.FirstExpRequirements
	}

	$EngineChkSyncMark = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Padding        = "15,0,0,0"
		Text           = $lang.FirstExpSyncMark
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Mark_Sync" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Mark_Sync" -ErrorAction SilentlyContinue) {
			"True" { $EngineChkSyncMark.Checked = $True }
			"False" { $EngineChkSyncMark.Checked = $False }
		}
	} else {
		$EngineChkSyncMark.Checked = $True
	}

	$EngineChkUpdate   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.FirstExpUpdate
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Auto_Update" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Auto_Update" -ErrorAction SilentlyContinue) {
			"True" { $EngineChkUpdate.Checked = $True }
			"False" { $EngineChkUpdate.Checked = $False }
		}
	} else {
		$EngineChkUpdate.Checked = $False
	}

	$EngineDefender    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.FirstExpDefender
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Defender" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Defender" -ErrorAction SilentlyContinue) {
			"True" { $EngineDefender.Checked = $True }
			"False" { $EngineDefender.Checked = $False }
		}
	} else {
		$EngineDefender.Checked = $False
	}

	$EngineNetworkLocationWizard = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = "$($lang.Disable) $($lang.NetworkLocationWizard)"
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Network_Location_Wizard" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Network_Location_Wizard" -ErrorAction SilentlyContinue) {
			"True" { $EngineNetworkLocationWizard.Checked = $True }
			"False" { $EngineNetworkLocationWizard.Checked = $False }
		}
	} else {
		$EngineNetworkLocationWizard.Checked = $True
	}

	$GUISolutionsVolume = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.FirstExpSyncLabel
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Sync_Volume_Name" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Sync_Volume_Name" -ErrorAction SilentlyContinue) {
			"True" { $GUISolutionsVolume.Checked = $True }
			"False" { $GUISolutionsVolume.Checked = $False }
		}
	}

	$GUIMultipleLanguages = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 418
		margin         = "15,25,0,0"
		Text           = $lang.MultipleLanguages
	}

	$GUIPreAppxCleanup = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.PreAppxCleanup
		Padding        = "34,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PreAppxCleanup" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PreAppxCleanup" -ErrorAction SilentlyContinue) {
			"True" { $GUIPreAppxCleanup.Checked = $True }
			"False" { $GUIPreAppxCleanup.Checked = $False }
		}
	} else {
		$GUIPreAppxCleanup.Checked = $False
	}

	$GUILanguageComponents = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.LanguageComponents
		Padding        = "34,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_LanguageComponents" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_LanguageComponents" -ErrorAction SilentlyContinue) {
			"True" { $GUILanguageComponents.Checked = $True }
			"False" { $GUILanguageComponents.Checked = $False }
		}
	} else {
		$GUILanguageComponents.Checked = $False
	}

	$GUIPreventCleaningUnusedLP = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 430
		Text           = $lang.PreventCleaningUnusedLP
		Padding        = "34,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PreventCleaningUnusedLP" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PreventCleaningUnusedLP" -ErrorAction SilentlyContinue) {
			"True" { $GUIPreventCleaningUnusedLP.Checked = $True }
			"False" { $GUIPreventCleaningUnusedLP.Checked = $False }
		}
	}

	$EngineDeskMenu    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 420
		Text           = $lang.FirstExpContextCustomize
		margin         = "15,25,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($EngineDeskMenu.Checked) {
				$EngineDeskMenuShift.Enabled = $True
			} else {
				$EngineDeskMenuShift.Enabled = $False
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Desktop_Menu" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Desktop_Menu" -ErrorAction SilentlyContinue) {
			"True" { $EngineDeskMenu.Checked = $True }
			"False" { $EngineDeskMenu.Checked = $False }
		}
	}

	$EngineDeskMenuShift = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 432
		Text           = $lang.FirstExpContextCustomizeShift
		Padding        = "34,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Desktop_Menu_Shift" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Desktop_Menu_Shift" -ErrorAction SilentlyContinue) {
			"True" { $EngineDeskMenuShift.Checked = $True }
			"False" { $EngineDeskMenuShift.Checked = $False }
		}
	}

	$EngineRegional    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 420
		Text           = $lang.SolutionsEngineRegional
		margin         = "15,25,0,0"
		add_Click      = {
			if ($EngineRegional.Checked) {
				$EngineRegionalShow.Enabled = $True
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Is_Region" -value "True" -String
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Is_Region" -value "False" -String
				$EngineRegionalShow.Enabled = $False
			}

			Solutions_Create_Refresh_Regional
		}
	}
	$EngineRegionalShow = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 40
		Width          = 404
		Text           = ""
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		margin         = "31,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			$GUISolutionsRegional.visible = $True
		}
	}

	<#
		.复选框：首次体验重启
	#>
	$EnginePrerequisitesReboot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 420
		Text           = $lang.EnglineDoneReboot
		margin         = "15,15,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Prerequisites_Reboot" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Prerequisites_Reboot" -ErrorAction SilentlyContinue) {
			"True" { $EnginePrerequisitesReboot.Checked = $True }
			"False" { $EnginePrerequisitesReboot.Checked = $False }
		}
	} else {
		$EnginePrerequisitesReboot.Checked = $True
	}

	$EnginePrerequisitesRebootTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.FirstExpRequirementsTips
		margin         = "31,0,0,0"
	}

	$GUISolutionsEngineFinish = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 435
		margin         = "0,45,0,0"
		Text           = $lang.FirstExpFinish
	}

	$EnginePopsupEngine = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Text           = $lang.FirstExpFinishPopup
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PopupEngine" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_PopupEngine" -ErrorAction SilentlyContinue) {
			"True" { $EnginePopsupEngine.Checked = $True }
			"False" { $EnginePopsupEngine.Checked = $False }
		}
	}

	$EngineFirstExp    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Text           = $lang.FirstExpFinishOnDemand
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Allow_First_Pre_Experience" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Allow_First_Pre_Experience" -ErrorAction SilentlyContinue) {
			"True" { $EngineFirstExp.Checked = $True }
			"False" { $EngineFirstExp.Checked = $False }
		}
	}

	$EngineRestricted  = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Text           = $lang.SolutionsEngineRestricted
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Restricted" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Restricted" -ErrorAction SilentlyContinue) {
			"True" { $EngineRestricted.Checked = $True }
			"False" { $EngineRestricted.Checked = $False }
		}
	}

	$EngineDoneClearFull = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Text           = $lang.EnglineDoneClearFull
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($EngineDoneClearFull.Checked) {
				$EngineDeskMenu.Enabled = $False
				$EngineDeskMenuShift.Enabled = $False
				$EnginePopsupEngine.Enabled = $False
				$EngineDoneClear.Enabled = $False
				$EngineDoneClear.Checked = $False
				$EngineDefender.Enabled = $False
			} else {
				$EngineDeskMenu.Enabled = $True
				$EngineDeskMenuShift.Enabled = $True
				$EnginePopsupEngine.Enabled = $True
				$EngineDoneClear.Enabled = $True
				$EngineDefender.Enabled = $True
			}
		}
	}
	$EngineDoneClear   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Padding        = "15,0,0,0"
		Text           = $lang.EnglineDoneClear
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($EngineDoneClear.Checked) {
				$EngineDeskMenu.Enabled = $False
				$EngineDeskMenuShift.Enabled = $False
				$EnginePopsupEngine.Enabled = $False
				$EngineDefender.Enabled = $False
			} else {
				$EngineDeskMenu.Enabled = $True
				$EngineDeskMenuShift.Enabled = $True
				$EnginePopsupEngine.Enabled = $True
				$EngineDefender.Enabled = $True
			}
		}
	}

	$FirstExpFinishReboot = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 435
		Text           = $lang.EnglineDoneReboot
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_First_Experience_Reboot" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_First_Experience_Reboot" -ErrorAction SilentlyContinue) {
			"True" {
				$FirstExpFinishReboot.Checked = $True
			}
		}
	}

	$FirstExpFinishRebootTips = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.FirstExpFinishTips
		Padding        = "34,0,0,0"
		margin         = "0,0,0,5"
	}

	<#
		.Set the name of the system disk home directory
		.设置系统盘主目录名称
	#>
	$SolutionsOtherFunctionGroup = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSize       = 1
		autoSizeMode   = 1
		margin         = "0,35,0,0"
		autoScroll     = $False
	}

	$GUISolutionsVerifyTitle = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 460
		Text           = $lang.VerifyName
	}
	$GUISolutionsVerify = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 460
		Text           = $lang.VerifyNameUse
		Checked        = $True
		Padding        = "15,0,0,0"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}

	$GUISolutionsCustomizeName = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 390
		Text           = ""
		margin         = "35,5,0,15"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_SaveEngine" -ErrorAction SilentlyContinue) {
		$GetSaveEngine = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_SaveEngine" -ErrorAction SilentlyContinue
		$GUISolutionsCustomizeName.Text = $GetSaveEngine
	} else {
		$GUISolutionsCustomizeName.Text = $(Get-Module -Name Solutions).Author
	}

	$GUISolutionsVerifyErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = $lang.VerifyNameTips
		Padding        = "31,0,0,0"
	}

	<#
		.侧边栏：仪表板
	#>
	$Solutions_Dashboard_Group = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 425
		Width          = 485
		autoSizeMode   = 1
		Location       = '560,15'
		autoScroll     = $True
	}

	$UI_Main_Dashboard = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Text           = $lang.Dashboard
	}

	$UI_Main_Dashboard_Event_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Padding        = "16,0,0,0"
		Text           = "$($lang.EventManager): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 430
		Text           = $lang.EventManagerCurrentClear
		Padding        = "32,0,0,0"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_Event_Clear -All }
	}

	$UI_Main_Dashboard_Event_Mul = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Padding        = "32,0,0,0"
		margin         = "0,15,0,0"
		Text           = $lang.EventManagerMul
	}
	$UI_Main_Dashboard_Event_Engine_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Padding        = "48,0,0,0"
		Text           = "$($lang.EnabledEnglish): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Engine_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 430
		margin         = "0,0,0,15"
		Padding        = "64,0,0,0"
		Text           = $lang.EventManagerCurrentClear
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_Event_Clear -Engine }
	}

	$UI_Main_Dashboard_Event_Unattend_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Padding        = "48,0,0,0"
		Text           = "$($lang.EnabledUnattend): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Unattend_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 430
		margin         = "0,0,0,15"
		Padding        = "64,0,0,0"
		Text           = $lang.EventManagerCurrentClear
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_Event_Clear -Unattend }
	}

	$UI_Main_Dashboard_Event_Collection_Status = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 430
		Padding        = "48,0,0,0"
		Text           = "$($lang.EnabledSoftwarePacker): $($lang.Failed)"
	}
	$UI_Main_Dashboard_Event_Collection_Clear = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 430
		margin         = "0,0,0,15"
		Padding        = "64,0,0,0"
		Text           = $lang.EventManagerCurrentClear
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Solutions_Event_Clear -Collection }
	}

	<#
		.End on-demand mode
		.结束按需模式
	#>
	$UI_Main_Suggestion_Manage = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '560,500'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop_Current = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 415
		Text           = $lang.AssignEndCurrent -f $Global:Primary_Key_Image.Uid
		Location       = '560,530'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			Event_Need_Mount_Global_Variable -DevQueue "6" -Master $Global:Primary_Key_Image.Master -MasterSuffix $Global:Primary_Key_Image.MasterSuffix -ImageFileName $Global:Primary_Key_Image.ImageFileName -Suffix $Global:Primary_Key_Image.Suffix
			Event_Reset_Suggest
			$UI_Main.Close()
		}
	}
	$UI_Main_Event_Assign_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '560,560'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	<#
		.Suggested content
		.建议的内容
	#>
	$UI_Main_Suggestion_Not = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 430
		Text           = $lang.SuggestedSkip
		Location       = '560,495'
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			
			if ($UI_Main_Suggestion_Not.Checked) {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "True" -String
				$UI_Main_Suggestion_Setting.Enabled = $False
				$UI_Main_Suggestion_Stop.Enabled = $False
			} else {
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -name "IsSuggested" -value "False" -String
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}
		}
	}
	$UI_Main_Suggestion_Setting = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignSetting
		Location       = '575,531'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Event_Assign_Setting }
	}
	$UI_Main_Suggestion_Stop = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 280
		Text           = $lang.AssignForceEnd
		Location       = '575,560'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = $UI_Main_Suggestion_Stop_Click
	}

	$UI_Main_End_Wrap  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 435
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "560,600"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "585,602"
		Height         = 30
		Width          = 460
		Text           = ""
	}
	$UI_Main_Event_Clear = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "560,635"
		Height         = 36
		Width          = 158
		Text           = $lang.EventManagerCurrentClear
		add_Click      = { Solutions_Event_Clear -All }
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "725,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Save
		add_Click      = {
			if (Autopilot_Solutions_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "889,635"
		Height         = 36
		Width          = 158
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()

			if ($UI_Main_Suggestion_Not.Checked) {
				Init_Canel_Event
			}

			Write-Host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UIUnzipPanel_Select_Rule,
		$GUISolutionsUnattendChange,
		$GUISolutionsCollectionChange,
		$GUISolutionsOfficeChange,
		$GUISolutionsRegional,
		$Solutions_Dashboard_Group,                     # 右侧边栏
		$GUISolutionsShowGlobal,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Event_Clear,
		$UI_Main_Save,
		$UI_Main_Canel
	))

	<#
		.蒙板：命令行，选择规则
	#>
	$UIUnzipPanel_Select_Rule.controls.AddRange((
		$UI_Command_Not_Class,
		$UIUnzipPanel_Select_Rule_Menu,
		$UIUnzipPanel_Error_Tips,
		$UIUnzipPanel_Tips,
		$UIUnzipPanel_Error,
		$UIUnzipPanel_Select_Rule_Menu_OK,
		$UIUnzipPanel_Select_Rule_Menu_Canel
	))

	$UIUnzipPanel_Error_Tips.controls.AddRange((
		$UIUnzipPanel_Error_Tips_Msg,
		$UIUnzipPanel_Error_Tips_Quick_Select,
		$UIUnzipPanel_Error_Unattend_Auto_Fix_Next
	))

	$Solutions_Dashboard_Group.controls.AddRange((
		$UI_Main_Dashboard,
		$UI_Main_Dashboard_Event_Status,
		$UI_Main_Dashboard_Event_Clear,
		$UI_Main_Dashboard_Event_Mul,
		$UI_Main_Dashboard_Event_Engine_Status,
		$UI_Main_Dashboard_Event_Engine_Clear,
		$UI_Main_Dashboard_Event_Unattend_Status,
		$UI_Main_Dashboard_Event_Unattend_Clear,
		$UI_Main_Dashboard_Event_Collection_Status,
		$UI_Main_Dashboard_Event_Collection_Clear
	))

	$GUISolutionsShowGlobal.controls.AddRange((
		$SolutionsCopyToTitle,                     # 解决方案添加到标题
		$GroupSolutionsCopyTo,                     # 解决方案添加到：组
		$SolutionsOtherFunctionGroup,              # 全局组：添加到的主目录名
		$SolutionsEngine,                          # 全局组：引擎，选择
		$GroupSolutionsEngine,                     # 全局组：引擎，显示区域
		$SolutionsUnattend,                        # 全局组：应预答，选择
		$GroupSolutionsUnattend,                   # 全局组：应预答，显示区域
		$SolutionsSoftwarePacker,                  # 全局组：添加合集，选择
		$GroupSolutionsSoftwarePacker,             # 全局组：添加合集，显示区域
		$UI_Main_End_Wrap
	))

	<#
		.Installation method
		.将解决方案添加到
	#>
	$GroupSolutionsCopyTo.controls.AddRange((
		$SolutionsToMount,
		$SolutionsToSources
	))

	$SolutionsOtherSelectUserGroup.controls.AddRange((
		$SolutionsOther_Custom,
		$SolutionsOther_Specified,
		$SolutionsOther_Specified_Expand
	))
	$SolutionsOther_Specified_Expand.controls.AddRange((
		$SolutionsOther_Specified_Expand_UserName_Custom,
		$GUISolutionsVerifySync,
		$GUISolutionsVerifySyncTips,
		$SolutionsOther_Specified_Expand_UserName_Autorun
	))

	$SolutionsOtherFunctionGroup.controls.AddRange((
		$GUISolutionsVerifyTitle,
		$GUISolutionsVerify,
		$GUISolutionsCustomizeName,
		$GUISolutionsVerifyErrorMsg
	))

	$GUISolutionsCollectionChange.controls.AddRange((
		$GUISolutionsCollectionChangeShowLanguage,
		$GUISolutionsCollectionChangeAdv,
		$GUISolutionsCollectionLangGet,
		$GUISolutionsCollectionLangSync,
		$GUISolutionsCollectionChange_Error_Icon,
		$GUISolutionsCollectionChange_Error,
		$GUISolutionsCollectionChangeCanel
	))
	
	$GUISolutionsOfficeChange.controls.AddRange((
		$GUISolutionsOfficeChangeShowLanguage,
		$GUISolutionsOfficeChangeAdv,
		$SolutionsOfficeOnly,
		$SolutionsOfficeOnlyTips,
		$GUISolutionsOfficeLangGet,
		$GUISolutionsOfficeLangSync,
		$GUISolutionsGroupOfficeTo,
		$GUISolutionsOfficeChange_Error_Icon,
		$GUISolutionsOfficeChange_Error,
		$GUISolutionsOfficeChangeCanel
	))

	$GUISolutionsRegional.controls.AddRange((
		$GUISolutionsShowLanguage,
		$GUISolutionsShowLanguageUTF8Title,
		$GUISolutionsShowLanguageUTF8,
		$GUISolutionsShowLanguageUTF8Tips,
		$GUISolutionsShowLanguageTitle,
		$GUISolutionsShowNewLanguage,
		$GUISolutionsRegionalChangeTips,

		$GUISolutionsRegionalCanel
	))

	$GUISolutionsGroupOfficeTo.controls.AddRange((
		$GUISolutionsGroupOfficeToTitle,
		$GUISolutionsOfficeToPublic,
		$GUISolutionsOfficeToPublicShow,
		$GUISolutionsOfficeToMain,
		$GUISolutionsOfficeToMain_Path
	))

	$GUISolutionsRegionalChangeTips.controls.AddRange((
		$GUISolutionsRegionalChangeTipsErrorMsg
	))

	<#
		软件包添加区域
	#>
	$GroupSolutionsSoftwarePacker.controls.AddRange((
		$GroupSoftwarePackerAdvTitle,
		$GroupSoftwarePackerADV,
		$SchemeLangTitle,
		$GroupSchemeLang,
		$ArchitectureTitle,
		$GroupArchitecture,
		$SolutionsOffice,
		$SolutionsOfficeShow,
		$SolutionsPackage,
		$SolutionsPackageShow,
		$GroupSoftwareListTitle,
		$GroupSoftwareList,
		$GroupFontsListTitle,
		$GroupFontsList
	))
	$SolutionsPackageShow.controls.AddRange((
		$SolutionsPackageTo,
		$SolutionsPackageToRoot,
		$SolutionsPackageToSolutions,
		$SolutionsPackageToPublish,
		$SolutionsPackageSel,
		$SolutionsPackageSelList
	))

	$SolutionsOfficeShow.controls.AddRange((
		$SolutionsOfficePre,
		$Solutions_Office_Select,
		$SolutionsOfficeKeep,
		$SolutionsOfficeKeepChange,
		$SolutionsOfficeKeepShow,
		$SolutionsOfficeTo,
		$SolutionsOfficeToShow
	))

	$GroupSoftwarePackerADV.controls.AddRange((
		$CreateReport
	))
	$GroupSchemeLang.controls.AddRange((
		$SchemeLangMulti,
		$SolutionsCollectionKeep,
		$SolutionsCollectionKeepChange,
		$SolutionsCollectionKeepShow,
		$SchemeLangSingleTitle,
		$SchemeLangSingle
	))
	$GroupArchitecture.controls.AddRange((
		$ArchitectureARM64,
		$ArchitectureAMD64,
		$ArchitectureX86,
		$SoftwareTips
	))
	$SoftwareTips.controls.AddRange($SoftwareTipsErrorMsg)

	<#
		应预答显示区域
	#>
	$GroupSolutionsUnattend.controls.AddRange((
		$Unattend_Version,
		$Unattend_Version_Select,
		$Unattend_Version_Tips,

		$SolutionsOther_Initl,
		$SolutionsOtherSelectUserGroup,
		
		$First_Command_Title,
		$First_Command_Select,
		$GroupUnattendVer,
		$InstlModeTitle,
		$GroupInstlMode,
		$SchemeDiskTitle,
		$GroupSchemeDisk,                # 选择 Unattend.xml 解决方案
		$GroupUnattendAdvTitle,
		$GroupShowUnattendADV,
		$SolutionsUnattendSetupUI,       # 安装界面
		$GroupUnattendSetupUI,           # 安装界面
		$GroupUnattendServerUI,
		$GroupUnattendServer,
		$GroupTimeZoneSelect
	))
	$GroupUnattendSetupUI.Controls.AddRange((
		$SolutionsUnattendOOBEActivate,        # 隐藏产品密钥
		$SolutionsUnattendSetupOSUI,           # 选择要安装的操作系统
		$SolutionsUnattendAccectEula           # 隐藏接受许可条款
	))

	$GroupUnattendServer.Controls.AddRange((
		$SolutionsUnattendDoNotServerManager,  # 登录时不自动启动服务器管理器
		$SolutionsUnattendIE,                  # Internet Explorer 增强的安全配置
		$SolutionsUnattendIEAdmin,             # 管理员
		$SolutionsUnattendIEUser               # 用户
	))
	$GroupTimeZoneSelect.controls.AddRange((
		$SchemeTimeZoneSelect,                 # 时间区域
		$SchemeTimezoneDynamicNow,             # 显示区域状态
		$SchemeTimezoneDynamicButton           # 更改时间区域
	))

	$GroupShowUnattendADV.controls.AddRange((
		$CreateUnattendISO,
		$CreateUnattendISOSources,
		$CreateUnattendISOSourcesOEM,
		$CreateUnattendPanther
	))
	$GroupUnattendVer.controls.AddRange((
		$SchemeVerTitle,
		$SchemeVerMulti,
		$SchemeVerSingleTitle,
		$SchemeVerSingle
	))
	$GroupSchemeDisk.controls.AddRange((
		$SchemeDiskHalf,
		$SchemeDiskUefi,
		$SchemeDiskLegacy,
		$SchemeDiskSpecifiedPanel
	))

	$SchemeDiskSpecifiedPanel.controls.AddRange((
		$SchemeDiskSpecified,
		$SchemeDiskSpecifiedIndex,
		$SchemeDiskSpecifiedIndexUnlock,
		$SchemeDiskSpecifiedIndexPanel,
		$SchemeDiskSpecifiedKEY,
		$SchemeDiskSpecifiedKEYUnlock,
		$SchemeDiskSpecifiedKEYPanel
	))
	$SchemeDiskSpecifiedIndexPanel.controls.AddRange((
		$SchemeDiskSpecifiedIndexShow,
		$SchemeDiskSpecifiedIndexChange
	))
	$SchemeDiskSpecifiedKEYPanel.controls.AddRange((
		$SchemeDiskSpecifiedKEYShow,
		$SchemeDiskSpecifiedKEYChange
	))

	$GroupInstlMode.controls.AddRange((
		$InstlModeBusiness,
		$InstlModeConsumer,
		$InstlModeTipsErrorMsg
	))
	$GUISolutionsUnattendChange.controls.AddRange((
		$GUISolutionsUnattendChangeShowTimeZone,
		$GUISolutionsUnattendChangeCustomize,
		$GUISolutionsUnattendChangeCustomizeInput,
		$GUISolutionsUnattendChangeInputTips,
		$GUISolutionsUnattendChangeCanel
	))

	<#
		.Main engine add area
		.主引擎添加区域
	#>
	$GroupSolutionsEngine.controls.AddRange((
		$GroupMainVerTitle,
		$GroupMainVerList,
		$GroupShowEngineADV
	))
	$GroupShowEngineADV.controls.AddRange((
		$EngineFirstAdvTitle,
		$Engine_Unattend_Auto_Fix,
		$Engine_Unattend_Auto_Fix_Tips,
		$EngineFirstExpRequirements,
		$EngineChkSyncMark,
		$EngineChkUpdate,
		$EngineDefender,
		$EngineNetworkLocationWizard,
		$GUISolutionsVolume,
		$GUIMultipleLanguages,
		$GUIPreAppxCleanup,
		$GUILanguageComponents,
		$GUIPreventCleaningUnusedLP,
		$EngineDeskMenu,
		$EngineDeskMenuShift,
		$EngineRegional,
		$EngineRegionalShow,
		$EnginePrerequisitesReboot,
		$EnginePrerequisitesRebootTips,
		$GUISolutionsEngineFinish,
		$EnginePopsupEngine,
		$EngineFirstExp,
		$EngineRestricted,
		$EngineDoneClearFull,
		$EngineDoneClear,
		$FirstExpFinishReboot,
		$FirstExpFinishRebootTips
	))

	if ($ISO) {
		$SolutionsToMount.Enabled = $False
		$SolutionsToMount.Checked = $False
		$SolutionsToSources.Enabled = $True
		$SolutionsToSources.Checked = $True
	} else {
		if ($Global:AutopilotMode) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

			$SolutionsToMount.Enabled = $True
			$SolutionsToMount.Checked = $True
			$SolutionsToSources.Enabled = $False
			$SolutionsToSources.Checked = $false
		}

		if ($Global:EventQueueMode) {
			Write-Host "`n  $($lang.Solution): $($lang.IsCreate)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.OnDemandPlanTask), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
			$UI_Main.controls.AddRange((
				$UI_Main_Suggestion_Manage,
				$UI_Main_Suggestion_Stop_Current,
				$UI_Main_Event_Assign_Stop
			))

			$SolutionsToMount.Enabled = $True
			$SolutionsToMount.Checked = $True
			$SolutionsToSources.Enabled = $False
			$SolutionsToSources.Checked = $false
		}

		if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
			Write-Host "`n  $($lang.Solution): $($lang.IsCreate)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"

			if (Image_Is_Select_IAB) {
				$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"

				$TestFolderMountRoute = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

				if (Test-Path -Path $TestFolderMountRoute -PathType Container) {
					$SolutionsToMount.Enabled = $True
					$SolutionsToMount.Checked = $True
					$SolutionsToSources.Enabled = $True
					$SolutionsToSources.Checked = $False
				} else {
					$SolutionsToMount.Enabled = $False
					$SolutionsToMount.Checked = $False
					$SolutionsToSources.Enabled = $True
					$SolutionsToSources.Checked = $True
				}
			} else {
				$SolutionsToMount.Enabled = $False
				$SolutionsToMount.Checked = $False
				$SolutionsToSources.Enabled = $True
				$SolutionsToSources.Checked = $True
			}

			<#
				.初始化复选框：不再建议
			#>
			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Suggested\$($Global:Event_Guid)" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
					"True" {
						$UI_Main_Suggestion_Not.Checked = $True
						$UI_Main_Suggestion_Setting.Enabled = $False
						$UI_Main_Suggestion_Stop.Enabled = $False
					}
					"False" {
						$UI_Main_Suggestion_Not.Checked = $False
						$UI_Main_Suggestion_Setting.Enabled = $True
						$UI_Main_Suggestion_Stop.Enabled = $True
					}
				}
			} else {
				$UI_Main_Suggestion_Not.Checked = $False
				$UI_Main_Suggestion_Setting.Enabled = $True
				$UI_Main_Suggestion_Stop.Enabled = $True
			}

			if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) {
				if ((Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "IsSuggested" -ErrorAction SilentlyContinue) -eq "True") {
					$UI_Main.controls.AddRange((
						$UI_Main_Suggestion_Not,
						$UI_Main_Suggestion_Setting,
						$UI_Main_Suggestion_Stop
					))
				}
			}
		}
	}

	<#
		刷新添加解决方案到，复选框
	#>
	Solutions_Create_Refresh_Add_To_Path

	<#
		.获取主引擎版本
		.Get the main engine version
	#>
	Solutions_Create_Refresh_Engine_Version

	<#
		.获取目录里的已知语言，输出到：应预答首选语言
	#>
	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$SchemeVerSingle.Items.Add($itemRegion.Region) | Out-Null
		$SchemeLangSingle.Items.Add($itemRegion.Region) | Out-Null
	}

	$SchemeVerSingle.controls.Clear()
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_LanguageUnattend" -ErrorAction SilentlyContinue) {
		$SchemeVerSingle.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_LanguageUnattend" -ErrorAction SilentlyContinue
	} else {
		$SchemeVerSingle.Text = $Global:MainImageLang
	}

	<#
		.获取目录里的已知语言，输出到：添加合集
	#>
	$SchemeLangSingle.controls.Clear()
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_LanguageCollection" -ErrorAction SilentlyContinue) {
		$SchemeLangSingle.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_LanguageCollection" -ErrorAction SilentlyContinue
	} else {
		$SchemeLangSingle.Text = $Global:MainImageLang
	}

	<#
		.选择解决方案语言包
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsLanguageUnattend" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsLanguageUnattend" -ErrorAction SilentlyContinue) {
			"True" {
				$SchemeVerMulti.Checked = $True
				$SchemeVerSingle.Enabled = $False
			}
			"False" {
				$SchemeVerMulti.Checked = $False
				$SchemeVerSingle.Enabled = $True
			}
		}
	} else {
		<#
			.获取当前 ISO 是否多语言系列
		#>
		$Verify_Language_New_Path = ISO_Local_Language_Calc

		if ($Verify_Language_New_Path.Count -ge 2) {
			$SchemeVerMulti.Checked = $True
			$SchemeVerSingle.Enabled = $False
		} else {
			$SchemeVerMulti.Checked = $False
			$SchemeVerSingle.Enabled = $True
		}
	}

	if ([string]::IsNullOrEmpty($Global:UnattendSelectIndex)) {
		$SchemeDiskSpecifiedIndexShow.Text = $lang.NoChoose
	} else {
		$SchemeDiskSpecifiedIndexShow.Text = $Global:UnattendSelectIndex.Name
	}

	if ([string]::IsNullOrEmpty($Global:ProductKey)) {
		$SchemeDiskSpecifiedKEYShow.Text = $lang.NoChoose
	} else {
		$SchemeDiskSpecifiedKEYShow.Text = $Global:ProductKey
	}

	<#
		.选择解决方案语言包
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsLanguageCollection" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsLanguageCollection" -ErrorAction SilentlyContinue) {
			"True" {
				$SchemeLangMulti.Checked = $True
				$SchemeLangSingle.Enabled = $False
				$SolutionsCollectionKeep.Enabled = $True
				$SolutionsCollectionKeepChange.Enabled = $True
				$SolutionsCollectionKeepShow.Enabled = $True
			}
			"False" {
				$SchemeLangMulti.Checked = $False
				$SolutionsCollectionKeep.Enabled = $False
				$SolutionsCollectionKeepChange.Enabled = $False
				$SolutionsCollectionKeepShow.Enabled = $False
				$SchemeLangSingle.Enabled = $True
			}
		}
	} else {
		<#
			.获取当前 ISO 是否多语言系列
		#>
		$Verify_Language_New_Path = ISO_Local_Language_Calc

		if ($Verify_Language_New_Path.Count -ge 2) {
			$SchemeLangMulti.Checked = $True
			$SolutionsCollectionKeep.Enabled = $True
			$SolutionsCollectionKeepChange.Enabled = $True
			$SolutionsCollectionKeepShow.Enabled = $True
			$SchemeLangSingle.Enabled = $False
		} else {
			$SchemeLangMulti.Checked = $False
			$SolutionsCollectionKeep.Enabled = $False
			$SolutionsCollectionKeepChange.Enabled = $False
			$SolutionsCollectionKeepShow.Enabled = $False
			$SchemeLangSingle.Enabled = $True
		}
	}
	
	<#
		.添加合集，更改语言，语言选择
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Collection_Reserved_Language" -ErrorAction SilentlyContinue) {
		$GetCollectionLanguageOnlyArray = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Collection" -Name "$($Script:init_To_GPS)_Collection_Reserved_Language" -ErrorAction SilentlyContinue
	} else {
		$Verify_Language_New_Path = ISO_Local_Language_Calc

		$GetCollectionLanguageOnlyArray = $Verify_Language_New_Path.Lang

		if ([string]::IsNullOrEmpty($GetCollectionLanguageOnlyArray)) {
			$GetCollectionLanguageOnlyArray = $Global:MainImageLang
		}
	}

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 55
			Width     = 310
			Text      = "$($itemRegion.Name)`n$($itemRegion.Region)"
			Tag       = "$($itemRegion.Region)"
			add_Click = { Solutions_Create_Refresh_Collection_Language }
		}

		if ($GetCollectionLanguageOnlyArray -contains $itemRegion.Region) {
			$CheckBox.Checked = $True
		}

		$GUISolutionsCollectionChangeShowLanguage.controls.AddRange($CheckBox)
	}
	
	<#
		.Add select all and clear buttons: font
		.添加全选、清除按钮：软件
	#>
	$GUISolutionsCollectionMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUISolutionsCollectionMenu.Items.Add($lang.AllSel).add_Click({
		$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}

		Solutions_Create_Refresh_Collection_Language
	})
	$GUISolutionsCollectionMenu.Items.Add($lang.AllClear).add_Click({
		$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		Solutions_Create_Refresh_Collection_Language
	})
	$GUISolutionsCollectionChangeShowLanguage.ContextMenuStrip = $GUISolutionsCollectionMenu

	Solutions_Create_Refresh_Collection_Language

	<#
		.复选框：Office 同步配置
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowDeploy" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_AllowDeploy" -ErrorAction SilentlyContinue) {
			"True" {
				$SolutionsOffice.Checked = $True
				$SolutionsOfficeShow.Enabled = $True
			}
			"False" {
				$SolutionsOffice.Checked = $False
				$SolutionsOfficeShow.Enabled = $False
			}
		}
	} else {
		$SolutionsOffice.Checked = $False
		$SolutionsOfficeShow.Enabled = $False
	}

	<#
		.选择框：选择部署到（1，公共桌面；2，主目录）
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_CopyTo" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_CopyTo" -ErrorAction SilentlyContinue) {
			"1" {
				$GUISolutionsOfficeToPublic.Checked = $True
				$SolutionsOfficeToShow.Text = $lang.SolutionsDeployOfficeToPublic
			}
			"2" {
				$GUISolutionsOfficeToMain.Checked = $True
				$SolutionsOfficeToShow.Text = $lang.MainImageFolder
			}
		}
	} else {
		$GUISolutionsOfficeToPublic.Checked = $True
		$SolutionsOfficeToShow.Text = $lang.SolutionsDeployOfficeToPublic
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_CopyTo" -value 1 -String
	}

	<#
		.Microsoft Office
	#>
	$Region = Language_Region

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_Reserved_Language" -ErrorAction SilentlyContinue) {
		$GetTempSelectPacker = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -Name "$($Script:init_To_GPS)_Reserved_Language" -ErrorAction SilentlyContinue
		$GetOfficeLanguageOnlyArray = $GetTempSelectPacker
	} else {
		$GetOfficeLanguageOnlyArray = ""
	}

	ForEach ($itemRegion in $Region) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 55
			Width     = 310
			Text      = "$($itemRegion.Name)`n$($itemRegion.Region)"
			Tag       = "$($itemRegion.Region)"
			add_Click = { Solutions_Create_Refresh_Office_Language }
		}

		if ($GetOfficeLanguageOnlyArray -contains $itemRegion.Region) {
			$CheckBox.Checked = $True
		}

		$GUISolutionsOfficeChangeShowLanguage.controls.AddRange($CheckBox)
	}

	<#
		.Add select all and clear buttons: font
		.添加全选、清除按钮：软件
	#>
	$GUISolutionsOfficeMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUISolutionsOfficeMenu.Items.Add($lang.AllSel).add_Click({
		$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}

		Solutions_Create_Refresh_Office_Language
	})
	$GUISolutionsOfficeMenu.Items.Add($lang.AllClear).add_Click({
		$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}

		Solutions_Create_Refresh_Office_Language
	})
	$GUISolutionsOfficeChangeShowLanguage.ContextMenuStrip = $GUISolutionsOfficeMenu

	# Office End

	<#
		.软件包合集
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_SolutionsPacker" -ErrorAction SilentlyContinue) {
		$GetTempSelectPacker = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_SolutionsPacker" -ErrorAction SilentlyContinue
		$TempSelectPacker = $GetTempSelectPacker
	} else {
		$TempSelectPacker = ""
	}

	$OptionalPacker = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Collection" -ErrorAction SilentlyContinue
	Get-ChildItem $OptionalPacker -directory -ErrorAction SilentlyContinue | ForEach-Object {
		if (Test-Path -Path "$($_.FullName)\Deploy.ps1" -PathType Leaf) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 40
				Width     = 385
				Text      = $_.BaseName
				Tag       = $_.FullName
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null
					
					$SolutionsPackageSelList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.RadioButton]) {
							if ($_.Enabled) {
								if ($_.Checked) {
									Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_SolutionsPacker" -value $_.Text -String
								}
							}
						}
					}
				}
			}

			if ($TempSelectPacker -eq $_.BaseName) {
				$CheckBox.Checked = $True
			}

			$SolutionsPackageSelList.controls.AddRange($CheckBox)
		}
	}

	<#
		.复选框：部署软件包合集
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_AllowDeployCollection" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_AllowDeployCollection" -ErrorAction SilentlyContinue) {
			"True" {
				$SolutionsPackage.Checked = $True
				$SolutionsPackageShow.Enabled = $True
			}
			"False" {
				$SolutionsPackage.Checked = $False
				$SolutionsPackageShow.Enabled = $False
			}
		}
	} else {
		$SolutionsPackage.Checked = $False
		$SolutionsPackageShow.Enabled = $False
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_DeployCollectionSelect" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -Name "$($Script:init_To_GPS)_DeployCollectionSelect" -ErrorAction SilentlyContinue) {
			"1" { $SolutionsPackageToRoot.Checked = $True }
			"2" { $SolutionsPackageToSolutions.Checked = $True }
			"3" { $SolutionsPackageToPublish.Checked = $True }
		}
	} else {
		$SolutionsPackageToRoot.Checked = $True
	}

	<#
		.读取本地软件包，显示到需要加入的软件列表，实时操作
		.Read the local SoftwarePackage, display to the list of software to be added, real-time operation
	#>
	Solutions_Create_Refresh_Software_List

	<#
		.复选框：Select the software to be added
		.复选框：选择需要加入的软件
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsSoftware" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsSoftware" -ErrorAction SilentlyContinue) {
			"True" {
				$GroupSoftwareListTitle.Checked = $True
				$GroupSoftwareList.Enabled = $True
			}
			"False" {
				$GroupSoftwareListTitle.Checked = $False
				$GroupSoftwareList.Enabled = $False
			}
		}
	} else {
		$GroupSoftwareListTitle.Checked = $True
		$GroupSoftwareList.Enabled = $True
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsSoftware" -value "True" -String
	}

	<#
		.复选框：Select the fonts to be added
		.复选框：选择需要加入的字体
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsFonts" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_IsFonts" -ErrorAction SilentlyContinue) {
			"True" {
				$GroupFontsListTitle.Checked = $True
				$GroupFontsList.Enabled = $True
			}
			"False" {
				$GroupFontsListTitle.Checked = $False
				$GroupFontsList.Enabled = $False
			}
		}
	} else {
		$GroupFontsListTitle.Checked = $True
		$GroupFontsList.Enabled = $True
		Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -name "$($Script:init_To_GPS)_IsFonts" -value "True" -String
	}

	<#
		.Obtain the installation type: commercial version, consumer version
		.获取安装类型：
		 商业版, ei.cfg
		 消费者版, no ei.cfg
	#>
	$SaveFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
	if (Test-Path -Path $SaveFileTo -PathType Leaf) {
		$InstlModebusiness.Checked = $True
		$InstlModeconsumer.Checked = $False
		$InstlModeTipsErrorMsg.Text = $lang.BusinessTips
	} else {
		$InstlModebusiness.Checked = $False
		$InstlModeconsumer.Checked = $True
		$InstlModeTipsErrorMsg.Text = $lang.ConsumerTips
	}

	<#
		.Add select all and clear buttons: font
		.添加全选、清除按钮：软件
	#>
	$GUISolutionsMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUISolutionsMenu.Items.Add($lang.AllSel).add_Click({
		$GroupSoftwareList.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUISolutionsMenu.Items.Add($lang.AllClear).add_Click({
		$GroupSoftwareList.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GroupSoftwareList.ContextMenuStrip = $GUISolutionsMenu

	<#
		.Add select all and clear buttons: font
		.添加全选、清除按钮：字体
	#>
	$GUIFontsMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIFontsMenu.Items.Add($lang.AllSel).add_Click({
		$GroupFontsList.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$GUIFontsMenu.Items.Add($lang.AllClear).add_Click({
		$GroupFontsList.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$GroupFontsList.ContextMenuStrip = $GUIFontsMenu

	$Region = Language_Region
	<#
		.时间：将所有已知时间显示到列表里
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_Time_Zone" -ErrorAction SilentlyContinue) {
		$GetSaveTimezone = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_Time_Zone" -ErrorAction SilentlyContinue
		New-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -Value $GetSaveTimezone -Force
		$GUISolutionsUnattendChangeCustomizeInput.Text = $GetSaveTimezone
		$SchemeTimezoneDynamicNow.Text = $GetSaveTimezone
	} else {
		ForEach ($itemRegion in $Region) {
			if ($itemRegion.Region -eq $Global:MainImageLang) {
				New-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -Value $itemRegion.Timezone -Force
				$GUISolutionsUnattendChangeCustomizeInput.Text = $itemRegion.Timezone
				$SchemeTimezoneDynamicNow.Text = $itemRegion.Timezone
				Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_Time_Zone" -value $itemRegion.Timezone -String
				break
			}
		}
	}

	ForEach ($itemRegion in $Region) {
		$CheckBox      = New-Object System.Windows.Forms.RadioButton -Property @{
			Name       = $itemRegion.Region
			Height     = 45
			Width      = 346
			Text       = "$($itemRegion.Region)`n$($itemRegion.Timezone)"
			Tag        = $itemRegion.Timezone
			add_Click  = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				$GUISolutionsUnattendChangeShowTimeZone.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.RadioButton]) {
						if ($_.Enabled) {
							if ($_.Checked) {
								New-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -Value $_.Tag -Force

								$GUISolutionsUnattendChangeCustomizeInput.Text = $_.Tag
								$SchemeTimezoneDynamicNow.Text = $_.Tag
								Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_Time_Zone" -value $_.Tag -String
							}
						}
					}
				}
			}
		}

		$GUISolutionsUnattendChangeShowTimeZone.controls.AddRange($CheckBox)
	}

	<#
		.复选框：时间区域
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsTimeZone" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_IsTimeZone" -ErrorAction SilentlyContinue) {
			"True" {
				$SchemeTimeZoneSelect.Checked = $True
				$SchemeTimezoneDynamicButton.Enabled = $True
			}
			"False" {
				$SchemeTimeZoneSelect.Checked = $False
				$SchemeTimezoneDynamicButton.Enabled = $False
			}
		}
	} else {
		$SchemeTimeZoneSelect.Checked = $False
		$SchemeTimezoneDynamicButton.Enabled = $False
	}

	<#
		判断是否需要删除整个解决方案
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_ClearFull" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_ClearFull" -ErrorAction SilentlyContinue) {
			"True" {
				$EngineDoneClearFull.Enabled = $True
				$EngineDoneClearFull.Checked = $True
				$EngineDoneClear.Enabled = $False
				$EngineDeskMenu.Enabled = $False
				$EngineDeskMenuShift.Enabled = $False
				$EnginePopsupEngine.Enabled = $False
				$EngineDefender.Enabled = $False
			}
			"False" {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Clear" -ErrorAction SilentlyContinue) {
					switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Clear" -ErrorAction SilentlyContinue) {
						"True" {
							$EngineDoneClearFull.Enabled = $True
							$EngineDoneClear.Checked = $True
							$EngineDeskMenu.Enabled = $False
							$EngineDeskMenuShift.Enabled = $False
							$EnginePopsupEngine.Enabled = $False
							$EngineDefender.Enabled = $False
						}
						"False" {
							$EngineDoneClearFull.Checked = $False
							$EngineDoneClear.Enabled = $True
							$EngineDeskMenu.Enabled = $True
							$EngineDeskMenuShift.Enabled = $True
							$EnginePopsupEngine.Enabled = $True
							$EngineDefender.Enabled = $True
						}
					}
				}
			}
		}
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Clear" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Clear" -ErrorAction SilentlyContinue) {
				"True" {
					$EngineDoneClearFull.Enabled = $True
					$EngineDoneClear.Checked = $True
					$EngineDeskMenu.Enabled = $False
					$EngineDeskMenuShift.Enabled = $False
					$EnginePopsupEngine.Enabled = $False
					$EngineDefender.Enabled = $False
				}
				"False" {
					$EngineDoneClearFull.Checked = $False
					$EngineDoneClear.Enabled = $True
					$EngineDeskMenu.Enabled = $True
					$EngineDeskMenuShift.Enabled = $True
					$EngineDefender.Enabled = $True
				}
			}
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Region_UTF8" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create" -Name "$($Script:init_To_GPS)_Region_UTF8" -ErrorAction SilentlyContinue) {
			"True" {
				$GUISolutionsShowLanguageUTF8.Checked = $True
			}
			"False" {
				$GUISolutionsShowLanguageUTF8.Checked = $False
			}
		}
	}

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		$CheckBox      = New-Object System.Windows.Forms.RadioButton -Property @{
			Height     = 55
			Width      = 310
			Text       = "$($itemRegion.Name)`n$($itemRegion.Region)"
			Tag        = $itemRegion.Region
			add_Click  = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null

				$GUISolutionsShowLanguage.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.RadioButton]) {
						if ($_.Checked) {
							$GUISolutionsShowNewLanguage.Text = $_.Tag
							$EngineRegionalShow.Text = $($lang.SolutionsEngineRegionalTips -f $Global:MainImageLang, $_.Tag)
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -name "$($Script:init_To_GPS)_Region_Preferred" -value $_.Tag -String
						}
					}
				}
			}
		}

		if ($itemRegion.Region -eq $Global:MainImageLang) {
			$CheckBox.Checked = $True
		}

		$GUISolutionsShowLanguage.controls.AddRange($CheckBox)
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Region" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Region" -ErrorAction SilentlyContinue) {
			"True" {
				$EngineRegional.Checked = $True
				$EngineRegionalShow.Enabled = $True
			}
			"False" {
				$EngineRegional.Checked = $False
				$EngineRegionalShow.Enabled = $False
			}
		}
	} else {
		$EngineRegionalShow.Enabled = $False
	}

	<#
		.刷新
	#>
	Solutions_Create_Refresh_Regional

	<#
		.刷新 Autounattend.xml 按钮状态：半自动、UEFI、Legacy
	#>
	switch ($Global:Architecture) {
		"arm64" {
			$SchemeDiskUefi.Enabled = $True
			$SchemeDiskLegacy.Enabled = $False
		}
		"AMD64" {
			$SchemeDiskUefi.Enabled = $True
			$SchemeDiskLegacy.Enabled = $False
		}
		"x86" {
			$SchemeDiskUefi.Enabled = $False
			$SchemeDiskLegacy.Enabled = $True
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_UnattendMode" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -Name "$($Script:init_To_GPS)_UnattendMode" -ErrorAction SilentlyContinue) {
			"1" { $SchemeDiskHalf.Checked = $True }
			"2" { $SchemeDiskUefi.Checked = $True }
			"3" { $SchemeDiskLegacy.Checked = $True }
		}
	} else {
		$SchemeDiskHalf.Checked = $True
	}

	<#
		.刷新应预答状态
	#>
	Solutions_Unattend_Refresh_Status

	<#
		.初始化复选框：自定义创建用户名、指定用户名
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_OOBE_Select_Init_User" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\OOBE" -Name "$($Script:init_To_GPS)_OOBE_Select_Init_User" -ErrorAction SilentlyContinue) {
			"Custom" {
				$SolutionsOther_Custom.Checked = $True
				$SolutionsOther_Specified.Checked = $False
			}
			"Specified" {
				$SolutionsOther_Custom.Checked = $False
				$SolutionsOther_Specified.Checked = $True
			}
			default {
				$SolutionsOther_Custom.Checked = $False
				$SolutionsOther_Specified.Checked = $True
			}
		}
	} else {
		$SolutionsOther_Custom.Checked = $False
		$SolutionsOther_Specified.Checked = $True
	}

	Refresh_Select_OOBE_Init_User

	<#
		.刷新：命令行已选择项
	#>
	Refresh_Command_Rule_Select_Group

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	switch ($Global:IsLang) {
		"de-DE" {
			$EngineChkSyncMark.Height = "35"
			$EngineDefender.Height = "35"
			$GUISolutionsVolume.Height = "35"
			$EngineDeskMenuShift.Height = "35"
			$SolutionsUnattendSetupOSUI.Height = "35"
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green
		Write-Host "  $('-' * 80)"
		Write-Host "  " -NoNewline
		Write-Host " $($lang.Save) " -NoNewline -BackgroundColor White -ForegroundColor Black

		<#
			.部署到
		#>
		Switch ($Autopilot.SaveTo.Path) {
			"ISO" {
				$SolutionsToMount.Enabled = $False
				$SolutionsToMount.Checked = $False
				$SolutionsToSources.Enabled = $True
				$SolutionsToSources.Checked = $True
			}
			"Mounted" {
				$SolutionsToMount.Enabled = $True
				$SolutionsToMount.Checked = $True
				$SolutionsToSources.Enabled = $False
				$SolutionsToSources.Checked = $false
			}
		}

		<#
			.自定义主目录名称
		#>
		if ([string]::IsNullOrEmpty($Autopilot.SaveTo.FolderName)) {

		} else {
			$GUISolutionsCustomizeName.Text = $Autopilot.SaveTo.FolderName
		}

		<#
			.用户首次体验
		#>
		Switch ($Autopilot.Account.Schome) {
			"Custom" {
				$SolutionsOther_Custom.Checked = $True
			}
			"Designated" {
				$SolutionsOther_Specified.Checked = $True
				
				<#
					.用户名
				#>
				$SolutionsOther_Specified_Expand_UserName_Custom.Text = $Autopilot.Account.Designated.UserName

				<#
					.将目录名设置为主用户名
				#>
				if ($Autopilot.Account.Designated.SyncMainFolder) {
					$GUISolutionsVerifySync.Checked = $True
				} else {
					$GUISolutionsVerifySync.Checked = $False
				}

				<#
					.自动登录
				#>
				if ($Autopilot.Account.Designated.AutoLogin) {
					$SolutionsOther_Specified_Expand_UserName_Autorun.Checked = $True
				} else {
					$SolutionsOther_Specified_Expand_UserName_Autorun.Checked = $False
				}
			}
		}

		<#
			.自动驾驶：部署引擎
		#>
		#region 自动驾驶：部署引擎
			<#
				.允许添加
			#>
			if ($Autopilot.Schome.Engine.Enable) {
				$SolutionsEngine.Checked = $True
				$GroupSolutionsEngine.Enabled = $True
			} else {
				$SolutionsEngine.Checked = $False
				$GroupSolutionsEngine.Enabled = $False
			}

			<#
				.部署引擎：选择版本
			#>
			if ([string]::IsNullOrEmpty($Autopilot.Schome.Engine.Version)) {
			} else {
				$GroupMainVerList.Text = $Autopilot.Schome.Engine.Version
			}

			<#
				.未选择必备项时自动修复
			#>
			if ($Autopilot.Schome.Engine.OptAdv.AutoFix) {
				$Engine_Unattend_Auto_Fix.Checked = $True
			} else {
				$Engine_Unattend_Auto_Fix.Checked = $False
			}

			<#
				.首次体验
			#>
				<#
					.首次体验，部署先决条件过程中
				#>
					<#
						.允许全盘搜索并同步部署标记
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.FirstExpSyncMark) {
						$EngineChkSyncMark.Checked = $True
					} else {
						$EngineChkSyncMark.Checked = $False
					}

					<#
						.允许自动更新
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.FirstExpUpdate) {
						$EngineChkUpdate.Checked = $True
					} else {
						$EngineChkUpdate.Checked = $False
					}

					<#
						.添加主目录到 Defend 排除目录
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.FirstExpDefender) {
						$EngineDefender.Checked = $True
					} else {
						$EngineDefender.Checked = $False
					}

					<#
						.网络位置向导
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.NetworkLocationWizard) {
						$EngineNetworkLocationWizard.Checked = $True
					} else {
						$EngineNetworkLocationWizard.Checked = $False
					}

					<#
						.系统盘卷标：主目录名相同
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.FirstExpSyncLabel) {
						$GUISolutionsVolume.Checked = $True
					} else {
						$GUISolutionsVolume.Checked = $False
					}

					<#
						.遇到多语言时：
					#>
						<#
							.阻止 Appx 清理维护任务
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.IsMulti.PreAppxCleanup) {
							$GUIPreAppxCleanup.Checked = $True
						} else {
							$GUIPreAppxCleanup.Checked = $False
						}

						<#
							.阻止清理未使用的按需功能语言包
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.IsMulti.LanguageComponents) {
							$GUILanguageComponents.Checked = $True
						} else {
							$GUILanguageComponents.Checked = $False
						}

						<#
							.阻止清理未使用的语言包
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.IsMulti.PreventCleaningUnusedLP) {
							$GUIPreventCleaningUnusedLP.Checked = $True
						} else {
							$GUIPreventCleaningUnusedLP.Checked = $False
						}

					<#
						.个性化“上下文菜单”
					#>
						<#
							.个性化“上下文菜单”：添加
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.DesktopMenu.Enable) {
							$EngineDeskMenu.Checked = $True
						} else {
							$EngineDeskMenu.Checked = $False
						}

						<#
							.个性化“上下文菜单”：按住 Shift 键后点击右键
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.DesktopMenu.Right) {
							$EngineDeskMenuShift.Checked = $True
						} else {
							$EngineDeskMenuShift.Checked = $False
						}

					<#
						.时间区域
					#>
						<#
							.更改时间
						#>
						if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.Time.Enable) {
							$EngineRegional.Checked = $True
							$EngineRegionalShow.Enabled = $True

							if ([string]::IsNullOrEmpty($Autopilot.Schome.Engine.FirstExperience.Prerequisite.Time.Region)) {
							} else {
								$GUISolutionsShowLanguage.Controls | ForEach-Object {
									if ($_ -is [System.Windows.Forms.RadioButton]) {
										if ($_.Tag -eq $Autopilot.Schome.Engine.FirstExperience.Prerequisite.Time.Region) {
											$_.Checked = $True
											$GUISolutionsShowNewLanguage.Text = $_.Tag
											$EngineRegionalShow.Text = $($lang.SolutionsEngineRegionalTips -f $Global:MainImageLang, $_.Tag)
										}
									}
								}
							}

							
							<#
								.Beta 版：使用 Unicode UTF-8 提供全球语言支持
							#>
							if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.Time.UTF8) {
								$GUISolutionsShowLanguageUTF8.Checked = $True
							} else {
								$GUISolutionsShowLanguageUTF8.Checked = $False
							}
						} else {
							$EngineRegional.Checked = $False
							$EngineRegionalShow.Enabled = $False
						}

					<#
						.重新启动计算机
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Prerequisite.Restart) {
						$EnginePrerequisitesReboot.Checked = $True
					} else {
						$EnginePrerequisitesReboot.Checked = $False
					}

				<#
					.首次体验，完成先决条件后
				#>
					<#
						.弹出部署引擎主界面
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.FirstExpFinishPopup) {
						$EnginePopsupEngine.Checked = $True
					} else {
						$EnginePopsupEngine.Checked = $False
					}

					<#
						.允许首次预体验，按计划
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.FirstExpFinishOnDemand) {
						$EngineFirstExp.Checked = $True
					} else {
						$EngineFirstExp.Checked = $False
					}

					<#
						.恢复 Powershell 执行策略：受限
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.ResetExecutionPolicy) {
						$EngineRestricted.Checked = $True
					} else {
						$EngineRestricted.Checked = $False
					}

					<#
						.删除整个解决方案
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.ClearFull) {
						$EngineDoneClearFull.Checked = $True
					} else {
						$EngineDoneClearFull.Checked = $False
					}

					<#
						.删除部署引擎，保留其它
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.OnlyClearEngine) {
						$EngineDoneClear.Checked = $True
					} else {
						$EngineDoneClear.Checked = $False
					}

					<#
						.重新启动计算机
					#>
					if ($Autopilot.Schome.Engine.FirstExperience.Finish.Restart) {
						$FirstExpFinishReboot.Checked = $True
					} else {
						$FirstExpFinishReboot.Checked = $False
					}
		#endregion

		<#
			.自动驾驶：应预答
		#>
		#region 自动驾驶：应预答
			<#
				.允许添加
			#>
			if ($Autopilot.Schome.Unattend.Enable) {
				$SolutionsUnattend.Checked = $True
				$GroupSolutionsUnattend.Enabled = $True
				$GUISolutionsVerifySync.Enabled = $True
				$GUISolutionsVerifySyncTips.Enabled = $True

				<#
					.应预答：选择版本
				#>
				if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Version)) {
				} else {
					$Unattend_Version_Select.Text = $Autopilot.Schome.Unattend.Version
				}

				<#
					.应预答：命令行
				#>
				#region 应预答：命令行
					<#
						.Windows 安装
					#>
					if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Command.WindowsSetup)) {
					} else {
						$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ("WinSetup" -eq $_.Name) {
									$_.Controls | ForEach-Object {
										if ($_ -is [System.Windows.Forms.CheckBox]) {
											if ($Autopilot.Schome.Unattend.Command.WindowsSetup -contains $_.Tag) {
												$_.Checked = $True
											} else {
												$_.Checked = $False
											}
										}
									}
								}
							}
						}
					}

					<#
						.Windows 安装
					#>
					if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Command.WindowsPE)) {
					} else {
						$UIUnzipPanel_Select_Rule_Menu.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.FlowLayoutPanel]) {
								if ("WinPE" -eq $_.Name) {
									$_.Controls | ForEach-Object {
										if ($_ -is [System.Windows.Forms.CheckBox]) {
											if ($Autopilot.Schome.Unattend.Command.WindowsPE -contains $_.Tag) {
												$_.Checked = $True
											} else {
												$_.Checked = $False
											}
										}
									}
								}
							}
						}
					}
				#endregion

				<#
					.应预答：单语、多语
				#>
				Switch ($Autopilot.Schome.Unattend.IsMulti) {
					"Auto" {
					}
					default {
						$SchemeVerMulti.Checked = $False
						$SchemeVerSingle.Enabled = $True

						$SchemeVerSingle.Text = $Autopilot.Schome.Unattend.IsMulti
					}
				}

				<#
					.应预答：安装方式
				#>
				$SaveFileTo = Join-Path -Path $Global:Image_source -ChildPath "Sources\EI.CFG"
				Switch ($Autopilot.Schome.Unattend.InstallMethod) {
					"Auto" {
					}
					"Business" {
						$InstlModebusiness.Checked = $True

@"
[Channel]
volume

[VL]
1
"@ | Out-File -FilePath $SaveFileTo -Encoding Ascii -ErrorAction SilentlyContinue
					}
					"Consumer" {
						$InstlModeconsumer.Checked = $True
						Remove_Tree $SaveFileTo
					}
				}

				<#
					.应预答：选择 Autounattend.xml 解决方案
				#>
				Switch ($Autopilot.Schome.Unattend.Schome.Version) {
					"Semi" {
						$SchemeDiskHalf.Checked = $True
					}
					"UEFI" {
						if ($SchemeDiskUefi.Enabled) {
							if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Schome.UEFI.ImageIndex)) {
							} else {
								$SchemeDiskUefi.Checked = $True
								$SchemeDiskSpecifiedPanel.Enabled = $True
								$SchemeVerMulti.Enabled = $True
								$SchemeVerSingle.Enabled = $True

								$NewAutopilot = @{
									Index = $Autopilot.Schome.Unattend.Schome.UEFI.ImageIndex
								}
								Solutions_Index_UI -Autopilot $NewAutopilot
								$SchemeDiskSpecifiedIndexShow.Text = $Global:UnattendSelectIndex.Name
							}
						}
					}
					"Legacy" {
						if ($SchemeDiskLegacy.Enabled) {
							if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Schome.Legacy.ProductKey)) {
							} else {
								$SchemeDiskLegacy.Checked = $True
								$SchemeDiskSpecifiedPanel.Enabled = $True
								$SchemeVerMulti.Enabled = $True
								$SchemeVerSingle.Enabled = $True

								$Global:ProductKey = $Autopilot.Schome.Unattend.Schome.Legacy.ProductKey
								$SchemeDiskSpecifiedKEYShow.Text = $Autopilot.Schome.Unattend.Schome.Legacy.ProductKey
							}
						}
					}
				}

				<#
					.应预答：添加到
				#>
					<#
						.[ISO]:\\Autounattend.xml
					#>
					if ($Autopilot.Schome.Unattend.AddTo.ISOAutounattend) {
						$CreateUnattendISO.Checked = $True
					} else {
						$CreateUnattendISO.Checked = $False
					}

					<#
						.[ISO]:\\sources\\Unattend.xml
					#>
					if ($Autopilot.Schome.Unattend.AddTo.ISOSourcesUnattend) {
						$CreateUnattendISOSources.Checked = $True
					} else {
						$CreateUnattendISOSources.Checked = $False
					}

					<#
						.[ISO]:\\sources\\$OEM$\\$$\\Panther\\unattend.xml
					#>
					if ($Autopilot.Schome.Unattend.AddTo.ISOPantherUnattendOEM) {
						$CreateUnattendISOSourcesOEM.Checked = $True
					} else {
						$CreateUnattendISOSourcesOEM.Checked = $False
					}

					<#
						.[挂载到]:\\Windows\\Panther\\unattend.xml
					#>
					if ($Autopilot.Schome.Unattend.AddTo.ISOPantherUnattendOS) {
						$CreateUnattendPanther.Checked = $True
					} else {
						$CreateUnattendPanther.Checked = $False
					}

				<#
					.安装界面
				#>
					<#
						.隐藏 产品密钥
					#>
					if ($Autopilot.Schome.Unattend.InstallInterface.OOBEProductKey) {
						$SolutionsUnattendOOBEActivate.Checked = $True
					} else {
						$SolutionsUnattendOOBEActivate.Checked = $False
					}

					<#
						.隐藏 选择要安装的操作系统
					#>
					if ($Autopilot.Schome.Unattend.InstallInterface.OOBEOSImage) {
						$SolutionsUnattendSetupOSUI.Checked = $True
					} else {
						$SolutionsUnattendSetupOSUI.Checked = $False
					}

					<#
						.隐藏 接受许可条款
					#>
					if ($Autopilot.Schome.Unattend.InstallInterface.OOBEEula) {
						$SolutionsUnattendAccectEula.Checked = $True
					} else {
						$SolutionsUnattendAccectEula.Checked = $False
					}

				<#
					.服务器选项
				#>
					<#
						.登录时不自动启动服务器管理器
					#>
					if ($Autopilot.Schome.Unattend.Server.ServerManager) {
						$SolutionsUnattendDoNotServerManager.Checked = $True
					} else {
						$SolutionsUnattendDoNotServerManager.Checked = $False
					}

					<#
						.Internet Explorer 增强的安全配置
					#>
						<#
							.关闭“管理员”
						#>
						if ($Autopilot.Schome.Unattend.Server.InternetExplorer.Administrator) {
							$SolutionsUnattendIEAdmin.Checked = $True
						} else {
							$SolutionsUnattendIEAdmin.Checked = $False
						}

						<#
							.关闭“用户”
						#>
						if ($Autopilot.Schome.Unattend.Server.InternetExplorer.User) {
							$SolutionsUnattendIEUser.Checked = $True
						} else {
							$SolutionsUnattendIEUser.Checked = $False
						}

				<#
					.时间区域
				#>
					<#
						.更改时间
					#>
					if ($Autopilot.Schome.Unattend.Time.Enable) {
						$SchemeTimeZoneSelect.Checked = $True
						$SchemeTimezoneDynamicButton.Enabled = $True

						if ([string]::IsNullOrEmpty($Autopilot.Schome.Unattend.Time.Region)) {
						} else {
							$GUISolutionsUnattendChangeShowTimeZone.Controls | ForEach-Object {
								if ($_ -is [System.Windows.Forms.RadioButton]) {
									if ($_.Name -eq $Autopilot.Schome.Unattend.Time.Region) {
										$_.Checked = $True
										New-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -Value $_.Tag -Force

										$GUISolutionsUnattendChangeCustomizeInput.Text = $_.Tag
										$SchemeTimezoneDynamicNow.Text = $_.Tag
										Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Unattend" -name "$($Script:init_To_GPS)_Time_Zone" -value $_.Tag -String
									}
								}
							}
						}
					} else {
						$SchemeTimeZoneSelect.Checked = $False
						$SchemeTimezoneDynamicButton.Enabled = $False
					}
			} else {
				$SolutionsUnattend.Checked = $False
				$GroupSolutionsUnattend.Enabled = $False
				$GUISolutionsVerifySync.Enabled = $False
				$GUISolutionsVerifySyncTips.Enabled = $False
			}
		#endregion

		<#
			.自动驾驶：合集
		#>
		#region 自动驾驶：合集
			<#
				.允许添加
			#>
			if ($Autopilot.Schome.Collection.Enable) {
				$SolutionsSoftwarePacker.Checked = $True
				$GroupSolutionsSoftwarePacker.Enabled = $True

				<#
					.生成预部署报告
				#>
				if ($Autopilot.Schome.Collection.OptAdv.GenerateReport) {
					$CreateReport.Checked = $True
				} else {
					$CreateReport.Checked = $False
				}

				<#
					.初始化：语言包
				#>
				switch ($Autopilot.Schome.Collection.Language.IsMulti) {
					"auto" {}
					"Multi" {
						$SchemeLangMulti.Checked = $True
						$SchemeLangSingle.Enabled = $False
						$SolutionsCollectionKeep.Enabled = $True
						$SolutionsCollectionKeepChange.Enabled = $True
						$SolutionsCollectionKeepShow.Enabled = $True

						$GUISolutionsCollectionChangeShowLanguage.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.CheckBox]) {
								if ($Autopilot.Schome.Collection.Language.Multi -contains $_.Tag) {
									$_.Checked = $True
								} else {
									$_.Checked = $False
								}
							}
						}

						$SolutionsCollectionKeepShow.Text = $Autopilot.Schome.Collection.Language.Multi
					}
					"Single" {
						$SchemeLangMulti.Checked = $False
						$SchemeLangSingle.Enabled = $True
						$SolutionsCollectionKeep.Enabled = $False
						$SolutionsCollectionKeepChange.Enabled = $False
						$SolutionsCollectionKeepShow.Enabled = $False

						$SchemeLangSingle.Text = $Autopilot.Schome.Collection.Language.Single
					}
				}

				<#
					.初始化：语言包
				#>
				switch ($Autopilot.Schome.Collection.Architecture) {
					"auto" {
						switch ($Global:ArchitecturePack) {
							"arm64" {
								if ($ArchitectureARM64.Enabled) {
									$ArchitectureARM64.Checked = $True
									Solutions_Create_Refresh_Office_Status
								}
							}
							"AMD64" {
								if ($ArchitectureAMD64.Enabled) {
									$ArchitectureAMD64.Checked = $True
									Solutions_Create_Refresh_Office_Status
								}
							}
							"x86" {
								if ($ArchitectureX86.Enabled) {
									$ArchitectureX86.Checked = $True
									Solutions_Create_Refresh_Office_Status
								}
							}
						}
					}
					"arm64" {
						if ($ArchitectureARM64.Enabled) {
							$ArchitectureARM64.Checked = $True
							Solutions_Create_Refresh_Office_Status
						}
					}
					"x64" {
						if ($ArchitectureAMD64.Enabled) {
							$ArchitectureAMD64.Checked = $True
							Solutions_Create_Refresh_Office_Status
						}
					}
					"x86" {
						if ($ArchitectureX86.Enabled) {
							$ArchitectureX86.Checked = $True
							Solutions_Create_Refresh_Office_Status
						}
					}
				}

				<#
					.部署 Office
				#>
				if ($Autopilot.Schome.Collection.Office.IsDeploy) {
					if ([string]::IsNullOrEmpty($Autopilot.Schome.Collection.Office.Version)) {
						$SolutionsOffice.Checked = $False
						$SolutionsOfficeShow.Enabled = $False
						Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String
					} else {
						$Solutions_Office_Select.Text = $Autopilot.Schome.Collection.Office.Version

						if ([string]::IsNullOrEmpty($Solutions_Office_Select.Text)) {
							$SolutionsOffice.Checked = $True
							$SolutionsOfficeShow.Enabled = $True
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String

							$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
							$UI_Main_Error.Text = "$($lang.SolutionsDeployOfficeNoSelect): $($Autopilot.Schome.Collection.Office.Version)"
						} else {
							$SolutionsOffice.Checked = $True
							$SolutionsOfficeShow.Enabled = $True
							Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "True" -String
						}

						switch ($Autopilot.Schome.Collection.Office.Language) {
							"Auto" {}
							Default {
								$GUISolutionsOfficeChangeShowLanguage.Controls | ForEach-Object {
									if ($Autopilot.Schome.Collection.Office.Language -contains $_.Tag) {
										$_.Checked = $True
									} else {
										$_.Checked = $False
									}
								}

								Solutions_Create_Refresh_Office_Language
							}
						}

						switch ($Autopilot.Schome.Collection.Office.DeployTo) {
							"PublicDektop" {
								$GUISolutionsOfficeToPublic.Checked = $True
								$SolutionsOfficeToShow.Text = $lang.SolutionsDeployOfficeToPublic
							}
							"MainDirectory" {
								$GUISolutionsOfficeToMain.Checked = $True
								$SolutionsOfficeToShow.Text = $lang.MainImageFolder
							}
						}
					}
				} else {
					$SolutionsOffice.Checked = $False
					$SolutionsOfficeShow.Enabled = $False
					Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Office" -name "$($Script:init_To_GPS)_AllowDeploy" -value "False" -String
				}

				<#
					.自定义合集
				#>
				if ($Autopilot.Schome.Collection.Custom.IsDeploy) {
					switch ($Autopilot.Schome.Collection.Custom.DeployTo) {
						"SystemDisk" {
							$SolutionsPackageToRoot.Checked = $True
						}
						"Solution" {
							$SolutionsPackageToSolutions.Checked = $True
						}
						"PublicDesktop" {
							$SolutionsPackageToPublish.Checked = $True
						}
					}

					if ([string]::IsNullOrEmpty($Autopilot.Schome.Collection.Custom.Version)) {
						$SolutionsPackage.Checked = $False
						$SolutionsPackageShow.Enabled = $False
					} else {
						$MarkCheckPackageSel = @()
						$SolutionsPackageSelList.Controls | ForEach-Object {
							if ($_ -is [System.Windows.Forms.RadioButton]) {
								if ($Autopilot.Schome.Collection.Custom.Version -eq $_.Text) {
									$_.Checked = $True
									$MarkCheckPackageSel += $_.Text
									New-Variable -Scope global -Name "DeployPackerVersion_$($Script:init_To_GPS)" -Value $_.Tag -Force
									Save_Dynamic -regkey "Solutions\ImageSources\$($Global:MainImage)\Deploy\Package" -name "$($Script:init_To_GPS)_SolutionsPacker" -value $_.Text -String
								} else {
									$_.Checked = $False
								}
							}
						}

						if ($MarkCheckPackageSel.Count -gt 0) {
							$SolutionsPackage.Checked = $True
							$SolutionsPackageShow.Enabled = $True
						} else {
							$SolutionsPackage.Checked = $False
							$SolutionsPackageShow.Enabled = $False
						}
					}
				} else {
					$SolutionsPackage.Checked = $False
					$SolutionsPackageShow.Enabled = $False
				}

				<#
					.软件包
				#>
				if ($Autopilot.Schome.Collection.Software.IsDeploy) {
					$GroupSoftwareListTitle.Checked = $True
					$GroupSoftwareList.Enabled = $True

					$MarkCheckPackageSel = @()
					$GroupSoftwareList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.Checkbox]) {
							if ($Autopilot.Schome.Collection.Software.App -contains $_.Text) {
								$_.Checked = $True
								$MarkCheckPackageSel += $_.Text
							} else {
								$_.Checked = $False
							}
						}
					}

					if ($MarkCheckPackageSel.Count -gt 0) {
						$GroupFontsListTitle.Checked = $True
						$GroupFontsList.Enabled = $True
					} else {
						$GroupFontsListTitle.Checked = $False
						$GroupFontsList.Enabled = $False
					}
				} else {
					$GroupSoftwareListTitle.Checked = $False
					$GroupSoftwareList.Enabled = $False
				}


				<#
					.字体
				#>
				if ($Autopilot.Schome.Collection.Fonts.IsDeploy) {
					$MarkCheckPackageSel = @()
					$GroupFontsList.Controls | ForEach-Object {
						if ($_ -is [System.Windows.Forms.Checkbox]) {
							if ($Autopilot.Schome.Collection.Fonts.Package -contains $_.Text) {
								$_.Checked = $True
								$MarkCheckPackageSel += $_.Text
							} else {
								$_.Checked = $False
							}
						}
					}

					if ($MarkCheckPackageSel.Count -gt 0) {
						$GroupFontsListTitle.Checked = $True
						$GroupFontsList.Enabled = $True
					} else {
						$GroupFontsListTitle.Checked = $False
						$GroupFontsList.Enabled = $False
					}
				} else {
					$GroupFontsListTitle.Checked = $False
					$GroupFontsList.Enabled = $False
				}
			} else {
				$SolutionsSoftwarePacker.Checked = $False
				$GroupSolutionsSoftwarePacker.Enabled = $False
			}
		#endregion

		Refres_Event_Tasks_Solutions_Add

		if (Autopilot_Solutions_Save) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.ISOCreateFailed) " -BackgroundColor DarkRed -ForegroundColor White

			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		Refres_Event_Tasks_Solutions_Add

		$UI_Main.ShowDialog() | Out-Null
	}
}

Function Autopilot_Solutions_Create_Import
{
	param
	(
		$Tasks,
		[switch]$ISO,
		[switch]$Mount
	)

	<#
		.测试完成后，检查配置文件里是否有事件
	#>
	if ([string]::IsNullOrEmpty($Tasks)) {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red
	} else {
		Write-Host "  $($lang.YesWork)" -ForegroundColor Yellow

		if ($ISO) {
			Solutions_Create_UI -Autopilot $Tasks -ISO
		}

		if ($Mount) {
			Solutions_Create_UI -Autopilot $Tasks -Mount
		}
	}
}

<#
	.Start working on the build solution
	.开始处理生成解决方案
#>
Function Solutions_Copy_Prerequisite
{
	param
	(
		[string]$Path,
		[string]$ShortPath
	)

	<#
		.Requirementsing: arm64
		.处理：arm64
	#>
	if ($Global:ArchitecturePack -eq "arm64") {
		if (Test-Path -Path "$($path)\arm64" -PathType Container) {
			Solutions_Copy_Files_To_Prerequisite -From "$($path)\arm64" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
		} else {
			if (Test-Path -Path "$($path)\AMD64" -PathType Container) {
				Solutions_Copy_Files_To_Prerequisite -From "$($path)\AMD64" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
			} else {
				if (Test-Path -Path "$($path)\x86" -PathType Container) {
					Solutions_Copy_Files_To_Prerequisite -From "$($path)\x86" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
				} else {
					Write-Host "  $($lang.NoInstallImage)"
					Write-Host "  $($path)\x86" -ForegroundColor Red
				}
			}
		}
	}

	<#
		.Requirementsing: AMD64
		.处理：AMD64
	#>
	if ($Global:ArchitecturePack -eq "AMD64") {
		if (Test-Path -Path "$($path)\AMD64" -PathType Container) {
			Solutions_Copy_Files_To_Prerequisite -From "$($path)\AMD64" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
		} else {
			if (Test-Path -Path "$($path)\x86" -PathType Container) {
				Solutions_Copy_Files_To_Prerequisite -From "$($path)\x86" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
			} else {
				Write-Host "  $($lang.NoInstallImage)"
				Write-Host "  $($path)\x86" -ForegroundColor Red
			}
		}
	}

	<#
		.Requirementsing: x86
		.处理：x86
	#>
	if ($Global:ArchitecturePack -eq "x86") {
		if (Test-Path -Path "$($path)\x86" -PathType Container) {
			Solutions_Copy_Files_To_Prerequisite -From "$($path)\x86" -ShortPath $ShortPath -To $Script:CopySolutionsToRoot
		} else {
			Write-Host "  $($lang.NoInstallImage)"
			Write-Host "  $($path)\x86" -ForegroundColor Red
		}
	}
}

<#
	.Copy solution directory
	.复制解决方案目录
#>
Function Solutions_Copy_Files_To_Prerequisite
{
	param
	(
		[string]$From,
		[string]$ShortPath,
		[string]$To
	)

	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$OSDefaultSolutionsLangDefault = (Get-Variable -Scope global -Name "SolutionsLangDefault_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	switch ((Get-Variable -Scope global -Name "SolutionsLang_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		"Single" {
			$NewPathTo = Join-Path -Path $To -ChildPath "$($OSDefaultUser)\$($ShortPath)"

			if (Test-Path -Path "$($From)\$($OSDefaultSolutionsLangDefault)" -PathType Container) {
				Check_Folder -chkpath $NewPathTo
				Write-Host "  $($lang.SaveTo): " -noNewline -ForegroundColor Yellow
				Write-Host $NewPathTo -ForegroundColor Green

				Copy-Item -Path "$($From)\$($OSDefaultSolutionsLangDefault)\*" -Destination $NewPathTo -Recurse -Force -ErrorAction SilentlyContinue
			} else {
				if (Test-Path -Path "$($From)\en-US" -PathType Container) {
					Check_Folder -chkpath $NewPathTo
					Write-Host "  $($lang.SaveTo): " -noNewline -ForegroundColor Yellow
					Write-Host $NewPathTo -ForegroundColor Green

					Copy-Item -Path "$($From)\en-US\*" -Destination $NewPathTo -Recurse -Force -ErrorAction SilentlyContinue
				} else {
					Check_Folder -chkpath $NewPathTo
					Write-Host "  $($lang.SaveTo): " -noNewline -ForegroundColor Yellow
					Write-Host $NewPathTo -ForegroundColor Green

					Copy-Item -Path "$($From)\*" -Destination $NewPathTo -Recurse -Force -ErrorAction SilentlyContinue
				}
			}
		}
		"Mul" {
			ForEach ($item in (Get-Variable -Scope global -Name "DeployCollectionLanguageOnly_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
				$NewPathTo = Join-Path -Path $To -ChildPath "$($OSDefaultUser)\$($ShortPath)"
				Check_Folder -chkpath $NewPathTo

				if (Test-Path -Path "$($From)\$($item)" -PathType Container) {
					Write-Host "  $($lang.SaveTo): " -noNewline -ForegroundColor Yellow
					Write-Host $NewPathTo -ForegroundColor Green

					Copy-Item -Path "$($From)\$($item)" -Destination $NewPathTo -Recurse -Force -ErrorAction SilentlyContinue
				}
			}
		}
	}
}

Function Solutions_Copy_Fonts_Prerequisite
{
	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	ForEach ($item in (Get-Variable -Scope global -Name "QueueFontsSelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($item.Name)" -ForegroundColor Green

		$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Fonts"
		Check_Folder -chkpath $NewPathTo

		Write-Host "  $($lang.SaveTo): " -noNewline -ForegroundColor Yellow
		Write-Host $NewPathTo -ForegroundColor Green

		Copy-Item -Path $item.Path -Destination $NewPathTo -Force -ErrorAction SilentlyContinue
	}
}

Function Solutions_Office_Copy
{
	$OSDeployOfficeVersion = (Get-Variable -Scope global -Name "DeployOfficeVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	<#
		.Requirementsing: AMD64
		.处理：AMD64
	#>
	if ($Global:ArchitecturePack -eq "AMD64") {
		if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\amd64\Office\Data\v64.cab" -PathType Leaf) {
			Solutions_Office_Copy_Prerequisite -From "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\amd64\Office"
		} else {
			if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office\Data\v32.cab" -PathType Leaf) {
				Solutions_Office_Copy_Prerequisite -From "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office"
			} else {
				Write-Host "  $($lang.NoInstallImage)"
				Write-Host "  $($PSScriptRoot)\..\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office" -ForegroundColor Red
			}
		}
	}

	<#
		.Requirementsing: x86
		.处理：x86
	#>
	if ($Global:ArchitecturePack -eq "x86") {
		if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office\Data\v32.cab" -PathType Leaf) {
			Solutions_Office_Copy_Prerequisite -From "$($PSScriptRoot)\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office"
		} else {
			Write-Host "  $($lang.NoInstallImage)"
			Write-Host "  $($PSScriptRoot)\..\..\..\..\..\_Custom\Office\$($OSDeployOfficeVersion)\x86\Office" -ForegroundColor Red
		}
	}
}

<#
	.添加 Office 后，匹配不同语言包并删除
#>
Function Solutions_Office_Match
{
	param
	(
		$Sources
	)

	$OSDefaultQueueDeployLanguageExclue = (Get-Variable -Scope global -Name "QueueDeployLanguageExclue_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$Region = Language_Region
	$DataFileAll = @()
	$DataLanguage = @()

	Get-ChildItem -Path "$($Sources)\Data" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
		Get-ChildItem $_.FullName -File -ErrorAction SilentlyContinue | ForEach-Object {
			$DataFileAll += $_.FullName
		}
	}

	Write-Host "`n  $($lang.Del)"
	ForEach ($item in $DataFileAll) {
		$SaveToName = [IO.Path]::GetFileName($item)
		$SaveToName = $SaveToName.replace('i640','').replace('i64','').replace('s640','').replace('s64','').replace('sp64','').replace('i320','').replace('i32','').replace('s320','').replace('s32','').replace('sp32','')

		ForEach ($itemRegion in $Region) {
			if ($OSDefaultQueueDeployLanguageExclue -Contains $itemRegion.Region) {
			} else {
				if ($SaveToName -like "*$($itemRegion.Region)*") {
					$DataLanguage += $item
					break
				}

				if ($SaveToName -like "*$($itemRegion.RegionID)*") {
					$DataLanguage += $item
					break
				}
			}
		}
	}

	ForEach ($item in $DataLanguage) {
		$SaveToName = [IO.Path]::GetFileName($item)
		Write-Host "  $($SaveToName)" -ForegroundColor Green
		Remove-Item -Path $item -ErrorAction SilentlyContinue
	}
}


<#
	.Copy solution directory
	.复制 Microsoft Office 安装包
#>
Function Solutions_Office_Copy_Prerequisite
{
	param
	(
		[string]$From
	)

	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$OSDefaultQueueDeployDeployOfficeSyncConfig = (Get-Variable -Scope global -Name "DeployOfficeSyncConfig_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	switch ((Get-Variable -Scope global -Name "DeployOfficeTo_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		1 {
			Write-Host "`n  $($lang.SolutionsDeployOfficeTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "Users\Public\Desktop\Office"
			Write-Host "  $($NewPathTo)" -ForegroundColor Green

			Remove_Tree $NewPathTo
			Check_Folder -chkpath $NewPathTo
			Copy-Item -Path "$($From)\*" -Destination $NewPathTo -Force -Recurse -ErrorAction SilentlyContinue
			Solutions_Office_Match -Source $NewPathTo
			Copy-Item -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office\setup.exe" -Destination $NewPathTo -ErrorAction SilentlyContinue

			Write-Host "`n  $($lang.SolutionsDeployOfficeSync)"
			if ($OSDefaultQueueDeployDeployOfficeSyncConfig) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				Solutions_Office_Copy_Config_Prerequisite -To $NewPathTo
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}
		}
		2 {
			Write-Host "  $($lang.SolutionsDeployOfficeTo)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Office"
			Write-Host "  $($NewPathTo)" -ForegroundColor Green

			Remove_Tree $NewPathTo
			Check_Folder -chkpath $NewPathTo
			Copy-Item -Path "$($From)\*" -Destination $NewPathTo -Force -Recurse -ErrorAction SilentlyContinue
			Solutions_Office_Match -Source $NewPathTo
			Copy-Item -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Office\setup.exe" -Destination $NewPathTo -ErrorAction SilentlyContinue

			Write-Host "`n  $($lang.SolutionsDeployOfficeSync)"
			if ($OSDefaultQueueDeployDeployOfficeSyncConfig) {
				Write-Host "  $($lang.Operable)" -ForegroundColor Green
				Solutions_Office_Copy_Config_Prerequisite -To $NewPathTo
			} else {
				Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
			}
		}
	}
}

<#
	.Copy 合集
	.复制 合集
#>
Function Solutions_Copy_Package_Prerequisite
{
	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$OSDefaultDeployPackerVersion = (Get-Variable -Scope global -Name "DeployPackerVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	switch ((Get-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		1 {
			$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "Package"
			Remove_Tree $NewPathTo
			Check_Folder -chkpath $NewPathTo
			Start-Process "robocopy.exe" -argumentlist "`"$($OSDefaultDeployPackerVersion)`" `"$($NewPathTo)`" /E /XO /W:1 /R:1" -wait -WindowStyle Minimized
		}
		2 {
			$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Package"
			Remove_Tree $NewPathTo
			Check_Folder -chkpath $NewPathTo
			Start-Process "robocopy.exe" -argumentlist "`"$($OSDefaultDeployPackerVersion)`" `"$($NewPathTo)`" /E /XO /W:1 /R:1" -wait -WindowStyle Minimized
		}
		3 {
			$NewPathTo = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "Users\Public\Desktop\Package"
			Remove_Tree $NewPathTo
			Check_Folder -chkpath $NewPathTo
			Start-Process "robocopy.exe" -argumentlist "`"$($OSDefaultDeployPackerVersion)`" `"$($NewPathTo)`" /E /XO /W:1 /R:1" -wait -WindowStyle Minimized
		}
	}
}

Function Solutions_Office_Copy_Config_Prerequisite
{
	param
	(
		$To
	)

	$OSDefaultQueueDeployLanguageExclue = (Get-Variable -Scope global -Name "QueueDeployLanguageExclue_$($To)" -ErrorAction SilentlyContinue).Value

	$TempOfficeLanguage = @()
	<#
		.优先添加 英文
	#>

	ForEach ($item in $OSDefaultQueueDeployLanguageExclue) {
		if ($item -eq "en-US") {
			$TempOfficeLanguage += "			<Language ID=""$($item)"" />`n"
		}
	}

	ForEach ($item in $OSDefaultQueueDeployLanguageExclue) {
		if ($item -ne "en-US") {
			$TempOfficeLanguage += "			<Language ID=""$($item)"" />`n"
		}
	}

	Get-ChildItem -Path $To -Recurse -include "*.xml" | Where-Object {
		(Get-Content $_.FullName) | ForEach-Object {
			$_ -replace "{ImageLanguage}", $TempOfficeLanguage
		} | Set-Content -Path $_.FullName -ErrorAction SilentlyContinue

		Write-Host "`n  $($lang.Wim_Rule_Verify)"
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		Write-Host $_.FullName -ForegroundColor Green

		Write-Host "  " -NoNewline
		Write-Host " $($lang.Wim_Rule_Verify) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (TestXMLFile -path $_.FullName) {
			Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
	}
}

<#
	.Select the image source index number user interface
	.选择映像源索引号用户界面
#>
Function Solutions_Index_UI
{
	param
	(
		[array]$Autopilot
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function Solutions_Index_Save
	{
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$UI_Main.Hide()
						$Global:UnattendSelectIndex = @{
							Name  = $_.Text;
							Index = $_.Tag
						}
						$UI_Main.Close()
					}
				}
			}
		}

		$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
		$UI_Main_Error.Text = "$($lang.SelectFromError): $($lang.NoChoose)"
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.SelectSettingImage
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 15
		Dock           = 1
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "15,563"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "40,565"
		Height         = 30
		Width          = 490
		Text           = ""
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		Text           = $lang.OK
		add_Click      = { Solutions_Index_Save }
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Save,
		$UI_Main_Canel
	))

	$Install_wim = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.wim"
	if (Test-Path -Path $Install_wim -PathType Leaf) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 8`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($Install_wim)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Get-WindowsImage -ImagePath $Install_wim -ErrorAction SilentlyContinue | ForEach-Object {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 55
					Width     = 405
					Text      = "$($lang.MountedIndex): $($_.ImageIndex)`n$($lang.Wim_Image_Name): $($_.ImageName)"
					Tag       = $_.ImageIndex
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Global:UnattendSelectIndex.Index -eq $_.ImageIndex) {
					$CheckBox.Checked = $True
				}
				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($Install_wim)"
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	$Install_ESD = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.esd"
	if (Test-Path -Path $Install_ESD -PathType Leaf) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 9`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($Install_ESD)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Get-WindowsImage -ImagePath $Install_ESD -ErrorAction SilentlyContinue | ForEach-Object {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 55
					Width     = 405
					Text      = "$($lang.MountedIndex): $($_.ImageIndex)`n$($lang.Wim_Image_Name): $($_.ImageName)"
					Tag       = $_.ImageIndex
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Global:UnattendSelectIndex.Index -eq $_.ImageIndex) {
					$CheckBox.Checked = $True
				}
				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($Install_ESD)"
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	$Install_SWM = Join-Path -Path $Global:Image_source -ChildPath "Sources\install.swm"
	if (Test-Path -Path $Install_SWM -PathType Leaf) {
		if ($Global:Developers_Mode) {
			Write-Host "`n  $($lang.Developers_Mode_Location): 10`n" -ForegroundColor Green
		}

		if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -ErrorAction SilentlyContinue).'ShowCommand' -eq "True") {
			Write-Host "`n  $($lang.Command)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  Get-WindowsImage -ImagePath ""$($Install_SWM)""" -ForegroundColor Green
			Write-Host "  $('-' * 80)`n"
		}

		try {
			Get-WindowsImage -ImagePath $Install_SWM -ErrorAction SilentlyContinue | ForEach-Object {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 55
					Width     = 405
					Text      = "$($lang.MountedIndex): $($_.ImageIndex)`n$($lang.Wim_Image_Name): $($_.ImageName)"
					Tag       = $_.ImageIndex
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
					}
				}

				if ($Global:UnattendSelectIndex.Index -eq $_.ImageIndex) {
					$CheckBox.Checked = $True
				}
				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		} catch {
			Write-Host "  $($lang.ConvertChk)"
			Write-Host "  $($Install_SWM)"
			Write-Host "  $($_)" -ForegroundColor Red
			Write-Host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	<#
		.Allow open windows to be on top
		.允许打开的窗口后置顶
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions" -Name "TopMost" -ErrorAction SilentlyContinue) {
			"True" { $UI_Main.TopMost = $True }
		}
	}

	if ($Autopilot) {
		Write-Host "  $($lang.Autopilot)" -ForegroundColor Green

		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.tag -eq $Autopilot.index) {
					$Global:UnattendSelectIndex = @{
						Name  = $_.Text;
						Index = $_.Tag
					}
				}
			}
		}
	
		$UI_Main.Close()
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.KMS User Interface
	.KMS 用户界面
#>
Function KMSkeys
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 876
		Text           = $lang.KMSSelect
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
		TopMost        = $True
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 550
		Width          = 375
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,8,8,8"
		Dock           = 3
	}
	$UI_Main_KMS_Custom_Name = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 400
		Text           = $lang.ManualKey
		Location       = '420,20'
	}
	$UI_Main_KMS_Custom = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Text           = $Global:ProductKey
		Location       = '436,55'
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
		}
	}
	$UI_Main_KMS_Custom_Tips = New-Object System.Windows.Forms.Label -Property @{
		Height         = 36
		Width          = 400
		Text           = $lang.ManualKeyTips
		Location       = "435,90"
	}
	$UI_Main_KMS_Show_MS = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 400
		Text           = $lang.KMSLink1
		Location       = "435,180"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$OpenWebsiteLink1 = "https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys"
			Write-Host "  $($OpenWebsiteLink1)"
			Start-Process $OpenWebsiteLink1
		}
	}
	$UI_Main_KMS_Show_All = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 30
		Width          = 400
		Text           = $lang.KMSUnlock
		Location       = "435,225"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Menu.controls.Clear()

			ForEach ($item in $SearchKMS) {
				$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 55
					Width     = 340
					Text      = "$($item.Name)`n$($item.ProductKey)"
					Tag       = $item.ProductKey
					add_Click = {
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null
						
						$UI_Main_KMS_Custom.BackColor = "#FFFFFF"
						$UI_Main_Error.Text = ""
						$UI_Main_Error_Icon.Image = $null

						$UI_Main_KMS_Custom.Text = $This.Tag
					}
				}
				$UI_Main_Menu.controls.AddRange($CheckBox)
			}
		}
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "422,563"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "447,565"
		Height         = 30
		Width          = 404
		Text           = ""
	}
	$UI_Main_Save      = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "420,595"
		Height         = 36
		Width          = 429
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null
			$MarkVerifyKey = $False
			If ($UI_Main_KMS_Custom.Text -Match '^([A-Z0-9]{5}-){4}[A-Z0-9]{5}$') {
				$MarkVerifyKey = $True
			}

			if ($MarkVerifyKey) {
				$UI_Main.Hide()
				$Global:ProductKey = $UI_Main_KMS_Custom.Text
				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.ManualKeyError
				$UI_Main_KMS_Custom.BackColor = "LightPink"
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "420,635"
		Height         = 36
		Width          = 429
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_KMS_Custom_Name,
		$UI_Main_KMS_Custom,
		$UI_Main_KMS_Custom_Tips,
		$UI_Main_KMS_Show_MS,
		$UI_Main_KMS_Show_All,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_Save,
		$UI_Main_Canel
	))
 
	<#
		.Display the serial number according to the kernel
		.根据内核显示序列号
	#>
	ForEach ($item in $SearchKMS) {
		if ($item.Type -eq $Global:ImageType) {
			$CheckBox     = New-Object System.Windows.Forms.RadioButton -Property @{
				Height    = 55
				Width     = 340
				Text      = "$($item.Name)`n$($item.ProductKey)"
				Tag       = $item.ProductKey
				add_Click = {
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					$UI_Main_KMS_Custom.BackColor = "#FFFFFF"
					$UI_Main_Error.Text = ""
					$UI_Main_Error_Icon.Image = $null

					$UI_Main_KMS_Custom.Text = $This.Tag
				}
			}
			$UI_Main_Menu.controls.AddRange($CheckBox)
		}
	}

	if ($Global:AutopilotMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Autopilot), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if ($Global:EventQueueMode) {
		$UI_Main.Text = "$($UI_Main.Text) [ $($lang.QueueMode), $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
	}

	if (-not $Global:AutopilotMode -xor $Global:EventQueueMode) {
		if (Image_Is_Select_IAB) {
			$UI_Main.Text = "$($UI_Main.Text) [ $($lang.Event_Primary_Key): $($Global:Primary_Key_Image.Uid) ]"
		}
	}

	$UI_Main.ShowDialog() | Out-Null
}

<#
	.生成报告
	.Generate report
#>
Function Solutions_Create_Deploy_Report
{
	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	$QueueDeployOfficeLangSelectPrint = @()
	ForEach ($item in (Get-Variable -Scope global -Name "QueueDeployLanguageExclue_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$QueueDeployOfficeLangSelectPrint += "$($item);"
	}

	$QueueDeployFileSelectPrint = @()
	ForEach ($item in (Get-Variable -Scope global -Name "QueueDeploySelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$QueueDeployFileSelectPrint += "$($item);"
	}

	$QueueSoftwareSelectPrint = @()
	ForEach ($item in (Get-Variable -Scope global -Name "QueueSoftwareSelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$QueueSoftwareSelectPrint += "$($item.Name);"
	}

	$QueueFontsSelectPrint = @()
	ForEach ($item in (Get-Variable -Scope global -Name "QueueFontsSelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$QueueFontsSelectPrint += "$($item.Name);"
	}

	$Save_engine_to_new_path = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine"
	$Save_engine_to_new_path_json = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine\Deploy.json"
	Check_Folder -chkpath $Save_engine_to_new_path

@"
{
	"Author": {
		"Name":          "$((Get-Module -Name Solutions).Author)'s Solutions",
		"Version":       "$((Get-Module -Name Solutions).Version)",
		"Url":           "$((Get-Module -Name Solutions).HelpInfoURI)"
	},
	"Unattend": {
		"ISORoot":       "$((Get-Variable -Scope global -Name "SolutionsCreateUnattendISO_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"ISOSources":    "$((Get-Variable -Scope global -Name "SolutionsCreateUnattendISOSources_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"ISOOEM":        "$((Get-Variable -Scope global -Name "SolutionsCreateUnattendISOSourcesOEM_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"Panther":       "$((Get-Variable -Scope global -Name "SolutionsCreateUnattendPanther_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"Language":      "$((Get-Variable -Scope global -Name "UnattendLang_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"IsTimeZone":    "$((Get-Variable -Scope global -Name "OOBETimZone_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"TimeZone":      "$((Get-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"Plan":          "$((Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)"
	},
	"OS": {
		"Types":         "$($Global:ImageType)",
		"ServerManager": "$($OOBEServerManager)",
		"IEHardenAdmin": "$($OOBEIEAdmin)",
		"IEHardenUser":  "$($OOBEIEUser)",
		"Architecture":  "$($Global:Architecture)",
		"Language":      "$($Global:MainImageLang)",
		"Source":        "$($Global:MainImage)"
	},
	"Office": {
		"Version":       "$((Get-Variable -Scope global -Name "DeployOfficeVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"Language":      "$($QueueDeployOfficeLangSelectPrint)",
		"Sync":          "$((Get-Variable -Scope global -Name "DeployOfficeSyncConfig_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"AddTo":         "$((Get-Variable -Scope global -Name "DeployOfficeTo_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)"
	},
	"DeployPacker": {
		"Version":       "$((Get-Variable -Scope global -Name "DeployPackerVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"AddTo":         "$((Get-Variable -Scope global -Name "DeployPackageTo_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)"
	},
	"Deploy": {
		"Engine":        "$((Get-Variable -Scope global -Name "SelectSolutionVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)",
		"Architecture":  "$($Global:ArchitecturePack)",
		"Allow":         "$($QueueDeployFileSelectPrint)",
		"Apps":          "$($QueueSoftwareSelectPrint)",
		"Fonts":         "$($QueueFontsSelectPrint)",
		"Time":          "$(Get-Date -Format "dd/MM/yyyy hh:mm:ss")"
	}
}
"@ | Out-File -FilePath $Save_engine_to_new_path_json -Encoding Ascii -ErrorAction SilentlyContinue

	Write-Host "`n  $($lang.Wim_Rule_Check)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	Write-Host "  $($Save_engine_to_new_path_json)"

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Wim_Rule_Verify) " -NoNewline -BackgroundColor White -ForegroundColor Black
	try {
		$Autopilot = Get-Content -Raw -Path $Save_engine_to_new_path_json | ConvertFrom-Json
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} catch {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

<#
	.Replace Unattend content
	.替换 Unattend 内容
#>
Function Solutions_Replace_Unattend
{
	param
	(
		[string]$From,
		[string]$FileName,
		[string]$SaveTo,
		[string]$index,
		[string]$key,
		$GUID
	)

	$RandomUniqueGUID = [guid]::NewGuid()

	$FullFilename = Join-Path -Path $SaveTo -ChildPath $FileName
	Write-Host "  $($lang.SaveTo): " -NoNewline
	Write-Host $FullFilename -ForegroundColor Green

	if (-not (Test-Path -Path $From -PathType Leaf)) {
		Write-Host "`n  $($lang.NoInstallImage)"
		Write-Host "  $($From)" -ForegroundColor Red
		return
	}

	<#
		.新的引擎目录名
	#>
	$New_User_Name_Engine_Write = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	<#
		.新的用户名
	#>
	$New_User_Name_Write = (Get-Variable -Scope global -Name "Name_Unattend_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	switch ((Get-Variable -Scope global -Name "Queue_Is_OOBE_Account_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		"Custom" {
			$Is_NEW_Select_OOBE_ACCOUNT_Write = ""
			$Is_NEW_Select_OOBE_Setting_Write = @"
				<ProtectYourPC>3</ProtectYourPC>
				<HideEULAPage>true</HideEULAPage>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
"@
			$Is_NEW_Select_OOBE_Setting_AutoLogon_Write = ""
		}
		"Specified" {
			$Is_NEW_Select_OOBE_ACCOUNT_Write = @"
			<UserAccounts>
				<LocalAccounts>
					<LocalAccount wcm:action="add">
						<Password>
							<Value></Value>
							<PlainText>true</PlainText>
						</Password>
						<Description>$($New_User_Name_Write)</Description>
						<DisplayName>$($New_User_Name_Write)</DisplayName>
						<Group>Administrators</Group>
						<Name>$($New_User_Name_Write)</Name>
					</LocalAccount>
				</LocalAccounts>
			</UserAccounts>
"@
			$Is_NEW_Select_OOBE_Setting_Write = @"
				<HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
				<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
				<HideLocalAccountScreen>true</HideLocalAccountScreen>
				<NetworkLocation>Other</NetworkLocation>
				<SkipMachineOOBE>true</SkipMachineOOBE>
				<SkipUserOOBE>true</SkipUserOOBE>
				<HideEULAPage>true</HideEULAPage>
				<ProtectYourPC>3</ProtectYourPC>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
"@
			if ((Get-Variable -Scope global -Name "Queue_Is_OOBE_Account_AutoLogon_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
				$Is_NEW_Select_OOBE_Setting_AutoLogon_Write = @"
			<AutoLogon>
				<Password>
					<Value></Value>
					<PlainText>true</PlainText>
				</Password>
				<Enabled>true</Enabled>
				<Username>$($New_User_Name_Write)</Username>
			</AutoLogon>
"@
			} else {
				$Is_NEW_Select_OOBE_Setting_AutoLogon_Write = ""
			}
		}
	}

	<#
		.It must be case sensitive, otherwise the installation will report an error
		.必须区分大小写，否则安装会报错
	#>
	<#
		.仅允许：
		 OnError, Always
	#>
	if ((Get-Variable -Scope global -Name "OOBEActivate_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEActivate = "OnError"
	} else {
		$OOBEActivate = "Always"
	}

	if ((Get-Variable -Scope global -Name "OOBEOSImage_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEOSImage = "OnError"
	} else {
		$OOBEOSImage = "Always"
	}

	<#
		.Only lowercase is allowed:
		.仅允许小写：
		 true, false
	#>
	if ((Get-Variable -Scope global -Name "OOBEAccectEula_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEAccectEula = "true"
	} else {
		$OOBEAccectEula = "false"
	}

	<#
		.Only lowercase is allowed:
		.仅允许小写：
		 true, false
	#>
	if ((Get-Variable -Scope global -Name "OOBEServerManager_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEServerManager = "true"
	} else {
		$OOBEServerManager = "false"
	}

	<#
		.Only lowercase is allowed:
		.仅允许小写：
		 true, false
	#>
	if ((Get-Variable -Scope global -Name "OOBEIEAdmin_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEIEAdmin = "false"
	} else {
		$OOBEIEAdmin = "true"
	}

	<#
		.Only lowercase is allowed:
		.仅允许小写：
		 true, false
	#>
	if ((Get-Variable -Scope global -Name "OOBEIEUser_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBEIEUser = "false"
	} else {
		$OOBEIEUser = "true"
	}

	<#
		.设置时间
	#>
	if ((Get-Variable -Scope global -Name "OOBETimZone_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$OOBETimZone = "			<TimeZone>$((Get-Variable -Scope global -Name "TimeZone_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value)</TimeZone>"
	} else {
		$OOBETimZone = ""
	}

	if ((Get-Variable -Scope global -Name "AllowUnattendIndex_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$UnattendIndex = @"
					<InstallFrom>
						<MetaData wcm:action="add">
							<Key>/IMAGE/INDEX</Key>
							<Value>$($index)</Value>
						</MetaData>
					</InstallFrom>
"@
	} else {
		$UnattendIndex = ""
	}

	if ((Get-Variable -Scope global -Name "AllowUnattendProductKey_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		$UnattendKeys = @"
					<KEY>$($key)</KEY>
"@
	} else {
		$UnattendKeys = ""
	}

	$Print_Save_Microsoft_Windows_Setup = ""
	$Print_Save_Microsoft_Windws_PE = ""

	<#
		.命令行：组，Windows 安装
	#>
	$Get_Queue_Command_WinSetup = (Get-Variable -Scope global -Name "Queue_Command_WinSetup_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	if ($Get_Queue_Command_WinSetup.Count -gt 0) {
		$Save_Microsoft_Windows_Setup = @()
		[int]$Init_Microsoft_Windows_Setup = 0
	
		ForEach ($item in $Global:Pre_Config_Command_Rules) {
			if ($Get_Queue_Command_WinSetup -Contains $item.GUID) {
				foreach ($itemCommand in $item.Command) {
					<#
						替换内容
					#>
					$SearchNewFileName = $itemCommand.Replace("{UniqueID}", $New_User_Name_Engine_Write)
					$Init_Microsoft_Windows_Setup++

					$Save_Microsoft_Windows_Setup += @"
				<SynchronousCommand wcm:action="add">
					<Order>$($Init_Microsoft_Windows_Setup)</Order>
					<CommandLine>$($SearchNewFileName)</CommandLine>
				</SynchronousCommand>

"@
				}
			}
		}

		if ($Save_Microsoft_Windows_Setup.Count -gt 0) {
			$Print_Save_Microsoft_Windows_Setup = @"
			<FirstLogonCommands>
$($Save_Microsoft_Windows_Setup)
			</FirstLogonCommands>
"@
		}
	}

	<#
		.命令行：组，Windows PE
	#>
	$Get_Queue_Command_WinPE = (Get-Variable -Scope global -Name "Queue_Command_WinPE_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	if ($Get_Queue_Command_WinPE.Count -gt 0) {
		$Save_Microsoft_Windows_PE = @()
		[int]$Init_Microsoft_Windows_Setup = 0

		ForEach ($item in $Global:Pre_Config_Command_Rules) {
			if ($Get_Queue_Command_WinPE -Contains $item.GUID) {
				foreach ($itemCommand in $item.Command) {
					<#
						替换内容
					#>
					$SearchNewFileName = $itemCommand.Replace("{UniqueID}", $New_User_Name_Engine_Write)
					$Init_Microsoft_Windows_Setup++

					$Save_Microsoft_Windows_PE += @"
				<RunSynchronousCommand wcm:action="add">
					<Order>$($Init_Microsoft_Windows_Setup)</Order>
					<Path>$($SearchNewFileName)</Path>
				</RunSynchronousCommand>

"@
				}
			}
		}

		if ($Save_Microsoft_Windows_PE.Count -gt 0) {
			$Print_Save_Microsoft_Windws_PE = @"
			<RunSynchronous>
$($Save_Microsoft_Windows_PE)
			</RunSynchronous>
"@	
		}
	}

	Check_Folder -chkpath $SaveTo
	(Get-Content $From) | ForEach-Object {
		$_ -replace "{GUID}", $RandomUniqueGUID `
		   -replace "{ImageLanguage}",   $((Get-Variable -Scope global -Name "UnattendLangDefault_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) `
		   -replace "{UnattendIndex}",   $UnattendIndex `
		   -replace "{InitProductKey}",  $UnattendKeys `
		   -replace "{UniqueID}",        $New_User_Name_Engine_Write `
		   -replace "{InitUsers}",       $Is_NEW_Select_OOBE_ACCOUNT_Write `
		   -replace "{InitOOBESetting}", $Is_NEW_Select_OOBE_Setting_Write `
		   -replace "{InitAutoLogon}",   $Is_NEW_Select_OOBE_Setting_AutoLogon_Write `
		   -replace "{TimeZone}",        $OOBETimZone `
		   -replace "{ProductKeyUi}",    $OOBEActivate `
		   -replace "{AccectEula}",      $OOBEAccectEula `
		   -replace "{OSImageUi}",       $OOBEOSImage `
		   -replace "{OSServerManager}", $OOBEServerManager `
		   -replace "{OSIEAdmin}",       $OOBEIEAdmin `
		   -replace "{OSIEUser}",        $OOBEIEUser `
		   -replace "{WindowsPESetupFirstLogonCommands}",    $Print_Save_Microsoft_Windws_PE `
		   -replace "{WindowsShellSetupFirstLogonCommands}", $Print_Save_Microsoft_Windows_Setup
	} | Set-Content -Path $FullFilename -ErrorAction SilentlyContinue

	Write-Host "`n  $($lang.Wim_Rule_Verify)"
	Write-Host "  $('-' * 80)"
	Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $FullFilename -ForegroundColor Green

	Write-Host "  " -NoNewline
	Write-Host " $($lang.Wim_Rule_Verify) " -NoNewline -BackgroundColor White -ForegroundColor Black
	if (TestXMLFile -path $FullFilename) {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
	}
}

<#
	.Start working on the build solution
	.开始处理生成解决方案
#>
Function Solutions_Generate_Prerequisite
{
	param
	(
		[switch]$ISO,
		[switch]$Mount
	)

	$OSDefaultUser = (Get-Variable -Scope global -Name "Name_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$OSDefaultQueueDeploySelect = (Get-Variable -Scope global -Name "QueueDeploySelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	if ($ISO) {
		$Script:init_To_GPS = "ISO"
		$Script:CopySolutionsToRoot    = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$\`$1"
		$Script:CopySolutionsToWindows = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$\`$$"

		Write-Host "`n  $($lang.ClearOld), ISO"
		$GroupCleanISO = @(
			"autounattend.xml"
			"_Unattend"
			"sources\unattend.xml"
			"sources\`$OEM$"
		)

		ForEach ($item in $GroupCleanISO) {
			$WaitCleanFolder = Join-Path -Path $Global:Image_source -ChildPath $item

			Write-Host "  $($WaitCleanFolder)" -ForegroundColor Green
			Remove_Tree $WaitCleanFolder

			if (Test-Path -Path $WaitCleanFolder -PathType Container) {
				Write-Host "  $($lang.Del), $($lang.Failed): $($WaitCleanFolder)" -ForegroundColor Red
			}
		}
	}

	if ($Mount) {
		if (Image_Is_Select_IAB) {
			$Script:init_To_GPS = "$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)"
			$Script:CopySolutionsToRoot = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"
			$Script:CopySolutionsToWindows = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount\Windows"

			if (Test-Path -Path $Script:CopySolutionsToRoot -PathType Container) {
				Write-Host "`n  $($lang.ClearOld), Mount"

				$OSDefaultUserMount = (Get-Variable -Scope global -Name "Name_Engine_$($Global:Primary_Key_Image.Master)_$($Global:Primary_Key_Image.ImageFileName)" -ErrorAction SilentlyContinue).Value

				$GroupCleanMountTo = @(
					"$($OSDefaultUserMount)"
					"Users\Desktop\Office"
					"Windows\Panther"
				)

				ForEach ($item in $GroupCleanMountTo) {
					$TestNewItem = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath $item

					Write-Host "  $($TestNewItem)" -ForegroundColor Green
					Remove_Tree $TestNewItem

					if (Test-Path -Path $TestNewItem -PathType Container) {
						Write-Host "  $($lang.Del), $($lang.Failed): $($TestNewItem)" -ForegroundColor Red
					}
				}
			} else {
				Write-Host "  $($lang.SolutionsSkip)" -ForegroundColor Red
				return
			}
		} else {
			Write-Host "  $($lang.SolutionsSkip)" -ForegroundColor Red
			return
		}
	}

	if ((Get-Variable -Scope global -Name "SolutionsSoftwarePacker_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "`n  $($lang.RuleFileType)" -ForegroundColor Green
		Write-Host "`n  $($lang.SolutionsDeployOfficeOnly)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in (Get-Variable -Scope global -Name "DeployCollectionLanguageOnly_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		$PrintQueueSoftwareSelect = (Get-Variable -Scope global -Name "QueueSoftwareSelect_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

		Write-Host "`n  $($lang.AddSources)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $PrintQueueSoftwareSelect) {
			Write-Host "  $($lang.RuleFileType): " -noNewline -ForegroundColor Yellow
			Write-Host $item.Name -ForegroundColor Green
		}

		Write-Host "`n  $($lang.AddQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$Temp_New_Software_Path = Join-Path -Path $(Convert-Path "$($PSScriptRoot)\..\..\..\..") -ChildPath "_Custom\Software"
		ForEach ($item in $PrintQueueSoftwareSelect) {
			$Latest_Temp_New_Software_Path = Join-Path -Path $Temp_New_Software_Path -ChildPath $item.Path

			Write-Host "  $($lang.RuleFileType): " -noNewline -ForegroundColor Yellow
			Write-Host $item.Name -ForegroundColor Green

			Write-Host "  $($lang.AddSources): " -noNewline -ForegroundColor Yellow
			Write-Host $item.Path -ForegroundColor Green

			Solutions_Copy_Prerequisite -Path $Latest_Temp_New_Software_Path -ShortPath $item.Path
		}

		Write-Host "`n  $($lang.Fonts)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "DeployFonts_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Solutions_Copy_Fonts_Prerequisite
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.部署 Microsoft Office 安装包
		#>
		Write-Host "`n  $($lang.SolutionsDeployOfficeInstall)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "SolutionsDeployOfficeInstall_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green
			Solutions_Office_Copy
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.部署 合集
		#>
		Write-Host "`n  $($lang.DeployPackage)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		if ((Get-Variable -Scope global -Name "SolutionsDeployPackageInstall_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Write-Host "  $($lang.Operable)" -ForegroundColor Green
			Solutions_Copy_Package_Prerequisite
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.清理不同架构包
			.Clean up different architecture packages
		#>
		$GroupCleanArm64 = @()
		$GroupCleanAMD64 = @()
		$GroupCleanx86 = @()

		switch ($Global:ArchitecturePack) {
			"arm64" {
				ForEach ($item in $GroupCleanArm64) {
					Remove_Tree $(Join-Path -Path $Script:CopySolutionsToRoot -ChildPath $item)
				}
			}
			"AMD64" {
				ForEach ($item in $GroupCleanAMD64) {
					Remove_Tree $(Join-Path -Path $Script:CopySolutionsToRoot -ChildPath $item)
				}
			}
			"x86" {
				ForEach ($item in $GroupCleanx86) {
					Remove_Tree $(Join-Path -Path $Script:CopySolutionsToRoot -ChildPath $item)
				}
			}
		}
	} else {
		Write-Host "`n  $($lang.EnabledSoftwarePacker)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.UserCancel)`n" -ForegroundColor Red
	}

	<#
		.创建应预答
	#>
	Write-Host "`n  $($lang.EnabledUnattend)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ((Get-Variable -Scope global -Name "SolutionsUnattend_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "  $($lang.CreateUnattendISO)" -ForegroundColor Green
		if ((Get-Variable -Scope global -Name "SolutionsCreateUnattendISO_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Solutions_Copy_Unattend_Files_To_Prerequisite -SaveTo $Global:Image_source -NewFileName "Autounattend.xml"
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		Write-Host "`n  $($lang.CreateUnattendISOSources)" -ForegroundColor Green
		if ((Get-Variable -Scope global -Name "SolutionsCreateUnattendISOSources_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$TempGetFolder = Join-Path -Path $Global:Image_source -ChildPath "Sources"

			Solutions_Copy_Unattend_Files_To_Prerequisite -SaveTo $TempGetFolder -NewFileName "Unattend.xml"
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		Write-Host "`n  $($lang.CreateUnattendISOSourcesOEM)" -ForegroundColor Green
		if ((Get-Variable -Scope global -Name "SolutionsCreateUnattendISOSourcesOEM_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			$TempGetFolder = Join-Path -Path $Global:Image_source -ChildPath "Sources\`$OEM$\`$$\Panther"

			Solutions_Copy_Unattend_Files_To_Prerequisite -SaveTo $TempGetFolder -NewFileName "Unattend.xml"
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		Write-Host "`n  $($lang.CreateUnattendPanther)" -ForegroundColor Green
		if ((Get-Variable -Scope global -Name "SolutionsCreateUnattendPanther_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			if (Image_Is_Select_IAB) {
				$TempGetFolder = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount"

				if (Test-Path -Path $TempGetFolder -PathType Container 	-ErrorAction SilentlyContinue) {
					$TempGetFolderPanther = Join-Path -Path $Global:Mount_To_Route -ChildPath "$($Global:Primary_Key_Image.Master).$($Global:Primary_Key_Image.MasterSuffix)\$($Global:Primary_Key_Image.ImageFileName).$($Global:Primary_Key_Image.Suffix)\Mount\Windows\Panther"

					Solutions_Copy_Unattend_Files_To_Prerequisite -SaveTo $TempGetFolderPanther -NewFileName "Unattend.xml"
				} else {
					Write-Host "  $($lang.NotMounted)" -ForegroundColor Red
				}
			} else {
				Write-Host "  $($lang.IABSelectNo)" -ForegroundColor Red
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}
	} else {
		Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_Engine_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		Write-Host "`n  $($lang.EnabledEnglish)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"

		$Save_engine_to_new_path = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine"
		Check_Folder -chkpath $Save_engine_to_new_path

		$OSDefaultSelectSolutionVersion = (Get-Variable -Scope global -Name "SelectSolutionVersion_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

		Copy-Item -Path "$($PSScriptRoot)\..\..\..\..\_Custom\Engine\$($OSDefaultSelectSolutionVersion)\*" -Destination $Save_engine_to_new_path -Recurse -Force -ErrorAction SilentlyContinue

		<#
			.清理“主引擎”里的不同软件包软件
			.Clean up different SoftwarePackages in the "main engine"
		#>
		$ClearArchSoftware = @(
			Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine\AIO"
		)
		ForEach ($item in $ClearArchSoftware) {
			Write-Host "  $($item)" -ForegroundColor Green
			Get-ChildItem $item -directory -ErrorAction SilentlyContinue | ForEach-Object {
				Write-Host "  $($lang.FileName): " -NoNewline -ForegroundColor Yellow
				Write-Host $_.FullName -ForegroundColor Green

				Clear_Arch_Path -Path $_.FullName
			}
		}

		<#
			.生成报告
			.Generate report
		#>
		if ((Get-Variable -Scope global -Name "SolutionsReport_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
			Solutions_Create_Deploy_Report
		}

		<#
			.根据功能选择：生成部署所需的标记
		#>
		$Create_Mark_Deploy_Allow  = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine\Deploy\Allow"
		$Create_Mark_Deploy_Region = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\Engine\Deploy\Region"
		Check_Folder -chkpath $Create_Mark_Deploy_Allow

		Write-Host "`n  $($lang.Deploy_Tags), $($lang.SaveTo)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($Create_Mark_Deploy_Allow)" -ForegroundColor Green

		Write-Host "`n  $($lang.LXPsWaitAdd)"
		Write-Host "  $('-' * 80)"
		ForEach ($item in $OSDefaultQueueDeploySelect) {
			Write-Host "  $($item)" -ForegroundColor Green
			Out-File -FilePath "$($Create_Mark_Deploy_Allow)\$($item)" -Encoding utf8 -ErrorAction SilentlyContinue
		}

		Write-Host "`n  $($lang.SolutionsEngineRegional)"
		Write-Host "  $('-' * 80)"
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Region" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Is_Region" -ErrorAction SilentlyContinue) {
				"True" {
					Write-Host "  $($lang.LXPsWaitAdd)"
					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue) {
						$GetNewSaveLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\Deploy\Create\Mark" -Name "$($Script:init_To_GPS)_Region_Preferred" -ErrorAction SilentlyContinue
						$TempSaveLangToNew = "$($Create_Mark_Deploy_Region)\$($GetNewSaveLanguage)"

						Write-Host "  $($lang.SaveTo): " -NoNewline
						Write-Host $Create_Mark_Deploy_Region -ForegroundColor Green

						Write-Host "  $($lang.LanguageCode): " -NoNewline
						Write-Host $GetNewSaveLanguage -ForegroundColor Green

						Out-File -FilePath $TempSaveLangToNew -Encoding utf8 -ErrorAction SilentlyContinue
						if (Test-Path -Path $TempSaveLangToNew -PathType Leaf) {
							Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
						} else {
							Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
						}
					} else {
						Write-Host "  $($lang.SelectFromError)" -ForegroundColor Red
					}
				}
				"False" {
					Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
				}
			}
		} else {
			Write-Host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.清理，通用，指定
			.Cleanup, general, designated
		#>
		<#
			.B 3. Solution, after generation: clean up the specified directory
			.B 3. 解决方案，生成后：清理指定目录
		#>
		$GroupCleanDIY = @(
			"Engine\Logs"
			"Engine\get.ps1"
		)

		ForEach ($item in $GroupCleanDIY) {
			$DelNewItem = Join-Path -Path $Script:CopySolutionsToRoot -ChildPath "$($OSDefaultUser)\$($item)"
			Remove_Tree $DelNewItem
		}
	} else {
		Write-Host "`n  $($lang.EnabledEnglish)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.UserCancel)`n" -ForegroundColor Red
	}
}

Function Solutions_Copy_Unattend_Files_To_Prerequisite
{
	param
	(
		$SaveTo,
		$NewFileName
	)

	<#
		.Pre-answer solution language: 1 = single language, current Requirementsing: 1, semi-auto;
		.应预答解决方案语言：1 = 单语言，当前处理：1、半自动；
	#>

	<#
		.Judging the third step, judging the installation method, 1 = commercial version; 2 = consumer version;
		.判断第三步，判断安装方式：1 = 商业版；2 = 消费者版；

		.Current Requirementsing: 1 = single language, 1 = semi-automatic is valid for all installation methods
		.当前处理：1 = 单语言，1 = 半自动对所有安装方式有效
	#>

	$OSDefaultDeployUnattendLang = (Get-Variable -Scope global -Name "UnattendLang_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$OSDefaultSolutionsInstallMode = (Get-Variable -Scope global -Name "SolutionsInstallMode_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value
	$Unattend_Schome_Select = (Get-Variable -Scope global -Name "Queue_Unattend_Scheme_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value

	switch ((Get-Variable -Scope global -Name "Autounattend_$($Script:init_To_GPS)" -ErrorAction SilentlyContinue).Value) {
		1 {
			switch ($OSDefaultSolutionsInstallMode) {
				1 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\business.Semi.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
				2 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\Consumer.Semi.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
			}
		}
		2 {
			switch ($OSDefaultSolutionsInstallMode) {
				1 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\business.UEFI.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
				2 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\Consumer.UEFI.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
			}
		}
		3 {
			<#
				.Pre-answer solution language: 1 = single language, current Requirementsing: 1, semi-auto;
				.应预答解决方案语言：1 = 单语言，当前处理：2、Legacy 自动安装
			#>
			switch ($OSDefaultSolutionsInstallMode) {
				1 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\business.Legacy.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
				2 {
					Solutions_Replace_Unattend -From "$($PSScriptRoot)\..\..\..\..\_Custom\Unattend\$($Unattend_Schome_Select)\$($Global:ImageType)\$($OSDefaultDeployUnattendLang)\Consumer.Legacy.xml" $SaveTo -Filename $NewFileName -index $Global:UnattendSelectIndex.Index -key $Global:ProductKey
				}
			}
		}
	}
}

Function Solutions_Quick_Copy_Process_To_ISO
{
	if ((Get-Variable -Scope global -Name "Queue_Is_Solutions_ISO" -ErrorAction SilentlyContinue).Value) {
		<#
			.[主目录]:\Sources\$OEM$
		#>
		Write-Host "`n  $($lang.Solution)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		Write-Host "  $($lang.Operable)" -ForegroundColor Green
		Solutions_Generate_Prerequisite -ISO

		New-Variable -Scope global -Name "Queue_Is_Solutions_ISO" -Value $False -Force
	}
}