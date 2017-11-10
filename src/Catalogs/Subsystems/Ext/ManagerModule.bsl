
Function Load(Parameters) Export
	Var Ref, Parent;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	Parameters.Property("Parent", Parent);
	
	// precondition:
	// # Parent is subsystem
	// # Path is folder path
	
	This = Catalogs.Subsystems;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Subsystem;
	PropertyValues = Data.Properties;
	ChildObjects = Data.ChildObjects;
	UUID = Data.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Parent = Parent;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
	    "Comment"
		"IncludeHelpInContents"
		"IncludeInCommandInterface"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Explanation"
		"Synonym"
	));
	
	Object.Write();
	
	// Operations
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Owner;
	ChildParameters.Insert("Parent", Ref);
	
	For Each Subsystem In ChildObjects.Subsystem Do
		
		ChildParameters.Path = Abc.JoinPath(Path, "Subsystems\" + Subsystem);
		This.Load(ChildParameters);
		
	EndDo;	
	
	Return Object.Ref;
	
EndFunction // Load()