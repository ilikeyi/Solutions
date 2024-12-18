Get-WindowsImage -ImagePath "D:\OS_10\sources\install.wim" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "   Image name: " -NoNewline; Write-Host "$($_.ImageName)" -ForegroundColor Yellow
    Write-Host "   The index number: " -NoNewline; Write-Host "$($_.ImageIndex)" -ForegroundColor Yellow
    Write-Host "`n   Replacement "
    $Arguments = @(
        "update",
        "D:\OS_10\sources\install.wim",
        "$($_.ImageIndex)",
        "--command=""add 'D:\OS_10_Custom\Install\Install\Update\Winlib\WinRE.wim' '\Windows\System32\Recovery\WinRe.wim'"""
    )

    Start-Process -FilePath "d:\wimlib\wimlib-imagex.exe" -ArgumentList $Arguments -wait -nonewwindow
    Write-Host "   Finish`n" -ForegroundColor Green
}
