//%attributes = {}
// Test the component signature with custom signature settings (True, None, None) in specified destination folder
If (Is macOS)
	var $build : cs.Build4D.Component
	var $settings : Object
	var $success : Boolean
	var $deletedFile : 4D.File
	var $link : Text
	$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.buildName:="Build4D"
	$settings.destinationFolder:="./Test/"
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib"))  // Silicon compilation mandatory, else no code to sign, so can't check requested result
	$settings.signApplication:=New object("macSignature"; True)
	
	$build:=cs.Build4D.Component.new($settings)
	
	$success:=$build.build()
	
	ASSERT($success=False; "(Current project) Component build should fail"+$link)  // No certificate name
	
	var $siliconCodeFile : 4D.File
	$siliconCodeFile:=$build.settings.destinationFolder.file("Libraries/lib4d-arm64.dylib")
	If ($siliconCodeFile.exists)
		var $verificationWorker : 4D.SystemWorker
		$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$siliconCodeFile.path)
		$verificationWorker.wait(120)
		If ($verificationWorker.terminated)
			If ($verificationWorker.exitCode=0)
				// The file is signed if a line "Runtime Version=versionNumber" exists
				var $lines : Collection
				$lines:=Split string($verificationWorker.responseError; "\n")
				ASSERT(Undefined($lines.find(Formula($1.value=$2); "Runtime Version=@")); "(Current project) Component should NOT be signed. Verification response: "+$verificationWorker.responseError+$link)
			End if 
		End if 
	End if 
	
	// Cleanup build folder
	Folder("/PACKAGE/Test"; *).delete(fk recursive)
	
	// MARK:- External project
	
	$settings.projectFile:=Storage.settings.externalProjectFile
	
	$build:=cs.Build4D.Component.new($settings)
	
	$success:=$build.build()
	
	ASSERT($success=False; "(External project) Component build should fail"+$link)  // No certificate name
	
	var $siliconCodeFile : 4D.File
	$siliconCodeFile:=$build.settings.destinationFolder.file("Libraries/lib4d-arm64.dylib")
	If ($siliconCodeFile.exists)
		var $verificationWorker : 4D.SystemWorker
		$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$siliconCodeFile.path)
		$verificationWorker.wait(120)
		If ($verificationWorker.terminated)
			If ($verificationWorker.exitCode=0)
				// The file is signed if a line "Runtime Version=versionNumber" exists
				var $lines : Collection
				$lines:=Split string($verificationWorker.responseError; "\n")
				ASSERT(Undefined($lines.find(Formula($1.value=$2); "Runtime Version=@")); "(External project) Component should NOT be signed. Verification response: "+$verificationWorker.responseError+$link)
			End if 
		End if 
	End if 
	
	// Cleanup build folder
	Storage.settings.externalProjectRootFolder.folder("Test").delete(fk recursive)
End if 
