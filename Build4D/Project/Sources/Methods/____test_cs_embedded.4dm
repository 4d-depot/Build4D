//%attributes = {}



var $cs : cs.CS

var $server : Object
var $mac : Object
var $win : Object



$server:={}
$mac:={}
$win:={}




$server.buildName:="myFabulousApp"
$server.publishName:="myPublishName"
$server.hardLink:="meineStarkeVerbindung"

$server.useSDI:=False
$server.obfuscated:=False

$server.portNumber:=29813  // attention le numéro de port est fixé dans les settings de la base. il n'existe pas de clef pour le fixer par code
$server.IPAddress:="192.168.75.13"

$mac.singleInstance:=True
/*

//$win.singleInstance:=True



*/

//mark:-  DESTINATION FOLDER

$server.destinationFolder:="../Test/Dominique/"

//mark:-  RUNTIMES

$mac.sourceAppFolder:="/Applications/4D v20.2/4D Volume Desktop MAC/4D Volume Desktop.app/"

$win.sourceAppFolder:="/Applications/4D v20.2/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.2/4D Server MAC/4D Server.app/"

//mark:-  PATHS


var $source : 4D.File
var $path : Object
var $package : 4D.Folder


$package:=Folder(Folder("/PACKAGE/").platformPath; fk platform path)

$source:=$package.parent.file("README.md")

$path:={\
source: $source.path; \
destination: "/Ressources"\
}

$server.includePaths:=[$path]

$server.deletePaths:=[]
$server.deletePaths.push("../Components/4D Widgets.4dbase")
$server.deletePaths.push("../Components/4D Progress.4dbase")
$server.deletePaths.push("../Components/4D WritePro Interface.4dbase")

//$mac.deletePaths:=[]
//$mac.deletePaths.push("../Components/4D SVG.4dbase")

//$win.deletePaths:=[]
//$win.deletePaths.push("../Components/4D SVG.4dbase")


//mark:-  EMBEDDED CLIENTS

//$mac.databaseToEmbedInClient:="../ConnectingDB_Build/ConnectingDB/ConnectingDB.4DZ"
//$win.databaseToEmbedInClient:="../ConnectingDB_Build/ConnectingDB/ConnectingDB.4DZ"


//mark:-  SIGNATURE

$server.signApplication:={}
$server.signApplication.adHocSignature:=True


$cs:=cs.CS.new($server; $mac)  //; $win) // mac only

If ($cs.build())
	
	
	$cs.show()
	
	
End if 



