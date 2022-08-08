object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32418#33394#35686#25106'2'#12289#23588#37324#30340#22797#20167' '#20462#25913#22120
  ClientHeight = 170
  ClientWidth = 339
  Color = clWhite
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
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 160
    Height = 14
    Caption = 'F5'#9#25351#23450#30636#31227#30446#26631#21442#29031#23545#35937
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    StyleElements = [seClient, seBorder]
  end
  object Label2: TLabel
    Left = 8
    Top = 68
    Width = 172
    Height = 14
    Caption = 'F8 '#9#30636#31227#36873#20013#37096#38431#21040#25351#23450#22352#26631
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    StyleElements = [seClient, seBorder]
  end
  object Label3: TLabel
    Left = 8
    Top = 88
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
    Top = 108
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
    Top = 128
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
    Top = 156
    Width = 339
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
    ExplicitWidth = 244
  end
  object Label7: TLabel
    Left = 232
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
    Left = 269
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
    Left = 232
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
    Left = 269
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
    Left = 232
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
    Left = 269
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
    TabOrder = 1
    TextHint = #36873#25321#28216#25103#31867#22411
    OnClick = ComboBox1Click
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 312
    Top = 8
  end
end
