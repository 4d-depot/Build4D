//%attributes = {}
// Define an invalid licence
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $link : Text
var $log : Variant

$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.invalid_LicenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success=False; "(Current project) Standalone build should fail with invalid license"+$link)

$log:=$build.logs.find(Formula($1.value.function=$2); "Deployment license creation")

ASSERT((($log#Null) && ($log.severity=Error message)); "(Current project) Standalone license error should be logged"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

ASSERT($success=False; "(External project) Standalone build should fail with invalid license"+$link)

$log:=Null
$log:=$build.logs.find(Formula($1.value.function=$2); "Deployment license creation")

ASSERT((($log#Null) && ($log.severity=Error message)); "(External project) Standalone license error should be logged"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
