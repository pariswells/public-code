# Script Name: Remediate_M365Companions.ps1
# Description: Removes Microsoft.M365Companions AppX package for all users and de-provisions it
# Notes: Runs only if detection script exits with code 1

try {
    # Remove the AppX package for all users
    $app = Get-AppxPackage -AllUsers -Name "Microsoft.M365Companions" -ErrorAction SilentlyContinue
    if ($null -ne $app) {
        foreach ($package in $app) {
            Write-Host "Removing Microsoft.M365Companions for user: $($package.PackageUserInformation)"
            Remove-AppxPackage -Package $package.PackageFullName -AllUsers -ErrorAction Continue
        }
    } else {
        Write-Host "Microsoft.M365Companions not found for removal."
    }

    # De-provision the AppX package to prevent reinstallation for new users
    $provisionedApp = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.M365Companions" }
    if ($null -ne $provisionedApp) {
        Write-Host "De-provisioning Microsoft.M365Companions."
        Remove-AppxProvisionedPackage -Online -PackageName $provisionedApp.PackageName -AllUsers -ErrorAction Continue
    } else {
        Write-Host "Microsoft.M365Companions not provisioned on the device."
    }

    Write-Host "Remediation completed successfully."
    exit 0
} catch {
    Write-Host "Error during remediation: $_"
    exit 1
}