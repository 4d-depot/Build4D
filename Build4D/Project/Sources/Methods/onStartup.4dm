//%attributes = {}
#DECLARE($launch : Boolean)

If (Count parameters=0)  // Execute code in a new worker
	
	CALL WORKER(Current method name; Current method name; True)
	
Else 
	
	var $userParam : Text
	var $result : Integer
	var $quit4D : Boolean
	
	$result:=Get database parameter(User param value; $userParam)
	If ($userParam#"")
		$quit4D:=(Not(Shift down))
		Case of 
			: ($userParam="build")
				buildComponent
			Else 
				LOG EVENT(Into system standard outputs; "::error ::User parameter not recognized ("+$userParam+")!"; Error message)
		End case 
		
		If ($quit4D)
			QUIT 4D
		End if 
	End if 
	
End if 
