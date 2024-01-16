property \
_targets : Collection



Class constructor
	
	This._targets:=(Is macOS) ? ["x86_64_generic"; "arm64_macOS_lib"] : ["x86_64_generic"]
	
	
	//mark:-
	//.    getters
	
Function get targets : Collection
	
	return This._targets.copy()
	
	
	
	//mark:-
	//     member functions 
	
Function load_settings($settings : Object) : cs._compilerOptions
	
	return This
	
	
	
Function save_settings : Object
	var $settings : Object
	
	$settings:={}
	
	return $settings
	
	
	