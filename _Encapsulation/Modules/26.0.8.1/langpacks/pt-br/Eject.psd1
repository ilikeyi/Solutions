ConvertFrom-StringData -StringData @'
	# pt-BR
	# Portuguese (Brazil)

	Save                            = Salvar
	DoNotSave                       = Não salve
	DoNotSaveTips                   = Irrecuperável, desinstale a imagem diretamente.
	UnmountAndSave                  = Então desinstale
	UnmountNotAssignMain            = Quando {0} não está alocado
	UnmountNotAssignMain_Tips       = Durante o processamento em lote, você precisa especificar se deseja salvar os itens principais não atribuídos ou não.
	ImageEjectTips                  = Aviso\n\n    1. Antes de salvar, é recomendável "Verificar o status de integridade". Se aparecer "Reparável" ou "Não reparável":\n       * Durante o processo de conversão ESD, o erro 13 é exibido e os dados são inválidos;\n       * Ocorreu um erro ao instalar o sistema.\n\n    2. Verifique o status de integridade, boot.wim não é compatível.\n\n    3. Quando houver um arquivo montado na imagem e nenhuma ação de desinstalação for especificada na imagem, ele será salvo por padrão.\n\n    4. Ao salvar, você pode atribuir eventos de extensão;\n\n    5. O evento após o pop-up será executado somente se não for salvo.
	ImageEjectSpecification         = Ocorreu um erro ao desinstalar {0} Desinstale a extensão e tente novamente.
	ImageEjectExpand                = Gerenciar arquivos dentro da imagem
	ImageEjectExpandTips            = Dica\n\n    Verifique o status de integridade A extensão pode não ser compatível. Você pode tentar verificar depois de ativá-la.
	Image_Eject_Force               = Permitir que imagens offline sejam desinstaladas
	ImageEjectDone                  = Depois de completar todas as tarefas

	Abandon_Allow                   = Permitir Descarte Rápido
	Abandon_Allow_Auto              = Permitir que o Descarte Rápido seja ativado automaticamente
	Abandon_Allow_Auto_Tips         = Após permitir esta opção, a opção "Permitir Descarte Rápido" aparecerá em "Piloto Automático, Atribuição Personalizada de Eventos Conhecidos, Janelas Pop-up". Este recurso é compatível apenas com: Tarefas Principais.
	Abandon_Agreement               = Descarte Rápido: Acordo
	Abandon_Agreement_Disk_range    = Partições de disco que aceitaram o descarte rápido
	Abandon_Agreement_Allow         = Aceito o uso do descarte rápido e não serei mais responsável pelas consequências da formatação de partições de disco
	Abandon_Terms                   = Termos
	Abandon_Terms_Change            = Os termos foram alterados
	Abandon_Allow_Format            = Permitir Formatação
	Abandon_Allow_UnFormat          = Formatação não autorizada de partições
	Abandon_Allow_Time_Range        = Permitir a execução de funções do PowerShell entrará em vigor a qualquer momento
'@