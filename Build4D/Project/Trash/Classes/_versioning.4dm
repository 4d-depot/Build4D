property \
version; \
copyright; \
companyName; \
fileDescription; \
internalName : Text


property \
rangeVersMin; \
rangeVersMax; \
currentVers : Integer


property \
hardLink; \
serverStructureFolderName : Text


Class constructor
	
	This.version:=""
	This.copyright:=""
	This.companyName:=""
	This.fileDescription:=""
	This.internalName:=""
	
	This.rangeVersMin:=0
	This.rangeVersMax:=0
	This.currentVers:=0
	
	This.hardLink:=""
	This.serverStructureFolderName:=""
	
	
	
Function load_settings($settings : Object) : cs._versioning
	
	var $key : Text
	
	Case of 
			
		: (Count parameters<1)
			
		: ($settings=Null)
			
		Else 
			
			For each ($key; $settings)
				
				If (This[$key]#Null)
					This[$key]:=$settings[$key]
				End if 
				
			End for each 
			
			
	End case 
	
	
	return This
	
	
	
Function save_settings : Object
	var $settings : Object
	
	$settings:={}
	
	return $settings
	