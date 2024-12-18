<#
    .Summary
     Office Download

	.Description
     Office Download ( ODT )

	.Version
	 v1.0

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS command line: 

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

<#
	.Determine whether there is Setup.exe
	.判断是否存在 Setup.exe

	https://www.microsoft.com/en-us/download/details.aspx?id=49117
#>
$Init_Setup = "$($PSScriptRoot)\..\..\Setup.exe"

if (Test-Path $Init_Setup -PathType Leaf) {
	Write-Host "`n   Discover the ODT tool" -ForegroundColor Green
} else {
	Write-Host "   - No ODT tool found" -ForegroundColor Red

	$start_time = Get-Date
	Invoke-WebRequest -Uri "https://officecdn.microsoft.com/pr/wsus/setup.exe" -OutFile $Init_Setup -TimeoutSec 30 -DisableKeepAlive -ErrorAction SilentlyContinue | Out-Null
	Write-Host "`n   Time Used: $((Get-Date).Subtract($start_time).Seconds) (s)`n"
}

if (Test-Path $Init_Setup -PathType Leaf) {
	Write-Host "`n   $($PSScriptRoot)\Download.x86.xml" -ForegroundColor Green
	if (Test-Path "$($PSScriptRoot)\Download.x86.xml" -PathType Leaf) {
		start-process $Init_Setup -ArgumentList "/Download $($PSScriptRoot)\Download.x86.xml" -wait -WindowStyle Hidden
	} else {
		Write-Host "   - No configuration file found" -ForegroundColor Red
	}
} else {
	Write-Host "   - No ODT tool found" -ForegroundColor Red
}