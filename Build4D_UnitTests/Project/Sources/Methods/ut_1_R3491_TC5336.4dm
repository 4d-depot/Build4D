//%attributes = {}
// Build a compiled project and don't create a read-only .4dz packed file
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
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"
$settings.packedProject:=False

$build:=cs.Build4D.CompiledProject.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

$compiledProject:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
ASSERT($compiledProject.exists=False; "(Current project) Compiled project 4DZ file should not exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.CompiledProject.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

$compiledProject:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
ASSERT($compiledProject.exists=False; "(External project) Compiled project 4DZ file should not exist: "+$compiledProject.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test"; *).delete(fk recursive)
