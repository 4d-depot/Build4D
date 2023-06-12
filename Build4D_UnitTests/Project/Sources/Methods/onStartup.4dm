//%attributes = {}
#DECLARE($launch : Boolean)

If (Count parameters=0)  // Execute code in a new worker
	
	Use (Storage)
		Storage.settings:=New shared object()
		Storage.settings:=OB Copy(JSON Parse(File("/PACKAGE/Settings/UT_Settings.json").getText()); ck shared)
	End use 
	Use (Storage.settings)
		Storage.settings.rootFolder:=Folder(Folder(fk database folder; *).platformPath; fk platform path)
		Storage.settings.projectName:=File(Structure file(*); fk platform path).name
		Storage.settings.userInterface:=Not(Get application info.headless)
		Storage.settings.externalProjectRootFolder:=Storage.settings.rootFolder.folder("Build4D_External")
		Storage.settings.externalProjectName:="Build4D_External"
		Storage.settings.externalProjectFile:=Storage.settings.externalProjectRootFolder.file("Project/Build4D_External.4DProject")
		Storage.settings.logRunFile:=Storage.settings.rootFolder.file("UT_run.log")
		Storage.settings.logErrorFile:=Storage.settings.rootFolder.file("UT_errors.log")
	End use 
	
	SET ASSERT ENABLED(False)
	CALL WORKER(Current method name; Current method name; True)
	
Else 
	var $userParam : Text
	var $result : Integer
	var $quit4D : Boolean
	
	$result:=Get database parameter(User param value; $userParam)
	If ($userParam#"")
		$quit4D:=(Not(Shift down))
		Case of 
			: ($userParam="test")
				runAutomaticUnitTests
			Else 
				LOG EVENT(Into system standard outputs; "::error ::User parameter not recognized ("+$userParam+")!"; Error message)
		End case 
		
		If ($quit4D)
			QUIT 4D
		End if 
	End if 
	
End if 
