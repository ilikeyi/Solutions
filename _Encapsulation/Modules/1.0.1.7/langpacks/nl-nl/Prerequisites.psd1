ConvertFrom-StringData -StringData @'
	# nl-NL
	# Dutch (Netherlands)

	Prerequisites                   = Vereisten
	Check_PSVersion                 = Controleer PS-versie 5.1 en hoger
	Check_OSVersion                 = Controleer Windows-versie > 10.0.16299.0
	Check_Higher_elevated           = Controle moet worden verhoogd naar hogere rechten
	Check_execution_strategy        = Controleer de uitvoeringsstrategie

	Check_Pass                      = Doorgang
	Check_Did_not_pass              = Mislukt
	Check_Pass_Done                 = Gefeliciteerd, geslaagd.
	How_solve                       = Hoe op te lossen
	UpdatePSVersion                 = Installeer de nieuwste PowerShell-versie
	UpdateOSVersion                 = 1. Ga naar de officiële website van Microsoft om de nieuwste versie van het besturingssysteem te downloaden\n    2. Installeer de nieuwste versie van het besturingssysteem en probeer het opnieuw
	HigherTermail                   = 1. Open Terminal of PowerShell ISE als beheerder, \n       PowerShell-uitvoeringsbeleid instellen: Bypass, PS-opdrachtregel: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Eenmaal opgelost, voert u de opdracht opnieuw uit.
	HigherTermailAdmin              = 1. Open Terminal of PowerShell ISE als beheerder. \n     2. Eenmaal opgelost, voert u de opdracht opnieuw uit.
	LowAndCurrentError              = Minimale versie: {0}, huidige versie: {1}
	Check_Eligible                  = In aanmerking komend
	Check_Version_PSM_Error         = Versiefout. Raadpleeg {0}.psm1. Voorbeeld: upgrade {0}.psm1 opnieuw en probeer het opnieuw.

	Check_OSEnv                     = Controle van de systeemomgeving
	Check_Image_Bad                 = Controleer of de geladen afbeelding beschadigd is
	Check_Need_Fix                  = Kapotte spullen die gerepareerd moeten worden
	Image_Mount_Mode                = Montagemodus
	Image_Mount_Status              = Mount-status
	Check_Compatibility             = Compatibiliteitscontrole
	Check_Duplicate_rule            = Controleer op dubbele regelinvoer
	Duplicates                      = Herhalen
	ISO_File                        = ISO-bestand
	ISO_Langpack                    = ISO-taalpakket
'@