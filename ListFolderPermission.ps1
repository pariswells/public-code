$OutFile = "C:\temp\Permissions.csv"
Remove-Item $OutFile -ErrorAction SilentlyContinue
$Header = "Folder Path,Exception,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
Add-Content -Value $Header -Path $OutFile 

$RootPath = "D:\Shares\Users$"

try
{
#to add subfolders add - Recurse after $RootPath
    $Folders = dir $RootPath 2>&1 | where {$_.psiscontainer -eq $true} 
}
catch [System.Exception]
{
    $_.Exception.Message
}

foreach ($Folder in $Folders){
    
    try
    { 
        $ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
        $Exception = $false 
      }
    catch [System.Exception]
    {
        $Exception = $true
        $SystemMessage = $_.Exception.Message 
    }
    Finally
    {
        Foreach ($ACL in $ACLs)
        {
             if ($Exception -eq $false) {
            $OutInfo = $Folder.Fullname + "," + $Exception  + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
             }
           else {
            $OutInfo = $Folder.Fullname + "," + $Exception  + "," + $SystemMessage
           }
           Add-Content -Value $OutInfo -Path $OutFile
       }
    }
}
