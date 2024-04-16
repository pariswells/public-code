# MrNetTek
# eddiejackson.net
# 7/15/2022
# free for public use
# free to claim as your own
 
$SoftwareName = "*Chipset Device Software"
 
$ItemProperties = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Select-Object DisplayName,UninstallString
 
foreach ($Item in $ItemProperties)
    {
        $DisplayName = $Item.DisplayName
        $UninstallString = $Item.UninstallString
        if($DisplayName -like "*$SoftwareName*")
            {
                Write-Host "$DisplayName : $UninstallString"
                # Output: Microsoft Silverlight : MsiExec.exe /X{89F4137D-6C26-4A84-BDB8-2E5A4BB71E00}
                 
                # Always test this on a reference machine, first
                # Sometimes the uninstall string is wrong, right from the vendor
                # If you do run across an invalid uninstall string, fix it
                # and hard code the uninstall string into your script
                # Silverlight was missing the /qn
                cmd.exe /c "$UninstallString /qn"
            }
    }