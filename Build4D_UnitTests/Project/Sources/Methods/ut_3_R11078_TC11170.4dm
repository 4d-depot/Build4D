//%attributes = {}
// Not define any path of Volume Desktop application
var $build : cs.Build4D.Standalone
var $settings : Object
var $success; $found : Boolean
var $link : Text
var $log : Object

$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build._validInstance=False; "(Current project) Object instance shouldn't be valid"+$link)

$found:=False
For each ($log; $build.logs)
	If ($log.function="Source application folder checking")
		If ($log.severity=2)
			$found:=True
			break
		End if 
	End if 
End for each 

ASSERT($found; "(Current project) Standalone build should generate an error"+$link)

$success:=$build.build()

ASSERT($success=False; "(Current project) Standalone build should fail"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Standalone.new($settings)

ASSERT($build._validInstance=False; "(External project) Object instance shouldn't be valid"+$link)

$found:=False
For each ($log; $build.logs)
	If ($log.function="Source application folder checking")
		If ($log.severity=2)
			$found:=True
			break
		End if 
	End if 
End for each 

ASSERT($found; "(External project) Standalone build should generate an error"+$link)

$success:=$build.build()

ASSERT($success=False; "(External project) Standalone build should fail"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
