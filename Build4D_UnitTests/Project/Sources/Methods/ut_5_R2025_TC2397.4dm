//%attributes = {}
// Build a server application and add a file located at a relative path to an undefined destination
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
source: "../README.md"; \
destination: Null\
}

$settings.includePaths:=[$path]


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success=False; "(Current project) Server build should'nt success"+$link)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success=False; "(External project) Server build should'nt success"+$link)

