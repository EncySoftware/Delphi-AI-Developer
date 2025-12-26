unit DelphiAIDev.AI.Facade;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  RESTRequest4D,
  DelphiAIDev.Consts,
  DelphiAIDev.Utils,
  DelphiAIDev.Settings,
  DelphiAIDev.AI.Interfaces,
  DelphiAIDev.Types,
  DelphiAIDev.AI.Response;

type
  TDelphiAIDevAIFacade = class
  private
    FSettings: TDelphiAIDevSettings;
    FResponse: IDelphiAIDevAIResponse;
    procedure AIChatRequest(const AQuestion: string);
  public
    constructor Create;
    destructor Destroy; override;
    function ProcessSend(const AQuestion: string): TDelphiAIDevAIFacade;
    function Response: IDelphiAIDevAIResponse;
  end;

implementation

constructor TDelphiAIDevAIFacade.Create;
begin
  FSettings := TDelphiAIDevSettings.GetInstance;
  FSettings.LoadData;
  FResponse := TDelphiAIDevAIResponse.New;
end;

destructor TDelphiAIDevAIFacade.Destroy;
begin
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

  AIChatRequest(LQuestion);
end;

function TDelphiAIDevAIFacade.Response: IDelphiAIDevAIResponse;
begin
  Result := FResponse;
end;

procedure TDelphiAIDevAIFacade.AIChatRequest(const AQuestion: string);
const
  API_JSON_BODY_BASE = '{"model": "%s", "messages": [{"role": "user", "content": "%s"}], "stream": false, "max_tokens": 2048}';
var
  LResponse: IResponse;
  LJsonValueAll: TJSONValue;
  LJsonValueChoices: TJSONValue;
  LJsonArrayChoices: TJSONArray;
  LJsonObjChoices: TJSONObject;
  LJsonValueMessage: TJSONValue;
  LJsonObjMessage: TJSONObject;
  LItemChoices: Integer;
  LResult: string;
begin
  LResponse := TRequest.New
    .BaseURL(FSettings.BaseUrlAIChat)
    .ContentType(TConsts.APPLICATION_JSON)
    .Accept(TConsts.APPLICATION_JSON)
    .TokenBearer(FSettings.ApiKeyAIChat)
    .AddBody(Format(API_JSON_BODY_BASE, [FSettings.ModelAIChat, AQuestion]))
    .Post;

  FResponse.SetStatusCode(LResponse.StatusCode);

  if LResponse.StatusCode <> 200 then
  begin
    FResponse.SetContentText('Question cannot be answered' + sLineBreak + 'Return: ' + LResponse.Content);
    Exit;
  end;

  LJsonValueAll := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse.Content), 0);
  if not(LJsonValueAll is TJSONObject) then
  begin
    FResponse.SetContentText('The question cannot be answered, return object not found.' + sLineBreak +
      'Return: ' + LResponse.Content);
    Exit;
  end;

  LJsonValueChoices := TJSONObject(LJsonValueAll).GetValue('choices');
  if not(LJsonValueChoices is TJSONArray) then
  begin
    FResponse.SetContentText('The question cannot be answered, choices not found.' + sLineBreak +
      'Return: ' + LResponse.Content);
    Exit;
  end;

  LJsonArrayChoices := LJsonValueChoices as TJSONArray;
  for LItemChoices := 0 to Pred(LJsonArrayChoices.Count) do
  begin
    if not(LJsonArrayChoices.Items[LItemChoices] is TJSONObject) then
      Continue;

    //CAST ITEM CHOICES LIKE TJSONObject
    LJsonObjChoices := LJsonArrayChoices.Items[LItemChoices] as TJSONObject;

    //GET MESSAGE LIKE TJSONValue
    LJsonValueMessage := LJsonObjChoices.GetValue('message');
    if not(LJsonValueMessage is TJSONObject) then
      Continue;

    //GET MESSAGE LIKE TJSONObject
    LJsonObjMessage := LJsonValueMessage as TJSONObject;
    LResult := LResult + TJSONString(LJsonObjMessage.GetValue('content')).Value.Trim + sLineBreak;
  end;

  FResponse.SetContentText(LResult.Trim);
end;

end.
