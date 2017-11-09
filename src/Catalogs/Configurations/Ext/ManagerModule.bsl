
Function AttributeValue(Ref, AttributeName) Export
	
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames);
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path) Export
		
	Data = Meta.ReadMetadataXML(Abc.JoinPath(Path, "Configuration.xml"));
	
	ChildObjects = Data.Configuration.ChildObjects;
	Items = New Structure;
	For Each Property In ChildObjects.Properties() Do
		Items.Insert(Property.Name, ChildObjects[Property.Name]);
	EndDo; 
	
	List = Undefined;
	
	//If Items.Property("Language", List) Then
	//	LoadMetadata(Configuration, Path, "Languages", ChildObjects.Language);
	//EndIf; 
	
	If Items.Property("AccountingRegister", List) Then
		LoadMetadata(Configuration, Path, "AccountingRegisters", ChildObjects.AccountingRegister);
	EndIf; 
	
	//If Items.Property("AccumulationRegister", List) Then
	//	LoadMetadata(Configuration, Path, "AccumulationRegisters", ChildObjects.AccumulationRegister);
	//EndIf;
	//
	//If Items.Property("BusinessProcess", List) Then
	//	LoadMetadata(Configuration, Path, "BusinessProcesses", ChildObjects.BusinessProcess);
	//EndIf; 
	//
	//If Items.Property("CalculationRegister", List) Then
	//	LoadMetadata(Configuration, Path, "CalculationRegisters", List);
	//EndIf;
	//
	//If Items.Property("Catalog", List) Then
	//	LoadMetadata(Configuration, Path, "Catalogs", ChildObjects.Catalog);
	//EndIf;
	//
	//If Items.Property("ChartOfAccounts", List) Then
	//	LoadMetadata(Configuration, Path, "ChartsOfAccounts", List);
	//EndIf;
	//
	//If Items.Property("ChartOfCalculationTypes", List) Then
	//	LoadMetadata(Configuration, Path, "ChartsOfCalculationTypes", List);
	//EndIf;
	//
	//If Items.Property("ChartOfCharacteristicTypes", List) Then
	//	LoadMetadata(Configuration, Path, "ChartsOfCharacteristicTypes", List);
	//EndIf;
	//
	//If Items.Property("CommandGroup", List) Then
	//	LoadMetadata(Configuration, Path, "CommandGroups", List);
	//EndIf;
	//
	//If Items.Property("CommonAttribute", List) Then
	//	LoadMetadata(Configuration, Path, "CommonAttributes", List);
	//EndIf;
	//
	//If Items.Property("CommonCommand", List) Then
	//	LoadMetadata(Configuration, Path, "Commands", List, "CommonCommands");
	//EndIf;
	//
	//If Items.Property("CommonForm", List) Then
	//	LoadMetadata(Configuration, Path, "Forms", List, "CommonForms");
	//EndIf;
	//
	//If Items.Property("CommonModule", List) Then
	//	LoadMetadata(Configuration, Path, "CommonModules", List);
	//EndIf;
	//
	//If Items.Property("CommonPicture", List) Then
	//	LoadMetadata(Configuration, Path, "Pictures", List, "CommonPictures");
	//EndIf;
	//
	//If Items.Property("CommonTemplate", List) Then
	//	LoadMetadata(Configuration, Path, "Templates", List, "CommonTemplates");
	//EndIf;
	//
	//
	//If Items.Property("Constant", List) Then
	//	LoadMetadata(Configuration, Path, "Constants", List);
	//EndIf;
	//
	//If Items.Property("DataProcessor", List) Then
	//	LoadMetadata(Configuration, Path, "DataProcessors", List);
	//EndIf;
	//
	//If Items.Property("DocumentJournal", List) Then
	//	LoadMetadata(Configuration, Path, "DocumentJournals", List);
	//EndIf;
	//
	//If Items.Property("DocumentNumerator", List) Then
	//	LoadMetadata(Configuration, Path, "DocumentNumerators", List);
	//EndIf;
	//
	//If Items.Property("Document", List) Then
	//	LoadMetadata(Configuration, Path, "Documents", List);
	//EndIf;
	//
	//If Items.Property("Enum", List) Then
	//	LoadMetadata(Configuration, Path, "Enums", List);
	//EndIf;
	//
	//If Items.Property("EventSubscription", List) Then
	//	LoadMetadata(Configuration, Path, "EventSubscriptions", List);
	//EndIf;
	//
	//If Items.Property("ExchangePlan", List) Then
	//	LoadMetadata(Configuration, Path, "ExchangePlans", List);
	//EndIf;
	//
	//If Items.Property("FilterCriterion", List) Then
	//	LoadMetadata(Configuration, Path, "FilterCriteria", List);
	//EndIf;
	//
	//If Items.Property("FunctionalOption", List) Then
	//	LoadMetadata(Configuration, Path, "FunctionalOptions", List);
	//EndIf;
	//
	//If Items.Property("FunctionalOptionsParameter", List) Then
	//	LoadMetadata(Configuration, Path, "FunctionalOptionsParameters", List);
	//EndIf;
	//
	//If Items.Property("HTTPService", List) Then
	//	LoadMetadata(Configuration, Path, "HTTPServices", List);
	//EndIf;
	//
	//If Items.Property("InformationRegister", List) Then
	//	LoadMetadata(Configuration, Path, "InformationRegisters", List);
	//EndIf;
	//
	//If Items.Property("Report", List) Then
	//	LoadMetadata(Configuration, Path, "Reports", List);
	//EndIf;	
	//
	//If Items.Property("Role", List) Then
	//	LoadMetadata(Configuration, Path, "Roles", List);
	//EndIf;
	//
	//If Items.Property("ScheduledJob", List) Then
	//	LoadMetadata(Configuration, Path, "ScheduledJobs", List);
	//EndIf;
	//
	//If Items.Property("Sequence", List) Then
	//	LoadMetadata(Configuration, Path, "Sequences", List);
	//EndIf;
	//
	//If Items.Property("SessionParameter", List) Then
	//	LoadMetadata(Configuration, Path, "SessionParameters", List);
	//EndIf;
	//
	//If Items.Property("SettingsStorage", List) Then
	//	LoadMetadata(Configuration, Path, "SettingsStorages", List);
	//EndIf;
	//
	//If Items.Property("Subsystem", List) Then
	//	LoadMetadata(Configuration, Path, "Subsystems", List);
	//EndIf;
	//
	//If Items.Property("Task", List) Then
	//	LoadMetadata(Configuration, Path, "Tasks", List);
	//EndIf;
	//
	//If Items.Property("WebService", List) Then
	//	LoadMetadata(Configuration, Path, "WebServices", List);
	//EndIf;
	//
	//If Items.Property("WSReference", List) Then
	//	LoadMetadata(Configuration, Path, "WSReferences", List);
	//EndIf;
	//
	//If Items.Property("XDTOPackage", List) Then
	//	LoadMetadata(Configuration, Path, "XDTOPackages", List);
	//EndIf;
	
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
 