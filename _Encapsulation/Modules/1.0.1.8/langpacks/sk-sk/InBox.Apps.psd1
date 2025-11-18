ConvertFrom-StringData -StringData @'
	# sk-SK
	# Slovak (Slovakia)

	AdvAppsDetailed                 = Vygenerovať prehľad
	AdvAppsDetailedTips             = Vyhľadajte podľa značky regiónu, získajte ďalšie podrobnosti, keď sú k dispozícii balíčky skúseností s miestnym jazykom, a vygenerujte súbor správy: *.CSV.
	ProcessSources                  = Zdroj spracovania
	InboxAppsManager                = Aplikácia Inbox
	InboxAppsMatchDel               = Odstrániť podľa zodpovedajúcich pravidiel
	InboxAppsOfflineDel             = Odstráňte zabezpečenú aplikáciu
	InboxAppsClear                  = Vynútiť odstránenie všetkých nainštalovaných predbežných aplikácií ( InBox Apps )
	InBox_Apps_Match                = Priraďte InBox Apps Apps
	InBox_Apps_Check                = Skontrolujte balíčky závislostí
	InBox_Apps_Check_Tips           = Podľa pravidiel získajte všetky vybrané položky inštalácie a overte, či boli vybraté závislé položky inštalácie.
	LocalExperiencePack             = Balíky miestnych jazykových skúseností ( LXPs )
	LEPBrandNew                     = Novým spôsobom, odporúčané
	UWPAutoMissingPacker            = Automaticky vyhľadať chýbajúce balíčky zo všetkých diskov
	UWPAutoMissingPackerSupport     = X64, je potrebné nainštalovať chýbajúce balíčky.
	UWPAutoMissingPackerNotSupport  = Architektúra iná ako x64, používa sa, keď je podporovaná iba architektúra x64.
	UWPEdition                      = Jedinečný identifikátor verzie systému Windows
	Optimize_Appx_Package           = Optimalizujte poskytovanie balíkov Appx nahradením rovnakých súborov pevnými odkazmi
	Optimize_ing                    = Optimalizácia
	Remove_Appx_Tips                = Ilustrovať:\n\nPrvý krok: Pridajte balíky skúseností s lokálnym jazykom ( LXPs ) Tento krok musí zodpovedať príslušnému balíku oficiálne vydaným spoločnosťou Microsoft.\n       Pridajte jazykové balíky do obrazov s viacerými reláciami systému Windows 10\n       https://learn.microsoft.com/sk-sk/azure/virtual-desktop/language-packs\n\n       Pridajte jazyky do obrázkov Windows 11 Enterprise\n       https://learn.microsoft.com/sk-sk/azure/virtual-desktop/windows-11-language-packs\n\nKrok 2: Rozbaľte alebo pripojte *_InboxApps.iso a vyberte adresár podľa architektúry;\n\nKrok 3: Ak spoločnosť Microsoft oficiálne nevydala najnovší balík lokálnych jazykových skúseností ( LXPs ), tento krok preskočte: pozrite si oficiálne oznámenie od spoločnosti Microsoft:\n       1. Zodpovedajúce balíkom miestnych jazykových skúseností ( LXPs );\n       2. Zodpovedajúce kumulatívnym aktualizáciám. \n\nPredinštalované aplikácie ( InBox Apps ) sú jednojazyčné a ak chcete získať viacjazyčné, musíte ich preinštalovať. \n\n1. Môžete si vybrať medzi vývojárskou verziou a počiatočnou verziou;\n    Verzia vývojára, napríklad číslo verzie je:\n    Windows 11 séria\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Počiatočná verzia, známa počiatočná verzia: \n    Windows 11 séria\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 séria\n    Windows 10 22H2, Build 19045.2006\n\n    dôležité:\n      a. Po aktualizácii každej verzie znova vytvorte obrázok. Napríklad pri prechode z 21H1. hodiny na 21H2. hodinu neaktualizujte na základe starého obrázka, aby ste predišli iným problémom s kompatibilitou.\n      b. Toto nariadenie bolo jasne oznámené baličom v rôznych formách niektorými výrobcami OEM a priame aktualizácie z iteračných verzií nie sú povolené.\n      Kľúčové slová: iterácia, krížová verzia, kumulatívna aktualizácia.\n\n2. Po nainštalovaní jazykového balíka musíte pridať kumulatívnu aktualizáciu, pretože pred pridaním kumulatívnej aktualizácie nebudú na komponente žiadne zmeny, kým sa nenainštaluje kumulatívna aktualizácia. zastarané, treba vypustiť;\n\n3. Pri použití verzie s kumulatívnymi aktualizáciami musíte na konci stále znova pridať kumulatívne aktualizácie, čo je opakovaná operácia;\n\n4. Preto sa odporúča, aby ste počas produkcie používali verziu bez kumulatívnych aktualizácií a potom v poslednom kroku pridali kumulatívne aktualizácie. \n\nPodmienky vyhľadávania po výbere adresára: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Vyčistite duplicitné súbory
	ForceRemovaAllUWP               = Preskočte pridanie balíka skúseností s miestnym jazykom ( LXPs ), vykonajte iné
	LEPSkipAddEnglish               = Počas inštalácie sa odporúča preskočiť pridávanie en-US.
	LEPSkipAddEnglishTips           = Predvolený anglický jazykový balík nie je potrebné pridať.
	License                         = Certifikát
	IsLicense                       = Majte certifikát
	NoLicense                       = Žiadny certifikát
	CurrentIsNVeriosn               = Séria verzie N
	CurrentNoIsNVersion             = Plne funkčná verzia
	LXPsWaitAddUpdate               = Na aktualizáciu
	LXPsWaitAdd                     = Na doplnenie
	LXPsWaitAssign                  = Na pridelenie
	LXPsWaitRemove                  = Na vymazanie
	LXPsAddDelTipsView              = Existujú nové tipy, skontrolujte ich
	LXPsAddDelTipsGlobal            = Už žiadne výzvy, synchronizujte s globálnymi
	LXPsAddDelTips                  = Nezobrazovať výzvu znova
	Instl_Dependency_Package        = Povoliť automatické zostavovanie závislých balíkov pri inštalácii aplikácií InBox
	Instl_Dependency_Package_Tips   = Keď aplikácia, ktorá sa má pridať, obsahuje závislé balíky, automaticky sa zhoduje podľa pravidiel a dokončí funkciu automatického kombinovania požadovaných závislých balíkov.
	Instl_Dependency_Package_Match  = Kombinácia balíkov závislostí
	Instl_Dependency_Package_Group  = Kombinácia
	InBoxAppsErrorNoSave            = Pri stretnutí s chybou nie je dovolené uložiť
	InBoxAppsErrorTips              = Existujú chyby, položka sa vyskytla v položke zhody {0}, ktorá bola neúspešná
	InBoxAppsErrorNo                = Pri zhode sa nenašli žiadne chyby
'@