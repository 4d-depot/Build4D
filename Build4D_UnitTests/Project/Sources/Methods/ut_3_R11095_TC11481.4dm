//%attributes = {}
// Remove a file located at a relative path
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $modulePath : 4D.Folder
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.excludeModules:=New collection("mecab")

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success; "(Current project) Standalone build should success"+$link)

$modulePath:=$build._structureFolder.parent.folder("Resources/mecab/")
ASSERT($modulePath.exists=False; "(Current project) Module folder shouldn't exist: "+$modulePath.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success; "(External project) Standalone build should success"+$link)

$modulePath:=$build._structureFolder.parent.folder("Resources/mecab/")
ASSERT($modulePath.exists=False; "(Current project) Module folder shouldn't exist: "+$modulePath.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
