ConvertFrom-StringData -StringData @'
	# he-IL
	# Hebrew (Israel)

	AdvAppsDetailed                 = הפק דוח
	AdvAppsDetailedTips             = חפש לפי תג אזור, קבל פרטים נוספים כאשר חבילות חוויית שפה מקומיות זמינות, והפק קובץ דוח: *.CSV.
	ProcessSources                  = מקור עיבוד
	InboxAppsManager                = אפליקציית Inbox
	InboxAppsMatchDel               = מחק לפי התאמה של כללים
	InboxAppsOfflineDel             = מחק יישום שהוקצה
	InboxAppsClear                  = כפוי הסרה של כל האפליקציות המותקנות מראש ( InBox Apps )
	InBox_Apps_Match                = התאם יישומי InBox Apps
	InBox_Apps_Check                = בדוק חבילות תלות
	InBox_Apps_Check_Tips           = על פי הכללים, השג את כל פריטי ההתקנה שנבחרו וודא אם פריטי ההתקנה התלויים נבחרו.
	LocalExperiencePack             = חבילות חוויית שפה מקומית
	LEPBrandNew                     = בצורה חדשה, מומלץ
	UWPAutoMissingPacker            = חפש אוטומטית חבילות חסרות מכל הדיסקים
	UWPAutoMissingPackerSupport     = ארכיטקטורת x64, יש להתקין חבילות חסרות.
	UWPAutoMissingPackerNotSupport  = ארכיטקטורה שאינה x64, משמשת כאשר רק ארכיטקטורת x64 נתמכת.
	UWPEdition                      = מזהה ייחודי של גרסת Windows
	Optimize_Appx_Package           = בצע אופטימיזציה של הקצאת חבילות Appx על ידי החלפת קבצים זהים בקישורים קשיחים
	Optimize_ing                    = אופטימיזציה
	Remove_Appx_Tips                = לְהַדגִים:\n\nשלב ראשון: הוסף חבילות חוויית שפה מקומית ( LXPs ) שלב זה חייב להתאים לחבילה המתאימה שפורסמה רשמית על ידי מיקרוסופט.\n       הוסף חבילות שפה לתמונות מרובי הפעלות של Windows 10\n       https://learn.microsoft.com/he-il/azure/virtual-desktop/language-packs\n\n       הוסף שפות לתמונות Windows 11 Enterprise\n       https://learn.microsoft.com/he-il/azure/virtual-desktop/windows-11-language-packs\n\nשלב 2: פתח או התקן את *_InboxApps.iso, ובחר את הספרייה בהתאם לארכיטקטורה;\n\nשלב 3: אם מיקרוסופט לא פרסמה רשמית את חבילת חוויית השפה המקומית האחרונה ( LXPs ), דלג על שלב זה אם כן: עיין בהודעה הרשמית של מיקרוסופט:\n       1. התאמה לחבילות חוויית שפה מקומית ( LXPs );\n       2. התאמה לעדכונים מצטברים. \n\nאפליקציות מותקנות מראש ( InBox Apps ) הן בשפה אחת ויש להתקין אותן מחדש כדי לקבל ריבוי שפות. \n\n1. ניתן לבחור בין גרסת מפתח לגרסה ראשונית;\n    גרסת מפתחים, למשל, מספר הגרסה הוא: \n    Windows 11 סִדרָה\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    גרסה ראשונית, גרסה ראשונית ידועה: \n    Windows 11 סִדרָה\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 סִדרָה\n    Windows 10 22H2, Build 19045.2006\n\n    חָשׁוּב: \n      a. אנא צור מחדש את התמונה כאשר כל גרסה מתעדכנת. לדוגמה, בעת מעבר מ-21H1 ל-22H2, נא לא לעדכן על סמך התמונה הישנה כדי למנוע בעיות תאימות אחרות. שוב, אנא השתמש בגרסה הראשונית.\n      b. תקנה זו נמסרה בבירור לאריזות בצורות שונות על ידי חלק מיצרני OEM, ושדרוגים ישירים מגרסאות איטרטיביות אינם מותרים.\n      מילות מפתח: איטרציה, גרסה צולבת, עדכון מצטבר.\n\n2. לאחר התקנת ערכת השפה, עליך להוסיף עדכון מצטבר, מכיוון שלפני הוספת העדכון המצטבר, לא יהיו שינויים חדשים ברכיב עד להתקנת העדכון המצטבר. מיושן, להימחק;\n\n3. בעת שימוש בגרסה עם עדכונים מצטברים, עדיין צריך להוסיף עדכונים מצטברים שוב בסופו של דבר, שזו פעולה חוזרת;\n\n4. לכן, מומלץ להשתמש בגרסה ללא עדכונים מצטברים במהלך הייצור, ולאחר מכן להוסיף עדכונים מצטברים בשלב האחרון. \n\nתנאי חיפוש לאחר בחירת הספרייה: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = לאחר החילוץ, קובץ ה-ISO המותקן יופיע. כללים: 
	ImportCleanDuplicate            = נקה קבצים כפולים
	ForceRemovaAllUWP               = דלג על תוספת חבילת חוויית שפה מקומית ( LXPs ), בצע אחר
	LEPSkipAddEnglish               = מומלץ לדלג על הוספת en-US במהלך ההתקנה.
	LEPSkipAddEnglishTips           = ערכת ברירת המחדל של השפה האנגלית אינה נחוצה כדי להוסיף אותה.
	License                         = תְעוּדָה
	IsLicense                       = יש תעודה
	NoLicense                       = אין תעודה
	CurrentIsNVeriosn               = סדרת גרסת N
	CurrentNoIsNVersion             = גרסה פונקציונלית מלאה
	LXPsWaitAddUpdate               = להתעדכן
	LXPsWaitAdd                     = יש להוסיף
	LXPsWaitAssign                  = יש להקצות
	LXPsWaitRemove                  = להימחק
	LXPsAddDelTipsView              = יש טיפים חדשים, בדוק עכשיו
	LXPsAddDelTipsGlobal            = אין יותר הנחיות, סנכרן לגלובל
	LXPsAddDelTips                  = אל תבקש שוב
	Instl_Dependency_Package        = אפשר הרכבה אוטומטית של תלות בעת התקנת InBox Apps
	Instl_Dependency_Package_Tips   = כאשר לאפליקציה שיש להוסיף יש חבילות תלויות, היא תתאים אוטומטית לפי הכללים ותשלים את הפונקציה של שילוב אוטומטי של החבילות התלויות הנדרשות.
	Instl_Dependency_Package_Match  = שילוב חבילות תלות
	Instl_Dependency_Package_Group  = קוֹמבִּינַצִיָה
	InBoxAppsErrorNoSave            = כאשר נתקלים בטעות, אסור להישמר לו
	InBoxAppsErrorTips              = יש שגיאות, הפריט שנתקל בפריט ההתאמה {0} לא הצליח
	InBoxAppsErrorNo                = בהתאמה לא נמצאו שגיאות בהתאמה
'@