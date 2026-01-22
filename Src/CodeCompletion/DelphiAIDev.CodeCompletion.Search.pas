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

procedure TDelphiAIDevCodeCompletionSearch.Process(const AContext: IOTAKeyContext);
const
  CODE_SIZE_BEFORE = 25000;
  CODE_SIZE_AFTER = 5000;
var
  LIOTAEditPosition: IOTAEditPosition;
  LPrefix, LSuffix, LResultText: string;
  LRow, LColumn: Integer;
begin
  FSettings.ValidateFillingAICodeComplOptions(TShowMsg.No);

  Screen.Cursor := crHourGlass;
  try
    TUtilsOTA.GetTextAroundCursor(LPrefix, LSuffix);
    if LPrefix = '' then Exit;

    if LPrefix.Length > CODE_SIZE_BEFORE then
      LPrefix := LPrefix.Substring(LPrefix.Length - CODE_SIZE_BEFORE);

    if LSuffix.Length > CODE_SIZE_AFTER then
      LSuffix := LSuffix.Substring(0, CODE_SIZE_AFTER);

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
