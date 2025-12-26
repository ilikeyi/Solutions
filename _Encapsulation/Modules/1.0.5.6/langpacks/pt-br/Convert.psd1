ConvertFrom-StringData -StringData @'
	# pt-BR
	# Portuguese (Brazil)

	Convert_Only                    = Transferir
	Conver_Merged                   = Mesclar
	Conver_Split_To_Swm             = Dividir
	Conver_Split_rule               = Dividir {0} em {1}
	ConvertToArchive                = Converta todos os pacotes de software em pacotes compactados
	ConvertOpen                     = A conversão está ativada, desative-a.
	ConvertBackup                   = Crie um backup antes da conversão
	ConvertBackupTips               = Gere backup aleatoriamente e crie informações de arquivo
	ConvertSplit                    = Tamanho dividido
	ConvertSplitTips                = Nota\n\n    1. Você não pode dividir boot.wim ou converter boot.wim para o formato esd;\n\n    2. Dividido no formato SWM, é recomendado apenas dividir o formato original em install.wim;\n\n    3. Após a divisão forçada de install.esd no formato install*.swm, ao usar o instalador do Windows para instalar o sistema, o seguinte erro será relatado: \n\n    O Windows não pode instalar os arquivos necessários. O arquivo pode estar corrompido ou ausente. Certifique-se de que todos os arquivos necessários para a instalação estejam disponíveis e reinicie a instalação. Código de erro: 0x80070570
	ConvertSWM                      = Mesclar install*.swm
	ConvertSWMTips                  = Remova todos os *.swm após converter para install.wim.
	ConvertImageSwitch              = {0} convertido em {1}
	ConvertImageNot                 = {0} não é mais convertido em {1}
	Converting                      = Convertendo {0} em {1}
	CompressionType                 = Tipo de compressão
	CompressionType_None            = Sem compactação
	CompressionType_Fast            = Rápido
	CompressionType_Max             = Mais alto
'@