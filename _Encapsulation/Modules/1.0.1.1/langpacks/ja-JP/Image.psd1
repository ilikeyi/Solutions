ConvertFrom-StringData -StringData @'
	# ja-JP
	# Japanese (Japan)

	SaveModeClear                   = 選択した履歴をクリアする
	SaveModeTipsClear               = 保存された履歴, クリーンアップできます
	SelectTips                      = ヒント\n\n    1, 処理する必要があるイメージ名を選択してください。\n    2, キャンセル後, タスクを操作する前に「マウント」する必要があり, もはや有効になりません。
	CacheDisk                       = ディスクキャッシュ
	CacheDiskCustomize              = カスタムキャッシュパス
	AutoSelectRAMDISK               = ディスクラベルの自動選択を許可する
	AutoSelectRAMDISKFailed         = ボリューム・ラベルに一致しません：{0}
	ReFS_Find_Volume                = ディスクフォーマット REFS が見つかった場合は除外します
	ReFS_Exclude                    = ReFS パーティションが除外されました
	RAMDISK_Change                  = ボリューム ラベル名を変更します
	RAMDISK_Restore                 = 初期化ボリューム・ラベル名のリカバリー: {0}
	AllowTopMost                    = 開いているウィンドウを一番上に移動できるようにします
	History                         = 履歴をクリア
	History_Del_Tips                = パッケージングタスクがある場合, 次のオプションを実行しないでください。そうしないと, 操作中にパッケージングスクリプトが不明な問題を引き起こします。
	History_View                    = 履歴を見る
	HistoryLog                      = 7 日より古いログの自動クリーンアップを許可する
	HistorySaveFolder               = その他の画像ソース パス
	HistoryClearappxStage           = InBox Apps: インストール中に生成された一時ファイルを削除します
	DoNotCheckBoot                  = Boot.wim ファイルサイズが 520MB を超えたら, [再構築]を選択します
	HistoryClearDismSave            = レジストリに保存されている DISM マウントレコードを削除します
	Clear_Bad_Mount                 = 損傷した画像に関連付けられたすべてのリソースを削除します
	ShowCommand                     = 実行する完全なコマンド ラインを表示する
	Command                         = コマンドライン
	SelectSettingImage              = 画像ソース
	NoSelectImageSource             = 画像ソースが選択されていません
	SettingImageRestore             = デフォルトのマウント位置に戻す
	SettingImage                    = イメージソースのマウント場所を変更する
	SelectImageMountStatus          = イメージソースを選択した後, マウントステータスを取得します
	SettingImageTempFolder          = 一時ディレクトリ
	SettingImageToTemp              = 一時ディレクトリは, マウントされた場所と同じです
	SettingImagePathTemp            = Temp ディレクトリの使用
	SettingImageLow                 = 最小空き容量を確認してください
	SettingImageNewPath             = ディスクのマウントを選択します
	SettingImageNewPathTips         = Ultra RAMDisk, ImDisk, およびその他の仮想メモリソフトウェアを使用できる最速のメモリディスクにマウントすることをお勧めします。
	SelectImageSource               = [展開エンジン解決シナリオ] が選択され, ポイントで決定できます。
	NoImagePreSource                = 利用可能なソースは見つかりませんでした：\n\n     1. より多くのイメージ ソースを追加します：\n          {0}\n\n     2. [設定] を選択して, イメージ ソース検索ディスクを再選択します。\n\n     3.「ISO」を選択し, 解凍するISOやマウントする項目などを選択します。
	NoImageOtherSource              = クリックして別のパスを「追加」するか, 現在のウィンドウに「ディレクトリをドラッグ」します。
	SearchImageSource               = 画像ソース検索ディスク
	Kernel                          = カーネル
	Architecture                    = 建築
	ArchitecturePack                = パッケージアーキテクチャ, 追加ルールの理解
	ImageLevel                      = インストールタイプ
	LevelDesktop                    = デスクトップ
	LevelServer                     = サーバ
	ImageCodename                   = コード
	ImageCodenameNo                 = 認識されない 
	MainImageFolder                 = メインディレクトリ
	MountImageTo                    = にマウントする
	Image_Path                      = 画像パス
	MountedIndex                    = 番号
	MountedIndexSelect              = インデックス番号を選択
	AutoSelectIndexFailed           = インデックス {0} の自動選択に失敗しました。もう一度お試しください。
	Apply                           = 画像を適用する
	Eject                           = 現れる
	Mount                           = マウント
	Unmount                         = アンインストール
	Mounted                         = マウント
	NotMounted                      = マウントされていません
	NotMountedSpecify               = マウントされていない場合は, マウント場所を指定できます
	MountedIndexError               = マウントが異常です。削除して再試行してください。
	ImageSouresNoSelect             = 画像ソースを選択した後, 詳細を表示する
	Mounted_Mode                    = マウントモード
	Mounted_Status                  = マウント状態
	Image_Popup_Default             = デフォルトとして保存
	Image_Restore_Default           = デフォルトに戻す
	Image_Popup_Tips                = ヒント：\n\nイベントを割り当てるときに, {0} を処理するためのインデックス番号を指定しませんでした。\n\n選択インターフェイスがポップアップしました。インデックス番号を指定してください。指定が完了したら, 「デフォルトとして保存」を選択することをお勧めします。次回はポップアップしません。
	Rule_Show_Full                  = すべて表示
	Rule_Show_Only                  = ルールのみを表示
	Rule_Show_Only_Select           = ルールから選ぶ
	Image_Unmount_After             = マウントされているすべてのイメージを強制的にアンマウントします

	Wim_Rule_Update                 = イメージ内のファイルの抽出, 更新
	Wim_Rule_Extract                = ファイルを抽出します
	Wim_Rule_Extract_Tips           = パス ルールを選択したら, 指定したファイルを抽出し, ローカルに保存します。

	Wim_Rule_Verify                 = 確認する
	Wim_Rule_Check                  = 診る
	Destination                     = 行き先

	Wim_Rename                      = 画像情報の修正
	Wim_Image_Name                  = 画像名
	Wim_Image_Description           = 画像の説明
	Wim_Display_Name                = 番組名
	Wim_Display_Description         = 説明を表示
	Wim_Edition                     = 画像ロゴ
	Wim_Edition_Select_Know         = 既知の画像フラグを選択する
	Wim_Created                     = 作成日
	Wim_Expander_Space              = スペースを広げる

	IABSelectNo                     = 主キーが選択されていません: Install, WinRE, Boot
	Unique_Name                     = 一意の名前
	Select_Path                     = パス
	Setting_Pri_Key                 = この更新ファイルをメイン テンプレートとして設定します：
	Pri_Key_Update_To               = 次に, 次のように更新します：
	Pri_Key_Template                = 選択したアイテムに同期する優先テンプレートとしてこのファイルを設定します
	Pri_key_Running                 = 主キー タスクが同期的に完了し, スキップされました。
	ShowAllExclude                  = 非推奨の除外をすべて表示

	Index_Process_All               = すべての既知のインデックス番号を処理する
	Index_Is_Event_Select           = イベントが発生すると, 選択インターフェイスがポップアップします
	Index_Pre_Select                = 事前に割り当てられたインデックス番号
	Index_Select_Tips               = ヒント：\n\n{0}.wim は現在マウントされていません。次のことができます:\n\n   1. [すべての既知のインデックス番号を処理する] を選択します；\n\n   2, 2.「イベントが発生すると, インデックス番号を選択するためのインターフェイスがポップアップします」を選択します；\n\n   3. 事前に指定されたインデックス番号\n      インデックス番号 6 が指定され, 処理中にインデックス番号が存在しないため, 処理がスキップされます。
'@