
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

Function TypeManagers() Export
	
	TypeManagers = New Map;
	
	For Each Enum In Enums Do
		TypeManagers[TypeOf(Enum.EmptyRef())] = Enum;
	EndDo; 
	
	Return New FixedMap(TypeManagers);
	
EndFunction // TypeManagers() 