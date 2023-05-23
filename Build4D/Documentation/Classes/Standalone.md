<!-- Type your summary here -->
## Description

This class allows you to create a standalone application. It is composed of:

* a [Class constructor](#class-constructor)
* a [\_renameExecutable](#renameExecutable) function
* a [build()](#build) function

### Class constructor

```4D
Class constructor($customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $customSettings | Object | in | $customSettings is a custom settings object overriding target default settings stored in "/RESOURCES/Standalone.json" file |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|        
|buildName | String | Name of the target build. Defined by the component if missing in the custom settings.|
|projectFile | File or String | Project file. Pass the project file path if you want to build an external project. Not necessary if it is a current project.|
|destinationFolder | Folder or String | Folder where the build will be generated. Defined by the component if missing in the custom settings.|
|sourceAppFolder| Folder or String | Folder of the 4D Volume Desktop.|
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if is not null. For more details about the object format, read the documentation of the Compile project command.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|obfuscated | Boolean | True if the 4DZ shall not be dezippable.|
|lastDataPathLookup| String | Defines the way the application stores its link with the last data file. Possible values: "ByAppName", "ByAppPath"|
|useSDI| Boolean | On Windows, use the SDI interface mode instead of the MDI.|
|startElevated| Boolean | On Windows, allow to start the Updater with elevated privileges.|
|iconPath| File or String | File of the icon to be used instead of the 4D Volume Desktop icon.|
|versioning| Object | Object contains the contents of the application information.|
|versioning.version| String | Version number |
|versioning.copyright| String | Copyright text |
|versioning.creator| String | Creator code (4 characters maximum) (macOS only)|
|versioning.comment| String | Comment (Windows only) |
|versioning.companyName| String | Company name  (Windows only)|
|versioning.fileDescription| String | Description (Windows only)|
|versioning.internalName| String | Internal name (Windows only)|
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | String | Source folder or file path (relative to the built project/absolute/filesystem strings).|
|includePaths[].destination | String | Destination folder path (relative to the built project/absolute/filesystem strings).|
|deletePaths[] | Collection of Strings | Collection of paths to folders and files to be deleted (relative to the built project/absolute/filesystem strings).|
|excludeModules| Collection of Strings | Collection of module names to exclude from final application. The module names can be found in the "BuildappOptionalModules.json" file in the resources of 4D application.|
|license| File or String | Unlimited desktop license file.|
|signApplication.macSignature | Boolean | Signs the built applications.|
|signApplication.macCertificate | String | Certificate name used  for signature.|
|signApplication.adHocSignature | Boolean | Signs the built applications with AdHoc signature if macSignature not performed.|
|logger | Formula | Formula called when a log is written.|

<h3 id="renameExecutable">_renameExecutable</h3>

```4D
Function _renameExecutable() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the executable has correctly renamed. |

Rename the executable.

### build()

```4D
Function build() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the standalone has been correctly executed|

Build the standalone application.

## Example

```4D



```
