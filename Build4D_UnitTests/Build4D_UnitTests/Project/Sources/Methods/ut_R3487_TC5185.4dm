//%attributes = {}
// Build an application/component and add a folder located at an absolute path to a destination located at an absolute path
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean
var $includedFolder : 4D.Folder
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"
$settings.includePaths:=New collection(New object(\
"source"; Folder(Folder(fk database folder; *).platformPath; fk platform path).folder("Documentation").path; \
"destination"; Folder(Folder(fk database folder; *).platformPath; fk platform path).folder("Test").path)\
)

$build:=cs.Build4D.Component.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Component build should success"+$link)

$includedFolder:=Folder(fk database folder; *).folder("Test/Documentation")
ASSERT($includedFolder.exists; "(Current project) Included folder should exist: "+$includedFolder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile
$settings.includePaths:=New collection(New object(\
"source"; Storage.settings.externalProjectRootFolder.folder("Documentation").path; \
"destination"; Storage.settings.externalProjectRootFolder.folder("Test").path)\
)

$build:=cs.Build4D.Component.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Component build should success"+$link)

$includedFolder:=Storage.settings.externalProjectRootFolder.folder("Test/Documentation")
ASSERT($includedFolder.exists; "(External project) Included folder should exist: "+$includedFolder.platformPath+$link)

// Cleanup build folder
Storage.settings.externalProjectRootFolder.folder("Test").delete(fk recursive)
