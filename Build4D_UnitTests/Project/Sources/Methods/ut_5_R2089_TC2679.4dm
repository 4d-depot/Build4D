//%attributes = {"invisible":true}
// Test _build() function in the default folder
var $build : cs.Build4D.CompiledProject
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $4DLink : 4D.File
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

ASSERT($success; "(Current project) Client build should success"+$link)

If (Is macOS)
	$4DLink:=$build.settings.destinationFolder.file("Contents/Database/EnginedServer.4Dlink")
Else 
	// to validate on windows
	$4DLink:=$build.settings.destinationFolder.file("Database/EnginedServer.4Dlink")
End if 



var $c_link : cs._4DLink

$c_link:=cs._4DLink.new($4DLink)

Case of 
	: (Asserted($c_link.is_valid=False; "(Current project) EnginedServer.4Dlink file should exist: "+$link))
	: (Asserted($c_link.has_database_name=False; "(Current project) EnginedServer.4Dlink database_name should exist: "+$link))
	: (Asserted($c_link.has_path=False; "(Current project) EnginedServer.4Dlink database_path exist: "+$link))
	: (Asserted($c_link.has_port=False; "(Current project) EnginedServer.4Dlink port should exist: "+$link))
		
	Else 
		
		// everything is ok
		
End case 


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


var $c_link : cs._4DLink

$c_link:=cs._4DLink.new($4DLink)

Case of 
	: (Asserted($c_link.is_valid=False; "(External project) EnginedServer.4Dlink file should exist: "+$link))
	: (Asserted($c_link.has_database_name=False; "(External project) EnginedServer.4Dlink database_name should exist: "+$link))
	: (Asserted($c_link.has_path=False; "(External project) EnginedServer.4Dlink database_path exist: "+$link))
	: (Asserted($c_link.has_port=False; "(External project) EnginedServer.4Dlink port should exist: "+$link))
		
	Else 
		
		// everything is ok
		
End case 

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 