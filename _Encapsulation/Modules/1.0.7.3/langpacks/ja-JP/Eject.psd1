ConvertFrom-StringData -StringData @'
	# ja-JP
	# Japanese (Japan)

	Save                            = 保存する
	DoNotSave                       = 保存しない
	DoNotSaveTips                   = 回復不能です。イメージを直接アンマウントしてください。
	UnmountAndSave                  = それからアンインストールします
	UnmountNotAssignMain            = {0} が割り当てられていない場合
	UnmountNotAssignMain_Tips       = バッチ処理では, 割り当てられていない主明細を保存するかどうかを指定します。
	ImageEjectTips                  = 暖かい\n\n    1. 保存する前に，「ヘルスステータスの確認」を実行することをお勧めします。「修復可能」または「修復不能」が表示された場合：\n       * ESD の変換中に, エラー 13 が表示され, データが無効になります。\n       * システムのインストール時にエラーが発生しました。\n\n    2. ヘルスステータスの確認, サポートされていません boot.wim。\n\n    3, イメージ内ファイルマウントがある場合, イメージ内アンロード動作が指定されていない場合は, 自動的に事前設定で処理します。\n\n    4, 保存時に, 拡張イベントを割り当てることができます。\n\n    5, 保存しないとポップアップ後のイベントが実行されます。
	ImageEjectSpecification         = {0} のアンインストール中にエラーが発生しました。拡張機能をアンインストールして、もう一度お試しください。
	ImageEjectExpand                = イメージ内のファイルを管理します
	ImageEjectExpandTips            = ヒント\n\n    健康状態を確認し, 拡張機能をサポートしていない可能性があり, 開封後に確認を試みる必要があります。
	Image_Eject_Force               = オフライン画像のアンロードを許可する
	ImageEjectDone                  = すべてのタスクの完了後
'@