#######################################################
# 
# I put this script together to fix the permissions on users' home folders
# that had gotten messed up when they were moved to a new fileserver
# cluster.  After many attempts that 'almost' worked, I incorporated scripts
# from fellow SpiceHeads, most notably Martin Pugh (Martin9700).  An 
# edit or two from others, (Simon Matthews helped with the Set-ACL syntax 
# and Martin Boyle contributed the Set-Strictmode line for debugging), and
# I fixed up the logging output.
# 
# There's a couple of comments in the script that I left in but really only apply
# to the limited type of environment I was dealing with (2003 functional domain 
# with no access to the ActiveDirectory module).  (I figure I can't be the only 
# with overlords stuck in the past.)
# 
# Mike Schulman (s31064) 11/19/2015
# 
#######################################################

#Set-Strictmode -Version Latest -Verbose	##### Uncomment for configuring to your situation, then comment out again when you've got it right.

$Path = "D:\Shares\Users$"

##### Permissions adds the users/groups and the permissions they should have.  The actual User should not be added here.  
##### What's on the line below is an example only.  The format is domain\user-group:Permission.  
##### Separate additional users/groups with a comma and enclose the list in "".

$Permissions = "%yourdomainname%\Domain Admins:FullControl"

# Setup Access Rules
# $Domain = (Get-ADDomain).NetBIOSName	##### Need to set statically on next line because of 2003 limitations.
$Domain = 'ENCOM'
$AccessRules = @()
ForEach ($Perm in $Permissions.Split(","))
{	$Group = $Perm.Split(":")[0]
	$Level = $Perm.Split(":")[1]
	$AccessRules += New-Object System.Security.AccessControl.FileSystemAccessRule($Group,$Level, "ContainerInherit, ObjectInherit", 

"None", "Allow")
}

##### Setup Logging
##### Pasting this script as text into a PS command line causes the line below to throw an error and place the log file in the C:\ folder.  The script still works.

$Log = "$(Split-Path $MyInvocation.MyCommand.Path)\Set-UserACL-$(Get-Date -format 'MMddyy-hhmm').log"
Add-Content -Value "$(Get-Date): Script begins" -Path $Log
Add-Content -Value "$(Get-Date): Processing folder: $Path" -Path $Log

##### This is where it all starts to happen.
##### You can also modify the -Path in the Get-ChildItem line to limit the number of folders affected during testing.

$Dirs = Get-ChildItem -Path "$Path\*" | Where { $_.PSisContainer }
$UserError = @()
ForEach ($Dir in $Dirs)
{	$User = Split-Path $Dir.Fullname -Leaf
	Try
	{	Add-Content -Value "-----------------------------------------------" -Path $Log
	 	Add-Content -Value "$(Get-Date): Testing $($User): $($Dir.Fullname)" -Path $Log

##### The next line should be        $Test = Get-ADUser $User -ErrorAction Stop
##### It will test for the existence of the user before looping through the script.  I had to take it out because of the limitations of my environment.

	 	$ACL = Get-Acl $Dir -ErrorAction Stop
        
        ##### Set inheritance to no
		#$ACL.SetAccessRuleProtection($true, $false)
        #Add-Content -Value "$(Get-Date): Inheritance for $User set successfully" -Path $Log
        
        ##### Set owner to user
		#$ACL.SetOwner([System.Security.Principal.NTAccount]$User)
        #Add-Content -Value "$(Get-Date): Owner $User set successfully" -Path $Log
        
        ##### Remove old permissions
		$ACL.Access | ForEach { [Void]$ACL.RemoveAccessRule($_) }
        Add-Content -Value "$(Get-Date): Old permissions for $User removed successfully" -Path $Log
        
        ##### Set new permissions
		ForEach ($Rule in $AccessRules)
		{	$ACL.AddAccessRule($Rule)
		}
		$UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$Domain\$User","Modify", "ContainerInherit, 

ObjectInherit", "None", "Allow")
		$ACL.AddAccessRule($UserRule)
		Set-Acl -Path $Dir -AclObject $ACL -ErrorAction Stop
        Add-Content -Value "$(Get-Date): New permissions for $User set successfully" -Path $Log
	}
	Catch

##### This is where the errors get logged.  The first line logs them to the console, and the next two lines add them to the log file.

	{	Write-Host "Unable to process $($Dir.Fullname) because $($Error[0])" -ForegroundColor Red
		Add-Content -Value "-----------------------------------------------" -Path $Log
        		Add-Content -Value "$(Get-Date): Unable to process $($Dir.Fullname) because $($Error[0])" -Path $Log
	}
}

##### This just closes the log file.

Add-Content -Value "-----------------------------------------------" -Path $Log
Add-Content -Value "$(Get-Date): Script completed" -Path $Log
