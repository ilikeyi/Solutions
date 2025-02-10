ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	Prerequisites                   = 先决条件
	Check_PSVersion                 = 检查 PS 版本 5.1 及以上
	Check_OSVersion                 = 检查 Windows 版本 > 10.0.16299.0
	Check_Higher_elevated           = 检查必须提升至更高权限
	Check_execution_strategy        = 检查执行策略

	Check_Pass                      = 通过
	Check_Did_not_pass              = 没有通过
	Check_Pass_Done                 = 恭喜，通过了。
	How_solve                       = 如何解决
	UpdatePSVersion                 = 请安装最新的 PowerShell 版本
	UpdateOSVersion                 = 1. 前往微软官方网站下载最新版本的操作系统\n    2. 安装最新版本的操作系统并重试
	HigherTermail                   = 1. 以管理员身份打开“终端”或“PowerShell ISE”，\n       设置 PowerShell 执行策略：绕过，PS命令行：\n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. 解决后，重新运行命令。
	HigherTermailAdmin              = 1. 以管理员身份打开“终端”或“PowerShell ISE”。\n     2. 解决后，重新运行命令。
	LowAndCurrentError              = 最低版本：{0}，当前版本：{1}
	Check_Eligible                  = 符合条件
	Check_Version_PSM_Error         = 版本错误，请参考 {0}.psm1.Example，重新升级 {0}.psm1 后重试。

	Check_OSEnv                     = 系统环境检查
	Check_Image_Bad                 = 检查加载的图像是否损坏
	Check_Need_Fix                  = 需要修复的损坏项
	Image_Mount_Mode                = 挂载模式
	Image_Mount_Status              = 挂载状态
	Check_Compatibility             = 兼容性检查
	Check_Duplicate_rule            = 检查重复的规则条目
	Duplicates                      = 重复
	ISO_File                        = ISO 文件
	ISO_Langpack                    = ISO 语言包
'@