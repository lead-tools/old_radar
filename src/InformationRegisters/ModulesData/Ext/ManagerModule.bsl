
Function MarshalAST(Module, GitSHA1) Export	
	
	JSONWriter = New JSONWriter;
	TempFileName = GetTempFileName(".json");
	JSONWriter.OpenFile(TempFileName,,, New JSONWriterSettings(, Chars.Tab));
	AST = AST(Module, GitSHA1);
	Comments = New Map;
	For Each Item In AST.Comments Do
		Comments[Format(Item.Key, "NZ=0; NG=")] = Item.Value;
	EndDo;
	AST.Comments = Comments;
	WriteJSON(JSONWriter, AST,, "ConvertJSON", InformationRegisters.ModulesData);
	JSONWriter.Close();
	TextReader = New TextReader(TempFileName, TextEncoding.UTF8);
	
	Return TextReader.Read();		
EndFunction // MarshalAST()

Function ConvertJSON(Property, Value, Other, Cancel) Export
	If Value = Null Then
		Return Undefined;
	EndIf;
EndFunction // ConvertJSON()

Function AST(Module, GitSHA1)
	
	Query = New Query;
	Query.SetParameter("Module", Module);
	Query.SetParameter("GitSHA1", GitSHA1);
	Query.Text =
	"SELECT
	|	ModulesData.AST AS AST
	|FROM
	|	InformationRegister.ModulesData AS ModulesData
	|WHERE
	|	ModulesData.Module = &Module
	|	AND ModulesData.GitSHA1 = &GitSHA1";
	
	QueryResult = Query.Execute();
	
	If Not QueryResult.IsEmpty() Then
		Rider = QueryResult.Select();
		Rider.Next();
		Return Rider.AST.Get();
	EndIf; 
	
	Return Undefined;
	
EndFunction // AST()