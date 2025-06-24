# Script Name: Detect_M365Companions.ps1
# Description: Detects if Microsoft.M365Companions AppX package is installed for any user
# Notes: Exits with code 1 if detected, 0 if not detected

try {
    $app = Get-AppxPackage -AllUsers -Name "Microsoft.M365Companions" -ErrorAction SilentlyContinue
    if ($null -eq $app) {
        Write-Host "Microsoft.M365Companions not found on the device."
        exit 0
    } else {
        Write-Host "Microsoft.M365Companions found on the device."
        exit 1
    }
} catch {
    Write-Host "Error detecting Microsoft.M365Companions: $_"
    exit 1
}
