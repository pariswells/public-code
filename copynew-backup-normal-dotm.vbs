Set objShell = CreateObject( "WScript.Shell" )
Set objFSO = CreateObject("Scripting.FileSystemObject")
appDataLocation=objShell.ExpandEnvironmentStrings("%APPDATA%")
quick_normal_location = appDataLocation & "\Microsoft\Templates\"
quick_normal_location_file = appDataLocation & "\Microsoft\Templates\Normal.dotm"
		normal_local_network = "%network localtion%Normal.dotm"

' Does the network normal exist
If objFSO.FileExists(normal_local_network) = True Then
	' Does the Local Normal Exist
	If objFSO.FileExists(quick_normal_location_file) = True Then
			' Check to see if the Local Normal is older than the newer Normal
		If CDate(objFSO.GetFile(normal_local_network).DateLastModified) > CDate(objFSO.GetFile(quick_normal_location_file).DateLastModified) Then
			intBkpNum = 1
			While objFSO.FileExists(quick_normal_location_file & intBkpNum) = True
				intBkpNum = intBkpNum + 1
			Wend
			objFSO.MoveFile quick_normal_location_file, quick_normal_location_file & intBkpNum
			objFSO.CopyFile normal_local_network, quick_normal_location_file
		End If
	End If
End If
