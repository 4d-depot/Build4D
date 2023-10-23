//%attributes = {}

var $name : Text
var $file : 4D.File
var $zip : 4D.ZipArchive



$name:=Select document(""; ""; ""; 0)


Case of 
	: (Error#0)
		
	: (OK=0)
		
	: (Test path name(document)#Is a document)
		
	Else 
		
		
		$file:=File(document; fk platform path)
		
		
		$zip:=ZIP Read archive($file)
		
		
End case 