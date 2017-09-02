
#If Server Then
	
Function GetDataProcessor(Name) Export
	
	Return CommonUse_ServerCached.GetDataProcessor(Name);
	
EndFunction // GetDataProcessor()
	
#EndIf // Server

Function GetConstant(Name) Export
	
	#If Server Then
		Return CommonUse_ServerCached.GetConstant(Name);
	#Else
		Return CommonUse_ServerCall.GetConstant(Name);
	#EndIf // Server
	
EndFunction // GetConstant()