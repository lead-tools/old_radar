
Function LanguageByCode(Configuration, LanguageCode) Export
	
	Query = New Query;
	Query.SetParameter("Owner", Configuration);
	Query.SetParameter("LanguageCode", LanguageCode);
	Query.Text =
	"SELECT
	|	Languages.Ref AS Ref
	|FROM
	|	Catalog.Languages AS Languages
	|WHERE
	|	Languages.Owner = &Owner
	|	AND Languages.LanguageCode = &LanguageCode";
	
	QueryResult = Query.Execute(); 
	
	If QueryResult.IsEmpty() Then
		Return Undefined;
	EndIf; 
	
	Return QueryResult.Unload()[0].Ref;
	
EndFunction // LanguageByCode()

Function XDTOFactory() Export
	
	XMLReader = New XMLReader;
	XMLReader.SetString(GetCommonTemplate("MDClasses_2_4").GetText());
	XDTOModel = XDTOFactory.ReadXML(XMLReader);
	XMLReader.Close();
	
	Packages = New Array;
	Packages.Add(XDTOFactory.Packages.Get("http://v8.1c.ru/8.1/data/enterprise/current-config"));
	
	Return New XDTOFactory(XDTOModel, Packages);
	
EndFunction // XDTOFactory()

Function StringCache(Configuration) Export
	
	Query = New Query;
	Query.SetParameter("Configuration", Configuration);
	Query.Text =
	"SELECT
	|	Strings.Ref AS Ref,
	|	Strings.SHA1 AS SHA1
	|FROM
	|	Catalog.Strings AS Strings
	|WHERE
	|	Strings.Configuration = &Configuration";
	
	StringCache = Query.Execute().Unload();
	StringCache.Indexes.Add("Ref");
	
	Return StringCache;
	
EndFunction // StringCache()  