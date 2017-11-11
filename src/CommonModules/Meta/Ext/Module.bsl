
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
Function StringCache(Configuration) Export
	
	Return Meta_sr.StringCache(Configuration);
	
EndFunction // StringCache() 

&AtServer
Function LanguageByCodeFromCache(Configuration, LanguageCode) Export
	
	Return Meta_sr.LanguageByCode(Configuration, LanguageCode);
	
EndFunction // LanguageByCode()  

&AtServer
Procedure UpdateStrings(Configuration, Owner, Object, XDTODataObject, Keys) Export
	Var Key;
	
	LoadParameters = Meta.ObjectLoadParameters();
	LoadParameters.Configuration = Configuration;
	LoadParameters.Owner = Owner;
	LoadParameters.Insert("LocalString");
	LoadParameters.Insert("StringRef");
	
	For Each Key In Keys Do
		LocalString = XDTODataObject[Key];
		If LocalString <> Undefined Then
			LoadParameters.LocalString = LocalString;
			LoadParameters.StringRef = Object[Key];
			Object[Key] = Catalogs.Strings.Load(LoadParameters);
			//UpdateString(Configuration, Owner, Object[Key], LocalString);
		EndIf; 
	EndDo; 
	
EndProcedure // UpdateStrings() 

&AtServer
Function ReadMetadataXML(Path, SHA1 = Undefined) Export
		
	DataReader = New DataReader(Path, TextEncoding.UTF8); 
	BinaryDataBuffer = DataReader.ReadIntoBinaryDataBuffer();
	
	MemoryStream = New MemoryStream(BinaryDataBuffer);
	
	If SHA1 <> Undefined Then
		StreamSHA1 = Abc.SHA1(MemoryStream);
		MemoryStream.Seek(0, PositionInStream.Begin);
		If StreamSHA1 = SHA1 Then
			Return Undefined;
		Else
			SHA1 = StreamSHA1;
		EndIf; 
	EndIf; 
	
	TextReader = New TextReader(Path, TextEncoding.UTF8);	
	Offset = 3 + StrLen(TextReader.ReadLine()) + 1; // BOM + XML declaration + LF
	MetaDataObjectTag = TextReader.ReadLine();
	TextReader.Close();
	
	MDClassesPos = Offset + StrFind(MetaDataObjectTag, "http://v8.1c.ru/8.3/MDClasses");
	//MDClassesPos = Abc.BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/MDClasses"));
	BinaryDataBuffer.Write(MDClassesPos, GetBinaryDataBufferFromString("http://Lead-Bullets/MDClasses"));
	
	ReadablePos = Offset + StrFind(MetaDataObjectTag, "http://v8.1c.ru/8.3/xcf/readable");
	//ReadablePos = Abc.BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/xcf/readable"));
	BinaryDataBuffer.Write(ReadablePos, GetBinaryDataBufferFromString("http://Lead-Bullets/xcf/readable"));
	
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