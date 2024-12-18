ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	SaveModeClear                   = 清除已選擇的歷史記錄
	SaveModeTipsClear               = 已保存歷史記錄，可清理
	SelectTips                      = 提示\n\n    1、請選擇需要處理的映像名稱；\n    2、您取消後，需要“掛載”後才操作的任務，將不再生效。
	CacheDisk                       = 磁盤緩存
	CacheDiskCustomize              = 自定義緩存路徑
	AutoSelectRAMDISK               = 允許自動選擇磁盤捲標
	AutoSelectRAMDISKFailed         = 未符合到標籤：{0}
	ReFS_Find_Volume                = 遇到磁碟格式 REFS 時，排除
	ReFS_Exclude                    = 已排除 ReFS 分割區
	RAMDISK_Change                  = 更改標籤名
	RAMDISK_Restore                 = 恢復初始化標籤名稱：{0}
	AllowTopMost                    = 允許打開的窗口後置頂
	History                         = 清除歷史記錄
	History_Del_Tips                = 有封裝任務時，請勿執行下列可選項，否則會導致封裝腳本在執行過程中出現未知問題。
	History_View                    = 查看歷史記錄
	HistoryLog                      = 允許自動清理超過 7 天的日誌
	HistorySaveFolder               = 其它映像源路徑
	HistoryClearappxStage           = InBox Apps: 刪除安裝時產生的臨時文件
	DoNotCheckBoot                  = Boot.wim 文件大小超過 520MB 後，選擇重建
	HistoryClearDismSave            = 刪除保存在註冊表裡的 DISM 掛載記錄
	Clear_Bad_Mount                 = 刪除與已損壞的已裝載映像關聯的所有資源
	ShowCommand                     = 顯示運行的完整命令行
	Command                         = 命令行
	SelectSettingImage              = 映像源
	NoSelectImageSource             = 未選擇映像源
	SettingImageRestore             = 恢復默認掛載位置
	SettingImage                    = 更改映像源掛載位置
	SelectImageMountStatus          = 選擇映像源後獲取掛載狀態
	SettingImageTempFolder          = 臨時目錄
	SettingImageToTemp              = 臨時目錄與掛載到位置相同
	SettingImagePathTemp            = 使用 Temp 目錄
	SettingImageLow                 = 檢查最低可用剩餘空間
	SettingImageNewPath             = 選擇掛載磁盤
	SettingImageNewPathTips         = 推薦你掛載到內存磁盤，這樣速度最快，可使用：Ultra RAMDisk, ImDisk 等虛擬內存軟件。
	SelectImageSource               = 已選擇“部署引擎解決方案”，可點確定。
	NoImagePreSource                = 未發現有可用的來源，你應該：\n\n     1. 將更多的映射源新增到：\n          {0}\n\n     2. 選擇「設置」，重新選擇映射源搜索盤;\n\n     3. 選擇“ISO”，選擇待解壓縮的 ISO、待掛載項等。
	NoImageOtherSource              = 點我“添加”其他路徑或“拖動目錄”到當前窗口。
	SearchImageSource               = 映像源搜索盤
	Kernel                          = 內核
	Architecture                    = 體系結構
	ArchitecturePack                = 軟件包架構，了解添加規則
	ImageLevel                      = 安裝類型
	LevelDesktop                    = 桌面
	LevelServer                     = 服務器
	ImageCodename                   = 代號
	ImageCodenameNo                 = 未識別 
	MainImageFolder                 = 主目錄
	MountImageTo                    = 掛載到
	Image_Path                      = 映像路徑
	MountedIndex                    = 索引
	MountedIndexSelect              = 選擇索引号
	AutoSelectIndexFailed           = 自動選擇索引 {0} 失敗，重選後再試。
	Apply                           = 應用影像
	Eject                           = 彈出
	Mount                           = 掛載
	Unmount                         = 卸載
	Mounted                         = 已掛載
	NotMounted                      = 未掛載
	NotMountedSpecify               = 未掛載，可指定掛載位置
	MountedIndexError               = 非正常掛載，刪除後重試。
	ImageSouresNoSelect             = 選擇映像源後顯示更多詳細信息
	Mounted_Mode                    = 掛載模式
	Mounted_Status                  = 掛載狀態
	Image_Popup_Default             = 保存為默認
	Image_Restore_Default           = 恢復為默認
	Image_Popup_Tips                = 提示：\n\n你在分配事件時，未指定需要處理 {0} 的索引號；\n\n當前已彈出選擇界面，請指定索引號，指定完成後建議你選擇“保存為默認”，下次處理時將不再彈出。
	Rule_Show_Full                  = 顯示全部
	Rule_Show_Only                  = 僅顯示規則裡的
	Rule_Show_Only_Select           = 從規則裡選擇
	Image_Unmount_After             = 強行卸載所有已掛載映像

	Wim_Rule_Update                 = 提取、更新映像內的文件
	Wim_Rule_Extract                = 提取文件
	Wim_Rule_Extract_Tips           = 選擇路徑規則後，提取指定的文件，並保存到本地。

	Wim_Rule_Verify                 = 驗證
	Wim_Rule_Check                  = 檢查
	Destination                     = 目的地

	Wim_Rename                      = 修改映像信息
	Wim_Image_Name                  = 映像名稱
	Wim_Image_Description           = 映像說明
	Wim_Display_Name                = 顯示名稱
	Wim_Display_Description         = 顯示說明
	Wim_Edition                     = 映像標誌
	Wim_Edition_Select_Know         = 選擇已知映像標誌
	Wim_Created                     = 創建日期
	Wim_Expander_Space              = 展開空間

	IABSelectNo                     = 未選擇主鍵：Install、WinRE、Boot
	Unique_Name                     = 唯一命名
	Select_Path                     = 路徑
	Setting_Pri_Key                 = 將此更新檔案設定為主範本：
	Pri_Key_Update_To               = 然後更新到：
	Pri_Key_Template                = 設置此文件為首選模板，待同步到所選項
	Pri_key_Running                 = 主鍵任務已同步完成，已跳過。
	ShowAllExclude                  = 顯示所有不建議排除項

	Index_Process_All               = 處理全部已知索引號
	Index_Is_Event_Select           = 有事件時，彈出選擇界面
	Index_Pre_Select                = 預指定索引號
	Index_Select_Tips               = 提示：\n\n當前未掛載 {0}.wim，你可以：\n\n   1、選擇“處理全部已知索引號”；\n\n   2、選擇“有事件時，彈出選擇索引號界面”；\n\n   3、預指定索引號\n      指定了索引號 6，處理時索引號不存在，跳過處理。
'@