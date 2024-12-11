$Lang = "en-US"
$Mount = "D:\OS_11_Custom\Install\WinRE\Mount"
$Sources = "D:\OS_11_Custom\Install\WinRE\Language\Del\en-US"

$Initl_install_Language_Component = @()
Get-WindowsPackage -Path $Mount | ForEach-Object {
    $Initl_install_Language_Component += $_.PackageName
}

$Language = @(
    @{ Match = "*windowsupdate*"; File = "winpe-windowsupdate_$($Lang).cab"; }
    @{ Match = "*appxdeployment*"; File = "winpe-appxdeployment_$($Lang).cab"; }
    @{ Match = "*hta*"; File = "winpe-hta_$($Lang).cab"; }
    @{ Match = "*opcservices*"; File = "winpe-opcservices_$($Lang).cab"; }
    @{ Match = "*rejuv*"; File = "winpe-rejuv_$($Lang).cab"; }
    @{ Match = "*WiFi*"; File = "winpe-wifi_$($Lang).cab"; }
    @{ Match = "*StorageWMI*"; File = "winpe-storagewmi_$($Lang).cab"; }
    @{ Match = "*WinPE-AppxPackaging*"; File = "winpe-appxpackaging_$($Lang).cab"; }
    @{ Match = "*-WMI-Package*"; File = "winpe-wmi_$($Lang).cab"; }
    @{ Match = "*wds-tools*"; File = "winpe-wds-tools_$($Lang).cab"; }
    @{ Match = "*srt*"; File = "winpe-srt_$($Lang).cab"; }
    @{ Match = "*srh*"; File = "winpe-srh_$($Lang).cab"; }
    @{ Match = "*Speech-TTS*"; File = "winpe-speech-tts_$($Lang).cab"; }
    @{ Match = "*scripting*"; File = "winpe-scripting_$($Lang).cab"; }
    @{ Match = "*Narrator*"; File = "winpe-narrator_$($Lang).cab"; }
    @{ Match = "*EnhancedStorage*"; File = "winpe-enhancedstorage_$($Lang).cab"; }
    @{ Match = "*AudioDrivers*"; File = "winpe-audiodrivers_$($Lang).cab"; }
    @{ Match = "*AudioCore*"; File = "winpe-audiocore_$($Lang).cab"; }
    @{ Match = "*ATBroker*"; File = "winpe-atbroker_$($Lang).cab"; }
    @{ Match = "*SecureStartup*"; File = "winpe-securestartup_$($Lang).cab"; }
    @{ Match = "*WinPE-LanguagePack-Package*"; File = "lp.cab"; }
)

ForEach ($Rule in $Language) {
    Write-Host "`n   Rule name: $($Rule.Match)" -ForegroundColor Yellow; Write-Host "   $('-' * 80)"
    ForEach ($Component in $Initl_install_Language_Component) {
        if ($Component -like "*$($Rule.Match)*$($Lang)*") {
            Write-Host "   Component name: " -NoNewline; Write-Host $Component -ForegroundColor Green
            Write-Host "   Language pack file: " -NoNewline; Write-Host "$($Sources)\$($Rule.File)" -ForegroundColor Green
            Write-Host "   Deleting ".PadRight(22) -NoNewline
            try {
                Remove-WindowsPackage -Path $Mount -PackagePath "$($Sources)\$($Rule.File)" -ErrorAction SilentlyContinue | Out-Null

                Write-Host "Finish" -ForegroundColor Green
            } catch {
                Write-Host "Failed" -ForegroundColor Red
                Write-Host "   $($_)" -ForegroundColor Red
            }

            break
        }
    }
}

$InitlClearLanguagePackage = @()
Get-WindowsPackage -Path $Mount | ForEach-Object {
    if ($_.PackageName -like "*$($Lang)*") {
        $InitlClearLanguagePackage += $_.PackageName
    }
}

if ($InitlClearLanguagePackage.count -gt 0) {
    ForEach ($item in $InitlClearLanguagePackage) {
        Write-Host "`n   $($item)" -ForegroundColor Green
        Write-Host "   Deleting ".PadRight(22) -NoNewline
        try {
            Remove-AppxProvisionedPackage -Path $Mount -PackageName $item -ErrorAction SilentlyContinue | Out-Null
            Write-Host "Finish" -ForegroundColor Green
        } catch {
            Write-Host "Failed" -ForegroundColor Red
            Write-Host "   $($_)" -ForegroundColor Red
        }
    }
}
