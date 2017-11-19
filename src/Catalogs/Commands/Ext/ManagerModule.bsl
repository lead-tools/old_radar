
Function Load(Context, Data) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner.Owner)
	// # Path is folder path
	
	This = Catalogs.Commands;
	MetaName = "Command";
	
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
		"Representation"
		"ParameterUseMode"
		"ModifiesData"
	)); 
	
	Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
	    "Synonym"
		"ToolTip"
	));
	
	Object.Write();
	
	ChildContext = Meta.LoadContext(Config, CacheItem.Ref, Cache, Abc.JoinPath(Path, "Commands\" + Properties.Name));
	
	// Module
	
	CommandModule = Catalogs.Modules.Load(
		ChildContext,
		Enums.ModuleKinds.CommandModule
	);	
	
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
		|FROM Catalog.Commands
		|WHERE Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Table.Indexes.Add("UUID");
	
	Return Table;
	
EndFunction // Cache()
 