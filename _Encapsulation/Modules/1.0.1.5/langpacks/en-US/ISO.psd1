ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	UnpackISO                       = Generate ISO
	ISOLabel                        = Volume label has been set: \
	ISOCustomize                    = ISO volume label name
	ISO9660                         = Validation naming rules
	ISO9660Tips                     = The unique name cannot exceed 260 characters, the ISO volume label name cannot exceed 16 characters, and cannot contain: leading and trailing spaces, \\ /: *? & @! "" <> |
	ISOFolderName                   = Custom unique naming
	ISOAddFlagsLang                 = Add multilingual markup
	ISOAddFlagsLangGet              = Get the known installation language
	ISOAddFlagsVer                  = Add multi-version mark
	ISOAddFlagsVerGet               = Get known image version
	ISOAddEICFG                     = Add version type
	ISOAddEICFGTips                 = When relying on EI.cfg, it is a commercial version.
	ISO9660TipsErrorSpace           = Cannot contain: spaces
	ISO9660TipsErrorOther           = Cannot contain: \\ / : * ? & @ ! "" < > |
	SelOSver                        = Choose language types
	SelLabel                        = Code
	ISOVerLabel                     = Select ISO volume label name
	NoSetLabel                      = Custom ISO label is not set
	ISOLengthError                  = The label length cannot be greater than {0} characters
	RenameFailed                    = Same as old directory, rename failed
	ISOCreateAfter                  = Needed before creating ISO
	ISOCreateRear                   = What needs to be done after creating the ISO
	BypassTPM                       = Bypass TPM installation check
	Disable_BitLocker               = Disable BitLocker device encryption during installation
	PublicDate                      = Publish Date
	PublicDateGetCurrent            = Sync current date
	PublicYear                      = Year
	PublicMonth                     = Month
	ISOCreateFailed                 = Failed to create, directory is not readable and writable.
	ISORefreshAuto                  = Refresh ISO tags every time
	ISOSaveTo                       = Generate ISO save location
	ISOSaveSameGlobal               = Use global ISO default save location
	ISOSaveSync                     = Automatically sync new location after selecting image source search disk
	ISOSaveSame                     = Search Disk Path Using Image Source
	ISOFolderWrite                  = Verify that the directory is readable and writable
	SelectAutoAvailable             = When auto selecting available disks
	SelectCheckAvailable            = Check for minimum free remaining space
	ISOStructure                    = New directory structure
	ISOOSLevel                      = Add installation type
	ISOUniqueNameDirectory          = Add unique name directory
	NextDoOperate                   = No ISO is created
	SelCreateISO                    = Generate ISO, execute on demand
	Reconstruction                  = Rebuild {0}.wim with the highest compression
	Reconstruction_Tips_Select      = Before rebuilding, it is only executed when it is not mounted, it will be forced to open the save, and then unmount the mounted.
	ReconstructionTips              = Over 520 MB, it is recommended to rebuild
	EmptyDirectory                  = Delete the image source home directory
	CreateASC                       = Add PGP signature to ISO
	CreateASCPwd                    = Certificate password
	CreateASCAuthor                 = Signed by
	CreateASCAuthorTips             = No signers selected.
	CreateSHA256                    = Generate .SHA-256 for ISO
	GenerateRandom                  = Generate random numbers
	RandomNumberReset               = Regenerate
'@