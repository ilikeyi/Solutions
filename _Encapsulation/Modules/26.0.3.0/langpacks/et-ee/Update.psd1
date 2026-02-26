ConvertFrom-StringData -StringData @'
	# et-ee
	# Estonian (Estonia)

	ChkUpdate                 = Kontrollige värskendusi
	UpdateServerSelect        = Automaatne serveri valik või kohandatud valik
	UpdateServerNoSelect      = Valige saadaolev server
	UpdateSilent              = Värskendage vaikselt, kui värskendused on saadaval
	UpdateClean               = Lubage vabal ajal vanu versioone puhastada
	UpdateReset               = Lähtestage see lahendus
	UpdateResetTips           = Kui allalaadimisaadress on saadaval, siis allalaadimine sunnitakse ja seda värskendatakse automaatselt.
	UpdateCheckServerStatus   = Kontrolli serveri olekut ( saadaval on {0} valikut )
	UpdateServerAddress       = Serveri aadress
	UpdatePriority            = Juba seatud prioriteediks
	UpdateServerTestFailed    = Serveri oleku test ebaõnnestus
	UpdateQueryingUpdate      = Värskenduste päring...
	UpdateQueryingTime        = Kontrollimaks, kas uusim versioon on saadaval, võttis ühendus aega {0} millisekundit.
	UpdateConnectFailed       = Kaugserveriga ei saa ühendust luua, värskenduste otsimine katkestati.
	UpdateREConnect           = Ühenduse loomine ebaõnnestus, proovin uuesti {0}/{1} korda.
	UpdateMinimumVersion      = Vastab värskendaja versiooni miinimumnõuetele, minimaalne nõutav versioon: {0}
	UpdateVerifyAvailable     = Kontrollige aadressi olemasolu
	Download                  = Allalaadimise
	UpdateDownloadAddress     = Allalaadimise aadress
	UpdateAvailable           = Saadaval
	UpdateUnavailable         = Ei ole saadaval
	UpdateCurrent             = Hetkel kasutusel versioon
	UpdateLatest              = Saadaval on uusim versioon
	UpdateNewLatest           = Avastage uusi saadaolevaid versioone!
	UpdateSkipUpdateCheck     = Eelkonfigureeritud reegel, mis ei luba automaatseid värskendusi esimest korda käivitada.
	UpdateTimeUsed            = Kulutatud aeg
	UpdatePostProc            = Järeltöötlus
	UpdateNotExecuted         = Ei hukatud
	UpdateNoPost              = Järeltöötlusülesannet ei leitud
	UpdateUnpacking           = Lahtipakkimine
	UpdateDone                = Värskendamine õnnestus!
	UpdateDoneRefresh         = Pärast värskendamise lõpetamist teostatakse funktsioonide töötlemine.
	UpdateUpdateStop          = Värskenduse allalaadimisel ilmnes viga ja värskendusprotsess katkestati.
	UpdateInstall             = Kas soovite selle värskenduse installida?
	UpdateInstallSel          = Jah, ülaltoodud värskendus installitakse\nEi, värskendust ei installita
	UpdateNotSatisfied        = \n  Värskendusprogrammi versiooni miinimumnõuded ei ole täidetud, \n\n  Minimaalne nõutav versioon: {0}\n\n  Palun laadige uuesti alla.\n\n  Värskenduste otsimine on katkestatud.\n

	IsAllowSHA256Check        = Luba SHA256 räsi kontrollimine
	GetSHAFailed              = Räsi hankimine allalaaditud failiga võrdlemiseks ebaõnnestus.
	Verify_Done               = Kontrollimine õnnestus.
	Verify_Failed             = Kontrollimine ebaõnnestus, räsi mittevastavus.

	Auto_Update_Allow         = Luba automaatsed taustavärskenduste kontrollid
	Auto_Update_New_Allow     = Uute värskenduste tuvastamisel luba automaatsed värskendused.
	Auto_Check_Time           = Tunnid, automaatsete kontrollide vaheline intervall
	Auto_Last_Check_Time      = Viimase automaatse värskenduste kontrolli aeg
	Auto_Next_Check_Time      = Mitte rohkem kui {0} tundi, järgmise kontrolli aeg
	Auto_First_Check          = Värskenduste kontrolli ei teostatud, teostatakse esimene värskenduste kontroll
	Auto_Update_Last_status   = Viimase värskenduse olek
	Auto_Update_IsLatest      = See on juba kõige uuem versioon.

	SearchOrder               = Otsingujärjekord
	SearchOrderTips           = Otsingujärjekord\n  Kui [ 1.  2. ] tingimust on täidetud, otsing peatub; vastasel juhul jätkub.\n\n\n1. Indeksinumber\n   Otsi [ Lisa allikas ]\\Kohandatud\\[ Vastav hetkel paigaldatud indeksinumbrile ]. Kui leitakse vaste, lisage fail ja peatage otsing.\n\n2. Pildi lipp\n   Otsi [ Lisa allikas ]\\Kohandatud\\[ Hangi hetkel paigaldatud pildi lipp ]. Kui leitakse vaste, lisage fail ja peatage otsing.\n\n3. Muu\n   Kui ükski 12 tingimusest pole täidetud, lisatakse vaikimisi kõik allika failid ( välja arvatud allika kohandatud kaust ).
'@