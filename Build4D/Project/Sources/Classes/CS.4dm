


Class constructor($serverSettings : Object; $macSettings : Object; $winSettings : Object)
	
	
	This._server:=cs.Server.new($serverSettings)
	
	This._mac:=cs.Client.new($macSettings)
	
	This._win:=cs.Client.new($winSettings)
	
	
Function get valid : Boolean
	
	var $server_ok; $mac_ok; $win_ok : Boolean
	
	$server_ok:=This._server._validInstance
	$mac_ok:=This._mac._validInstance
	$win_ok:=This._win._validInstance
	
	return $mac_ok & $win_ok & $server_ok
	
	
	
Function get server_settings : Object
	return This._server.settings
	
	
	
Function show() : cs.CS
	
	SHOW ON DISK(This.server_settings.destinationFolder.platformPath)
	
	return This
	
	
	
Function build() : Boolean
	
	var $mac; $win : Object
	
	If (This._mac.build())
		
		$mac:=This._mac.buildArchive()
		
		If ($mac.success)
			
			This.server_settings.macOSClientArchive:=$mac.archive
			
		End if 
		
	End if 
	
	
	If (This._win.build())
		
		$win:=This._win.buildArchive()
		
		If ($win.success)
			
			This.server_settings.windowsClientArchive:=$win.archive
			
		End if 
		
	End if 
	
	
	If (This._server.build())
		
		return True
		
	End if 