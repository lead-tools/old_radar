
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.CommonAttributes, "CommonAttribute");
	
EndFunction // Load()

#Region Cache

Function CachedFields() Export
	
	Return "UUID, Name, Owner, SHA1";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.CommonAttributes
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
	
	Return Undefined;
	
EndFunction // StandardAttributes()

Function SimpleTypeProperties() Export
	
	Return Abc.Lines(
	    "AuthenticationSeparation"
		"AutoUse"
		"ChoiceHistoryOnInput"
		"Comment"
		"ConfigurationExtensionsSeparation"
		"CreateOnInput"
		"DataSeparation"
		"ExtendedEdit"
		"FillChecking"
		"FillFromFillingValue"
		"FullTextSearch"
		"Indexing"
		"MarkNegatives"
		"Mask"
		"MultiLine"
		"PasswordMode"
		"QuickChoice"
		"SeparatedDataUse"
		"UsersSeparation"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
	    "Synonym"
		"EditFormat"
		"Format"
		"ToolTip"
	);
	
EndFunction // LocaleStringTypeProperties() 

Function FormTypeProperties() Export
	
	Return Undefined;
	
EndFunction // FormTypeProperties() 

Function ChildObjectNames() Export
	
	Return Undefined;
	
EndFunction // ChildObjectNames() 

Function ModuleKinds() Export
	
	Return Undefined; 
	
EndFunction // ModuleKinds()

#EndRegion // ObjectDescription