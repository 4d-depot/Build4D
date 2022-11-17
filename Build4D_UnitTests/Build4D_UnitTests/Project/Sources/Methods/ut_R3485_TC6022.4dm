//%attributes = {}
// Test _build() function with the default name
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $compiledProject : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$build:=cs.Build4D.CompiledProject.new($settings)

ASSERT($build.settings.buildName=Storage.settings.projectName; "(Current project) Wrong default build name: "+$build.settings.buildName+" (https://dev.azure.com/4dimension/4D/_workitems/edit/4736)")

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

$compiledProject:=Folder("/PACKAGE/Test"; *).file(Storage.settings.projectName+".4DZ")
ASSERT($compiledProject.exists; "(Current project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.CompiledProject.new($settings)

ASSERT($build.settings.buildName=Storage.settings.externalProjectName; "(External project) Wrong default build name: "+$build.settings.buildName+" (https://dev.azure.com/4dimension/4D/_workitems/edit/4736)")

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

$compiledProject:=Storage.settings.externalProjectRootFolder.folder("Test").file(Storage.settings.externalProjectName+".4DZ")
ASSERT($compiledProject.exists; "(External project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Storage.settings.externalProjectRootFolder.folder("Test").delete(fk recursive)

