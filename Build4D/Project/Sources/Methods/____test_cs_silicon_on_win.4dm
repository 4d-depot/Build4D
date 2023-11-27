//%attributes = {}



var $cs : cs.CS

var $server : Object
var $mac : Object
var $win : Object

var $signApplication : Object


$server:={}

//mark:-  DESTINATION FOLDER

$server.destinationFolder:="../Test/Dominique/"

//mark:-  RUNTIMES

//$win.sourceAppFolder:="/Applications/4D v20.2/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.2/4D Server MAC/4D Server.app/"


//mark:- SILICON CODE INTO WINSERVER  requirement #2061

// copier dans "server database" le dossier library
$server.macCompiledProject:=Folder(Folder("/PACKAGE/").platformPath; fk platform path).parent.folder("Mac Compiled Database - #2061/Build4D/").path




//mark:-  SIGNATURE

// Sign the macOS appplication 
$server.signApplication:={}
$server.signApplication.adHocSignature:=True



$cs:=cs.CS.new($server)

If ($cs.build())
	
	
	$cs.show()
	
	
End if 



