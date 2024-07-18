$sessions = Get-RDUserSession |  ? {$_.Username -eq "pwells"}

foreach($session in $sessions)
{
    Invoke-RDUserLogoff -HostServer $session.HostServer -UnifiedSessionID $session.UnifiedSessionId -Force
}
