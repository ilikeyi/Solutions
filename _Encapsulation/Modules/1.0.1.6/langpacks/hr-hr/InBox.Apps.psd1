ConvertFrom-StringData -StringData @'
	# hr-HR
	# Croatian (Croatia)

	AdvAppsDetailed                 = Generiraj izvješće
	AdvAppsDetailedTips             = Pretražujte po oznaci regije, saznajte više pojedinosti kada paketi iskustva na lokalnom jeziku budu dostupni i generirajte datoteku izvješća: *.CSV.
	ProcessSources                  = Izvor obrade
	InboxAppsManager                = Aplikacija Inbox
	InboxAppsMatchDel               = Brisanje po odgovarajućim pravilima
	InboxAppsOfflineDel             = Brisanje dodijeljene aplikacije
	InboxAppsClear                  = Prisilno uklanjanje svih instaliranih pred-aplikacija ( InBox Apps )
	InBox_Apps_Match                = Podudaranje InBox Apps Apps
	InBox_Apps_Check                = Provjerite pakete ovisnosti
	InBox_Apps_Check_Tips           = U skladu s pravilima, nabavite sve odabrane stavke instalacije i provjerite jesu li odabrane zavisne stavke instalacije.
	LocalExperiencePack             = Paketi iskustva lokalnog jezika ( LXPs )
	LEPBrandNew                     = Na novi način, preporuka
	UWPAutoMissingPacker            = Automatsko traženje paketa koji nedostaju sa svih diskova
	UWPAutoMissingPackerSupport     = X64 arhitektura, potrebno je instalirati pakete koji nedostaju.
	UWPAutoMissingPackerNotSupport  = Arhitektura koja nije x64, koristi se kada je podržana samo x64 arhitektura.
	UWPEdition                      = Jedinstveni identifikator verzije sustava Windows
	Optimize_Appx_Package           = Optimizirajte pružanje Appx paketa zamjenom identičnih datoteka tvrdim vezama
	Optimize_ing                    = Optimiziranje
	Remove_Appx_Tips                = Ilustrirati:\n\nPrvi korak: Dodajte pakete lokalnog jezika ( LXPs ) Ovaj korak mora odgovarati odgovarajućem paketu koji je službeno objavio Microsoft.\n       Dodajte jezične pakete Windows 10 slikama za više sesija\n       https://learn.microsoft.com/hr-hr/azure/virtual-desktop/language-packs\n\n       Dodajte jezike slikama sustava Windows 11 Enterprise\n       https://learn.microsoft.com/hr-hr/azure/virtual-desktop/windows-11-language-packs\n\nKorak 2: Raspakirajte ili montirajte *_InboxApps.iso i odaberite direktorij prema arhitekturi;\n\nKorak 3: Ako Microsoft nije službeno objavio najnoviji paket iskustva na lokalnom jeziku ( LXPs ), preskočite ovaj korak ako je tako: pogledajte službenu objavu Microsofta:\n       1. Odgovara paketima iskustva lokalnog jezika ( LXPs );\n       2. Odgovara kumulativnim ažuriranjima. \n\nUnaprijed instalirane aplikacije ( InBox Apps ) su na jednom jeziku i potrebno ih je ponovno instalirati da biste dobili više jezika. \n\n1. Možete birati između verzije razvojnog programera i početne verzije;\n    Verzija programera, na primjer, broj verzije je: \n    Windows 11 niz\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Početna verzija, poznata početna verzija: \n    Windows 11 niz\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 niz\n    Windows 10 22H2, Build 19045.2006\n\n    važno: \n      a. Molimo ponovno izradite sliku kada se svaka verzija ažurira, na primjer, nemojte ažurirati na temelju stare slike kako biste izbjegli druge probleme s kompatibilnošću. Ponovno koristite početnu verziju.\n      b. Neki proizvođači OEM-a ovu su uredbu jasno priopćili pakirivačima u različitim oblicima, a izravne nadogradnje iz iterativnih verzija nisu dopuštene.\n      Ključne riječi: iteracija, unakrsna verzija, kumulativno ažuriranje.\n\n2. Nakon instaliranja jezičnog paketa, morate dodati kumulativno ažuriranje, jer prije nego što se kumulativno ažuriranje doda, komponenta neće imati nikakvih promjena. Do novih promjena neće doći dok se kumulativno ažuriranje ne instalira. zastario, za brisanje;\n\n3. Kada koristite verziju s kumulativnim ažuriranjima, još uvijek na kraju morate ponovo dodati kumulativna ažuriranja, što je ponovljena operacija;\n\n4. Stoga se preporučuje da koristite verziju bez kumulativnih ažuriranja tijekom proizvodnje, a zatim dodate kumulativna ažuriranja u zadnjem koraku. \n\nUvjeti pretraživanja nakon odabira direktorija: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Očistite duplicirane datoteke
	ForceRemovaAllUWP               = Preskoči dodavanje paketa doživljaja lokalnog jezika ( LXPs ), izvedi drugo
	LEPSkipAddEnglish               = Preporuča se preskočiti en-US dodavanje tijekom instalacije.
	LEPSkipAddEnglishTips           = Zadani paket engleskog jezika nije potreban za njegovo dodavanje.
	License                         = Potvrda
	IsLicense                       = Imati certifikat
	NoLicense                       = Nema certifikata
	CurrentIsNVeriosn               = N verzija serije
	CurrentNoIsNVersion             = Potpuno funkcionalna verzija
	LXPsWaitAddUpdate               = Za ažuriranje
	LXPsWaitAdd                     = Za dodavanje
	LXPsWaitAssign                  = Za dodjelu
	LXPsWaitRemove                  = Za brisanje
	LXPsAddDelTipsView              = Postoje novi savjeti, provjerite sada
	LXPsAddDelTipsGlobal            = Nema više upita, sinkroniziraj na globalno
	LXPsAddDelTips                  = Nemoj ponovno tražiti
	Instl_Dependency_Package        = Dopusti automatsko sastavljanje zavisnih paketa prilikom instaliranja InBox Apps
	Instl_Dependency_Package_Tips   = Kada aplikacija koju treba dodati ima ovisne pakete, automatski će se uskladiti prema pravilima i dovršiti funkciju automatskog kombiniranja potrebnih ovisnih paketa.
	Instl_Dependency_Package_Match  = Kombiniranje paketa ovisnosti
	Instl_Dependency_Package_Group  = Kombinacija
	InBoxAppsErrorNoSave            = Kada se susretnete s pogreškom, nije dopušteno spasiti
	InBoxAppsErrorTips              = Postoje pogreške, a stavka se susreće u podudarnoj {0} stavka nije bila uspješna
	InBoxAppsErrorNo                = U podudaranju nisu pronađene pogreške
'@