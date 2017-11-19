
Function Load(Context, Data) Export
	Var Object;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	
	// precondition:
	// # (Config == Owner.Owner)
	
	This = Catalogs.StandardAttributes;
	MetaName = "StandardAttribute"; 
	
	Properties = Data;
	Name = Properties.Name;
		
	CacheItem = Meta.CacheItem(Cache, MetaName, New Structure("Owner, Name", Owner, Name));
	
	BeginTransaction();
	
	If Not ValueIsFilled(CacheItem.Ref) Then
		Object = This.CreateItem();
		CacheItem.Ref = This.GetRef();
		Object.SetNewObjectRef(CacheItem.Ref);
	Else
		Object = CacheItem.Ref.GetObject();
	EndIf;  
	
	// Cached fields  
		
	FillPropertyValues(Object, CacheItem, CachedFields());
	
	// Properties
	
	Object.Config = Config;
	
	Abc.Fill(Object, Properties, Abc.Lines(
		"ChoiceHistoryOnInput"
		"Comment"
		"CreateOnInput"
		"ExtendedEdit"
		"FillChecking"
		"FillFromFillingValue"
		"FullTextSearch"
		"MarkNegatives"
		"Mask"
		"MultiLine"
		"PasswordMode"
		"QuickChoice"
	)); 
	
	Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, Abc.Lines(
	    "Synonym"
		"Format"
		"ToolTip"
	));
		
	Object.Write();	
	
	CommitTransaction();
	
	Return CacheItem.Ref;
	
EndFunction // Load()

Function CachedFields() Export
	
	Return "Name, Owner";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.StandardAttributes
		|WHERE
		|	Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Return Table;
	
EndFunction // Cache()