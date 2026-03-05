ConvertFrom-StringData -StringData @'
	# hr-HR
	# Croatian (Croatia)

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
	UpdateOSVersion                 = 1. Posjetite Microsoftovo službeno web mjesto kako biste preuzeli najnoviju verziju operativnog sustava\n    2. Instalirajte najnoviju verziju operativnog sustava i pokušajte ponovno
	HigherTermail                   = 1. Otvorite terminal ili PowerShell ISE kao administrator, \n       Postavite politiku izvršavanja PowerShell-a: Zaobiđite, PS naredbeni redak: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Kad se riješi, ponovno pokrenite naredbu.
	HigherTermailAdmin              = 1. Otvorite terminal ili PowerShell ISE kao administrator. \n    2. Kad se riješi, ponovno pokrenite naredbu.
	LowAndCurrentError              = Minimalna verzija: {0}, trenutna verzija: {1}
	Check_Eligible                  = Ispunjava uvjete
	Check_Version_PSM_Error         = Pogreška verzije, pogledajte {0}.psm1. Primjer, ponovno nadogradite {0}.psm1 i pokušajte ponovno.

	Check_OSEnv                     = Provjera okruženja sustava
	Check_Image_Bad                 = Provjerite je li učitana slika oštećena
	Check_Need_Fix                  = Polomljeni predmeti koje je potrebno popraviti
	Image_Mount_Mode                = Način montiranja
	Image_Mount_Status              = Status montiranja
	Check_Compatibility             = Provjera kompatibilnosti
	Check_Duplicate_rule            = Provjerite duplicirane unose pravila
	Duplicates                      = Ponoviti
	ISO_File                        = ISO datoteka
	ISO_Langpack                    = ISO jezični paket
'@