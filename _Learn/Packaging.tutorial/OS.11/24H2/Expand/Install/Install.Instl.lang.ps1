Function Language_Install
{
    param($Mount, $Sources, $Lang)

    $Initl_install_Language_Component = @()
    if (Test-Path $Mount -PathType Container) {
        Get-WindowsPackage -Path $Mount | ForEach-Object { $Initl_install_Language_Component += $_.PackageName }
    } else {
        Write-Host "Not mounted: $($Mount)"
        return
    }

    $Script:Init_Folder_All_File = @()
    if (Test-Path "$($Sources)\$($Lang)" -PathType Container) {
        Get-ChildItem -Path $Sources -Recurse -Include "*.cab" -ErrorAction SilentlyContinue | ForEach-Object {
            $Script:Init_Folder_All_File += $_.FullName
        }

        Write-Host "`n   Available language pack installation files"
        if ($Script:Init_Folder_All_File.Count -gt 0) {
            ForEach ($item in $Script:Init_Folder_All_File) {
                Write-Host "   $($item)"
            }
        } else {
            Write-Host "There are no language pack files locally"
            return
        }
    } else {
        Write-Host "Path does not exist: $($Sources)\$($Lang)"
        return
    }

    $Script:Init_Folder_All_File_Match_Done = @()
    $Script:Init_Folder_All_File_Exclude = @()
    $Script:Search_File_Order = @(
        @{
            Name = "Fonts"
            Description = "Fonts"
            Rule = @(
                "*Fonts*"
            )
        }
        @{
            Name = "Basic"
            Description = "Basic"
            Rule = @(
                "*LanguageFeatures-Basic*"
                "*Client*Language*Pack*"
            )
        }
        @{
            Name = "OCR"
            Description = "Optical character recognition"
            Rule = @(
                "*LanguageFeatures-OCR*"
            )
        }
        @{
            Name = "Handwriting"
            Description = "Handwriting recognition"
            Rule = @(
                "*LanguageFeatures-Handwriting*"
            )
        }
        @{
            Name = "TextToSpeech"
            Description = "Text-to-speech"
            Rule = @(
                "*LanguageFeatures-TextToSpeech*"
            )
        }
        @{
            Name = "Speech"
            Description = "Speech recognition"
            Rule = @(
                "*LanguageFeatures-Speech*"
            )
        }
        @{
            Name = "RegionSpecific"
            Description = "Other region-specific requirements"
            Rule = @(
                "*InternationalFeatures*"
            )
        }
        @{
            Name = "Retail"
            Description = "Retail demo experience"
            Rule = @(
                "*RetailDemo*"
            )
        }
        @{
            Name = "Features_On_Demand"
            Description = "Features on demand"
            Rule = @(
                "*InternetExplorer*~x86~*"
                "*InternetExplorer*~x64~*"
                "*InternetExplorer*~amd64~*"
                "*InternetExplorer*~wow64~*"
                "*InternetExplorer*~arm64.x86~*"
                "*InternetExplorer*~arm64~*"
                "*MSPaint*~x86~*"
                "*MSPaint*~x64~*"
                "*MSPaint*~amd64~*"
                "*MSPaint*~wow64~*"
                "*MSPaint*~arm64.x86~*"
                "*MSPaint*~arm64~*"
                "*Notepad-FoD-Package*~x86~*"
                "*Notepad-FoD-Package*~x64~*"
                "*Notepad-FoD-Package*~amd64~*"
                "*Notepad-FoD-Package*~wow64~*"
                "*Notepad-FoD-Package*~arm64.x86~*"
                "*Notepad-FoD-Package*~arm64~*"
                "*Notepad-System-FoD-Package*~x86~*"
                "*Notepad-System-FoD-Package*~x64~*"
                "*Notepad-System-FoD-Package*~amd64~*"
                "*Notepad-System-FoD-Package*~wow64~*"
                "*Notepad-System-FoD-Package*~arm64.x86~*"
                "*Notepad-System-FoD-Package*~arm64~*"
                "*MediaPlayer*~x86~*"
                "*MediaPlayer*~x64~*"
                "*MediaPlayer*~amd64~*"
                "*MediaPlayer*~wow64~*"
                "*MediaPlayer*~arm64.x86~*"
                "*MediaPlayer*~arm64~*"
                "*PowerShell*ISE*~x86~*"
                "*PowerShell*ISE*~x64~*"
                "*PowerShell*ISE*~amd64~*"
                "*PowerShell*ISE*~wow64~*"
                "*PowerShell*ISE*~arm64.x86~*"
                "*PowerShell*ISE*~arm64~*"
                "*StepsRecorder*~x86~*"
                "*StepsRecorder*~x64~*"
                "*StepsRecorder*~amd64~*"
                "*StepsRecorder*~wow64~*"
                "*StepsRecorder*~arm64.x86~*"
                "*StepsRecorder*~arm64~*"
                "*SnippingTool*~x86~*"
                "*SnippingTool*~x64~*"
                "*SnippingTool*~amd64~*"
                "*SnippingTool*~wow64~*"
                "*SnippingTool*~arm64.x86~*"
                "*SnippingTool*~arm64~*"
                "*WMIC*~x86~*"
                "*WMIC*~x64~*"
                "*WMIC*~amd64~*"
                "*WMIC*~wow64~*"
                "*WMIC*~arm64.x86~*"
                "*WMIC*~arm64~*"
                "*WordPad*~x86~*"
                "*WordPad*~x64~*"
                "*WordPad*~amd64~*"
                "*WordPad*~wow64~*"
                "*WordPad*~arm64.x86~*"
                "*WordPad*~arm64~*"
                "*Printing-WFS*~x86~*"
                "*Printing-WFS*~x64~*"
                "*Printing-WFS*~amd64~*"
                "*Printing-WFS*~wow64~*"
                "*Printing-WFS*~arm64.x86~*"
                "*Printing-WFS*~arm64~*"
                "*Printing-PMCPPC*~x86~*"
                "*Printing-PMCPPC*~x64~*"
                "*Printing-PMCPPC*~amd64~*"
                "*Printing-PMCPPC*~wow64~*"
                "*Printing-PMCPPC*~arm64.x86~*"
                "*Printing-PMCPPC*~arm64~*"
                "*Telnet-Client*~x86~*"
                "*Telnet-Client*~x64~*"
                "*Telnet-Client*~amd64~*"
                "*Telnet-Client*~wow64~*"
                "*Telnet-Client*~arm64.x86~*"
                "*Telnet-Client*~arm64~*"
                "*TFTP-Client*~x86~*"
                "*TFTP-Client*~x64~*"
                "*TFTP-Client*~amd64~*"
                "*TFTP-Client*~wow64~*"
                "*TFTP-Client*~arm64.x86~*"
                "*TFTP-Client*~arm64~*"
                "*VBSCRIPT*~x86~*"
                "*VBSCRIPT*~x64~*"
                "*VBSCRIPT*~amd64~*"
                "*VBSCRIPT*~wow64~*"
                "*VBSCRIPT*~arm64.x86~*"
                "*VBSCRIPT*~arm64~*"
                "*WinOcr-FOD-Package*~x86~*"
                "*WinOcr-FOD-Package*~x64~*"
                "*WinOcr-FOD-Package*~amd64~*"
                "*WinOcr-FOD-Package*~wow64~*"
                "*WinOcr-FOD-Package*~arm64.x86~*"
                "*WinOcr-FOD-Package*~arm64~*"
                "*ProjFS-OptionalFeature-FOD-Package*~x86~*"
                "*ProjFS-OptionalFeature-FOD-Package*~x64~*"
                "*ProjFS-OptionalFeature-FOD-Package*~amd64~*"
                "*ProjFS-OptionalFeature-FOD-Package*~wow64~*"
                "*ProjFS-OptionalFeature-FOD-Package*~arm64.x86~*"
                "*ProjFS-OptionalFeature-FOD-Package*~arm64~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~x64~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~amd64~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~wow64~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~arm64.x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-BitmapFonts-FOD-Package*~arm64~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~x64~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~amd64~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~wow64~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~arm64.x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-Support-FOD-Package*~arm64~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~x64~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~amd64~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~wow64~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~arm64.x86~*"
                "*ServerCoreFonts-NonCritical-Fonts-TrueType-FOD-Package*~arm64~*"
                "*SimpleTCP-FOD-Package*~x86~*"
                "*SimpleTCP-FOD-Package*~x64~*"
                "*SimpleTCP-FOD-Package*~amd64~*"
                "*SimpleTCP-FOD-Package*~wow64~*"
                "*SimpleTCP-FOD-Package*~arm64.x86~*"
                "*SimpleTCP-FOD-Package*~arm64~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~x86~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~x64~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~amd64~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~wow64~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~arm64.x86~*"
                "*VirtualMachinePlatform-Client-Disabled-FOD-Package*~arm64~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~x86~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~x64~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~amd64~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~wow64~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~arm64.x86~*"
                "*DirectoryServices-ADAM-Client-FOD-Package*~arm64~*"
                "*EnterpriseClientSync-Host-FOD-Package*~x86~*"
                "*EnterpriseClientSync-Host-FOD-Package*~x64~*"
                "*EnterpriseClientSync-Host-FOD-Package*~amd64~*"
                "*EnterpriseClientSync-Host-FOD-Package*~wow64~*"
                "*EnterpriseClientSync-Host-FOD-Package*~arm64.x86~*"
                "*EnterpriseClientSync-Host-FOD-Package*~arm64~*"
                "*SenseClient-FoD-Package*~x86~*"
                "*SenseClient-FoD-Package*~x64~*"
                "*SenseClient-FoD-Package*~amd64~*"
                "*SenseClient-FoD-Package*~wow64~*"
                "*SenseClient-FoD-Package*~arm64.x86~*"
                "*SenseClient-FoD-Package*~arm64~*"
                "*SmbDirect-FOD-Package*~x86~*"
                "*SmbDirect-FOD-Package*~x64~*"
                "*SmbDirect-FOD-Package*~amd64~*"
                "*SmbDirect-FOD-Package*~wow64~*"
                "*SmbDirect-FOD-Package*~arm64.x86~*"
                "*SmbDirect-FOD-Package*~arm64~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~x86~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~x64~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~amd64~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~wow64~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~arm64.x86~*"
                "*TerminalServices-AppServer-Client-FOD-Package*~arm64~*"
            )
        }
    )

    ForEach ($item in $Script:Search_File_Order) { New-Variable -Name "Init_File_Type_$($item.Name)" -Value @() -Force }

    $ExcludeNameItem = @(
        "Fonts"
        "RegionSpecific"
    )

    ForEach ($WildCard in $Script:Init_Folder_All_File) {
        ForEach ($item in $Script:Search_File_Order) {
            ForEach ($NewRule in $item.Rule) {
                if ($WildCard -like "*$($NewRule)*") {
                    Write-Host "`n   Fuzzy matching: " -NoNewline; Write-Host $NewRule -ForegroundColor Green
                    Write-Host "   File name: " -NoNewline; Write-Host $WildCard -ForegroundColor Green

                    $OSDefaultUser = (Get-Variable -Name "Init_File_Type_$($item.Name)" -ErrorAction SilentlyContinue).Value
                    $TempSave = @{ Match_Name = $NewRule; FileName = $WildCard }
                    $new = $OSDefaultUser + $TempSave

                    if ($item.name -Contains $ExcludeNameItem) {
                        Write-Host "   Do not match, install directly" -ForegroundColor Yellow
                        New-Variable -Name "Init_File_Type_$($item.Name)" -Value $new -Force
                        $Script:Init_Folder_All_File_Match_Done += $WildCard
                    } else {
                        ForEach ($Component in $Initl_install_Language_Component) {
                            if ($Component -like "*$($NewRule)*") {
                                Write-Host "   Component name: " -NoNewline; Write-Host $Component -ForegroundColor Green

                                New-Variable -Name "Init_File_Type_$($item.Name)" -Value $new -Force
                                $Script:Init_Folder_All_File_Match_Done += $WildCard
                                break
                            }
                        }
                    }
               }
            }
        }
    }

    Write-Host "`n   Grouping is complete, pending installation" -ForegroundColor Yellow
    Write-Host "   $('-' * 80)"
    ForEach ($WildCard in $Script:Search_File_Order) {
        $OSDefaultUser = (Get-Variable -Name "Init_File_Type_$($WildCard.Name)" -ErrorAction SilentlyContinue).Value
        Write-Host "`n   $($WildCard.Description) ( $($OSDefaultUser.Count) item )"
        if ($OSDefaultUser.Count -gt 0) {
            ForEach ($item in $OSDefaultUser) {
                Write-Host "   $($item.FileName)" -ForegroundColor Green
            }
        } else {
            Write-Host "   Not available" -ForegroundColor Red
        }
    }

    Write-Host "`n   Not matched, no longer installed" -ForegroundColor Yellow
    Write-Host "   $('-' * 80)"
    ForEach ($item in $Script:Init_Folder_All_File) {
        if ($Script:Init_Folder_All_File_Match_Done -notcontains $item) {
            $Script:Init_Folder_All_File_Exclude += $item
            Write-Host "   $($item)" -ForegroundColor Red
        }
    }

    Write-Host "`n   Install" -ForegroundColor Yellow
    Write-Host "   $('-' * 80)"
    ForEach ($WildCard in $Script:Search_File_Order) {
        $OSDefaultUser = (Get-Variable -Name "Init_File_Type_$($WildCard.Name)" -ErrorAction SilentlyContinue).Value
        Write-Host "`n   $($WildCard.Description) ( $($OSDefaultUser.Count) item )"; Write-Host "   $('-' * 80)"     

        if ($OSDefaultUser.Count -gt 0) {
            ForEach ($item in $OSDefaultUser) {
                Write-Host "   File name: " -NoNewline; Write-Host $item.FileName -ForegroundColor Green
                Write-Host "   Installing ".PadRight(22) -NoNewline
                if (Test-Path $item.FileName -PathType Leaf) {
                    try {
                        Add-WindowsPackage -Path $Mount -PackagePath $item.FileName | Out-Null
                        Write-Host "Finish`n" -ForegroundColor Green
                    } catch {
                        Write-Host "Failed" -ForegroundColor Red
                        Write-Host "   $($_)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "Does not exist`n"
                }
            }
        } else {
            Write-Host "   Not available`n" -ForegroundColor Red
        }
    }
}

Language_Install -Mount "D:\OS_11_Custom\Install\Install\Mount" -Sources "D:\OS_11_Custom\Install\Install\Language\Add" -Lang "zh-CN"
