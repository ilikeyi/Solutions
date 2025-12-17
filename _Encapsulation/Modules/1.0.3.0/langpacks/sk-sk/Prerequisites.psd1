ConvertFrom-StringData -StringData @'
	# sk-SK
	# Slovak (Slovakia)

	Prerequisites                   = Predpoklady
	Check_PSVersion                 = Skontrolujte verziu PS 5.1 a vyššiu
	Check_OSVersion                 = Skontrolujte verziu systému Windows > 10.0.16299.0
	Check_Higher_elevated           = Kontrola musí byť povýšená na vyššie oprávnenia
	Check_execution_strategy        = Skontrolujte stratégiu vykonávania

	Check_Pass                      = Prejsť
	Check_Did_not_pass              = Nepodarilo
	Check_Pass_Done                 = Gratulujem, prešiel.
	How_solve                       = Ako vyriešiť
	UpdatePSVersion                 = Nainštalujte si najnovšiu verziu prostredia PowerShell
	UpdateOSVersion                 = 1. Prejdite na oficiálnu webovú stránku spoločnosti Microsoft a stiahnite si najnovšiu verziu operačného systému\n    2. Nainštalujte najnovšiu verziu operačného systému a skúste to znova
	HigherTermail                   = 1. Otvorte terminál alebo PowerShell ISE ako správca, \n       Nastaviť politiku vykonávania prostredia PowerShell: Obísť, príkazový riadok PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Po vyriešení príkaz znova spustite.
	HigherTermailAdmin              = 1. Otvorte terminál alebo PowerShell ISE ako správca. \n    2. Po vyriešení príkaz znova spustite.
	LowAndCurrentError              = Minimálna verzia: {0}, aktuálna verzia: {1}
	Check_Eligible                  = Oprávnené
	Check_Version_PSM_Error         = Chyba verzie, pozrite si súbor {0}.psm1. Príklad, znova inovujte súbor {0}.psm1 a skúste to znova.

	Check_OSEnv                     = Kontrola prostredia systému
	Check_Image_Bad                 = Skontrolujte, či načítaný obrázok nie je poškodený
	Check_Need_Fix                  = Rozbité predmety, ktoré je potrebné opraviť
	Image_Mount_Mode                = Režim montáže
	Image_Mount_Status              = Stav pripojenia
	Check_Compatibility             = Kontrola kompatibility
	Check_Duplicate_rule            = Skontrolujte duplicitné položky pravidiel
	Duplicates                      = Opakovať
	ISO_File                        = ISO súbor
	ISO_Langpack                    = Jazykový balík ISO
'@