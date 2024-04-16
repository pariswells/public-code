$SoftwareName = "*Chipset Device Software"

$ItemProperties = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where Displayname -like "*$SoftwareName*"


if ($ItemProperties) {
    Write-Host "$SoftwareName found"
    Exit 1
} Else {
    Write-Host "$SoftwareName Not found"
    Exit 0
}


 catch{
    $errMsg = $_.exeption.essage
    Write-Output $errMsg
 }