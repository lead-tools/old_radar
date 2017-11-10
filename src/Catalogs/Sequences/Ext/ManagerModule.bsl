
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.Sequences;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Sequence;
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
		"DataLockControlMode"
		"MoveBoundaryOnPosting"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Synonym"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
		
	// Attributes
	
	AttributeOrder = Object.AttributeOrder;
	AttributeOrder.Clear();
		
	For Each DimensionData In ChildObjects.Dimension Do
		ChildParameters.Data = DimensionData;
		AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(ChildParameters);
	EndDo;
	
	ChildParameters.Data = Undefined;
	
	// Modules
	
	ChildParameters.Insert("ModuleKind");
	ChildParameters.Insert("ModuleRef");
	
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\RecordSetModule.bsl");
	ChildParameters.ModuleKind = Enums.ModuleKinds.RecordSetModule;
	ChildParameters.ModuleRef = Object.RecordSetModule;
	Object.RecordSetModule = Catalogs.Modules.Load(ChildParameters);	
		
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()
