ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	ChkUpdate                 = Se efter opdateringer
	UpdateServerSelect        = Automatisk servervalg eller brugerdefineret valg
	UpdateServerNoSelect      = Vælg venligst en tilgængelig server
	UpdateSilent              = Opdater lydløst, når opdateringer er tilgængelige
	UpdateClean               = Tillad rengøring af gamle versioner i ro og mag
	UpdateReset               = Nulstil denne løsning
	UpdateResetTips           = Når downloadadressen er tilgængelig, tvinges overførslen og opdateres automatisk.
	UpdateCheckServerStatus   = Tjek serverstatus ( {0} tilgængelige muligheder )
	UpdateServerAddress       = Serveradresse
	UpdatePriority            = Allerede sat som prioritet
	UpdateServerTestFailed    = Mislykket serverstatustest
	UpdateQueryingUpdate      = Forespørger efter opdateringer...
	UpdateQueryingTime        = Ved at tjekke, om den nyeste version er tilgængelig, tog forbindelsen {0} millisekunder.
	UpdateConnectFailed       = Kan ikke oprette forbindelse til fjernserveren, søger efter opdateringer afbrudt.
	UpdateREConnect           = Forbindelsen mislykkedes, prøver igen for {0}/{1} gang.
	UpdateMinimumVersion      = Opfylder minimumskrav til opdateringsversion, minimum påkrævet version: {0}
	UpdateVerifyAvailable     = Bekræft, at adressen er tilgængelig
	Download                  = Downloade
	UpdateDownloadAddress     = Hent adresse
	UpdateAvailable           = Tilgængelig
	UpdateUnavailable         = Ikke tilgængelig
	UpdateCurrent             = Bruger i øjeblikket version
	UpdateLatest              = Seneste version tilgængelig
	UpdateNewLatest           = Opdag nye tilgængelige versioner!
	UpdateSkipUpdateCheck     = Forudkonfigureret politik for ikke at tillade automatiske opdateringer at køre for første gang.
	UpdateTimeUsed            = Brugt tid
	UpdatePostProc            = Efterbehandling
	UpdateNotExecuted         = Ikke henrettet
	UpdateNoPost              = Efterbehandlingsopgave blev ikke fundet
	UpdateUnpacking           = Udpakker
	UpdateDone                = Opdateret med succes!
	UpdateDoneRefresh         = Efter opdateringen er fuldført, udføres funktionsbehandling.
	UpdateUpdateStop          = Der opstod en fejl under download af opdateringen, og opdateringsprocessen blev afbrudt.
	UpdateInstall             = Vil du installere denne opdatering?
	UpdateInstallSel          = Ja, ovenstående opdatering vil blive installeret\nNej, opdateringen vil ikke blive installeret
	UpdateNotSatisfied        = \n  Minimumskravene til opdateringsprogramversion er ikke opfyldt, \n\n  Minimum påkrævet version: {0}\n\n  Download venligst igen.\n\n  Søgning efter opdateringer er blevet afbrudt.\n

	IsAllowSHA256Check        = Tillad SHA256 hash-verifikation
	GetSHAFailed              = Kunne ikke hente hash til sammenligning med downloadet fil.
	Verify_Done               = Verifikation vellykket.
	Verify_Failed             = Verifikation mislykkedes, hash-uoverensstemmelse.

	Auto_Update_Allow         = Tillad automatiske baggrundsopdateringstjek
	Auto_Update_New_Allow     = Tillad automatiske opdateringer, når der registreres nye opdateringer.
	Auto_Check_Time           = Timer, interval mellem automatiske tjek
	Auto_Last_Check_Time      = Sidste automatiske opdateringstjektidspunkt
	Auto_Next_Check_Time      = Ikke mere end {0} timer, næste tjektidspunkt
	Auto_First_Check          = Ingen opdateringstjek udført, den første opdateringstjek udføres
	Auto_Update_Last_status   = Sidste opdateringsstatus
	Auto_Update_IsLatest      = Det er allerede den nyeste version.

	SearchOrder               = Søgerækkefølge
	SearchOrderTips           = Søgerækkefølge\n  Hvis [ 1.  2. ] betingelser er opfyldt, stopper søgningen; ellers fortsætter den.\n\n\n1. Indeksnummer\n   Søg efter [ Tilføj kilde ]\\Brugerdefineret\\[ Matcher det aktuelt monterede indeksnummer ]. Hvis der findes et match, skal du tilføje filen og stoppe søgningen.\n\n2. Billedflag\n   Søg efter [ Tilføj kilde ]\\Brugerdefineret\\[ Hent det aktuelt monterede billedflag ]. Hvis der findes et match, skal du tilføje filen og stoppe søgningen.\n\n3. Andet\n   Hvis ingen af ​de 12 betingelser er opfyldt, tilføjes alle filer fra kilden som standard ( eksklusive mappen Brugerdefineret i kilden ).
'@