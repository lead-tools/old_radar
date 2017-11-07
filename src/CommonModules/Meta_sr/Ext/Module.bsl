
Function AttributeTypes(MetadataObjectFullName) Export
	
	MetadataObject = Metadata.FindByFullName(MetadataObjectFullName);
	
	AttributeTypes = New Structure;
	
	For Each Attribute In MetadataObject.Attributes Do
		
		Types = Attribute.Type.Types();
		
		If Types.Count() <> 1 Then
			Raise "Composite types not supported"
		EndIf; 
		
		Type = Types[0];
		
		AttributeTypes.Insert(Attribute.Name, Type);
		
	EndDo;
	
	Return New FixedStructure(AttributeTypes);
	
EndFunction // AttributeTypes()

Function SkipProperties() Export
	
	SkipProperties = New Structure(
		"DataHistory,"
		"ManagerModule,"
		"ObjectModule,"
		"RecordSetModule,"
		"Module,"
		"ValueManagerModule,"
		"Flowchart,"
		"Schedule,"
		"CommandInterface,"
		"UUID,"
	);
	
	Return New FixedStructure(SkipProperties);
	
EndFunction // SkipProperties()

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