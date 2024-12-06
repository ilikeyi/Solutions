$WimLibPath = "D:\OS_2022_Custom\Install\Install\Update\Winlib"
$FileName = "D:\OS_2022_Custom\Install\Install\Mount\Windows\System32\Recovery\WinRE.wim"
New-Item -Path $WimLibPath -ItemType Directory -ErrorAction SilentlyContinue
Copy-Item -Path $FileName -Destination $WimLibPath -Force
