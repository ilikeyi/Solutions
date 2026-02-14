ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	AssignSkip                      = 不再處理映像源
	Function_Limited                = 部分受限的
	AssignNeedMount                 = 有新的掛載映像時
	AssignNoMount                   = 沒有掛載映像時
	AssignSetting                   = 管理感知事件
	AssignEndCurrent                = 僅結束分配 ( {0} ) 事件
	AssignEndNoMount                = 結束無掛載時事件
	AssignForceEnd                  = 結束全部分配事件
	SuggestedAllow                  = 觸發時，使用感知建議
	SuggestedSkip                   = 不再感知此項
	SuggestedReset                  = 重置所有感知的建議
	SuggestedNext                   = 同步為全局感到建議

	EventManagerMul                 = 多任務事件
	EventManager                    = 事件
	EventManagerCount               = 項
	EventManagerNo                  = 無事件
	EventManagerClear               = 清除所有事件
	EventManagerCurrentClear        = 清除已儲存的任務
	AfterFinishingNotExecuted       = 有可用任務或事件時
	AfterFinishCleanupTemp          = 允許清理 Temp 臨時文件
	AfterFinishingNoProcess         = 不处理
	AfterFinishingPause             = 暫停
	AfterFinishingReboot            = 重啟計算機
	AfterFinishingShutdown          = 關閉計算機

	Event_Primary_Key               = 首選主鍵
	Event_Primary_Key_CPK           = 清除已選主鍵
	Sel_Primary_Key                 = 選擇主鍵
	Event_Group                     = 群組
	Event_Assign_Main               = 可分配的主要項
	Event_Assign_Expand             = 可分配的擴展項
	Event_Process_All               = 處理所有已知任務
	Event_Allow_Update_Rule         = 允許更新規則
	Event_Allow_Update_Rule_Tips    = 完成 {0}.wim 處理後，清除相關任務，繼續等待處理 {1}.wim 完成後，以更新相同文件；\n\n按每索引處理 {2}.wim 會增加文件大小，只有更新相同文件即可減少 {3}.wim 的文件大小。
	Event_Allow_Update_Rule_Only    = 僅處理部分，用戶已選擇的映像
	Event_Allow_Update_To_All       = 更新規則同步到所有索引號
	Event_Allow_Update_To_All_Tips  = 完成處理 {0}.wim 後，獲取 {1}.wim 裡的所有索引號，並更新至全部。\n\n創建模板後，只有彈出 {2} 時才會觸發此任務，未卸載前，可在“保存、卸載映像”裡管理。
	Pri_Key_Setting                 = 僅設置為首選
	Pri_Key_Setting_Not             = 不可設置為首選

	Wimlib_New                      = 有新的彈出後事件，{0} 項
	Wimlib_New_Tips                 = 沒有彈出後的事件

	WaitTimeTitle                   = 什麼時候開始
	WaitTimeTips                    = 提示\n\n    1、請選擇需要等待的時間；\n\n    2、取消，隊列中有任務將立即執行。
	WaitQueue                       = 正在等待隊列
	AddSources                      = 添加來源
	AddQueue                        = 添加隊列
	YesWork                         = 隊列中有任務
	NoWork                          = 無任務
	TimeExecute                     = 立即執行
	Time_Sky                        = 天
	Time_Hour                       = 小時
	Time_Minute                     = 分鐘
	TimeWait                        = 等待時間: \
	NowTime                         = 當前時間: \
	TimeStart                       = 開始時間: \
	TimeEnd                         = 完成時間: \
	TimeEndAll                      = 已用時間: \
	TimeEndAllseconds               = 已用毫秒: \
	TimeSeconds                     = 秒
	TimeMillisecond                 = 毫秒
	TimeMsg                         = 請耐心等待...
'@