Class extends _core



//MARK:-
Class constructor($customSettings : Object)
	
	var $currentAppInfo; $sourceAppInfo : Object
	var $fileCheck : Boolean
	
	Super("Client"; $customSettings)
	
	If (This._validInstance)
		
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("ClientApp/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(Is macOS; ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(Is macOS; "Contents/"; "")+"Database/")
		
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
	
	//MARK:-
	//TODO: append publication port for client/server on settings by default 19813
	
Function _make4dLink() : Boolean
	
	var $xml; $text : Text
	var $4DLink : 4D.File
	
	
	If (This._structureFolder.exists)
		
	Else 
		This._structureFolder.create()
	End if 
	
	$xml:=DOM Create XML Ref("database_shortcut")
	
	DOM SET XML ATTRIBUTE($xml; \
		"is_remote"; "true"; \
		"server_database_name"; This.settings.buildName; \
		"server_path"; ":19813")
	
	DOM EXPORT TO VAR($xml; $text)
	DOM CLOSE XML($xml)
	
	
	$4DLink:=This._structureFolder.file("EnginedServer.4Dlink")
	
	If ($4DLink.create())
		
		$4DLink.setText($text)
		
	Else 
		
		This._log(New object(\
			"function"; "Create 4DLink"; \
			"message"; "Unable to create 4DLink: '"+This.settings.buildName+"'"; \
			"severity"; Error message))
		
	End if 
	
	return $4DLink.exists
	
	
	//MARK:-
	
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
	
	
	//MARK:-
	
Function build()->$success : Boolean
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._compileProject() : False  // util ?
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._renameExecutable() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._excludeModules() : False
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	
	If (True)
		$success:=($success) ? This._make4dLink() : False
	Else 
		$success:=($success) ? This._create4DZ() : False
	End if 
	
	If (Is macOS)
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Standalone application build successful."; \
			"messageSeverity"; Information message))
	End if 
	
	
	
Function build_archive()->$result : Object
	
	var $app_folder : 4D.Folder
	var $zip_archive : 4D.File
	var $filename : Text
	
	$app_folder:=This.settings.destinationFolder
	
	If ($app_folder.exists)
		
		$filename:=This.settings.sourceAppFolder.isPackage ? "update.mac.4darchive" : "update.win.4darchive"
		
		$zip_archive:=$app_folder.parent.file($filename)
		
		If ($zip_archive.exists)
			$zip_archive.delete(fk recursive)
		End if 
		
		$result:=ZIP Create archive($app_folder; $zip_archive; ZIP Without enclosing folder)
		If ($result.success)
			
			$result.archive:=$zip_archive
			$result.application:=$app_folder
			
		End if 
		
	Else 
		$result:={success: False; statusText: "executable doesn't exist !"}
	End if 
	
	
	