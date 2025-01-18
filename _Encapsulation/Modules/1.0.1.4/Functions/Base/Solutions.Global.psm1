<#
	.Create a directory
	.创建目录
#>
Function Check_Folder
{
	Param
	(
		[string]$chkpath
	)

	if (Test-Path -Path $chkpath -PathType Container) {

	} else {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		if (Test-Path -Path $chkpath -PathType Container) {

		} else {
			Write-Host "`n  $($lang.FailedCreateFolder)"
			Write-Host "  $($chkpath)" -ForegroundColor Red
			return
		}
	}
}

<#
	.Try to delete the directory
	.尝试删除目录
#>
Function Remove_Tree
{
	Param
	(
		[string]$Path
	)

	Remove-Item -Path $Path -force -Recurse -ErrorAction silentlycontinue -Confirm:$false | Out-Null

	if (Test-Path -Path "$($path)\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -Path $_.FullName -force -ErrorAction SilentlyContinue -Confirm:$false
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			Remove_Tree -Path $_.FullName
		}

		if (Test-Path -Path "$($path)\" -ErrorAction silentlycontinue) {
			Remove-Item -Path $Path -force -Recurse -ErrorAction SilentlyContinue -Confirm:$false
		}
	}
}

<#
	.Add the path suffix \
	.路径后缀添加 \
#>
Function Join_MainFolder
{
	param
	(
		[string]$Path
	)

	if ($Path.EndsWith('\')) {
		return $Path
	} else {
		return "$($path)\"
	}
}

<#
	.Dynamic save function
	.动态保存功能
#>
Function Save_Dynamic
{
	param
	(
		$regkey,
		$name,
		$value,
		[switch]$Multi,
		[switch]$String
	)

	$Path = "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\$($regkey)"

	if (Test-Path -Path $Path) {

	} else {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Multi) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType MultiString -force -ErrorAction SilentlyContinue | Out-Null
	}
	if ($String) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
	}
}

<#
	.Test whether the disk is readable and writable
	.测试磁盘是否可读写
#>
Function Test_Available_Disk
{
	param
	(
		[string]$Path
	)

	try {
		$Path = Join_MainFolder -Path $Path
		New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		$RandomGuid = [guid]::NewGuid()
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path $Path -ChildPath $test_tmp_filename -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path -Path $test_filename -PathType Leaf) {
			Remove-Item -Path $test_filename -ErrorAction SilentlyContinue
			return $true
		}

		return $false
	} catch {
		return $false
	}
}

Function TakeownFile($path)
{
	takeown.exe /A /F $path | Out-Null
	$acl = Get-Acl $path

	# get administraor group
	$admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
	$admins = $admins.Translate([System.Security.Principal.NTAccount])

	# add NT Authority\SYSTEM
	$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
	$acl.AddAccessRule($rule)

	Set-Acl -Path $path -AclObject $acl | Out-Null
}

Function TakeownFolder($path)
{
	TakeownFile $path
	ForEach ($item in Get-ChildItem $path) {
		if (Test-Path -Path $item -PathType Container) {
			TakeownFolder $item.FullName
		} else {
			TakeownFile $item.FullName
		}
	}
}

Function ElevatePrivileges
{
	param
	(
		$Privilege
	)

	$Definition = @"
    using System;
    using System.Runtime.InteropServices;

    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);

        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }

        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@

	$ProcessHandle = (Get-Process -id $pid).Handle
	$type = Add-Type $definition -PassThru
	$type[0]::EnablePrivilege($processHandle, $Privilege)
}

<#
	.Unzip
	.解压缩
#>
Function Archive
{
	param
	(
		$Password,
		$filename,
		$to
	)

	$filename = Convert-Path -Path $filename -ErrorAction SilentlyContinue

	if (Test-Path -Path $to -PathType Container) {
		$to = Convert-Path -Path $to -ErrorAction SilentlyContinue
	}

	Write-Host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $filename -ForegroundColor Green

	Write-Host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $to -ForegroundColor Green

	Write-Host "  $($lang.UpdateUnpacking): " -NoNewline

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		if (([string]::IsNullOrEmpty($Password))) {
			$arguments = @(
				"x",
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		} else {
			$arguments = @(
				"x",
				"-p$($Password)"
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		}

		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	Write-Host
}

<#
	.Descending order: Clean up the specified directory by structure
	.降序：按架构清理指定的目录
#>
Function Clear_Arch_Path
{
	param
	(
		[string]$Path
	)

	switch ($Global:ArchitecturePack) {
		"arm64" {
			if (Test-Path -Path "$($path)\arm64" -PathType Container) {
				Remove_Tree -Path "$($path)\AMD64"
				Remove_Tree -Path "$($path)\x86"
			} else {
				if (Test-Path -Path "$($path)\AMD64" -PathType Container) {
					Remove_Tree -Path "$($path)\arm64"
					Remove_Tree -Path "$($path)\x86"
				} else {
					if (Test-Path -Path "$($path)\x86" -PathType Container) {
						Remove_Tree -Path "$($path)\arm64"
						Remove_Tree -Path "$($path)\AMD64"
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($path)\AMD64" -PathType Container) {
				Remove_Tree -Path "$($path)\arm64"
				Remove_Tree -Path "$($path)\x86"
			} else {
				if (Test-Path -Path "$($path)\x86" -PathType Container) {
					Remove_Tree -Path "$($path)\arm64"
					Remove_Tree -Path "$($path)\AMD64"
				}
			}
		}
		"x86" {
			Remove_Tree -Path "$($path)\arm64"
			Remove_Tree -Path "$($path)\AMD64"
		}
	}
}

<#
	.Determine if architecture is available by path
	.按路径来判断架构是否可用
#>
Function Get_Arch_Path
{
	param
	(
		[string]$Path
	)

	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			$SearchArch = @(
				"arm64\$($Global:IsLang)"
				"arm64\en-US"
				"arm64"
				"AMD64\$($Global:IsLang)"
				"AMD64\en-US"
				"AMD64"
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
		"AMD64" {
			$SearchArch = @(
				"AMD64\$($Global:IsLang)"
				"AMD64\en-US"
				"AMD64"
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
		"x86" {
			$SearchArch = @(
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
	}

	return $Path
}

<#
	.Pause prompt
	.暂停提示
#>
Function Get_Next
{
	Write-Host "`n  $($lang.WorkDone)`n"
	pause
}

Function Get_Zip
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\7-Zip\$($Run)"
		"${env:ProgramFiles(x86)}\7-Zip\$($Run)"
		"$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\AIO\7zPacker")\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
}

Function Get_ASC
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\GnuPG\bin\$($Run)"
		"${env:ProgramFiles(x86)}\GnuPG\bin\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
}

Function Is_Find_Modules
{
	param
	(
		$Name
	)

	Get-Module -Name $Name | ForEach-Object {
		if ($Name -eq $_.Name) {
			return $True
		}
	}

	return $False
}

Function Get_GPS_Location
{
	ForEach ($item in $Global:Image_Rule) {
		if ($Global:Primary_Key_Image.Uid -eq $item.Main.Uid) {
			return "$($item.Main.ImageFileName)_$($item.Main.ImageFileName)"
		}

		if ($item.Expand.Count -gt 0) {
			ForEach ($Expand in $item.Expand) {
				if ($Global:Primary_Key_Image.Uid -eq $Expand.Uid) {
					return "$($item.Main.ImageFileName)_$($Expand.ImageFileName)"
				}
			}
		}
	}

	return "ISO"
}

Function Get_Autopilot_Location
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue) {
		$GetSaveLabelGUID = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Solutions).Author)\Solutions\ImageSources\$($Global:MainImage)\MVS" -Name "Kernel" -ErrorAction SilentlyContinue

		return $GetSaveLabelGUID
	}

	return "Default"
}