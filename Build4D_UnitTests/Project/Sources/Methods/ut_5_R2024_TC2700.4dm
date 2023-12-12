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
"macCertificate"; Storage.settings.macCertificate)



$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

var $siliconCodeFile : 4D.File
$siliconCodeFile:=$build.settings.destinationFolder.file("Contents/Server Database/Libraries/lib4d-arm64.dylib")
If ($siliconCodeFile.exists)
	var $siliconCodePath : Text
	var $verificationWorker : 4D.SystemWorker
	
	$siliconCodePath:=Replace string($siliconCodeFile.path; " "; "\\ ")  // Server Database -> Server\ Database
	
	$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$siliconCodePath)
	$verificationWorker.wait(120)
	If ($verificationWorker.terminated)
		If ($verificationWorker.exitCode=0)
			// The file is signed if a line "Runtime Version=versionNumber" exists
			var $lines : Collection
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Runtime Version=@"))); "(Current project) Server should be signed. Verification response: "+$verificationWorker.responseError+$link)
		End if 
	End if 
End if 

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

ASSERT($success; "(External project) Server build should success "+$link)

var $siliconCodeFile : 4D.File
$siliconCodeFile:=$build.settings.destinationFolder.file("Contents/Server Database/Libraries/lib4d-arm64.dylib")
If ($siliconCodeFile.exists)
	var $siliconCodePath : Text
	var $verificationWorker : 4D.SystemWorker
	
	$siliconCodePath:=Replace string($siliconCodeFile.path; " "; "\\ ")  // Server Database -> Server\ Database
	
	$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$siliconCodePath)
	$verificationWorker.wait(120)
	If ($verificationWorker.terminated)
		If ($verificationWorker.exitCode=0)
			// The file is signed if a line "Runtime Version=versionNumber" exists
			var $lines : Collection
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Runtime Version=@"))); "(Current project) Server should be signed. Verification response: "+$verificationWorker.responseError+$link)
		End if 
	End if 
End if 

// Cleanup build folder
If (Is macOS)
	
	$build.settings.destinationFolder.parent.delete(fk recursive)
	
Else 
	// to validate on windows
	$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
	
End if 
