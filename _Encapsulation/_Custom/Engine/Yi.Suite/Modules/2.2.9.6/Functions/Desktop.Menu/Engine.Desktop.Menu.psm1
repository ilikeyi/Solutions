<#
	.Personalized desktop right click
	.个性化桌面右键
#>
Function Personalise
{
	param
	(
		[switch]$Add,
		[switch]$Del,
		[switch]$Hide
	)

	write-host "  $($lang.DesktopMenu)" -ForegroundColor Green
	if ($Del) {
		write-host "  $($lang.Del)".PadRight(28) -NoNewline
		Remove-Item -Path "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	}

	if ($Add) {
		write-host "  $($lang.AddTo)".PadRight(28) -NoNewline
		$IconFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\.." -ErrorAction SilentlyContinue
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\MainPanel.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel" -Name "MUIVerb" -Value "$($Global:Author)'s Solutions" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).MainPanel\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\Engine.Gift.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir" -Name "MUIVerb" -Value $($lang.Location) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Dir\command" -Name '(default)' -Value "explorer $(Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\.." -ErrorAction SilentlyContinue)" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\FirstExperience.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg" -Name "MUIVerb" -Value $($lang.FirstDeployment) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Reg\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""FirstExperience -Quit\""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\update.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update" -Name "MUIVerb" -Value $($lang.ChkUpdate) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).Update\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""Update -Quit\""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\about.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About" -Name "MUIVerb" -Value $($lang.About) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($Global:Author).About\command" -Name '(default)' -Value "explorer ""$((Get-Module -Name Engine).HelpInfoURI)/go/os""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name "MUIVerb" -Value "$($Global:Author)'s Solutions" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name 'Icon' -Value "$($IconFolder)\Assets\icon\Engine.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name "SeparatorAfter" -Value "" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name "Position" -Value 'Top' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null

		if ($Hide) {
			New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name "Extended" -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		}

		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$($Global:Author)" -Name 'SubCommands' -Value "$($Global:Author).MainPanel;$($Global:Author).Dir;|;$($Global:Author).Update;$($Global:Author).Reg;|;$($Global:Author).About;" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	}
}