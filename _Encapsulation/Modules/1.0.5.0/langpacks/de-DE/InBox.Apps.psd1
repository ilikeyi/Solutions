ConvertFrom-StringData -StringData @'
	# de-DE
	# German (Germany)

	AdvAppsDetailed                 = Generieren eines Berichts
	AdvAppsDetailedTips             = Suchen Sie nach Region Tag, finden Sie verfügbare lokale Spracherfahrungspakete, erhalten Sie weitere Details, generieren Sie eine Berichtsdatei: *.CSV.
	ProcessSources                  = Verarbeiten der Quelle
	InboxAppsManager                = Posteingang App
	InboxAppsMatchDel               = Löschen nach übereinstimmender Regel
	InboxAppsOfflineDel             = Löschen der bereitgestellten Anwendung
	InboxAppsClear                  = Alle installierten Pre Apps (UWP) zwangsweise entfernen
	InBox_Apps_Match                = Passen Sie InBox Apps an
	InBox_Apps_Check                = Abhängigkeiten prüfen
	InBox_Apps_Check_Tips           = Rufen Sie gemäß den Regeln alle ausgewählten Installationselemente ab und überprüfen Sie, ob die abhängigen Installationselemente ausgewählt wurden.
	LocalExperiencePack             = Local Language Experience Packs
	LEPBrandNew                     = Auf eine neue Art, empfehlenswert
	UWPAutoMissingPacker            = Automatische Suche nach fehlenden Paketen auf allen Datenträgern
	UWPAutoMissingPackerSupport     = x64 Architektur müssen die fehlenden Pakete installiert werden.
	UWPAutoMissingPackerNotSupport  = Nicht x64 Architektur, wird nur verwendet, wenn x64 Architektur unterstützt wird.
	UWPEdition                      = Der eindeutige Bezeichner der Windows Version
	Optimize_Appx_Package           = Optimieren Sie die Bereitstellung von Appx Paketen, indem Sie identische Dateien durch feste Links ersetzen
	Optimize_ing                    = Optimieren
	Remove_Appx_Tips                = Veranschaulichen: \n\nSchritt 1: Lokale Spracherlebnispakete ( LXPs ) hinzufügen, dieser Schritt muss den entsprechenden Paketen entsprechen, die offiziell von Microsoft veröffentlicht wurden, gehen Sie hier und laden Sie es herunter:\n       Sprachpakete zu Windows 10 Images für mehrere Sitzungen hinzufügen\n       https://learn.microsoft.com/de-de/azure/virtual-desktop/language-packs\n\n       Sprachen zu Windows 11 Enterprise-Images hinzufügen\n       https://learn.microsoft.com/de-de/azure/virtual-desktop/windows-11-language-packs\n\nSchritt 2: Entpacken oder mounten Sie *_InboxApps.iso und wählen Sie das Verzeichnis entsprechend der Architektur aus;\n\n Schritt 3: Wenn Microsoft die neuesten Local Language Experience Packs ( LXPs ) nicht offiziell veröffentlicht hat, überspringen Sie diesen Schritt; wenn ja: lesen Sie bitte die offizielle Ankündigung von Microsoft:\n       1. Entsprechende lokale Spracherfahrungspakete ( LXPs );\n       2. Entsprechendes kumulatives Update. \n\nVorinstallierte Apps (UWP) sind einsprachig und müssen neu installiert werden, um mehrsprachig zu werden.\n\n1 können Sie die Entwicklerversion, die ursprüngliche Version der Produktion, auswählen;\n    Die Entwicklerversion, zum Beispiel, die Versionsnummer lautet:\n    Windows 11 Reihe\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Erstveröffentlichung, bekannte Erstversion:\n    Windows 11 Reihe\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 Serie\n    Windows 10 22H2, Build 19045.2006\n\n    wichtig:\n      a. Wenn jede Version aktualisiert wird, erstellen Sie bitte das Image neu. Wenn Sie beispielsweise von 21H1 auf 22H2 wechseln, aktualisieren Sie bitte nicht auf der Grundlage des alten Images, und andere Kompatibilitätsprobleme sollten vermieden werden. Denken Sie erneut daran, verwenden Sie bitte die erste Version zu erstellen.\n      b. Diese Verordnung hat den Verpackern in verschiedenen Formen bei einigen OEM Herstellern das Dekret klar mitgeteilt, und direkte Upgrades von iterativen Versionen sind nicht zulässig.\n      Schlüsselwörter: Iteration, Cross Version, kumulatives Update.\n\n2. Nach der Installation des Sprachpakets muss das kumulative Update hinzugefügt werden, da vor dem Hinzufügen des kumulativen Updates keine Änderungen an den Komponenten vorgenommen werden und neue Änderungen erst nach der Installation des kumulativen Updates erfolgen, z. B. Komponentenstatus: veraltet , gelöscht werden;\n\n3. Verwenden Sie die Version mit dem kumulativen Update Am Ende müssen Sie das kumulative Update immer noch erneut hinzufügen, und der Vorgang wurde wiederholt.\n\n4. Daher wird empfohlen, bei der Erstellung die Version ohne das kumulative Update zu verwenden und im letzten Schritt das kumulative Update hinzuzufügen. \n\nNach Auswahl eines Verzeichnisses Suchkriterien: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Nach dem Entpacken wird die eingebundene ISO Datei angezeigt. Regeln: 
	ImportCleanDuplicate            = Bereinigen Sie doppelte Dateien
	ForceRemovaAllUWP               = Überspringen Sie die Hinzufügung von Local Language Experience Packs ( LXPs ) und erledigen Sie andere
	LEPSkipAddEnglish               = Überspringen Sie en-US Zusätze bei der Installation, empfohlen
	LEPSkipAddEnglishTips           = Das standardmäßige englische Sprachpaket ist zum Hinzufügen überflüssig.
	License                         = Zertifikat
	IsLicense                       = Mit Zertifikat
	NoLicense                       = Kein Zertifikat
	CurrentIsNVeriosn               = N Versionsserie
	CurrentNoIsNVersion             = Voll funktionsfähige Version
	LXPsWaitAddUpdate               = ausstehendes Upgrade
	LXPsWaitAdd                     = Hinzuzufügen
	LXPsWaitAssign                  = Zuzuordnen
	LXPsWaitRemove                  = Gelöscht werden
	LXPsAddDelTipsView              = Es gibt neue Tipps, schau es dir jetzt an
	LXPsAddDelTipsGlobal            = Keine Eingabeaufforderungen mehr, synchronisieren Sie mit dem globalen
	LXPsAddDelTips                  = Nicht erneut erinnern
	Instl_Dependency_Package        = Erlauben Sie die automatische Zusammenstellung abhängiger Pakete bei der Installation von InBox Apps
	Instl_Dependency_Package_Tips   = Wenn die hinzuzufügende Anwendung über abhängige Pakete verfügt, wird sie automatisch gemäß den Regeln abgeglichen und die Funktion der automatischen Kombination der erforderlichen abhängigen Pakete abgeschlossen.
	Instl_Dependency_Package_Match  = Abhängigkeitspakete kombinieren
	Instl_Dependency_Package_Group  = Kombination
	InBoxAppsErrorNoSave            = Bei der Begegnung auf einen Fehler darf er nicht gespeichert werden
	InBoxAppsErrorTips              = Es gibt Fehler, das Element, das in dem passenden {0} Element aufgetreten ist, war erfolglos
	InBoxAppsErrorNo                = Es wurden keine Fehler in der Übereinstimmung gefunden
'@