//%attributes = {}
//Build a server application and execulde modules defined from the Module name in the /RESOURCES/BuildappOptionalModules.json
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

If ($success)
	If (Is macOS)
		$folder:=Folder($build.settings.destinationFolder.path+"Contents/Resources/mecab/")
	Else 
		// to validate on windows
		$folder:=Folder($build.settings.destinationFolder.path+"Resources/mecab/")
	End if 
	
	ASSERT($folder.exists=False; "the exculed module must be deleted.")
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
		$folder:=Folder($build.settings.destinationFolder.path+"Contents/Resources/mecab/")
	Else 
		// to validate on windows
		$folder:=Folder($build.settings.destinationFolder.path+"Resources/mecab/")
	End if 
	
	ASSERT($folder.exists=False; "the exculed module must be deleted.")
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
