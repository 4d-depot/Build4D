//%attributes = {"invisible":true}
// Test _build() function in the default folder
var $build : cs.Build4D.Client
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $folder : 4D.Folder
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$settings.deletePaths:=[]
$settings.deletePaths.push("../Resources/ja.lproj/")

$build:=cs.Build4D.Client.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)


If (Is macOS)
	$folder:=$build.settings.destinationFolder.folder("Contents/Resources/ja.lproj/")
Else 
	$folder:=$build.settings.destinationFolder.folder("Resources/ja.lproj/")
End if 

ASSERT($folder.exists=False; "(Current project) /Resources/ja.lproj folder should'nt exist: "+$folder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)



If (Is macOS)
	$folder:=$build.settings.destinationFolder.folder("Contents/Resources/ja.lproj/")
Else 
	$folder:=$build.settings.destinationFolder.folder("Resources/ja.lproj/")
End if 


ASSERT($folder.exists=False; "(External project) /Resources/ja.lproj folder should'nt exist: "+$folder.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)