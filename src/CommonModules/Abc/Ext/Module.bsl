
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer

Function GetConstant(Name) Export
	
	#If Server Then
		Return Abc_sr.GetConstant(Name);
	#Else
		Return Abc_sc.GetConstant(Name);
	#EndIf // Server
	
EndFunction // GetConstant()

#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

&AtServer	
Function GetDataProcessor(Name) Export
	
	Return Abc_sr.GetDataProcessor(Name);
	
EndFunction // GetDataProcessor()

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client