unit DelphiAIDev.AI.Request.Chat;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Classes,
  RESTRequest4D,
  DelphiAIDev.Types,
  DelphiAIDev.Consts,
  DelphiAIDev.Settings,
  DelphiAIDev.AI.Interfaces;

type
  TDelphiAIDevAIRequestChat = class
  private
    FSettings: TDelphiAIDevSettings;
    function GetRequestBody(const AIMessages: array of TAIMessage): string;
    function ParseSSEToText(const AContent: string): string;
  public
    constructor Create(const ASettings: TDelphiAIDevSettings);
    procedure SendRequest(const AIMessages: array of TAIMessage; AResponse: IDelphiAIDevAIResponse);
  end;

implementation

constructor TDelphiAIDevAIRequestChat.Create(const ASettings: TDelphiAIDevSettings);
begin
  FSettings := ASettings;
end;

procedure TDelphiAIDevAIRequestChat.SendRequest(const AIMessages: array of TAIMessage; AResponse: IDelphiAIDevAIResponse);
var
  LResponse: IResponse;
  LJsonValueAll, LJsonValueChoices, LJsonValueMessage, LJsonValueText: TJSONValue;
  LJsonArrayChoices: TJSONArray;
  LJsonObjChoices, LJsonObjMessage: TJSONObject;
  LItemChoices: Integer;
  LResult: string;
begin
  var body := GetRequestBody(AIMessages);
  LResponse := TRequest.New
    .BaseURL(FSettings.BaseUrlAIChat)
    .ContentType(TConsts.APPLICATION_JSON)
    .Accept(TConsts.APPLICATION_JSON)
    .TokenBearer(FSettings.ApiKeyAIChat)
    .AddBody(body)
    .Post;

  AResponse.SetStatusCode(LResponse.StatusCode);

  if LResponse.StatusCode <> 200 then
  begin
    AResponse.SetContentText('Question cannot be answered' + sLineBreak + 'Return: ' + LResponse.Content);
    Exit;
  end;

  // --- streaming support (SSE) ---
  if (LResponse.Content.StartsWith('data:')) or
     (LResponse.Content.IndexOf('chat.completion.chunk') >= 0) then
  begin
    LResult := ParseSSEToText(LResponse.Content);
    if LResult <> '' then
      AResponse.SetContentText(LResult)
    else
      AResponse.SetContentText('The question cannot be answered, empty SSE stream.');
    Exit;
  end;

  // --- plain (non-streaming) JSON ---
  LJsonValueAll := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse.Content), 0);
  try
    if not (LJsonValueAll is TJSONObject) then
    begin
      AResponse.SetContentText('The question cannot be answered, return object not found.' + sLineBreak +
        'Return: ' + LResponse.Content);
      Exit;
    end;

    LJsonValueChoices := TJSONObject(LJsonValueAll).GetValue('choices');
    if not (LJsonValueChoices is TJSONArray) then
    begin
      AResponse.SetContentText('The question cannot be answered, choices not found.' + sLineBreak +
        'Return: ' + LResponse.Content);
      Exit;
    end;

    LJsonArrayChoices := TJSONArray(LJsonValueChoices);
    for LItemChoices := 0 to Pred(LJsonArrayChoices.Count) do
      if LJsonArrayChoices.Items[LItemChoices] is TJSONObject then
      begin
        LJsonObjChoices := TJSONObject(LJsonArrayChoices.Items[LItemChoices]);

        // chat/completions -> choices[].message.content
        LJsonValueMessage := LJsonObjChoices.GetValue('message');
        if (LJsonValueMessage is TJSONObject) then
        begin
          LJsonObjMessage := TJSONObject(LJsonValueMessage);
          if LJsonObjMessage.GetValue('content') is TJSONString then
            LResult := LResult + TJSONString(LJsonObjMessage.GetValue('content')).Value.Trim + sLineBreak;
          Continue;
        end;

        // completions -> choices[].text
        LJsonValueText := LJsonObjChoices.GetValue('text');
        if LJsonValueText is TJSONString then
          LResult := LResult + TJSONString(LJsonValueText).Value.Trim + sLineBreak;
      end;
  finally
    LJsonValueAll.Free;
  end;

  AResponse.SetContentText(LResult.Trim);
end;

// '{"model": "%s", "messages": [{"role": "user", "content": "%s"}], "stream": false, "max_tokens": 2048}'
function TDelphiAIDevAIRequestChat.GetRequestBody(const AIMessages: array of TAIMessage): string;
begin
  result := '{}';
  var Body := TJSONObject.Create;
  try
    // model type
    if FSettings.ModelAIChat.Trim <> '' then
      Body.AddPair('model', FSettings.ModelAIChat);

    // stream
    // Body.AddPair('stream', TJSONBool.Create(False));

    // array of messages
    var jArr := TJSONArray.Create;
    for var m in AIMessages do begin
      var jMsg := TJSONObject.Create;
      jMsg.AddPair('role', m.Role);
      jMsg.AddPair('content', m.Content);
      jArr.AddElement(jMsg);
    end;
    Body.AddPair('messages', jArr);

    // convert to string json
    result := Body.ToJSON
  finally
    Body.Free;
  end;
end;

function TDelphiAIDevAIRequestChat.ParseSSEToText(const AContent: string): string;
var
  Lines: TArray<string>;
  Line, JsonText: string;
  V, ChoicesVal, DeltaVal, MsgVal, TextVal: TJSONValue;
  O, ChoiceObj, DeltaObj, MsgObj: TJSONObject;
  Choices: TJSONArray;
begin
  Result := '';
  Lines := AContent.Replace(#13, '').Split([#10]);

  for Line in Lines do
  begin
    if not Line.StartsWith('data: ') then
      Continue;

    JsonText := Trim(Copy(Line, 7, MaxInt));
    if (JsonText = '') or (SameText(JsonText, '[DONE]')) then
      Continue;

    V := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonText), 0);
    try
      if not (V is TJSONObject) then
        Continue;

      O := TJSONObject(V);
      ChoicesVal := O.GetValue('choices');
      if not (ChoicesVal is TJSONArray) then
        Continue;

      Choices := TJSONArray(ChoicesVal);
      if (Choices.Count = 0) or not (Choices.Items[0] is TJSONObject) then
        Continue;

      ChoiceObj := TJSONObject(Choices.Items[0]);

      // chat/completions -> delta.content
      DeltaVal := ChoiceObj.GetValue('delta');
      if (DeltaVal is TJSONObject) then
      begin
        DeltaObj := TJSONObject(DeltaVal);
        if DeltaObj.GetValue('content') is TJSONString then
          Result := Result + TJSONString(DeltaObj.GetValue('content')).Value;
        Continue;
      end;

      // sometimes message.content
      MsgVal := ChoiceObj.GetValue('message');
      if (MsgVal is TJSONObject) then
      begin
        MsgObj := TJSONObject(MsgVal);
        if MsgObj.GetValue('content') is TJSONString then
          Result := Result + TJSONString(MsgObj.GetValue('content')).Value;
        Continue;
      end;

      // completions -> text
      TextVal := ChoiceObj.GetValue('text');
      if TextVal is TJSONString then
        Result := Result + TJSONString(TextVal).Value;
    finally
      V.Free;
    end;
  end;

  Result := Result.Trim;
end;

end.
