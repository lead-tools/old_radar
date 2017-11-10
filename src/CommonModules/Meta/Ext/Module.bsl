
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