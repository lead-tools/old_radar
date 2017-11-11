
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	Kind = Parameters.ModuleKind;
	Ref  = Parameters.ModuleRef;
	
	// precondition:
	// # (Configuration == Owner.Owner)
	// # Path is file path
	
	This = Catalogs.Modules;
	
	If Not ValueIsFilled(Ref) Then
		Object = This.CreateItem();
		Ref = This.GetRef();
		Object.SetNewObjectRef(Ref);
	Else
		Object = Ref.GetObject();
	EndIf;
	
	// Properties
	
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Kind = Kind;
	Object.Path = Path;
	
	If Abc.FileExists(Path) Then
		
		DataReader = New DataReader(Path, TextEncoding.UTF8);
		BinaryData = DataReader.Read().GetBinaryData();
		
		SHA1 = Abc.SHA1(BinaryData);
		If Object.SHA1 <> SHA1 Then
			Object.SHA1 = SHA1;
			Object.Data = New ValueStorage(BinaryData, New Deflation);
		EndIf; 
		
	EndIf; 
	
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()
