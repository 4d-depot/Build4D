//%attributes = {}
var $options; $settings; $versioning; $signApplication : Object
var $destFolder : 4D.Folder
var $license; $xmlKeyLicense; $iconPath : Variant
var $targets : Collection
var $path : Text


// https://github.com/orgs/4d/projects/119?pane=issue&itemId=32074136



$targets:=(Is macOS) ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]


$license:=File("/PACKAGE/Settings/4UUD.license4D")  //UT_Settings.json")

$options:={\
targets: $targets\
}


$versioning:={\
version: "1.0.0"; \
copyright: " © 2023 4D SAS"; \
companyName: "4D SAS"; \
fileDescription: "4D4D"; \
internalName: "4DC"; \
rangeVersMin: 20; \
rangeVersMax: 21; \
currentVers: 20; \
hardLink: "ø∞"; \
serverStructureFolderName: "app"\
}


$signApplication:={\
macSignature: False; \
macCertificate: "Dominique Delahaye"; \
adHocSignature: True\
}


$settings:={\
buildName: "MyAppl"; \
compilerOptions: $options; \
sourceAppFolder: $path; \
destinationFolder: $destFolder; \
versioning: $versioning; \
license: $license; \
xmlKeyLicense: $xmlKeyLicense; \
iconPath: $iconPath; \
signApplication: $signApplication; \
includePaths: []; \
deletePaths: []; \
startElevated: True; \
excludeModule: []; \
obfuscated: False; \
packedProject: False; \
lastDataPathLookup: ""; \
hideDataExplorerMenuItem: True; \
hideRuntimeExplorerMenuItem: True; \
hideAdministrationWindowMenuItem: True; \
serverDataCollection: True; \
singleInstance: True; \
macOSClientArchive: ""; \
windowsClientArchive: ""\
}

var $standAlone : cs.Standalone
var $server : cs.Server

var $c_settings : cs._settings

var $save_setting : Object



$standAlone:=cs.Standalone.new($settings)

$server:=cs.Server.new($settings)



$c_settings:=cs._settings.new($settings)


$c_settings.versioning:=Null  // read only property -10702

$save_setting:=$c_settings.save_settings()

SET TEXT TO PASTEBOARD(JSON Stringify($save_setting; *))

