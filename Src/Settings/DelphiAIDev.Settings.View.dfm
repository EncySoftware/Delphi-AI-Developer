object DelphiAIDevSettingsView: TDelphiAIDevSettingsView
  Left = 0
  Top = 0
  Caption = 'Delphi AI Developer - Settings'
  ClientHeight = 676
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object pnBackAll: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 676
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 668
    ExplicitHeight = 668
    object pnBottom: TPanel
      Left = 0
      Top = 641
      Width = 670
      Height = 35
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alBottom
      BevelEdges = [beLeft, beRight, beBottom]
      BevelOuter = bvNone
      Padding.Top = 2
      Padding.Right = 2
      Padding.Bottom = 2
      ParentBackground = False
      TabOrder = 0
      ExplicitTop = 633
      ExplicitWidth = 668
      object lbRestoreDefaults: TLabel
        AlignWithMargins = True
        Left = 16
        Top = 7
        Width = 80
        Height = 21
        Cursor = crHandPoint
        Margins.Left = 16
        Margins.Top = 5
        Margins.Bottom = 5
        Align = alLeft
        Caption = 'Restore defaults'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Layout = tlCenter
        OnClick = lbRestoreDefaultsClick
        ExplicitHeight = 13
      end
      object btnConfirm: TButton
        AlignWithMargins = True
        Left = 442
        Top = 2
        Width = 110
        Height = 31
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'Confirm'
        TabOrder = 0
        OnClick = btnConfirmClick
        ExplicitLeft = 440
      end
      object btnClose: TButton
        AlignWithMargins = True
        Left = 555
        Top = 2
        Width = 110
        Height = 31
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = 'Close'
        TabOrder = 1
        OnClick = btnCloseClick
        ExplicitLeft = 553
      end
    end
    object pnMyControl: TPanel
      Left = 0
      Top = 0
      Width = 670
      Height = 641
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 668
      ExplicitHeight = 633
      object pnMyControlButtons: TPanel
        Left = 0
        Top = 0
        Width = 670
        Height = 30
        Align = alTop
        BevelEdges = [beBottom]
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 668
        object Bevel5: TBevel
          AlignWithMargins = True
          Left = 0
          Top = 26
          Width = 670
          Height = 1
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Align = alBottom
          Shape = bsTopLine
          ExplicitTop = 218
          ExplicitWidth = 632
        end
        object btnPreferences: TButton
          AlignWithMargins = True
          Left = 3
          Top = 2
          Width = 95
          Height = 23
          Cursor = crHandPoint
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'Preferences'
          TabOrder = 0
          OnClick = btnPreferencesClick
        end
        object btnIAsOnline: TButton
          AlignWithMargins = True
          Left = 101
          Top = 2
          Width = 95
          Height = 23
          Cursor = crHandPoint
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'AI Chat'
          TabOrder = 1
          OnClick = btnIAsOnlineClick
        end
        object btnCodeCompletion: TButton
          AlignWithMargins = True
          Left = 199
          Top = 2
          Width = 95
          Height = 23
          Cursor = crHandPoint
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'Code Completion'
          TabOrder = 2
          OnClick = btnCodeCompletionClick
        end
      end
      object pnBody: TPanel
        Left = 0
        Top = 30
        Width = 670
        Height = 611
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 668
        ExplicitHeight = 603
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 33
    Width = 667
    Height = 552
    ActivePage = TabSheet2
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Preferences'
      object pnPreferencesBack: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 653
        Height = 518
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object GroupBox2: TGroupBox
          Left = 0
          Top = 0
          Width = 653
          Height = 518
          Align = alClient
          Caption = ' Preferences '
          ParentBackground = False
          TabOrder = 0
          object Label4: TLabel
            Left = 21
            Top = 23
            Width = 133
            Height = 13
            Caption = 'Language used in questions'
          end
          object cBoxLanguageQuestions: TComboBox
            Left = 21
            Top = 38
            Width = 249
            Height = 21
            Hint = 'What is the standard language for questions?'
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object gboxData: TGroupBox
            Left = 2
            Top = 458
            Width = 649
            Height = 58
            Align = alBottom
            Caption = ' Data '
            Padding.Left = 2
            Padding.Top = 5
            Padding.Bottom = 3
            TabOrder = 1
            object btnOpenDataFolder: TButton
              Left = 4
              Top = 20
              Width = 122
              Height = 33
              Cursor = crHandPoint
              Align = alLeft
              Caption = 'Open Data Folder'
              TabOrder = 0
              OnClick = btnOpenDataFolderClick
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'AI Chat'
      ImageIndex = 1
      object pnIAsOnLineBack: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 653
        Height = 518
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object BevelAIChat: TBevel
          AlignWithMargins = True
          Left = 0
          Top = 113
          Width = 653
          Height = 1
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Align = alTop
          Shape = bsTopLine
          ExplicitTop = 218
          ExplicitWidth = 632
        end
        object gBoxAIChat: TGroupBox
          Left = 0
          Top = 0
          Width = 653
          Height = 113
          Align = alTop
          Caption = 'Connection'
          ParentBackground = False
          TabOrder = 0
          object pnAIChat: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 643
            Height = 90
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Label5: TLabel
              Left = 16
              Top = 5
              Width = 45
              Height = 13
              Caption = 'Base URL'
            end
            object Label6: TLabel
              Left = 16
              Top = 44
              Width = 37
              Height = 13
              Caption = 'API key'
            end
            object Label7: TLabel
              Left = 267
              Top = 5
              Width = 28
              Height = 13
              Caption = 'Model'
            end
            object btnApiKeyAIChat: TSpeedButton
              Left = 606
              Top = 59
              Width = 23
              Height = 22
              Cursor = crHandPoint
              Hint = 'Show/Hide API Key'
              Flat = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000120B0000120B00000000000000000000FF00FF4A667C
                BE9596FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FF6B9CC31E89E84B7AA3C89693FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4BB4FE51B5FF
                2089E94B7AA2C69592FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF51B7FE51B3FF1D87E64E7AA0CA9792FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                51B7FE4EB2FF1F89E64E7BA2B99497FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52B8FE4BB1FF2787D95F6A76FF
                00FFB0857FC09F94C09F96BC988EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FF55BDFFB5D6EDBF9D92BB9B8CE7DAC2FFFFE3FFFFE5FDFADAD8C3
                B3B58D85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCEA795FD
                EEBEFFFFD8FFFFDAFFFFDBFFFFE6FFFFFBEADDDCAE837FFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFC1A091FBDCA8FEF7D0FFFFDBFFFFE3FFFFF8FFFF
                FDFFFFFDC6A99CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC1A091FEE3ACF1
                C491FCF2CAFFFFDDFFFFE4FFFFF7FFFFF7FFFFE9EEE5CBB9948CFF00FFFF00FF
                FF00FFFF00FFFF00FFC2A191FFE6AEEEB581F7DCAEFEFDD8FFFFDFFFFFE3FFFF
                E4FFFFE0F3ECD2BB968EFF00FFFF00FFFF00FFFF00FFFF00FFBC978CFBE7B7F4
                C791F2C994F8E5B9FEFCD8FFFFDDFFFFDCFFFFE0E2D2BAB68E86FF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFD9C3A9FFFEE5F7DCB8F2C994F5D4A5FAE8BDFDF4
                C9FDFBD6B69089FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB58D85E8
                DEDDFFFEF2F9D8A3F4C48CF9D49FFDEAB8D0B49FB89086FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFAD827FC9AA9EEFE0B7EFDFB2E7CEACB890
                86B89086FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFBA968ABB988CB79188FF00FFFF00FFFF00FFFF00FF}
              ParentShowHint = False
              ShowHint = True
              OnClick = btnApiKeyAIChatClick
            end
            object edtBaseUrlAIChat: TEdit
              Left = 16
              Top = 20
              Width = 249
              Height = 21
              TabOrder = 0
            end
            object edtApiKeyAIChat: TEdit
              Left = 16
              Top = 60
              Width = 585
              Height = 21
              PasswordChar = '*'
              TabOrder = 2
            end
            object cBoxModelAIChat: TComboBox
              Left = 267
              Top = 20
              Width = 362
              Height = 21
              TabOrder = 1
              Items.Strings = (
                'DeepSeek-Coder-V2-Lite-instruct')
            end
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 117
          Width = 653
          Height = 401
          Align = alClient
          Caption = 'Options'
          ParentBackground = False
          TabOrder = 1
          object Panel3: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 643
            Height = 378
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Label19: TLabel
              Left = 16
              Top = 58
              Width = 72
              Height = 13
              Caption = 'Default Prompt'
            end
            object ckColorHighlightCodeDelphiUse: TCheckBox
              Left = 16
              Top = 3
              Width = 225
              Height = 17
              Caption = 'Color to highlight Delphi/Pascal code'
              TabOrder = 0
              OnClick = ckColorHighlightCodeDelphiUseClick
            end
            object ColorBoxColorHighlightCodeDelphi: TColorBox
              Left = 16
              Top = 23
              Width = 194
              Height = 22
              TabOrder = 1
            end
            object mmDefaultPrompt: TMemo
              Left = 16
              Top = 75
              Width = 617
              Height = 201
              ScrollBars = ssVertical
              TabOrder = 2
            end
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Code Completion'
      ImageIndex = 3
      object pnCodeCompletionBack: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 653
        Height = 518
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 0
        object Bevel1: TBevel
          AlignWithMargins = True
          Left = 0
          Top = 113
          Width = 653
          Height = 1
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Align = alTop
          Shape = bsTopLine
          ExplicitTop = 121
          ExplicitWidth = 659
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 117
          Width = 653
          Height = 401
          Align = alClient
          Caption = 'Options'
          ParentBackground = False
          TabOrder = 0
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 643
            Height = 378
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Label16: TLabel
              Left = 16
              Top = 85
              Width = 231
              Height = 13
              Caption = 'Shortcut for invoke (Delphi IDE restart required)'
            end
            object Label18: TLabel
              Left = 16
              Top = 134
              Width = 72
              Height = 13
              Caption = 'Default Prompt'
            end
            object ckCodeCompletionUse: TCheckBox
              Left = 16
              Top = 5
              Width = 131
              Height = 17
              Cursor = crHandPoint
              Caption = 'Use Code Completion'
              TabOrder = 0
            end
            object ColorBoxCodeCompletionSuggestionColor: TColorBox
              Left = 16
              Top = 49
              Width = 333
              Height = 22
              TabOrder = 1
            end
            object ckCodeCompletionSuggestionColorUse: TCheckBox
              Left = 16
              Top = 28
              Width = 131
              Height = 17
              Cursor = crHandPoint
              Caption = 'Suggestion Code Color'
              TabOrder = 2
              OnClick = ckCodeCompletionSuggestionColorUseClick
            end
            object edtCodeCompletionShortcutInvoke: TEdit
              Left = 16
              Top = 102
              Width = 333
              Height = 21
              TabOrder = 3
            end
            object mmCodeCompletionDefaultPrompt: TMemo
              Left = 16
              Top = 151
              Width = 617
              Height = 201
              ScrollBars = ssVertical
              TabOrder = 4
            end
          end
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 653
          Height = 113
          Align = alTop
          Caption = 'Connection'
          ParentBackground = False
          TabOrder = 1
          object Panel1: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 18
            Width = 643
            Height = 90
            Align = alClient
            BevelOuter = bvNone
            ParentBackground = False
            TabOrder = 0
            object Label1: TLabel
              Left = 16
              Top = 5
              Width = 45
              Height = 13
              Caption = 'Base URL'
            end
            object Label2: TLabel
              Left = 16
              Top = 44
              Width = 37
              Height = 13
              Caption = 'API key'
            end
            object Label3: TLabel
              Left = 267
              Top = 5
              Width = 28
              Height = 13
              Caption = 'Model'
            end
            object btnApiKeyCodeCompl: TSpeedButton
              Left = 606
              Top = 59
              Width = 23
              Height = 22
              Cursor = crHandPoint
              Hint = 'Show/Hide API Key'
              Flat = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000120B0000120B00000000000000000000FF00FF4A667C
                BE9596FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FF6B9CC31E89E84B7AA3C89693FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4BB4FE51B5FF
                2089E94B7AA2C69592FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF51B7FE51B3FF1D87E64E7AA0CA9792FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                51B7FE4EB2FF1F89E64E7BA2B99497FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52B8FE4BB1FF2787D95F6A76FF
                00FFB0857FC09F94C09F96BC988EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FF55BDFFB5D6EDBF9D92BB9B8CE7DAC2FFFFE3FFFFE5FDFADAD8C3
                B3B58D85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCEA795FD
                EEBEFFFFD8FFFFDAFFFFDBFFFFE6FFFFFBEADDDCAE837FFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFC1A091FBDCA8FEF7D0FFFFDBFFFFE3FFFFF8FFFF
                FDFFFFFDC6A99CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC1A091FEE3ACF1
                C491FCF2CAFFFFDDFFFFE4FFFFF7FFFFF7FFFFE9EEE5CBB9948CFF00FFFF00FF
                FF00FFFF00FFFF00FFC2A191FFE6AEEEB581F7DCAEFEFDD8FFFFDFFFFFE3FFFF
                E4FFFFE0F3ECD2BB968EFF00FFFF00FFFF00FFFF00FFFF00FFBC978CFBE7B7F4
                C791F2C994F8E5B9FEFCD8FFFFDDFFFFDCFFFFE0E2D2BAB68E86FF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFD9C3A9FFFEE5F7DCB8F2C994F5D4A5FAE8BDFDF4
                C9FDFBD6B69089FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB58D85E8
                DEDDFFFEF2F9D8A3F4C48CF9D49FFDEAB8D0B49FB89086FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFAD827FC9AA9EEFE0B7EFDFB2E7CEACB890
                86B89086FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFBA968ABB988CB79188FF00FFFF00FFFF00FFFF00FF}
              ParentShowHint = False
              ShowHint = True
              OnClick = btnApiKeyCodeComplClick
            end
            object editBaseUrlCodeCompl: TEdit
              Left = 16
              Top = 20
              Width = 249
              Height = 21
              TabOrder = 0
            end
            object editApiKeyCodeCompl: TEdit
              Left = 16
              Top = 60
              Width = 585
              Height = 21
              PasswordChar = '*'
              TabOrder = 2
            end
            object cBoxModelCodeCompl: TComboBox
              Left = 267
              Top = 20
              Width = 362
              Height = 21
              TabOrder = 1
              Items.Strings = (
                'DeepSeek-Coder-V2-Lite-base')
            end
          end
        end
      end
    end
  end
end
