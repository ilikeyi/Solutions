ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	UnpackISO                       = 生成 ISOx
	ISOLabel                        = 已經設置卷標：
	ISOCustomize                    = ISO 卷標名
	ISO9660                         = 驗證命名規則
	ISO9660Tips                     = 唯一命名不能超过 260 字符、ISO 卷标名不能超过 16 字符，不能包含：前后空格、\\ / : * ? & @ ! "" < > |
	ISOFolderName                   = 自定義唯一命名
	ISOAddFlagsLang                 = 添加多語言標記
	ISOAddFlagsLangGet              = 獲取已知安裝語言
	ISOAddFlagsVer                  = 添加多版本標記
	ISOAddFlagsVerGet               = 獲取已知映像版本
	ISOAddEICFG                     = 添加版本類型
	ISOAddEICFGTips                 = 依賴 EI.cfg 時，屬於商業版。
	ISO9660TipsErrorSpace           = 不能包含：前后空格
	ISO9660TipsErrorOther           = 不能包含：\\ / : * ? & @ ! "" < > |
	SelOSver                        = 选择语言类型
	SelLabel                        = 代號
	ISOVerLabel                     = 選擇 ISO 卷標名
	NoSetLabel                      = 自定義 ISO 卷標未設置
	ISOLengthError                  = 卷標長度不能大於 {0} 字符
	RenameFailed                    = 與舊目錄相同，重新命名失敗
	ISOCreateAfter                  = 創建 ISO 前需要
	ISOCreateRear                   = 創建 ISO 後需要做些什麼
	BypassTPM                       = 繞過 TPM 安裝檢查
	Disable_BitLocker               = 安裝期間禁止 BitLocker 裝置加密
	PublicDate                      = 發行日期
	PublicDateGetCurrent            = 同步當前日期
	PublicYear                      = 年
	PublicMonth                     = 月
	ISOCreateFailed                 = 創建失敗，目錄不可讀寫。
	ISORefreshAuto                  = 每次刷新 ISO 标签
	ISOSaveTo                       = 生成 ISO 保存位置
	ISOSaveSameGlobal               = 使用全局 ISO 默認保存位置
	ISOSaveSync                     = 選擇映像源搜索盤後自動同步新位置
	ISOSaveSame                     = 使用映像源搜索盤路徑
	ISOFolderWrite                  = 驗證目錄是否可讀寫
	SelectAutoAvailable             = 自動選擇可用磁盤時
	SelectCheckAvailable            = 檢查最低可用剩餘空間
	ISOStructure                    = 新的目錄結構
	ISOOSLevel                      = 添加安裝類型
	ISOUniqueNameDirectory          = 添加唯一名稱目錄
	NextDoOperate                   = 不創建 ISO
	SelCreateISO                    = 生成 ISO，按需執行
	Reconstruction                  = 以最高壓縮重建 {0}.wim
	Reconstruction_Tips_Select      = 重建前，僅在未載時執行，將強制開啟保存，再卸載已掛載。
	ReconstructionTips              = 超過 520 建議重建
	EmptyDirectory                  = 刪除 映像源主目錄
	CreateASC                       = 給 ISO 添加 PGP 簽名
	CreateASCPwd                    = 證書密碼
	CreateASCAuthor                 = 簽署者
	CreateASCAuthorTips             = 未選擇簽署者。
	CreateSHA256                    = 給 ISO 生成 .SHA-256
	GenerateRandom                  = 生成隨機數
	RandomNumberReset               = 重新生成
'@