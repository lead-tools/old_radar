
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
	
EndFunction // AttributeValue()

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
Function ReadMetadataXML(Path) Export
	
	XMLReader = New XMLReader;
	XMLReader.OpenFile(Path);
	
	Return XDTOFactory.ReadXML(XMLReader);
	
EndFunction // ReadMetadataXML()

&AtServer
Procedure RefreshAllReusableValues() Export
	RefreshReusableValues();
EndProcedure // RefreshAllReusableValues() 

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client