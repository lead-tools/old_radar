
Function AttributeValue(Ref, AttributeName) Export
		
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
		
	Return Abc.AttributeValues(Ref, AttributeNames, "Catalog.Modules");
	
EndFunction // AttributeValues()