<!-- Type your summary here -->
## Description

This class allows you to create a component. It is composed of:

* a [Class constructor](#class-constructor)
* a [build()](#build) function

### Class constructor

```4D
Class constructor($customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $customSettings | Object | in | $customSettings is a custom settings object overriding target default settings stored in "/RESOURCES/Component.json" file |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|        
|buildName | String | Name of the target build. Defined by the component if missing in the custom settings.|
|destinationFolder | Folder | Folder where the build will be generated. Defined by the component if missing in the custom settings.|
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if is not null.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|obfuscated4DZ | Boolean | True if the 4DZ shall not be dezippable.|
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | String | Source folder or file path (relative/absolute/filesystem strings).|
|includePaths[].destination | String | Destination folder path (relative/absolute/filesystem strings).|
|deletePaths[] | Collection of Strings | Collection of paths to folders and files to be deleted (relative/absolute/filesystem strings).|
|signApplication.macSignature | Boolean | Signs the built applications.|
|signApplication.macCertificate | String | Certificate name used  for signature.|
|signApplication.adHocSignature | Boolean | Signs the built applications with AdHoc signature if macSignature not performed.|
|formulaForLogs | Formula | Formula called when a log is written.|

### build()

```4D
Function build() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the build has been correctly executed|

Build the component.

## Example

If you use Build4D as a component, you can write:

```4D
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean

$settings:=New object()
$settings.destinationFolder:="./Test/"
$settings.buildName:="myComponent"

$settings.includePaths:=New collection
$settings.includePaths.push(New object("source"; "./Documentation/"; "destination"; ""))

$settings.deletePaths:=New collection
$settings.deletePaths.push("./Resources/Dev/")

$build:=cs.Build4D.Component.new($settings)
$success:=$build.build()
```
