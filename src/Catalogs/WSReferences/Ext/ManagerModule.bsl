
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.WSReferences;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").WSReference;
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"LocationURL"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Synonym"
	));	
		
	Object.Write();	
		
	Return Object.Ref;
	
EndFunction // Load()
