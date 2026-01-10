ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	Save                            = 保存
	DoNotSave                       = 不保存
	DoNotSaveTips                   = 不可恢复，直接卸载映像。
	UnmountAndSave                  = 后卸载
	UnmountNotAssignMain            = 未分配 {0} 时
	UnmountNotAssignMain_Tips       = 批量处理时，未分配主要项是否保存、不保存时，需指定。
	ImageEjectTips                  = 警告\n\n    1. 保存前，建议您进行“检查健康状态”，出现“可修复”、“不可修复”时：\n       * 转换 ESD 过程中，提示错误 13，数据无效；\n       * 安装系统时报错。\n\n    2. 检查健康状态，不支持 boot.wim。\n\n    3、有映像内文件挂载时，未指定映像内卸载动作时，默认保存。\n\n    4、保存时，可分配扩展项事件；\n\n    5、不保存时才会执行弹出后的事件。
	ImageEjectSpecification         = 卸载 {0} 时出错，请先卸载扩展项后再试。
	ImageEjectExpand                = 管理映像内的文件
	ImageEjectExpandTips            = 提示\n\n    检查健康状态，有可能不支持扩展项，开启后可尝试检查。
	Image_Eject_Force               = 允许卸载脱机映像
	ImageEjectDone                  = 完成所有任务后

	Abandon_Allow                   = 允许使用快速抛弃方式
	Abandon_Allow_Auto              = 允许自动开启快速抛弃方式
	Abandon_Allow_Auto_Tips         = 允许后“自动驾驶、自定义分配已知事件、弹出”将会显示“允许使用快速抛弃方式选择”项，该功能仅支持：主线任务。
	Abandon_Agreement               = 快速抛弃方式：协议
	Abandon_Agreement_Disk_range    = 已接受快速抛弃的磁盘分区
	Abandon_Agreement_Allow         = 我接受使用快速抛弃功能，不再承担格式化磁盘分区的后果
	Abandon_Terms                   = 条款
	Abandon_Terms_Change            = 条款有新的变化
	Abandon_Allow_Format            = 允许格式化
	Abandon_Allow_UnFormat          = 未经授权格式化的分区
	Abandon_Allow_Time_Range        = 允许执行 PowerShell 函数将在任意时间内生效
'@