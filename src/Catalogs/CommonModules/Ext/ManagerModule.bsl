
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.CommonModules;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").CommonModule;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
	    "ClientManagedApplication"
		"ClientOrdinaryApplication"
		"Comment"
		"ExternalConnection"
		"Global"
		"Privileged"
		"ReturnValuesReuse"
		"Server"
		"ServerCall"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\Module.bsl");

	ChildParameters.Insert("ModuleKind", Enums.ModuleKinds.CommonModule);
	ChildParameters.Insert("ModuleRef", Object.Module);
		
	Object.Module = Catalogs.Modules.Load(ChildParameters);
	
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()