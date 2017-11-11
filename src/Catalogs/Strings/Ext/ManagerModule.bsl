﻿
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

Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	LocalString = Parameters.LocalString;
	Ref  = Parameters.StringRef;
	
	SHA1 = SHA1(LocalString);
	
	StringCache = Meta.StringCache(Configuration);
	
	If ValueIsFilled(Ref) Then
		
		StringCacheItem = StringCache.Find(Ref, "Ref");
		If StringCacheItem <> Undefined And StringCacheItem.SHA1 = SHA1 Then
			Return Ref;
		EndIf;
		
		StringObject = Ref.GetObject();
		If StringObject.Owner <> Owner Then
			Raise "Call in violation of protocol";
		EndIf; 
		StringObject.Values.Clear();
		
	Else
		
		If LocalString.item.Count() = 0 Then
			Return Ref;
		EndIf;
		
		StringObject = Catalogs.Strings.CreateItem();
		StringObject.Owner = Owner;
		StringObject.Configuration = Configuration;
		
	EndIf;
	
	For Each LocalStringItem In LocalString.item Do
		
		Item = StringObject.Values.Add();
		Item.Language = Meta.LanguageByCodeFromCache(Configuration, LocalStringItem.Lang);
		Item.Value = LocalStringItem.Content;
		
	EndDo; 
	
	StringObject.SHA1 = SHA1;
	StringObject.Write();
	
	Return StringObject.Ref;
	
EndFunction // Load()

Function SHA1(LocalString) Export
	Var SHA1;
	
	DataHashing = New DataHashing(HashFunction.SHA1);
	
	For Each LocalStringItem In LocalString.item Do
		
		DataHashing.Append(LocalStringItem.Lang);
		DataHashing.Append(Format(StrLen(LocalStringItem.Content), "NZ=0; NG="));
		DataHashing.Append(LocalStringItem.Content);
		
	EndDo; 
	
	SHA1 = GetHexStringFromBinaryData(DataHashing.HashSum);
	
	Return SHA1;
	
EndFunction // SHA1()