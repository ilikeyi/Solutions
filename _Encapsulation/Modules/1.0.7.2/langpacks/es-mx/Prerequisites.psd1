ConvertFrom-StringData -StringData @'
	# es-mx
	# Spanish (Mexico)

	Prerequisites                   = Requisitos previos
	Check_PSVersion                 = Verifique la versión de PS 5.1 y superior
	Check_OSVersion                 = Verifique la versión de Windows > 10.0.16299.0
	Check_Higher_elevated           = El cheque debe estar elevado a privilegios más altos
	Check_execution_strategy        = Verificar estrategia de ejecución

	Check_Pass                      = Aprobar
	Check_Did_not_pass              = Fallido
	Check_Pass_Done                 = Felicitaciones, pasó.
	How_solve                       = Como resolver
	UpdatePSVersion                 = Instale la última versión de PowerShell
	UpdateOSVersion                 = 1. Vaya al sitio web oficial de Microsoft para descargar la última versión del sistema operativo.\n    2. Instale la última versión del sistema operativo y vuelva a intentarlo
	HigherTermail                   = 1. Abra Terminal o PowerShell ISE como administrador, \n       Establecer política de ejecución de PowerShell: omitir, línea de comando PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Una vez resuelto, vuelva a ejecutar el comando.
	HigherTermailAdmin              = 1. Abra Terminal o PowerShell ISE como administrador. \n    2. Una vez resuelto, vuelva a ejecutar el comando.
	LowAndCurrentError              = Versión mínima: {0}, versión actual: {1}
	Check_Eligible                  = Elegible
	Check_Version_PSM_Error         = Error de versión, consulte {0}.psm1. Ejemplo, vuelva a actualizar {0}.psm1 e inténtelo de nuevo.

	Check_OSEnv                     = Verificación del entorno del sistema
	Check_Image_Bad                 = Compruebe si la imagen cargada está corrupta
	Check_Need_Fix                  = Artículos rotos que necesitan ser reparados
	Image_Mount_Mode                = Modo de montaje
	Image_Mount_Status              = Estado de montaje
	Check_Compatibility             = Verificación de compatibilidad
	Check_Duplicate_rule            = Buscar entradas de reglas duplicadas
	Duplicates                      = Repetir
	ISO_File                        = Archivo iso
	ISO_Langpack                    = Paquete de idioma ISO
'@