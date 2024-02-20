//%attributes = {}
// Build a compiled project and create a read-only .4DZ packed file
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean
var $4DZ : 4D.File
var $folder : 4D.Folder

var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.buildName:="Build4D"
$settings.destinationFolder:="./Test/"

$settings.packedProject:=True

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If ($success)
	If (Is macOS)
		$folder:=$build.settings.destinationFolder.folder("Contents/Server Database/")
	Else 
		// to validate on windows
		$folder:=$build.settings.destinationFolder.folder("Server Database/")
	End if 
	
	$4DZ:=$folder.file($build.settings.buildName+".4DZ")
	ASSERT($4DZ.exists; "(Current project) Compiled project 4DZ file should exist: "+$4DZ.platformPath+$link)
	
End if 


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

If ($success)
	If (Is macOS)
		$folder:=$build.settings.destinationFolder.folder("Contents/Server Database/")
	Else 
		// to validate on windows
		$folder:=$build.settings.destinationFolder.folder("Server Database/")
	End if 
	
	$4DZ:=$folder.file($build.settings.buildName+".4DZ")
	ASSERT($4DZ.exists; "(Current project) Compiled project 4DZ file should exist: "+$4DZ.platformPath+$link)
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
