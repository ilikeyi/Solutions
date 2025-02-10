ConvertFrom-StringData -StringData @'
	# pl-PL
	# Polish (Poland)

	Prerequisites                   = Warunki wstępne
	Check_PSVersion                 = Sprawdź wersję PS 5.1 i nowszą
	Check_OSVersion                 = Sprawdź wersję systemu Windows > 10.0.16299.0
	Check_Higher_elevated           = Czek musi zostać podniesiony do wyższych uprawnień
	Check_execution_strategy        = Sprawdź strategię wykonania

	Check_Pass                      = Przechodzić
	Check_Did_not_pass              = Przegrany
	Check_Pass_Done                 = Gratulacje, przeszło.
	How_solve                       = Jak rozwiązać
	UpdatePSVersion                 = Zainstaluj najnowszą wersję PowerShell
	UpdateOSVersion                 = 1. Przejdź do oficjalnej strony Microsoftu, aby pobrać najnowszą wersję systemu operacyjnego\n    2. Zainstaluj najnowszą wersję systemu operacyjnego i spróbuj ponownie
	HigherTermail                   = 1. Otwórz Terminal lub PowerShell ISE jako administrator, \n       Ustaw zasady wykonywania PowerShell: Pomiń, wiersz poleceń PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Po rozwiązaniu problemu uruchom ponownie polecenie.
	HigherTermailAdmin              = 1. Otwórz Terminal lub PowerShell ISE jako administrator. \n     2. Po rozwiązaniu problemu uruchom ponownie polecenie.
	LowAndCurrentError              = Wersja minimalna: {0}, aktualna wersja: {1}
	Check_Eligible                  = Odpowiedni
	Check_Version_PSM_Error         = Błąd wersji, sprawdź plik {0}.psm1. Przykład, zaktualizuj ponownie plik {0}.psm1 i spróbuj ponownie.

	Check_OSEnv                     = Kontrola środowiska systemowego
	Check_Image_Bad                 = Sprawdź, czy załadowany obraz nie jest uszkodzony
	Check_Need_Fix                  = Uszkodzone elementy wymagające naprawy
	Image_Mount_Mode                = Tryb montowania
	Image_Mount_Status              = Stan montażu
	Check_Compatibility             = Kontrola kompatybilności
	Check_Duplicate_rule            = Sprawdź, czy nie ma zduplikowanych wpisów reguł
	Duplicates                      = Powtarzać
	ISO_File                        = Plik ISO
	ISO_Langpack                    = Pakiet językowy ISO
'@