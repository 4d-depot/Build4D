//%attributes = {"invisible":true}
// build the server application without adding the BuildCurrentVers key
var $build : cs.Build4D.Server
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildClient : 4D.File
var $infoPlist : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If (Is macOS)
	$infoPlist:=$build.settings.destinationFolder.file("Contents/Info.plist")
Else 
	// to validate on windows
	$infoPlist:=$build.settings.destinationFolder.file("Resources/Info.plist")
End if 

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	
	ASSERT($infos["BuildCurrentVers"]="1"; "(Current project) Info.plist BuildCurrentVers Key should have value: 1")
	
End if 


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)

If (Is macOS)
	$infoPlist:=$build.settings.destinationFolder.file("Contents/Info.plist")
Else 
	// to validate on windows
	$infoPlist:=$build.settings.destinationFolder.file("Resources/Info.plist")
End if 

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	
	ASSERT($infos["BuildCurrentVers"]="1"; "(External project) Info.plist BuildCurrentVers Key should have value: 1")
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)