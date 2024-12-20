﻿ConvertFrom-StringData -StringData @'
	# hu-HU
	# Hungarian (Hungary)

	IsCreate                        = Teremt
	Solution                        = Megoldás
	EnabledSoftwarePacker           = Gyűjtemény
	EnabledUnattend                 = Előre kell válaszolni
	EnabledEnglish                  = Bevetési motor
	UnattendSelectVer               = Válassza a "Válasz" megoldás nyelvét
	UnattendLangPack                = Válassza a "Megoldás" nyelvi csomagot
	UnattendSelectSingleInstl       = Többnyelvű, a telepítés során opcionális
	UnattendSelectMulti             = Többnyelvű
	UnattendSelectDisk              = Válassza ki az Autounattend.xml megoldást
	UnattendSelectSemi              = A félautomata minden telepítési módra érvényes
	UnattendSelectUefi              = Az UEFI automatikusan települ, és meg kell adni
	UnattendSelectLegacy            = A Legacy automatikusan telepítésre kerül, és meg kell adni
	NeedSpecified                   = Kérjük, válassza ki, mit kell megadni:
	OOBESetupOS                     = Telepítési felület
	OOBEProductKey                  = Termékkulcs
	OOBEOSImage                     = Válassza ki a telepíteni kívánt operációs rendszert
	OOBEEula                        = Fogadja el a licencfeltételeket
	OOBEDoNotServerManager          = A Kiszolgálókezelő nem indul el automatikusan bejelentkezéskor
	OOBEIE                          = Az Internet Explorer fokozott biztonsági konfigurációja
	OOBEIEAdmin                     = Az "Adminisztrátor" bezárása
	OObeIEUser                      = "Felhasználók" bezárása

	OOBE_Init_User                  = Kezdeti felhasználó a kicsomagolás során
	OOBE_init_Create                = Hozzon létre egyéni felhasználókat
	OOBE_init_Specified             = Felhasználó megadása
	OOBE_Init_Autologin             = Automatikus bejelentkezés

	InstlMode                       = Telepítési mód
	Business                        = Üzleti verzió
	BusinessTips                    = Az EI.cfg-től függően az indexszámot meg kell adni az automatikus telepítéshez.
	Consumer                        = Fogyasztói változat
	ConsumerTips                    = Nem támaszkodik az EI.cfg-re. Az automatikus telepítéshez meg kell adni az indexszámot.
	CreateUnattendISO               = [ISO]:\\Autounattend.xml
	CreateUnattendISOSources        = [ISO]:\\sources\\Unattend.xml
	CreateUnattendISOSourcesOEM     = [ISO]:\\sources\\$OEM$\\$$\\Panther\\unattend.xml
	CreateUnattendPanther           = [szerelje fel]:\\Windows\\Panther\\unattend.xml

	VerifyName                      = Hozzáadás a rendszerlemez kezdőkönyvtárának nevéhez
	VerifyNameUse                   = Ellenőrizze, hogy a könyvtárnév nem tartalmazhat-e
	VerifyNameTips                  = Csak angol betűk és számok kombinációja megengedett, és nem tartalmazhatja a következőket: szóközök, hossza nem lehet nagyobb 260 karakternél, \\ / : * ? & @ ! "" < > |
	VerifyNumberFailed              = Az ellenőrzés sikertelen, kérjük, adja meg a helyes számot.
	VerifyNameSync                  = Állítsa be a könyvtár nevét elsődleges felhasználónévként
	VerifyNameSyncTips              = Már nem használt administrator
	ManualKey                       = Válassza ki vagy adja meg manuálisan a termékkulcsot
	ManualKeyTips                   = Adjon meg egy érvényes termékkulcsot. Ha a kiválasztott régió nem érhető el, keresse fel a Microsoft hivatalos webhelyét.
	ManualKeyError                  = A megadott termékkulcs érvénytelen.
	KMSLink1                        = KMS kliens beállítási kulcs
	KMSUnlock                       = Az összes ismert KMS sorozatszám megjelenítése
	KMSSelect                       = Kérjük, válassza ki a VOL sorozatszámot
	KMSKey                          = Sorozatszámát
	KMSKeySelect                    = Módosítsa a termék sorozatszámát
	ClearOld                        = Tisztítsa meg a régi fájlokat
	SolutionsSkip                   = A megoldás létrehozásának kihagyása
	SolutionsTo                     = Add hozzá a "megoldást" ehhez:
	SolutionsToMount                = Fel van szerelve vagy hozzáadva a sorhoz
	SolutionsToError                = Egyes funkciók le vannak tiltva. Ha kényszeríteni kell a használatukat, kattintson a "Feloldás" gombra.\n\n
	UnlockBoot                      = Kinyit
	SolutionsToSources              = Főkönyvtár, [ISO]:\\Sources\\$OEM$
	SolutionsScript                 = Válassza ki a "Deployment Engine" verziót
	SolutionsEngineRegionaUTF8      = Béta: Globális nyelvtámogatás Unicode UTF-8 használatával
	SolutionsEngineRegionaUTF8Tips  = Úgy tűnik, hogy a kinyitás után újabb problémákat okozhat. Nem ajánlott.
	SolutionsEngineRegionaling      = Változás új nyelvre:
	SolutionsEngineRegionalingTips  = Módosítsa a rendszer területi beállítását, amely a számítógépen lévő összes felhasználói fiókot érinti.
	SolutionsEngineRegional         = Változtassa meg a rendszer területi beállítását
	SolutionsEngineRegionalTips     = Globális alapértelmezett: {0}, a következőre módosult: {1}
	SolutionsEngineCopyPublic       = Nyilvános {0} másolása a telepítéshez
	SolutionsEngineCopyOpen         = Böngésszen a nyilvános tárhely {0} helyén
	EnglineDoneReboot               = Indítsa újra a számítógépet
	SolutionsTipsArm64              = Az arm64 csomagot részesítjük előnyben, és sorrendben választja ki: x64, x86.
	SolutionsTipsAMD64              = Inkább x64-es csomagokat, sorrendben: x86.
	SolutionsTipsX86                = Csak x86-os csomagok kerülnek hozzáadásra.
	SolutionsReport                 = Üzembe helyezés előtti jelentés létrehozása
	SolutionsDeployOfficeInstall    = Telepítse a Microsoft Office telepítőcsomagját
	SolutionsDeployOfficeChange     = Módosítsa a telepítési konfigurációt
	SolutionsDeployOfficePre        = Előre telepített csomag verzió
	SolutionsDeployOfficeNoSelect   = Nincs kiválasztva Office előtelepítő csomag
	SolutionsDeployOfficeVersion    = {0} verzió
	SolutionsDeployOfficeOnly       = Tartsa meg a megadott nyelvi csomagokat
	SolutionsDeployOfficeSync       = A nyelvi szinkronizálás megőrzése a telepítési konfigurációhoz
	SolutionsDeployOfficeSyncTips   = A szinkronizálás után a telepítő szkript nem tudja meghatározni a preferált nyelvet.
	DeploySyncMainLanguage          = Szinkronizálás a fő nyelvvel
	SolutionsDeployOfficeTo         = Telepítse a telepítőcsomagot ide
	SolutionsDeployOfficeToPublic   = Nyilvános asztal
	DeployPackage                   = Egyéni gyűjtőcsomag telepítése
	DeployPackageSelect             = Válasszon előgyűjtési csomagot
	DeployPackageTo                 = Telepítse az előgyűjtési csomagot ide
	DeployPackageToRoot             = Rendszerlemez:\\Package
	DeployPackageToSolutions        = A megoldás kezdőkönyvtárában
	DeployTimeZone                  = Időzóna
	DeployTimeZoneChange            = Időzóna módosítása
	DeployTimeZoneChangeTips        = Állítsa be az alapértelmezett időtartományt, ahol az előzetes válaszokat meg kell válaszolni, nyelvterületenként.

	Deploy_Tags                     = Telepítési címke
	FirstExpProcess                 = Első tapasztalat, a telepítés során előfeltételek:
	FirstExpProcessTips             = Az előfeltételek teljesítése után indítsa újra a számítógépet, hogy megoldja az újraindítás szükségességét.
	FirstExpFinish                  = Első tapasztalat, az előfeltételek teljesítése után
	FirstExpSyncMark                = Lehetővé teszi a globális keresést és a telepítési címkék szinkronizálását
	FirstExpUpdate                  = Automatikus frissítések engedélyezése
	FirstExpDefender                = Saját könyvtár hozzáadása a kizárt könyvtárak védelméhez
	FirstExpSyncLabel               = Rendszerlemez kötetcímke: A kezdőkönyvtár neve megegyezik
	MultipleLanguages               = Ha több nyelvvel találkozik:
	NetworkLocationWizard           = Hálózati hely varázsló
	PreAppxCleanup                  = Az Appx tisztítási karbantartási feladatok blokkolása
	LanguageComponents              = Akadályozza meg a nem használt igény szerinti funkciónyelvi csomagok tisztítását
	PreventCleaningUnusedLP         = Akadályozza meg a nem használt nyelvi csomagok tisztítását
	FirstExpContextCustomize        = Személyre szabott "helyi menü" hozzáadása
	FirstExpContextCustomizeShift   = Tartsa lenyomva a Shift billentyűt, és kattintson a jobb gombbal

	FirstExpFinishTips              = A telepítés befejezése után nincsenek fontos események. Javasoljuk, hogy törölje.
	FirstExpFinishPopup             = Nyissa meg a telepítési motor fő felületét
	FirstExpFinishOnDemand          = Az első előnézet engedélyezése a tervek szerint
	SolutionsEngineRestricted       = Powershell végrehajtási házirend visszaállítása: korlátozott
	EnglineDoneClearFull            = Törölje a teljes megoldást
	EnglineDoneClear                = Törölje a telepítési motort, és tartsa meg a többit

	Unattend_Auto_Fix_Next          = Amikor legközelebb találkozik vele, automatikusan válassza ki a szükséges elemeket az automatikus javításhoz.
	Unattend_Auto_Fix               = Automatikus javítás, ha az előfeltételek nincsenek kiválasztva
	Unattend_Auto_Fix_Tips          = Amikor hozzáadja a telepítési motort, és nem választja ki az első futtatási parancsot, a rendszer automatikusan kijavítja és kiválasztja: Powershell végrehajtási házirend: futtassa a telepítési motort korlátozások nélkül.
	Unattend_Version_Tips           = Opcionálisan csak tartalmazza, használja az alapértelmezettet az ARM64, x64, x86 támogatásához.
	First_Run_Commmand              = Az első üzembe helyezéskor futásra vonatkozó parancsok
	First_Run_Commmand_Setting      = Válassza ki a futtatni kívánt parancsot
	Command_Not_Class               = Már nincs automatikusan kategorizálva szűréskor
	Command_WinSetup                = Windows telepítés
	Command_WinPE                   = Windows PE
	Command_Tips                    = Kérjük, rendelje hozzá a First Run alkalmazást a következőhöz: Windows Installation, Windows PE\n\nVegye figyelembe, hogy ha telepítőmotort ad hozzá, az első futtatáskor ellenőriznie kell a következőket: Powershell végrehajtási házirend: Korlátozott, engedélyezze a telepítési motor parancsfájljainak futtatását.
	Waring_Not_Select_Command       = Telepítési motor hozzáadásakor a Powershell végrehajtási szabályzata nem lett kiválasztva: Ne állítson be korlátozásokat, és engedélyezze a telepítési motor szkriptjének futtatását. Válassza ki, és próbálja újra, vagy kattintson a "Gyorsjavítás nincs kiválasztva" gombra.
	Quic_Fix_Not_Select_Command     = Gyors javítás nem opció

	PowerShell_Unrestricted         = Powershell végrehajtási szabályzat: nincs korlátozás
	Allow_Running_Deploy_Engine     = A telepítési motor szkriptek futtatásának engedélyezése
	Bypass_TPM                      = A TPM ellenőrzések megkerülése a telepítés során
'@