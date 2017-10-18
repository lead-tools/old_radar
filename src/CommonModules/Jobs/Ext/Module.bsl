
///////////////////////////////////////////////////////////////////////////////

#Region ClientServer

Procedure StartParseModule(Module) Export
	
	Parameters = New Array;
	Parameters.Add(Module);
	
	Jobs_sc.StartJob("Jobs_sc.ParseModule", Parameters);
	
EndProcedure // StartParseModule()

Procedure StartParseProjectModules(Project) Export
	
	Parameters = New Array;
	Parameters.Add(Project);
	
	Jobs_sc.StartJob("Jobs_sc.StartParseProjectModules", Parameters);
	
EndProcedure // StartParseProjectModules()

#EndRegion // ClientServer

///////////////////////////////////////////////////////////////////////////////

#Region Server



#EndRegion // Server

///////////////////////////////////////////////////////////////////////////////

#Region Client



#EndRegion // Client