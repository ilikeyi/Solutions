ConvertFrom-StringData -StringData @'
	# he-IL
	# Hebrew (Israel)

	Prerequisites                   = דרישות מוקדמות
	Check_PSVersion                 = בדוק PS גרסה 5.1 ומעלה
	Check_OSVersion                 = בדוק את גרסת Windows > 10.0.16299.0
	Check_Higher_elevated           = יש להעלות את ההמחאה להרשאות גבוהות יותר
	Check_execution_strategy        = בדוק אסטרטגיית ביצוע

	Check_Pass                      = לַעֲבוֹר
	Check_Did_not_pass              = נִכשָׁל
	Check_Pass_Done                 = מזל טוב, עבר.
	How_solve                       = איך לפתור
	UpdatePSVersion                 = אנא התקן את גרסת PowerShell העדכנית ביותר
	UpdateOSVersion                 = 1. עבור לאתר הרשמי של מיקרוסופט כדי להוריד את הגרסה העדכנית ביותר של מערכת ההפעלה\n    2. התקן את הגרסה העדכנית ביותר של מערכת ההפעלה ונסה שוב
	HigherTermail                   = 1. פתח את Terminal או PowerShell ISE כמנהל, \n       הגדר מדיניות ביצוע של PowerShell: עוקף, שורת פקודה PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n    2. לאחר פתרון, הפעל מחדש את הפקודה.
	HigherTermailAdmin              = 1. פתח את Terminal או PowerShell ISE כמנהל. \n     2. לאחר פתרון, הפעל מחדש את הפקודה.
	LowAndCurrentError              = גרסה מינימלית: {0}, גרסה נוכחית: {1}
	Check_Eligible                  = כשיר
	Check_Version_PSM_Error         = שגיאת גרסה, עיין ב-{0}.psm1. לדוגמה, שדרג מחדש את {0}.psm1 ונסה שוב.

	Check_OSEnv                     = בדיקת סביבת המערכת
	Check_Image_Bad                 = בדוק אם התמונה שנטענה פגומה
	Check_Need_Fix                  = פריטים שבורים שצריך לתקן
	Image_Mount_Mode                = מצב הרכבה
	Image_Mount_Status              = מצב הר
	Check_Compatibility             = בדיקת תאימות
	Check_Duplicate_rule            = בדוק אם יש ערכי כללים כפולים
	Duplicates                      = לַחֲזוֹר עַל
	ISO_File                        = קובץ ISO
	ISO_Langpack                    = ערכת שפה ISO
'@