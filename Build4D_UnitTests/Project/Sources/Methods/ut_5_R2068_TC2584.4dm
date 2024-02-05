//%attributes = {"invisible":true}
// Test _build() function in the default folder
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


$archive:=$client.buildArchive()


ASSERT($archive.archive.exists; "(Current project) "+$archive.archive.fullName+" file should exist: "+$archive.archive.platformPath+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$client:=cs.Build4D.Client.new($settings)

$success:=$client.build()


ASSERT($success; "(External project) Server build should success"+$link)

$archive:=$client.buildArchive()


ASSERT($archive.archive.exists; "(External project) "+$archive.archive.fullName+" file should exist: "+$archive.archive.platformPath+$link)


// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)


