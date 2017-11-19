
Function Load(Context, Name) Export
	
	Return Meta.GenericLoad(Context, Name, Catalogs.Languages, "Language");
	
EndFunction // Load()  

#Region Cache

Function CachedFields() Export
	
	Return "UUID, Name, Owner, SHA1, LanguageCode";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.Languages
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
	    "LanguageCode"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Undefined;
	
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