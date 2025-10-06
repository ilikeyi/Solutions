@{
	RootModule        = 'LXPs.psm1'
	ModuleVersion     = '1.0.1.0'
	GUID              = 'f80caca0-10a7-453c-91f9-ea04f4f32f92'
	Author            = 'Yi'
	Copyright         = 'FengYi, Inc. All rights reserved.'
	Description       = ''
	PowerShellVersion = '5.1'
	NestedModules     = @()
	FunctionsToExport = '*'
	CmdletsToExport   = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'

	PrivateData = @{
		PSData = @{
			Tags         = @("LXPs")
			LicenseUri   = 'https://opensource.org/license/mit'
			ProjectUri   = @(
				'https://github.com/ilikeyi/LXPs'
			)
#			IconUri      = ''
#			ReleaseNotes = ''
			Buildstring    = 'yi_release.2025.1.7'
			MinimumVersion = '1.0.0.0'
			UpdateServer = @(
				"https://fengyi.tel/download/solutions/update/LXPs/latest.json"
				"https://github.com/ilikeyi/LXPs/raw/main/update/latest.json"
			)
		}
	}
	HelpInfoURI = 'https://fengyi.tel'
#	DefaultCommandPrefix = ''
}