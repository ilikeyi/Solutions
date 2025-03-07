ConvertFrom-StringData -StringData @'
	# pl-PL
	# Polish (Poland)

	AdvAppsDetailed                 = Wygeneruj raport
	AdvAppsDetailedTips             = Wyszukaj według tagu regionu, uzyskaj więcej szczegółów, gdy będą dostępne pakiety języka lokalnego, i wygeneruj plik raportu: *.CSV.
	ProcessSources                  = Źródło przetwarzania
	InboxAppsManager                = Aplikacja skrzynki odbiorczej
	InboxAppsMatchDel               = Usuń, dopasowując reguły
	InboxAppsOfflineDel             = Usuń udostępnioną aplikację
	InboxAppsClear                  = Wymuś usunięcie wszystkich zainstalowanych aplikacji wstępnych ( InBox Apps )
	InBox_Apps_Match                = Dopasuj InBox Apps
	InBox_Apps_Check                = Sprawdź pakiety zależności
	InBox_Apps_Check_Tips           = Zgodnie z zasadami uzyskaj wszystkie wybrane elementy instalacji i sprawdź, czy zostały wybrane zależne elementy instalacji.
	LocalExperiencePack             = Pakiety doświadczeń językowych ( LXPs )
	LEPBrandNew                     = W nowy sposób polecam
	UWPAutoMissingPacker            = Automatycznie wyszukuj brakujące pakiety na wszystkich dyskach
	UWPAutoMissingPackerSupport     = Architekturze x64, należy zainstalować brakujące pakiety.
	UWPAutoMissingPackerNotSupport  = Architektura inna niż x64, używana, gdy obsługiwana jest tylko architektura x64.
	UWPEdition                      = Unikalny identyfikator wersji systemu Windows
	Optimize_Appx_Package           = Zoptymalizuj udostępnianie pakietów Appx, zastępując identyczne pliki twardymi linkami
	Optimize_ing                    = Optymalizacja
	Remove_Appx_Tips                = Zilustrować:\n\nKrok pierwszy: Dodaj pakiety języka lokalnego ( LXPs ). Ten krok musi odpowiadać odpowiedniemu pakietowi oficjalnie wydanemu przez firmę Microsoft. Przejdź tutaj i pobierz:\n       Dodaj pakiety językowe do obrazów wielosesyjnych systemu Windows 10\n       https://learn.microsoft.com/pl-pl/azure/virtual-desktop/language-packs\n\n       Dodaj języki do obrazów systemu Windows 11 Enterprise\n       https://learn.microsoft.com/pl-pl/azure/virtual-desktop/windows-11-language-packs\n\nKrok 2: Rozpakuj lub zamontuj *_InboxApps.iso i wybierz katalog zgodnie z architekturą;\n\nKrok 3: Jeśli firma Microsoft nie wydała oficjalnie najnowszego pakietu obsługi języka lokalnego ( LXPs ), pomiń ten krok: zapoznaj się z oficjalnym ogłoszeniem firmy Microsoft:\n       1. Odpowiadające lokalnym pakietom językowym ( LXPs );\n       2. Odpowiadające aktualizacjom zbiorczym. \n\nWstępnie zainstalowane aplikacje ( InBox Apps ) są jednojęzyczne i należy je ponownie zainstalować, aby uzyskać dostęp do wielu języków. \n\n1. Możesz wybrać pomiędzy wersją deweloperską a wersją początkową;\n    Wersja deweloperska, na przykład numer wersji to:\n    Windows 11 szereg\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Wersja pierwotna, znana wersja pierwotna: \n    Windows 11 szereg\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 szereg\n    Windows 10 22H2, Build 19045.2006\n\n    ważny:\n      a. Utwórz obraz ponownie po aktualizacji każdej wersji. Na przykład podczas przejścia z wersji 21H1 na 22H2 nie aktualizuj w oparciu o stary obraz, aby uniknąć innych problemów ze zgodnością. Ponownie użyj wersji początkowej.\n      b. Niektórzy producenci OEM wyraźnie zakomunikowali to rozporządzenie w różnych formach podmiotom pakującym i bezpośrednie aktualizacje z wersji iteracyjnych nie są dozwolone.\n      Słowa kluczowe: iteracja, wersja krzyżowa, aktualizacja zbiorcza.\n\n2. Po zainstalowaniu pakietu językowego należy dodać aktualizację zbiorczą, ponieważ przed dodaniem aktualizacji zbiorczej komponent nie będzie miał żadnych zmian. Nowe zmiany nie zostaną wprowadzone, dopóki aktualizacja zbiorcza nie zostanie zainstalowana. Na przykład stan komponentu: nieaktualne, do usunięcia;\n\n3. Jeśli korzystasz z wersji z aktualizacjami zbiorczymi, na koniec musisz jeszcze raz dodać aktualizacje zbiorcze, co jest operacją powtarzaną;\n\n4. Dlatego zaleca się, aby podczas produkcji używać wersji bez aktualizacji zbiorczych, a następnie w ostatnim kroku dodać aktualizacje zbiorcze. \n\nWarunki wyszukiwania po wybraniu katalogu: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Wyczyść zduplikowane pliki
	ForceRemovaAllUWP               = Pomiń dodawanie pakietu obsługi języka lokalnego ( LXPs ), wykonaj inne
	LEPSkipAddEnglish               = Zaleca się pominięcie dodawania en-US podczas instalacji.
	LEPSkipAddEnglishTips           = Domyślny pakiet języka angielskiego nie jest konieczny, aby go dodać.
	License                         = Certyfikat
	IsLicense                       = Posiadaj certyfikat
	NoLicense                       = Brak certyfikatu
	CurrentIsNVeriosn               = Seria wersji N
	CurrentNoIsNVersion             = Wersja w pełni funkcjonalna
	LXPsWaitAddUpdate               = Do aktualizacji
	LXPsWaitAdd                     = Do dodania
	LXPsWaitAssign                  = Do przydzielenia
	LXPsWaitRemove                  = Do usunięcia
	LXPsAddDelTipsView              = Pojawiły się nowe wskazówki, sprawdź już teraz
	LXPsAddDelTipsGlobal            = Żadnych więcej monitów, zsynchronizuj z globalnym
	LXPsAddDelTips                  = Nie monituj ponownie
	Instl_Dependency_Package        = Zezwalaj na automatyczne składanie zależnych pakietów podczas instalowania aplikacji InBox
	Instl_Dependency_Package_Tips   = Gdy dodawana aplikacja posiada pakiety zależne, automatycznie dopasuje się zgodnie z regułami i zakończy funkcję automatycznego łączenia wymaganych pakietów zależnych.
	Instl_Dependency_Package_Match  = Łączenie pakietów zależności
	Instl_Dependency_Package_Group  = Połączenie
	InBoxAppsErrorNoSave            = Podczas napotkającego błędu nie można go zapisać
	InBoxAppsErrorTips              = Istnieją błędy, element napotkany w dopasowaniu {0} element nie powiodła się
	InBoxAppsErrorNo                = W dopasowaniu nie znaleziono błędów
'@