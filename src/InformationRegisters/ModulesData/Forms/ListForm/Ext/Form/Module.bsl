
&AtClient
Procedure ShowAST(Command)
	Text = MarshalAST();
	TextDocument = New TextDocument();
	TextDocument.SetText(Text);
	TextDocument.Show();
EndProcedure // ShowAST()

&AtServer
Function MarshalAST()
	CurrentRow = Items.List.CurrentRow;
	If ValueIsFilled(CurrentRow) Then
		Return InformationRegisters.ModulesData.MarshalAST(CurrentRow.Module, CurrentRow.GitSHA1);
	EndIf; 
EndFunction // MarshalAST() 
