﻿ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	UnpackISO                       = 生成 ISO
	ISOLabel                        = 已经设置卷标：
	ISOCustomize                    = ISO 卷标名
	ISO9660                         = 验证命名规则
	ISO9660Tips                     = 唯一命名不能超过 260 字符、ISO 卷标名不能超过 16 字符，不能包含：前后空格、\\ / : * ? & @ ! "" < > |
	ISOFolderName                   = 自定义唯一命名
	ISOAddFlagsLang                 = 添加多语言标记
	ISOAddFlagsLangGet              = 获取已知安装语言
	ISOAddFlagsVer                  = 添加多版本标记
	ISOAddFlagsVerGet               = 获取已知映像版本
	ISOAddEICFG                     = 添加版本类型
	ISOAddEICFGTips                 = 依赖 EI.cfg 时，属于商业版。
	ISO9660TipsErrorSpace           = 不能包含：前后空格
	ISO9660TipsErrorOther           = 不能包含：\\ / : * ? & @ ! "" < > |
	SelOSver                        = 选择语言类型
	SelLabel                        = 代号
	ISOVerLabel                     = 选择 ISO 卷标名
	NoSetLabel                      = 自定义 ISO 卷标未设置
	ISOLengthError                  = 卷标长度不能大于 {0} 字符
	RenameFailed                    = 与旧目录相同，重命名失败
	ISOCreateAfter                  = 创建 ISO 前需要做些什么
	ISOCreateRear                   = 创建 ISO 后需要做些什么
	BypassTPM                       = 绕过 TPM 安装检查
	Disable_BitLocker               = 安装期间禁止 BitLocker 设备加密
	PublicDate                      = 发行日期
	PublicDateGetCurrent            = 同步当前日期
	PublicYear                      = 年
	PublicMonth                     = 月
	ISOCreateFailed                 = 创建失败，目录不可读写。
	ISORefreshAuto                  = 每次刷新 ISO 标签
	ISOSaveTo                       = ISO 默认保存位置
	ISOSaveSameGlobal               = 使用全局 ISO 默认保存位置
	ISOSaveSync                     = 选择映像源搜索盘后自动同步新位置
	ISOSaveSame                     = 使用映像源搜索盘路径
	ISOFolderWrite                  = 验证目录是否可读写
	SelectAutoAvailable             = 自动选择可用磁盘时
	SelectCheckAvailable            = 检查最低可用剩余空间
	ISOStructure                    = 新的目录结构
	ISOOSLevel                      = 添加安装类型
	ISOUniqueNameDirectory          = 添加唯一名称目录
	NextDoOperate                   = 不创建 ISO
	SelCreateISO                    = 生成 ISO，按需执行
	Reconstruction                  = 以最高压缩重建 {0}.wim
	Reconstruction_Tips_Select      = 重建前，仅在未载时执行，将强制开启保存，再卸载已挂载。
	ReconstructionTips              = 超过 520 MB，建议重建
	EmptyDirectory                  = 删除 映像源主目录
	CreateASC                       = 给 ISO 添加 PGP 签名
	CreateASCPwd                    = 证书密码
	CreateASCAuthor                 = 签署者
	CreateASCAuthorTips             = 未选择签署者。
	CreateSHA256                    = 给 ISO 生成 .SHA-256
	GenerateRandom                  = 生成随机数
	RandomNumberReset               = 重新生成
'@