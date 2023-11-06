//%attributes = {}



var $cs : cs.CS

var $server : Object
var $mac : Object
var $win : Object

var $signApplication : Object


$server:={}
$mac:={}
$win:={}



//$server.hardLink:="toto"
$server.IPAddress:=""
//$server.portNumber:=29814


$mac.singleInstance:=True
/*

//$win.singleInstance:=True


$server.obfuscated:=False
$server.useSDI:=False

*/

//mark:-  DESTINATION FOLDER

$server.destinationFolder:="../Test/Dominique/"

//mark:-  RUNTIMES

$mac.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Volume Desktop MAC/4D Volume Desktop.app/"

$win.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Server MAC/4D Server.app/"

//mark:-  PATHS

//$server.deletePaths:=[]
//$server.deletePaths.push("../Components/4D SVG.4dbase")

//$mac.deletePaths:=[]
//$mac.deletePaths.push("../Components/4D SVG.4dbase")

//$win.deletePaths:=[]
//$win.deletePaths.push("../Components/4D SVG.4dbase")


//mark:-  EMBEDDED CLIENTS

//$mac.databaseToEmbedInClient:="../ConnectingDB_Build/ConnectingDB/ConnectingDB.4DZ"
//$win.databaseToEmbedInClient:="../ConnectingDB_Build/ConnectingDB/ConnectingDB.4DZ"


//mark:-  SIGNATURE
/*
$signApplication:={\
macSignature: True; \
macCertificate: "Dominique Delahaye"\
}
$server.signApplication:=$signApplication
*/


// Sign the macOS appplication 
$server.signApplication:={}
$server.signApplication.adHocSignature:=True



$server.obfuscated:=False
$server.useSDI:=False

$cs:=cs.CS.new($server; $mac)  //; $win) // mac only

If ($cs.build())
	
	
	$cs.show()
	
	
End if 



