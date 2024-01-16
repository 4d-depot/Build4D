//%attributes = {}
// Test _build() function in the default folder

If (Is Windows)  // windows only
	
	var $build : cs.Build4D.Server
	var $settings : Object
	var $success : Boolean
	var $destinationFolder : 4D.Folder
	var $buildServer : 4D.File
	var $link : Text
	$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)
	
	$settings.macCompiledProject:=Folder(Folder("/PACKAGE/").platformPath; fk platform path).folder("ConnectingDB_Build/ConnectingDB/Libraries/").path
	
	
	$build:=cs.Build4D.Server.new($settings)
	
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Server build should success"+$link)
	
	
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/Libraries/").file("lib4d-arm64.dylib")
	
	ASSERT($buildServer.exists=False; "(Current project) Silicon Code folder should exist: "+$buildServer.platformPath+$link)
	
	// Cleanup build folder
	
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Server.new($settings)
	
	$destinationFolder:=$build._projectPackage.folder($build._projectFile.name+"_Build/CompiledProject/"+$build.settings.buildName)
	ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(External project) Wrong default destination folder: "+$build.settings.destinationFolder.platformPath+$link)
	
	$success:=$build.build()
	
	ASSERT($success; "(External project) Server build should success"+$link)
	
	
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/Libraries/").file("lib4d-arm64.dylib")
	
	ASSERT($buildServer.exists=False; "(External project) Silicon Code folder should exist: "+$buildServer.platformPath+$link)
	
	
	
	
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
	
	
End if 