//%attributes = {"invisible":true}
// build the server application choosing to integrate the client Windows archive using the "windowsClientArchive" key
var $build : cs.Build4D.Server
var $settings; $infos; $archive : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $clientArchive : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)


// MARK:- Build Client

var $client : cs.Build4D.Client

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/Client/"

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$client:=cs.Build4D.Client.new($settings)


$success:=$client.build()

ASSERT($success; "(Current project) Client build should success"+$link)


// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/Server/"


$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)

$archive:=$client.buildArchive()

$settings.windowsClientArchive:=$archive.archive

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Server build should success"+$link)

If (Is macOS)
	$clientArchive:=$build.settings.destinationFolder.file("Contents/Upgrade4DClient/update.mac.4darchive")  // it's a mac archive 
Else 
	// to validate on windows
	$clientArchive:=$build.settings.destinationFolder.file("Upgrade4DClient/update.win.4darchive")
End if 


ASSERT($clientArchive.exists; "(Current project) "+$clientArchive.fullName+" file should exist: "+$clientArchive.platformPath+$link)

// il faut checker aussi le contenu du fichier json

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$archive:=$client.buildArchive()

$settings.windowsClientArchive:=$archive.archive

$build:=cs.Build4D.Server.new($settings)

$success:=$build.build()

ASSERT($success; "(External project) Server build should success"+$link)


If (Is macOS)
	$clientArchive:=$build.settings.destinationFolder.file("Contents/Upgrade4DClient/update.mac.4darchive")
Else 
	// to validate on windows
	$clientArchive:=$build.settings.destinationFolder.file("Upgrade4DClient/update.win.4darchive")
End if 

ASSERT($clientArchive.exists; "(External project) "+$clientArchive.fullName+" file should exist: "+$buildServer.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


