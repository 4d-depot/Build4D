//%attributes = {"invisible":true}
// Test the client application signature
var $build : cs.Build4D.Client
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
//$settings.serverSelectionAllowed:=False

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$settings.signApplication:=New object(\
"macSignature"; False; \
"adHocSignature"; True)

$build:=cs.Build4D.Client.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)

var $verificationWorker : 4D.SystemWorker
$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$build.settings.destinationFolder.path)
$verificationWorker.wait(120)
If ($verificationWorker.terminated)
	If ($verificationWorker.exitCode=0)
		// The application is signed adhoc if a line "Signature=adhoc" exists
		var $lines : Collection
		$lines:=Split string($verificationWorker.responseError; "\n")
		ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Signature=adhoc"))); "(Current project) Standalone should be signed. Verification response: "+$verificationWorker.responseError+$link)
	End if 
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Client.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)


var $verificationWorker : 4D.SystemWorker
$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$build.settings.destinationFolder.path)
$verificationWorker.wait(120)
If ($verificationWorker.terminated)
	If ($verificationWorker.exitCode=0)
		// The application is signed adhoc if a line "Signature=adhoc" exists
		var $lines : Collection
		$lines:=Split string($verificationWorker.responseError; "\n")
		ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Signature=adhoc"))); "(Current project) Standalone should be signed. Verification response: "+$verificationWorker.responseError+$link)
	End if 
End if 

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)