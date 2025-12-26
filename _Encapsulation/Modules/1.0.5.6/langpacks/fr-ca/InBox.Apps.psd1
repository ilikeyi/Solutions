ConvertFrom-StringData -StringData @'
	# fr-ca
	# French (Canada)

	AdvAppsDetailed                 = Générer un rapport
	AdvAppsDetailedTips             = Recherchez par balise de région, obtenez plus de détails lorsque des packs d'expérience en langue locale sont disponibles et générez un fichier de rapport: *.CSV.
	ProcessSources                  = Source de traitement
	InboxAppsManager                = Boîte de réception d'application
	InboxAppsMatchDel               = Supprimer en faisant correspondre les règles
	InboxAppsOfflineDel             = Supprimer une application provisionnée
	InboxAppsClear                  = Supprimer de force toutes les pré-applications installées ( InBox Apps )
	InBox_Apps_Match                = Faire correspondre les applications InBox Apps
	InBox_Apps_Check                = Vérifier les paquets de dépendances
	InBox_Apps_Check_Tips           = Conformément aux règles, obtenez tous les éléments d'installation sélectionnés et vérifiez si les éléments d'installation dépendants ont été sélectionnés.
	LocalExperiencePack             = Packs d'expérience en langue locale
	LEPBrandNew                     = D'une nouvelle manière, recommandé
	UWPAutoMissingPacker            = Rechercher automatiquement les paquets manquants sur tous les disques
	UWPAutoMissingPackerSupport     = Architecture x64, les forfaits manquants doivent être installés.
	UWPAutoMissingPackerNotSupport  = Architecture non x64, utilisée lorsque seulement l'architecture x64 est prise en charge.
	UWPEdition                      = Identificateur unique de la version Windows
	Optimize_Appx_Package           = Optimisez l'approvisionnement des packages Appx en remplaçant les fichiers identiques par des liens physiques
	Optimize_ing                    = Optimisation
	Remove_Appx_Tips                = Illustrer:\n\nPremière étape: ajouter des forfaits d'expérience en langue locale ( LXPs ): \n       Ajouter des modules linguistiques aux images multisessions Windows 10\n       https://learn.microsoft.com/en-us/azure/virtual-desktop/language-packs\n\n       Ajouter des langues aux images Windows 11 Entreprise\n       https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs\n\nÉtape 2: Décompressez ou montez *_InboxApps.iso, et sélectionnez le répertoire en fonction de l'architecture ;\n\nÉtape 3: Si Microsoft n'a pas officiellement publié le dernier paquet d'expérience en langue locale ( LXPs ), ignorez cette étape si c'est le cas: veuillez vous référer à l'annonce officielle de Microsoft:\n       1. Correspondant aux forfaits d'expérience en langue locale ( LXPs );\n       2. Correspondant aux mises à jour cumulatives. \n\nLes applications préinstallées ( InBox Apps ) sont monolingues et doivent être réinstallées pour obtenir plusieurs langues.\n\n1. Vous pouvez choisir entre la version développeur et la version initiale;\n    Version développeur, par exemple, le numéro de version est:\n    Windows 11 série\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Version initiale, version initiale connue: \n    Windows 11 série\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 série\n    Windows 10 22H2, Build 19045.2006\n\n    important:\n      a. Veuillez recréer l'image lorsque chaque version est mise à jour. veuillez utiliser la version initiale.\n      b. Cette réglementation a été clairement communiquée aux conditionneurs sous diverses formes par certains fabricants OEM, et les mises à niveau directes à partir de versions itératives ne sont pas autorisées.\n      Mots-clés: itération, version croisée, mise à jour cumulative.\n\n2. Après avoir installé le module linguistique, des mises à jour cumulatives doivent être ajoutées, car avant que les mises à jour cumulatives ne soient ajoutées, les composants ne subiront aucune modification tant que les mises à jour cumulatives ne seront pas installées. , l'état du composant: obsolète.\n\n3. Lorsque vous utilisez une version avec des mises à jour cumulatives, vous devez quand même ajouter à nouveau des mises à jour cumulatives à la fin, ce qui est une opération répétée ;\n\n4. Par conséquent, il est recommandé d'utiliser une version sans mises à jour cumulatives pendant la production, puis d'ajouter des mises à jour cumulatives lors de la dernière étape. \n\nConditions de recherche après sélection du répertoire: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Après l'extraction, l'image ISO montée s'affichera. Règles: 
	ImportCleanDuplicate            = Nettoyer les fichiers en double
	ForceRemovaAllUWP               = Ignorer l'ajout du paquet d'expérience en langue locale ( LXPs ), effectuer d'autres
	LEPSkipAddEnglish               = Il est recommandé d'ignorer l'ajout en-US lors de l'installation.
	LEPSkipAddEnglishTips           = Le pack de langue anglaise par défaut n'est pas nécessaire pour l'ajouter.
	License                         = Certificat
	IsLicense                       = Avoir un certificat
	NoLicense                       = Pas de certificat
	CurrentIsNVeriosn               = Série de versions N
	CurrentNoIsNVersion             = Version entièrement fonctionnelle
	LXPsWaitAddUpdate               = À mettre à jour
	LXPsWaitAdd                     = À ajouter
	LXPsWaitAssign                  = À attribuer
	LXPsWaitRemove                  = À supprimer
	LXPsAddDelTipsView              = Il y a de nouveaux conseils, vérifiez maintenant
	LXPsAddDelTipsGlobal            = Plus d'invites, synchroniser avec global
	LXPsAddDelTips                  = Ne plus demander
	Instl_Dependency_Package        = Autoriser l'assemblage automatique des progiciels dépendants lors de l'installation des InBox Apps 
	Instl_Dependency_Package_Tips   = Lorsque l'application à ajouter comporte des paquets dépendants, elle correspondra automatiquement selon les règles et remplira la fonction de combinaison automatique des packages dépendants requis.
	Instl_Dependency_Package_Match  = Combinaison de paquets de dépendances
	Instl_Dependency_Package_Group  = Combinaison
	InBoxAppsErrorNoSave            = Lors de la rencontre d'une erreur, il n'est pas autorisé à être sauvé
	InBoxAppsErrorTips              = Il y a des erreurs, l'élément rencontré dans l'élément correspondant {0} a échoué
	InBoxAppsErrorNo                = Aucune erreur n'a été trouvée dans le match
'@