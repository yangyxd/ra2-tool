VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00808080&
   BorderStyle     =   0  'None
   Caption         =   "����ĸ����Ǯ�޸���"
   ClientHeight    =   2490
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4530
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2490
   ScaleWidth      =   4530
   StartUpPosition =   2  '��Ļ����
   Begin ����1.MyButton MyButton1 
      Height          =   240
      Left            =   4200
      TabIndex        =   5
      Top             =   80
      Width           =   240
      _ExtentX        =   423
      _ExtentY        =   423
      Icon            =   "Form1.frx":1272
      Style           =   4
      Caption         =   " "
      IconSize        =   18
      iNonThemeStyle  =   0
      USeCustomColors =   -1  'True
      BackColor       =   8421504
      IconColor       =   8421504
      HighlightColor  =   8421504
      FontColor       =   8421504
      FontHighlightColor=   8421504
      Tooltiptitle    =   ""
      ToolTipIcon     =   0
      ToolTipType     =   0
      ttForeColor     =   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      MaskColor       =   8421504
      IconOffset      =   0
      UseFontColor    =   -1  'True
      RoundedBordersByTheme=   0   'False
   End
   Begin VB.Timer Timer2 
      Interval        =   15
      Left            =   3780
      Tag             =   "�ȼ�"
      Top             =   1260
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   1995
      Left            =   90
      ScaleHeight     =   1995
      ScaleWidth      =   4335
      TabIndex        =   0
      Top             =   405
      Width           =   4335
      Begin VB.CheckBox Check1 
         BackColor       =   &H80000007&
         Caption         =   "ǿ������"
         ForeColor       =   &H00FFFFFF&
         Height          =   345
         Left            =   3060
         TabIndex        =   10
         Top             =   270
         Width           =   1095
      End
      Begin ����1.MyButton Command1 
         Height          =   330
         Left            =   135
         TabIndex        =   6
         Top             =   135
         Width           =   1770
         _ExtentX        =   3122
         _ExtentY        =   582
         Style           =   8
         Caption         =   "��Ǯ 500000 (F9)"
         BackColor       =   0
         IconColor       =   0
         HighlightColor  =   0
         FontColor       =   192
         FontHighlightColor=   255
         Tooltiptitle    =   ""
         ToolTipIcon     =   0
         ToolTipType     =   1
         ttForeColor     =   0
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "����"
            Size            =   9
            Charset         =   134
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         MaskColor       =   0
         IconOffset      =   4
         UseFontColor    =   -1  'True
         RoundedBordersByTheme=   0   'False
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "F10 : ѡ�в���ֱ����Ϊ����"
         ForeColor       =   &H00FFC0FF&
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   9
         Top             =   1035
         Width           =   2340
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "F11 : ����ѡ�в��ӣ���Ѫ��"
         ForeColor       =   &H00FFC0FF&
         Height          =   180
         Index           =   5
         Left            =   180
         TabIndex        =   8
         Top             =   1260
         Width           =   2340
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "F12 : ǿ��ѡ�в��ӣ�Ѫ����Ϊ 65500��"
         ForeColor       =   &H00FFC0FF&
         Height          =   180
         Index           =   4
         Left            =   180
         TabIndex        =   7
         Top             =   1485
         Width           =   3240
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "F5  : ָ��˲�Ƶ�Ŀ����ն���"
         ForeColor       =   &H00FFC0FF&
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   4
         Top             =   585
         Width           =   2520
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "F8  : ˲��ѡ�в��ӵ�ָ������"
         ForeColor       =   &H00FFC0FF&
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   3
         Top             =   810
         Width           =   2520
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "��ѩ������ ��Ȩ���� mail:yangyxd@126.com"
         ForeColor       =   &H0000FFFF&
         Height          =   180
         Left            =   135
         TabIndex        =   1
         Top             =   1755
         Width           =   3600
      End
   End
   Begin VB.Image Image1 
      Height          =   255
      Left            =   90
      Picture         =   "Form1.frx":180C
      Stretch         =   -1  'True
      Top             =   45
      Width           =   255
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "��ɫ����2������ĸ��� ��Ǯ�޸���"
      BeginProperty Font 
         Name            =   "����_GB2312"
         Size            =   10.5
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   210
      Left            =   360
      TabIndex        =   2
      Top             =   90
      Width           =   3615
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim pid As Long '��¼��Ϸ����
Dim game As Integer  '��ǰ�ҵ�����Ϸ�����Ǻ쾯2ʱΪ0, ����ĸ���ʱΪ1, ���°�ʱΪ2

Private Const GAME_RA2_CLASSNAME = "Red Alert 2"      '��ɫ����2
Private Const GAME_YURI_CLASSNAME = "Yuri's Revenge"  '����ĸ���

'����ĸ����ַ��ƫ��
Private Const Money_BuffAdders = &HA82CB4 'Ǯ��ַ
Private Const Money_Excursion = &H30C  '��Ǯƫ��
Private Const SEL_BASE = &HA8DC24  '��һ��ѡ�ж����ַ
Private Const SEL_DJ = &H150    '��3��ƫ��

'����ĸ����ַ��ƫ�� ����������
Private Const Money_BuffAdders2 = &HA83D4C 'Ǯ��ַ
Private Const SEL_BASE2 = &HA8ECBC  '��һ��ѡ�ж����ַ

'��ɫ����2��ַ��ƫ��
Private Const Money_BuffAdders_Ra2 = &HA35DB4 'Ǯ��ַ
Private Const Money_Excursion_Ra2 = &H24C  '��Ǯƫ��
Private Const SEL_BASE_Ra2 = &HA40C64  '��һ��ѡ�ж����ַ
Private Const SEL_DJ_Ra2 = &H11C    '��3��ƫ��
'&HA40C70 ��ǰѡ�еĶ������


Dim cx As Long, cy As Long



Private Sub GetGamePID()
  pid = GetWMpid(GAME_RA2_CLASSNAME)
  If pid = 0 Then
    pid = GetWMpid(GAME_YURI_CLASSNAME)
    game = 1
  Else
    game = 0
  End If
End Sub

Private Sub Command1_Click()
  '�����û�д���Ϸ
  GetGamePID
  If pid = 0 Then
    MsgBox "��Ϸû�����У�", 48, "����"
    Exit Sub
  End If
  '�޸��ڴ�����
  Call SetGameData
  cx = 0
  cy = 0
End Sub

Private Sub Form_Initialize()
  'InitCommonControls
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
 If Button = 1 Then MoveForm (Me.hwnd)
End Sub

Private Sub SetGameData()
  Dim B() As Byte

  If pid <= 0 Then Exit Sub
  ReDim B(3)

      B(3) = &H0
      B(2) = &H7
      B(1) = &HA1
      B(0) = &H20
      If game = 0 Then
        SetData pid, (GetData(pid, Money_BuffAdders_Ra2, 4) + Money_Excursion_Ra2), B, 4
      Else
        If (GetData(pid, Money_BuffAdders, 4) < &H10000000) And (Check1.value = 0) Then
            SetData pid, (GetData(pid, Money_BuffAdders, 4) + Money_Excursion), B, 4
        Else
            SetData pid, (GetData(pid, Money_BuffAdders2, 4) + Money_Excursion), B, 4
        End If
      End If

End Sub

Private Sub Form_Load()
  game = 0
  GetGamePID
  cx = 0
  cy = 0
End Sub

Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  If Button = 1 Then MoveForm (Me.hwnd)
End Sub

Private Sub Timer1_Timer()
  If pid <= 0 Then Exit Sub
  Call SetGameData
End Sub

Private Sub MyButton1_Click()
    Unload Me
End Sub

Private Sub Timer2_Timer()
  Static i As Byte
  If Myhotkey(vbKeyF12) Then
     If i = 1 Then Exit Sub
     i = 1
     Call AmdHP(0)
  ElseIf Myhotkey(vbKeyF11) Then
     If i = 2 Then Exit Sub
     i = 2
     Call AmdHP(1)
  ElseIf Myhotkey(vbKeyF10) Then
     If i = 3 Then Exit Sub
     i = 3
     Call AmdHP(2)
  ElseIf Myhotkey(vbKeyF9) Then
     If i = 4 Then Exit Sub
     i = 4
     If pid = 0 Then
        GetGamePID
     End If
     If pid = 0 Then Exit Sub
     Call Command1_Click
  ElseIf Myhotkey(vbKeyF5) Then
     If i = 5 Then Exit Sub
     i = 5
     If pid = 0 Then
        GetGamePID
     End If
     Call AmdSY(1)
  ElseIf Myhotkey(vbKeyF8) Then
     If i = 6 Then Exit Sub
     i = 6
     If pid = 0 Then
        GetGamePID
     End If
     Call AmdSY(2)
  Else
     i = 0
  End If
End Sub

Private Sub AmdSY(m As Byte)
  Dim tAddr As Long, tmp As Long, oldtmp As Long
  Dim i As Integer
  
  If pid <= 0 Then Exit Sub
  '�õ�ѡ�ж����ַ
  If game = 0 Then
    tAddr = GetData(pid, SEL_BASE_Ra2)
  Else
    tAddr = GetData(pid, SEL_BASE)
  End If
  If tAddr = 0 Then Exit Sub
  
  If m = 1 Then
    '����Ŀ��
    cx = 0
    cy = 0
    tAddr = GetData(pid, tAddr)
    cx = GetData(pid, tAddr + &H9C)
    cy = GetData(pid, tAddr + &HA0)
  Else
    '�ƶ�Ŀ��
    If cx = 0 Or cy = 0 Then Exit Sub
    oldtmp = 0
    
    For i = 0 To 80
      tmp = GetData(pid, tAddr + i * 4)
      If tmp = 0 Or tmp = oldtmp Then Exit Sub
      oldtmp = tmp
      
      
      SetData2 pid, tmp + &H9C, cx
      SetData2 pid, tmp + &HA0, cy
      SetData2 pid, tmp + &H254, cx
      SetData2 pid, tmp + &H258, cy
      cx = cx + 200
      'If m = 1 Then Exit For
    Next
    
  End If

End Sub

Private Sub AmdHP(m As Byte)
  Dim B(3) As Byte
  Dim tAddr As Long, tmp As Long, oldtmp As Long
  Dim i As Integer
  
  If pid <= 0 Then Exit Sub
  
  '�õ�ѡ�ж����ַ
  If game = 0 Then
    tAddr = GetData(pid, SEL_BASE_Ra2)
  Else
    tAddr = GetData(pid, SEL_BASE)
    If tAddr = -1 Then tAddr = GetData(pid, SEL_BASE2)
  End If
  If tAddr = 0 Then Exit Sub
  
  If m = 0 Then  '��Ѫ
  
    B(3) = &H0
    B(2) = &H0
    B(1) = &HFF
    B(0) = &HDC
  
  ElseIf m = 1 Then '��Ѫ
  
    B(3) = &H0
    B(2) = &H0
    B(1) = &H0
    B(0) = &HA
  
  ElseIf m = 2 Then '������
    
    B(3) = &H40
    B(2) = &H0
    B(1) = &H0
    B(0) = &H0
    
  End If
  
  oldtmp = 0
  
  For i = 0 To 80
    tmp = GetData(pid, tAddr + i * 4)
    If tmp = 0 Or tmp = oldtmp Then Exit Sub
    oldtmp = tmp
    If m = 2 Then
      If game = 0 Then
        SetData pid, tmp + SEL_DJ_Ra2, B, 4
      Else
        SetData pid, tmp + SEL_DJ, B, 4
      End If
    Else
      SetData pid, tmp + &H6C, B, 4
      SetData pid, tmp + &H70, B, 4
    End If
    'If m = 1 Then Exit For
  Next
End Sub
