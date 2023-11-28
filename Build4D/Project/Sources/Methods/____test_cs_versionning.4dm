//%attributes = {}



var $cs : cs.CS

var $server : Object
var $mac : Object
var $win : Object

var $zips : Object

var $signApplication : Object


$server:={}
$mac:={}
$win:={}


$server.rangeVersMin:=1
$server.rangeVersMax:=1
$server.currentVers:=1

$mac.rangeVersMin:=1
$mac.rangeVersMax:=1
$mac.currentVers:=1


$win.rangeVersMin:=1
$win.rangeVersMax:=1
$win.currentVers:=1


//mark:-  RUNTIMES

$mac.sourceAppFolder:="/Applications/4D v20.2/4D Volume Desktop MAC/4D Volume Desktop.app/"

$win.sourceAppFolder:="/Applications/4D v20.2/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.2/4D Server MAC/4D Server.app/"



//mark:-  SIGNATURE

$server.signApplication:={}
$server.signApplication.adHocSignature:=True


$server.signApplication:=$signApplication
$mac.signApplication:=$signApplication
$win.signApplication:=$signApplication  // juste pour tester l'impact

$cs:=cs.CS.new($server; $mac; $win)

If ($cs.build())
	
	
	$cs.show()
	
	$zips:=$cs._buildZip()
	
	
	
End if 



