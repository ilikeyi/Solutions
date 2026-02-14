ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	Convert_Only                    = 互轉
	Conver_Merged                   = 合併
	Conver_Split_To_Swm             = 拆分
	Conver_Split_rule               = 拆分 {0} 到 {1}
	ConvertToArchive                = 轉換所有軟件包為壓縮包
	ConvertOpen                     = 轉換已啟用，禁用此項。
	ConvertBackup                   = 轉換前創建備份
	ConvertBackupTips               = 隨機生成備份和創建文件信息
	ConvertSplit                    = 拆分大小
	ConvertSplitTips                = 注意\n\n    1. 不可拆分 boot.wim 或轉換 boot.wim 為 esd 格式；\n\n   2. 拆分為 SWM 格式，僅建議拆分原格式為 install.wim；\n\n    3. 強行拆分 install.esd 為 install*.swm 格式後，使用 Windows 安裝程序安裝系統時，將會報以下錯誤：\n\n    Windows 無法安裝所需的文件。文件可能損壞或丟失。請確保安裝所需的所有文件可用，並重新啟動安裝。錯誤代碼：0x80070570
	ConvertSWM                      = 合併 install*.swm
	ConvertSWMTips                  = 轉換為 install.wim 後刪除所有 *.swm。
	ConvertImageSwitch              = {0} 轉換成 {1}
	ConvertImageNot                 = 不再將 {0} 轉換為 {1}
	Converting                      = 正在轉換 {0} 到 {1}
	CompressionType                 = 压缩类型
	CompressionType_None            = 不压缩
	CompressionType_Fast            = 快速
	CompressionType_Max             = 最高
'@