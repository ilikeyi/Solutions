ConvertFrom-StringData -StringData @'
	# sv-SE
	# Swedish (Sweden)

	AdvAppsDetailed                 = Skapa rapport
	AdvAppsDetailedTips             = Sök efter regiontagg, få mer information när lokala språkupplevelsepaket är tillgängliga och generera en rapportfil: *.CSV.
	ProcessSources                  = Bearbetningskälla
	InboxAppsManager                = Inbox app
	InboxAppsMatchDel               = Ta bort genom att matcha regler
	InboxAppsOfflineDel             = Ta bort en tillhandahållen applikation
	InboxAppsClear                  = Tvinga bort alla installerade förappar ( InBox Apps )
	InBox_Apps_Match                = Matcha InBox Apps-appar
	InBox_Apps_Check                = Kontrollera beroendepaket
	InBox_Apps_Check_Tips           = Enligt reglerna, skaffa alla valda installationsobjekt och verifiera om de beroende installationsobjekten har valts.
	LocalExperiencePack             = Lokala språkupplevelsepaket ( LXPs )
	LEPBrandNew                     = På ett nytt sätt, rekommenderas
	UWPAutoMissingPacker            = Sök automatiskt efter saknade paket från alla diskar
	UWPAutoMissingPackerSupport     = X64-arkitektur, saknade paket måste installeras.
	UWPAutoMissingPackerNotSupport  = Icke-x64-arkitektur, används när endast x64-arkitektur stöds.
	UWPEdition                      = Windows-versionens unika identifierare
	Optimize_Appx_Package           = Optimera provisioneringen av Appx-paket genom att ersätta identiska filer med hårda länkar
	Optimize_ing                    = Optimerande
	Remove_Appx_Tips                = Illustrera:\n\nSteg ett: Lägg till lokala språkupplevelsepaket ( LXPs ) Detta steg måste motsvara motsvarande paket som officiellt släppts av Microsoft. Gå hit och ladda ner:\n       Lägg till språkpaket till Windows 10 multisessionsbilder\n       https://learn.microsoft.com/sv-se/azure/virtual-desktop/language-packs\n\n       Lägg till språk till Windows 11 Enterprise-bilder\n       https://learn.microsoft.com/sv-se/azure/virtual-desktop/windows-11-language-packs\n\nSteg 2: Packa upp eller montera *_InboxApps.iso och välj katalogen enligt arkitekturen;\n\nSteg 3: Om Microsoft inte officiellt har släppt det senaste lokala språkupplevelsepaketet ( LXPs ), hoppa över det här steget i så fall: se det officiella tillkännagivandet från Microsoft:\n       1. Motsvarar lokala språkupplevelsepaket ( LXPs );\n       2. Motsvarande kumulativa uppdateringar. \n\nFörinstallerade appar ( InBox Apps ) är enspråkiga och måste installeras om för att få flerspråkiga. \n\n1. Du kan välja mellan utvecklarversion och initialversion;\n    Utvecklarversion, till exempel, versionsnumret är: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Initial version, känd initial version: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    viktig:\n      a. Återskapa bilden när varje version uppdateras Till exempel, när du flyttar från 21H1 till 22H2, vänligen uppdatera inte baserat på den gamla bilden för att undvika andra kompatibilitetsproblem. Återigen, använd den ursprungliga versionen.\n      b. Denna förordning har tydligt kommunicerats till förpackare i olika former av vissa OEM-tillverkare, och direkta uppgraderingar från iterativa versioner är inte tillåtna.\n      Nyckelord: iteration, cross-version, kumulativ uppdatering.\n\n2. Efter att du har installerat språkpaketet måste du lägga till en kumulativ uppdatering, eftersom komponenten inte har några ändringar innan den kumulativa uppdateringen har installerats. föråldrad, att utgå;\n\n3. När du använder en version med kumulativa uppdateringar måste du fortfarande lägga till kumulativa uppdateringar igen i slutet, vilket är en upprepad operation;\n\n4. Därför rekommenderas det att du använder en version utan kumulativa uppdateringar under produktionen och sedan lägger till kumulativa uppdateringar i det sista steget. \n\nSökkriterier efter att ha valt en katalog: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Rensa dubbletter av filer
	ForceRemovaAllUWP               = Hoppa över lokalt språkupplevelsepaket ( LXPs ) tillägg, utför annat
	LEPSkipAddEnglish               = Det rekommenderas att hoppa över en-US-tillägg under installationen.
	LEPSkipAddEnglishTips           = Standardpaketet för engelska är onödigt för att lägga till det.
	License                         = Certifikat
	IsLicense                       = Har certifikat
	NoLicense                       = Inget certifikat
	CurrentIsNVeriosn               = N version serien
	CurrentNoIsNVersion             = Fullt fungerande version
	LXPsWaitAddUpdate               = Ska uppdateras
	LXPsWaitAdd                     = Ska läggas till
	LXPsWaitAssign                  = Ska tilldelas
	LXPsWaitRemove                  = Ska raderas
	LXPsAddDelTipsView              = Det finns nya tips, kolla nu
	LXPsAddDelTipsGlobal            = Inga fler uppmaningar, synkronisera till globalt
	LXPsAddDelTips                  = Fråga inte igen
	Instl_Dependency_Package        = Tillåt automatisk sammansättning av beroende paket när du installerar InBox Apps
	Instl_Dependency_Package_Tips   = När applikationen som ska läggas till har beroende paket kommer den automatiskt att matcha enligt reglerna och slutföra funktionen att automatiskt kombinera de nödvändiga beroende paketen.
	Instl_Dependency_Package_Match  = Kombinera beroendepaket
	Instl_Dependency_Package_Group  = Kombination
	InBoxAppsErrorNoSave            = När man möter ett misstag får det inte räddas
	InBoxAppsErrorTips              = Det finns fel, objektet som mötte i matchningen {0} var misslyckad
	InBoxAppsErrorNo                = Inga fel hittades i matchningen
'@