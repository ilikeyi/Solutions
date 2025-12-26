ConvertFrom-StringData -StringData @'
	# es-ES
	# Spanish (Spain)

	AdvAppsDetailed                 = Generar informe
	AdvAppsDetailedTips             = Busque por etiqueta de región, obtenga más detalles cuando los paquetes de experiencia en el idioma local estén disponibles y genere un archivo de informe: *.CSV.
	ProcessSources                  = Fuente de procesamiento
	InboxAppsManager                = Aplicación de bandeja de entrada
	InboxAppsMatchDel               = Eliminar por reglas coincidentes
	InboxAppsOfflineDel             = Eliminar una aplicación aprovisionada
	InboxAppsClear                  = Forzar la eliminación de todas las aplicaciones previas instaladas ( InBox Apps )
	InBox_Apps_Match                = Coincidir con las aplicaciones de la bandeja de entrada
	InBox_Apps_Check                = Verificar paquetes de dependencia
	InBox_Apps_Check_Tips           = De acuerdo con las reglas, obtenga todos los elementos de instalación seleccionados y verifique si se han seleccionado los elementos de instalación dependientes.
	LocalExperiencePack             = Paquetes de experiencia en idiomas locales
	LEPBrandNew                     = De una manera nueva, recomendado.
	UWPAutoMissingPacker            = Busque automáticamente paquetes faltantes en todos los discos
	UWPAutoMissingPackerSupport     = Arquitectura x64, es necesario instalar los paquetes que faltan.
	UWPAutoMissingPackerNotSupport  = Arquitectura que no es x64, se utiliza cuando solo se admite la arquitectura x64.
	UWPEdition                      = Identificador único de la versión de Windows
	Optimize_Appx_Package           = Optimice el aprovisionamiento de paquetes Appx reemplazando archivos idénticos con enlaces físicos
	Optimize_ing                    = Optimización
	Remove_Appx_Tips                = Ilustrar:\n\nPaso uno: Agregar paquetes de experiencia en el idioma local ( LXPs ). Este paso debe corresponder al paquete correspondiente publicado oficialmente por Microsoft. Vaya aquí y descárguelo:\n       Agregue paquetes de idiomas a imágenes multisesión de Windows 10\n       https://learn.microsoft.com/es-es/azure/virtual-desktop/language-packs\n\n       Agregue idiomas a las imágenes de Windows 11 Enterprise\n       https://learn.microsoft.com/es-es/azure/virtual-desktop/windows-11-language-packs\n\nPaso 2: descomprima o monte *_InboxApps.iso y seleccione el directorio según la arquitectura;\n\nPaso 3: Si Microsoft no ha lanzado oficialmente el último paquete de experiencia en idioma local ( LXPs ), omita este paso si es así: consulte el anuncio oficial de Microsoft: \n       1. Correspondiente a paquetes de experiencia en el idioma local ( LXPs );\n       2. Correspondientes a actualizaciones acumulativas. \n\nLas aplicaciones preinstaladas ( InBox Apps ) son de un solo idioma y deben reinstalarse para obtener varios idiomas. \n\n1. Puedes elegir entre la versión de desarrollador y la versión inicial;\n    Versión de desarrollador, por ejemplo, el número de versión es: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Versión inicial, versión inicial conocida: \n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    importante:\n      a. Vuelva a crear la imagen cuando se actualice cada versión. Por ejemplo, al pasar de 21H1 a 22H2, no actualice según la imagen anterior para evitar otros problemas de compatibilidad. Nuevamente, utilice la versión inicial.\n      b. Algunos fabricantes OEM han comunicado claramente esta regulación a los empaquetadores de diversas formas, y no se permiten actualizaciones directas desde versiones iterativas.\n      Palabras clave: iteración, versión cruzada, actualización acumulativa.\n\n2. Después de instalar el paquete de idioma, debe agregar una actualización acumulativa, porque antes de que se agregue la actualización acumulativa, el componente no tendrá ningún cambio hasta que se instale la actualización acumulativa. obsoleto, para ser eliminado;\n\n3. Cuando utilice una versión con actualizaciones acumulativas, aún tendrá que agregar actualizaciones acumulativas nuevamente al final, lo cual es una operación repetida;\n\n4. Por lo tanto, se recomienda utilizar una versión sin actualizaciones acumulativas durante la producción y luego agregar actualizaciones acumulativas en el último paso. \n\nCondiciones de búsqueda después de seleccionar el directorio: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = Tras la extracción, aparecerá la imagen ISO montada. Reglas: 
	ImportCleanDuplicate            = Limpiar archivos duplicados
	ForceRemovaAllUWP               = Omita la adición del paquete de experiencia en el idioma local ( LXPs ), realice otras
	LEPSkipAddEnglish               = Se recomienda omitir la adición de en-US durante la instalación.
	LEPSkipAddEnglishTips           = No es necesario agregar el paquete de idioma inglés predeterminado.
	License                         = Certificado
	IsLicense                       = Tener certificado
	NoLicense                       = Sin certificado
	CurrentIsNVeriosn               = Serie versión N
	CurrentNoIsNVersion             = Versión completamente funcional
	LXPsWaitAddUpdate               = Para ser actualizado
	LXPsWaitAdd                     = Para ser agregado
	LXPsWaitAssign                  = Para ser asignado
	LXPsWaitRemove                  = Para ser eliminado
	LXPsAddDelTipsView              = Hay nuevos consejos, compruébalo ahora.
	LXPsAddDelTipsGlobal            = No más mensajes, sincroniza con global
	LXPsAddDelTips                  = No volver a preguntar
	Instl_Dependency_Package        = Permitir el ensamblaje automático de paquetes dependientes al instalar InBox Apps
	Instl_Dependency_Package_Tips   = Cuando la aplicación que se agregará tiene paquetes dependientes, coincidirá automáticamente de acuerdo con las reglas y completará la función de combinar automáticamente los paquetes dependientes requeridos.
	Instl_Dependency_Package_Match  = Combinando paquetes de dependencia
	Instl_Dependency_Package_Group  = Combinación
	InBoxAppsErrorNoSave            = Al encontrar un error, no se le permite salvarse
	InBoxAppsErrorTips              = Hay errores, el elemento encontrado en el elemento de coincidencia {0} no tuvo éxito
	InBoxAppsErrorNo                = No se encontraron errores en la coincidencia
'@