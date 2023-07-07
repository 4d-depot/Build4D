//%attributes = {}
// Use SDI mode on Windows
If (Is Windows)
	var $build : cs.Build4D.Standalone
	var $settings; $info : Object
	var $success : Boolean
	var $link : Text
	$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	$settings.license:=Storage.settings.licenseUUD
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
	$settings.useSDI:=True
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Standalone build should success"+$link)
	
	$info:=$build.settings.destinationFolder.file("Resources/Info.plist").getAppInfo()
	ASSERT($info.SDIRuntime="1"; "(Current project) Standalone SDI mode should be true"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	ASSERT($success; "(External project) Standalone build should success"+$link)
	
	$info:=$build.settings.destinationFolder.file("Resources/Info.plist").getAppInfo()
	ASSERT($info.SDIRuntime="1"; "(Current project) Standalone SDI mode should be true"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
End if 
