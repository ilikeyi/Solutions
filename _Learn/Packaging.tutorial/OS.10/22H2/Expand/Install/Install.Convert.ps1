Write-Host "Convert ESD to WIM";
Get-WindowsImage -ImagePath "D:\OS_10\Sources\install.esd" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Image Name: " -NoNewline; Write-Host $_.ImageName -ForegroundColor Yellow;
    Write-Host "Index Number: " -NoNewline;	Write-Host $_.ImageIndex -ForegroundColor Yellow;

    Write-Host "Exporting".PadRight(28) -NoNewline
    try {
        Export-WindowsImage -SourceImagePath "D:\OS_10\Sources\install.esd" -SourceIndex $_.ImageIndex -DestinationImagePath "D:\OS_10\Sources\install.wim" -CompressionType "Max" -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Done`n" -ForegroundColor Green
    } catch {
        Write-Host $_ -ForegroundColor Yellow
        Write-Host "Falied`n" -ForegroundColor Red
    }
}

Write-Host "`nVerify completion and delete old files"
if (Test-Path -Path "D:\OS_10\Sources\install.wim" -PathType leaf) {
    Remove-Item -Path "D:\OS_10\Sources\install.esd"
    Write-Host "Done" -ForegroundColor Green
} else {
    Write-Host "Falied" -ForegroundColor Green
}
