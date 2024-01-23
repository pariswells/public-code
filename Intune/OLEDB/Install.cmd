if not exist "C:\ProgramData\AppDeployment" md "C:\ProgramData\AppDeployment"
if not exist "C:\ProgramData\AppDeployment\SQLOLEDB" md "C:\ProgramData\AppDeployment\SQLOLEDB"
xcopy "msoledbsql.msi" "C:\ProgramData\AppDeployment\SQLOLEDB\" /Y
xcopy "VC_redist.x64.exe" "C:\ProgramData\AppDeployment\SQLOLEDB\" /Y
xcopy "SQLOLEDBInstall.ps1" "C:\ProgramData\AppDeployment\SQLOLEDB\" /Y
xcopy "SQLOLEDBUninstall.ps1" "C:\ProgramData\AppDeployment\SQLOLEDB\" /Y
xcopy "SQLOLEDBDetection.ps1" "C:\ProgramData\AppDeployment\SQLOLEDB\" /Y
Powershell.exe -Executionpolicy bypass -File "C:\ProgramData\AppDeployment\SQLOLEDB\SQLOLEDBInstall.ps1"

