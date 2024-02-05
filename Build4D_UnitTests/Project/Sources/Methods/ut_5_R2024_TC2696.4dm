//%attributes = {}
// Test _build() function in the default folder
var $build : cs.Build4D.Server
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

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

If (Is macOS)
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib"))  // Silicon compilation mandatory, else no code to sign, so can't check requested result
Else 
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"))
End if 

//the goal : signApp app
$settings.signApplication:=New object(\
"macSignature"; True; \
"adHocSignature"; False)


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

If (Is macOS)
	ASSERT($success=False; "(Current project) Server build should not success"+$link)
Else 
	ASSERT($success; "(Current project) Server build should success"+$link)
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

If (Is macOS)
	ASSERT($success=False; "(External project) Server build should not success"+$link)
Else 
	ASSERT($success; "(External project) Server build should success"+$link)
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
