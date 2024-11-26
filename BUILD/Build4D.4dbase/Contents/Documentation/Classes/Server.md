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
|versioning| Object | Object containing the contents of the application information.|
|versioning.version| String | Version number. |
|versioning.copyright| String | Copyright text. |
|versioning.companyName| String | Company name. |
|versioning.fileDescription| String | Description (Windows only).|
|versioning.internalName| String | Internal name (Windows only).|
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | Folder, File, or String | Source folder or file path (relative to the open project/absolute/filesystem).|
|includePaths[].destination | Folder, File, or String | Destination folder path (relative to the built project/absolute/filesystem).|
|deletePaths[] | Collection of Folder, File, or Strings | Collection of paths to folders and files to be deleted (relative to the built project/absolute/filesystem strings).|
|excludeModules| Collection of Strings | Collection of module names to exclude from final application. The module names can be found in the "BuildappOptionalModules.json" file in the resources of the 4D application.|
|macCompiledProject| Folder or String | Specifies the path to the folder containing the structure compiled on macOS for silicon and Intel.|
|macOSClientArchive| Folder or String | Specifies the path of the .4darchive macOS file to be integrated into the built server application.|
|windowsClientArchive| Folder or String | Specifies the path of the .4darchive Windows file to be integrated into the built server application.|
|license| File or String | 4D OEM Server license file (relative to the built project/absolute/filesystem).|
|xmlKeyLicense| File or String | 4D OEM XML Keys license file (relative to the built project/absolute/filesystem).|
|signApplication| Object | Object containing the contents of the application signing.|
|signApplication.macSignature | Boolean | Signs the built applications.|
|signApplication.macCertificate | String | Certificate name used for signature.|
|signApplication.adHocSignature | Boolean | Signs the built applications with AdHoc signature if macSignature not performed.|
|logger | Formula | Formula called when a log is written.|
 

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
$settings.compilerOptions:={components: $components}

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
