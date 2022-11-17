Class extends _core

//MARK:-
Class constructor($customSettings : Object)
	// TODO: Include documentation of private functions and shared methods in the includePaths collection.
	
	Super("Component"; $customSettings)
	
	If (This._validInstance)
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Component/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+".4dbase/")
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
	If (Is macOS)
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Component build successful."; \
			"messageSeverity"; Information message))
	End if 
	