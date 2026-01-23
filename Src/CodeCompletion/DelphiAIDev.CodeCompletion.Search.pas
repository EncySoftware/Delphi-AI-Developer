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
    ind := APrefix.LastIndexOf('end;');
    if ind > 0 then
      APrefix := APrefix.Substring(ind + 4).TrimLeft;

    // check type string
    ind := APrefix.LastIndexOf('type');
    if ind > 0 then
      APrefix := APrefix.Substring(ind);
  end else begin
    // check procedure string
    ind := APrefix.LastIndexOf('procedure');
    if ind > 0 then
      APrefix := APrefix.Substring(ind);

    // check function string
    ind := APrefix.LastIndexOf('function');
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
  var ind := ASuffix.IndexOf('end;');
  if ind > 0 then
    ASuffix := ASuffix.Substring(0, ind + 4);

  // max length
  if ASuffix.Length > MAX_CODE_SIZE then
    ASuffix := ASuffix.Substring(0, MAX_CODE_SIZE);
end;

procedure TDelphiAIDevCodeCompletionSearch.Process(const AContext: IOTAKeyContext);
var
  LPrefix, LSuffix: string;
begin
  FSettings.ValidateFillingAICodeComplOptions(TShowMsg.No);

  Screen.Cursor := crHourGlass;
  try
    TUtilsOTA.GetTextAroundCursor(LPrefix, LSuffix);
    if LPrefix.Trim = '' then Exit;

    var isImplSection := LSuffix.Contains('implementation');
    FormatPrefixCode(LPrefix, isImplSection);
    FormatSuffixCode(LSuffix);

    FAIRequest.SendRequest(LPrefix, LSuffix);

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
