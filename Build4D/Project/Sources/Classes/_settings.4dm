property \
buildName : Text

property \
_compilerOptions : cs._compilerOptions


/* posix path */

property \
_sourceAppFolder; \
_destinationFolder : Text

property \
_versioning : cs._versioning

property \
_license; \
_xmlKeyLicense; \
_iconPath : Text

property \
_signApplication : cs._signApplication


/* _path collection */
property \
_includePaths; \
_deletePaths; \
_excludeModule : Collection

property \
startElevated; \
obfuscated; \
packedProject : Boolean


/* text controled input */
property \
_lastDataPathLookup : Text

property \
hideDataExplorerMenuItem; \
hideRuntimeExplorerMenuItem; \
hideAdministrationWindowMenuItem; \
serverDataCollection; \
clientWinSingleInstance : Boolean


/* posix path */
property \
_macOSClientArchive; \
_windowsClientArchive; \
_MacCompiledDatabaseToWin : Text\



Class constructor($settings : Object)
	
	//---------------------------------------
	// public properties
	This.buildName:=""
	
	This.hideDataExplorerMenuItem:=False
	This.hideRuntimeExplorerMenuItem:=False
	This.hideAdministrationWindowMenuItem:=False
	
	This.serverDataCollection:=False
	This.clientWinSingleInstance:=False
	This.startElevated:=False
	This.obfuscated:=False
	This.packedProject:=True
	
	
	//---------------------------------------
	// private properties
	This._sourceAppFolder:=""
	This._destinationFolder:=""
	This._license:=""
	This._xmlKeyLicense:=""
	This._iconPath:=""
	
	
	This._lastDataPathLookup:=""
	
	This._macOSClientArchive:=""
	This._windowsClientArchive:=""
	This._MacCompiledDatabaseToWin:=""
	
	This._compilerOptions:=cs._compilerOptions.new()
	This._versioning:=cs._versioning.new()
	This._signApplication:=cs._signApplication.new()
	
	This.reset()
	
	If (Count parameters>0)
		
		This.load_settings($settings)
		
	End if 
	
	
	
	//mark:- 
	//.     private
	
Function _var_to_posix_path($var : Variant) : Text
	
	Case of 
			
		: (Value type($var)=Is text)
			// (*) peut être voir avec le _core pour les accès relatifs et autres
			return $var
			
			
		: (Value type($var)#Is object)
			
			
		: (OB Instance of($var; 4D.File))
			
			return $var.path
			
			
	End case 
	
	
	//mark:- 
	//.     getters
	
Function get sourceAppFolder : Text
	return This._sourceAppFolder
	
	
Function get destinationFolder : Text
	return This._destinationFolder
	
	
Function get license : Text
	return This._license
	
	
Function get xmlKeyLicense : Text
	return This._xmlKeyLicense
	
	
Function get iconPath : Text
	return This._iconPath
	
	
Function get includePaths : Collection
	return (This._includePaths=Null) ? Null : This._includePaths.copy()
	
	
Function get deletePaths : Collection
	return (This._deletePaths=Null) ? Null : This._deletePaths.copy()
	
	
Function get excludeModules : Collection
	return (This._excludeModule=Null) ? Null : This._excludeModule.copy()
	
	
Function get lastDataPathLookup : Text
	return This._lastDataPathLookup
	
	
Function get macOSClientArchive : Text
	return This._macOSClientArchive
	
	
Function get windowsClientArchive : Text
	return This._windowsClientArchive
	
	
Function get MacCompiledDatabaseToWin : Text
	return This._MacCompiledDatabaseToWin
	
	
Function get compilerOptions : cs._compilerOptions
	return This._compilerOptions
	
	
Function get versioning : cs._versioning
	return This._versioning
	
	
Function get signApplication : cs._signApplication
	return This._signApplication
	
	
	//mark:- 
	//.      setters
	
Function set sourceAppFolder($path : Variant)
	This._sourceAppFolder:=This._var_to_posix_path($path)
	
Function set destinationFolder($path : Variant)
	This._destinationFolder:=This._var_to_posix_path($path)
	
Function set license($path : Variant)
	This._license:=This._var_to_posix_path($path)
	
Function set xmlKeyLicense($path : Variant)
	This._xmlKeyLicense:=This._var_to_posix_path($path)
	
Function set iconPath($path : Variant)
	This._iconPath:=This._var_to_posix_path($path)
	
Function set lastDataPathLookup($path : Text)
	Case of 
		: ($path="ByAppName")
			This._lastDataPathLookup:="ByAppName"
			
		: ($path="ByAppPath")
			This._lastDataPathLookup:="ByAppPath"
			
			//: ($path="InDbStruct")
			//This._lastDataPathLookup:="InDbStruct"
			
		Else 
			
	End case 
	
Function set macOSClientArchive($path : Variant)
	This._macOSClientArchive:=This._var_to_posix_path($path)
	
Function set windowsClientArchive($path : Variant)
	This._windowsClientArchive:=This._var_to_posix_path($path)
	
Function set MacCompiledDatabaseToWin($path : Variant)
	This._MacCompiledDatabaseToWin:=This._var_to_posix_path($path)
	
	
	//mark:-
	// member functions
	
	
Function reset() : cs._settings
	
	This._includePaths:=New collection
	This._deletePaths:=New collection
	This._excludeModule:=New collection
	
	return This
	
	
Function includePath($path : Variant) : cs._settings
	
	This._includePaths.push(This._var_to_posix_path($path))
	
	return This
	
	
Function deletePath($path : Variant) : cs._settings
	
	This._deletePaths.push(This._var_to_posix_path($path))
	
	return This
	
	
Function excludeModule($path : Variant) : cs._settings
	
	This._excludeModule.push(This._var_to_posix_path($path))
	
	return This
	
	
Function load_settings($settings : Object)
	
	var $type : Integer
	
	If ($settings#Null)
		
		For each ($key; $settings)
			
			
			$type:=Value type($settings[$key])
			
			Case of 
					
				: (This[$key]=Null)
					
					
				: ($type=Is object) && (OB Instance of(This[$key]; cs._compilerOptions))
					
					This._compilerOptions.load_settings($settings[$key])
					
					
					
				: ($type=Is object) && (OB Instance of(This[$key]; cs._versioning))
					
					This._versioning.load_settings($settings[$key])
					
					
					
				: ($type=Is object) && (OB Instance of(This[$key]; cs._signApplication))
					
					This._signApplication.load_settings($settings[$key])
					
					
					
				: ($type=Is collection) && (This["_"+$key]#Null)
					
					
					
				: ($type=Value type($settings[$key]))
					
					This[$key]:=$settings[$key]
					
					
					
					
					
				: ($type#Is object) && (This["_"+$key]#Null)
					
					
				Else 
					
			End case 
			
		End for each 
		
		
	End if 
	
Function save_settings : Object
	
	var $settings : Object
	var $key : Text
	var $this_type : Integer
	
	$settings:=New object
	
	For each ($key; This)
		
		
		$this_type:=Value type(This[$key])
		
		Case of 
				
			: ($key="_@")
				
			: ($this_type=Is object) && (OB Instance of(This[$key]; cs._compilerOptions))
				
			Else 
				
				$settings[$key]:=This[$key]
				
		End case 
		
		
		
	End for each 
	
	
	return $settings
	
	
	
	
	