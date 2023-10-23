//%attributes = {}
// Check the custom elevation right for the Updater (normal)
If (Is Windows)  // Only on Windows
	
	var $build : cs.Build4D.Standalone
	var $settings : Object
	var $success : Boolean
	var $manifestFile : 4D.File
	var $manifestContent : Text
	var $link : Text
	
	$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	$settings.license:=Storage.settings.licenseUUD
	$settings.sourceAppFolder:=Folder(Storage.settings.winVolumeDesktop)
	$settings.startElevated:=False
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
	ASSERT($manifestFile.exists; "(Current project) Standalone Updater manifest should exist: "+$manifestFile.platformPath+$link)
	
	$manifestContent:=$manifestFile.getText()
	ASSERT($manifestContent="@level=\"asInvoker\"@"; "(Current project) Standalone Updater manifest should contain normal rights"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
	ASSERT($manifestFile.exists; "(External project) Standalone Updater manifest should exist: "+$manifestFile.platformPath+$link)
	
	$manifestContent:=$manifestFile.getText()
	ASSERT($manifestContent="@level=\"asInvoker\"@"; "(External project) Standalone Updater manifest should contain normal rights"+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
End if 
