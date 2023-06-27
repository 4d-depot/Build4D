//%attributes = {}
// Define an icon
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
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.iconPath:=(Is macOS) ? File("/PACKAGE/Build4D.icns") : File("/PACKAGE/Build4D.ico")

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()
TRACE
// Check icon

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()
TRACE
// Check icon

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

SET ASSERT ENABLED($assertions)
