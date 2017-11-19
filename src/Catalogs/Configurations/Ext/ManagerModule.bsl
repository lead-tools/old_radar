
Procedure Load(Configuration, Path) Export
	Var SHA1;
	
	Message("Configuration start: " + CurrentDate());
	
	Cache = Cache(Configuration);
	
	Context = Meta.LoadContext(Configuration, Configuration, Undefined, Undefined);
	
	ReadResult = Meta.ReadMetadataXML(Context, Abc.JoinPath(Path, "Configuration.xml"), "Configuration", Undefined);
	Data = ReadResult.Data;
	
	ChildObjects = Data.ChildObjects;
		
	LoadMetadata(Configuration, Cache, Path, "Languages",                   ChildObjects.Language);
	LoadMetadata(Configuration, Cache, Path, "AccountingRegisters",         ChildObjects.AccountingRegister);
	LoadMetadata(Configuration, Cache, Path, "AccumulationRegisters",       ChildObjects.AccumulationRegister);
	LoadMetadata(Configuration, Cache, Path, "BusinessProcesses",           ChildObjects.BusinessProcess);
	LoadMetadata(Configuration, Cache, Path, "CalculationRegisters",        ChildObjects.CalculationRegister);
	LoadMetadata(Configuration, Cache, Path, "Catalogs",                    ChildObjects.Catalog);
	LoadMetadata(Configuration, Cache, Path, "ChartsOfAccounts",            ChildObjects.ChartOfAccounts);
	LoadMetadata(Configuration, Cache, Path, "ChartsOfCalculationTypes",    ChildObjects.ChartOfCalculationTypes);
	LoadMetadata(Configuration, Cache, Path, "ChartsOfCharacteristicTypes", ChildObjects.ChartOfCharacteristicTypes);
	LoadMetadata(Configuration, Cache, Path, "CommandGroups",               ChildObjects.CommandGroup);
	LoadMetadata(Configuration, Cache, Path, "CommonAttributes",            ChildObjects.CommonAttribute);
	LoadMetadata(Configuration, Cache, Path, "CommonCommands",              ChildObjects.CommonCommand);
	LoadMetadata(Configuration, Cache, Path, "Forms",                       ChildObjects.CommonForm, "CommonForms");
	LoadMetadata(Configuration, Cache, Path, "CommonModules",               ChildObjects.CommonModule);
	LoadMetadata(Configuration, Cache, Path, "CommonPictures",              ChildObjects.CommonPicture);
	LoadMetadata(Configuration, Cache, Path, "Templates",                   ChildObjects.CommonTemplate, "CommonTemplates");
	LoadMetadata(Configuration, Cache, Path, "Constants",                   ChildObjects.Constant);
	LoadMetadata(Configuration, Cache, Path, "DataProcessors",              ChildObjects.DataProcessor);
	LoadMetadata(Configuration, Cache, Path, "DocumentJournals",            ChildObjects.DocumentJournal);
	LoadMetadata(Configuration, Cache, Path, "DocumentNumerators",          ChildObjects.DocumentNumerator);
	LoadMetadata(Configuration, Cache, Path, "Documents",                   ChildObjects.Document);
	LoadMetadata(Configuration, Cache, Path, "Enums",                       ChildObjects.Enum);
	LoadMetadata(Configuration, Cache, Path, "EventSubscriptions",          ChildObjects.EventSubscription);
	LoadMetadata(Configuration, Cache, Path, "ExchangePlans",               ChildObjects.ExchangePlan);
	LoadMetadata(Configuration, Cache, Path, "FilterCriteria",              ChildObjects.FilterCriterion);
	LoadMetadata(Configuration, Cache, Path, "FunctionalOptions",           ChildObjects.FunctionalOption);
	LoadMetadata(Configuration, Cache, Path, "FunctionalOptionsParameters", ChildObjects.FunctionalOptionsParameter);
	LoadMetadata(Configuration, Cache, Path, "HTTPServices",                ChildObjects.HTTPService);
	LoadMetadata(Configuration, Cache, Path, "InformationRegisters",        ChildObjects.InformationRegister);
	LoadMetadata(Configuration, Cache, Path, "Reports",                     ChildObjects.Report);
	LoadMetadata(Configuration, Cache, Path, "Roles",                       ChildObjects.Role);
	LoadMetadata(Configuration, Cache, Path, "ScheduledJobs",               ChildObjects.ScheduledJob);
	LoadMetadata(Configuration, Cache, Path, "Sequences",                   ChildObjects.Sequence);
	LoadMetadata(Configuration, Cache, Path, "SessionParameters",           ChildObjects.SessionParameter);
	LoadMetadata(Configuration, Cache, Path, "SettingsStorages",            ChildObjects.SettingsStorage);
	LoadMetadata(Configuration, Cache, Path, "Subsystems",                  ChildObjects.Subsystem);
	LoadMetadata(Configuration, Cache, Path, "Tasks",                       ChildObjects.Task);
	LoadMetadata(Configuration, Cache, Path, "WebServices",                 ChildObjects.WebService);
	LoadMetadata(Configuration, Cache, Path, "WSReferences",                ChildObjects.WSReference);
	LoadMetadata(Configuration, Cache, Path, "XDTOPackages",                ChildObjects.XDTOPackage);
	
	Message("Configuration end: " + CurrentDate());
	
	Abc.RefreshAllReusableValues();
	
EndProcedure // Load()

Procedure LoadMetadata(Configuration, Cache, Path, ClassName, NameList, FolderName = Undefined)
	
	Message(StrTemplate("%1 start: %2", ClassName, CurrentDate()));
	
	If FolderName = Undefined Then
		FolderName = ClassName;
	EndIf; 
	
	MetadataManager = Catalogs[ClassName];
	Context = Meta.LoadContext(Configuration, Configuration, Cache, Abc.JoinPath(Path, FolderName));
	
	For Each Name In NameList Do
		MetadataManager.Load(Context, Name);
	EndDo;
	
EndProcedure // LoadMetadata()

Function Cache(Config) Export
	
	Cache = New Structure("Config", Config);
	
	For Each Item In Meta.RootNames() Do
		Cache.Insert(Item.Value, Catalogs[Item.Key].Cache(Config));
	EndDo;
	
	Cache.Insert("Form", Cache.CommonForm);
	Cache.Insert("Template", Cache.CommonTemplate);
	
	Return Cache;
	
EndFunction // Cache() 
 