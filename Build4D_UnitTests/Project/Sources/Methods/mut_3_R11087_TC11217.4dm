//%attributes = {}
// Test application signature with certificate
If (Is macOS)
	var $build : cs.Build4D.Standalone
	var $settings : Object
	var $success : Boolean
	var $link : Text
	var $assertions : Boolean
	$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"
	
	$assertions:=Get assert enabled
	SET ASSERT ENABLED(True)
	
	logGitHubActions(Current method name)
	
	// MARK:- Current project
	
	$settings:=New object()
	$settings.formulaForLogs:=Formula(logGitHubActions($1))
	$settings.destinationFolder:="./Test/"
	$settings.license:=Storage.settings.licenseUUD
	$settings.compilerOptions:=New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib"))
	$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)
	$settings.signApplication:=New object(\
		"macSignature"; True; \
		"macCertificate"; Storage.settings.macCertificate; \
		"adHocSignature"; False)
	
	$build:=cs.Build4D.Standalone.new($settings)
	$success:=$build.build()
	
	ASSERT($success; "(Current project) Standalone build should success"+$link)
	
	var $verificationWorker : 4D.SystemWorker
	$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$build.settings.destinationFolder.path)
	$verificationWorker.wait(120)
	If ($verificationWorker.terminated)
		If ($verificationWorker.exitCode=0)
			// The application is signed with certificate if a line "Authority=certificate name" exists
			var $lines : Collection
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Authority="+Storage.settings.macCertificate))); "(Current project) Standalone should be signed. Verification response: "+$verificationWorker.responseError+$link)
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
			// The application is signed with certificate if a line "Authority=certificate name" exists
			var $lines : Collection
			$lines:=New collection()
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Authority="+Storage.settings.macCertificate))); "(External project) Standalone should be signed. Verification response: "+$verificationWorker.responseError+$link)
		End if 
	End if 
	
	// Cleanup build folder
	Folder("/PACKAGE/Test").delete(fk recursive)
	
	SET ASSERT ENABLED($assertions)
	
Else 
	ALERT("macOS only!")
End if 
