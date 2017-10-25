
Function AttributeValue(Ref, AttributeName) Export
	
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames, "Catalog.Configurations");
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path) Export
		
	Data = Abc.ReadMetadataXML(JoinPath(Path, "Configuration.xml"));
	
	LoadCatalogs(Configuration, Path, Data.Configuration.ChildObjects.Catalog);
	
EndProcedure // Load()

Procedure LoadCatalogs(Configuration, Path, List)
	
	CatalogsPath = JoinPath(Path, "Catalogs");
	
	If TypeOf(List) = Type("String") Then
		
		Catalogs.Catalogs.Load(Configuration, JoinPath(CatalogsPath, List));
		
	ElsIf TypeOf(List) = Type("XDTOList") Then
		
		For Each Item In List Do
			Catalogs.Catalogs.Load(Configuration, JoinPath(CatalogsPath, Item));
		EndDo; 
		
	Else
		Raise "Call in violation of protocol";
	EndIf; 
	
EndProcedure // LoadCatalogs() 