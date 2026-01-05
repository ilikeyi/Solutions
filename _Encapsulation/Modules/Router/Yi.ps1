[CmdletBinding()]
param
(
	$Language,
	[string]$Guid,
	[switch]$Help,
	[switch]$Update,
	[switch]$Ct,
	[switch]$Logs,
	[switch]$Disk,
	[switch]$Add,
	[switch]$Remove,
	[switch]$Reset,
	[switch]$History,
	[switch]$Sip,
	[switch]$Unpack,
	[switch]$Ceup,
	[switch]$va,
	[switch]$vu,
	[switch]$zip,
	[switch]$Fix,
	[switch]$FixDism,
	[switch]$FixBad,
	[switch]$LXPs,
	[switch]$Mul,
	[switch]$Ys
)

if ($Guid) {
	Out-File -FilePath $Guid -Encoding Ascii
	return
}

<#
	.Language
	.语言
#>
$Global:lang = @()
$Global:IsLang = ""
$AvailableLanguages = @(
	@{
		Region   = "en-US"
		Name     = "English (United States)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Usage: "
			Learn                = "Learn"
			Choose               = "Please choose"
			Reset                = "Reset"
			History              = "Clean up command-line records"
			Add                  = "Add routing functionality, system variables"
			AddOK                = "Added"
			AddDone              = "Add complete"
			Remove               = "Delete"
			RemoveRoute          = "Remove the routing function, system variables"
			RemoveDone           = "Delete successful"
			SIP                  = "System encapsulation"
			VerifyAutopilot      = "Verification: Autonomous Driving Profile"
			VerifyUnattend       = "Verification: Pre-answer template file"
			Unpack               = "pack"
			ChkUpdate            = "Check for updates"
			CreateTemplate       = "Create template"
			CEUP                 = "Create a deployment engine upgrade package"
			zip                  = "All software is packaged in zip compression format"
			Repair               = "Repair"
			All                  = "All"
			HistoryClearDismSave = "Delete DISM mount records saved in the registry"
			Clear_Bad_Mount      = "Delete all resources associated with the corrupted mounted image"
			CleanupLogs          = "Cleaning: Temp files, solution logs, DISM logs"
			CleanupDisk          = "Clean up all temporary disk files"
		}
	}
	@{
		Region   = "ar-SA"
		Name     = "Arabic (Saudi Arabia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "الاستخدام:"
			Learn                = "يذاكر"
			Choose               = "اختر من فضلك"
			Reset                = "إعادة ضبط"
			History              = "مسح سجلات سطر الأوامر"
			Add                  = "إضافة وظيفة التوجيه ، متغير النظام"
			AddOK                = "أضيف"
			AddDone              = "أضف لإكمال"
			Remove               = "يمسح"
			RemoveRoute          = "حذف وظيفة التوجيه ، متغير النظام"
			RemoveDone           = "تم الحذف بنجاح"
			SIP                  = "البرنامج النصي لتغليف النظام"
			VerifyAutopilot      = "التحقق: ملف تعريف القيادة الذاتية"
			VerifyUnattend       = "التحقق: يجب أن يكون ملف قالب الإجابة المسبقة"
			Unpack               = "بالة"
			ChkUpdate            = "تحقق من وجود تحديثات"
			CreateTemplate       = "إنشاء قالب"
			CEUP                 = "إنشاء حزمة ترقية محرك النشر"
			zip                  = "يتم تعبئة جميع البرامج بتنسيق ضغط الرمز البريدي"
			Repair               = "بصلح"
			All                  = "الجميع"
			HistoryClearDismSave = "حذف سجلات تحميل DISM المحفوظة في السجل"
			Clear_Bad_Mount      = "احذف جميع الموارد المرتبطة بالصورة المثبتة التالفة"
			CleanupLogs          = "لتنظيف: الملفات المؤقتة وسجلات الحلول وسجلات DISM"
			CleanupDisk          = "تنظيف كافة ملفات القرص المؤقتة"
		}
	}
	@{
		Region   = "bg-BG"
		Name     = "Bulgarian (Bulgaria)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Използване:"
			Learn                = "Проучване"
			Choose               = "Моля избери"
			Reset                = "нулиране"
			History              = "Изчистване на записите на командния ред"
			Add                  = "Добавяне на функция за маршрутизиране, променлива на системата"
			AddOK                = "Добавено"
			AddDone              = "Добавете към Complete"
			Remove               = "изтрий"
			RemoveRoute          = "Изтриване на функцията за маршрутизиране, променлива на системата"
			RemoveDone           = "Успешно изтрити"
			SIP                  = "Скрипт на системната опаковка"
			VerifyAutopilot      = "Проверка: Профил на автономно шофиране"
			VerifyUnattend       = "Проверка: трябва предварително отговор файл шаблон"
			Unpack               = "Бейл"
			ChkUpdate            = "Провери за актуализации"
			CreateTemplate       = "Създайте шаблон"
			CEUP                 = "Създайте пакет за надграждане на машина за внедряване"
			zip                  = "Целият софтуер e опакован във формат на компресия c цип"
			Repair               = "ремонт"
			All                  = "всичко"
			HistoryClearDismSave = "Изтрийте записите за монтиране на DISM, запазени в системния регистър"
			Clear_Bad_Mount      = "Изтрийте всички ресурси, свързани с повреденото монтирано изображение"
			CleanupLogs          = "Почистване: временни файлове, регистрационни файлове на решения, регистрационни файлове на DISM"
			CleanupDisk          = "Почистете всички временни дискови файлове"
		}
	}
	@{
		Region   = "da-DK"
		Name     = "Danish (Denmark)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Brug:"
			Learn                = "Studere"
			Choose               = "Vælg venligst"
			Reset                = "Nulstil"
			History              = "Ryd kommandolinjeposter"
			Add                  = "Tilføj routingfunktion, systemvariabel"
			AddOK                = "Tilføjet"
			AddDone              = "Tilføj til komplet"
			Remove               = "Slette"
			RemoveRoute          = "Slet routingfunktionen, systemvariabel"
			RemoveDone           = "med succes slettet"
			SIP                  = "Systememballage -script"
			VerifyAutopilot      = "Bekræftelse: Autonom kørselsprofil"
			VerifyUnattend       = "Bekræftelse: skal forhåndsbesvare skabelonfil"
			Unpack               = "Bale"
			ChkUpdate            = "Søg efter opdateringer"
			CreateTemplate       = "Opret skabelon"
			CEUP                 = "Opret en opgraderingspakke til implementeringsmotor"
			zip                  = "Al software er pakket i zip -komprimeringsformat"
			Repair               = "reparation"
			All                  = "alle"
			HistoryClearDismSave = "Slet DISM mount records gemt i registreringsdatabasen"
			Clear_Bad_Mount      = "Slet alle ressourcer forbundet med det beskadigede monterede billede"
			CleanupLogs          = "Oprydning: Temp-filer, løsningslogfiler, DISM-logfiler"
			CleanupDisk          = "Rens alle midlertidige diskfiler"
		}
	}
	@{
		Region   = "de-DE"
		Name     = "German (Germany)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Verwendungszweck:"
			Learn                = "Studie"
			Choose               = "bitte auswählen"
			Reset                = "zurücksetzen"
			History              = "Befehlszeilendatensätze löschen"
			Add                  = "Routing -Funktion hinzufügen, Systemvariable"
			AddOK                = "hinzugefügt"
			AddDone              = "Hinzufügen zum Vervollständigen"
			Remove               = "löschen"
			RemoveRoute          = "Löschen Sie die Routing -Funktion, Systemvariable"
			RemoveDone           = "erfolgreich gelöscht"
			SIP                  = "Systemverpackungsskript"
			VerifyAutopilot      = "Überprüfung: Autonomes Fahrprofil"
			VerifyUnattend       = "Überprüfung: Es sollte eine Vorlagedatei vorab beantwortet werden"
			Unpack               = "Ballen"
			ChkUpdate            = "Auf Updates prüfen"
			CreateTemplate       = "Vorlage erstellen"
			CEUP                 = "Erstellen Sie ein Upgradepaket für die Bereitstellungs-Engine"
			zip                  = "Alle Software ist im ZIP -Komprimierungsformat verpackt"
			Repair               = "Reparatur"
			All                  = "alle"
			HistoryClearDismSave = "Löschen Sie in der Registrierung gespeicherte DISM-Mount-Einträge"
			Clear_Bad_Mount      = "Löschen Sie alle Ressourcen, die mit dem beschädigten gemounteten Image verknüpft sind"
			CleanupLogs          = "Bereinigung: Temporäre Dateien, Lösungsprotokolle, DISM-Protokolle"
			CleanupDisk          = "Bereinigen Sie alle temporären Festplattendateien"
		}
	}
	@{
		Region   = "el-GR"
		Name     = "Greek (Greece)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "χρήση:"
			Learn                = "Μελέτη"
			Choose               = "Παρακαλώ επιλέξτε"
			Reset                = "επαναφορά"
			History              = "Εκκαθάριση εγγραφών γραμμής εντολών"
			Add                  = "Προσθήκη λειτουργίας δρομολόγησης, μεταβλητή συστήματος"
			AddOK                = "Προστέθηκε"
			AddDone              = "Προσθήκη στο πλήρες"
			Remove               = "διαγράφω"
			RemoveRoute          = "Διαγράψτε τη λειτουργία δρομολόγησης, μεταβλητή συστήματος"
			RemoveDone           = "Διαγράφηκε με επιτυχία"
			SIP                  = "Σενάριο συσκευασίας συστήματος"
			VerifyAutopilot      = "Επαλήθευση: Προφίλ αυτόνομης οδήγησης"
			VerifyUnattend       = "Επαλήθευση: θα πρέπει να απαντήσει εκ των προτέρων το αρχείο προτύπου"
			Unpack               = "Μπάλλα"
			ChkUpdate            = "Ελεγχος για ενημερώσεις"
			CreateTemplate       = "Δημιουργία προτύπου"
			CEUP                 = "Δημιουργήστε ένα πακέτο αναβάθμισης κινητήρα ανάπτυξης"
			zip                  = "Όλο το λογισμικό είναι συσκευασμένο σε μορφή συμπίεσης με φερμουάρ"
			Repair               = "επισκευή"
			All                  = "όλα"
			HistoryClearDismSave = "Διαγράψτε τις εγγραφές προσάρτησης DISM που είναι αποθηκευμένες στο μητρώο"
			Clear_Bad_Mount      = "Διαγράψτε όλους τους πόρους που σχετίζονται με την κατεστραμμένη προσαρτημένη εικόνα"
			CleanupLogs          = "Εκκαθάριση: αρχεία Temp, αρχεία καταγραφής λύσεων, αρχεία καταγραφής DISM"
			CleanupDisk          = "Καθαρίστε όλα τα προσωρινά αρχεία δίσκου"
		}
	}
	@{
		Region   = "es-es"
		Name     = "Spanish (Spain)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Uso: "
			Learn                = "Estudiar"
			Choose               = "Por favor seleccione"
			Reset                = "Reiniciar"
			History              = "Limpiar registros de línea de comando"
			Add                  = "Agregar funciones de enrutamiento y variables del sistema"
			AddOK                = "Agregado"
			AddDone              = "Añadir completado"
			Remove               = "Borrar"
			RemoveRoute          = "Eliminar funciones de enrutamiento y variables del sistema."
			RemoveDone           = "Eliminar con éxito"
			SIP                  = "Script de empaquetado del sistema"
			VerifyAutopilot      = "Verificación: Perfil de conducción autónoma"
			VerifyUnattend       = "Verificación: debe responder previamente el archivo de plantilla"
			Unpack               = "Embalar"
			ChkUpdate            = "Buscar actualizaciones"
			CreateTemplate       = "Crear plantilla"
			CEUP                 = "Crear un paquete de actualización del motor de implementación"
			zip                  = "Todo el software está empaquetado en formato comprimido zip."
			Repair               = "Reparar"
			All                  = "Todo"
			HistoryClearDismSave = "Eliminar registros de montaje DISM guardados en el registro"
			Clear_Bad_Mount      = "Elimine todos los recursos asociados con la imagen montada dañada"
			CleanupLogs          = "Limpieza: archivos temporales, registros de soluciones, registros DISM"
			CleanupDisk          = "Limpiar todos los archivos temporales del disco"
		}
	}
	@{
		Region   = "es-MX"
		Name     = "Spanish (Mexico)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Uso:"
			Learn                = ""
			Choose               = "por favor elige"
			Reset                = "reiniciar"
			History              = "Borrar registros de línea de comando"
			Add                  = "Agregar función de enrutamiento, variable del sistema"
			AddOK                = "adicional"
			AddDone              = "Añadir a Complete"
			Remove               = "borrar"
			RemoveRoute          = "Eliminar la función de enrutamiento, variable del sistema"
			RemoveDone           = "Eliminado con éxito"
			SIP                  = "Script de empaque del sistema"
			VerifyAutopilot      = "Verificación: Perfil de conducción autónoma"
			VerifyUnattend       = "Verificación: debe responder previamente el archivo de plantilla"
			Unpack               = "Bala"
			ChkUpdate            = "Buscar actualizaciones"
			CreateTemplate       = "Ustvari predlogo"
			CEUP                 = "Crear un paquete de actualización del motor de implementación"
			zip                  = "Todo el software está empaquetado en formato de compresión zip"
			Repair               = "reparar"
			All                  = "todo"
			HistoryClearDismSave = "Eliminar registros de montaje DISM guardados en el registro"
			Clear_Bad_Mount      = "Elimine todos los recursos asociados con la imagen montada dañada"
			CleanupLogs          = "Limpieza: archivos temporales, registros de soluciones, registros DISM"
			CleanupDisk          = "Limpiar todos los archivos temporales del disco"
		}
	}
	@{
		Region   = "et-EE"
		Name     = "Estonian (Estonia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Kasutamine:"
			Learn                = "Uuring"
			Choose               = "palun vali"
			Reset                = "lähtestada"
			History              = "Tühjendage käsurea kirjed"
			Add                  = "Lisage marsruutimisfunktsioon, süsteemimuutuja"
			AddOK                = "Lisatud"
			AddDone              = "Lisage lõpule"
			Remove               = "kustutada"
			RemoveRoute          = "Kustuta marsruutimisfunktsioon, süsteemimuutuja"
			RemoveDone           = "Edukalt kustutatud"
			SIP                  = "Süsteemi pakendi skript"
			VerifyAutopilot      = "Kinnitus: autonoomne sõiduprofiil"
			VerifyUnattend       = "Kinnitus: peaks mallifaili eelnevalt vastama"
			Unpack               = "Bale"
			ChkUpdate            = "Kontrolli kas uuendused on saadaval"
			CreateTemplate       = "Loo mall"
			CEUP                 = "Looge juurutusmootori täienduspakett"
			zip                  = "Kogu tarkvara on pakendatud ZIP -i tihendusvormingusse"
			Repair               = "remont"
			All                  = "kõik"
			HistoryClearDismSave = "Kustutage registrisse salvestatud DISM-ühenduse kirjed"
			Clear_Bad_Mount      = "Kustutage kõik rikutud ühendatud pildiga seotud ressursid"
			CleanupLogs          = "Puhastamine: ajutised failid, lahenduslogid, DISM-i logid"
			CleanupDisk          = "Puhastage kõik ajutised kettafailid"
		}
	}
	@{
		Region   = "fi-FI"
		Name     = "Finnish (Finland)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "käyttö:"
			Learn                = "Opiskella"
			Choose               = "Valitse"
			Reset                = "nollaa"
			History              = "Tyhjennä komentorivin tietueet"
			Add                  = "Lisää reititystoiminto, järjestelmämuuttuja"
			AddOK                = "Lisätty"
			AddDone              = "Lisää loppuun"
			Remove               = "Puhdistus: Temp-tiedostot, ratkaisulokit, DISM-lokit"
			RemoveRoute          = "Poista reititystoiminto, järjestelmämuuttuja"
			RemoveDone           = "Poistettu onnistuneesti"
			SIP                  = "Järjestelmäpakkauskomentosarja"
			VerifyAutopilot      = "Vahvistus: Autonominen ajoprofiili"
			VerifyUnattend       = "Varmistus: pitäisi vastata mallitiedostoon etukäteen"
			Unpack               = "Paali"
			ChkUpdate            = "Tarkista päivitykset"
			CreateTemplate       = "Luo malli"
			CEUP                 = "Luo käyttöönottomoottorin päivityspaketti"
			zip                  = "Kaikki ohjelmistot on pakattu postinumeroon"
			Repair               = "korjaus"
			All                  = "kaikki"
			HistoryClearDismSave = "Poista rekisteriin tallennetut DISM-liitostietueet"
			Clear_Bad_Mount      = "Poista kaikki resurssit, jotka liittyvät vioittuneeseen liitettyyn kuvaan"
			CleanupLogs          = "Puhdistus: Temp-tiedostot, ratkaisulokit, DISM-lokit"
			CleanupDisk          = "Puhdista kaikki väliaikaiset levytiedostot"
		}
	}
	@{
		Region   = "fr-CA"
		Name     = "French (Canada)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "usage:"
			Learn                = "Étude"
			Choose               = "Choisissez s'il vous plaît"
			Reset                = "réinitialiser"
			History              = "Effacer les enregistrements de ligne de commande"
			Add                  = "Ajouter la fonction de routage, variable système"
			AddOK                = "ajoutée"
			AddDone              = "Ajouter à complet"
			Remove               = "Supprimer"
			RemoveRoute          = "Supprimer la fonction de routage, variable système"
			RemoveDone           = "Supprimé avec succès"
			SIP                  = "Script d'emballage système"
			VerifyAutopilot      = "Vérification: profil de conduite autonome"
			VerifyUnattend       = "Vérification: doit pré-répondre le fichier modèle"
			Unpack               = "Balle"
			ChkUpdate            = "Vérifier les mises à jour"
			CreateTemplate       = "Créer un modèle"
			CEUP                 = "Créer un package de mise à niveau du moteur de déploiement"
			zip                  = "Tous les logiciels sont emballés au format de compression zip"
			Repair               = "réparation"
			All                  = "tous"
			HistoryClearDismSave = "Supprimer les enregistrements de montage DISM enregistrés dans le registre"
			Clear_Bad_Mount      = "Supprimez toutes les ressources associées à l'image montée corrompue"
			CleanupLogs          = "Nettoyage: fichiers temporaires, journaux de solutions, journaux DISM"
			CleanupDisk          = "Nettoyer tous les fichiers de disque temporaires"
		}
	}
	@{
		Region   = "fr-fr"
		Name     = "French (France)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Usage:"
			Learn                = "Étude"
			Choose               = "Veuillez sélectionner"
			Reset                = "Réinitialiser"
			History              = "Nettoyer les enregistrements de ligne de commande"
			Add                  = "Ajouter des fonctions de routage et des variables système"
			AddOK                = "Ajouté"
			AddDone              = "Ajout terminé"
			Remove               = "Supprimer"
			RemoveRoute          = "Supprimer les fonctions de routage et les variables système"
			RemoveDone           = "Supprimer avec succès"
			SIP                  = "Script d'empaquetage du système"
			VerifyAutopilot      = "Vérification: profil de conduite autonome"
			VerifyUnattend       = "Vérification: doit pré-répondre le fichier modèle"
			Unpack               = "Paquet"
			ChkUpdate            = "Vérifier les mises à jour"
			CreateTemplate       = "Créer un modèle"
			CEUP                 = "Créer un package de mise à niveau du moteur de déploiement"
			zip                  = "Tous les logiciels sont emballés au format compressé zip"
			Repair               = "Réparation"
			All                  = "Tous"
			HistoryClearDismSave = "Supprimer les enregistrements de montage DISM enregistrés dans le registre"
			Clear_Bad_Mount      = "Supprimez toutes les ressources associées à l'image montée corrompue"
			CleanupLogs          = "Nettoyage: fichiers temporaires, journaux de solutions, journaux DISM"
			CleanupDisk          = "Nettoyer tous les fichiers de disque temporaires"
		}
	}
	@{
		Region   = "he-IL"
		Name     = "Hebrew (Israel)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "נוֹהָג:"
			Learn                = "לִלמוֹד"
			Choose               = "בבקשה תבחר"
			Reset                = "אִתחוּל"
			History              = "נקה רשומות שורת הפקודה"
			Add                  = "הוסף פונקציית ניתוב, משתנה מערכת"
			AddOK                = "נוסף"
			AddDone              = "הוסף להשלמה"
			Remove               = "לִמְחוֹק"
			RemoveRoute          = "מחק את פונקציית הניתוב, משתנה המערכת"
			RemoveDone           = "נמחק בהצלחה"
			SIP                  = "סקריפט אריזות מערכת"
			VerifyAutopilot      = "אימות: פרופיל נהיגה אוטונומית"
			VerifyUnattend       = "אימות: צריך לענות מראש על קובץ תבנית"
			Unpack               = "חֲבִילָה"
			ChkUpdate            = "בדוק עדכונים"
			CreateTemplate       = "צור תבנית"
			CEUP                 = "צור חבילת שדרוג מנוע פריסה"
			zip                  = "כל התוכנה ארוזת בפורמט דחיסת מיקוד"
			Repair               = "לְתַקֵן"
			All                  = "את כל"
			HistoryClearDismSave = "מחק את רשומות הטעינה של DISM שנשמרו ברישום"
			Clear_Bad_Mount      = "מחק את כל המשאבים המשויכים לתמונה המותקנת הפגומה"
			CleanupLogs          = "ניקוי: קבצי זמני, יומני פתרונות, יומני DISM"
			CleanupDisk          = "נקה את כל קבצי הדיסק הזמניים"
		}
	}
	@{
		Region   = "hr-HR"
		Name     = "Croatian (Croatia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Upotreba:"
			Learn                = "Studija"
			Choose               = "molim odaberite"
			Reset                = "Resetirati"
			History              = "Obrišite zapise naredbenog retka"
			Add                  = "Dodaj funkciju usmjeravanja, varijablu sustava"
			AddOK                = "Dodano"
			AddDone              = "Dodaj u komplet"
			Remove               = "izbrisati"
			RemoveRoute          = "Izbriši funkciju usmjeravanja, varijablu sustava"
			RemoveDone           = "Uspješno izbrisano"
			SIP                  = "Skripta za pakiranje sustava"
			VerifyAutopilot      = "Provjera: Profil autonomne vožnje"
			VerifyUnattend       = "Provjera: trebala bi biti datoteka predloška odgovora"
			Unpack               = "Bale"
			ChkUpdate            = "Provjerite ima li ažuriranja"
			CreateTemplate       = "Izradi predložak"
			CEUP                 = "Stvorite paket za nadogradnju mehanizma za implementaciju"
			zip                  = "Sav je softver pakiran u formatu kompresije ZIP -a"
			Repair               = "popravak"
			All                  = "svi"
			HistoryClearDismSave = "Izbrišite zapise montiranja DISM-a spremljene u registru"
			Clear_Bad_Mount      = "Izbrišite sve resurse povezane s oštećenom montiranom slikom"
			CleanupLogs          = "Čišćenje: privremene datoteke, zapisnici rješenja, zapisnici DISM-a"
			CleanupDisk          = "Očistite sve privremene diskovne datoteke"
		}
	}
	@{
		Region   = "hu-HU"
		Name     = "Hungarian (Hungary)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "használat:"
			Learn                = "Tanulmány"
			Choose               = "kérlek válassz"
			Reset                = "Visszaállítás"
			History              = "Parancssori rekordok törlése"
			Add                  = "Az útválasztási funkció hozzáadása, a rendszerváltozó"
			AddOK                = "Hozzáadva"
			AddDone              = "Hozzáadás a teljeshez"
			Remove               = "töröl"
			RemoveRoute          = "Törölje az útválasztási funkciót, a rendszerváltozót"
			RemoveDone           = "Sikeresen törölte"
			SIP                  = "A rendszercsomagolási szkript"
			VerifyAutopilot      = "Ellenőrzés: autonóm vezetési profil"
			VerifyUnattend       = "Ellenőrzés: előre meg kell válaszolni a sablonfájlt"
			Unpack               = "Bála"
			ChkUpdate            = "Frissítések keresése"
			CreateTemplate       = "Sablon létrehozása"
			CEUP                 = "Hozzon létre egy telepítési motor-frissítési csomagot"
			zip                  = "Az összes szoftver zip tömörítési formátumban van csomagolva"
			Repair               = "javítás"
			All                  = "minden"
			HistoryClearDismSave = "Törölje a rendszerleíró adatbázisban mentett DISM csatolási rekordokat"
			Clear_Bad_Mount      = "Törölje a sérült csatolt képfájlhoz tartozó összes erőforrást"
			CleanupLogs          = "Tisztítás: Ideiglenes fájlok, megoldásnaplók, DISM-naplók"
			CleanupDisk          = "Tisztítsa meg az összes ideiglenes lemezfájlt"
		}
	}
	@{
		Region   = "it-IT"
		Name     = "Italian (Italy)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Utilizzo:"
			Learn                = "Étude"
			Choose               = "si prega di scegliere"
			Reset                = "Ripristina"
			History              = "Cancella i record della riga di comando"
			Add                  = "Aggiungi funzione di routing, variabile di sistema"
			AddOK                = "Aggiunto"
			AddDone              = "Aggiungi a completare"
			Remove               = "eliminare"
			RemoveRoute          = "Elimina la funzione di routing, variabile di sistema"
			RemoveDone           = "Eliminato con successo"
			SIP                  = "Script di packaging di sistema"
			VerifyAutopilot      = "Verifica: profilo di guida autonoma"
			VerifyUnattend       = "Verifica: dovrebbe pre-rispondere al file modello"
			Unpack               = "Balla"
			ChkUpdate            = "Controlla gli aggiornamenti"
			CreateTemplate       = "Crea modello"
			CEUP                 = "Creare un pacchetto di aggiornamento del motore di distribuzione"
			zip                  = "Tutto il software è confezionato in formato di compressione Zip"
			Repair               = "riparazione"
			All                  = "Tutto"
			HistoryClearDismSave = "Elimina i record di montaggio DISM salvati nel registro"
			Clear_Bad_Mount      = "Elimina tutte le risorse associate all'immagine montata danneggiata"
			CleanupLogs          = "Pulizia: file temporanei, registri delle soluzioni, registri DISM"
			CleanupDisk          = "Pulisci tutti i file temporanei del disco"
		}
	}
	@{
		Region   = "ja-JP"
		Name     = "Japanese (Japan)"
		Language = @{
			FontsUI              = "Yu Gothic UI"
			Usage                = "利用方法："
			Learn                = "勉強"
			Choose               = "選んでください"
			Reset                = "リセット"
			History              = "コマンドラインレコードをクリアする"
			Add                  = "ルーティング機能、システム変数を追加"
			AddOK                = "追加した"
			AddDone              = "完了に追加"
			Remove               = "消去"
			RemoveRoute          = "ルーティング関数、システム変数を削除"
			RemoveDone           = "削除された"
			SIP                  = "システムパッケージングスクリプト"
			VerifyAutopilot      = "検証：自動運転プロファイル"
			VerifyUnattend       = "検証: テンプレート ファイルを事前に回答する必要があります"
			Unpack               = "ベール"
			ChkUpdate            = "アップデートを確認"
			CreateTemplate       = "テンプレートの作成"
			CEUP                 = "デプロイメント エンジン アップグレード パッケージを作成する"
			zip                  = "すべてのソフトウェアはzip圧縮形式でパッケージ化されています"
			Repair               = "修理"
			All                  = "全て"
			HistoryClearDismSave = "レジストリに保存されている DISM マウント レコードを削除します"
			Clear_Bad_Mount      = "破損したマウントされたイメージに関連付けられたすべてのリソースを削除します"
			CleanupLogs          = "クリーンアップ: 一時ファイル、ソリューション ログ、DISM ログ"
			CleanupDisk          = "すべての一時ディスク ファイルをクリーンアップする"
		}
	}
	@{
		Region   = "ko-KR"
		Name     = "Korean (Korea)"
		Language = @{
			FontsUI              = "Malgun Gothic"
			Usage                = "용법:"
			Learn                = "공부하다"
			Choose               = "선택해주세요"
			Reset                = "초기화"
			History              = "명령줄 레코드 지우기"
			Add                  = "라우팅 기능 추가, 시스템 변수"
			AddOK                = "추가"
			AddDone              = "완료하기 위해 추가"
			Remove               = "삭제"
			RemoveRoute          = "라우팅 기능, 시스템 변수 삭제"
			RemoveDone           = "성공적으로 삭제"
			SIP                  = "시스템 포장 스크립트"
			VerifyAutopilot      = "확인: 자율주행 프로필"
			VerifyUnattend       = "확인: 템플릿 파일에 미리 답변해야 합니다."
			Unpack               = "곤포"
			ChkUpdate            = "업데이트 확인"
			CreateTemplate       = "템플릿 만들기"
			CEUP                 = "배치 엔진 업그레이드 패키지 작성"
			zip                  = "모든 소프트웨어는 zip 압축 형식으로 포장됩니다"
			Repair               = "수리하다"
			All                  = "모두"
			HistoryClearDismSave = "레지스트리에 저장된 DISM 마운트 기록 삭제"
			Clear_Bad_Mount      = "손상된 탑재된 이미지와 관련된 모든 리소스 삭제"
			CleanupLogs          = "정리: 임시 파일, 솔루션 로그, DISM 로그"
			CleanupDisk          = "모든 임시 디스크 파일 정리"
		}
	}
	@{
		Region   = "lt-LT"
		Name     = "Lithuanian (Lithuania)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Naudojimas:"
			Learn                = "Studijuoti"
			Choose               = "Prašome pasirinkti"
			Reset                = "atstatyti"
			History              = "Išvalyti komandinės eilutės įrašus"
			Add                  = "Pridėti maršruto parinkimo funkciją, sistemos kintamąjį"
			AddOK                = "Pridėta"
			AddDone              = "Pridėti prie pilno"
			Remove               = "ištrinti"
			RemoveRoute          = "Ištrinkite maršruto parinkimo funkciją, sistemos kintamąjį"
			RemoveDone           = "Sėkmingai ištrintas"
			SIP                  = "Sistemos pakavimo scenarijus"
			VerifyAutopilot      = "Patvirtinimas: savarankiško vairavimo profilis"
			VerifyUnattend       = "Patvirtinimas: turėtų iš anksto atsakyti šablono failas"
			Unpack               = "Bale"
			ChkUpdate            = "Tikrinti, ar yra atnaujinimų"
			CreateTemplate       = "Sukurti šabloną"
			CEUP                 = "Sukurkite diegimo variklio naujinimo paketą"
			zip                  = "Visa programinė įranga yra supakuota į ZIP suspaudimo formatą"
			Repair               = "remontas"
			All                  = "visi"
			HistoryClearDismSave = "Ištrinkite registre išsaugotus DISM prijungimo įrašus"
			Clear_Bad_Mount      = "Ištrinkite visus išteklius, susijusius su sugadintu prijungtu vaizdu"
			CleanupLogs          = "Valymas: laikinieji failai, sprendimų žurnalai, DISM žurnalai"
			CleanupDisk          = "Išvalykite visus laikinuosius disko failus"
		}
	}
	@{
		Region   = "lv-LV"
		Name     = "Latvian (Latvia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Lietojums:"
			Learn                = "Pētījums"
			Choose               = "Lūdzu izvēlies"
			Reset                = "atiestatīt"
			History              = "Notīrīt komandrindas ierakstus"
			Add                  = "Pievienojiet maršrutēšanas funkciju, sistēmas mainīgo"
			AddOK                = "Pievienots"
			AddDone              = "Pievienot, lai pabeigtu"
			Remove               = "dzēst"
			RemoveRoute          = "Izdzēsiet maršrutēšanas funkciju, sistēmas mainīgo"
			RemoveDone           = "Veiksmīgi izdzēsti"
			SIP                  = "Sistēmas iepakojuma skripts"
			VerifyAutopilot      = "Verifikācija: autonomas braukšanas profils"
			VerifyUnattend       = "Verifikācija: vajadzētu pirms atbildes veidnes faila"
			Unpack               = "Bāle"
			ChkUpdate            = "Meklēt atjauninājumus"
			CreateTemplate       = "Izveidot veidni"
			CEUP                 = "Izveidojiet izvietošanas programmas jaunināšanas pakotni"
			zip                  = "Visa programmatūra ir iesaiņota pasta kompresijas formātā"
			Repair               = "remonts"
			All                  = "visi"
			HistoryClearDismSave = "Dzēsiet reģistrā saglabātos DISM montāžas ierakstus"
			Clear_Bad_Mount      = "Dzēsiet visus resursus, kas saistīti ar bojāto pievienoto attēlu"
			CleanupLogs          = "Tīrīšana: pagaidu faili, risinājumu žurnāli, DISM žurnāli"
			CleanupDisk          = "Notīriet visus pagaidu diska failus"
		}
	}
	@{
		Region   = "nb-NO"
		Name     = "Norwegian, Bokmål (Norway)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Bruk:"
			Learn                = "Studere"
			Choose               = "Vennligst velg"
			Reset                = "nullstille"
			History              = "Slett kommandolinjeposter"
			Add                  = "Legg til rutingsfunksjon, systemvariabel"
			AddOK                = "la til"
			AddDone              = "Legg til i fullført"
			Remove               = "slette"
			RemoveRoute          = "Slett rutingsfunksjonen, systemvariabel"
			RemoveDone           = "vellykket slettet"
			SIP                  = "Systememballasjeskript"
			VerifyAutopilot      = "Bekreftelse: Autonom kjøreprofil"
			VerifyUnattend       = "Bekreftelse: skal forhåndsbesvare malfil"
			Unpack               = "Bale"
			ChkUpdate            = "Se etter oppdateringer"
			CreateTemplate       = "Lag mal"
			CEUP                 = "Opprett en oppgraderingspakke for distribusjonsmotoren"
			zip                  = "All programvare er pakket i zip -komprimeringsformat"
			Repair               = "reparere"
			All                  = "alle"
			HistoryClearDismSave = "Slett DISM-monteringsposter som er lagret i registret"
			Clear_Bad_Mount      = "Slett alle ressurser knyttet til det ødelagte monterte bildet"
			CleanupLogs          = "Opprydding: Temp-filer, løsningslogger, DISM-logger"
			CleanupDisk          = "Rengjør alle midlertidige diskfiler"
		}
	}
	@{
		Region   = "nl-nl"
		Name     = "Dutch (Netherlands)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Gebruik:"
			Learn                = "Studie"
			Choose               = "Selecteer alstublieft"
			Reset                = "Opnieuw instellen"
			History              = "Opdrachtregelrecords opschonen"
			Add                  = "Voeg routeringsfuncties en systeemvariabelen toe"
			AddOK                = "Toegevoegd"
			AddDone              = "Toevoegen voltooid"
			Remove               = "Verwijderen"
			RemoveRoute          = "Routeringsfuncties en systeemvariabelen verwijderen"
			RemoveDone           = "Succesvol verwijderen"
			SIP                  = "Systeemverpakkingsscript"
			VerifyAutopilot      = "Verificatie: Autonoom Rijprofiel"
			VerifyUnattend       = "Verificatie: moet het sjabloonbestand vooraf beantwoorden"
			Unpack               = "Pak"
			ChkUpdate            = "Controleer op updates"
			CreateTemplate       = "Sjabloon maken"
			CEUP                 = "Maak een upgradepakket voor de implementatie-engine"
			zip                  = "Alle software is verpakt in een gecomprimeerd zip-formaat"
			Repair               = "Reparatie"
			All                  = "Alle"
			HistoryClearDismSave = "Verwijder DISM-mountrecords die in het register zijn opgeslagen"
			Clear_Bad_Mount      = "Verwijder alle bronnen die zijn gekoppeld aan de beschadigde gekoppelde afbeelding"
			CleanupLogs          = "Opschonen: tijdelijke bestanden, oplossingslogboeken, DISM-logboeken"
			CleanupDisk          = "Maak alle tijdelijke schijfbestanden schoon"
		}
	}
	@{
		Region   = "pl-PL"
		Name     = "Polish (Poland)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "stosowanie:"
			Learn                = "Badanie"
			Choose               = "proszę wybrać"
			Reset                = "Resetowanie"
			History              = "Wyczyść rekordy wiersza poleceń"
			Add                  = "Dodaj funkcję routingu, zmienna systemowa"
			AddOK                = "dodany"
			AddDone              = "Dodaj do kompletnego"
			Remove               = "usuwać"
			RemoveRoute          = "Usuń funkcję routingu, zmienną systemową"
			RemoveDone           = "Z powodzeniem usunięto"
			SIP                  = "Skrypt pakowania systemu"
			VerifyAutopilot      = "Weryfikacja: Profil jazdy autonomicznej"
			VerifyUnattend       = "Weryfikacja: powinna wstępnie odpowiedzieć na plik szablonu"
			Unpack               = "Bela"
			ChkUpdate            = "Sprawdź aktualizacje"
			CreateTemplate       = "Utwórz szablon"
			CEUP                 = "Utwórz pakiet aktualizacji mechanizmu wdrażania"
			zip                  = "Wszystkie oprogramowanie jest pakowane w formacie kompresji zip"
			Repair               = "naprawa"
			All                  = "Wszystko"
			HistoryClearDismSave = "Usuń rekordy podłączenia DISM zapisane w rejestrze"
			Clear_Bad_Mount      = "Usuń wszystkie zasoby powiązane z uszkodzonym zamontowanym obrazem"
			CleanupLogs          = "Oczyszczanie: pliki tymczasowe, dzienniki rozwiązań, dzienniki DISM"
			CleanupDisk          = "Wyczyść wszystkie pliki tymczasowe na dysku"
		}
	}
	@{
		Region   = "pt-BR"
		Name     = "Portuguese (Brazil)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "uso:"
			Learn                = "Estudar"
			Choose               = "por favor escolha"
			Reset                = "reiniciar"
			History              = "Limpar registros de linha de comando"
			Add                  = "Adicionar função de roteamento, variável do sistema"
			AddOK                = "Adicionado"
			AddDone              = "Adicionar para completar"
			Remove               = "excluir"
			RemoveRoute          = "Exclua a função de roteamento, variável do sistema"
			RemoveDone           = "Excluído com sucesso"
			SIP                  = "Script de embalagem do sistema"
			VerifyAutopilot      = "Verificação: Perfil de direção autônoma"
			VerifyUnattend       = "Verificação: deve pré-responder arquivo de modelo"
			Unpack               = "Fardo"
			ChkUpdate            = "Verifique se há atualizações"
			CreateTemplate       = "Utwórz szablon"
			CEUP                 = "Criar um pacote de atualização do mecanismo de implantação"
			zip                  = "Todo o software está embalado em formato de compressão ZIP"
			Repair               = "reparar"
			All                  = "todos"
			HistoryClearDismSave = "Exclua os registros de montagem DISM salvos no registro"
			Clear_Bad_Mount      = "Exclua todos os recursos associados à imagem montada corrompida"
			CleanupLogs          = "Limpeza: arquivos temporários, logs de solução, logs DISM"
			CleanupDisk          = "Limpe todos os arquivos temporários do disco"
		}
	}
	@{
		Region   = "pt-pt"
		Name     = "Portuguese (Portugal)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Utilização:"
			Learn                = "Estudar"
			Choose               = "Selecione"
			Reset                = "Reiniciar"
			History              = "Limpar registos de linha de comando"
			Add                  = "Adicione funções de encaminhamento e variáveis de sistema"
			AddOK                = "Adicionado"
			AddDone              = "Adicionar concluído"
			Remove               = "Excluir"
			RemoveRoute          = "Remover funções de encaminhamento, variáveis do sistema"
			RemoveDone           = "Apagar com sucesso"
			SIP                  = "Script de empacotamento do sistema"
			VerifyAutopilot      = "Verificação: Perfil de condução autónoma"
			VerifyUnattend       = "Verificação: deve pré-responder ficheiro de modelo"
			Unpack               = "Pacote"
			ChkUpdate            = "Verifique se existem atualizações"
			CreateTemplate       = "Criar modelo"
			CEUP                 = "Crie um pacote de atualização do mecanismo de implementação"
			zip                  = "Todo o software é empacotado em formato comprimido zip"
			Repair               = "Reparar"
			All                  = "Todos"
			HistoryClearDismSave = "Apague os registos de montagem DISM guardados no registo"
			Clear_Bad_Mount      = "Apague todos os recursos associados à imagem montada corrompida"
			CleanupLogs          = "Limpeza: ficheiros temporários, registos de soluções, registos DISM"
			CleanupDisk          = "Limpe todos os ficheiros temporários do disco"
		}
	}
	@{
		Region   = "ro-RO"
		Name     = "Romanian (Romania)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Utilizare:"
			Learn                = "Studiu"
			Choose               = "vă rugăm să alegeți"
			Reset                = "resetare"
			History              = "Ștergeți înregistrările din linia de comandă"
			Add                  = "Adăugați funcția de rutare, variabilă de sistem"
			AddOK                = "adăugat"
			AddDone              = "Adăugați la finalizare"
			Remove               = "şterge"
			RemoveRoute          = "Ștergeți funcția de rutare, variabila de sistem"
			RemoveDone           = "Șters cu succes"
			SIP                  = "Script de ambalare a sistemului"
			VerifyAutopilot      = "Verificare: Profil de conducere autonomă"
			VerifyUnattend       = "Verificare: ar trebui să răspundă înainte de fișierul șablon"
			Unpack               = "Balot"
			ChkUpdate            = "Verifică pentru actualizări"
			CreateTemplate       = "Creați șablon"
			CEUP                 = "Creați un pachet de actualizare a motorului de implementare"
			zip                  = "Toate software -ul este ambalat în format de compresie zip"
			Repair               = "reparație"
			All                  = "toate"
			HistoryClearDismSave = "Ștergeți înregistrările de montare DISM salvate în registry"
			Clear_Bad_Mount      = "Ștergeți toate resursele asociate cu imaginea montată coruptă"
			CleanupLogs          = "Curățare: fișiere temporare, jurnale de soluții, jurnale DISM"
			CleanupDisk          = "Curățați toate fișierele temporare de pe disc"
		}
	}
	@{
		Region   = "ru-RU"
		Name     = "Russian (Russia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Применение:"
			Learn                = "Изучать"
			Choose               = "пожалуйста, выберите"
			Reset                = "перезагрузить"
			History              = "Очистить записи командной строки"
			Add                  = "Добавить функцию маршрутизации, системную переменную"
			AddOK                = "добавлен"
			AddDone              = "Добавить в комплект"
			Remove               = "удалить"
			RemoveRoute          = "Удалить функцию маршрутизации, системная переменная"
			RemoveDone           = "Успешно удален"
			SIP                  = "Системная упаковка сценарий"
			VerifyAutopilot      = "Проверка: профиль автономного вождения"
			VerifyUnattend       = "Проверка: необходимо предварительно ответить на файл шаблона"
			Unpack               = "Бэйл"
			ChkUpdate            = "Проверить наличие обновлений"
			CreateTemplate       = "Создать шаблон"
			CEUP                 = "Создание пакета обновления механизма развертывания"
			zip                  = "Bce программное обеспечение упаковано в формате сжатия Zip"
			Repair               = "ремонт"
			All                  = "все"
			HistoryClearDismSave = "Удалить записи монтирования DISM, сохраненные в реестре"
			Clear_Bad_Mount      = "Удалите все ресурсы, связанные с поврежденным смонтированным образом"
			CleanupLogs          = "Очистка: временные файлы, журналы решений, журналы DISM."
			CleanupDisk          = "Очистите все временные файлы на диске"
		}
	}
	@{
		Region   = "sk-SK"
		Name     = "Slovak (Slovakia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Použitie:"
			Learn                = "Štúdium"
			Choose               = "prosím vyber si"
			Reset                = "resetovať"
			History              = "Vymazať záznamy príkazového riadku"
			Add                  = "Pridajte funkciu smerovania, systémovú premennú"
			AddOK                = "Pridané"
			AddDone              = "Pridať do dokončenia"
			Remove               = "vymazať"
			RemoveRoute          = "Odstráňte funkciu smerovania, systémovú premennú"
			RemoveDone           = "Úspešne vymazané"
			SIP                  = "Systémový obalový skript"
			VerifyAutopilot      = "Overenie: Profil autonómnej jazdy"
			VerifyUnattend       = "Overenie: mal by sa predpísať súbor šablóny odpovede"
			Unpack               = "Bale"
			ChkUpdate            = "Skontroluj aktualizácie"
			CreateTemplate       = "Vytvorte šablónu"
			CEUP                 = "Vytvorte balík inovácie nástroja nasadenia"
			zip                  = "Celý softvér je zabalený vo formáte kompresie zipsov"
			Repair               = "oprava"
			All                  = "všetky"
			HistoryClearDismSave = "Odstráňte záznamy pripojenia DISM uložené v registri"
			Clear_Bad_Mount      = "Odstráňte všetky prostriedky spojené s poškodeným pripojeným obrazom"
			CleanupLogs          = "Čistenie: dočasné súbory, protokoly riešení, protokoly DISM"
			CleanupDisk          = "Vyčistite všetky dočasné súbory na disku"
		}
	}
	@{
		Region   = "sl-SI"
		Name     = "Slovenian (Slovenia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Uporaba:"
			Learn                = "Študija"
			Choose               = "prosim izberite"
			Reset                = "ponastaviti"
			History              = "Počisti zapise ukazne vrstice"
			Add                  = "Dodajte funkcijo usmerjanja, sistemska spremenljivka"
			AddOK                = "Dodano"
			AddDone              = "Dodaj za dokončanje"
			Remove               = "izbrisati"
			RemoveRoute          = "Izbriši funkcijo usmerjanja, sistemska spremenljivka"
			RemoveDone           = "Uspešno izbrisano"
			SIP                  = "Script Scrip Packaging Script"
			VerifyAutopilot      = "Preverjanje: Profil avtonomne vožnje"
			VerifyUnattend       = "Preverjanje: datoteka predloge mora biti pred odgovorom"
			Unpack               = "Bale"
			ChkUpdate            = "Preveri za posodobitve"
			CreateTemplate       = "Ustvari predlogo"
			CEUP                 = "Ustvarite paket nadgradnje motorja za uvajanje"
			zip                  = "Vsa programska oprema je pakirana v obliki stiskanja zip"
			Repair               = "popravilo"
			All                  = "vse"
			HistoryClearDismSave = "Izbrišite zapise namestitve DISM, shranjene v registru"
			Clear_Bad_Mount      = "Izbrišite vse vire, povezane s poškodovano nameščeno sliko"
			CleanupLogs          = "Čiščenje: začasne datoteke, dnevniki rešitev, dnevniki DISM"
			CleanupDisk          = "Očistite vse začasne datoteke na disku"
		}
	}
	@{
		Region   = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "употреба:"
			Learn                = "Студија"
			Choose               = "молимо изаберите"
			Reset                = "ресетовати"
			History              = "Обришите записе командне линије"
			Add                  = "Додајте функцију усмеравања, системска променљива"
			AddOK                = "додато"
			AddDone              = "Додај за комплетну"
			Remove               = "избрисати"
			RemoveRoute          = "Избришите функцију усмеравања, системска променљива"
			RemoveDone           = "Успешно избрисано"
			SIP                  = "Скрипта за паковање система"
			VerifyAutopilot      = "Верификација: профил аутономне вожње"
			VerifyUnattend       = "Верификација: треба унапред одговорити на датотеку шаблона"
			Unpack               = "Бале"
			ChkUpdate            = "Провери ажурирања"
			CreateTemplate       = "Креирајте шаблон"
			CEUP                 = "Креирајте пакет за надоградњу машине за примену"
			zip                  = "Сав софтвер је упакован у зип компресијски формат"
			Repair               = "поправити"
			All                  = "све"
			HistoryClearDismSave = "Избришите ДИСМ моунт записе сачуване у регистратору"
			Clear_Bad_Mount      = "Избришите све ресурсе повезане са оштећеном монтираном сликом"
			CleanupLogs          = "Чишћење: Темп датотеке, евиденције решења, ДИСМ евиденције"
			CleanupDisk          = "Очистите све привремене датотеке на диску"
		}
	}
	@{
		Region   = "sv-SE"
		Name     = "Swedish (Sweden)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Användande:"
			Learn                = "Studera"
			Choose               = "Vänligen välj"
			Reset                = "Återställa"
			History              = "Rengör kommandoradsposter"
			Add                  = "Lägg till routingfunktioner och systemvariabler"
			AddOK                = "Tillagd"
			AddDone              = "Lägg till slutfört"
			Remove               = "Radera"
			RemoveRoute          = "Ta bort routingfunktioner, systemvariabler"
			RemoveDone           = "Radera framgångsrikt"
			SIP                  = "Systempaketeringsskript"
			VerifyAutopilot      = "Verifiering: Autonom körprofil"
			VerifyUnattend       = "Verifiering: ska förhandsbesvara mallfil"
			Unpack               = "Packa"
			ChkUpdate            = "Sök efter uppdateringar"
			CreateTemplate       = "Skapa mall"
			CEUP                 = "Skapa ett uppgraderingspaket för distributionsmotorn"
			zip                  = "All programvara är förpackad i zip-komprimerat format"
			Repair               = "Reparera"
			All                  = "Alla"
			HistoryClearDismSave = "Ta bort DISM-monteringsposter som sparats i registret"
			Clear_Bad_Mount      = "Ta bort alla resurser som är associerade med den skadade monterade bilden"
			CleanupLogs          = "Rensning: Temp-filer, lösningsloggar, DISM-loggar"
			CleanupDisk          = "Rensa alla temporära diskfiler"
		}
	}
	@{
		Region   = "th-TH"
		Name     = "Thai (Thailand)"
		Language = @{
			FontsUI              = "Leelawadee UI"
			Usage                = "การใช้งาน:"
			Learn                = "ศึกษา"
			Choose               = "โปรดเลือก"
			Reset                = "รีเซ็ต"
			History              = "ล้างบันทึกบรรทัดคำสั่ง"
			Add                  = "เพิ่มฟังก์ชั่นการกำหนดเส้นทางตัวแปรระบบ"
			AddOK                = "เพิ่ม"
			AddDone              = "เพิ่มให้เสร็จสมบูรณ์"
			Remove               = "ลบ"
			RemoveRoute          = "ลบฟังก์ชั่นการกำหนดเส้นทางตัวแปรระบบ"
			RemoveDone           = "ลบสำเร็จ"
			SIP                  = "สคริปต์บรรจุภัณฑ์ของระบบ"
			VerifyAutopilot      = "การยืนยัน: โปรไฟล์การขับขี่แบบอัตโนมัติ"
			VerifyUnattend       = "การยืนยัน: ควรตอบไฟล์เทมเพลตล่วงหน้า"
			Unpack               = "เบล"
			ChkUpdate            = "ตรวจสอบสำหรับการอัพเดต"
			CreateTemplate       = "สร้างเทมเพลต"
			CEUP                 = "สร้างแพ็คเกจการปรับรุ่นกลไกการปรับใช้"
			zip                  = "ซอฟต์แวร์ทั้งหมดบรรจุในรูปแบบการบีบอัด zip"
			Repair               = "ซ่อมแซม"
			All                  = "ทั้งหมด"
			HistoryClearDismSave = "ลบบันทึกการเมานต์ DISM ที่บันทึกไว้ในรีจิสทรี"
			Clear_Bad_Mount      = "ลบทรัพยากรทั้งหมดที่เกี่ยวข้องกับอิมเมจที่เมาท์ที่เสียหาย"
			CleanupLogs          = "การล้างข้อมูล: ไฟล์ชั่วคราว บันทึกโซลูชัน บันทึก DISM"
			CleanupDisk          = "ทำความสะอาดไฟล์ดิสก์ชั่วคราวทั้งหมด"
		}
	}
	@{
		Region   = "tr-TR"
		Name     = "Turkish (Turkey)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Kullanım:"
			Learn                = "Çalışmak"
			Choose               = "lütfen seç"
			Reset                = "Sıfırla"
			History              = "Komut satırı kayıtlarını temizle"
			Add                  = "Yönlendirme işlevi, sistem değişkeni ekle"
			AddOK                = "katma"
			AddDone              = "Tamamlamak için ekle"
			Remove               = "silmek"
			RemoveRoute          = "Yönlendirme işlevini sil, sistem değişkeni"
			RemoveDone           = "Başarılı bir şekilde silindi"
			SIP                  = "Sistem Ambalaj Komut Dosyası"
			VerifyAutopilot      = "Doğrulama: Otonom Sürüş Profili"
			VerifyUnattend       = "Doğrulama: şablon dosyasına önceden yanıt verilmelidir"
			Unpack               = "Balya"
			ChkUpdate            = "Güncellemeleri kontrol et"
			CreateTemplate       = "Şablon oluştur"
			CEUP                 = "Bir dağıtım altyapısı yükseltme paketi oluşturun"
			zip                  = "Tüm yazılımlar zip sıkıştırma formatında paketlenmiştir"
			Repair               = "tamirat"
			All                  = "Tümü"
			HistoryClearDismSave = "Kayıt defterinde kayıtlı DISM bağlama kayıtlarını silin"
			Clear_Bad_Mount      = "Bozuk monte edilmiş görüntüyle ilişkili tüm kaynakları silin"
			CleanupLogs          = "Temizleme: Geçici dosyalar, çözüm günlükleri, DISM günlükleri"
			CleanupDisk          = "Tüm geçici disk dosyalarını temizleyin"
		}
	}
	@{
		Region   = "uk-UA"
		Name     = "Ukrainian (Ukraine)"
		Language = @{
			FontsUI              = "Segoe UI"
			Usage                = "Використання:"
			Learn                = "Вивчення"
			Choose               = "будь-ласка оберіть"
			Reset                = "скинути"
			History              = "Очистити записи командного рядка"
			Add                  = "Додайте функцію маршрутизації, системну змінну"
			AddOK                = "Додав"
			AddDone              = "Додати для завершення"
			Remove               = "видалити"
			RemoveRoute          = "Видаліть функцію маршрутизації, системна змінна"
			RemoveDone           = "успішно видалено"
			SIP                  = "Сценарій упаковки системи"
			VerifyAutopilot      = "Перевірка: профіль автономного водіння"
			VerifyUnattend       = "Перевірка: необхідно попередньо відповісти файл шаблону"
			Unpack               = "Бейл"
			ChkUpdate            = "Перевірити наявність оновлень"
			CreateTemplate       = "Створити шаблон"
			CEUP                 = "Створіть пакет оновлення механізму розгортання"
			zip                  = "Bce програмне забезпечення упаковано y форматі стиснення zip"
			Repair               = "ремонт"
			All                  = "все"
			HistoryClearDismSave = "Видаліть записи монтування DISM, збережені в реєстрі"
			Clear_Bad_Mount      = "Видаліть усі ресурси, пов'язані з пошкодженим підключеним образом"
			CleanupLogs          = "Очищення: тимчасові файли, журнали рішень, журнали DISM"
			CleanupDisk          = "Очистіть усі тимчасові файли диска"
		}
	}
	@{
		Region   = "zh-CN"
		Name     = "Chinese (Simplified, China)"
		Language = @{
			FontsUI              = "Microsoft YaHei UI"
			Usage                = "用法："
			Learn                = "学习"
			Choose               = "请选择"
			Reset                = "重置"
			History              = "清理命令行记录"
			Add                  = "添加路由功能、系统变量"
			AddOK                = "已添加"
			AddDone              = "添加完成"
			Remove               = "删除"
			RemoveRoute          = "删除路由功能，系统变量"
			RemoveDone           = "删除成功"
			SIP                  = "系统封装脚本"
			VerifyAutopilot      = "验证：自动驾驶配置文件"
			VerifyUnattend       = "验证：应预答模板文件"
			Unpack               = "打包"
			ChkUpdate            = "检查更新"
			CreateTemplate       = "创建模板"
			CEUP                 = "创建部署引擎升级包"
			zip                  = "所有软件都以 zip 压缩格式打包"
			Repair               = "修复"
			All                  = "所有"
			HistoryClearDismSave = "删除保存在注册表里的 DISM 挂载记录"
			Clear_Bad_Mount      = "删除与已损坏的已装载映像关联的所有资源"
			CleanupLogs          = "清理：Temp 临时文件、解决方案日志、DISM 日志"
			CleanupDisk          = "清理所有磁盘临时文件"
		}
	}
	@{
		Region   = "zh-TW"
		Name     = "Chinese (Traditional, Taiwan)"
		Language = @{
			FontsUI              = "Microsoft JhengHei UI"
			Usage                = "用法："
			Learn                = "學習"
			Choose               = "請選擇"
			Reset                = "重置"
			History              = "清理命令行記錄"
			Add                  = "添加路由功能、系統變量"
			AddOK                = "已添加"
			AddDone              = "添加完成"
			Remove               = "刪除"
			RemoveRoute          = "刪除路由功能，系統變量"
			RemoveDone           = "刪除成功"
			SIP                  = "系統封裝腳本"
			VerifyAutopilot      = "驗證：自動駕駛設定檔"
			VerifyUnattend       = "驗證：應預答範本文件"
			Unpack               = "打包"
			ChkUpdate            = "檢查更新"
			CreateTemplate       = "創建範本"
			CEUP                 = "創建部署引擎升級包"
			zip                  = "所有軟件都以 zip 壓縮格式打包"
			Repair               = "修復"
			All                  = "所有"
			HistoryClearDismSave = "刪除儲存在登錄機碼裡的 DISM 掛載記錄"
			Clear_Bad_Mount      = "刪除與已損壞的已裝載映像關聯的所有資源"
			CleanupLogs          = "清理：Temp 臨時檔案、解決方案日誌、DISM 日誌"
			CleanupDisk          = "清理所有磁碟臨時文件"
		}
	}
)

Function Language
{
	param
	(
		$NewLang = (Get-Culture).Name
	)

	$Global:lang = @()
	$Global:IsLang = ""

	ForEach ($item in $AvailableLanguages) {
		if ($item.Region -eq $NewLang) {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Region
			return
		}
	}

	ForEach ($item in $AvailableLanguages) {
		if ($item.Region -eq "en-US") {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Region
			return
		}
	}

	Write-Host "No language packs found, please try again." -ForegroundColor Red
	exit
}

function Solutions_Reset
{
	Write-Host "`n  $($lang.Reset)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$Path = "HKCU:\SOFTWARE\Yi\Solutions"
	Remove-Item -Path $Path -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

	Write-Host "  $($lang.RemoveDone)`n" -ForegroundColor Green
}

function Mount_Fix_Bad
{
	Write-Host "`n  $($lang.Clear_Bad_Mount)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	dism /cleanup-wim | Out-Null
	Clear-WindowsCorruptMountPoint -ErrorAction SilentlyContinue | Out-Null

	Write-Host "  $($lang.RemoveDone)" -ForegroundColor Green
}

function Mount_Fix_Dism
{
	Write-Host "`n  $($lang.HistoryClearDismSave)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WIMMount\Mounted Images\*" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

	Write-Host "  $($lang.RemoveDone)" -ForegroundColor Green
}

function Solutions_Clear_Hostiry
{
	Write-Host "`n  $($lang.History)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Clear-History
	Remove-Item  -Path (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue

	Write-Host "  $($lang.RemoveDone)`n" -ForegroundColor Green
}

Function System_Env_Test_Order
{
	$Current_Folder = Convert-Path -Path $PSScriptRoot -ErrorAction SilentlyContinue
	$GetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue
	$windows_path = $GetVarPath -split ';'

	$RandomGuid = [guid]::NewGuid()
	$newFileName = Join-Path -Path $env:Temp -ChildPath $RandomGuid

	$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
	[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")
	Invoke-Expression -Command "Yi -Guid $($newFileName)"

	if (Test-Path -Path $newFileName -PathType leaf) {
		remove-item -path $newFileName -force -ErrorAction SilentlyContinue
		return
	}
	remove-item -path $newFileName -force -ErrorAction SilentlyContinue

	for ($i = 1; $i -le $windows_path.Count; $i++) {
		$RefreshGetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue
		$windows_path = $RefreshGetVarPath -split ';'

		<#
			.Configure the system variables from the registry and delete the routing directory
			.从注册表里系统变量配置，并删除路由目录
		#>
		$NewGroupPathNotOldPath = @()
		Foreach ($item in $windows_path) {
			if ($item -ne $Current_Folder) {
				$NewGroupPathNotOldPath += $item
			}
		}

		$CalcCurrentPath = @()
		$CalcCurrentValue = 0
		Foreach ($item in $windows_path) {
			$CalcCurrentValue++

			$CalcCurrentPath += @{
				SN = $CalcCurrentValue
				OldPath = $item
			}
		}

		<#
			.Get the path number
			.获取路径所在序号
		#>
		$FlagOrage = ""
		Foreach ($item in $CalcCurrentPath) {
			if ($item.OldPath -eq $Current_Folder) {
				$FlagOrage = $item.SN
				break
			}
		}

		$NewGroupAll = @()
		$FalgRunCalcCurrentValue = 0
		Foreach ($item in $NewGroupPathNotOldPath) {
			$FalgRunCalcCurrentValue++

			$FlagOragefs = $FlagOrage -1

			if ($FalgRunCalcCurrentValue -eq $FlagOragefs) {
				$NewGroupAll += $Current_Folder
			}

			$NewGroupAll += $item
		}

		$result = [string]::Join(";", $NewGroupAll)
		$result = $result.TrimEnd(';')

		Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $result
		$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
		[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")
		Invoke-Expression -Command "Yi -Guid $($newFileName)"

		if (Test-Path -Path $newFileName -PathType leaf) {
			remove-item -path $newFileName -force -ErrorAction SilentlyContinue
			return
		}
	}

	$GetVarPath = "$($GetVarPath);$($Current_Folder)"
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $GetVarPath
	remove-item -path $newFileName -force -ErrorAction SilentlyContinue
}

function System_Env
{
	param
	(
		[switch]$Add,
		[switch]$Remove
	)

	Write-Host "`n  $($lang.Add)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$Current_Folder = Convert-Path -Path $PSScriptRoot -ErrorAction SilentlyContinue
	$GetVarPath = Get-ItemPropertyValue -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path" -ErrorAction SilentlyContinue

	if ($Add) {
		$windows_path = $GetVarPath -split ';'

		if ($windows_path -Contains $Current_Folder) {
			System_Env_Test_Order
			Write-Host "  $($lang.AddOK)`n" -ForegroundColor Green
		} else {
			$GetVarPath = "$($GetVarPath);$($Current_Folder)"
			Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $GetVarPath
			System_Env_Test_Order
			Write-Host "  $($lang.AddDone)`n" -ForegroundColor Green
		}
	}

	if ($Remove) {
		$path = ($GetVarPath.Split(';') | Where-Object { $_ -ne $Current_Folder }) -join ';'
		$path = $path.TrimEnd(';')

		Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $path
		$Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
		[System.Environment]::SetEnvironmentVariable("Path", $Env:Path, "Machine")
		Write-Host "  $($lang.RemoveDone)`n" -ForegroundColor Green
	}
}

Function Cleanup_Logs
{
	Write-Host "`n  $($lang.CleanupLogs)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$TempPaths = @(
		$env:Temp
		"$($env:SystemRoot)\Logs\DISM"
		Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..") -ChildPath "Logs"
		Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..") -ChildPath "_Custom\Engine\LXPs\Logs"
		Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..") -ChildPath "_Custom\Engine\Multilingual\Logs"
		Join-Path -Path $(Convert-Path -Path "$($PSScriptRoot)\..\..") -ChildPath "_Custom\Engine\Yi.Suite\Logs"
	)

	foreach ($TempPath in $TempPaths) {
		Write-Host "  $($TempPath)" -ForegroundColor Green

		if (Test-Path -Path $TempPath -PathType Container) {
			Get-ChildItem -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				try {
					Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
				} catch {
					Write-Host $_ -ForegroundColor Red
				}
			}

			Remove-Item -Path $TempPath -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		}
	}

	Write-Host "`n  $('-' * 80)"
	Write-Host "  $($lang.RemoveDone)`n" -ForegroundColor Green
}

<#
	.Disk clean-up
	.磁盘清理
#>
Function Cleanup_Disk
{
	Write-Host "`n  $($lang.CleanupDisk)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	$SageSet = "StateFlags0099"
	$Base = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\"
	$Locations= @(
		"Active Setup Temp Folders"
		"BranchCache"
		"Downloaded Program Files"
		"GameNewsFiles"
		"GameStatisticsFiles"
		"GameUpdateFiles"
		"Internet Cache Files"
		"Memory Dump Files"
		"Offline Pages Files"
		"Old ChkDsk Files"
		"D3D Shader Cache"
		"Delivery Optimization Files"
		"Diagnostic Data Viewer database files"
		"Previous Installations"
		"Recycle Bin"
		"Service Pack Cleanup"
		"Setup Log Files"
		"System error memory dump files"
		"System error minidump files"
		"Temporary Files"
		"Temporary Setup Files"
		"Temporary Sync Files"
		"Thumbnail Cache"
		"Update Cleanup"
		"Upgrade Discarded Files"
		"User file versions"
		"Windows Defender"
		"Windows Error Reporting Archive Files"
		"Windows Error Reporting Queue Files"
		"Windows Error Reporting System Archive Files"
		"Windows Error Reporting System Queue Files"
		"Windows ESD installation files"
		"Windows Upgrade Log Files"
	)

	ForEach ($item in $Locations) {
		Set-ItemProperty -Path $($Base+$item) -Name $SageSet -Type DWORD -Value 2 -ErrorAction SilentlyContinue | Out-Null
	}

	<#
		.Do the clean-up. Have to convert the SageSet number
		.进行清理。 必须转换 SageSet 编号
	#>
	$Args = "/sagerun:$([string]([int]$SageSet.Substring($SageSet.Length-4)))"
	Start-Process -FilePath "$($env:SystemRoot)\System32\cleanmgr.exe" -ArgumentList $Args

	<#
		.Remove the Stateflags
		.删除状态标志
	#>
	ForEach ($item in $Locations) {
		Remove-ItemProperty -Path $($Base+$item) -Name $SageSet -force -ErrorAction SilentlyContinue | Out-Null
	}

	Write-Host "  $($lang.RemoveDone)`n" -ForegroundColor Green
}

function PSscript
{
	$PSscript = Get-Item $MyInvocation.ScriptName
	Return $PSscript
}

Function Help
{
	$PSscript = PSscript

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "Yi's Solutions"
	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " Yi's Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v1.0.0.8 " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.Learn) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " https://fengyi.tel/solutions https://github.com/ilikeyi/solutions " -BackgroundColor DarkBlue -ForegroundColor White

	Write-Host
	Write-Host "  $($lang.Usage)"
	Write-Host "  $('-' * 80)"
	Write-Host "    U   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Update" -NoNewLine -ForegroundColor Green
	Write-Host "  | " -NoNewLine
	Write-Host $lang.ChkUpdate -ForegroundColor Yellow

	Write-Host "    T   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -CT" -NoNewLine -ForegroundColor Green
	Write-Host "      | " -NoNewLine
	Write-Host $lang.CreateTemplate -ForegroundColor Yellow

	Write-Host

	Write-Host "    1   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Add" -NoNewLine -ForegroundColor Green
	Write-Host "     | " -NoNewLine
	Write-Host $lang.Add -ForegroundColor Yellow

	Write-Host "    2   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Remove" -NoNewLine -ForegroundColor Green
	Write-Host "  | " -NoNewLine
	Write-Host $lang.RemoveRoute -ForegroundColor Yellow

	Write-Host "    3   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Reset" -NoNewLine -ForegroundColor Green
	Write-Host "   | " -NoNewLine
	Write-Host $lang.Reset -ForegroundColor Yellow

	Write-Host "    4   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -History" -NoNewLine -ForegroundColor Green
	Write-Host " | " -NoNewLine
	Write-Host $lang.History -ForegroundColor Yellow

	Write-Host

	Write-Host "   11   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -SIP" -NoNewLine -ForegroundColor Green
	Write-Host "     | " -NoNewLine
	Write-Host $lang.SIP -ForegroundColor Yellow

	Write-Host "   12   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Unpack" -NoNewLine -ForegroundColor Green
	Write-Host "  | " -NoNewLine
	Write-Host $lang.Unpack -ForegroundColor Yellow

	Write-Host "   13   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -CEUP" -NoNewLine -ForegroundColor Green
	Write-Host "    | " -NoNewLine
	Write-Host $lang.CEUP -ForegroundColor Yellow

	Write-Host "   14   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -zip" -NoNewLine -ForegroundColor Green
	Write-Host "     | " -NoNewLine
	Write-Host $lang.zip -ForegroundColor Yellow

	Write-Host "   15   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -VA" -NoNewLine -ForegroundColor Green
	Write-Host "      | " -NoNewLine
	Write-Host $lang.VerifyAutopilot -ForegroundColor Yellow

	Write-Host "   16   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -VU" -NoNewLine -ForegroundColor Green
	Write-Host "      | " -NoNewLine
	Write-Host $lang.VerifyUnattend -ForegroundColor Yellow

	Write-Host "`n  $($lang.Repair)" -ForegroundColor Yellow

	Write-Host "   21   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Fix" -NoNewLine -ForegroundColor Green
	Write-Host "     | " -NoNewLine
	Write-Host "$($lang.Repair), $($lang.All)" -ForegroundColor Yellow

	Write-Host "   22   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -FixDism" -NoNewLine -ForegroundColor Green
	Write-Host " | " -NoNewLine
	Write-Host $lang.HistoryClearDismSave -ForegroundColor Yellow

	Write-Host "   23   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -FixBad" -NoNewLine -ForegroundColor Green
	Write-Host "  | " -NoNewLine
	Write-Host $lang.Clear_Bad_Mount -ForegroundColor Yellow

	Write-Host "`n  $($lang.Remove)" -ForegroundColor Yellow

	Write-Host "   32   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Logs" -NoNewLine -ForegroundColor Green
	Write-Host "    | " -NoNewLine
	Write-Host $lang.CleanupLogs -ForegroundColor Yellow

	Write-Host "   33   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Disk" -NoNewLine -ForegroundColor Green
	Write-Host "    | " -NoNewLine
	Write-Host $lang.CleanupDisk -ForegroundColor Yellow

	$Current_Folder = Convert-Path -Path "$($PSScriptRoot)\..\..\_Custom\Engine" -ErrorAction SilentlyContinue
	Write-Host "`n  $($Current_Folder)" -ForegroundColor Yellow

	Write-Host "   aa   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -LXPs" -NoNewLine -ForegroundColor Green
	Write-Host "    | " -NoNewLine
	Write-Host "\LXPs\LXPs.ps1" -ForegroundColor Yellow

	Write-Host "   ss   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Mul" -NoNewLine -ForegroundColor Green
	Write-Host "     | " -NoNewLine
	Write-Host "\Multilingual\Engine.ps1" -ForegroundColor Yellow

	Write-Host "   dd   " -NoNewLine -ForegroundColor Green
	Write-Host "$($PSscript.BaseName) -Ys" -NoNewLine -ForegroundColor Green
	Write-Host "      | " -NoNewLine
	Write-Host "\Yi.Suite\Engine.ps1" -ForegroundColor Yellow

	Write-Host
	write-host "  " -NoNewline
	Write-Host " $($lang.Choose) " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host ": " -NoNewline
	$NewEnter = Read-Host

	<#
		.The prefix cannot contain spaces
		.前缀不能带空格
	#>
	while ($true) {
		if ($NewEnter -match '^\s') {
			$NewEnter = $NewEnter.Remove(0, 1)
		} else {
			break
		}
	}

	switch -Wildcard ($NewEnter)
	{
		"u" {
			powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Update"
		}
		"t" {
			powershell -file "$($PSScriptRoot)\..\..\_Create.Template.ps1"
		}
		"1" {
			System_Env -Add
		}
		"2" {
			System_Env -Remove
		}
		"3" {
			Solutions_Reset
		}
		"4" {
			Solutions_Clear_Hostiry
		}
		"11" {
			powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1"
		}
		"12" {
			powershell -file "$($PSScriptRoot)\..\..\_Unpack.ps1"
		}
		"13" {
			powershell -file "$($PSScriptRoot)\..\..\_Create.Custom.Engine.upgrade.package.ps1"
		}
		"14" {
			powershell -file "$($PSScriptRoot)\..\..\_zip.ps1"
		}
		"15" {
			powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Verify_Autopilot_Custom_File"
		}
		"16" {
			powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Verify_Unattend_Custom_File"
		}
		"21" {
			Mount_Fix_Dism
			Mount_Fix_Bad
		}
		"22" {
			Mount_Fix_Dism
		}
		"23" {
			Mount_Fix_Bad
		}
		"32" {
			Cleanup_Logs
			exit
		}
		"33" {
			Cleanup_Disk
			exit
		}
		"aa" {
			powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\LXPs\LXPs.ps1"
		}
		"ss" {
			powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\Multilingual\Engine.ps1"
		}
		"dd" {
			powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\Yi.Suite\Engine.ps1"
		}
		default {
			Write-Host
			exit
		}
	}
}

<#
	.Set language pack, usage:
	 Language                  | Language selected by the user
	 Language -NewLang "zh-CN" | Mandatory use of specified language
#>
if ($Language) {
	Language -NewLang $Language
} else {
	Language
}

if ($Help) {
	Help
	return
}

if ($Update) {
	powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Update"
	return
}

if ($CT) {
	powershell -file "$($PSScriptRoot)\..\..\_Create.Template.ps1"
	return
}

if ($Logs) {
	Cleanup_Logs
	return
}

if ($Disk) {
	Cleanup_Disk
	return
}

if ($Add) {
	System_Env -Add
	return
}

if ($Remove) {
	System_Env -Remove
	return
}

if ($Reset) {
	Solutions_Reset
	return
}

if ($Fix) {
	Mount_Fix_Dism
	Mount_Fix_Bad
	return
}

if ($FixDism) {
	Mount_Fix_Dism
	return
}

if ($FixBad) {
	Mount_Fix_Bad
	return
}

if ($History) {
	Solutions_Clear_Hostiry
	return
}

if ($Sip) {
	powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1"
	return
}

if ($Unpack) {
	powershell -file "$($PSScriptRoot)\..\..\_Unpack.ps1"
	return
}

if ($Ceup) {
	powershell -file "$($PSScriptRoot)\..\..\_Create.Custom.Engine.upgrade.package.ps1"
	return
}

if ($va) {
	powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Verify_Autopilot_Custom_File"
	return
}

if ($vu) {
	powershell -file "$($PSScriptRoot)\..\..\_Sip.ps1" -Function "Verify_Unattend_Custom_File"
	return
}

if ($zip) {
	powershell -file "$($PSScriptRoot)\..\..\_zip.ps1"
	return
}

if ($LXPs) {
	powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\LXPs\LXPs.ps1"
	return
}

if ($Mul) {
	powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\Multilingual\Engine.ps1"
	return
}

if ($Ys) {
	powershell -file "$($PSScriptRoot)\..\..\_Custom\Engine\Yi.Suite\Engine.ps1"
	return
}

clear-host
Help