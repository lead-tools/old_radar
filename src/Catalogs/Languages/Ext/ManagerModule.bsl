
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.Languages;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Language;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
	    "LanguageCode"
	));
	
	//Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	//    "Synonym"
	//));
	
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()