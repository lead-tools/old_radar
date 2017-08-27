
#If Server Then

Function GetDataProcessor(Name) Export
	
	Return CommonUse_ServerCached.GetDataProcessor(Name);
	
EndFunction // GetDataProcessor()

#EndIf // Server