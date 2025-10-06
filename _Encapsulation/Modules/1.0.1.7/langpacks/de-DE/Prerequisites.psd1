ConvertFrom-StringData -StringData @'
	# de-DE
	# German (Germany)

	Prerequisites                   = Voraussetzungen
	Check_PSVersion                 = Überprüfen Sie PS-Version 5.1 und höher
	Check_OSVersion                 = Überprüfen Sie die Windows-Version > 10.0.16299.0
	Check_Higher_elevated           = Die Prüfung muss auf höhere Berechtigungen erhöht werden
	Check_execution_strategy        = Ausführungsstrategie prüfen

	Check_Pass                      = passieren
	Check_Did_not_pass              = fehlgeschlagen
	Check_Pass_Done                 = Herzlichen Glückwunsch, bestanden.
	How_solve                       = So lösen Sie es
	UpdatePSVersion                 = Bitte installieren Sie die neueste PowerShell-Version
	UpdateOSVersion                 = 1. Besuchen Sie die offizielle Website von Microsoft,\n      um die neueste Version des Betriebssystems herunterzuladen\n    2. Installieren Sie die neueste Version des Betriebssystems und versuchen Sie es erneut
	HigherTermail                   = 1. Öffnen Sie Terminal oder PowerShell ISE als Administrator.\n       PowerShell-Ausführungsrichtlinie festlegen: Bypass, PS-Befehlszeile: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Sobald das Problem gelöst ist, führen Sie den Befehl erneut aus.
	HigherTermailAdmin              = 1. Öffnen Sie Terminal oder PowerShell ISE als Administrator.\n     2. Sobald das Problem gelöst ist, führen Sie den Befehl erneut aus.
	LowAndCurrentError              = Mindestversion: {0}, aktuelle Version: {1}
	Check_Eligible                  = Berechtigt
	Check_Version_PSM_Error         = Versionsfehler, siehe {0}.psm1.Beispiel, aktualisieren Sie {0}.psm1 erneut und versuchen Sie es erneut.

	Check_OSEnv                     = Überprüfung der Systemumgebung
	Check_Image_Bad                 = Überprüfen Sie, ob das geladene Bild beschädigt ist
	Check_Need_Fix                  = Defekte Gegenstände, die repariert werden müssen
	Image_Mount_Mode                = Mount-Modus
	Image_Mount_Status              = Mount-Status
	Check_Compatibility             = Kompatibilitätsprüfung
	Check_Duplicate_rule            = Suchen Sie nach doppelten Regeleinträgen
	Duplicates                      = wiederholen
	ISO_File                        = ISO-Datei
	ISO_Langpack                    = ISO-Sprachpaket
'@