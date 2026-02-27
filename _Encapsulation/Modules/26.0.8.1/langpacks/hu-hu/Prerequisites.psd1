ConvertFrom-StringData -StringData @'
	# hu-HU
	# Hungarian (Hungary)

	Prerequisites                   = Preduvjeti
	Check_PSVersion                 = Provjerite PS verziju 5.1 i novije
	Check_OSVersion                 = Provjerite verziju sustava Windows > 10.0.16299.0
	Check_Higher_elevated           = Ček mora biti podignut na više privilegije
	Check_execution_strategy        = Provjerite strategiju izvršenja

	Check_Pass                      = Proći
	Check_Did_not_pass              = Nije uspio
	Check_Pass_Done                 = Čestitam, prošao.
	How_solve                       = Kako riješiti
	UpdatePSVersion                 = Instalirajte najnoviju verziju PowerShell-a
	UpdateOSVersion                 = 1. Idite na Microsoftovo službeno web mjesto kako biste preuzeli najnoviju verziju operativnog sustava\n    2. Instalirajte najnoviju verziju operativnog sustava i pokušajte ponovno
	HigherTermail                   = 1. Otvorite terminal ili PowerShell ISE kao administrator, \n       Postavite politiku izvršavanja PowerShell-a: Zaobiđite, PS naredbeni redak: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Kad se riješi, ponovno pokrenite naredbu.
	HigherTermailAdmin              = 1. Otvorite terminal ili PowerShell ISE kao administrator. \n    2. Kad se riješi, ponovno pokrenite naredbu.
	LowAndCurrentError              = Minimális verzió: {0}, jelenlegi verzió: {1}
	Check_Eligible                  = Jogosult
	Check_Version_PSM_Error         = Verzióhiba, kérjük, olvassa el a következőt: {0}.psm1.Példa, frissítse újra a {0}.psm1 fájlt, és próbálja újra.

	Check_OSEnv                     = Rendszerkörnyezet ellenőrzése
	Check_Image_Bad                 = Ellenőrizze, hogy a betöltött kép nem sérült-e
	Check_Need_Fix                  = Törött tárgyak, amelyeket javítani kell
	Image_Mount_Mode                = Mount mód
	Image_Mount_Status              = Felszerelés állapota
	Check_Compatibility             = Kompatibilitás ellenőrzése
	Check_Duplicate_rule            = Ellenőrizze, hogy vannak-e ismétlődő szabálybejegyzések
	Duplicates                      = Ismétlés
	ISO_File                        = ISO fájl
	ISO_Langpack                    = ISO nyelvi csomag
'@