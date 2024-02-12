//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($launch : Boolean)

If (Count parameters=0)  // Execute code in a new worker
	
	CALL WORKER("Build 4D"; Current method name; True)
	
Else 
	
	
/*
	
à faire évoluer
	
*/
	
	var $userParam; $action : Text
	var $result : Integer
	var $quit4D : Boolean
	var $_args : Collection
	
	$result:=Get database parameter(User param value; $userParam)
	If ($userParam#"")
		$quit4D:=(Not(Shift down))
		
		$_args:=Split string($userParam; " "; sk trim spaces+sk ignore empty strings)
		
		$action:=$_args[0]
		
		Case of 
				
			: ($action="build")
				buildComponent
				
				
				
				
			Else 
				LOG EVENT(Into system standard outputs; "::error ::User parameter not recognized ("+$userParam+")!"; Error message)
		End case 
		
		If ($quit4D)
			
			//QUIT 4D // not préemptive
			CALL WORKER("cooperative bridge"; "quit4D_coop")
			
		End if 
	End if 
	
End if 
