
Function Load(Context, Data) Export
	Var Ref;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	
	// precondition:
	// # (Config == Owner.Owner)
	
	This = Catalogs.EnumValues;
	MetaName = "EnumValue";
	
	Properties = Data.Properties;
	UUID = Data.UUID;
	
	CacheItem = Meta.CacheItem(Cache, MetaName, New Structure("UUID", UUID));
	
	CacheItem.Owner = Owner;	
	CacheItem.Name = Properties.Name;
	
	BeginTransaction();
	
	Object = Meta.GetObject(This, CacheItem);  
	
	// Cached fields  
		
	FillPropertyValues(Object, CacheItem, CachedFields());
	
	// Properties
	
	Object.Config = Config;
	
	Abc.Fill(Object, Properties, Abc.Lines(
		"Comment"
	));
		
	Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
	    "Synonym"
	));
		
	Object.Write();	
	
	CommitTransaction();
	
	Return CacheItem.Ref;
	
EndFunction // Load()

Function CachedFields() Export
	
	Return "UUID, Name, Owner";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.EnumValues
		|WHERE
		|	Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Return Table;
	
EndFunction // Cache()