//%attributes = {}
// define the versioning.copyright server application information
var $build : cs.Build4D.Server
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer; $infoFile; $exeFile : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
//$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$settings.versioning:={}
$settings.versioning.copyright:="theCopyright"

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success "+$link)

If (Is macOS)
	$infoFile:=$build.settings.destinationFolder.file("Contents/Info.plist")
	$infos:=$infoFile.getAppInfo()
	
	ASSERT($infos.NSHumanReadableCopyright="theCopyright"; "(Current project) Server companyName should be set (https://github.com/orgs/4d/projects/119/views/4?pane=issue&itemId=37680117")
	
Else 
	$exeFile:=$build.settings.destinationFolder.file($build.settings.buildName+".exe")
	If ($exeFile.exists)
		$infos:=$exeFile.getAppInfo()
		ASSERT($infos.LegalCopyright="theCopyright"; "(Current project) Server companyName should be set (https://github.com/orgs/4d/projects/119/views/4?pane=issue&itemId=37680117")
		
		
	Else 
		
		ASSERT(False; "(Current project) Server exe file does not exist: "+$exeFile.path)
	End if 
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Server build should success "+$link)


If (Is macOS)
	$infoFile:=$build.settings.destinationFolder.file("Contents/Info.plist")
	$infos:=$infoFile.getAppInfo()
	
	ASSERT($infos.NSHumanReadableCopyright="theCopyright"; "(Current project) Server companyName should be set (https://github.com/orgs/4d/projects/119/views/4?pane=issue&itemId=37680117")
	
Else 
	$exeFile:=$build.settings.destinationFolder.file($build.settings.buildName+".exe")
	If ($exeFile.exists)
		$infos:=$exeFile.getAppInfo()
		ASSERT($infos.LegalCopyright="theCopyright"; "(Current project) Server companyName should be set (https://github.com/orgs/4d/projects/119/views/4?pane=issue&itemId=37680117")
		
		
	Else 
		
		ASSERT(False; "(Current project) Server exe file does not exist: "+$exeFile.path)
	End if 
End if 


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)