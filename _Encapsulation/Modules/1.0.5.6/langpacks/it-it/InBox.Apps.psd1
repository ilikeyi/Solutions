ConvertFrom-StringData -StringData @'
	# it-IT
	# Italian (Italy)

	AdvAppsDetailed                 = Genera rapporto
	AdvAppsDetailedTips             = Cerca per tag regionale, ottieni maggiori dettagli quando sono disponibili i pacchetti di esperienze nella lingua locale e genera un file di report: *.CSV.
	ProcessSources                  = Fonte di elaborazione
	InboxAppsManager                = Applicazione Posta in arrivo
	InboxAppsMatchDel               = Elimina rispettando le regole
	InboxAppsOfflineDel             = Elimina un'applicazione con provisioning
	InboxAppsClear                  = Rimozione forzata di tutte le pre-app installate ( InBox Apps )
	InBox_Apps_Match                = Abbina le app delle InBox Apps
	InBox_Apps_Check                = Controlla i pacchetti di dipendenze
	InBox_Apps_Check_Tips           = Secondo le regole, ottenere tutti gli elementi di installazione selezionati e verificare se gli elementi di installazione dipendenti sono stati selezionati.
	LocalExperiencePack             = Pacchetti di esperienze in lingua locale ( LXPs )
	LEPBrandNew                     = In un modo nuovo, consigliato
	UWPAutoMissingPacker            = Cerca automaticamente i pacchetti mancanti da tutti i dischi
	UWPAutoMissingPackerSupport     = Architettura x64, i pacchetti mancanti devono essere installati.
	UWPAutoMissingPackerNotSupport  = Architettura non x64, utilizzata quando è supportata solo l'architettura x64.
	UWPEdition                      = Identificatore univoco della versione di Windows
	Optimize_Appx_Package           = Ottimizza il provisioning dei pacchetti Appx sostituendo file identici con collegamenti reali
	Optimize_ing                    = Ottimizzazione
	Remove_Appx_Tips                = Illustrare:\n\nPassaggio 1: aggiungere pacchetti di esperienza in lingua locale ( LXPs ). Questo passaggio deve corrispondere al pacchetto corrispondente rilasciato ufficialmente da Microsoft. Vai qui e scarica:\n       Aggiungi Language Pack alle immagini multisessione di Windows 10\n       https://learn.microsoft.com/it-it/azure/virtual-desktop/language-packs\n\n       Aggiungi lingue alle immagini di Windows 11 Enterprise\n       https://learn.microsoft.com/it-it/azure/virtual-desktop/windows-11-language-packs\n\nPassaggio 2: decomprimere o montare *_InboxApps.iso e selezionare la directory in base all'architettura;\n\nPassaggio 3: se Microsoft non ha rilasciato ufficialmente l'ultimo pacchetto di esperienza in lingua locale ( LXPs ), in tal caso salta questo passaggio: fai riferimento all'annuncio ufficiale di Microsoft:\n       1. Corrispondenti ai pacchetti di esperienze in lingua locale ( LXPs );\n       2. Corrispondente agli aggiornamenti cumulativi. \n\nLe app preinstallate ( InBox Apps ) sono monolingua e devono essere reinstallate per diventare multilingue. \n\n1. Puoi scegliere tra la versione sviluppatore e la versione iniziale;\n    Versione sviluppatore, ad esempio, il numero di versione è: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Versione iniziale, versione iniziale conosciuta:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    importante:\n      a. Ricrea l'immagine quando ogni versione viene aggiornata. Ad esempio, quando passi da 21H1 a 22H2, non aggiornare in base alla vecchia immagine per evitare altri problemi di compatibilità. Ancora una volta, utilizza la versione iniziale.\n      b. Questo regolamento è stato chiaramente comunicato ai confezionatori in varie forme da alcuni produttori OEM e non sono consentiti aggiornamenti diretti da versioni iterative.\n      Parole chiave: iterazione, versioni incrociate, aggiornamento cumulativo.\n\n2. Dopo aver installato il Language Pack, è necessario aggiungere un aggiornamento cumulativo, poiché prima dell'aggiunta dell'aggiornamento cumulativo, il componente non subirà alcuna modifica. Le nuove modifiche non verranno apportate fino all'installazione dell'aggiornamento cumulativo. Ad esempio, lo stato del componente:. obsoleto, da eliminare;\n\n3. Quando si utilizza una versione con aggiornamenti cumulativi, è comunque necessario aggiungere nuovamente gli aggiornamenti cumulativi alla fine, il che è un'operazione ripetuta;\n\n4. Pertanto, si consiglia di utilizzare una versione senza aggiornamenti cumulativi durante la produzione e quindi aggiungere aggiornamenti cumulativi nell'ultimo passaggio. \n\nCondizioni di ricerca dopo aver selezionato la directory: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Dopo l'estrazione, verrà visualizzata la ISO montata. Regole: 
	ImportCleanDuplicate            = Pulisci i file duplicati
	ForceRemovaAllUWP               = Salta l'aggiunta del pacchetto di esperienze in lingua locale ( LXPs ), esegui altro
	LEPSkipAddEnglish               = Si consiglia di ignorare l'aggiunta di en-US durante l'installazione.
	LEPSkipAddEnglishTips           = Non è necessario aggiungere il pacchetto di lingua inglese predefinito.
	License                         = Certificato
	IsLicense                       = Avere certificato
	NoLicense                       = Nessun certificato
	CurrentIsNVeriosn               = Serie versione N
	CurrentNoIsNVersion             = Versione completamente funzionante
	LXPsWaitAddUpdate               = Da aggiornare
	LXPsWaitAdd                     = Da aggiungere
	LXPsWaitAssign                  = Da destinare
	LXPsWaitRemove                  = Da eliminare
	LXPsAddDelTipsView              = Ci sono nuovi suggerimenti, controlla ora
	LXPsAddDelTipsGlobal            = Niente più richieste, sincronizza su globale
	LXPsAddDelTips                  = Non chiedere più
	Instl_Dependency_Package        = Consenti l'assemblaggio automatico di pacchetti dipendenti durante l'installazione delle app InBox
	Instl_Dependency_Package_Tips   = Quando l'applicazione da aggiungere ha pacchetti dipendenti, si abbinerà automaticamente secondo le regole e completerà la funzione di combinazione automatica dei pacchetti dipendenti richiesti.
	Instl_Dependency_Package_Match  = Combinazione di pacchetti di dipendenze
	Instl_Dependency_Package_Group  = Combinazione
	InBoxAppsErrorNoSave            = Quando si incontra un errore, non è permesso essere salvato
	InBoxAppsErrorTips              = Ci sono errori, l'elemento riscontrato nell'elemento corrispondente {0} non ha avuto successo
	InBoxAppsErrorNo                = Non sono stati trovati errori nella corrispondenza
'@