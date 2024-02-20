//%attributes = {}
// Build a server application and remove an absolute folder path
var $build : cs.Build4D.Server
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder; $folder : 4D.Folder
var $buildServer : 4D.File
var $infoPlist : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$settings.deletePaths:=[]
//$settings.deletePaths.push("../Components/4D Widgets.4dbase")
$settings.deletePaths.push("/Resources/")

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)


If (Is macOS)
	$folder:=$build.settings.destinationFolder.folder("Contents/Server Database/Resources/")
Else 
	// to validate on windows
	$folder:=$build.settings.destinationFolder.folder("Server Database/Resources/")
End if 

ASSERT($folder.exists=False; "(Current project) Resources folder doesnt exist.")


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)



// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)


If (Is macOS)
	$folder:=$build.settings.destinationFolder.folder("Contents/Server Database/Resources/")
Else 
	// to validate on windows
	$folder:=$build.settings.destinationFolder.folder("Server Database/Resources/")
End if 

ASSERT($folder.exists=False; "(External project) Resources folder doesnt exist.")


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
