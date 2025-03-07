$InstallWim = "D:\OS_2022\sources\install.wim"
Get-WindowsImage -ImagePath $InstallWim -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "   Image name: " -NoNewline; Write-Host "$($_.ImageName)" -ForegroundColor Yellow
    Write-Host "   The index number: " -NoNewline; Write-Host "$($_.ImageIndex)" -ForegroundColor Yellow
    Write-Host "`n   Under reconstruction".PadRight(28) -NoNewline
    Export-WindowsImage -SourceImagePath $InstallWim -SourceIndex "$($_.ImageIndex)" -DestinationImagePath "$($InstallWim).New" -CompressionType max | Out-Null
    Write-Host "Finish`n" -ForegroundColor Green
}

if (Test-Path "$($InstallWim).New" -PathType Leaf) {
    Remove-Item -Path $InstallWim
    Move-Item -Path "$($InstallWim).New" -Destination $InstallWim
    Write-Host "Finish" -ForegroundColor Green
} else {
    Write-Host "Failed" -ForegroundColor Red
}
