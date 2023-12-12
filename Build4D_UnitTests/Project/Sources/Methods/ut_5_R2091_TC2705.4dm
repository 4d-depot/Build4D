//%attributes = {"invisible":true}
// Test _build() function in the default folder
var $build : cs.Build4D.Client
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $4DLink : 4D.File
var $link; $buffer : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.clientServerSystemFolderName:="myFavoriteLocation"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$build:=cs.Build4D.Client.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Client build should success"+$link)

If (Is macOS)
	$4DLink:=$build.settings.destinationFolder.file("Contents/Database/EnginedServer.4Dlink")
Else 
	// to validate on windows
	$4DLink:=$build.settings.destinationFolder.file("Database/EnginedServer.4Dlink")
End if 


ASSERT($4DLink.exists; "(Current project) EnginedServer.4Dlink file should exist: "+$link)

If ($4DLink.exists)
	$buffer:=$4DLink.getText()
	
	ASSERT(Position("cache_folder_name"; $buffer)>0; "(Current project) cache_folder_name Key should have value: "+$settings.clientServerSystemFolderName)
	
End if 

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Client build should success"+$link)

If (Is macOS)
	$4DLink:=$build.settings.destinationFolder.file("Contents/Database/EnginedServer.4Dlink")
Else 
	// to validate on windows
	$4DLink:=$build.settings.destinationFolder.file("Database/EnginedServer.4Dlink")
End if 


ASSERT($4DLink.exists; "(External project) EnginedServer.4Dlink file should exist: "+$link)

If ($4DLink.exists)
	$buffer:=$4DLink.getText()
	
	ASSERT(Position("cache_folder_name"; $buffer)>0; "(External project) cache_folder_name Key should have value: "+$settings.clientServerSystemFolderName)
	
End if 

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 