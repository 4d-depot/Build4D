//%attributes = {}
// Test _build() function with the default name
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean
var $serverApp : 4D.File
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseServer
$settings.xmlKeyLicense:=Storage.settings.xmlKeyLicense
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)
$settings.buildName:="myApp"
$settings.publishName:="myServer"  // utilité ? demander à moussa ?
$settings.iconPath:="/RESOURCES/myIcon.icns"


$settings.versioning:={\
version: "21.1.0"; \
copyright: "MyMy"; \
companyName: "myComp"; \
fileDescription: "none"; \
internalName: "none"\
}


//$settings.hardLink:="strong"
//$settings.hideRuntimeExplorerMenuItem:=True
//$settings.hideDataExplorerMenuItem:=True
//$settings.hideAdministrationWindowMenuItem:=True

$settings.deletePaths:=[]
$settings.deletePaths.push("../Components/4D SVG.4dbase")

$settings.rangeVersMin:=8
$settings.rangeVersMax:=10
$settings.currentVers:=10

$settings.signApplication:={\
macSignature: True; \
macCertificate: "toto"\
}


$build:=cs.Build4D.Server.new($settings)

ASSERT($build.settings.buildName=Storage.settings.projectName; "(Current project) Wrong default build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(Current project) Standalone build should success"+$link)

$serverApp:=(Is macOS) ? Folder("/PACKAGE/Test/"+Storage.settings.projectName+".app") : Folder("/PACKAGE/Test/"+Storage.settings.projectName).file(Storage.settings.projectName+".exe")
ASSERT($serverApp.exists; "(Current project) Standalone should exist: "+$serverApp.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)

// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)

ASSERT($build.settings.buildName=Storage.settings.externalProjectName; "(External project) Wrong default build name: "+$build.settings.buildName+$link)

$success:=$build.build()

ASSERT($success; "(External project) Standalone build should success"+$link)

$serverApp:=(Is macOS) ? Folder("/PACKAGE/Test/"+Storage.settings.externalProjectName+".app") : Folder("/PACKAGE/Test/"+Storage.settings.externalProjectName).file(Storage.settings.externalProjectName+".exe")
ASSERT($serverApp.exists; "(External project) Standalone should exist: "+$serverApp.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
