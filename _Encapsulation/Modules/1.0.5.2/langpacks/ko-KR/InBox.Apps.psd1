ConvertFrom-StringData -StringData @'
	# ko-KR
	# Korean (Korea)

	AdvAppsDetailed                 = 처리 소스입니다
	AdvAppsDetailedTips             = 지역 태그별로 검색하고 사용 가능한 현지 언어 경험 패키지를 찾은 후 자세한 내용을 확인하여 보고서 파일을 생성합니다: *.CSV.
	ProcessSources                  = 처리 소스입니다
	InboxAppsManager                = 받은 편지함 앱
	InboxAppsMatchDel               = 일치하는 규칙으로 삭제
	InboxAppsOfflineDel             = 프로비저닝된 애플리케이션 삭제
	InboxAppsClear                  = 설치된 모든 사전 앱 ( InBox Apps ) 을 강제로 제거
	InBox_Apps_Match                = InBox Apps 앱 일치
	InBox_Apps_Check                = 종속성 확인
	InBox_Apps_Check_Tips           = 규칙에 따라 선택한 설치 항목을 모두 가져오고 종속 설치 항목이 선택되었는지 확인합니다.
	LocalExperiencePack             = 현지 언어 체험 팩
	LEPBrandNew                     = 새로운 방식으로 추천
	UWPAutoMissingPacker            = 모든 디스크에서 누락된 패키지 자동 검색
	UWPAutoMissingPackerSupport     = x64 아키텍처의 경우 누락된 패키지를 설치해야 합니다.
	UWPAutoMissingPackerNotSupport  = 비 x64 아키텍처, x64 아키텍처가 지원되는 경우에만 사용됩니다.
	UWPEdition                      = Windows 버전 고유 식별자입니다
	Optimize_Appx_Package           = 동일한 파일을 하드 링크로 교체하여 Appx 패키지 프로비저닝 최적화
	Optimize_ing                    = 최적화
	Remove_Appx_Tips                = 설명하다:\n\n1 단계: 현지 언어 경험 팩( LXPs ) 을 추가합니다. 이 단계는 Microsoft 에서 공식적으로 출시한 해당 팩과 일치해야 합니다. 여기로 이동하여 다운로드하십시오.\n       Windows 10 다중 세션 이미지에 언어 팩 추가\n       https://learn.microsoft.com/ko-kr/azure/virtual-desktop/language-packs\n\n       Windows 11 Enterprise 이미지에 언어 추가\n       https://learn.microsoft.com/ko-kr/azure/virtual-desktop/windows-11-language-packs\n\n2 단계: *_InboxApps.iso의 압축을 풀거나 마운트하고 아키텍처에 따라 디렉터리를 선택합니다.\n\n3 단계: Microsoft가 최신 현지 언어 경험 팩( LXPs )을 공식적으로 출시하지 않은 경우 이 단계를 건너뛰고, 그렇다면 다음 Microsoft 공식 발표를 참조하십시오.\n       1. 해당 지역 언어 체험 팩 ( LXPs );\n       2. 해당 누적 업데이트. \n\n사전 설치된 애플리케이션( InBox Apps )은 단일 언어이며 다국어를 사용하려면 다시 설치해야 합니다. \n\n1, 당신은 개발자 버전, 초기 버전 제작을 선택할 수 있습니다;\n    개발자 버전(예: 버전 번호: \n    Windows 11 시리즈\n    Windows 11 24H2, Build 26100.1\n    Windows 11 23H2, Build 22631.1\n    Windows 11 22H2, Build 22621.1\n    Windows 11 21H2, Build 22000.1\n\n    초기 버전, 알려진 초기 버전: \n    Windows 11 시리즈\n    Windows 11 24H2, Build 26100.2033\n    Windows 11 23H2, Build 22631.2428\n    Windows 11 22H2, Build 22621.382\n    Windows 11 21H2, Build 22000.194\n\n    Windows 10 시리즈\n    Windows 10 22H2, Build 19045.2006\n\n    중요한:\n      a. 각 버전이 업데이트될 때 이미지를 다시 생성하십시오, 예를 들어 21H1 에서 22H2 로 교차할 때 이전 이미지를 기반으로 업데이트하지 말고 기타 호환성 문제를 피해야 합니다. 생성할 초기 버전.\n      b. 이 규정은 일부 OEM 제조업체의 다양한 형태로 포장업자에게 법령을 명확하게 전달했으며 반복 버전에서 직접 업그레이드할 수 없습니다.\n\n      키워드: 반복, 교차 버전, 누적 업데이트.\n\n2. 언어 팩을 설치한 후에는 누적 업데이트를 추가해야 합니다. 누적 업데이트가 추가되기 전에는 구성 요소에 변경 사항이 없고, 구성 요소 상태: 구식, 보류 중과 같이 누적 업데이트가 설치될 때까지 새로운 변경 사항이 발생하지 않기 때문입니다. 삭제;\n\n3. 누적 업데이트가 있는 버전을 사용하면 여전히 마지막에 누적 업데이트를 다시 추가해야 하며 작업이 반복되었습니다.\n\n4. 따라서 제작 시 누적 업데이트가 없는 버전을 사용하고 마지막 단계에서 누적 업데이트를 추가하는 것을 권장합니다.\n\n디렉토리를 선택한 후 검색 기준: LanguageExperiencePack.*.Neutral.appx
	Export_Lang_Eject_ISO           = 추출 후 마운트된 ISO가 팝업됩니다. 규칙: 
	ImportCleanDuplicate            = 중복 파일 정리
	ForceRemovaAllUWP               = 현지 언어 체험 팩 건너뛰기 ( LXPs ) 추가, 실행 기타
	LEPSkipAddEnglish               = 설치 시 en-US 추가 건너뛰기, 권장
	LEPSkipAddEnglishTips           = 기본 영어 언어 팩은 추가할 필요가 없습니다.	
	License                         = 인증서
	IsLicense                       = 인증서로
	NoLicense                       = 인증서 없음
	CurrentIsNVeriosn               = N 에디션 시리즈
	CurrentNoIsNVersion             = 완전한 기능 버전
	LXPsWaitAddUpdate               = 보류 중인 업그레이드
	LXPsWaitAdd                     = 추가할 수 있습니다
	LXPsWaitAssign                  = 할당 예정
	LXPsWaitRemove                  = 삭제될
	LXPsAddDelTipsView              = 새로운 팁이 있습니다, 지금 확인하세요
	LXPsAddDelTipsGlobal            = 더 이상 프롬프트가 표시되지 않습니다. 글로벌 동기화
	LXPsAddDelTips                  = 다시 상기시키지 않음
	Instl_Dependency_Package        = InBox Apps 애플리케이션 설치 시 종속성 자동 조립 허용
	Instl_Dependency_Package_Tips   = 추가할 애플리케이션에 종속 패키지가 있는 경우 규칙에 따라 자동으로 일치하고 필요한 종속 패키지를 자동으로 결합하는 기능을 완료합니다.
	Instl_Dependency_Package_Match  = 종속성 패키지 결합
	Instl_Dependency_Package_Group  = 콤비네이션
	InBoxAppsErrorNoSave            = 실수를 겪을 때는 저장할 수 없습니다
	InBoxAppsErrorTips              = 오류가 있습니다. 일치하는 항목 {0} 항목이 실패했습니다
	InBoxAppsErrorNo                = 일치에서 오류가 발견되지 않았습니다
'@