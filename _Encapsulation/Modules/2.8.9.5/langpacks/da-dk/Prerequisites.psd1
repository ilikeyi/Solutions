ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	Prerequisites                   = Forudsætninger
	Check_PSVersion                 = Tjek PS version 5.1 og nyere
	Check_OSVersion                 = Tjek Windows version > 10.0.16299.0
	Check_Higher_elevated           = Check skal hæves til højere privilegier
	Check_execution_strategy        = Tjek udførelsesstrategi

	Check_Pass                      = Passere
	Check_Did_not_pass              = Mislykkedes
	Check_Pass_Done                 = Tillykke, bestået.
	How_solve                       = Sådan løses
	UpdatePSVersion                 = Installer venligst den seneste PowerShell version
	UpdateOSVersion                 = 1. Gå til Microsofts officielle hjemmeside for at downloade den seneste version af operativsystemet\n    2. Installer den seneste version af operativsystemet, og prøv igen
	HigherTermail                   = 1. Åbn Terminal eller PowerShell ISE som administrator, \n       Indstil PowerShell udførelsespolitik: Bypass, PS kommandolinje: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Når det er løst, kør kommandoen igen.
	HigherTermailAdmin              = 1. Åbn Terminal eller PowerShell ISE som administrator. \n    2. Når det er løst, kør kommandoen igen.
	LowAndCurrentError              = Minimumversion: {0}, nuværende version: {1}
	Check_Eligible                  = Berettiget
	Check_Version_PSM_Error         = Versionsfejl, se venligst {0}.psm1. Eksempel, genopgrader {0}.psm1 og prøv igen.

	Check_OSEnv                     = Systemmiljøtjek
	Check_Image_Bad                 = Tjek, om det indlæste billede er beskadiget
	Check_Need_Fix                  = Ødelagte ting, der skal repareres
	Image_Mount_Mode                = Monteringstilstand
	Image_Mount_Status              = Monteringsstatus
	Check_Compatibility             = Kompatibilitetstjek
	Check_Duplicate_rule            = Tjek for duplikerede regelindtastninger
	Duplicates                      = Gentage
	ISO_File                        = ISO fil
	ISO_Langpack                    = ISO sprogpakke
'@