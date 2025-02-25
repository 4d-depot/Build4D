Class extends _core

//MARK:-
Class constructor($customSettings : Object)
	
	Super("Component"; $customSettings)
	
	If (This._validInstance)
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Components/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+".4dbase/")
		This._structureFolder:=This.settings.destinationFolder.folder("Contents")
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
	
Function _setAppOptions() : Boolean
	var $infoFile : 4D.File
	var $appInfo : Object:={}
	
	$infoFile:=(Is macOS) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
	
/*
	
	
*/
	
	
	
	//https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102364
	
	$appInfo.CFBundleName:=This.settings.buildName
	$appInfo.CFBundleDisplayName:=This.settings.buildName
	
	$appInfo.CFBundleVersion:=This.settings.versioning.version
	$appInfo.CFBundleShortVersionString:=This.settings.versioning.version
	
	$appInfo.NSHumanReadableCopyright:=This.settings.versioning.copyright
	
	$infoFile.setAppInfo($appInfo)
	
	
	
	return $infoFile.exists
	
	
	
	//MARK:-
Function build()->$success : Boolean
	
	var $script : 4D.File
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	$success:=($success) ? This._compileProject() : False
	$success:=($success) ? This._createStructure() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._manageSettingsPaths() : False
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