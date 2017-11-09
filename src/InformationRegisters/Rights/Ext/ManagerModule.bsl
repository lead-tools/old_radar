
Function Load(Parameters) Export
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner.Owner)
	// # Path is file path
	
	This = InformationRegisters.Rights;
	
	Type = XDTOFactory.Type("http://v8.1c.ru/8.2/roles", "Rights");
	XMLReader = New XMLReader;
	XMLReader.OpenFile(Path);
	Data = XDTOFactory.ReadXML(XMLReader, Type);
	XMLReader.Close();
	
EndFunction // Load() 