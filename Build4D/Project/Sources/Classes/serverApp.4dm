Class extends _core


// https://github.com/orgs/4d/projects/119?pane=issue&itemId=32074136

//MARK:-
Class constructor($customSettings : Object)
	
	var $currentAppInfo; $sourceAppInfo : Object
	var $fileCheck : Boolean
	
	Super("ServerApp"; $customSettings)