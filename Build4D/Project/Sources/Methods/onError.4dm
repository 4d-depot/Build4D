//%attributes = {"invisible":true,"preemptive":"capable"}
If (Bool(This._ignoreError))
	
	// file command generate an error -1 if the path is a folder path
	
Else 
	This._log(New object("severity"; Error message; "callChain"; Get call chain; "errorCode"; Error; "errorMethod"; Error method; "errorLine"; Error line; "errorFormula"; Error formula))
	This._noError:=False
End if 