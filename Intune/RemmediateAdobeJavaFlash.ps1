#check for reg keys for Adobe Reader and DC
$adobereader = Test-Path -Path 'HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'
$adobedc = Test-Path -Path 'HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
$adobe11 = Test-Path -Path 'HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown'


If(!($adobereader -or $adobedc -or $adobe11)){
    Write-Output "Neither Program Detected"
    Exit
}
#If keys exist add reg values
If($adobereader){
    New-ItemProperty "HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Name "bEnableFlash" -Value '0' -PropertyType DWORD -Force
    New-ItemProperty "HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Name "bDisableJavaScript" -Value '1' -PropertyType DWORD -Force
}

If($adobe11){
    New-ItemProperty "HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown" -Name "bEnableFlash" -Value '0' -PropertyType DWORD -Force
    New-ItemProperty "HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown" -Name "bDisableJavaScript" -Value '1' -PropertyType DWORD -Force
}

If($adobedc){
    New-ItemProperty "HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown" -Name "bDisableJavaScript" -Value '1' -PropertyType DWORD -Force
}