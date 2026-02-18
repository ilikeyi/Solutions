ConvertFrom-StringData -StringData @'
	# pl-PL
	# Polish (Poland)

	Save                            = Ratować
	DoNotSave                       = Nie oszczędzaj
	DoNotSaveTips                   = Nie do odzyskania, odinstaluj obraz bezpośrednio.
	UnmountAndSave                  = Następnie odinstaluj
	UnmountNotAssignMain            = Gdy {0} nie jest przydzielone
	UnmountNotAssignMain_Tips       = Podczas przetwarzania wsadowego należy określić, czy zapisać nieprzypisane pozycje główne, czy nie.
	ImageEjectTips                  = Ostrzeżenie\n\n    1. Przed zapisaniem zaleca się "Sprawdzenie stanu zdrowia". Jeśli pojawi się komunikat "Do naprawy" lub "Nie do naprawy":\n       * Podczas procesu konwersji ESD wyświetla się błąd 13 i dane są nieprawidłowe;\n       * Wystąpił błąd podczas instalacji systemu.\n\n    2. Sprawdź stan zdrowia, boot.wim nie jest obsługiwany.\n\n    3. Jeśli na obrazie zamontowany jest plik, a na obrazie nie określono żadnej akcji deinstalacyjnej, zostanie on domyślnie zapisany.\n\n    4. Podczas zapisywania możesz przypisać zdarzenia rozszerzeń;\n\n    5. Zdarzenie po pop-upie zostanie wykonane tylko wtedy, gdy nie zostanie zapisane.
	ImageEjectSpecification         = Wystąpił błąd podczas odinstalowywania programu {0}. Odinstaluj rozszerzenie i spróbuj ponownie.
	ImageEjectExpand                = Zarządzaj plikami na obrazie
	ImageEjectExpandTips            = Wskazówka\n\n    Sprawdź stan rozszerzenia, które może nie być obsługiwane. Możesz spróbować to sprawdzić po jego włączeniu.
	Image_Eject_Force               = Zezwalaj na odinstalowywanie obrazów offline
	ImageEjectDone                  = Po wykonaniu wszystkich zadań

	Abandon_Allow                   = Zezwalaj na szybką likwidację
	Abandon_Allow_Auto              = Zezwalaj na automatyczne włączanie szybkiej likwidacji
	Abandon_Allow_Auto_Tips         = Po włączeniu tej opcji opcja "Zezwalaj na szybką likwidację" pojawi się w obszarze "Autopilot, Niestandardowe przypisywanie znanych zdarzeń, Okna podręczne". Ta funkcja jest obsługiwana tylko w: Zadaniach głównych.
	Abandon_Agreement               = Szybka likwidacja: Zgoda
	Abandon_Agreement_Disk_range    = Partycje dysku, które zaakceptowały szybką likwidację
	Abandon_Agreement_Allow         = Akceptuję korzystanie z szybkiej likwidacji i nie będę już ponosić odpowiedzialności za konsekwencje formatowania partycji dysku
	Abandon_Terms                   = Warunki
	Abandon_Terms_Change            = Warunki uległy zmianie
	Abandon_Allow_Format            = Zezwalaj na formatowanie
	Abandon_Allow_UnFormat          = Nieautoryzowane formatowanie partycji
	Abandon_Allow_Time_Range        = Zezwalanie na wykonywanie funkcji programu PowerShell zostanie aktywowane w dowolnym momencie
'@