#48622 - GP Webclient Session Services
#48623 - GP Webclient Session Central
#48650 - GP Webservices (GP Workflow)
#48651 - GP Webresources cache (GP Workflow)
#4713  - Management Reporter Service (SSL)

param($result)
if (!$result.IsSuccess) {

$hostname = XXXX.XXXXXX.com.au
#get thumbprint from Certify the web
$thumbprint = $result.ManagedItem.CertificateThumbprintHash # e.g. 2c127d49b4f63d947dd7b91750c9e57751eced0c

net stop "GPWebClientSessionServices" 

net stop "GPWebClientSessionCentral" 

net stop "GPService" 

net stop "GPWebResourceCache" 

net stop "MR2012ApplicationService" 

net stop "MR2012ProcessService" 

 
netsh http show sslcert > sslcert.Orig.txt 

#netsh http delete sslcert ipport=0.0.0.0:48622 

#netsh http delete sslcert ipport=0.0.0.0:48623 

netsh http delete sslcert ipport=0.0.0.0:48650 

netsh http delete sslcert ipport=0.0.0.0:48651 

netsh http delete sslcert hostnameport=$hostname:4713 

#netsh http add sslcert ipport=0.0.0.0:48622 certhash=$thumbprint appid={7689db5c-f331-4e87-addf-95ccb40b8a2e} 

#netsh http add sslcert ipport=0.0.0.0:48623 certhash=$thumbprint appid={7689db5c-f331-4e87-addf-95ccb40b8a2e} 

netsh http add sslcert ipport=0.0.0.0:48650 certhash=$thumbprint appid={5b1e387d-9f42-4387-9b7d-4e8d046bae33} 

netsh http add sslcert ipport=0.0.0.0:48651 certhash=$thumbprint appid={5b1e387d-9f42-4387-9b7d-4e8d046bae33} 

netsh http add sslcert hostnameport=$hostname:4713 certhash=$thumbprint certstorename=MY appid={85118119-e5f5-40da-b837-4acbd51d62f0} 


net start "GPWebClientSessionServices" 

net start "GPWebClientSessionCentral" 

net start "GPService" 

net start "GPWebResourceCache" 

net start "MR2012ApplicationService" 

net start "MR2012ProcessService" 
}

