ConvertFrom-StringData -StringData @'
	# hu-HU
	# Hungarian (Hungary)

	AdvAppsDetailed                 = Jelentés generálása
	AdvAppsDetailedTips             = Keressen régiócímke szerint, tájékozódjon további részletekről, ha rendelkezésre állnak a helyi nyelvi élménycsomagok, és készítsen jelentésfájlt: *.CSV.
	ProcessSources                  = Feldolgozási forrás
	InboxAppsManager                = Inbox alkalmazás
	InboxAppsMatchDel               = Törlés szabályok egyeztetésével
	InboxAppsOfflineDel             = Kiépített alkalmazás törlése
	InboxAppsClear                  = Az összes telepített előzetes alkalmazás kényszerített eltávolítása (InBox alkalmazások)
	InBox_Apps_Match                = Párosítsa az InBox Apps alkalmazásokat
	InBox_Apps_Check                = Ellenőrizze a függőségi csomagokat
	InBox_Apps_Check_Tips           = A szabályoknak megfelelően szerezze be az összes kiválasztott telepítési elemet, és ellenőrizze, hogy a függő telepítési elemek kiválasztásra kerültek-e.
	LocalExperiencePack             = Helyi nyelvi élménycsomagok ( LXPs )
	LEPBrandNew                     = Új módon, ajánlott
	UWPAutoMissingPacker            = A hiányzó csomagok automatikus keresése az összes lemezről
	UWPAutoMissingPackerSupport     = X64 architektúra, a hiányzó csomagokat telepíteni kell.
	UWPAutoMissingPackerNotSupport  = Nem x64 architektúra, akkor használatos, ha csak az x64 architektúra támogatott.
	UWPEdition                      = A Windows verzió egyedi azonosítója
	Optimize_Appx_Package           = Optimalizálja az Appx-csomagok kiépítését az azonos fájlok merev hivatkozásokkal való helyettesítésével
	Optimize_ing                    = Optimalizálás
	Remove_Appx_Tips                = Szemléltet:\n\nElső lépés: Helyi nyelvi élménycsomagok ( LXPs ) hozzáadása Ennek a lépésnek meg kell felelnie a Microsoft által hivatalosan kiadott megfelelő csomagnak.\n       Nyelvi csomagok hozzáadása a Windows 10 több munkamenetes képeihez\n       https://learn.microsoft.com/hu-hu/azure/virtual-desktop/language-packs\n\n       Nyelvek hozzáadása a Windows 11 Enterprise rendszerképekhez\n       https://learn.microsoft.com/hu-hu/azure/virtual-desktop/windows-11-language-packs\n\n2. lépés: Csomagolja ki vagy csatolja be az *_InboxApps.iso fájlt, és válassza ki a könyvtárat az architektúrának megfelelően;\n\n3. lépés: Ha a Microsoft nem adta ki hivatalosan a legújabb helyi nyelvi élménycsomagot ( LXPs ), hagyja ki ezt a lépést: olvassa el a Microsoft hivatalos közleményét:\n       1. Helyi nyelvi élménycsomagoknak (LXP-knek) megfelelő;\n       2. Az összesített frissítéseknek megfelelően. \n\nAz előre telepített alkalmazások ( InBox Apps ) egynyelvűek, és újra kell telepíteni a többnyelvű használathoz. \n\n1. Választhat a fejlesztői verzió és a kezdeti verzió között;\n    A fejlesztői verzió például a verziószám: \n    Windows 11 sorozat\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Kezdeti verzió, ismert kezdeti verzió: \n    Windows 11 sorozat\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 sorozat\n    Windows 10 22H2, Build 19045.2006\n\n    fontos: \n      a. Kérjük, hozza létre újra a képet az egyes verziók frissítésekor. Ha például a 21H1-ről a 22H2-re vált, kérjük, ne frissítse a régi kép alapján, hogy elkerülje az egyéb kompatibilitási problémákat.\n      b. Ezt a szabályozást egyes OEM-gyártók különböző formákban egyértelműen közölték a csomagolókkal, és az iteratív verziókból történő közvetlen frissítés nem megengedett.\n      Kulcsszavak: iteráció, több verzió, kumulatív frissítés.\n\n2. A nyelvi csomag telepítése után hozzáadnia kell egy összesített frissítést, mert az összesített frissítés hozzáadása előtt az összetevő nem változtatja meg az összesített frissítést. Például az összetevő állapota: elavult, törlendő;\n\n3. Ha kumulatív frissítéssel rendelkező verziót használ, akkor is a végén újra fel kell vennie az összesített frissítéseket, ami ismétlődő művelet;\n\n4. Ezért azt javasoljuk, hogy a termelés során olyan verziót használjon, amely nem tartalmaz összesített frissítéseket, majd az utolsó lépésben adja hozzá az összesített frissítéseket. \n\nKeresési feltételek a könyvtár kiválasztása után: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Tisztítsa meg a duplikált fájlokat
	ForceRemovaAllUWP               = Hagyja ki a helyi nyelvi élménycsomag ( LXPs ) hozzáadását, hajtson végre mást
	LEPSkipAddEnglish               = A telepítés során ajánlatos kihagyni az en-US hozzáadást.
	LEPSkipAddEnglishTips           = Az alapértelmezett angol nyelvi csomag nem szükséges hozzá.
	License                         = Bizonyítvány
	IsLicense                       = Legyen bizonyítvány
	NoLicense                       = Nincs tanúsítvány
	CurrentIsNVeriosn               = N verzió sorozat
	CurrentNoIsNVersion             = Teljesen működőképes verzió
	LXPsWaitAddUpdate               = Frissítendő
	LXPsWaitAdd                     = Hozzá kell adni
	LXPsWaitAssign                  = Ki kell osztani
	LXPsWaitRemove                  = Törölni kell
	LXPsAddDelTipsView              = Vannak új tippek, nézze meg most
	LXPsAddDelTipsGlobal            = Nincs több felszólítás, szinkronizálás globálisra
	LXPsAddDelTips                  = Ne kérdezzen újra
	Instl_Dependency_Package        = Az InBox Apps telepítésekor engedélyezze a függő csomagok automatikus összeállítását
	Instl_Dependency_Package_Tips   = Ha a hozzáadandó alkalmazás függő csomagokkal rendelkezik, az automatikusan illeszkedik a szabályoknak megfelelően, és befejezi a szükséges függő csomagok automatikus kombinálását.
	Instl_Dependency_Package_Match  = Függőségi csomagok kombinálása
	Instl_Dependency_Package_Group  = Kombináció
	InBoxAppsErrorNoSave            = Ha hibát tapasztal, akkor nem szabad megmenteni
	InBoxAppsErrorTips              = Vannak hibák, a megfelelő {0} elemben tapasztalt elem sikertelen volt
	InBoxAppsErrorNo                = A megfelelőségben nem találtak hibákat
'@