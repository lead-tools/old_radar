
Procedure StartJob(Method, Parameters) Export
	
	BackgroundJobs.Execute(Method, Parameters);
	
EndProcedure // StartJob() 

Procedure StartParseProjectModules(Project) Export
	
	Modules = Catalogs.Projects.Modules(Project); 
	
	For Each Module In Modules Do
		
		Parameters = New Array;
		Parameters.Add(Module.Ref);
		
		StartJob("Jobs_ServerCall.ParseModule", Parameters);
		
	EndDo; 
	
EndProcedure // StartParseProjectModules()

Procedure ParseModule(Module) Export
	
	ModuleAttributes = Catalogs.Modules.AttributeValues(Module, "Owner, Path");
	ProjectPath = Catalogs.Projects.AttributeValue(ModuleAttributes.Owner, "Path"); 
	
	FilePath = JoinPath(ProjectPath, ModuleAttributes.Path);
	
	DataReader = New DataReader(FilePath, TextEncoding.UTF8); 
	Source = DataReader.ReadChars();
		
	GitSHA1 = Git.SHA1(Module, Source);
	
	BSLParser = CommonUse.GetDataProcessor("BSLParser");
	Parser = BSLParser.Parser(Mid(Source, 2));
	ParsingStart = CurrentUniversalDateInMilliseconds();
	BSLParser.ParseModule(Parser);
	ParsingDuration = (CurrentUniversalDateInMilliseconds() - ParsingStart) / 1000;
	
	Record = InformationRegisters.ModulesData.CreateRecordManager();
	Record.Module = Module;
	Record.GitSHA1 = GitSHA1;
	Record.AST = New ValueStorage(Parser.Module, New Deflation);
	Record.ParsingDuration = ParsingDuration;
	Record.Write(True);
	
EndProcedure // ParseModule() 