//%attributes = {}
// Define the version application information
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $infoFile; $exeFile : 4D.File
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
	$exeFile:=$build.settings.destinationFolder.file($build.settings.buildName+".exe")
	If ($exeFile.exists)
		$infos:=$exeFile.getAppInfo()
		ASSERT($infos.FileVersion="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
		ASSERT($infos.ProductVersion="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
		ASSERT($infos.LegalCopyright="UT_copyright"; "(Current project) Standalone copyright should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11181")
		ASSERT($infos.CompanyName="UT_companyName"; "(Current project) Standalone companyName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11184")
		ASSERT($infos.FileDescription="UT_fileDescription"; "(Current project) Standalone fileDescription should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11185")
		ASSERT($infos.InternalName="UT_internalName"; "(Current project) Standalone internalName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11186")
		ASSERT($infos.OriginalFilename=$exeFile.fullName; "(Current project) Standalone OriginalFilename should be set")
		ASSERT($infos.ProductName=$build.settings.buildName; "(Current project) Standalone ProductName should be set")
	Else 
		ASSERT(False; "(Current project) Standalone exe file does not exist:"+$exeFile.path)
	End if 
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
	$exeFile:=$build.settings.destinationFolder.file($build.settings.buildName+".exe")
	If ($exeFile.exists)
		$infos:=$exeFile.getAppInfo()
		ASSERT($infos.FileVersion="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
		ASSERT($infos.ProductVersion="UT_version"; "(Current project) Standalone version should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11179")
		ASSERT($infos.LegalCopyright="UT_copyright"; "(Current project) Standalone copyright should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11181")
		ASSERT($infos.CompanyName="UT_companyName"; "(Current project) Standalone companyName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11184")
		ASSERT($infos.FileDescription="UT_fileDescription"; "(Current project) Standalone fileDescription should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11185")
		ASSERT($infos.InternalName="UT_internalName"; "(Current project) Standalone internalName should be set (https://dev.azure.com/4dimension/4D/_workitems/edit/11186")
		ASSERT($infos.OriginalFilename=$exeFile.fullName; "(Current project) Standalone OriginalFilename should be set")
		ASSERT($infos.ProductName=$build.settings.buildName; "(Current project) Standalone ProductName should be set")
	Else 
		ASSERT(False; "(Current project) Standalone exe file does not exist:"+$exeFile.path)
	End if 
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
