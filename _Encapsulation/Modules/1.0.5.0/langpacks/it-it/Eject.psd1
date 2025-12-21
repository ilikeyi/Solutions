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
'@