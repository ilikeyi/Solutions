ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	AssignSkip                      = No longer process image sources
	Function_Limited                = Partially restricted
	AssignNeedMount                 = When there is a new mount image
	AssignNoMount                   = When no image is mounted
	AssignSetting                   = Manage perception events
	AssignEndCurrent                = End allocation ( {0} ) events only
	AssignEndNoMount                = End no mount time event
	AssignForceEnd                  = End all assignment events
	SuggestedAllow                  = When triggered, use sense suggestions
	SuggestedSkip                   = No longer perceive this
	SuggestedReset                  = Reset all perception suggestions
	SuggestedNext                   = Synchronization is recommended for the global

	EventManagerMul                 = Multitasking events
	EventManager                    = Events
	EventManagerCount               = Items
	EventManagerNo                  = No event
	EventManagerClear               = Clear all events
	EventManagerCurrentClear        = Clear saved tasks
	AfterFinishingNotExecuted       = When a task or event is available
	AfterFinishingNoProcess         = Not processed
	AfterFinishingPause             = Pause
	AfterFinishingReboot            = Restart computer
	AfterFinishingShutdown          = Turn off the computer

	Event_Primary_Key               = Preferred primary key
	Event_Primary_Key_CPK           = Reset and clear the selected primary key
	Sel_Primary_Key                 = Select Primary Key
	Event_Group                     = Group
	Event_Assign_Main               = Main items that can be assigned
	Event_Assign_Expand             = Assignable extensions
	Event_Process_All               = Process all known tasks
	Event_Allow_Update_Rule         = Allow update rules
	Event_Allow_Update_Rule_Tips    = After completing the processing of {0}.wim, clear related tasks and continue to wait for the completion of processing {1}.wim to update the same file;\n\nprocessing {2}.wim by each index will increase the file size, which can be reduced only by updating the same file The file size of {3}.wim.
	Event_Allow_Update_Rule_Only    = Only the processing part, the image that the user has selected
	Event_Allow_Update_To_All       = Update rules are synced to all index numbers
	Event_Allow_Update_To_All_Tips  = After processing {0}.wim, get all index numbers in {1}.wim and update to all.\n\nAfter the template is created, this task will only be triggered when {2} is displayed. Before uninstalling, it can be managed in "Save and Uninstall Image".
	Pri_Key_Setting                 = Only set as preferred
	Pri_Key_Setting_Not             = Cannot be set as preferred

	Wimlib_New                      = There are new pop-up events after {0} items
	Wimlib_New_Tips                 = There are no events after pop-up

	WaitTimeTitle                   = When does it begin
	WaitTimeTips                    = Tips\n\n    1. Please select the time to wait;\n\n    2. Cancel, the tasks in the queue will be executed immediately.
	WaitQueue                       = Waiting in queue
	AddSources                      = Add source
	AddQueue                        = Add queue
	YesWork                         = There are tasks in the queue
	NoWork                          = No task
	TimeExecute                     = Execute immediately
	Time_Sky                        = Sky
	Time_Hour                       = Hour
	Time_Minute                     = Minute
	TimeWait                        = Waiting time:         \
	NowTime                         = Current time:         \
	TimeStart                       = Start time:           \
	TimeEnd                         = Complete time:        \
	TimeEndAll                      = Elapsed time:         \
	TimeEndAllseconds               = Elapsed milliseconds: \
	TimeSeconds                     = Seconds
	TimeMillisecond                 = Milliseconds
	TimeMsg                         = Please wait patiently...
'@