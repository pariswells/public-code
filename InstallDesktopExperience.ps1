<#
.SYNOPSIS
Install Desktop Experience for servers for disk cleanup.
#>


# V2 admin check
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as an Administrator!"
    Exit 1
}

[version]$OSVersion = [Environment]::OSVersion.Version

#check OS version
If ($OSVersion -gt "6.2") {
#server 2012 and above
   Install-WindowsFeature -Name Desktop-Experience
} ElseIf ($OSVersion -gt "6.1") {
#server 2008r2 and above
    Add-WindowsFeature -Name Desktop-Experience
} ElseIf ($OSVersion -gt "6.0") {
#server 2008 and above
    servermanagercmd.exe -install Desktop-Experience
} Else {
    write-host 'What OS Is this?'
}
