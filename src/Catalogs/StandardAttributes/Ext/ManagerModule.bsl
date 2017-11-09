
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Data = Parameters.Data;
	
	// precondition:
	// # (Configuration == Owner.Owner)
	
	This = Catalogs.StandardAttributes;
	
	PropertyValues = Data;
	
	If Ref = Undefined Then
		Ref = This.FindByDescription(PropertyValues.Name, True,, Owner);
	EndIf; 
	
	If Not ValueIsFilled(Ref) Then
		Object = This.CreateItem();
		Ref = This.GetRef();
		Object.SetNewObjectRef(Ref);
	Else
		Object = Ref.GetObject();
	EndIf;  
	
	// Properties
	
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"ChoiceHistoryOnInput"
		"Comment"
		"CreateOnInput"
		"ExtendedEdit"
		"FillChecking"
		"FillFromFillingValue"
		"FullTextSearch"
		"MarkNegatives"
		"Mask"
		"MultiLine"
		"PasswordMode"
		"QuickChoice"
	)); 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		"Format"
		"ToolTip"
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()