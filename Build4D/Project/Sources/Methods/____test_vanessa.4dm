//%attributes = {}
//%attributes = {}
var $buildServer : cs.Server
var $buildClient : cs.Client
var $settings : Object
var $success : Boolean


//var $componentsFolder : 4D.Folder

//$componentsFolder:=Folder(fk documents folder).folder("bbb/4D v20.1/4D.app/Contents/Components/")

$settings:={}

// Configure the application
$settings.buildName:="myAppBuild"
$settings.publishName:="myAppBuild"
$settings.destinationFolder:="../Test/Vanessa/Client/"
$settings.singleInstance:=True
//$settings.serverSelectionAllowed:=True
$settings.hardLink:=""

// Define the 4D Volume Desktop path
//$settings.sourceAppFolder:=Folder(fk desktop folder).folder("4D v20.1/4D Volume Desktop.app")
$settings.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Volume Desktop MAC/4D Volume Desktop.app/"


// Include the folders and files
//$settings.includePaths:=[]
//$settings.includePaths.push({source: $componentsFolder.folder("4D WritePro Interface.4dbase").path; destination: "../Components/"})
//$settings.includePaths.push({source: $componentsFolder.folder("4D SVG.4dbase").path; destination: "../Components/"})

// Sign the macOS appplication 
$settings.signApplication:={}
$settings.signApplication.adHocSignature:=True

// Launch the build
$buildClient:=cs.Client.new($settings)
$success:=$buildClient.build()

var $archive : Object
$archive:=$buildClient.buildArchive()



//SERVER

$settings:={}

// Configure the application
$settings.buildName:="myAppBuild"
$settings.publishName:="myAppBuild"
$settings.destinationFolder:="../Test/Vanessa/Server/"
$settings.obfuscated:=False
$settings.useSDI:=False

// Client Archive
$settings.macOSClientArchive:=$archive.archive

// Define the 4D Server path
//$settings.sourceAppFolder:=Folder(fk desktop folder).folder("4D v20.1/4D Server.app")
$settings.sourceAppFolder:="/Applications/4D v20.1 HF1/4D Server MAC/4D Server.app/"

// Sign the macOS appplication 
$settings.signApplication:={}
$settings.signApplication.adHocSignature:=True

// Launch the build
$buildServer:=cs.Server.new($settings)
$success:=$buildServer.build()
