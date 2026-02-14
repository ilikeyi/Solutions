ConvertFrom-StringData -StringData @'
	# sr-latn-rs
	# Serbian (Latin, Serbia)

	Prerequisites                   = Предуслови
	Check_PSVersion                 = Проверите ПС верзију 5.1 и новију
	Check_OSVersion                 = Проверите верзију Виндовс-а > 10.0.16299.0
	Check_Higher_elevated           = Провера мора бити подигнута на више привилегије
	Check_execution_strategy        = Проверите стратегију извршења

	Check_Pass                      = Проћи
	Check_Did_not_pass              = Пропао
	Check_Pass_Done                 = Честитам, прошао.
	How_solve                       = Како решити
	UpdatePSVersion                 = Инсталирајте најновију верзију ПоверСхелл-а
	UpdateOSVersion                 = 1. Идите на Мицрософтову званичну веб локацију да бисте преузели најновију верзију оперативног система\n    2. Инсталирајте најновију верзију оперативног система и покушајте поново
	HigherTermail                   = 1. Отворите Терминал или ПоверСхелл ИСЕ као администратор, \n       Подесите политику извршавања ПоверСхелл-а: Заобиђите, ПС командна линија: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Када се реши, поново покрените команду.
	HigherTermailAdmin              = 1. Отворите Терминал или ПоверСхелл ИСЕ као администратор. \n    2. Када се реши, поново покрените команду.
	LowAndCurrentError              = Минимална верзија: {0}, тренутна верзија: {1}
	Check_Eligible                  = Подобно
	Check_Version_PSM_Error         = Грешка у верзији, погледајте {0}.psm1.Example, ре-упграде {0}.psm1 Покушајте поново касније.

	Check_OSEnv                     = Провера системског окружења
	Check_Image_Bad                 = Проверите да ли је учитана слика оштећена
	Check_Need_Fix                  = Поломљени предмети које треба поправити
	Image_Mount_Mode                = Режим монтирања
	Image_Mount_Status              = Статус монтирања
	Check_Compatibility             = Провера компатибилности
	Check_Duplicate_rule            = Проверите да ли има дуплих уноса правила
	Duplicates                      = Поновити
	ISO_File                        = ISO документ
	ISO_Langpack                    = ISO Језички пакет
'@