Class extends _core

property _target : Text


//MARK:-
Class constructor($customSettings : Object)
	
	var \
		$currentAppInfo; \
		$sourceAppInfo : Object
	
	var \
		$librariesFolder : 4D.Folder
	
	var \
		$fileCheck; \
		$is_conform : Boolean
	
	Super("Server"; $customSettings)
	
	
	If (This._validInstance)
		
		If (Value type(This.settings.publishName)#Is text)
			This.settings.publishName:=This.settings.buildName
		End if 
		
		//This.settings.buildName+=Is macOS ? " Server" : "Server" //nop
		
		If (This._isDefaultDestinationFolder)
			This.settings.destinationFolder:=This.settings.destinationFolder.folder("Server/")
		End if 
		This.settings.destinationFolder:=This.settings.destinationFolder.folder(This.settings.buildName+Choose(Is macOS; ".app"; "")+"/")
		This._structureFolder:=This.settings.destinationFolder.folder(Choose(Is macOS; "Contents/"; "")+"Server Database/")
		
		//:#2028
		If (This.settings.startElevated=Null)
			This.settings.startElevated:=False
		End if 
		
		//:#2031
		If (This.settings.obfuscated=Null)
			This.settings.obfuscated:=False
		End if 
		
		//:#2033
		If (This.settings.packedProject=Null)
			This.settings.packedProject:=True
		End if 
		
		//Checking license
		If ((This.settings.license=Null) || (Not(OB Instance of(This.settings.license; 4D.File))))
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
		
		
		//:- requirement #2061
		If (This._validInstance)
			
			If (This.is_win_target())
				
				If (OB Instance of(This.settings.macCompiledProject; 4D.Folder))
					
					
					$librariesFolder:=This.settings.macCompiledProject.folder("Libraries")
					
					Case of 
							
						: (This.settings.macCompiledProject.exists=False)
							This._log(New object(\
								"function"; "Class constuctor"; \
								"message"; "macCompiledProject don't exist."; \
								"severity"; Error message))
							
							
						: (This.settings.macCompiledProject.file(This.settings.buildName+".4DZ").exists=False)
							This._log(New object(\
								"function"; "Class constuctor"; \
								"message"; "macCompiledProject 4DZ not found."; \
								"severity"; Error message))
							
							
						: ($librariesFolder.exists=False)
							This._log(New object(\
								"function"; "Class constuctor"; \
								"message"; "macCompiledProject Libraries folder don't exist."; \
								"severity"; Error message))
							
						: ($librariesFolder.file("lib4d-arm64.dylib").exists=False)
							This._log(New object(\
								"function"; "Class constuctor"; \
								"message"; "macCompiledProject lib4d-arm64.dylib in Libraries folder not found."; \
								"severity"; Error message))
							
						Else 
							$is_conform:=True
					End case 
					
					This._validInstance:=$is_conform
					
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
	
	return (Is macOS & (This.settings.sourceAppFolder.file("Contents/MacOS/4D Server").exists))
	
	
	//MARK:- identify if we build a mac or win client
	
Function is_win_target : Boolean
	
	return (This.settings.sourceAppFolder.file("4D Server.exe").exists)
	
	
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
	var \
		$renamedExecutable; \
		$renamedResources : 4D.File
	
	If (This.is_mac_target())
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
	
	var $infoFile : 4D.File
	var $appInfo : Object
	
	If (Super._setAppOptions())  //#2034 #2140
		
		$infoFile:=(This.is_mac_target()) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
		
		If ($infoFile.exists)
			
			$appInfo:=$infoFile.getAppInfo()
			
			$appInfo.BuildName:=This.settings.buildName
			
			$appInfo.PublishName:=Value type(This.settings.publishName)=Is text ? This.settings.publishName : This.settings.buildName  //#2055 #2092
			
			$appInfo["4D_SingleInstance"]:="1"  //Value type(This.settings.singleInstance)=Is boolean ? string(Num(This.settings.singleInstance)) : "1"//#2054 #2053
			
			$appInfo["com.4d.dataCollection"]:=Value type(This.settings.serverDataCollection)=Is boolean ? This.settings.serverDataCollection : True  //#2052
			$appInfo["com.4d.dataCollection"]:=$appInfo["com.4d.dataCollection"] ? "true" : "false"  //#2051
			
			$appInfo["com.4d.ServerCacheFolderName"]:=Value type(This.settings.serverStructureFolderName)=Is text ? This.settings.serverStructureFolderName : ""  //#2060
			
			$appInfo["com.4D.HideDataExplorerMenuItem"]:=Value type(This.settings.hideDataExplorerMenuItem)=Is boolean ? This.settings.hideDataExplorerMenuItem : False  //#2045
			$appInfo["com.4D.HideDataExplorerMenuItem"]:=$appInfo["com.4D.HideDataExplorerMenuItem"] ? "true" : "false"  //#2044
			
			
			$appInfo["com.4D.HideRuntimeExplorerMenuItem"]:=Value type(This.settings.hideRuntimeExplorerMenuItem)=Is boolean ? This.settings.hideRuntimeExplorerMenuItem : False  //#2047
			$appInfo["com.4D.HideRuntimeExplorerMenuItem"]:=$appInfo["com.4D.HideRuntimeExplorerMenuItem"] ? "true" : "false"  //#2046
			
			
			$appInfo["com.4D.HideAdministrationWindowMenuItem"]:=Value type(This.settings.hideAdministrationWindowMenuItem)=Is boolean ? This.settings.hideAdministrationWindowMenuItem : False  //#2050
			$appInfo["com.4D.HideAdministrationWindowMenuItem"]:=$appInfo["com.4D.HideAdministrationWindowMenuItem"] ? "true" : "false"  //#2049
			
			//only on json file et 4D.link
			//$appInfo.BuildIPAddress:=Value type(This.settings.IPAddress)=Is text ? This.settings.IPAddress : ""
			//$appInfo.BuildIPPort:=Value type(This.settings.portNumber)=Is real ? String(This.settings.portNumber) : "19813"
			
			$appInfo.BuildHardLink:=Value type(This.settings.hardLink)=Is text ? This.settings.hardLink : ""  //#2059
			
			$appInfo.BuildRangeVersMin:=Value type(This.settings.rangeVersMin)=Is real ? String(This.settings.rangeVersMin) : "1"  //#2056 #2165
			$appInfo.BuildRangeVersMax:=Value type(This.settings.rangeVersMax)=Is real ? String(This.settings.rangeVersMax) : "1"  //#2057 #2166
			$appInfo.BuildCurrentVers:=Value type(This.settings.currentVers)=Is real ? String(This.settings.currentVers) : "1"  //#2058 #2167
			
			
			// clefs specifiques si target windows
			
			// macCompiledProject (folder contain silicon code)
			
			$infoFile.setAppInfo($appInfo)
			
			
			return True
		Else 
			
		End if 
		
	End if 
	
	
	return False
	
	
	
	//MARK:- Add embedded database in client app
	
/*
	
Function _hasLicenses() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if licenses are associated in the settings.
....................................................................................
	
*/
	
Function _hasLicenses : Boolean
	
	If (OB Instance of(This.settings.license; 4D.File) && OB Instance of(This.settings.xmlKeyLicense; 4D.File))
		
		return This.settings.license.exists && This.settings.xmlKeyLicense.exists
		
	End if 
	
	return False
	
	
	//mark:- (utility) Zip the client server
	
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
	
	$filename:=This.settings.buildName+(This.is_mac_target() ? "-server-mac.zip" : "-server-win.zip")
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
	
	
	
	//MARK:- Build the server application.
	
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
	$success:=($success) ? This._compileProject() : False
	$success:=($success) ? This._createStructure() : False
	$success:=($success) ? This._copySourceApp() : False
	$success:=($success) ? This._renameExecutable() : False
	$success:=($success) ? This._setAppOptions() : False
	$success:=($success) ? This._excludeModules() : False  //#2029
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False  //#2025
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False  //#2026
	$success:=($success) ? This._create4DZ() : False  //#2030 #2032
	
	
	If ($success)
		
		var $Upgrade4DClient; $libraries_folder : 4D.Folder
		var $4DZ; $infosFile : 4D.File
		var $path : Text
		var $hasClients : Boolean
		var $infos : Object
		//var $portNumber : Integer
		
		$path:=This.settings.destinationFolder.path
		
		$path+=(Is macOS) ? "Contents/Upgrade4DClient/" : "Upgrade4DClient/"
		
		$Upgrade4DClient:=Folder($path; fk posix path)
		
		If ($Upgrade4DClient.exists)
			$Upgrade4DClient.delete(fk recursive)
		End if 
		
		$Upgrade4DClient.create()
		
		If (OB Instance of(This.settings.macOSClientArchive; 4D.File))  //#2062
			
			This.settings.macOSClientArchive.moveTo($Upgrade4DClient)
			
			$hasClients:=True
			
		End if 
		
		If (OB Instance of(This.settings.windowsClientArchive; 4D.File))  //#2063
			
			This.settings.windowsClientArchive.moveTo($Upgrade4DClient)
			
			$hasClients:=True
			
		End if 
		
		
		If ($hasClients)  //#2064
			
			$infos:={}
			
			$infos.BuildName:=This.settings.buildName
			$infos.BuildIPAddress:=Value type(This.settings.IPAddress)=Is text ? This.settings.IPAddress : ""
			$infos.BuildIPPort:=Value type(This.settings.portNumber)=Is real ? String(This.settings.portNumber) : "19813"
			$infos.BuildHardLink:=Value type(This.settings.hardLink)=Is text ? This.settings.hardLink : ""
			//$infos.BuildCreator:=Char(0)*4
			$infos.BuildRangeVersMin:=Value type(This.settings.rangeVersMin)=Is real ? String(This.settings.rangeVersMin) : "1"
			$infos.BuildRangeVersMax:=Value type(This.settings.rangeVersMax)=Is real ? String(This.settings.rangeVersMax) : "1"
			$infos.BuildCurrentVers:=Value type(This.settings.currentVers)=Is real ? String(This.settings.currentVers) : "1"
			$infos.PublishName:=Value type(This.settings.publishName)=Is text ? This.settings.publishName : This.settings.buildName
			
			If (This.is_mac_target())
				$infos.ServerPlatform:="mac"
			Else 
				$infos.ServerPlatform:="win"
			End if 
			
/*
			
$infos.Icon": "DarkMode.icns",
$infos.IconFolder": "DarkMode",
$infos.OtherIcon": "DarkMode.icns",
$infos.OtherIconFolder": "DarkMode",
//$infos["com.4D.HideDataExplorerMenuItem"]:=Value type(This.settings.hideDataExplorerMenuItem)=Is boolean ? This.settings.hideDataExplorerMenuItem : False
//$infos["com.4D.HideRuntimeExplorerMenuItem"]:=Value type(This.settings.hideDataExplorerMenuItem)=Is boolean ? This.settings.hideDataExplorerMenuItem : False
			
*/
			
			
			Case of 
					
				: (This.settings.signApplication=Null)
					
				: (Bool(This.settings.signApplication.macSignature))
					
					$infos.MacCertificate:=This.settings.signApplication.macCertificate
					$infos.MacSignature:=True
					
				Else 
					
					
			End case 
			
			If (OB Instance of(This.settings.macOSClientArchive; 4D.File))
				$infos.macUpdate:="update.mac.4darchive"
			End if 
			
			If (OB Instance of(This.settings.windowsClientArchive; 4D.File))
				$infos.winUpdate:="update.win.4darchive"
			End if 
			
			$path:=$Upgrade4DClient.path+"info.json"
			
			$infosFile:=File($path; fk posix path)
			
			$infosFile.create()
			$infosFile.setText(JSON Stringify($infos; *))
			
		Else 
			
			$Upgrade4DClient.delete(fk recursive)
			
		End if 
		
		//#2061
		If (Is Windows)
			
			If (This.settings.macCompiledProject#Null)
				
				If (OB Instance of(This.settings.macCompiledProject; 4D.Folder))
					
					$4DZ:=This._structureFolder.file(This.settings.buildName+".4DZ")
					
					If ($4DZ.exists)
						$4DZ.delete()
					End if 
					
					$4DZ:=This.settings.macCompiledProject.file(This.settings.buildName+".4DZ")
					
					$4DZ.copyTo(This._structureFolder; fk overwrite)
					
					//----
					
					$libraries_folder:=This._structureFolder.folder("Libraries")
					
					If ($libraries_folder.exists)
						$libraries_folder.delete(fk recursive)
					End if 
					$libraries_folder:=This.settings.macCompiledProject.folder("Libraries"; fk overwrite)
					
					$libraries_folder.copyTo(This._structureFolder)
					
				End if 
				
			End if 
			
		End if 
		
		If (This._hasLicenses())
			
			$success:=($success) ? This._generateLicense() : False
			
		End if 
		
		If (Is macOS)
			$success:=($success) ? This._sign() : False
		End if 
		
	End if 
	
	
	If ($success)
		This._log(New object(\
			"function"; "Build"; \
			"message"; "Server application build successful."; \
			"messageSeverity"; Information message))
	End if 
	
	return $success
	