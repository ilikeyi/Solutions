ConvertFrom-StringData -StringData @'
	# nb-NO
	# Norwegian, Bokmål (Norway)

	AdvAppsDetailed                 = Generer rapport
	AdvAppsDetailedTips             = Søk etter region-tag, få flere detaljer når lokale språkopplevelsespakker er tilgjengelige, og generer en rapportfil: *.CSV.
	ProcessSources                  = Behandlingskilden
	InboxAppsManager                = Innboks-app
	InboxAppsMatchDel               = Slett etter samsvarende regler
	InboxAppsOfflineDel             = Slett en klargjort applikasjon
	InboxAppsClear                  = Tving fjerning av alle installerte forhåndsapper ( InBox Apps )
	InBox_Apps_Match                = Match InBox Apps apper
	InBox_Apps_Check                = Sjekk avhengighetspakker
	InBox_Apps_Check_Tips           = I henhold til reglene, skaff deg alle valgte installasjonselementer og kontroller om de avhengige installasjonselementene er valgt.
	LocalExperiencePack             = Lokale språkopplevelsespakker
	LEPBrandNew                     = På en ny måte, anbefales
	UWPAutoMissingPacker            = Søk automatisk etter manglende pakker fra alle disker
	UWPAutoMissingPackerSupport     = X64-arkitektur, manglende pakker må installeres.
	UWPAutoMissingPackerNotSupport  = Ikke-x64-arkitektur, brukes når kun x64-arkitektur støttes.
	UWPEdition                      = Unik identifikator for Windows-versjonen
	Optimize_Appx_Package           = Optimaliser levering av Appx-pakker ved å erstatte identiske filer med harde lenker
	Optimize_ing                    = Optimalisering
	Remove_Appx_Tips                = Illustrere:\n\nTrinn én: Legg til lokale språkopplevelsespakker ( LXPs ) Dette trinnet må samsvare med den tilsvarende pakken offisielt utgitt av Microsoft. Gå her og last ned:\n       Legg til språkpakker til Windows 10 multi-session-bilder\n       https://learn.microsoft.com/nb-no/azure/virtual-desktop/language-packs\n\n       Legg til språk til Windows 11 Enterprise-bilder\n       https://learn.microsoft.com/nb-no/azure/virtual-desktop/windows-11-language-packs\n\nTrinn 2: Pakk ut eller monter *_InboxApps.iso, og velg katalogen i henhold til arkitekturen;\n\nTrinn 3: Hvis Microsoft ikke offisielt har gitt ut den siste lokale språkopplevelsespakken ( LXPs ), hopp over dette trinnet i så fall: se den offisielle kunngjøringen fra Microsoft:\n       1. Tilsvarende lokale språkopplevelsespakker ( LXPs );\n       2. Tilsvarer kumulative oppdateringer. \n\nForhåndsinstallerte apper ( InBox Apps ) er ettspråklige og må installeres på nytt for å få flerspråklige. \n\n1. Du kan velge mellom utviklerversjon og initialversjon;\n    Utviklerversjon, for eksempel, versjonsnummeret er: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Opprinnelig versjon, kjent innledende versjon:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    viktig: \n      a. Opprett bildet på nytt når hver versjon er oppdatert. For eksempel, ikke oppdater basert på det gamle bildet. Igjen, bruk den første versjonen.\n      b. Denne forskriften har blitt tydelig kommunisert til pakkere i ulike former av noen OEM-produsenter, og direkte oppgraderinger fra iterative versjoner er ikke tillatt.\n      Nøkkelord: iterasjon, kryssversjon, kumulativ oppdatering.\n\n2. Etter at du har installert språkpakken, må du legge til en kumulativ oppdatering, fordi før den kumulative oppdateringen legges til, vil komponenten ikke ha noen endringer. Nye endringer vil ikke skje før den kumulative oppdateringen er installert. foreldet, skal slettes;\n\n3. Når du bruker en versjon med kumulative oppdateringer, må du fortsatt legge til kumulative oppdateringer igjen til slutt, som er en gjentatt operasjon;\n\n4. Derfor anbefales det at du bruker en versjon uten kumulative oppdateringer under produksjonen, og deretter legger til kumulative oppdateringer i siste trinn. \n\nSøkebetingelser etter valg av katalog: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Etter utpakking vil den monterte ISO-en dukke opp. Regler: 
	ImportCleanDuplicate            = Rengjør dupliserte filer
	ForceRemovaAllUWP               = Hopp over lokal språkopplevelsespakke ( LXPs ) tillegg, utfør andre
	LEPSkipAddEnglish               = Det anbefales å hoppe over en-US tillegg under installasjonen.
	LEPSkipAddEnglishTips           = Standard engelskspråkpakke er unødvendig for å legge den til.
	License                         = Sertifikat
	IsLicense                       = Har sertifikat
	NoLicense                       = Ingen sertifikat
	CurrentIsNVeriosn               = N versjonsserie
	CurrentNoIsNVersion             = Fullt funksjonell versjon
	LXPsWaitAddUpdate               = Skal oppdateres
	LXPsWaitAdd                     = Skal legges til
	LXPsWaitAssign                  = Skal tildeles
	LXPsWaitRemove                  = Skal slettes
	LXPsAddDelTipsView              = Det er nye tips, sjekk nå
	LXPsAddDelTipsGlobal            = Ingen flere forespørsler, synkroniser til globalt
	LXPsAddDelTips                  = Ikke spør igjen
	Instl_Dependency_Package        = Tillat automatisk sammenstilling av avhengige pakker når du installerer InBox-apper
	Instl_Dependency_Package_Tips   = Når applikasjonen som skal legges til har avhengige pakker, vil den automatisk matche i henhold til reglene og fullføre funksjonen med automatisk å kombinere de nødvendige avhengige pakkene.
	Instl_Dependency_Package_Match  = Kombinere avhengighetspakker
	Instl_Dependency_Package_Group  = Kombinasjon
	InBoxAppsErrorNoSave            = Når du møter en feil, er det ikke lov til å bli frelst
	InBoxAppsErrorTips              = Det er feil, varen som ble oppstått i matching {0} var mislykket
	InBoxAppsErrorNo                = Ingen feil ble funnet i matchingen
'@