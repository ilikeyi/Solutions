<#
	.Install font search font: directory structure
	.搜索字体：目录结构
#>
$DirectoryStructure = @(
	"$((Get-Module -Name Engine).Author)\Fonts"
	"Fonts"
)

<#
	.Search font: file type
	.搜索字体：文件类型
#>
$type = @(
	"*.otf"
	"*.ttf"
)

<#
	.Processing: install fonts
	.处理：安装字体
#>
Function Install_Fonts
{
	param
	(
		[string]$fontFile,
		[string]$shortname
	)
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($lang.InstallFonts)"

	write-host "  $($fontFile)"
	write-host "  $($lang.Instl)".PadRight(28) -NoNewline
	if ((Test-Path "$($env:SystemDrive)\Windows\fonts\$($shortname)") -or 
		(Test-Path "$($env:LOCALAPPDATA)\Microsoft\Windows\Fonts\$($shortname)")) {
		Write-Host "$($lang.ItInstalled)`n" -ForegroundColor Red
	} else {
		(New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere($_.FullName) | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Install fonts: search fonts according to the directory structure, from A-Z disks
	.安装字体：按目录结构搜索字体，从 A - Z 盘
#>
Function Install_Fonts_Process
{
	write-host "`n  $($lang.InstallFonts)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	$drives = Get-PSDrive | Select-Object -ExpandProperty 'Name' | Select-String -Pattern '^[a-z]$'
	ForEach ($drive in $drives) {
		ForEach ($item in $DirectoryStructure) {
			Get-ChildItem -Path "${drive}:\$($item)" -Recurse -Include ($type) -ErrorAction SilentlyContinue | ForEach-Object {
				Install_Fonts -fontFile $_.FullName -shortname $_.Name
			}
		}
	}

	Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\..\Fonts"
}