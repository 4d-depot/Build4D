//%attributes = {}
var $targets : Collection:=Is macOS ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]

var $settings : Object:={\
buildName: "Build4D"; \
compilerOptions: {targets: $targets}; \
signApplication: {macSignature: False; adHocSignature: False}; \
destinationFolder: "./BUILD/"; \
includePaths: [{source: "Documentation/"}]; \
deletePaths: ["./Resources/Dev/"]\
}

var $component : cs.Component:=cs.Component.new($settings)

var $success : Boolean:=$component.build()

If ($success)
	
	var $zip : Object:=ZIP Create archive(\
		$component.settings.destinationFolder; \
		$component.settings.destinationFolder.file("../Build4D.zip"))
	
End if 

BEEP