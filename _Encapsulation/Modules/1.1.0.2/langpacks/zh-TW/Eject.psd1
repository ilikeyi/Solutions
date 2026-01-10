ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	Save                            = 保存
	DoNotSave                       = 不保存
	DoNotSaveTips                   = 不可恢復，直接卸載映像。
	UnmountAndSave                  = 後卸載
	UnmountNotAssignMain            = 未分配 {0} 时
	UnmountNotAssignMain_Tips       = 批量處理時，未分配主要項是否保存、不保存時，需指定。
	ImageEjectTips                  = 警告\n\n    1. 保存前，建議您進行“檢查健康狀態”，出現“可修復”、“不可修復”時：\n       * 轉換 ESD 過程中，提示錯誤 13，數據無效；\n       * 安裝系統時報錯。\n\n    2. 檢查健康狀態，不支持 boot.wim。\n\n    3、有映射內檔掛載時，未指定映射內卸載動作時，自動按預設置處理。\n\n    4、保存時，可分配擴展項事件。\n\n    5、不保存時才會執行彈出后的事件。
	ImageEjectSpecification         = 卸載 {0} 時出錯，請先卸載擴充功能後再試。
	ImageEjectExpand                = 管理映像內的檔
	ImageEjectExpandTips            = 提示\n\n    檢查健康狀態，有可能不支援擴展項，開啟后可嘗試檢查。
	Image_Eject_Force               = 允許卸載離機映像
	ImageEjectDone                  = 完成所有任務後

	Abandon_Allow                   = 允許使用快速拋棄方式
	Abandon_Allow_Auto              = 允許自動開啟快速拋棄方式
	Abandon_Allow_Auto_Tips         = 允許後「自動駕駛、自訂分配已知事件、彈出」將會顯示「允許使用快速拋棄方式」選擇項，該功能僅支援：主線任務。
	Abandon_Agreement               = 快速拋棄方式：協議
	Abandon_Agreement_Disk_range    = 已接受快速拋棄的磁碟分割區
	Abandon_Agreement_Allow         = 我接受使用快速拋棄功能，不再承擔格式化磁碟分割的後果
	Abandon_Terms                   = 條款
	Abandon_Terms_Change            = 條款有新的變化
	Abandon_Allow_Format            = 允許格式化
	Abandon_Allow_UnFormat          = 未經授權格式化的分割區
	Abandon_Allow_Time_Range        = 允許執行 PowerShell 函數將在任意時間內生效
'@