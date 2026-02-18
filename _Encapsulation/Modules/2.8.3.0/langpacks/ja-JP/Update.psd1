ConvertFrom-StringData -StringData @'
	# ja-JP
	# Japanese (Japan)

	ChkUpdate                 = 更新を確認します
	UpdateServerSelect        = 自動サーバー選択またはカスタム選択
	UpdateServerNoSelect      = 利用可能なサーバーを選択してください
	UpdateSilent              = 利用可能なアップデートがある場合のサイレントアップデート
	UpdateClean               = 古いバージョンを自由にクリーニングできるようにする
	UpdateReset               = このソリューションをリセットします
	UpdateResetTips           = ダウンロードアドレスが利用可能になったら, ダウンロードを強制して自動的に更新します。
	UpdateCheckServerStatus   = サーバーステータスを確認します ( 合計 {0} はオプション )
	UpdateServerAddress       = サーバーアドレス
	UpdatePriority            = が優先度として設定されています
	UpdateServerTestFailed    = サーバーステータステストに失敗しました
	UpdateQueryingUpdate      = クエリと更新...
	UpdateQueryingTime        = 最新バージョンが利用可能かどうかを確認すると, 接続に {0} ミリ秒かかりました。
	UpdateConnectFailed       = リモートサーバーに接続できません。更新の確認が中止されました。
	UpdateREConnect           = 接続に失敗しました，{0}/{1} 回目の再試行です。
	UpdateMinimumVersion      = 更新プログラムの最小バージョン要件, 必要な最小バージョンを満たします：{0}
	UpdateVerifyAvailable     = アドレスが使用可能であることを確認します
	Download                  = ダウンロード
	UpdateDownloadAddress     = ダウンロードアドレス
	UpdateAvailable           = 利用可能
	UpdateUnavailable         = 利用不可
	UpdateCurrent             = 現在のバージョン
	UpdateLatest              = 利用可能な最新バージョン
	UpdateNewLatest           = 利用可能な新しいバージョンが見つかりました！
	UpdateSkipUpdateCheck     = 事前設定されたポリシー。これにより, 自動更新を初めて実行することはできません。
	UpdateTimeUsed            = 使用時間
	UpdatePostProc            = 後処理
	UpdateNotExecuted         = 実行されません
	UpdateNoPost              = 後処理タスクが見つかりません
	UpdateUnpacking           = 開梱
	UpdateDone                = 正常に更新されました！
	UpdateDoneRefresh         = 更新が完了したら, 関数処理を実行します。
	UpdateUpdateStop          = 更新のダウンロード中にエラーが発生し, 更新プロセスが中止されました。
	UpdateInstall             = このアップデートをインストールしますか？
	UpdateInstallSel          = はい, 上記のアップデートがインストールされます\nいいえ, アップデートはインストールされません
	UpdateNotSatisfied        = \n  最小更新プログラム バージョン要件が満たされていません, \n\n  最低限必要なバージョン：{0}\n\n  再度ダウンロードしてください。\n\n  チェックの更新が中止されました。\n

	IsAllowSHA256Check        = SHA256 ハッシュ検証を許可
	GetSHAFailed              = ダウンロードしたファイルとの比較用ハッシュの取得に失敗しました。
	Verify_Done               = 検証は成功しました。
	Verify_Failed             = 検証に失敗しました，ハッシュが一致しません。

	Auto_Update_Allow         = 自動バックグラウンド更新チェックを許可する
	Auto_Update_New_Allow     = 新しい更新が検出されたら、自動更新を許可します。
	Auto_Check_Time           = 時間、自動チェック間隔
	Auto_Last_Check_Time      = 前回の自動更新チェック時刻
	Auto_Next_Check_Time      = {0} 時間以内、次回チェック時刻
	Auto_First_Check          = 更新チェックは実行されませんでした。最初の更新チェックを実行します。
	Auto_Update_Last_status   = 前回の更新ステータス
	Auto_Update_IsLatest      = 最新バージョンです

	SearchOrder               = 検索順序
	SearchOrderTips           = 検索順序\n  [ 1.  2. ] の条件が満たされた場合、検索は停止します。満たされない場合は検索を続行します。\n\n\n1. インデックス番号\n   [ ソースの追加 ]\\Custom\\[ 現在マウントされているインデックス番号に一致する ] を検索します。一致するファイルが見つかった場合、ファイルを追加して検索を停止します。\n\n2. イメージフラグ\n   [ ソースの追加 ]\\Custom\\[ 現在マウントされているイメージフラグを取得する ] を検索します。一致するファイルが見つかった場合、ファイルを追加して検索を停止します。\n\n3. その他\n   12 の条件のいずれも満たされない場合、デフォルトでソース内のすべてのファイルが追加されます（ソース内のCustomディレクトリは除く）。
'@