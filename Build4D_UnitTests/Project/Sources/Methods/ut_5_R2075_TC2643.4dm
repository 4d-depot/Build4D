//%attributes = {"invisible":true}
// check the update of the Windows client application with startElevated=false
var $build : cs.Build4D.Client
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $manifestFile : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

If (Is Windows)
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	$settings.startElevated:=False
	
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
	
	$build:=cs.Build4D.Client.new($settings)
	
	
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Compiled project build should success"+$link)
	
	
	// to validate on windows
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/normal.manifest")
	
	
	ASSERT($manifestFile.exists; "(Current project) manifest file should exist: "+$manifestFile.platformPath+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Client.new($settings)
	
	$success:=$build.build()
	
	ASSERT($success; "(External project) Compiled project build should success"+$link)
	
	
	
	// to validate on windows
	$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/normal.manifest")
	
	
	ASSERT($manifestFile.exists; "(External project) manifest file should exist: "+$manifestFile.platformPath+$link)
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
End if 

