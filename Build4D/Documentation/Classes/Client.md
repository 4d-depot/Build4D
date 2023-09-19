<!-- Type your summary here -->
## Description

This class allows you to create a client application. It is composed of the following:

* a [Class constructor](#class-constructor)
* a [\_renameExecutable](#renameExecutable) function
* a [build()](#build) function

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
|IPAddress| string | Server IP address |
|portNumber| number | Server port number (default 19813) |
|clientAppPath | Folder or String | Folder where the build will be generated. |
|sourceAppFolder| Folder or String | Folder of the 4D Volume Desktop (relative to the open project/absolute/filesystem).|
|iconPath| File or String | File path of the icon to be used instead of the 4D Volume Desktop icon.|
|startElevated| Boolean | Allows to start the Updater with elevated privileges (Windows only).|
|useSDI| Boolean | Allows to use the SDI interface mode instead of the MDI (Windows only).|
|serverSelectionAllowed| Boolean | Disable the server selection window.|
|singleInstance| Boolean | Allow multiple or single instances of the client application.|
|clientServerSystemFolderName| String | Custom name of the local client cache folder.|
|clientUserPreferencesFolderByPath| boolean |  |
|rangeVersMin| number | default value 1. |
|rangeVersMax| number | default value 1. |
|currentVers| number | default value 1. |
|hardLink| string | default value "". |
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

Builds the client application.

## Example

This code is an example to generate a client application from an external project.


```4D
var $build : cs.Build4D.Client
var $settings : Object
var $success : Boolean

$settings:={}

// Define the external project file 
$settings.projectFile:=Folder(fk documents folder).file("Contact/Project/Contact.4DProject") 



```