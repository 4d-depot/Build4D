<!-- Type your summary here -->
## Description

This class allows you to create a client application. It is composed of the following:

* a [Class constructor](#class-constructor)
* a [build()](#build) function
* a [buildArchive()](#buildArchive) function

### Class constructor

```4D
Class constructor($customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $customSettings | Object | in | $customSettings is a custom settings object overriding target default settings stored in the "/RESOURCES/Client.json" file. |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|  
|buildName | String | Name of the target build, defined by the component if missing in the custom settings.|
|publishName | String | Name of the publication name, defined by the component if missing in the custom settings.|
|projectFile | File or String | Project file (relative to the open project/absolute/filesystem). Pass the project file path if you want to build an external project (not necessary if building the current project).|
|destinationFolder | Folder or String | Folder where the build will be generated (relative to the open project/absolute/filesystem), defined by the component if missing in the custom settings. Its contents are deleted before each build.|
|sourceAppFolder| Folder or String | Folder of the 4D Server (relative to the open project/absolute/filesystem).|
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if it is not null. For more details about the object format, read the documentation of the Compile project command.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|obfuscated | Boolean | True if the 4DZ is to not be dezippable.|
|useSDI| Boolean | Allows to use the SDI interface mode instead of the MDI (Windows only).|
|startElevated| Boolean | Allows to start the Updater with elevated privileges (Windows only).|
|iconPath| File or String | File path of the icon to be used instead of the 4D Volume Desktop icon.|
|serverSelectionAllowed| Boolean | Disable the server selection window.|
|singleInstance| Boolean | Allow multiple or single instances of the client application.|
|IPAddress| string | Server IP address |
|portNumber| number | Server port number (default 19813) |
|currentVers| Number | Allows you to specify the current version number of the built application (Default value 1).|
|rangeVersMin| Number | Allows you to specify the minimum Client version (Default value 1).|
|rangeVersMax| Number | Allows you to specify the maximum Client version (Default value 1).|
|hardLink| Number | To create a hard link between client and serveer (Default value "").|
|clientServerSystemFolderName| String | Custom name of the local client cache folder. More details in this blog: https://blog.4d.com/multiple-servers-one-shared-local-resources/|
|clientUserPreferencesFolderByPath| boolean | True, if each merged client application has its own folder in the user preferences folder and connects to the right server. More details in this blog: https://blog.4d.com/use-duplicated-merged-client-applications/|
|shareLocalResourcesOnWindowsClient| | True if the local resources of the application must be downloaded from 4D Server to a shared folder on Windows merged clients. More details in this blog: https://blog.4d.com/share-local-resources-between-users-with-windows-remote-desktop-services/ |
|databaseToEmbedInClient| File or String | Path of the folder containing the compiled structure file to embed.|
|versioning| Object | Object containing the contents of the application informations.|
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
| $status | Boolean | out | True if the standalone has been correctly executed.|

Builds the client application.

### buildArchive()

```4D
Function buildArchive() -> $result : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $result | Object | out | $result.success: True if the standalone has been correctly executed.
| | | |$result.archive: 4D.File of the generated client archive application.|

Builds the client application archive.

## Example

This code is an example to generate a client application from an external project.

```4D
var $build : cs.Build4D.Client
var $settings; $archive : Object
var $success : Boolean

$settings:={}

// Define the external project file 
$settings.projectFile:=Folder(fk documents folder).file("Contact/Project/Contact.4DProject") 

// Define the 4D Volume Desktop path
$settings.sourceAppFolder:=Folder(fk documents folder).folder("4D v20.1/4D Volume Desktop.app")

// Configure the application
$settings.buildName:="myAppBuild"
$settings.publishName:="myApp"
$settings.destinationFolder:="Test/Client/"

// Sign the macOS appplication 
$settings.signApplication:={}
$settings.signApplication.adHocSignature:=True

// Create the client application
$build:=cs.Client.new($settings)
$success:=$build.build()

// Create the client application archive
$archive:=$build.buildArchive()
```
