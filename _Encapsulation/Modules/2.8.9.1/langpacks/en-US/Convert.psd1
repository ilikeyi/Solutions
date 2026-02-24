ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	Convert_Only                    = Interconversion
	Conver_Merged                   = Merged
	Conver_Split_To_Swm             = Split
	Conver_Split_rule               = Split {0} to {1}
	ConvertToArchive                = Convert all packages to zip
	ConvertOpen                     = Conversion is enabled, disable this option.
	ConvertBackup                   = Create a backup before conversion
	ConvertBackupTips               = Randomly generate backup and create file information
	ConvertSplit                    = Split size
	ConvertSplitTips                = Note\n\n    1. Do not split boot.wim or convert boot.wim to esd format;\n\n    2. For splitting into SWM format, it is only recommended to split the original format as install.wim;\n\n    3. after forcibly splitting install.esd into install*.swm format, the following error will be reported when using the Windows installer to install the system:\n\n    Windows Unable to install required files. Files may be damaged or lost. Make sure that all files required for the installation are available and restart the installation. Error code: 0x80070570
	ConvertSWM                      = Merge install*.swm
	ConvertSWMTips                  = Remove all *.swm after converting to install.wim.
	ConvertImageSwitch              = Convert {0} to {1}
	ConvertImageNot                 = {0} is no longer converted to {1}
	Converting                      = Converting {0} to {1}
	CompressionType                 = Compression Type
	CompressionType_None            = No compression
	CompressionType_Fast            = Fast
	CompressionType_Max             = Maximum
'@