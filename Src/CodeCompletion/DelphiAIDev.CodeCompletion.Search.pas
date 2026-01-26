unit DelphiAIDev.CodeCompletion.Search;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  ToolsAPI,
  DelphiAIDev.Types,
  DelphiAIDev.Consts,
  DelphiAIDev.Settings,
  DelphiAIDev.Utils,
  DelphiAIDev.Utils.OTA,
  DelphiAIDev.CodeCompletion.Vars,
  DelphiAIDev.AI.Request.CodeCmpl;

type
  IDelphiAIDevCodeCompletionSearch = interface
    ['{5F8BDEE9-14DC-4C8C-BA7A-681A94844AD8}']
    procedure Process(const AContext: IOTAKeyContext);
  end;

  TDelphiAIDevCodeCompletionSearch = class(TInterfacedObject, IDelphiAIDevCodeCompletionSearch)
  private
    FSettings: TDelphiAIDevSettings;
    FAIRequest: TDelphiAIDevAIRequestCodeCmpl;
    FVars: TDelphiAIDevCodeCompletionVars;
    FIOTAEditPosition: IOTAEditPosition;
    procedure ProcessResponse;
    procedure FormatPrefixCode(var APrefix: string; isImplSection: Boolean);
    procedure FormatSuffixCode(var ASuffix: string);
    function GetClassName(const ACodeText: string): string;
    function GetClassDeclaration(const ACodeText, AClassName: string): string;
  protected
    procedure Process(const AContext: IOTAKeyContext);
  public
    class function New: IDelphiAIDevCodeCompletionSearch;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

class function TDelphiAIDevCodeCompletionSearch.New: IDelphiAIDevCodeCompletionSearch;
begin
  Result := Self.Create;
end;

constructor TDelphiAIDevCodeCompletionSearch.Create;
begin
  FSettings := TDelphiAIDevSettings.GetInstance;
  FVars := TDelphiAIDevCodeCompletionVars.GetInstance;
  FAIRequest := TDelphiAIDevAIRequestCodeCmpl.Create;
end;

destructor TDelphiAIDevCodeCompletionSearch.Destroy;
begin
  FAIRequest.Free;
  inherited;
end;

procedure TDelphiAIDevCodeCompletionSearch.FormatPrefixCode(var APrefix: string;
  isImplSection: Boolean);
const
  MAX_CODE_SIZE = 8000;
begin
  // check implementation section
  var ind := 0;
  if isImplSection then begin
    // check end; string
    ind := APrefix.ToLower.LastIndexOf('end;');
    if ind > 0 then
      APrefix := APrefix.Substring(ind + 4).TrimLeft;

    // check type string
    ind := APrefix.ToLower.LastIndexOf('type');
    if ind > 0 then
      APrefix := APrefix.Substring(ind);
  end else begin
    // check procedure string
    ind := APrefix.ToLower.LastIndexOf('procedure ');
    if ind > 0 then
      APrefix := APrefix.Substring(ind);

    // check function string
    ind := APrefix.ToLower.LastIndexOf('function ');
    if ind > 0 then
      APrefix := APrefix.Substring(ind);
  end;

  // check max length
  if APrefix.Length > MAX_CODE_SIZE then
    APrefix := APrefix.Substring(APrefix.Length - MAX_CODE_SIZE);
end;

procedure TDelphiAIDevCodeCompletionSearch.FormatSuffixCode(var ASuffix: string);
const
  MAX_CODE_SIZE = 1000;
begin
  // first end
  var ind := ASuffix.ToLower.IndexOf('end;');
  if ind > 0 then
    ASuffix := ASuffix.Substring(0, ind + 4);

  // max length
  if ASuffix.Length > MAX_CODE_SIZE then
    ASuffix := ASuffix.Substring(0, MAX_CODE_SIZE);
end;

function TDelphiAIDevCodeCompletionSearch.GetClassDeclaration(const ACodeText,
  AClassName: string): string;
begin
  Result := '';
  var ind := ACodeText.IndexOf(AClassName + ' = class');
  if ind > 0 then begin
    var ClassDecl := ACodeText.Substring(ind);
    ind := ClassDecl.ToLower.IndexOf('end;');
    if ind > 0 then
      Result := ClassDecl.Substring(0, ind + 4);
  end;
end;

function TDelphiAIDevCodeCompletionSearch.GetClassName(const ACodeText: string): string;
begin
  Result := '';

  // search function or procedure
  var ind := ACodeText.ToLower.IndexOf('function ');
  if ind = -1 then
    ind := ACodeText.ToLower.IndexOf('procedure ');

  // substring class name
  if ind <> -1 then begin
    var cl := ACodeText.Substring(ind + 9).Trim;
    if cl.Contains('.') then
      Result := cl.Substring(0, cl.IndexOf('.'));
  end;
end;

procedure TDelphiAIDevCodeCompletionSearch.Process(const AContext: IOTAKeyContext);
var
  LPrefix, LSuffix, LDeclaration, LClassName: string;
begin
  FSettings.ValidateFillingAICodeComplOptions(TShowMsg.No);

  Screen.Cursor := crHourGlass;
  try
    var filePath := TUtilsOTA.GetCurrentModuleFileName;
    if not FileExists(filePath) then Exit;

    var ext := ExtractFileExt(filePath);
    if (ext <> '.pas') and (ext <> '.dpr') and (ext <> '.dpk') then Exit;

    TUtilsOTA.GetTextAroundCursor(LPrefix, LSuffix);
    if LPrefix.Trim = '' then Exit;

    var fullPrefix := LPrefix;
    var isImplSection := LSuffix.Contains('implementation');

    FormatPrefixCode(LPrefix, isImplSection);
    FormatSuffixCode(LSuffix);

    if not isImplSection then
      LClassName := GetClassName(LPrefix);

    if not LClassName.IsEmpty then
      LDeclaration := GetClassDeclaration(fullPrefix, LClassName);

    FAIRequest.SendRequest(LPrefix, LSuffix, LDeclaration, filePath);

    FIOTAEditPosition := AContext.EditBuffer.EditPosition;
    Self.ProcessResponse;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TDelphiAIDevCodeCompletionSearch.ProcessResponse;
var
  LRow: Integer;
  LColumn: Integer;
  LBlankTextLines: string;
  i: Integer;
begin
  if FAIRequest.Response.GetStatusCode <> 200 then
  begin
    TUtils.ShowMsg('Unable to perform AI request.',
      Format('Code: %d %s Message: %s', [FAIRequest.Response.GetStatusCode, sLineBreak, FAIRequest.Response.GetContent.Text]));
    Exit;
  end;

  FVars.Module := TUtilsOTA.GetCurrentModule;
  FVars.Contents.Text := TUtils.ConfReturnAI(FAIRequest.Response.GetContent.Text);
  LRow := FIOTAEditPosition.Row;
  LColumn := FIOTAEditPosition.Column;

  FVars.Row := LRow;
  FVars.Column := LColumn;
  FVars.LineIni := LRow;
  FVars.LineEnd := FVars.LineIni + FVars.Contents.Count;

  LBlankTextLines := '';
  for i := 1 to Pred(FVars.Contents.Count) do
    LBlankTextLines := LBlankTextLines + sLineBreak;

  FIOTAEditPosition.InsertText(LBlankTextLines);
  FIOTAEditPosition.Move(FVars.LineIni, LColumn);
end;

end.
