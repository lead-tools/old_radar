
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	Data = Parameters.Data;
	
	// precondition:
	// # (Configuration == Owner) or (Configuration == Owner.Owner)
	// # Path is folder path
	
	This = Catalogs.Commands;
	
	Command = Data;
	PropertyValues = Command.Properties;
	UUID = Command.UUID;
		
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"Representation"
		//"IncludeHelpInContents"
		"ParameterUseMode"
		"ModifiesData"
	)); 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		"ToolTip"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	
	// Modules
	
	ChildParameters.Insert("ModuleKind");
	ChildParameters.Insert("ModuleRef");
	
	ChildParameters.Path = Abc.JoinPath(Path, StrTemplate("Commands\%1\Ext\CommandModule.bsl"));
	ChildParameters.ModuleKind = Enums.ModuleKinds.CommandModule;
	ChildParameters.ModuleRef = Object.CommandModule;
	Object.CommandModule = Catalogs.Modules.Load(ChildParameters);
	
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()