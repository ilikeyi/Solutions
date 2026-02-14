ConvertFrom-StringData -StringData @'
	# ja-JP
	# Japanese (Japan)

	Convert_Only                    = 転送
	Conver_Merged                   = マージ
	Conver_Split_To_Swm             = 割る
	Conver_Split_rule               = {0} を {1} に分割
	ConvertToArchive                = すべてのパッケージを zip に変換
	ConvertOpen                     = 変換が有効になっている場合は, これを無効にします。
	ConvertBackup                   = 変換する前にバックアップを作成する
	ConvertBackupTips               = ランダムにバックアップを生成し, ファイル情報を作成します
	ConvertSplit                    = スプリットサイズ
	ConvertSplitTips                = 知らせ\n\n    1. boot.wim を分割できないか, boot.wim を esd 形式に変換します。\n\n    2. SWM 形式に分割し, 分割元の形式を install.wim としてのみ推奨します。\n\n    3. install.esd を install*.swm 形式に強制的に分割すると, Windows インストーラを使用してシステムをインストールすると, 次のエラーが報告されます。\n\n    Windows 必要なファイルをインストールできませんでした。 ファイルが破損しているか, 見つからない可能性があります。 インストールに必要なすべてのファイルが使用可能であることを確認し, インストールを再開します。 エラー コード: 0x80070570
	ConvertSWM                      = マージ install*.swm
	ConvertSWMTips                  = install.wim に変換した後, すべての *.swm を削除します。
	ConvertImageSwitch              = {0} は {1} に変換されました
	ConvertImageNot                 = {0} を {1} に変換しなくなりました。
	Converting                      = {0} から {1} へ変換中
	CompressionType                 = 圧縮タイプ
	CompressionType_None            = 圧縮なし
	CompressionType_Fast            = 高速
	CompressionType_Max             = 最大
'@