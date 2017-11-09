
Function Load(Parameters) Export
	Var Ref;
	
	Configuration = Parameters.Configuration;
	Owner = Parameters.Owner;
	Path = Parameters.Path;
	
	// precondition:
	// # (Configuration == Owner) or (Configuration == Owner.Owner)
	// # Path is folder path
	
	This = Catalogs.Forms;
	
	Data = Meta.ReadMetadataXML(Path + ".xml");
	IsCommonForm = (Configuration = Owner);
	If IsCommonForm Then
		Form = Data.CommonForm;
	Else
		Form = Data.Form;
	EndIf; 
	PropertyValues = Form.Properties;
	UUID = Form.UUID; 
	
	Object = Meta.GetObject(This, UUID, Owner, Ref);  
	
	// Properties
	
	Object.UUID = UUID;
	Object.Owner = Owner;
	Object.Configuration = Configuration;
	Object.Description = PropertyValues.Name;
	
	Abc.Fill(Object, PropertyValues, Abc.Lines(
		"Comment"
		"FormType"
		"IncludeHelpInContents"
		+ ?(IsCommonForm, "UseStandardCommands", "")
	));
	
	Meta.UpdateStrings(Configuration, Ref, Object, PropertyValues, Abc.Lines(
	    "Synonym"
		+ ?(IsCommonForm, "Explanation" "ExtendedPresentation", "")
	));
		
	Object.Write();	
	
	Return Object.Ref;
	
EndFunction // Load()