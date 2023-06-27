//%attributes = {}
// Test application adhoc signature
If (Is macOS)
	var $build : cs.Build4D.Standalone
	var $settings : Object
	var $success : Boolean
	var $link : Text
	$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	$settings.license:=Storage.settings.licenseUUD
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib"))
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Standalone build should success"+$link)
	
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
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	ASSERT($success; "(External project) Standalone build should success"+$link)
	
	var $verificationWorker : 4D.SystemWorker
	$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$build.settings.destinationFolder.path)
	$verificationWorker.wait(120)
	If ($verificationWorker.terminated)
		If ($verificationWorker.exitCode=0)
			// The application is signed adhoc if a line "Signature=adhoc" exists
			var $lines : Collection
			$lines:=New collection()
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Signature=adhoc"))); "(External project) Standalone should be signed. Verification response: "+$verificationWorker.responseError+$link)
		End if 
	End if 
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
End if 
