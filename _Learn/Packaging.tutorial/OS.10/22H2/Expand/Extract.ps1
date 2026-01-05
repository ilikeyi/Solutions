Function Extract_Language
{
    param($NewArch, $Act, $NewLang, $Expand, $ISO, $SaveTo)

    Function Match_Required_Fonts
    {
        param($Lang)

        $Fonts = @(
            @{ Match = @("as", "ar-SA", "ar", "ar-AE", "ar-BH", "ar-DJ", "ar-DZ", "ar-EG", "ar-ER", "ar-IL", "ar-IQ", "ar-JO", "ar-KM", "ar-KW", "ar-LB", "ar-LY", "ar-MA", "ar-MR", "ar-OM", "ar-PS", "ar-QA", "ar-SD", "ar-SO", "ar-SS", "ar-SY", "ar-TD", "ar-TN", "ar-YE", "arz-Arab", "ckb-Arab", "fa", "fa-AF", "fa-IR", "glk-Arab", "ha-Arab", "ks-Arab", "ks-Arab-IN", "ku-Arab", "ku-Arab-IQ", "mzn-Arab", "pa-Arab", "pa-Arab-PK", "pnb-Arab", "prs", "prs-AF", "prs-Arab", "ps", "ps-AF", "sd-Arab", "sd-Arab-PK", "tk-Arab", "ug", "ug-Arab", "ug-CN", "ur", "ur-IN", "ur-PK", "uz-Arab", "uz-Arab-AF"); Name = "Arab"; }
            @{ Match = @("bn-IN", "as-IN", "bn", "bn-BD", "bpy-Beng"); Name = "Beng"; }
            @{ Match = @("da-dk", "iu-Cans", "iu-Cans-CA"); Name = "Cans"; }
            @{ Match = @("chr-Cher-US", "chr-Cher"); Name = "Cher"; }
            @{ Match = @("hi-IN", "bh-Deva", "brx", "brx-Deva", "brx-IN", "hi", "ks-Deva", "mai", "mr", "mr-IN", "ne", "ne-IN", "ne-NP", "new-Deva", "pi-Deva", "sa", "sa-Deva", "sa-IN"); Name = "Deva"; }
            @{ Match = @("am", "am-ET", "byn", "byn-ER", "byn-Ethi", "ti", "ti-ER", "ti-ET", "tig", "tig-ER", "tig-Ethi", "ve-Ethi", "wal", "wal-ET", "wal-Ethi"); Name = "Ethi"; }
            @{ Match = @("gu", "gu-IN"); Name = "Gujr"; }
            @{ Match = @("pa", "pa-IN", "pa-Guru"); Name = "Guru"; }
            @{ Match = @("zh-CN", "cmn-Hans", "gan-Hans", "hak-Hans", "wuu-Hans", "yue-Hans", "zh-gan-Hans", "zh-hak-Hans", "zh-Hans", "zh-SG", "zh-wuu-Hans", "zh-yue-Hans"); Name = "Hans"; }
            @{ Match = @("zh-TW", "cmn-Hant", "hak-Hant", "lzh-Hant", "zh-hak-Hant", "zh-Hant", "zh-HK", "zh-lzh-Hant", "zh-MO", "zh-yue-Hant"); Name = "Hant"; }
            @{ Match = @("he", "he-IL", "yi"); Name = "Hebr"; }
            @{ Match = @("ja", "ja-JP"); Name = "Jpan"; }
            @{ Match = @("km", "km-KH"); Name = "Khmr"; }
            @{ Match = @("kn", "kn-IN"); Name = "Knda"; }
            @{ Match = @("ko", "ko-KR"); Name = "Kore"; }
            @{ Match = @("de-de", "lo", "lo-LA"); Name = "Laoo"; }
            @{ Match = @("ml", "ml-IN"); Name = "Mlym"; }
            @{ Match = @("or", "or-IN"); Name = "Orya"; }
            @{ Match = @("si", "si-LK"); Name = "Sinh"; }
            @{ Match = @("tr-tr", "arc-Syrc", "syr", "syr-SY", "syr-Syrc"); Name = "Syrc"; }
            @{ Match = @("ta", "ta-IN", "ta-LK", "ta-MY", "ta-SG"); Name = "Taml"; }
            @{ Match = @("te", "te-IN"); Name = "Telu"; }
            @{ Match = @("th", "th-TH"); Name = "Thai"; }
        )

        ForEach ($item in $Fonts) {
            if (($item.Match) -Contains $Lang) {
                return $item.Name
            }
        }

        return "Not_matched"
    }

    Function Match_Other_Region_Specific_Requirements
    {
        param($Lang)

        $RegionSpecific = @(
            @{ Match = @("zh-TW"); Name = "Taiwan"; }
        )

        ForEach ($item in $RegionSpecific) {
            if (($item.Match) -Contains $Lang) {
                return $item.Name
            }
        }

        return "Skip_specific_packages"
    }

    Function Extract_Process
    {
        param($Package, $Name, $NewSaveTo)

        $NewSaveTo = "$($SaveTo)\$($NewSaveTo)\Language\$($Act)\$($NewLang)"
        New-Item -Path $NewSaveTo -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

        if ($ISO -eq "Auto") {
            Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
                ForEach ($item in $Package) {
                    $TempFilePath = Join-Path -Path $_.Root -ChildPath $item

                    if (Test-Path $TempFilePath -PathType Leaf) {
                        Write-Host "`n   Find: " -NoNewLine; Write-Host $TempFilePath -ForegroundColor Green
                        Write-Host "   Copy to: " -NoNewLine; Write-Host $NewSaveTo
                        Copy-Item -Path $TempFilePath -Destination $NewSaveTo -Force
                    }
                }
            }
        } else {
            ForEach ($item in $Package) {
                $TempFilePath = Join-Path -Path $ISO -ChildPath $item

                Write-Host "`n   Find: " -NoNewline; Write-Host $TempFilePath -ForegroundColor Green
                if (Test-Path $TempFilePath -PathType Leaf) {
                    Write-Host "   Copy to: " -NoNewLine; Write-Host $NewSaveTo
                    Copy-Item -Path $TempFilePath -Destination $NewSaveTo -Force
                } else {
                    Write-Host "   Not found"
                }
            }
        }
        
        Write-Host "`n   Verify the language pack file"
        ForEach ($item in $Package) {
            $Path = "$($NewSaveTo)\$([IO.Path]::GetFileName($item))"

            if (Test-Path $Path -PathType Leaf) {
                Write-Host "   Discover: " -NoNewLine; Write-Host $Path -ForegroundColor Green
            } else {
                Write-Host "   Not found: " -NoNewLine; Write-Host $Path -ForegroundColor Red
            }
        }
    }

    $AdvLanguage = @(
        @{
            Path = "Install\Install"
            Rule = @(
                "Microsoft-Windows-LanguageFeatures-Fonts-{DiyLang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "{ARCHC}\langpacks\Microsoft-Windows-Client-Language-Pack_x64_{Lang}.cab"
                "Microsoft-Windows-LanguageFeatures-Basic-{Lang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "Microsoft-Windows-LanguageFeatures-Handwriting-{Lang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "Microsoft-Windows-LanguageFeatures-OCR-{Lang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "Microsoft-Windows-LanguageFeatures-Speech-{Lang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "Microsoft-Windows-LanguageFeatures-TextToSpeech-{Lang}-Package~31bf3856ad364e35~AMD64~~.cab"
                "Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab"
                "Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab"
                "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~{ARCH}~{Lang}~.cab"
                "Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab"
                "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~wow64~{Lang}~.cab"
                "Microsoft-Windows-Printing-PMCPPC-FoD-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~wow64~{Lang}~.cab"
                "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~AMD64~{Lang}~.cab"
                "Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~wow64~{Lang}~.cab"
                "Microsoft-Windows-InternationalFeatures-{Specific}-Package~31bf3856ad364e35~amd64~~.cab"
            )
        }
        @{
            Path = "Install\WinRE"
            Rule = @(
                "Windows Preinstallation Environment\x64\WinPE_OCs\WinPE-FontSupport-{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\lp.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-securestartup_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-atbroker_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-audiocore_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-audiodrivers_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-enhancedstorage_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-narrator_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-scripting_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-speech-tts_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-srh_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-srt_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-wds-tools_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-wmi_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-appxpackaging_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-storagewmi_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-wifi_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-rejuv_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-opcservices_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-hta_{Lang}.cab"
            )
        }
        @{
            Path = "Boot\Boot"
            Rule = @(
                "Windows Preinstallation Environment\x64\WinPE_OCs\WinPE-FontSupport-{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\lp.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\WinPE-Setup_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\WINPE-SETUP-CLIENT_{Lang}.CAB"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-securestartup_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-atbroker_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-audiocore_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-audiodrivers_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-enhancedstorage_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-narrator_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-scripting_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-speech-tts_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-srh_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-srt_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-wds-tools_{Lang}.cab"
                "Windows Preinstallation Environment\x64\WinPE_OCs\{Lang}\winpe-wmi_{Lang}.cab"
            )
        }
    )

    $NewFonts = Match_Required_Fonts -Lang $NewLang
    $SpecificPackage = Match_Other_Region_Specific_Requirements -Lang $NewLang
    $NewArchC = $NewArch.Replace("AMD64", "x64")

    Foreach ($item in $Expand) {
        $Language = @()

        Foreach ($itemList in $AdvLanguage) {
            if ($itemList.Path -eq $item) {
                Foreach ($PrintLang in $itemList.Rule) {
                    $Language += "$($PrintLang)".Replace("{Lang}", $NewLang).Replace("{DiyLang}", $NewFonts).Replace("{Specific}", $SpecificPackage).Replace("{ARCH}", $NewArch).Replace("{ARCHC}", $NewArchC)
                }

                Extract_Process -NewSaveTo $itemList.Path -Package $Language -Name $item
            }
        }
    }
}

# Extract add, delete
$Extract_language_Pack = @(
    @{ Tag = "zh-CN"; Arch = "AMD64"; Act = "Add"; Scope = @("Install\Install"; "Install\WinRE"; "Boot\Boot") }
    @{ Tag = "en-US"; Arch = "AMD64"; Act = "Del"; Scope = @( "Install\Install"; "Install\WinRE"; "Boot\Boot" ) }
)
ForEach ($item in $Extract_language_Pack) {
    Extract_Language -Act $item.Act -NewLang $item.Tag -NewArch $item.Arch -Expand $item.Scope -ISO "Auto" -SaveTo "D:\ISOTemp_Custom"
}
