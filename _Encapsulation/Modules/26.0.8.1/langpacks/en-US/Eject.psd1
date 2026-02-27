ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	Save                            = Save
	DoNotSave                       = Do not save
	DoNotSaveTips                   = Unrecoverable, unmount the image directly.
	UnmountAndSave                  = Then uninstall
	UnmountNotAssignMain            = When not assigned {0}
	UnmountNotAssignMain_Tips       = When batch processing, you need to specify whether or not the unassigned major items are saved and not saved.
	ImageEjectTips                  = Warning\n\n    1. Before saving, it is recommended that you perform "Check Health Status". When "Repairable" or "Unrepairable" appears:\n       * During the conversion of ESD, error 13 is prompted, the data is invalid;\n       * Error when installing the system.\n\n    2. Check the health status, boot.wim is not supported.\n\n    3. When there is an image file mounted, if the unmount action in the image is not specified, it will be saved by default.\n\n    4. When saving, extension items can be assigned;\n\n    5. The event after the pop-up will only be executed when it is not saved.
	ImageEjectSpecification         = An error occurred while uninstalling {0}, please uninstall the extension and try again.
	ImageEjectExpand                = Manage files within an image
	ImageEjectExpandTips            = Prompt\n\n    Check the health status, you may not support extended items, you can try to check after you enable it.
	Image_Eject_Force               = Allow uninstallation of offline images
	ImageEjectDone                  = After completing all the tasks

	Abandon_Allow                   = Allow quick discard method
	Abandon_Allow_Auto              = Allow automatic activation of quick discard method
	Abandon_Allow_Auto_Tips         = After enabling "Automatic driving, custom assignment of known events, pop-up," the "Allow quick discard method" option will be displayed. This function is only supported for: main quests.
	Abandon_Agreement               = Quick discard method: Protocol
	Abandon_Agreement_Disk_range    = Disk partitions that have accepted quick discard
	Abandon_Agreement_Allow         = I accept the use of the quick discard function and will no longer bear the consequences of formatting the disk partition
	Abandon_Terms                   = Terms and Conditions
	Abandon_Terms_Change            = Terms and conditions have changed
	Abandon_Allow_Format            = Allow formatting
	Abandon_Allow_UnFormat          = Unauthorized formatted partitions
	Abandon_Allow_Time_Range        = Allowing the execution of PowerShell functions will take effect at any time
'@