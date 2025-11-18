<#
	.Summary
	 Yi's Solutions

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS command line: 

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.Example
	 PS C:\> .\_UnPack.ps1
	 PS C:\> .\_UnPack.ps1 -Function "Function1 -Param", "Function2 -Param"

	.LINK
	 https://fengyi.tel/solutions
	 https://github.com/ilikeyi/Solutions

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

<#
	.The log is saved to the directory name
	.日志保存到目录名称
#>
$Global:LogSaveTo = "Log-$(Get-Date -Format "yyyyMMddHHmmss")"

Remove-Module -Name Solutions -Force -ErrorAction Ignore | Out-Null
Import-Module -Name $PSScriptRoot\Modules\Solutions.psd1 -PassThru -Force | Out-Null

<#
	.Set language pack, usage:
	.设置语言，用法
	 Language                  | Language selected by the user       | 选择语言，交互
	 Language -Auto            | Automatic matching                  | 自动选择，不提示
	 Language -NewLang "zh-CN" | Mandatory use of specified language | 强制选择语言
#>
Language -Auto

<#
	.Prerequisites
	.先决条件
#>
Prerequisite

<#
	.Enable log
	.启用日志
#>
Logging

UnPack_Create_UI