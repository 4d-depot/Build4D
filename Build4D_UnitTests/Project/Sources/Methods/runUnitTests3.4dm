//%attributes = {}
//Performs automatic unit tests on target 1: standalone

var $target : Text
$target:=Substring(Current method name; Length(Current method name))

Storage.settings.logRunFile.delete()
Storage.settings.logErrorFile.delete()
Storage.settings.rootFolder.file("UT_start.log").setText(Timestamp)
Storage.settings.rootFolder.file("UT_end.log").delete()

var $errorMethod : Text
$errorMethod:=Method called on error
ON ERR CALL("onError")

METHOD SET CODE("compilationError"; ""; *)
SET ASSERT ENABLED(True)

logGitHubActions("Unit Tests "+$target+" start")
logGitHubActions("::group::Storage content")
logGitHubActions(New object("Storage content"; Storage))
logGitHubActions("::endgroup::")

// Execute all automatic test methods
ARRAY TEXT($methods; 0)
var $m : Integer
METHOD GET NAMES($methods; "ut_"+$target+"_@")
SORT ARRAY($methods)
For ($m; 1; Size of array($methods))
	logGitHubActions("::group::"+$methods{$m})
	EXECUTE METHOD($methods{$m})
	logGitHubActions("::endgroup::")
End for 

Storage.settings.rootFolder.file("UT_end.log").setText(Timestamp)
logGitHubActions("Unit Tests "+$target+" end")

If (Storage.settings.userInterface)
	If (Storage.settings.logErrorFile.exists)
		ALERT("Unit tests "+$target+" FAILED")
		SHOW ON DISK(Storage.settings.logErrorFile.platformPath)
	Else 
		ALERT("Unit tests "+$target+" passed")
	End if 
End if 

ON ERR CALL($errorMethod)
