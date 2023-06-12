//%attributes = {}
// Define the version application information
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $infoFile : 4D.File
var $infos : Object

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
$settings.versioning:=New object
$settings.versioning.version:="UT_version"
$settings.versioning.copyright:="UT_copyright"
$settings.versioning.companyName:="UT_companyName"
$settings.versioning.fileDescription:="UT_fileDescription"
$settings.versioning.internalName:="UT_internalName"

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

If (Is macOS)
	$infoFile:=$build.settings.destinationFolder.file("Contents/Info.plist")
	$infos:=$infoFile.getAppInfo()
	ASSERT($infos.CFBundleVersion="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
	ASSERT($infos.CFBundleShortVersionString="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
	ASSERT($infos.NSHumanReadableCopyright="UT_copyright"; "(Current project) Standalone copyright should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11181")
	ASSERT($infos.CFBundleIdentifier="UT_companyName@"; "(Current project) Standalone companyName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11184")
Else 
	$infoFile:=This.settings.destinationFolder.file("Resources/Info.plist")
	$infos:=$infoFile.getAppInfo()
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)
$success:=$build.build()

If (Is macOS)
	$infoFile:=$build.settings.destinationFolder.file("Contents/Info.plist")
	$infos:=$infoFile.getAppInfo()
	ASSERT($infos.CFBundleVersion="UT_version"; "(External project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
	ASSERT($infos.CFBundleShortVersionString="UT_version"; "(External project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
	ASSERT($infos.NSHumanReadableCopyright="UT_copyright"; "(External project) Standalone copyright should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11181")
	ASSERT($infos.CFBundleIdentifier="UT_companyName@"; "(External project) Standalone companyName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11184")
Else 
	$infoFile:=This.settings.destinationFolder.file("Resources/Info.plist")
	$infos:=$infoFile.getAppInfo()
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
