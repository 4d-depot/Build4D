Class extends _core




//MARK:-
Class constructor($customSettings : Object)
	
	var \
		$currentAppInfo; \
		$sourceAppInfo : Object
	
	var \
		$fileCheck : Boolean
	
	Super("Server"; $customSettings)
	
	
	If (This._validInstance)
		
		This.settings.buildName+=Is macOS ? " Server" : "Server"
		
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Server/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(Is macOS; ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(Is macOS; "Contents/"; "")+"Server Database/")
		
		
		//Checking license
		If ((This.settings.license=Null) || (Not(OB Instance of(This.settings.license; 4D.File))))
			//This._validInstance:=False
			This._log(New object(\
				"function"; "License file checking"; \
				"message"; "License file is not defined"; \
				"severity"; Information message))
		Else 
			If (Not(This.settings.license.exists))
				//This._validInstance:=False
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
				$fileCheck:=(Is macOS) ? This.settings.sourceAppFolder.file("Contents/MacOS/4D Server").exists : This.settings.sourceAppFolder.file("4D Server.exe").exists
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
Function _renameExecutable() : Boolean
	var \
		$renamedExecutable; \
		$renamedResources : 4D.File
	
	If (Is macOS)
		$renamedExecutable:=This.settings.destinationFolder.file("Contents/MacOS/4D Server").rename(This.settings.buildName)
		$renamedResources:=This.settings.destinationFolder.file("Contents/Resources/4D Server.rsrc").rename(This.settings.buildName+".rsrc")
	Else 
		$renamedExecutable:=This.settings.destinationFolder.file("4D Server.exe").rename(This.settings.buildName+".exe")
		$renamedResources:=This.settings.destinationFolder.file("Resources/4D Server.rsr").rename(This.settings.buildName+".rsr")
	End if 
	
	If ($renamedExecutable.name#This.settings.buildName)
		This._log(New object(\
			"function"; "Rename executable"; \
			"message"; "Unable to rename the app: '"+This.settings.buildName+"'"; \
			"severity"; Error message))
		return False
	End if 
	
	If ($renamedResources.name#This.settings.buildName)
		This._log(New object(\
			"function"; "Rename resources file"; \
			"message"; "Unable to rename the 4D Server.rsr : '"+This.settings.buildName+"'"; \
			"severity"; Error message))
		return False
	End if 
	
	return True
	
	
	
Function _setAppOptions() : Boolean
	
	var $infoFile : 4D.File
	var $appInfo : Object
	
	If (Super._setAppOptions())
		
		$infoFile:=(Is macOS) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
		
		If ($infoFile.exists)
			
			$appInfo:=$infoFile.getAppInfo()
			
			$appInfo.BuildName:=This.settings.buildName
			
			$appInfo.PublishName:=Value type(This.settings.publishName)=Is text ? This.settings.publishName : This.settings.buildName
			
			$appInfo["4D_SingleInstance"]:=Value type(This.settings.singleInstance)=Is boolean ? Num(This.settings.singleInstance) : 1
			
			$appInfo["com.4d.dataCollection"]:=Value type(This.settings.serverDataCollection)=Is boolean ? This.settings.serverDataCollection : True
			$appInfo["com.4d.dataCollection"]:=$appInfo["com.4d.dataCollection"] ? "true" : "false"
			
			$appInfo["com.4d.ServerCacheFolderName"]:=Value type(This.settings.serverStructureFolderName)=Is text ? This.settings.serverStructureFolderName : ""
			
			$appInfo["com.4D.HideDataExplorerMenuItem"]:=Value type(This.settings.hideDataExplorerMenuItem)=Is boolean ? This.settings.hideDataExplorerMenuItem : False
			$appInfo["com.4D.HideDataExplorerMenuItem"]:=$appInfo["com.4D.HideDataExplorerMenuItem"] ? "true" : "false"
			
			
			$appInfo["com.4D.HideRuntimeExplorerMenuItem"]:=Value type(This.settings.hideRuntimeExplorerMenuItem)=Is boolean ? This.settings.hideRuntimeExplorerMenuItem : False
			$appInfo["com.4D.HideRuntimeExplorerMenuItem"]:=$appInfo["com.4D.HideRuntimeExplorerMenuItem"] ? "true" : "false"
			
			
			
			$appInfo["com.4D.HideAdministrationWindowMenuItem"]:=Value type(This.settings.hideAdministrationWindowMenuItem)=Is boolean ? This.settings.hideAdministrationWindowMenuItem : False
			$appInfo["com.4D.HideAdministrationWindowMenuItem"]:=$appInfo["com.4D.HideAdministrationWindowMenuItem"] ? "true" : "false"
			
			$appInfo.BuildHardLink:=Value type(This.settings.hardLink)=Is text ? This.settings.hardLink : ""
			
			$appInfo.BuildRangeVersMin:=Value type(This.settings.rangeVersMin)=Is real ? This.settings.rangeVersMin : 1
			$appInfo.BuildRangeVersMax:=Value type(This.settings.rangeVersMax)=Is real ? This.settings.rangeVersMax : 1
			$appInfo.BuildCurrentVers:=Value type(This.settings.currentVers)=Is real ? This.settings.currentVers : 1
			
			// clefs specifiques si target windows
			
			// macCompiledProject (folder contain silicon code)
			
			$infoFile.setAppInfo($appInfo)
			
			
			return True
		Else 
			
		End if 
		
	End if 
	
	
	return False
	
	
	
Function _hasLicenses : Boolean
	
	If (OB Instance of(This.settings.license; 4D.File) && OB Instance of(This.settings.xmlKeyLicense; 4D.File))
		
		return This.settings.license.exists && This.settings.xmlKeyLicense.exists
		
	End if 
	
	return False
	
	
	
	
	
	//MARK:-
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
	
	
	If (OB Instance of(This.settings.macOSClientArchive; 4D.File))
		var $Upgrade4DClient : 4D.Folder
		var $path : Text
		
		$path:=This.settings.destinationFolder.path
		
		//todo: a voir sur windows le chemin
		
		$path+=(Is macOS) ? "Contents/Upgrade4DClient/" : ""
		
		$Upgrade4DClient:=Folder($path; fk posix path)
		
		If ($Upgrade4DClient.exists)
			$Upgrade4DClient.delete(fk recursive)
		End if 
		
		$Upgrade4DClient.create()
		
		This.settings.macOSClientArchive.moveTo($Upgrade4DClient)
		
		
	End if 
	
	
	If (This._hasLicenses())
		
		$success:=($success) ? This._generateLicense() : False
		
	End if 
	
	If (Is macOS)
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Server application build successful."; \
			"messageSeverity"; Information message))
	End if 
	