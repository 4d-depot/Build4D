//%attributes = {}
// The default value of "obfuscated" shall be "False"
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean
var $link : Text
$link:=" (https://dev.azure.com/4dimension/4D/_workitems/edit/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.license:=Storage.settings.licenseUUD
$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macVolumeDesktop) : Folder(Storage.settings.winVolumeDesktop)

$build:=cs.Build4D.Standalone.new($settings)

ASSERT((($build.settings.obfuscated#Null) && ($build.settings.obfuscated=False)); "Standalone: obfuscated default setting shall be false"+$link)

// Cleanup build folder
Folder("/PACKAGE/Test").delete(fk recursive)
