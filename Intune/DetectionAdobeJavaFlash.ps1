#check for registry keys
$adobereader = Test-Path -Path 'HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'
$adobedc = Test-Path -Path 'HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
$adobe11 = Test-Path -Path 'HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown'


#if neither exists stop script and return success
If(!($adobereader -or $adobedc -or $adobe11)){
    Write-Host "Neither Program Detected"
    Exit 0
}

#check for correct reg vaules
If($adobereader){
    $adobereaderflash = (Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown").bEnableFlash
    $adobereaderjs = (Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown").bDisableJavaScript

    If(($adobereaderflash -eq 0) -and ($adobereaderjs -eq 1)){
        $ResultReader = "True"
    }
    Else {$ResultReader = "False"}
}

If($adobedc){
    $adobedcjs = (Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown").bDisableJavaScript
    If($adobedcjs -eq 1){
        $ResultAcrobat = "True"
    }
    Else {$ResultAcrobat = "False"}
}

If($adobe11){
    $adobe11js = (Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Adobe\Adobe Acrobat\11.0\FeatureLockDown").bDisableJavaScript
	$adobe11flash = (Get-ItemProperty -Path "HKLM:SOFTWARE\Policies\Adobe\Acrobat Reader\11.0\FeatureLockDown").bEnableFlash
    If(($adobe11flash -eq 1) -and ($adobe11js -eq 1)){
        $ResultAcrobat11 = "True"
    }
    Else {$ResultAcrobat11 = "False"}
}

#check results and give proper exit code
If (($ResultAcrobat -eq "True") -or ($ResultReader -eq "True") -or ($ResultAcrobat11 -eq "True")){
    Write-Host "Registry Remediations Detected"
    Exit 0
}
Else {
    Write-Host  "Registry Remediations not found!"
    Exit 1
}