//%attributes = {"invisible":true}


var $xml; $server_name; $address : Text
var $link : 4D:C1709.File


$server_name:=Request:C163("Server Name ?")


Case of 
		
	: (OK=0)
		
	: ($server_name="")
		
	Else 
		
		$address:=Request:C163("Server path : (name/ip) : port ")
		
		Case of 
				
			: (OK=1)
				
			: ($address="")
				
			Else 
				
				$xml:="<?xml version=\"1.0\" encoding=\"UTF-8\"?><database_shortcut is_remote=\"true\" server_database_name=\""+$server_name+"\" server_path=\""+$address+"\"/>"
				
				$link:=Folder:C1567(fk user preferences folder:K87:10).file("server.4dlink")
				
				$link.setText($xml)
				
				OPEN DATABASE:C1321($link.platformPath)
				
				
				
		End case 
End case 