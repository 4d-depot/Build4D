//%attributes = {"invisible":true}
// Build a client application and remove a relative file path
var $build : cs.Build4D.Client
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

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$settings.deletePaths:=[]
$settings.deletePaths.push("../Resources/smart constants.xml")

$build:=cs.Build4D.Client.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)


If (Is macOS)
	$file:=$build.settings.destinationFolder.file("Contents/Resources/smart constants.xml")
Else 
	$file:=$build.settings.destinationFolder.file("Resources/smart constants.xml")
End if 

ASSERT($file.exists=False; "(Current project) /Resources/smart constants.xml file should'nt exist: "+$file.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)



If (Is macOS)
	$file:=$build.settings.destinationFolder.file("Contents/Resources/smart constants.xml")
Else 
	$file:=$build.settings.destinationFolder.file("Resources/smart constants.xml")
End if 


ASSERT($file.exists=False; "(External project) /Resources/smart constants.xml file should'nt exist: "+$file.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)