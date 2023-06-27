//%attributes = {}
// The default value of "packedProject" shall be "True"
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=Folder(Storage.settings.winVolumeDesktop)
$settings.excludeModules:=New collection("mecab")


logGitHubActions(Current method name)

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$build:=cs.Build4D.Standalone.new($settings)

ASSERT((($build.settings.packedProject#Null) && ($build.settings.packedProject)); "Standalone: obfuscated default setting shall be false"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
