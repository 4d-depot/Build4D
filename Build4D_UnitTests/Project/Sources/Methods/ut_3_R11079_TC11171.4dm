//%attributes = {}
// Define a 4D Volume Desktop with the version number is not match the 4D Developer Edition version number
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $link : Text
var $assertions : Boolean
var $log : Variant

$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

$assertions:=Get assert enabled
SET ASSERT ENABLED(True)

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.invalid_macVolumeDesktop) : Folder(Storage.settings.invalid_winVolumeDesktop)

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build._validInstance=False; "(Current project) Object instance shouldn't be valid"+$link)

$log:=$build.logs.find(Formula($1.value.function=$2); "Source application version checking")

ASSERT((($log#Null) && ($log.severity=Error message)); "(Current project) Standalone build should generate an error"+$link)

$success:=$build.build()

ASSERT($success=False; "(Current project) Standalone build should fail"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build._validInstance=False; "(External project) Object instance shouldn't be valid"+$link)

$log:=Null
$log:=$build.logs.find(Formula($1.value.function=$2); "Source application version checking")

ASSERT((($log#Null) && ($log.severity=Error message)); "(External project) Standalone build should generate an error"+$link)

$success:=$build.build()

ASSERT($success=False; "(External project) Standalone build should fail"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

SET ASSERT ENABLED($assertions)
