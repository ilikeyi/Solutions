ConvertFrom-StringData -StringData @'
	# sv-SE
	# Swedish (Sweden)

	Convert_Only                    = Överföra
	Conver_Merged                   = Slå ihop
	Conver_Split_To_Swm             = Split
	Conver_Split_rule               = Dela upp {0} i {1}
	ConvertToArchive                = Konvertera alla mjukvarupaket till komprimerade paket
	ConvertOpen                     = Konvertering är aktiverad, inaktivera detta.
	ConvertBackup                   = Skapa en säkerhetskopia före konvertering
	ConvertBackupTips               = Generera slumpmässigt säkerhetskopiering och skapa filinformation
	ConvertSplit                    = Delad storlek
	ConvertSplitTips                = Varsel\n\n    1. Boot.wim kan inte delas eller boot.wim konverteras till esd-format;\n\n    2.Dela upp i SWM format, det rekommenderas endast att dela upp originalformatet till install.wim;\n\n    3. Efter tvångsdelning av install.esd till installation*.swm-format, när du använder Windows-installationsprogrammet för att installera systemet, kommer följande fel att rapporteras:\n\n    Windows kan inte installera de nödvändiga filerna. Filen kan vara skadad eller saknas. Se till att alla filer som krävs för installationen är tillgängliga och starta om installationen. Felkod: 0x80070570
	ConvertSWM                      = Slå samman installation*.swm
	ConvertSWMTips                  = Ta bort alla *.swm efter konvertering till install.wim.
	ConvertImageSwitch              = {0} konverterade till {1}
	ConvertImageNot                 = {0} konverteras inte längre till {1}
	Converting                      = Konverterar {0} till {1}
	CompressionType                 = Kompressionstyp
	CompressionType_None            = Ingen kompression
	CompressionType_Fast            = Snabb
	CompressionType_Max             = Högsta
'@