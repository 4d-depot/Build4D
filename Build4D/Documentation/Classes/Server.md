<!-- Type your summary here -->
## Description

This class allows you to create a server application. It is composed of the following:

* a [Class constructor](#class-constructor)
* a [build()](#build) function

### Class constructor

```4D
Class constructor($customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $customSettings | Object | in | $customSettings is a custom settings object overriding target default settings stored in the "/RESOURCES/Server.json" file. |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|        
|buildName | String | Name of the target build, defined by the component if missing in the custom settings.|
|publishName | String | Name of the publication name. If undefined, the buildName is used.|
|<b>publishPort<b> | Integer | Remote connection publication port. If undefined, the port defined in project is used.|
|projectFile | File or String | Project file (relative to the open project/absolute/filesystem). Pass the project file path if you want to build an external project (not necessary if building the current project).|
|destinationFolder | Folder or String | Folder where the build will be generated (relative to the open project/absolute/filesystem), defined by the component if missing in the custom settings. Its contents are deleted before each build.|
|sourceAppFolder| Folder or String | Folder of the 4D Server (relative to the open project/absolute/filesystem).|
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if it is not null. For more details about the object format, read the documentation of the Compile project command.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|obfuscated | Boolean | True if the 4DZ is to not be dezippable.|
|lastDataPathLookup| String | Defines the way the application stores its link with the last data file. Possible values: "ByAppName" (Default value) and "ByAppPath".|
|useSDI| Boolean | Allows to use the SDI interface mode instead of the MDI (Windows only).|
|startElevated| Boolean | Allows to start the Updater with elevated privileges (Windows only).|
|iconPath| File or String | File path of the icon to be used instead of the 4D Volume Desktop icon.|
|hideDataExplorerMenuItem| Boolean | True if the Data Explorer menu item is hidden.|
|hideRuntimeExplorerMenuItem| Boolean | True if the Runtime explorer menu item is hidden.|
|hideAdministrationWindowMenuItem| Boolean | True if the Administration Window menu item is hidden.|
|serverDataCollection| Boolean | True to disable the automatic data collection.|
|clientWinSingleInstance| Boolean | True if only a single instance of the Client application can be launched on Windows (Windows only).|
|currentVers| Number | Allows you to specify the current version number of the built application (Default value 1).|
|rangeVersMin| Number | Allows you to specify the minimum Client version (Default value 1).|
|rangeVersMax| Number | Allows you to specify the maximum Client version (Default value 1).|
|hardLink| Number | To create a hard link between client and serveer (Default value "").|
|serverStructureFolderName| String | Allows to define a custom name for the cache folder of the built server application.|
|<b><u>versioning</u></b>| Object | Object containing the contents of the application information.|
|<i>versioning</i>.<b>version</b>| String | Version number. |
|<i>versioning</i>.<b>copyright</b>| String | Copyright text. |
|<i>versioning</i>.<b>companyName</b>| String | Company name. |
|<i>versioning</i>.<b>fileDescription</b>| String | Description (Windows only).|
|<i>versioning</i>.<b>internalName</b>| String | Internal name (Windows only).|
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | Folder, File, or String | Source folder or file path (relative to the open project/absolute/filesystem).|
|includePaths[].destination | Folder, File, or String | Destination folder path (relative to the built project/absolute/filesystem).|
|deletePaths[] | Collection of Folder, File, or Strings | Collection of paths to folders and files to be deleted (relative to the built project/absolute/filesystem strings).|
|excludeModules| Collection of Strings | Collection of module names to exclude from final application. The module names can be found in the "BuildappOptionalModules.json" file in the resources of the 4D application.|
|macCompiledProject| Folder or String | Specifies the path to the folder containing the structure compiled on macOS for silicon and Intel.|
|macOSClientArchive| Folder or String | Specifies the path of the .4darchive macOS file to be integrated into the built server application.|
|windowsClientArchive| Folder or String | Specifies the path of the .4darchive Windows file to be integrated into the built server application.|
|<b>license</b>| File or String | 4D OEM Server license file (relative to the built project/absolute/filesystem) or following constant : <u>License Automatic mode</u>, <u>License Evaluation mode</u>.|
|xmlKeyLicense| File or String | 4D OEM XML Keys license file (relative to the built project/absolute/filesystem).|
|<b><u>signApplication</u></b>| Object | Object containing the contents of the application signing.|
|<i>signApplication</i>.<b>macSignature</b> | Boolean | Signs the built applications.|
|<i>signApplication</i>.<b>macCertificate</b> | String | Certificate name used for signature.|
|<i>signApplication</i>.<b>adHocSignature</b> | Boolean | Signs the built applications with AdHoc signature if macSignature not performed.|
|logger | Formula | Formula called when a log is written.|
|<b>allowUserSettings</b> | Boolean | Allow user to define server settings https://developer.4d.com/docs/settings/overview.|
|<b>sqlServerPort</b> | Integer |SQL Server publication port. If undefined, the port defined in project is used.|
|<b>phpAddress</b> | String |PHP server address. If undefined, the address defined in project is used.|
|<b>sqlServerPort</b> | Integer |PHP Server port. If undefined, the port defined in project is used.|
|<b>listeners</b> | Object |Web, Rest, Web Services and options configuration show description below.|
 

### <u>Listeners</u>
| Attributes | Type | Description |
|---|---|---|        
|web | Object | Web Server configuration.|
|options | Object | Web Server option.|
|rest | Object | Rest Server configuration|
|webService | Object | Web Service configuration|


see : https://developer.4d.com/docs/settings/web

### <u>Web Server configuration</u>
| Attributes | Type | Description |
|---|---|---| 
|publish_at_startup | Boolean | Start web server on startup database.|
|listening_address | String | Specific IP address web server.|
|http_port_number | Integer | Http port listener number.|
|https_port_number | Integer | Https port listener number.|
|allow_http | Boolean | Accept incomming http query.|
|allow_http_local | Boolean | Accept local incomming http query.|
|allow_ssl | Boolean | Accept SSL for https query.|
|automatic_session_management | Boolean | Enable automatic session maanagement.|
|certificate_folder | String | Folder path where certificates are located.|
|reuse_context | Boolean | Allow web server to reuse web context.|
|html_root | String | Path of the web folder.|
|home_page | String | Name of the root web page.|


### <u>Web Server options</u>
| Attributes | Type | Description |
|---|---|---| 
|cache_max_size | Integer | .|
|cached_object_max_size | Integer | .|
|use_4d_web_cache | Boolean | .|
|<b><u>text_conversion</u></b> | Object | .|
|<i>text_conversion</i>.<b>send_extended</b> | Boolean | .|
|<i>text_conversion</i>.<b>standard_set</b> | String | .|
|<b><u>web_processes</u></b> | Object | .|
|<i>web_processes</i>.<b>max_concurrent</b> | Integer | .|
|<i>web_processes</i>.<b>timeout_for_inactives</b> | Integer | .|
|<i>web_processes</i>.<b>preemptive</b> | Boolean | .|
|<b><u>web_passwords</u></b> | Object | .|
|<i>web_passwords</i>.<b>generic_web_user</b> | Integer | .|
|<i>web_passwords</i>.<b>with_4d_passwords</b> | Boolean | .|
|<b><u>keep_alive</u></b> | Object | .|
|<i>keep_alive</i>.<b>requests_number</b> | Integer | .|
|<i>keep_alive</i>.<b>timeout</b> | Integer | .|
|<i>keep_alive</i>.<b>with_keep_alive</b> | Boolean | .|
|<b><u>filters</u></b> | Object | .|
|<i>filters</i>.<b>allow_4dsync_urls</b> | Boolean | .|
|<b><u>cors</u></b> | Object | .|
|<i>cors</i>.<b>enabled</b> | Boolean | .|


### <u>Rest Server configuration</u>
| Attributes | Type | Description |
|---|---|---| 
|launch_at_startup | Boolean | Start rest server on startup database.|


### <u>Web Service configuration</u>
| Attributes | Type | Description |
|---|---|---| 
|enabled | Boolean | Enable Web Service.|
|name | String | Web Service name ex : A_WebService.|
|name_space | String | Web Service namespace ex : http://www.4d.com/namespace/default .|


## Member Functions

### build()

```4D
Function build() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the server has been correctly executed.|

Builds the server application.

## Example

This code is an example to generate a server application from an external project.

```4D
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean

$settings:={}

// Define the external project file 
$settings.projectFile:=Folder(fk documents folder).file("Contact/Project/Contact.4DProject") 

// Configure the application
$settings.buildName:="myApp" 
$settings.destinationFolder:="Test/Server/" 
$settings.obfuscated:=True 
$settings.lastDataPathLookup:="ByAppPath"

// Specify the components required for compilation
$componentsFolder:=Folder(fk documents folder).folder("4D v20.0/4D.app/Contents/Components")
$components:=[]
$components.push($componentsFolder.file("4D WritePro Interface.4dbase/4D WritePro Interface.4DZ"))

$compilationTarget:=(Is macOS) ? [Compilation for x86; Compilation for ARM] : [Compilation for x86]

$settings.compilerOptions:={components: $components ; targets: $compilationTarget}

// Define the 4D Server path
$settings.sourceAppFolder:=Folder(fk documents folder).folder("4D v20.0/4D Server.app")

// Delete the unnecessary module 
$settings.excludeModules:=["CEF"; "MeCab"]

// Include the folders and files
$settings.includePaths:=[] 
$settings.includePaths.push({source: $componentsFolder.folder("4D WritePro Interface.4dbase").path; destination: "../Components/"})
$settings.includePaths.push({source: $componentsFolder.folder("4D SVG.4dbase").path; destination: "../Components/"})

// Delete the folders and files 
$settings.deletePaths:=[] 
$settings.deletePaths.push("Resources/Dev/")

// Add the application icon 
$settings.iconPath:="/RESOURCES/myIcon.icns"

// Add the application information 
$settings.versioning:={} 
$settings.versioning.version:="version" 
$settings.versioning.copyright:="copyright" 
$settings.versioning.companyName:="companyName" 

// Create the deployment license file
$settings.license:=Folder(fk licenses folder).file("XXXXX.license4D")
$settings.xmlKeyLicense:=Folder(fk licenses folder).file("XXXXX.license4D")

// Sign the macOS appplication 
$settings.signApplication:={} 
$settings.signApplication.macSignature:=True 
$settings.signApplication.macCertificate:="xxxxxx"

// Launch the build
$build:=cs.Build4D.Server.new($settings) 
$success:=$build.build()
```
