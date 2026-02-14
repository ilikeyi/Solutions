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
                @{ Match_Name = "*Fonts*"; IsMatch = "No"; }
            )
        }
        @{
            Name = "Basic"
            Description = "Basic"
            Rule = @(
                @{ Match_Name = "*LanguageFeatures-Basic*"; IsMatch = "Yes"; }
                @{ Match_Name = "*Client*Language*Pack*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "OCR"
            Description = "Optical character recognition"
            Rule = @(
                @{ Match_Name = "*LanguageFeatures-OCR*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "Handwriting"
            Description = "Handwriting recognition"
            Rule = @(
                @{ Match_Name = "*LanguageFeatures-Handwriting*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "TextToSpeech"
            Description = "Text-to-speech"
            Rule = @(
                @{ Match_Name = "*LanguageFeatures-TextToSpeech*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "Speech"
            Description = "Speech recognition"
            Rule = @(
                @{ Match_Name = "*LanguageFeatures-Speech*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "RegionSpecific"
            Description = "Other region-specific requirements"
            Rule = @(
                @{ Match_Name = "*InternationalFeatures*"; IsMatch = "No"; }
            )
        }
        @{
            Name = "Retail"
            Description = "Retail demo experience"
            Rule = @(
                @{ Match_Name = "*RetailDemo*"; IsMatch = "Yes"; }
            )
        }
        @{
            Name = "Features_On_Demand"
            Description = "Features on demand"
            Rule = @(
                @{ Match_Name = "*InternetExplorer*"; IsMatch = "Yes"; }
                @{ Match_Name = "*MSPaint*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*MSPaint*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*Notepad*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*Notepad*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*MediaPlayer*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*MediaPlayer*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*PowerShell-ISE-FOD-Package*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*PowerShell-ISE-FOD-Package*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*Printing*PMCPPC*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*Printing*WFS*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*StepsRecorder*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*StepsRecorder*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*WordPad*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*WordPad*wow64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*WMIC*FoD*Package*amd64*"; IsMatch = "Yes"; }
                @{ Match_Name = "*WMIC*FoD*Package*wow64*"; IsMatch = "Yes"; }
            )
        }
    )

    ForEach ($item in $Script:Search_File_Order) { New-Variable -Name "Init_File_Type_$($item.Name)" -Value @() -Force }

    ForEach ($WildCard in $Script:Init_Folder_All_File) {
        ForEach ($item in $Script:Search_File_Order) {
            ForEach ($NewRule in $item.Rule) {
                if ($WildCard -like "*$($NewRule.Match_Name)*") {
                    Write-Host "`n   Fuzzy matching: " -NoNewline; Write-Host $NewRule.Match_Name -ForegroundColor Green
                    Write-Host "   Language pack file: " -NoNewline; Write-Host $WildCard -ForegroundColor Green

                    $OSDefaultUser = (Get-Variable -Name "Init_File_Type_$($item.Name)" -ErrorAction SilentlyContinue).Value
                    $TempSave = @{ Match_Name = $NewRule.Match_Name; FileName = $WildCard }
                    $new = $OSDefaultUser + $TempSave
                    if ($NewRule.IsMatch -eq "Yes") {
                        ForEach ($Component in $Initl_install_Language_Component) {
                            if ($Component -like "*$($NewRule.Match_Name)*") {
                                Write-Host "   Component name: " -NoNewline; Write-Host $Component -ForegroundColor Green

                                New-Variable -Name "Init_File_Type_$($item.Name)" -Value $new -Force
                                $Script:Init_Folder_All_File_Match_Done += $WildCard
                                break
                            }
                        }
                    } else {
                        Write-Host "   Do not match, install directly" -ForegroundColor Yellow
                        New-Variable -Name "Init_File_Type_$($item.Name)" -Value $new -Force
                        $Script:Init_Folder_All_File_Match_Done += $WildCard
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
                Write-Host "   Language pack file: " -NoNewline; Write-Host $item.FileName -ForegroundColor Green
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

Language_Install -Mount "D:\ISOTemp_Custom\Install\Install\Mount" -Sources "D:\ISOTemp_Custom\Install\Install\Language\Add" -Lang "zh-CN"
