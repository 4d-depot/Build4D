//%attributes = {}
// integrate a valid license into the build server application
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


$settings.license:=File("/PACKAGE/Settings/4DSRV20x.license4D")

$settings.xmlKeyLicense:=File("/PACKAGE/Settings/4DOEM20x.license4D")


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If (Is macOS)
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/").file($build.settings.buildName+".4DZ")
Else 
	// to validate on windows
	$buildServer:=$build.settings.destinationFolder.folder("Server Database/").file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.exists; "(Current project) Server should exist: "+$buildServer.platformPath+$link)

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
	$buildServer:=$build.settings.destinationFolder.folder("Server Database/").file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.exists; "(External project) Server should exist: "+$buildServer.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)