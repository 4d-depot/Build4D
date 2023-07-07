//%attributes = {}
// Test settings.destinationFolder (Folder) function
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="Test/"

$build:=cs.Build4D.Component.new($settings)

$destinationFolder:=Folder("/PACKAGE/Test").folder($build.settings.buildName+".4dbase/")
ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(Current project) Wrong custom destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Component build should success"+$link)

ASSERT($build.settings.destinationFolder.exists; "(Current project) Component should be placed in the custom destination folder: "+$build.settings.destinationFolder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Component.new($settings)

ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(External project) Wrong custom destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(External project) Component build should success"+$link)

ASSERT($build.settings.destinationFolder.exists; "(External project) Component should be placed in the custom destination folder: "+$build.settings.destinationFolder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
