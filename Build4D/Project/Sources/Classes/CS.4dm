


Class constructor($serverSettings : Object; $macSettings : Object; $winSettings : Object)
	
	
	This._server:=cs.Server.new($serverSettings)
	
	
	If ($macSettings#Null)
		$macSettings.signApplication:=OB Copy($serverSettings.signApplication)
		
		
		$macSettings.destinationFolder:=$serverSettings.destinationFolder+"Client/mac/"
		
		$macSettings.hardLink:=$serverSettings.hardLink
		
		$macSettings.publishName:=This._server.publishName
	End if 
	
	If ($winSettings#Null)
		$winSettings.destinationFolder:=$serverSettings.destinationFolder+"Client/win/"  // update 
		
		$winSettings.hardLink:=$serverSettings.hardLink
		
		$winSettings.publishName:=This._server.publishName
		
	End if 
	
	
	
	
	
	
	If (Value type($serverSettings.IPAddress)=Is text) && ($serverSettings.IPAddress#"")
		
		$macSettings.IPAddress:=$serverSettings.IPAddress
		$winSettings.IPAddress:=$serverSettings.IPAddress
		
	End if 
	
	
	If (Value type($serverSettings.portNumber)=Is real) && ($serverSettings.portNumber>0) && ($serverSettings.portNumber<32768)
		
		$macSettings.portNumber:=$serverSettings.portNumber
		$winSettings.portNumber:=$serverSettings.portNumber
		
	End if 
	
	If ($macSettings#Null)
		This._mac:=cs.Client.new($macSettings)
	End if 
	
	If ($winSettings#Null)
		This._win:=cs.Client.new($winSettings)
	End if 
	
Function get valid : Boolean
	
	var $server_ok; $mac_ok; $win_ok : Boolean
	
	$server_ok:=This._server._validInstance
	$mac_ok:=(This._mac._validInstance=Null) ? True : This._mac._validInstance
	$win_ok:=(This._win._validInstance=Null) ? True : This._win._validInstance
	
	return $mac_ok & $win_ok & $server_ok
	
	//Function zip
	
	
	
	
Function get server_settings : Object
	return This._server.settings
	
	
	
Function show() : cs.CS
	
	SHOW ON DISK(This.server_settings.destinationFolder.platformPath)
	
	return This
	
	
Function _build_mac : Boolean
	
	var $mac : Object
	
	If (This._mac#Null)
		
		If (This._mac.build())
			
			$mac:=This._mac.buildArchive()
			
			If ($mac.success)
				
				This.server_settings.macOSClientArchive:=$mac.archive
				
				return True
			End if 
			
		End if 
		
	End if 
	
Function _build_win : Boolean
	
	var $win : Object
	If (This._win#Null)
		If (This._win.build())
			
			$win:=This._win.buildArchive()
			
			If ($win.success)
				
				This.server_settings.windowsClientArchive:=$win.archive
				return True
			End if 
			
		End if 
	End if 
	
Function build() : Boolean
	
	var $mac; $win : Object
	
	
	If (This._build_mac())
		
	End if 
	
	If (This._build_win())
		
	End if 
	
	
	If (This._server.build())
		
		return True
		
	End if 