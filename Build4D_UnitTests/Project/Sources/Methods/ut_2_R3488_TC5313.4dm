//%attributes = {}
// Build an application/component and remove a relative folder path
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean
var $deletedFolder : 4D.Folder
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"
$settings.deletePaths:=New collection("./Resources/")

$build:=cs.Build4D.Component.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Component build should success"+$link)

$deletedFolder:=$build.settings.destinationFolder.folder("Resources")
ASSERT($deletedFolder.exists=False; "(Current project) Deleted folder shouldn't exist: "+$deletedFolder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Component.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Component build should success"+$link)

$deletedFolder:=$build.settings.destinationFolder.folder("Resources")
ASSERT($deletedFolder.exists=False; "(External project) Deleted folder shouldn't exist: "+$deletedFolder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)
