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




$mac.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Volume Desktop MAC/4D Volume Desktop.app/"

$win.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Volume Desktop WIN/"  //4D Volume Desktop.4DE"

$server.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Server MAC/4D Server.app/"



//mark:-  SIGNATURE

// Sign the macOS appplication 
$server.signApplication:={}
$server.signApplication.adHocSignature:=True


$cs:=cs.CS.new($server; $mac; $win)

If ($cs.build())
	
	
	$cs.show()
	
	$zips:=$cs._buildZip()
	
	
	
End if 



