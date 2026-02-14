<#
	.Summary
	 Yi's Solutions

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS >

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.Example
	 PS C:\> .\Instl.ps1

	.LINK
	 https://fengyi.tel/solutions
	 https://github.com/ilikeyi/Solutions

	.About
	 Author:  Yi
	 Website: http://fengyi.tel

  PowerShell 安装软件

  . 主要功能
    1. 本地不存在安装包，激活下载功能；
    2. 使用下载功能时，自动判断系统类型，自动按顺序选择，依次类推；
    3. 自动选择盘符：
        3.1    可指定盘符，设置自动后将排除当前系统盘，
               搜索不到可用盘时，回退到当前系统盘；
        3.2    可设置最低要求剩余可用空间，默认 1GB；

    4. 搜索文件名支持模糊查找，通配符 *；
    5. 队列，运行安装程序后添加到队列，等待结束；
    6. 依次按预先设置的结构搜索：
       * 原始下载地址：https://fengyi.tel/Instl.Packer.Latest.exe
         + 模糊文件名：Instl.Packer*
           - 条件 1：系统语言：en-US，搜索条件：Instl.Packer*en-US*
           - 条件 2：搜索模糊文件名：Instl.Packer*
           - 条件 3：搜索网站下载原始文件名：Instl.Packer.Latest

    7. 动态功能：已添加运行前，运行后处理，前往 Function Open_Apps {} 处更改该模块；
    8. 支持解压包处理等。

	运行模式：Wait = 等待完成；Fast = 直接运行；Queue = 队列
	运行动作：Install = 安装；NoInst = 下载后不安装；To = 下载压缩包到目录；Unzip = 下载后

  . 先决条件
  	- PowerShell 5.1 或更高

  . 连接
  	- https://github.com/ilikeyi/Instl

  .用法
   -Language "en-US"           | 指定语言
   -Config "D:\instl.json"     | 指定配置文件
   -App "Gpg4win", "Python"    | 从指定配置文件 instl.json 里获取应用程序，如果没有指定则自动从网站上下载配置文件
                                 可指定应用程序名、GUID 唯一识别符
   -Silent                     | 静默安装

#>

#Requires -version 5.1

# 获取脚本参数（如果有）
[CmdletBinding()]
param
(
	$Language,
	$Config,
	[string[]]$App,
	[switch]$Silent
)

<#
	.Available servers
	.可用的服务器

	Usage:
	用法：

       Only one URL address must be added in front of the, number, multiple addresses do not need to be added, example:
       只有一个 URL 地址必须在前面添加 , 号，多地址不用添加，示例：

	$Update_Server = @(
		@{
			Region = "en-US"
			Link   = @(
				"https://fengyi.tel/solutions/update/Instl/en-US/latest.json",
				"https://github.com/ilikeyi/Instl/raw/main/update/en-US/latest.json"
			)
		}
	)
#>
$Script:ServerList = @()
$Script:ServerListSelect = @()
$Update_Server = @(
	@{
		Region = "en-US"
		Name   = "English (United States)"
		Link   = @(
			"https://fengyi.tel/solutions/update/Instl/en-US/latest.json",
			"https://github.com/ilikeyi/Instl/raw/main/update/en-US/latest.json"
		)
	}
	@{
		Region = "zh-CN"
		Name   = "Chinese (Simplified, China)"
		Link   = @(
			"https://fengyi.tel/solutions/update/Instl/zh-CN/latest.json"
			"https://github.com/ilikeyi/Instl/raw/main/update/zh-CN/latest.json"
		)
	}
)

# 初始化自动选择磁盘最低大小：1GB
$Script:DiskMinSize = 1

# 重置队列
$Script:AppQueue = @()

<#
	.设置软件列表
#>
$Script:Install_App = @()

<#
	.Language
	.语言
#>
$Global:lang = @()
$Global:IsLang = ""
$AvailableLanguages = @(
	@{
		Tag      = "en-US"
		Name     = "English (United States)"
		Language = @{
			FontsUI                 = "Segoe UI"
			Instl                   = "Software Installation"
			Setting                 = "Set up"
			Refresh                 = "Refresh"
			OK                      = "OK"
			AllSel                  = "Select all"
			AllClear                = "Clear all"
			Cancel                  = "Cancel"
			UpdateList              = "Update list"
			FailedCreateFolder      = "Failed to create directory"
			Installing              = "Installing"
			Done                    = "Finish"
			ExistingPacker          = "Already installed package"
			QucikRun                = "Quick run:"
			WaitDone                = "Wait for completion:"
			WaitQueue               = "Waiting in queue"
			AddQueue                = "Add queue: "
			Parameter               = "Parameter: "
			LocallyExist            = "local presence"
			InstlNo                 = "No installation files found, please check integrity: "
			OnlyUnzip               = "Unzip only"
			StartDown               = "Start download"
			DownloadFailed          = "Download failed"
			ConnectTo               = "Connected to"
			FileName                = "File name"
			SaveTo                  = "Save to"
			ItInstalled             = "Installed"
			UpdateAvailable         = "Available"
			UpdateUnavailable       = "Unavailable"
			ExistingInstlPacker     = "Already compressed"
			DownloadLinkError       = "The download address is invalid."
			ErrorDown               = "An error occurred during the download"
			Unpacking               = "Unpacking"
			ToQuit                  = "{0} Seconds to exit the installer software script."
			ChoseClass              = "Choose category"
			ChoseClassNo            = "Please select a category first"
			ChoseInstall            = "Select the software to be installed"
			ChoseSoftwareNot        = "No software selected for download"
			Instllsoftwareing       = "Installing software"
			InstllUnavailable       = "No installer available"
			SelectAutoAvailable     = "When automatically selecting an available disk"
			SelectCheckAvailable    = "Check the minimum available free space"
			SettingDiskNewPath      = "Disk is used by default (click me to refresh)"
			SelectNoDisk            = "Use disk by default is not selected"
			PreDownLink             = "Preferred download address"
			SolutionsTipsArm64      = "Prefer arm64 packages, select in order: x64, x86."
			SolutionsTipsAMD64      = "Prefer x64 packages, select in order: x86."
			SolutionsTipsX86        = "Only add x86 packages."
			UpdateServerSelect      = "Automatic server selection or custom selection"
			SetDefault              = "Set as default"
			AppNo                   = "No software available"
			NoWork                  = "No task"
			NoInstallImage          = "Does not exist locally"
			ConfigNot               = "Configuration file:"
			UpdateCheckServerStatus = "Check server status ( {0} optional )"
			UpdateServerAddress     = "Server address"
			UpdatePriority          = "Set as priority"
			UpdateServerTestFailed  = "Failed server status test"
			UpdateQueryingUpdate    = "Querying for updates..."
			UpdateTimeUsed          = "Time taken"
			VerifyConfig            = "Verifying correct configuration file"
			UpdateFailedConfig      = "Download succeeded, but profile test failed, updated failed."
			ConfigError             = "Configuration file error"
			PSFunction              = "PowerShell Function"
			Command                 = "Custom command line"
		}
	}
	@{
		Tag      = "zh-CN"
		Name     = "Chinese (Simplified, China)"
		Language = @{
			FontsUI                 = "Microsoft YaHei UI"
			Instl                   = "软件安装"
			Setting                 = "设置"
			Refresh                 = "刷新"
			OK                      = "确定"
			AllSel                  = "选择所有"
			AllClear                = "清除所有"
			Cancel                  = "取消"
			UpdateList              = "更新列表"
			FailedCreateFolder      = "创建目录失败"
			Installing              = "正在安装"
			Done                    = "完成"
			ExistingPacker          = "已有安装包"
			QucikRun                = "快速运行："
			WaitDone                = "等待完成："
			WaitQueue               = "正在等待队列"
			AddQueue                = "添加队列："
			Parameter               = "参数："
			LocallyExist            = "本地存在"
			InstlNo                 = "未发现安装文件，请检查完整性："
			OnlyUnzip               = "仅解压"
			StartDown               = "开始下载"
			DownloadFailed          = "下载失败"
			ConnectTo               = "连接到"
			FileName                = "文件名"
			SaveTo                  = "保存到"
			ItInstalled             = "已安装"
			UpdateAvailable         = "可用"
			UpdateUnavailable       = "不可用"
			ExistingInstlPacker     = "已有压缩包"
			DownloadLinkError       = "下载地址无效。"
			ErrorDown               = "下载过程中出现错误"
			Unpacking               = "解压中"
			ToQuit                  = "{0} 秒後退出主菜單。"
			ChoseClass              = "选择分类"
			ChoseClassNo            = "请先选择分类"
			ChoseInstall            = "选择待安装的软件"
			ChoseSoftwareNot        = "未选择待下载的软件"
			Instllsoftwareing       = "正在安装软件中"
			InstllUnavailable       = "没有可用的安装软件"
			SelectAutoAvailable     = "自动选择可用磁盘时"
			SelectCheckAvailable    = "检查最低可用剩余空间"
			SettingDiskNewPath      = "默认使用磁盘 ( 点我刷新 )"
			SelectNoDisk            = "未选择默认使用磁盘"
			PreDownLink             = "首选下载地址"
			SolutionsTipsArm64      = "首选 arm64 软件包，依次按顺序选择：x64、x86。"
			SolutionsTipsAMD64      = "首选 x64 软件包，依次按顺序选择：x86。"
			SolutionsTipsX86        = "仅添加 x86 软件包。"
			UpdateServerSelect      = "自动选择服务器或自定义选择"
			SetDefault              = "已设置为默认"
			AppNo                   = "无可用软件"
			NoWork                  = "无任务"
			NoInstallImage          = "本地不存在"
			ConfigNot               = "配置文件："
			UpdateCheckServerStatus = "检查服务器状态 ( 共 {0} 个可选 )"
			UpdateServerAddress     = "服务器地址"
			UpdatePriority          = "已设置为优先级"
			UpdateServerTestFailed  = "未通过服务器状态测试"
			UpdateQueryingUpdate    = "正在查询更新中..."
			UpdateTimeUsed          = "所用的时间"
			VerifyConfig            = "正在验证正确的配置文件"
			UpdateFailedConfig      = "下载成功，但配置文件测试失败，已更新失败。"
			ConfigError             = "配置文件错误"
			PSFunction              = "PowerShell 函数"
			Command                 = "自定义命令行"
		}
	}
)

Function Language
{
	param
	(
		$NewLang = (Get-Culture).Name
	)

	$Global:lang = @()
	$Global:IsLang = ""

	ForEach ($item in $AvailableLanguages) {
		if ($item.Tag -eq $NewLang) {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Tag
			return
		}
	}

	ForEach ($item in $AvailableLanguages) {
		if ($item.Tag -eq "en-US") {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Tag
			return
		}
	}

	Write-Host "No language packs found, please try again." -ForegroundColor Red
	exit
}

<#
	.系统架构
#>
Function Get_Architecture
{
	<#
		.从注册表获取：用户指定系统架构
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "Architecture" -ErrorAction SilentlyContinue) {
		$Global:InstlArchitecture = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "Architecture" -ErrorAction SilentlyContinue
		return
	}

	<#
		.初始化：系统架构
	#>
	Set_Architecture -Type $env:PROCESSOR_ARCHITECTURE
}

<#
	.设置系统架构
#>
Function Set_Architecture
{
	param
	(
		[string]$Type
	)

	$FullPath = "HKCU:\SOFTWARE\Yi\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "Architecture" -Value $Type -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null

	$Global:InstlArchitecture = $Type
}

<#
	.自动选择磁盘
#>
Function Install_Init_Disk_To
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskTo" -ErrorAction SilentlyContinue) {
		$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskTo" -ErrorAction SilentlyContinue
		if (Test_Available_Disk -Path $GetDiskTo) {
			$Global:FreeDiskTo = $GetDiskTo
			return
		}
	}

	<#
		.搜索磁盘条件，排除系统盘
	#>
	$ExcludeDisk = @(
		Join_MainFolder -Path $env:SystemDrive
		"A:\"
		"B:\"
	)

	$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Where-Object { $ExcludeDisk -notcontains $_.Root } | Select-Object -ExpandProperty 'Root'

	<#
		.从注册表里获取选择的磁盘
	#>
	$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue

	<#
		.搜索磁盘条件，排除系统盘
	#>
	$FlagsSearchNewDisk = $False
	ForEach ($item in $drives) {
		if (Test_Available_Disk -Path $item) {
			$FlagsSearchNewDisk = $True

			if (Verify_Available_Size -Disk $item -Size $GetDiskMinSize) {
				SetNewFreeDiskTo -Disk $item
				return
			}
		}
	}

	<#
		.未找到可用磁盘，初始化：当前系统盘
	#>
	if (-not ($FlagsSearchNewDisk)) {
		SetNewFreeDiskTo -Disk (Join_MainFolder -Path $env:SystemDrive)
	}
}

Function SetNewFreeDiskTo
{
	param
	(
		[string]$Disk
	)

	$FullPath = "HKCU:\SOFTWARE\Yi\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskTo" -Value $Disk -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null

	$Global:FreeDiskTo = $Disk
}

<#
	.从注册表里获取选择的磁盘并判断，如果是强行设置磁盘，跳过检查剩余磁盘空间了，继续
#>
Function Setting_Init_Disk_Free
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue) {
		$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue

		if ([string]::IsNullOrEmpty($GetDiskMinSize)) {
			Setting_Set_Disk_Free -Size $Script:DiskMinSize
		}

		if (-not ($GetDiskMinSize -ge $Script:DiskMinSize)) {
			Setting_Set_Disk_Free -Size $Script:DiskMinSize
		}
	} else {
		Setting_Set_Disk_Free -Size $Script:DiskMinSize
	}
}

Function Setting_Set_Disk_Free
{
	param
	(
		[string]$Size
	)

	$FullPath = "HKCU:\SOFTWARE\Yi\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskMinSize" -Value $Size -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
}

<#
	.从注册表里获取是否检查磁盘可用空间
#>
Function Setting_Init_Disk_Available
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
		<#
			.从注册表里获取是否检查磁盘可用空间
		#>
		$GetDiskStatus = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue

		if ([string]::IsNullOrEmpty($GetDiskStatus)) {
			Setting_Set_Disk_Available -Status "True"
		} else {
			$Global:FreeDiskStatus = $GetDiskStatus
		}
	} else {
		Setting_Set_Disk_Available -Status "True"
	}
}

<#
	.设置可用磁盘
#>
Function Setting_Set_Disk_Available
{
	param
	(
		[string]$Status
	)

	$FullPath = "HKCU:\SOFTWARE\Yi\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskStatus" -Value $Status -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null

	$Global:FreeDiskStatus = $Status
}

<#
	.验证可用磁盘大小
#>
Function Verify_Available_Size
{
	param
	(
		[string]$Disk,
		[int]$Size
	)

	$TempCheckVerify = $false

	Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { ((Join_MainFolder -Path $Disk) -eq $_.Root) } | ForEach-Object {
		if ($_.Free -gt (Convert_Size -From GB -To Bytes -Size $Size)) {
			$TempCheckVerify = $True
		} else {
			$TempCheckVerify = $false
		}
	}

	return $TempCheckVerify
}

<#
	.转换磁盘空间大小
#>
Function Convert_Size
{
	param
	(
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$From,
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$To,
		[Parameter(Mandatory=$true)]
		[double]$Size,
		[int]$Precision = 4
	)

	switch($From) {
		"Bytes" { $Size = $Size }
		"KB" { $Size = $Size * 1024 }
		"MB" { $Size = $Size * 1024 * 1024 }
		"GB" { $Size = $Size * 1024 * 1024 * 1024 }
		"TB" { $Size = $Size * 1024 * 1024 * 1024 * 1024 }
	}

	switch ($To) {
		"Bytes" { return $Size }
		"KB" { $Size = $Size/1KB }
		"MB" { $Size = $Size/1MB }
		"GB" { $Size = $Size/1GB }
		"TB" { $Size = $Size/1TB }
	}

	return [Math]::Round($Size, $Precision, [MidPointRounding]::AwayFromZero)
}

Function Test_Available_Disk
{
	param
	(
		[string]$Path
	)

	try {
		New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		$RandomGuid = [guid]::NewGuid()
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path $Path -ChildPath $test_tmp_filename -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename -PathType Leaf) {
			Remove-Item -Path $test_filename -ErrorAction SilentlyContinue
			return $true
		}
		$false
	} catch {
		return $false
	}
}

<#
	.Test if the URL address is available
	.测试 URL 地址是否可用
#>
Function Test_URI
{
	Param
	(
		[Parameter(Position=0,Mandatory,HelpMessage="HTTP or HTTPS")]
		[ValidatePattern( "^(http|https)://" )]
		[Alias("url")]
		[string]$URI,

		[Parameter(ParameterSetName="Detail")]
		[Switch]$Detail,

		[ValidateScript({$_ -ge 0})]
		[int]$Timeout = 30
	)

	Process
	{
		Try
		{
			$paramHash = @{
				UseBasicParsing = $True
				DisableKeepAlive = $True
				Uri = $uri
				Method = 'Head'
				ErrorAction = 'stop'
				TimeoutSec = $Timeout
			}
			$test = Invoke-WebRequest @paramHash

			if ($Detail) {
				$test.BaseResponse | Select-Object ResponseURI, ContentLength, ContentType, LastModified, @{
					Name = "Status";
					Expression = {
						$Test.StatusCode
					}
				}
			} else {
				if ($test.statuscode -ne 200) {
					$False
				} else {
					$True
				}
			}
		} Catch {
			write-verbose -message $_.exception
			if ($Detail) {
				$objProp = [ordered]@{
					ResponseURI = $uri
					ContentLength = $null
					ContentType = $null
					LastModified = $null
					Status = 404
				}

				New-Object -TypeName psobject -Property $objProp
			} else {
				$False
			}
		}
	}
}

Function Check_Folder
{
	Param
	(
		[string]$chkpath
	)

	if (Test-Path -Path $chkpath -PathType Container) {

	} else {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		if (Test-Path -Path $chkpath -PathType Container) {

		} else {
			write-host "`n  $($lang.FailedCreateFolder)"
			write-host "  $($chkpath)" -ForegroundColor Red
			return
		}
	}
}

Function Join_MainFolder
{
	param
	(
		[string]$Path
	)

	if ($Path.EndsWith('\')) {
		return $Path
	} else {
		return "$($Path)\"
	}
}

Function Install_Process
{
	param
	(
		$appname,
		$act,
		$mode,
		$todisk,
		$structure,
		$pwd,
		$url,
		$urlAMD64,
		$urlarm64,
		$filename,
		$param,
		$NewPS,
		$NewCmd
	)

	write-host "  $($lang.Installing) - $($appname)" -ForegroundColor Green

	switch ($Global:InstlArchitecture) {
		"arm64" {
			if ([string]::IsNullOrEmpty($urlarm64)) {
				if ([string]::IsNullOrEmpty($urlAMD64)) {
					if ([string]::IsNullOrEmpty($url)) {
						$FilenameTo = $urlAMD64
					} else {
						$url = $url
						$FilenameTo = $url
					}
				} else {
					$url = $urlAMD64
					$FilenameTo = $urlAMD64
				}
			} else {
				$url = $urlarm64
				$FilenameTo = $urlarm64
			}
		}
		"AMD64" {
			if ($Global:InstlArchitecture -eq "AMD64") {
				if ([string]::IsNullOrEmpty($urlAMD64)) {
					if ([string]::IsNullOrEmpty($url)) {
						$FilenameTo = $urlAMD64
					} else {
						$url = $url
						$FilenameTo = $url
					}
				} else {
					$url = $urlAMD64
					$FilenameTo = $urlAMD64
				}
			}
		}
		Default {
			if ($Global:InstlArchitecture -eq "x86") {
				if ([string]::IsNullOrEmpty($url)) {
					$FilenameTo = $urlAMD64
				} else {
					$url = $url
					$FilenameTo = $url
				}
			}
		}
	}

	$SaveToName = [IO.Path]::GetFileName($FilenameTo)
	$packer = [IO.Path]::GetFileNameWithoutExtension($FilenameTo)
	$types =  [IO.Path]::GetExtension($FilenameTo).Replace(".", "")

	Switch ($todisk)
	{
		auto
		{
			Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
				$TempRootPath = $_.Root
				$tempoutputfoldoer = Join-Path -Path $TempRootPath -ChildPath $structure

				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($filename)*$((Get-Culture).Name)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path $TempRootPath -ChildPath $structure
					$OutAny = $_.fullname
					break
				}

				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($filename)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path $TempRootPath -ChildPath $structure
					$OutAny = $_.fullname
					break
				}

				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($packer)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path $TempRootPath -ChildPath $structure
					$OutAny = $_.fullname
					break
				}
				$OutTo = Join-Path -Path $Global:FreeDiskTo -ChildPath $structure
				$OutAny = Join-Path -Path $Global:FreeDiskTo -ChildPath "$($structure)\$($SaveToName)"
			}
		}
		PSScriptRoot
		{
			$OutTo = Join-Path -Path $(Convert-Path -Path $PSScriptRoot) -ChildPath $structure
			$OutAny = Join-Path -Path $(Convert-Path -Path $PSScriptRoot) -ChildPath "$($structure)\$($SaveToName)"
			Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}

			Get-ChildItem -Path $OutTo -Filter "*$($filename)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}

			Get-ChildItem -Path $OutTo -Filter "*$($packer)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}
		}
		default
		{
			$OutTo = Join-Path -Path $todisk -ChildPath $structure
			$OutAny = Join-Path -Path $todisk -ChildPath "$($structure)\$($SaveToName)"
			Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}

			Get-ChildItem -Path $OutTo -Filter "*$($filename)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}

			Get-ChildItem -Path $OutTo -Filter "*$($packer)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $_.fullname
				break
			}
		}
	}

	Switch ($types)
	{
		zip
		{
			Switch ($act) {
				Install {
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "   - $($lang.LocallyExist): " -NoNewline -ForegroundColor Yellow
						Write-Host $_.fullname -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "   - $($lang.LocallyExist): " -NoNewline -ForegroundColor Yellow
						Write-Host $_.fullname -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "  - $($lang.LocallyExist): " -NoNewline -ForegroundColor Yellow
						Write-Host $_.fullname -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
					if (Test-Path $OutAny) {
						write-host "   - $($lang.ExistingPacker)"
					} else {
						write-host "   * $($lang.StartDown)"
						if ([string]::IsNullOrEmpty($url)) {
							write-host "   - $($lang.DownloadLinkError)" -ForegroundColor Red
						} else {
							if (Test_URI $url) {
								write-host "    > $($lang.ConnectTo)" -ForegroundColor Yellow
								write-host "      $($url)" -ForegroundColor Green
								write-host
								write-host "    + $($lang.SaveTo)" -ForegroundColor Yellow
								write-host "      $($OutAny)" -ForegroundColor Green

								Check_Folder -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								write-host "     - $($lang.UpdateUnavailable)" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						write-host "   - $($lang.Unpacking)".PadRight(28) -NoNewline

						Archive -Password $pwd -filename $OutAny -to $OutTo
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						write-host "     - $($lang.ErrorDown)`n" -ForegroundColor Red
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "   - $($lang.LocallyExist): " -ForegroundColor Yellow
						write-host "     $($_.fullname)" -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "   - $($lang.LocallyExist): " -ForegroundColor Yellow
						write-host "     $($_.fullname)" -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						write-host "   - $($lang.LocallyExist): " -ForegroundColor Yellow
						write-host "     $($_.fullname)" -ForegroundColor Green
						Write-Host

						Open_Apps -filename $_.fullname -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
						break
					}
				}
				NoInst {
					if (Test-Path $OutAny) {
						write-host "   - $($lang.ItInstalled)`n"
					} else {
						write-host "   * $($lang.StartDown)"
						if ([string]::IsNullOrEmpty($url)) {
							write-host "     - $($lang.DownloadLinkError)" -ForegroundColor Red
						} else {
							if (Test_URI $url) {
								write-host "    > $($lang.ConnectTo)" -ForegroundColor Yellow
								write-host "      $($url)" -ForegroundColor Green
								write-host
								write-host "    + $($lang.SaveTo)" -ForegroundColor Yellow
								write-host "      $($OutAny)" -ForegroundColor Green

								Check_Folder -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								write-host "     - $($lang.UpdateUnavailable)`n" -ForegroundColor Red
							}
						}
					}
				}
				To {
					$newoutputfoldoer = "$($OutTo)\$($packer)"
					if (Test-Path $newoutputfoldoer -PathType Container) {
						write-host "   - $($lang.ItInstalled)`n"
						break
					}
					if (Test-Path $OutAny) {
						write-host "   - $($lang.ExistingInstlPacker)"
					} else {
						write-host "   * $($lang.StartDown)"
						if ([string]::IsNullOrEmpty($url)) {
							write-host "     - $($lang.DownloadLinkError)" -ForegroundColor Red
						} else {
							write-host "    > $($lang.ConnectTo)" -ForegroundColor Yellow
							write-host "      $($url)" -ForegroundColor Green
							write-host
							write-host "    + $($lang.SaveTo)" -ForegroundColor Yellow
							write-host "      $($OutAny)" -ForegroundColor Green

							Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						}
					}
					if (Test-Path $OutAny) {
						write-host "   - $($lang.OnlyUnzip)".PadRight(28) -NoNewline
						Archive -Password $pwd -filename $OutAny -to $newoutputfoldoer
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						write-host "     - $($lang.ErrorDown)`n" -ForegroundColor Red
					}
				}
				Unzip {
					if (Test-Path $OutAny) {
						write-host "   - $($lang.ExistingPacker)"
					} else {
						write-host "   * $($lang.StartDown)"
						if ([string]::IsNullOrEmpty($url)) {
							write-host "     - $($lang.DownloadLinkError)" -ForegroundColor Red
						} else {
							if (Test_URI $url) {
								write-host "    > $($lang.ConnectTo)" -ForegroundColor Yellow
								write-host "      $($url)" -ForegroundColor Green
								write-host
								write-host "    + $($lang.SaveTo)" -ForegroundColor Yellow
								write-host "      $($OutAny)" -ForegroundColor Green

								Check_Folder -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								write-host "     - $($lang.UpdateUnavailable)`n" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						write-host "   - $($lang.OnlyUnzip)".PadRight(28) -NoNewline
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						write-host "     - $($lang.ErrorDown)`n" -ForegroundColor Red
					}
				}
			}
		}
		default {
			if (Test-Path $OutAny -PathType Leaf) {
				Open_Apps -filename $OutAny -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
			} else {
				write-host "   * $($lang.StartDown)"
				if ([string]::IsNullOrEmpty($url)) {
					write-host "     - $($lang.DownloadLinkError)`n" -ForegroundColor Red
				} else {
					write-host "    > $($lang.ConnectTo)" -ForegroundColor Yellow
					write-host "      $($url)" -ForegroundColor Green

					if (Test_URI $url) {
						write-host
						write-host "    + $($lang.SaveTo)" -ForegroundColor Yellow
						write-host "      $($OutAny)`n" -ForegroundColor Green

						Check_Folder -chkpath $OutTo
						Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						Open_Apps -filename $OutAny -param $param -mode $mode -NewPS $NewPS -NewCmd $NewCmd
					} else {
						write-host "     - $($lang.UpdateUnavailable)`n" -ForegroundColor Red
					}
				}
			}
		}
	}
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

Function Get_Zip
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\7-Zip\$($Run)"
		"${env:ProgramFiles(x86)}\7-Zip\$($Run)"
		"$(Get_Arch_Path -Path "$($PSScriptRoot)\7zPacker")\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
}

Function Archive
{
	param
	(
		$Password,
		$filename,
		$to
	)

	$filename = Convert-Path -Path $filename -ErrorAction SilentlyContinue

	if (Test-Path -Path $to -PathType Container) {
		$to = Convert-Path -Path $to -ErrorAction SilentlyContinue
	}

	write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $filename -ForegroundColor Green

	write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $to -ForegroundColor Green

	write-host "  $($lang.Unpacking)".PadRight(28) -NoNewline

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		if (([string]::IsNullOrEmpty($Password))) {
			$arguments = @(
				"x",
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		} else {
			$arguments = @(
				"x",
				"-p$($Password)"
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		}

		Write-Host $lang.Done -ForegroundColor Green
	} else {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host $lang.Done -ForegroundColor Green
	}

	Write-Host
}

Function Wait_Process_End
{
	write-host "`n  $($lang.WaitQueue)" -ForegroundColor Green
	if ($Script:AppQueue.Count -gt 0) {
		foreach ($item in $Script:AppQueue) {
			write-host "   * PID: $($item.ID)".PadRight(22) -NoNewline

			while ($true) {
				if ((Get-Process -ID $item.ID -ErrorAction SilentlyContinue).Path -eq $item.Path) {
					Start-Sleep -s 2
				} else {
					Write-Host $lang.Done -ForegroundColor Yellow

					write-host "`n     $($lang.PSFunction)" -ForegroundColor Yellow
					write-host "     $('-' * 76)"
					if ($item.PS.Count -gt 0) {
						$SNTasks = 0
						foreach ($itemPS in $item.PS) {
							$SNTasks++
							write-host "     $($SNTasks)/$($item.PS.Count) $($itemPS)" -ForegroundColor Green
							Invoke-Expression -Command $itemPS
							write-host "     $($SNTasks)/$($item.Cmd.Count) $($itemPS) < $($lang.Done)`n" -ForegroundColor Green
						}
					} else {
						write-host "     $($lang.NoWork)" -ForegroundColor Red
					}

					write-host
					write-host "     $($lang.Command)" -ForegroundColor Yellow
					write-host "     $('-' * 76)"
					if ($item.Cmd.Count -gt 0) {
						$SNTasks = 0
						foreach ($itemCmd in $item.Cmd) {
							$SNTasks++
							write-host "     $($SNTasks)/$($item.Cmd.Count) $($itemCmd)" -ForegroundColor Green
							Invoke-Expression $itemCmd
							write-host "     $($SNTasks)/$($item.Cmd.Count) $($itemCmd) < $($lang.Done)`n" -ForegroundColor Green
						}
					} else {
						write-host "     $($lang.NoWork)" -ForegroundColor Red
					}
					break
				}
			}
		}
	} else {
		write-host "  $($lang.NoWork)" -ForegroundColor Red
	}

	$Script:AppQueue = @()
}

Function Open_Apps
{
	param
	(
		$filename,
		$param,
		$mode,
		$NewPS,
		$NewCmd
	)

	if (Test-Path $filename -PathType Leaf) {
		Switch ($mode) {
			"Fast" {
				if ([string]::IsNullOrEmpty($param)) {
					write-host "   - $($lang.QucikRun)" -ForegroundColor Yellow
					write-host "     $($filename)`n" -ForegroundColor Green

					Start-Process -FilePath $filename
				} else {
					write-host "   - $($lang.QucikRun)" -ForegroundColor Yellow
					write-host "     $($filename)" -ForegroundColor Green

					write-host "`n  - $($lang.Parameter)" -ForegroundColor Yellow
					write-host "     $($param)`n" -ForegroundColor Green

					Start-Process -FilePath $filename -ArgumentList $param
				}
			}
			"Wait" {
				if ([string]::IsNullOrEmpty($param)) {
					write-host "   - $($lang.WaitDone)" -ForegroundColor Yellow
					write-host "     $($filename)`n" -ForegroundColor Green
					Start-Process -FilePath $filename -Wait
				} else {
					write-host "   - $($lang.WaitDone)" -ForegroundColor Yellow
					write-host "     $($filename)" -ForegroundColor Green

					write-host "`n  - $($lang.Parameter)" -ForegroundColor Yellow
					write-host "     $($param)`n" -ForegroundColor Green

					Start-Process -FilePath $filename -ArgumentList $param -Wait
				}
			}
			"Queue" {
				write-host "   - $($lang.QucikRun)" -ForegroundColor Yellow
				write-host "     $($filename)" -ForegroundColor Green

				if ([string]::IsNullOrEmpty($param)) {
					$AppRunQueue = Start-Process -FilePath $filename -passthru
					$Script:AppQueue += [pscustomobject]@{
						ID   = $AppRunQueue.Id;
						PATH = $filename;
						PS   = $NewPS;
						Cmd  = $NewCmd
					}

					write-host "   - $($lang.AddQueue)" -NoNewline -ForegroundColor Yellow
					Write-Host $AppRunQueue.Id -ForegroundColor Green

					Write-Host
				} else {
					$AppRunQueue = Start-Process -FilePath $filename -ArgumentList $param -passthru
					$Script:AppQueue += [pscustomobject]@{
						ID   = $AppRunQueue.Id;
						PATH = $filename;
						PS   = $NewPS;
						Cmd  = $NewCmd
					}

					write-host "`n  - $($lang.Parameter)" -ForegroundColor Yellow
					write-host "    $($param)" -ForegroundColor Green

					write-host "`n  - $($lang.PSFunction)" -ForegroundColor Yellow
					if ($NewPS.Count -gt 0) {
						foreach ($psitem in $NewPS) {
							write-host "    $($psitem)" -ForegroundColor Green
						}
					} else {
						write-host "    $($lang.NoWork)" -ForegroundColor Red
					}

					write-host "`n  - $($lang.Command)" -ForegroundColor Yellow
					if ($NewCmd.Count -gt 0) {
						foreach ($cmditem in $NewCmd) {
							write-host "    $($cmditem)" -ForegroundColor Green
						}
					} else {
						write-host "    $($lang.NoWork)" -ForegroundColor Red
					}

					write-host "`n  - $($lang.AddQueue)" -NoNewline -ForegroundColor Yellow
					Write-Host $AppRunQueue.Id -ForegroundColor Green

					Write-Host
				}
			}
		}
	} else {
		write-host "   - $($lang.InstlNo)" -ForegroundColor Yellow
		write-host "     $($filename)" -ForegroundColor Red
	}
}

Function ToMainpage
{
	param
	(
		[int]$wait
	)
	write-host "  $($lang.ToQuit -f $wait)" -ForegroundColor Red
	Start-Sleep -s $wait
	exit
}

Function Install_Start_Process
{
	write-host "`n  $($lang.Instllsoftwareing) ( $($Script:Install_App.Count) )" -ForegroundColor Yellow
	write-host "  $('-' * 80)"
	if ($Script:Install_App.Count -gt 0) {
		foreach ($item in $Script:Install_App) {
			Install_Process -appname $item.Name -act $item.Action -mode $item.Manner -todisk $item.DLetter -structure $item.Structure -pwd $item.Unpwd -url $item.url.x86 -urlAMD64 $item.url.x64 -urlarm64 $item.url.arm64 -filename $item.FindFile -param $item.param -NewPS $item.PS -NewCmd $item.Command
		}

		Wait_Process_End
	} else {
		write-host "  $($lang.InstllUnavailable)" -ForegroundColor Red
	}
}

<#
	.Update interface
	.更新界面
#>
Function Update_Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.UpdateList
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}
	$GUIUpdateAuto     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 505
		Text           = $lang.UpdateServerSelect
		Location       = '10,6'
		Checked        = $True
		add_Click      = {
			if ($GUIUpdateAuto.Checked) {
				$UI_Main_Menu.Enabled = $False
			} else {
				$UI_Main_Menu.Enabled = $True
			}
		}
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 415
		Width          = 530
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "24,0,8,0"
		Dock           = 0
		Location       = "0,28"
		Enabled        = $False
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "10,570"
		Height         = 22
		Width          = 490
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$Script:ServerList = @()

			if ($GUIUpdateAuto.Checked) {
				$UI_Main.Hide()
				ForEach ($item in $Script:ServerListSelect | Sort-Object { Get-Random } ) {
					$Script:ServerList += $item
				}
			
				Update_Process
				$UI_Main.Close()
			} else {
				$UI_Main_Menu.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Checked) {
							$Script:ServerList += $_.Tag
						}
					}
				}
			
				if ($Script:ServerList.Count -gt 0) {
					$UI_Main.Hide()
					Update_Process
					$UI_Main.Close()
				} else {
					$UI_Main_Error.Text = $lang.UpdateServerNoSelect
				}
			}
		}
	}
	$UI_Main_Canel    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Text           = $lang.Cancel
		Location       = "268,635"
		add_Click      = {
			$UI_Main.Hide()
			$Script:ServerList = @()
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$GUIUpdateAuto,
		$UI_Main_Menu,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	ForEach ($item in $Script:ServerListSelect) {
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height  = 35
			Width   = 395
			Text    = $item
			Tag     = $item
			Checked = $true
		}

		$UI_Main_Menu.controls.AddRange($CheckBox)
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_MainMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_MainMenu.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_MainMenu.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_MainMenu

	$UI_Main.ShowDialog() | Out-Null
}

Function Refresh_Server_List
{
	ForEach ($item in $Update_Server) {
		if ($Global:IsLang -eq $item.Region) {
			ForEach ($itemLink in $item.Link) {
				$Script:ServerListSelect += $itemLink
			}

			break
		}

		if ($Global:IsLang -eq "en-US") {
			ForEach ($itemLink in $item.Link) {
				$Script:ServerListSelect += $itemLink
			}

			break
		}
	}
}

<#
	.Update process
	.更新处理
#>
Function Update_Process
{
	<#
		.Disabled IE first-launch configuration
		.禁用 IE 首次启动配置
	#>
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2 -ErrorAction SilentlyContinue

	write-host "`n  $($lang.UpdateCheckServerStatus -f $Script:ServerList.Count)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	ForEach ($item in $Script:ServerList) {
		write-host "  * $($lang.UpdateServerAddress): " -NoNewline -ForegroundColor Yellow
		Write-Host $item -ForegroundColor Green

		if (Test_URI $item) {
			$ServerTest = $true
			$url = $item
			write-host "    $($lang.UpdateAvailable)" -ForegroundColor Green
			break
		} else {
			write-host "    $($lang.UpdateUnavailable)`n" -ForegroundColor Red
		}
	}

	if ($ServerTest) {
		write-host "  $('-' * 80)"
		write-host "    $($lang.UpdatePriority)" -ForegroundColor Green

		write-host "`n  $($lang.UpdateQueryingUpdate)"

		$RandomGuid = [guid]::NewGuid()
		$output = "$(Convert-Path -Path $PSScriptRoot -ErrorAction SilentlyContinue)\$($RandomGuid).json"

		New-Item -Path "$(Convert-Path -Path $PSScriptRoot -ErrorAction SilentlyContinue)\$($Global:IsLang)" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
	
		$start_time = Get-Date
		remove-item -path $output -force -ErrorAction SilentlyContinue
		Invoke-WebRequest -Uri $url -OutFile $output -TimeoutSec 30 -DisableKeepAlive -ErrorAction SilentlyContinue | Out-Null
		write-host "`n  $($lang.UpdateTimeUsed): $((Get-Date).Subtract($start_time).Seconds) (s)`n"
		
		if (Test-Path -Path $output -PathType Leaf) {
			write-host "  $($lang.VerifyConfig)"

			try {
				$Custom_Config = Get-Content -Path $output | ConvertFrom-JSON
				Remove-Item -Path $Script:Init_Config -ErrorAction SilentlyContinue
				Move-Item $output $Script:Init_Config -Force -ErrorAction SilentlyContinue

				if (Test-Path -Path $Script:Init_Config -PathType Leaf) {
					write-host "  $($lang.Done)" -ForegroundColor Green
				} else {
					write-host "  $($lang.UpdateFailedConfig)" -ForegroundColor Red
				}
			} catch {
				write-host "  $($lang.ConfigError)" -ForegroundColor Red
			}
		} else {
			write-host "  $($lang.DownloadFailed)" -ForegroundColor Red
		}
	} else {
		write-host "    $($lang.UpdateServerTestFailed)" -ForegroundColor Red
		write-host "  $('-' * 80)"

		$output = Join-Path -Path $(Convert-Path -Path $PSScriptRoot) -ChildPath "Backup\$($Global:IsLang)\latest.json"
		write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
		write-host "  $('-' * 80)"

		write-host "  $($output)" -ForegroundColor Yellow
		write-host "  $($lang.SetDefault)" -ForegroundColor Green

		if (Test-Path -Path $output -PathType Leaf) {
			write-host "`n  $($lang.VerifyConfig)"

			try {
				$Custom_Config = Get-Content -Path $output | ConvertFrom-JSON

				$Script:Init_Config = $output

				if (Test-Path -Path $Script:Init_Config -PathType Leaf) {
					write-host "  $($lang.Done)" -ForegroundColor Green
				} else {
					write-host "  $($lang.UpdateFailedConfig)" -ForegroundColor Red
				}
			} catch {
				write-host "  $($lang.ConfigError)" -ForegroundColor Red
			}
		} else {
			write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"
			write-host "  $($output)" -ForegroundColor Green

			write-host "  $($lang.NoInstallImage)"
			return
		}
	}
}

Function Install_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	function Instl_Save
	{
		$Match_Wait_App = @()

		<#
			.获取用户是否选择了软件
		#>
		$Select_App.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Checked) {
					$Match_Wait_App += $_.Tag
				}
			}
		}

		if ($Match_Wait_App.Count -gt 0) {
		} else {
			$UI_Main_Error.Text = $lang.ChoseSoftwareNot
			return $False
		}

		<#
			.从配置文件里获取软件匹配
		#>
		$Script:Install_App = @()
		$Custom_Config = Get-Content -Path $Script:Init_Config | ConvertFrom-JSON
		foreach ($item in $Custom_Config) {
			if ($item.App.app.Count -gt 0) {
				foreach ($itemApp in $item.App.app) {
					if (($Match_Wait_App -Contains $itemApp.Name) -or
						($Match_Wait_App -Contains $itemApp.GUID))
					{
						$Script:Install_App += [pscustomobject]@{
							GUID      = $itemApp.GUID;
							Name      = $itemApp.name;
							Action    = $itemApp.Action;
							Manner    = $itemApp.Manner;
							DLetter   = $itemApp.DLetter;
							Structure = $itemApp.Structure;
							Unpwd     = $itemApp.Unpwd;
							Url       = $itemApp.url;
							FindFile  = $itemApp.FindFile;
							param     = $itemApp.param;
							PS        = $itemApp.PS;
							Command   = $itemApp.Command
						}
					}
				}
			}
		}

		if ($Script:Install_App.Count -gt 0) {
			$UI_Main.Hide()
			Install_Start_Process
			$UI_Main.Close()
			return $True
		} else {
			$UI_Main_Error.Text = $lang.InstllUnavailable
			return $False
		}
	}

	Function Setting_Init_Disk_To
	{
		$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskTo" -ErrorAction SilentlyContinue

		$FormSelectDiSKPane1.controls.Clear()
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			if (Test_Available_Disk -Path $_.Root) {
				$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 30
					Width     = 418
					Text      = $_.Root
					Tag       = $_.Description
				}

				if ($_.Root -eq $GetDiskTo) {
					$RadioButton.Checked = $True
				}

				if ($FormSelectDiSKLowSize.Checked) {
					if (-not (Verify_Available_Size -Disk $_.Root -Size $SelectLowSize.Text)) {
						$RadioButton.Enabled = $False
					}
				}
				$FormSelectDiSKPane1.controls.AddRange($RadioButton)
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 825
		Text           = $lang.Instl
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 550
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = 8
		Dock           = 3
	}
	$Select_Group_Value = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 435
		Padding        = 8
		Text           = $lang.ChoseClass
	}
	$Select_Group      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		AutoSize       = 1
		autoSizeMode   = 1
		BorderStyle    = 0
		autoScroll     = $False
		Padding        = 8
		margin         = "28,0,0,15"
	}
	$Select_App_Value  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 435
		Padding        = 8
		Text           = $lang.ChoseInstall
	}
	$Select_App        = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		AutoSize       = 1
		autoSizeMode   = 1
		BorderStyle    = 0
		autoScroll     = $False
		Padding        = 8
		margin         = "22,0,0,0"
	}
	$Setting           = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,10"
		Height         = 36
		Width          = 220
		Text           = $lang.Setting
		add_Click      = {
			$UIUnzipPanel.visible = $True
		}
	}
	$UIUpdateConfig    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,50"
		Height         = 36
		Width          = 220
		Text           = $lang.UpdateList
		add_Click      = {
			$UI_Main.Hide()
			Update_Setting_UI
			$UI_Main.Close()

			Install_UI
		}
	}
	$UI_Main_Refresh_Sources = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,90"
		Height         = 36
		Width          = 220
		add_Click      = { Refresh_Select_Group }
		Text           = $lang.Refresh
	}

	<#
		蒙板：设置
	#>
	$UIUnzipPanel      = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 678
		Width          = 1006
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,0'
		Visible        = $False
	}
	<#
		.搜索 ISO 来源，显示菜单
	#>
	$UIUnzipPanel_Menu = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 650
		Width          = 550
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Dock           = 3
		Padding        = "8,16,8,0"
	}

	$ArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 470
		Text           = $lang.PreDownLink
	}
	$GroupArchitecture = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autoSizeMode   = 1
		Height         = 30
		Width          = 470
		Padding        = "20,0,0,0"
	}
	$ArchitectureARM64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		margin         = "0,0,20,0"
		Text           = "arm64"
		add_Click      = {
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsArm64
		}
	}
	$ArchitectureAMD64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		margin         = "0,0,20,0"
		Text           = "x64"
		add_Click      = {
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsAMD64
		}
	}
	$ArchitectureX86   = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		margin         = "0,0,20,0"
		Text           = "x86"
		add_Click      = {
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsX86
		}
	}
	$SoftwareTips      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 45
		Width          = 470
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Padding        = "31,0,8,0"
	}
	$SoftwareTipsUIUnzipPanelErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = ""
	}
	$FormSelectDiSKSize = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 470
		Text           = $lang.SelectAutoAvailable
		Location       = '10,115'
	}
	$FormSelectDiSKLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 25
		Width          = 470
		Text           = $lang.SelectCheckAvailable
		Padding        = "26,0,0,0"
		add_Click      = {
			if ($FormSelectDiSKLowSize.Checked) {
				$SelectLowSize.Enabled = $True
				Setting_Set_Disk_Available -Status "True"
			} else {
				$SelectLowSize.Enabled = $False
				Setting_Set_Disk_Available -Status "False"
			}
			Setting_Init_Disk_To
		}
	}
	$SelectLowSize     = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 22
		Width          = 60
		margin         = "46,0,5,0"
		Value          = 1
		Minimum        = 1
		Maximum        = 999999
		TextAlign      = 1
		add_Click      = {
			Setting_Set_Disk_Free -Size $SelectLowSize.Text
			Setting_Init_Disk_To
		}
	}
	$SelectLowUnit     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 80
		Text           = "GB"
		Location       = "115,168"
	}
	$FormSelectDiSKTitle = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 470
		margin         = "28,25,0,0"
		Text           = $lang.SettingDiskNewPath
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { Setting_Init_Disk_To }
	}
	$FormSelectDiSKPane1 = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 400
		Width          = 470
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "26,0,8,0"
	}

	$UIUnzipPanelErrorMsg = New-Object System.Windows.Forms.RichTextBox -Property @{
		Height         = 275
		Width          = 220
		Location       = "575,210"
		BorderStyle    = 0
		Text           = ""
		BackColor      = "#FFFFFF"
		ReadOnly       = $True
	}
	$UIUnzipPanelOK    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,595"
		Height         = 36
		Width          = 220
		Text           = $lang.OK
		add_Click      = {
			if ($ArchitectureARM64.Checked) { Set_Architecture -Type "ARM64" }
			if ($ArchitectureAMD64.Checked) { Set_Architecture -Type "AMD64" }
			if ($ArchitectureX86.Checked) { Set_Architecture -Type "x86" }

			$init_Select_In = ""
			$FormSelectDiSKPane1.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							$init_Select_In = $_.Text
						}
					}
				}
			}

			if ([string]::IsNullOrEmpty($init_Select_In)) {
				$UIUnzipPanelErrorMsg.Text = $lang.SelectNoDisk
			} else {
				SetNewFreeDiskTo -Disk $init_Select_In
				$UIUnzipPanel.visible = $False
			}
		}
	}
	$UIUnzipPanelCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,635"
		Height         = 36
		Width          = 220
		Text           = $lang.Cancel
		add_Click      = {
			$UIUnzipPanel.visible = $False
		}
	}

	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Location       = "575,510"
		Height         = 80
		Width          = 220
		Text           = ""
	}
	$UI_Main_Ok        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,595"
		Height         = 36
		Width          = 220
		Text           = $lang.OK
		add_Click      = {
			if (Instl_Save) {

			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "575,635"
		Height         = 36
		Width          = 220
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UIUnzipPanel,
		$UI_Main_Menu,
		$AllSel,
		$AllClear,
		$Setting,
		$UI_Main_Refresh_Sources,
		$UIUpdateConfig,
		$UI_Main_Error,
		$UI_Main_Ok,
		$UI_Main_Canel
	))

	$UI_Main_Menu.controls.AddRange((
		$Select_Group_Value,
		$Select_Group,
		$Select_App_Value,
		$Select_App
	))

	<#
		.蒙板：设置，添加控件区域
	#>
	$UIUnzipPanel.controls.AddRange((
		$UIUnzipPanel_Menu,
		<#
			搜索按钮
		#>
		$UIUnzipPanelErrorMsg,
		$UIUnzipPanelOK,
		$UIUnzipPanelCanel
	))
	$UIUnzipPanel_Menu.controls.AddRange((
		$ArchitectureTitle,
		$GroupArchitecture,
		$SoftwareTips,
		$FormSelectDiSKSize,
		$FormSelectDiSKLowSize,
		$SelectLowSize,
		$SelectLowUnit,
		$FormSelectDiSKTitle,
		$FormSelectDiSKPane1
	))
	$SoftwareTips.controls.AddRange((
		$SoftwareTipsUIUnzipPanelErrorMsg
	))
	$GroupArchitecture.controls.AddRange((
		$ArchitectureARM64,
		$ArchitectureAMD64,
		$ArchitectureX86
	))

	switch ($Global:InstlArchitecture) {
		"ARM64" {
			$ArchitectureARM64.Checked = $True
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsArm64
		}
		"AMD64" {
			if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
				$ArchitectureARM64.Enabled = $True
			} else {
				$ArchitectureARM64.Enabled = $False
			}

			$ArchitectureAMD64.Checked = $True
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsAMD64
		}
		Default {
			if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
				$ArchitectureARM64.Enabled = $True
			} else {
				$ArchitectureARM64.Enabled = $False
			}

			if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
				$ArchitectureAMD64.Enabled = $True
			} else {
				$ArchitectureAMD64.Enabled = $False
			}

			$ArchitectureX86.Checked = $True
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.SolutionsTipsX86
		}
	}

	Function Refres_Sources_Config
	{
		$UI_Main_Error.Text = ""
		if (Test-Path -Path $Script:Init_Config -PathType leaf) {
			$Script:Install_App = @()
			$Script:Custom_Config = Get-Content -Path $Script:Init_Config | ConvertFrom-JSON

			foreach ($item in $Script:Custom_Config.App) {
				$CheckBox    = New-Object System.Windows.Forms.Checkbox -Property @{
					autoSize = 1
					Text     = $item.Group
					Checked  = $True
					margin   = "0,0,25,15"
					add_Click = { Refresh_Select_Group }
				}
				$Select_Group.controls.AddRange($CheckBox)
			}

			Refresh_Select_Group
		} else {
			$SoftwareTipsUIUnzipPanelErrorMsg.Text = $lang.NoInstallImage
		}
	}

	Function Refresh_Select_Group
	{
		$UI_Main_Error.Text = ""
		$Select_App.controls.Clear()
		$Script:Init_Select_Value = @()
		$Select_Group.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$Script:Init_Select_Value += $_.Text
					}
				}
			}
		}

		if ($Script:Init_Select_Value.Count -gt 0) {
			Refresh_Select_Item
		} else {
			$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
				Height   = 35
				Width    = 470
				Text     = $lang.ChoseClassNo
			}
			$Select_App.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
			return
		}
	}

	Function Refresh_Select_Item
	{
		$init_Select_Default_App = $Script:Custom_Config.Config.DefaultSelect

		foreach ($item in $Script:Custom_Config.App) {
			if ($Script:Init_Select_Value -Contains $item.Group) {
				$Temp_Main_Save_Expand_Name = New-Object system.Windows.Forms.Label -Property @{
					Height         = 30
					Width          = 470
					Text           = $item.Group
				}
				$Select_App.controls.AddRange($Temp_Main_Save_Expand_Name)

				if ($item.app.Count -gt 0) {
					if ($item.app.Count -gt 0) {
						foreach ($itemApp in $item.app) {
							$CheckBox    = New-Object System.Windows.Forms.Checkbox -Property @{
								Height   = 30
								Width    = 470
								Padding  = "20,0,0,0"
								Text     = $itemApp.name
								Tag      = $itemApp.GUID
							}

							if (($init_Select_Default_App -Contains $itemApp.Name) -or
								($init_Select_Default_App -Contains $itemApp.GUID))
							{
								$CheckBox.Checked = $True
							}

							$Select_App.controls.AddRange($CheckBox)
						}

						$UI_Expand_Wrap = New-Object system.Windows.Forms.Label -Property @{
							Height         = 30
							Width          = 470
						}
						$Select_App.controls.AddRange($UI_Expand_Wrap)
					} else {
						$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
							Height   = 30
							Width    = 470
							Padding  = "20,0,0,0"
							Text     = $lang.AppNo
						}
						$Select_App.controls.AddRange($UI_Main_Pre_Rule_Not_Find)
					}
				} else {
					$UI_Main_Pre_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
						Height   = 30
						Width    = 470
						Padding  = "20,0,0,0"
						Text     = $lang.AppNo
					}

					$UI_Expand_Wrap = New-Object system.Windows.Forms.Label -Property @{
						Height         = 30
						Width          = 465
					}
					$Select_App.controls.AddRange((
						$UI_Main_Pre_Rule_Not_Find,
						$UI_Expand_Wrap
					))
				}
			}
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue) {
		$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue
		$SelectLowSize.Text = $GetDiskMinSize
	} else {
		Setting_Set_Disk_Free -Size $Script:DiskMinSize
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
			"True" {
				$FormSelectDiSKLowSize.Checked = $True
				$SelectLowSize.Enabled = $True
			}
			"False" {
				$FormSelectDiSKLowSize.Checked = $False
				$SelectLowSize.Enabled = $False
			}
		}
	} else {
		$FormSelectDiSKLowSize.Checked = $True
		$SelectLowSize.Enabled = $True
	}

	Setting_Init_Disk_To
	Refres_Sources_Config

	<#
		.右键菜单：选择标签
	#>
	$SelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$SelectMenu.Items.Add($lang.AllSel).add_Click({
		$Select_Group.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $true }
		}

		Refresh_Select_Group
	})
	$SelectMenu.Items.Add($lang.AllClear).add_Click({
		$Select_Group.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $false }
		}

		Refresh_Select_Group
	})
	$Select_Group.ContextMenuStrip = $SelectMenu

	<#
		.右键菜单：选择所有应用
	#>
	$SelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$SelectMenu.Items.Add($lang.AllSel).add_Click({
		$Select_App.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $true }
		}
	})
	$SelectMenu.Items.Add($lang.AllClear).add_Click({
		$Select_App.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $false }
		}
	})
	$Select_App.ContextMenuStrip = $SelectMenu

	if ($Silent) {
		if (Instl_Save) {

		} else {
			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

<#
	.自定义 PowerShell 函数功能，对接 配置文件
#>
Function Set_WiFi
{
	param(
		[string]$SSID,
		[string]$PSK
	)

	Get-Service -Name WlanSvc | Start-Service
	Write-Output "WiFi Profile Setup"
	Write-Output "WLANSvc Status"
	Get-Service -Name WlanSvc
	$WirelessAdapters = Get-NetAdapter | Where-Object {($_.PhysicalMediaType -eq 'Native 802.11') -or ($_.PhysicalMediaType -eq 'Wireless LAN')}
	Write-Output "Wireless Adapters: $($WirelessAdapters.InterfaceDescription)"
	Write-Output ""

	if ($WirelessAdapters){
		Write-Output "Setting WiFi Profile"
		Set_WiFi_User_profiles -SSID $SSID -PSK $PSK
	} else {
		Write-Output "NO WiFi Adapters Found to set"
	}
}

Function Set_WiFi_User_profiles
{
	param(
		[string]$SSID,
		[string]$PSK
	)

	$guid = [guid]::NewGuid()
	$HexArray = $ssid.ToCharArray() | foreach-object { [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($_)) }
	$HexSSID = $HexArray -join ""
@"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
	<name>$($SSID)</name>
	<SSIDConfig>
		<SSID>
			<hex>$($HexSSID)</hex>
			<name>$($SSID)</name>
		</SSID>
	</SSIDConfig>
	<connectionType>ESS</connectionType>
	<connectionMode>auto</connectionMode>
	<MSM>
		<security>
			<authEncryption>
				<authentication>WPA2PSK</authentication>
				<encryption>AES</encryption>
				<useOneX>false</useOneX>
			</authEncryption>
			<sharedKey>
				<keyType>passPhrase</keyType>
				<protected>false</protected>
				<keyMaterial>$($PSK)</keyMaterial>
			</sharedKey>
		</security>
	</MSM>
	<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
		<enableRandomization>false</enableRandomization>
		<randomizationSeed>1451755948</randomizationSeed>
	</MacRandomization>
</WLANProfile>
"@ | out-file "$($ENV:TEMP)\$guid.SSID"

	netsh wlan add profile filename="$($ENV:TEMP)\$guid.SSID" user=all
	remove-item "$($ENV:TEMP)\$guid.SSID" -Force
}

Function Mainpage
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = $lang.Instl

	write-host "`n  Author: Yi ( https://fengyi.tel )

  From: Yi's Solutions
  buildstring: 1.0.0.2.yi_release.2026.1.1

  $($lang.Instl)"
	write-host "  $('-' * 80)"
}

Function Refresh_Match
{
	param
	(
		[string[]]$MatchApp
	)

	$Script:Install_App = @()

	$Custom_Config = Get-Content -Path $Script:Init_Config | ConvertFrom-JSON
	foreach ($item in $Custom_Config) {
		if ($item.App.App.Count -gt 0) {
			foreach ($itemApp in $item.App.app) {
				if (($MatchApp -Contains $itemApp.Name) -or
					($MatchApp -Contains $itemApp.GUID))
				{
					$Script:Install_App += [pscustomobject]@{
						GUID      = $itemApp.GUID;
						Name      = $itemApp.name;
						Action    = $itemApp.Action;
						Manner    = $itemApp.Manner;
						DLetter   = $itemApp.DLetter;
						Structure = $itemApp.Structure;
						Unpwd     = $itemApp.Unpwd;
						Url       = $itemApp.url;
						FindFile  = $itemApp.FindFile;
						param     = $itemApp.param;
						PS        = $itemApp.PS;
						Command   = $itemApp.Command
					}
				}
			}
		}
	}
}

<#
	.Set language pack, usage:
	 Language                  | Language selected by the user
	 Language -NewLang "zh-CN" | Mandatory use of specified language
#>
if ($Language) {
	Language -NewLang $Language
} else {
	Language
}

<#
	.初始化默认配置文件
#>
$Script:Init_Config = Join-Path -Path $(Convert-Path -Path $PSScriptRoot) -ChildPath "$($Global:IsLang)\latest.json"

Get_Architecture
Setting_Init_Disk_Free
Setting_Init_Disk_Available
Install_Init_Disk_To
Refresh_Server_List
Mainpage

<#
	.配置文件
	 -Config "Yi.json"
	
	.安装软件名
	 -App "Google Chrome", "QQ"
#>
if ($App) {
	ForEach ($item in $app) {
		write-host "  $($item)" -ForegroundColor Green
	}

	if ($Config) {
		write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "  $($config)" -ForegroundColor Yellow

		if (Test-Path -Path $config -PathType leaf) {
			$Script:Init_Config = $Config
			write-host "  $($lang.SetDefault)" -ForegroundColor Green
		} else {
			write-host "  $($lang.NoInstallImage)" -ForegroundColor Red
			return
		}
	} else {
		<#
			.未指定配置文件，优先读取本地 Instl.json，如果没有就激活自动下载功能
		#>
		if (-not (Test-Path -Path $Script:Init_Config -PathType leaf)) {
			ForEach ($item in $Script:ServerListSelect | Sort-Object { Get-Random } ) {
				$Script:ServerList += $item
			}

			Update_Process
		}

		<#
			.未指定配置文件，优先读取本地 Instl.json，如果没有就激活自动下载功能
		#>
		if (Test-Path -Path $Script:Init_Config -PathType leaf) {
			write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"
			write-host "  $($Script:Init_Config)" -ForegroundColor Yellow
			write-host "  $($lang.SetDefault)" -ForegroundColor Green
		} else {
			write-host "`n  $($lang.NoInstallImage)"
			return
		}
	}

	Refresh_Match -MatchApp $App
	Install_Start_Process
} else {
	if ($Config) {
		write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "  $($config)" -ForegroundColor Yellow

		if (Test-Path -Path $config -PathType leaf) {
			$Script:Init_Config = $Config
			write-host "  $($lang.SetDefault)" -ForegroundColor Green
		} else {
			write-host "  $($lang.NoInstallImage)"
			return
		}
	} else {
		<#
			.未指定配置文件，优先读取本地 Instl.json，如果没有就激活自动下载功能
		#>
		if (Test-Path -Path $Script:Init_Config -PathType leaf) {
			write-host "`n  $($lang.ConfigNot)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"
			write-host "  $($Script:Init_Config)" -ForegroundColor Yellow
			write-host "  $($lang.SetDefault)" -ForegroundColor Green
		} else {
			ForEach ($item in $Script:ServerListSelect | Sort-Object { Get-Random } ) {
				$Script:ServerList += $item
			}

			Update_Process
		}
	}

	Install_UI
}