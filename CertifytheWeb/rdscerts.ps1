#Grab variables from Certify output
param($result)
write-host $result
$pfxpath = $result.ManagedItem.CertificatePath

#Enter the internal FQDN of the Connection Broker (usually on one of the session hosts)
$cb = 'server.domain.com'

#Set password for temp PFX files
$pfxPassword = ConvertTo-SecureString -String "pass12345678" -Force -AsPlainText
$pfxPassString = "pass12345678"

write-host "Importing certificate from" $pfxpath

#Create certificate object and import PFX to object
$pfxCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 # create empty Certificate Object
Try {
    $pfxCert.Import($pfxpath, "$pfxPassString", 'DefaultKeySet')
}
Catch {
    Throw "Certificate import error"
}

#Pull in modules required for managing RDS components
Import-Module RemoteDesktop
#import-module rdwebclientmanagement

#Import the LE cert to the Windows cert store 
Import-PfxCertificate -FilePath $pfxpath -CertStoreLocation Cert:\LocalMachine\My -Exportable -password $pfxPassword
write-host "Certificate Imported to Windows Store"

#Export cert into PEM (cer) format for the HTML5 client
export-certificate -filepath "$env:TEMP\rdsgate-temp.der" -cert $pfxCert
certutil -encode  "$env:TEMP\rdsgate-temp.der" "$env:TEMP\rdsgate-temp.cer"
write-host "RD Web Certificate Exported"

#Install cert to traditional RDS roles
Set-RDCertificate -Role RDGateway -ConnectionBroker $cb -ImportPath $pfxpath -Password $pfxPassword -Force
write-host "RD Gateway Certificate Installed"
Set-RDCertificate -Role RDPublishing -ConnectionBroker $cb -ImportPath $pfxpath -Password $pfxPassword -Force
write-host "RD Broker Publishing Certificate Installed"
Set-RDCertificate -role RDRedirector -ConnectionBroker $cb -ImportPath $pfxpath -Password $pfxPassword -Force
write-host "RD Broker Redirection Certificate Installed"
Set-RDCertificate -role RDWebAccess -ConnectionBroker $cb -ImportPath $pfxpath -Password $pfxPassword -Force
write-host "RD Web Access (legacy) Certificate Installed"

#Install cert to HTML5 web client
#Import-RDWebClientBrokerCert "$env:TEMP\rdsgate-temp.cer"
#Publish-RDWebClientPackage -Type Production -Latest
#write-host "RD Web Client Certificate Updates"

#Leave the campsite in the same shape you found it
Remove-Item -Path "$env:TEMP\rdsgate-temp.cer"
Remove-Item -Path "$env:TEMP\rdsgate-temp.der"
