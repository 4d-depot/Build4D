property \
_source; \
_destination : Text


/** bad class name **/


Class constructor($source : Variant; $destination : Variant)
	
	
	This._source:=""
	This._destination:=""
	
	
	
	
Function get source : Text
	
	return This._source
	
	
	
Function set source($source : Variant)
	
	Case of 
			
		: (Value type($source)=Is text)
			This._source:=$source
			
			
		: (Value type($source)#Is object)
			
			
		: (OB Instance of($source; 4D.File))
			
			This._source:=$source.path
			
			
	End case 
	
	
	
Function get destination : Text
	
	return This._destination
	
	
	
Function set destination($destination : Variant)
	
	Case of 
			
		: (Value type($destination)=Is text)
			This._destination:=$destination
			
			
		: (Value type($destination)#Is object)
			
			
		: (OB Instance of($destination; 4D.File))
			
			This._destination:=$destination.path
			
			
	End case 
	
	
	