
Function JoinPath(Part1, Part2) Export
	
	If Right(Part1, 1) = "\" And Left(Part2, 1) = "\" Then
		Return Part1 + Mid(Part2, 2);
	EndIf; 
	
	If Right(Part1, 1) <> "\" And Left(Part2, 1) <> "\" Then
		Return StrTemplate("%1\%2", Part1, Part2);
	EndIf;
	
	Return Part1 + Part2;
	
EndFunction // JoinPath()