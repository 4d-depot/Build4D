//%attributes = {}
// Test _build() function in the default folder
var $build : cs.Build4D.Server
var $settings; $infos : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $file1; $file2 : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$settings.deletePaths:=[]
$settings.deletePaths.push("../Resources/default.4DProject")
$settings.deletePaths.push("../Resources/default.4DPreferences")

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If ($success)
	
	If (Is macOS)
		$file1:=$build.settings.destinationFolder.file("Contents/Resources/default.4DProject")
		$file2:=$build.settings.destinationFolder.file("Contents/Resources/default.4DPreferences")
	Else 
		$file1:=$build.settings.destinationFolder.file("Resources/default.4DProject")
		$file2:=$build.settings.destinationFolder.file("Resources/default.4DPreferences")
	End if 
	
	ASSERT($file1.exists=False; "the file must be deleted !")
	ASSERT($file2.exists=False; "the file must be deleted !")
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)

If ($success)
	
	If (Is macOS)
		$file1:=$build.settings.destinationFolder.file("Contents/Resources/default.4DProject")
		$file2:=$build.settings.destinationFolder.file("Contents/Resources/default.4DPreferences")
	Else 
		$file1:=$build.settings.destinationFolder.file("Resources/default.4DProject")
		$file2:=$build.settings.destinationFolder.file("Resources/default.4DPreferences")
	End if 
	
	ASSERT($file1.exists=False; "the file must be deleted !")
	ASSERT($file2.exists=False; "the file must be deleted !")
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
