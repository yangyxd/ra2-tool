object FRa2Tool: TFRa2Tool
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32418#33394#35686#25106'2'#12289#23588#37324#30340#22797#20167' '#20462#25913#22120
  ClientHeight = 130
  ClientWidth = 362
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  StyleElements = [seClient, seBorder]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 160
    Height = 14
    Caption = 'F10'#9#36873#20013#37096#38431#30452#25509#21319#32423#19977#26143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Label4: TLabel
    Left = 8
    Top = 68
    Width = 160
    Height = 14
    Caption = 'F11'#9#24369#21270#36873#20013#37096#38431#65288#38477#34880#65289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Label5: TLabel
    Left = 8
    Top = 88
    Width = 223
    Height = 14
    Caption = 'F12'#9#24378#21270#36873#20013#37096#38431#65288#34880#37327#21464#20026' 65500'#65289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Label6: TLabel
    Left = 0
    Top = 116
    Width = 362
    Height = 14
    Align = alBottom
    Alignment = taCenter
    Caption = 'yangyxd@126.com  '#26412#31243#24207#20165#20379#23398#20064#30740#31350#25152#29992
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMedGray
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
    ExplicitTop = 156
    ExplicitWidth = 244
  end
  object Label7: TLabel
    Left = 248
    Top = 48
    Width = 36
    Height = 14
    Caption = #37329#38065#65306
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lbMoney: TLabel
    Left = 285
    Top = 50
    Width = 7
    Height = 14
    Caption = '0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Label8: TLabel
    Left = 248
    Top = 68
    Width = 36
    Height = 14
    Caption = #30005#21147#65306
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lbDL: TLabel
    Left = 285
    Top = 70
    Width = 7
    Height = 14
    Caption = '0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Label10: TLabel
    Left = 248
    Top = 88
    Width = 36
    Height = 14
    Caption = #36127#36733#65306
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object lbDLFZ: TLabel
    Left = 285
    Top = 90
    Width = 7
    Height = 14
    Caption = '0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clSkyBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 145
    Height = 25
    Caption = 'F9    '#37329#38065'500000'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 160
    Top = 9
    Width = 145
    Height = 22
    Hint = #28216#25103#31867#22411
    Style = csDropDownList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TabStop = False
    TextHint = #36873#25321#28216#25103#31867#22411
    OnClick = ComboBox1Click
  end
end
