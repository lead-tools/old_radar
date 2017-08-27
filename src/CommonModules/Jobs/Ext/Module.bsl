
Procedure StartParseModule(Module) Export
	
	Parameters = New Array;
	Parameters.Add(Module);
	
	Jobs_ServerCall.StartJob("Jobs_ServerCall.ParseModule", Parameters);
	
EndProcedure // StartParseModule()

Procedure StartParseProjectModules(Project) Export
	
	Jobs_ServerCall.StartParseProjectModules(Project);
	
EndProcedure // StartParseProjectModules()