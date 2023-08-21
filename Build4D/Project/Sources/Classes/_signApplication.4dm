property \
macSignature; \
adHocSignature : Boolean


property \
macCertificate : Text


Class constructor
	
	This.macSignature:=False
	This.macCertificate:=""
	This.adHocSignature:=False
	
	
	
Function load_settings($settings : Object) : cs._signApplication
	
	var $key : Text
	
	Case of 
			
		: (Count parameters<1)
			
		: ($settings=Null)
			
		Else 
			
			For each ($key; $settings)
				
				If (This[$key]#Null)
					This[$key]:=$settings[$key]
				End if 
				
			End for each 
			
	End case 
	
	return This
	
	
Function save_settings : Object
	
	var $settings : Object
	
	$settings:={\
		macSignature: This.macSignature; \
		macCertificate: This.macCertificate; \
		adHocSignature: This.adHocSignature\
		}
	
	return $settings
	