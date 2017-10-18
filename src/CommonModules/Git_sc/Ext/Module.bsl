
Function SHA1(Module, Source) Export
	Var SHA1;
	
	//TempFileName = GetTempFileName("txt");
	//Commit = "HEAD";
	//
	//Shell = New COMObject("Wscript.shell");
	//Shell.CurrentDirectory = Module.Owner.Path;
	//Ret = Shell.Run(StrTemplate("cmd.exe /c git rev-parse --verify %1:%2 >%3", Commit, Module.Path, TempFileName), 0, True);
	//Ret = Shell.Run(StrTemplate("cmd.exe /c git hash-object %1 >%2", Module.Path, TempFileName), 0, True);
	
	//If Ret = 0 Then
	//	
	//	TextReader = New TextReader(TempFileName, TextEncoding.ANSI);
	//	SHA1 = Upper(TextReader.Read(40));
	//	
	//EndIf; 	
	//	
	//If SHA1 = Undefined Or Left(SHA1, 5) = "FATAL" Then
		
		BinaryData = GetBinaryDataFromString(Source);
		
		DataHashing = New DataHashing(HashFunction.SHA1);
		DataHashing.Append("blob " + Format(BinaryData.Size(), "NZ=0; NG=") + Char(0));
		DataHashing.Append(BinaryData);
		
		SHA1 = GetHexStringFromBinaryData(DataHashing.HashSum);
		
	//EndIf; 
	
	Return SHA1;
	
EndFunction // SHA1()