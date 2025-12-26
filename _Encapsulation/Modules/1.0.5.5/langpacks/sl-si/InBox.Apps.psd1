ConvertFrom-StringData -StringData @'
	# sl-SI
	# Slovenian (Slovenia)

	AdvAppsDetailed                 = Ustvari poročilo
	AdvAppsDetailedTips             = Iščite po oznaki regije, pridobite več podrobnosti, ko bodo na voljo lokalni jezikovni paketi izkušenj, in ustvarite datoteko poročila: *.CSV.
	ProcessSources                  = Vir obdelave
	InboxAppsManager                = Aplikacija Inbox
	InboxAppsMatchDel               = Izbriši po pravilih ujemanja
	InboxAppsOfflineDel             = Izbrišite pripravljeno aplikacijo
	InboxAppsClear                  = Prisilna odstranitev vseh vnaprej nameščenih aplikacij ( InBox Apps )
	InBox_Apps_Match                = Match InBox Apps Aplikacije
	InBox_Apps_Check                = Preverite pakete odvisnosti
	InBox_Apps_Check_Tips           = V skladu s pravili pridobite vse izbrane namestitvene elemente in preverite, ali so izbrani odvisni namestitveni elementi.
	LocalExperiencePack             = Paketi lokalnih jezikovnih izkušenj
	LEPBrandNew                     = Na nov način, priporočljivo
	UWPAutoMissingPacker            = Samodejno poiščite manjkajoče pakete na vseh diskih
	UWPAutoMissingPackerSupport     = X64 arhitektura, treba je namestiti manjkajoče pakete.
	UWPAutoMissingPackerNotSupport  = Arhitektura, ki ni x64, uporablja se, ko je podprta samo arhitektura x64.
	UWPEdition                      = Edinstveni identifikator različice sistema Windows
	Optimize_Appx_Package           = Optimizirajte zagotavljanje paketov Appx z zamenjavo enakih datotek s trdimi povezavami
	Optimize_ing                    = Optimizacija
	Remove_Appx_Tips                = Ilustrirati:\n\nPrvi korak: dodajte lokalne jezikovne pakete ( LXPs ). Ta korak mora ustrezati ustreznemu paketu, ki ga je uradno izdal Microsoft.\n       Dodajte jezikovne pakete slikam sistema Windows 10 za več sej\n       https://learn.microsoft.com/sl-si/azure/virtual-desktop/language-packs\n\n       Dodajte jezike slikam sistema Windows 11 Enterprise\n       https://learn.microsoft.com/sl-si/azure/virtual-desktop/windows-11-language-packs\n\n2. korak: Razpakirajte ali namestite *_InboxApps.iso in izberite imenik glede na arhitekturo;\n\n3. korak: Če Microsoft ni uradno izdal najnovejšega paketa lokalne jezikovne izkušnje ( LXPs ), preskočite ta korak; v tem primeru glejte uradno obvestilo Microsofta: \n       1. Ustreza paketom lokalnih jezikovnih izkušenj ( LXPs );\n       2. Ustreza kumulativnim posodobitvam. \n\nVnaprej nameščene aplikacije ( InBox Apps ) so enojezične in jih je treba znova namestiti, da dobite večjezičnost. \n\n1. Izbirate lahko med različico za razvijalce in začetno različico;\n    Različica razvijalca, številka različice je na primer: \n    Windows 11 serije\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Začetna različica, znana začetna različica:\n    Windows 11 serije\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serije\n    Windows 10 22H2, Build 19045.2006\n\n    pomembno: \n      a. Prosimo, da znova ustvarite sliko, ko je posodobljena vsaka različica. Na primer, pri prehodu iz 21H1 v 22H2 ne posodabljajte na podlagi stare slike, da se izognete drugim težavam z združljivostjo.\n      b. To uredbo so nekateri proizvajalci originalne opreme v različnih oblikah jasno sporočili pakirnikom in neposredne nadgradnje iz ponavljajočih se različic niso dovoljene.\n      Ključne besede: iteracija, navzkrižna različica, kumulativna posodobitev.\n\n2. Po namestitvi jezikovnega paketa morate dodati kumulativno posodobitev, ker pred dodajanjem kumulativne posodobitve komponenta ne bo imela nobenih sprememb, dokler ne bo nameščena kumulativna posodobitev. zastarel, za izbris;\n\n3. Pri uporabi različice s kumulativnimi posodobitvami morate na koncu še vedno znova dodati kumulativne posodobitve, kar je ponavljajoča se operacija;\n\n4. Zato je priporočljivo, da med proizvodnjo uporabite različico brez kumulativnih posodobitev in nato v zadnjem koraku dodate kumulativne posodobitve. \n\nPogoji iskanja po izbiri imenika: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Po ekstrakciji se bo prikazal nameščeni ISO. Pravila: 
	ImportCleanDuplicate            = Očistite podvojene datoteke
	ForceRemovaAllUWP               = Preskočite dodatek paketa lokalnih jezikovnih izkušenj ( LXPs ), izvedite drugo
	LEPSkipAddEnglish               = Priporočljivo je, da med namestitvijo preskočite dodajanje en-US.
	LEPSkipAddEnglishTips           = Za dodajanje privzetega angleškega jezikovnega paketa ni potreben.
	License                         = Certifikat
	IsLicense                       = Imeti certifikat
	NoLicense                       = Brez potrdila
	CurrentIsNVeriosn               = Serija različic N
	CurrentNoIsNVersion             = Popolnoma funkcionalna različica
	LXPsWaitAddUpdate               = Za posodobitev
	LXPsWaitAdd                     = Za dodajanje
	LXPsWaitAssign                  = Za dodelitev
	LXPsWaitRemove                  = Za brisanje
	LXPsAddDelTipsView              = Obstajajo novi nasveti, preverite zdaj
	LXPsAddDelTipsGlobal            = Nič več pozivov, sinhronizacija z globalno
	LXPsAddDelTips                  = Ne pozivaj več
	Instl_Dependency_Package        = Dovoli samodejno sestavljanje odvisnih paketov pri namestitvi InBox Apps
	Instl_Dependency_Package_Tips   = Ko ima aplikacija, ki jo želite dodati, odvisne pakete, se bo samodejno ujemala v skladu s pravili in dokončala funkcijo samodejnega združevanja zahtevanih odvisnih paketov.
	Instl_Dependency_Package_Match  = Združevanje paketov odvisnosti
	Instl_Dependency_Package_Group  = Kombinacija
	InBoxAppsErrorNoSave            = Ko naletite na napako, je ni dovoljeno rešiti
	InBoxAppsErrorTips              = Obstajajo napake, element, ki je bil na sporedu v ujemajočem se {0}, ni bil uspešen
	InBoxAppsErrorNo                = V ujemanju ni bilo mogoče najti napak
'@