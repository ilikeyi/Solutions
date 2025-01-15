ConvertFrom-StringData -StringData @'
	# sv-SE
	# Swedish (Sweden)

	Save                            = Spara
	DoNotSave                       = Spara inte
	DoNotSaveTips                   = Det går inte att återställa, avinstallera bilden direkt.
	UnmountAndSave                  = Efter att ha sparat och avmonterat bilden
	UnmountNotAssignMain            = När {0} inte tilldelas
	UnmountNotAssignMain_Tips       = Under batchbearbetning måste du ange om de otilldelade huvudartiklarna ska sparas eller inte.
	ImageEjectTips                  = Varna\n\n    1. Innan du sparar, rekommenderas det att du "Kontrollera hälsostatus" när "Repairable" eller "Inrepairable" visas: \n       * Under ESD konverteringsprocessen visas fel 13 och data är ogiltigt;\n       * Ett fel uppstod vid installation av systemet.\n\n    2. Kontrollera hälsostatus, boot.wim stöds inte.\n\n    3. När det finns en fil i bilden monterad och ingen avinstallationsåtgärd anges i bilden, sparas den som standard.\n\n    4. När du sparar kan du tilldela förlängningshändelser;\n\n    5. Händelsen efter popup kommer endast att köras om den inte sparas.
	ImageEjectSpecification         = Ett fel uppstod när {0} avinstallerades. Avinstallera tillägget och försök igen.
	ImageEjectExpand                = Hantera filer i bilden
	ImageEjectExpandTips            = Tips\n\n    Kontrollera hälsostatus Tillägget kanske inte stöds.
	Image_Eject_Force               = Tillåt att offlinebilder avinstalleras
	ImageEjectDone                  = Efter att ha slutfört alla uppgifter
'@