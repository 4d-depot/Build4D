ALERT:C41("Hello from hosted db")

CONFIRM:C162("connect ?"; "YES"; "NO")

If (ok=1)
	C_TEXT:C284($xml)
	C_OBJECT:C1216($link)
	$xml:="<?xml version=\"1.0\" encoding=\"UTF-8\"?><database_shortcut is_remote=\"true\" server_database_name=\"Build4D\" server_path=\":19813\"/>"
	$link:=Folder:C1567(fk user preferences folder:K87:10).file("server.4dlink")
	$link.setText($xml)
	OPEN DATABASE:C1321($link.platformPath)
	
End if 

//<?xml version="1.0"Encoding="UTF-8" ? ><database_shortcut is_remote="true"server_database_name="Build4D"server_path=":19813"/>