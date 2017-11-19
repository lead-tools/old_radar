
Function Load(Context, Kind) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner.Owner)
	// # Path is folder path
	
	This = Catalogs.Modules;
	MetaName = "Module";
	
	If Kind = Enums.ModuleKinds.CommandModule Then
		Name = "CommandModule";
	ElsIf Kind = Enums.ModuleKinds.ManagerModule Then
		Name = "ManagerModule";
	ElsIf Kind = Enums.ModuleKinds.ObjectModule Then
		Name = "ObjectModule";
	ElsIf Kind = Enums.ModuleKinds.RecordSetModule Then
		Name = "RecordSetModule";
	ElsIf Kind = Enums.ModuleKinds.ValueManagerModule Then
		Name = "ValueManagerModule";
	Else
		Name = "Module"
	EndIf;
		
	If Kind = Enums.ModuleKinds.FormModule Then
		FilePath = Abc.JoinPath(Path, StrTemplate("Ext\Form\%1.bsl", Name));
	Else
		FilePath = Abc.JoinPath(Path, StrTemplate("Ext\%1.bsl", Name));
	EndIf; 	
		
	If Abc.FileExists(FilePath) Then
		
		CacheItem = Meta.CacheItem(Cache, MetaName, New Structure("Kind, Owner", Kind, Owner));
		
		DataReader = New DataReader(FilePath, TextEncoding.UTF8);
		BinaryData = DataReader.Read().GetBinaryData();
		
		SHA1 = Abc.SHA1(BinaryData);
		
		If CacheItem.SHA1 <> SHA1 Then
			
			CacheItem.SHA1 = SHA1;
			
			Object = Meta.GetObject(This, CacheItem);
			
			// Cached fields  
		
			FillPropertyValues(Object, CacheItem, CachedFields());
			
			// Properties
			
			Object.Config = Config;
			
			Object.Path = FilePath;
			Object.Data = New ValueStorage(BinaryData, New Deflation);;
			
			Object.Write();
			
		EndIf; 
		
		Return CacheItem.Ref;
		
	EndIf; 
	
	Return Undefined;
	
EndFunction // Load()

Function CachedFields() Export
	
	Return "Kind, Owner, SHA1";
	
EndFunction // CachedFields()

Function Cache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text = StrTemplate(
		"SELECT Ref, %1
		|FROM Catalog.Modules
		|WHERE Config = &Config AND NOT Deleted",
		CachedFields()
	);
	
	Table = Query.Execute().Unload();
	
	Table.Columns.Add("Mark", New TypeDescription("Boolean"));
	
	Table.Indexes.Add("Kind, Owner");
	
	Return Table;
	
EndFunction // Cache()
