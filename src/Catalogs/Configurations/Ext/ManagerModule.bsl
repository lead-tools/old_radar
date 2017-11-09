
Procedure Load(Configuration, Path) Export
		
	Data = Meta.ReadMetadataXML(Abc.JoinPath(Path, "Configuration.xml"));
	
	ChildObjects = Data.Configuration.ChildObjects;
	
	//LoadMetadata(Configuration, Path, "Languages",                   ChildObjects.Language);
	//LoadMetadata(Configuration, Path, "AccountingRegisters",         ChildObjects.AccountingRegister);
	//LoadMetadata(Configuration, Path, "AccumulationRegisters",       ChildObjects.AccumulationRegister);
	//LoadMetadata(Configuration, Path, "BusinessProcesses",           ChildObjects.BusinessProcess);
	//LoadMetadata(Configuration, Path, "CalculationRegisters",        ChildObjects.CalculationRegister);
	//LoadMetadata(Configuration, Path, "Catalogs",                    ChildObjects.Catalog);
	//LoadMetadata(Configuration, Path, "ChartsOfAccounts",            ChildObjects.ChartOfAccounts);
	//LoadMetadata(Configuration, Path, "ChartsOfCalculationTypes",    ChildObjects.ChartOfCalculationTypes);
	//LoadMetadata(Configuration, Path, "ChartsOfCharacteristicTypes", ChildObjects.ChartOfCharacteristicTypes);
	//LoadMetadata(Configuration, Path, "CommandGroups",               ChildObjects.CommandGroup);
	//LoadMetadata(Configuration, Path, "CommonAttributes",            ChildObjects.CommonAttribute);
	//LoadMetadata(Configuration, Path, "Commands",                    ChildObjects.CommonCommand, "CommonCommands");
	//LoadMetadata(Configuration, Path, "Forms",                       ChildObjects.CommonForm, "CommonForms");
	//LoadMetadata(Configuration, Path, "CommonModules",               ChildObjects.CommonModule);
	//LoadMetadata(Configuration, Path, "Pictures",                    ChildObjects.CommonPicture, "CommonPictures");
	//LoadMetadata(Configuration, Path, "Templates",                   ChildObjects.CommonTemplate, "CommonTemplates");
	//LoadMetadata(Configuration, Path, "Constants",                   ChildObjects.Constant);
	//LoadMetadata(Configuration, Path, "DataProcessors",              ChildObjects.DataProcessor);
	//LoadMetadata(Configuration, Path, "DocumentJournals",            ChildObjects.DocumentJournal);
	//LoadMetadata(Configuration, Path, "DocumentNumerators",          ChildObjects.DocumentNumerator);
	//LoadMetadata(Configuration, Path, "Documents",                   ChildObjects.Document);
	//LoadMetadata(Configuration, Path, "Enums",                       ChildObjects.Enum);
	//LoadMetadata(Configuration, Path, "EventSubscriptions",          ChildObjects.EventSubscription);
	//LoadMetadata(Configuration, Path, "ExchangePlans",               ChildObjects.ExchangePlan);
	//LoadMetadata(Configuration, Path, "FilterCriteria",              ChildObjects.FilterCriterion);
	//LoadMetadata(Configuration, Path, "FunctionalOptions",           ChildObjects.FunctionalOption);
	//LoadMetadata(Configuration, Path, "FunctionalOptionsParameters", ChildObjects.FunctionalOptionsParameter);
	//LoadMetadata(Configuration, Path, "HTTPServices",                ChildObjects.HTTPService);
	//LoadMetadata(Configuration, Path, "InformationRegisters",        ChildObjects.InformationRegister);
	//LoadMetadata(Configuration, Path, "Reports",                     ChildObjects.Report);
	//LoadMetadata(Configuration, Path, "Roles",                       ChildObjects.Role);
	//LoadMetadata(Configuration, Path, "ScheduledJobs",               ChildObjects.ScheduledJob);
	//LoadMetadata(Configuration, Path, "Sequences",                   ChildObjects.Sequence);
	//LoadMetadata(Configuration, Path, "SessionParameters",           ChildObjects.SessionParameter);
	//LoadMetadata(Configuration, Path, "SettingsStorages",            ChildObjects.SettingsStorage);
	//LoadMetadata(Configuration, Path, "Subsystems",                  ChildObjects.Subsystem);
	LoadMetadata(Configuration, Path, "Tasks",                       ChildObjects.Task);
	//LoadMetadata(Configuration, Path, "WebServices",                 ChildObjects.WebService);
	//LoadMetadata(Configuration, Path, "WSReferences",                ChildObjects.WSReference);
	//LoadMetadata(Configuration, Path, "XDTOPackages",                ChildObjects.XDTOPackage);
	
EndProcedure // Load()

Procedure LoadMetadata(Configuration, Path, Name, XDTOList, FolderName = Undefined)
		
	If FolderName = Undefined Then
		FolderName = Name;
	EndIf; 
	
	MetadataPath = Abc.JoinPath(Path, FolderName);
	MetadataManager = Catalogs[Name];
	
	LoadParameters = Meta.ObjectLoadParameters();
	LoadParameters.Configuration = Configuration;
	LoadParameters.Owner = Configuration;
	
	For Each Item In XDTOList Do
		LoadParameters.Path = Abc.JoinPath(MetadataPath, Item);
		MetadataManager.Load(LoadParameters);
	EndDo;
	
EndProcedure // LoadMetadata()
 