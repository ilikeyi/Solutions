ConvertFrom-StringData -StringData @'
	# pt-BR
	# Portuguese (Brazil)

	AdvAppsDetailed                 = Gerar relatório
	AdvAppsDetailedTips             = Pesquise por tag de região, obtenha mais detalhes quando os pacotes de experiência no idioma local estiverem disponíveis e gere um arquivo de relatório: *.CSV.
	ProcessSources                  = Fonte de processamento
	InboxAppsManager                = Aplicativo de caixa de entrada
	InboxAppsMatchDel               = Excluir por regras correspondentes
	InboxAppsOfflineDel             = Excluir um aplicativo provisionado
	InboxAppsClear                  = Forçar a remoção de todos os pré-aplicativos instalados ( InBox Apps )
	InBox_Apps_Match                = Combine aplicativos de InBox Apps
	InBox_Apps_Check                = Verifique os pacotes de dependência
	InBox_Apps_Check_Tips           = De acordo com as regras, obtenha todos os itens de instalação selecionados e verifique se os itens de instalação dependentes foram selecionados.
	LocalExperiencePack             = Pacotes de experiência no idioma local ( LXPs )
	LEPBrandNew                     = De uma nova maneira, recomendado
	UWPAutoMissingPacker            = Procure automaticamente pacotes ausentes em todos os discos
	UWPAutoMissingPackerSupport     = Arquitetura x64, os pacotes ausentes precisam ser instalados.
	UWPAutoMissingPackerNotSupport  = Arquitetura não x64, usada quando apenas a arquitetura x64 é suportada.
	UWPEdition                      = Identificador exclusivo da versão do Windows
	Optimize_Appx_Package           = Otimize o provisionamento de pacotes Appx substituindo arquivos idênticos por links físicos
	Optimize_ing                    = Otimizando
	Remove_Appx_Tips                = Ilustrar:\n\nEtapa um: Adicionar pacotes de experiência de idioma local ( LXPs ). Esta etapa deve corresponder ao pacote correspondente lançado oficialmente pela Microsoft.\n       Adicione pacotes de idiomas às imagens multisessão do Windows 10\n       https://learn.microsoft.com/pt-br/azure/virtual-desktop/language-packs\n\n       Adicione idiomas às imagens do Windows 11 Enterprise\n       https://learn.microsoft.com/pt-br/azure/virtual-desktop/windows-11-language-packs\n\nPasso 2: Descompacte ou monte *_InboxApps.iso, e selecione o diretório de acordo com a arquitetura;\n\nEtapa 3: Se a Microsoft não lançou oficialmente o pacote de experiência de idioma local ( LXPs ) mais recente, pule esta etapa: consulte o anúncio oficial da Microsoft:\n       1. Correspondente a pacotes de experiência no idioma local ( LXPs );\n       2. Correspondente a atualizações cumulativas. \n\nOs aplicativos pré-instalados ( InBox Apps ) são de idioma único e precisam ser reinstalados para serem multilíngues. \n\n1. Você pode escolher entre versão de desenvolvedor e versão inicial;\n    Versão do desenvolvedor, por exemplo, o número da versão é:\n    Windows 11 série\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Versão inicial, versão inicial conhecida:\n    Windows 11 série\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 série\n    Windows 10 22H2, Build 19045.2006\n\n    importante:\n      a. Recrie a imagem quando cada versão for atualizada. Por exemplo, ao passar de 21H1 para 22H2, não atualize com base na imagem antiga para evitar outros problemas de compatibilidade. Novamente, use a versão inicial.\n      b. Este regulamento foi comunicado claramente aos empacotadores de várias formas por alguns fabricantes OEM, e atualizações diretas de versões iterativas não são permitidas.\n      Palavras-chave: iteração, versão cruzada, atualização cumulativa.\n\n2. Após instalar o pacote de idiomas, você deve adicionar uma atualização cumulativa, porque antes que a atualização cumulativa seja adicionada, o componente não terá nenhuma alteração. Novas alterações não ocorrerão até que a atualização cumulativa seja instalada. obsoleto, a ser excluído;\n\n3. Ao usar uma versão com atualizações cumulativas, você ainda terá que adicionar atualizações cumulativas novamente no final, o que é uma operação repetida;\n\n4. Portanto, é recomendável usar uma versão sem atualizações cumulativas durante a produção e, em seguida, adicionar atualizações cumulativas na última etapa. \n\nCondições de pesquisa após selecionar o diretório: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Limpe arquivos duplicados
	ForceRemovaAllUWP               = Ignore a adição do pacote de experiência no idioma local ( LXPs ), execute outras
	LEPSkipAddEnglish               = Recomenda-se pular a adição en-US durante a instalação.
	LEPSkipAddEnglishTips           = O pacote de idioma inglês padrão não é necessário para adicioná-lo.
	License                         = Certificado
	IsLicense                       = Ter certificado
	NoLicense                       = Sem certificado
	CurrentIsNVeriosn               = Série de versão N
	CurrentNoIsNVersion             = Versão totalmente funcional
	LXPsWaitAddUpdate               = Para ser atualizado
	LXPsWaitAdd                     = Para ser adicionado
	LXPsWaitAssign                  = A ser alocado
	LXPsWaitRemove                  = Para ser excluído
	LXPsAddDelTipsView              = Tem novas dicas, confira agora
	LXPsAddDelTipsGlobal            = Chega de solicitações, sincronize com global
	LXPsAddDelTips                  = Não pergunte novamente
	Instl_Dependency_Package        = Permitir montagem automática de pacotes dependentes ao instalar InBox Apps
	Instl_Dependency_Package_Tips   = Quando o aplicativo a ser adicionado possuir pacotes dependentes, ele fará a correspondência automaticamente de acordo com as regras e completará a função de combinar automaticamente os pacotes dependentes necessários.
	Instl_Dependency_Package_Match  = Combinando pacotes de dependência
	Instl_Dependency_Package_Group  = Combinação
	InBoxAppsErrorNoSave            = Ao encontrar um erro, não é permitido ser salvo
	InBoxAppsErrorTips              = Existem erros, o item encontrado no item correspondente {0} não foi bem -sucedido
	InBoxAppsErrorNo                = Nenhum erro foi encontrado na correspondência
'@