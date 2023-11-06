//%attributes = {"invisible":true}
// Test _build() function in the default folder
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
//$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)

$destinationFolder:=$build._projectPackage.parent.folder($build._projectFile.name+"_Build/CompiledProject/"+$build.settings.buildName)
ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(Current project) Wrong default destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

If (Is macOS)
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/").file($build.settings.buildName+".4DZ")
Else 
	// to validate on windows
	$buildServer:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.name=$build._projectFile.name; "(Current project) Build Server Name should be: "+$build._projectFile.name+$link)

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

$destinationFolder:=$build._projectPackage.parent.folder($build._projectFile.name+"_Build/CompiledProject/"+$build.settings.buildName)
ASSERT($build.settings.destinationFolder.platformPath=$destinationFolder.platformPath; "(External project) Wrong default destination folder: "+$build.settings.destinationFolder.platformPath+$link)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

If (Is macOS)
	$buildServer:=$build.settings.destinationFolder.folder("Contents/Server Database/").file($build.settings.buildName+".4DZ")
Else 
	$buildServer:=$build.settings.destinationFolder.file($build.settings.buildName+".4DZ")
End if 
ASSERT($buildServer.name=$build._projectFile.name; "(External project)  Build Server Name should be: "+$build._projectFile.name+$link)

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 