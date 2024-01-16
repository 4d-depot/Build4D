//%attributes = {}


var $win : Object

var $client : cs.Client


$win:={}



$win.sourceAppFolder:="/Applications/4D v20.1/4D Volume Desktop WIN/"


$client:=cs.Client.new($win)




If ($client.build())
	
	$client._show()
	
	
	
	
	var $result : Object
	
	$result:=$client.buildArchive()
	
	If ($result.success)
		
		SHOW ON DISK($result.archive.platformPath)
		
		
	End if 
	
	
	
	
End if 


