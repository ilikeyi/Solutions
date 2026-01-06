ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	ChkUpdate                 = 檢查更新
	UpdateServerSelect        = 自動選擇服務器或自定義選擇
	UpdateServerNoSelect      = 請選擇可用的服務器
	UpdateSilent              = 有可用更新時，靜默更新
	UpdateClean               = 允許空閒時清理舊版本
	UpdateReset               = 重置此解決方案
	UpdateResetTips           = 下載地址可用時，強制下載並自動更新。
	UpdateCheckServerStatus   = 檢查服務器狀態 ( 共 {0} 個可選 )
	UpdateServerAddress       = 服務器地址
	UpdatePriority            = 已設置為優先級
	UpdateServerTestFailed    = 未通過服務器狀態測試
	UpdateQueryingUpdate      = 正在查詢更新中...
	UpdateQueryingTime        = 正檢查是否有最新版本可用，連接耗時 {0} 毫秒。
	UpdateConnectFailed       = 無法連接到遠程服務器，檢查更新已中止。
	UpdateMinimumVersion      = 滿足最低更新程序版本要求，最低要求版本：{0}
	UpdateVerifyAvailable     = 驗證地址是否可用
	Download                  = 下載
	UpdateDownloadAddress     = 下載地址
	UpdateAvailable           = 可用
	UpdateUnavailable         = 不可用
	UpdateCurrent             = 當前使用版本
	UpdateLatest              = 可用最新版本
	UpdateNewLatest           = 發現新的可用版本！
	UpdateSkipUpdateCheck     = 預配置策略，不允許首次運行自動更新。
	UpdateTimeUsed            = 所用的時間
	UpdatePostProc            = 後期處理
	UpdateNotExecuted         = 不執行
	UpdateNoPost              = 未找到後期處理任務
	UpdateUnpacking           = 正在解壓
	UpdateDone                = 已成功更新！
	UpdateDoneRefresh         = 更新完成後，執行函數處理。
	UpdateUpdateStop          = 下載更新時發生錯誤，更新過程中止。
	UpdateInstall             = 您要安裝此更新嗎？
	UpdateInstallSel          = 是，將安裝上述更新\n否，則不會安裝該更新
	UpdateNoUpdateAvailable   = \n  沒有可用的更新。 \n\n  您正在運行 {0}'s Solutions 的是最新版。\n
	UpdateNotSatisfied        = \n  不滿足最低更新程序版本要求，\n\n  最低要求版本：{0}\n\n  請重新下載 {1}'s Solutions 的副本，以更新此工具。 \n\n  檢查更新已中止。 \n

	SearchOrder               = 搜尋順序
	SearchOrderTips           = 搜尋順序\n  滿足 12 項後，關閉繼續搜索，不滿足則繼續搜索。\n\n\n1. 索引號\n   搜尋 [ 新增來源 ]\\Custom\\[ 符合目前已掛載的索引號 ]，符合到添加，關閉搜尋；\n\n2. 映像標誌\n   搜尋 [ 新增來源 ]\\Custom\\[ 取得目前掛載映像標誌 ]，配對到添加，關閉搜尋；\n\n3. 其它\n   未滿足 12 項，預設新增來源所有檔案（排除來源裡的 Custom 目錄）。
'@