
&AtClient
Procedure CommandProcessing(Project, CommandExecuteParameters)
	LoadModules(Project);
EndProcedure

&AtServer
Procedure LoadModules(Project)
	Catalogs.Projects.LoadModules(Project);
EndProcedure