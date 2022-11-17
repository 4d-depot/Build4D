//%attributes = {}
// Build4D component build

var $build : cs.Component
var $settings : Object
var $success : Boolean

File("/PACKAGE/Build_start.log").setText(Timestamp)
File("/PACKAGE/Build_failed.log").delete()
File("/PACKAGE/Build_end.log").delete()

$settings:=New object(\
"buildName"; "Build4D"; \
"compilerOptions"; New object("targets"; New collection("x86_64_generic"; "arm64_macOS_lib")); \
"destinationFolder"; "../Build4D_UnitTests/Build4D_UnitTests/Components/"; \
"includePaths"; New collection(New object("source"; "Documentation/"))\
)

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
