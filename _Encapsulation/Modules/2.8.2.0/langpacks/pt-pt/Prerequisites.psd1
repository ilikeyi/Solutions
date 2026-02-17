ConvertFrom-StringData -StringData @'
	# pt-PT
	# Portuguese (Portugal)

	Prerequisites                   = Pré-requisitos
	Check_PSVersion                 = Verifique a versão PS 5.1 e superior
	Check_OSVersion                 = Verifique a versão do Windows> 10.0.16299.0
	Check_Higher_elevated           = A verificação deve ser elevada para privilégios mais elevados
	Check_execution_strategy        = Verifique a estratégia de execução

	Check_Pass                      = Passar
	Check_Did_not_pass              = Fracassado
	Check_Pass_Done                 = Parabéns, aprovado.
	How_solve                       = Como resolver
	UpdatePSVersion                 = Instale a versão mais recente do PowerShell
	UpdateOSVersion                 = 1. Aceda ao site oficial da Microsoft para descarregar a versão mais recente do sistema operativo\n    2. Instale a versão mais recente do sistema operativo e tente novamente
	HigherTermail                   = 1. Abra o Terminal ou o PowerShell ISE como administrador, \n       Definir política de execução do PowerShell: Ignorar, linha de comandos PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Depois de resolvido, execute novamente o comando.
	HigherTermailAdmin              = 1. Abra o Terminal ou o PowerShell ISE como administrador. \n    2. Depois de resolvido, execute novamente o comando.
	LowAndCurrentError              = Versão mínima: {0}, versão atual: {1}
	Check_Eligible                  = Elegível
	Check_Version_PSM_Error         = Erro de versão, consulte {0}.psm1.Exemplo, atualize novamente {0}.psm1 e tente novamente.

	Check_OSEnv                     = Verificação do ambiente do sistema
	Check_Image_Bad                 = Verifique se a imagem carregada está corrompida
	Check_Need_Fix                  = Itens quebrados que precisam de ser reparados
	Image_Mount_Mode                = Modo de montagem
	Image_Mount_Status              = Estado da montagem
	Check_Compatibility             = Verificação de compatibilidade
	Check_Duplicate_rule            = Verifique se existem entradas de regras duplicadas
	Duplicates                      = Repita
	ISO_File                        = Arquivo ISO
	ISO_Langpack                    = Pacote de idiomas ISO
'@