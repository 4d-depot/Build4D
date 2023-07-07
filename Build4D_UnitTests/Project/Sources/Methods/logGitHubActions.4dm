//%attributes = {}
#DECLARE($log : Variant)
var $logFile : 4D.File
var $logs : Collection

$logFile:=Storage.settings.logRunFile
$logs:=($logFile.exists) ? JSON Parse($logFile.getText()) : New collection

Case of 
		
	: (Value type($log)=Is text)  // Text information message or group
		
		If (($log="::group::@") | ($log="::endgroup::"))
			LOG EVENT(Into system standard outputs; $log+"\n"; Error message)
		Else 
			LOG EVENT(Into system standard outputs; "::notice ::"+$log+"\n"; Error message)  // GitHub Actions message
			var $logMessage : Object
			$logMessage:=New object("message"; $log; "timestamp"; Timestamp)
			$logs.push($logMessage)
			$logFile.setText(JSON Stringify($logs; *))
		End if 
		
	: (Value type($log)=Is object)  // Component message
		var $logType : Text
		var $severity : Integer
		$severity:=$log.severity
		//$logType:=Choose($severity; "::notice ::"; "::warning ::"; "::error ::") // Error stops GitHub Actions workflow
		$logType:=Choose($severity; "::notice ::"; "::warning ::"; "::warning ::[ERROR] ")
		LOG EVENT(Into system standard outputs; $logType+JSON Stringify($log; *)+"\n"; Error message)  // GitHub Actions message
		
		$log.timestamp:=Timestamp
		$logs.push($log)
		$logFile.setText(JSON Stringify($logs; *))
		
End case 
