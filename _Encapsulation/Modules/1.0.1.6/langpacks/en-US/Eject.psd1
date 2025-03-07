ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	Save                            = Save
	DoNotSave                       = Do not save
	DoNotSaveTips                   = Unrecoverable, unmount the image directly.
	UnmountAndSave                  = After saving and unmounting the image
	UnmountNotAssignMain            = When not assigned {0}
	UnmountNotAssignMain_Tips       = When batch processing, you need to specify whether or not the unassigned major items are saved and not saved.
	ImageEjectTips                  = Warning\n\n    1. Before saving, it is recommended that you perform "Check Health Status". When "Repairable" or "Unrepairable" appears:\n       * During the conversion of ESD, error 13 is prompted, the data is invalid;\n       * Error when installing the system.\n\n    2. Check the health status, boot.wim is not supported.\n\n    3. When there is an image file mounted, if the unmount action in the image is not specified, it will be saved by default.\n\n    4. When saving, extension items can be assigned;\n\n    5. The event after the pop-up will only be executed when it is not saved.
	ImageEjectSpecification         = An error occurred while uninstalling {0}, please uninstall the extension and try again.
	ImageEjectExpand                = Manage files within an image
	ImageEjectExpandTips            = Prompt\n\n    Check the health status, you may not support extended items, you can try to check after you enable it.
	Image_Eject_Force               = Allow uninstallation of offline images
	ImageEjectDone                  = After completing all the tasks
'@