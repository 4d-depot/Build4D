//%attributes = {}
// Define the data linking mode as By application path
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
$settings.lastDataPathLookup:="ByAppPath"

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

$infoFile:=(Is macOS) ? $build.settings.destinationFolder.file("Contents/Info.plist") : $build.settings.destinationFolder.file("Resources/Info.plist")
$infos:=$infoFile.getAppInfo()
ASSERT($infos["com.4D.BuildApp.LastDataPathLookup"]="ByAppPath"; "(Current project) Standalone lastDataPathLookup should be set to ByAppPath"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

$infoFile:=(Is macOS) ? $build.settings.destinationFolder.file("Contents/Info.plist") : $build.settings.destinationFolder.file("Resources/Info.plist")
$infos:=$infoFile.getAppInfo()
ASSERT($infos["com.4D.BuildApp.LastDataPathLookup"]="ByAppPath"; "(External project) Standalone lastDataPathLookup should be set to ByAppPath"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
