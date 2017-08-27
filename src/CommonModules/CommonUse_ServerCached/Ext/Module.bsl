
Function GetDataProcessor(Name) Export
	
	If Metadata.DataProcessors.Find(Name) <> Undefined Then
		DataProcessor = DataProcessors[Name].Create();
	Else
		ExternalDataProcessorsPath = Constants.ExternalDataProcessorsPath.Get();
		DataProcessor = ExternalDataProcessors.Create(JoinPath(ExternalDataProcessorsPath, Name) + ".epf");
	EndIf; 
	
	DataProcessor.Init();
	
	Return DataProcessor;
	
EndFunction // GetDataProcessor() 