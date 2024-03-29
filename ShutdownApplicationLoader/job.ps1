param(
    [Parameter(Mandatory=$true)]
    [string]$FileName
)
$FullFileName = $FileName + ".au3"
$FullExeFileName = $FileName + ".exe"
Write-Output "The provided file name is: $FullFileName"

# Path to Aut2exe.exe
$Aut2exePath = "C:\Work\AutoIt3\Aut2Exe\Aut2exe.exe"

# Call Aut2exe.exe with the specified parameters (/in $FullFileName /x86) and wait for it to finish
Start-Process -FilePath $Aut2exePath -ArgumentList "/in", $FullFileName, "/x86", "/icon", "C:\Work\AutoIt3\Icons\MyAutoIt3_Green.ico" -Wait
Set-AuthenticodeSignature $FullExeFileName -Certificate (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)

#Set-AuthenticodeSignature $FullExeFileName -Certificate (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)