//%attributes = {}
// Test _build() function in the default folder
var $build : cs.Build4D.Server
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $file : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$settings.excludeModules:=[]
$settings.excludeModules.push("mecab")

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)


If (Is macOS)
	$file:=$build.settings.destinationFolder.file("Contents/Server Database/Ressources/UnitTests.txt")
Else 
	// to validate on windows
	$file:=$build.settings.destinationFolder.folder("Server Database/Ressources/UnitTests.txt")
End if 

ASSERT($file.exists; "(Current project) UnitTest.txt file doesnt exist.")





// Cleanup build folder

$build.settings.destinationFolder.parent.delete(fk recursive)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)


If (Is macOS)
	$file:=$build.settings.destinationFolder.file("Contents/Server Database/Ressources/UnitTests.txt")
Else 
	// to validate on windows
	$file:=$build.settings.destinationFolder.folder("Server Database/Ressources/UnitTests.txt")
End if 

ASSERT($file.exists; "(External project) UnitTest.txt file doesnt exist.")




// Cleanup build folder
$build.settings.destinationFolder.parent.delete(fk recursive)