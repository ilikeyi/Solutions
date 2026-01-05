ConvertFrom-StringData -StringData @'
	# da-dk
	# Danish (Denmark)

	SaveModeClear                   = Ryd valgt historik
	SaveModeTipsClear               = Historien er blevet gemt og kan ryddes
	SelectTips                      = Antydning\n\n    1. Vælg venligst navnet på det billede, der skal behandles;\n    2. Efter du har annulleret, vil opgaver, der kræver "montering" før betjening, ikke længere træde i kraft.
	CacheDisk                       = Disk cache
	CacheDiskCustomize              = Tilpasset cachesti
	AutoSelectRAMDISK               = Tillad automatisk valg af diskvolumenetiketter
	AutoSelectRAMDISKFailed         = Volumenetiketten matcher ikke
	ReFS_Find_Volume                = Når diskformatet REFS stødes på, skal du ekskludere
	ReFS_Exclude                    = ReFS partition udelukket
	Disk_Not_satisfied_Exclude      = Minimumskrav til disk ikke opfyldt
	RAMDISK_Change                  = Skift navn på volumetiket
	RAMDISK_Search                  = Søg efter volumennavn
	RAMDISK_Restore                 = Gendan initialiseret volumennavn: {0}
	AllowTopMost                    = Tillad, at åbne vinduer fastgøres til toppen
	History                         = Klar historie
	History_Del_Tips                = Når der er en indkapslingsopgave, skal du ikke udføre følgende valgfrie muligheder, ellers vil det forårsage ukendte problemer under kørsel af indkapslingsscriptet.
	History_View                    = Se historik
	HistoryLog                      = Tillad automatisk rensning af træstammer ældre end 7 dage
	HistorySaveFolder               = Andre billedkildestier
	HistoryClearappxStage           = InBox Apps: Slet midlertidige filer genereret under installationen
	DoNotCheckBoot                  = Når størrelsen af Boot.wim filen overstiger 520 MB, vælges genopbygning automatisk, når ISO'en genereres.
	HistoryClearDismSave            = Slet DISM mount records gemt i registreringsdatabasen
	ImageSourcesClickShowKey        = Tillad visning af menuen "Vælg primær nøgle"
	ImageSourcesClickShowKeyTips    = Når brugeren har valgt billedkilden: Tilføj en menu "Vælg primær nøgle" til højre, og tilføj "Gå til" muligheder: Monter, Gem, Pop op.
	Clear_Bad_Mount                 = Slet alle ressourcer forbundet med det beskadigede monterede billede
	ShowCommand                     = Vis hele kommandolinjekørslen
	Command                         = Kommandolinje
	SelectSettingImage              = Billedkilde
	NoSelectImageSource             = Der er ikke valgt nogen billedkilde
	SettingImageRestore             = Gendan standard monteringsplacering
	SettingImage                    = Skift billedkildens monteringsplacering
	SelectImageMountStatus          = Få monteringsstatus efter valg af billedkilde
	SettingImageTempFolder          = Midlertidig mappe
	SettingImageToTemp              = Den midlertidige mappe er den samme som den placering, hvor den blev monteret
	SettingImagePathTemp            = Brug af Temp biblioteket
	SettingImageLow                 = Kontroller den mindste ledige plads
	SettingImageNewPath             = Vælg monteringsdisk
	SettingImageNewPathTips         = Det anbefales, at du monterer den på en hukommelsesdisk, som er den hurtigste. Du kan bruge virtuel hukommelsessoftware som Ultra RAMDisk og ImDisk.
	SelectImageSource               = "Deploy Engine Solution" er blevet valgt, klik på OK.
	NoImagePreSource                = Ingen tilgængelig kilde fundet, du skal: \n\n     1. Tilføj flere billedkilder til: \n          {0}\n\n     2. Vælg "Indstillinger", og vælg billedkildesøgningsdisken igen;\n\n     3. Vælg "ISO" og vælg den ISO, der skal dekomprimeres, emner, der skal monteres osv.
	NoImageOtherSource              = Klik på mig for at "Tilføj" andre stier eller "Træk mappe" til det aktuelle vindue.
	SearchImageSource               = Billedkildesøgningsdisk
	Kernel                          = Kernel
	Architecture                    = Arkitektur
	ArchitecturePack                = Pakkearkitektur, forståelse af tilføjelse af regler
	ImageLevel                      = Installationstype
	LevelDesktop                    = Skrivebord
	LevelServer                     = Server
	ImageCodename                   = Kodenavn
	ImageCodenameNo                 = Ikke genkendt
	MainImageFolder                 = Hjemmekatalog
	MountImageTo                    = Montere til
	Image_Path                      = Billedsti
	MountedIndex                    = Indeks
	MountedIndexSelect              = Vælg indeksnummer
	AutoSelectIndexFailed           = Automatisk valg af indeks {0} mislykkedes. Prøv venligst igen.
	Apply                           = Anvendelse
	Eject                           = Poppe op
	Mount                           = Montere
	Unmount                         = Afinstallere
	Mounted                         = Monteret
	NotMounted                      = Ikke monteret
	NotMountedSpecify               = Ikke monteret, kan du angive monteringsstedet
	MountedIndexError               = Unormal montering, slet og prøv igen.
	ImageSouresNoSelect             = Vis flere detaljer efter valg af billedkilde
	Mounted_Mode                    = Monteringstilstand
	Mounted_Status                  = Monteringsstatus
	Image_Popup_Default             = Gem som standard
	Image_Restore_Default           = Vend tilbage til standard
	Image_Popup_Tips                = Antydning: \n\nDa du tildelte hændelsen, specificerede du ikke det indeksnummer, der skulle behandles {0};\n\nUdvælgelsesgrænsefladen er i øjeblikket dukket op. Angiv venligst indeksnummeret. Når specifikationen er fuldført, anbefales det at du vælger "Gem som standard".
	Rule_Show_Full                  = Vis alle
	Rule_Show_Only                  = Vis kun regler
	Rule_Show_Only_Select           = Vælg mellem regler
	Image_Unmount_After             = Afinstaller alt monteret

	Wim_Rule_Update                 = Udpak og opdater filer i billedet
	Wim_Rule_Extract                = Udpak filer
	Wim_Rule_Extract_Tips           = Når du har valgt stireglen, skal du udpakke den angivne fil og gemme den lokalt.

	Wim_Rule_Verify                 = Verificere
	Wim_Rule_Check                  = Undersøge
	Wim_Rule_CheckIntegrity         = Kontroller integritet
	Wim_Rule_WIMBoot                = Startbar
	Wim_Rule_Compact                = Komprimer operativsystemfiler
	Win_Rule_Setbootable            = Marker diskenhedsbillede som startbart
	Win_Rule_Setbootable_Tips       = Denne parameter gælder kun for Windows PE billeder.\nKun ét diskenhedsbillede kan markeres som startbart i en .wim fil.
	Destination                     = Bestemmelsessted

	Wim_Append                      = Tilføj
	Wim_Capture                     = Hent
	Wim_Capture_Tips                = Hent drevbilledet til en ny WIM fil.
	Wim_Capture_Sources             = Hentningskilde
	Wim_Capture_Sources_Tips        = Den hentede mappe indeholder alle undermapper og data.\nDu kan ikke hente en tom mappe. Mappen skal indeholde mindst én fil.
	Wim_Config_File                 = Konfigurationsfilsti ( undtagelser )
	Wim_Config_Edit                 = Rediger
	Wim_Config_Learn                = Undersøg konfigurationslisten og WimScript.ini filen

	Wim_Rename                      = Rediger billedoplysninger
	Wim_Image_Name                  = Billednavn
	Wim_Image_Description           = Billedbeskrivelse
	Wim_Display_Name                = Visningsnavn
	Wim_Display_Description         = Vis beskrivelse
	Wim_Edition                     = Billedmærke
	Wim_Edition_Select_Know         = Vælg kendte billedflag
	Wim_CreatedTime                 = Oprettelsesdato
	Wim_ModifiedTime                = Sidst ændret
	Wim_FileCount                   = Antal filer
	Wim_DirectoryCount              = Antal mapper
	Wim_Expander_Space              = Udvidelsesrum

	IABSelectNo                     = Ingen primær nøgle valgt: Installer, WinRE, Boot
	Unique_Name                     = Unik navngivning
	Select_Path                     = Sti
	Setting_Pri_Key                 = Indstil denne opdateringsfil som hovedskabelon
	Pri_Key_Update_To               = Opdater derefter til
	Pri_Key_Template                = Indstil denne fil som den foretrukne skabelon, der skal synkroniseres til de valgte elementer
	Pri_key_Running                 = Den primære nøgleopgave er blevet synkroniseret og er blevet sprunget over.
	ShowAllExclude                  = Vis alle forældede ekskluderinger

	Index_Process_All               = Behandl alle kendte indeksnumre
	Index_Is_Event_Select           = Når der er en hændelse, dukker grænsefladen til valg af indeksnummer op.
	Index_Pre_Select                = Forudtildelt indeksnummer
	Index_Select_Tips               = Antydning: \n\n{0}.wim er ikke monteret i øjeblikket, du kan: \n\n   1. Vælg "Behandle alle kendte indeksnumre";\n\n   2. Vælg "Når der er en begivenhed, vil grænsefladen til valg af indeksnummer poppe op";\n\n   3. Forudspecificeret indeksnummer\n Indeksnummer 6 er angivet Indeksnummeret eksisterer ikke under behandlingen, og behandlingen springes over.

	Index_Tips_Custom_Expand        = Gruppe: {0}\n\nVed behandling af {1} skal {2} indeksnummeret tildeles, ellers kan det ikke behandles.\n\nEfter at have valgt "Synkroniser opdateringsregler til alle indeksnumre", behøver du kun at markere en som hovedskabelon.

	DefenderExclude                 = Windows Antivirus udelukkelser
	DefenderFolder                  = Tilføj denne mappe til Windows Antivirus udelukkelser.
	DefenderVolume                  = Når du har fundet et matchende volumennavn, skal du tilføje denne disk til Windows Antivirus udelukkelser.
	DefenderIsAdd                   = Føjet til Windows Antivirus udelukkelser
'@