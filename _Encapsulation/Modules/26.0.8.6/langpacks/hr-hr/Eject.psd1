ConvertFrom-StringData -StringData @'
	# hr-HR
	# Croatian (Croatia)

	Save                            = Uštedjeti
	DoNotSave                       = Ne štedi
	DoNotSaveTips                   = Nepopravljivo, deinstalirajte sliku izravno.
	UnmountAndSave                  = Zatim deinstaliraj
	UnmountNotAssignMain            = Kada {0} nije dodijeljen
	UnmountNotAssignMain_Tips       = Tijekom skupne obrade morate odrediti želite li spremiti nedodijeljene glavne stavke ili ne.
	ImageEjectTips                  = Upozoriti\n\n    1. Prije spremanja preporučuje se da "Provjerite status ispravnosti" Kada se pojavi "Popravljivo" ili "Nepopravljivo": \n       * Tijekom procesa ESD konverzije prikazuje se pogreška 13 i podaci su nevažeći;\n       * Došlo je do greške prilikom instaliranja sustava.\n\n    2. Provjerite status ispravnosti, boot.wim nije podržan.\n\n    3. Kada postoji montirana datoteka na slici, a na slici nije navedena akcija deinstalacije, ona će biti spremljena prema zadanim postavkama.\n\n    4. Prilikom spremanja možete dodijeliti događaje proširenja;\n\n    5. Događaj nakon skočnog prozora bit će izvršen samo ako nije spremljen.
	ImageEjectSpecification         = Došlo je do pogreške prilikom deinstalacije {0}. Deinstalirajte proširenje i pokušajte ponovno.
	ImageEjectExpand                = Upravljanje datotekama unutar slike
	ImageEjectExpandTips            = Savjet\n\n    Provjerite stanje ispravnosti. Možete pokušati provjeriti nakon što ga omogućite.
	Image_Eject_Force               = Dopusti deinstalaciju izvanmrežnih slika
	ImageEjectDone                  = Nakon izvršenja svih zadataka

	Abandon_Allow                   = Dopusti brzo odlaganje
	Abandon_Allow_Auto              = Dopusti automatsko omogućavanje brzog odlaganja
	Abandon_Allow_Auto_Tips         = Nakon što omogućite ovu opciju, opcija "Dopusti brzo odlaganje" pojavit će se u odjeljku "Autopilot, Prilagođeno dodjeljivanje poznatih događaja, Skočni prozori". Ova značajka podržana je samo u: Glavnim zadacima.
	Abandon_Agreement               = Brzo odlaganje: Ugovor
	Abandon_Agreement_Disk_range    = Particije diska koje su prihvatile brzo odlaganje
	Abandon_Agreement_Allow         = Prihvaćam korištenje brzog odlaganja i više neću biti odgovoran za posljedice formatiranja particija diska
	Abandon_Terms                   = Uvjeti
	Abandon_Terms_Change            = Uvjeti su se promijenili
	Abandon_Allow_Format            = Dopusti formatiranje
	Abandon_Allow_UnFormat          = Neovlašteno formatiranje particija
	Abandon_Allow_Time_Range        = Dopuštanje izvršavanja PowerShell funkcija stupit će na snagu u bilo kojem trenutku
'@