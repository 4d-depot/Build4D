//%attributes = {}
// Test _build() function in the default folder
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean
var $destinationFolder : 4D.Folder
var $buildServer : 4D.File
var $link : Text
$link:=" (https://github.com/4d/4d/issues/"+Substring(Current method name; Position("_TC"; Current method name)+3)+")"

logGitHubActions(Current method name)

// MARK:- Current project

$settings:=New object()
$settings.formulaForLogs:=Formula(logGitHubActions($1))
$settings.destinationFolder:="./Test/"
$settings.signApplication:={adHocSignature: True}

$settings.sourceAppFolder:=(Is macOS) ? Folder(Storage.settings.macServer) : Folder(Storage.settings.winServer)


$settings.compilerOptions:={targets: ["x86_64_generic"]}


//the goal : Build a server application and add a file located at an absolute path to a destination located at an absolute path
$settings.includePaths:=New collection(New object(\
"source"; "/README.md"; \
"destination"; "/Ressources EN/")\
)


$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(Current project) Compiled project build should success"+$link)



// Cleanup build folder
If ($success)
	
	If (Is macOS)
		
		$build.settings.destinationFolder.parent.delete(fk recursive)
		
	Else 
		// to validate on windows
		$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
		
	End if 
End if 


// MARK:- External project

$settings.projectFile:=Storage.settings.externalProjectFile

$build:=cs.Build4D.Server.new($settings)


$success:=$build.build()

ASSERT($success; "(External project) Compiled project build should success"+$link)

var $siliconCodeFile : 4D.File
$siliconCodeFile:=$build.settings.destinationFolder.file("Contents/Server Database/Libraries/lib4d-arm64.dylib")
If ($siliconCodeFile.exists)
	var $siliconCodePath : Text
	var $verificationWorker : 4D.SystemWorker
	
	$siliconCodePath:=Replace string($siliconCodeFile.path; " "; "\\ ")  // Server Database -> Server\ Database
	
	$verificationWorker:=4D.SystemWorker.new("codesign -dv --verbose=4 "+$siliconCodePath)
	$verificationWorker.wait(120)
	If ($verificationWorker.terminated)
		If ($verificationWorker.exitCode=0)
			// The file is signed if a line "Runtime Version=versionNumber" exists
			var $lines : Collection
			$lines:=Split string($verificationWorker.responseError; "\n")
			ASSERT(Not(Undefined($lines.find(Formula($1.value=$2); "Runtime Version=@"))); "(Current project) Component should be signed. Verification response: "+$verificationWorker.responseError+$link)
		End if 
	End if 
End if 

// Cleanup build folder
If ($success)
	If (Is macOS)
		
		$build.settings.destinationFolder.parent.delete(fk recursive)
		
	Else 
		// to validate on windows
		$build._projectPackage.parent.folder($build._projectFile.name+"_Build").delete(fk recursive)
		
	End if 
End if 
