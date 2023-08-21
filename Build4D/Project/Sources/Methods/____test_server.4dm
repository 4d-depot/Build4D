//%attributes = {}
var $options; $settings; $versioning; $signApplication; $objPath : Object
var $destFolder : 4D.Folder
var $license; $xmlKeyLicense; $iconPath : Variant
var $targets : Collection
var $path : Text

$targets:=(Is macOS) ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]

$objPath:={\
source: ""; \
destination: ""\
}

$options:={\
targets: $targets\
}


$versioning:={\
version: "1.0.0"; \
copyright: "(c)2023 4D SAS"; \
companyName: "4D SAS"; \
fileDescription: "4D4D"; \
internalName: "4DC"; \
rangeVersMin: 20; \
rangeVersMax: 21; \
currentVers: 20; \
hardLink: "ø"; \
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
clientWinSingleInstance: True; \
macOSClientArchive: ""; \
windowsClientArchive: ""; \
MacCompiledDatabaseToWin: ""\
}



$settings:=cs._settings.new($settings)

$save_setting:=$settings.save_settings()


