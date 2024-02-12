Class extends _core

//MARK:-
Class constructor($customSettings : Object)
	var $currentAppInfo; $sourceAppInfo : Object
	var $fileCheck : Boolean
	
	Super("Standalone"; $customSettings)
	
	If (This._validInstance)
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Standalone/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(Is macOS; ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(Is macOS; "Contents/"; "")+"Database/")
		
		//Checking license
		If ((This.settings.license=Null) || (Not(OB Instance of(This.settings.license; 4D.File))))
			This._validInstance:=False
			This._log(New object(\
				"function"; "License file checking"; \
				"message"; "License file is not defined"; \
				"severity"; Error message))
		Else 
			If (Not(This.settings.license.exists))
				This._validInstance:=False
				This._log(New object(\
					"function"; "License file checking"; \
					"message"; "License file doesn't exist"; \
					"severity"; Error message; \
					"path"; This.settings.license.path))
			End if 
		End if 
		
		//Checking source app
		If ((This.settings.sourceAppFolder=Null) || (Not(OB Instance of(This.settings.sourceAppFolder; 4D.Folder))))
			This._validInstance:=False
			This._log(New object(\
				"function"; "Source application folder checking"; \
				"message"; "Source application folder is not defined"; \
				"severity"; Error message))
		Else 
			If (Not(This.settings.sourceAppFolder.exists))
				This._validInstance:=False
				This._log(New object(\
					"function"; "Source application folder checking"; \
					"message"; "Source application folder doesn't exist"; \
					"severity"; Error message; \
					"sourceAppFolder"; This.settings.sourceAppFolder.path))
			Else 
				$fileCheck:=(Is macOS) ? This.settings.sourceAppFolder.file("Contents/MacOS/4D Volume Desktop").exists : This.settings.sourceAppFolder.file("4D Volume Desktop.4DE").exists
				If (Not($fileCheck))
					This._validInstance:=False
					This._log(New object(\
						"function"; "Source application folder checking"; \
						"message"; "Source application is not a 4D Volume Desktop"; \
						"severity"; Error message; \
						"sourceAppFolder"; This.settings.sourceAppFolder.path))
				Else   // Versions checking
					$sourceAppInfo:=(Is macOS) ? This.settings.sourceAppFolder.file("Contents/Info.plist").getAppInfo() : This.settings.sourceAppFolder.file("Resources/Info.plist").getAppInfo()
					$currentAppInfo:=(Is macOS) ? Folder(Application file; fk platform path).file("Contents/Info.plist").getAppInfo() : File(Application file; fk platform path).parent.file("Resources/Info.plist").getAppInfo()
					If (($sourceAppInfo.CFBundleVersion=Null) || ($currentAppInfo.CFBundleVersion=Null) || ($sourceAppInfo.CFBundleVersion#$currentAppInfo.CFBundleVersion))
						This._validInstance:=False
						This._log(New object(\
							"function"; "Source application version checking"; \
							"message"; "Source application version doesn't match to current application version"; \
							"severity"; Error message; \
							"sourceAppFolder"; This.settings.sourceAppFolder.path))
					End if 
				End if 
			End if 
		End if 
		
		If (This._validInstance)
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
		
	Else 
		This._log(New object(\
			"function"; "Class constuctor"; \
			"message"; "Class init failed."; \
			"severity"; Error message))
	End if 
	
	//MARK:- Renames the executable.
	
/*
	
Function _renameExecutable() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the executable has been correctly renamed.
....................................................................................
	
*/
	
Function _renameExecutable() : Boolean
	var $renamedExecutable : 4D.File
	If (Is macOS)
		$renamedExecutable:=This.settings.destinationFolder.file("Contents/MacOS/4D Volume Desktop").rename(This.settings.buildName)
	Else 
		$renamedExecutable:=This.settings.destinationFolder.file("4D Volume Desktop.4DE").rename(This.settings.buildName+".exe")
		This.settings.destinationFolder.file("4D Volume Desktop.rsr").rename(This.settings.buildName+".rsr")
	End if 
	If ($renamedExecutable.name#This.settings.buildName)
		This._log(New object(\
			"function"; "Source app copy"; \
			"message"; "Unable to rename the app: '"+This.settings.buildName+"'"; \
			"severity"; Error message))
		return False
	End if 
	return True
	
	
	//MARK:- Build the server application.
	
Function build()->$success : Boolean
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._compileProject() : False
	$success:=($success) ? This._createStructure() : False
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._renameExecutable() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._excludeModules() : False
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	$success:=($success) ? This._create4DZ() : False
	$success:=($success) ? This._generateLicense() : False
	If (Is macOS)
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Standalone application build successful."; \
			"messageSeverity"; Information message))
	End if 
	