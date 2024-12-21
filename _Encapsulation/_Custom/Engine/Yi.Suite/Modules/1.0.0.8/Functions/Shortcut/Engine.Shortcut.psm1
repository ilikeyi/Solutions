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
	$Shortcut  = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\Shortcut")\Shortcut.exe"
	$syspin    = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\syspin")\syspin.exe"
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
	Remove-Item -Path "$($PSScriptRoot)\..\..\..\..\..\*.lnk" -ErrorAction SilentlyContinue
	Remove-Item -Path "$($PSScriptRoot)\..\..\..\..\..\Desktop.ini" -ErrorAction SilentlyContinue

	Get-ChildItem "$($PSScriptRoot)\..\..\..\..\.." -directory -ErrorAction SilentlyContinue | ForEach-Object {
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

		$IconFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\.." -ErrorAction SilentlyContinue
		Start-Process -FilePath $Shortcut -ArgumentList "/f:""$($env:SystemDrive)\Users\Public\Desktop\$($lang.MainHisName).lnk"" /a:c /t:""$($Global:UniqueMainFolder)"" /i:""$($IconFolder)\Assets\icons\Engine.Gift.ico""" -WindowStyle Hidden
		Start-Process -FilePath $Shortcut -ArgumentList "/f:""$($StartMenu)\- $($lang.Location) -.lnk"" /a:c /t:""$($Global:UniqueMainFolder)"" /i:""$($IconFolder)\Assets\icons\Engine.Gift.ico""" -WindowStyle Hidden
		Start-Process -FilePath $Shortcut -ArgumentList "/f:""$($StartMenu)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"" /a:c /t:""powershell"" /p:""-Command \""Start-Process 'Powershell.exe' -Argument '-File \""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))\""' -Verb RunAs"" /i:""$($IconFolder)\Assets\icons\MainPanel.ico""" -WindowStyle Hidden -Wait
		Start-Process -FilePath $Shortcut -ArgumentList "/f:""$($Global:UniqueMainFolder)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"" /a:c /t:""powershell"" /p:""-Command \""Start-Process 'Powershell.exe' -Argument '-File \""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))\""' -Verb RunAs"" /i:""$($IconFolder)\Assets\icons\MainPanel.ico""" -WindowStyle Hidden

		Pin_To_Start
	}

	Wait-Process -Name "Shortcut" -ErrorAction SilentlyContinue
}

Function Pin_To_Start
{
	$syspin    = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\syspin")\syspin.exe"
	$StartMenu = "$($env:SystemDrive)\ProgramData\Microsoft\Windows\Start Menu\Programs\$((Get-Module -Name Engine).Author)'s Solutions"

	if (Test-Path $syspin -PathType Leaf) {
		Start-Process -FilePath $syspin -ArgumentList """$($StartMenu)\$((Get-Module -Name Engine).Author)'s Solutions.lnk"" ""51201""" -Wait -WindowStyle Hidden
	}
}