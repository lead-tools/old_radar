
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer

Function JoinPath(Part1, Part2) Export
	
	If Right(Part1, 1) = "\" And Left(Part2, 1) = "\" Then
		Return Part1 + Mid(Part2, 2);
	EndIf; 
	
	If Right(Part1, 1) <> "\" And Left(Part2, 1) <> "\" Then
		Return StrTemplate("%1\%2", Part1, Part2);
	EndIf;
	
	Return Part1 + Part2;
	
EndFunction // JoinPath()

Function Slice(Array, Start, Count) Export

	Slice = New Array;
	
	For Index = Start To Start + Count - 1 Do
		Slice.Add(Array[Index]);
	EndDo; 
	
	Return Slice;
	
EndFunction // Slice()

Function GetConstant(Name) Export
	
	#If Server Then
		Return Abc_sr.GetConstant(Name);
	#Else
		Return Abc_sc.GetConstant(Name);
	#EndIf // Server
	
EndFunction // GetConstant() 	
	
#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

&AtServer
Function AttributeValue(Ref, AttributeName) Export
	
	Query = New Query;
	Query.SetParameter("Ref", Ref);
	Query.Text = StrTemplate("SELECT %1 FROM %2 WHERE Ref = &Ref", AttributeName, Ref.Metadata().FullName());
	
	Return Query.Execute().Unload()[0][AttributeName]; 
	
EndFunction // AttributeValue() 

&AtServer
Function AttributeValueFromCache(Ref, AttributeName) Export
	
	Return Abc_sr.AttributeValue(Ref, AttributeName); 
	
EndFunction // AttributeValueFromCache()

&AtServer
Function AttributeValues(Ref, AttributeNames) Export
	
	AttributeValues = New Structure(AttributeNames);
	
	Query = New Query;
	Query.SetParameter("Ref", Ref);
	Query.Text = StrTemplate("SELECT %1 FROM %2 WHERE Ref = &Ref", AttributeNames, Ref.Metadata().FullName());
	
	FillPropertyValues(AttributeValues, Query.Execute().Unload()[0]); 
	
	Return AttributeValues;
	
EndFunction // AttributeValues()
	
&AtServer	
Function GetDataProcessor(Name) Export
	
	Return Abc_sr.GetDataProcessor(Name);
	
EndFunction // GetDataProcessor()

&AtServer
Function BinFind(BinaryDataBuffer, SearchData, InitPos = 0) Export
	
	// naive search
	
	For Pos = InitPos To BinaryDataBuffer.Size - 1 Do
		
		Offset = 0;
		
		While Offset < SearchData.Size
			And BinaryDataBuffer[Pos + Offset] = SearchData[Offset] Do
			Offset = Offset + 1;
		EndDo; 
		
		If Offset = SearchData.Size Then
			Return Pos;
		EndIf; 
		
	EndDo; 
	
	Return Undefined;
	
EndFunction // BinFind() 

&AtServer
Function ReadMetadataXML(Path) Export
	
	DataReader = New DataReader(Path, TextEncoding.UTF8); 
	BinaryDataBuffer = DataReader.ReadIntoBinaryDataBuffer();
	
	MDClassesPos = BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/MDClasses"));
	BinaryDataBuffer.Write(MDClassesPos, GetBinaryDataBufferFromString("http://Lead-Bullets/MDClasses"));
	
	ReadablePos = BinFind(BinaryDataBuffer, GetBinaryDataBufferFromString("http://v8.1c.ru/8.3/xcf/readable"));
	BinaryDataBuffer.Write(ReadablePos, GetBinaryDataBufferFromString("http://Lead-Bullets/xcf/readable"));
	
	MemoryStream = New MemoryStream(BinaryDataBuffer);
	
	XMLReader = New XMLReader;
	XMLReader.SetString(GetCommonTemplate("MDClasses_2_4").GetText());
	XDTOModel = XDTOFactory.ReadXML(XMLReader);
	XMLReader.Close();
	
	Packages = New Array;
	Packages.Add(XDTOFactory.Packages.Get("http://v8.1c.ru/8.1/data/enterprise/current-config"));
	
	MyXDTOFactory = New XDTOFactory(XDTOModel, Packages);
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

&AtServer
Procedure RefreshAllReusableValues() Export
	RefreshReusableValues();
EndProcedure // RefreshAllReusableValues() 

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client