ConvertFrom-StringData -StringData @'
	# nb-NO
	# Norwegian, Bokmål (Norway)

	Prerequisites                   = Forutsetninger
	Check_PSVersion                 = Sjekk PS versjon 5.1 og nyere
	Check_OSVersion                 = Sjekk Windows-versjon > 10.0.16299.0
	Check_Higher_elevated           = Sjekk må heves til høyere privilegier
	Check_execution_strategy        = Sjekk utførelsesstrategi

	Check_Pass                      = Pass
	Check_Did_not_pass              = Mislyktes
	Check_Pass_Done                 = Gratulerer, bestått.
	How_solve                       = Hvordan løse
	UpdatePSVersion                 = Installer den nyeste PowerShell-versjonen
	UpdateOSVersion                 = 1. Gå til Microsofts offisielle nettsted for å laste ned den nyeste versjonen av operativsystemet\n    2. Installer den nyeste versjonen av operativsystemet og prøv igjen
	HigherTermail                   = 1. Åpne Terminal eller PowerShell ISE som administrator, \n       Angi PowerShell-utførelsespolicy: Bypass, PS-kommandolinje: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Når det er løst, kjør kommandoen på nytt.
	HigherTermailAdmin              = 1. Åpne Terminal eller PowerShell ISE som administrator.\n     2. Når det er løst, kjør kommandoen på nytt.
	LowAndCurrentError              = Minimumsversjon: {0}, gjeldende versjon: {1}
	Check_Eligible                  = Berettiget
	Check_Version_PSM_Error         = Versjonsfeil, se {0}.psm1.Example, oppgrader {0}.psm1 på nytt og prøv på nytt.

	Check_OSEnv                     = Systemmiljøsjekk
	Check_Image_Bad                 = Sjekk om det lastede bildet er ødelagt
	Check_Need_Fix                  = Ødelagte gjenstander som må repareres
	Image_Mount_Mode                = Monteringsmodus
	Image_Mount_Status              = Monteringsstatus
	Check_Compatibility             = Kompatibilitetssjekk
	Check_Duplicate_rule            = Se etter dupliserte regeloppføringer
	Duplicates                      = Gjenta
	ISO_File                        = ISO-fil
	ISO_Langpack                    = ISO språkpakke
'@