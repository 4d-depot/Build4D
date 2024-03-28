<!-- Type your summary here -->
## Description

This class is a base class used by the other classes to create a compiled project or a component. It is composed of the following:

* [Class constructor](#class-constructor)
* [Function \_checkDestinationFolder](#function-checkDestinationFolder)
* [Function \_compileProject](#function-compileProject)
* [Function \_copySourceApp](#function-copySourceApp)
* [Function \_create4DZ](#function-create4DZ)
* [Function \_createStructure](#function-createStructure)
* [Function \_deletePaths](#function-deletePaths)
* [Function \_excludeModules](#function-excludeModules)
* [Function \_generateLicense](#function-generateLicense)
* [Function \_includePaths](#function-includePaths)
* [Function \_log](#function-log)
* [Function \_overrideSettings](#function-overrideSettings)
* [Function \_resolvePath()](#function-resolvePath)
* [Function \_setAppOptions()](#function-setAppOptions)
* [Function \_sign()](#function-sign)

### Class constructor

```4D
Class constructor($target : Text; $customSettings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $target | Text | in | The target to build, the possible values are "CompiledProject" or "Component". |
| $customSettings | Object | in | Object containing all settings for target build. |

$customSettings is an object that contains the following parameters:

| Attributes | Type | Description |
|---|---|---|        
|\_validInstance | Boolean | True if the instanciated object can be used for build. False if a condition is not filled (e.g. project doesn't exist).|
|\_projectFile | File | Project file.|
|\_projectPackage | Folder | Folder of the project package.|
|\_isCurrentProject | Boolean | True if the project is the current one.|
|\_isDefaultDestinationFolder | Boolean | True if the destination folder is the one computed automatically.|
|\_structureFolder | Folder | Folder of the destination structure.|
|settings | Object | Root object containing all settings for target build. It can be overriden by a constructor's parameter. The structure of the $settings object is described in each class corresponding to the target.|

<h3 id="function-checkDestinationFolder">Function _checkDestinationFolder</h3>

```4D
Function _checkDestinationFolder() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the destination folder exists. |

Checks the destination folder. Its contents are deleted before each build.

<h3 id="function-compileProject">Function _compileProject</h3>

```4D
Function _compileProject() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the compilation has succeeded. Otherwise, the compilation's result object is included in an error log. |

Compiles the project with the settings.compilerOptions (if it exists).

<h3 id="function-copySourceApp">Function _copySourceApp</h3>

```4D
Function _copySourceApp() -> $status : Boolean
```

| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the copy is successful. |

Copies the source application (4D Volume Desktop or 4D Server) in the destination folder.

<h3 id="function-create4DZ">Function _create4DZ</h3>

```4D
Function _create4DZ() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the compression has succeeded. Otherwise, the archive creation's result object is included in an error log. |

Creates the 4DZ file of the project, and deletes the Project folder if successful.

<h3 id="function-createStructure">Function _createStructure</h3>

```4D
Function _createStructure() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the destination structure has been correctly created. |

Creates the destination structure folders and files.

<h3 id="function-deletePaths">Function _deletePaths</h3>

```4D
Function _deletePaths($paths : Collection) -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $paths | Collection of texts | in | List of folders and files to delete. |
| $status | Boolean | out |  True if all paths have been correctly removed. Otherwise, an error log is created with "path" information. |

Deletes folders and files from the destination structure.

<h3 id="function-excludeModules">Function _excludeModules</h3>

```4D
Function _excludeModules() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if all modules have been correctly removed. Otherwise, an error log is created with "path" information.|

Deletes the folders and files composing the module to be removed according to the information in the "/RESOURCES/BuildappOptionalModules.json" file.

<h3 id="function-generateLicense">Function _generateLicense</h3>

```4D
Function _generateLicense() -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the deployment license have been correctly created. Otherwise, xxx.|

Creates the deployment license file in the license folder of the generated application.

<h3 id="function-includePaths">Function _includePaths</h3>

```4D
Function _includePaths($pathsObj : Collection) -> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $paths | Collection of objects | in | List of folder and file objects to include. |
| $status | Boolean | out | True if all paths have been correctly copied. Otherwise, an error log is created with "sourcePath" and "destinationPath" information. |

Includes folders and files into the destination structure.

<h3 id="function-log">Function _log</h3>

```4D
Function _log($log : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $log | Object | in | Object containing the attributes: "function", "message", "messageSeverity", and optionnaly: "result", "path", "sourcePath", "destinationPath". |

Calls the settings.formulaForLogs formula with the $log object parameter.

<h3 id="function-overrideSettings">Function _overrideSettings</h3>

```4D
Function _overrideSettings($settings : Object)
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $settings | Object | in | Settings passed by the derived class to override the default settings. |

Overrides the default target settings with the $settings parameter.

<h3 id="function-resolvePath">Function _resolvePath</h3>

```4D
Function _resolvePath($path : Text; $baseFolder : 4D.Folder) -> $object : Object
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $path | Text | in | Relative path to $baseFolder. |
| $baseFolder | 4D.Folder | in | Absolute path. |
| $object | 4D.Folder or 4D.File | out | 4D folder or 4D File. |

Resolves a relative/absolute/filesystem string path to a Folder/File object.

<h3 id="function-setAppOptions">Function _setAppOptions</h3>

```4D
Function _setAppOptions()-> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the information has been correctly added. |

Sets the information to the application.

<h3 id="function-sign">Function _sign</h3>

```4D
Function _sign()-> $status : Boolean
```
| Parameter | Type | in/out | Description |
|---|---|---|---|
| $status | Boolean | out | True if the signature is successful. |

Signs the project.
