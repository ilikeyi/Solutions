ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	AssignSkip                      = 不再处理映像源
	Function_Limited                = 部分受限的
	AssignNeedMount                 = 有新的挂载映像时
	AssignNoMount                   = 没有挂载映像时
	AssignSetting                   = 管理感知事件
	AssignEndCurrent                = 仅结束分配 ( {0} ) 事件
	AssignEndNoMount                = 结束无挂载时事件
	AssignForceEnd                  = 结束全部分配事件
	SuggestedAllow                  = 触发时，使用感知建议
	SuggestedSkip                   = 不再感知此项
	SuggestedReset                  = 重置所有感知的建议
	SuggestedNext                   = 同步为全局感到建议

	EventManagerMul                 = 多任务事件
	EventManager                    = 事件
	EventManagerCount               = 项
	EventManagerNo                  = 无事件
	EventManagerClear               = 清除所有事件
	EventManagerCurrentClear        = 清除已保存的任务
	AfterFinishingNotExecuted       = 有可用任务或事件时
	AfterFinishCleanupTemp          = 允许清理 Temp 临时文件
	AfterFinishingNoProcess         = 不处理
	AfterFinishingPause             = 暂停
	AfterFinishingReboot            = 重启计算机
	AfterFinishingShutdown          = 关闭计算机

	Event_Primary_Key               = 首选主键
	Event_Primary_Key_CPK           = 清除已选主键
	Sel_Primary_Key                 = 选择主键
	Event_Group                     = 群组
	Event_Assign_Main               = 可分配的主要项
	Event_Assign_Expand             = 可分配的扩展项
	Event_Process_All               = 处理所有已知任务
	Event_Allow_Update_Rule         = 允许更新规则
	Event_Allow_Update_Rule_Tips    = 完成 {0}.wim 处理后，清除相关任务，继续等待处理 {1}.wim 完成后，以更新相同文件；\n\n按每索引处理 {2}.wim 会增加文件大小，只有更新相同文件即可减少 {3}.wim 的文件大小。
	Event_Allow_Update_Rule_Only    = 仅处理部分，用户已选择的映像
	Event_Allow_Update_To_All       = 更新规则同步到所有索引号
	Event_Allow_Update_To_All_Tips  = 完成处理 {0}.wim 后，获取 {1}.wim 里的所有索引号，并更新至全部。\n\n创建模板后，只有弹出 {2} 时才会触发此任务，未卸载前，可在“保存、卸载映像”里管理。
	Pri_Key_Setting                 = 仅设置为首选
	Pri_Key_Setting_Not             = 不可设置为首选

	Wimlib_New                      = 有新的弹出后事件，{0} 项
	Wimlib_New_Tips                 = 没有弹出后的事件

	WaitTimeTitle                   = 什么时候开始
	WaitTimeTips                    = 提示\n\n    1、请选择需要等待的时间；\n\n    2、取消，队列中有任务将立即执行。
	WaitQueue                       = 正在等待队列
	AddSources                      = 添加来源
	AddQueue                        = 添加队列
	YesWork                         = 队列中有任务
	NoWork                          = 无任务
	TimeExecute                     = 立即执行
	Time_Sky                        = 天
	Time_Hour                       = 小时
	Time_Minute                     = 分钟
	TimeWait                        = 等待时间: \
	NowTime                         = 当前时间: \
	TimeStart                       = 开始时间: \
	TimeEnd                         = 完成时间: \
	TimeEndAll                      = 已用时间: \
	TimeEndAllseconds               = 已用毫秒: \
	TimeSeconds                     = 秒
	TimeMillisecond                 = 毫秒
	TimeMsg                         = 请耐心等待...
'@