
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;	
	
	// precondition:
	// # (Configuration == Owner)
	
	This = Catalogs.Constants;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Constant;
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"ChoiceFoldersAndItems"
		"ChoiceHistoryOnInput"
		"Comment"
		"DataLockControlMode"
		"ExtendedEdit"
		"FillChecking"
		"MarkNegatives"
		"Mask"
		"MultiLine"
		"PasswordMode"
		"QuickChoice"
		"UseStandardCommands"
	)); 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"EditFormat"
		"Explanation"
		"ExtendedPresentation"
		"Format"
		"Synonym"
		"ToolTip"
	));
		
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\ValueManagerModule.bsl");

	ChildParameters.Insert("ModuleKind", Enums.ModuleKinds.ValueManagerModule);
	ChildParameters.Insert("ModuleRef", Object.ValueManagerModule);
		
	Object.ValueManagerModule = Catalogs.Modules.Load(ChildParameters);
	
	Object.Write();	
	
	CommitTransaction();
	
	
	Return Object.Ref;
	
EndFunction // Load()