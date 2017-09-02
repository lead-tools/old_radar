
Procedure StartParseModule(Module) Export
	
	Parameters = New Array;
	Parameters.Add(Module);
	
	Jobs_ServerCall.StartJob("Jobs_ServerCall.ParseModule", Parameters);
	
EndProcedure // StartParseModule()

Procedure StartParseProjectModules(Project) Export
	
	Parameters = New Array;
	Parameters.Add(Project);
	
	Jobs_ServerCall.StartJob("Jobs_ServerCall.StartParseProjectModules", Parameters);
	
EndProcedure // StartParseProjectModules()