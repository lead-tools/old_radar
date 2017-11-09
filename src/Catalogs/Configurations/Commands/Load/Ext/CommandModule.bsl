
&AtClient
Procedure CommandProcessing(Configuration, CommandExecuteParameters)
	Load(Configuration);
EndProcedure

&AtServer
Procedure Load(Configuration)
	Path = Abc.AttributeValue(Configuration, "Path");
	Catalogs.Configurations.Load(Configuration, Path);	
EndProcedure 
