//%attributes = {}

var $settings : Object

var $standalone : cs.Standalone


var $componentsFolder : 4D.Folder



$settings:={}

//MANDATORY SETTINGS
$settings.license:=File("/PACKAGE/Settings/4UUD.license4D")
$settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop MAC/4D Volume Desktop.app/"
$settings.destinationFolder:="./Test/"

// PATHS
$componentsFolder:=Folder(fk applications folder).folder("4D v20.0/4D.app/Contents/Components")

$settings.includePaths:=[]
$settings.includePaths.push({source: $componentsFolder.folder("4D WritePro Interface.4dbase").path; destination: "../Components/"})
$settings.includePaths.push({source: $componentsFolder.folder("4D SVG.4dbase").path; destination: "../Components/"})


$standalone:=cs.Standalone.new($settings)


If ($standalone.build())
	
	
	
End if 