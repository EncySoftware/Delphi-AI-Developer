unit DelphiAIDev.Settings;

interface

uses
  System.SysUtils,
  System.Win.Registry,
  Winapi.Windows,
  Vcl.Graphics,
  DelphiAIDev.Types,
  DelphiAIDev.Consts,
  DelphiAIDev.Utils,
  DelphiAIDev.Utils.OTA;

type
  TDelphiAIDevSettings = class
  private const
    FIELD_LanguageQuestions = 'LanguageQuestions';
    FIELD_ColorHighlightCodeDelphiUse = 'ColorHighlightCodeDelphiUse';
    FIELD_ColorHighlightCodeDelphi = 'ColorHighlightCodeDelphi';
    FIELD_DefaultPrompt = 'DefaultPrompt';
    FIELD_CodeCompletionUse = 'CodeCompletionUse';
    FIELD_CodeCompletionSuggestionColorUse = 'CodeCompletionSuggestionColorUse';
    FIELD_CodeCompletionSuggestionColor = 'CodeCompletionSuggestionColor';
    FIELD_CodeCompletionShortcutInvoke = 'CodeCompletionShortcutInvoke';
    FIELD_CodeCompletionDefaultPrompt =  'CodeCompletionDefaultPrompt';
    FIELD_BaseUrlAIChat = 'BaseUrlAIChat';
    FIELD_ModelAIChat = 'ModelAIChat';
    FIELD_ApiKeyAIChat = 'ApiKeyAIChat';
    FIELD_BaseUrlCodeCmpl = 'BaseUrlCodeCmpl';
    FIELD_ModelCodeCmpl = 'ModelCodeCmpl';
    FIELD_ApiKeyCodeCmpl = 'ApiKeyCodeCmpl';
  private
    FLanguageQuestions: TC4DLanguage;
    FColorHighlightCodeDelphiUse: Boolean;
    FColorHighlightCodeDelphi: TColor;
    FDefaultPrompt: string;

    FCodeCompletionUse: Boolean;
    FCodeCompletionSuggestionColorUse: Boolean;
    FCodeCompletionSuggestionColor: TColor;
    FCodeCompletionShortcutInvoke: string;
    FCodeCompletionDefaultPrompt: string;

    FBaseUrlAIChat: string;
    FModelAIChat: string;
    FApiKeyAIChat: string;

    FBaseUrlCodeCmpl: string;
    FModelCodeCmpl: string;
    FApiKeyCodeCmpl: string;

    constructor Create;
  public
    class function GetInstance: TDelphiAIDevSettings;
    procedure LoadDefaults;
    procedure SaveData;
    procedure LoadData;
    procedure ValidateFillingAIChatOptions(const AShowMsg: TShowMsg = TShowMsg.Yes);
    procedure ValidateFillingAICodeComplOptions(const AShowMsg: TShowMsg = TShowMsg.Yes);

    property LanguageQuestions: TC4DLanguage read FLanguageQuestions write FLanguageQuestions;
    property ColorHighlightCodeDelphiUse: Boolean read FColorHighlightCodeDelphiUse write FColorHighlightCodeDelphiUse;
    property ColorHighlightCodeDelphi: TColor read FColorHighlightCodeDelphi write FColorHighlightCodeDelphi;
    property DefaultPrompt: string read FDefaultPrompt write FDefaultPrompt;

    property CodeCompletionUse: Boolean read FCodeCompletionUse write FCodeCompletionUse;
    property CodeCompletionSuggestionColorUse: Boolean read FCodeCompletionSuggestionColorUse write FCodeCompletionSuggestionColorUse;
    property CodeCompletionSuggestionColor: TColor read FCodeCompletionSuggestionColor write FCodeCompletionSuggestionColor;
    property CodeCompletionShortcutInvoke: string read FCodeCompletionShortcutInvoke write FCodeCompletionShortcutInvoke;
    property CodeCompletionDefaultPrompt: string read FCodeCompletionDefaultPrompt write FCodeCompletionDefaultPrompt;

    property BaseUrlAIChat: string read FBaseUrlAIChat write FBaseUrlAIChat;
    property ModelAIChat: string read FModelAIChat write FModelAIChat;
    property ApiKeyAIChat: string read FApiKeyAIChat write FApiKeyAIChat;

    property BaseUrlCodeCmpl: string read FBaseUrlCodeCmpl write FBaseUrlCodeCmpl;
    property ModelCodeCmpl: string read FModelCodeCmpl write FModelCodeCmpl;
    property ApiKeyCodeCmpl: string read FApiKeyCodeCmpl write FApiKeyCodeCmpl;
  end;

implementation

var
  Instance: TDelphiAIDevSettings;

class function TDelphiAIDevSettings.GetInstance: TDelphiAIDevSettings;
begin
  if not Assigned(Instance) then begin
    Instance := Self.Create;
    Instance.LoadData;
  end;
  Result := Instance;
end;

constructor TDelphiAIDevSettings.Create;
begin
  Self.LoadDefaults;
end;

procedure TDelphiAIDevSettings.LoadDefaults;
begin
  FLanguageQuestions := TC4DLanguage.ptBR;

  FColorHighlightCodeDelphiUse := False;
  FColorHighlightCodeDelphi := clNone;
  FDefaultPrompt := '';

  FCodeCompletionUse := True;
  FCodeCompletionSuggestionColorUse := False;
  FCodeCompletionSuggestionColor := TConsts.CODE_COMPLETION_SUGGESTION_COLOR;
  FCodeCompletionShortcutInvoke := TConsts.CODE_COMPLETION_SHORTCUT_INVOKE;
  FCodeCompletionDefaultPrompt := '';

  FBaseUrlAIChat := 'http://localhost';
  FModelAIChat := '';
  FApiKeyAIChat := '';

  FBaseUrlCodeCmpl := 'http://localhost';
  FModelCodeCmpl := '';
  FApiKeyCodeCmpl := '';
end;

procedure TDelphiAIDevSettings.SaveData;
var
  LReg: TRegistry;
begin
  LReg := TRegistry.Create;
  try
    LReg.CloseKey;
    LReg.RootKey := HKEY_CURRENT_USER;
    if not(LReg.OpenKey(TConsts.KEY_SETTINGS_IN_WINDOWS_REGISTRY, True))then
      raise Exception.Create('Unable to save settings to Windows registry');

    LReg.WriteInteger(FIELD_LanguageQuestions, Integer(FLanguageQuestions));

    LReg.WriteBool(FIELD_ColorHighlightCodeDelphiUse, FColorHighlightCodeDelphiUse);
    LReg.WriteString(FIELD_ColorHighlightCodeDelphi, ColorToString(FColorHighlightCodeDelphi));
    LReg.WriteString(FIELD_DefaultPrompt, FDefaultPrompt);

    LReg.WriteBool(FIELD_CodeCompletionUse, FCodeCompletionUse);
    LReg.WriteBool(FIELD_CodeCompletionSuggestionColorUse, FCodeCompletionSuggestionColorUse);
    LReg.WriteString(FIELD_CodeCompletionSuggestionColor, ColorToString(FCodeCompletionSuggestionColor));
    LReg.WriteString(FIELD_CodeCompletionShortcutInvoke, FCodeCompletionShortcutInvoke);
    LReg.WriteString(FIELD_CodeCompletionDefaultPrompt, FCodeCompletionDefaultPrompt);

    LReg.WriteString(FIELD_BaseUrlAIChat, FBaseUrlAIChat);
    LReg.WriteString(FIELD_ModelAIChat, FModelAIChat);
    LReg.WriteString(FIELD_ApiKeyAIChat, FApiKeyAIChat);

    LReg.WriteString(FIELD_BaseUrlCodeCmpl, FBaseUrlCodeCmpl);
    LReg.WriteString(FIELD_ModelCodeCmpl, FModelCodeCmpl);
    LReg.WriteString(FIELD_ApiKeyCodeCmpl, FApiKeyCodeCmpl);
  finally
    LReg.Free;
  end;
end;

procedure TDelphiAIDevSettings.LoadData;
var
  LReg: TRegistry;
begin
  Self.LoadDefaults;
  LReg := TRegistry.Create;
  try
    try
      LReg.CloseKey;
      LReg.RootKey := HKEY_CURRENT_USER;

      if not LReg.OpenKey(TConsts.KEY_SETTINGS_IN_WINDOWS_REGISTRY, False) then
        Exit;

      if LReg.ValueExists(FIELD_LanguageQuestions) then
        FLanguageQuestions := TC4DLanguage(LReg.ReadInteger(FIELD_LanguageQuestions));

      //COLOR FOR HIGHLIGHT CODE DELPHI/PASCAL
      if LReg.ValueExists(FIELD_ColorHighlightCodeDelphiUse) then
        FColorHighlightCodeDelphiUse := LReg.ReadBool(FIELD_ColorHighlightCodeDelphiUse);

      if LReg.ValueExists(FIELD_ColorHighlightCodeDelphi) then
        FColorHighlightCodeDelphi := TUtils.StringToColorDef(LReg.ReadString(FIELD_ColorHighlightCodeDelphi),
          TUtilsOTA.ActiveThemeForCode);

      if LReg.ValueExists(FIELD_DefaultPrompt) then
        FDefaultPrompt := LReg.ReadString(FIELD_DefaultPrompt);

      //Code Completion
      if LReg.ValueExists(FIELD_CodeCompletionUse) then
        FCodeCompletionUse := LReg.ReadBool(FIELD_CodeCompletionUse);

      if LReg.ValueExists(FIELD_CodeCompletionSuggestionColorUse) then
        FCodeCompletionSuggestionColorUse := LReg.ReadBool(FIELD_CodeCompletionSuggestionColorUse);

      if LReg.ValueExists(FIELD_CodeCompletionSuggestionColor) then
        FCodeCompletionSuggestionColor := TUtils.StringToColorDef(LReg.ReadString(FIELD_CodeCompletionSuggestionColor),
          TUtilsOTA.ActiveThemeForCode);

      if LReg.ValueExists(FIELD_CodeCompletionShortcutInvoke) then
        FCodeCompletionShortcutInvoke := LReg.ReadString(FIELD_CodeCompletionShortcutInvoke);

      if LReg.ValueExists(FIELD_CodeCompletionDefaultPrompt) then
        FCodeCompletionDefaultPrompt := LReg.ReadString(FIELD_CodeCompletionDefaultPrompt);

      if LReg.ValueExists(FIELD_BaseUrlCodeCmpl) then
        fBaseUrlCodeCmpl := LReg.ReadString(FIELD_BaseUrlCodeCmpl);

      if LReg.ValueExists(FIELD_ModelCodeCmpl) then
        fModelCodeCmpl := LReg.ReadString(FIELD_ModelCodeCmpl);

      if LReg.ValueExists(FIELD_ApiKeyCodeCmpl) then
        fApiKeyCodeCmpl := LReg.ReadString(FIELD_ApiKeyCodeCmpl);

      // AI Chat
      if LReg.ValueExists(FIELD_BaseUrlAIChat) then
        FBaseUrlAIChat := LReg.ReadString(FIELD_BaseUrlAIChat);

      if LReg.ValueExists(FIELD_ModelAIChat) then
        FModelAIChat := LReg.ReadString(FIELD_ModelAIChat);

      if LReg.ValueExists(FIELD_ApiKeyAIChat) then
        FApiKeyAIChat := LReg.ReadString(FIELD_ApiKeyAIChat);
    except
      Self.LoadDefaults;
    end;
  finally
    LReg.Free;
  end;
end;

procedure TDelphiAIDevSettings.ValidateFillingAIChatOptions(
  const AShowMsg: TShowMsg);
const
  MSG = '"%s" for IA %s not specified in settings.' + sLineBreak + sLineBreak +
    'Access menu > AI Developer > Settings';

  procedure ShowMsgInternal(const AArgs: array of const);//(const AMsg: string);
  begin
    if AShowMsg = TShowMsg.Yes then
      TUtils.ShowMsg(Format(MSG, AArgs));
    Abort;
  end;
begin
  if FBaseUrlAIChat.Trim.IsEmpty then
        ShowMsgInternal(['Base URL', 'AIChat']);

  if FModelAIChat.Trim.IsEmpty then
    ShowMsgInternal(['Model', 'AIChat']);

  if FApiKeyAIChat.Trim.IsEmpty then
    ShowMsgInternal(['API Key', 'AIChat']);
end;

procedure TDelphiAIDevSettings.ValidateFillingAICodeComplOptions(
  const AShowMsg: TShowMsg);
const
  MSG = '"%s" for IA %s not specified in settings.' + sLineBreak + sLineBreak +
    'Access menu > AI Developer > Settings';

  procedure ShowMsgInternal(const AArgs: array of const);//(const AMsg: string);
  begin
    if AShowMsg = TShowMsg.Yes then
      TUtils.ShowMsg(Format(MSG, AArgs));
    Abort;
  end;
begin
  if FBaseUrlCodeCmpl.Trim.IsEmpty then
    ShowMsgInternal(['Base URL', 'CodeCompletion']);

  if FModelCodeCmpl.Trim.IsEmpty then
    ShowMsgInternal(['Model', 'CodeCompletion']);

  if FApiKeyCodeCmpl.Trim.IsEmpty then
    ShowMsgInternal(['API Key', 'CodeCompletion']);
end;

initialization

finalization
  if Assigned(Instance) then
    FreeAndNil(Instance);

end.
