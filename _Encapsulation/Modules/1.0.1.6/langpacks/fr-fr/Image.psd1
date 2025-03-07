ConvertFrom-StringData -StringData @'
	# fr-FR
	# French (France)

	SaveModeClear                   = Effacer l'historique sélectionné
	SaveModeTipsClear               = L'historique a été enregistré et peut être effacé
	SelectTips                      = Indice\n\n    1. Veuillez sélectionner le nom de l'image à traiter;\n    2. Après avoir annulé, les tâches qui nécessitent un "montage" avant l'opération ne prendront plus effet.
	CacheDisk                       = Cache disque
	CacheDiskCustomize              = Chemin de cache personnalisé
	AutoSelectRAMDISK               = Autoriser la sélection automatique du nom du volume du disque
	AutoSelectRAMDISKFailed         = Le libellé du volume ne correspond pas: {0}
	ReFS_Find_Volume                = Lorsque le format de disque REFS est rencontré, excluez
	ReFS_Exclude                    = Partition ReFS exclue
	RAMDISK_Change                  = Changer le nom du nom de volume
	RAMDISK_Restore                 = Restaurer le nom du volume initialisé: {0}
	AllowTopMost                    = Autoriser les fenêtres ouvertes à être épinglées en haut
	History                         = Effacer l'historique
	History_Del_Tips                = Lorsqu'il y a une tâche d'encapsulation, n'exécutez pas les options facultatives suivantes, sinon cela entraînerait des problèmes inconnus lors de l'exécution du script d'encapsulation.
	History_View                    = Afficher l'historique
	HistoryLog                      = Autoriser le nettoyage automatique des journaux datant de plus de 7 jours
	HistorySaveFolder               = Autres chemins de source d'image
	HistoryClearappxStage           = InBox Apps: supprimer les fichiers temporaires générés lors de l'installation
	DoNotCheckBoot                  = Lorsque la taille du fichier Boot.wim dépasse 520 Mo, la reconstruction est automatiquement sélectionnée lors de la génération de l'ISO.
	HistoryClearDismSave            = Supprimer les enregistrements de montage DISM enregistrés dans le registre
	Clear_Bad_Mount                 = Supprimez toutes les ressources associées à l'image montée corrompue
	ShowCommand                     = Afficher l'exécution complète de la ligne de commande
	Command                         = Ligne de commande
	SelectSettingImage              = Source d'images
	NoSelectImageSource             = Aucune source d'image sélectionnée
	SettingImageRestore             = Restaurer l'emplacement de montage par défaut
	SettingImage                    = Modifier l'emplacement de montage de la source d'image
	SelectImageMountStatus          = Obtenir l'état du montage après avoir sélectionné la source de l'image
	SettingImageTempFolder          = Répertoire temporaire
	SettingImageToTemp              = Le répertoire temporaire est le même que l'emplacement où il a été monté.
	SettingImagePathTemp            = Utiliser le répertoire Temp
	SettingImageLow                 = Vérifiez l'espace restant minimum disponible
	SettingImageNewPath             = Sélectionnez le disque de montage
	SettingImageNewPathTips         = Il est recommandé de le monter sur un disque mémoire, qui est le plus rapide. Vous pouvez utiliser un logiciel de mémoire virtuelle tel qu'Ultra RAMDisk et ImDisk.
	SelectImageSource               = "Déployer la solution du moteur" a été sélectionné, cliquez sur OK.
	NoImagePreSource                = Aucune source disponible trouvée, vous devez: \n\n     1. Ajoutez plus de sources d'images à:\n          {0}\n\n     2. Sélectionnez "Paramètres" et resélectionnez le disque de recherche de source d'image;\n\n     3. Sélectionnez "ISO" et sélectionnez l'ISO à décompresser, les éléments à monter, etc.
	NoImageOtherSource              = Cliquez sur moi pour "Ajouter" d'autres chemins ou "Faites glisser le répertoire" vers la fenêtre actuelle.
	SearchImageSource               = Disque de recherche de source d'image
	Kernel                          = Noyau
	Architecture                    = Architecture
	ArchitecturePack                = Architecture du package, compréhension de l'ajout de règles
	ImageLevel                      = Type d'installation
	LevelDesktop                    = Ordinateur de bureau
	LevelServer                     = Serveur
	ImageCodename                   = Nom de code
	ImageCodenameNo                 = Non reconnu
	MainImageFolder                 = Répertoire personnel
	MountImageTo                    = Monter à
	Image_Path                      = Chemin de l'image
	MountedIndex                    = Indice
	MountedIndexSelect              = Sélectionnez le numéro d'index
	AutoSelectIndexFailed           = La sélection automatique de l'index {0} a échoué, veuillez réessayer.
	Apply                           = Application
	Eject                           = Surgir
	Mount                           = Monter
	Unmount                         = Désinstaller
	Mounted                         = Monté
	NotMounted                      = Non monté
	NotMountedSpecify               = Non monté, vous pouvez préciser l'emplacement de montage
	MountedIndexError               = Montage anormal, supprimez et réessayez.
	ImageSouresNoSelect             = Afficher plus de détails après avoir sélectionné la source de l'image
	Mounted_Mode                    = Mode de montage
	Mounted_Status                  = État du montage
	Image_Popup_Default             = Enregistrer par défaut
	Image_Restore_Default           = Revenir aux paramètres par défaut
	Image_Popup_Tips                = Indice:\n\nLorsque vous avez attribué l'événement, vous n'avez pas spécifié le numéro d'index à traiter {0};\n\nL'interface de sélection est actuellement apparue. Veuillez spécifier le numéro d'index. Une fois la spécification terminée, il est recommandé de sélectionner "Enregistrer par défaut". Elle ne réapparaîtra pas la prochaine fois que vous la traiterez.
	Rule_Show_Full                  = Afficher tout
	Rule_Show_Only                  = Afficher uniquement les règles
	Rule_Show_Only_Select           = Choisissez parmi les règles
	Image_Unmount_After             = Désinstaller tous les montés

	Wim_Rule_Update                 = Extraire et mettre à jour les fichiers dans l'image
	Wim_Rule_Extract                = Extraire des fichiers
	Wim_Rule_Extract_Tips           = Après avoir sélectionné la règle de chemin, extrayez le fichier spécifié et enregistrez-le localement.

	Wim_Rule_Verify                 = Vérifier
	Wim_Rule_Check                  = Examiner
	Destination                     = Destination

	Wim_Rename                      = Modifier les informations de l'image
	Wim_Image_Name                  = Nom de l'image
	Wim_Image_Description           = Description des images
	Wim_Display_Name                = Nom d'affichage
	Wim_Display_Description         = Afficher la description
	Wim_Edition                     = Marque d'image
	Wim_Edition_Select_Know         = Sélectionnez les indicateurs d'image connus
	Wim_Created                     = Date de création
	Wim_Expander_Space              = Espace d'extension

	IABSelectNo                     = Aucune clé primaire sélectionnée: Installer, WinRE, Boot
	Unique_Name                     = Dénomination unique
	Select_Path                     = Chemin
	Setting_Pri_Key                 = Définissez ce fichier de mise à jour comme modèle principal:
	Pri_Key_Update_To               = Puis mettez à jour vers:
	Pri_Key_Template                = Définir ce fichier comme modèle préféré à synchroniser avec les éléments sélectionnés
	Pri_key_Running                 = La tâche de clé primaire a été synchronisée et a été ignorée.
	ShowAllExclude                  = Afficher toutes les exclusions obsolètes

	Index_Process_All               = Traiter tous les numéros d'index connus
	Index_Is_Event_Select           = Lorsqu'il y a un événement, l'interface de sélection du numéro d'index apparaît.
	Index_Pre_Select                = Numéro d'index pré-attribué
	Index_Select_Tips               = Indice:\n\n{0}.wim n'est pas actuellement monté, vous pouvez: \n\n   1. Sélectionnez "Traiter tous les numéros d'index connus" ;\n\n   2. Sélectionnez "Lorsqu'il y a un événement, l'interface de sélection du numéro d'index apparaîtra";\n\n   3. Numéro d'index prédéfini\n      Le numéro d'index 6 est spécifié, le numéro d'index n'existe pas pendant le traitement et le traitement est ignoré.

	Index_Tips_Custom_Expand        = Groupe: {0}\n\nLors du traitement de {1}, le numéro d'index {2} doit être attribué, sinon il ne peut pas être traité. \n\nAprès avoir sélectionné "Synchroniser les règles de mise à jour avec tous les numéros d'index", il vous suffit d'en cocher un comme modèle principal.
'@