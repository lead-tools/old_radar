
Function LanguageByCode(Config, LanguageCode) Export
	
	Query = New Query;
	Query.SetParameter("Owner", Config);
	Query.SetParameter("LanguageCode", LanguageCode);
	Query.Text =
	"SELECT
	|	Languages.Ref AS Ref
	|FROM
	|	Catalog.Languages AS Languages
	|WHERE
	|	Languages.Owner = &Owner
	|	AND Languages.LanguageCode = &LanguageCode";
	
	QueryResult = Query.Execute(); 
	
	If QueryResult.IsEmpty() Then
		Return Undefined;
	EndIf; 
	
	Return QueryResult.Unload()[0].Ref;
	
EndFunction // LanguageByCode()

Function XDTOFactory() Export
	
	XMLReader = New XMLReader;
	XMLReader.SetString(GetCommonTemplate("MDClasses_2_4").GetText());
	XDTOModel = XDTOFactory.ReadXML(XMLReader);
	XMLReader.Close();
	
	Packages = New Array;
	Packages.Add(XDTOFactory.Packages.Get("http://v8.1c.ru/8.1/data/enterprise/current-config"));
	
	Return New XDTOFactory(XDTOModel, Packages);
	
EndFunction // XDTOFactory()

Function StringCache(Config) Export
	
	Query = New Query;
	Query.SetParameter("Config", Config);
	Query.Text =
	"SELECT
	|	LocaleStrings.Ref AS Ref,
	|	LocaleStrings.SHA1 AS SHA1
	|FROM
	|	Catalog.LocaleStrings AS LocaleStrings
	|WHERE
	|	LocaleStrings.Config = &Config";
	
	StringCache = Query.Execute().Unload();
	StringCache.Indexes.Add("Ref");
	
	Return StringCache;
	
EndFunction // StringCache()

Function RootNames() Export
	
	RootNames = New Structure;
	
	RootNames.Insert("AccountingRegisters",         "AccountingRegister");
	RootNames.Insert("AccumulationRegisters",       "AccumulationRegister");
	RootNames.Insert("BusinessProcesses",           "BusinessProcess");
	RootNames.Insert("CalculationRegisters",        "CalculationRegister");
	RootNames.Insert("Catalogs",                    "Catalog");
	RootNames.Insert("ChartsOfAccounts",            "ChartOfAccounts");
	RootNames.Insert("ChartsOfCalculationTypes",    "ChartOfCalculationTypes");
	RootNames.Insert("ChartsOfCharacteristicTypes", "ChartOfCharacteristicTypes");
	RootNames.Insert("CommandGroups",               "CommandGroup");
	RootNames.Insert("Commands",                    "Command");
	RootNames.Insert("CommonAttributes",            "CommonAttribute");
	RootNames.Insert("CommonCommands",              "CommonCommand");
	RootNames.Insert("Forms",                       "CommonForm");
	RootNames.Insert("CommonModules",               "CommonModule");
	RootNames.Insert("CommonPictures",              "CommonPicture");
	RootNames.Insert("Templates",                   "CommonTemplate");
	RootNames.Insert("Constants",                   "Constant");
	RootNames.Insert("DataProcessors",              "DataProcessor");
	RootNames.Insert("DocumentJournals",            "DocumentJournal");
	RootNames.Insert("DocumentNumerators",          "DocumentNumerator");
	RootNames.Insert("Documents",                   "Document");
	RootNames.Insert("Enums",                       "Enum");
	RootNames.Insert("EnumValues",                  "EnumValue");
	RootNames.Insert("EventSubscriptions",          "EventSubscription");
	RootNames.Insert("ExchangePlans",               "ExchangePlan");
	RootNames.Insert("FilterCriteria",              "FilterCriterion");
	RootNames.Insert("FunctionalOptions",           "FunctionalOption");
	RootNames.Insert("FunctionalOptionsParameters", "FunctionalOptionsParameter");
	RootNames.Insert("HTTPServices",                "HTTPService");
	RootNames.Insert("InformationRegisters",        "InformationRegister");
	RootNames.Insert("Languages",                   "Language");
	RootNames.Insert("Reports",                     "Report");
	RootNames.Insert("Roles",                       "Role");
	RootNames.Insert("ScheduledJobs",               "ScheduledJob");
	RootNames.Insert("Sequences",                   "Sequence");
	RootNames.Insert("SessionParameters",           "SessionParameter");
	RootNames.Insert("SettingsStorages",            "SettingsStorage");
	RootNames.Insert("Subsystems",                  "Subsystem");
	RootNames.Insert("Tasks",                       "Task");
	RootNames.Insert("WebServices",                 "WebService");
	RootNames.Insert("WSReferences",                "WSReference");
	RootNames.Insert("XDTOPackages",                "XDTOPackage");
	RootNames.Insert("Attributes",                  "Attribute");
	RootNames.Insert("StandardAttributes",          "StandardAttribute");
	RootNames.Insert("TabularSections",             "TabularSection");
	RootNames.Insert("Modules",                     "Module");
	
	Return New FixedStructure(RootNames);
	
EndFunction // RootNames()

Function ObjectDescription(CatalogName) Export
	
	Manager = Catalogs[CatalogName];	
	EmptyArray = New Array;
	
	ObjectDescription = New Structure;
	
	ObjectDescription.Insert("StandardAttributes",
	    New FixedArray(Abc.NVL(Manager.StandardAttributes(), EmptyArray))
	);
	
	ObjectDescription.Insert("SimpleTypeProperties",
	    New FixedArray(Abc.NVL(Manager.SimpleTypeProperties(), EmptyArray))
	);
	
	ObjectDescription.Insert("LocaleStringTypeProperties",
	    New FixedArray(Abc.NVL(Manager.LocaleStringTypeProperties(), EmptyArray))
	);
	
	ObjectDescription.Insert("StandardAttributes",
	    New FixedArray(Abc.NVL(Manager.StandardAttributes(), EmptyArray))
	);
	
	ObjectDescription.Insert("FormTypeProperties",
	    New FixedArray(Abc.NVL(Manager.FormTypeProperties(), EmptyArray))
	);
	
	ObjectDescription.Insert("ChildObjectNames",
	    New FixedArray(Abc.NVL(Manager.ChildObjectNames(), EmptyArray))
	);
	
	ObjectDescription.Insert("ModuleKinds",
	    New FixedArray(Abc.NVL(Manager.ModuleKinds(), EmptyArray))
	);
	
	Return ObjectDescription;
	
EndFunction // ObjectDescription()