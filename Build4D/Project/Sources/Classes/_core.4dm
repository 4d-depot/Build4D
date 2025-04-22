
//mark:- DOCUMENTATION PRIVATE PROPERTIES

/*

PRIVATE PROPERTIES

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Attributes                    |   Type           |      Description
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
_validInstance                |   Boolean        |      True if the instanciated object can be used for build. False if a condition is not filled (e.g. project doesn't exist).
_projectFile                  |   File           |      Project file.
_projectPackage               |   Folder         |      Folder of the project package.
_isCurrentProject.            |   Boolean        |      True if the project is the current one.
_isDefaultDestinationFolder   |   Boolean        |      True if the destination folder is the one computed automatically.
_structureFolder              |   Folder         |      Folder of the destination structure.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/


property _validInstance : Boolean
property _isCurrentProject : Boolean
property _isDefaultDestinationFolder : Boolean
property _noError : Boolean

property _projectFile : 4D.File

property _currentProjectPackage : 4D.Folder
property _projectPackage : 4D.Folder
property _structureFolder : 4D.Folder
property _target : Text

property logs : Collection

property settings : Object


Class constructor($target : Text; $customSettings : Object)
	
	var $settings : Object
	
	ON ERR CALL("onError"; ek global)
	
	This.logs:=New collection
	This.settings:=New object()
	This.settings.includePaths:=New collection
	This.settings.deletePaths:=New collection
	
	If (File("/RESOURCES/"+$target+".json").exists)
		This._overrideSettings(JSON Parse(File("/RESOURCES/"+$target+".json").getText()))  // Loads target default settings
	End if 
	
	This._isDefaultDestinationFolder:=False
	
	$settings:=($customSettings#Null) ? $customSettings : {}
	
	//NOTE : if you want to create a container for the target ...
	//If ($settings.destinationFolder=Null)
	// $settings.destinationFolder:="/"+$target+"/"
	//Else 
	// $settings.destinationFolder+=(($settings.destinationFolder="@/") ? "" : "/")+$target+"/"
	//End if 
	
	
	This._validInstance:=True
	This._isCurrentProject:=True
	
	This._projectFile:=File(Structure file(*); fk platform path)
	This._currentProjectPackage:=Folder(Folder("/PACKAGE/"; *).platformPath; fk platform path)
	If (($settings#Null) && ($settings.projectFile#Null) && \
		((Value type($settings.projectFile)=Is object) && OB Instance of($settings.projectFile; 4D.File)) || \
		((Value type($settings.projectFile)=Is text) && ($settings.projectFile#"")))
		This._isCurrentProject:=False
		This._projectFile:=This._resolvePath($settings.projectFile; This._currentProjectPackage)
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
		
		//#2068
		
		Case of 
				
			: (This.settings.sourceAppFolder.file("Contents/MacOS/4D Volume Desktop").exists)
				This._target:="mac"
				
			: (This.settings.sourceAppFolder.file("Contents/MacOS/4D Server").exists)
				This._target:="mac"
				
				
				
			: (This.settings.sourceAppFolder.file("4D Volume Desktop.4DE").exists)
				This._target:="win"
				
			: (This.settings.sourceAppFolder.file("4D Server.exe").exists)
				This._target:="win"
				
			Else 
				
				
				This._target:=""
				
		End case 
		
		
		
	End if 
	
Function get buildName : Text
	If (Value type(This.settings.buildName)=Is text)
		return This.settings.buildName
	Else 
		return This._projectFile.name
	End if 
	
	
Function get is_component : Boolean
	
	return OB Class(This).name=cs.Component.name
	
Function get is_standalone : Boolean
	
	return OB Class(This).name=cs.Standalone.name
	
	
Function get is_server : Boolean
	
	return OB Class(This).name=cs.Server.name
	
	
	
Function get is_client : Boolean
	
	return OB Class(This).name=cs.Client.name
	
	
	
	
	
	//MARK:- identify if we build a mac or win client
	
Function get is_mac_target : Boolean
	
	return Bool(This._target="mac")
	
	
	//MARK:- identify if we build a mac or win client
	
Function get is_win_target : Boolean
	
	return Bool(This._target="win")
	
	
	
	
	//MARK:- Overrides the default target settings with the $settings parameter.
	
/*
	
Function _overrideSettings($settings : Object)
....................................................................................
Parameter      Type          in/out         Description
....................................................................................
$settings.     Object          in           Settings passed by the derived class to override the default settings.
....................................................................................
	
*/
	
Function _overrideSettings($settings : Object)
	
	var $entries : Collection
	var $entry : Object
	
	$entries:=OB Entries($settings)
	For each ($entry; $entries)
		
		Case of 
				
			: ($entry.key="destinationFolder")
				This.settings.destinationFolder:=This._resolvePath($settings.destinationFolder; This._currentProjectPackage)
				If (Not(OB Instance of(This.settings.destinationFolder; 4D.Folder)))
					This._validInstance:=False
				Else 
					This._validInstance:=This._checkDestinationFolder()
				End if 
				
			: ($entry.key="includePaths")
				This.settings.includePaths:=This.settings.includePaths.concat($settings.includePaths)
				
			: ($entry.key="iconPath")
				This.settings.iconPath:=This._resolvePath($settings.iconPath; This._currentProjectPackage)
				
			: ($entry.key="license")
				This.settings.license:=This._resolvePath($settings.license; Null)
				
			: ($entry.key="xmlKeyLicense")
				This.settings.xmlKeyLicense:=This._resolvePath($settings.xmlKeyLicense; Null)
				
			: ($entry.key="sourceAppFolder")
				If (Value type($settings.sourceAppFolder)=Is text)
					$settings.sourceAppFolder:=($settings.sourceAppFolder="@/") ? $settings.sourceAppFolder : $settings.sourceAppFolder+"/"
				End if 
				This.settings.sourceAppFolder:=This._resolvePath($settings.sourceAppFolder; This._currentProjectPackage)
				
			: ($entry.key="macCompiledProject")
				If (Value type($settings.macCompiledProject)=Is text)
					$settings.macCompiledProject:=($settings.macCompiledProject="@/") ? $settings.macCompiledProject : $settings.macCompiledProject+"/"
				End if 
				This.settings.macCompiledProject:=This._resolvePath($settings.macCompiledProject; This._currentProjectPackage)
				
			Else 
				This.settings[$entry.key]:=$entry.value
				
		End case 
		
	End for each 
	
	
	
	//MARK:-Calls the settings.formulaForLogs formula with the $log object parameter.
	
/*
	
Function _log($log : Object)
....................................................................................
Parameter      Type          in/out         Description
....................................................................................
$log           Object         in            Object containing the attributes: "function", "message", "messageSeverity", and optionnaly: "result", "path", "sourcePath", "destinationPath".
....................................................................................
	
*/
	
Function _log($log : Object)
	
	This.logs.push($log)
	If (This.settings.logger#Null)
		This.settings.logger($log)
	End if 
	
	
	
	//MARK:- Resolves a relative/absolute/filesystem string path to a Folder/File object.
	
/*
Function _resolvePath($path : Text; $baseFolder : 4D.Folder) -> $object : Object
....................................................................................
Parameter      Type                     in/out         Description
....................................................................................
$path.         Text                      in            Relative path to $baseFolder.
$baseFolder    4D.Folder                 in            Absolute path.
$object        4D.Folder or 4D.File.     out           4D folder or 4D File.
....................................................................................
	
*/
	
Function _resolvePath($path : Variant; $baseFolder : 4D.Folder) : Object
	
	var $absolutePath : Text
	var $absoluteFolder; $app; $folder : 4D.Folder
	var $file : 4D.File
	var $path_root; $base_root : Text
	var $_path; $_base; $_volume : Collection
	
	Case of 
			
		: ((Value type($path)=Is object) && (OB Instance of($path; 4D.File) || OB Instance of($path; 4D.Folder)))  // $path is a File or a Folder
			return $path
			
		: (Value type($path)=Is text)  // $path is a text
			
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
							
							Case of 
									
								: (Folder($path; *).exists)
									
									$absolutePath:=Folder(Folder($path; *).platformPath; fk platform path).path
									
									
								: (File($path; *).exists)
									
									$absolutePath:=File(File($path; *).platformPath; fk platform path).path
									
								Else 
									
									$_base:=($baseFolder=Null) ? [] : Split string($baseFolder.path; "/"; sk ignore empty strings)
									
									$_path:=Split string($path; "/"; sk ignore empty strings)
									
									$base_root:=Split string($baseFolder.platformPath; Folder separator)[0]
									$path_root:=Split string(Folder($path; fk posix path).platformPath; Folder separator)[0]
									
									If ($path_root=$base_root)  // we are on se same root volume path
										
										If ($_base[0]=$_path[0])  // are we on the same root
											$absolutePath:=$path
										Else   // this is an absolute path
											$absolutePath:=$absoluteFolder.path+$path
										End if 
										
									Else 
										
										// a path on different volume ?
										
										$_volume:=System info.volumes.query(" name = :1 "; $path_root)
										If ($_volume.length>0)
											$absolutePath:=$path
										Else 
											$absolutePath:=$absoluteFolder.path+$path  // stranger thing
										End if 
										
									End if 
									
									$absolutePath:=Replace string($absolutePath; "//"; "/")
									
							End case 
							
					End case 
					
			End case 
			
			//https://github.com/4d/4d/issues/2139
			//return ($absolutePath="@/") ? Folder(Folder($absolutePath; *).platformPath; fk platform path) : File(File($absolutePath; *).platformPath; fk platform path)
			
			$folder:=Folder($absolutePath; *)
			
			If ($absolutePath="@/")
				
			Else 
				
				$file:=File($absolutePath; *)  // generate a -1 error if path is a folder
				
			End if 
			
			Case of 
					
				: ($folder.isPackage)
					return Folder($folder.platformPath; fk platform path)
					
				: (Bool($file.isFile))
					return File($file.platformPath; fk platform path)
					
				Else 
					return Folder($folder.platformPath; fk platform path)
					
			End case 
			
			
		Else 
			return Null
			
	End case 
	
	
	
	//MARK:- Checks the destination folder.
	
/*
	
Function _checkDestinationFolder() -> $status : Boolean
....................................................................................
Parameter      Type          in/out        Description
....................................................................................
$status       Boolean        out          True if the destination folder exists.
....................................................................................
	
*/
	
Function _checkDestinationFolder() : Boolean
	
	This._noError:=True
	
	If (This.settings.destinationFolder.exists)  // Delete destination folder content if exists
		This.settings.destinationFolder.delete(fk recursive)
	End if 
	
	If (Not(This.settings.destinationFolder.create()))
		This._log(New object(\
			"function"; "Destination folder checking"; \
			"message"; "Destination folder doesn't exist and can't be created"; \
			"severity"; Error message; \
			"destinationFolder"; This.settings.destinationFolder.path))
		
		return False
	End if 
	
	return This._noError
	
	
	
	//MARK:- Compiles the project with the settings.compilerOptions (if it exists).
	
/*
	
Function _compileProject() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean        out         True if the compilation has succeeded. Otherwise, the compilation's result object is included in an error log.
....................................................................................
	
*/
	
Function _compileProject() : Boolean
	
	If (This._validInstance)
		var $compilation : Object
		var $flag : Text
		
		$flag:="$compile_project"
		While (Semaphore($flag; 5))
			IDLE
			DELAY PROCESS(Current process; 5)
		End while 
		
		If (Undefined(This.settings.compilerOptions))
			$compilation:=(This._isCurrentProject) ? Compile project : Compile project(This._projectFile)
		Else 
			$compilation:=(This._isCurrentProject) ? Compile project(This.settings.compilerOptions) : Compile project(This._projectFile; This.settings.compilerOptions)
		End if 
		CLEAR SEMAPHORE($flag)
		
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
	
	
	
	//MARK:- Creates the destination structure folders and files.
	
/*
	
Function _createStructure() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the destination structure has been correctly created.
....................................................................................
	
*/
	
Function _createStructure() : Boolean
	
	var $structureFolder; $librariesFolder : 4D.Folder
	var $deletePaths : Collection
	
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
		
		If (This.is_standalone || This.is_server)
			$deletePaths.push($structureFolder.file("Project/Sources/dependencies.json"))
		End if 
		
		If (This._deletePaths($deletePaths))
			$deletePaths:=$structureFolder.files(fk recursive).query("extension =:1"; ".4DM")  // Table Form, Form and Form object methods
			If (($deletePaths.length=0) || (This._deletePaths($deletePaths)))
				// Copy Libraries folder
				$librariesFolder:=This._projectPackage.folder("Libraries")
				If (($librariesFolder.exists) && ($librariesFolder.files().length>0))
					$librariesFolder.copyTo($structureFolder; fk overwrite)
				End if 
				return True
			End if 
		End if 
	End if 
	
	
	
	//MARK:- Includes folders and files into the destination structure.
	
/*
	
Function _includePaths($pathsObj : Collection) -> $status : Boolean
....................................................................................
Parameter      Type                     in/out        Description
....................................................................................
$paths.        Collection of objects     in           List of folder and file objects to include.
$status        Boolean.                  out         True if all paths have been correctly copied. Otherwise, an error log is created with "sourcePath" and "destinationPath" information.
....................................................................................
	
*/
	
Function _includePaths($pathsObj : Collection) : Boolean
	
	var $pathObj; $sourcePath; $destinationPath : Object
	var $is_string_path : Boolean
	
	If (($pathsObj#Null) && ($pathsObj.length>0))
		
		For each ($pathObj; $pathsObj)
			
			If (Undefined($pathObj.source))
				This._log(New object(\
					"function"; "Paths include"; \
					"message"; "Collection.source must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
					"severity"; Error message))
				return False
			Else 
				If ((Value type($pathObj.source)=Is text) || (OB Instance of($pathObj.source; 4D.Folder)) || (OB Instance of($pathObj.source; 4D.File)))
					$sourcePath:=This._resolvePath($pathObj.source; This._currentProjectPackage)
				Else 
					This._log(New object(\
						"function"; "Paths include"; \
						"message"; "Collection.source must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
						"severity"; Error message))
					return False
				End if 
			End if 
			
			If (Undefined($pathObj.destination))
				$destinationPath:=This._structureFolder
			Else 
				
				$is_string_path:=(Value type($pathObj.destination)=Is text)
				If ($is_string_path || (OB Instance of($pathObj.destination; 4D.Folder)))
					
					If ($is_string_path)
						If ($pathObj.destination#"@/")
							$pathObj.destination+="/"
						End if 
					End if 
					
					$destinationPath:=This._resolvePath($pathObj.destination; This._structureFolder)
				Else 
					This._log(New object(\
						"function"; "Paths include"; \
						"message"; "Collection.destination must contain Posix text paths or 4D.Folder objects"; \
						"severity"; Error message))
					return False
				End if 
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
	
	
	
	//MARK:- Deletes folders and files from the destination structure.
	
/*
	
Function _deletePaths($paths : Collection) -> $status : Boolean
....................................................................................
Parameter      Type                   in/out        Description
....................................................................................
$paths.        Collection of texts     in           List of folders and files to delete.
$status        Boolean                 out          True if all paths have been correctly removed. Otherwise, an error log is created with "path" information.
....................................................................................
	
*/
	
Function _deletePaths($paths : Collection) : Boolean
	
	var $path : Variant
	var $deletePath : Object
	
	If (($paths#Null) && ($paths.length>0))
		
		For each ($path; $paths)
			
			If ((Value type($path)=Is text) || ((OB Instance of($path; 4D.Folder)) || (OB Instance of($path; 4D.File))))
				$deletePath:=This._resolvePath($path; This._structureFolder)
			Else 
				This._log(New object(\
					"function"; "Paths delete"; \
					"message"; "Collection must contain Posix text paths, 4D.File objects or 4D.Folder objects"; \
					"severity"; Error message))
				return False
			End if 
			
			//If ($deletePath.exists)//https://github.com/4d/4d/issues/2139
			If (Test path name(String($deletePath.platformPath))>=0)
				Case of 
					: (OB Instance of($path; 4D.File))
						$deletePath.delete()
					Else   // : (OB Instance of($path; 4D.Folder)) // if not 4D folder?
						$deletePath.delete(fk recursive)
				End case 
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
	
	
	// MARK:- Manage paths from settings
	
Function _manageSettingsPaths() : Boolean
	var $success : Boolean
	$success:=True
	$success:=($success) ? This._includePaths(This.settings.includePaths) : False  //#2025
	$success:=($success) ? This._deletePaths(This.settings.deletePaths) : False  //#2026
	return $success
	
	//MARK:- Creates the 4DZ file of the project, and deletes the Project folder if successful.
	
/*
	
Function _create4DZ() -> $status : Boolean
....................................................................................
Parameter      Type         in/out        Description
....................................................................................
$status        Boolean       out          True if the compression has succeeded. Otherwise, the archive creation's result object is included in an error log.
....................................................................................
	
*/
	
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
	
	
	
	//MARK:- Copies the source application (4D Volume Desktop or 4D Server) in the destination folder.
	
/*
	
Function _copySourceApp() -> $status : Boolean
....................................................................................
Parameter      Type           in/out        Description
....................................................................................
$status        Boolean         out          True if the copy is successful.
....................................................................................
	
*/
	
Function _copySourceApp() : Boolean
	This._noError:=True
	This.settings.sourceAppFolder.copyTo(This.settings.destinationFolder.parent; This.settings.destinationFolder.fullName)
	return This._noError
	
	
	
	//MARK:- Deletes the folders and files composing the module to be removed according to the information in the "/RESOURCES/BuildappOptionalModules.json" file.
	
/*
	
Function _excludeModules() -> $status : Boolean
....................................................................................
Parameter      Type         in/out         Description
....................................................................................
$status        Boolean        out          True if all modules have been correctly removed. Otherwise, an error log is created with "path" information.
....................................................................................
	
*/
	
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
			$basePath:=(Is macOS) ? This.settings.destinationFolder.path+"Contents/" : This.settings.destinationFolder.path
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
	
	
	
	//MARK:- Sets the information to the application.
	
/*
	
Function _setAppOptions()-> $status : Boolean
....................................................................................
Parameter      Type.         in/out.        Description
....................................................................................
$status        Boolean        out           True if the information has been correctly added.
....................................................................................
	
*/
	
Function _setAppOptions() : Boolean
	var $appInfo; $exeInfo : Object
	var $infoFile; $exeFile; $manifestFile : 4D.File
	var $identifier : Text
	var $type : Integer
	
	This._noError:=True
	
	$infoFile:=(Is macOS) ? This.settings.destinationFolder.file("Contents/Info.plist") : This.settings.destinationFolder.file("Resources/Info.plist")
	
	If ($infoFile.exists)
		$appInfo:=New object(\
			"com.4D.BuildApp.ReadOnlyApp"; "true"; \
			"com.4D.BuildApp.LastDataPathLookup"; Choose((This.settings.lastDataPathLookup="ByAppName") | (This.settings.lastDataPathLookup="ByAppPath"); This.settings.lastDataPathLookup; "ByAppName"); \
			"DataFileConversionMode"; "0"\
			)
		$appInfo.SDIRuntime:=((This.settings.useSDI#Null) && This.settings.useSDI) ? "1" : "0"
		
		If (Is macOS)
			$appInfo.CFBundleName:=This.settings.buildName
			$appInfo.CFBundleDisplayName:=This.settings.buildName
			$appInfo.CFBundleExecutable:=This.settings.buildName
			$identifier:=((This.settings.versioning.companyName#Null) && (This.settings.versioning.companyName#"")) ? This.settings.versioning.companyName : "com.4d"
			$identifier+="."+This.settings.buildName
			$appInfo.CFBundleIdentifier:=$identifier
		Else 
			$exeInfo:=New object("ProductName"; This.settings.buildName)
		End if 
		
		If (This.settings.iconPath#Null)  // Set icon
			If (This.settings.iconPath.exists)
				If (Is macOS)
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
			If (Is macOS)
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
		
		
		//ACI0105060
		If (This.is_standalone || This.is_server)
			
			$type:=Value type(This.settings.dataFilePath)
			
			Case of 
					
				: ($type=Is null)
					
				: ($type=Is text)
					
					If (Position(Folder separator; This.settings.dataFilePath; *)>0)
						$appInfo.BuildDataPath:=This.settings.dataFilePath
					Else 
						
						If (This.is_mac_target)
							
							This.settings.dataFilePath:=Replace string(This.settings.dataFilePath; "/"; ":")
							
							If (Position(":"; This.settings.dataFilePath)#1)
								This.settings.dataFilePath:=":"+This.settings.dataFilePath
							End if 
							
						Else 
							
							This.settings.dataFilePath:=Replace string(This.settings.dataFilePath; "/"; "\\")
							
							If (Position("\\"; This.settings.dataFilePath)#1)
								This.settings.dataFilePath:="\\"+This.settings.dataFilePath
							End if 
							
						End if 
						
						$appInfo.BuildDataPath:=This.settings.dataFilePath
						
					End if 
					
				: ($type=Is object) && OB Instance of(This.settings.dataFilePath; 4D.File)
					
					$appInfo.BuildDataPath:=This.settings.dataFilePath.platformPath
					
				Else 
					
					This._log(New object(\
						"function"; "Setting app options"; \
						"message"; "dataFilePath property accept only text or 4D.File values"; \
						"severity"; Information message))
					
			End case 
			
			//mark:- [4d/4d] Intégrer le mode evaluation dans le composant Build (Issue #13272)
			
			
			If (This._is_evaluationMode())
				
				$appInfo["com.4D.BuildApp.EvaluationKey"]:=License info.licenseNumber
				
			End if 
			
			If (Value type(This.settings.evaluationName)=Is text)
				$appInfo["com.4D.BuildApp.EvaluationName"]:=This.settings.evaluationName
			End if 
			
			//mark:-
			
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
	
	If (Is Windows)  // Updater elevation rights #2027
		$manifestFile:=((This.settings.startElevated#Null) && (This.settings.startElevated))\
			 ? This.settings.destinationFolder.file("Resources/Updater/elevated.manifest")\
			 : This.settings.destinationFolder.file("Resources/Updater/normal.manifest")
		$manifestFile.copyTo(This.settings.destinationFolder.folder("Resources/Updater/"); "Updater.exe.manifest"; fk overwrite)
		This.settings.destinationFolder.file("Resources/Updater/elevated.manifest").delete()
		This.settings.destinationFolder.file("Resources/Updater/normal.manifest").delete()
	End if 
	
	return This._noError
	
	
	
	//mark:- test if the build is in evaluation mode.
	
/*
	
Function _is_evaluationMode()-> $status : Boolean
....................................................................................
Parameter      Type.         in/out.        Description
....................................................................................
$status        Boolean        out           True if the build is in evaluation mode.
....................................................................................
	
*/
	
Function _is_evaluationMode : Boolean
	return (Value type(This.settings.evaluationMode)=Is boolean) && (This.settings.evaluationMode)
	
	
	
	
	
	//MARK:- Creates the deployment license file in the license folder of the generated application.
	
/*
	
Function _generateLicense() -> $status : Boolean
....................................................................................
Parameter      Type         in/out         Description
....................................................................................
$status.       Boolean        out          True if the deployment license have been correctly created. Otherwise, xxx.
....................................................................................
	
*/
	
Function _generateLicense() : Boolean
	var $status : Object
	
	If ((This.settings.license#Null) && (This.settings.license.exists))
		If ((This.settings.xmlKeyLicense#Null) && (OB Instance of(This.settings.xmlKeyLicense; 4D.File)))
			$status:=Create deployment license(This.settings.destinationFolder; This.settings.license; This.settings.xmlKeyLicense)
		Else 
			$status:=Create deployment license(This.settings.destinationFolder; This.settings.license)
		End if 
		If ($status.success)
			return True
		Else 
			This._log(New object(\
				"function"; "Deployment license creation"; \
				"message"; "Deployment license creation failed"; \
				"severity"; Error message; \
				"result"; $status))
		End if 
	Else 
		
		//#issue 12064
		This._log(New object(\
			"function"; "Deployment license creation"; \
			"message"; "License file doesn't exist: "+Choose(This.settings.license#Null; This.settings.license.path; "Undefined"); \
			"severity"; Error message))
	End if 
	
	//MARK:- Posix
	
	
Function toPosix($o : Object) : Object
	
	Case of 
			
		: (OB Instance of($o; 4D.File))
			
			return File($o.platformPath; fk platform path)
			
		: (OB Instance of($o; 4D.Folder))
			
			return Folder($o.platformPath; fk platform path)
			
	End case 
	
	
	//MARK:- Change default uuid from app
	
	//feature #13565 when the build4d component is used to build a macos application then its uuids shall be made unique
	
Function _change_uuid() : Boolean
	
	var $app : 4D.Folder
	var $executable; $info_plist : 4D.File
	var $bundleID : Text
	var $arch; $info : Object
	
	
	If (This.is_mac_target && Is macOS)
		
		$app:=This._structureFolder.parent.parent
		
		If ($app.exists)
			// read the bundle id in the info.plist
			$info_plist:=$app.file("Contents/Info.plist").getAppInfo()
			
			If ($info_plist#Null)
				// read the bundle id in the info.plist
				$bundleID:=$info_plist.CFBundleIdentifier
				
				// reading uuids
				$executable:=$app.folder("Contents/MacOS/").file(This.buildName)
				
				If ($executable.exists)
					$info:=$executable.getAppInfo()
					
					Case of 
							
						: (Value type($info.archs)=Is collection) && ($info.archs.length>0)
							// update uuids by combining them with the id bundle
							For each ($arch; $info.archs)
								$arch.uuid:=Uppercase(Substring(Generate digest($bundleID+$arch.uuid; SHA256 digest); 1; 32))
							End for each 
							
							// write new uuids
							$executable.setAppInfo($info)
					End case 
					
					return True
					
				Else 
					
					This._log(New object(\
						"function"; "Change application uuid"; \
						"message"; "Application binary not found."; \
						"severity"; Error message))
					
				End if 
				
			Else 
				This._log(New object(\
					"function"; "Change application uuid"; \
					"message"; "Can't retrieve Info.plist inforation."; \
					"severity"; Error message))
			End if 
		Else 
			
			This._log(New object(\
				"function"; "Change application uuid"; \
				"message"; "Builded application not found."; \
				"severity"; Error message))
		End if 
		
	Else 
		return True
	End if 
	
	//MARK:- Signs the project
	
/*
Function _sign()-> $status : Boolean
....................................................................................
Parameter      Type          in/out         Description
....................................................................................
$status        Boolean        out           True if the signature is successful.
....................................................................................
*/
	
Function _sign() : Boolean
	
	If (Is macOS && (This.settings.signApplication#Null))
		//Default values initialization
		This.settings.signApplication.macSignature:=(This.settings.signApplication.macSignature#Null) ? This.settings.signApplication.macSignature : False
		This.settings.signApplication.macCertificate:=(This.settings.signApplication.macCertificate#Null) ? This.settings.signApplication.macCertificate : ""
		This.settings.signApplication.adHocSignature:=(This.settings.signApplication.adHocSignature#Null) ? This.settings.signApplication.adHocSignature : True
		
		If (This.settings.signApplication.macSignature || This.settings.signApplication.adHocSignature)
			
			var $commandLine; $certificateName : Text
			var $signatureWorker : 4D.SystemWorker
			var $entitlements : 4D.File
			var $script : 4D.File
			
			$entitlements:=Folder(Application file; fk platform path).file("Contents/Resources/4D.entitlements")
			
			
			If (This.is_component)
				
				$script:=Folder(Application file; fk platform path).file("Contents/Resources/app_sign_pack_notarize.sh")
				
			Else 
				
				$script:=Folder(Application file; fk platform path).file("Contents/Resources/SignApp.sh")
				
			End if 
			
			If ($script.exists && $entitlements.exists)
				
				$certificateName:=(Not(This.settings.signApplication.macSignature) && This.settings.signApplication.adHocSignature) ? "-" : This.settings.signApplication.macCertificate  // If AdHocSignature, the certificate name shall be '-'
				
				If ($certificateName#"")
					
					$commandLine:="'"+$script.path+"'"
					
					If (This.is_component)
						
						$commandLine+=" sign "
						
						$commandLine+=" '"+This.toPosix(This.settings.destinationFolder).path+"'"
						$commandLine+=" '"+This.toPosix($entitlements).path+"'"
						$commandLine+=" '"+$certificateName+"'"
						
					Else 
						
						$commandLine+=" '"+$certificateName+"'"
						$commandLine+=" '"+This.toPosix(This.settings.destinationFolder).path+"'"
						$commandLine+=" '"+This.toPosix($entitlements).path+"'"
						
					End if 
					
					//SET TEXT TO PASTEBOARD($commandLine)
					
					$signatureWorker:=4D.SystemWorker.new($commandLine)
					$signatureWorker.wait()
					
					
/*
#DD
Warning, if you receive an exitcode == 1 with a timestamp error
that mean codesign could not join the apple time server "timestamp.apple.com" (timestamp.v.aaplimg.com.[17.32.213.161])
check your network configuration proxy .....
*/
					
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
				
			End if 
			
		Else 
			
			
		End if 
	End if 
	
	return True
	
	
	//MARK:- Utilities
	
Function _show() : Object
	
	
	SHOW ON DISK(This.settings.destinationFolder.platformPath)
	
	return This