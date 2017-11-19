
Function Load(Context, Data) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner.Owner)
	
	This = Catalogs.TabularSections;
	MetaName = "TabularSection";
	
	Properties = Data.Properties;
	ChildObjects = Data.ChildObjects;
	UUID = Data.UUID;
	
	CacheItem = Meta.CacheItem(Context.Cache, MetaName, New Structure("UUID", UUID));
	
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
		"FillChecking"
	)); 
	
	Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
	    "Synonym"
		"ToolTip"
	));
	
	ChildContext = Meta.LoadContext(Config, CacheItem.Ref, Cache);
	
	// Standard attributes
	
	If Properties.StandardAttributes <> Undefined Then
		For Each StandardAttributeData In Properties.StandardAttributes.StandardAttribute Do
			StandardAttribute = Catalogs.StandardAttributes.Load(ChildContext, StandardAttributeData);
		EndDo; 
	EndIf; 
	
	// Attributes
	
	AttributeOrder = Object.AttributeOrder;
	AttributeOrder.Clear();
		
	For Each AttributeData In ChildObjects.Attribute Do
		AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(ChildContext, AttributeData);
	EndDo;
	
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
		|FROM Catalog.TabularSections
		|WHERE Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Table.Indexes.Add("UUID");
	
	Return Table;
	
EndFunction // Cache()