$WimLibPath = "D:\OS_10_Custom\Install\Install\Update\Winlib"
$FileName = "D:\OS_10_Custom\Install\Install\Mount\Windows\System32\Recovery\WinRE.wim"
New-Item -Path $WimLibPath -ItemType Directory
Copy-Item -Path $FileName -Destination $WimLibPath -Force
