ConvertFrom-StringData -StringData @'
	# et-ee
	# Estonian (Estonia)

	AdvAppsDetailed                 = Loo aruanne
	AdvAppsDetailedTips             = Otsige piirkonnasildi järgi, hankige lisateavet, kui kohaliku keele kogemuspaketid on saadaval, ja looge aruandefail: *.CSV.
	ProcessSources                  = Töötlemise allikas
	InboxAppsManager                = Postkasti rakendus
	InboxAppsMatchDel               = Kustutage reeglite sobitamise teel
	InboxAppsOfflineDel             = Varustatud rakenduse kustutamine
	InboxAppsClear                  = Eemaldage jõuga kõik installitud eelrakendused ( InBox Apps )
	InBox_Apps_Match                = Vaste InBox Apps rakendus
	InBox_Apps_Check                = Kontrollige sõltuvuspakette
	InBox_Apps_Check_Tips           = Vastavalt reeglitele hankige kõik valitud installielemendid ja kontrollige, kas sõltuvad installielemendid on valitud.
	LocalExperiencePack             = Kohalikud keelekogemuse paketid
	LEPBrandNew                     = Uuel viisil, soovitatav
	UWPAutoMissingPacker            = Otsige automaatselt puuduvaid pakette kõigilt ketastelt
	UWPAutoMissingPackerSupport     = X64 arhitektuur, puuduvad paketid tuleb installida.
	UWPAutoMissingPackerNotSupport  = Mitte-x64 arhitektuur, kasutatakse siis, kui toetatakse ainult x64 arhitektuuri.
	UWPEdition                      = Windowsi versiooni kordumatu identifikaator
	Optimize_Appx_Package           = Optimeerige Appx-pakettide pakkumist, asendades identsed failid kõvade linkidega
	Optimize_ing                    = Optimeerimine
	Remove_Appx_Tips                = Illustreerima:\n\nEsimene samm: lisage kohalikud keelekogemuse paketid ( LXPs ). See samm peab vastama Microsofti ametlikult välja antud paketile.\n       Lisage keelepakette Windows 10 mitme seansi piltidele\n       https://learn.microsoft.com/et-ee/azure/virtual-desktop/language-packs\n\n       Lisage Windows 11 Enterprise piltidele keeli\n       https://learn.microsoft.com/et-ee/azure/virtual-desktop/windows-11-language-packs\n\n2. samm: pakkige lahti või ühendage *_InboxApps.iso ja valige kataloog vastavalt arhitektuurile;\n\n3. samm: kui Microsoft pole ametlikult välja andnud uusimat kohaliku keele kogemuse paketti ( LXPs ), jätke see samm vahele: vaadake Microsofti ametlikku teadaannet:\n       1. Vastavad kohalikele keelekogemuspakettidele ( LXPs );\n       2. Vastab kumulatiivsetele värskendustele. \n\nEelinstallitud rakendused ( InBox Apps ) on ühes keeles ja mitmekeelseks kasutamiseks tuleb need uuesti installida. \n\n1. Saate valida arendaja versiooni ja esialgse versiooni vahel;\n    Näiteks arendaja versioon on versiooni number: \n    Windows 11 seeria\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Esialgne versioon, teadaolev esialgne versioon: \n    Windows 11 seeria\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 seeria\n    Windows 10 22H2, Build 19045.2006\n\n    oluline: \n      a. Looge pilt uuesti, kui iga versioon on värskendatud. Näiteks 21H1 versioonile 22H2 üleminekul ärge värskendage vana pildi alusel, et vältida muid ühilduvusprobleeme.\n     b. Mõned originaalseadmete tootjad on sellest määrusest pakendajatele eri vormides selgelt edastanud ja iteratiivsete versioonide otsene uuendamine ei ole lubatud.\n      Märksõnad: iteratsioon, ristversioon, kumulatiivne värskendus.\n\n2. Pärast keelepaketi installimist tuleb lisada kumulatiivsed värskendused, sest enne kumulatiivsete värskenduste lisamist ei toimu uusi muudatusi enne, kui kumulatiivsed värskendused on installitud , kustutatakse;\n\n3. Kumulatiivsete uuendustega versiooni kasutamisel tuleb ikkagi lõpuks kumulatiivsed uuendused uuesti lisada, mis on korduv toiming;\n\n4. Seetõttu on soovitatav tootmise ajal kasutada ilma kumulatiivsete värskendusteta versiooni ja seejärel lisada viimases etapis kumulatiivsed värskendused. \n\nOtsingutingimused pärast kataloogi valimist: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Pärast eemaldamist ilmub paigaldatud ISO-fail nähtavale. Reeglid: 
	ImportCleanDuplicate            = Puhastage duplikaatfailid
	ForceRemovaAllUWP               = Jäta vahele kohaliku keelekogemuse paketi ( LXPs ) lisamine, teosta muu
	LEPSkipAddEnglish               = Installimise ajal on soovitatav en-US lisamine vahele jätta.
	LEPSkipAddEnglishTips           = Inglise keele vaikekeelepaketti pole selle lisamiseks vaja.
	License                         = Tunnistus
	IsLicense                       = Omama sertifikaati
	NoLicense                       = Sertifikaadi pole
	CurrentIsNVeriosn               = N versiooni seeria
	CurrentNoIsNVersion             = Täisfunktsionaalne versioon
	LXPsWaitAddUpdate               = Uuendatakse
	LXPsWaitAdd                     = Lisatakse
	LXPsWaitAssign                  = Eraldada
	LXPsWaitRemove                  = Kustutamisele
	LXPsAddDelTipsView              = On uusi näpunäiteid, kontrollige kohe
	LXPsAddDelTipsGlobal            = Enam pole viipasid, sünkroonige globaalsega
	LXPsAddDelTips                  = Ärge küsige uuesti
	Instl_Dependency_Package        = Lubage sõltuvate pakettide automaatne kokkupanek InBox Appsi installimisel
	Instl_Dependency_Package_Tips   = Kui lisataval rakendusel on sõltuvad paketid, sobitub see automaatselt vastavalt reeglitele ja täidab vajalike sõltuvate pakettide automaatse kombineerimise funktsiooni.
	Instl_Dependency_Package_Match  = Sõltuvuspakettide kombineerimine
	Instl_Dependency_Package_Group  = Kombinatsioon
	InBoxAppsErrorNoSave            = Veaga kokku puutudes ei tohi seda päästa
	InBoxAppsErrorTips              = Seal on vigu, sobitamises {0} üksuses tekkinud üksus oli ebaõnnestunud
	InBoxAppsErrorNo                = Vigast ei leitud sobitamisest
'@