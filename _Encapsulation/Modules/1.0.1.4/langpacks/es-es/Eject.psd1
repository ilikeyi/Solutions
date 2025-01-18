ConvertFrom-StringData -StringData @'
	# es-ES
	# Spanish (Spain)

	Save                            = Ahorrar
	DoNotSave                       = No guardar
	DoNotSaveTips                   = Irrecuperable, desinstale la imagen directamente.
	UnmountAndSave                  = Después de guardar y desmontar la imagen.
	UnmountNotAssignMain            = Cuando {0} no está asignado
	UnmountNotAssignMain_Tips       = Durante el procesamiento por lotes, debe especificar si desea guardar o no los elementos principales no asignados.
	ImageEjectTips                  = Advertencia\n\n 1. Antes de guardar, se recomienda "verificar el estado de salud" si aparece "Reparable" o "Irreparable":\n       * Durante el proceso de conversión de ESD, se muestra el error 13 y los datos no son válidos;\n       * Se produjo un error al instalar el sistema.\n\n    2. Verifique el estado de salud, boot.wim no es compatible.\n\n    3. Cuando hay un archivo en la imagen montado y no se especifica ninguna acción de desinstalación en la imagen, se guardará de forma predeterminada.\n\n    4. Al guardar, puede asignar eventos de extensión;\n\n    5. El evento posterior a la ventana emergente se ejecutará solo si no se guarda.
	ImageEjectSpecification         = Se produjo un error al desinstalar {0}. Desinstale la extensión y vuelva a intentarlo.
	ImageEjectExpand                = Administrar archivos dentro de la imagen.
	ImageEjectExpandTips            = Pista\n\n    Verifique el estado de salud. Es posible que la extensión no sea compatible. Puede intentar verificarla después de habilitarla.
	Image_Eject_Force               = Permitir que se desinstalen imágenes sin conexión
	ImageEjectDone                  = Después de completar todas las tareas
'@