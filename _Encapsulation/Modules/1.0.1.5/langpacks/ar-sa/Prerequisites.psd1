ConvertFrom-StringData -StringData @'
	# ar-sa
	# Arabic (Saudi Arabia)

	Prerequisites                   = المتطلبات الأساسية
	Check_PSVersion                 = تحقق من إصدار PS 5.1 وما فوق
	Check_OSVersion                 = تحقق من إصدار Windows> 10.0.16299.0
	Check_Higher_elevated           = يجب أن يتم رفع الشيك إلى امتيازات أعلى
	Check_execution_strategy        = التحقق من استراتيجية التنفيذ

	Check_Pass                      = يمر
	Check_Did_not_pass              = فشل
	Check_Pass_Done                 = مبروك، مرت.
	How_solve                       = كيفية الحل
	UpdatePSVersion                 = الرجاء تثبيت أحدث إصدار من PowerShell
	UpdateOSVersion                 = 1. انتقل إلى موقع Microsoft الرسمي لتنزيل أحدث إصدار من نظام التشغيل\n    2. قم بتثبيت أحدث إصدار من نظام التشغيل وحاول مرة أخرى
	HigherTermail                   = 1. افتح Terminal أو PowerShell ISE كمسؤول،\n       تعيين سياسة تنفيذ PowerShell: التجاوز، سطر أوامر PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. بمجرد حلها، أعد تشغيل الأمر.
	HigherTermailAdmin              = 1. افتح Terminal أو PowerShell ISE كمسؤول، \n     2. بمجرد حلها، أعد تشغيل الأمر.
	LowAndCurrentError              = الحد الأدنى للإصدار: {0}، الإصدار الحالي: {1}
	Check_Eligible                  = صالح
	Check_Version_PSM_Error         = خطأ في الإصدار، يرجى الرجوع إلى {0}.psm1. على سبيل المثال، أعد ترقية {0}.psm1 وحاول مرة أخرى.

	Check_OSEnv                     = فحص بيئة النظام
	Check_Image_Bad                 = تحقق مما إذا كانت الصورة المحملة تالفة
	Check_Need_Fix                  = العناصر المكسورة التي تحتاج إلى إصلاح
	Image_Mount_Mode                = وضع التثبيت
	Image_Mount_Status              = حالة جبل
	Check_Compatibility             = التحقق من التوافق
	Check_Duplicate_rule            = التحقق من وجود إدخالات القاعدة المكررة
	Duplicates                      = يكرر
	ISO_File                        = ISO وثيقة
	ISO_Langpack                    = ISO حزمة اللغة
'@