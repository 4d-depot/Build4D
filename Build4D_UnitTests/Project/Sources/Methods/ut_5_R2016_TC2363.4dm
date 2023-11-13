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

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.compilerOptions:=New object("targets"; New collection("arm32_macOS_lib"; "arm128_macOS_lib"))  // arm 32 & 128 bits ?



$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(Current project) Compiled project build should success"+$link)


// Cleanup build folder
If ($success)
	If (Is macOS)
		
		$build.settings.destinationFolder.parent.delete(fk recursive)
		
	Else 
		// to validate on windows
		$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
		
	End if 
End if 

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success=False; "(External project) Compiled project build should success"+$link)

// Cleanup build folder
If ($success)
	If (Is macOS)
		
		$build.settings.destinationFolder.parent.delete(fk recursive)
		
	Else 
		// to validate on windows
		$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
		
	End if 
End if 