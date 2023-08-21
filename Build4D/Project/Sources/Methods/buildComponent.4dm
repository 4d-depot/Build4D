//%attributes = {"preemptive":"capable"}
// Build4D component build

var $build : cs.Component
var $settings : Object
var $success : Boolean
var $targets : Collection

File("/PACKAGE/Build_start.log").setText(Timestamp)
File("/PACKAGE/Build_failed.log").delete()
File("/PACKAGE/Build_end.log").delete()

$targets:=(Is macOS) ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]

$settings:={\
buildName: "Build4D"; \
compilerOptions: {targets: $targets}; \
destinationFolder: "../Build4D_UnitTests/Components/"; \
includePaths: [{source: "Documentation/"}]\
}

$build:=cs.Component.new($settings)

$success:=$build.build()

File("/PACKAGE/Build_end.log").setText(Timestamp)
If (Not($success))  // Write logs if failed
	File("/PACKAGE/Build_failed.log").setText(JSON Stringify($build.logs; *))
End if 

If (Not(Get application info.headless))
	If ($success)
		ALERT("Build OK")
	Else 
		ALERT("Build failed")
		SHOW ON DISK(File("/PACKAGE/Build_failed.log").platformPath)
	End if 
End if 
