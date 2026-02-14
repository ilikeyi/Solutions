<#
	.Available languages
	.可用语言

	RegionID = Decimal ID, ISO3166
	Region   = Language/region
	Tag      = Language/region tag
	Name     = Name
	Timezone = Timezone
	LIP      = LIP ID
#>
$Global:Languages_Available = @(
	@{
		RegionID = "1033"
		Region   = "en-US"
		Tag      = "en"
		Name     = "English (United States)"
		Timezone = "Pacific Standard Time"
		LIP      = "9PDSCC711RVF"
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
		RegionID = "1029"
		Region   = "cs-CZ"
		Tag      = "dz"
		Name     = "Czech (Czech Republic)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9P3WXZ1KTM7C"
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
		RegionID = "1031"
		Region   = "de-DE"
		Tag      = "de"
		Name     = "German (Germany)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P6CT0SLW589"
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
		RegionID = "2057"
		Region   = "en-gb"
		Tag      = "gb"
		Name     = "English (United Kingdom)"
		Timezone = "GMT Standard Time"
		LIP      = "9NT52VQ39BVN"
	}
	@{
		RegionID = "3082"
		Region   = "es-ES"
		Tag      = "es-ES"
		Name     = "Spanish (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9NWVGWLHPB1Z"
	}
	@{
		RegionID = "2058"
		Region   = "es-MX"
		Tag      = "mx"
		Name     = "Spanish (Mexico)"
		Timezone = "Central Standard Time (Mexico)"
		LIP      = "9N8MCM1X3928"
	}
	@{
		RegionID = "1061"
		Region   = "et-EE"
		Tag      = "ee"
		Name     = "Estonian (Estonia)"
		Timezone = "FLE Standard Time"
		LIP      = "9NFBHFMCR30L"
	}
	@{
		RegionID = "1035"
		Region   = "fi-FI"
		Tag      = "fi"
		Name     = "Finnish (Finland)"
		Timezone = "FLE Standard Time"
		LIP      = "9MW3PQ7SD3QK"
	}
	@{
		RegionID = "3084"
		Region   = "fr-CA"
		Tag      = "ca"
		Name     = "French (Canada)"
		Timezone = "Eastern Standard Time"
		LIP      = "9MTP2VP0VL92"
	}
	@{
		RegionID = "1036"
		Region   = "fr-FR"
		Tag      = "fr"
		Name     = "French (France)"
		Timezone = "Central European Time"
		LIP      = "9NHMG4BJKMDG"
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
		RegionID = "1050"
		Region   = "hr-HR"
		Tag      = "hr"
		Name     = "Croatian (Croatia)"
		Timezone = "Central European Standard Time"
		LIP      = "9NW01VND4LTW"
	}
	@{
		RegionID = "1038"
		Region   = "hu-HU"
		Tag      = "hu"
		Name     = "Hungarian (Hungary)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9MWN3C58HL87"
	}
	@{
		RegionID = "1040"
		Region   = "it-IT"
		Tag      = "it"
		Name     = "Italian (Italy)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P8PQWNS6VJX"
	}
	@{
		RegionID = "1041"
		Region   = "ja-JP"
		Tag      = "jp"
		Name     = "Japanese (Japan)"
		Timezone = "Tokyo Standard Time"
		LIP      = "9N1W692FV4S1"
	}
	@{
		RegionID = "1042"
		Region   = "ko-KR"
		Tag      = "kr"
		Name     = "Korean (Korea)"
		Timezone = "Korea Standard Time"
		LIP      = "9N4TXPCVRNGF"
	}
	@{
		RegionID = "1063"
		Region   = "lt-LT"
		Tag      = "lt"
		Name     = "Lithuanian (Lithuania)"
		Timezone = "FLE Standard Time"
		LIP      = "9NWWD891H6HN"
	}
	@{
		RegionID = "1062"
		Region   = "lv-LV"
		Tag      = "lv"
		Name     = "Latvian (Latvia)"
		Timezone = "FLE Standard Time"
		LIP      = "9N5CQDPH6SQT"
	}
	@{
		RegionID = "1044"
		Region   = "nb-NO"
		Tag      = "no"
		Name     = "Norwegian, Bokmål (Norway)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9N6J0M5DHCK0"
	}
	@{
		RegionID = "1043"
		Region   = "nl-NL"
		Tag      = "nl"
		Name     = "Dutch (Netherlands)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PF1C9NB5PRV"
	}
	@{
		RegionID = "1045"
		Region   = "pl-PL"
		Tag      = "pl"
		Name     = "Polish (Poland)"
		Timezone = "Central European Standard Time"
		LIP      = "9NC5HW94R0LD"
	}
	@{
		RegionID = "1046"
		Region   = "pt-BR"
		Tag      = "br"
		Name     = "Portuguese (Brazil)"
		Timezone = "E. South America Standard Time"
		LIP      = "9P8LBDM4FW35"
	}
	@{
		RegionID = "2070"
		Region   = "pt-PT"
		Tag      = "pt"
		Name     = "Portuguese (Portugal)"
		Timezone = "GMT Standard Time"
		LIP      = "9P7X8QJ7FL0X"
	}
	@{
		RegionID = "1048"
		Region   = "ro-RO"
		Tag      = "ro"
		Name     = "Romanian (Romania)"
		Timezone = "GTB Standard Time"
		LIP      = "9MWXGPJ5PJ3H"
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
		RegionID = "1051"
		Region   = "sk-SK"
		Tag      = "sk"
		Name     = "Slovak (Slovakia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9N7LSNN099WB"
	}
	@{
		RegionID = "1060"
		Region   = "sl-SI"
		Tag      = "si"
		Name     = "Slovenian (Slovenia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NV27L34J4ST"
	}
	@{
		RegionID = "9242"
		Region   = "sr-latn-rs"
		Tag      = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NBZ0SJDPPVT"
	}
	@{
		RegionID = "1053"
		Region   = "sv-SE"
		Tag      = "se"
		Name     = "Swedish (Sweden)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9P0HSNX08177"
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
		RegionID = "1055"
		Region   = "tr-TR"
		Tag      = "tr"
		Name     = "Turkish (Turkey)"
		Timezone = "Turkey Standard Time"
		LIP      = "9NL1D3T5HG9R"
	}
	@{
		RegionID = "1058"
		Region   = "uk-UA"
		Tag      = "ua"
		Name     = "Ukrainian (Ukraine)"
		Timezone = "FLE Standard Time"
		LIP      = "9PPPMZRSGHR8"
	}
	@{
		RegionID = "2052"
		Region   = "zh-CN"
		Tag      = "cn"
		Name     = "Chinese (Simplified, China)"
		Timezone = "China Standard Time"
		LIP      = "9NRMNT6GMZ70"
	}
	@{
		RegionID = "1028"
		Region   = "zh-TW"
		Tag      = "tw"
		Name     = "Chinese (Traditional, Taiwan)"
		Timezone = "Taipei Standard Time"
		LIP      = "9PCJ4DHCQ1JQ"
	}
)

$Global:Language_Only_LIP = @(
	@{
		RegionID = "1078"
		Region   = "af-za"
		Tag      = "af"
		Name     = "Afrikaans (South Africa)"
		Timezone = "Afghanistan Standard Time"
		LIP      = "9PDW16B5HMXR"
	}
	@{
		RegionID = "1101"
		Region   = "as-in"
		Tag      = "as-in"
		Name     = "Assamese (India)"
		Timezone = "India Standard Time"
		LIP      = "9NTJLXMXX35J"
	}
	@{
		RegionID = "1068"
		Region   = "az-latn-az"
		Tag      = "az-latn-az"
		Name     = "Azerbaijani (Latin, Azerbaijan)"
		Timezone = "Azerbaijan Standard Time"
		LIP      = "9P5TFKZHQ5K8"
	}
	@{
		RegionID = "1059"
		Region   = "be-by"
		Tag      = "be-by"
		Name     = "Belarusian (Belarus)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9MXPBGNNDW3L"
	}
	@{
		RegionID = "2117"
		Region   = "bn-bd"
		Tag      = "bn-bd"
		Name     = "Bangla (Bangladesh)"
		Timezone = "Bangladesh Standard Time"
		LIP      = "9PH7TKVXGGM8"
	}
	@{
		RegionID = "1093"
		Region   = "bn-in"
		Tag      = "bn-in"
		Name     = "Bangla (India)"
		Timezone = "India Standard Time"
		LIP      = "9P1M44L7W84T"
	}
	@{
		RegionID = "5146"
		Region   = "bs-latn-ba"
		Tag      = "bs-latn-ba"
		Name     = "Bosnian (Latin)"
		Timezone = "Central European Standard Time"
		LIP      = "9MVFKLJ10MFL"
	}
	@{
		RegionID = "1027"
		Region   = "ca-es"
		Tag      = "ca-es"
		Name     = "Catalan (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9P6JMKJQZ9S7"
	}
	@{
		RegionID = "1106"
		Region   = "cy-gb"
		Tag      = "cy"
		Name     = "Welsh (United Kingdom)"
		Timezone = "E. Europe Standard Time"
		LIP      = "9NKJ9TBML4HB"
	}
	@{
		RegionID = "1069"
		Region   = "eu-es"
		Tag      = "eu-es"
		Name     = "Basque (Basque)"
		Timezone = "Romance Standard Time"
		LIP      = "9NMCHQHZ37HZ"
	}
	@{
		RegionID = "1065"
		Region   = "fa-ir"
		Tag      = "fa"
		Name     = "Farsi (Iran)"
		Timezone = "Iran Standard Time"
		LIP      = "9NGS7DD4QS21"
	}
	@{
		RegionID = "1124"
		Region   = "fil-ph"
		Tag      = "fil-ph"
		Name     = "Filipino (Philippines)"
		Timezone = "Singapore Standard Time"
		LIP      = "9NWM2KGTDSSS"
	}
	@{
		RegionID = "2108"
		Region   = "ga-ie"
		Tag      = "ga-ie"
		Name     = "Irish (Ireland)"
		Timezone = "GMT Standard Time"
		LIP      = "9P0L5Q848KXT"
	}
	@{
		RegionID = "1169"
		Region   = "gd-gb"
		Tag      = "gd-gb"
		Name     = "Scottish Gaelic (United Kingdom)"
		Timezone = "GMT Standard Time"
		LIP      = "9P1DBPF36BF3"
	}
	@{
		RegionID = "1110"
		Region   = "gl-es"
		Tag      = "gl"
		Name     = "Galician (Spain)"
		Timezone = "Greenland Standard Time"
		LIP      = "9NXRNBRNJN9B"
	}
	@{
		RegionID = "1095"
		Region   = "gu-in"
		Tag      = "gu"
		Name     = "Gujarati (India)"
		Timezone = "West Pacific Standard Time"
		LIP      = "9P2HMSWDJDQ1"
	}
	@{
		RegionID = "1128"
		Region   = "ha-latn-ng"
		Tag      = "ha-latn-ng"
		Name     = "Hausa (Latin, Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9N1L95DBGRG3"
	}
	@{
		RegionID = "1141"
		Region   = "haw-us"
		Tag      = "haw-us"
		Name     = "Hawaiian (United States)"
		Timezone = "Pacific Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1067"
		Region   = "hy-am"
		Tag      = "hy"
		Name     = "Armenian (Armenia)"
		Timezone = "Caucasus Standard Time"
		LIP      = "9NKM28TM6P67"
	}
	@{
		RegionID = "1057"
		Region   = "id-id"
		Tag      = "id"
		Name     = "Indonesian (Indonesia)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9P4X3N4SDK8P"
	}
	@{
		RegionID = "1136"
		Region   = "ig-ng"
		Tag      = "ig-ng"
		Name     = "Igbo (Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9PG4ZFJ48JSX"
	}
	@{
		RegionID = "1039"
		Region   = "is-is"
		Tag      = "is"
		Name     = "Icelandic (Iceland)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9NTHJR7TQXX1"
	}
	@{
		RegionID = "1079"
		Region   = "ka-ge"
		Tag      = "ka"
		Name     = "Georgian (Georgia)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9P60JZL05WGH"
	}
	@{
		RegionID = "1087"
		Region   = "kk-kz"
		Tag      = "kk"
		Name     = "Kazakh (Kazakhstan)"
		Timezone = "Central Asia Standard Time"
		LIP      = "9PHV179R97LV"
	}
	@{
		RegionID = "1135"
		Region   = "kl-gl"
		Tag      = "kl-gl"
		Name     = "Kalaallisut (Greenland)"
		Timezone = "Greenland Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1099"
		Region   = "kn-in"
		Tag      = "kn"
		Name     = "Kannada (India)"
		Timezone = "SA Western Standard Time"
		LIP      = "9NC6DB7N95F9"
	}
	@{
		RegionID = "1111"
		Region   = "kok-in"
		Tag      = "kok"
		Name     = "Konkani (India)"
		Timezone = "India Standard Time"
		LIP      = "9MV3P55CMZ6P"
	}
	@{
		RegionID = "1088"
		Region   = "ky-kg"
		Tag      = "ky"
		Name     = "Kyrgyz (Kyrgyzstan)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9P7D3JJGZM48"
	}
	@{
		RegionID = "1134"
		Region   = "lb-lu"
		Tag      = "lb-lu"
		Name     = "Luxembourgish (Luxembourg)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9N0ST1WBZ9D9"
	}
	@{
		RegionID = "1153"
		Region   = "mi-nz"
		Tag      = "mi"
		Name     = "Maori (New Zealand)"
		Timezone = "New Zealand Standard Time"
		LIP      = "9P2GDFB3JPSX"
	}
	@{
		RegionID = "1071"
		Region   = "mk-mk"
		Tag      = "mk"
		Name     = "Macedonian (North Macedonia)"
		Timezone = "Central European Standard Time"
		LIP      = "9P1X6XB1K3RN"
	}
	@{
		RegionID = "1100"
		Region   = "ml-in"
		Tag      = "ml-in"
		Name     = "Malayalam (India)"
		Timezone = "Central European Standard Time"
		LIP      = "9NWDTV8FFV7L"
	}
	@{
		RegionID = "1104"
		Region   = "mn-mn"
		Tag      = "mn"
		Name     = "Mongolian (Mongolia)"
		Timezone = "Ulaanbaatar Standard Time"
		LIP      = "9PG1DHC4VTZW"
	}
	@{
		RegionID = "1102"
		Region   = "mr-in"
		Tag      = "mr"
		Name     = "Marathi (India)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9MWXCKHJVR1J"
	}
	@{
		RegionID = "2110"
		Region   = "ms-bn"
		Tag      = "ms-bn"
		Name     = "Malay (Brunei)"
		Timezone = "Singapore Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1086"
		Region   = "ms-my"
		Tag      = "ms-my"
		Name     = "Malay (Malaysia)"
		Timezone = "Singapore Standard Time"
		LIP      = "9NPXL8ZSDDQ7"
	}
	@{
		RegionID = "1082"
		Region   = "mt-mt"
		Tag      = "mt"
		Name     = "Maltese (Malta)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PDG96SQ6BN8"
	}
	@{
		RegionID = "1121"
		Region   = "ne-np"
		Tag      = "ne-np"
		Name     = "Nepali (Nepal)"
		Timezone = "Nepal Standard Time"
		LIP      = "9P7CHPLWDQVN"
	}
	@{
		RegionID = "2068"
		Region   = "nn-no"
		Tag      = "nn-no"
		Name     = "Norwegian (Nynorsk) (Norway)"
		Timezone = "W. Europe Standard Time"
		LIP      = "9PK7KM3Z06KH"
	}
	@{
		RegionID = "1132"
		Region   = "nso-za"
		Tag      = "nso-za"
		Name     = "Sesotho sa Leboa (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NS49QLX5CDV"
	}
	@{
		RegionID = "1096"
		Region   = "or-in"
		Tag      = "or-in"
		Name     = "Odia (India)"
		Timezone = "India Standard Time"
		LIP      = "9NTHCXCXSJDH"
	}
	@{
		RegionID = "1094"
		Region   = "pa-in"
		Tag      = "pa"
		Name     = "Punjabi (India)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9NSNC0ZJX69B"
	}
	@{
		RegionID = "1123"
		Region   = "ps-af"
		Tag      = "ps-af"
		Name     = "Pashto (Afghanistan)"
		Timezone = "Afghanistan Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1047"
		Region   = "rm-ch"
		Tag      = "rm-ch"
		Name     = "Romansh (Switzerland)"
		Timezone = "GTB Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "2072"
		Region   = "ro-md"
		Tag      = "ro-md"
		Name     = "Romanian (Moldova)"
		Timezone = "GTB Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1157"
		Region   = "sah-ru"
		Tag      = "sah-ru"
		Name     = "Sakha (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = ""
	}
	@{
		RegionID = "1115"
		Region   = "si-lk"
		Tag      = "si-lk"
		Name     = "Sinhala (Sri Lanka)"
		Timezone = "Sri Lanka Standard Time"
		LIP      = "9NVF9QSLGTL0"
	}
	@{
		RegionID = "1052"
		Region   = "sq-al"
		Tag      = "sq"
		Name     = "Albanian (Albania)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9MWLRGNMDGK7"
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
		RegionID = "9242"
		Region   = "sr-latn-rs"
		Tag      = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Timezone = "Central Europe Standard Time"
		LIP      = "9NBZ0SJDPPVT"
	}
	@{
		RegionID = "1089"
		Region   = "sw-ke"
		Tag      = "sw-ke"
		Name     = "Kiswahili (Kenya)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NFF2M19DQ55"
	}
	@{
		RegionID = "1097"
		Region   = "ta-in"
		Tag      = "ta-in"
		Name     = "Tamil (India)"
		Timezone = "India Standard Time"
		LIP      = "9PDZB1WT1B34"
	}
	@{
		RegionID = "1064"
		Region   = "tg-cyrl-tj"
		Tag      = "tg-cyrl-tj"
		Name     = "Tajik (Cyrillic)"
		Timezone = "West Asia Standard Time"
		LIP      = "9MZHLBPPT2HC"
	}
	@{
		RegionID = "1090"
		Region   = "tk-tm"
		Tag      = "tk-tm"
		Name     = "Turkmen (Turkmenistan)"
		Timezone = "West Asia Standard Time"
		LIP      = "9NKHQ4GL6VLT"
	}
	@{
		RegionID = "1092"
		Region   = "tt-ru"
		Tag      = "tt-ru"
		Name     = "Tatar (Russia)"
		Timezone = "Russian Standard Time"
		LIP      = "9NV90Q1X1ZR2"
	}
	@{
		RegionID = "1152"
		Region   = "ug-cn"
		Tag      = "ug-cn"
		Name     = "Uyghur (People's Republic of China)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9P52C5D7VL5S"
	}
	@{
		RegionID = "1056"
		Region   = "ur-pk"
		Tag      = "ur-pk"
		Name     = "Urdu (Islamic Republic of Pakistan)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NDWFTFW12BQ"
	}
	@{
		RegionID = "1091"
		Region   = "uz-latn-uz"
		Tag      = "uz-latn-uz"
		Name     = "Uzbek (Latin)"
		Timezone = "West Asia Standard Time"
		LIP      = "9P5P2T5P5L9S"
	}
	@{
		RegionID = "1066"
		Region   = "vi-vn"
		Tag      = "vi-vn"
		Name     = "Vietnamese (Vietnam)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9P0W68X0XZPT"
	}
	@{
		RegionID ="1160"
		Region   = "wo-sn"
		Tag      = "wo-sn"
		Name     = "Wolof (Senegal)"
		Timezone = "Greenwich Standard Time"
		LIP      = "9NH3SW1CR90F"
	}
	@{
		RegionID = "1076"
		Region   = "xh-za"
		Tag      = "xh-za"
		Name     = "Xhosa (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NW3QWSLQD17"
	}
	@{
		RegionID = "1130"
		Region   = "yo-ng"
		Tag      = "yo-ng"
		Name     = "Yoruba (Nigeria)"
		Timezone = "W. Central Africa Standard Time"
		LIP      = "9NGM3VPPZS5V"
	}
	@{
		RegionID = "2052"
		Region   = "zh-CN"
		Tag      = "cn"
		Name     = "Chinese (Simplified, China)"
		Timezone = "China Standard Time"
		LIP      = "9NRMNT6GMZ70"
	}
	@{
		RegionID = "1130"
		Region   = "zu-za"
		Tag      = "zu-za"
		Name     = "Zulu (South Africa)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NNRM7KT5NB0"
	}
	@{
		RegionID = "1116"
		Region   = "chr-cher-us"
		Tag      = "chr-cher-us"
		Name     = "Cherokee (United States)"
		Timezone = "Central Standard Time (Mexico)"
		LIP      = "9MX15485N3RK"
	}
	@{
		RegionID = "1081"
		Region   = "hi-in"
		Tag      = "hi"
		Name     = "Hindi (India)"
		Timezone = "India Standard Time"
		LIP      = "9NZC3GRX8LD3"
	}
	@{
		RegionID = "1118"
		Region   = "am-et"
		Tag      = "am-et"
		Name     = "Amharic (Ethiopia)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NGL4R61W3PL"
	}
	@{
		RegionID = "1159"
		Region   = "rw-rw"
		Tag      = "rw-rw"
		Name     = "Kinyarwanda (Rwanda)"
		Timezone = "South Africa Standard Time"
		LIP      = "9NFW0M20H9WG"
	}
	@{
		RegionID = "2051"
		Region   = "ca-es-valencia"
		Tag      = "ca-es-valencia"
		Name     = "Valencian (Spain)"
		Timezone = "Romance Standard Time"
		LIP      = "9P9K3WMFSW90"
	}
	@{
		RegionID = "1107"
		Region   = "km-kh"
		Tag      = "km-kh"
		Name     = "Khmer (Cambodia)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9PGKTS4JS531"
	}
	@{
		RegionID = "1170"
		Region   = "ku-arab-iq"
		Tag      = "ku-arab-iq"
		Name     = "Central Kurdish (Iraq)"
		Timezone = "Arabic Standard Time"
		LIP      = "9P1C18QL3D7H"
	}
	@{
		RegionID = "1108"
		Region   = "lo-la"
		Tag      = "lo-la"
		Name     = "Lao (Laos)"
		Timezone = "SE Asia Standard Time"
		LIP      = "9N8X352G5NZV"
	}
	@{
		RegionID = "2118"
		Region   = "pa-arab-pk"
		Tag      = "pa-arab-pk"
		Name     = "Punjabi (Arabic, Pakistan)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NJRL03WH6FM"
	}
	@{
		RegionID = "1164"
		Region   = "prs-af"
		Tag      = "prs-af"
		Name     = "Dari (Afghanistan)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9P3NGC6X5ZQC"
	}
	@{
		RegionID = "1158"
		Region   = "quc-latn-gt"
		Tag      = "quc-latn-gt"
		Name     = "K'iche' (Guatemala)"
		Timezone = "Central America Standard Time"
		LIP      = "9P2V6MNNQZ0B"
	}
	@{
		RegionID = "3179"
		Region   = "quz-pe"
		Tag      = "quz-pe"
		Name     = "Quechua (Peru)"
		Timezone = "SA Pacific Standard Time"
		LIP      = "9NHTX8NVQ04K"
	}
	@{
		RegionID = "2137"
		Region   = "sd-arab-pk"
		Tag      = "sd-arab-pk"
		Name     = "Sindhi (Arabic)"
		Timezone = "Pakistan Standard Time"
		LIP      = "9NB9JSCXW9X5"
	}
	@{
		RegionID = "1139"
		Region   = "ti-et"
		Tag      = "ti-et"
		Name     = "Tigrinya (Ethiopia)"
		Timezone = "E. Africa Standard Time"
		LIP      = "9NC8C9RDNK2S"
	}
)

Function Language_Region
{
	$ResultList = [System.Collections.Generic.List[PSCustomObject]]::new()
	$SeenRegions = [System.Collections.Generic.HashSet[string]]::new()

	function AddUniqueRegion($Item) {
		if ($null -ne $Item.Region -and $SeenRegions.Add($Item.Region)) {
			$ResultList.Add([PSCustomObject]@{
				RegionID = $Item.RegionID
				Region   = $Item.Region
				Tag      = $Item.Tag
				Name     = $Item.Name
				Timezone = $Item.Timezone
				LIP      = $Item.LIP
			})
		}
	}

	foreach ($item in $Global:Languages_Available) {
		AddUniqueRegion $item

		if ($item.Expand -and $item.Expand.Count -gt 0) {
			foreach ($subItem in $item.Expand) {
				AddUniqueRegion $subItem
			}
		}
	}

	return $ResultList | Sort-Object -Property Region
}

<#
	.Language Module
	.语言模块
#>
Function Language
{
	param
	(
		[string]$NewLang,
		[switch]$Reset,
		[switch]$Auto
	)

	$Global:Author = (Get-Module -Name LXPs).Author

	<#
		.Reset
		.重置
	#>
	if ($Reset) {
		$Global:IsLang = $null
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "LanguagePrompt" -ErrorAction SilentlyContinue) {
			$GetLanguagePrompt = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "LanguagePrompt" -ErrorAction SilentlyContinue
			if ($GetLanguagePrompt -eq "True") {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language" -ErrorAction SilentlyContinue) {
					$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language"
					Language_Change -lang $GetLanguage
					Modules_Import -Import
					return
				}
			}
		}
	}

	<#
		.Automatic
		.自动
	#>
	if ($Auto) {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language" -ErrorAction SilentlyContinue) {
			$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language"
			Language_Change -lang $GetLanguage
		} else {
			Language_Change -lang (Get-Culture).Name
		}

		Modules_Import -Import
		return
	}

	<#
		.Mandatory use of the specified language
		.强制使用指定语言
	#>
	if (-not ([string]::IsNullOrEmpty($NewLang))) {
		Language_Change -lang $NewLang
		Modules_Import -Import
		return
	}

	<#
		.Saved language
		.已保存语言
	#>
	if ([string]::IsNullOrEmpty($Global:IsLang)) {
		Language_Select_GUI
	} else {
		Language_Change -lang $Global:IsLang
		Modules_Import -Import
	}
}

Function Language_Select_GUI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Clear-Host
	Write-Host "`n  $($lang.LanguageSelRegion)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"

	Function Language_Refresh_Search
	{
		$UI_Main_Menu.controls.Clear()
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language" -ErrorAction SilentlyContinue) {
			$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "Language"
			$FlagsDefaultLanguage = $GetLanguage
		} else {
			$FlagsDefaultLanguage = (Get-Culture).Name
		}

		$CurrentVersion = (Get-Module -Name LXPs).Version

		$Region = Language_Region
		If ([String]::IsNullOrEmpty($UI_Main_Search.Text)) {
			ForEach ($item in $Region) {
				if (Test-Path -Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\$($item.Region)" -PathType Container) {
					$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
						Height  = 35
						Width   = 485
						Text    = $item.Name
						Tag     = $item.Region
					}

					if ($item.Region -eq $FlagsDefaultLanguage) {
						$CheckBox.Checked = $True
					}

					$UI_Main_Menu.controls.AddRange($CheckBox)
				}
			}
		} else {
			$MatchLanguage = @()
			$MatchLanguageResult = @()
			ForEach ($item in $Region) {
				$IsMatch = $True
				if ($IsMatch) {
					if ($item.Name -match $UI_Main_Search.Text) {
						$IsMatch = $False
						$MatchLanguage += $item.Region
					}
				}

				if ($IsMatch) {
					if ($item.Region -match $UI_Main_Search.Text) {
						$IsMatch = $False
						$MatchLanguage += $item.Region
					}
				}

				if ($IsMatch) {
					if ($item.RegionID -match $UI_Main_Search.Text) {
						$IsMatch = $False
						$MatchLanguage += $item.Region
					}
				}
			}

			if ($MatchLanguage.count -gt 0) {
				ForEach ($item in $MatchLanguage) {
					if (Test-Path -Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\$($item)" -PathType Container) {
						$MatchLanguageResult += $item
					}
				}
			}

			$MatchLanguageResult = $MatchLanguageResult | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
			if ($MatchLanguageResult.count -gt 0) {
				ForEach ($item in $Region) {
					if ($MatchLanguageResult -contains $item.Region) {
						$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
							Height  = 35
							Width   = 485
							Text    = $item.Name
							Tag     = $item.Region
						}

						if ($item.Region -eq $FlagsDefaultLanguage) {
							$CheckBox.Checked = $True
						}

						$UI_Main_Menu.controls.AddRange($CheckBox)
					}
				}
			} else {
				$UI_Main_Other_Rule_Not_Find = New-Object system.Windows.Forms.Label -Property @{
					Height         = 40
					Width          = 485
					Text           = $lang.LanguageSearchNo
				}
				$UI_Main_Menu.controls.AddRange($UI_Main_Other_Rule_Not_Find)
			}
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.LanguageSelRegion
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\Assets\icon\Yi.ico")
	}

	$UI_Main_Search    = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 375
		Location       = "20,22"
		Text           = ""
		BackColor      = "#FFFFFF"
		add_Click      = {
			$This.BackColor = "#FFFFFF"
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.ForeColor = "#000000"
		}
	}

	<#
		.搜索或匹配
	#>
	$UI_Main_Search_Refresh = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "400,15"
		Height         = 36
		Width          = 120
		Text           = $lang.Search
		add_Click      = { Language_Refresh_Search }
	}

	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 480
		Width          = 528
		Location       = "0,60"
		BorderStyle    = 0
		autoSizeMode   = 1
		autoScroll     = $True
		Padding        = "16,6,0,0"
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "10,568"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Location       = "35,570"
		Text           = ""
	}
	$UI_Main_Dont_Prompt = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 508
		Location       = '12,596'
		Text           = $lang.LanguageRemember
		add_Click      = {
			if ($UI_Main_Dont_Prompt.Checked) {
				Save_Dynamic -regkey "LXPs" -name "LanguagePrompt" -value "True"
			} else {
				Save_Dynamic -regkey "LXPs" -name "LanguagePrompt" -value "False"
			}
		}
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "LanguagePrompt" -ErrorAction SilentlyContinue) {
		$GetLanguagePrompt = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\LXPs" -Name "LanguagePrompt" -ErrorAction SilentlyContinue
		switch ($GetLanguagePrompt) {
			"True" { $UI_Main_Dont_Prompt.Checked = $True }
			"False" { $UI_Main_Dont_Prompt.Checked = $False }
		}
	}

	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,635"
		Text           = $lang.Ok
		add_Click      = {
			$FlagsLanguageCheck = $False
			$UI_Main_Menu.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.RadioButton]) {
					if ($_.Enabled) {
						if ($_.Checked) {
							Write-host "  $($_.Text)" -ForegroundColor Green

							$FlagsLanguageCheck = $True
							Save_Dynamic -regkey "LXPs" -name "Language" -value $_.Tag
							Language_Change -lang $_.Tag
							Modules_Import -Import
						}
					}
				}
			}

			if ($FlagsLanguageCheck) {
				$UI_Main.Close()
			} else {
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\Assets\icon\Error.ico")
				$UI_Main_Error.Text = $lang.LanguageNoSel
			}
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Search,
		$UI_Main_Search_Refresh,
		$UI_Main_Menu,
		$UI_Main_Dont_Prompt,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
	))

	Language_Refresh_Search
	$UI_Main.ShowDialog() | Out-Null
}

<#
	.Change language
	.更改语言
#>
Function Language_Change
{
	param
	(
		[string]$lang
	)

	$Global:Lang = @()
	$CurrentVersion = (Get-Module -Name LXPs).Version

	if (Test-Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\$($lang)\Lang.psd1" -PathType Leaf) {
		$Global:IsLang = $lang

		Get-ChildItem -Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\$($lang)" -Recurse -include "*.psd1" | ForEach-Object {
			$Global:Lang += Import-LocalizedData -FileName $_.Name -BaseDirectory $_.DirectoryName
		}
	} else {
		if (Test-Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\en-US\Lang.psd1" -PathType Leaf) {
			$Global:IsLang = "en-US"

			Get-ChildItem -Path "$($PSScriptRoot)\$($CurrentVersion)\langpacks\en-US" -Recurse -include "*.psd1" | ForEach-Object {
				$Global:Lang += Import-LocalizedData -FileName $_.Name -BaseDirectory $_.DirectoryName
			}
		} else {
			<#
				.Language pack is missing, when running in PowreShell 7 it will not occupy local resources, allowing changes and deletions, but when running under PowerShell 5.1 it will occupy local resources and cannot be changed and deleted
				.语言包丢失, 在 PowreShell 7 运行不会占用本地资源，允许更改和删除，但在 PowerShell 5.1 下运行会占用本地资源，且无法更改和删除
			#>
			$manifest = Invoke-Expression (Get-Content "$($PSScriptRoot)\LXPs.psd1" -Raw)
			if (Test-Path "$($PSScriptRoot)\$($manifest.ModuleVersion)\langpacks\en-US\Lang.psd1" -PathType Leaf) {
				$Global:IsLang = "en-US"

				Get-ChildItem -Path "$($PSScriptRoot)\$($manifest.ModuleVersion)\langpacks\en-US" -Recurse -include "*.psd1" | ForEach-Object {
					$Global:Lang += Import-LocalizedData -FileName $_.Name -BaseDirectory $_.DirectoryName
				}
			} else {
				Clear-Host
				Write-Host "`n  The local language pack is missing or corrupted. Please download it again." -ForegroundColor Red
				Write-Host "  $('-' * 80)"

				Write-host "  Learn more at: " -ForegroundColor Yellow
				write-host "  1. https://fengyi.tel/solutions" -ForegroundColor Green
				write-host "  2. https://github.com/ilikeyi/LXPs" -ForegroundColor Green
				write-host "`n  Please try again after reinstalling."
				write-host "`n  The application will exit automatically.`n"
				Start-Sleep -s 6
				exit
			}
		}
	}
}

<#
	.Refresh all modules
	.刷新所有模块
#>
Function Modules_Refresh
{
	param
	(
		[string[]]$Functions
	)

	$Global:SaveTempVersion = ""

	Write-Host
	Write-Host "  " -NoNewline
	Write-Host " $($lang.RefreshModules) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Language -Auto
	Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White

	if ($Functions) {
		ForEach ($Function in $Functions) {
			Invoke-Expression -Command $Function
		}
	}
}

<#
	.Import all modules
	.导入所有模块
#>
Function Modules_Import
{
	param
	(
		[switch]$Import
	)

	<#
		.Failed to retrieve version information., when running in PowreShell 7 it will not occupy local resources, allowing changes and deletions, but when running under PowerShell 5.1 it will occupy local resources and cannot be changed and deleted
		.获取版本丢失, 在 PowreShell 7 运行不会占用本地资源，允许更改和删除，但在 PowerShell 5.1 下运行会占用本地资源，且无法更改和删除
	#>
	$manifest = Invoke-Expression (Get-Content "$($PSScriptRoot)\LXPs.psd1" -Raw)
	if (Test-Path "$($PSScriptRoot)\$($manifest.ModuleVersion)" -PathType Container) {
		$CurrentVersion = $manifest.ModuleVersion
	} else {
		Clear-Host
		Write-Host "`n  The file is missing or corrupted. Please download it again." -ForegroundColor Red
		Write-Host "  $('-' * 80)"

		Write-host "  Learn more at: " -ForegroundColor Yellow
		write-host "  1. https://fengyi.tel/solutions" -ForegroundColor Green
		write-host "  2. https://github.com/ilikeyi/LXPs" -ForegroundColor Green
		write-host "`n  Please try again after reinstalling."
		write-host "`n  The application will exit automatically.`n"
		Start-Sleep -s 6
		exit
	}

	<#
		.Remove all LXPs modules
		.删除所有 LXPs 模块
	#>
	Get-Module -Name LXPs* | Where-Object -Property Name -like "LXPs*" | ForEach-Object {
		Remove-Module -Name $_.Name -Force -ErrorAction Ignore
	}

	if ($Import) {
		Import-Module -Name $PSScriptRoot\..\Modules\LXPs.psd1 -Scope Global -Force | Out-Null

		<#
			.Import all *.psd1
			.导入所有 *.psd1
		#>
		Get-ChildItem -Path "$($PSScriptRoot)\$($CurrentVersion)\Functions" -Recurse -include "LXPs.*.psd1" | ForEach-Object {
			Import-Module -Name $_.FullName -Scope Global -Force
		}
	}
}