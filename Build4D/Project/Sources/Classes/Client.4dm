Class extends _core

property _target : Text


//MARK:-
Class constructor($customSettings : Object)
	
	var $currentAppInfo; $sourceAppInfo : Object
	var $fileCheck : Boolean
	
	Super("Client"; $customSettings)  //#2067
	
	This._target:=""
	
	If (This._validInstance)
		
		//#2068
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
	
	
	
	//MARK:-
	
Function get publishName : Text
	If (Value type(This.settings.publishName)=Is text)
		return This.settings.publishName
	Else 
		return This.buildName
	End if 
	
	
	//MARK:- identify if we build a mac or win client
	
Function is_mac_target : Boolean
	
	return Bool(This._target="mac")
	
	
	//MARK:- identify if we build a mac or win client
	
Function is_win_target : Boolean
	
	return Bool(This._target="win")
	
	
	
	
	
	//MARK:- Generates the "4Dlink" file
	
	
/*
	
Function _make4dLink() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the "4Dlink" file has been correctly created.
....................................................................................
	
*/
	
Function _make4dLink() : Boolean
	
	var $xml; $text; $server_path : Text
	var $4DLink : 4D.File
	
	If (This._structureFolder.exists)
		
	Else 
		This._structureFolder.create()
	End if 
	
	$xml:=DOM Create XML Ref("database_shortcut")
	
	$server_path:=((This.settings.IPAddress#Null) ? This.settings.IPAddress : "")+(":"+String(This.settings.portNumber))
	
	DOM SET XML ATTRIBUTE($xml; \
		"is_remote"; "true"; \
		"server_database_name"; This.settings.buildName; \
		"server_path"; $server_path)
	
	//#3829
	Case of 
			
		: (This.is_mac_target())  //#3940
			
		: (This.settings.shareLocalResourcesOnWindowsClient=Null)
			
		: (Value type(This.settings.shareLocalResourcesOnWindowsClient)#Is boolean)
			
		: (This.settings.shareLocalResourcesOnWindowsClient=False)
		Else 
			
			DOM SET XML ATTRIBUTE($xml; "remote_shared_resources"; "true")
	End case 
	
	//#2091
	Case of 
		: (This.settings.clientServerSystemFolderName=Null)
		: (Value type(This.settings.clientServerSystemFolderName)#Is text)
		: (Bool(This.settings.clientServerSystemFolderName=""))
			
		Else 
			
			DOM SET XML ATTRIBUTE($xml; "cache_folder_name"; This.settings.clientServerSystemFolderName)  //#2091 #4118
			
	End case 
	
	
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
	
	
	//MARK:- Sets the information to the client application.
	
/*
	
Function _setAppOptions() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the information has been correctly added.
....................................................................................
	
*/
	
Function _setAppOptions() : Boolean
	var $appInfo; $exeInfo : Object
	var $infoFile; $exeFile; $manifestFile : 4D.File
	var $identifier : Text
	var $subFolder : 4D.Folder
	var $infoPlistFile : 4D.File
	var $resourcesSubFolders : Collection
	var $fileContent : Text
	
	This._noError:=True
	
	$infoFile:=(This.is_mac_target()) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
	
	If ($infoFile.exists)
		
		$appInfo:=New object(\
			"com.4D.BuildApp.ReadOnlyApp"; "true")
		
		$appInfo.BuildName:=This.settings.buildName
		$appInfo.PublishName:=Value type(This.settings.publishName)=Is text ? This.settings.publishName : This.settings.buildName
		
		$appInfo.SDIRuntime:=((This.settings.useSDI#Null) && This.settings.useSDI) ? "1" : "0"
		
		$appInfo.BuildHardLink:=Value type(This.settings.hardLink)=Is text ? This.settings.hardLink : ""
		
		$appInfo["4D_SingleInstance"]:=Value type(This.settings.singleInstance)=Is boolean ? (This.settings.singleInstance ? "1" : "0") : "1"
		
		$appInfo.BuildRangeVersMin:=Value type(This.settings.rangeVersMin)=Is real ? String(This.settings.rangeVersMin) : "1"
		$appInfo.BuildRangeVersMax:=Value type(This.settings.rangeVersMax)=Is real ? String(This.settings.rangeVersMax) : "1"
		$appInfo.BuildCurrentVers:=Value type(This.settings.currentVers)=Is real ? String(This.settings.currentVers) : "1"
		$appInfo.RemoteSharedResources:="false"  //#3829
		
		If (This.settings.databaseToEmbedInClient#Null)  //#3763
			OB REMOVE($appInfo; "PublishName")
			
			$appInfo["com.4d.BuildApp.dataless"]:="true"
		End if 
		
		$appInfo["com.4D.BuildApp.ServerSelectionAllowed"]:=This.settings.serverSelectionAllowed ? "true" : "false"  // #2080
		
		If (Value type(This.settings.clientUserPreferencesFolderByPath)=Is boolean)  //#2088  #3939
			
			$appInfo["4D_MultipleClient"]:=This.settings.clientUserPreferencesFolderByPath ? "1" : "0"
			
		End if 
		
		If (This.settings.clientServerSystemFolderName#Null)  //#2087
			$appInfo.BuildCacheFolderNameClient:=This.settings.clientServerSystemFolderName
		Else 
			$appInfo.BuildCacheFolderNameClient:=""
		End if 
		
		If (This.is_mac_target())
			
			$appInfo.RemoteSharedResources:="false"  //#3829 #3940
			
			$appInfo.CFBundleName:=This.settings.buildName
			$appInfo.CFBundleDisplayName:=This.settings.buildName
			$appInfo.CFBundleExecutable:=This.settings.buildName
			$identifier:=((This.settings.versioning.companyName#Null) && (This.settings.versioning.companyName#"")) ? This.settings.versioning.companyName : "com.4d"
			$identifier+="."+This.settings.buildName
			$appInfo.CFBundleIdentifier:=$identifier
			
		Else 
			
			If (This.settings.shareLocalResourcesOnWindowsClient#Null)  // #4330
				
				$appInfo.RemoteSharedResources:=Bool(This.settings.shareLocalResourcesOnWindowsClient) ? "true" : "false"  //#3829 #3940 
				
			Else 
				
				$appInfo.RemoteSharedResources:="false"  //#3829 #3940
				
			End if 
			
			$exeInfo:=New object("ProductName"; This.settings.buildName)
			
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
	
	
	
	//MARK:- Add embedded database in client app
	
/*
	
Function _hasEmbeddedClient() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the embedded database has been correctly added.
....................................................................................
	
*/
	
Function _hasEmbeddedClient : Boolean  //#3917
	
	var $path : Object
	
	If (This.settings.databaseToEmbedInClient#Null)
		
		$path:=This._resolvePath(This.settings.databaseToEmbedInClient; This._currentProjectPackage)
		
		Case of 
			: (OB Instance of($path; 4D.File)=False)
			: ($path.exists=False)
			Else 
				
				var $folder : 4D.Folder
				var $file; $fileCopied : 4D.File
				
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
					
					$fileCopied:=$file.copyTo(This._structureFolder)
					
					If ($file.extension=".4DZ")
						$file:=$fileCopied.rename(This.settings.buildName+$file.extension)
					End if 
					
					
				End for each 
				
				return True
				
		End case 
		
	End if 
	return False
	
	
	
	//MARK:- Build the client application.
	
/*
	
Function Build() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the standalone has been correctly executed.
....................................................................................
	
*/
	
Function build() : Boolean
	
	var $success : Boolean
	
	$success:=This._validInstance
	$success:=($success) ? This._checkDestinationFolder() : False
	//$success:=($success) ? This._compileProject() : False  // util ?
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._renameExecutable() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._excludeModules() : False
	
	If (This._hasEmbeddedClient())
		
		
	Else 
		
		$success:=($success) ? This._make4dLink() : False
		
	End if 
	
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False
	
	
	If (Is macOS & This.is_mac_target())
		$success:=($success) ? This._sign() : False
	End if 
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Client application build successful."; \
			"severity"; Information message))
	End if 
	
	This._validInstance:=$success
	
	return $success
	
	//mark:- (utility) Zip the client application
	
/*
	
Function buildZip() -> $result : Object
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$result        object       out          $result.success: True if the zip has been correctly build.
                                         $result.status: status code from Zip create archive result.
                                         $result.statusText: status text from Zip create archive result.
                                         $result.archive: 4D.File instance to the zip archive.
                                         $result.application: 4D.File instance to the application to zip.
....................................................................................
	
*/
	
Function buildZip()->$result : Object
	
	var $app_folder : 4D.Folder
	var $zip_archive : 4D.File
	var $filename : Text
	
	$filename:=This.settings.buildName+(This.is_mac_target() ? "-client-mac.zip" : "-client-win.zip")
	$app_folder:=This.settings.destinationFolder
	
	If ($app_folder.exists)
		
		$zip_archive:=$app_folder.parent.file($filename)
		
		If ($zip_archive.exists)
			$zip_archive.delete()  //(fk recursive)
		End if 
		
		$result:=ZIP Create archive($app_folder; $zip_archive; ZIP Without enclosing folder)
		If ($result.success)
			
			$result.archive:=$zip_archive
			$result.application:=$app_folder
			
		End if 
	Else 
		$result:={success: False; statusText: "folder doesn't exist: "+$app_folder.path}
	End if 
	
	
	//mark:- Builds the client application archive.
	
	
/*
	
Function buildArchive() -> $result : Object
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$result        object       out          $result.success: True if the archive has been correctly build.
                                         $result.status: status code from Zip create archive result.
                                         $result.statusText: status text from Zip create archive result.
                                         $result.archive: 4D.File instance to the archive file.
                                         $result.application: 4D.File instance to the application to zip.
....................................................................................
	
*/
	
	
Function buildArchive()->$result : Object
	
	var $app_folder : 4D.Folder
	var $zip_archive : 4D.File
	var $filename : Text
	
	$filename:=This.is_mac_target() ? "update.mac.4darchive" : "update.win.4darchive"
	
	$app_folder:=This.settings.destinationFolder
	
	If ($app_folder.exists)
		
		$zip_archive:=$app_folder.parent.file($filename)
		
		If ($zip_archive.exists)
			$zip_archive.delete()  //(fk recursive)
		End if 
		
		$result:=ZIP Create archive($app_folder; $zip_archive; ZIP Without enclosing folder)
		If ($result.success)
			
			$result.archive:=$zip_archive
			$result.application:=$app_folder
			
		End if 
		
	Else 
		$result:={success: False; statusText: "folder doesn't exist: "+$app_folder.path}
	End if 
	
	If ($result.success)
		This._log(New object(\
			"function"; "buildArchive"; \
			"message"; "Client archive build successful."; \
			"severity"; Information message))
	Else 
		This._log(New object(\
			"function"; "buildArchive"; \
			"message"; "Unable to build Client Archive: "+$result.statusText; \
			"severity"; Error message))
	End if 
	
	
	