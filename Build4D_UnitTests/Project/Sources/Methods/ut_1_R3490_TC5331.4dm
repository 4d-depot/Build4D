//%attributes = {}
// Compile an application/component with good $settings.compilerOptions
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Variant
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))

$build:=cs.Build4D.CompiledProject.new($settings)

METHOD SET CODE("compilationError"; ""; *)
$success:=$build._compileProject()
ASSERT($success; "(Current project) Compilation should success"+$link)

METHOD SET CODE("compilationError"; "This line should generate a compilation error!"; *)
$success:=$build._compileProject()
ASSERT($success=False; "(Current project) Compilation should fail"+$link)

METHOD SET CODE("compilationError"; ""; *)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.CompiledProject.new($settings)

Storage.settings.externalProjectRootFolder.file("Project/Sources/Methods/compilationError.4dm").delete()
$success:=$build._compileProject()
ASSERT($success; "(External project) Compilation should success"+$link)

File("/RESOURCES/compilationError.4dm").copyTo(Storage.settings.externalProjectRootFolder.folder("Project/Sources/Methods"); fk overwrite)
$success:=$build._compileProject()
ASSERT($success=False; "(External project) Compilation should fail"+$link)

Storage.settings.externalProjectRootFolder.file("Project/Sources/Methods/compilationError.4dm").delete()
