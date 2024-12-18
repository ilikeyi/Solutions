$Arguments = @(
    "extract",
    "D:\OS_10\sources\install.wim",
    "1",
    "\Windows\System32\Recovery\Winre.wim",
    "--dest-dir=""D:\OS_10_Custom\Install\Install\Update\Winlib"""
)
New-Item -Path "D:\OS_10_Custom\Install\Install\Update\Winlib" -ItemType Directory -ErrorAction SilentlyContinue
Start-Process -FilePath "d:\wimlib\wimlib-imagex.exe" -ArgumentList $Arguments -wait -nonewwindow
