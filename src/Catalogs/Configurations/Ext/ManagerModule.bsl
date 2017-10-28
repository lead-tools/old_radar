
Function AttributeValue(Ref, AttributeName) Export
	
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames);
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path) Export
		
	Data = Abc.ReadMetadataXML(Abc.JoinPath(Path, "Configuration.xml"));
	
	ChildObjects = Data.Configuration.ChildObjects;
	Items = New Structure;
	For Each Property In ChildObjects.Properties() Do
		Items.Insert(Property.Name, ChildObjects[Property.Name]);
	EndDo; 
	
	List = Undefined;
	
	If Items.Property("Language", List) Then
		LoadMetadata(Configuration, Path, "Languages", ChildObjects.Language);
	EndIf; 
	
	If Items.Property("AccountingRegister", List) Then
		LoadMetadata(Configuration, Path, "AccountingRegisters", ChildObjects.AccountingRegister);
	EndIf; 
	
	If Items.Property("AccumulationRegister", List) Then
		LoadMetadata(Configuration, Path, "AccumulationRegisters", ChildObjects.AccumulationRegister);
	EndIf;
	
	If Items.Property("BusinessProcess", List) Then
		LoadMetadata(Configuration, Path, "BusinessProcesses", ChildObjects.BusinessProcess);
	EndIf; 
	
	If Items.Property("CalculationRegister", List) Then
		LoadMetadata(Configuration, Path, "CalculationRegisters", List);
	EndIf;
	
	If Items.Property("Catalog", List) Then
		LoadMetadata(Configuration, Path, "Catalogs", ChildObjects.Catalog);
	EndIf;
	
	If Items.Property("ChartOfAccounts", List) Then
		LoadMetadata(Configuration, Path, "ChartsOfAccounts", List);
	EndIf;
	
EndProcedure // Load()

Procedure LoadMetadata(Configuration, Path, Name, List)
	
	MetadataPath = Abc.JoinPath(Path, Name);
	MetadataManager = Catalogs[Name];
	
	If TypeOf(List) = Type("String") Then
		MetadataManager.Load(Configuration, Abc.JoinPath(MetadataPath, List));
	ElsIf TypeOf(List) = Type("XDTOList") Then
		For Each Item In List Do
			MetadataManager.Load(Configuration, Abc.JoinPath(MetadataPath, Item));
		EndDo; 
	Else
		Raise "Call in violation of protocol";
	EndIf; 
	
EndProcedure // LoadMetadata()
 