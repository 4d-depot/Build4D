//%attributes = {"invisible":true}
// define a wrong path of the 4D server application
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


// the goal :  define any wrong path of 4D Server application
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.invalid_macServer) : Folder(Storage.settings.invalid_winServer)

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(Current project) Invalid 4D Server application path"+$link)



// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(External project) Invalid 4D Server application path"+$link)

