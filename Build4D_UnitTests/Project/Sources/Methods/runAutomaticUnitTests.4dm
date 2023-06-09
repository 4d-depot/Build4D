//%attributes = {}
//Performs all automatic unit tests

var $artifactsFolder : 4D.Folder
var $errorsLogFile : 4D.File
$artifactsFolder:=Storage.settings.rootFolder.parent.parent.folder("Artifacts")
$artifactsFolder.folder("Build4D.4dbase").delete(Delete with contents)
$errorsLogFile:=Storage.settings.logErrorFile

Storage.settings.logRunFile.delete()
Storage.settings.logErrorFile.delete()
Storage.settings.rootFolder.file("UT_start.log").setText(Timestamp)
Storage.settings.rootFolder.file("UT_end.log").delete()

var $errorMethod : Text
$errorMethod:=Method called on error
ON ERR CALL("onError")

METHOD SET CODE("compilationError"; ""; *)
SET ASSERT ENABLED(True)

logGitHubActions("Unit Tests start")
logGitHubActions("::group::Storage content")
logGitHubActions(New object("Storage content"; Storage))
logGitHubActions("::endgroup::")


// Check compilation first
logGitHubActions("::group::Compilation checking (compilationTest)")
compilationTest
logGitHubActions("::endgroup::")

If (Not($errorsLogFile.exists))  // Compilation Ok -> execute all unit tests methods
	
	// Execute all automatic test methods
	ARRAY TEXT($methods; 0)
	var $m : Integer
	METHOD GET NAMES($methods; "ut_@")
	SORT ARRAY($methods)
	For ($m; 1; Size of array($methods))
		logGitHubActions("::group::"+$methods{$m})
		EXECUTE METHOD($methods{$m})
		logGitHubActions("::endgroup::")
	End for 
	
End if 

Storage.settings.rootFolder.file("UT_end.log").setText(Timestamp)
logGitHubActions("Unit Tests end")

If (Not(Storage.settings.logErrorFile.exists))  // Unit tests successful: copy into Artifacts ditectory
	Storage.settings.rootFolder.folder("Components/Build4D.4dbase").copyTo($artifactsFolder)
End if 

If (Storage.settings.userInterface)
	If (Storage.settings.logErrorFile.exists)
		ALERT("Unit tests FAILED")
		SHOW ON DISK(Storage.settings.logErrorFile.platformPath)
	Else 
		ALERT("Unit tests passed")
	End if 
End if 

ON ERR CALL($errorMethod)
