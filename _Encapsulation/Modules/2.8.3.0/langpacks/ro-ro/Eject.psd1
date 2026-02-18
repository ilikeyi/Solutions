ConvertFrom-StringData -StringData @'
	# ro-RO
	# Romanian (Romania)

	Save                            = Salva
	DoNotSave                       = Nu salva
	DoNotSaveTips                   = Nerecuperabil, dezinstalează imaginea direct.
	UnmountAndSave                  = Apoi dezinstalează
	UnmountNotAssignMain            = Când {0} nu este alocat
	UnmountNotAssignMain_Tips       = În timpul procesării în lot, trebuie să specificați dacă să salvați sau nu elementele principale nealocate.
	ImageEjectTips                  = Avertisment\n\n    1. Înainte de a salva, se recomandă să "Verificați starea de sănătate" dacă apare "Reparabil" sau "Nereparabil":\n       * În timpul procesului de conversie ESD, eroarea 13 este afișată și datele sunt invalide;\n       * A apărut o eroare la instalarea sistemului.\n\n    2. Verificați starea de sănătate, boot.wim nu este acceptat.\n\n    3. Când există un fișier în imagine montat și nu este specificată nicio acțiune de dezinstalare în imagine, acesta va fi salvat în mod implicit.\n\n    4. Când salvați, puteți atribui evenimente de extensie;\n\n    5. Evenimentul de după pop-up va fi executat numai dacă nu este salvat.
	ImageEjectSpecification         = A apărut o eroare la dezinstalarea {0}. Dezinstalați extensia și încercați din nou.
	ImageEjectExpand                = Gestionați fișierele din imagine
	ImageEjectExpandTips            = Sfat\n\n    Verificați starea de sănătate Este posibil ca extensia să nu fie acceptată. Puteți încerca să o verificați.
	Image_Eject_Force               = Permiteți dezinstalarea imaginilor offline
	ImageEjectDone                  = După finalizarea tuturor sarcinilor

	Abandon_Allow                   = Permite eliminarea rapidă
	Abandon_Allow_Auto              = Permite activarea automată a eliminării rapide
	Abandon_Allow_Auto_Tips         = După activarea acestei opțiuni, opțiunea "Permite eliminarea rapidă” va apărea în "Autopilot, Atribuire personalizată a evenimentelor cunoscute, Ferestre pop-up”. Această funcție este acceptată numai în: Sarcini principale.
	Abandon_Agreement               = Eliminare rapidă: Acord
	Abandon_Agreement_Disk_range    = Partiții de disc care au acceptat eliminarea rapidă
	Abandon_Agreement_Allow         = Accept utilizarea eliminării rapide și nu voi mai fi responsabil pentru consecințele formatării partițiilor de disc
	Abandon_Terms                   = Termeni
	Abandon_Terms_Change            = Termenii s-au modificat
	Abandon_Allow_Format            = Permite formatarea
	Abandon_Allow_UnFormat          = Formatarea neautorizată a partițiilor
	Abandon_Allow_Time_Range        = Permiterea executării funcțiilor PowerShell va intra în vigoare oricând
'@