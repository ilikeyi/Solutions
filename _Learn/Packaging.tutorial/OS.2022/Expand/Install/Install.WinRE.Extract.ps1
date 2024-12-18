$Arguments = @(
    "extract",
    "D:\OS_2022\sources\install.wim",
    "1",
    "\Windows\System32\Recovery\Winre.wim",
    "--dest-dir=""D:\OS_2022_Custom\Install\Install\Update\Winlib"""
)
New-Item -Path "D:\OS_2022_Custom\Install\Install\Update\Winlib" -ItemType Directory -ErrorAction SilentlyContinue
Start-Process -FilePath "d:\wimlib\wimlib-imagex.exe" -ArgumentList $Arguments -wait -nonewwindow
