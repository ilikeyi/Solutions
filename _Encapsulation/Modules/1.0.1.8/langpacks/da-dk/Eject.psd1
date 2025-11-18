ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	Save                            = Spare
	DoNotSave                       = Gem ikke
	DoNotSaveTips                   = Kan ikke gendannes, afinstaller billedet direkte.
	UnmountAndSave                  = Efter at have gemt og afmonteret billedet
	UnmountNotAssignMain            = Når {0} ikke er tildelt
	UnmountNotAssignMain_Tips       = Under batchbehandling skal du angive, om de ikke-tildelte hovedelementer skal gemmes eller ej.
	ImageEjectTips                  = Advare\n\n    1. Før du gemmer, anbefales det, at du "Kontroller helbredsstatus", når "Repairable" eller "Unrepairable" vises:\n       * Under ESD-konverteringsprocessen vises fejl 13, og dataene er ugyldige;\n       * Der opstod en fejl under installation af systemet.\n\n    2. Tjek sundhedsstatus, boot.wim er ikke understøttet.\n\n    3. Når der er en fil i billedet monteret, og der ikke er angivet nogen afinstallationshandling i billedet, vil den blive gemt som standard.\n\n    4. Når du gemmer, kan du tildele udvidelsesbegivenheder;\n\n    5. Hændelsen efter pop-up vil kun blive udført, hvis den ikke er gemt.
	ImageEjectSpecification         = Der opstod en fejl under afinstallation af {0}. Afinstaller udvidelsen, og prøv igen.
	ImageEjectExpand                = Administrer filer i billedet
	ImageEjectExpandTips            = Antydning\n\n    Kontroller sundhedsstatus Udvidelsen understøttes muligvis ikke.
	Image_Eject_Force               = Tillad at offlinebilleder afinstalleres
	ImageEjectDone                  = Efter at have fuldført alle opgaver
'@