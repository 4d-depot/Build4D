//%attributes = {}
// build the client application without setting the "publishName"
var $build : cs.Build4D.Client
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $infoPlist : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)


$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)


If (Is macOS)
	$infoPlist:=$build.settings.destinationFolder.file("Contents/Info.plist")
Else 
	// to validate on windows
	$infoPlist:=$build.settings.destinationFolder.file("Resources/Info.plist")
End if 

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	
	ASSERT($infos["PublishName"]=$settings.buildName; "(Current project) Info.plist PublishName Key should have value: "+$settings.buildName)
Else 
	ASSERT(False; "(Current project) Info.plist file doesnt exist.")
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

If (Is macOS)
	$infoPlist:=$build.settings.destinationFolder.file("Contents/Info.plist")
Else 
	// to validate on windows
	$infoPlist:=$build.settings.destinationFolder.file("Resources/Info.plist")
End if 

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	ASSERT($infos["PublishName"]=$settings.buildName; "(External project) Info.plist PublishName Key should have value: "+$settings.buildName)
Else 
	ASSERT(False; "(External project) Info.plist file doesnt exist.")
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)