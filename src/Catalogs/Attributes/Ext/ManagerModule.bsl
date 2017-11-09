
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Data = Parameters.Data;	
	Parameters.Property("Ref", Ref);
	
	// precondition:
	// # (Configuration == Owner.Owner)
	
	This = Catalogs.Attributes;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	Kind = Enums.AttributeKinds[Data.Type().Name];
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Description = PropertyValues.Name;
	Object.Kind = Kind;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"ChoiceFoldersAndItems"
		"ChoiceHistoryOnInput"
		"Comment"
		"CreateOnInput"
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
	));
	
	If Kind = Enums.AttributeKinds.Dimension Then
		Abc.Fill(Object, PropertyValues, Abc.Lines(
			"Balance"
			"BaseDimension"
			"DenyIncompleteValues"
			"MainFilter"
			"Master"
			"UseInTotals"
		));	
	EndIf; 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		"EditFormat"
		"Format"
		"ToolTip"
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()