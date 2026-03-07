ConvertFrom-StringData -StringData @'
	# de-DE
	# German (Germany)

	Save                            = Sparen
	DoNotSave                       = Rette nicht
	DoNotSaveTips                   = Nicht wiederherstellbar, unmounten Sie das Image direkt.
	UnmountAndSave                  = Dann deinstallieren
	UnmountNotAssignMain            = Wenn {0} nicht zugewiesen ist
	UnmountNotAssignMain_Tips       = Bei der Stapelverarbeitung müssen Sie angeben, ob der Hauptartikel gespeichert wird oder nicht, wenn er nicht zugewiesen ist.
	ImageEjectTips                  = Warnen\n\n    1. Vor dem Speichern, dass Sie "Check Health Status" durchführen, "reparierbar" erscheint, Wenn "nicht reparierbar":\n       * Während der Konvertierung von ESD wird Fehler 13 angezeigt, die Daten sind ungültig;\n       * Fehler bei der Installation des Systems.\n\n    2. Überprüfen Sie den Integritätsstatus, boot.wim wird nicht unterstützt.\n\n    3. Wenn eine Image Datei eingehängt wird und die Aktion zum Aushängen im Image nicht angegeben ist, wird sie automatisch gemäß der Voreinstellung verarbeitet.\n\n    4. Beim Speichern können Erweiterungselemente zugewiesen werden;\n\n    5. Das Ereignis nach dem Pop up wird nur ausgeführt, wenn es nicht gespeichert wird.
	ImageEjectSpecification         = Beim Deinstallieren von {0} ist ein Fehler aufgetreten. Bitte deinstallieren Sie die Erweiterung und versuchen Sie es erneut.
	ImageEjectExpand                = Verwalten von Dateien innerhalb eines Bildes
	ImageEjectExpandTips            = Prompt\n\n    Überprüfen Sie den Integritätsstatus, Sie unterstützen möglicherweise keine erweiterten Elemente, Sie können versuchen, dies zu überprüfen, nachdem Sie es aktiviert haben.
	Image_Eject_Force               = Entladen von Offline Bildern zulassen
	ImageEjectDone                  = Nach Beendigung aller Aufgaben

	Abandon_Allow                   = Schnelle Datenlöschung zulassen
	Abandon_Allow_Auto              = Schnelle Datenlöschung automatisch aktivieren
	Abandon_Allow_Auto_Tips         = Nachdem Sie diese Option aktiviert haben, erscheint die Option "Schnelle Datenlöschung zulassen" unter "Autopilot > Benutzerdefinierte Zuordnung bekannter Ereignisse > Popups". Diese Funktion wird nur in Hauptaufgaben unterstützt.
	Abandon_Agreement               = Schnelle Datenlöschung: Zustimmung
	Abandon_Agreement_Disk_range    = Festplattenpartitionen, für die die schnelle Datenlöschung aktiviert ist
	Abandon_Agreement_Allow         = Ich akzeptiere die Verwendung der schnellen Datenlöschung und übernehme keine Verantwortung mehr für die Folgen der Formatierung von Festplattenpartitionen
	Abandon_Terms                   = Bedingungen
	Abandon_Terms_Change            = Die Bedingungen haben sich geändert
	Abandon_Allow_Format            = Formatierung zulassen
	Abandon_Allow_UnFormat          = Nicht autorisierte Formatierung von Partitionen
	Abandon_Allow_Time_Range        = Die Ausführung von PowerShell-Funktionen wird jederzeit zugelassen
'@