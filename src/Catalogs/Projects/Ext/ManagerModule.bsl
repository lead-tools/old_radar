
Function Modules(Project) Export
	
	Query = New Query;
	Query.SetParameter("Project", Project);
	Query.Text =
	"SELECT
	|	Modules.Ref AS Ref
	|FROM
	|	Catalog.Modules AS Modules
	|WHERE
	|	Modules.Owner = &Project
	|	AND NOT Modules.DeletionMark";
	
	Return Query.Execute().Unload();
	
EndFunction // Modules()

Function AttributeValue(Ref, AttributeName) Export
	
	Query = New Query;
	Query.SetParameter("Ref", Ref);
	Query.Text = StrTemplate("SELECT %1 FROM Catalog.Projects AS Projects WHERE Projects.Ref = &Ref", AttributeName);
	
	Return Query.Execute().Unload()[0][AttributeName]; 
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Query = New Query;
	Query.SetParameter("Ref", Ref);
	Query.Text = StrTemplate("SELECT %1 FROM Catalog.Projects AS Projects WHERE Projects.Ref = &Ref", AttributeNames);
	
	AttributeValues = New Structure(AttributeNames);
	FillPropertyValues(AttributeValues, Query.Execute().Unload()[0]); 
	
	Return AttributeValues;
	
EndFunction // AttributeValues()

Procedure LoadModules(Ref) Export
	
	Path = AttributeValue(Ref, "Path");
	Files = FindFiles(Path, "*.bsl", True);
	
	For Each File In Files Do
		
		Module = Catalogs.Modules.CreateItem();
		Module.Owner = Ref;
		Module.Path = Mid(File.FullName, StrLen(Path) + 1);
		Module.Description = StrReplace(Right(Module.Path, 150), "\", ".");
		Module.Write();
		
	EndDo; 
	
EndProcedure // LoadModules() 