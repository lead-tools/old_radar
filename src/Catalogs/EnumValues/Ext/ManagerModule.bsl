
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Data = Parameters.Data;	
	
	// precondition:
	// # (Configuration == Owner.Owner)
	
	This = Catalogs.EnumValues;
	
	PropertyValues = Data.Properties;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
	));
		
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()