Class extends _core

//MARK:-
Class constructor($customSettings : Object)
	
	Super("CompiledProject"; $customSettings)
	
	If (This._validInstance)
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("CompiledProject/"+This.settings.buildName+"/")
		End if 
		This._structureFolder:=This.settings.destinationFolder
		This._log(New object(\
			"function"; "Class constuctor"; \
			"message"; "Class init successful."; \
			"severity"; Information message))
	Else 
		This._log(New object(\
			"function"; "Class constuctor"; \
			"message"; "Class init failed."; \
			"severity"; Error message))
	End if 
	
	//MARK:-
Function build()->$success : Boolean
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._compileProject() : False
	$success:=($success) ? This._createStructure() : False
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	$success:=($success) ? This._create4DZ() : False
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; "message"; \
			"Compiled project build successful."; \
			"messageSeverity"; Information message))
	End if 