ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	SaveModeClear                   = Clear selected history
	SaveModeTipsClear               = History has been saved and can be cleaned up
	SelectTips                      = Tips\n\n    1. Please select the image name to be processed;\n    2. After you cancel, the tasks that need to be "mounted" will no longer take effect.
	CacheDisk                       = Disk cache
	CacheDiskCustomize              = Custom cache path
	AutoSelectRAMDISK               = Allow automatic selection of disk labels
	AutoSelectRAMDISKFailed         = Not matched to volume label: {0}
	ReFS_Find_Volume                = When encountering disk format REFS, exclude
	ReFS_Exclude                    = ReFS partitions have been excluded
	RAMDISK_Change                  = Change the volume name
	RAMDISK_Restore                 = Restore initialization volume name: {0}
	AllowTopMost                    = Allow open windows to be on top
	History                         = Clear history
	History_Del_Tips                = Do not execute the following options when there is a wrapping task, otherwise unknown problems may occur during the running of the wrapping script.
	History_View                    = View history
	HistoryLog                      = Allow automatic cleaning of logs older than 7 days
	HistorySaveFolder               = Other Image Source Paths
	HistoryClearappxStage           = InBox Apps: Delete Temporary Files Generated During Installation
	DoNotCheckBoot                  = After the Boot.wim file size exceeds 520MB, choose to rebuild
	HistoryClearDismSave            = Delete the DISM mount record saved in the registry
	Clear_Bad_Mount                 = Delete all resources associated with the corrupted mounted image
	ShowCommand                     = Show the full command line to run
	Command                         = Command Line
	SelectSettingImage              = Image source
	NoSelectImageSource             = No image source selected
	SettingImageRestore             = Restore the default mount location
	SettingImage                    = Change the image source mount location
	SelectImageMountStatus          = Get the mount status after selecting the image source
	SettingImageTempFolder          = Temporary directory
	SettingImageToTemp              = The temporary directory is the same as mounted to the location
	SettingImagePathTemp            = Use Temp directory
	SettingImageLow                 = Check the minimum free remaining space
	SettingImageNewPath             = Select mount disk
	SettingImageNewPathTips         = It is recommended that you mount it to a RAM disk, which is the fastest. You can use: Ultra RAMDisk, ImDisk and other virtual memory software.
	SelectImageSource               = "Deployment Engine Solution" has been selected, click OK.
	NoImagePreSource                = If no sources are found available, you should: \n\n     1. Add more image sources to: \n         {0}\n\n     2. Select "Settings" to reselect the image source search disk;\n\n     3. Select "ISO" and select the ISO to be decompressed, items to be mounted, etc.
	NoImageOtherSource              = Click to "Add" another path or "Drag a directory" to the current window.
	SearchImageSource               = Image source search disk
	Kernel                          = Kernel
	Architecture                    = Architecture
	ArchitecturePack                = Package architecture, understand the rules for adding
	ImageLevel                      = Types
	LevelDesktop                    = Desktop
	LevelServer                     = Server
	ImageCodename                   = Codename
	ImageCodenameNo                 = Unrecognized
	MainImageFolder                 = Main directory
	MountImageTo                    = Mount to
	Image_Path                      = Image path
	MountedIndex                    = Index
	MountedIndexSelect              = Select index number
	AutoSelectIndexFailed           = Automatic selection of index {0} failed, try again after reselection.
	Apply                           = Apply image
	Eject                           = Pop up
	Mount                           = Mount
	Unmount                         = Unmount
	Mounted                         = Mounted
	NotMounted                      = Not mounted
	NotMountedSpecify               = Not mounted, you can specify the mounting location
	MountedIndexError               = Abnormal mount, delete it and try again.
	ImageSouresNoSelect             = Show more details after selecting the image source
	Mounted_Mode                    = Mount mode
	Mounted_Status                  = Mount status
	Image_Popup_Default             = Save as default
	Image_Restore_Default           = Revert to default
	Image_Popup_Tips                = Hint:\n\nWhen you assign the event, you did not specify the index number to process {0};\n\nThe selection interface has now popped up. Please specify the index number. After the specification is complete, it is recommended that you select "Save as default", and it will not pop up next time.
	Rule_Show_Full                  = Show all
	Rule_Show_Only                  = Only those in the rule are displayed
	Rule_Show_Only_Select           = Select from the rules
	Image_Unmount_After             = Unmount all mounted

	Wim_Rule_Update                 = Extract, update files within the image
	Wim_Rule_Extract                = Extracting files
	Wim_Rule_Extract_Tips           = After selecting the path rule, extract the specified file and save it locally.

	Wim_Rule_Verify                 = Verify
	Wim_Rule_Check                  = Check
	Destination                     = Destination

	Wim_Rename                      = Modify image information
	Wim_Image_Name                  = Image name
	Wim_Image_Description           = Image description
	Wim_Display_Name                = Display name
	Wim_Display_Description         = Display description
	Wim_Edition                     = Edition
	Wim_Edition_Select_Know         = Selecting known image flags
	Wim_Created                     = Date created
	Wim_Expander_Space              = Expand space

	IABSelectNo                     = Primary key not selected: Install, WinRE, Boot
	Unique_Name                     = Unique Name
	Select_Path                     = Path
	Setting_Pri_Key                 = Set this update file as the main template: \
	Pri_Key_Update_To               = Then update to: \
	Pri_Key_Template                = Set this file as the preferred template to synchronize to the selected item
	Pri_key_Running                 = Primary key task completed synchronously, skipped.
	ShowAllExclude                  = Displays all deprecated exclusions

	Index_Process_All               = Process all known index numbers
	Index_Is_Event_Select           = When there is an event, the selection interface pops up
	Index_Pre_Select                = Pre-assigned index number
	Index_Select_Tips               = Hint: \n\n{0}.wim is not currently mounted, you can: \n\n   1. Select "Process all known index numbers";\n\n   2. Select "When there is an event, the interface for selecting an index number will pop up";\n\n   3. Pre-specified index number\n      The index number 6 is specified, the index number does not exist during processing, and the processing is skipped.

	Index_Tips_Custom_Expand        = Group: {0}\n\nWhen processing {1}, the {2} index number needs to be assigned, otherwise it cannot be processed.\n\nAfter selecting "Synchronize update rules to all index numbers", you only need to check any one of them as the main template.
'@