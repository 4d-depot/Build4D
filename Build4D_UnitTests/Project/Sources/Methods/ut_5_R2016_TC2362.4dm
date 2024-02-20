//%attributes = {"invisible":true}
// Build server application with specific name
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


//$settings.license:=Storage.settings.licenseUUD

// the goal : create a server application application with specific name

$settings.buildName:="SampleApplication"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If (Is macOS)
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/").file($build.settings.buildName+".4DZ")
Else 
	// to validate on windows
	$buildServer:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.name=$settings.buildName; "(Current project) Build Server Name should be: "+$settings.buildName+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)

If (Is macOS)
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/").file($build.settings.buildName+".4DZ")
Else 
	$buildServer:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.name=$settings.buildName; "(External project)  Build Server Name should be: "+$settings.buildName+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)