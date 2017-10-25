
Function RefByUUID(Configuration, UUID) Export
	
	Query = New Query;
	Query.SetParameter("Configuration", Configuration);
	Query.SetParameter("UUID", UUID);
	Query.Text =
	"SELECT
	|	MetaUUID.Ref AS Ref,
	|	MetaUUID.Configuration AS Configuration
	|FROM
	|	InformationRegister.MetaUUID AS MetaUUID
	|WHERE
	|	MetaUUID.Configuration = &Configuration
	|	AND MetaUUID.UUID = &UUID";
	
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Return Undefined;
	EndIf; 
	
	Return QueryResult.Unload()[0].Ref;
	
EndFunction // RefByUUID() 