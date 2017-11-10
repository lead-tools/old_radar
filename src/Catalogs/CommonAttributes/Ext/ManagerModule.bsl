
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;	
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.CommonAttributes;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").CommonAttribute;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
	    "AuthenticationSeparation"
		"AutoUse"
		"ChoiceHistoryOnInput"
		"Comment"
		"ConfigurationExtensionsSeparation"
		"CreateOnInput"
		"DataSeparation"
		"ExtendedEdit"
		"FillChecking"
		"FillFromFillingValue"
		"FullTextSearch"
		"Indexing"
		"MarkNegatives"
		"Mask"
		"MultiLine"
		"PasswordMode"
		"QuickChoice"
		"SeparatedDataUse"
		"UsersSeparation"
	)); 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		"EditFormat"
		"Format"
		"ToolTip"
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()