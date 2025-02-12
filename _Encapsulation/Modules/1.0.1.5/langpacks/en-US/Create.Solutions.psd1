﻿ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	IsCreate                        = Create
	Solution                        = Solutions
	EnabledSoftwarePacker           = Collection
	EnabledUnattend                 = Answer in advance
	EnabledEnglish                  = Deployment engine
	UnattendSelectVer               = Select the 'pre-answered' solution language
	UnattendLangPack                = Select the 'solution' language pack
	UnattendSelectSingleInstl       = Multi language, optional during installation
	UnattendSelectMulti             = Multi-language
	UnattendSelectDisk              = Choose Autounattend.xml solution
	UnattendSelectSemi              = Semi-automatic is valid for all installation methods.
	UnattendSelectUefi              = UEFI automatic installation, need to be specified
	UnattendSelectLegacy            = Legacy automatic installation, need to be specified
	NeedSpecified                   = Please select what needs to be specified:
	OOBESetupOS                     = Installation interface
	OOBEProductKey                  = Product key
	OOBEOSImage                     = Choose the operating system to install
	OOBEEula                        = Accept license terms
	OOBEDoNotServerManager          = Do not automatically start Server Manager at login
	OOBEIE                          = Internet Explorer Enhanced Security Configuration
	OOBEIEAdmin                     = Close "Administrator"
	OObeIEUser                      = Close "User"

	OOBE_Init_User                  = The initial user during the unboxing experience
	OOBE_init_Create                = Create custom users
	OOBE_init_Specified             = Designated user
	OOBE_Init_Autologin             = Auto login

	InstlMode                       = Installation method
	Business                        = Business
	BusinessTips                    = Depends on EI.cfg, the automatic installation needs to specify the index number.
	Consumer                        = Consumer
	ConsumerTips                    = Does not depend on EI.cfg, the serial number needs to be specified for automatic installation, and the index number needs to be specified when suspending the version selection interface.
	CreateUnattendISO               = [ISO]:\\Autounattend.xml
	CreateUnattendISOSources        = [ISO]:\\sources\\Unattend.xml
	CreateUnattendISOSourcesOEM     = [ISO]:\\sources\\$OEM$\\$$\\Panther\\unattend.xml
	CreateUnattendPanther           = [Mount To]:\\Windows\\Panther\\unattend.xml

	VerifyName                      = Add to the main directory name of the system disk
	VerifyNameUse                   = Verify that the directory name cannot contain
	VerifyNameTips                  = Only allow the combination of English letters and numbers, can not contain: spaces, the length cannot be greater than 260 characters, \\ / : * ?  @ ! "" < > |
	VerifyNumberFailed              = Verification failed, please enter a correct number.
	VerifyNameSync                  = Set the directory name as the main user name
	VerifyNameSyncTips              = No longer use administrator.
	ManualKey                       = Select or manually enter the product key
	ManualKeyTips                   = Enter a valid product key. If the selected area is not available, please go to Microsoft's official check.
	ManualKeyError                  = The product key you entered is invalid.
	KMSLink1                        = KMS client setup keys
	KMSUnlock                       = Display all known KMS serial numbers
	KMSSelect                       = Please select VOL serial number
	KMSKey                          = Serial number
	KMSKeySelect                    = Change product serial number
	ClearOld                        = Clean up old files
	SolutionsSkip                   = Skip creating solution
	SolutionsTo                     = Add 'Solution' to:
	SolutionsToMount                = Mounted or added to the queue
	SolutionsToError                = Some functions have been disabled, if you want to use it forcibly, please click the "Unlock" button.\n\n
	UnlockBoot                      = Unlock
	SolutionsToSources              = Home directory, [ISO]:\\Sources\\$OEM$
	SolutionsScript                 = Select the 'Deployment Engine' version
	SolutionsEngineRegionaUTF8      = Beta: Use Unicode UTF-8 to provide global language support
	SolutionsEngineRegionaUTF8Tips  = After opening it seems, it may cause new problems. not suggested.
	SolutionsEngineRegionaling      = Change to the new locale:
	SolutionsEngineRegionalingTips  = Change the system locale, this setting affects all user accounts on the computer.
	SolutionsEngineRegional         = Change system locale
	SolutionsEngineRegionalTips     = Global default: {0}, change to: {1}
	SolutionsEngineCopyPublic       = Copy the public {0} to the deployment
	SolutionsEngineCopyOpen         = Browse public storage {0} location
	EnglineDoneReboot               = Restart the computer
	SolutionsTipsArm64              = Preferred arm64 download address, select in order: x64, x86.
	SolutionsTipsAMD64              = Preferred x64 download address, and select in order: x86.
	SolutionsTipsX86                = Only select the x86 download address.
	SolutionsReport                 = Generate pre-deployment report
	SolutionsDeployOfficeInstall    = Deploy Microsoft Office installation package
	SolutionsDeployOfficeChange     = Change deployment configuration
	SolutionsDeployOfficePre        = Pre-installed package version
	SolutionsDeployOfficeNoSelect   = The Office preinstallation package is not selected
	SolutionsDeployOfficeVersion    = {0} version
	SolutionsDeployOfficeOnly       = Keep the specified language pack
	SolutionsDeployOfficeSync       = Keep the language, update the deployment configuration synchronously
	SolutionsDeployOfficeSyncTips   = After synchronization, the installation script cannot determine the preferred language.
	DeploySyncMainLanguage          = Synchronization is consistent with the main language
	SolutionsDeployOfficeTo         = Deploy the installation package to
	SolutionsDeployOfficeToPublic   = Public desktop
	DeployPackage                   = Deploy a custom collection package
	DeployPackageSelect             = Choose a pre-collection package
	DeployPackageTo                 = Deploy the pre-collection package to
	DeployPackageToRoot             = System disk:\\Package
	DeployPackageToSolutions        = Solution home directory
	DeployTimeZone                  = Time zone
	DeployTimeZoneChange            = Change time zone
	DeployTimeZoneChangeTips        = Set the default time zone for pre-answer, press the locale.

	Deploy_Tags                     = Deployment Tags
	FirstExpProcess                 = First experience, during the deployment of prerequisites:
	FirstExpProcessTips             = Restart the computer after completing the prerequisites to solve the problem that requires a restart to take effect.
	FirstExpFinish                  = First time experience, after completing prerequisites
	FirstExpSyncMark                = Allows full disk search and synchronization of deployment tags
	FirstExpUpdate                  = Allow automatic updates
	FirstExpDefender                = Add home directory to Defend exclude directory
	FirstExpSyncLabel               = System disk volume label: the same home directory name
	MultipleLanguages               = When encountering multiple languages:
	NetworkLocationWizard           = Network Location Wizard
	PreAppxCleanup                  = Prevent Appx from cleaning up maintenance tasks
	LanguageComponents              = Prevent cleanup of unused feature-on-demand language packs
	PreventCleaningUnusedLP         = Prevent cleaning of unused language packs
	FirstExpContextCustomize        = Add a personalized context menu
	FirstExpContextCustomizeShift   = Hold down the Shift key and click the right button

	FirstExpFinishTips              = After the deployment is complete, there are no important events. It is recommended that you cancel.
	FirstExpFinishPopup             = The main interface of the deployment engine pops up
	FirstExpFinishOnDemand          = Allow the first pre-experience, as planned
	SolutionsEngineRestricted       = Recovery Powershell execution strategy: restricted
	EnglineDoneClearFull            = Delete the entire solution
	EnglineDoneClear                = Delete the deployment engine, keep the others

	Unattend_Auto_Fix_Next          = Auto-fix when pre-requisites are selected next time they are encountered
	Unattend_Auto_Fix               = Auto-repair when prerequisites are not selected
	Unattend_Auto_Fix_Tips          = When the first run command is not selected when adding a deployment engine, it is automatically repaired and selected: Powershell execution strategy: run the deployment engine without any restrictions.
	Unattend_Version_Tips           = You can select Include only, and use the default to support ARM64, x64, x86.
	First_Run_Commmand              = The command that runs when you first deploy
	First_Run_Commmand_Setting      = Select the command to run
	Command_Not_Class               = Filtering is no longer automatically categorized
	Command_WinSetup                = Windows installation
	Command_WinPE                   = Windows PE
	Command_Tips                    = Please assign First Run Applied to: Windows Installation, Windows PE\n\nNote that when you add a deployment engine, you need to check: Powershell Execution Policy: Restricted, Allow running deployment engine scripts when running for the first time.
	Waring_Not_Select_Command       = When adding a deployment engine, the Powershell execution policy was not selected: set no restrictions, allow running deployment engine scripts, please select and try again, or click "Quick Fix Not Selected".
	Quic_Fix_Not_Select_Command     = Quick fix not selected

	PowerShell_Unrestricted         = Powershell Execution Policy: No Limits
	Allow_Running_Deploy_Engine     = Allow running deployment engine scripts
	Bypass_TPM                      = Bypass TPM checks during installation
'@