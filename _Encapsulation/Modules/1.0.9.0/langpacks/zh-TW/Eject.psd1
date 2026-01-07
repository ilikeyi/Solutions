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
'@