Write-Host "Solid compressed Install.wim";
Get-WindowsImage -ImagePath "D:\OS_11\Sources\install.wim" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Image Name: " -NoNewline; Write-Host $_.ImageName -ForegroundColor Yellow;
    Write-Host "Index Number: " -NoNewline;	Write-Host $_.ImageIndex -ForegroundColor Yellow;

    Write-Host "Compressing".PadRight(28) -NoNewline
    dism /export-image /SourceImageFile:"D:\OS_11\Sources\install.wim" /SourceIndex:"$($_.ImageIndex)" /DestinationImageFile:"D:\OS_11\Sources\install.esd" /Compress:recovery /CheckIntegrity
    Write-Host "Compression completed`n" -ForegroundColor Green
}

Write-Host "`nVerify completion and delete old files"
if (Test-Path -Path "D:\OS_11\Sources\install.esd" -PathType leaf) {
    Remove-Item -Path "D:\OS_11\Sources\install.wim"
    Write-Host "Done" -ForegroundColor Green
} else {
    Write-Host "Falied" -ForegroundColor Green
}
