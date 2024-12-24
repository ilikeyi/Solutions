ConvertFrom-StringData -StringData @'
	# et-ee
	# Estonian (Estonia)

	Prerequisites                   = Eeldused
	Check_PSVersion                 = Kontrollige PS versiooni 5.1 ja uuemat
	Check_OSVersion                 = Kontrollige Windowsi versiooni > 10.0.16299.0
	Check_Higher_elevated           = Tšekk peab olema tõstetud kõrgematele õigustele
	Check_execution_strategy        = Kontrollige täitmisstrateegiat

	Check_Pass                      = Läbida
	Check_Did_not_pass              = Ebaõnnestunud
	Check_Pass_Done                 = Õnnitleme, läbitud.
	How_solve                       = Kuidas lahendada
	UpdatePSVersion                 = Installige uusim PowerShelli versioon
	UpdateOSVersion                 = 1. Minge Microsofti ametlikule veebisaidile, et laadida alla operatsioonisüsteemi uusim versioon\n    2. Installige operatsioonisüsteemi uusim versioon ja proovige uuesti
	HigherTermail                   = 1. Avage administraatorina terminal või PowerShell ISE, \n       Seadke PowerShelli täitmispoliitika: ümbersõit, PS-i käsurida: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Kui see on lahendatud, käivitage käsk uuesti.
	HigherTermailAdmin              = 1. Avage administraatorina terminal või PowerShell ISE. \n     2. Kui see on lahendatud, käivitage käsk uuesti.
	LowAndCurrentError              = Minimaalne versioon: {0}, praegune versioon: {1}
	Check_Eligible                  = Sobilik
	Check_Version_PSM_Error         = Versiooniviga, vaadake {0}.psm1.Näide, uuendage {0}.psm1 uuesti ja proovige uuesti.

	Check_OSEnv                     = Süsteemikeskkonna kontroll
	Check_Image_Bad                 = Kontrollige, kas laaditud pilt on rikutud
	Check_Need_Fix                  = Katkised esemed, mis vajavad parandamist
	Image_Mount_Mode                = Paigaldusrežiim
	Image_Mount_Status              = Kinnituse olek
	Check_Compatibility             = Ühilduvuse kontroll
	Check_Duplicate_rule            = Kontrollige reeglite dubleerivaid kirjeid
	Duplicates                      = Korda
	ISO_File                        = ISO fail
	ISO_Langpack                    = ISO keelepakett
'@