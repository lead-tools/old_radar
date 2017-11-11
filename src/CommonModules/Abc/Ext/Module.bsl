
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

Function Lines(String, Separator = Undefined, IncludeBlanks = False) Export
	
	If Separator = Undefined Then
		Separator = Chars.LF;
	EndIf; 
	
	Return StrSplit(String, Separator, IncludeBlanks);
	
EndFunction // Lines()

Function Fill(Dst, Src, Keys) Export
	Var Key;
	
	For Each Key In Keys Do
		If Not Assign(Dst[Key], Src[Key]) Then
			Raise StrTemplate("assignment failed; key: `%1`", Key);
		EndIf; 
	EndDo; 
	
EndFunction // Fill()

Function Assign(Variable, Value) Export
	
	Variable = Value;	
	Return Variable = Value Or Value = Undefined; 
	
EndFunction // Assign() 

Function FileExists(FullFileName) Export
		
	File = New File(FullFileName);
	
	Return File.Exist();
	
EndFunction // FileExists()

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
Function SHA1(BinaryDataOrStream) Export
	Var SHA1;
	
	// git method
	
	DataHashing = New DataHashing(HashFunction.SHA1);
	DataHashing.Append("blob " + Format(BinaryDataOrStream.Size(), "NZ=0; NG=") + Char(0));
	DataHashing.Append(BinaryDataOrStream);
	
	SHA1 = GetHexStringFromBinaryData(DataHashing.HashSum);
	
	Return SHA1;
	
EndFunction // SHA1()

&AtServer
Function BinFind(BinaryDataBuffer, SearchData, InitPos = 0) Export
		
	// naive search
	
	For Pos = InitPos To BinaryDataBuffer.Size - SearchData.Size Do
		
		Offset = SearchData.Size - 1;
		
		While Offset >= 0
			And BinaryDataBuffer[Pos + Offset] = SearchData[Offset] Do
			Offset = Offset - 1;
		EndDo; 
		
		If Offset = -1 Then
			Return Pos;
		EndIf; 
		
	EndDo; 
	
	Return Undefined;
	
EndFunction // BinFind() 

&AtServer
Procedure RefreshAllReusableValues() Export
	
	RefreshReusableValues();
	
EndProcedure // RefreshAllReusableValues() 

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client