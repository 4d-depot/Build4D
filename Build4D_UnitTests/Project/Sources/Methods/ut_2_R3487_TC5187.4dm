//%attributes = {}
// Build an application/component and add a file identified by a filesystem string to a destination located at an absolute path
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean
var $includedFile : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"
$settings.includePaths:=New collection(New object(\
"source"; "/PACKAGE/README.md"; \
"destination"; Folder(Folder(fk database folder; *).platformPath; fk platform path).folder("Test").path)\
)

$build:=cs.Build4D.Component.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Component build should success"+$link)

$includedFile:=Folder(fk database folder; *).file("Test/README.md")
ASSERT($includedFile.exists; "(Current project) Included file should exist: "+$includedFile.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project
// Filesystems are relative to the project executing the code, so they can not be resolved related to an external project