<#
	.Windows 11
#>
Function IsWin11
{
	$FlagsCheckIsWin11 = $False

	if ([System.Environment]::OSVersion.Version.Build -ge "21996") {
		$FlagsCheckIsWin11 = $True
	}

	return $FlagsCheckIsWin11
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

	$Path = "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\$($regkey)"

	if (-not (Test-Path $Path)) {
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
		New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		$RandomGuid = [guid]::NewGuid()
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path $Path -ChildPath $test_tmp_filename -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename -PathType Leaf) {
			Remove-Item -Path $test_filename -ErrorAction SilentlyContinue
			return $true
		}
		$false
	} catch {
		return $false
	}
}

<#
	.验证可用磁盘大小
#>
Function Verify_Available_Size
{
	param
	(
		[string]$Disk,
		[int]$Size
	)

	$TempCheckVerify = $false

	Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { ((Join_MainFolder -Path $Disk) -eq $_.Root) } | ForEach-Object {
		if ($_.Free -gt (Convert_Size -From GB -To Bytes $Size)) {
			$TempCheckVerify = $True
		} else {
			$TempCheckVerify = $false
		}
	}

	return $TempCheckVerify
}

<#
	.转换磁盘空间大小
#>
Function Convert_Size
{
	param
	(
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$From,
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$To,
		[Parameter(Mandatory=$true)]
		[double]$Value,
		[int]$Precision = 4
	)

	switch($From) {
		"Bytes" { $value = $Value }
		"KB" { $value = $Value * 1024 }
		"MB" { $value = $Value * 1024 * 1024 }
		"GB" { $value = $Value * 1024 * 1024 * 1024 }
		"TB" { $value = $Value * 1024 * 1024 * 1024 * 1024 }
	}

	switch ($To) {
		"Bytes" { return $value }
		"KB" { $Value = $Value/1KB }
		"MB" { $Value = $Value/1MB }
		"GB" { $Value = $Value/1GB }
		"TB" { $Value = $Value/1TB }
	}

	return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
}

<#
	.Verify the directory and create
	.验证目录并创建
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
			write-host "`n  $($lang.FailedCreateFolder)"
			write-host "  $($chkpath)" -ForegroundColor Red
			return
		}
	}
}

<#
	.Delete directory
	.删除目录
#>
Function Remove_Tree
{
	Param
	(
		[string]$Path
	)

	Remove-Item -Path $Path -force -Recurse -ErrorAction silentlycontinue | Out-Null
	
	if (Test-Path -Path "$($Path)\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -Path $_.FullName -force -ErrorAction SilentlyContinue
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			Remove_Tree -Path $_.FullName
		}

		if (Test-Path -Path "$($Path)\" -ErrorAction silentlycontinue) {
			Remove-Item -Path $Path -force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.验证路径是否后缀带有 \
	.Verify that the path is suffixed with \
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
		return "$($Path)\"
	}
}

<#
	.Pause prompt
	.暂停提示
#>
Function Get_Next
{
	write-host "`n  $($lang.WorkDone)`n"
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
		"$(Get_Arch_Path -Path "$($PSScriptRoot)\AIO\7zPacker")\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
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

	write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $filename -ForegroundColor Green

	write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $to -ForegroundColor Green

	write-host "  $($lang.UpdateUnpacking)".PadRight(28) -NoNewline

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

		Write-Host $lang.Done -ForegroundColor Green
	} else {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host $lang.Done -ForegroundColor Green
	}

	Write-Host
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

Function TakeownFile($path) {
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

Function TakeownFolder($path) {
	TakeownFile $path
	ForEach ($item in Get-ChildItem $path) {
		if (Test-Path $item -PathType Container) {
			TakeownFolder $item.FullName
		} else {
			TakeownFile $item.FullName
		}
	}
}

Function TakeownRegistry($key) {
    # TODO does not work for all root keys yet
    switch ($key.split('\')[0]) {
        "HKEY_CLASSES_ROOT" {
            $reg = [Microsoft.Win32.Registry]::ClassesRoot
            $key = $key.substring(18)
        }
        "HKEY_CURRENT_USER" {
            $reg = [Microsoft.Win32.Registry]::CurrentUser
            $key = $key.substring(18)
        }
        "HKEY_LOCAL_MACHINE" {
            $reg = [Microsoft.Win32.Registry]::LocalMachine
            $key = $key.substring(19)
        }
    }

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # set owner
    $key = $reg.OpenSubKey($key, "ReadWriteSubTree", "TakeOwnership")
    $acl = $key.GetAccessControl()
    $acl.SetOwner($admins)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($admins, "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}

Function Restart_Explorer
{
	Stop-Process -ProcessName explorer -force -ErrorAction SilentlyContinue
	Start-Sleep 5
	$Running = Get-Process explorer -ErrorAction SilentlyContinue
	if (-not ($Running)) {
		Start-Process "explorer.exe"
	}
}