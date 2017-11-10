
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.Roles;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Role;
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Synonym"
	));	
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\Rights.xml");
	
	InformationRegisters.Rights.Load(ChildParameters);
	
	Object.Write();	
		
	Return Object.Ref;
	
EndFunction // Load()
