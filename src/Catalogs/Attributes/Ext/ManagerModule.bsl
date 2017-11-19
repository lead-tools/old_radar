
Function Load(Context, Data) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner.Owner)
	
	This = Catalogs.Attributes;
	MetaName = "Attribute";
	
	Properties = Data.Properties;
	UUID = Data.UUID; 
	Kind = Enums.AttributeKinds[Data.Type().Name];
	
	CacheItem = Meta.CacheItem(Cache, MetaName, New Structure("UUID", UUID));  
	
	CacheItem.Owner = Owner;	
	CacheItem.Name = Properties.Name;
	CacheItem.Kind = Kind;
	
	BeginTransaction();
	
	Object = Meta.GetObject(This, CacheItem);
	
	// Cached fields  
		
	FillPropertyValues(Object, CacheItem, CachedFields());
	
	// Properties
	
	Object.Config = Config;
	
	Abc.Fill(Object, Properties, Abc.Lines(
		"ChoiceFoldersAndItems"
		"ChoiceHistoryOnInput"
		"Comment"
		"CreateOnInput"
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
	));
	
	If Kind = Enums.AttributeKinds.Dimension Then
		Abc.Fill(Object, Properties, Abc.Lines(
			"Balance"
			"BaseDimension"
			"DenyIncompleteValues"
			"MainFilter"
			"Master"
			"UseInTotals"
		));	
	EndIf; 
	
	Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
	    "Synonym"
		"EditFormat"
		"Format"
		"ToolTip"
	));
		
	Object.Write();	
	
	CommitTransaction();
	
	Return CacheItem.Ref;
	
EndFunction // Load()

Function CachedFields() Export
	
	Return "UUID, Name, Owner, Kind";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT
		|	Ref, %1
		|FROM Catalog.Attributes
		|WHERE
		|	Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Table.Indexes.Add("UUID");
	
	Return Table;
	
EndFunction // Cache()