##
##HKCU
$RegistryPATH = "HKCU:\SOFTWARE\Adobe\Acrobat Reader\DC\TrustManager\cDefaultLaunchURLPerms"
$Name = "iURLPerms"
$Value = "1"
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force



#$RegistryPATH = "HKCU:\SOFTWARE\Adobe\Acrobat Reader\DC\Originals"
#$Name = "bSecureOpenFile"
#$Value = "1"
#If (-NOT (Test-Path $RegistryPath)) {
#  New-Item -Path $RegistryPath -Force | Out-Null
#}
## Now set the value
#New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force
