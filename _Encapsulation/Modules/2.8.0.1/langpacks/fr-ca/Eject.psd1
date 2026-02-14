ConvertFrom-StringData -StringData @'
	# fr-ca
	# French (Canada)

	Save                            = Sauvegarder
	DoNotSave                       = Ne sauvegardez pas
	DoNotSaveTips                   = Irrécupérable, désinstallez directement l'image.
	UnmountAndSave                  = Puis désinstalle
	UnmountNotAssignMain            = Lorsque {0} n'est pas alloué
	UnmountNotAssignMain_Tips       = Lors du traitement par lots, vous devez préciser si vous souhaitez ou non sauvegarder les postes principaux non affectés.
	ImageEjectTips                  = Avertir\n\n    1. Avant d'enregistrer, il est recommandé de "Vérifier l'état de santé".\n       * Durant le processus de conversion ESD, l'erreur 13 s'affiche et les données ne sont pas valides;\n       * Une erreur s'est produite lors de l'installation du système.\n\n    2. Vérifiez l'état de santé, boot.wim n'est pas pris en charge.\n\n    3. Lorsqu'un fichier est monté dans l'image et qu'aucune action de désinstallation n'est spécifiée dans l'image, il sera enregistré par défaut.\n\n    4. Lors de l'enregistrement, vous pouvez attribuer des événements d'extension;\n\n    5. L'événement après la fenêtre contextuelle ne sera exécuté que s'il n'est pas enregistré.
	ImageEjectSpecification         = Une erreur s'est produite lors de la désinstallation de {0}.
	ImageEjectExpand                = Gérer les fichiers dans l'image
	ImageEjectExpandTips            = Indice\n\n    Vérifiez l'état de santé.
	Image_Eject_Force               = Autoriser la désinstallation des images hors ligne
	ImageEjectDone                  = Après avoir complété toutes les tâches

	Abandon_Allow                   = Autoriser la suppression rapide
	Abandon_Allow_Auto              = Activer automatiquement la suppression rapide
	Abandon_Allow_Auto_Tips         = Après avoir activé cette option, l'option "Autoriser la suppression rapide" apparaîtra dans "Pilote automatique, Affectation personnalisée des événements connus, Fenêtres contextuelles". Cette fonctionnalité est prise en charge uniquement dans: Tâches principales.
	Abandon_Agreement               = Suppression rapide: Accord
	Abandon_Agreement_Disk_range    = Partitions de disque acceptant la suppression rapide
	Abandon_Agreement_Allow         = J'accepte l'utilisation de la suppression rapide et je ne serai plus responsable des conséquences du formatage des partitions de disque
	Abandon_Terms                   = Conditions d'utilisation
	Abandon_Terms_Change            = Les conditions d'utilisation ont changé
	Abandon_Allow_Format            = Autoriser le formatage
	Abandon_Allow_UnFormat          = Formatage non autorisé des partitions
	Abandon_Allow_Time_Range        = L'autorisation d'exécuter des fonctions PowerShell entrera en vigueur à tout moment
'@