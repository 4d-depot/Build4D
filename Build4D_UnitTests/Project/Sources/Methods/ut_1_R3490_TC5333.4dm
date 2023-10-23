//%attributes = {}
// Compile an application/component with wrong $settings.compilerOptions
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $link : Text

$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))

$settings.compilerOptions:=New object("typeInference"; "all")
$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build._compileProject()
ASSERT($success; "(Current project) Compilation should success"+$link)

$testVariable:="Don't remove this line to make the test efficient: the variable is not defined, so the compilation should fail with option 'All variables are typed'"
$settings.compilerOptions:=New object("typeInference"; "none")  // $testVariable is not typed in the method: compilation with this option should fail
$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build._compileProject()
ASSERT($success=False; "(Current project) Compilation should fail"+$link)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$settings.compilerOptions:=New object("typeInference"; "all")
$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build._compileProject()
ASSERT($success; "(External project) Compilation should success"+$link)

$settings.compilerOptions:=New object("typeInference"; "none")  // $testVariable is not typed in the unitTests method: compilation with this option should fail
$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build._compileProject()
ASSERT($success=False; "(External project) Compilation should fail"+$link)
