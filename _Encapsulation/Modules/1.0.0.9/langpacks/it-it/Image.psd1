ConvertFrom-StringData -StringData @'
	# it-IT
	# Italian (Italy)

	SaveModeClear                   = Cancella la cronologia selezionata
	SaveModeTipsClear               = La cronologia è stata salvata e può essere cancellata
	SelectTips                      = Suggerimento\n\n    1. Selezionare il nome dell'immagine da elaborare;\n    2. Dopo l'annullamento, le attività che richiedono il "montaggio" prima dell'operazione non avranno più effetto.
	CacheDisk                       = Cache del disco
	CacheDiskCustomize              = Percorso della cache personalizzato
	AutoSelectRAMDISK               = Consenti la selezione automatica dell'etichetta del volume del disco
	AutoSelectRAMDISKFailed         = Etichetta del volume non corrispondente: {0}
	ReFS_Find_Volume                = Quando viene rilevato il formato disco REFS, escludere
	ReFS_Exclude                    = Partizione ReFS esclusa
	RAMDISK_Change                  = Modifica il nome dell'etichetta del volume
	RAMDISK_Restore                 = Ripristina il nome del volume inizializzato: {0}
	AllowTopMost                    = Consenti alle finestre aperte di essere bloccate in alto
	History                         = Storia chiara
	History_Del_Tips                = Quando è presente un'attività di incapsulamento, non eseguire le seguenti opzioni facoltative, altrimenti causerà problemi sconosciuti durante l'esecuzione dello script di incapsulamento.
	History_View                    = Visualizza la cronologia
	HistoryLog                      = Consenti la pulizia automatica dei registri più vecchi di 7 giorni
	HistorySaveFolder               = Altri percorsi di origine dell'immagine
	HistoryClearappxStage           = App InBox: elimina i file temporanei generati durante l'installazione
	DoNotCheckBoot                  = Quando la dimensione del file Boot.wim supera i 520 MB, la ricostruzione viene selezionata automaticamente durante la generazione dell'ISO.
	HistoryClearDismSave            = Elimina i record di montaggio DISM salvati nel registro
	Clear_Bad_Mount                 = Elimina tutte le risorse associate all'immagine montata danneggiata
	ShowCommand                     = Mostra l'esecuzione completa della riga di comando
	Command                         = Riga di comando
	SelectSettingImage              = Fonte dell'immagine
	NoSelectImageSource             = Nessuna sorgente immagine selezionata
	SettingImageRestore             = Ripristina la posizione di montaggio predefinita
	SettingImage                    = Modifica la posizione di montaggio dell'origine immagine
	SelectImageMountStatus          = Ottieni lo stato di montaggio dopo aver selezionato la sorgente dell'immagine
	SettingImageTempFolder          = Directory temporanea
	SettingImageToTemp              = La directory temporanea è la stessa della posizione in cui è stata montata
	SettingImagePathTemp            = Utilizzando la directory Temp
	SettingImageLow                 = Controlla lo spazio minimo rimanente disponibile
	SettingImageNewPath             = Seleziona il disco di montaggio
	SettingImageNewPathTips         = Si consiglia di montarlo su un disco di memoria, che è il più veloce. È possibile utilizzare software di memoria virtuale come Ultra RAMDisk e ImDisk.
	SelectImageSource               = "Deploy Engine Solution" è stato selezionato, fare clic su OK.
	NoImagePreSource                = Nessuna fonte disponibile trovata, dovresti: \n\n     1. Aggiungi altre origini immagini a:\n          {0}\n\n     2. Seleziona "Impostazioni" e riseleziona il disco di ricerca della sorgente dell'immagine;\n\n     3. Seleziona "ISO" e seleziona l'ISO da decomprimere, gli elementi da montare, ecc.
	NoImageOtherSource              = Fai clic su di me per "Aggiungi" altri percorsi o "Trascina directory" nella finestra corrente.
	SearchImageSource               = Disco di ricerca dell'origine immagine
	Kernel                          = Nocciolo
	Architecture                    = Architettura
	ArchitecturePack                = Architettura del pacchetto, comprensione delle regole di aggiunta
	ImageLevel                      = Tipo di installazione
	LevelDesktop                    = Scrivania
	LevelServer                     = Server
	ImageCodename                   = Nome in codice
	ImageCodenameNo                 = Non riconosciuto
	MainImageFolder                 = Directory principale
	MountImageTo                    = Montare su
	Image_Path                      = Percorso dell'immagine
	MountedIndex                    = Indice
	MountedIndexSelect              = Seleziona il numero di indice
	AutoSelectIndexFailed           = La selezione automatica dell'indice {0} non è riuscita, riprova.
	Apply                           = Applicazione
	Eject                           = Apparire
	Mount                           = Montare
	Unmount                         = Disinstallare
	Mounted                         = Montato
	NotMounted                      = Non montato
	NotMountedSpecify               = Non montato, è possibile specificare la posizione di montaggio
	MountedIndexError               = Montaggio anomalo, elimina e riprova.
	ImageSouresNoSelect             = Mostra più dettagli dopo aver selezionato la sorgente dell'immagine
	Mounted_Mode                    = Modalità di montaggio
	Mounted_Status                  = Stato del montaggio
	Image_Popup_Default             = Salva come predefinito
	Image_Restore_Default           = Ripristina le impostazioni predefinite
	Image_Popup_Tips                = Suggerimento: \n\nQuando hai assegnato l'evento, non hai specificato il numero di indice da elaborare {0};\n\nL'interfaccia di selezione è attualmente visualizzata. Specificare il numero di indice Una volta completata la specifica, si consiglia di selezionare "Salva come predefinito". Non verrà visualizzata nuovamente la prossima volta che la si elabora.
	Rule_Show_Full                  = Mostra tutto
	Rule_Show_Only                  = Mostra solo le regole
	Rule_Show_Only_Select           = Scegli tra le regole
	Image_Unmount_After             = Smonta forzatamente tutte le immagini montate

	Wim_Rule_Update                 = Estrai e aggiorna i file all'interno dell'immagine
	Wim_Rule_Extract                = Estrai file
	Wim_Rule_Extract_Tips           = Dopo aver selezionato la regola del percorso, estrai il file specificato e salvalo localmente.

	Wim_Rule_Verify                 = Verificare
	Wim_Rule_Check                  = Esaminare
	Destination                     = Destinazione

	Wim_Rename                      = Modifica le informazioni sull'immagine
	Wim_Image_Name                  = Nome dell'immagine
	Wim_Image_Description           = Descrizione dell'immagine
	Wim_Display_Name                = Nome da visualizzare
	Wim_Display_Description         = Mostra la descrizione
	Wim_Edition                     = Marchio dell'immagine
	Wim_Edition_Select_Know         = Seleziona i flag di immagine conosciuti
	Wim_Created                     = Data di creazione
	Wim_Expander_Space              = Spazio di espansione

	IABSelectNo                     = Nessuna chiave primaria selezionata: Install, WinRE, Boot
	Unique_Name                     = Denominazione univoca
	Select_Path                     = Sentiero
	Setting_Pri_Key                 = Imposta questo file di aggiornamento come modello principale:
	Pri_Key_Update_To               = Quindi aggiorna a:
	Pri_Key_Template                = Imposta questo file come modello preferito da sincronizzare con gli elementi selezionati
	Pri_key_Running                 = L'attività della chiave primaria è stata sincronizzata ed è stata saltata.
	ShowAllExclude                  = Mostra tutte le esclusioni deprecate

	Index_Process_All               = Elabora tutti i numeri di indice conosciuti
	Index_Is_Event_Select           = Quando si verifica un evento, viene visualizzata l'interfaccia di selezione del numero di indice.
	Index_Pre_Select                = Numero indice preassegnato
	Index_Select_Tips               = Suggerimento:\n\n{0}.wim non è attualmente montato, puoi:\n\n   1. Selezionare "Elabora tutti i numeri di indice conosciuti";\n\n   2. Selezionare "Quando si verifica un evento, verrà visualizzata l'interfaccia di selezione del numero di indice";\n\n   3. Numero di indice preimpostato\n      È specificato il numero di indice 6, il numero di indice non esiste durante l'elaborazione e l'elaborazione viene saltata.

	Index_Tips_Custom_Expand        = Gruppo: {0}\n\nDurante l'elaborazione di {1}, è necessario assegnare il numero di indice {2}, altrimenti non può essere elaborato.\n\nDopo aver selezionato "Sincronizza le regole di aggiornamento su tutti i numeri di indice", devi solo selezionarne uno qualsiasi come modello principale.
'@