ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	Convert_Only                    = 互转
	Conver_Merged                   = 合并
	Conver_Split_To_Swm             = 拆分
	Conver_Split_rule               = 拆分 {0} 到 {1}
	ConvertToArchive                = 转换所有软件包为压缩包
	ConvertOpen                     = 转换已启用，禁用此项。
	ConvertBackup                   = 转换前创建备份
	ConvertBackupTips               = 随机生成备份和创建文件信息
	ConvertSplit                    = 拆分大小
	ConvertSplitTips                = 注意\n\n    1. 不可拆分 boot.wim 或转换 boot.wim 为 esd 格式；\n\n    2. 拆分为 SWM 格式，仅建议拆分原格式为 install.wim；\n\n    3. 强行拆分 install.esd 为 install*.swm 格式后，使用 Windows 安装程序安装系统时，将会报以下错误：\n\n    Windows 无法安装所需的文件。文件可能损坏或丢失。请确保安装所需的所有文件可用，并重新启动安装。错误代码：0x80070570
	ConvertSWM                      = 合并 install*.swm
	ConvertSWMTips                  = 转换为 install.wim 后删除所有 *.swm。
	ConvertImageSwitch              = {0} 转换成 {1}
	ConvertImageNot                 = 不再将 {0} 转换为 {1}
	Converting                      = 正在转换 {0} 到 {1}
	CompressionType                 = 压缩类型
	CompressionType_None            = 不压缩
	CompressionType_Fast            = 快速
	CompressionType_Max             = 最高
'@