ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	Prerequisites                   = 先決條件
	Check_PSVersion                 = 檢查 PS 版本 5.1 以上
	Check_OSVersion                 = 檢查 Windows 版本 > 10.0.16299.0
	Check_Higher_elevated           = 檢查必須提升至更高權限
	Check_execution_strategy        = 檢查執行策略

	Check_Pass                      = 透過
	Check_Did_not_pass              = 沒有通過
	Check_Pass_Done                 = 恭喜，通過了。
	How_solve                       = 如何解決
	UpdatePSVersion                 = 請安裝最新的 PowerShell 版本
	UpdateOSVersion                 = 1. 前往微軟官方網站下載最新版本的作業系統\n    2. 安裝最新版本的作業系統並重試
	HigherTermail                   = 1. 以管理員身分開啟“終端”或“PowerShell ISE”，\n       設定 PowerShell 執行策略：繞過，PS命令列：\n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. 解決後，重新運行命令。
	HigherTermailAdmin              = 1. 以管理員身分開啟“終端”或“PowerShell ISE”。\n    2. 解決後，重新運行命令。
	LowAndCurrentError              = 最低版本：{0}，目前版本：{1}
	Check_Eligible                  = 符合條件
	Check_Version_PSM_Error         = 版本錯誤，請參考 {0}.psm1.Example，重新升級 {0}.psm1 後重試。

	Check_OSEnv                     = 系統環境檢查
	Check_Image_Bad                 = 檢查已載入的圖像是否損壞
	Check_Need_Fix                  = 需要修復的損壞項
	Image_Mount_Mode                = 掛載模式
	Image_Mount_Status              = 掛載狀態
	Check_Compatibility             = 相容性檢查
	Check_Duplicate_rule            = 檢查重複的規則條目
	Duplicates                      = 重複
	ISO_File                        = ISO 檔案
	ISO_Langpack                    = ISO 語言封包
'@