property _validInstance; _isCurrentProject; _isDefaultDestinationFolder; _noError : Boolean
property _projectFile : 4D.File
property _projectPackage; _structureFolder : 4D.Folder
property logs : Collection
property settings : Object

Class constructor($target : Text; $customSettings : Object)
	ON ERR CALL("onError"; ek global)
	
	var $settings : Object
	
	This.logs:=New collection
	This.settings:=New object()
	This.settings.includePaths:=New collection
	This.settings.deletePaths:=New collection
	
	If (File("/RESOURCES/"+$target+".json").exists)
		This._overrideSettings(JSON Parse(File("/RESOURCES/"+$target+".json").getText()))  // Loads target default settings
	End if 
	This._isDefaultDestinationFolder:=False
	
	$settings:=($customSettings#Null) ? $customSettings : New object()
	
	This._validInstance:=True
	This._isCurrentProject:=True
	This._projectFile:=File(Structure file(*); fk platform path)
	If (($settings#Null) && ($settings.projectFile#Null) && ($settings.projectFile#""))
		This._isCurrentProject:=False
		This._projectFile:=This._resolvePath($settings.projectFile; Folder("/PACKAGE/"; *))
		If (Not(This._projectFile.exists))
			This._validInstance:=False
			This._log(New object(\
				"function"; "Class constuctor"; \
				"message"; "Project file doesn't exist, instanciated object is unusable."; \
				"severity"; Error message))
		End if 
	End if 
	
	This._projectPackage:=This._projectFile.parent.parent
	
	If (This._validInstance)
		This._overrideSettings($settings)
		If ((This.settings.buildName=Null) || (This.settings.buildName=""))
			This.settings.buildName:=This._projectFile.name
			This._log(New object(\
				"function"; "Settings checking"; \
				"message"; "Build name automatically defined."; \
				"severity"; Information message))
		End if 
		If (This.settings.destinationFolder=Null)
			This.settings.destinationFolder:=This._projectPackage.parent.folder(This._projectFile.name+"_Build/")
			This._isDefaultDestinationFolder:=True
			This._log(New object(\
				"function"; "Settings checking"; \
				"message"; "Destination folder automatically defined."; \
				"severity"; Information message))
		End if 
		This._log(New object(\
			"function"; "Class constuctor"; \
			"message"; "Class init successful."; \
			"severity"; Information message))
	End if 
	
	//MARK:-
Function _overrideSettings($settings : Object)
	
	var $entries : Collection
	var $entry; $currentAppInfo; $sourceAppInfo : Object
	
	$entries:=OB Entries($settings)
	For each ($entry; $entries)
		Case of 
			: ($entry.key="destinationFolder")
				This.settings.destinationFolder:=This._resolvePath($settings.destinationFolder; This._projectPackage)
				If (Not(OB Instance of(This.settings.destinationFolder; 4D.Folder)))
					This._validInstance:=False
				Else 
					This._validInstance:=This._checkDestinationFolder()
				End if 
				
			: ($entry.key="includePaths")
				This.settings.includePaths:=This.settings.includePaths.concat($settings.includePaths)
				
			: ($entry.key="iconPath")
				This.settings.iconPath:=This._resolvePath($settings.iconPath; This._projectPackage)
				
			: ($entry.key="license")
				This.settings.license:=This._resolvePath($settings.license; Null)
				
			: ($entry.key="sourceAppFolder")
				$settings.sourceAppFolder:=($settings.sourceAppFolder="@/") ? $settings.sourceAppFolder : $settings.sourceAppFolder+"/"
				This.settings.sourceAppFolder:=This._resolvePath($settings.sourceAppFolder; Null)
				If ((This.settings.sourceAppFolder=Null) || (Not(OB Instance of(This.settings.sourceAppFolder; 4D.Folder)) || (Not(This.settings.sourceAppFolder.exists))))
					This._validInstance:=False
					This._log(New object(\
						"function"; "Source application folder checking"; \
						"message"; "Source application folder doesn't exist"; \
						"severity"; Error message); \
						"sourceAppFolder"; $settings.sourceAppFolder)
					
				Else   // Versions checking
					$sourceAppInfo:=(Is macOS) ? This.settings.sourceAppFolder.file("Contents/Info.plist").getAppInfo() : This.settings.sourceAppFolder.file("Resources/Info.plist").getAppInfo()
					$currentAppInfo:=(Is macOS) ? Folder(Application file; fk platform path).file("Contents/Info.plist").getAppInfo() : File(Application file; fk platform path).parent.file("Resources/Info.plist").getAppInfo()
					If (($sourceAppInfo.CFBundleVersion=Null) || ($currentAppInfo.CFBundleVersion=Null) || ($sourceAppInfo.CFBundleVersion#$currentAppInfo.CFBundleVersion))
						This._validInstance:=False
						This._log(New object(\
							"function"; "Source application version checking"; \
							"message"; "Source application version doesn't match to current application version"; \
							"severity"; Error message); \
							"sourceAppFolder"; $settings.sourceAppFolder)
					End if 
				End if 
				
			Else 
				This.settings[$entry.key]:=$entry.value
		End case 
	End for each 
	
	//MARK:-
Function _log($log : Object)
	
	This.logs.push($log)
	If (This.settings.logger#Null)
		This.settings.logger($log)
	End if 
	
	//MARK:-
Function _resolvePath($path : Text; $baseFolder : 4D.Folder) : Object
	
	var $absolutePath : Text
	var $absoluteFolder; $app : 4D.Folder
	
	$absoluteFolder:=$baseFolder
	Case of 
		: ($path="./@")  // Relative path inside $baseFolder
			$path:=Substring($path; 3)
			$absolutePath:=$absoluteFolder.path+$path
		: ($path="../@")  // Relative path outside $baseFolder
			While ($path="../@")
				$absoluteFolder:=$absoluteFolder.parent
				$path:=Substring($path; 4)
			End while 
			$absolutePath:=$absoluteFolder.path+$path
		Else   // Absolute path or custom fileSystem
			Case of 
				: ($path="/4DCOMPONENTS/@")
					$app:=(Is macOS) ? Folder(Application file; fk platform path).folder("Contents/Components") : File(Application file; fk platform path).parent.folder("Components")
					$absolutePath:=$app.path+Substring($path; 15)
					
				: (($path="") | ($path="/"))  // Base folder
					$absolutePath:=$baseFolder.path
					
				Else   // Absolute path or baseFolder subpath
					
					var $pathExists : Boolean
					$pathExists:=($path="@/") ? Folder(Folder($path; *).platformPath; fk platform path).exists : File(File($path; *).platformPath; fk platform path).exists
					$absolutePath:=($pathExists) ? $path : $absoluteFolder.path+$path
			End case 
			
	End case 
	
	return ($absolutePath="@/") ? Folder(Folder($absolutePath; *).platformPath; fk platform path) : File(File($absolutePath; *).platformPath; fk platform path)
	
	//MARK:-
Function _checkDestinationFolder() : Boolean
	
	This._noError:=True
	
	If (This.settings.destinationFolder.exists)  // Delete destination folder content if exists
		This.settings.destinationFolder.delete(fk recursive)
	End if 
	
	If (Not(This.settings.destinationFolder.create()))
		This._log(New object(\
			"function"; "Destination folder checking"; \
			"message"; "Destination folder doesn't exist and can't be created"; \
			"severity"; Error message); \
			"destinationFolder"; This.settings.destinationFolder.path)
		return False
	End if 
	
	return This._noError
	
	//MARK:-
Function _compileProject() : Boolean
	
	If (This._validInstance)
		var $compilation : Object
		
		If (Undefined(This.settings.compilerOptions))
			$compilation:=(This._isCurrentProject) ? Compile project : Compile project(This._projectFile)
		Else 
			$compilation:=(This._isCurrentProject) ? Compile project(This.settings.compilerOptions) : Compile project(This._projectFile; This.settings.compilerOptions)
		End if 
		
		If ($compilation.success)
			This._log(New object(\
				"function"; "Compilation"; \
				"message"; "Compilation successful."; \
				"severity"; Information message; \
				"result"; $compilation))
			return True
		Else 
			This._log(New object(\
				"function"; "Compilation"; \
				"message"; "Compilation failed."; \
				"severity"; Error message; \
				"result"; $compilation))
		End if 
	End if 
	
	//MARK:-
Function _createStructure() : Boolean
	
	var $structureFolder; $librariesFolder : 4D.Folder
	var $deletePaths : Collection
	var $result : Boolean
	
	If (This._validInstance)
		
		$structureFolder:=This._structureFolder
		
		// Copy Project Folder
		If ($structureFolder.exists)  // Empty the structure folder
			$structureFolder.delete(fk recursive)
		End if 
		$structureFolder.create()
		
		This._projectFile.parent.copyTo($structureFolder; fk overwrite)
		
		// Remove source methods
		$deletePaths:=New collection
		$deletePaths.push($structureFolder.folder("Project/Sources/Classes/"))
		$deletePaths.push($structureFolder.folder("Project/Sources/DatabaseMethods/"))
		$deletePaths.push($structureFolder.folder("Project/Sources/Methods/"))
		$deletePaths.push($structureFolder.folder("Project/Sources/Triggers/"))
		$deletePaths.push($structureFolder.folder("Project/Trash/"))
		
		If (This._deletePaths($deletePaths))
			$deletePaths:=$structureFolder.files(fk recursive).query("extension =:1"; ".4DM")  // Table Form, Form and Form object methods
			If (($deletePaths.length>0) || (This._deletePaths($deletePaths)))
				// Copy Libraries folder
				$librariesFolder:=This._projectPackage.folder("Libraries")
				If (($librariesFolder.exists) && ($librariesFolder.files.length))
					$librariesFolder.copyTo($structureFolder; fk overwrite)
				End if 
				return True
			End if 
		End if 
	End if 
	
	//MARK:-
Function _includePaths($pathsObj : Collection) : Boolean
	
	var $pathObj; $sourcePath; $destinationPath : Object
	
	If (($pathsObj#Null) && ($pathsObj.length>0))
		For each ($pathObj; $pathsObj)
			
			If (Undefined($pathObj.source))
				This._log(New object(\
					"function"; "Paths include"; \
					"message"; "Collection.source must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
					"severity"; Error message))
				return False
			Else 
				Case of 
					: (Value type($pathObj.source)=Is text)
						$sourcePath:=This._resolvePath($pathObj.source; This._projectPackage)
					: ((OB Instance of($pathObj.source; 4D.Folder)) || (OB Instance of($pathObj.source; 4D.File)))
						$sourcePath:=$pathObj.source
					Else 
						This._log(New object(\
							"function"; "Paths include"; \
							"message"; "Collection.source must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
							"severity"; Error message))
						return False
				End case 
			End if 
			
			If (Undefined($pathObj.destination))
				$destinationPath:=This._structureFolder
			Else 
				Case of 
					: (Value type($pathObj.destination)=Is text)
						$destinationPath:=This._resolvePath($pathObj.destination; This._structureFolder)
					: (OB Instance of($pathObj.destination; 4D.Folder))
						$destinationPath:=$pathObj.destination
					Else 
						This._log(New object(\
							"function"; "Paths include"; \
							"message"; "Collection.destination must contain Posix text paths or 4D.Folder objects"; \
							"severity"; Error message))
						return False
				End case 
			End if 
			
			If (Not($destinationPath.exists) && Not($destinationPath.create()))
				This._log(New object(\
					"function"; "Paths include"; \
					"message"; "Destination folder doesn't exist and can't be created"; \
					"severity"; Error message; \
					"destinationPath"; $destinationPath.path))
				return False
			End if 
			If ($sourcePath.exists)
				$destinationPath:=$sourcePath.copyTo($destinationPath; fk overwrite)
				If ($destinationPath.exists)
					This._log(New object(\
						"function"; "Paths include"; \
						"message"; "Path copied"; \
						"severity"; Information message; \
						"sourcePath"; $sourcePath.path; \
						"destinationPath"; $destinationPath.path))
				Else 
					This._log(New object(\
						"function"; "Paths include"; \
						"message"; "Path doesn't exist"; \
						"severity"; Warning message; \
						"sourcePath"; $sourcePath.path; \
						"destinationPath"; $destinationPath.path))
				End if 
			Else 
				This._log(New object(\
					"function"; "Paths include"; \
					"message"; "Path doesn't exist"; \
					"severity"; Warning message; \
					"sourcePath"; $sourcePath.path))
			End if 
		End for each 
	Else 
		This._log(New object(\
			"function"; "Paths include"; \
			"message"; "Empty paths collection"; \
			"severity"; Information message))
	End if 
	
	return True
	
	//MARK:-
Function _deletePaths($paths : Collection) : Boolean
	
	var $path : Variant
	var $deletePath : Object
	
	If (($paths#Null) && ($paths.length>0))
		For each ($path; $paths)
			
			Case of 
				: (Value type($path)=Is text)
					$deletePath:=This._resolvePath($path; This._structureFolder)
				: ((OB Instance of($path; 4D.Folder)) || (OB Instance of($path; 4D.File)))
					$deletePath:=$path
				Else 
					This._log(New object(\
						"function"; "Paths delete"; \
						"message"; "Collection must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
						"severity"; Error message))
					return False
			End case 
			
			If ($deletePath.exists)
				$deletePath.delete(fk recursive)
				This._log(New object(\
					"function"; "Paths delete"; \
					"message"; "Path deleted"; \
					"severity"; Information message; \
					"path"; $deletePath.path))
			Else 
				This._log(New object(\
					"function"; "Paths delete"; \
					"message"; "Path doesn't exist"; \
					"severity"; Warning message; \
					"path"; $deletePath.path))
			End if 
		End for each 
	Else 
		This._log(New object(\
			"function"; "Paths delete"; \
			"message"; "Empty paths collection"; \
			"severity"; Information message))
	End if 
	return True
	
	//MARK:-
Function _create4DZ() : Boolean
	
	var $structureFolder : 4D.Folder
	var $zipStructure : Object
	var $return : Object
	
	If ((This._validInstance) && (This.settings.packedProject))
		$structureFolder:=This._structureFolder
		$zipStructure:=New object
		$zipStructure.files:=New collection($structureFolder.folder("Project"))
		$zipStructure.encryption:=(This.settings.obfuscated) ? -1 : ZIP Encryption none
		$return:=ZIP Create archive($zipStructure; $structureFolder.file(This.settings.buildName+".4DZ"))
		If ($return.success)
			$structureFolder.folder("Project").delete(Delete with contents)
		Else 
			This._log(New object(\
				"function"; "Package compression"; \
				"message"; "Compression failed."; \
				"severity"; Error message; \
				"result"; $return))
			return False
		End if 
	End if 
	return True
	
Function _copySourceApp() : Boolean
	This._noError:=True
	This.settings.sourceAppFolder.copyTo(This.settings.destinationFolder.parent; This.settings.destinationFolder.fullName)
	return This._noError
	
	//MARK:-
Function _excludeModules() : Boolean
	//TODO: remove modules
	
	return True
	
	//MARK:-
Function _setAppOptions() : Boolean
	var $appInfo : Object
	var $infoFile; $exeFile : 4D.File
	
	This._noError:=True
	
	$infoFile:=(Is macOS) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
	
	If ($infoFile.exists)
		$appInfo:=New object(\
			"com.4D.BuildApp.LastDataPathLookup"; This.settings.lastDataPathLookup\
			)
		
		If ((This.settings.iconPath#Null) && (This.settings.iconPath.exists))  // Set icon
			If (Is macOS)
				$appInfo.CFBundleIconFile:=This.settings.iconPath.fullName
				This.settings.iconPath.copyTo(This.settings.destinationFolder.folder("Contents/Resources/"))
			Else   // Windows
				$exeFile:=This.settings.destinationFolder.file(This.settings.buildName+".exe")
				If ($exeFile.exists)
					If ((This.settings.iconPath#Null) && (This.settings.iconPath.exists))  // Set icon
						$exeFile.setAppInfo(New object("WinIcon"; This.settings.iconPath))
					End if 
				Else 
					This._log(New object(\
						"function"; "Setting app options"; \
						"message"; "Exe file doesn't exist: "+$exeFile.path; \
						"severity"; Warning message))
					return False
				End if 
			End if 
		End if 
		
		If (Is macOS)
			$appInfo.CFBundleDisplayName:=This.settings.buildName
			$appInfo.CFBundleExecutable:=This.settings.buildName
		Else   // Windows
			
		End if 
		
		$infoFile.setAppInfo($appInfo)
		
	Else 
		This._log(New object(\
			"function"; "Setting app options"; \
			"message"; "Info.plist file doesn't exist: "+$infoFile.path; \
			"severity"; Warning message))
		return False
	End if 
	
	return This._noError
	
	//MARK:-
Function _generateLicense() : Boolean
	If ((This.settings.license#Null) && (This.settings.license.exists))
		$status:=Create deployment license(This.settings.destinationFolder; This.settings.license)
		return $status.success
	End if 
	
	
	//MARK:-
Function _sign() : Boolean
	
	If (Is macOS && (This.settings.signApplication#Null))
		//Default values initialization
		This.settings.signApplication.macSignature:=(This.settings.signApplication.macSignature#Null) ? This.settings.signApplication.macSignature : False
		This.settings.signApplication.macCertificate:=(This.settings.signApplication.macCertificate#Null) ? This.settings.signApplication.macCertificate : ""
		This.settings.signApplication.adHocSignature:=(This.settings.signApplication.adHocSignature#Null) ? This.settings.signApplication.adHocSignature : True
		
		If (This.settings.signApplication.macSignature || This.settings.signApplication.adHocSignature)
			var $script; $entitlements : 4D.File
			$script:=Folder(Application file; fk platform path).file("Contents/Resources/SignApp.sh")
			$entitlements:=Folder(Application file; fk platform path).file("Contents/Resources/4D.entitlements")
			If ($script.exists && $entitlements.exists)
				var $commandLine; $certificateName : Text
				var $signatureWorker : 4D.SystemWorker
				
				$certificateName:=(Not(This.settings.signApplication.macSignature) && This.settings.signApplication.adHocSignature) ? "-" : This.settings.signApplication.macCertificate  // If nAdHocSignature, the certificate name shall be '-'
				
				If ($certificateName#"")
					
					$commandLine:="'"
					$commandLine+=$script.path+"' '"
					$commandLine+=$certificateName+"' '"
					$commandLine+=This.settings.destinationFolder.path+"' '"
					$commandLine+=$entitlements.path+"'"
					
					$signatureWorker:=4D.SystemWorker.new($commandLine)
					$signatureWorker.wait(120)
					
					If ($signatureWorker.terminated)
						If ($signatureWorker.exitCode=0)
							This._log(New object(\
								"function"; "Signature"; \
								"message"; "Signature successful."; \
								"severity"; Information message; \
								"signatureReturn"; $signatureWorker.response))
						Else 
							This._log(New object(\
								"function"; "Signature"; \
								"message"; "Signature error."; \
								"severity"; Error message; \
								"signatureReturn"; $signatureWorker.response))
							return False
						End if 
					Else 
						This._log(New object(\
							"function"; "Signature"; \
							"message"; "Signature timeout."; \
							"severity"; Error message))
						return False
					End if 
				Else 
					This._log(New object(\
						"function"; "Signature"; \
						"message"; "No certificate defined."; \
						"severity"; Error message))
					return False
				End if 
			Else 
				This._log(New object(\
					"function"; "Signature"; \
					"message"; "Signature files are missing."; \
					"severity"; Error message; \
					"script"; $script.path; \
					"entitlements"; $entitlements.path))
				return False
			End if 
		End if 
	End if 
	return True
	