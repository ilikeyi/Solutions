ConvertFrom-StringData -StringData @'
	# es-mx
	# Spanish (Mexico)

	ChkUpdate                 = Buscar actualizaciones
	UpdateServerSelect        = Selección automática de servidor o selección personalizada
	UpdateServerNoSelect      = Por favor seleccione un servidor disponible
	UpdateSilent              = Actualizar silenciosamente cuando haya actualizaciones disponibles
	UpdateClean               = Permitir la limpieza de versiones antiguas cuando lo desee
	UpdateReset               = Restablecer esta solución
	UpdateResetTips           = Cuando la dirección de descarga está disponible, la descarga se fuerza y se actualiza automáticamente.
	UpdateCheckServerStatus   = Verificar el estado del servidor ( {0} opciones disponibles )
	UpdateServerAddress       = Dirección del servidor
	UpdatePriority            = Ya establecido como prioridad
	UpdateServerTestFailed    = Prueba de estado del servidor fallida
	UpdateQueryingUpdate      = Consultando actualizaciones...
	UpdateQueryingTime        = Al comprobar si la última versión está disponible, la conexión tardó {0} milisegundos.
	UpdateConnectFailed       = No se puede conectar al servidor remoto, se canceló la búsqueda de actualizaciones.
	UpdateREConnect           = La conexión falló, se intentará nuevamente por {0}/{1} ª vez.
	UpdateMinimumVersion      = Cumple con los requisitos mínimos de versión del actualizador, versión mínima requerida: {0}
	UpdateVerifyAvailable     = Verificar que la dirección esté disponible
	Download                  = Descargar
	UpdateDownloadAddress     = Descargar dirección
	UpdateAvailable           = Disponible
	UpdateUnavailable         = No disponible
	UpdateCurrent             = Versión actualmente en uso
	UpdateLatest              = Última versión disponible
	UpdateNewLatest           = Descubre nuevas versiones disponibles!
	UpdateSkipUpdateCheck     = Política preconfigurada para no permitir que se ejecuten actualizaciones automáticas por primera vez.
	UpdateTimeUsed            = Tiempo invertido
	UpdatePostProc            = Postprocesamiento
	UpdateNotExecuted         = No ejecutado
	UpdateNoPost              = Tarea de posprocesamiento no encontrada
	UpdateUnpacking           = Descomprimiendo
	UpdateDone                = Actualizado con éxito!
	UpdateDoneRefresh         = Una vez completada la actualización, se realiza el procesamiento de la función.
	UpdateUpdateStop          = Se produjo un error al descargar la actualización y se canceló el proceso de actualización.
	UpdateInstall             = ¿Quieres instalar esta actualización?
	UpdateInstallSel          = Sí, se instalarán las actualizaciones anteriores.\nNo, la actualización no se instalará.
	UpdateNotSatisfied        = \n  No se cumplen los requisitos mínimos de versión del programa de actualización, \n\n  Versión mínima requerida: {0}\n\n  Por favor descargue nuevamente.\n\n  Se ha cancelado la búsqueda de actualizaciones.\n

	IsAllowSHA256Check        = Permitir verificación de hash SHA256
	GetSHAFailed              = No se pudo obtener el hash para compararlo con el archivo descargado.
	Verify_Done               = Verificación exitosa.
	Verify_Failed             = Verificación fallida; el hash no coincide.

	Auto_Update_Allow         = Permitir comprobaciones automáticas de actualizaciones en segundo plano
	Auto_Update_New_Allow     = Al detectar nuevas actualizaciones, permitir las actualizaciones automáticas.
	Auto_Check_Time           = Horas, intervalo entre comprobaciones automáticas
	Auto_Last_Check_Time      = Hora de la última comprobación de actualización automática
	Auto_Next_Check_Time      = No más de {0} horas, hora de la próxima comprobación
	Auto_First_Check          = No se realizó ninguna comprobación de actualización; se realizará la primera comprobación de actualización
	Auto_Update_Last_status   = Estado de la última actualización
	Auto_Update_IsLatest      = Ya estás usando la última versión.

	SearchOrder               = Orden de búsqueda
	SearchOrderTips           = Orden de búsqueda\n  Si se cumplen [ 1.  2. ] condiciones, la búsqueda se detiene; de ​lo contrario, continúa.\n\n\n1. Número de índice\n   Buscar [ Añadir origen ]\\Personalizado\\[ Coincide con el número de índice montado actualmente ]. Si se encuentra una coincidencia, añadir el archivo y detener la búsqueda.\n\n2. Bandera de imagen\n   Buscar [ Añadir origen ]\\Personalizado\\[ Obtener la bandera de la imagen montada actualmente ]. Si se encuentra una coincidencia, añadir el archivo y detener la búsqueda.\n\n3. Otro\n   Si no se cumple ninguna de las 12 condiciones, se añaden todos los archivos del origen de forma predeterminada ( excepto el directorio personalizado dentro del origen ).
'@