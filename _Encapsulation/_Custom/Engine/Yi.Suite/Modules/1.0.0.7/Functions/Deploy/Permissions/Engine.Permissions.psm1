<#
	.Get all the directories under the directory and hide them
	.获取目录下的所有目录，并隐藏
#>
$GroupFolderHide = @(
	"10"
)

<#
	.Only hide the directory, not under the directory
	.只隐藏目录，不含目录下的
#>
$GroupFile = @(
	"Engine"
)

<#
	.Handling hidden tasks
	.处理隐藏任务
#>
Function Permissions
{
	Write-Host "`n   $($lang.Authority)"
	ForEach ($item in $GroupFolderHide) {
		Get-ChildItem "$($PSScriptRoot)\..\..\..\..\..\..\$($item)" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			Set-ItemProperty -Path $_.FullName -Name Attributes -Value Hidden -ErrorAction SilentlyContinue
		}
	}

	ForEach ($item in $GroupFile) {
		Set-ItemProperty -Path "$($PSScriptRoot)\..\..\..\..\..\..\$($item)" -Name Attributes -Value Hidden -ErrorAction SilentlyContinue
	}

	Write-Host "   $($lang.Done)" -ForegroundColor Green
}