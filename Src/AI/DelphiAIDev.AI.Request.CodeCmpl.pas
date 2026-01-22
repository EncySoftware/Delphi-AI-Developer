unit DelphiAIDev.AI.Request.CodeCmpl;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Classes,
  RESTRequest4D,
  DelphiAIDev.Utils,
  DelphiAIDev.Types,
  DelphiAIDev.Consts,
  DelphiAIDev.Settings,
  DelphiAIDev.AI.Response;

type
  TDelphiAIDevAIRequestCodeCmpl = class
  private
    FSettings: TDelphiAIDevSettings;
    FResponse: IDelphiAIDevAIResponse;
    function GetRequestBody(const APrefix, ASuffix: string): string;
    function GetResponseText(const AJsonResponse: string): string;
  public
    constructor Create;

    property Response: IDelphiAIDevAIResponse read FResponse;
    procedure SendRequest(const APrefix, ASuffix: string);
  end;

implementation

constructor TDelphiAIDevAIRequestCodeCmpl.Create();
begin
  FSettings := TDelphiAIDevSettings.GetInstance;;
  FResponse := TDelphiAIDevAIResponse.New;
end;

procedure TDelphiAIDevAIRequestCodeCmpl.SendRequest(const APrefix, ASuffix: string);
var
  LResponse: IResponse;
  LResult, LPrefix, LSuffix, RBody: string;
begin
  LPrefix := TUtils.AdjustQuestionToJson(APrefix);
  LSuffix := TUtils.AdjustQuestionToJson(ASuffix);
  RBody := GetRequestBody(LPrefix, LSuffix);

  LResponse := TRequest.New
    .BaseURL(FSettings.BaseUrlCodeCmpl)
    .ContentType(TConsts.APPLICATION_JSON)
    .Accept(TConsts.APPLICATION_JSON)
    .TokenBearer(FSettings.ApiKeyCodeCmpl)
    .AddBody(RBody)
    .Post;

  FResponse.SetStatusCode(LResponse.StatusCode);

  if LResponse.StatusCode <> 200 then
  begin
    FResponse.SetContentText('Question cannot be answered' + sLineBreak + 'Return: ' + LResponse.Content);
    Exit;
  end;

  LResult := GetResponseText(LResponse.Content).Trim;
  FResponse.SetContentText(LResult);
end;

// {"language": "pascal", "segments": {"prefix": "code before cursor","suffix": "code after cursor"}}
function TDelphiAIDevAIRequestCodeCmpl.GetRequestBody(const APrefix, ASuffix: string): string;
begin
  result := '{}';
  var JBody := TJSONObject.Create;
  try
    // set language
    JBody.AddPair('language', '');

    // add prefix and suffix to the segments object
    var SegmentsObj := TJSONObject.Create;
    SegmentsObj.AddPair('prefix', APrefix);
    SegmentsObj.AddPair('suffix', ASuffix);

    // add segments to the main object
    JBody.AddPair('segments', SegmentsObj);

    result := JBody.ToJSON;
  finally
    JBody.Free;
  end;
end;

// {"id":"cmpl-d92752e0-d328-4511-8359-6e1717f2a859","choices":[{"index":0,"text":"\\n"}],"mode":"standard"}
function TDelphiAIDevAIRequestCodeCmpl.GetResponseText(const AJsonResponse: string): string;
begin
  result := '';
  var JSONRoot := TJSONObject.ParseJSONValue(AJsonResponse) as TJSONObject;
  if not Assigned(JSONRoot) then
    Exit;
  try
    // get choices
    var Choices := JSONRoot.GetValue('choices') as TJSONArray;
    if not Assigned(Choices) or (Choices.Count = 0) then
      Exit;

    // get first choice
    var Choice := Choices.Items[0] as TJSONObject;
    if not Assigned(Choice) then
      Exit;

    // get text data
    var TextValue := Choice.GetValue('text');
    if Assigned(TextValue) then
      result := TextValue.Value;
  finally
    JSONRoot.Free;
  end;
end;

end.
