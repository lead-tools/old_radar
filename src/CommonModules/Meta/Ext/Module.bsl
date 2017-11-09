
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer

Function ObjectLoadParameters() Export
	
	Return New Structure("Configuration, Owner, Path, Data");
	
EndFunction // ObjectLoadParameters() 

#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

&AtServer
Function GetObject(Manager, UUID, Owner, Ref = Undefined) Export
	
	If Ref = Undefined Then
		Ref = Manager.FindByAttribute("UUID", UUID,, Owner);
	EndIf; 
	
	If Not ValueIsFilled(Ref) Then
		Object = Manager.CreateItem();
		Ref = Manager.GetRef();
		Object.SetNewObjectRef(Ref);
	Else
		Object = Ref.GetObject();
	EndIf;
	
	Return Object;
	
EndFunction // GetObject()

&AtServer
Function AttributeTypes(MetadataObject) Export
	
	Return Meta_sr.AttributeTypes(MetadataObject.FullName());
	
EndFunction // AttributeTypes() 

&AtServer
Function GenericLoad(Configuration, Owner, Path, MetadataObject, Ref = Undefined) Export
		
	Manager = Catalogs[MetadataObject.Name];
	
	Data = ReadMetadataXML(Path + ".xml");
	XDTOObject = Data.Sequence().GetValue(0);
	XDTOProperties = XDTOObject.Properties;
	UUID = New UUID(XDTOObject.UUID);
	
	If Ref = Undefined Then
		Ref = Manager.FindByAttribute("UUID", UUID,, Owner);
	EndIf; 
	
	If Not ValueIsFilled(Ref) Then
		Object = Manager.CreateItem();
	Else
		Object = Ref.GetObject();
	EndIf; 
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Description = XDTOProperties.Name;
	
	Meta.FillAttributesByXDTOProperties(Configuration, Owner, Object, XDTOProperties); 
	
	Object.Write();
	
	Ref = Object.Ref;
	
	Return Ref;
	
EndFunction // GenericLoad()

&AtServer
Procedure FillAttributesByXDTOProperties(Configuration, Owner, Object, XDTOProperties) Export
	
	AttributeTypes = AttributeTypes(Object.Metadata());
	SkipProperties = Meta_sr.SkipProperties();
		
	For Each Attribute In AttributeTypes Do
		
		Name = Attribute.Key;
		Type = Attribute.Value;
		
		If Not SkipProperties.Property(Name) Then
			Try
				If Name = "IsPredefined" Then
					XDTOValue = XDTOProperties.Predefined;
				Else
					XDTOValue = XDTOProperties[Name];
				EndIf; 
			Except
				Message(StrTemplate("Property `%1` not found", Name));
				Continue;
			EndTry;
		EndIf; 
		
		If Type = Type("String") Then
			If TypeOf(XDTOValue) = Type("String") Then
				Object[Name] = XDTOValue;
			EndIf; 
		ElsIf Type = Type("Number") Then
			Object[Name] = Number(XDTOValue);
		ElsIf Type = Type("CatalogRef.Forms") Then
			
		ElsIf Type = Type("CatalogRef.Modules") Then
			
		ElsIf Type = Type("CatalogRef.Strings") Then
			UpdateString(Configuration, Owner, Object[Name], XDTOValue)
		ElsIf Type = Type("CatalogRef.ChartsOfAccounts") Then
			
		ElsIf Type = Type("CatalogRef.Tasks") Then
			
		ElsIf Type = Type("CatalogRef.ChartsOfCharacteristicTypes") Then
			
		ElsIf Type = Type("CatalogRef.Catalogs") And Name = "CharacteristicExtValues" Then	
			
		ElsIf Type = Type("CatalogRef.Types") Then
			
		ElsIf Type = Type("CatalogRef.ChoiceParameterLinks") Then
			
		ElsIf Type = Type("CatalogRef.ChoiceParameters") Then	
			
		ElsIf Type = Type("CatalogRef.TypeLinks") Then	
			
		ElsIf Type = Type("CatalogRef.Values") Then	
			
		ElsIf Type = Type("CatalogRef.DocumentNumerators") Then
			
		ElsIf Type = Type("CatalogRef.Events") Then
			
		ElsIf Type = Type("CatalogRef.Handlers") Then
			
		ElsIf Type = Type("CatalogRef.Locations") Then
			
		ElsIf Type = Type("CatalogRef.SettingsStorages") Then
			
		ElsIf Type = Type("CatalogRef.CommandInterfaces") Then
			
		ElsIf Type = Type("CatalogRef.Pictures") Then
			
		ElsIf Type = Type("ValueStorage") And Name = "Flowchart" Then
			
		ElsIf Type = Type("ValueStorage") And Name = "Schedule" Then
			
		ElsIf Type = Type("CatalogRef.InformationRegisters") Then
			
		ElsIf Type = Type("CatalogRef.SessionParameters") Then
			
		ElsIf Type = Type("CatalogRef.Attributes") Then	
			
		ElsIf Type = Type("CatalogRef.Constants") Then	
			
		ElsIf Type = Type("CatalogRef.Files") Then	
			
		ElsIf Type = Type("CatalogRef.Configurations") Then	
			
		ElsIf Type = Type("EnumRef.DataHistoryUse") Then	
			// 8.3.11
		ElsIf Type = Type("UUID") Then	
			// skip
		Else
			Object[Name] = XDTOValue;
			If Object[Name] <> XDTOValue Then
				Raise "assignment failed: " + XDTOValue;
			EndIf; 
		EndIf;
		
	EndDo;
	
EndProcedure // FillAttributesByXDTOProperties()

&AtServer
Procedure UpdateStrings(Configuration, Owner, Object, XDTODataObject, Keys) Export
	Var Key;
	
	For Each Key In Keys Do
		UpdateString(Configuration, Owner, Object[Key], XDTODataObject[Key]);
	EndDo; 
	
EndProcedure // UpdateStrings() 

&AtServer
Procedure UpdateString(Configuration, Owner, String, LocalString) Export
	
	If ValueIsFilled(String) Then
		StringObject = String.GetObject();
		If StringObject.Owner <> Owner Then
			Raise "Call in violation of protocol";
		EndIf; 
		StringObject.Values.Clear();
	Else
		If LocalString.item.Count() = 0 Then
			Return;
		EndIf; 
		StringObject = Catalogs.Strings.CreateItem();
		StringObject.Owner = Owner;
		StringObject.Configuration = Configuration;
	EndIf;
	
	For Each LocalStringItem In LocalString.item Do
		
		Item = StringObject.Values.Add();
		Item.Language = Meta_sr.LanguageByCode(Configuration, LocalStringItem.Lang);
		Item.Value = LocalStringItem.Content;
		
	EndDo; 
	
	StringObject.Write();
	String = StringObject.Ref;
	
EndProcedure // UpdateString()

&AtServer
Function ReadMetadataXML(Path) Export
	
	DataReader = New DataReader(Path, TextEncoding.UTF8); 
	BinaryDataBuffer = DataReader.ReadIntoBinaryDataBuffer();
	
	MDClassesPos = Abc.BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/MDClasses"));
	BinaryDataBuffer.Write(MDClassesPos, GetBinaryDataBufferFromString("http://Lead-Bullets/MDClasses"));
	
	ReadablePos = Abc.BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/xcf/readable"));
	BinaryDataBuffer.Write(ReadablePos, GetBinaryDataBufferFromString("http://Lead-Bullets/xcf/readable"));
	
	MemoryStream = New MemoryStream(BinaryDataBuffer);
	
	MyXDTOFactory = Meta_sr.XDTOFactory();
	Type = MyXDTOFactory.Type("http://Lead-Bullets/MDClasses", "MetaDataObject");  
	
	XMLReader = New XMLReader;
	XMLReader.OpenStream(MemoryStream);
	Try
		XDTOObject = MyXDTOFactory.ReadXML(XMLReader, Type);
	Except
		Message("Error path:" + Path);
		Raise;
	EndTry;
	XMLReader.Close();
	
	Return XDTOObject;
	
EndFunction // ReadMetadataXML()

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client