ConvertFrom-StringData -StringData @'
	# uk-UA
	# Ukrainian (Ukraine)

	Prerequisites                   = передумови
	Check_PSVersion                 = Перевірте PS версії 5.1 і вище
	Check_OSVersion                 = Перевірте версію Windows > 10.0.16299.0
	Check_Higher_elevated           = Чек повинен бути підвищений до вищих привілеїв
	Check_execution_strategy        = Перевірити стратегію виконання

	Check_Pass                      = пропуск
	Check_Did_not_pass              = не вдалося
	Check_Pass_Done                 = Вітаю, пройдено.
	How_solve                       = Як вирішити
	UpdatePSVersion                 = Установіть останню версію PowerShell
	UpdateOSVersion                 = 1. Перейдіть на офіційний сайт Microsoft, щоб завантажити останню версію операційної системи\n    2. Установіть останню версію операційної системи та повторіть спробу
	HigherTermail                   = 1. Відкрийте термінал або PowerShell ISE як адміністратор, \n       Налаштуйте політику виконання PowerShell: обхід, командний рядок PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. Після вирішення повторно запустіть команду.
	HigherTermailAdmin              = 1. Відкрийте термінал або PowerShell ISE як адміністратор. \n     2. Після вирішення повторно запустіть команду.
	LowAndCurrentError              = Мінімальна версія: {0}, поточна версія: {1}
	Check_Eligible                  = Придатний
	Check_Version_PSM_Error         = Помилка версії, зверніться до {0}.psm1. Наприклад, повторно оновіть {0}.psm1 і повторіть спробу.

	Check_OSEnv                     = Перевірка системного середовища
	Check_Image_Bad                 = Перевірте, чи не пошкоджено завантажене зображення
	Check_Need_Fix                  = Зламані предмети, які потребують ремонту
	Image_Mount_Mode                = режим монтування
	Image_Mount_Status              = Статус монтування
	Check_Compatibility             = Перевірка сумісності
	Check_Duplicate_rule            = Перевірте наявність дублікатів правил
	Duplicates                      = повторити
	ISO_File                        = файл ISO
	ISO_Langpack                    = Мовний пакет ISO
'@