unit DelphiAIDev.CodeCompletion.Utils.DelphiCode;

interface

uses
  System.SysUtils, System.Classes;

type
  TDelphiCodeUtils = class
    class function RemoveComments(const SourceCode: string): string;
    class function GetClassDeclaration(const SourceCode, ClassName: string): string;
    class function GetClassDeclarations(const SourceCode, ClassName: string): TStringList;
  end;

implementation

{ TDelphiCodeUtils }

class function TDelphiCodeUtils.GetClassDeclaration(const SourceCode,
  ClassName: string): string;
begin
  Result := '';
  var ind := SourceCode.LastIndexOf(ClassName + ' = class');
  if ind > 0 then begin
    var ClassDecl := SourceCode.Substring(ind);
    ind := ClassDecl.ToLower.IndexOf('end;');
    if ind > 0 then
      Result := ClassDecl.Substring(0, ind + 4);
  end;
end;

class function TDelphiCodeUtils.GetClassDeclarations(const SourceCode,
  ClassName: string): TStringList;
begin
  Result := TStringList.Create;

  // find class declaration and remove all comments
  var classDecl := GetClassDeclaration(SourceCode, ClassName);
  Result.Text := RemoveComments(classDecl);

  var decl := '';
  for var i := Result.Count - 1 downto 1 do begin
    var line := Result[i].Trim;

    // leave only variable declarations
    if not line.Contains(':') and not line.ToLower.Contains('procedure ') then begin
      Result.Delete(i);
      continue;
    end;

    // start multiline variable declarations
    if line.Contains(')') and not line.Contains('(') then begin
      decl := line;
      Result.Delete(i);
      continue;
    end;

    // multiline variable declarations
    if not decl.IsEmpty and not line.Contains('(') then begin
      decl := line + ' ' + decl;
      Result.Delete(i);
      continue;
    end;

    // end multiline variable declarations
    if not decl.IsEmpty then begin
      line := line + ' ' + decl;
      decl := string.Empty;
    end;

    Result[i] := line;
  end;
end;

class function TDelphiCodeUtils.RemoveComments(const SourceCode: string): string;
var
  I: Integer;
  InComment, InString: Boolean;
begin
  Result := '';
  InComment := False;
  InString := False;
  I := 1;

  while I <= Length(SourceCode) do
  begin
    // start of a one-line comment
    if not InComment and not InString and
       (I < Length(SourceCode)) and
       (SourceCode[I] = '/') and (SourceCode[I+1] = '/') then
    begin
      Inc(I, 2);
      // skip to line end
      while (I <= Length(SourceCode)) and not (SourceCode[I] in [#10, #13]) do
        Inc(I);
      Continue;
    end;

    // start of multi-line comment
    if not InComment and not InString and (SourceCode[I] = '{') then
    begin
      InComment := True;
      Inc(I);
      Continue;
    end;

    // end of multi-line comment
    if InComment and (SourceCode[I] = '}') then
    begin
      InComment := False;
      Inc(I);
      Continue;
    end;

    // Handling strings (to avoid counting quotes inside comments)
    if not InComment and (SourceCode[I] = '''') then
      InString := not InString;

    // Adding a symbol if not in the comments
    if not InComment then
      Result := Result + SourceCode[I];

    Inc(I);
  end;

end;

end.
