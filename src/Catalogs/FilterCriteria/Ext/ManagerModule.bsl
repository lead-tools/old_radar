﻿
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.FilterCriteria, "FilterCriterion");
	
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
		|FROM Catalog.FilterCriteria
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
	    "Comment"
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
		"DefaultForm"
	);
	
EndFunction // FormTypeProperties() 

Function ChildObjectNames() Export
	
	Return Abc.Lines(
		"Form"
		"Command"
	);
	
EndFunction // ChildObjectNames() 

Function ModuleKinds() Export
	Var ModuleKinds;
	
	ModuleKinds = New Array;
	ModuleKinds.Add(Enums.ModuleKinds.ManagerModule);
	
	Return ModuleKinds; 
	
EndFunction // ModuleKinds()

#EndRegion // ObjectDescription