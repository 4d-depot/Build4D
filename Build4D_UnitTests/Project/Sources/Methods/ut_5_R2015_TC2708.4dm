//%attributes = {"invisible":true}
// Test the Client application
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildClient : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Client build should success"+$link)

If (Is macOS)
	$buildClient:=$build.settings.destinationFolder.file("Contents/Database/EnginedServer.4Dlink")
Else 
	// to validate on windows
	$buildClient:=$build.settings.destinationFolder.folder("Server Database/").file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildClient.exists; "(Current project) Compiled project should exist: "+$buildClient.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

If (Is macOS)
	$buildClient:=$build.settings.destinationFolder.file("Contents/Database/EnginedServer.4Dlink")
Else 
	$buildClient:=$build.settings.destinationFolder.folder("Server Database/").file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildClient.exists; "(External project) Client should exist: "+$buildClient.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)