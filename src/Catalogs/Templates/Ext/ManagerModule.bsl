
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner) or (Configuration == Owner.Owner)
	// # Path is folder path
	
	This = Catalogs.Templates;
	
	IsCommonTemplate = (Configuration = Owner);
	
	If IsCommonTemplate Then
		Data = Meta.ReadMetadataXML(Path + ".xml").CommonTemplate;
	Else
		Data = Meta.ReadMetadataXML(Path + ".xml").Template;
	EndIf;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"TemplateType"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()