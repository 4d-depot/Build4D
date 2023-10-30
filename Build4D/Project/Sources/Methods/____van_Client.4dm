//%attributes = {}
var $build : cs.Client
var $settings : Object
var $success : Boolean

$settings:={}

// Define the external project file 
//$settings.projectFile:=Folder(fk documents folder).file("Contact/Project/Contact.4DProject")

// Configure the application
$settings.buildName:="myApp"
$settings.destinationFolder:="Test/"
$settings.startElevated:=False
$settings.useSDI:=False
$settings.singleInstance:=True
$settings.clientServerSystemFolderName:="rety"
$settings.clientUserPreferencesFolderByPath:=True
$settings.serverSelectionAllowed:=False
$settings.currentVers:=2
$settings.rangeVersMin:=2
$settings.rangeVersMax:=2

// Define the 4D Volume Desktop path
$settings.sourceAppFolder:="/Applications/4D v20.0/4D Volume Desktop MAC/4D Volume Desktop.app/"  //Folder(fk documents folder).folder("Boulot/4D v20.1/4D Volume Desktop.app")

// Delete the unnecessary module 
//$settings.excludeModules:=["CEF"; "MeCab"]

// Include the folders and files
var $componentsFolder : 4D.Folder
$componentsFolder:=Folder(fk applications folder).folder("4D v20.0/4D.app/Contents/Components")
$settings.includePaths:=[]
$settings.includePaths.push({source: $componentsFolder.folder("4D WritePro Interface.4dbase").path; destination: "../Components/"})
$settings.includePaths.push({source: $componentsFolder.folder("4D SVG.4dbase").path; destination: "../Components/"})

// Delete the folders and files 
//$settings.deletePaths:=[]
//$settings.deletePaths.push("../Components/4D SVG.4dbase")
//$settings.deletePaths.push("../Components/4D NetKit.4dbase")  

// Add the application icon 
$settings.iconPath:=File("/RESOURCES/Build4D.icns")

// Add the application information 
//$settings.versioning:={}
//$settings.versioning.version:="version"
//$settings.versioning.copyright:="copyright"
//$settings.versioning.companyName:="companyName"

// Sign the macOS appplication 
$settings.signApplication:={}
//$settings.signApplication.macSignature:=True
$settings.signApplication.adHocSignature:=True

// Launch the build
$build:=cs.Client.new($settings)
$success:=$build.build()
