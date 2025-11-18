<#
	.Summary
	 Office silent installation

	.Description
	 Office silent installation, automatic framework recognition

	.Version
	 v1.0

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS command line: 

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

<#
	.Available languages
	.可用语言
#>
$Global:Languages_Available = @(
	<#
		RegionID = Decimal ID, ISO3166
		Region   = Language/region
		Tag      = Language/region tag
		Name     = Name
		Timezone = Timezone
		LIP      = LIP ID
		Expand   = Expand language
	#>
	@{
		RegionID = "1078"
		Region   = "af-za"
		Tag      = "af"
		Name     = "Afrikaans (South Africa)"
		Timezone = "Afghanistan Standard Time"
		LIP      = "9PDW16B5HMXR"
		Expand   = @()
	}
	@{
		RegionID = "1025"
		Region   = "ar-SA"
		Tag      = "ar"
		Name     = "Arabic (Saudi Arabia)"
		Timezone = "Argentina Standard Time"
		LIP      = "9N4S78P86PKX"
		Expand   = @(
			@{
				RegionID = "14337"
				Region   = "ar-ae"
				Tag      = "ar"
				Name     = "Arabic (U.A.E.)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "15361"
				Region   = "ar-BH"
				Tag      = "ar"
				Name     = "Arabic (Bahrain)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-DJ"
				Tag      = "ar"
				Name     = "Arabic (Djibouti)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "5121"
				Region   = "ar-DZ"
				Tag      = "ar"
				Name     = "Arabic (Algeria)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "3073"
				Region   = "ar-EG"
				Tag      = "ar"
				Name     = "Arabic (Egypt)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-ER"
				Tag      = "ar"
				Name     = "Arabic (Eritrea)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-IL"
				Tag      = "ar"
				Name     = "Arabic (Israel)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "2049"
				Region   = "ar-IQ"
				Tag      = "ar"
				Name     = "Arabic (Iraq)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "11265"
				Region   = "ar-JO"
				Tag      = "ar"
				Name     = "Arabic (Jordan)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-KM"
				Tag      = "ar"
				Name     = "Arabic (Comoros)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "13313"
				Region   = "ar-KW"
				Tag      = "ar"
				Name     = "Arabic (Kuwait)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "12289"
				Region   = "ar-LB"
				Tag      = "ar"
				Name     = "Arabic (Lebanon)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4097"
				Region   = "ar-LY"
				Tag      = "ar"
				Name     = "Arabic (Libya)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "6145"
				Region   = "ar-MA"
				Tag      = "ar"
				Name     = "Arabic (Morocco)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-MR"
				Tag      = "ar"
				Name     = "Arabic (Mauritania)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "8193"
				Region   = "ar-OM"
				Tag      = "ar"
				Name     = "Arabic (Oman)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-PS"
				Tag      = "ar"
				Name     = "Arabic (West Bank and Gaza)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "16385"
				Region   = "ar-QA"
				Tag      = "ar"
				Name     = "Arabic (Qatar)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-SD"
				Tag      = "ar"
				Name     = "Arabic (Sudan)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-SO"
				Tag      = "ar"
				Name     = "Arabic (Somalia)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-SS"
				Tag      = "ar"
				Name     = "Arabic (South Sudan)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "10241"
				Region   = "ar-SY"
				Tag      = "ar"
				Name     = "Arabic (Syria)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4096"
				Region   = "ar-TD"
				Tag      = "ar"
				Name     = "Arabic (Chad)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "7169"
				Region   = "ar-TN"
				Tag      = "ar"
				Name     = "Arabic (Tunisia)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "9217"
				Region   = "ar-YE"
				Tag      = "ar"
				Name     = "Arabic (Yemen)"
				Timezone = "Argentina Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1101"
		Region   = "as-in"
		Tag      = "as-in"
		Name     = "Assamese (India)"
		Timezone = "India Standard Time"
		LIP      = "9NTJLXMXX35J"
		Expand   = @()
	}
	@{
		RegionID = "1068"
		Region   = "az-latn-az"
		Tag      = "az-latn-az"
		Name     = "Azerbaijani (Latin, Azerbaijan)"
		Timezone = "Azerbaijan Standard Time"
		LIP      = "9P5TFKZHQ5K8"
		Expand   = @()
	}
	@{
		RegionID = "1133"
		Region   = "ba-ru"
		Tag      = "ba-ru"
		Name     = "Bashkir (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1059"
		Region   = "be-by"
		Tag      = "be-by"
		Name     = "Belarusian (Belarus)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9MXPBGNNDW3L"
		Expand   = @()
	}
	@{
		RegionID = "1026"
		Region   = "bg-BG"
		Tag      = "bg"
		Name     = "Bulgarian (Bulgaria)"
		Timezone = "FLE Standard Time"
		LIP      = "9MX54588434F"
		Expand   = @()
	}
	@{
		RegionID = "2117"
		Region   = "bn-bd"
		Tag      = "bn-bd"
		Name     = "Bangla (Bangladesh)"
		Timezone = "Bangladesh Standard Time"
		LIP      = "9PH7TKVXGGM8"
		Expand   = @()
	}
	@{
		RegionID = "1093"
		Region   = "bn-in"
		Tag      = "bn-in"
		Name     = "Bangla (India)"
		Timezone = "India Standard Time"
		LIP      = "9P1M44L7W84T"
		Expand   = @()
	}
	@{
		RegionID = "5146"
		Region   = "bs-latn-ba"
		Tag      = "bs-latn-ba"
		Name     = "Bosnian (Latin)"
		Timezone = "Central European Standard Time"
		LIP      = "9MVFKLJ10MFL"
		Expand   = @()
	}
	@{
		RegionID = "1027"
		Region   = "ca-es"
		Tag      = "ca-es"
		Name     = "Catalan (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9P6JMKJQZ9S7"
		Expand   = @()
	}
	@{
		RegionID = "1029"
		Region   = "cs-CZ"
		Tag      = "dz"
		Name     = "Czech (Czech Republic)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9P3WXZ1KTM7C"
		Expand   = @()
	}
	@{
		RegionID = "1106"
		Region   = "cy-gb"
		Tag      = "cy"
		Name     = "Welsh (United Kingdom)"
		Timezone = "E. Europe Standard Time"
		LIP      = "9NKJ9TBML4HB"
		Expand   = @()
	}
	@{
		RegionID = "1030"
		Region   = "da-DK"
		Tag      = "dk"
		Name     = "Danish (Denmark)"
		Timezone = "Romance Standard Time"
		LIP      = "9NDMT2VKSNL1"
		Expand   = @()
	}
	@{
		RegionID = "1031"
		Region   = "de-DE"
		Tag      = "de"
		Name     = "German (Germany)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P6CT0SLW589"
		Expand   = @(
			@{
				RegionID = "3079"
				Region   = "de-AT"
				Tag      = "de-AT"
				Name     = "German (Austria)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "5127"
				Region   = "de-LI"
				Tag      = "de-LI"
				Name     = "German (Liechtenstein)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "4103"
				Region   = "de-LU"
				Tag      = "de-LU"
				Name     = "German (Luxembourg)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "2055"
				Region   = "de-CH"
				Tag      = "de-CH"
				Name     = "German (Switzerland)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1032"
		Region   = "el-GR"
		Tag      = "gr"
		Name     = "Greek (Greece)"
		Timezone = "GTB Standard Time"
		LIP      = "9N586B13PBLD"
		Expand   = @()
	}
	@{
		RegionID = "2057"
		Region   = "en-gb"
		Tag      = "gb"
		Name     = "English (United Kingdom)"
		Timezone = "GMT Standard Time"
		LIP      = "9NT52VQ39BVN"
		Expand   = @(
			@{
				RegionID = "3081"
				Region   = "en-au"
				Tag      = "en-au"
				Name     = "English (Australia)"
				Timezone = "GMT Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "16393"
				Region   = "en-in"
				Tag      = "en-in"
				Name     = "English (India)"
				Timezone = "GMT Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1033"
		Region   = "en-US"
		Tag      = "en"
		Name     = "English (United States)"
		Timezone = "Pacific Standard Time"
		LIP      = "9PDSCC711RVF"
		Expand   = @(
			@{
				RegionID = "4105"
				Region   = "en-ca"
				Tag      = "en-ca"
				Name     = "English (Canada)"
				Timezone = "Pacific Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "1025"
				Region   = "ar-SA"
				Tag      = "ar"
				Name     = "Arabic (Saudi Arabia)"
				Timezone = "Argentina Standard Time"
				LIP      = "9N4S78P86PKX"
			}
			@{
				RegionID = "1026"
				Region   = "bg-BG"
				Tag      = "bg"
				Name     = "Bulgarian (Bulgaria)"
				Timezone = "FLE Standard Time"
				LIP      = "9MX54588434F"
			}
			@{
				RegionID = "1030"
				Region   = "da-DK"
				Tag      = "dk"
				Name     = "Danish (Denmark)"
				Timezone = "Romance Standard Time"
				LIP      = "9NDMT2VKSNL1"
			}
			@{
				RegionID = "1032"
				Region   = "el-GR"
				Tag      = "gr"
				Name     = "Greek (Greece)"
				Timezone = "GTB Standard Time"
				LIP      = "9N586B13PBLD"
			}
			@{
				RegionID = "1037"
				Region   = "he-IL"
				Tag      = "il"
				Name     = "Hebrew (Israel)"
				Timezone = "Israel Standard Time"
				LIP      = "9NB6ZFND5HCQ"
			}
			@{
				RegionID = "1049"
				Region   = "ru-RU"
				Tag      = "ru"
				Name     = "Russian (Russia)"
				Timezone = "Russian Standard Time"
				LIP      = "9NMJCX77QKPX"
			}
			@{
				RegionID = "10266"
				Region   = "sr-cyrl-rs"
				Tag      = "sr-cyrl-rs"
				Name     = "Serbian (Cyrillic, Serbia)"
				Timezone = "Central Europe Standard Time"
				LIP      = "9PPD6CCK9K5H"
			}
			@{
				RegionID = "1054"
				Region   = "th-TH"
				Tag      = "th"
				Name     = "Thai (Thailand)"
				Timezone = "SE Asia Standard Time"
				LIP      = "9MSTWFRL0LR4"
			}
			@{
				RegionID = "1058"
				Region   = "uk-UA"
				Tag      = "ua"
				Name     = "Ukrainian (Ukraine)"
				Timezone = "FLE Standard Time"
				LIP      = "9PPPMZRSGHR8"
			}
		)
	}
	@{
		RegionID = "3082"
		Region   = "es-ES"
		Tag      = "es-ES"
		Name     = "Spanish (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9NWVGWLHPB1Z"
		Expand   = @()
	}
	@{
		RegionID = "2058"
		Region   = "es-MX"
		Tag      = "mx"
		Name     = "Spanish (Mexico)"
		Timezone = "Central Standard Time (Mexico)"
		LIP      = "9N8MCM1X3928"
		Expand   = @(
			@{
				RegionID = "22538"
				Region   = "es-419"
				Tag      = "es-419"
				Name     = "Spanish (Latin America)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "11274"
				Region   = "es-AR"
				Tag      = "es-AR"
				Name     = "Spanish (Argentina)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "16394"
				Region   = "es-BO"
				Tag      = "es-BO"
				Name     = "Spanish (Bolivia)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "13322"
				Region   = "es-CL"
				Tag      = "es-CL"
				Name     = "Spanish (Chile)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "9226"
				Region   = "es-CO"
				Tag      = "es-CO"
				Name     = "Spanish (Colombia)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "5130"
				Region   = "es-CR"
				Tag      = "es-CR"
				Name     = "Spanish (Costa Rica)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "7178"
				Region   = "es-DO"
				Tag      = "es-DO"
				Name     = "Spanish (Dominican Republic)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "12298"
				Region   = "es-EC"
				Tag      = "es-EC"
				Name     = "Spanish (Ecuador)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "4106"
				Region   = "es-GT"
				Tag      = "es-GT"
				Name     = "Spanish (Guatemala)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "18442"
				Region   = "es-HN"
				Tag      = "es-HN"
				Name     = "Spanish (Honduras)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "19466"
				Region   = "es-NI"
				Tag      = "es-NI"
				Name     = "Spanish (Nicaragua)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "6154"
				Region   = "es-PA"
				Tag      = "es-PA"
				Name     = "Spanish (Panama)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "10250"
				Region   = "es-PE"
				Tag      = "es-PE"
				Name     = "Spanish (Peru)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "20490"
				Region   = "es-PR"
				Tag      = "es-PR"
				Name     = "Spanish (Puerto Rico)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "15370"
				Region   = "es-PY"
				Tag      = "es-PY"
				Name     = "Spanish (Paraguay)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "17418"
				Region   = "es-SV"
				Tag      = "es-SV"
				Name     = "Spanish (El Salvador)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "21514"
				Region   = "es-US"
				Tag      = "es-US"
				Name     = "Spanish (United States)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "14346"
				Region   = "es-UY"
				Tag      = "es-UY"
				Name     = "Spanish (Uruguay)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
			@{
				RegionID = "8202"
				Region   = "es-VE"
				Tag      = "es-VE"
				Name     = "Spanish (Venezuela)"
				Timezone = "Central Standard Time (Mexico)"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1061"
		Region   = "et-EE"
		Tag      = "ee"
		Name     = "Estonian (Estonia)"
		Timezone = "FLE Standard Time"
		LIP      = "9NFBHFMCR30L"
		Expand   = @()
	}
	@{
		RegionID = "1069"
		Region   = "eu-es"
		Tag      = "eu-es"
		Name     = "Basque (Basque)"
		Timezone = "Romance Standard Time"
		LIP      = "9NMCHQHZ37HZ"
		Expand   = @()
	}
	@{
		RegionID = "1065"
		Region   = "fa-ir"
		Tag      = "fa"
		Name     = "Farsi (Iran)"
		Timezone = "Iran Standard Time"
		LIP      = "9NGS7DD4QS21"
		Expand   = @()
	}
	@{
		RegionID = "1035"
		Region   = "fi-FI"
		Tag      = "fi"
		Name     = "Finnish (Finland)"
		Timezone = "FLE Standard Time"
		LIP      = "9MW3PQ7SD3QK"
		Expand   = @()
	}
	@{
		RegionID = "1124"
		Region   = "fil-ph"
		Tag      = "fil-ph"
		Name     = "Filipino (Philippines)"
		Timezone = "Singapore Standard Time"
		LIP      = "9NWM2KGTDSSS"
		Expand   = @()
	}
	@{
		RegionID = "3084"
		Region   = "fr-CA"
		Tag      = "ca"
		Name     = "French (Canada)"
		Timezone = "Eastern Standard Time"
		LIP      = "9MTP2VP0VL92"
		Expand   = @()
	}
	@{
		RegionID = "1036"
		Region   = "fr-FR"
		Tag      = "fr"
		Name     = "French (France)"
		Timezone = "Central European Time"
		LIP      = "9NHMG4BJKMDG"
		Expand   = @(
			@{
				RegionID = "2060"
				Region   = "fr-BE"
				Tag      = "fr-BE"
				Name     = "French (Belgium)"
				Timezone = "Central European Time"
				LIP      = ""
			}
			@{
				RegionID = "7180"
				Region   = "fr-029"
				Tag      = "fr-029"
				Name     = "French (Caribbean)"
				Timezone = "Central European Time"
				LIP      = ""
			}
			@{
				RegionID = "5132"
				Region   = "fr-LU"
				Tag      = "fr-LU"
				Name     = "French (Luxembourg)"
				Timezone = "Central European Time"
				LIP      = ""
			}
			@{
				RegionID = "6156"
				Region   = "fr-MC"
				Tag      = "fr-MC"
				Name     = "French (Monaco)"
				Timezone = "Central European Time"
				LIP      = ""
			}
			@{
				RegionID = "4108"
				Region   = "fr-CH"
				Tag      = "fr-CH"
				Name     = "French (Switzerland)"
				Timezone = "Central European Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "2108"
		Region   = "ga-ie"
		Tag      = "ga-ie"
		Name     = "Irish (Ireland)"
		Timezone = "GMT Standard Time"
		LIP      = "9P0L5Q848KXT"
		Expand   = @()
	}
	@{
		RegionID = "1169"
		Region   = "gd-gb"
		Tag      = "gd-gb"
		Name     = "Scottish Gaelic (United Kingdom)"
		Timezone = "GMT Standard Time"
		LIP      = "9P1DBPF36BF3"
		Expand   = @()
	}
	@{
		RegionID = "1110"
		Region   = "gl-es"
		Tag      = "gl"
		Name     = "Galician (Spain)"
		Timezone = "Greenland Standard Time"
		LIP      = "9NXRNBRNJN9B"
		Expand   = @()
	}
	@{
		RegionID = "1095"
		Region   = "gu-in"
		Tag      = "gu"
		Name     = "Gujarati (India)"
		Timezone = "West Pacific Standard Time"
		LIP      = "9P2HMSWDJDQ1"
		Expand   = @()
	}
	@{
		RegionID = "1128"
		Region   = "ha-latn-ng"
		Tag      = "ha-latn-ng"
		Name     = "Hausa (Latin, Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9N1L95DBGRG3"
		Expand   = @()
	}
	@{
		RegionID = "1141"
		Region   = "haw-us"
		Tag      = "haw-us"
		Name     = "Hawaiian (United States)"
		Timezone = "Pacific Standard Time"
		LIP      = ""
		Expand   = @()
	}
 	@{
		RegionID = "1037"
		Region   = "he-IL"
		Tag      = "il"
		Name     = "Hebrew (Israel)"
		Timezone = "Israel Standard Time"
		LIP      = "9NB6ZFND5HCQ"
		Expand   = @()
	}
	@{
		RegionID = "1050"
		Region   = "hr-HR"
		Tag      = "hr"
		Name     = "Croatian (Croatia)"
		Timezone = "Central European Standard Time"
		LIP      = "9NW01VND4LTW"
		Expand   = @()
	}
	@{
		RegionID = "1038"
		Region   = "hu-HU"
		Tag      = "hu"
		Name     = "Hungarian (Hungary)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9MWN3C58HL87"
		Expand   = @()
	}
	@{
		RegionID = "1067"
		Region   = "hy-am"
		Tag      = "hy"
		Name     = "Armenian (Armenia)"
		Timezone = "Caucasus Standard Time"
		LIP      = "9NKM28TM6P67"
		Expand   = @()
	}
	@{
		RegionID = "1057"
		Region   = "id-id"
		Tag      = "id"
		Name     = "Indonesian (Indonesia)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9P4X3N4SDK8P"
		Expand   = @()
	}
	@{
		RegionID = "1136"
		Region   = "ig-ng"
		Tag      = "ig-ng"
		Name     = "Igbo (Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9PG4ZFJ48JSX"
		Expand   = @()
	}
	@{
		RegionID = "1039"
		Region   = "is-is"
		Tag      = "is"
		Name     = "Icelandic (Iceland)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9NTHJR7TQXX1"
		Expand   = @()
	}
	@{
		RegionID = "1040"
		Region   = "it-IT"
		Tag      = "it"
		Name     = "Italian (Italy)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P8PQWNS6VJX"
		Expand   = @(
			@{
				RegionID = "2064"
				Region   = "it-CH"
				Tag      = "it-CH"
				Name     = "Italian (Switzerland)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1041"
		Region   = "ja-JP"
		Tag      = "jp"
		Name     = "Japanese (Japan)"
		Timezone = "Tokyo Standard Time"
		LIP      = "9N1W692FV4S1"
		Expand   = @()
	}
	@{
		RegionID = "1079"
		Region   = "ka-ge"
		Tag      = "ka"
		Name     = "Georgian (Georgia)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9P60JZL05WGH"
		Expand   = @()
	}
	@{
		RegionID = "1087"
		Region   = "kk-kz"
		Tag      = "kk"
		Name     = "Kazakh (Kazakhstan)"
		Timezone = "Central Asia Standard Time"
		LIP      = "9PHV179R97LV"
		Expand   = @()
	}
	@{
		RegionID = "1135"
		Region   = "kl-gl"
		Tag      = "kl-gl"
		Name     = "Kalaallisut (Greenland)"
		Timezone = "Greenland Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1099"
		Region   = "kn-in"
		Tag      = "kn"
		Name     = "Kannada (India)"
		Timezone = "SA Western Standard Time"
		LIP      = "9NC6DB7N95F9"
		Expand   = @()
	}
	@{
		RegionID = "1111"
		Region   = "kok-in"
		Tag      = "kok"
		Name     = "Konkani (India)"
		Timezone = "India Standard Time"
		LIP      = "9MV3P55CMZ6P"
		Expand   = @()
	}
	@{
		RegionID = "1042"
		Region   = "ko-KR"
		Tag      = "kr"
		Name     = "Korean (Korea)"
		Timezone = "Korea Standard Time"
		LIP      = "9N4TXPCVRNGF"
		Expand   = @()
	}
	@{
		RegionID = "1088"
		Region   = "ky-kg"
		Tag      = "ky"
		Name     = "Kyrgyz (Kyrgyzstan)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9P7D3JJGZM48"
		Expand   = @()
	}
	@{
		RegionID = "1134"
		Region   = "lb-lu"
		Tag      = "lb-lu"
		Name     = "Luxembourgish (Luxembourg)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9N0ST1WBZ9D9"
		Expand   = @()
	}
	@{
		RegionID = "1063"
		Region   = "lt-LT"
		Tag      = "lt"
		Name     = "Lithuanian (Lithuania)"
		Timezone = "FLE Standard Time"
		LIP      = "9NWWD891H6HN"
		Expand   = @()
	}
	@{
		RegionID = "1062"
		Region   = "lv-LV"
		Tag      = "lv"
		Name     = "Latvian (Latvia)"
		Timezone = "FLE Standard Time"
		LIP      = "9N5CQDPH6SQT"
		Expand   = @()
	}
	@{
		RegionID = "1153"
		Region   = "mi-nz"
		Tag      = "mi"
		Name     = "Maori (New Zealand)"
		Timezone = "New Zealand Standard Time"
		LIP      = "9P2GDFB3JPSX"
		Expand   = @()
	}
	@{
		RegionID = "1071"
		Region   = "mk-mk"
		Tag      = "mk"
		Name     = "Macedonian (North Macedonia)"
		Timezone = "Central European Standard Time"
		LIP      = "9P1X6XB1K3RN"
		Expand   = @()
	}
	@{
		RegionID = "1100"
		Region   = "ml-in"
		Tag      = "ml-in"
		Name     = "Malayalam (India)"
		Timezone = "Central European Standard Time"
		LIP      = "9NWDTV8FFV7L"
		Expand   = @()
	}
	@{
		RegionID = "1104"
		Region   = "mn-mn"
		Tag      = "mn"
		Name     = "Mongolian (Mongolia)"
		Timezone = "Ulaanbaatar Standard Time"
		LIP      = "9PG1DHC4VTZW"
		Expand   = @()
	}
	@{
		RegionID = "1102"
		Region   = "mr-in"
		Tag      = "mr"
		Name     = "Marathi (India)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9MWXCKHJVR1J"
		Expand   = @()
	}
	@{
		RegionID = "2110"
		Region   = "ms-bn"
		Tag      = "ms-bn"
		Name     = "Malay (Brunei)"
		Timezone = "Singapore Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1086"
		Region   = "ms-my"
		Tag      = "ms-my"
		Name     = "Malay (Malaysia)"
		Timezone = "Singapore Standard Time"
		LIP      = "9NPXL8ZSDDQ7"
		Expand   = @()
	}
	@{
		RegionID = "1082"
		Region   = "mt-mt"
		Tag      = "mt"
		Name     = "Maltese (Malta)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PDG96SQ6BN8"
		Expand   = @()
	}
	@{
		RegionID = "1044"
		Region   = "nb-NO"
		Tag      = "no"
		Name     = "Norwegian, Bokmål (Norway)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9N6J0M5DHCK0"
		Expand   = @()
	}
	@{
		RegionID = "1121"
		Region   = "ne-np"
		Tag      = "ne-np"
		Name     = "Nepali (Nepal)"
		Timezone = "Nepal Standard Time"
		LIP      = "9P7CHPLWDQVN"
		Expand   = @()
	}
	@{
		RegionID = "1043"
		Region   = "nl-NL"
		Tag      = "nl"
		Name     = "Dutch (Netherlands)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PF1C9NB5PRV"
		Expand   = @(
			@{
				RegionID = "2067"
				Region   = "nl-be"
				Tag      = "nl-be"
				Name     = "Dutch (Belgium)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "2068"
		Region   = "nn-no"
		Tag      = "nn-no"
		Name     = "Norwegian (Nynorsk) (Norway)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PK7KM3Z06KH"
		Expand   = @()
	}
	@{
		RegionID = "1132"
		Region   = "nso-za"
		Tag      = "nso-za"
		Name     = "Sesotho sa Leboa (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NS49QLX5CDV"
		Expand   = @()
	}
	@{
		RegionID = "1096"
		Region   = "or-in"
		Tag      = "or-in"
		Name     = "Odia (India)"
		Timezone = "India Standard Time"
		LIP      = "9NTHCXCXSJDH"
		Expand   = @()
	}
	@{
		RegionID = "1094"
		Region   = "pa-in"
		Tag      = "pa"
		Name     = "Punjabi (India)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9NSNC0ZJX69B"
		Expand   = @()
	}
	@{
		RegionID = "1045"
		Region   = "pl-PL"
		Tag      = "pl"
		Name     = "Polish (Poland)"
		Timezone = "Central European Standard Time"
		LIP      = "9NC5HW94R0LD"
		Expand   = @()
	}
	@{
		RegionID = "1123"
		Region   = "ps-af"
		Tag      = "ps-af"
		Name     = "Pashto (Afghanistan)"
		Timezone = "Afghanistan Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1046"
		Region   = "pt-BR"
		Tag      = "br"
		Name     = "Portuguese (Brazil)"
		Timezone = "E. South America Standard Time"
		LIP      = "9P8LBDM4FW35"
		Expand   = @()
	}
	@{
		RegionID = "2070"
		Region   = "pt-PT"
		Tag      = "pt"
		Name     = "Portuguese (Portugal)"
		Timezone = "GMT Standard Time"
		LIP      = "9P7X8QJ7FL0X"
		Expand   = @()
	}
	@{
		RegionID = "1047"
		Region   = "rm-ch"
		Tag      = "rm-ch"
		Name     = "Romansh (Switzerland)"
		Timezone = "GTB Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1048"
		Region   = "ro-RO"
		Tag      = "ro"
		Name     = "Romanian (Romania)"
		Timezone = "GTB Standard Time"
		LIP      = "9MWXGPJ5PJ3H"
		Expand   = @()
	}
	@{
		RegionID = "2072"
		Region   = "ro-md"
		Tag      = "ro-md"
		Name     = "Romanian (Moldova)"
		Timezone = "GTB Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1049"
		Region   = "ru-RU"
		Tag      = "ru"
		Name     = "Russian (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = "9NMJCX77QKPX"
		Expand   = @()
	}
	@{
		RegionID = "1157"
		Region   = "sah-ru"
		Tag      = "sah-ru"
		Name     = "Sakha (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = ""
		Expand   = @()
	}
	@{
		RegionID = "1115"
		Region   = "si-lk"
		Tag      = "si-lk"
		Name     = "Sinhala (Sri Lanka)"
		Timezone = "Sri Lanka Standard Time"
		LIP      = "9NVF9QSLGTL0"
		Expand   = @()
	}
	@{
		RegionID = "1051"
		Region   = "sk-SK"
		Tag      = "sk"
		Name     = "Slovak (Slovakia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9N7LSNN099WB"
		Expand   = @()
	}
	@{
		RegionID = "1060"
		Region   = "sl-SI"
		Tag      = "si"
		Name     = "Slovenian (Slovenia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NV27L34J4ST"
		Expand   = @()
	}
	@{
		RegionID = "1052"
		Region   = "sq-al"
		Tag      = "sq"
		Name     = "Albanian (Albania)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9MWLRGNMDGK7"
		Expand   = @()
	}
	@{
		RegionID = "10266"
		Region   = "sr-cyrl-rs"
		Tag      = "sr-cyrl-rs"
		Name     = "Serbian (Cyrillic, Serbia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9PPD6CCK9K5H"
		Expand   = @(
			@{
				RegionID = "7194"
				Region   = "sr-cyrl-ba"
				Tag      = "sr-cyrl-ba"
				Name     = "Serbian (Cyrillic, Bosnia and Herzegovina)"
				Timezone = "Central European Standard Time"
				LIP      = "9MXGN7V65C7B"
			}
			@{
				RegionID = "12314"
				Region   = "sr-cyrl-ME"
				Tag      = "sr-cyrl-ME"
				Name     = "Serbian (Cyrillic, Montenegro)"
				Timezone = "Central Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "9242"
		Region   = "sr-latn-rs"
		Tag      = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NBZ0SJDPPVT"
		Expand   = @(
			@{
				RegionID = "6170"
				Region   = "sr-latn-BA"
				Tag      = "sr-latn-BA"
				Name     = "Serbian (Latin, Bosnia and Herzegovina)"
				Timezone = "Central Europe Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "11290"
				Region   = "sr-latn-ME"
				Tag      = "sr-latn-ME"
				Name     = "Serbian (Latin, Montenegro)"
				Timezone = "Central Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1053"
		Region   = "sv-SE"
		Tag      = "se"
		Name     = "Swedish (Sweden)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P0HSNX08177"
		Expand   = @(
			@{
				RegionID = "2077"
				Region   = "sv-fi"
				Tag      = "sv-fi"
				Name     = "Swedish (Finland)"
				Timezone = "W. Europe Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1089"
		Region   = "sw-ke"
		Tag      = "sw-ke"
		Name     = "Kiswahili (Kenya)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NFF2M19DQ55"
		Expand   = @()
	}
	@{
		RegionID = "1097"
		Region   = "ta-in"
		Tag      = "ta-in"
		Name     = "Tamil (India)"
		Timezone = "India Standard Time"
		LIP      = "9PDZB1WT1B34"
		Expand   = @(
			@{
				RegionID = "2121"
				Region   = "ta-LK"
				Tag      = "ta-LK"
				Name     = "Tamil (Sri Lanka)"
				Timezone = "India Standard Time"
				LIP      = ""
			}
			@{
				RegionID = "1098"
				Region   = "te-in"
				Tag      = "te-in"
				Name     = "Telugu (India)"
				Timezone = "India Standard Time"
				LIP      = "9PMQJJGF63FW"
			}
		)
	}
	@{
		RegionID = "1064"
		Region   = "tg-cyrl-tj"
		Tag      = "tg-cyrl-tj"
		Name     = "Tajik (Cyrillic)"
		Timezone = "West Asia Standard Time"
		LIP      = "9MZHLBPPT2HC"
		Expand   = @()
	}
	@{
		RegionID = "1054"
		Region   = "th-TH"
		Tag      = "th"
		Name     = "Thai (Thailand)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9MSTWFRL0LR4"
		Expand   = @()
	}
	@{
		RegionID = "1090"
		Region   = "tk-tm"
		Tag      = "tk-tm"
		Name     = "Turkmen (Turkmenistan)"
		Timezone = "West Asia Standard Time"
		LIP      = "9NKHQ4GL6VLT"
		Expand   = @()
	}
	@{
		RegionID = "1074"
		Region   = "tn-za"
		Tag      = "tn-za"
		Name     = "Tswana (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NFSXM123DHT"
		Expand   = @(
			@{
				RegionID = "2098"
				Region   = "tn-BW"
				Tag      = "tn-BW"
				Name     = "Tamil (Sri Lanka)"
				Timezone = "South Africa Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1055"
		Region   = "tr-TR"
		Tag      = "tr"
		Name     = "Turkish (Turkey)"
		Timezone = "Turkey Standard Time"
		LIP      = "9NL1D3T5HG9R"
		Expand   = @()
	}
	@{
		RegionID = "1092"
		Region   = "tt-ru"
		Tag      = "tt-ru"
		Name     = "Tatar (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = "9NV90Q1X1ZR2"
		Expand   = @()
	}
	@{
		RegionID = "1152"
		Region   = "ug-cn"
		Tag      = "ug-cn"
		Name     = "Uyghur (People's Republic of China)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9P52C5D7VL5S"
		Expand   = @()
	}
	@{
		RegionID = "1058"
		Region   = "uk-UA"
		Tag      = "ua"
		Name     = "Ukrainian (Ukraine)"
		Timezone = "FLE Standard Time"
		LIP      = "9PPPMZRSGHR8"
		Expand   = @()
	}
	@{
		RegionID = "1056"
		Region   = "ur-pk"
		Tag      = "ur-pk"
		Name     = "Urdu (Islamic Republic of Pakistan)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NDWFTFW12BQ"
		Expand   = @(
			@{
				RegionID = "2080"
				Region   = "ur-IN"
				Tag      = "ur-IN"
				Name     = "Urdu (India)"
				Timezone = "Pakistan Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1091"
		Region   = "uz-latn-uz"
		Tag      = "uz-latn-uz"
		Name     = "Uzbek (Latin)"
		Timezone = "West Asia Standard Time"
		LIP      = "9P5P2T5P5L9S"
		Expand   = @()
	}
	@{
		RegionID = "1066"
		Region   = "vi-vn"
		Tag      = "vi-vn"
		Name     = "Vietnamese (Vietnam)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9P0W68X0XZPT"
		Expand   = @()
	}
	@{
		RegionID ="1160"
		Region   = "wo-sn"
		Tag      = "wo-sn"
		Name     = "Wolof (Senegal)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9NH3SW1CR90F"
		Expand   = @()
	}
	@{
		RegionID = "1076"
		Region   = "xh-za"
		Tag      = "xh-za"
		Name     = "Xhosa (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NW3QWSLQD17"
		Expand   = @()
	}
	@{
		RegionID = "1130"
		Region   = "yo-ng"
		Tag      = "yo-ng"
		Name     = "Yoruba (Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9NGM3VPPZS5V"
		Expand   = @()
	}
	@{
		RegionID = "2052"
		Region   = "zh-CN"
		Tag      = "cn"
		Name     = "Chinese (Simplified, China)"
		Timezone = "China Standard Time"
		LIP      = "9NRMNT6GMZ70"
		Expand   = @()
	}
	@{
		RegionID = "1028"
		Region   = "zh-TW"
		Tag      = "tw"
		Name     = "Chinese (Traditional, Taiwan)"
		Timezone = "Taipei Standard Time"
		LIP      = "9PCJ4DHCQ1JQ"
		Expand   = @(
			@{
				RegionID = "1028"
				Region   = "zh-HK"
				Tag      = "hk"
				Name     = "Chinese (Traditional, Hong Kong SAR)"
				Timezone = "China Standard Time"
				LIP      = ""
			}
		)
	}
	@{
		RegionID = "1130"
		Region   = "zu-za"
		Tag      = "zu-za"
		Name     = "Zulu (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NNRM7KT5NB0"
		Expand   = @()
	}
	@{
		RegionID = "1116"
		Region   = "chr-cher-us"
		Tag      = "chr-cher-us"
		Name     = "Cherokee (United States)"
		Timezone = "Central Standard Time (Mexico)"
		LIP      = "9MX15485N3RK"
		Expand   = @()
	}
	@{
		RegionID = "1081"
		Region   = "hi-in"
		Tag      = "hi"
		Name     = "Hindi (India)"
		Timezone = "India Standard Time"
		LIP      = "9NZC3GRX8LD3"
		Expand   = @()
	}
	@{
		RegionID = "1118"
		Region   = "am-et"
		Tag      = "am-et"
		Name     = "Amharic (Ethiopia)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NGL4R61W3PL"
		Expand   = @()
	}
	@{
		RegionID = "1159"
		Region   = "rw-rw"
		Tag      = "rw-rw"
		Name     = "Kinyarwanda (Rwanda)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NFW0M20H9WG"
		Expand   = @()
	}
	@{
		RegionID = "2051"
		Region   = "ca-es-valencia"
		Tag      = "ca-es-valencia"
		Name     = "Valencian (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9P9K3WMFSW90"
		Expand   = @()
	}
	@{
		RegionID = "1107"
		Region   = "km-kh"
		Tag      = "km-kh"
		Name     = "Khmer (Cambodia)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9PGKTS4JS531"
		Expand   = @()
	}
	@{
		RegionID = "1170"
		Region   = "ku-arab-iq"
		Tag      = "ku-arab-iq"
		Name     = "Central Kurdish (Iraq)"
		Timezone = "Arabic Standard Time"
		LIP      = "9P1C18QL3D7H"
		Expand   = @()
	}
	@{
		RegionID = "1108"
		Region   = "lo-la"
		Tag      = "lo-la"
		Name     = "Lao (Laos)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9N8X352G5NZV"
		Expand   = @()
	}
	@{
		RegionID = "2118"
		Region   = "pa-arab-pk"
		Tag      = "pa-arab-pk"
		Name     = "Punjabi (Arabic, Pakistan)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NJRL03WH6FM"
		Expand   = @()
	}
	@{
		RegionID = "1164"
		Region   = "prs-af"
		Tag      = "prs-af"
		Name     = "Dari (Afghanistan)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9P3NGC6X5ZQC"
		Expand   = @()
	}
	@{
		RegionID = "1158"
		Region   = "quc-latn-gt"
		Tag      = "quc-latn-gt"
		Name     = "K'iche' (Guatemala)"
		Timezone = "Central America Standard Time"
		LIP      = "9P2V6MNNQZ0B"
		Expand   = @()
	}
	@{
		RegionID = "3179"
		Region   = "quz-pe"
		Tag      = "quz-pe"
		Name     = "Quechua (Peru)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9NHTX8NVQ04K"
		Expand   = @()
	}
	@{
		RegionID = "2137"
		Region   = "sd-arab-pk"
		Tag      = "sd-arab-pk"
		Name     = "Sindhi (Arabic)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NB9JSCXW9X5"
		Expand   = @()
	}
	@{
		RegionID = "1139"
		Region   = "ti-et"
		Tag      = "ti-et"
		Name     = "Tigrinya (Ethiopia)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NC8C9RDNK2S"
		Expand   = @()
	}
)

Function Language_Region
{
	$LanguageFull = @()

	ForEach ($item in $Global:Languages_Available) {
		if ($LanguageFull.Region -NotContains $item.Region) {
			$LanguageFull += @{
				RegionID = $item.RegionID
				Region   = $item.Region
				Tag      = $item.Tag
				Name     = $item.Name
				Timezone = $item.Timezone
				LIP      = $item.LIP
			}
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($itemExpand in $item.Expand) {
				if ($LanguageFull.Region -NotContains $itemExpand.Region) {
					$LanguageFull += @{
						RegionID = $itemExpand.RegionID
						Region   = $itemExpand.Region
						Tag      = $itemExpand.Tag
						Name     = $itemExpand.Name
						Timezone = $itemExpand.Timezone
						LIP      = $itemExpand.LIP
					}
				}
			}
		}
	}

	return $LanguageFull
}

<#
	.Installation processing
	.安装处理
#>
Function Install-Process
{
	param
	(
		[string]$Version,
		[switch]$Activation,
		[switch]$Cleanup,
		[switch]$Force
	)

	<#
		1. 判断是否存在 Setup.exe
		1. Determine if a Setup .exe exists
	#>
	$Init_Setup = "$($PSScriptRoot)\Setup.exe"

	if (-not (Test-Path $Init_Setup -PathType Leaf)) {
		Write-Host "   - No ODT tool found" -ForegroundColor Red

		$start_time = Get-Date
		Invoke-WebRequest -Uri "https://officecdn.microsoft.com/pr/wsus/setup.exe" -OutFile $Init_Setup -TimeoutSec 30 -DisableKeepAlive -ErrorAction SilentlyContinue | Out-Null
		Write-Host "`n   Time Used: $((Get-Date).Subtract($start_time).Seconds) (s)`n"
	}

	if (Test-Path $Init_Setup -PathType Leaf) {
		Write-Host "`n   Discover the ODT tool`n   $($Init_Setup)" -ForegroundColor Green
	} else {
		Write-Host "   - No ODT tool found" -ForegroundColor Red
		return
	}

	$Global:UILanguage = (Get-Culture).Name
	$Global:OfficeSP = Convert-Path "$($PSScriptRoot)" -ErrorAction SilentlyContinue

	<#
		.部署前，获取已知语言并同步至配置文件

		.获取已安装的语言包
	#>
	$GetKnownLanguages = @()
	$GetAddedLanguage = @()
	$TempOfficeLanguage = @()
	Get-ChildItem "$($PSScriptRoot)\Data" -directory -ErrorAction SilentlyContinue | Foreach-Object {
		ForEach ($itemRegion in $Region) {
			Get-ChildItem -Path $_.FullName -Filter "*$($itemRegion.Region)*" -Include *.dat -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				if (Test-Path -Path $_.FullName -PathType Leaf) {
					$GetKnownLanguages += $itemRegion.Region
				}
			}
		}
	}

	<#
		.Get the default language of the current operating system
		.获取当前操作系统默认语言
	#>
	Write-Host "`n   Main language: $($Global:UILanguage)"
	if ($GetKnownLanguages -Contains $Global:UILanguage) {
		$GetAddedLanguage += $Global:UILanguage
		$TempOfficeLanguage += "			<Language ID=""$($Global:UILanguage)"" />`n"
	} else {
		if ($GetKnownLanguages -Contains "en-US") {
			$GetAddedLanguage += "en-US"
			$TempOfficeLanguage += "			<Language ID=""en-US"" />`n"
		}
	}

	foreach ($item in $GetKnownLanguages) {
		if ($GetAddedLanguage -notcontains $item) {
			$GetAddedLanguage += $item
			$TempOfficeLanguage += "			<Language ID=""$($item)"" />`n"
		}
	}

	$RandomGuid = [guid]::NewGuid()
	$TempGuidConfiguration = "$($env:userprofile)\AppData\Local\Temp\$($RandomGuid)"
	CheckCatalog -chkpath $TempGuidConfiguration
	Write-Host "`n   Configuration temp folder: $($TempGuidConfiguration)"

	Copy-Item -Path "$($PSScriptRoot)\Configuration\*.xml" -Destination $TempGuidConfiguration -Force -ErrorAction SilentlyContinue
	Get-ChildItem $TempGuidConfiguration -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }

	<#
		.Replace xml
		.替换 xml
	#>
	Get-ChildItem –Path "$($TempGuidConfiguration)\*.xml" | Where-Object {
		(Get-Content $_.FullName) | Foreach-Object {
			$_ -replace "--REPLACELANGUAGE--", $TempOfficeLanguage `
			   -replace "--REPLACESourcePath--", $Global:OfficeSP
		} | Set-Content -Path $_.FullName -ErrorAction SilentlyContinue
	}

	<#
		.Determine whether there is Setup.exe
		.判断是否存在 Setup.exe

		https://www.microsoft.com/en-us/download/details.aspx?id=49117
	#>
	Write-Host "`n   Sources: $($Global:OfficeSP)"

	<#
		.Convert the architecture type, configure according to the architecture settings
		.转换架构类型，按架构设置配置
	#>
	$XmlConfiguration = "Default"
	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\Arm64.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).arm64.xml"
			} else {
				if (Test-Path -Path "$($Global:OfficeSP)\Data\v64.cab" -PathType Leaf) {
					$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x64.xml"
				} else {
					if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
						$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\v64.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x64.xml"
			} else {
				if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
					$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
				}
			}
		}
		"x86" {
			if (Test-Path -Path "$($Global:OfficeSP)\Data\v32.cab" -PathType Leaf) {
				$XmlConfiguration = "$($TempGuidConfiguration)\$($Version).x86.xml"
			}
		}
	}

	<#
		.Determine the configuration file
		.判断配置文件
	#>
	$FlagsClean = $False
	if (Test-Path $XmlConfiguration -PathType Leaf) {
		Write-Host "`n   Install`n   Sources: $($XmlConfiguration)"
		Start-Process -FilePath "$($Global:OfficeSP)\Setup.exe" -ArgumentList "/configure $($XmlConfiguration)" -wait -WindowStyle Minimized

		Write-Host "`n   Installation status" -ForegroundColor Red
		if (Install-StatusCheck) {
			Write-Host "   - It has been installed`n" -ForegroundColor Green

			<#
				.After passing the installation status check, get whether to clear the installation package after success
				.通过安装状态检查后，成功后获取是否清除安装包
			#>
			if ($Cleanup) {
				$FlagsClean = $True
			}

			<#
				.Activation method
				.激活方式
			#>
			if ($Activation) {
				if (Test-Path "$($Global:OfficeSP)\Tools.exe" -PathType Leaf) {
					<#
						.Add to Defend rule
						.添加到 Defend 规则
					#>
					Add-MpPreference -ExclusionPath "$($Global:OfficeSP)\Tools.exe" -ErrorAction SilentlyContinue | Out-Null
					Start-Process -FilePath "$($Global:OfficeSP)\Tools.exe" -ArgumentList "*" -Wait
					Remove-MpPreference -ExclusionPath "$($Global:OfficeSP)\Tools.exe"
				}
			}
		} else {
			Write-Host "   - Not Installed`n" -ForegroundColor Red
		}
	} else {
		Write-Host "   - The installation configuration file was not found.`n" -ForegroundColor Red
		return
	}

	if ($Force) {
		$FlagsClean = $True
	}

	if ($FlagsClean) {
		$RandomTempGuid = [guid]::NewGuid()
		$test_tmp_filename = "$($Global:OfficeSP)\writetest-$($RandomTempGuid)"
		Out-File -FilePath $test_tmp_filename -Encoding utf8 -ErrorAction SilentlyContinue

		if (Test-Path $test_tmp_filename -PathType Leaf) {
			Remove-Item -Path $test_tmp_filename -Force -ErrorAction SilentlyContinue
			RemoveTree "$($Global:OfficeSP)"

			<#
				.In order to prevent the installation package from being unable to be cleaned up, the next time you log in, execute it again
				.为了防止无法清理安装包，下次登录时，再次执行
			#>
			Write-Host "   After logging in next time, Clear Office Install Folder`n" -ForegroundColor Green
			$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
			$regKey = "Clear Office Install Folder"
			$regValue = "cmd.exe /c rd /s /q ""$($Global:OfficeSP)"""
			if (Test-Path $regPath) {
				New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
			} else {
				New-Item -Path $regPath -Force | Out-Null
				New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
			}
		} else {
			Write-Host "   - Unable to clear Office installation package directory.`n" -ForegroundColor Red
		}
	}

	<#
		.Clean up the temporary configuration directory
		.清理临时配置目录
	#>
	RemoveTree $TempGuidConfiguration

	<#
		.Rearrange the desktop icons by name
		.重新按名称排列桌面图标
	#>
	ResetDesktop
}

Function Install-StatusCheck
{
	$OfficeProduct = @(
		"Word"
		"Access"
		"Excel"
		"Lync"
		"OneDrive"
		"OneNote"
		"Outlook"
		"PowerPoint"
		"Publisher"
		"Teams"
	)

	foreach ($item in $OfficeProduct) {
		if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Office\16.0\$($item)" -ErrorAction SilentlyContinue) {
			return $True
		}
	}

	if (Test-Path "${env:ProgramFiles}\Microsoft Office\Office16\OSPP.VBS" -PathType Leaf) {
		return $True
	}

	if (Test-Path "${env:ProgramFiles(x86)}\Microsoft Office\Office16\OSPP.VBS" -PathType Leaf) {
		return $True
	}

	# Check if Office 365 suite was installed correctly.
	$RegLocations = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
					  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
					)
	foreach ($Key in (Get-ChildItem $RegLocations) ) {
		if ($Key.GetValue('DisplayName') -like '*Microsoft 365*') {
			$OfficeVersionInstalled = $Key.GetValue('DisplayName')
			return $True
		}
	}

	return $False
}

<#
	.Create a directory
	.创建目录
#>
Function CheckCatalog
{
	Param
	(
		[string]$chkpath
	)

	if (-not (Test-Path $chkpath -PathType Container)) {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (-not (Test-Path $chkpath -PathType Container)) {
			Write-Host "   - Create Folder Failed $($chkpath)`n" -ForegroundColor Red
			return
		}
	}
}

<#
	.Try to delete the directory
	.尝试删除目录
#>
Function RemoveTree
{
	Param
	(
		[string]$Path
	)

	Remove-Item -Path $Path -force -Recurse -ErrorAction silentlycontinue -Confirm:$false | Out-Null

	if (Test-Path "$($Path)\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -Path $_.FullName -force -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			RemoveTree -Path $_.FullName
		}

		if (Test-Path "$($Path)\" -ErrorAction silentlycontinue) {
			Remove-Item -Path $Path -force -Recurse -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
		}
	}
}

<#
	.Refresh icon cache
	.刷新图标缓存
#>
Function RefreshIconCache
{
	$code = @'
	private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
	private const int WM_SETTINGCHANGE = 0x1a;
	private const int SMTO_ABORTIFHUNG = 0x0002;

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
private static extern IntPtr SendMessageTimeout ( IntPtr hWnd, int Msg, IntPtr wParam, string lParam, uint fuFlags, uint uTimeout, IntPtr lpdwResult );

[System.Runtime.InteropServices.DllImport("Shell32.dll")] 
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

public static void Refresh() {
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);
}
'@

	Add-Type -MemberDefinition $code -Namespace MyWinAPI -Name Explorer
	[MyWinAPI.Explorer]::Refresh()
}

Function RestartExplorer
{
	Stop-Process -ProcessName explorer -force -ErrorAction SilentlyContinue
	Start-Sleep 5
	$Running = Get-Process explorer -ErrorAction SilentlyContinue
	if (-not ($Running)) {
		Start-Process "explorer.exe"
	}
}

<#
	.Rearrange the desktop icons by name
	.重新按名称排列桌面图标
#>
Function ResetDesktop
{
	$ResetDesktopReg = @(
		'HKCU:\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\Bags'
		'HKCU:\Software\Microsoft\Windows\ShellNoRoam\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
		'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\Bags'
		'HKCU:\Software\Classes\Wow6432Node\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
	)

	foreach ($item in $ResetDesktopReg) {
		Remove-Item -Path $item -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
	}

	RestartExplorer
	RefreshIconCache
}

<#
	.Install Office version
	.安装 Office 版本

	Usage:
	用法：

	-Version
		"365"
			| O365ProPlusRetail        = Office 365 Apps for Enterprise
			| O365BusinessRetail       = Office 365 Apps for business
			| O365SmallBusPremRetail   = Office 365 Small Business Premium
			| O365HomePremRetail       = Office 365 Home

		"2021"
			| ProPlus2021Volume        = Office Professional Plus 2021 Volume


	-Activation  | After the installation is successful, try the activation method
                   安装成功后，尝试激活方式
	-Cleanup     | After the installation is successful, clear the Office installation package directory
                   安装成功后，清除 Office 安装包目录
	-Force       | Regardless of whether the installation succeeds or fails, the installation package directory is forcibly cleared
                   无论安装成功和失败时，强制清除 Office 安装包目录

#>

Install-Process -Version "O365ProPlusRetail" -Activation -Cleanup