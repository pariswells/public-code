Set objShell = CreateObject( "WScript.Shell" )
Set objFSO = CreateObject("Scripting.FileSystemObject")
appDataLocation=objShell.ExpandEnvironmentStrings("%APPDATA%")
quick_normal_location = appDataLocation & "\Microsoft\Templates\"
quick_normal_location_file = appDataLocation & "\Microsoft\Templates\Normal.dotm"
normal_local_network = "%server%\file"

If objFSO.FileExists(normal_local_network) = True Then
	If CDate(objFSO.GetFile(normal_local_network).DateLastModified) > CDate(objFSO.GetFile(quick_normal_location_file).DateLastModified) Then
		intBkpNum = 1
		While objFSO.FileExists(quick_normal_location & "Normal.dotm_bak" & intBkpNum) = True
			intBkpNum = intBkpNum + 1
		Wend
		objFSO.MoveFile quick_normal_location_file, quick_normal_location_file & intBkpNum
		objFSO.CopyFile normal_local_network, quick_normal_location_file
	End If
End If
