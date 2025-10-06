ConvertFrom-StringData -StringData @'
	# cs-cz
	# Czech (Czech Republic)

	Prerequisites                   = Předpoklady
	Check_PSVersion                 = Zkontrolujte verzi PS 5.1 a vyšší
	Check_OSVersion                 = Zkontrolujte verzi Windows > 10.0.16299.0
	Check_Higher_elevated           = Kontrola musí být povýšena na vyšší oprávnění
	Check_execution_strategy        = Zkontrolujte strategii provádění

	Check_Pass                      = Přihrávka
	Check_Did_not_pass              = Nepodařilo
	Check_Pass_Done                 = Gratuluji, prospělo.
	How_solve                       = Jak řešit
	UpdatePSVersion                 = Nainstalujte si prosím nejnovější verzi PowerShellu
	UpdateOSVersion                 = 1. Přejděte na oficiální web společnosti Microsoft a stáhněte si nejnovější verzi operačního systému\n    2. Nainstalujte nejnovější verzi operačního systému a zkuste to znovu
	HigherTermail                   = 1. Otevřete terminál nebo PowerShell ISE jako správce, \n       Nastavit zásady provádění PowerShellu: Obejít, příkazový řádek PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Po vyřešení spusťte příkaz znovu.
	HigherTermailAdmin              = 1. Otevřete terminál nebo PowerShell ISE jako správce. \n     2. Po vyřešení spusťte příkaz znovu.
	LowAndCurrentError              = Minimální verze: {0}, aktuální verze: {1}
	Check_Eligible                  = Oprávněný
	Check_Version_PSM_Error         = Chyba verze, viz {0}.psm1.Příklad, znovu upgradujte soubor {0}.psm1 a zkuste to znovu.

	Check_OSEnv                     = Kontrola prostředí systému
	Check_Image_Bad                 = Zkontrolujte, zda není načtený obrázek poškozen
	Check_Need_Fix                  = Rozbité předměty, které je třeba opravit
	Image_Mount_Mode                = Režim montáže
	Image_Mount_Status              = Stav připojení
	Check_Compatibility             = Kontrola kompatibility
	Check_Duplicate_rule            = Zkontrolujte duplicitní položky pravidel
	Duplicates                      = Opakovat
	ISO_File                        = ISO soubor
	ISO_Langpack                    = Jazykový balíček ISO
'@