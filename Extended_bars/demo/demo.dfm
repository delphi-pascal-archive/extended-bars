object Form1: TForm1
  Left = 220
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Extended bars Demo'
  ClientHeight = 346
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Potentio1: TPotentio
    Left = 8
    Top = 8
    Width = 329
    Height = 329
    ButtonColor = 3026478
    StickColor = clWhite
    BorderColor = 4934475
    StringsColor = clBlack
    VisiblePosition = False
    Pos = 0
  end
  object SelectBouton1: TSelectBouton
    Left = 336
    Top = 8
    Width = 345
    Height = 345
    ButtonColor = 3026478
    StickColor = clWhite
    BorderColor = 4934475
    StringsColor = clBlack
    Positions.Strings = (
      'Delphi'
      'FAQ'
      'Sources'
      'Articles'
      'Forum')
  end
  object TrackBarValue1: TTrackBarValue
    Left = 696
    Top = 8
    Width = 33
    Height = 337
    ColorBody = clOlive
    ColorText = clWhite
    ColorLines = clBlack
    ColorStick = clGreen
    ColorCentral = clWhite
    Min = 0
    Max = 100
    Pos = 100
    Frequency = 2
    OnChange = TrackBarValue1Change
  end
end
