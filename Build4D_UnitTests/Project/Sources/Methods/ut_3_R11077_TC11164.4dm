//%attributes = {}
// Test _build() function with a specific name
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $standaloneApp : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.buildName:="TEST"

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build.settings.buildName="TEST"; "(Current project) Wrong specified build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Standalone build should success"+$link)

$standaloneApp:=(Is macOS) ? Folder("/PACKAGE/Test/TEST.app") : File("/PACKAGE/Test/TEST/TEST.exe")
ASSERT($standaloneApp.exists; "(Current project) Standalone should exist: "+$standaloneApp.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build.settings.buildName="TEST"; "(External project) Wrong specified build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(External project) Standalone build should success"+$link)

$standaloneApp:=(Is macOS) ? Folder("/PACKAGE/Test/TEST.app") : File("/PACKAGE/Test/TEST/TEST.exe")
ASSERT($standaloneApp.exists; "(External project) Standalone should exist: "+$standaloneApp.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
