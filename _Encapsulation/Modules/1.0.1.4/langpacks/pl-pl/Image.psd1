ConvertFrom-StringData -StringData @'
	# pl-PL
	# Polish (Poland)

	SaveModeClear                   = Wyczyść wybraną historię
	SaveModeTipsClear               = Historia została zapisana i można ją wyczyścić
	SelectTips                      = Wskazówki\n\n    1. Wybierz nazwę obrazu, który ma zostać przetworzony;\n    2. Po anulowaniu zadania wymagające "zamontowania" przed operacją nie będą już realizowane.
	CacheDisk                       = Pamięć podręczna dysku
	CacheDiskCustomize              = Niestandardowa ścieżka pamięci podręcznej
	AutoSelectRAMDISK               = Zezwalaj na automatyczny wybór etykiety woluminu dysku
	AutoSelectRAMDISKFailed         = Nie dopasowana etykieta woluminu: {0}
	ReFS_Find_Volume                = W przypadku napotkania formatu dysku REFS wyklucz
	ReFS_Exclude                    = Partycja ReFS wykluczona
	RAMDISK_Change                  = Zmień nazwę etykiety woluminu
	RAMDISK_Restore                 = Przywróć zainicjowaną nazwę woluminu: {0}
	AllowTopMost                    = Pozwól, aby otwarte okna były przypinane do góry
	History                         = Jasna historia
	History_Del_Tips                = Jeśli istnieje zadanie enkapsulacji, nie wykonuj poniższych opcji opcjonalnych, w przeciwnym razie spowoduje to nieznane problemy podczas uruchamiania skryptu enkapsulacji.
	History_View                    = Zobacz historię
	HistoryLog                      = Zezwalaj na automatyczne czyszczenie kłód starszych niż 7 dni
	HistorySaveFolder               = Inne ścieżki źródeł obrazu
	HistoryClearappxStage           = InBox Apps: Usuń pliki tymczasowe wygenerowane podczas instalacji
	DoNotCheckBoot                  = Gdy rozmiar pliku Boot.wim przekracza 520 MB, podczas generowania obrazu ISO automatycznie wybierana jest opcja przebudowania.
	HistoryClearDismSave            = Usuń rekordy podłączenia DISM zapisane w rejestrze
	Clear_Bad_Mount                 = Usuń wszystkie zasoby powiązane z uszkodzonym zamontowanym obrazem
	ShowCommand                     = Pokaż pełne uruchomienie wiersza poleceń
	Command                         = Wiersz poleceń
	SelectSettingImage              = Źródło obrazu
	NoSelectImageSource             = Nie wybrano źródła obrazu
	SettingImageRestore             = Przywróć domyślną lokalizację montowania
	SettingImage                    = Zmień lokalizację montażu źródła obrazu
	SelectImageMountStatus          = Uzyskaj status podłączenia po wybraniu źródła obrazu
	SettingImageTempFolder          = Katalog tymczasowy
	SettingImageToTemp              = Katalog tymczasowy jest taki sam jak lokalizacja, w której został zamontowany
	SettingImagePathTemp            = Korzystanie z katalogu Temp
	SettingImageLow                 = Sprawdź minimalną pozostałą ilość wolnego miejsca
	SettingImageNewPath             = Wybierz opcję montażu dysku
	SettingImageNewPathTips         = Zalecane jest zamontowanie go na dysku pamięci, który jest najszybszy. Można używać oprogramowania pamięci wirtualnej, takiego jak Ultra RAMDisk i ImDisk.
	SelectImageSource               = Wybrano opcję "Wdróż rozwiązanie silnika", kliknij OK.
	NoImagePreSource                = Nie znaleziono dostępnego źródła. Powinieneś: \n\n     1. Dodaj więcej źródeł obrazów do: \n          {0}\n\n     2. Wybierz "Ustawienia" i ponownie wybierz dysk wyszukiwania źródła obrazu;\n\n     3. Wybierz "ISO" i wybierz ISO do dekompresji, elementy do zamontowania itp.
	NoImageOtherSource              = Kliknij mnie, aby "Dodaj" inne ścieżki lub "Przeciągnij katalog" do bieżącego okna.
	SearchImageSource               = Dysk wyszukiwania źródła obrazu
	Kernel                          = Jądro
	Architecture                    = Architektura
	ArchitecturePack                = Architektura pakietu, zrozumienie zasad dodawania
	ImageLevel                      = Typ instalacji
	LevelDesktop                    = Pulpit
	LevelServer                     = Serwer
	ImageCodename                   = Nazwa kodowa
	ImageCodenameNo                 = Nierozpoznany
	MainImageFolder                 = Katalog domowy
	MountImageTo                    = Zamontować do
	Image_Path                      = Ścieżka obrazu
	MountedIndex                    = Indeks
	MountedIndexSelect              = Wybierz numer indeksu
	AutoSelectIndexFailed           = Automatyczny wybór indeksu {0} nie powiódł się. Spróbuj ponownie.
	Apply                           = Aplikacja
	Eject                           = Wyskoczyć
	Mount                           = Uchwyt
	Unmount                         = Odinstaluj
	Mounted                         = Zmontowany
	NotMounted                      = Nie zamontowany
	NotMountedSpecify               = Niezamontowany, można określić miejsce montażu
	MountedIndexError               = Nieprawidłowy montaż, usuń i spróbuj ponownie.
	ImageSouresNoSelect             = Pokaż więcej szczegółów po wybraniu źródła obrazu
	Mounted_Mode                    = Tryb montowania
	Mounted_Status                  = Stan montażu
	Image_Popup_Default             = Zapisz jako domyślny
	Image_Restore_Default           = Przywróć ustawienia domyślne
	Image_Popup_Tips                = Wskazówka: \n\nPrzypisując zdarzenie, nie określiłeś numeru indeksu do przetworzenia {0}; \n\nAktualnie pojawił się interfejs wyboru. Proszę podać numer indeksu. Po zakończeniu specyfikacji zaleca się wybranie opcji "Zapisz jako domyślne". Nie pojawi się on ponownie przy następnym przetwarzaniu.
	Rule_Show_Full                  = Pokaż wszystko
	Rule_Show_Only                  = Pokaż tylko zasady
	Rule_Show_Only_Select           = Wybierz z zasad
	Image_Unmount_After             = Odinstaluj wszystkie zamontowane

	Wim_Rule_Update                 = Wyodrębnij i zaktualizuj pliki z obrazu
	Wim_Rule_Extract                = Wyodrębnij pliki
	Wim_Rule_Extract_Tips           = Po wybraniu reguły ścieżki wyodrębnij określony plik i zapisz go lokalnie.

	Wim_Rule_Verify                 = Zweryfikować
	Wim_Rule_Check                  = Zbadać
	Destination                     = Miejsce docelowe

	Wim_Rename                      = Zmodyfikuj informacje o obrazie
	Wim_Image_Name                  = Nazwa obrazu
	Wim_Image_Description           = Opis obrazu
	Wim_Display_Name                = Nazwa wyświetlana
	Wim_Display_Description         = Pokaż opis
	Wim_Edition                     = Znak obrazu
	Wim_Edition_Select_Know         = Wybierz znane flagi obrazu
	Wim_Created                     = Data utworzenia
	Wim_Expander_Space              = Przestrzeń ekspansji

	IABSelectNo                     = Nie wybrano klucza podstawowego: Zainstaluj, WinRE, Boot
	Unique_Name                     = Unikalne nazewnictwo
	Select_Path                     = Ścieżka
	Setting_Pri_Key                 = Ustaw ten plik aktualizacji jako główny szablon:
	Pri_Key_Update_To               = Następnie zaktualizuj do:
	Pri_Key_Template                = Ustaw ten plik jako preferowany szablon do synchronizacji z wybranymi elementami
	Pri_key_Running                 = Zadanie klucza podstawowego zostało zsynchronizowane i pominięte.
	ShowAllExclude                  = Pokaż wszystkie przestarzałe wykluczenia

	Index_Process_All               = Przetwarzaj wszystkie znane numery indeksów
	Index_Is_Event_Select           = W przypadku wystąpienia zdarzenia pojawia się interfejs wyboru numeru indeksu.
	Index_Pre_Select                = Wstępnie przypisany numer indeksu
	Index_Select_Tips               = Wskazówka: \n\nPlik {0}.wim nie jest aktualnie zamontowany, możesz: \n\n   1. Wybierz "Przetwarzaj wszystkie znane numery indeksowe";\n\n   2. Wybierz opcję "W przypadku wystąpienia zdarzenia pojawi się interfejs wyboru numeru indeksu";\n\n   3. Wstępnie określony numer indeksu\n      Podano indeks o numerze 6, numer indeksu nie istnieje podczas przetwarzania i przetwarzanie jest pomijane.

	Index_Tips_Custom_Expand        = Grupa: {0}\n\nPodczas przetwarzania {1} należy przypisać numer indeksu {2}, w przeciwnym razie nie można go przetworzyć.\n\nPo wybraniu opcji "Synchronizuj reguły aktualizacji ze wszystkimi numerami indeksu" wystarczy zaznaczyć dowolny z nich jako szablon główny.
'@