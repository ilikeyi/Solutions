<#
	.Unzip the compressed package
	.解压压缩包
#>

Function Unzip_Compressed_Package
{
	$UnzipPath = @(
		"$($PSScriptRoot)\..\..\..\..\..\.."
	)

	$Instpack = "$($env:SystemDrive)\Installation package"
	if (Test-Path -Path $Instpack -PathType Container) {
		$UnzipPath += $Instpack
	}

	ForEach ($NewPath in $UnzipPath) {
		Get-ChildItem -Path $NewPath -filter "*.zip" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
			$SaveToName = [IO.Path]::GetDirectoryName($_.FullName)
			Archive -filename $_.FullName -to $SaveToName
			Remove-Item -Path $_.FullName -ErrorAction SilentlyContinue
			Remove-Item -Path "$($_.FullName).sha256" -ErrorAction SilentlyContinue
		}
		Write-Host
	}
}