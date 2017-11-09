
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	
	StandardProcessing = False;
	
	Fields.Add("Configuration");
	Fields.Add("Ref");	
	
EndProcedure // PresentationFieldsGetProcessing()

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	
	If ValueIsFilled(Data.Configuration) Then
		
		StandardProcessing = False;
		
		DefaultLanguage = Abc.AttributeValueFromCache(Data.Configuration, "DefaultLanguage");
		Presentation = Presentation(Data.Ref, DefaultLanguage);
		
	EndIf; 
	
EndProcedure // PresentationGetProcessing()

Function Presentation(Ref, Language)
	
	Query = New Query;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Language", Language);
	Query.Text =
	"SELECT
	|	StringsValues.Value AS Value
	|FROM
	|	Catalog.Strings.Values AS StringsValues
	|WHERE
	|	StringsValues.Ref = &Ref
	|	AND StringsValues.Language = &Language";
	
	QueryResult = Query.Execute(); 
	
	If QueryResult.IsEmpty() Then
		Return "";
	EndIf; 
	
	Return QueryResult.Unload()[0].Value;
	
EndFunction // Presentation() 