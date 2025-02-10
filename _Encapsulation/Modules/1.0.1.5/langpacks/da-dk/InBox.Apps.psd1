ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	AdvAppsDetailed                 = Generer rapport
	AdvAppsDetailedTips             = Søg efter regionstag, få flere detaljer, når lokale sprogoplevelsespakker er tilgængelige, og generer en rapportfil: *.CSV.
	ProcessSources                  = Behandlingskilde
	InboxAppsManager                = Indbakke app
	InboxAppsMatchDel               = Slet ved at matche regler
	InboxAppsOfflineDel             = Slet en klargjort applikation
	InboxAppsClear                  = Tving fjernelse af alle installerede præ-apps ( InBox Apps )
	InBox_Apps_Match                = Match InBox Apps Apps
	InBox_Apps_Check                = Tjek afhængighedspakker
	InBox_Apps_Check_Tips           = I henhold til reglerne skal du indhente alle valgte installationselementer og kontrollere, om de afhængige installationselementer er blevet valgt.
	LocalExperiencePack             = Lokale sprogoplevelsespakker ( LXPs )
	LEPBrandNew                     = På en ny måde, anbefales
	UWPAutoMissingPacker            = Søg automatisk efter manglende pakker fra alle diske
	UWPAutoMissingPackerSupport     = X64-arkitektur, manglende pakker skal installeres.
	UWPAutoMissingPackerNotSupport  = Ikke-x64-arkitektur, bruges når kun x64-arkitektur understøttes.
	UWPEdition                      = Windows-versionens unikke identifikator
	Optimize_Appx_Package           = Optimer leveringen af Appx-pakker ved at erstatte identiske filer med hårde links
	Optimize_ing                    = Optimering
	Remove_Appx_Tips                = Illustrere:\n\nTrin et: Tilføj lokale sprogoplevelsespakker (LXP'er) Dette trin skal svare til den tilsvarende pakke, der officielt er udgivet af Microsoft. Gå her og download.\n       Tilføj sprogpakker til Windows 10 multi-session billeder\n       https://learn.microsoft.com/da-dk/azure/virtual-desktop/language-packs\n\n       Føj sprog til Windows 11 Enterprise-billeder\n       https://learn.microsoft.com/da-dk/azure/virtual-desktop/windows-11-language-packs\n\nTrin 2: Udpak eller monter *_InboxApps.iso, og vælg mappen i henhold til arkitekturen;\n\nTrin 3: Hvis Microsoft ikke officielt har udgivet den seneste lokale sprogoplevelsespakke (LXP'er), skal du springe dette trin over, hvis ja: Se venligst den officielle meddelelse fra Microsoft:\n       1. Svarende til lokale sprogoplevelsespakker (LXP'er);\n       2. Svarende til kumulative opdateringer. \n\nForudinstallerede apps ( InBox Apps ) er enkeltsprogede og skal geninstalleres for at få flere sprog.\n\n1. Du kan vælge mellem udviklerversion og initialversion;\n    Udviklerversion, for eksempel versionsnummeret er: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Initial version, kendt initial version:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    vigtig: \n      a. Genopret billedet, når hver version er opdateret. For eksempel, når du flytter fra 21H1 til 22H2, skal du ikke opdatere baseret på det gamle billede for at undgå andre kompatibilitetsproblemer. Brug venligst den oprindelige version.\n      b. Denne regulering er tydeligt blevet kommunikeret til pakkerier i forskellige former af nogle OEM-producenter, og direkte opgraderinger fra iterative versioner er ikke tilladt.\n      Nøgleord: iteration, cross-version, kumulativ opdatering.\n\n2. Efter installation af sprogpakken skal kumulative opdateringer tilføjes, for før de kumulative opdateringer tilføjes, vil komponenterne ikke have nogen ændringer. Nye ændringer vil ikke ske, før de kumulative opdateringer er installeret , skal slettes;\n\n3. Når du bruger en version med kumulative opdateringer, skal du stadig tilføje kumulative opdateringer igen til sidst, hvilket er en gentagen operation;\n\n4. Derfor anbefales det, at du bruger en version uden kumulative opdateringer under produktionen, og derefter tilføjer kumulative opdateringer i sidste trin. \n\nSøgebetingelser efter valg af bibliotek: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Rens dubletfiler
	ForceRemovaAllUWP               = Spring over tilføjelse af lokal sprogoplevelsespakke ( LXPs ), udfør andet
	LEPSkipAddEnglish               = Det anbefales at springe en-US tilføjelse over under installationen.
	LEPSkipAddEnglishTips           = Standard engelsk sprogpakke er unødvendig for at tilføje den.
	License                         = Certifikat
	IsLicense                       = Har certifikat
	NoLicense                       = Intet certifikat
	CurrentIsNVeriosn               = N version serie
	CurrentNoIsNVersion             = Fuldt funktionel version
	LXPsWaitAddUpdate               = Skal opdateres
	LXPsWaitAdd                     = Skal tilføjes
	LXPsWaitAssign                  = Skal tildeles
	LXPsWaitRemove                  = Skal slettes
	LXPsAddDelTipsView              = Der er nye tips, tjek nu
	LXPsAddDelTipsGlobal            = Ikke flere prompter, synkroniser til global
	LXPsAddDelTips                  = Spørg ikke igen
	Instl_Dependency_Package        = Tillad automatisk samling af afhængige pakker, når du installerer InBox Apps
	Instl_Dependency_Package_Tips   = Når applikationen, der skal tilføjes, har afhængige pakker, vil den automatisk matche i henhold til reglerne og fuldføre funktionen med automatisk at kombinere de nødvendige afhængige pakker.
	Instl_Dependency_Package_Match  = Kombination af afhængighedspakker
	Instl_Dependency_Package_Group  = Kombination
	InBoxAppsErrorNoSave            = Når man støder på en fejltagelse, er det ikke tilladt at blive frelst
	InBoxAppsErrorTips              = Der er fejl, varen, der blev stødt på i den matchende {0} vare, var ikke succesrige
	InBoxAppsErrorNo                = Der blev ikke fundet nogen fejl i matchningen
'@