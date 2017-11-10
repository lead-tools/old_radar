
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.SettingsStorages;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").SettingsStorage;
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
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Synonym"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
		
	// Forms
	
	Forms = New Structure;
	
	For Each FormName In ChildObjects.Form Do
		ChildParameters.Path = Abc.JoinPath(Path, "Forms\" + FormName);
		Forms.Insert(FormName, Catalogs.Forms.Load(ChildParameters));
	EndDo; 
	
	For Each PropertyName In Abc.Lines(
			"AuxiliaryLoadForm"
			"AuxiliarySaveForm"
			"DefaultLoadForm"
			"DefaultSaveForm"
		) Do
		
		FormFullName = PropertyValues[PropertyName];
		FormName = Mid(FormFullName, StrFind(FormFullName, ".", SearchDirection.FromEnd) + 1);
		
		If Not IsBlankString(FormName) Then
			If Not Forms.Property(FormName, Object[PropertyName]) Then
				Raise "form not found";
			EndIf; 
		EndIf; 
		
	EndDo;	
	
	ChildParameters.Path = Undefined;
	
	// Templates
	
	For Each TemplateName In ChildObjects.Template Do
		ChildParameters.Path = Abc.JoinPath(Path, "Templates\" + TemplateName);
		Template = Catalogs.Templates.Load(ChildParameters);
	EndDo;
	
	ChildParameters.Data = Undefined;
	
	// Modules
	
	ChildParameters.Insert("ModuleKind");
	ChildParameters.Insert("ModuleRef");
	
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\ManagerModule.bsl");
	ChildParameters.ModuleKind = Enums.ModuleKinds.ManagerModule;
	ChildParameters.ModuleRef = Object.ManagerModule;
	Object.ManagerModule = Catalogs.Modules.Load(ChildParameters);	
	
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()
