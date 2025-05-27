//%attributes = {}
var $build : cs.Standalone
var $settings : Object
var $success : Boolean
var $targets : Collection


$targets:=(Is macOS) ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]

$settings:={}

// Define the external project file 
$settings.compilerOptions:={targets: $targets}
$settings.projectFile:=Folder(fk desktop folder).file("/Users/4d/Desktop/Program/build4D/not exposed/source_db/Project/source.4DProject")

// Configure the application
$settings.buildName:="MyBestApp"
$settings.publishName:="MyBestServer"
$settings.publishPort:=29000

$settings.destinationFolder:=Folder(fk desktop folder).folder("/Users/4d/Desktop/Program/build4D/not exposed/Test/MyApp/")
//$settings.obfuscated:=False

$settings.lastDataPathLookup:="ByAppPath"

// à partir de la main only

$settings.signApplication:={}
//$settings.signApplication.adHocSignature:=True
$settings.signApplication.macSignature:=True
$settings.signApplication.macCertificate:="Developer ID Application: CEDRIC GAREAU (BSE3R8CQZT)"


//$settings.license:=License Evaluation mode

$settings.license:=License Automatic mode


Case of 
	: (False)
		// Define the embedded app path path
		$settings.sourceAppFolder:=Folder(Application file; fk platform path).parent.folder("4D Volume Desktop.app")
		
		// Launch the build
		$build:=cs.Standalone.new($settings)
		$success:=$build.build()
		
		If ($success)
			
			SHOW ON DISK($build.settings.destinationFolder.platformPath)
			ALERT("OK")
		Else 
			ALERT("KO")
		End if 
		
	: (True)
		
		
		
		$settings.sqlServerPort:=30000
		$settings.phpAddress:="10.16.17.18"
		$settings.phpPort:=15001
		
		
		$settings.sourceAppFolder:=Folder(Application file; fk platform path).parent.folder("4D Server.app")
		
		// Launch the build
		$build:=cs.Server.new($settings)
		$success:=$build.build()
		
		If ($success)
			
			SHOW ON DISK($build.settings.destinationFolder.platformPath)
			ALERT("OK")
		Else 
			ALERT("KO")
		End if 
		
End case 
