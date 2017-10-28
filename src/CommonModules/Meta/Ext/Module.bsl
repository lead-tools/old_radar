
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer
 

#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

&AtServer
Function AttributeTypes(MetadataObject) Export
	
	Return Meta_sr.AttributeTypes(MetadataObject.FullName());
	
EndFunction // AttributeTypes()

&AtServer
Function TypeManager(Type) Export
	
	Return Meta_sr.TypeManagers()[Type];
	
EndFunction // TypeManager() 

&AtServer
Procedure GenericLoad(Configuration, Path, MetadataObject, Ref = Undefined) Export
	
	Manager = Catalogs[MetadataObject.Name];
	
	Data = Abc.ReadMetadataXML(Path + ".xml");
	XDTOObject = Data.Sequence().GetValue(0);
	XDTOProperties = XDTOObject.Properties;
	UUID = New UUID(XDTOObject.UUID);
	
	If Ref = Undefined Then
		Ref = Manager.FindByAttribute("UUID", UUID,, Configuration);
	EndIf; 
	
	If Not ValueIsFilled(Ref) Then
		Object = Manager.CreateItem();
	Else
		Object = Ref.GetObject();
	EndIf; 
	
	Object.UUID = UUID;
	Object.Owner = Configuration;
	Object.Description = XDTOProperties.Name;
	
	Meta.FillAttributesByXDTOProperties(Configuration, Object, XDTOProperties); 
	
	Object.Write();
	
EndProcedure // GenericLoad()

&AtServer
Procedure FillAttributesByXDTOProperties(Configuration, Object, XDTOProperties) Export
	
	AttributeTypes = AttributeTypes(Object.Metadata());
	SkipProperties = Meta_sr.SkipProperties();
		
	For Each Attribute In AttributeTypes Do
		
		Name = Attribute.Key;
		Type = Attribute.Value;
		
		If Not SkipProperties.Property(Name) Then
			Try
				XDTOValue = XDTOProperties[Name];
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
			UpdateString(Configuration, Object[Name], XDTOValue.Sequence())
		ElsIf Type = Type("CatalogRef.ChartsOfAccounts") Then
			
		ElsIf Type = Type("CatalogRef.Tasks") Then
			
		ElsIf Type = Type("CatalogRef.ChartsOfCharacteristicTypes") Then
		
		ElsIf Type = Type("EnumRef.DataHistoryUse") Then	
			// 8.3.11
		ElsIf Type = Type("UUID") Then	
			// skip
		Else
			TypeEnum = TypeManager(Type);
			Object[Name] = TypeEnum[XDTOValue];
		EndIf;
		
	EndDo;
	
EndProcedure // FillAttributesByXDTOProperties()

&AtServer
Procedure UpdateString(Configuration, String, XDTOSequence)
	
	If ValueIsFilled(String) Then
		StringObject = String.GetObject();
		If StringObject.Owner <> Configuration Then
			Raise "Call in violation of protocol";
		EndIf; 
		StringObject.Values.Clear();
	Else
		If XDTOSequence.Count() = 0 Then
			Return;
		EndIf; 
		StringObject = Catalogs.Strings.CreateItem();
		StringObject.Owner = Configuration;
	EndIf;
	
	For Index = 0 To XDTOSequence.Count() - 1 Do
		
		XDTODataObject = XDTOSequence.GetValue(Index);
		
		Item = StringObject.Values.Add();
		Item.Language = Meta_sr.LanguageByCode(Configuration, XDTODataObject.Lang);
		Item.Value = XDTODataObject.Content;
		
	EndDo; 
	
	StringObject.Write();
	String = StringObject.Ref;
	
EndProcedure // UpdateString()

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client