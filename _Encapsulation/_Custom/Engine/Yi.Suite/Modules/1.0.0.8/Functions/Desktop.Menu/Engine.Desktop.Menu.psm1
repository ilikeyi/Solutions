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
		Remove-Item -Path "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	}

	if ($Add) {
		write-host "  $($lang.AddTo)".PadRight(28) -NoNewline
		$IconFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\.." -ErrorAction SilentlyContinue
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\MainPanel.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel" -Name "MUIVerb" -Value "$((Get-Module -Name Engine).Author)'s Solutions" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).MainPanel\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\Engine.Gift.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir" -Name "MUIVerb" -Value $($lang.Location) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Dir\command" -Name '(default)' -Value "explorer $($Global:UniqueMainFolder)" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\FirstExperience.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg" -Name "MUIVerb" -Value $($lang.FirstDeployment) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Reg\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""FirstExperience -Quit\""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\update.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update" -Name "MUIVerb" -Value $($lang.ChkUpdate) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).Update\command" -Name '(default)' -Value "powershell.exe -Command ""Start-Process 'Powershell.exe' -Argument '-File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""Update -Quit\""' -Verb RunAs""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About" -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About\command" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\about.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About" -Name "MUIVerb" -Value $($lang.About) -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$((Get-Module -Name Engine).Author).About\command" -Name '(default)' -Value "explorer ""$((Get-Module -Name Engine).HelpInfoURI)/go/os""" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-Item "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name "MUIVerb" -Value "$((Get-Module -Name Engine).Author)'s Solutions" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name 'Icon' -Value "$($IconFolder)\Assets\icons\Engine.ico" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name "SeparatorAfter" -Value "" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name "Position" -Value 'Top' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null

		if ($Hide) {
			New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name "Extended" -Value '' -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		}

		New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\$((Get-Module -Name Engine).Author)" -Name 'SubCommands' -Value "$((Get-Module -Name Engine).Author).MainPanel;$((Get-Module -Name Engine).Author).Dir;|;$((Get-Module -Name Engine).Author).Update;$((Get-Module -Name Engine).Author).Reg;|;$((Get-Module -Name Engine).Author).About;" -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	}
}