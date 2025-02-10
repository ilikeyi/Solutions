ConvertFrom-StringData -StringData @'
	# nl-NL
	# Dutch (Netherlands)

	AdvAppsDetailed                 = Rapport genereren
	AdvAppsDetailedTips             = Zoek op regiotag, krijg meer details wanneer er ervaringspakketten in de lokale taal beschikbaar zijn en genereer een rapportbestand: *.CSV.
	ProcessSources                  = Verwerkingsbron
	InboxAppsManager                = Inbox-app
	InboxAppsMatchDel               = Verwijderen door regels te matchen
	InboxAppsOfflineDel             = Een ingerichte toepassing verwijderen
	InboxAppsClear                  = Forceer verwijdering van alle geïnstalleerde pre-apps ( InBox Apps )
	InBox_Apps_Match                = Match InBox-apps
	InBox_Apps_Check                = Controleer afhankelijkheidspakketten
	InBox_Apps_Check_Tips           = Verkrijg volgens de regels alle geselecteerde installatie-items en controleer of de afhankelijke installatie-items zijn geselecteerd.
	LocalExperiencePack             = Lokale taalervaringspakketten ( LXPs )
	LEPBrandNew                     = Op een nieuwe manier, aanbevolen
	UWPAutoMissingPacker            = Zoek automatisch naar ontbrekende pakketten op alle schijven
	UWPAutoMissingPackerSupport     = X64-architectuur, ontbrekende pakketten moeten worden geïnstalleerd.
	UWPAutoMissingPackerNotSupport  = Niet-x64-architectuur, gebruikt wanneer alleen x64-architectuur wordt ondersteund.
	UWPEdition                      = Unieke identificatie van de Windows-versie
	Optimize_Appx_Package           = Optimaliseer de inrichting van Appx-pakketten door identieke bestanden te vervangen door harde links
	Optimize_ing                    = Optimaliseren
	Remove_Appx_Tips                = Illustreren:\n\nStap één: Voeg lokale taalervaringspakketten ( LXPs ) toe. Deze stap moet overeenkomen met het overeenkomstige pakket dat officieel door Microsoft is uitgebracht.\n       Voeg taalpakketten toe aan Windows 10-images met meerdere sessies\n       https://learn.microsoft.com/nl-nl/azure/virtual-desktop/language-packs\n\n       Voeg talen toe aan Windows 11 Enterprise images\n       https://learn.microsoft.com/nl-nl/azure/virtual-desktop/windows-11-language-packs\n\nStap 2: Unzip of mount *_InboxApps.iso, en selecteer de map volgens de architectuur;\n\nStap 3: Als Microsoft het nieuwste lokale taalervaringspakket ( LXPs ) niet officieel heeft uitgebracht, sla dan deze stap over als dat wel het geval is: raadpleeg de officiële aankondiging van Microsoft:\n       1. Komt overeen met lokale taalervaringspakketten ( LXPs );\n       2. Komt overeen met cumulatieve updates. \n\nVooraf geïnstalleerde apps ( InBox Apps ) zijn ééntalig en moeten opnieuw worden geïnstalleerd om meertalig te worden. \n\n1. U kunt kiezen tussen de ontwikkelaarsversie en de initiële versie;\n    Ontwikkelaarsversie, het versienummer is bijvoorbeeld:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    Initiële versie, bekende initiële versie:\n    Windows 11 serie\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 serie\n    Windows 10 22H2, Build 19045.2006\n\n    belangrijk: \n      a. Maak de afbeelding opnieuw wanneer elke versie wordt bijgewerkt. Als u bijvoorbeeld van 21H1 naar 22H2 gaat, update dan niet op basis van de oude afbeelding om andere compatibiliteitsproblemen te voorkomen. Gebruik opnieuw de oorspronkelijke versie.\n      b. Deze regelgeving is door sommige OEM-fabrikanten in verschillende vormen duidelijk aan verpakkers gecommuniceerd, en directe upgrades van iteratieve versies zijn niet toegestaan.\n      Trefwoorden: iteratie, cross-versie, cumulatieve update.\n\n2. Nadat u het taalpakket hebt geïnstalleerd, moet u een cumulatieve update toevoegen, omdat voordat de cumulatieve update wordt toegevoegd, het onderdeel geen wijzigingen zal ondergaan totdat de cumulatieve update is geïnstalleerd. Bijvoorbeeld de onderdeelstatus: verouderd, te verwijderen;\n\n3. Wanneer u een versie met cumulatieve updates gebruikt, moet u uiteindelijk toch weer cumulatieve updates toevoegen, wat een herhaalde handeling is;\n\n4. Daarom wordt aanbevolen dat u tijdens de productie een versie zonder cumulatieve updates gebruikt en vervolgens in de laatste stap cumulatieve updates toevoegt. \n\nZoekvoorwaarden na het selecteren van de directory: LanguageExperiencePack.*.Neutral.appx
	ImportCleanDuplicate            = Dubbele bestanden opruimen
	ForceRemovaAllUWP               = Sla de toevoeging van het lokale taalervaringspakket ( LXPs ) over, voer andere uit
	LEPSkipAddEnglish               = Het wordt aanbevolen om de toevoeging van en-US tijdens de installatie over te slaan.
	LEPSkipAddEnglishTips           = Het standaard Engelse taalpakket is niet nodig om het toe te voegen.
	License                         = Certificaat
	IsLicense                       = Certificaat hebben
	NoLicense                       = Geen certificaat
	CurrentIsNVeriosn               = N-versie serie
	CurrentNoIsNVersion             = Volledig functionele versie
	LXPsWaitAddUpdate               = Moet worden bijgewerkt
	LXPsWaitAdd                     = Toe te voegen
	LXPsWaitAssign                  = Toe te wijzen
	LXPsWaitRemove                  = Te verwijderen
	LXPsAddDelTipsView              = Er zijn nieuwe tips, kijk nu
	LXPsAddDelTipsGlobal            = Geen aanwijzingen meer, synchroniseer met globaal
	LXPsAddDelTips                  = Vraag niet opnieuw
	Instl_Dependency_Package        = Sta automatische samenstelling van afhankelijke pakketten toe bij het installeren van InBox Apps
	Instl_Dependency_Package_Tips   = Wanneer de toe te voegen applicatie afhankelijke pakketten heeft, zal deze automatisch overeenkomen volgens de regels en de functie van het automatisch combineren van de vereiste afhankelijke pakketten voltooien.
	Instl_Dependency_Package_Match  = Afhankelijkheidspakketten combineren
	Instl_Dependency_Package_Group  = Combinatie
	InBoxAppsErrorNoSave            = Bij het tegenkomen van een fout mag het niet worden opgeslagen
	InBoxAppsErrorTips              = Er zijn fouten, het item dat in het item Matching {0} werd aangetroffen, was niet succesvol
	InBoxAppsErrorNo                = Er werden geen fouten gevonden in de matching
'@