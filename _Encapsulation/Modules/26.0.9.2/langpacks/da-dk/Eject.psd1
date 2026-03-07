ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	Save                            = Spare
	DoNotSave                       = Gem ikke
	DoNotSaveTips                   = Kan ikke gendannes, afinstaller billedet direkte.
	UnmountAndSave                  = Afinstaller derefter
	UnmountNotAssignMain            = Når {0} ikke er tildelt
	UnmountNotAssignMain_Tips       = Under batchbehandling skal du angive, om de ikke tildelte hovedelementer skal gemmes eller ej.
	ImageEjectTips                  = Advare\n\n    1. Før du gemmer, anbefales det, at du "Kontroller helbredsstatus", når "Repairable" eller "Unrepairable" vises:\n       * Under ESD konverteringsprocessen vises fejl 13, og dataene er ugyldige;\n       * Der opstod en fejl under installation af systemet.\n\n    2. Tjek sundhedsstatus, boot.wim er ikke understøttet.\n\n    3. Når der er en fil i billedet monteret, og der ikke er angivet nogen afinstallationshandling i billedet, vil den blive gemt som standard.\n\n    4. Når du gemmer, kan du tildele udvidelsesbegivenheder;\n\n    5. Hændelsen efter pop up vil kun blive udført, hvis den ikke er gemt.
	ImageEjectSpecification         = Der opstod en fejl under afinstallation af {0}. Afinstaller udvidelsen, og prøv igen.
	ImageEjectExpand                = Administrer filer i billedet
	ImageEjectExpandTips            = Antydning\n\n    Kontroller sundhedsstatus Udvidelsen understøttes muligvis ikke.
	Image_Eject_Force               = Tillad at offlinebilleder afinstalleres
	ImageEjectDone                  = Efter at have fuldført alle opgaver

	Abandon_Allow                   = Tillad hurtig bortskaffelse
	Abandon_Allow_Auto              = Tillad automatisk aktivering af hurtig bortskaffelse
	Abandon_Allow_Auto_Tips         = Efter at have aktiveret denne indstilling, vises indstillingen "Tillad hurtig bortskaffelse" i "Autopilot, Brugerdefineret tildeling af kendte hændelser, Pop op-vinduer". Denne funktion understøttes kun i: Hovedopgaver.
	Abandon_Agreement               = Hurtig bortskaffelse: Aftale
	Abandon_Agreement_Disk_range    = Diskpartitioner, der har accepteret hurtig bortskaffelse
	Abandon_Agreement_Allow         = Jeg accepterer brugen af ​hurtig bortskaffelse og er ikke længere ansvarlig for konsekvenserne af formatering af diskpartitioner
	Abandon_Terms                   = Vilkår
	Abandon_Terms_Change            = Vilkår er ændret
	Abandon_Allow_Format            = Tillad formatering
	Abandon_Allow_UnFormat          = Uautoriseret formatering af partitioner
	Abandon_Allow_Time_Range        = Tilladelse af udførelse af PowerShell-funktioner træder i kraft når som helst
'@