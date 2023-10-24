Class extends _core



//MARK:-
Class constructor($customSettings : Object)
	
	var $currentAppInfo; $sourceAppInfo : Object
	var $fileCheck : Boolean
	
	Super("Client"; $customSettings)
	
	This._target:=""  // 
	
	If (This._validInstance)
		
		Case of 
				
			: (Is macOS & (This.settings.sourceAppFolder.file("Contents/MacOS/4D Volume Desktop").exists))
				This._target:="mac"
				
			: (This.settings.sourceAppFolder.file("4D Volume Desktop.4DE").exists)
				This._target:="win"
				
			Else 
				This._validInstance:=False
		End case 
		
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("ClientApp/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(This.is_mac_target(); ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(This.is_mac_target(); "Contents/"; "")+"Database/")
		
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
				$fileCheck:=This._target#""  //(Is macOS) ? This.settings.sourceAppFolder.file("Contents/MacOS/4D Volume Desktop").exists : This.settings.sourceAppFolder.file("4D Volume Desktop.4DE").exists
				If (Not($fileCheck))
					This._validInstance:=False
					This._log(New object(\
						"function"; "Source application folder checking"; \
						"message"; "Source application is not a 4D Volume Desktop"; \
						"severity"; Error message; \
						"sourceAppFolder"; This.settings.sourceAppFolder.path))
				Else   // Versions checking
					$sourceAppInfo:=(This.is_mac_target()) ? This.settings.sourceAppFolder.file("Contents/Info.plist").getAppInfo() : This.settings.sourceAppFolder.file("Resources/Info.plist").getAppInfo()
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
	
	
	
	
Function is_mac_target : Boolean
	
	return Bool(This._target="mac")
	
	
Function is_win_target : Boolean
	
	return Bool(This._target="win")
	
	
	
	
	
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
		"server_path"; ":"+String(This.settings.portNumber))
	
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
	If (This.is_mac_target())
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
	
	
	//Function _hasEmbedded : Boolean
	
	
Function _show() : cs.Client
	
	SHOW ON DISK(This.settings.destinationFolder.platformPath)
	
	return This
	
	//MARK:-
Function _setAppOptions() : Boolean
	var $appInfo; $exeInfo : Object
	var $infoFile; $exeFile; $manifestFile : 4D.File
	var $identifier : Text
	
	This._noError:=True
	
	$infoFile:=(This.is_mac_target()) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
	
	If ($infoFile.exists)
		$appInfo:=New object(\
			"com.4D.BuildApp.ReadOnlyApp"; "true"; \
			"DataFileConversionMode"; "0"\
			)
		$appInfo.SDIRuntime:=((This.settings.useSDI#Null) && This.settings.useSDI) ? "1" : "0"
		
		If (This.is_mac_target())
			$appInfo.CFBundleName:=This.settings.buildName
			$appInfo.CFBundleDisplayName:=This.settings.buildName
			$appInfo.CFBundleExecutable:=This.settings.buildName
			$identifier:=((This.settings.versioning.companyName#Null) && (This.settings.versioning.companyName#"")) ? This.settings.versioning.companyName : "com.4d"
			$identifier+="."+This.settings.buildName
			$appInfo.CFBundleIdentifier:=$identifier
			
			$appInfo["com.4d.xxx.ServerSelectionAllowed"]:=This.settings.serverSelectionAllowed ? "true" : "false"
			
			
			If (This.settings.clientUserPreferencesFolderByPath#Null)
				$appInfo["4D_MultipleClient"]:=This.settings.clientUserPreferencesFolderByPath ? "true" : "false"
			End if 
			
			
		Else 
			$exeInfo:=New object("ProductName"; This.settings.buildName)
			
			$exeInfo["com.4d.xxx.ServerSelectionAllowed"]:=This.settings.serverSelectionAllowed ? "true" : "false"
			
			If (This.settings.clientUserPreferencesFolderByPath#Null)
				$exeInfo["4D_MultipleClient"]:=This.settings.clientUserPreferencesFolderByPath ? "true" : "false"
			End if 
			
		End if 
		
		If (This.settings.iconPath#Null)  // Set icon
			If (This.settings.iconPath.exists)
				If (This.is_mac_target())
					$appInfo.CFBundleIconFile:=This.settings.iconPath.fullName
					This.settings.iconPath.copyTo(This.settings.destinationFolder.folder("Contents/Resources/"))
					This.settings.iconPath.copyTo(This.settings.destinationFolder.folder("Contents/Resources/Images/WindowIcons/"); "windowIcon_205.icns"; fk overwrite)
				Else   // Windows
					$exeInfo.WinIcon:=This.settings.iconPath
				End if 
			Else 
				This._log(New object(\
					"function"; "Icon integration"; \
					"message"; "Icon file doesn't exist: "+This.settings.iconPath.path; \
					"severity"; Error message))
			End if 
		End if 
		
		If (This.settings.versioning#Null)  // Set version info
			If (This.is_mac_target())
				If (This.settings.versioning.version#Null)
					$appInfo.CFBundleVersion:=This.settings.versioning.version
					$appInfo.CFBundleShortVersionString:=This.settings.versioning.version
				End if 
				If (This.settings.versioning.copyright#Null)
					$appInfo.NSHumanReadableCopyright:=This.settings.versioning.copyright
					// Force macOS to get copyright from info.plist file instead of localized strings file
					var $subFolder : 4D.Folder
					var $infoPlistFile : 4D.File
					var $resourcesSubFolders : Collection
					var $fileContent : Text
					$resourcesSubFolders:=This.settings.destinationFolder.folder("Contents/Resources/").folders()
					For each ($subFolder; $resourcesSubFolders)
						If ($subFolder.extension=".lproj")
							$infoPlistFile:=$subFolder.file("InfoPlist.strings")
							If ($infoPlistFile.exists)
								$fileContent:=$infoPlistFile.getText()
								$fileContent:=Replace string($fileContent; "CFBundleGetInfoString ="; "CF4DBundleGetInfoString ="; 1)
								$fileContent:=Replace string($fileContent; "NSHumanReadableCopyright ="; "NS4DHumanReadableCopyright ="; 1)
								$infoPlistFile.setText($fileContent)
							End if 
						End if 
					End for each 
				End if 
				
			Else   // Windows
				If (This.settings.versioning.version#Null)
					$exeInfo.ProductVersion:=This.settings.versioning.version
					$exeInfo.FileVersion:=This.settings.versioning.version
				End if 
				If (This.settings.versioning.copyright#Null)
					$exeInfo.LegalCopyright:=This.settings.versioning.copyright
				End if 
				If (This.settings.versioning.companyName#Null)
					$exeInfo.CompanyName:=This.settings.versioning.companyName
				End if 
				If (This.settings.versioning.fileDescription#Null)
					$exeInfo.FileDescription:=This.settings.versioning.fileDescription
				End if 
				If (This.settings.versioning.internalName#Null)
					$exeInfo.InternalName:=This.settings.versioning.internalName
				End if 
			End if 
		End if 
		
		$infoFile.setAppInfo($appInfo)
		
		If ($exeInfo#Null)
			$exeFile:=This.settings.destinationFolder.file(This.settings.buildName+".exe")
			If ($exeFile.exists)
				$exeInfo.OriginalFilename:=$exeFile.fullName
				$exeFile.setAppInfo($exeInfo)
			Else 
				This._log(New object(\
					"function"; "Setting app options"; \
					"message"; "Exe file doesn't exist: "+$exeFile.path; \
					"severity"; Warning message))
				return False
			End if 
		End if 
		
	Else 
		This._log(New object(\
			"function"; "Setting app options"; \
			"message"; "Info.plist file doesn't exist: "+$infoFile.path; \
			"severity"; Warning message))
		return False
	End if 
	
	If (This.is_win_target())  // Updater elevation rights
		$manifestFile:=((This.settings.startElevated#Null) && (This.settings.startElevated))\
			 ? This.settings.destinationFolder.file("Resources/Updater/elevated.manifest")\
			 : This.settings.destinationFolder.file("Resources/Updater/normal.manifest")
		$manifestFile.copyTo(This.settings.destinationFolder.folder("Resources/Updater/"); "Updater.exe.manifest"; fk overwrite)
		This.settings.destinationFolder.file("Resources/Updater/elevated.manifest").delete()
		This.settings.destinationFolder.file("Resources/Updater/normal.manifest").delete()
	End if 
	
	return This._noError
	
	
	
	//MARK:-
Function _excludeModules() : Boolean
	var $excludedModule; $path; $basePath : Text
	var $optionalModulesFile : 4D.File
	var $optionalModules : Object
	var $paths; $modules : Collection
	
	This._noError:=True
	
	If ((This.settings.excludeModules#Null) && (This.settings.excludeModules.length>0))
		$optionalModulesFile:=(Is macOS) ? Folder(Application file; fk platform path).file("Contents/Resources/BuildappOptionalModules.json") : File(Application file; fk platform path).parent.file("Resources/BuildappOptionalModules.json")
		If ($optionalModulesFile.exists)
			$paths:=New collection
			$basePath:=(This.is_mac_target()) ? This.settings.destinationFolder.path+"Contents/" : This.settings.destinationFolder.path
			$optionalModules:=JSON Parse($optionalModulesFile.getText())
			For each ($excludedModule; This.settings.excludeModules)
				$modules:=$optionalModules.modules.query("name = :1"; $excludedModule)
				If ($modules.length>0)
					If (($modules[0].foldersArray#Null) && ($modules[0].foldersArray.length>0))
						For each ($path; $modules[0].foldersArray)
							$paths.push($basePath+$path+"/")
						End for each 
					End if 
					If (($modules[0].filesArray#Null) && ($modules[0].filesArray.length>0))
						For each ($path; $modules[0].filesArray)
							$paths.push($basePath+$path)
						End for each 
					End if 
				End if 
			End for each 
			This._deletePaths($paths)
		Else 
			This._log(New object(\
				"function"; "Modules exclusion"; \
				"message"; "Unable to find the modules file: "+$optionalModulesFile.path; \
				"severity"; Error message))
			return False
		End if 
	End if 
	
	return This._noError
	
	
	
Function _hasEmbeddedClient : Boolean
	
	var $path : Object
	
	If (This.settings.databaseToEmbedInClient#Null)
		
		$path:=This._resolvePath(This.settings.databaseToEmbedInClient; This._currentProjectPackage)
		
		Case of 
			: (OB Instance of($path; 4D.File)=False)
			: ($path.exists=False)
			Else 
				
				var $folder : 4D.Folder
				var $file : 4D.File
				// may be test if the path is a 4DZ file :...
				
				If (This._structureFolder.exists)
					
				Else 
					This._structureFolder.create()
				End if 
				
				This.settings.databaseToEmbedInClient:=$path
				
				For each ($folder; $path.parent.folders())
					
					$folder.copyTo(This._structureFolder)
					
				End for each 
				
				For each ($file; $path.parent.files())
					
					$file.copyTo(This._structureFolder)
					
				End for each 
				
				return True
				
		End case 
		
	End if 
	return False
	
	
	
	//MARK:-
	
Function build() : Boolean
	
	var $success : Boolean
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._compileProject() : False  // util ?
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._renameExecutable() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._excludeModules() : False
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	
	//TODO: 
	
	
	If (This._hasEmbeddedClient())
		
		
	Else 
		
		$success:=($success) ? This._make4dLink() : False
		
	End if 
	
	
	
	If (Is macOS & This.is_mac_target())
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Client application build successful."; \
			"messageSeverity"; Information message))
	End if 
	
	This._validInstance:=$success
	
	return $success
	
	
Function buildArchive()->$result : Object
	
	var $app_folder : 4D.Folder
	var $zip_archive : 4D.File
	var $filename : Text
	
	$app_folder:=This.settings.destinationFolder
	
	If ($app_folder.exists)
		
		$filename:=This.is_mac_target() ? "update.mac.4darchive" : "update.win.4darchive"
		
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
	
	
	