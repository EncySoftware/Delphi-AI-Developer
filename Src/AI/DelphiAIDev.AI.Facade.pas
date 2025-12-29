unit DelphiAIDev.AI.Facade;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  DelphiAIDev.Consts,
  DelphiAIDev.Utils,
  DelphiAIDev.Settings,
  DelphiAIDev.AI.Interfaces,
  DelphiAIDev.Types,
  DelphiAIDev.AI.Response,
  DelphiAIDev.AI.Request.Chat;

type
  TDelphiAIDevAIFacade = class
  const
    HISTORY_DEPTH = 10;
  private
    FSettings: TDelphiAIDevSettings;
    FAIRequestChat: TDelphiAIDevAIRequestChat;
    FResponse: IDelphiAIDevAIResponse;
    FHistory: TList<TAIMessage>;
    procedure AddHistory(const ASender, AContent: string);
  public
    constructor Create;
    destructor Destroy; override;
    function ProcessSend(const AQuestion: string): TDelphiAIDevAIFacade;
    function Response: IDelphiAIDevAIResponse;
    procedure ClearHistory;
  end;

implementation

procedure TDelphiAIDevAIFacade.AddHistory(const ASender, AContent: string);
begin
  if FHistory.Count > HISTORY_DEPTH then
    FHistory.Delete(0);
  FHistory.Add(TAIMessage.Create(ASender, AContent));
end;

procedure TDelphiAIDevAIFacade.ClearHistory;
begin
  FHistory.Clear;
end;

constructor TDelphiAIDevAIFacade.Create;
begin
  FSettings := TDelphiAIDevSettings.GetInstance;
  FSettings.LoadData;
  FResponse := TDelphiAIDevAIResponse.New;
  FHistory := TList<TAIMessage>.Create;
  FAIRequestChat := TDelphiAIDevAIRequestChat.Create(FSettings);
end;

destructor TDelphiAIDevAIFacade.Destroy;
begin
  FHistory.Free;
  FreeAndNil(FAIRequestChat);
  inherited;
end;

function TDelphiAIDevAIFacade.ProcessSend(const AQuestion: string): TDelphiAIDevAIFacade;
var
  LQuestion: string;
begin
  Result := Self;
  LQuestion := TUtils.AdjustQuestionToJson(AQuestion);

  if TUtils.DebugMyIsOn then
    TUtils.AddLogDeleteFileFirst(LQuestion, 'DelphiAIDevAI_ProcessSend');

  AddHistory('user', LQuestion);
  FAIRequestChat.SendRequest(FHistory.ToArray(), FResponse);
end;

function TDelphiAIDevAIFacade.Response: IDelphiAIDevAIResponse;
begin
  var respText := FResponse.GetContent().Text;
  AddHistory('assistant', TUtils.AdjustQuestionToJson(respText));
  Result := FResponse;
end;

end.
