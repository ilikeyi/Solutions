$FileName = "D:\OS_10_Custom\Install\Install\Mount\Windows\System32\Recovery\WinRE.wim"
Get-WindowsImage -ImagePath $Filename -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "   Image name: " -NoNewline; Write-Host "$($_.ImageName)" -ForegroundColor Yellow
    Write-Host "   The index number: " -NoNewline; Write-Host "$($_.ImageIndex)" -ForegroundColor Yellow
    Write-Host "`n   Under reconstruction ".PadRight(28) -NoNewline
    try {
        Export-WindowsImage -SourceImagePath "$($Filename)" -SourceIndex "$($_.ImageIndex)" -DestinationImagePath "$($FileName).New" -CompressionType max | Out-Null
        Write-Host "Finish" -ForegroundColor Green
    } catch {
        Write-Host $_ -ForegroundColor Yellow
        Write-Host $Failed -ForegroundColor Red
    }
}
Write-Host "`n   Rename: " -NoNewline -ForegroundColor Yellow
if (Test-Path "$($FileName).New" -PathType Leaf) {
    Remove-Item -Path $Filename
    Move-Item -Path "$($FileName).New" -Destination $Filename
    Write-Host "Finish" -ForegroundColor Green
} else {
    Write-Host "Failed" -ForegroundColor Red
    Write-Host "   $($_)" -ForegroundColor Red
}
