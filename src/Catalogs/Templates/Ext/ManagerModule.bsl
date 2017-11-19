
Function Load(Context, Name) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner) or (Config == Owner.Owner)
	// # Path is folder path
	
	If Config = Owner Then
		Return Meta.GenericLoad(Context, Name, Catalogs.Templates, "CommonTemplate");
	EndIf;
	
	This = Catalogs.Templates;
	
	CommonTemplate = False;
	MetaName = "Template";
	
	FilePath = Abc.JoinPath(Path, StrTemplate("Templates\%1.xml", Name));
	
	ReadResult = Meta.ReadMetadataXML(Context, FilePath, MetaName, Name);
	Data = ReadResult.Data;
	CacheItem = ReadResult.CacheItem;
	
	If Data <> Undefined Then
	
		Properties = Data.Properties;
		
		BeginTransaction();
			
		Object = Meta.GetObject(This, CacheItem);  
		
		// Properties
		
		Object.Config = Config;
		
		FillPropertyValues(Object, CacheItem, CachedFields());
		
		Abc.Fill(Object, Properties, Abc.Lines(
			"Comment"
			"TemplateType"
		));
		
		Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
		    "Synonym"
		));
			
		Object.Write();	
		
		CommitTransaction();
	
	EndIf; 
	
	Return CacheItem.Ref;
	
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
		|FROM Catalog.Templates
		|WHERE Config = &Config AND NOT Deleted",
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
		"TemplateType"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
	    "Synonym"
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