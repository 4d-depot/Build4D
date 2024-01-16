property \
_address; \
_databaseName : Text

property \
_port : Integer

property \
_openLoginDialog : Boolean


Class constructor($setting : Object)
	
	This._address:=""
	This._port:=0x4D65
	This._databaseName:=""
	This._openLoginDialog:=False
	
	
	This.load_settings($setting)
	
	//mark:-
	// getters
	
	
Function get address : Text
	return This._address
	
	
	
Function get port : Integer
	return This._port
	
	
	
Function get databaseName : Text
	return This._databaseName
	
	
	
Function get openLoginDialog : Boolean
	return This._openLoginDialog
	
	
	
	//mark:-
	// setters
	
	
Function set address($address : Text)
	This._address:=$address
	
	
	
Function set port($port : Integer)
	If ($port>0)
		This._port:=$port
	End if 
	
	
	
Function set databaseName($name : Text)
	This._databaseName:=$name
	
	
	
Function set openLoginDialog($open : Boolean)
	This._openLoginDialog:=$open
	
	
	
	//mark:-
	// member functions
	
Function load_settings($setting : Object) : cs._clientApplication
	
	var $key : Text
	var $settings : Object
	
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
	
	$settings:={\
		address: This._address; \
		port: This._port; \
		databaseName: This._databaseName; \
		openLoginDialog: This._openLoginDialog\
		}
	
	return $settings
	
	
	//mark:-
	
	
Function make4D_link($folder : 4D.Folder) : Boolean
	
	var $xml; $text : Text
	var $file : 4D.File
	
	Case of 
			
		: (Count parameters<1)
			
		: (Not(OB Instance of($folder; 4D.Folder)))
			
		Else 
			
			$xml:=DOM Create XML Ref("database_shortcut")
			
			DOM SET XML ATTRIBUTE($xml; \
				"is_remote"; "true"; \
				"server_database_name"; This._databaseName; \
				"server_path"; This._address+":"+String(This._port); \
				"open_login_dialog"; This._openLoginDialog)
			
			DOM EXPORT TO VAR($xml; $text)
			DOM CLOSE XML($xml)
			
			
			$file:=$folder.file("EnginedServer.4Dlink")
			
			If ($file.create())
				
				$file.setText($text)
				
				return True
				
			Else 
				
				//This._log(New object(\
															"function"; "Create 4DLink"; \
															"message"; "Unable to create 4DLink: '"+This._databaseName+"'"; \
															"severity"; Error message))
				
			End if 
	End case 
	
	
	return False
	
	
	