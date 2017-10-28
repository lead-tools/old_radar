
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer



#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server

&AtServer
Function AttributeTypes(MetadataObject) Export
	
	Return Meta_sr.AttributeTypes(MetadataObject.FullName());
	
EndFunction // AttributeTypes()

&AtServer
Function TypeManager(Type) Export
	
	Return Meta_sr.TypeManagers()[Type];
	
EndFunction // TypeManager() 

&AtServer
Procedure FillAttributesByXDTOProperties(Object, XDTOProperties) Export
	
	AttributeTypes = AttributeTypes(Object.Metadata());
	
	For Each Attribute In AttributeTypes Do
		
		Name = Attribute.Key;
		Type = Attribute.Value;
		Value = Undefined;
		
		Try
			XDTOValue = XDTOProperties[Name];
		Except
			Message(StrTemplate("Property %1 not found", Name));
			Continue;
		EndTry;
		
		If Type = Type("String") Then
			If TypeOf(XDTOValue) = Type("String") Then
				Value = XDTOValue;
			EndIf; 
		ElsIf Type = Type("Number") Then
			Value = Number(XDTOValue);
		ElsIf Type = Type("CatalogRef.Forms") Then
			
		ElsIf Type = Type("CatalogRef.Modules") Then
			
		ElsIf Type = Type("CatalogRef.Strings") Then
			
		Else
			TypeEnum = TypeManager(Type);
			Value = TypeEnum[XDTOValue];
		EndIf; 
		
		Object[Name] = Value;	
		
	EndDo;
	
EndProcedure // FillAttributesByXDTOProperties() 

#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client