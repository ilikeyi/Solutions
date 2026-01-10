ConvertFrom-StringData -StringData @'
	# it-IT
	# Italian (Italy)

	Save                            = Salva
	DoNotSave                       = Non salvare
	DoNotSaveTips                   = Irrecuperabile, disinstalla direttamente l'immagine.
	UnmountAndSave                  = Quindi disinstallare
	UnmountNotAssignMain            = Quando {0} non è allocato
	UnmountNotAssignMain_Tips       = Durante l'elaborazione batch è necessario specificare se salvare o meno gli articoli principali non assegnati.
	ImageEjectTips                  = Avvisare\n\n    1. Prima di salvare, si consiglia di "Verificare lo stato di integrità" Quando viene visualizzato "Riparabile" o "Irreparabile": \n       * Durante il processo di conversione ESD viene visualizzato l'errore 13 e i dati non sono validi;\n       * Si è verificato un errore durante l'installazione del sistema.\n\n    2. Controlla lo stato di integrità, boot.wim non è supportato.\n\n    3. Quando nell'immagine è montato un file e nell'immagine non è specificata alcuna azione di disinstallazione, verrà salvato per impostazione predefinita.\n\n    4. Durante il salvataggio è possibile assegnare eventi di interno;\n\n    5. L'evento dopo il pop-up verrà eseguito solo se non viene salvato.
	ImageEjectSpecification         = Si è verificato un errore durante la disinstallazione di {0}. Disinstalla l'estensione e riprova.
	ImageEjectExpand                = Gestisci i file all'interno dell'immagine
	ImageEjectExpandTips            = Suggerimento\n\n    Controlla lo stato di integrità. L'estensione potrebbe non essere supportata. Puoi provare a controllarla dopo averla abilitata.
	Image_Eject_Force               = Consenti la disinstallazione delle immagini offline
	ImageEjectDone                  = Dopo aver completato tutte le attività

	Abandon_Allow                   = Consenti Eliminazione Rapida
	Abandon_Allow_Auto              = Consenti l'attivazione automatica dell'Eliminazione Rapida
	Abandon_Allow_Auto_Tips         = Dopo aver abilitato questa opzione, l'opzione "Consenti Eliminazione Rapida" apparirà in "Autopilot, Assegnazione personalizzata di eventi noti, Pop-up". Questa funzionalità è supportata solo in: Attività principali.
	Abandon_Agreement               = Eliminazione Rapida: Accordo
	Abandon_Agreement_Disk_range    = Partizioni del disco che hanno accettato l'eliminazione rapida
	Abandon_Agreement_Allow         = Accetto l'utilizzo dell'eliminazione rapida e non sarò più responsabile delle conseguenze della formattazione delle partizioni del disco
	Abandon_Terms                   = Termini
	Abandon_Terms_Change            = I termini sono cambiati
	Abandon_Allow_Format            = Consenti formattazione
	Abandon_Allow_UnFormat          = Formattazione non autorizzata delle partizioni
	Abandon_Allow_Time_Range        = L'esecuzione delle funzioni di PowerShell consentita avrà effetto in qualsiasi momento
'@