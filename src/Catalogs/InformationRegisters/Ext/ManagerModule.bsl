
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.InformationRegisters, "InformationRegister");
	
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
		|FROM Catalog.InformationRegisters
		|WHERE Owner = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Return Table;
	
EndFunction // Cache()

#EndRegion // Cache

#Region ObjectDescription

Function StandardAttributes() Export
	
	Return Abc.Lines(
	    "Period"
		"Recorder"
		"LineNumber"
		"Active"
	);
	
EndFunction // StandardAttributes()

Function SimpleTypeProperties() Export
	
	Return Abc.Lines(
	    "Comment"
		"DataLockControlMode"
		"EditType"
		"EnableTotalsSliceFirst"
		"EnableTotalsSliceLast"
		"FullTextSearch"
		"IncludeHelpInContents"
		"InformationRegisterPeriodicity"
		"MainFilterOnPeriod"
		"UseStandardCommands"
		"WriteMode"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
	    "Explanation"
		"ExtendedListPresentation"
		"ExtendedRecordPresentation"
		"ListPresentation"
		"RecordPresentation"
		"Synonym"
	);
	
EndFunction // LocaleStringTypeProperties() 

Function FormTypeProperties() Export
	
	Return Abc.Lines(
		"DefaultListForm"
		"DefaultRecordForm"
	);
	
EndFunction // FormTypeProperties() 

Function ChildObjectNames() Export
	
	Return Abc.Lines(
		"Form"
		"Attribute"
		"Dimension"
		"Resource"
		"Command"
		"Template"
	);
	
EndFunction // ChildObjectNames() 

Function ModuleKinds() Export
	Var ModuleKinds;
	
	ModuleKinds = New Array;
	ModuleKinds.Add(Enums.ModuleKinds.ManagerModule);
	ModuleKinds.Add(Enums.ModuleKinds.RecordSetModule);
	
	Return ModuleKinds; 
	
EndFunction // ModuleKinds()

#EndRegion // ObjectDescription
