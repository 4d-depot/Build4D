property \
_source; \
_destination : Text



Class constructor($source : Variant; $destination : Variant)
	
	
	This._source:=""
	This._destination:=""
	
	
	
	
Function source_is_ready : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._source)
	
	Case of 
			
		: (Test path name($path)=Is a document)
			return True
			
		: (Test path name($path)=Is a folder)
			return True
			
		Else 
			
	End case 
	
	
	
Function source_is_file() : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._source)
	
	return (Test path name($path)=Is a document)
	
	
	
Function source_is_folder() : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._source)
	
	return (Test path name($path)=Is a folder)
	
	
	//mark:-
	
Function destination_is_ready : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._destination)
	
	Case of 
		: (Length($path)=0)
			
		: (Test path name($path)=Is a folder)
			return True
			
		: (Test path name($path)=Is a document)
			return True
			
		Else 
			
			
			CREATE FOLDER($path; *)
			
			return (Test path name($path)=Is a folder)
			
	End case 
	
	
	
Function destination_is_file() : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._destination)
	
	return (Test path name($path)=Is a document)
	
	
	
Function destination_is_folder() : Boolean
	
	var $path : Text
	
	$path:=Convert path POSIX to system(This._destination)
	
	return (Test path name($path)=Is a folder)
	
	
	//mark:-
	//.     getters
	
Function get ready : Boolean
	
	return This.source_is_ready() && This.destination_is_ready()
	
	
	
Function get source : Text
	
	return This._source
	
	
	
Function get destination : Text
	
	return This._destination
	
	
	
	//mark:-
	
	
	
Function set source($source : Variant)
	
	Case of 
			
		: (Value type($source)=Is text)
			
			If (Position(Folder separator; $source)>0)
				
				This._source:=Convert path system to POSIX($source)
				
			Else 
				
				This._source:=$source
				
			End if 
			
		: (Value type($source)#Is object)
			
			
		: (OB Instance of($source; 4D.File))
			
			This._source:=$source.path
			
			
	End case 
	
	
	
Function set destination($destination : Variant)
	
	Case of 
			
		: (Value type($destination)=Is text)
			
			If (Position(Folder separator; $destination)>0)
				This._destination:=Convert path system to POSIX($destination)
			Else 
				This._destination:=$destination
			End if 
			
		: (Value type($destination)#Is object)
			
			
		: (OB Instance of($destination; 4D.File))
			
			This._destination:=$destination.path
			
		: (OB Instance of($destination; 4D.Folder))
			
			This._destination:=$destination.path
			
	End case 
	
	
	//mark:-
	
	
Function copy() : cs._path_mover
	
	// Path to object
	
	// Object to path
	
	
	
Function move() : cs._path_mover
	
	
	
	