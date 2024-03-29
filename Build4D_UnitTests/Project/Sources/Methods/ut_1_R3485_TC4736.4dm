//%attributes = {}
// Test _build() function in a specified folder
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $compiledProject : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"

$build:=cs.Build4D.CompiledProject.new($settings)

$destinationFolder:=Folder("/PACKAGE/Test")
ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(Current project) Wrong specified destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

$compiledProject:=$destinationFolder.file($build.settings.buildName+".4DZ")
ASSERT($compiledProject.exists; "(Current project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.CompiledProject.new($settings)

ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(External project) Wrong specified destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

$compiledProject:=$destinationFolder.file($build.settings.buildName+".4DZ")
ASSERT($compiledProject.exists; "(External project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

