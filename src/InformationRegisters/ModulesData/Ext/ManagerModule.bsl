
Function MarshalAST(Module, GitSHA1) Export	
	
	JSONWriter = New JSONWriter;
	TempFileName = GetTempFileName(".json");
	JSONWriter.OpenFile(TempFileName,,, New JSONWriterSettings(, Chars.Tab));
	WriteJSON(JSONWriter, AST(Module, GitSHA1));
	JSONWriter.Close();
	TextReader = New TextReader(TempFileName, TextEncoding.UTF8);
	
	Return TextReader.Read();		
EndFunction // MarshalAST()

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