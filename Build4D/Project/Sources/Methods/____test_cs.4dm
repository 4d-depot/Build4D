//%attributes = {}



var $cs : cs.CS

var $server : Object
var $mac : Object
var $win : Object

var $signApplication : Object


$server:={}
$mac:={}
$win:={}



$signApplication:={\
macSignature: True; \
macCertificate: "Dominique Delahaye"\
}

$mac.sourceAppFolder:="/Applications/4D v20.1/4D Volume Desktop MAC/4D Volume Desktop.app/"

$win.sourceAppFolder:="/Applications/4D v20.1/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.1/4D Server MAC/4D Server.app/"


$server.deletePaths:=[]
$server.deletePaths.push("../Components/4D SVG.4dbase")

$mac.deletePaths:=[]
$mac.deletePaths.push("../Components/4D SVG.4dbase")

$win.deletePaths:=[]
$win.deletePaths.push("../Components/4D SVG.4dbase")



$server.signApplication:=$signApplication
$mac.signApplication:=$signApplication
$win.signApplication:=$signApplication  // juste pour tester l'impact

$cs:=cs.CS.new($server; $mac; $win)

If ($cs.build())
	
	
	$cs.show()
	
	
End if 



