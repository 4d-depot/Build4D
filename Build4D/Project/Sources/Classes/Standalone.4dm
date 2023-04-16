Class extends _core

//MARK:-
Class constructor($customSettings : Object)
	
	Super("Standalone"; $customSettings)
	
	If (This._validInstance)
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Standalone/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(Is macOS; ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(Is macOS; "Contents/"; "")+"Database/")
	End if 
	
	//MARK:-
Function build()->$success : Boolean
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._compileProject() : False
	$success:=($success) ? This._createStructure() : False
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	$success:=($success) ? This._create4DZ() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._generateLicenses() : False
	If (Is macOS)
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Standalone application build successful."; \
			"messageSeverity"; Information message))
	End if 
	