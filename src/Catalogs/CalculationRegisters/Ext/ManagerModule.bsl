
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.CalculationRegisters, "CalculationRegister");
	
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
		|FROM Catalog.CalculationRegisters
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
	    "RegistrationPeriod"
		"Recorder"
		"LineNumber"
		"CalculationType"
		"ActionPeriod"
		"BegOfActionPeriod"
		"EndOfActionPeriod"
		"BegOfBasePeriod"
		"EndOfBasePeriod"
		"Active"
		"ReversingEntry"
	);
	
EndFunction // StandardAttributes()

Function SimpleTypeProperties() Export
	
	Return Abc.Lines(
	    "ActionPeriod"
		"BasePeriod"
		"Comment"
		"DataLockControlMode"
		"FullTextSearch"
		"IncludeHelpInContents"
		"Periodicity"
		"UseStandardCommands"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
	    "Explanation"
		"ExtendedListPresentation"
		"ListPresentation"
		"Synonym"
	);
	
EndFunction // LocaleStringTypeProperties() 

Function FormTypeProperties() Export
	
	Return Abc.Lines(
		"DefaultListForm"
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
