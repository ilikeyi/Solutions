ConvertFrom-StringData -StringData @'
	# pt-PT
	# Portuguese (Portugal)

	AdvAppsDetailed                 = Gerar relatório
	AdvAppsDetailedTips             = Pesquise por etiqueta de região, obtenha mais detalhes quando os pacotes de experiência no idioma local estiverem disponíveis e gere um ficheiro de relatório: *. CSV.
	ProcessSources                  = Fonte de processamento
	InboxAppsManager                = Aplicação de caixa de entrada
	InboxAppsMatchDel               = Apagar por regras correspondentes
	InboxAppsOfflineDel             = Apagar um aplicativo provisionado
	InboxAppsClear                  = Forçar a remoção de todas as pré-aplicações instaladas ( InBox Apps )
	InBox_Apps_Match                = Combine aplicações de InBox Apps
	InBox_Apps_Check                = Verifique os pacotes de dependência
	InBox_Apps_Check_Tips           = De acordo com as regras, obtenha todos os itens de instalação selecionados e verifique se os itens de instalação dependentes foram selecionados.
	LocalExperiencePack             = Pacotes de experiência no idioma local
	LEPBrandNew                     = De uma nova forma, recomendado
	UWPAutoMissingPacker            = Procure automaticamente os pacotes em falta em todos os discos
	UWPAutoMissingPackerSupport     = Arquitetura x64, os pacotes em falta precisam de ser instalados.
	UWPAutoMissingPackerNotSupport  = Arquitetura não x64, utilizada quando apenas a arquitetura x64 é suportada.
	UWPEdition                      = Identificador único da versão do Windows
	Optimize_Appx_Package           = Otimize o aprovisionamento de pacotes Appx substituindo ficheiros idênticos por ligações físicas
	Optimize_ing                    = Otimizando
	Remove_Appx_Tips                = Ilustrar:\n\nPasso um: Adicionar pacotes de experiência de idioma local ( LXPs ).\n       Adicione pacotes de idiomas às imagens multisessão do Windows 10\n       https://learn.microsoft.com/pt-pt/azure/virtual-desktop/language-packs\n\n       Adicione idiomas às imagens do Windows 11 Enterprise\n       https://learn.microsoft.com/pt-pt/azure/virtual-desktop/windows-11-language-packs\n\nPasso 2: Descompacte ou monte *_InboxApps. iso, e selecione o diretório de acordo com a arquitetura;\n\nPasso 3: Se a Microsoft não lançou oficialmente o pacote de experiência de idioma local ( LXPs ) mais recente, ignore este passo: consulte o anúncio oficial da Microsoft:\n       1. Correspondente a pacotes de experiência na língua local ( LXPs );\n       2. Correspondente a atualizações cumulativas. \n\nAs aplicações pré-instaladas ( InBox Apps ) são de idioma único e precisam de ser reinstaladas para serem multilingues. \n\n1. Pode escolher entre versão de programador e versão inicial;\n    Versão do programador, por exemplo, o número da versão é: \n    Windows 11 série\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Versão inicial, versão inicial conhecida: \n    Windows 11 série\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 série\n    Windows 10 22H2, Build 19045.2006\n\n    importante:\n      a. Recrie a imagem quando cada versão é atualizada Por exemplo, ao passar de 21H1 para 22H2, não atualize com base na imagem antiga para evitar outros problemas de compatibilidade.\n      b. Este regulamento foi comunicado claramente aos embaladores de várias formas por alguns fabricantes OEM, não sendo permitidas atualizações diretas de versões iterativas.\n      Palavras-chave: iteração, versão cruzada, atualização cumulativa.\n\n2. Após instalar o pacote de idioma, deve adicionar uma atualização cumulativa, porque antes de a atualização cumulativa ser adicionada, o componente não terá qualquer alteração.\n\n3. Ao utilizar uma versão com atualizações cumulativas, terá ainda de voltar a adicionar atualizações cumulativas no final, o que é uma operação repetida;\n\n4. Por conseguinte, é recomendável utilizar uma versão sem atualizações cumulativas durante a produção e, em seguida, adicionar atualizações cumulativas na última etapa. \n\nCondições de pesquisa após a seleção do diretório: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Após a extração, irá aparecer a imagem ISO montada. Regras: 
	ImportCleanDuplicate            = Limpe ficheiros duplicados
	ForceRemovaAllUWP               = Ignore a adição do pacote de experiência no idioma local ( LXPs ), execute outras
	LEPSkipAddEnglish               = Recomenda-se ignorar a adição en-US durante a instalação.
	LEPSkipAddEnglishTips           = O pacote de idioma inglês padrão não é necessário para o adicionar.
	License                         = Certificado
	IsLicense                       = Ter certificado
	NoLicense                       = Sem certificado
	CurrentIsNVeriosn               = Série de versão N
	CurrentNoIsNVersion             = Versão totalmente funcional
	LXPsWaitAddUpdate               = Para ser atualizado
	LXPsWaitAdd                     = Para ser adicionado
	LXPsWaitAssign                  = A ser alocado
	LXPsWaitRemove                  = Para ser excluído
	LXPsAddDelTipsView              = Tem novas dicas, veja já
	LXPsAddDelTipsGlobal            = Chega de pedidos, sincronize com global
	LXPsAddDelTips                  = Não pergunte novamente
	Instl_Dependency_Package        = Permitir a montagem automática de pacotes dependentes ao instalar InBox Apps
	Instl_Dependency_Package_Tips   = Quando a aplicação a adicionar possuir pacotes dependentes, fará a correspondência automaticamente de acordo com as regras e completará a função de combinar automaticamente os pacotes dependentes necessários.
	Instl_Dependency_Package_Match  = Combinando pacotes de dependência
	Instl_Dependency_Package_Group  = Combinação
	InBoxAppsErrorNoSave            = Ao encontrar um erro, não é permitido ser salvo
	InBoxAppsErrorTips              = Existem erros, o item encontrado no item correspondente {0} não foi bem -sucedido
	InBoxAppsErrorNo                = Nenhum erro foi encontrado na correspondência
'@