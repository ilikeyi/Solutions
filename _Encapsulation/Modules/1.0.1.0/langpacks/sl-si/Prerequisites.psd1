ConvertFrom-StringData -StringData @'
	# sl-SI
	# Slovenian (Slovenia)

	Prerequisites                   = Predpogoji
	Check_PSVersion                 = Preverite različico PS 5.1 in novejše
	Check_OSVersion                 = Preverite različico sistema Windows > 10.0.16299.0
	Check_Higher_elevated           = Ček mora biti povišan na višje privilegije
	Check_execution_strategy        = Preverite strategijo izvajanja

	Check_Pass                      = Prehod
	Check_Did_not_pass              = Ni uspelo
	Check_Pass_Done                 = Čestitam, uspešno.
	How_solve                       = Kako rešiti
	UpdatePSVersion                 = Namestite najnovejšo različico PowerShell
	UpdateOSVersion                 = 1. Pojdite na Microsoftovo uradno spletno mesto in prenesite najnovejšo različico operacijskega sistema\n    2. Namestite najnovejšo različico operacijskega sistema in poskusite znova
	HigherTermail                   = 1. Odprite terminal ali PowerShell ISE kot skrbnik, \n       Nastavite pravilnik izvajanja lupine PowerShell: Bypass, ukazna vrstica PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Ko je težava rešena, znova zaženite ukaz.
	HigherTermailAdmin              = 1. Odprite terminal ali PowerShell ISE kot skrbnik. \n     2. Ko je težava rešena, znova zaženite ukaz.
	LowAndCurrentError              = Najmanjša različica: {0}, trenutna različica: {1}
	Check_Eligible                  = Primeren
	Check_Version_PSM_Error         = Napaka različice, glejte {0}.psm1. Primer, znova nadgradite {0}.psm1 in poskusite znova.

	Check_OSEnv                     = Preverjanje sistemskega okolja
	Check_Image_Bad                 = Preverite, ali je naložena slika poškodovana
	Check_Need_Fix                  = Polomljeni predmeti, ki jih je treba popraviti
	Image_Mount_Mode                = Način namestitve
	Image_Mount_Status              = Stanje namestitve
	Check_Compatibility             = Preverjanje združljivosti
	Check_Duplicate_rule            = Preverite podvojene vnose pravil
	Duplicates                      = Ponovite
	ISO_File                        = ISO datoteka
	ISO_Langpack                    = Jezikovni paket ISO
'@