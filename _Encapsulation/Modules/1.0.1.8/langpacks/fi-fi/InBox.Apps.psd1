ConvertFrom-StringData -StringData @'
	# fi-fi
	# Finnish (Finland)

	AdvAppsDetailed                 = Luo raportti
	AdvAppsDetailedTips             = Hae aluetunnisteen mukaan, saat lisätietoja, kun paikallisia kielikokemuspaketteja on saatavilla, ja luo raporttitiedosto: *.CSV.
	ProcessSources                  = Käsittelyn lähde
	InboxAppsManager                = Saapuneet sovellus
	InboxAppsMatchDel               = Poista sääntöjen mukaan
	InboxAppsOfflineDel             = Poista käytössä oleva sovellus
	InboxAppsClear                  = Poista kaikki asennetut esisovellukset väkisin ( InBox Apps )
	InBox_Apps_Match                = Yhdistä InBox Apps sovellukset
	InBox_Apps_Check                = Tarkista riippuvuuspaketit
	InBox_Apps_Check_Tips           = Hanki sääntöjen mukaisesti kaikki valitut asennuskohteet ja tarkista, onko riippuvaiset asennuskohteet valittu.
	LocalExperiencePack             = Paikallinen kielikokemuspaketti ( LXPs )
	LEPBrandNew                     = Uudella tavalla, suositeltava
	UWPAutoMissingPacker            = Etsi puuttuvat paketit automaattisesti kaikilta levyiltä
	UWPAutoMissingPackerSupport     = X64 arkkitehtuuri, puuttuvat paketit on asennettava.
	UWPAutoMissingPackerNotSupport  = Ei x64 arkkitehtuuri, käytetään, kun vain x64 arkkitehtuuri on tuettu.
	UWPEdition                      = Windows version yksilöllinen tunniste
	Optimize_Appx_Package           = Optimoi Appx pakettien hallinta korvaamalla identtiset tiedostot kovilla linkeillä
	Optimize_ing                    = Optimointi
	Remove_Appx_Tips                = Havainnollistaa:\n\nVaihe yksi: Lisää paikallisia kielikokemuspaketteja ( LXPs ) Tämän vaiheen on vastattava Microsoftin virallisesti julkaisemaa pakettia: \n       Lisää kielipaketteja Windows 10:n usean istunnon kuviin\n       https://learn.microsoft.com/fi-fi/azure/virtual-desktop/language-packs\n\n       Lisää kieliä Windows 11 Enterprise -kuviin\n       https://learn.microsoft.com/fi-fi/azure/virtual-desktop/windows-11-language-packs\n\nVaihe 2: Pura tai liitä *_InboxApps.iso ja valitse hakemisto arkkitehtuurin mukaan;\n\nVaihe 3: Jos Microsoft ei ole virallisesti julkaissut uusinta paikallista kielikokemuspakettia ( LXPs ), ohita tämä vaihe: katso Microsoftin virallinen ilmoitus:\n       1. Vastaa paikallisia kielikokemuspaketteja ( LXPs );\n       2. Vastaa kumulatiivisia päivityksiä. \n\nEsiasennetut sovellukset ( InBox Apps ) ovat yksikielisiä, ja ne on asennettava uudelleen, jotta ne ovat monikielisiä. \n\n1. Voit valita kehittäjäversion ja alkuperäisen version välillä;\n    Esimerkiksi kehittäjäversion versionumero on:\n    Windows 11 sarja\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Alkuperäinen versio, tunnettu alkuperäinen versio:\n    Windows 11 sarja\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 sarja\n    Windows 10 22H2, Build 19045.2006\n\n    tärkeä:\n      a. Luo kuva uudelleen, kun jokainen versio päivitetään. Älä esimerkiksi päivitä vanhan kuvan perusteella muiden yhteensopivuusongelmien välttämiseksi.\n      b. Jotkut OEM valmistajat ovat ilmoittaneet tästä määräyksestä selkeästi pakkaajille eri muodoissa, ja suorat päivitykset iteratiivisista versioista eivät ole sallittuja.\n      Avainsanat: iteraatio, ristiinversio, kumulatiivinen päivitys.\n\n2. Kielipaketin asennuksen jälkeen on lisättävä kumulatiiviset päivitykset, koska komponentteihin ei tehdä muutoksia ennen kuin kumulatiiviset päivitykset on asennettu. Esimerkiksi komponentin tila: vanhentunut , poistettava;\n\n3. Käytettäessä versiota, jossa on kumulatiivisia päivityksiä, sinun on silti lisättävä kumulatiivisia päivityksiä uudelleen, mikä on toistuva toimenpide;\n\n4. Siksi on suositeltavaa, että käytät versiota, jossa ei ole kumulatiivisia päivityksiä tuotannon aikana, ja lisäät sitten kumulatiiviset päivitykset viimeisessä vaiheessa.\n\nHakuehdot hakemiston valinnan jälkeen: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Puhdista päällekkäiset tiedostot
	ForceRemovaAllUWP               = Ohita paikallisten kielikokemuspakettien ( LXPs ) lisäys, suorita muita
	LEPSkipAddEnglish               = On suositeltavaa ohittaa en-US lisäys asennuksen aikana.
	LEPSkipAddEnglishTips           = Englannin oletuskielipakettia ei tarvita sen lisäämiseen.
	License                         = Todistus
	IsLicense                       = On todistus
	NoLicense                       = Ei todistusta
	CurrentIsNVeriosn               = N versio sarja
	CurrentNoIsNVersion             = Täysin toimiva versio
	LXPsWaitAddUpdate               = Päivitettävä
	LXPsWaitAdd                     = Lisättävä
	LXPsWaitAssign                  = Jaetaan
	LXPsWaitRemove                  = Poistettava
	LXPsAddDelTipsView              = Uusia vinkkejä on tullut, tarkista nyt
	LXPsAddDelTipsGlobal            = Ei enää kehotteita, synkronoi globaaliin
	LXPsAddDelTips                  = Älä kysy uudelleen
	Instl_Dependency_Package        = Salli riippuvien pakettien automaattinen kokoaminen, kun asennat InBox Apps sovelluksia
	Instl_Dependency_Package_Tips   = Kun lisättävässä sovelluksessa on riippuvaisia paketteja, se täsmää automaattisesti sääntöjen mukaisesti ja suorittaa tarvittavien riippuvien pakettien automaattisen yhdistämisen.
	Instl_Dependency_Package_Match  = Riippuvuuspakettien yhdistäminen
	Instl_Dependency_Package_Group  = Yhdistelmä
	InBoxAppsErrorNoSave            = Kun kohtaat virheen, sitä ei saa tallentaa
	InBoxAppsErrorTips              = Virheitä on, vastaavan {0} kohteen kohde oli epäonnistunut
	InBoxAppsErrorNo                = Vastaavasta virheistä ei löytynyt virheitä
'@