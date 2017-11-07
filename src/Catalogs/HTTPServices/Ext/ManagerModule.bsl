
Function AttributeValue(Ref, AttributeName) Export
		
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames);
	
EndFunction // AttributeValues()

Procedure Load(Configuration, Path, Ref = Undefined) Export
	
	Meta.GenericLoad(Configuration, Path, EmptyRef().Metadata(), Ref);
	
EndProcedure // Load()