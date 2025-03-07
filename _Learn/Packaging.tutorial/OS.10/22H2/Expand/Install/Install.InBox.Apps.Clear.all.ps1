Get-AppXProvisionedPackage -path "D:\OS_10_Custom\Install\Install\Mount" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "`n   $($_.DisplayName)"
    Write-Host "   Deleting ".PadRight(22) -NoNewline

    try {
        Remove-AppxProvisionedPackage -Path "D:\OS_10_Custom\Install\Install\Mount" -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Finish" -ForegroundColor Green
    } catch {
        Write-Host "Failed" -ForegroundColor Red
        Write-Host "   $($_)" -ForegroundColor Red
    }
}
