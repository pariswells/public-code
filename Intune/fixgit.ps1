$app_2upgrade = "Git.Git"

try{
    # resolve and navigate to winget.exe
 $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*\winget.exe")

if ($(&$winget upgrade --exact $app_2upgrade --silent --force --accept-package-agreements --accept-source-agreements) -like "A newer version was found, but the install") {
#Reinstall
&$winget remove $app_2upgrade --silent
&$winget install --exact $app_2upgrade --silent --force --accept-package-agreements --accept-source-agreements
	exit 0 
}

else {
    # upgrade command
    &$winget install --exact $app_2upgrade --silent --force --accept-package-agreements --accept-source-agreements
    exit 0
}

}catch{
    Write-Error "Error while installing upgrade for: $app_2upgrade"
    exit 1
}