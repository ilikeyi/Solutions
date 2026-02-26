$WimLibPath = "D:\ISOTemp_Custom\Install\Install\Update\Winlib"
$FileName = "D:\ISOTemp_Custom\Install\Install\Mount\Windows\System32\Recovery\WinRE.wim"
New-Item -Path $WimLibPath -ItemType Directory -ErrorAction SilentlyContinue
Copy-Item -Path $FileName -Destination $WimLibPath -Force
