
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
	
	Return Query.Execute().Unload().UnloadColumn("Ref");
	
EndFunction // Modules()

Function AttributeValue(Ref, AttributeName) Export
	
	Return Abc.AttributeValue(Ref, AttributeName);
	
EndFunction // AttributeValue() 

Function AttributeValues(Ref, AttributeNames) Export
	
	Return Abc.AttributeValues(Ref, AttributeNames);
	
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