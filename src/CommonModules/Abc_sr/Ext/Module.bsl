
Function GetDataProcessor(Name) Export
	
	If Metadata.DataProcessors.Find(Name) <> Undefined Then
		DataProcessor = DataProcessors[Name].Create();
	Else
		ExternalDataProcessorsPath = Constants.ExternalDataProcessorsPath.Get();
		DataProcessor = ExternalDataProcessors.Create(Abc.JoinPath(ExternalDataProcessorsPath, Name) + ".epf");
	EndIf; 
		
	Return DataProcessor;
	
EndFunction // GetDataProcessor()

Function GetConstant(Name) Export
	
	Return Constants[Name].Get();
	
EndFunction // GetConstant()

&AtServer
Function AttributeValue(Ref, AttributeName) Export
	
	Return Abc.AttributeValue(Ref, AttributeName); 
	
EndFunction // AttributeValue()