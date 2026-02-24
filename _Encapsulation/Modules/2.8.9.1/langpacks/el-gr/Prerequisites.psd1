ConvertFrom-StringData -StringData @'
	# el-gr
	# Greek (Greece)

	Prerequisites                   = Προαπαιτούμενα
	Check_PSVersion                 = Ελέγξτε την έκδοση PS 5.1 και νεότερη
	Check_OSVersion                 = Ελέγξτε την έκδοση των Windows > 10.0.16299.0
	Check_Higher_elevated           = Η επιταγή πρέπει να ανυψωθεί σε υψηλότερα προνόμια
	Check_execution_strategy        = Ελέγξτε τη στρατηγική εκτέλεσης

	Check_Pass                      = Πέρασμα
	Check_Did_not_pass              = Αποτυχημένος
	Check_Pass_Done                 = Συγχαρητήρια, πέρασε.
	How_solve                       = Πώς να λύσετε
	UpdatePSVersion                 = Εγκαταστήστε την πιο πρόσφατη έκδοση PowerShell
	UpdateOSVersion                 = 1. Μεταβείτε στον επίσημο ιστότοπο της Microsoft για λήψη της πιο πρόσφατης έκδοσης του λειτουργικού συστήματος\n    2. Εγκαταστήστε την πιο πρόσφατη έκδοση του λειτουργικού συστήματος και δοκιμάστε ξανά
	HigherTermail                   = 1. Ανοίξτε το Terminal ή το PowerShell ISE ως διαχειριστής, \n       Ορισμός πολιτικής εκτέλεσης PowerShell: Παράκαμψη, γραμμή εντολών PS: \n\n       Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n    2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή.
	HigherTermailAdmin              = 1. Ανοίξτε το Terminal ή το PowerShell ISE ως διαχειριστής. \n    2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή.
	LowAndCurrentError              = Ελάχιστη έκδοση: {0}, τρέχουσα έκδοση: {1}
	Check_Eligible                  = Εκλέξιμος
	Check_Version_PSM_Error         = Σφάλμα έκδοσης, ανατρέξτε στο {0}.psm1.Παράδειγμα, αναβαθμίστε ξανά το {0}.psm1 και δοκιμάστε ξανά.

	Check_OSEnv                     = Έλεγχος περιβάλλοντος συστήματος
	Check_Image_Bad                 = Ελέγξτε εάν η φορτωμένη εικόνα είναι κατεστραμμένη
	Check_Need_Fix                  = Σπασμένα αντικείμενα που πρέπει να επισκευαστούν
	Image_Mount_Mode                = Λειτουργία τοποθέτησης
	Image_Mount_Status              = Κατάσταση τοποθέτησης
	Check_Compatibility             = Έλεγχος συμβατότητας
	Check_Duplicate_rule            = Ελέγξτε για διπλότυπες εγγραφές κανόνων
	Duplicates                      = Επαναλαμβάνω
	ISO_File                        = Αρχείο ISO
	ISO_Langpack                    = Πακέτο γλώσσας ISO
'@