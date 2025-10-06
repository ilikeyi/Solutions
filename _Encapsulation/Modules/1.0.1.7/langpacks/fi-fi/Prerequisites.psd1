ConvertFrom-StringData -StringData @'
	# fi-fi
	# Finnish (Finland)

	Prerequisites                   = Edellytykset
	Check_PSVersion                 = Tarkista PS versio 5.1 ja uudemmat
	Check_OSVersion                 = Tarkista Windows versio > 10.0.16299.0
	Check_Higher_elevated           = Sekki on korotettava korkeampiin oikeuksiin
	Check_execution_strategy        = Tarkista toteutusstrategia

	Check_Pass                      = Syöttö
	Check_Did_not_pass              = Epäonnistunut
	Check_Pass_Done                 = Onnittelut, ohitettu.
	How_solve                       = Miten ratkaista
	UpdatePSVersion                 = Asenna uusin PowerShell versio
	UpdateOSVersion                 = 1. Siirry Microsoftin viralliselle verkkosivustolle ladataksesi käyttöjärjestelmän uusin versio\n    2. Asenna käyttöjärjestelmän uusin versio ja yritä uudelleen
	HigherTermail                   = 1. Avaa Terminal tai PowerShell ISE järjestelmänvalvojana, \n       Aseta PowerShell suorituskäytäntö: Ohitus, PS komentorivi: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Kun se on ratkaistu, suorita komento uudelleen.
	HigherTermailAdmin              = 1. Avaa Terminal tai PowerShell ISE järjestelmänvalvojana. \n     2. Kun se on ratkaistu, suorita komento uudelleen.
	LowAndCurrentError              = Vähimmäisversio: {0}, nykyinen versio: {1}
	Check_Eligible                  = Tukikelpoinen
	Check_Version_PSM_Error         = Versiovirhe, katso {0}.psm1.Esimerkki, päivitä {0}.psm1 uudelleen ja yritä uudelleen.

	Check_OSEnv                     = Järjestelmäympäristön tarkistus
	Check_Image_Bad                 = Tarkista, onko ladattu kuva vioittunut
	Check_Need_Fix                  = Rikkoutuneet esineet, jotka on korjattava
	Image_Mount_Mode                = Asennustila
	Image_Mount_Status              = Kiinnityksen tila
	Check_Compatibility             = Yhteensopivuuden tarkistus
	Check_Duplicate_rule            = Tarkista päällekkäiset sääntömerkinnät
	Duplicates                      = Toistaa
	ISO_File                        = ISO tiedosto
	ISO_Langpack                    = ISO kielipaketti
'@