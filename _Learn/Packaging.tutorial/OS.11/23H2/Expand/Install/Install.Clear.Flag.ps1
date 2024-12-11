$Lang = "zh-CN"
Get-AppXProvisionedPackage -Path "D:\OS_11_Custom\Install\Install\Mount" | Foreach-object {
    if ($_.DisplayName -Like "*LanguageExperiencePack*$($Lang)*") {
        Write-Host "   $($_.DisplayName)"
        Write-Host "   Deleting".PadRight(22) -NoNewline
        try {
            Remove-AppxProvisionedPackage -Path "D:\OS_11_Custom\Install\Install\Mount" -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
            Write-Host "Finish" -ForegroundColor Green
        } catch {
            Write-Host "Failed" -ForegroundColor Red
            Write-Host "   $($_)" -ForegroundColor Red
        }
    }
}
