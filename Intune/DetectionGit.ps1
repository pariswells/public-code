if (Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" -and $_.InstallationPolicy -ne "Trusted" }) {
    Install-PackageProvider -Name "NuGet" -MinimumVersion 2.8.5.208 -Force
    Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted"
}

$Installed = Get-Module -Name "Evergreen" -ListAvailable | `
    Sort-Object -Property @{ Expression = { [System.Version]$_.Version }; Descending = $true } | `
    Select-Object -First 1
$Published = Find-Module -Name "Evergreen"
if ($Null -eq $Installed) {
    Install-Module -Name "Evergreen"
}
elseif ([System.Version]$Published.Version -gt [System.Version]$Installed.Version) {
    Update-Module -Name "Evergreen"
}

Import-Module Evergreen

$gitversion = (Get-EvergreenApp -Name "GitForWindows" | Where-Object { $_.Architecture -eq "x64" -and $_.InstallerType -eq "Default" -and $_.Type -eq "exe"}).version

if ($(git --version) -notlike "*$gitversion*") {
	Write-Host "Upgrade available for Git"
	exit 1 # upgrade available, remediation needed
}
else {
		Write-Host "No Upgrade available"
		exit 0 # no upgared, no action needed
}