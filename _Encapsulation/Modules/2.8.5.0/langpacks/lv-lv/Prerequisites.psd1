ConvertFrom-StringData -StringData @'
	# lv-LV
	# Latvian (Latvia)

	Prerequisites                   = Priekšnoteikumi
	Check_PSVersion                 = Pārbaudiet PS versiju 5.1 un jaunāku versiju
	Check_OSVersion                 = Pārbaudiet Windows versiju > 10.0.16299.0
	Check_Higher_elevated           = Čekam jābūt paaugstinātam, lai iegūtu augstākas privilēģijas
	Check_execution_strategy        = Pārbaudiet izpildes stratēģiju

	Check_Pass                      = Caurlaide
	Check_Did_not_pass              = Neizdevās
	Check_Pass_Done                 = Apsveicu, pagājis.
	How_solve                       = Kā atrisināt
	UpdatePSVersion                 = Lūdzu, instalējiet jaunāko PowerShell versiju
	UpdateOSVersion                 = 1. Dodieties uz Microsoft oficiālo vietni, lai lejupielādētu jaunāko operētājsistēmas versiju\n    2. Instalējiet jaunāko operētājsistēmas versiju un mēģiniet vēlreiz
	HigherTermail                   = 1. Atveriet termināli vai PowerShell ISE kā administratoru, \n       Iestatīt PowerShell izpildes politiku: apiet, PS komandrinda: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Kad tas ir atrisināts, palaidiet komandu vēlreiz.
	HigherTermailAdmin              = 1. Atveriet termināli vai PowerShell ISE kā administratoru. \n    2. Kad tas ir atrisināts, palaidiet komandu vēlreiz.
	LowAndCurrentError              = Minimālā versija: {0}, pašreizējā versija: {1}
	Check_Eligible                  = Piemērots
	Check_Version_PSM_Error         = Versijas kļūda. Lūdzu, skatiet {0}.psm1.Piemērs, atkārtoti jauniniet {0}.psm1 un mēģiniet vēlreiz.

	Check_OSEnv                     = Sistēmas vides pārbaude
	Check_Image_Bad                 = Pārbaudiet, vai ielādētais attēls nav bojāts
	Check_Need_Fix                  = Salauztas lietas, kas jālabo
	Image_Mount_Mode                = Montāžas režīms
	Image_Mount_Status              = Montāžas statuss
	Check_Compatibility             = Saderības pārbaude
	Check_Duplicate_rule            = Pārbaudiet, vai nav dublēti kārtulu ieraksti
	Duplicates                      = Atkārtojiet
	ISO_File                        = ISO fails
	ISO_Langpack                    = ISO valodu pakotne
'@