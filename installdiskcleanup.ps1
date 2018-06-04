<#
.SYNOPSIS
Install Diskcleanup via copy for servers for disk cleanup.
#>


# V2 admin check
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as an Administrator!"
    Exit 1
}

[version]$OSVersion = [Environment]::OSVersion.Version

#check OS version
If ($OSVersion -gt "6.3") {
#server 2012 r2 and above
Install-WindowsFeature -Name Desktop-Experience
}
If ($OSVersion -gt "6.2") {
#server 2012 and above
copy C:\Windows\WinSxS\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.2.9200.16384_none_c60dddc5e750072a\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\WinSxS\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.2.9200.16384_en-us_b6a01752226afbb3\cleanmgr.exe.mui C:\Windows\System32\en-US\
} ElseIf ($OSVersion -gt "6.1") {
#server 2008r2 and above
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.1.7600.16385_none_c9392808773cd7da\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.1.7600.16385_en-us_b9cb6194b257cc63\cleanmgr.exe.mui C:\Windows\System32\en-US\
} ElseIf ($OSVersion -gt "6.0") {
#server 2008 and above
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr_31bf3856ad364e35_6.0.6001.18000_none_c962d1e515e94269\cleanmgr.exe C:\Windows\System32\
copy C:\Windows\winsxs\amd64_microsoft-windows-cleanmgr.resources_31bf3856ad364e35_6.0.6001.18000_en-us_b9f50b71510436f2\cleanmgr.exe.mui C:\Windows\System32\en-US\} 
Else {
    write-host 'What OS Is this?'
}
