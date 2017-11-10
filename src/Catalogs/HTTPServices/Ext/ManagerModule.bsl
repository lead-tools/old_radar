
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.HTTPServices;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").HTTPService;
	PropertyValues = Data.Properties;
	ChildObjects = Data.ChildObjects;
	UUID = Data.UUID; 
	
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"ReuseSessions"
		"RootURL"
		"SessionMaxAge"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Synonym"
	));
	
	// URLTemplates
	
	For Each URLTemplate In ChildObjects.URLTemplate Do
		// ...	
	EndDo;
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	
	// Modules
	
	ChildParameters.Insert("ModuleKind");
	ChildParameters.Insert("ModuleRef");
	
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\Module.bsl");
	ChildParameters.ModuleKind = Enums.ModuleKinds.HTTPServiceModule;
	ChildParameters.ModuleRef = Object.Module;
	Object.Module = Catalogs.Modules.Load(ChildParameters);	
		
	Object.Write();	
		
	Return Object.Ref;
	
EndFunction // Load()
