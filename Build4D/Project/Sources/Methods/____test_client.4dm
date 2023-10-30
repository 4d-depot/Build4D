//%attributes = {}


// https://github.com/orgs/4d/projects/119?pane=issue&itemId=32074136

var \
$client : cs.Client

var \
$ws_settings : Object

var \
$componentsFolder : 4D.Folder

$ws_settings:={\
startElevated: False; \
useSDI: False; \
serverSelectionAllowed: True; \
singleInstance: True; \
rangeVersMin: 1; \
rangeVersMax: 1; \
currentVers: 1; \
hardLink: ""; \
excludeModule: []; \
includePaths: []; \
deletePaths: []; \
signApplication: Null; \
IPAdress: ""; \
portNumber: 19813\
}

$ws_settings.signApplication:={\
macSignature: True; \
macCertificate: "Dominique Delahaye"; \
adHocSignature: True\
}


$ws_settings.serverSelectionAllowed:=True

$ws_settings.clientUserPreferencesFolderByPath:=True
$ws_settings.ClientServerSystemFolderName:="myBeautifullApp"

$ws_settings["//target"]:="Client"

$ws_settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop MAC/4D Volume Desktop.app/"

$componentsFolder:=Folder(fk applications folder).folder("4D v20.0/4D.app/Contents/Components")

$ws_settings.includePaths:=[]
$ws_settings.includePaths.push({source: $componentsFolder.folder("4D WritePro Interface.4dbase").path; destination: "../Components/"})
$ws_settings.includePaths.push({source: $componentsFolder.folder("4D SVG.4dbase").path; destination: "../Components/"})




$client:=cs.Client.new($ws_settings)



If ($client.build())
	
	
	
	var $result : Object
	
	$result:=$client.buildArchive()
	
	If ($result.success)
		
		SHOW ON DISK($result.archive.platformPath)
		
		
	End if 
	
	
Else 
	
	ALERT("Build client failed !")
End if 

