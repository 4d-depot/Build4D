//%attributes = {}


// https://github.com/orgs/4d/projects/119?pane=issue&itemId=32074136

var \
$client : cs.Client

var \
$ws_settings : Object


$ws_settings:={\
startElevated: False; \
useSDI: False; \
serverSelectionAllowed: False; \
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

$ws_settings["//target"]:="Client"

$ws_settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop MAC/4D Volume Desktop.app/"


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

