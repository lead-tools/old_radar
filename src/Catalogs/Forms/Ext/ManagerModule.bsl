
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
		Return Meta.GenericLoad(Context, Name, Catalogs.Forms, "CommonForm");
	EndIf;
	
	This = Catalogs.Forms;
	
	MetaName = "Form";
	
	FilePath = Abc.JoinPath(Path, StrTemplate("Forms\%1.xml", Name));
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
			"FormType"
			"IncludeHelpInContents"
		));
		
		Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
		    "Synonym"
		)); 
		
		Object.Write();
		
		ModulePath = Abc.JoinPath(Path, StrTemplate("Forms\%1", Name));
		
		ChildContext = Meta.LoadContext(Config, CacheItem.Ref, Cache, ModulePath);
		
		// Module
		
		FormModule = Catalogs.Modules.Load(
			ChildContext,
			Enums.ModuleKinds.FormModule
		);
		
		CommitTransaction();
		
	EndIf;
	
	Return CacheItem.Ref;
	
EndFunction // Load()

Function FormNames(Cache, Owner) Export
	
	FormNames = New Array;
	
	For Each Item In Cache.Form.FindRows(New Structure("Owner", Owner)) Do
		FormNames.Add(Item.Name);
	EndDo; 
	
	Return FormNames;
	
EndFunction // FormNames()

#Region Cache

Function CachedFields() Export
	
	Return "UUID, Name, Owner, SHA1";
	
EndFunction // CachedFields() 

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.Forms
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
		"FormType"
		"IncludeHelpInContents"
		"UseStandardCommands"
	);
	
EndFunction // SimpleTypeProperties() 

Function LocaleStringTypeProperties() Export
	
	Return Abc.Lines(
	    "Synonym"
		"Explanation"
		"ExtendedPresentation"
	);
	
EndFunction // LocaleStringTypeProperties() 

Function FormTypeProperties() Export
	
	Return Undefined;
	
EndFunction // FormTypeProperties() 

Function ChildObjectNames() Export
	
	Return Undefined;
	
EndFunction // ChildObjectNames() 

Function ModuleKinds() Export
	Var ModuleKinds;
	
	ModuleKinds = New Array;
	ModuleKinds.Add(Enums.ModuleKinds.FormModule);
	
	Return ModuleKinds; 
	
EndFunction // ModuleKinds()

#EndRegion // ObjectDescription
