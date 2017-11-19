
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer

Function LoadContext(Config, Owner, Cache, Path = Undefined) Export
	
	Return New Structure("Config, Owner, Cache, Path", Config, Owner, Cache, Path);
	
EndFunction // LoadContext() 

#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

#Region Cache

&AtServer
Function RefByFullName(Cache, FullName) Export
	
	NameList = StrSplit(FullName, ".");	
	Count = NameList.Count();
	
	Abc.Assert(Count % 2 = 0);
	
	Index = 0; 	
	Ref = Cache.Config;
	
	While Index < Count Do
	
		TableName = NameList[Index];
		Table = Cache[TableName];
		Index = Index + 1;
		
		Name = NameList[Index];
		Row = Abc.FindRow(Table, New Structure("Owner, Name, Mark", Ref, Name, True));
		If Row = Undefined Then
			Return Undefined;
		EndIf; 
		Ref = Row.Ref;
		Index = Index + 1;
		
	EndDo; 
	
	Return Ref;
	
EndFunction // RefByFullName() 

&AtServer
Function FullNameByRef(Cache, Val Ref) Export
	
	If Not ValueIsFilled(Ref) Then
		Return "";
	EndIf; 
	
	NameList = New Array;
	
	While Ref <> Cache.Config Do
		Name = RootNames()[Ref.Metadata().Name];
		Row = Cache[Name].Find(Ref, "Ref");
		NameList.Insert(0, Row.Name);
		NameList.Insert(0, Name);
		Ref = Row.Owner;
	EndDo; 
	
	Return StrConcat(NameList, ".");
	
EndFunction // FullNameByRef() 

&AtServer
Function CacheItem(Cache, MetaName, Filter, Mark = True) Export
	Var CacheItem, CacheTable;
	
	CacheTable = Cache[MetaName];
	CacheItem = Abc.FindRow(CacheTable, Filter);
	If CacheItem = Undefined Then
		CacheItem = CacheTable.Add();
		FillPropertyValues(CacheItem, Filter);
	EndIf;
	
	If Mark Then
		CacheItem.Mark = True;
	EndIf; 
	
	Return CacheItem;	
	
EndFunction // CacheItem()

&AtServer
Function GetObject(Manager, CacheItem) Export
	
	If Not ValueIsFilled(CacheItem.Ref) Then
		Object = Manager.CreateItem();
		CacheItem.Ref = Manager.GetRef();
		Object.SetNewObjectRef(CacheItem.Ref);
	Else
		Object = CacheItem.Ref.GetObject();
	EndIf;
	
	Return Object;
	
EndFunction // GetObject()

&AtServer
Function StringCache(Configuration) Export
	
	Return Meta_sr.StringCache(Configuration);
	
EndFunction // StringCache()

#EndRegion // Cache

&AtServer
Function ObjectDescription(Manager) Export
	Return Meta_sr.ObjectDescription(Manager.EmptyRef().Metadata().Name);
EndFunction // ObjectDescription() 

&AtServer
Function RootNames() Export
	
	Return Meta_sr.RootNames();
	
EndFunction // RootNames()  

&AtServer
Function LanguageByCodeFromCache(Configuration, LanguageCode) Export
	
	Return Meta_sr.LanguageByCode(Configuration, LanguageCode);
	
EndFunction // LanguageByCode()  

&AtServer
Procedure UpdateStrings(Configuration, Owner, Object, XDTODataObject, Keys) Export
	Var Key;
	
	LoadContext = LoadContext(Configuration, Owner, Undefined, Undefined);
	LoadContext.Insert("LocalString");
	LoadContext.Insert("StringRef");
	
	For Each Key In Keys Do
		LocalString = XDTODataObject[Key];
		If LocalString <> Undefined Then
			LoadContext.LocalString = LocalString;
			LoadContext.StringRef = Object[Key];
			Object[Key] = Catalogs.LocaleStrings.Load(LoadContext);
		EndIf; 
	EndDo; 
	
EndProcedure // UpdateStrings() 

&AtServer
Function ReadMetadataXML(Context, FilePath, MetaName, Name) Export
	
	ReadResult = New Structure("Data, CacheItem");
	
	DataReader = New DataReader(FilePath, TextEncoding.UTF8); 
	BinaryDataBuffer = DataReader.ReadIntoBinaryDataBuffer();
	
	MemoryStream = New MemoryStream(BinaryDataBuffer);
	
	SHA1 = Abc.SHA1(MemoryStream);
	
	MemoryStream.Seek(0, PositionInStream.Begin);
	
	TextReader = New TextReader(FilePath, TextEncoding.UTF8);	
	Offset = 3 + StrLen(TextReader.ReadLine()) + 1; // BOM + XML declaration + LF
	MetaDataObjectTag = TextReader.ReadLine();
	ObjectTag = TextReader.ReadLine();
	TextReader.Close();
	
	AttributeUUID = "uuid=""";
	UUID = New UUID(Mid(ObjectTag, StrFind(ObjectTag, AttributeUUID) + StrLen(AttributeUUID), 36));
	
	If Context.Cache <> Undefined Then
		
		CacheItem = Meta.CacheItem(Context.Cache, MetaName, New Structure("UUID", UUID));
		
		ReadResult.CacheItem = CacheItem;
		
		If CacheItem.SHA1 = SHA1 Then
			Return ReadResult;
		Else
			CacheItem.SHA1 = SHA1;
			CacheItem.Name = Name;
			CacheItem.Owner = Context.Owner;
			If Context.Property("Parent") Then
				CacheItem.Parent = Context.Parent;
			EndIf; 
		EndIf; 
		
	EndIf; 
	
	MDClassesPos = Offset + StrFind(MetaDataObjectTag, "http://v8.1c.ru/8.3/MDClasses");
	BinaryDataBuffer.Write(MDClassesPos, GetBinaryDataBufferFromString("http://Lead-Bullets/MDClasses"));
	
	ReadablePos = Offset + StrFind(MetaDataObjectTag, "http://v8.1c.ru/8.3/xcf/readable");
	BinaryDataBuffer.Write(ReadablePos, GetBinaryDataBufferFromString("http://Lead-Bullets/xcf/readable"));
	
	MyXDTOFactory = Meta_sr.XDTOFactory();
	Type = MyXDTOFactory.Type("http://Lead-Bullets/MDClasses", "MetaDataObject");  
	
	XMLReader = New XMLReader;
	XMLReader.OpenStream(MemoryStream);
	Try
		XDTOObject = MyXDTOFactory.ReadXML(XMLReader, Type);
	Except
		Message("Error path: " + FilePath);
		Raise;
	EndTry;
	XMLReader.Close();
	
	ReadResult.Data = XDTOObject[MetaName];
	
	Return ReadResult;
		
EndFunction // ReadMetadataXML() 

&AtServer
Function ObjectNames(CacheTable, Owner, Parent = Undefined) Export
	
	ObjectNames = New Array;
	Filter = New Structure("Owner", Owner);
	
	If Parent <> Undefined Then
		Filter.Insert("Parent", Parent);
	EndIf; 
	
	For Each Item In CacheTable.FindRows(Filter) Do
		ObjectNames.Add(Item.Name);
	EndDo; 
	
	Return ObjectNames;
	
EndFunction // ObjectNames()

&AtServer
Function GenericLoad(Context, Name, Manager, MetaName) Export
	Var Object, CacheItem;
	
	Config = Context.Config;
	Owner  = Context.Owner;
	Cache  = Context.Cache;
	Path   = Context.Path;
	
	// precondition:
	// # (Config == Owner) Or (Config == Owner.Owner)
	// # Path is folder path
	
	NeedToUpdate = False;
	
	FilePath = Abc.JoinPath(Path, Name) + ".xml";
	ReadResult = ReadMetadataXML(Context, FilePath, MetaName, Name);
	
	Data = ReadResult.Data;
	CacheItem = ReadResult.CacheItem;
	
	BeginTransaction();
	
	If Not ValueIsFilled(CacheItem.Ref) Then
		Object = GetObject(Manager, CacheItem);
		NeedToUpdate = True;
	EndIf;
	
	ThisPath = Abc.JoinPath(Path, Name);
	
	ChildContext = LoadContext(Config, CacheItem.Ref, Cache, ThisPath);
	
	ChildFilter = New Structure("Owner", CacheItem.Ref);
	
	ObjectDescription = ObjectDescription(Manager);
	
	Children = ObjectDescription.ChildObjectNames;
	
	//////////////////////////////////////////////////////////////////////////////
	// Commands
	
	If Children.Find("Command") <> Undefined Then
	
		If Data = Undefined Then
			ChildCommands = Cache.Command.FindRows(ChildFilter);
			For Each Command In ChildCommands Do
				CommandPath = Abc.JoinPath(Path, "Commands\" + Command.Name);
				CommandModule = Catalogs.Modules.Load(
					LoadContext(Config, Command.Ref, Cache, CommandPath),
					Enums.ModuleKinds.CommandModule
				);	
			EndDo; 
		Else
			For Each CommandData In Data.ChildObjects.Command Do
				Command = Catalogs.Commands.Load(
					ChildContext,
					CommandData
				);
			EndDo;
		EndIf; 
	
	EndIf;
	
	//////////////////////////////////////////////////////////////////////////////
	// Forms
	
	If Children.Find("Form") <> Undefined Then
		
		FormNames = Undefined;
		DefaultFormFullNames = New Structure;
		
		If Data = Undefined Then
			FormNames = ObjectNames(Cache.Form, CacheItem.Ref);
			For Each PropertyName In ObjectDescription.FormTypeProperties Do
				FormRef = CacheItem[PropertyName];
				DefaultFormFullNames.Insert(
					PropertyName,
					FullNameByRef(Cache, FormRef)
				);
			EndDo; 
		Else
			FormNames = Data.ChildObjects.Form;
			For Each PropertyName In ObjectDescription.FormTypeProperties Do
				DefaultFormFullNames.Insert(
					PropertyName,
					Data.Properties[PropertyName]
				);
			EndDo;
		EndIf; 
		
		ChildForms = New Structure;
		For Each FormName In FormNames Do
			ChildForms.Insert(
				FormName,
				Catalogs.Forms.Load(ChildContext, FormName)
			);
		EndDo; 
				
		For Each Item In DefaultFormFullNames Do
			If Mid(Item.Value, 9, 1) = "-" Then // UUID
				// todo
			Else
				If IsBlankString(Item.Value) Then
					If ValueIsFilled(CacheItem[Item.Key]) Then
						CacheItem[Item.Key] = Undefined;
						NeedToUpdate = True;
					EndIf; 
				Else
					FormRef = Meta.RefByFullName(Cache, Item.Value);
					If CacheItem[Item.Key] <> FormRef Then
						CacheItem[Item.Key] = FormRef;
						NeedToUpdate = True;	
					EndIf;
				EndIf;
			EndIf; 
		EndDo;
	
	EndIf; 
	
	//////////////////////////////////////////////////////////////////////////////
	// Templates
	
	If Children.Find("Template") <> Undefined Then
	
		If Data = Undefined Then
			TemplateNames = ObjectNames(Cache.Template, CacheItem.Ref);
		Else
			TemplateNames = Data.ChildObjects.Template;
		EndIf; 
		
		For Each TemplateName In TemplateNames Do
			Template = Catalogs.Templates.Load(
				ChildContext,
				TemplateName
			);
		EndDo;
	
	EndIf; 
	
	//////////////////////////////////////////////////////////////////////////////
	// Object
	
	If NeedToUpdate Then
		
		Properties = Data.Properties;
		If Children.Count() > 0 Then
			ChildObjects = Data.ChildObjects;
		EndIf; 
		UUID = Data.UUID;
		
		Abc.Assert(Properties.Name = Name);
		
		If Object = Undefined Then
			Object = GetObject(Manager, CacheItem);
		EndIf; 
		
		If Object.Metadata().Attributes.Find("Config") <> Undefined Then
			Object.Config = Config;
		EndIf; 
		
		/////////////////////////////////////////////////////////////////////////////
		// Cached fields  
		
		FillPropertyValues(Object, CacheItem, Manager.CachedFields());
		
		/////////////////////////////////////////////////////////////////////////////
		// Properties
		
		Abc.Fill(Object, Properties, ObjectDescription.SimpleTypeProperties);
		
		Meta.UpdateStrings(Config, CacheItem.Ref, Object, Properties, ObjectDescription.LocaleStringTypeProperties); 
		
		/////////////////////////////////////////////////////////////////////////////
		// Dimensions
		
		If Children.Find("Dimension") <> Undefined Then
		
			AttributeOrder = Object.AttributeOrder;
			AttributeOrder.Clear();
			For Each AttributeData In ChildObjects.Dimension Do
				AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(
					ChildContext,
					AttributeData
				);
			EndDo;
		
		EndIf;
		
		/////////////////////////////////////////////////////////////////////////////
		// Resources
		
		If Children.Find("Resource") <> Undefined Then
		
			AttributeOrder = Object.AttributeOrder;
			AttributeOrder.Clear();
			For Each AttributeData In ChildObjects.Resource Do
				AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(
					ChildContext,
					AttributeData
				);
			EndDo;
		
		EndIf;
		
		/////////////////////////////////////////////////////////////////////////////
		// Attributes
		
		If Children.Find("Attribute") <> Undefined Then
		
			AttributeOrder = Object.AttributeOrder;
			AttributeOrder.Clear();
			For Each AttributeData In ChildObjects.Attribute Do
				AttributeOrder.Add().Attribute = Catalogs.Attributes.Load(
					ChildContext,
					AttributeData
				);
			EndDo;
		
		EndIf; 
		
		/////////////////////////////////////////////////////////////////////////////
		// Standard attributes
		
		If ObjectDescription.StandardAttributes.Count() > 0
			And Properties.StandardAttributes <> Undefined Then
			
			For Each StandardAttributeData In Properties.StandardAttributes.StandardAttribute Do
				StandardAttribute = Catalogs.StandardAttributes.Load(
					ChildContext,
					StandardAttributeData
				);
			EndDo; 
			
		EndIf;
		
		/////////////////////////////////////////////////////////////////////////////
		// Tabular sections
		
		If Children.Find("TabularSection") <> Undefined Then
		
			For Each TabularSectionData In ChildObjects.TabularSection Do
				Catalogs.TabularSections.Load(
					ChildContext,
					TabularSectionData
				);
			EndDo;	
		
		EndIf; 
		
		/////////////////////////////////////////////////////////////////////////////
		// Enum values
		
		If Children.Find("EnumValue") <> Undefined Then
		
			For Each EnumValueData In ChildObjects.EnumValue Do
				Catalogs.EnumValues.Load(
					ChildContext,
					EnumValueData
				);
			EndDo;	
		
		EndIf;
		
		Object.Write();
		
	EndIf; // NeedToUpdate
	
	//////////////////////////////////////////////////////////////////////////////
	// Subsystems
	
	If Children.Find("Subsystem") <> Undefined Then
		
		If Data = Undefined Then
			SubsystemNames = ObjectNames(Cache.Subsystem, CacheItem.Ref);
		Else
			SubsystemNames = Data.ChildObjects.Subsystem;
		EndIf;
		
		For Each SubsystemName In SubsystemNames Do
			SubsystemPath = Abc.JoinPath(Path, Name + "\Subsystems");
			SubsystemContext = LoadContext(Config, Config, Cache, SubsystemPath);
			SubsystemContext.Insert("Parent", CacheItem.Ref);
			Subsystem = Catalogs.Subsystems.Load(
				SubsystemContext,
				SubsystemName
			);	
		EndDo;
	
	EndIf;
	
	//////////////////////////////////////////////////////////////////////////////
	// Modules
	
	For Each ModuleKind In ObjectDescription.ModuleKinds Do
		Module = Catalogs.Modules.Load(
			ChildContext,
			ModuleKind
		);	
	EndDo; 
	
	CommitTransaction();
	
	Return CacheItem.Ref;
	
EndFunction // GenericLoad() 

#Region EventSubscriptionsHandlers

&AtServer
Procedure PresentationGetProcessingPresentationGetProcessing(Source, Data, Presentation, StandardProcessing) Export
	
	StandardProcessing = False;	
	Presentation = Data.Name;
	
EndProcedure // PresentationGetProcessingPresentationGetProcessing()

&AtServer
Procedure PresentationFieldsGetProcessingPresentationFieldsGetProcessing(Source, Fields, StandardProcessing) Export
	
	StandardProcessing = False;	
	Fields.Add("Name");
	
EndProcedure // PresentationFieldsGetProcessingPresentationFieldsGetProcessing()

#EndRegion // EventSubscriptionsHandlers

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client