//%attributes = {}
// Test settings.destinationFolder (Folder) function errors
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test.txt"

$build:=cs.Build4D.Component.new($settings)

ASSERT($build._validInstance=False; "(Current project) Object instance shouldn't be valid"+$link)

$success:=$build.build()

ASSERT($success=False; "(Current project) Component build should fail"+$link)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Component.new($settings)

ASSERT($build._validInstance=False; "(External project) Object instance shouldn't be valid"+$link)

$success:=$build.build()

ASSERT($success=False; "(External project) Component build should fail"+$link)

