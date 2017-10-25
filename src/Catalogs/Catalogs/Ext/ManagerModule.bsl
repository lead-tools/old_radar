
Function AttributeValue(Ref, AttributeName) Export
		
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames, "Catalog.Catalogs");
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path, Catalog = Undefined) Export
	
	Data = Abc.ReadMetadataXML(Path + ".xml");
	UUID = New UUID(Data.Catalog.UUID);
	
	If Catalog = Undefined Then
		Catalog = Meta.RefByUUID(Configuration, UUID); 
	EndIf; 
	
	If Catalog = Undefined Then
		CatalogObject = Catalogs.Catalogs.CreateItem();
	Else
		CatalogObject = Catalog.GetObject();
	EndIf; 
	
	Meta.FillAttributesByXDTOProperties(CatalogObject, Data.Catalog.Properties); 
	
EndProcedure // Load()