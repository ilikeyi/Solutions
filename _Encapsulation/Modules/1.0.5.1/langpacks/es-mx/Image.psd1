ConvertFrom-StringData -StringData @'
	# es-mx
	# Spanish (Mexico)

	SaveModeClear                   = Borrar historial seleccionado
	SaveModeTipsClear               = El historial se ha guardado y se puede borrar.
	SelectTips                      = Pista\n\n    1. Seleccione el nombre de la imagen a procesar;\n    2. Después de cancelar, las tareas que requieren "montaje" antes de la operación ya no tendrán efecto.
	CacheDisk                       = Caché de disco
	CacheDiskCustomize              = Ruta de caché personalizada
	AutoSelectRAMDISK               = Permitir la selección automática de etiquetas de volumen de disco
	AutoSelectRAMDISKFailed         = La etiqueta de volumen no coincide
	ReFS_Find_Volume                = Cuando se encuentre el formato de disco REFS, excluya
	ReFS_Exclude                    = Partición ReFS excluida
	Disk_Not_satisfied_Exclude      = No se cumplen los requisitos mínimos de disco
	RAMDISK_Change                  = Cambiar el nombre de la etiqueta del volumen
	RAMDISK_Search                  = Buscar nombre de etiqueta de volumen
	RAMDISK_Restore                 = Restaurar el nombre del volumen inicializado: {0}
	AllowTopMost                    = Permitir que las ventanas abiertas se fijen en la parte superior
	History                         = Borrar historia
	History_Del_Tips                = Cuando haya una tarea de encapsulación, no ejecute las siguientes opciones opcionales; de lo contrario, causará problemas desconocidos durante la ejecución del script de encapsulación.
	History_View                    = Ver historial
	HistoryLog                      = Permitir la limpieza automática de registros de más de 7 días
	HistorySaveFolder               = Otras rutas de origen de imágenes
	HistoryClearappxStage           = InBox Apps: elimine los archivos temporales generados durante la instalación
	DoNotCheckBoot                  = Cuando el tamaño del archivo Boot.wim supera los 520 MB, la reconstrucción se selecciona automáticamente al generar la ISO.
	HistoryClearDismSave            = Eliminar registros de montaje DISM guardados en el registro
	ImageSourcesClickShowKey        = Permitir la visualización del menú "Seleccionar clave principal"
	ImageSourcesClickShowKeyTips    = Después de que el usuario seleccione la fuente de la imagen: Agregue un menú "Seleccionar clave principal" a la derecha y añada las opciones "Ir a": Montar, Guardar, Ventana emergente.
	Clear_Bad_Mount                 = Elimine todos los recursos asociados con la imagen montada dañada
	ShowCommand                     = Mostrar la ejecución completa de la línea de comando
	Command                         = Línea de comando
	SelectSettingImage              = Fuente de imagen
	NoSelectImageSource             = No se seleccionó ninguna fuente de imagen
	SettingImageRestore             = Restaurar la ubicación de montaje predeterminada
	SettingImage                    = Cambiar la ubicación de montaje de la fuente de la imagen
	SelectImageMountStatus          = Obtener el estado de montaje después de seleccionar la fuente de la imagen
	SettingImageTempFolder          = Directorio temporal
	SettingImageToTemp              = El directorio temporal es el mismo que la ubicación donde se montó.
	SettingImagePathTemp            = Usando el directorio temp
	SettingImageLow                 = Consulta el espacio restante mínimo disponible
	SettingImageNewPath             = Seleccione montar disco
	SettingImageNewPathTips         = Se recomienda montarlo en un disco de memoria, que es el más rápido. Puede utilizar software de memoria virtual como Ultra RAMDisk e ImDisk.
	SelectImageSource               = Se ha seleccionado "Implementar solución de motor", haga clic en Aceptar.
	NoImagePreSource                = No se encontró ninguna fuente disponible, usted debe: \n\n     1. Agregue más fuentes de imágenes a: \n          {0}\n\n     2. Seleccione "Configuración" y vuelva a seleccionar el disco de búsqueda de fuente de imagen;\n\n     3. Seleccione "ISO" y seleccione el ISO a descomprimir, elementos a montar, etc.
	NoImageOtherSource              = Haga clic en mí para "Agregar" otras rutas o "Arrastrar directorio" a la ventana actual.
	SearchImageSource               = Disco de búsqueda de fuente de imagen
	Kernel                          = Núcleo
	Architecture                    = Arquitectura
	ArchitecturePack                = Arquitectura de paquetes, comprensión de la adición de reglas
	ImageLevel                      = Tipo de instalación
	LevelDesktop                    = De oficina
	LevelServer                     = Servidor
	ImageCodename                   = Nombre en clave
	ImageCodenameNo                 = No reconocido
	MainImageFolder                 = Directorio de inicio
	MountImageTo                    = Montar a
	Image_Path                      = Ruta de la imagen
	MountedIndex                    = Índice
	MountedIndexSelect              = Seleccionar número de índice
	AutoSelectIndexFailed           = Error en la selección automática del índice {0}. Vuelva a intentarlo.
	Apply                           = Solicitud
	Eject                           = Surgir
	Mount                           = Montar
	Unmount                         = Desinstalar
	Mounted                         = Montado
	NotMounted                      = No montado
	NotMountedSpecify               = No montado, puede especificar la ubicación de montaje
	MountedIndexError               = Montaje anormal, elimínelo y vuelva a intentarlo.
	ImageSouresNoSelect             = Mostrar más detalles después de seleccionar la fuente de la imagen
	Mounted_Mode                    = Modo de montaje
	Mounted_Status                  = Estado de montaje
	Image_Popup_Default             = Guardar como predeterminado
	Image_Restore_Default           = Volver al valor predeterminado
	Image_Popup_Tips                = Pista: \n\nCuando asignó el evento, no especificó el número de índice para procesar {0};\n\nLa interfaz de selección ha aparecido actualmente. Especifique el número de índice. Una vez completada la especificación, se recomienda seleccionar "Guardar como predeterminado". No volverá a aparecer la próxima vez que la procese.
	Rule_Show_Full                  = Mostrar todo
	Rule_Show_Only                  = Mostrar solo reglas
	Rule_Show_Only_Select           = Elige entre reglas
	Image_Unmount_After             = Desinstalar todo montado

	Wim_Rule_Update                 = Extraer y actualizar archivos dentro de la imagen.
	Wim_Rule_Extract                = Extraer archivos
	Wim_Rule_Extract_Tips           = Después de seleccionar la regla de ruta, extraiga el archivo especificado y guárdelo localmente.

	Wim_Rule_Verify                 = Verificar
	Wim_Rule_Check                  = Examinar
	Wim_Rule_CheckIntegrity         = Comprobar integridad
	Wim_Rule_WIMBoot                = Arrancable
	Wim_Rule_Compact                = Comprimir archivos del sistema operativo
	Win_Rule_Setbootable            = Marcar imagen de volumen como arrancable
	Win_Rule_Setbootable_Tips       = Este parámetro solo se aplica a imágenes de Windows PE.\nSolo se puede marcar una imagen de volumen como arrancable en un archivo .wim.
	Destination                     = Destino

	Wim_Append                      = Añadir
	Wim_Capture                     = Capturar
	Wim_Capture_Tips                = Capturar la imagen de la unidad en un nuevo archivo WIM.
	Wim_Capture_Sources             = Origen de la captura
	Wim_Capture_Sources_Tips        = El directorio capturado contiene todas las subcarpetas y datos.\nNo se puede capturar un directorio vacío. El directorio debe contener al menos un archivo.
	Wim_Config_File                 = Ruta del archivo de configuración ( Exclusiones )
	Wim_Config_Edit                 = Editar
	Wim_Config_Learn                = Estudiar la lista de configuración y el archivo WimScript.ini

	Wim_Rename                      = Modificar información de la imagen
	Wim_Image_Name                  = Nombre de la imagen
	Wim_Image_Description           = Descripción de la imagen
	Wim_Display_Name                = Nombre para mostrar
	Wim_Display_Description         = Mostrar descripción
	Wim_Edition                     = Marca de imagen
	Wim_Edition_Select_Know         = Seleccionar banderas de imagen conocidas
	Wim_CreatedTime                 = Fecha de creación
	Wim_ModifiedTime                = Última modificación
	Wim_FileCount                   = Número de archivos
	Wim_DirectoryCount              = Número de directorios
	Wim_Expander_Space              = Espacio de expansión

	IABSelectNo                     = No se seleccionó ninguna clave principal: Instalar, WinRE, Boot
	Unique_Name                     = Denominación única
	Select_Path                     = Camino
	Setting_Pri_Key                 = Configure este archivo de actualización como plantilla principal
	Pri_Key_Update_To               = Luego actualice a
	Pri_Key_Template                = Establezca este archivo como la plantilla preferida para sincronizar con los elementos seleccionados
	Pri_key_Running                 = La tarea de clave principal se ha sincronizado y se ha omitido.
	ShowAllExclude                  = Mostrar todas las exclusiones obsoletas

	Index_Process_All               = Procesar todos los números de índice conocidos
	Index_Is_Event_Select           = Cuando hay un evento, aparece la interfaz de selección del número de índice.
	Index_Pre_Select                = Número de índice preasignado
	Index_Select_Tips               = Pista: \n\n{0}.wim no está montado actualmente, puedes: \n\n   1. Seleccione "Procesar todos los números de índice conocidos";\n\n   2. Seleccione "Cuando haya un evento, aparecerá la interfaz de selección del número de índice";\n\n   3. Número de índice preespecificado\n      Se especifica el número de índice 6, el número de índice no existe durante el procesamiento y se omite el procesamiento.

	Index_Tips_Custom_Expand        = Grupo: {0}\n\nAl procesar {1}, se debe asignar el número de índice {2}; de lo contrario, no se podrá procesar.\n\nDespués de seleccionar "Sincronizar reglas de actualización con todos los números de índice", solo necesita marcar cualquiera como plantilla principal.

	DefenderExclude                 = Exclusiones de Antivirus de Windows
	DefenderFolder                  = Agregue este directorio a las Exclusiones de Antivirus de Windows.
	DefenderVolume                  = Después de encontrar un nombre de etiqueta de volumen que coincida, agregue este disco a las Exclusiones de Antivirus de Windows.
	DefenderIsAdd                   = Agregado a las Exclusiones de Antivirus de Windows
'@