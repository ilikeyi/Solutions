Write-Host "Split Install.wim into Install.*.swm";
Write-Host "Splitting" -NoNewline;
Split-WindowsImage -ImagePath "D:\ISOTemp\sources\install.wim" -SplitImagePath "D:\ISOTemp\sources\install.swm" -FileSize "4096" -CheckIntegrity -ErrorAction SilentlyContinue | Out-Null
Write-Host "Split Complete`n" -ForegroundColor Green

Write-Host "`nVerify completion and delete old files"
if (Test-Path -Path "D:\ISOTemp\sources\install.swm" -PathType leaf) {
    Remove-Item -Path "D:\ISOTemp\sources\install.wim"
    Write-Host "Done" -ForegroundColor Green
} else {
    Write-Host "Failed" -ForegroundColor Red
}
