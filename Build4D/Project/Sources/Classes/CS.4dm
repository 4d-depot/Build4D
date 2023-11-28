


Class constructor($serverSettings : Object; $macSettings : Object; $winSettings : Object)
	
	
	This._server:=cs.Server.new($serverSettings)
	
	$serverSettings:=This._server.settings
	
	If ($macSettings#Null)
		
		If ($serverSettings.signApplication#Null)
			$macSettings.signApplication:=OB Copy($serverSettings.signApplication)
		End if 
		
		$macSettings.destinationFolder:=$serverSettings.destinationFolder.parent.parent.path+"Client/mac/"
		
		$macSettings.hardLink:=$serverSettings.hardLink
		
		$macSettings.buildName:=This._server.buildName
		
		$macSettings.publishName:=This._server.publishName
		
		If (Value type($serverSettings.IPAddress)=Is text) && ($serverSettings.IPAddress#"")
			
			$macSettings.IPAddress:=$serverSettings.IPAddress
			
		End if 
		
		If (Value type($serverSettings.portNumber)=Is real) && ($serverSettings.portNumber>0) && ($serverSettings.portNumber<32768)
			
			$macSettings.portNumber:=$serverSettings.portNumber
			
		End if 
		
		$macSettings.obfuscated:=($serverSettings.obfuscated=Null) ? Null : $serverSettings.obfuscated
		$macSettings.useSDI:=($serverSettings.useSDI=Null) ? Null : $serverSettings.useSDI
		
		
		
		This._mac:=cs.Client.new($macSettings)
	End if 
	
	If ($winSettings#Null)
		
		$winSettings.destinationFolder:=$serverSettings.destinationFolder.parent.parent.path+"Client/win/"  // update 
		
		$winSettings.hardLink:=$serverSettings.hardLink
		
		$winSettings.buildName:=This._server.buildName
		
		$winSettings.publishName:=This._server.publishName
		
		If (Value type($serverSettings.IPAddress)=Is text) && ($serverSettings.IPAddress#"")
			
			$winSettings.IPAddress:=$serverSettings.IPAddress
			
		End if 
		
		
		If (Value type($serverSettings.portNumber)=Is real) && ($serverSettings.portNumber>0) && ($serverSettings.portNumber<32768)
			
			$winSettings.portNumber:=$serverSettings.portNumber
			
		End if 
		
		
		$winSettings.obfuscated:=($serverSettings.obfuscated=Null) ? Null : $serverSettings.obfuscated
		$winSettings.useSDI:=($serverSettings.useSDI=Null) ? Null : $serverSettings.useSDI
		
		
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
	
	//MARK:-
	
	
Function _buildZip()->$result : Object
	
	$result:={}
	
	If (This._server._validInstance)
		$result.server:=This._server._buildZip()
		
	End if 
	
	If (This._mac._validInstance)
		$result.mac:=This._mac._buildZip()
	End if 
	
	
	If (This._win._validInstance)
		$result.win:=This._win._buildZip()
	End if 
	
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
	
	var $abort : Boolean
	
	Case of 
			
		: (This._mac=Null)
			
		: (This._build_mac())
			
		Else 
			$abort:=True
	End case 
	
	
	Case of 
			
		: ($abort)
			
		: (This._win=Null)
			
		: (This._build_win())
			
		Else 
			$abort:=True
			
	End case 
	
	Case of 
			
		: ($abort)
			
		: (This._server=Null)
			
		: (This._server.build())
			
			return True
			
	End case 