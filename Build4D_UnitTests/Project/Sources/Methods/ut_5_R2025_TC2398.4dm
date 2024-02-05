//%attributes = {}
// Test _build() function in the default folder
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer; $file : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

var $source : 4D.File
var $path : Object

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

If (Is macOS)
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib"))  // Silicon compilation mandatory, else no code to sign, so can't check requested result
Else 
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"))
End if 


$path:={\
source: "/README.md"; \
destination: "../Test/"\
}

$settings.includePaths:=[$path]


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If ($success)
	
	If (Is macOS)
		$file:=$build.settings.destinationFolder.file("Contents/Test/README.md")
	Else 
		$file:=$build.settings.destinationFolder.file("Test/README.md")
	End if 
	
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
		$file:=$build.settings.destinationFolder.file("Contents/Test/README.md")
	Else 
		$file:=$build.settings.destinationFolder.file("Test/README.md")
	End if 
	
	ASSERT($file.exists; "(External project) file added not found "+$source.path+" "+$link)
	
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
