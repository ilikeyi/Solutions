﻿ConvertFrom-StringData -StringData @'
	# ja-JP
	# Japanese (Japan)

	Prerequisites                   = 前提条件
	Check_PSVersion                 = PS バージョン 5.1 以降を確認してください
	Check_OSVersion                 = Windows バージョン > 10.0.16299.0 を確認してください
	Check_Higher_elevated           = チェックはより高い特権に昇格する必要があります
	Check_execution_strategy        = 実行戦略を確認する

	Check_Pass                      = 合格
	Check_Did_not_pass              = 失敗した
	Check_Pass_Done                 = おめでとうございます, 合格しました。
	How_solve                       = 解決方法
	UpdatePSVersion                 = 最新の PowerShell バージョンをインストールしてください
	UpdateOSVersion                 = 1. Microsoft の公式 Web サイトにアクセスして, \n       オペレーティング システムの最新バージョンをダウンロードします。\n    2. 最新バージョンのオペレーティング システムをインストールして再試行してください
	HigherTermail                   = 1. 管理者としてターミナルまたは PowerShell ISE を開きます。\n       设置 PowerShell 执行策略：绕过，PS命令行：\n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. 解決したら, コマンドを再実行します。
	HigherTermailAdmin              = 1. 管理者としてターミナルまたは PowerShell ISE を開きます。\n     2. 解決したら, コマンドを再実行します。
	LowAndCurrentError              = 最小バージョン: {0}, 現在のバージョン: {1}
	Check_Eligible                  = 適格
	Check_Version_PSM_Error         = バージョン エラー。{0}.psm1.Example を参照してください。{0}.psm1 を再アップグレードして, もう一度お試しください。

	Check_OSEnv                     = システム環境チェック
	Check_Image_Bad                 = 読み込んだ画像が破損していないか確認する
	Check_Need_Fix                  = 修理が必要な壊れたアイテム
	Image_Mount_Mode                = マウントモード
	Image_Mount_Status              = マウントステータス
	Check_Compatibility             = 互換性チェック
	Check_Duplicate_rule            = 重複したルールエントリをチェックする
	Duplicates                      = 繰り返す
	ISO_File                        = ISOファイル
	ISO_Langpack                    = ISO 言語パック
'@