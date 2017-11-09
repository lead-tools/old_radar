
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner)
	// # Path is folder path
	
	This = Catalogs.Catalogs;
	
	Data = Meta.ReadMetadataXML(Path + ".xml");
	Catalog = Data.Catalog;
	PropertyValues = Catalog.Properties;
	ChildObjects = Catalog.ChildObjects;
	UUID = Catalog.UUID; 
	
	// Properties
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
	    "Autonumbering"
		"CheckUnique"
		"ChoiceDataGetModeOnInputByString"
		"ChoiceHistoryOnInput"
		"ChoiceMode"
		"CodeAllowedLength"
		"CodeLength"
		"CodeSeries"
		"CodeType"
		"Comment"
		"CreateOnInput"
		"DataLockControlMode"
		"DefaultPresentation"
		"DescriptionLength"
		"EditType"
		"FoldersOnTop"
		"FullTextSearch"
		"FullTextSearchOnInputByString"
		"Hierarchical"
		"HierarchyType"
		"IncludeHelpInContents"
		"LevelCount"
		"LimitLevelCount"
		"PredefinedDataUpdate"
		"QuickChoice"
		"SearchStringModeOnInputByString"
		"SubordinationUse"
		"UseStandardCommands"
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
		"Explanation"
		"ExtendedListPresentation"
		"ExtendedObjectPresentation"
		"ListPresentation"
		"ObjectPresentation"
		"Synonym"
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
			"AuxiliaryChoiceForm"
			"AuxiliaryFolderChoiceForm"
			"AuxiliaryFolderForm"
			"AuxiliaryListForm"
			"AuxiliaryObjectForm"
			"DefaultChoiceForm"
			"DefaultFolderChoiceForm"
			"DefaultFolderForm"
			"DefaultListForm"
			"DefaultObjectForm"
		) Do
		
		FormFullName = PropertyValues[PropertyName];
		FormName = Mid(FormFullName, StrFind(FormFullName, ".", SearchDirection.FromEnd) + 1);
		
		If Not IsBlankString(FormName) Then
			If Not Forms.Property(FormName, Object[PropertyName]) Then
				Raise "form not found";
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
	
	For Each TemplateData In ChildObjects.Template Do
		ChildParameters.Data = TemplateData;
		Command = Catalogs.Templates.Load(ChildParameters);
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
