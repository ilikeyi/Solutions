ConvertFrom-StringData -StringData @'
	# nb-NO
	# Norwegian, Bokmål (Norway)

	Save                            = Spare
	DoNotSave                       = Ikke spar
	DoNotSaveTips                   = Kan ikke gjenopprettes, avinstaller bildet direkte.
	UnmountAndSave                  = Avinstaller deretter
	UnmountNotAssignMain            = Når {0} ikke er tildelt
	UnmountNotAssignMain_Tips       = Under batchbehandling må du spesifisere om de ikke-tilordnede hovedelementene skal lagres eller ikke.
	ImageEjectTips                  = Varsle\n\n    1. Før du lagrer, anbefales det at du "Sjekker helsestatus" når "Reparerbar" eller "Ureparerbar" vises:\n       * Under ESD-konverteringsprosessen vises feil 13 og dataene er ugyldige;\n       * Det oppstod en feil under installasjonen av systemet.\n\n    2. Sjekk helsestatus, boot.wim støttes ikke.\n\n    3. Når det er en fil i bildet montert og ingen avinstalleringshandling er spesifisert i bildet, vil den bli lagret som standard.\n\n    4. Når du lagrer, kan utvidelseshendelsen tildeles;\n\n 5. Popup-hendelsen vil kun utføres når den ikke er lagret.
	ImageEjectSpecification         = Det oppstod en feil under avinstallering av {0}. Avinstaller utvidelsen og prøv igjen.
	ImageEjectExpand                = Administrer filer i bildet
	ImageEjectExpandTips            = Tips\n\n    Sjekk helsestatusen Det kan hende at utvidelsen ikke støttes. Du kan prøve å sjekke etter at du har aktivert den.
	Image_Eject_Force               = Tillat å avinstallere bilder uten nett
	ImageEjectDone                  = Etter å ha fullført alle oppgaver

	Abandon_Allow                   = Tillat rask avhending
	Abandon_Allow_Auto              = Tillat at rask avhending aktiveres automatisk
	Abandon_Allow_Auto_Tips         = Etter at dette alternativet er aktivert, vises alternativet "Tillat rask avhending" i "Autopilot, Tilpasset tildeling av kjente hendelser, Popup-vinduer". Denne funksjonen støttes bare i: Hovedoppgaver.
	Abandon_Agreement               = Rask avhending: Avtale
	Abandon_Agreement_Disk_range    = Diskpartisjoner som har godtatt rask avhending
	Abandon_Agreement_Allow         = Jeg godtar bruken av rask avhending og vil ikke lenger være ansvarlig for konsekvensene av formatering av diskpartisjoner
	Abandon_Terms                   = Vilkår
	Abandon_Terms_Change            = Vilkårene er endret
	Abandon_Allow_Format            = Tillat formatering
	Abandon_Allow_UnFormat          = Uautorisert formatering av partisjoner
	Abandon_Allow_Time_Range        = Tillatelse av kjøring av PowerShell-funksjoner vil tre i kraft når som helst
'@