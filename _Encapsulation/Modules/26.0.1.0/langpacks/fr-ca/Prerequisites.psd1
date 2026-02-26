ConvertFrom-StringData -StringData @'
	# fr-ca
	# French (Canada)

	Prerequisites                   = Conditions préalables
	Check_PSVersion                 = Vérifiez la version PS 5.1 et version supérieure
	Check_OSVersion                 = Vérifiez la version de Windows > 10.0.16299.0
	Check_Higher_elevated           = Le chèque doit être élevé à des privilèges plus élevés
	Check_execution_strategy        = Vérifier la stratégie d'exécution

	Check_Pass                      = Passer
	Check_Did_not_pass              = Échoué
	Check_Pass_Done                 = Félicitations, c'est réussi.
	How_solve                       = Comment résoudre
	UpdatePSVersion                 = Veuillez installer la dernière version de PowerShell
	UpdateOSVersion                 = 1. Accédez au site officiel de Microsoft pour télécharger la dernière version du système d'exploitation\n    2. Installez la dernière version du système d'exploitation et réessayez
	HigherTermail                   = 1. Ouvrez Terminal ou PowerShell ISE en tant qu'administrateur, \n       Définir la politique d'exécution PowerShell: contourner, ligne de commande PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Une fois résolu, relancez la commande.
	HigherTermailAdmin              = 1. Ouvrez Terminal ou PowerShell ISE en tant qu'administrateur. \n    2. Une fois résolu, relancez la commande.
	LowAndCurrentError              = Version minimale:{0}, version courante:{1}
	Check_Eligible                  = Admissible
	Check_Version_PSM_Error         = Erreur de version, veuillez vous référer à {0}.psm1.Example, remettre à niveau {0}.psm1 et réessayez.

	Check_OSEnv                     = Vérification de l'environnement du système
	Check_Image_Bad                 = Vérifiez si l'image chargée est corrompue
	Check_Need_Fix                  = Objets brisés qui doivent être réparés
	Image_Mount_Mode                = Mode de montage
	Image_Mount_Status              = État du montage
	Check_Compatibility             = Vérification de la compatibilité
	Check_Duplicate_rule            = Rechercher les entrées de règle en double
	Duplicates                      = Répéter
	ISO_File                        = Fichier ISO
	ISO_Langpack                    = Pack de langue ISO
'@