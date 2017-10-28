
Function AttributeValue(Ref, AttributeName) Export
		
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames);
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path, Catalog = Undefined) Export
	
	Data = Abc.ReadMetadataXML(Path + ".xml");
	XDTOProperties = Data.Catalog.Properties;
	UUID = New UUID(Data.Catalog.UUID);
	
	If Catalog = Undefined Then
		Catalog = Catalogs.Catalogs.FindByAttribute("UUID", UUID,, Configuration);
	EndIf; 
	
	If Not ValueIsFilled(Catalog) Then
		CatalogObject = Catalogs.Catalogs.CreateItem();
	Else
		CatalogObject = Catalog.GetObject();
	EndIf; 
	
	CatalogObject.UUID = UUID;
	CatalogObject.Owner = Configuration;
	CatalogObject.Description = XDTOProperties.Name;
	
	Meta.FillAttributesByXDTOProperties(Configuration, CatalogObject, XDTOProperties); 
	
	CatalogObject.Write();
	
EndProcedure // Load()