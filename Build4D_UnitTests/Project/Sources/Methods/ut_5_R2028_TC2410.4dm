//%attributes = {"invisible":true}
// Test _build() function in the default folder
var $build : cs.Build4D.CompiledProject
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


$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
ASSERT($manifestFile.exists; "(Current project) Standalone Updater manifest should exist: "+$manifestFile.platformPath+$link)

$manifestContent:=$manifestFile.getText()
ASSERT($manifestContent="@level=\"asInvoker\"@"; "(Current project) Server Updater manifest should contain normal rights"+$link)

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

$manifestFile:=$build.settings.destinationFolder.file("Resources/Updater/Updater.exe.manifest")
ASSERT($manifestFile.exists; "(External project) Server Updater manifest should exist: "+$manifestFile.platformPath+$link)

$manifestContent:=$manifestFile.getText()
ASSERT($manifestContent="@level=\"asInvoker\"@"; "(External project) Server Updater manifest should contain normal rights"+$link)
// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 