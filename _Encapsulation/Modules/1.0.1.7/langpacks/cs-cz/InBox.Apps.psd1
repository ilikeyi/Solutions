ConvertFrom-StringData -StringData @'
	# cs-cz
	# Czech (Czech Republic)

	AdvAppsDetailed                 = Vygenerovat zprávu
	AdvAppsDetailedTips             = Hledejte podle značky regionu, získejte další podrobnosti, když jsou k dispozici balíčky zkušeností s místním jazykem, a vygenerujte soubor sestavy: *.CSV.
	ProcessSources                  = Zdroj zpracování
	InboxAppsManager                = Aplikace Inbox
	InboxAppsMatchDel               = Smazat podle odpovídajících pravidel
	InboxAppsOfflineDel             = Odstraňte zřízenou aplikaci
	InboxAppsClear                  = Vynutit odstranění všech nainstalovaných předaplikací ( InBox Apps )
	InBox_Apps_Match                = Porovnejte aplikace InBox Apps
	InBox_Apps_Check                = Zkontrolujte balíčky závislostí
	InBox_Apps_Check_Tips           = Podle pravidel získejte všechny vybrané položky instalace a ověřte, zda byly vybrány položky závislé instalace.
	LocalExperiencePack             = Balíčky místních jazykových zkušeností ( LXPs )
	LEPBrandNew                     = Novým způsobem, doporučeno
	UWPAutoMissingPacker            = Automaticky vyhledat chybějící balíčky ze všech disků
	UWPAutoMissingPackerSupport     = X64, je třeba nainstalovat chybějící balíčky.
	UWPAutoMissingPackerNotSupport  = Architektura jiná než x64, používá se, když je podporována pouze architektura x64.
	UWPEdition                      = Jedinečný identifikátor verze Windows
	Optimize_Appx_Package           = Optimalizujte poskytování balíčků Appx nahrazením identických souborů pevnými odkazy
	Optimize_ing                    = Optimalizace
	Remove_Appx_Tips                = Ilustrovat: \n\nKrok 1: Přidejte balíčky pro místní jazyk ( LXPs ) Tento krok musí odpovídat příslušnému balíčku oficiálně vydanému společností Microsoft.\n       Přidejte jazykové balíčky do obrazů více relací Windows 10\n       https://learn.microsoft.com/cs-cz/azure/virtual-desktop/language-packs\n\n       Přidejte jazyky do bitových kopií Windows 11 Enterprise\n       https://learn.microsoft.com/cs-cz/azure/virtual-desktop/windows-11-language-packs\n\nKrok 2: Rozbalte nebo připojte *_InboxApps.iso a vyberte adresář podle architektury;\n\nKrok 3: Pokud společnost Microsoft oficiálně nevydala nejnovější balíček místních jazykových zkušeností ( LXPs ), tento krok přeskočte: přečtěte si oficiální oznámení společnosti Microsoft:\n       1. Odpovídající místním jazykovým balíčkům ( LXPs );\n       2. Odpovídající kumulativním aktualizacím. \n\nPředinstalované aplikace ( InBox Apps ) jsou jednojazyčné a je třeba je znovu nainstalovat, abyste získali vícejazyčné. \n\n1. Můžete si vybrat mezi vývojovou verzí a počáteční verzí;\n    Vývojářská verze, například číslo verze je:\n    Windows 11 série\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Počáteční verze, známá počáteční verze: \n    Windows 11 série\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 série\n    Windows 10 22H2, Build 19045.2006\n\n    důležité: \n      a. Vytvořte prosím obrázek znovu, když bude každá verze aktualizována. Například při přechodu z 21.1. na 22.1.\n      b. Toto nařízení bylo jasně sděleno balírnám v různých formách některými výrobci OEM a přímé upgrady z iterativních verzí nejsou povoleny.\n      Klíčová slova: iterace, křížová verze, kumulativní aktualizace.\n\n2. Po instalaci jazykového balíčku je nutné přidat kumulativní aktualizace, protože před přidáním kumulativních aktualizací nebudou mít součásti žádné změny, dokud nebudou nainstalovány kumulativní aktualizace. Například stav součásti: zastaralý , bude vymazáno;\n\n3. Při použití verze s kumulativními aktualizacemi musíte nakonec kumulativní aktualizace znovu přidat, což je opakovaná operace;\n\n4. Proto se doporučuje, abyste během produkce používali verzi bez kumulativních aktualizací a poté v posledním kroku přidali kumulativní aktualizace. \n\nPodmínky vyhledávání po výběru adresáře: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Vyčistěte duplicitní soubory
	ForceRemovaAllUWP               = Přeskočte přidání balíčku zkušeností s místním jazykem ( LXPs ), proveďte jiné
	LEPSkipAddEnglish               = Během instalace se doporučuje přeskočit přidávání en-US.
	LEPSkipAddEnglishTips           = Výchozí anglický jazykový balíček je zbytečné přidávat.
	License                         = Osvědčení
	IsLicense                       = Mít certifikát
	NoLicense                       = Žádný certifikát
	CurrentIsNVeriosn               = Řada verze N
	CurrentNoIsNVersion             = Plně funkční verze
	LXPsWaitAddUpdate               = K aktualizaci
	LXPsWaitAdd                     = Bude přidáno
	LXPsWaitAssign                  = K přidělení
	LXPsWaitRemove                  = Ke smazání
	LXPsAddDelTipsView              = Existují nové tipy, podívejte se nyní
	LXPsAddDelTipsGlobal            = Žádné další výzvy, synchronizujte s globálními
	LXPsAddDelTips                  = Nezobrazovat výzvu znovu
	Instl_Dependency_Package        = Povolit automatické sestavení závislých balíčků při instalaci InBox Apps
	Instl_Dependency_Package_Tips   = Když aplikace, která má být přidána, obsahuje závislé balíčky, automaticky se přizpůsobí podle pravidel a dokončí funkci automatického kombinování požadovaných závislých balíčků.
	Instl_Dependency_Package_Match  = Kombinace závislých balíčků
	Instl_Dependency_Package_Group  = Kombinace
	InBoxAppsErrorNoSave            = Při setkání s chybou není dovoleno uložit
	InBoxAppsErrorTips              = Existují chyby, s nimiž se objevila položka v položce shody {0}, byla neúspěšná
	InBoxAppsErrorNo                = Při shodě nebyly nalezeny žádné chyby
'@