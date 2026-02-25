<#
	.触发一键按需事件
#>
Function Autopilot_Custom_Replace_Variable
{
	param
	(
		$Var
	)

	$Save_New_Var = @()

	<#
		.转换变量
	#>
	$NewArch  = $Global:Architecture
	$NewArchC = $Global:Architecture.Replace("AMD64", "x64")

	$NewArchCTag = $Global:Architecture.Replace("AMD64", "x64")
	if ($Global:Architecture -eq "arm64") {
		$NewArchCTag = "arm"
	}

	foreach ($item in $Var) {
		$NewVar = $item.Replace("{MainMasterFolder}", $Global:MainMasterFolder).Replace("{Mount_To_Route}", $Global:Mount_To_Route).Replace("{Image_source}", $Global:Image_source).Replace("{ImageType}", $Global:ImageType).Replace("{Master}", $Global:Primary_Key_Image.Master).Replace("{MasterSuffix}", $Global:Primary_Key_Image.MasterSuffix).Replace("{Image}", $Global:Primary_Key_Image.ImageFileName).Replace("{Suffix}", $Global:Primary_Key_Image.Suffix).Replace("{Arch}", $NewArch).Replace("{ArchC}", $NewArchC).Replace("{ArchCTag}", $NewArchCTag)

		$Save_New_Var += $NewVar
	}

	return $Save_New_Var
}