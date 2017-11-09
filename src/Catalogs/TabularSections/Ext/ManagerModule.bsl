
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Data = Parameters.Data;
	
	// precondition:
	// # (Configuration == Owner.Owner)
	
	This = Catalogs.TabularSections;
	
	TabularSection = Data;
	PropertyValues = TabularSection.Properties;
	ChildObjects = TabularSection.ChildObjects;
	UUID = TabularSection.UUID;
		
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"FillChecking"
	)); 
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		"ToolTip"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
	
	// Standard attributes
	
	If PropertyValues.StandardAttributes <> Undefined Then
		For Each StandardAttributeData In PropertyValues.StandardAttributes.StandardAttribute Do
			ChildParameters.Data = StandardAttributeData;
			StandardAttribute = Catalogs.StandardAttributes.Load(ChildParameters);
		EndDo; 
	EndIf; 
	
	// Attributes
	
	AttributeOrder = Object.AttributeOrder;
	AttributeOrder.Clear();
		
	For Each AttributeData In ChildObjects.Attribute Do
		ChildParameters.Data = AttributeData;
		AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(ChildParameters);
	EndDo;
	
	ChildParameters.Data = Undefined;
	
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()