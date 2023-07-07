//%attributes = {}
// Test _build() function with a specific name
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
$settings.buildName:="TEST"

$build:=cs.Build4D.CompiledProject.new($settings)

ASSERT($build.settings.buildName="TEST"; "(Current project) Wrong specified build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

$compiledProject:=Folder("/PACKAGE/Test").file("TEST.4DZ")
ASSERT($compiledProject.exists; "(Current project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.CompiledProject.new($settings)

ASSERT($build.settings.buildName="TEST"; "(External project) Wrong specified build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

ASSERT($compiledProject.exists; "(External project) Compiled project should exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
