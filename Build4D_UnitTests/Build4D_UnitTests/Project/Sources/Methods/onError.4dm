//%attributes = {}
var $log : Object
$log:=New object("severity"; Error message; "callChain"; Get call chain; "errorCode"; Error; "errorMethod"; Error method; "errorLine"; Error line; "errorFormula"; Error formula)

If ($log.errorCode=-10518)  // Assertion failure
	LOG EVENT(Into system standard outputs; "::error ::"+JSON Stringify($log)+"\n"; Error message)  // GitHub Actions message
	var $logFile : 4D.File
	var $logs : Collection
	$logFile:=Storage.settings.logErrorFile
	$logs:=($logFile.exists) ? JSON Parse($logFile.getText()) : New collection
	$log.timestamp:=Timestamp
	$logs.push($log)
	$logFile.setText(JSON Stringify($logs; *))
Else 
	logGitHubActions($log)
End if 
