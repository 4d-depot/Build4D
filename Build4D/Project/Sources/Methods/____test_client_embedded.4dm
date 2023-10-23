//%attributes = {}


var $settings : Object

var $client : cs.Client


$settings:={}



$settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop WIN/"
$settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop MAC/4D Volume Desktop.app/"


$settings.databaseToEmbedInClient:="../ConnectingDB_Build/ConnectingDB/ConnectingDB.4DZ"

$client:=cs.Client.new($settings)




If ($client.build())
	
	$client._show()
	
	
	
	
	//var $result : Object
	
	//$result:=$client.buildArchive()
	
	//If ($result.success)
	
	//SHOW ON DISK($result.archive.platformPath)
	
	
	//End if 
	
Else 
	
	
End if 


