//%attributes = {}

var $_volume; $_path : Collection
var $i : Integer

var $core : cs._core
var $badPath : 4D.Folder



$core:=cs._core.new()


$badPath:=Folder("toto"; fk platform path)

$_path:=[]
$_volume:=Get system info.volumes

For ($i; 0; $_volume.length-1)
	
	//$path:=
	
	$_volume[$i].path:=Folder($_volume[$i].mountPoint)
	
	//$_path.push($path)
	
End for 

//var $size; $used; $free : Real
ARRAY TEXT($_drives; 0)

VOLUME LIST($_drives)


//VOLUME ATTRIBUTES($path.fullName; $size; $used; $free)

