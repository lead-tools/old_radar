
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.Catalogs, "Catalog");
	
EndFunction // Load() 

#Region Cache

Function CachedFields() Export
	
	Return "UUID, Name, Owner, SHA1," + StrConcat(FormTypeProperties(), ", ");
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.Catalogs
		|WHERE Owner = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Table.Indexes.Add("Ref");
	Table.Indexes.Add("Name");
	
	Return Table;
	
EndFunction // Cache()

#EndRegion // Cache

#Region ObjectDescription

Function StandardAttributes() Export
	
	Return Abc.Lines(
		"Ref"
		"Code"
		"Description"
		"Owner"
		"Parent"
		"IsFolder"
		"DeletionMark"
		"Predefined"
		"PredefinedDataName"
	);
	
EndFunction // StandardAttributes() 

Function SimpleTypeProperties() Export
	
	Return Abc.Lines(
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
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
		"Explanation"
		"ExtendedListPresentation"
		"ExtendedObjectPresentation"
		"ListPresentation"
		"ObjectPresentation"
		"Synonym"
	);
	
EndFunction // LocaleStringTypeProperties() 

Function FormTypeProperties() Export
	
	Return Abc.Lines(
		"DefaultChoiceForm"
		"DefaultFolderChoiceForm"
		"DefaultFolderForm"
		"DefaultListForm"
		"DefaultObjectForm"
	);
	
EndFunction // FormTypeProperties() 

Function ChildObjectNames() Export
	
	Return Abc.Lines(
		"Form"
		"Attribute"
		"TabularSection"
		"Command"
		"Template"
	);
	
EndFunction // ChildObjectNames() 

Function ModuleKinds() Export
	Var ModuleKinds;
	
	ModuleKinds = New Array;
	ModuleKinds.Add(Enums.ModuleKinds.ManagerModule);
	ModuleKinds.Add(Enums.ModuleKinds.ObjectModule);
	
	Return ModuleKinds; 
	
EndFunction // ModuleKinds()

#EndRegion // ObjectDescription
