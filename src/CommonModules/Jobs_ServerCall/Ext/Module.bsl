
Procedure StartJob(Method, Parameters) Export
	
	BackgroundJobs.Execute(Method, Parameters);
	
EndProcedure // StartJob() 

Procedure StartParseProjectModules(Project) Export
	
	Modules = Catalogs.Projects.Modules(Project); 
	
	MaxJobs = Max(Constants.MaxJobs.Get(), 1);
	Total = Modules.Count();
	NumberPerJob = Int(Total / MaxJobs);
	Remain = Total - NumberPerJob * MaxJobs;
	
	Start = 0;
	For JobNum = 1 To MaxJobs - 1 Do		
		Chunk = Slice(Modules, Start, NumberPerJob);
		Parameters = New Array;
		Parameters.Add(Chunk);
		StartJob("Jobs_ServerCall.StartParseModules", Parameters);
		Start = Start + NumberPerJob;
	EndDo; 
	
	NumberPerJob = NumberPerJob + Remain;
	
	Chunk = Slice(Modules, Start, NumberPerJob);
	Parameters = New Array;
	Parameters.Add(Chunk);
	StartJob("Jobs_ServerCall.StartParseModules", Parameters);
	
EndProcedure // StartParseProjectModules()

Procedure StartParseModules(Modules) Export
	
	For Each Module In Modules Do
		Try
			ParseModule(Module);
		Except
			WriteLogEvent(
				"BSL-Parser",
				EventLogLevel.Error,
				Metadata.Catalogs.Modules,
				Module,
				ErrorDescription()
			);
		EndTry;
	EndDo; 
	
EndProcedure // StartParseModules()

Procedure ParseModule(Module) Export
	
	ModuleAttributes = Catalogs.Modules.AttributeValues(Module, "Owner, Path");
	ProjectPath = Catalogs.Projects.AttributeValue(ModuleAttributes.Owner, "Path"); 
	
	FilePath = JoinPath(ProjectPath, ModuleAttributes.Path);
	
	DataReader = New DataReader(FilePath, TextEncoding.UTF8); 
	Source = DataReader.ReadChars();
		
	GitSHA1 = Git.SHA1(Module, Source);
	
	BSLParser = CommonUse.GetDataProcessor("BSLParser");
	Parser = BSLParser.Parser(Mid(Source, 2));
	Parser.Scanner.Path = FilePath;
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