
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.Reports;
	
	Data = Meta.ReadMetadataXML(Path + ".xml").Report;
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
		"IncludeHelpInContents"
		"UseStandardCommands"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Explanation"
		"ExtendedPresentation"
		"Synonym"
	));
	
	BeginTransaction();
	
	ChildParameters = Meta.ObjectLoadParameters();
	ChildParameters.Configuration = Configuration;
	ChildParameters.Owner = Ref;
		
	// Attributes
	
	AttributeOrder = Object.AttributeOrder;
	AttributeOrder.Clear();
		
	For Each AttributeData In ChildObjects.Attribute Do
		ChildParameters.Data = AttributeData;
		AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(ChildParameters);
	EndDo;
	
	ChildParameters.Data = Undefined;
	
	// Tabular sections
	
	For Each TabularSectionData In ChildObjects.TabularSection Do
		ChildParameters.Data = TabularSectionData;
		Catalogs.TabularSections.Load(ChildParameters);
	EndDo;
	
	// Forms
	
	Forms = New Structure;
	
	For Each FormName In ChildObjects.Form Do
		ChildParameters.Path = Abc.JoinPath(Path, "Forms\" + FormName);
		Forms.Insert(FormName, Catalogs.Forms.Load(ChildParameters));
	EndDo; 
	
	For Each PropertyName In Abc.Lines(
			"AuxiliaryForm"
			"AuxiliarySettingsForm"
			"DefaultForm"
			"DefaultSettingsForm"
			"DefaultVariantForm"
		) Do
		
		FormFullName = PropertyValues[PropertyName];
		
		If StrStartsWith(FormFullName, "CommonForm.") Then
			
			// TODO
			
		Else
			
			FormName = Mid(FormFullName, StrFind(FormFullName, ".", SearchDirection.FromEnd) + 1);
			
			If Not IsBlankString(FormName) Then
				If Mid(FormName, 9, 1) = "-" // UUID
					Or Not Forms.Property(FormName, Object[PropertyName]) Then
					Message(StrTemplate("form not found [%1; %2; %3]", Path, PropertyName, FormFullName));
				EndIf; 
			EndIf;
			
		EndIf; 
		
	EndDo; 
	
	// Commands
	
	ChildParameters.Path = Path;
	
	For Each CommandData In ChildObjects.Command Do
		ChildParameters.Data = CommandData;
		Command = Catalogs.Commands.Load(ChildParameters);
	EndDo;	
	
	ChildParameters.Path = Undefined;
	ChildParameters.Data = Undefined;
	
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
	
	ChildParameters.Path = Abc.JoinPath(Path, "Ext\ObjectModule.bsl");
	ChildParameters.ModuleKind = Enums.ModuleKinds.ObjectModule;
	ChildParameters.ModuleRef = Object.ObjectModule;
	Object.ObjectModule = Catalogs.Modules.Load(ChildParameters);
	
	Object.Write();	
	
	CommitTransaction();
	
	Return Object.Ref;
	
EndFunction // Load()
