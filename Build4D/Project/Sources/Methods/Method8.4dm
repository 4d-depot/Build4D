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
		
		var $webserver : Object
		
		$webserver:={}
		$webserver.configuration:={\
			http_port_number: 80; \
			https_port_number: 443; \
			allow_http: False; \
			allow_http_local: False; \
			allow_ssl: True; \
			automatic_session_management: True; \
			certificate_folder: ""; \
			listening_address: "0.0.0.0"; \
			publish_at_startup: True; \
			retry_with_next_ports: False; \
			reuse_context: True; \
			session_mode: 1; \
			html_root: "./WebFolder"; \
			home_page: "index.html"\
			}
		
		
		$webserver.options:={\
			cache_max_size: 524288; \
			cached_object_max_size: 512; \
			use_4d_web_cache: True; \
			web_processes: {max_concurrent: 100; timeout_for_inactives: 480; preemptive: False}; \
			web_passwords: {generic_web_user: 1; with_4d_passwords: False}; \
			text_conversion: {send_extended: False; standard_set: "UTF-8"}; \
			keep_alive: {requests_number: 100; timeout: 15; with_keep_alive: True}; \
			filters: {allow_4dsync_urls: False}; \
			cors: {enabled: True}\
			}
		
		
		$webserver.rest:={launch_at_startup: True}
		$webserver.soap:={name: ""; name_space: ""; enabled: False}
		
		$settings.sqlServerPort:=30000
		$settings.phpAddress:="10.16.17.18"
		$settings.phpPort:=15001
		$settings.webserver:=$webserver
		
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
