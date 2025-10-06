Write-Host "Merge all Install.*.swm files into Install.wim";
Get-WindowsImage -ImagePath "D:\OS_11\Sources\install.swm" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Image Name: " -NoNewline; Write-Host $_.ImageName -ForegroundColor Yellow;
    Write-Host "Index Number: " -NoNewline;	Write-Host $_.ImageIndex -ForegroundColor Yellow;

    Write-Host "Exporting".PadRight(28) -NoNewline
    dism /export-image /SourceImageFile:"D:\OS_11\Sources\install.swm" /swmfile:"D:\OS_11\sources\install*.swm" /SourceIndex:"$($_.ImageIndex)" /DestinationImageFile:"D:\OS_11\Sources\install.wim" /Compress:"Max" /CheckIntegrity
    Write-Host "Export Complete`n" -ForegroundColor Green
}

Write-Host "`nVerify completion and delete old files"
if (Test-Path -Path "D:\OS_11\Sources\install.wim" -PathType leaf) {
    Get-ChildItem -Path "D:\OS_11\sources" -Recurse -include "*.swm" | ForEach-Object {
        Write-Host "Delete: $($_.Fullname)" -ForegroundColor Green
        Remove-Item -Path $_.Fullname
    }
    Write-Host "Done" -ForegroundColor Green
} else {
    Write-Host "Falied" -ForegroundColor Green
}
