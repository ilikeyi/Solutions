ConvertFrom-StringData -StringData @'
	# ar-sa
	# Arabic (Saudi Arabia)

	ChkUpdate                 = التحقق من وجود تحديثات
	UpdateServerSelect        = اختيار الخادم التلقائي أو الاختيار المخصص
	UpdateServerNoSelect      = الرجاء تحديد الخادم المتاح
	UpdateSilent              = قم بالتحديث بصمت عند توفر التحديثات
	UpdateClean               = السماح بتنظيف الإصدارات القديمة في أوقات الفراغ
	UpdateReset               = إعادة تعيين هذا الحل
	UpdateResetTips           = عندما يتوفر عنوان التنزيل، يتم فرض التنزيل وتحديثه تلقائيًا.
	UpdateCheckServerStatus   = التحقق من حالة الخادم ( يتوفر {0} من الخيارات )
	UpdateServerAddress       = عنوان الخادم
	UpdatePriority            = تم تعيينها بالفعل كأولوية
	UpdateServerTestFailed    = فشل اختبار حالة الخادم
	UpdateQueryingUpdate      = الاستعلام عن التحديثات...
	UpdateQueryingTime        = جارٍ التحقق لمعرفة ما إذا كان الإصدار الأحدث متاحًا، استغرق الاتصال {0} مللي ثانية.
	UpdateConnectFailed       = غير قادر على الاتصال بالخادم البعيد، تم إحباط البحث عن التحديثات.
	UpdateREConnect           = فشل الاتصال، جارٍ إعادة المحاولة للمرة {0}/{1}.
	UpdateMinimumVersion      = يلبي الحد الأدنى من متطلبات إصدار المحدث، الحد الأدنى من الإصدار المطلوب: {0}
	UpdateVerifyAvailable     = عنوان التحقق متاح
	Download                  = تحميل
	UpdateDownloadAddress     = عنوان التحميل
	UpdateAvailable           = متاح
	UpdateUnavailable         = غير متوفر
	UpdateCurrent             = تستخدم حاليا النسخة
	UpdateLatest              = أحدث إصدار متاح
	UpdateNewLatest           = اكتشاف الإصدارات الجديدة المتاحة!
	UpdateSkipUpdateCheck     = سياسة تم تكوينها مسبقًا لعدم السماح بتشغيل التحديثات التلقائية لأول مرة.
	UpdateTimeUsed            = الوقت الذي يقضيه
	UpdatePostProc            = معالجة ما بعد
	UpdateNotExecuted         = لم يتم تنفيذه
	UpdateNoPost              = لم يتم العثور على مهمة ما بعد المعالجة
	UpdateUnpacking           = فك الضغط
	UpdateDone                = تم التحديث بنجاح!
	UpdateDoneRefresh         = بعد اكتمال التحديث، يتم تنفيذ معالجة الوظيفة.
	UpdateUpdateStop          = حدث خطأ أثناء تنزيل التحديث وتم إحباط عملية التحديث.
	UpdateInstall             = هل تريد تثبيت هذا التحديث؟
	UpdateInstallSel          = نعم، سيتم تثبيت التحديث أعلاه\nلا، لن يتم تثبيت التحديث
	UpdateNotSatisfied        = \n  عدم استيفاء الحد الأدنى من متطلبات إصدار برنامج التحديث،\n\n  الحد الأدنى للإصدار المطلوب {0}\n\n  يرجى إعادة التنزيل.\n\n  تم إحباط التحقق من وجود تحديثات.\n

	IsAllowSHA256Check        = السماح بالتحقق من تجزئة SHA256
	GetSHAFailed              = تعذر استرداد التجزئة للمقارنة مع الملف الذي تم تنزيله.
	Verify_Done               = تم التحقق بنجاح.
	Verify_Failed             = فشل التحقق، عدم تطابق التجزئة.

	Auto_Update_Allow         = السماح بفحص التحديثات التلقائية في الخلفية
	Auto_Update_New_Allow     = السماح بالتحديثات التلقائية عند اكتشاف تحديثات جديدة
	Auto_Check_Time           = الساعات, فترة الفحص التلقائي
	Auto_Last_Check_Time      = آخر وقت لفحص التحديثات التلقائية
	Auto_Next_Check_Time      = قبل {0} ساعة على الأكثر، وقت الفحص التالي
	Auto_First_Check          = لم يتم إجراء أي فحص للتحديثات، سيتم إجراء أول فحص للتحديثات
	Auto_Update_Last_status   = حالة آخر تحديث
	Auto_Update_IsLatest      = إنها بالفعل أحدث نسخة.

	SearchOrder               = ترتيب البحث
	SearchOrderTips           = ترتيب البحث\n  إذا تحققت الشروط الـ [ 1.  2. ]، يتوقف البحث؛ وإلا يستمر.\n\n\n1. رقم الفهرس\n   ابحث عن [إضافة مصدر]\\Custom\\[يطابق رقم الفهرس المُثبَّت حاليًا]. إذا تم العثور على تطابق، أضف الملف وأوقف البحث.\n\n2. علامة الصورة\n   ابحث عن [إضافة مصدر]\\Custom\\[احصل على علامة الصورة المُثبَّتة حاليًا]. إذا تم العثور على تطابق، أضف الملف وأوقف البحث.\n\n3. أخرى\n   إذا لم يتحقق أي من الشروط الـ 12، تُضاف جميع الملفات من المصدر افتراضيًا (باستثناء مجلد Custom داخل المصدر).
'@