# Define browser user data paths
$browsers = @(
    @{ Name = "Edge"; Path = "$env:LocalAppData\Microsoft\Edge\User Data" },
    @{ Name = "Chrome"; Path = "$env:LocalAppData\Google\Chrome\User Data" },
    @{ Name = "Brave"; Path = "$env:LocalAppData\BraveSoftware\Brave-Browser\User Data" }
)

$results = @()
# Track processed ExtensionIDs to avoid duplicates
$processedIds = @{}

foreach ($browser in $browsers) {
    if (Test-Path $browser.Path) {
        $profilePaths = Get-ChildItem -Path $browser.Path -Directory | Where-Object { $_.Name -match '^(Default|Profile \d+)$' } | Select-Object -ExpandProperty FullName

        foreach ($profilePath in $profilePaths) {
            $extensionPath = "$profilePath\Extensions"
            if (Test-Path $extensionPath) {
                Get-ChildItem -Path $extensionPath -Directory | ForEach-Object {
                    $extId = $_.Name
                    # Skip excluded IDs and already processed ExtensionIDs
                    if ($extId -notin $excludeIds -and -not $processedIds.ContainsKey($extId)) {
                        $manifestPath = "$extensionPath\$extId\*\manifest.json"
                        if (Test-Path $manifestPath) {
                            $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
                            $name = $manifest.name

                            # Check if name is a localized message (e.g., __MSG_extName__)
                            if ($name -match '^__MSG_(.+)__$') {
                                $messageKey = $matches[1]
                                # Look for messages.json in _locales/en/ (default to English)
                                $localePath = "$extensionPath\$extId\*\_locales\en\messages.json"
                                if (Test-Path $localePath) {
                                    $messages = Get-Content $localePath -Raw | ConvertFrom-Json
                                    # Get the localized name from messages.json
                                    if ($messages.$messageKey.message) {
                                        $name = $messages.$messageKey.message
                                    } else {
                                        $name = "Unknown ($name)" # Fallback if key not found
                                    }
                                } else {
                                    $name = "Unknown ($name)" # Fallback if messages.json not found
                                }
                            }

                            # Add ExtensionID to processed list
                            $processedIds[$extId] = $true

                            [PSCustomObject]@{
                                Browser = $browser.Name
                                Profile = ($profilePath -split '\\')[-1]
                                ExtensionID = $extId
                                Name = $name
                                Version = $manifest.version
                                Permissions = $manifest.permissions -join ", "
                            }
                        }
                    }
                }
            }
        }
    }
}

$results | Format-Table -AutoSize
