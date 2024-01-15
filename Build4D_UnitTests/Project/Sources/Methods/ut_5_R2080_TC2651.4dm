//%attributes = {"invisible":true}
// Test _build() function in the default folder
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
//$settings.serverSelectionAllowed:=False

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


ASSERT($infoPlist.exists; "(Current project) Info.plist file should exist: "+$buildServer.platformPath+$link)

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	
	ASSERT($infos["com.4D.BuildApp.ServerSelectionAllowed"]="false"; "(Current project) Info.plist com.4D.BuildApp.ServerSelectionAllowed Key should have value: false")
	
	
End if 

// Cleanup build folder
$build.settings.destinationFolder.parent.delete(fk recursive)


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

ASSERT($infoPlist.exists; "(External project) Info.plist file should exist: "+$buildServer.platformPath+$link)

If ($infoPlist.exists)
	$infos:=$infoPlist.getAppInfo()
	
	ASSERT($infos["com.4D.BuildApp.ServerSelectionAllowed"]="false"; "(External project) Info.plist com.4D.BuildApp.ServerSelectionAllowed Key should have value: false")
	
	
End if 

// Cleanup build folder
$build.settings.destinationFolder.parent.delete(fk recursive)
