#Change Date to when DR Started
$DateTime="2020-11-06 17:00:00.0000"
$FromPath="\\file\path"
#Make sure this folder exists and is empty
$ToPath="\\file\newpath"

#Copy Folder Structure
Get-ChildItem -Path $FromPath -Directory -Recurse | Where { $_.LastWriteTime -ge $DateTime } | Select-Object FullName, @{N="NewPath";E={$_.FullName.Replace($FromPath, $ToPath)}} | ForEach-Object { New-Item -Path $_.NewPath -ItemType "Directory" }
#Copy Files
Get-ChildItem -Path $FromPath -Recurse | Where { $_.LastWriteTime -ge $DateTime } | Select-Object FullName, @{N="NewPath";E={$_.FullName.Replace($FromPath, $ToPath)}} | ForEach-Object { Copy-Item -Path $_.FullName -Destination $_.NewPath }
#zip up
Compress-Archive -Path $ToPath -DestinationPath $ToPath"\Out.zip"
