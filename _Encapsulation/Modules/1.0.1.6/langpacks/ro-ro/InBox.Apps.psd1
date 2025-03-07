ConvertFrom-StringData -StringData @'
	# ro-RO
	# Romanian (Romania)

	AdvAppsDetailed                 = Generați raport
	AdvAppsDetailedTips             = Căutați după eticheta de regiune, obțineți mai multe detalii când sunt disponibile pachete de experiență în limba locală și generați un fișier de raport: *.CSV.
	ProcessSources                  = Sursa de procesare
	InboxAppsManager                = Aplicația Inbox
	InboxAppsMatchDel               = Ștergeți conform regulilor
	InboxAppsOfflineDel             = Ștergeți o aplicație furnizată
	InboxAppsClear                  = Forțați eliminarea tuturor pre-aplicațiilor instalate ( InBox Apps )
	InBox_Apps_Match                = Potriviți aplicațiile InBox Aplicații
	InBox_Apps_Check                = Verificați pachetele de dependență
	InBox_Apps_Check_Tips           = Conform regulilor, obțineți toate elementele de instalare selectate și verificați dacă elementele de instalare dependente au fost selectate.
	LocalExperiencePack             = Pachete de experiență în limba locală ( LXPs )
	LEPBrandNew                     = Într-un mod nou, recomandat
	UWPAutoMissingPacker            = Căutați automat pachetele lipsă de pe toate discurile
	UWPAutoMissingPackerSupport     = Arhitectura x64, pachetele lipsă trebuie instalate.
	UWPAutoMissingPackerNotSupport  = Arhitectură non-x64, utilizată atunci când este acceptată doar arhitectura x64.
	UWPEdition                      = Identificator unic al versiunii Windows
	Optimize_Appx_Package           = Optimizați furnizarea pachetelor Appx prin înlocuirea fișierelor identice cu link-uri hard
	Optimize_ing                    = Optimizarea
	Remove_Appx_Tips                = Ilustra:\n\nPasul unu: Adăugați pachete de experiență în limba locală ( LXPs ) Acest pas trebuie să corespundă pachetului corespunzător lansat oficial de Microsoft.\n       Adăugați pachete de limbi la imaginile cu mai multe sesiuni Windows 10\n       https://learn.microsoft.com/ro-ro/azure/virtual-desktop/language-packs\n\n       Adăugați limbi la imaginile Windows 11 Enterprise\n       https://learn.microsoft.com/ro-ro/azure/virtual-desktop/windows-11-language-packs\n\nPasul 2: Dezarhivați sau montați *_InboxApps.iso și selectați directorul conform arhitecturii;\n\nPasul 3: Dacă Microsoft nu a lansat oficial cel mai recent pachet de experiență în limba locală ( LXPs ), săriți peste acest pas dacă da: vă rugăm să consultați anunțul oficial de la Microsoft:\n       1. Corespunzător pachetelor de experiență în limba locală ( LXPs );\n       2. Corespunzător actualizărilor cumulate. \n\nAplicațiile preinstalate ( InBox Apps ) sunt într-o singură limbă și trebuie reinstalate pentru a obține mai multe limbi. \n\n1. Puteți alege între versiunea de dezvoltator și versiunea inițială;\n    Versiunea pentru dezvoltatori, de exemplu, numărul versiunii este: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Versiunea inițială, versiunea inițială cunoscută:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    important:\n      a. Vă rugăm să recreați imaginea atunci când fiecare versiune este actualizată.\n      b. Acest regulament a fost comunicat în mod clar ambalatori în diferite forme de către unii producători OEM, iar upgrade-urile directe de la versiunile iterative nu sunt permise.\n      Cuvinte cheie: iterație, versiuni încrucișate, actualizare cumulativă.\n\n2. După instalarea pachetului de limbă, trebuie să adăugați o actualizare cumulativă, deoarece înainte de a fi adăugată actualizarea cumulativă, componenta nu va avea nicio modificare până când actualizarea cumulativă este instalată. învechit, de șters;\n\n3. Atunci când utilizați o versiune cu actualizări cumulate, mai trebuie să adăugați din nou actualizări cumulate la final, ceea ce este o operațiune repetată;\n\n4. Prin urmare, se recomandă să utilizați o versiune fără actualizări cumulate în timpul producției și apoi să adăugați actualizări cumulative în ultimul pas. \n\nCondiții de căutare după selectarea directorului: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Curățați fișierele duplicate
	ForceRemovaAllUWP               = Omiteți adăugarea pachetului de experiență în limba locală ( LXPs ), efectuați altele
	LEPSkipAddEnglish               = Se recomandă să omiteți adăugarea en-US în timpul instalării.
	LEPSkipAddEnglishTips           = Pachetul implicit în limba engleză nu este necesar pentru a-l adăuga.
	License                         = Certificat
	IsLicense                       = Aveți certificat
	NoLicense                       = Fără certificat
	CurrentIsNVeriosn               = Seria de versiune N
	CurrentNoIsNVersion             = Versiune complet funcțională
	LXPsWaitAddUpdate               = De actualizat
	LXPsWaitAdd                     = De adăugat
	LXPsWaitAssign                  = Pentru a fi alocate
	LXPsWaitRemove                  = De șters
	LXPsAddDelTipsView              = Sunt sfaturi noi, verificați acum
	LXPsAddDelTipsGlobal            = Nu mai sunt solicitări, sincronizați cu global
	LXPsAddDelTips                  = Nu solicita din nou
	Instl_Dependency_Package        = Permiteți asamblarea automată a pachetelor dependente la instalarea aplicațiilor InBox
	Instl_Dependency_Package_Tips   = Când aplicația care urmează să fie adăugată are pachete dependente, se va potrivi automat conform regulilor și va completa funcția de combinare automată a pachetelor dependente necesare.
	Instl_Dependency_Package_Match  = Combinarea pachetelor de dependențe
	Instl_Dependency_Package_Group  = Combinaţie
	InBoxAppsErrorNoSave            = Când întâlnești o greșeală, nu este permisă să fie salvat
	InBoxAppsErrorTips              = Există erori, elementul întâlnit în elementul potrivită {0} nu a reușit
	InBoxAppsErrorNo                = Nu au fost găsite erori în potrivire
'@