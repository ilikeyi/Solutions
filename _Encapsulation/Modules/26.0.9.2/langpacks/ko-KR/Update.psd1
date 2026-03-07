ConvertFrom-StringData -StringData @'
	# ko-KR
	# Korean (Korea)

	ChkUpdate                 = 업데이트 확인
	UpdateServerSelect        = 자동 서버 선택 또는 사용자 지정 선택
	UpdateServerNoSelect      = 사용 가능한 서버를 선택하십시오
	UpdateSilent              = 사용 가능한 업데이트가 있을 때 자동 업데이트
	UpdateClean               = 여가 시간에 이전 버전 청소 허용
	UpdateReset               = 이 솔루션 재설정
	UpdateResetTips           = 다운로드 주소를 사용할 수 있는 경우 강제로 다운로드 및 업데이트합니다.
	UpdateCheckServerStatus   = 서버 상태 확인 ( 총 {0} 개 선택사항 )
	UpdateServerAddress       = 서버 주소
	UpdatePriority            = 우선 순위로 설정되었습니다.
	UpdateServerTestFailed    = 서버 상태 테스트 실패
	UpdateQueryingUpdate      = 쿼리 및 업데이트 중...
	UpdateQueryingTime        = 최신 버전이 있는지 확인하는 데 {0} 밀리초가 걸렸습니다.
	UpdateConnectFailed       = 원격 서버에 연결할 수 없습니다. 업데이트가 중단되었는지 확인하십시오.
	UpdateREConnect           = 연결에 실패했습니다. {0}/{1} 번째로 다시 시도합니다.
	UpdateMinimumVersion      = 최소 업데이트 프로그램 버전 요구 사항 충족, 최소 필수 버전: {0}
	UpdateVerifyAvailable     = 주소를 사용할 수 있는지 확인
	Download                  = 다운로드
	UpdateDownloadAddress     = 다운로드 주소
	UpdateAvailable           = 사용 가능
	UpdateUnavailable         = 사용할 수 없음
	UpdateCurrent             = 현재 버전
	UpdateLatest              = 사용 가능한 최신 버전
	UpdateNewLatest           = 사용 가능한 새 버전을 찾았습니다!
	UpdateSkipUpdateCheck     = 자동 업데이트가 처음 실행되는 것을 허용하지 않는 사전 구성된 정책입니다.
	UpdateTimeUsed            = 사용한 시간
	UpdatePostProc            = 사후 처리
	UpdateNotExecuted         = 실행되지 않음
	UpdateNoPost              = 사후 처리 작업을 찾을 수 없음
	UpdateUnpacking           = 포장 풀기
	UpdateDone                = 성공적으로 업데이트되었습니다!
	UpdateDoneRefresh         = 업데이트 완료 후 기능 처리를 실행합니다.
	UpdateUpdateStop          = 업데이트를 다운로드하는 동안 오류가 발생하여 업데이트 프로세스가 중단되었습니다.
	UpdateInstall             = 이 업데이트를 설치하시겠습니까 ?
	UpdateInstallSel          = 예, 위 업데이트가 설치됩니다.\n아니요,이 업데이트를 설치하지 않습니다.
	UpdateNotSatisfied        = \n  최소 업데이트 버전 요구 사항을 충족시키지 마십시오.\n\n  최소 요구 사항 버전 {0}\n\n  다시 다운로드해 주세요.\n\n  업데이트가 중단되었는지 확인하십시오.\n

	IsAllowSHA256Check        = SHA256 해시 검증을 허용합니다.
	GetSHAFailed              = 다운로드한 파일과의 해시 비교에 실패했습니다.
	Verify_Done               = 검증 성공.
	Verify_Failed             = 검증 실패, 해시 불일치.

	Auto_Update_Allow         = 자동 백그라운드 업데이트 확인 허용
	Auto_Update_New_Allow     = 새 업데이트가 감지되면 자동 업데이트를 허용합니다.
	Auto_Check_Time           = 자동 확인 간격 ( 시간 )
	Auto_Last_Check_Time      = 마지막 자동 업데이트 확인 시간
	Auto_Next_Check_Time      = 다음 확인 시간(최대 {0} 시간)
	Auto_First_Check          = 업데이트 확인이 수행되지 않았습니다. 첫 번째 업데이트 확인을 수행합니다.
	Auto_Update_Last_status   = 최근 업데이트 상태
	Auto_Update_IsLatest      = 이미 최신 버전입니다.

	SearchOrder               = 검색 순서
	SearchOrderTips           = 검색 순서\n  [ 1.  2. ] 가지 조건이 모두 충족되면 검색이 중지되고, 그렇지 않으면 계속됩니다.\n\n\n1. 인덱스 번호\n   [ 소스 추가 ]\\Custom\\[ 현재 마운트된 인덱스 번호와 일치하는 항목 ] 을 검색합니다. 일치하는 항목이 발견되면 파일을 추가하고 검색을 중지합니다.\n\n2. 이미지 플래그\n   [ 소스 추가 ]\\Custom\\[ 현재 마운트된 이미지 플래그 ] 를 검색합니다. 일치하는 항목이 발견되면 파일을 추가하고 검색을 중지합니다.\n\n3. 기타\n   12 가지 조건 중 어느 것도 충족되지 않으면 기본적으로 소스의 모든 파일 ( 소스 내의 Custom 디렉터리 제외 ) 이 추가됩니다.
'@