<!-- Type your summary here -->
## Description

This class allows you to create a compiled project. It is composed of the following:

* a [Class constructor](#class-constructor)
* a [build()](#build) function

### Class constructor

```4D
Class constructor($customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $customSettings | Object | in | $customSettings is a custom settings object overriding target default settings stored in the "/RESOURCES/CompiledProject.json" file. |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|        
|buildName | String | Name of the target build, defined by the component if missing in the custom settings.|
|projectFile | File or String | Project file (relative to the open project/absolute/filesystem). Pass the project file path if you want to build an external project (not necessary if building the current project).|
|destinationFolder | Folder or String | Folder where the build will be generated (relative to the open project/absolute/filesystem), defined by the component if missing in the custom settings. Its contents are deleted before each build. |
|compilerOptions | Object | Compile options. The object is passed as parameter to the "Compile project" command if it is not null. For more details about the object format, read the documentation of the Compile project command.|
|packedProject | Boolean | True if the project is compressed into a 4DZ file.|
|obfuscated | Boolean | True if the 4DZ is to not be dezippable.|
|includePaths[] | Collection of Objects | Collection of folders and files to include.|
|includePaths[].source | Folder, File, or String | Source folder or file path (relative to the open project/absolute/filesystem strings).|
|includePaths[].destination | Folder, File, or String | Destination folder path (relative to the built project/absolute/filesystem).|
|deletePaths[] | Collection of Folders, Files, or Strings | Collection of paths to folders and files to be deleted (relative to the built project/absolute/filesystem).|
|logger | Formula | Formula called when a log is written.|

### build()

```4D
Function build() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the build has been correctly executed. |

Builds the compiled project.

## Example


If you use Build4D as a component to build an external project, you can write: 

```4D
$settings:=New object()
$settings.projectFile:="/Users/.../Contact/Project/Contact.4DProject"
$settings.buildName:="myContact"

$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build.build()
```

If you use Build4D as a component to build the current project, you can write:

```4D
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean

$settings:=New object()
$settings.destinationFolder:="./Test/"
$settings.buildName:="myProject"

$settings.includePaths:=New collection
$settings.includePaths.push(New object("source"; "./Documentation/"; "destination"; ""))
$settings.includePaths.push(New object("source"; "./Resources/"; "destination"; ""))

$settings.deletePaths:=New collection
$settings.deletePaths.push("./Resources/Dev/")

$build:=cs.Build4D.CompiledProject.new($settings)
$success:=$build.build()
```
