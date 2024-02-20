//%attributes = {"invisible":true}
//check tha update of the Windows server application with startElevated=true
If (Is Windows)  // Only on Windows
	
	var $build : cs.Build4D.Server
	var $settings; $infos : Object
	var $success : Boolean
	var $destinationFolder : 4D.Folder
	var $buildServer : 4D.File
	var $infoPlist; $manifestFile : 4D.File
	var $link; $manifestContent : Text
	$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	
	$settings.startElevated:=True
	
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)
	
	$build:=cs.Build4D.Server.new($settings)
	
	
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Server build should success"+$link)
	
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
	ASSERT($manifestFile.exists; "(Current project) Server Updater manifest should exist: "+$manifestFile.platformPath+$link)
	
	$manifestContent:=$manifestFile.getText()
	ASSERT($manifestContent#"@level=\"asInvoker\"@"; "(Current project) Server Updater manifest should contain normal rights"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Server.new($settings)
	
	$success:=$build.build()
	
	ASSERT($success; "(External project) Server build should success"+$link)
	
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
	ASSERT($manifestFile.exists; "(External project) Server Updater manifest should exist: "+$manifestFile.platformPath+$link)
	
	$manifestContent:=$manifestFile.getText()
	ASSERT($manifestContent#"@level=\"asInvoker\"@"; "(External project) Server Updater manifest should contain normal rights"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
End if 