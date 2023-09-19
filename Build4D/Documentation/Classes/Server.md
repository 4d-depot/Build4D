<!-- Type your summary here -->
## Description

This class allows you to create a server application. It is composed of the following:

* a [Class constructor](#class-constructor)
* a [\_renameExecutable](#renameExecutable) function
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
|publishName | String | Name of the publication name, defined by the component if missing in the custom settings.|
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if it is not null. For more details about the object format, read the documentation of the Compile project command.|
|iconPath| File or String | File path of the icon to be used instead of the 4D Volume Desktop icon.|
|startElevated| Boolean | Allows to start the Updater with elevated privileges (Windows only).|
|obfuscated | Boolean | True if the 4DZ is to not be dezippable.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|lastDataPathLookup | String | "byAppName" (default value) or "byAppPath" |
|hideDataExplorerMenuItem | Boolean | Hide the Data Explorer item menu |
|hideRuntimeExplorerMenuItem | Boolean | Hide Runtime Explorer item menu |
|hideAdministrationWindowMenuItem | Boolean | Hide Administration Window item menu |
|serverDataCollection | Boolean | Disable the automatic data collection |
|singleInstance | Boolean | Allow multiple or single instances of the client  |
|sourceAppFolder| Folder or String | Folder of the 4D Server (relative to the open project/absolute/filesystem).|
|destinationFolder | Folder or String | Folder where the build will be generated (relative to the open project/absolute/filesystem), defined by the component if missing in the custom settings.|
|rangeVersMin| number | default value 1. |
|rangeVersMax| number | default value 1. |
|currentVers| number | default value 1. |
|hardLink| string | default value "". |
|serverStructureFolderName| string |  |
|macCompiledProject| string | the path to the folder containing the structure compiled on macOS for silicon |
|macOSClientArchive| string | access path of the .4darchive macOS |
|windowsClientArchive| string | access path of the .4darchive Windows |
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | Folder, File, or String | Source folder or file path (relative to the open project/absolute/filesystem).|
|includePaths[].destination | Folder, File, or String | Destination folder path (relative to the built project/absolute/filesystem).|
|deletePaths[] | Collection of Folder, File, or Strings | Collection of paths to folders and files to be deleted (relative to the built project/absolute/filesystem strings).|
|excludeModules| Collection of Strings | Collection of module names to exclude from final application. The module names can be found in the "BuildappOptionalModules.json" file in the resources of the 4D application.|
|versioning| Object | Object containing the contents of the application informations.|
|versioning.version| String | Version number. |
|versioning.copyright| String | Copyright text. |
|versioning.companyName| String | Company name. |
|versioning.fileDescription| String | Description (Windows only).|
|versioning.internalName| String | Internal name (Windows only).|
|signApplication| Object | Object containing the contents of the application signing.|
|signApplication.macSignature | Boolean | Signs the built applications.|
|signApplication.macCertificate | String | Certificate name used for signature.|
|signApplication.adHocSignature | Boolean | Signs the built applications with AdHoc signature if macSignature not performed.|
|license| File or String | Server license license file (relative to the built project/absolute/filesystem).|
|xmlKeyLicense| File or String | 4D OEM XML Keys license file (relative to the built project/absolute/filesystem).|

 
<h3 id="renameExecutable">_renameExecutable</h3>

```4D
Function _renameExecutable() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the executable has been correctly renamed. |

Renames the executable.

### build()

```4D
Function build() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the standalone has been correctly executed.|

Builds the standalone application.

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
$settings.buildName:="myServer" 
$settings.destinationFolder:="Test/" 
$settings.obfuscated:=True 
$settings.packedProject:=True 
$settings.useSDI:=False 
$settings.startElevated:=False 
$settings.lastDataPathLookup:="ByAppPath"

// Specify the components required for compilation
$componentsFolder:=Folder(fk documents folder).folder("4D v20.0/4D Server.app/Contents/Components")
$components:=[]
$components.push($componentsFolder.file("4D WritePro Interface.4dbase/4D WritePro Interface.4DZ"))
$settings.compilerOptions:={components: $components}

// Define the 4D Volume Desktop path
$settings.sourceAppFolder:=Folder(fk documents folder).folder("4D v20.0/4D Server.app")

// Delete the unnecessary module 
$settings.excludeModules:=["MeCab"]

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

// Sign the macOS appplication 
$settings.signApplication:={} 
$settings.signApplication.macSignature:=True 
$settings.signApplication.macCertificate:="xxxxxx"

// Launch the build
$build:=cs.Build4D.Standalone.new($settings) 
$success:=$build.build()
```