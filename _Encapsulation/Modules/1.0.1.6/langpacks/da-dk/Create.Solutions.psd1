﻿ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	IsCreate                        = Skabe
	Solution                        = Løsning
	EnabledSoftwarePacker           = Samling
	EnabledUnattend                 = Skal svare på forhånd
	EnabledEnglish                  = Implementeringsmotor
	UnattendSelectVer               = Vælg 'Svar til' løsningssprog
	UnattendLangPack                = Vælg 'Solution' sprogpakke
	UnattendSelectSingleInstl       = Flersproget, valgfrit under installationen
	UnattendSelectMulti             = Flersproget
	UnattendSelectDisk              = Vælg Autounattend.xml-løsningen
	UnattendSelectSemi              = Halvautomatisk er gyldig for alle installationsmetoder
	UnattendSelectUefi              = UEFI installeres automatisk og skal specificeres
	UnattendSelectLegacy            = Legacy installeres automatisk og skal specificeres
	NeedSpecified                   = Vælg venligst hvad der skal angives:
	OOBESetupOS                     = Installationsgrænseflade
	OOBEProductKey                  = Produktnøgle
	OOBEOSImage                     = Vælg det operativsystem, der skal installeres
	OOBEEula                        = Accepter licensvilkårene
	OOBEDoNotServerManager          = Server Manager starter ikke automatisk ved login
	OOBEIE                          = Internet Explorer forbedret sikkerhedskonfiguration
	OOBEIEAdmin                     = Luk "Administrator"
	OObeIEUser                      = Luk "Brugere"

	OOBE_Init_User                  = Første bruger under unboxing-oplevelse
	OOBE_init_Create                = Opret brugerdefinerede brugere
	OOBE_init_Specified             = Angiv bruger
	OOBE_Init_Autologin             = Automatisk login

	InstlMode                       = Installationsmetode
	Business                        = Business version
	BusinessTips                    = Afhænger af EI.cfg, indeksnummeret skal angives for automatisk installation.
	Consumer                        = Forbrugerversion
	ConsumerTips                    = Den er ikke afhængig af EI.cfg. Serienummeret skal angives for automatisk installation.
	CreateUnattendISO               = [ISO]:\\Autounattend.xml
	CreateUnattendISOSources        = [ISO]:\\sources\\Unattend.xml
	CreateUnattendISOSourcesOEM     = [ISO]:\\sources\\$OEM$\\$$\\Panther\\unattend.xml
	CreateUnattendPanther           = [montere til]:\\Windows\\Panther\\unattend.xml

	VerifyName                      = Føj til systemdiskens hjemmemappenavn
	VerifyNameUse                   = Kontroller, at mappenavnet ikke kan indeholde
	VerifyNameTips                  = Kun en kombination af engelske bogstaver og tal er tilladt, og kan ikke indeholde: mellemrum, længden må ikke være større end 260 tegn, \\ / : * ?
	VerifyNumberFailed              = Bekræftelsen mislykkedes. Indtast venligst det korrekte nummer.
	VerifyNameSync                  = Indstil mappenavn som primært brugernavn
	VerifyNameSyncTips              = Administrator bruges ikke længere.
	ManualKey                       = Vælg eller indtast din produktnøgle manuelt
	ManualKeyTips                   = Indtast en gyldig produktnøgle Hvis den valgte region ikke er tilgængelig, skal du gå til Microsofts officielle websted for at kontrollere.
	ManualKeyError                  = Den produktnøgle, du indtastede, er ugyldig.
	KMSLink1                        = KMS klient indstillingsnøgle
	KMSUnlock                       = Vis alle kendte KMS-serienumre
	KMSSelect                       = Vælg venligst VOL serienummer
	KMSKey                          = Serienummer
	KMSKeySelect                    = Skift produktserienummer
	ClearOld                        = Ryd op i gamle filer
	SolutionsSkip                   = Spring over at skabe løsning
	SolutionsTo                     = Tilføj 'løsning' til:
	SolutionsToMount                = Monteret eller tilføjet til kø
	SolutionsToError                = Nogle funktioner er blevet deaktiveret Hvis du har brug for at tvinge dem til at bruge, skal du klikke på knappen "Lås op".\n\n
	UnlockBoot                      = Lås op
	SolutionsToSources              = Hjemmemappe, [ISO]:\\Sources\\$OEM$
	SolutionsScript                 = Vælg 'Deployment Engine'-version
	SolutionsEngineRegionaUTF8      = Beta: Global sprogunderstøttelse ved hjælp af Unicode UTF-8
	SolutionsEngineRegionaUTF8Tips  = Det ser ud til, at det kan forårsage nye problemer efter at have åbnet det. Ikke anbefalet.
	SolutionsEngineRegionaling      = Skift til ny lokalitet:
	SolutionsEngineRegionalingTips  = Skift systemlokalitet, som påvirker alle brugerkonti på computeren.
	SolutionsEngineRegional         = Skift systemlokalitet
	SolutionsEngineRegionalTips     = Global standard: {0}, ændret til: {1}
	SolutionsEngineCopyPublic       = Kopiér offentlige {0} til implementering
	SolutionsEngineCopyOpen         = Gennemse placeringen af det offentlige lager {0}
	EnglineDoneReboot               = Genstart din computer
	SolutionsTipsArm64              = Arm64-pakken foretrækkes, og du vælger i rækkefølge: x64, x86.
	SolutionsTipsAMD64              = Foretrækker x64-pakker, i rækkefølge: x86.
	SolutionsTipsX86                = Kun x86-pakker tilføjes.
	SolutionsReport                 = Generer rapport før implementering
	SolutionsDeployOfficeInstall    = Implementer Microsoft Office-installationspakken
	SolutionsDeployOfficeChange     = Skift implementeringskonfiguration
	SolutionsDeployOfficePre        = Forudinstalleret pakkeversion
	SolutionsDeployOfficeNoSelect   = Ingen Office-præinstallationspakke valgt
	SolutionsDeployOfficeVersion    = {0} version
	SolutionsDeployOfficeOnly       = Behold angivne sprogpakker
	SolutionsDeployOfficeSync       = Bevar sprogsynkronisering til implementeringskonfiguration
	SolutionsDeployOfficeSyncTips   = Efter synkronisering kan installationsscriptet ikke bestemme det foretrukne sprog.
	DeploySyncMainLanguage          = Synkroniser med hovedsproget
	SolutionsDeployOfficeTo         = Implementer installationspakken til
	SolutionsDeployOfficeToPublic   = Offentligt skrivebord
	DeployPackage                   = Implementer en tilpasset samlingspakke
	DeployPackageSelect             = Vælg en præ-afhentningspakke
	DeployPackageTo                 = Implementer præ-indsamlingspakken til
	DeployPackageToRoot             = Systemdisk:\\Package
	DeployPackageToSolutions        = I løsningens hjemmekatalog
	DeployTimeZone                  = Tidszone
	DeployTimeZoneChange            = Skift tidszone
	DeployTimeZoneChangeTips        = Indstil standardtidsområdet, hvor forhåndssvar skal besvares, efter sprogområde.

	Deploy_Tags                     = Implementeringstag
	FirstExpProcess                 = Forudsætninger for førstegangserfaring under implementering:
	FirstExpProcessTips             = Når du har gennemført forudsætningerne, skal du genstarte computeren for at løse problemet med at kræve en genstart for at træde i kraft.
	FirstExpFinish                  = Førstegangserfaring efter at have gennemført forudsætninger
	FirstExpSyncMark                = Tillad global søgning og synkronisering af implementeringstags
	FirstExpUpdate                  = Tillad automatiske opdateringer
	FirstExpDefender                = Tilføj hjemmemappe til Forsvar ekskluderede mapper
	FirstExpSyncLabel               = Systemdiskenhedsmærkat: Hjemmebibliotekets navn er det samme
	MultipleLanguages               = Når du støder på flere sprog:
	NetworkLocationWizard           = Netværksplaceringsguide
	PreAppxCleanup                  = Bloker Appx-oprydningsvedligeholdelsesopgaver
	LanguageComponents              = Forhindr oprydning af ubrugte on-demand-funktionssprogpakker
	PreventCleaningUnusedLP         = Undgå rengøring af ubrugte sprogpakker
	FirstExpContextCustomize        = Tilføj en personlig "kontekstmenu"
	FirstExpContextCustomizeShift   = Hold Shift-tasten nede, og højreklik

	FirstExpFinishTips              = Der er ingen vigtige begivenheder, efter at implementeringen er afsluttet. Det anbefales, at du annullerer.
	FirstExpFinishPopup             = Pop op implementeringsmotorens hovedgrænseflade
	FirstExpFinishOnDemand          = Tillad første forhåndsvisning som planlagt
	SolutionsEngineRestricted       = Gendan Powershell-udførelsespolitik: begrænset
	EnglineDoneClearFull            = Slet hele løsningen
	EnglineDoneClear                = Slet implementeringsmotoren og behold de andre

	Unattend_Auto_Fix_Next          = Næste gang du støder på det, skal du automatisk vælge de nødvendige elementer for automatisk at rette det.
	Unattend_Auto_Fix               = Reparer automatisk, når forudsætninger ikke er valgt
	Unattend_Auto_Fix_Tips          = Når du tilføjer implementeringsmotoren og ikke vælger den første kørselskommando, repareres og vælges den automatisk: Powershell-udførelsespolitik: kør implementeringsmotoren uden nogen begrænsninger.
	Unattend_Version_Tips           = Inkluder eventuelt kun, brug standard til at understøtte ARM64, x64, x86.
	First_Run_Commmand              = Kommandoer, der skal køres, når de implementeres for første gang
	First_Run_Commmand_Setting      = Vælg den kommando, der skal køres
	Command_Not_Class               = Ikke mere automatisk klassificering ved filtrering
	Command_WinSetup                = Windows Installere
	Command_WinPE                   = Windows PE
	Command_Tips                    = Tildel venligst First Run App til: Windows Installation, Windows PE\n\nBemærk, at når en implementeringsmotor tilføjes, skal du kontrollere følgende, når du kører for første gang: Powershell Execution Policy: Begrænset, tillad, at implementeringsmotorscripts køres.
	Waring_Not_Select_Command       = Når du tilføjer en implementeringsmotor, blev Powershell-udførelsespolitikken ikke valgt: Indstil ikke nogen begrænsninger, og tillad at implementeringsmotorscriptet kører. Vælg det, og prøv igen, eller klik på "Hurtig rettelse er ikke valgt".
	Quic_Fix_Not_Select_Command     = Quick fix ikke mulighed

	PowerShell_Unrestricted         = Powershell-udførelsespolitik: ingen begrænsninger
	Allow_Running_Deploy_Engine     = Tillad implementeringsmotorscripts at køre
	Bypass_TPM                      = Omgå TPM-tjek under installationen
'@