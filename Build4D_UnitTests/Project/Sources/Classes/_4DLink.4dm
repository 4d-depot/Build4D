
Class constructor($f : 4D.File)
	
	
	This._isValid:=False
	This._file:=$f
	This._attributs:={}
	
	If (OB Instance of(This._file; 4D.File))
		
		If (This._file.exists)
			var $buffer : Text
			var $root : Text
			var $db_tag : Text
			var $name; $value : Text
			var $i; $n : Integer
			
			var $save_ok; $save_error : Integer
			
			$save_ok:=OK
			$save_error:=Error
			
			OK:=1
			Error:=0
			
			$buffer:=This._file.getText()
			
			$root:=DOM Parse XML variable($buffer)
			
			Case of 
					
				: (OK=0)
				: (Error#0)
					
				Else 
					
					$db_tag:=DOM Find XML element($root; "/database_shortcut")
					
					Case of 
							
						: (OK=0)
						: (Error#0)
							
						Else 
							$n:=DOM Count XML attributes($db_tag)
							For ($i; 1; $n)
								DOM GET XML ATTRIBUTE BY INDEX($db_tag; $i; $name; $value)
								
								This._attributs[$name]:=$value
								
							End for 
							
							
					End case 
					
					
					DOM CLOSE XML($root)
			End case 
			
			This._isValid:=(OK=1) & (Error=0)
			
			OK:=$save_ok
			Error:=$save_error
			
		End if 
		
	End if 
	
	
	
Function get is_valid : Boolean
	return This._isValid
	
	
Function get is_remote : Boolean
	If (This._isValid) && (Value type(This._attributs.is_remote)=Is text)
		return This._attributs.is_remote="true"
	End if 
	
	
Function get has_database_name : Boolean
	return (This._isValid) && (Value type(This._attributs.server_database_name)=Is text)
	
	
Function get has_path : Boolean
	return (This._isValid) && (Value type(This._attributs.server_path)=Is text)
	
	
Function get has_port : Boolean
	return This.port>0
	
	
Function get has_user_name : Boolean
	return (This._isValid) && (Value type(This._attributs.user_name)=Is text)
	
	
Function get has_password : Boolean
	return (This._isValid) && (Value type(This._attributs.password)=Is text)
	
	
Function get has_md5_password : Boolean
	return (This._isValid) && (Value type(This._attributs.md5_password)=Is text)
	
	
Function get has_cache_folder_name : Boolean
	return (This._isValid) && (Value type(This._attributs.cache_folder_name)=Is text)
	
	
Function get has_structure_opening_mode : Boolean
	return (This._isValid) && (Value type(This._attributs.structure_opening_mode)=Is text)
	
Function get has_open_login_dialog : Boolean
	return (This._isValid) && (Value type(This._attributs.open_login_dialog)=Is text)
	
	//mark:-
	
Function get database_name : Text
	If (This.has_database_name)
		return This._attributs.server_database_name
	End if 
	
	
Function get path : Text
	If (This.has_path)
		return This._attributs.server_path
	End if 
	
	
Function get port : Integer
	var $_ : Collection
	
	$_:=Split string(This.path; ":")
	
	If ($_.length>0)
		return Num($_[1])
	End if 
	
	
Function get ip : Text
	
	var $_ : Collection
	
	$_:=Split string(This.path; ":")
	
	If ($_.length>0)
		return $_[0]
	End if 
	
	
Function get user_name : Text
	If (This.has_user_name)
		return This._attributs.user_name
	End if 
	
Function get password : Text
	If (This.has_password)
		return This._attributs.password
	End if 
	
	
Function get md5_password : Text
	If (This.has_md5_password)
		return This._attributs.md5_password
	End if 
	
	
Function get cache_folder_name : Text
	If (This.has_cache_folder_name)
		return This._attributs.cache_folder_name
	End if 
	
	//Function get interpreted : Boolean
	//If (This._isValid) && (This._attributs.structure_opening_mode#Null)
	//return Num(This._attributs.structure_opening_mode)=1
	//End if 
	
	//Function get compiled : Boolean
	//If (This._isValid) && (This._attributs.structure_opening_mode#Null)
	//return Num(This._attributs.structure_opening_mode)=2
	//End if 
	
Function get structure_opening_mode : Integer
	If (This.has_structure_opening_mode)
		return Num(This._attributs.structure_opening_mode)
	End if 
	
	
Function get open_login_dialog : Boolean
	If (This.has_open_login_dialog)
		return This._attributs.open_login_dialog="true"
	Else 
		return True
	End if 
	
	