ConvertFrom-StringData -StringData @'
	# pt-PT
	# Portuguese (Portugal)

	SaveModeClear                   = Limpar histórico selecionado
	SaveModeTipsClear               = O histórico foi guardado e pode ser apagado
	SelectTips                      = Dicas\n\n    1. Selecione o nome da imagem a processar;\n    2. Após o cancelamento, as tarefas que exijam "montagem" antes da operação deixarão de ter efeito.
	CacheDisk                       = Cache de disco
	CacheDiskCustomize              = Caminho de cache personalizado
	AutoSelectRAMDISK               = Permitir a seleção automática do rótulo do volume de disco
	AutoSelectRAMDISKFailed         = Rótulo do volume não correspondido
	ReFS_Find_Volume                = Quando o formato de disco REFS for encontrado, apague
	ReFS_Exclude                    = Partição ReFS eliminada
	Disk_Not_satisfied_Exclude      = Requisitos mínimos de disco não cumpridos
	RAMDISK_Change                  = Alterar o nome do rótulo do volume
	RAMDISK_Search                  = Pesquisar nome do rótulo do volume
	RAMDISK_Restore                 = Restaurar nome do volume inicializado: {0}
	AllowTopMost                    = Permitir que as janelas abertas sejam fixadas na parte superior
	History                         = Limpar histórico
	History_Del_Tips                = Quando existe uma tarefa de encapsulamento, não execute as seguintes opções opcionais, caso contrário irá causar problemas desconhecidos durante a execução do script de encapsulamento.
	History_View                    = Ver histórico
	HistoryLog                      = Permitir a limpeza automática de registos com mais de 7 dias
	HistorySaveFolder               = Outros caminhos de origem da imagem
	HistoryClearappxStage           = InBox Apps: apague os ficheiros temporários gerados durante a instalação
	DoNotCheckBoot                  = Quando o tamanho do ficheiro Boot. wim excede os 520 MB, a reconstrução é automaticamente selecionada ao gerar o ISO.
	HistoryClearDismSave            = Apague os registos de montagem DISM guardados no registo
	ImageSourcesClickShowKey        = Permitir a apresentação do menu "Selecionar chave primária"
	ImageSourcesClickShowKeyTips    = Após o utilizador selecionar a origem da imagem: Adicione um menu "Selecionar chave primária" à direita e adicione as opções "Ir para": Montar, Guardar, Janela de pop-up.
	Clear_Bad_Mount                 = Apague todos os recursos associados à imagem montada corrompida
	ShowCommand                     = Mostrar a execução completa da linha de comandos
	Command                         = Linha de comando
	SelectSettingImage              = Fonte da imagem
	NoSelectImageSource             = Nenhuma fonte de imagem selecionada
	SettingImageRestore             = Restaurar local de montagem predefinido
	SettingImage                    = Alterar local de montagem da fonte da imagem
	SelectImageMountStatus          = Obter o estado de montagem após selecionar a fonte da imagem
	SettingImageTempFolder          = Diretório temporário
	SettingImageToTemp              = O diretório temporário é o mesmo local onde foi montado
	SettingImagePathTemp            = Utilizando o diretório Temp
	SettingImageLow                 = Verifique o espaço restante mínimo disponível
	SettingImageNewPath             = Selecione o disco de montagem
	SettingImageNewPathTips         = É recomendável montá-lo num disco de memória, que é o mais rápido.
	SelectImageSource               = "Deploy Engine Solution" foi selecionado, clique em OK.
	NoImagePreSource                = Nenhuma fonte disponível encontrada, deve: \n\n     1. Adicione mais fontes de imagem a: \n          {0}\n\n     2. Selecione "Definições" e selecione novamente o disco de pesquisa de origem da imagem;\n\n     3. Selecione "ISO" e selecione o ISO a descomprimir, os itens a montar, etc.
	NoImageOtherSource              = Clique em mim para "Adicionar" outros caminhos ou "Arrastar Diretório" para a janela atual.
	SearchImageSource               = Disco de pesquisa de origem de imagem
	Kernel                          = Núcleo
	Architecture                    = Arquitetura
	ArchitecturePack                = Arquitetura de pacotes, compreensão de regras de adição
	ImageLevel                      = Tipo de instalação
	LevelDesktop                    = Área de trabalho
	LevelServer                     = Servidor
	ImageCodename                   = Codinome
	ImageCodenameNo                 = Não reconhecido
	MainImageFolder                 = Diretório inicial
	MountImageTo                    = Montar em
	Image_Path                      = Caminho da imagem
	MountedIndex                    = Índice
	MountedIndexSelect              = Selecione o número do índice
	AutoSelectIndexFailed           = A seleção automática do índice {0} falhou.
	Apply                           = Aplicativo
	Eject                           = Aparecer
	Mount                           = Montar
	Unmount                         = Desinstalar
	Mounted                         = Montado
	NotMounted                      = Não montado
	NotMountedSpecify               = Não montado, pode especificar o local de montagem
	MountedIndexError               = Montagem anormal, apague e tente novamente.
	ImageSouresNoSelect             = Mostrar mais detalhes após selecionar a fonte da imagem
	Mounted_Mode                    = Modo de montagem
	Mounted_Status                  = Estado da montagem
	Image_Popup_Default             = Guardar como padrão
	Image_Restore_Default           = Reverter para o padrão
	Image_Popup_Tips                = Dica:\n\nAo atribuir o evento, não especificou o número de índice para processar {0};\n\nA interface de seleção apareceu. Especifique o número do índice.
	Rule_Show_Full                  = Mostrar tudo
	Rule_Show_Only                  = Mostrar apenas regras
	Rule_Show_Only_Select           = Escolha entre as regras
	Image_Unmount_After             = Desinstalar tudo montado

	Wim_Rule_Update                 = Extraia e atualize ficheiros dentro da imagem
	Wim_Rule_Extract                = Extrair ficheiros
	Wim_Rule_Extract_Tips           = Após selecionar a regra de caminho, extraia o ficheiro especificado e guarde-o localmente.

	Wim_Rule_Verify                 = Verificar
	Wim_Rule_Check                  = Examinar
	Wim_Rule_CheckIntegrity         = Verificar Integridade
	Wim_Rule_WIMBoot                = Inicializável
	Wim_Rule_Compact                = Compactar Ficheiros do Sistema Operacional
	Win_Rule_Setbootable            = Marcar Imagem de Volume como Inicializável
	Win_Rule_Setbootable_Tips       = Este parâmetro aplica-se apenas às imagens do Windows PE.\nApenas uma imagem de volume pode ser marcada como inicializável num ficheiro .wim.
	Destination                     = Destino

	Wim_Append                      = Anexar
	Wim_Capture                     = Capturar
	Wim_Capture_Tips                = Capturar a imagem da unidade para um novo ficheiro WIM.
	Wim_Capture_Sources             = Origem da Captura
	Wim_Capture_Sources_Tips        = O diretório capturado contém todas as subpastas e dados.\nNão é possível capturar um diretório vazio. O diretório deve conter pelo menos um ficheiro.
	Wim_Config_File                 = Caminho do Ficheiro de Configuração ( Exclusões )
	Wim_Config_Edit                 = Editar
	Wim_Config_Learn                = Consulte a lista de definições e o ficheiro WimScript.ini

	Wim_Rename                      = Modificar a informação da imagem
	Wim_Image_Name                  = Nome da imagem
	Wim_Image_Description           = Descrição da imagem
	Wim_Display_Name                = Nome de exibição
	Wim_Display_Description         = Mostrar descrição
	Wim_Edition                     = Marca de imagem
	Wim_Edition_Select_Know         = Selecione sinalizadores de imagem conhecidos
	Wim_CreatedTime                 = Data de criação
	Wim_ModifiedTime                = Data da última modificação
	Wim_FileCount                   = Número de ficheiros
	Wim_DirectoryCount              = Número de diretórios
	Wim_Expander_Space              = Espaço de expansão

	IABSelectNo                     = Nenhuma chave primária selecionada: Instalar, WinRE, Arranque
	Unique_Name                     = Nomenclatura única
	Select_Path                     = Caminho
	Setting_Pri_Key                 = Defina este ficheiro de atualização como modelo principal
	Pri_Key_Update_To               = Em seguida, atualize para
	Pri_Key_Template                = Defina este ficheiro como o modelo preferido para ser sincronizado com os itens selecionados
	Pri_key_Running                 = A tarefa da chave primária foi sincronizada e ignorada.
	ShowAllExclude                  = Mostrar todas as exclusões obsoletas

	Index_Process_All               = Processe todos os números de índice conhecidos
	Index_Is_Event_Select           = Quando existe um evento, é apresentada a interface de seleção do número de índice.
	Index_Pre_Select                = Número de índice pré-atribuído
	Index_Select_Tips               = Dica:\n\n{0}.wim não está ativado de momento, pode: \n\n   1. Selecione "Processar todos os números de índice conhecidos";\n\n   2. Selecione "Quando existe um evento, será apresentada a interface de seleção do número de índice";\n\n   3. Número de índice pré-especificado\n      O número de índice 6 é especificado, o número de índice não existe durante o processamento e o processamento é ignorado.

	Index_Tips_Custom_Expand        = Grupo: {0}\n\nAo processar {1}, o número de índice {2} necessita de ser atribuído, caso contrário não poderá ser processado.\n\nDepois de selecionar "Sincronizar regras de atualização para todos os números de índice", só tem de marcar qualquer um como modelo principal.

	DefenderExclude                 = Exclusões do antivírus do Windows
	DefenderFolder                  = Adicionar este diretório às exclusões do antivírus do Windows.
	DefenderVolume                  = Após encontrar um nome de rótulo de volume correspondente, adicione este disco às exclusões do antivírus do Windows.
	DefenderIsAdd                   = Adicionado às exclusões do antivírus do Windows
'@