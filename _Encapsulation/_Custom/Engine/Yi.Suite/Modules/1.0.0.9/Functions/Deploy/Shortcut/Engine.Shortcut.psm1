<#
	.Start processing refresh task
	.开始处理刷新任务
#>
Function Shortcut_Process
{
	<#
		.Get the required application software path
		.获取所需的应用软件路径
	#>
	$Shortcut  = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\..\AIO\Shortcut")\Shortcut.exe"
	$syspin    = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\..\AIO\syspin")\syspin.exe"
	$StartMenu = "$($env:SystemDrive)\ProgramData\Microsoft\Windows\Start Menu\Programs\$((Get-Module -Name Engine).Author)'s Solutions"

	<#
		.Obtain deployment conditions:
		  1. Clean up the entire solution;
		  2. clean up the main engine after running.
		Set the mark after being satisfied: $True

		.获取部署条件：
		  1. 清理整个解决方案；
		  2. 运行后清理主引擎。
		满足后设置标记为：$True
	#>
	$FlagsClearSolutionsRule = $Flase
	if (Deploy_Sync -Mark "Clear_Solutions") {
		$FlagsClearSolutionsRule = $True
	}
	if (Deploy_Sync -Mark "Clear_Engine") {
		$FlagsClearSolutionsRule = $True
	}

	if (Test-Path $syspin -PathType Leaf) {
		Start-Process -FilePath $syspin -ArgumentList """$($StartMenu)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"" ""51394""" -Wait -WindowStyle Hidden
	}
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\Bundled Solutions.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\附赠解决方案.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\附贈解決方案.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\보너스 솔루션.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\ボーナスソリューション.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($env:SystemDrive)\Users\Public\Desktop\Bonuslösung.lnk" -ErrorAction SilentlyContinue

	<#
		.Clean up old Shortcut, Desktop.ini
		.清理旧快捷方式、Desktop.ini
	#>
	Remove-Item -Path "$($PSScriptRoot)\..\..\..\..\..\..\*.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($PSScriptRoot)\..\..\..\..\..\..\Desktop.ini" -ErrorAction SilentlyContinue

	Get-ChildItem "$($PSScriptRoot)\..\..\..\..\..\.." -directory -ErrorAction SilentlyContinue | ForEach-Object {
		Remove-Item -Path "$($_.Fullname)\*.lnk" -ErrorAction SilentlyContinue
		Remove-Item -Path "$($_.Fullname)\Desktop.ini" -ErrorAction SilentlyContinue
	}

	<#
		.Clean up old connections
		.清理旧文件
	#>
	Remove_Tree -Path $StartMenu
	Check_Folder -chkpath $StartMenu

	<#
		.Unzip the compressed package
		.解压压缩包
	#>
	Unzip_Compressed_Package

	<#
		.Pre-configuration processing
		.预配置处理
	#>
	if ($FlagsClearSolutionsRule) {
	} else {
		Repair_Home_Directory

		$IconFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\.." -ErrorAction SilentlyContinue

		#region Public
		$NewLnkPath = "$($env:SystemDrive)\Users\Public\Desktop\$($lang.MainHisName).lnk"
		write-host "`n  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		Write-Host $NewLnkPath -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$arguments = @(
			"/f:""$($NewLnkPath)""",
			"/a:c",
			"/t:""$($(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue))""",
			"/i:""$($IconFolder)\Assets\icons\Engine.Gift.ico"""
		)

		Write-Host "  Start-Process -FilePath ""$($Shortcut)"" -ArgumentList '$($Arguments)'" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Start-Process -FilePath $Shortcut -ArgumentList $arguments -Wait -WindowStyle Hidden

		write-host "  " -NoNewline
		write-host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (Test-Path $NewLnkPath -PathType Leaf) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
		#endregion


		#region Start menu
		$NewLnkPath = "$($StartMenu)\- $($lang.Location) -.lnk"
		write-host "`n  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		Write-Host $NewLnkPath -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$arguments = @(
			"/f:""$($NewLnkPath)""",
			"/a:c",
			"/t:""$($(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue))""",
			"/i:""$($IconFolder)\Assets\icons\Engine.Gift.ico"""
		)

		Write-Host "  Start-Process -FilePath ""$($Shortcut)"" -ArgumentList '$($Arguments)'" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Start-Process -FilePath $Shortcut -ArgumentList $arguments -Wait -WindowStyle Hidden

		write-host "  " -NoNewline
		write-host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (Test-Path $NewLnkPath -PathType Leaf) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
		#endregion


		#region Start menu
		$NewLnkPath = "$($StartMenu)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"
		write-host "`n  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		Write-Host $NewLnkPath -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$arguments = @(
			"/f:""$($NewLnkPath)""",
			"/a:c",
			"/t:""powershell"" /p:""-Command \""Start-Process 'Powershell.exe' -Argument '-File \""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))\""' -Verb RunAs""",
			"/i:""$($IconFolder)\Assets\icons\MainPanel.ico"""
		)

		Write-Host "  Start-Process -FilePath ""$($Shortcut)"" -ArgumentList '$($Arguments)'" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Start-Process -FilePath $Shortcut -ArgumentList $arguments -Wait -WindowStyle Hidden

		write-host "  " -NoNewline
		write-host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (Test-Path $NewLnkPath -PathType Leaf) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
		#endregion


		#region Main Folder
		$NewLnkPath = Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue) -ChildPath "$((Get-Module -Name Engine).Author)'s Solutions.lnk"
		write-host "`n  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
		Write-Host $NewLnkPath -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		$arguments = @(
			"/f:""$($NewLnkPath)""",
			"/a:c",
			"/t:""powershell"" /p:""-Command \""Start-Process 'Powershell.exe' -Argument '-File \""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))\""' -Verb RunAs""",
			"/i:""$($IconFolder)\Assets\icons\MainPanel.ico"""
		)

		Write-Host "  Start-Process -FilePath ""$($Shortcut)"" -ArgumentList '$($Arguments)'" -ForegroundColor Green
		Write-Host "  $('-' * 80)"

		Start-Process -FilePath $Shortcut -ArgumentList $arguments -Wait -WindowStyle Hidden

		write-host "  " -NoNewline
		write-host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
		if (Test-Path $NewLnkPath -PathType Leaf) {
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
		}
		#endregion

		Pin_To_Start
	}

	Wait-Process -Name "Shortcut" -ErrorAction SilentlyContinue
}

Function Pin_To_Start
{
	$syspin    = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\..\AIO\syspin")\syspin.exe"
	$StartMenu = "$($env:SystemDrive)\ProgramData\Microsoft\Windows\Start Menu\Programs\$((Get-Module -Name Engine).Author)'s Solutions"

	if (Test-Path $syspin -PathType Leaf) {
		Start-Process -FilePath $syspin -ArgumentList """$($StartMenu)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"" ""51201""" -Wait -WindowStyle Hidden
	}
}