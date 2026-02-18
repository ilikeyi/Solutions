ConvertFrom-StringData -StringData @'
	# ko-KR
	# Korean (Korea)

	Save                            = 저장
	DoNotSave                       = 저장하지 마십시오
	DoNotSaveTips                   = 복구할 수 없습니다. 이미지를 직접 마운트 해제하세요.
	UnmountAndSave                  = 그런 다음 제거
	UnmountNotAssignMain            = {0} 이 할당되지 않은 경우
	UnmountNotAssignMain_Tips       = 일괄 처리 시 기본 항목이 할당되지 않은 경우 저장 및 미저장 여부를 지정해야 합니다.
	ImageEjectTips                  = 경고하다\n\n    1. 저장하기 전에, "상태 확인"을 수행하는 것이 좋습니다. "복구 가능" 또는 "복구 불가능"이 나타나면:\n       * ESD를 변환하는 동안 오류 13이 표시되고 데이터가 유효하지 않습니다.\n       * 시스템을 설치할 때 오류가 발생했습니다.\n\n    2. 상태 확인, boot.wim 은 지원하지 않습니다.\n\n    3. 이미지 파일 마운트가있는 경우, 이미지 내에서 제거 작업을 지정하지 않은 경우, 자동으로 사전 설정에 따라 처리됩니다.\n\n    4. 저장, 확장 이벤트를 할당 할 수 있습니다;\n\n    5. 저장하지 않으면 팝업 후 이벤트가 실행됩니다.
	ImageEjectSpecification         = {0} 을(를) 제거하는 동안 오류가 발생했습니다. 확장 프로그램을 제거하고 다시 시도하십시오.
	ImageEjectExpand                = 이미지 내의 파일을 관리합니다
	ImageEjectExpandTips            = 팁\n\n    상태 확인, 확장이 지원되지 않을 수 있으며 켜져 있을 때 확인할 수 있습니다.
	Image_Eject_Force               = 오프라인 이미지의 언로드 허용
	ImageEjectDone                  = 모든 작업을 완료한 후

	Abandon_Allow                   = 빠른 삭제 허용
	Abandon_Allow_Auto              = 빠른 삭제 자동 활성화 허용
	Abandon_Allow_Auto_Tips         = 이 옵션을 허용하면 "자동 조종, 알려진 이벤트의 사용자 지정 할당, 팝업"에 "빠른 삭제 허용" 옵션이 나타납니다. 이 기능은 기본 작업에서만 지원됩니다.
	Abandon_Agreement               = 빠른 삭제: 동의
	Abandon_Agreement_Disk_range    = 빠른 삭제를 허용한 디스크 파티션
	Abandon_Agreement_Allow         = 빠른 삭제 사용에 동의하며, 디스크 파티션 포맷으로 인한 결과에 대해 더 이상 책임을 지지 않습니다
	Abandon_Terms                   = 약관
	Abandon_Terms_Change            = 약관이 변경되었습니다
	Abandon_Allow_Format            = 포맷 허용
	Abandon_Allow_UnFormat          = 파티션 무단 포맷
	Abandon_Allow_Time_Range        = PowerShell 함수 실행 허용은 언제든지 적용됩니다
'@