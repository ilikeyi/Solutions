ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	SaveModeClear                   = 清除已选择的历史记录
	SaveModeTipsClear               = 已保存历史记录，可清理
	SelectTips                      = 提示\n\n    1、请选择需要处理的映像名称；\n    2、您取消后，需要“挂载”后才操作的任务，将不再生效。
	CacheDisk                       = 磁盘缓存
	CacheDiskCustomize              = 自定义缓存路径
	AutoSelectRAMDISK               = 允许自动选择磁盘卷标
	AutoSelectRAMDISKFailed         = 未匹配到卷标
	ReFS_Find_Volume                = 遇到磁盘格式 REFS 时，排除
	ReFS_Exclude                    = 已排除 ReFS 分区
	Disk_Not_satisfied_Exclude      = 未满足最低磁盘要求
	RAMDISK_Change                  = 更改卷标名
	RAMDISK_Search                  = 搜索卷标名
	RAMDISK_Restore                 = 恢复初始化卷标名：{0}
	AllowTopMost                    = 允许打开的窗口后置顶
	History                         = 清除历史记录
	History_Del_Tips                = 有封装任务时，请勿执行以下可选项，否则会导致封装脚本在运行过程中出现未知问题。
	History_View                    = 查看历史记录
	HistoryLog                      = 允许自动清理超过 7 天的日志
	HistorySaveFolder               = 其它映像源路径
	HistoryClearappxStage           = InBox Apps：删除安装时产生的临时文件
	DoNotCheckBoot                  = Boot.wim 文件大小超过 520MB 后，生成 ISO 时自动勾选重建
	HistoryClearDismSave            = 删除保存在注册表里的 DISM 挂载记录
	ImageSourcesClickShowKey        = 允许显示选择主键菜单
	ImageSourcesClickShowKeyTips    = 用户选择映像来源后：添加右侧“选择主键菜单”、添加“可前往”选项：挂载、保存、弹出
	Clear_Bad_Mount                 = 删除与已损坏的已装载映像关联的所有资源
	ShowCommand                     = 显示运行的完整命令行
	Command                         = 命令行
	SelectSettingImage              = 映像源
	NoSelectImageSource             = 未选择映像源
	SettingImageRestore             = 恢复默认挂载位置
	SettingImage                    = 更改映像源挂载位置
	SelectImageMountStatus          = 选择映像源后获取挂载状态
	SettingImageTempFolder          = 临时目录
	SettingImageToTemp              = 临时目录与挂载到位置相同
	SettingImagePathTemp            = 使用 Temp 目录
	SettingImageLow                 = 检查最低可用剩余空间
	SettingImageNewPath             = 选择挂载磁盘
	SettingImageNewPathTips         = 推荐你挂载到内存磁盘，这样速度最快，可使用：Ultra RAMDisk, ImDisk 等虚拟内存软件。
	SelectImageSource               = 已选择“部署引擎解決方案”，可点确定。
	NoImagePreSource                = 未发现有可用的来源，你应该：\n\n     1. 将更多的映像源添加到：\n          {0}\n\n     2. 选择“设置”，重新选择映像源搜索盘；\n\n     3. 选择“ISO”，选择待解压的 ISO、待挂载项等。
	NoImageOtherSource              = 点我“添加”其它路径或“托动目录”到当前窗口。
	SearchImageSource               = 映像源搜索盘
	Kernel                          = 内核
	Architecture                    = 体系结构
	ArchitecturePack                = 软件包架构，了解添加规则
	ImageLevel                      = 安装类型
	LevelDesktop                    = 桌面
	LevelServer                     = 服务器
	ImageCodename                   = 代号
	ImageCodenameNo                 = 未识别
	MainImageFolder                 = 主目录
	MountImageTo                    = 挂载到
	Image_Path                      = 映像路径
	MountedIndex                    = 索引
	MountedIndexSelect              = 选择索引号
	AutoSelectIndexFailed           = 自动选择索引 {0} 失败，重选后再试。
	Apply                           = 应用
	Eject                           = 弹出
	Mount                           = 挂载
	Unmount                         = 卸载
	Mounted                         = 已挂载
	NotMounted                      = 未挂载
	NotMountedSpecify               = 未挂载，可指定挂载位置
	MountedIndexError               = 非正常挂载，删除后重试。
	ImageSouresNoSelect             = 选择映像源后显示更多详细信息
	Mounted_Mode                    = 挂载模式
	Mounted_Status                  = 挂载状态
	Image_Popup_Default             = 保存为默认
	Image_Restore_Default           = 恢复为默认
	Image_Popup_Tips                = 提示：\n\n你在分配事件时，未指定需要处理 {0} 的索引号；\n\n当前已弹出选择界面，请指定索引号，指定完成后建议你选择“保存为默认”，下次处理时将不再弹出。
	Rule_Show_Full                  = 显示全部
	Rule_Show_Only                  = 仅显示规则里的
	Rule_Show_Only_Select           = 从规则里选择
	Image_Unmount_After             = 卸载所有已挂载

	Wim_Rule_Update                 = 提取、更新映像内的文件
	Wim_Rule_Extract                = 提取文件
	Wim_Rule_Extract_Tips           = 选择路径规则后，提取指定的文件，并保存到本地。

	Wim_Rule_Verify                 = 验证
	Wim_Rule_Check                  = 检查
	Wim_Rule_CheckIntegrity         = 检查完整性
	Wim_Rule_WIMBoot                = 可启动
	Wim_Rule_Compact                = 将操作系统文件压缩
	Win_Rule_Setbootable            = 将卷映像标记为可启动映像
	Win_Rule_Setbootable_Tips       = 此参数仅适用于 Windows PE 映像。\n一个 .wim 文件中只能将一个卷映像标记为可启动。
	Destination                     = 目的地

	Wim_Append                      = 追加
	Wim_Capture                     = 捕获
	Wim_Capture_Tips                = 将驱动器映像捕获到新的 WIM 文件中。
	Wim_Capture_Sources             = 捕获来源
	Wim_Capture_Sources_Tips        = 捕获的目录包含所有子文件夹和数据。\n您不能捕获空目录。目录必须至少包含一个文件。
	Wim_Config_File                 = 配置文件路径（排除项）
	Wim_Config_Edit                 = 编辑
	Wim_Config_Learn                = 学习配置列表和 WimScript.ini 文件

	Wim_Rename                      = 修改映像信息
	Wim_Image_Name                  = 映像名称
	Wim_Image_Description           = 映像说明
	Wim_Display_Name                = 显示名称
	Wim_Display_Description         = 显示说明
	Wim_Edition                     = 映像标志
	Wim_Edition_Select_Know         = 选择已知映像标志
	Wim_CreatedTime                 = 创建日期
	Wim_ModifiedTime                = 上次修改时间
	Wim_FileCount                   = 文件数目
	Wim_DirectoryCount              = 目录数目
	Wim_Expander_Space              = 展开空间

	IABSelectNo                     = 未选择主键：Install、WinRE、Boot
	Unique_Name                     = 唯一命名
	Select_Path                     = 路径
	Setting_Pri_Key                 = 将此更新文件设置为主模板
	Pri_Key_Update_To               = 然后更新到
	Pri_Key_Template                = 设置此文件为首选模板，待同步到所选项
	Pri_key_Running                 = 主键任务已同步完成，已跳过。
	ShowAllExclude                  = 显示所有不建议排除项

	Index_Process_All               = 处理全部已知索引号
	Index_Is_Event_Select           = 有事件时，弹出选择索引号界面
	Index_Pre_Select                = 预指定索引号
	Index_Select_Tips               = 提示：\n\n当前未挂载 {0}.wim，你可以：\n\n   1、选择“处理全部已知索引号”；\n\n   2、选择“有事件时，弹出选择索引号界面”；\n\n   3、预指定索引号\n      指定了索引号 6，处理时索引号不存在，跳过处理。

	Index_Tips_Custom_Expand        = 群组：{0}\n\n处理 {1} 时，需要分配 {2} 索引号，否则无法处理。\n\n选择“更新规则同步到所有索引号”后，仅需勾选任意一条作为主模板即可。

	DefenderExclude                 = Windows 防病毒排除项
	DefenderFolder                  = 将此目录添加到 Windows 防病毒排除项。
	DefenderVolume                  = 搜索到符合的卷标名后，将此磁盘添加 Windows 防病毒排除项。
	DefenderIsAdd                   = 已添加到 Windows 防病毒排除项
'@