ConvertFrom-StringData -StringData @'
	# it-IT
	# Italian (Italy)

	Prerequisites                   = Prerequisiti
	Check_PSVersion                 = Controlla la versione PS 5.1 e successive
	Check_OSVersion                 = Controlla la versione di Windows > 10.0.16299.0
	Check_Higher_elevated           = Il controllo deve essere elevato a privilegi più elevati
	Check_execution_strategy        = Controllare la strategia di esecuzione

	Check_Pass                      = Passaggio
	Check_Did_not_pass              = Fallito
	Check_Pass_Done                 = Congratulazioni, superato.
	How_solve                       = Come risolvere
	UpdatePSVersion                 = Installa la versione più recente di PowerShell
	UpdateOSVersion                 = 1. Vai al sito Web ufficiale di Microsoft per scaricare l'ultima versione del sistema operativo\n    2. Installa la versione più recente del sistema operativo e riprova
	HigherTermail                   = 1. Apri Terminale o PowerShell ISE come amministratore, \n       Imposta i criteri di esecuzione di PowerShell: Bypass, riga di comando PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Una volta risolto, esegui nuovamente il comando.
	HigherTermailAdmin              = 1. Apri Terminale o PowerShell ISE come amministratore. \n     2. Una volta risolto, esegui nuovamente il comando.
	LowAndCurrentError              = Versione minima: {0}, versione corrente: {1}
	Check_Eligible                  = Idoneo
	Check_Version_PSM_Error         = Errore di versione, fai riferimento a {0}.psm1.Example, aggiorna nuovamente {0}.psm1 e riprova.

	Check_OSEnv                     = Controllo dell'ambiente di sistema
	Check_Image_Bad                 = Controlla se l'immagine caricata è danneggiata
	Check_Need_Fix                  = Oggetti rotti che necessitano di essere riparati
	Image_Mount_Mode                = Modalità di montaggio
	Image_Mount_Status              = Stato del montaggio
	Check_Compatibility             = Controllo di compatibilità
	Check_Duplicate_rule            = Verifica la presenza di voci di regole duplicate
	Duplicates                      = Ripetere
	ISO_File                        = File ISO
	ISO_Langpack                    = Pacchetto lingue ISO
'@