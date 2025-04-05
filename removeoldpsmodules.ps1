#Requires -RunAsAdministrator

# Get all installed modules with multiple versions
$modules = Get-Module -ListAvailable | 
    Group-Object Name | 
    Where-Object { $_.Count -gt 1 }

# Process each module with multiple versions
foreach ($module in $modules) {
    # Get all versions of the current module
    $versions = $module.Group | Sort-Object Version -Descending
    
    # Keep the latest version (first one after sorting descending)
    $latestVersion = $versions[0].Version
    Write-Host "Processing module: $($module.Name)"
    Write-Host "Keeping latest version: $latestVersion"
    
    # Remove all older versions
    $versions | Where-Object { $_.Version -ne $latestVersion } | ForEach-Object {
        try {
            Write-Host "Removing version: $($_.Version)"
            $modulePath = $_.ModuleBase
            Remove-Item -Path $modulePath -Recurse -Force -ErrorAction Stop
            Write-Host "Successfully removed version: $($_.Version)" -ForegroundColor Green
        }
        catch {
            Write-Host "Error removing $($module.Name) version $($_.Version): $_" -ForegroundColor Red
        }
    }
    Write-Host "" # Empty line for readability
}

# Verify the cleanup
Write-Host "Cleanup complete. Verifying remaining modules..." -ForegroundColor Yellow
Get-Module -ListAvailable | 
    Group-Object Name | 
    Where-Object { $_.Count -gt 1 } | 
    ForEach-Object {
        Write-Host "Multiple versions still exist for $($_.Name)" -ForegroundColor Red
        $_.Group | ForEach-Object {
            Write-Host " - Version: $($_.Version) at $($_.ModuleBase)"
        }
    }

Write-Host "Script completed." -ForegroundColor Green
