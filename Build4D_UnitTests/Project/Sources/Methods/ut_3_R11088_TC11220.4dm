//%attributes = {}
// Add a file located at a relative path to a destination located at a relative path
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $includedFile : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.includePaths:=New collection(New object(\
"source"; "./README.md"; \
"destination"; "./Test/")\
)

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success; "(Current project) Standalone build should success"+$link)

$includedFile:=$build._structureFolder.file("Test/README.md")
ASSERT($includedFile.exists; "(Current project) Included file should exist: "+$includedFile.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success; "(External project) Standalone build should success"+$link)

$includedFile:=$build._structureFolder.file("Test/README.md")
ASSERT($includedFile.exists; "(External project) Included file should exist: "+$includedFile.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
