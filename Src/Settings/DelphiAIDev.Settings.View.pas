unit DelphiAIDev.Settings.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.Menus,
  DelphiAIDev.Settings,
  DelphiAIDev.Types,
  DelphiAIDev.Consts;

type
  TDelphiAIDevSettingsView = class(TForm)
    pnBottom: TPanel;
    btnConfirm: TButton;
    btnClose: TButton;
    pnBackAll: TPanel;
    lbRestoreDefaults: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnMyControl: TPanel;
    pnMyControlButtons: TPanel;
    btnPreferences: TButton;
    btnIAsOnline: TButton;
    pnPreferencesBack: TPanel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    cBoxLanguageQuestions: TComboBox;
    TabSheet4: TTabSheet;
    pnCodeCompletionBack: TPanel;
    pnIAsOnLineBack: TPanel;
    BevelAIChat: TBevel;
    gBoxAIChat: TGroupBox;
    pnAIChat: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnApiKeyAIChat: TSpeedButton;
    edtBaseUrlAIChat: TEdit;
    edtApiKeyAIChat: TEdit;
    cBoxModelAIChat: TComboBox;
    pnBody: TPanel;
    btnCodeCompletion: TButton;
    Bevel5: TBevel;
    GroupBox3: TGroupBox;
    Panel2: TPanel;
    ckCodeCompletionUse: TCheckBox;
    ColorBoxCodeCompletionSuggestionColor: TColorBox;
    ckCodeCompletionSuggestionColorUse: TCheckBox;
    Label16: TLabel;
    gboxData: TGroupBox;
    btnOpenDataFolder: TButton;
    edtCodeCompletionShortcutInvoke: TEdit;
    Label18: TLabel;
    mmCodeCompletionDefaultPrompt: TMemo;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnApiKeyCodeCompl: TSpeedButton;
    editBaseUrlCodeCompl: TEdit;
    editApiKeyCodeCompl: TEdit;
    cBoxModelCodeCompl: TComboBox;
    GroupBox4: TGroupBox;
    Panel3: TPanel;
    ckColorHighlightCodeDelphiUse: TCheckBox;
    ColorBoxColorHighlightCodeDelphi: TColorBox;
    Label19: TLabel;
    mmDefaultPrompt: TMemo;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnApiKeyAIChatClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbRestoreDefaultsClick(Sender: TObject);
    procedure ckColorHighlightCodeDelphiUseClick(Sender: TObject);
    procedure btnPreferencesClick(Sender: TObject);
    procedure btnIAsOnlineClick(Sender: TObject);
    procedure btnCodeCompletionClick(Sender: TObject);
    procedure btnOpenDataFolderClick(Sender: TObject);
    procedure ckCodeCompletionSuggestionColorUseClick(Sender: TObject);
    procedure btnApiKeyCodeComplClick(Sender: TObject);
  private
    FSettings: TDelphiAIDevSettings;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure ConfigScreen;
    procedure ConfigFieldsColorHighlightDelphi;
    procedure FillcBoxLanguageQuestions;
    procedure ShowPanel(const AButton: TButton; const APanel: TPanel);
    procedure PanelsSetParent;
    procedure ValidateCodeCompletionShortcutInvoke;
    procedure ConfigFieldsCodeCompletionSuggestionColor;
  public

  end;

var
  DelphiAIDevSettingsView: TDelphiAIDevSettingsView;

implementation

uses
  DelphiAIDev.Utils,
  DelphiAIDev.Utils.OTA;

{$R *.dfm}

procedure TDelphiAIDevSettingsView.FormCreate(Sender: TObject);
begin
  TUtilsOTA.IDEThemingAll(TDelphiAIDevSettingsView, Self);
  FSettings := TDelphiAIDevSettings.GetInstance;

  Self.PanelsSetParent;
  Self.FillcBoxLanguageQuestions;
end;

procedure TDelphiAIDevSettingsView.FormShow(Sender: TObject);
begin
  FSettings.LoadData;
  Self.ConfigScreen;
  Self.LoadSettings;
end;

procedure TDelphiAIDevSettingsView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FSettings.LoadData;
end;

procedure TDelphiAIDevSettingsView.FillcBoxLanguageQuestions;
var
  LItem: TC4DLanguage;
begin
  cBoxLanguageQuestions.Items.Clear;
  for LItem := Low(TC4DLanguage) to High(TC4DLanguage) do
    cBoxLanguageQuestions.Items.Add(LItem.ToString);
end;

procedure TDelphiAIDevSettingsView.ConfigScreen;
var
  LColor: TColor;
begin
  LColor := TUtilsOTA.ActiveThemeColorLink;
end;

procedure TDelphiAIDevSettingsView.btnApiKeyAIChatClick(Sender: TObject);
begin
  TUtils.TogglePasswordChar(edtApiKeyAIChat);
end;

procedure TDelphiAIDevSettingsView.btnApiKeyCodeComplClick(Sender: TObject);
begin
  TUtils.TogglePasswordChar(editApiKeyCodeCompl);
end;

procedure TDelphiAIDevSettingsView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TDelphiAIDevSettingsView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F4:
      if ssAlt in Shift then
        Key := 0;
    VK_ESCAPE:
      if Shift = [] then
        btnClose.Click;
  end;
end;

procedure TDelphiAIDevSettingsView.lbRestoreDefaultsClick(Sender: TObject);
var
  LApiKeyAIChat: string;
  LApiKeyCodeCmpl: string;
begin
  LApiKeyAIChat := FSettings.ApiKeyAIChat;
  LApiKeyCodeCmpl := FSettings.ApiKeyCodeCmpl;
  FSettings.LoadDefaults;

  FSettings.ApiKeyAIChat := LApiKeyAIChat;
  FSettings.ApiKeyCodeCmpl := LApiKeyCodeCmpl;

  Self.LoadSettings;
end;

procedure TDelphiAIDevSettingsView.btnConfirmClick(Sender: TObject);
begin
  Self.ValidateCodeCompletionShortcutInvoke;

  Self.SaveSettings;
  Self.Close;
  Self.ModalResult := mrOk;
end;

procedure TDelphiAIDevSettingsView.ValidateCodeCompletionShortcutInvoke;
var
  LShortcutStr: string;
  LShortCut: TShortCut;
begin
  LShortcutStr := Trim(edtCodeCompletionShortcutInvoke.Text);
  if LShortcutStr.Length = 1 then
    raise Exception.Create('Invalid CodeCompletion shortcut');

  LShortCut := TextToShortCut(LShortcutStr);

  if ShortCutToText(LShortCut).Trim.IsEmpty then
    edtCodeCompletionShortcutInvoke.Text := TConsts.CODE_COMPLETION_SHORTCUT_INVOKE;
end;

procedure TDelphiAIDevSettingsView.ckCodeCompletionSuggestionColorUseClick(Sender: TObject);
begin
  Self.ConfigFieldsCodeCompletionSuggestionColor;
end;

procedure TDelphiAIDevSettingsView.ConfigFieldsCodeCompletionSuggestionColor;
begin
  ColorBoxCodeCompletionSuggestionColor.Enabled := ckCodeCompletionSuggestionColorUse.Checked;
end;

procedure TDelphiAIDevSettingsView.ckColorHighlightCodeDelphiUseClick(Sender: TObject);
begin
  Self.ConfigFieldsColorHighlightDelphi;
end;

procedure TDelphiAIDevSettingsView.ConfigFieldsColorHighlightDelphi;
begin
  ColorBoxColorHighlightCodeDelphi.Enabled := ckColorHighlightCodeDelphiUse.Checked;
end;

procedure TDelphiAIDevSettingsView.LoadSettings;
begin
  cBoxLanguageQuestions.ItemIndex := Integer(FSettings.LanguageQuestions);

  ckColorHighlightCodeDelphiUse.Checked := FSettings.ColorHighlightCodeDelphiUse;
  ColorBoxColorHighlightCodeDelphi.Selected := FSettings.ColorHighlightCodeDelphi;
  Self.ConfigFieldsColorHighlightDelphi;
  mmDefaultPrompt.Lines.Text := FSettings.DefaultPrompt;

  ckCodeCompletionUse.Checked := FSettings.CodeCompletionUse;
  ckCodeCompletionSuggestionColorUse.Checked := FSettings.CodeCompletionSuggestionColorUse;
  ColorBoxCodeCompletionSuggestionColor.Selected := FSettings.CodeCompletionSuggestionColor;
  edtCodeCompletionShortcutInvoke.Text := FSettings.CodeCompletionShortcutInvoke;
  mmCodeCompletionDefaultPrompt.Lines.Text := FSettings.CodeCompletionDefaultPrompt;

  edtBaseUrlAIChat.Text := FSettings.BaseUrlAIChat;
  cBoxModelAIChat.ItemIndex := cBoxModelAIChat.Items.IndexOf(FSettings.ModelAIChat);
  if cBoxModelAIChat.ItemIndex < 0 then
    cBoxModelAIChat.Text := FSettings.ModelAIChat;
  edtApiKeyAIChat.Text := FSettings.ApiKeyAIChat;

  editBaseUrlCodeCompl.Text := FSettings.BaseUrlCodeCmpl;
  cBoxModelCodeCompl.ItemIndex := cBoxModelCodeCompl.Items.IndexOf(FSettings.ModelCodeCmpl);
  if cBoxModelCodeCompl.ItemIndex < 0 then
    cBoxModelCodeCompl.Text := FSettings.ModelCodeCmpl;
  editApiKeyCodeCompl.Text := FSettings.ApiKeyCodeCmpl;
end;

procedure TDelphiAIDevSettingsView.SaveSettings;
begin
  FSettings.LanguageQuestions := TC4DLanguage(cBoxLanguageQuestions.ItemIndex);

  FSettings.ColorHighlightCodeDelphiUse := ckColorHighlightCodeDelphiUse.Checked;
  FSettings.ColorHighlightCodeDelphi := ColorBoxColorHighlightCodeDelphi.Selected;
  FSettings.DefaultPrompt := mmDefaultPrompt.Lines.Text;

  FSettings.CodeCompletionUse := ckCodeCompletionUse.Checked;
  FSettings.CodeCompletionSuggestionColorUse := ckCodeCompletionSuggestionColorUse.Checked;
  FSettings.CodeCompletionSuggestionColor := ColorBoxCodeCompletionSuggestionColor.Selected;
  FSettings.CodeCompletionShortcutInvoke := edtCodeCompletionShortcutInvoke.Text;
  FSettings.CodeCompletionDefaultPrompt := mmCodeCompletionDefaultPrompt.Lines.Text;

  FSettings.BaseUrlAIChat := edtBaseUrlAIChat.Text;
  FSettings.ModelAIChat := cBoxModelAIChat.Text;
  FSettings.ApiKeyAIChat := edtApiKeyAIChat.Text;

  FSettings.BaseUrlCodeCmpl := editBaseUrlCodeCompl.Text;
  FSettings.ModelCodeCmpl := cBoxModelCodeCompl.Text;
  FSettings.ApiKeyCodeCmpl := editApiKeyCodeCompl.Text;

  FSettings.SaveData;
end;

procedure TDelphiAIDevSettingsView.PanelsSetParent;
begin
  pnPreferencesBack.Visible := False;
  pnIAsOnLineBack.Visible := False;
  pnCodeCompletionBack.Visible := False;

  pnPreferencesBack.Parent := pnBody;
  pnIAsOnLineBack.Parent := pnBody;
  pnCodeCompletionBack.Parent := pnBody;
  PageControl1.Visible := False;

  btnPreferences.Click;
end;

procedure TDelphiAIDevSettingsView.btnPreferencesClick(Sender: TObject);
begin
  Self.ShowPanel(TButton(Sender), pnPreferencesBack);
end;

procedure TDelphiAIDevSettingsView.btnIAsOnlineClick(Sender: TObject);
begin
  Self.ShowPanel(TButton(Sender), pnIAsOnLineBack);
end;

procedure TDelphiAIDevSettingsView.btnOpenDataFolderClick(Sender: TObject);
var
  LPathFolder: string;
begin
  LPathFolder := TUtils.GetPathFolderRoot;
  if not DirectoryExists(LPathFolder) then
    TUtils.ShowMsg('Folder not found: ' + LPathFolder);

  TUtils.OpenFolder(LPathFolder);
end;

procedure TDelphiAIDevSettingsView.btnCodeCompletionClick(Sender: TObject);
begin
  Self.ShowPanel(TButton(Sender), pnCodeCompletionBack);
end;

procedure TDelphiAIDevSettingsView.ShowPanel(const AButton: TButton; const APanel: TPanel);
begin
  btnPreferences.Default := False;
  btnIAsOnline.Default := False;
  btnCodeCompletion.Default := False;
  AButton.Default := True;

  pnPreferencesBack.Visible := False;
  pnIAsOnLineBack.Visible := False;
  pnCodeCompletionBack.Visible := False;
  APanel.Visible := True;
end;

end.
