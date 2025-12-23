ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	AdvAppsDetailed                 = 生成報告
	AdvAppsDetailedTips             = 按區域標記搜索，發現可用的本地語言體驗包后獲取更多詳細資訊，生成一份報告檔：*. CSV。
	ProcessSources                  = 處理來源
	InboxAppsManager                = 收件箱應用
	InboxAppsMatchDel               = 按匹配規則刪除
	InboxAppsOfflineDel             = 刪除預配的應用程式
	InboxAppsClear                  = 強行刪除已安裝的所有預應用程序 ( InBox Apps )
	InBox_Apps_Match                = 匹配 InBox Apps 應用
	InBox_Apps_Check                = 檢查依賴包
	InBox_Apps_Check_Tips           = 根據規則，獲取已選擇的所有安裝項，校驗是否已選擇所依賴的安裝項。
	LocalExperiencePack             = 本地語言體驗包
	LEPBrandNew                     = 以全新方式，推薦
	UWPAutoMissingPacker            = 自動從所有磁盤搜索缺少的軟件包
	UWPAutoMissingPackerSupport     = x64 架構，需要安裝缺少的軟件包。
	UWPAutoMissingPackerNotSupport  = 非 x64 架構，只支持 x64 架構時使用。
	UWPEdition                      = Windows 版本唯一識別碼
	Optimize_Appx_Package           = 優化預配 Appx 包，通過用硬鏈接替換相同的文件
	Optimize_ing                    = 最佳化中
	Remove_Appx_Tips                = 請認真閱讀添加說明。 \n\n第一步：添加本地語言體驗包（LXPs），該步驟必須使用來自該文件裡的安裝包：\n1904*.*.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso；\n\n第二步：解壓或掛載1904*.vb_release_svc _*_InboxApps.iso，根據架構選擇目錄；\n\n第三步：如果微軟官方尚未發行最新本地語言體驗包（LXPs），跳過此步驟；如果有：請參照微軟官方發布的公告：1、對應本地語言體驗包（LXPs）；2、對應累積更新。 \n\n\n說明：\n\n已預安裝的應用程序 ( InBox Apps ) 是單語言，需要重新安裝才會獲得多語言。 \n\n微軟官方最新文檔裡暗示：\n1、您可以选择开发者版本、初始版本制作；\n    开发者版本，例如版本号为：\n    Windows 11 系列\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    初始版本，已知初始版本：\n    Windows 11 系列\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 系列\n    Windows 10 22H2, Build 19045.2006\n\n    重要：\n      a. 每版本更新时，请重新制作镜像，例如从 21H1 跨越到 22H2 时，请勿在旧镜像基础上更新，应避免出现其它兼容性问题；再次提醒您，请使用初始版本制作。\n      b. 该条例已经在某些 OEM 厂商，通过各种形式向封装师明确传达了该法令，不允许直接从迭代版本里直接升级。\n      关键词：迭代、跨版本、累积更新。\n\n2、這樣暗示是對的，在製作多語言時，添加本地語言包後必須添加累積更新；\n\n3、你使用已帶累積更新的版本，到了最後還是得再次添加累積更新，已經重複操作了；\n\n4、為什麼不直接使用初始版不帶累積更新來製作？再最後一步添加累積更新？\n\n\n選擇目錄後搜索條件：LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = 提取完成後彈出已掛載的 ISO，規則：
	ImportCleanDuplicate            = 清理重複檔
	ForceRemovaAllUWP               = 跳過本地語言體驗包 ( LXPs ) 添加，執行其它
	LEPSkipAddEnglish               = 安裝時跳過 en-US 添加，建議
	LEPSkipAddEnglishTips           = 默認英文語言包，再添加就多此一舉。
	License                         = 證書
	IsLicense                       = 有證書
	NoLicense                       = 無證書
	CurrentIsNVeriosn               = N 版系列
	CurrentNoIsNVersion             = 全功能版本
	LXPsWaitAddUpdate               = 待更新
	LXPsWaitAdd                     = 待添加
	LXPsWaitAssign                  = 待分配
	LXPsWaitRemove                  = 待刪除
	LXPsAddDelTipsView              = 有新的提示，現在查看
	LXPsAddDelTipsGlobal            = 不再提示，同步至全域
	LXPsAddDelTips                  = 不再提示
	Instl_Dependency_Package        = 安裝 InBox Apps 應用程式時，允許自動組合依賴套件
	Instl_Dependency_Package_Tips   = 待新增的應用程式有依賴套件時，自動根據規則來進行比對並完成自動組合所需的依賴套件功能。
	Instl_Dependency_Package_Match  = 正在組合依賴套件
	Instl_Dependency_Package_Group  = 組合
	InBoxAppsErrorNoSave            = 遇到錯誤時不允許保存
	InBoxAppsErrorTips              = 有錯誤，匹配中遇到 {0} 項未成功
	InBoxAppsErrorNo                = 匹配中未發現有錯誤
'@