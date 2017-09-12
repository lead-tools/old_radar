
Procedure StartJob(Method, Parameters) Export
	
	BackgroundJobs.Execute(Method, Parameters);
	
EndProcedure // StartJob() 

Procedure StartParseProjectModules(Project) Export
	
	Modules = Catalogs.Projects.Modules(Project); 	
	MaxJobs = Max(CommonUse.GetConstant("MaxJobs"), 1);
	QueueID = New UUID;
	
	Record = InformationRegisters.JobQueue.CreateRecordManager();
	Record.QueueID = QueueID;
	Record.Total = Modules.Count();
	Record.StartDate = CurrentDate();
	Record.Write();
	
	For JobNum = 1 To MaxJobs Do		
		Parameters = New Array;
		Parameters.Add(Modules);
		Parameters.Add(QueueID);
		StartJob("Jobs_ServerCall.StartParseModules", Parameters);
	EndDo; 
	
EndProcedure // StartParseProjectModules() 

Procedure StartParseModules(Modules, QueueID) Export
	
	Chunk = TakeChunk(Modules, QueueID);
	
	While Chunk.Count() > 0 Do
		
		For Each Module In Chunk Do
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
		
		Chunk = TakeChunk(Modules, QueueID);
		
	EndDo; 
	
EndProcedure // StartParseModules()

Function TakeChunk(Array, QueueID)
	
	ChunkSize = Max(CommonUse.GetConstant("ChunkSize"), 1);	
	
	DataLock = New DataLock;
	LockItem = DataLock.Add("InformationRegister.JobQueue");
	LockItem.SetValue("QueueID", QueueID);
	
	Record = InformationRegisters.JobQueue.CreateRecordManager();
	Record.QueueID = QueueID;
	
	BeginTransaction();
	
	DataLock.Lock();
	Record.Read();
	
	Taken = Record.Taken;
	ChunkSize = Min(ChunkSize, Record.Total - Taken);
	Record.Taken = Taken + ChunkSize;
	Record.EndDate = CurrentDate();
	
	Record.Write(True);
	
	CommitTransaction();
	
	Return Slice(Array, Taken, ChunkSize);
	
EndFunction // TakeChunk()

Procedure ParseModule(Module) Export
	
	ModuleAttributes = Catalogs.Modules.AttributeValues(Module, "Owner, Path");
	ProjectPath = Catalogs.Projects.AttributeValue(ModuleAttributes.Owner, "Path"); 
	
	FilePath = JoinPath(ProjectPath, ModuleAttributes.Path);
	
	DataReader = New DataReader(FilePath, TextEncoding.UTF8); 
	Source = DataReader.ReadChars();
		
	GitSHA1 = Git.SHA1(Module, Source);
	
	BSLParser = CommonUse.GetDataProcessor("BSLParser");
	BSLParser.Location = True;
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