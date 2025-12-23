ConvertFrom-StringData -StringData @'
	# lt-LT
	# Lithuanian (Lithuania)

	Prerequisites                   = Būtinos sąlygos
	Check_PSVersion                 = Patikrinkite PS 5.1 ir naujesnę versiją
	Check_OSVersion                 = Patikrinkite "Windows" versiją > 10.0.16299.0
	Check_Higher_elevated           = Čekis turi būti padidintas iki aukštesnių privilegijų
	Check_execution_strategy        = Patikrinkite vykdymo strategiją

	Check_Pass                      = Praeiti
	Check_Did_not_pass              = Nepavyko
	Check_Pass_Done                 = Sveikinu, praėjo.
	How_solve                       = Kaip išspręsti
	UpdatePSVersion                 = Įdiekite naujausią "PowerShell" versiją
	UpdateOSVersion                 = 1. Eikite į oficialią "Microsoft" svetainę ir atsisiųskite naujausią operacinės sistemos versiją\n    2. Įdiekite naujausią operacinės sistemos versiją ir bandykite dar kartą
	HigherTermail                   = 1. Atidarykite terminalą arba PowerShell ISE kaip administratorių, \n       Nustatykite "PowerShell" vykdymo strategiją: apeiti, PS komandų eilutė: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Išspręsę komandą paleiskite iš naujo.
	HigherTermailAdmin              = 1. Atidarykite terminalą arba PowerShell ISE kaip administratorių. \n    2. Išspręsę komandą paleiskite iš naujo.
	LowAndCurrentError              = Minimali versija: {0}, dabartinė versija: {1}
	Check_Eligible                  = Tinkamas
	Check_Version_PSM_Error         = Versijos klaida, žr. {0}.psm1.Pavyzdys, iš naujo atnaujinkite {0}.psm1 ir bandykite dar kartą.

	Check_OSEnv                     = Sistemos aplinkos patikrinimas
	Check_Image_Bad                 = Patikrinkite, ar įkeltas vaizdas nėra sugadintas
	Check_Need_Fix                  = Sugedę daiktai, kuriuos reikia taisyti
	Image_Mount_Mode                = Montavimo režimas
	Image_Mount_Status              = Montavimo būsena
	Check_Compatibility             = Suderinamumo patikrinimas
	Check_Duplicate_rule            = Patikrinkite, ar nėra pasikartojančių taisyklių įrašų
	Duplicates                      = Kartoti
	ISO_File                        = ISO failas
	ISO_Langpack                    = ISO kalbos paketas
'@