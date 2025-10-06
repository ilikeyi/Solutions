ConvertFrom-StringData -StringData @'
	# ru-RU
	# Russian (Russia)

	Prerequisites                   = Предварительные условия
	Check_PSVersion                 = Проверьте версию PS 5.1 и выше.
	Check_OSVersion                 = Проверьте версию Windows > 10.0.16299.0.
	Check_Higher_elevated           = Проверка должна быть повышена до более высоких привилегий
	Check_execution_strategy        = Проверьте стратегию исполнения

	Check_Pass                      = Проходить
	Check_Did_not_pass              = Неуспешный
	Check_Pass_Done                 = Поздравляю, прошло.
	How_solve                       = Как решить
	UpdatePSVersion                 = Пожалуйста, установите последнюю версию PowerShell.
	UpdateOSVersion                 = 1. Перейдите на официальный сайт Microsoft, чтобы загрузить последнюю версию операционной системы.\n    2. Установите последнюю версию операционной системы и повторите попытку.
	HigherTermail                   = 1. Откройте терминал или PowerShell ISE от имени администратора, \n       Установите политику выполнения PowerShell: Обход, командная строка PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. После решения повторите команду.
	HigherTermailAdmin              = 1. Откройте терминал или PowerShell ISE от имени администратора. \n     2. После решения повторите команду.
	LowAndCurrentError              = Минимальная версия: {0}, текущая версия: {1}.
	Check_Eligible                  = Имеющий право
	Check_Version_PSM_Error         = Ошибка версии. См. пример {0}.psm1.Example, повторно обновите {0}.psm1 и повторите попытку.

	Check_OSEnv                     = Проверка системной среды
	Check_Image_Bad                 = Проверьте, не повреждено ли загруженное изображение
	Check_Need_Fix                  = Сломанные предметы, которые необходимо починить
	Image_Mount_Mode                = Режим монтирования
	Image_Mount_Status              = Статус монтирования
	Check_Compatibility             = Проверка совместимости
	Check_Duplicate_rule            = Проверьте наличие повторяющихся записей правил.
	Duplicates                      = Повторить
	ISO_File                        = ISO-файл
	ISO_Langpack                    = Языковой пакет ISO
'@