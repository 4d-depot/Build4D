//%attributes = {"invisible":true}
// Build server application with wrong $settings.compilerOptions
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.compilerOptions:=New object("targets"; New collection("arm32_macOS_lib"; "arm128_macOS_lib"))  // arm 32 & 128 bits ?



$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(Current project) Server build should not be success"+$link)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(External project) Server build should success"+$link)

