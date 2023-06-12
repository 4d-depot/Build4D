//%attributes = {}
// Define the data linking mode as other value than By application name or application path
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $infoFile : 4D.File
var $infos : Object

$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.versioning:=New object
$settings.lastDataPathLookup:="AnotherValue"

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

$infoFile:=(Is macOS) ? $build.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
$infos:=$infoFile.getAppInfo()
ASSERT($infos["com.4D.BuildApp.LastDataPathLookup"]="ByAppName"; "(Current project) Standalone lastDataPathLookup should be set to byAppName"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

$infoFile:=(Is macOS) ? $build.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
$infos:=$infoFile.getAppInfo()
ASSERT($infos["com.4D.BuildApp.LastDataPathLookup"]="ByAppName"; "(External project) Standalone lastDataPathLookup should be set to byAppName"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
