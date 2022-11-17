//%attributes = {}
//Performs all manual unit tests

var $errorMethod : Text
$errorMethod:=Method called on error
ON ERR CALL("onError")

// Execute all automatic test methods
ARRAY TEXT($methods; 0)
var $m : Integer
METHOD GET NAMES($methods; "mut_@")
SORT ARRAY($methods)
For ($m; 1; Size of array($methods))
	logGitHubActions("::group::"+$methods{$m})
	EXECUTE METHOD($methods{$m})
	logGitHubActions("::endgroup::")
End for 

If (Storage.settings.userInterface)
	If (Storage.settings.logErrorFile.exists)
		ALERT("Unit tests FAILED")
		SHOW ON DISK(Storage.settings.logErrorFile.platformPath)
	Else 
		ALERT("Unit tests passed")
	End if 
End if 

ON ERR CALL($errorMethod)
