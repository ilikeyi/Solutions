$Oscdimg = "D:\Oscdimg.exe"
$ISO = "D:\OS_2022"
$Volume = "OS_2022"
$FileName = "D:\OS_2022.iso"
$Arguments = @(
    "-m",
    "-o",
    "-u2",
    "-udfver102",
    "-l""$($Volume)""",
    "-bootdata:2#p0,e,b""$($ISO)\boot\etfsboot.com""#pEF,e,b""$($ISO)\efi\microsoft\boot\efisys.bin""",
    $ISO,
    $FileName
)
Start-Process -FilePath $Oscdimg -ArgumentList $Arguments -wait -nonewwindow
