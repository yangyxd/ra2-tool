Attribute VB_Name = "Module2"
Option Explicit

'设置热键
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vkey As Long) As Integer

'查找窗体写内存等
Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Public Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Public Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Public Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Any, ByVal lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long
Public Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, lpBaseAddress As Any, lpBuffer As Any, ByVal nSize As Long, lpNumberOfBytesWritten As Long) As Long

Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Public Const STANDARD_RIGHTS_REQUIRED = &HF0000
Public Const SYNCHRONIZE = &H100000
Public Const SPECIFIC_RIGHTS_ALL = &HFFFF
Public Const STANDARD_RIGHTS_ALL = &H1F0000
Public Const PROCESS_ALL_ACCESS = &H1F0FFF ' STANDARD_RIGHTS_REQUIRED Or SYNCHRONIZE Or &HFFF
Public Const PROCESS_VM_OPERATION = &H8&
Public Const PROCESS_VM_READ = &H10&
Public Const PROCESS_VM_WRITE = &H20&

'其它
Public Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Declare Function SetActiveWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ShowWindowAsync Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
Declare Function SetFocusAPI& Lib "user32" Alias "SetFocus" (ByVal hwnd As Long)
Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As String) As Long
Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Public Const SW_RESTORE = 9
Public Const SW_HIDE = 0
Public Const SW_MAXIMIZE = 3
Public Const SW_MINIMIZE = 6
Public Const SW_SHOW = 5
Public Const SW_SHOWMAXIMIZED = 3
Public Const SW_SHOWMINIMIZED = 2
Public Const WM_LBUTTONDOWN = &H201
'模拟键盘和鼠标操作
Public Declare Sub mouse_event Lib "user32" (ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)
Public Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)
Public Const EM_GETPASSWORDCHAR = &HD2
Public Const MOUSEEVENTF_LEFTDOWN = &H2
Public Const MOUSEEVENTF_LEFTUP = &H4
Public Const MOUSEEVENTF_RIGHTDOWN = &H8
Public Const MOUSEEVENTF_RIGHTUP = &H10
Public Const MOUSEEVENTF_MOVE = &H1 '  mouse move
'兼容XP界面
Public Declare Sub InitCommonControls Lib "comctl32.dll" ()

Private Declare Function ReleaseCapture Lib "user32" () As Long
'权限提升
Private Declare Function GetCurrentProcess Lib "kernel32" () As Long
Private Declare Function LookupPrivilegeValue Lib "advapi32.dll" Alias "LookupPrivilegeValueA" (ByVal lpSystemName As String, ByVal lpName As String, lpLuid As LUID) As Long
Private Declare Function AdjustTokenPrivileges Lib "advapi32.dll" (ByVal TokenHandle As Long, ByVal DisableAllPrivileges As Long, NewState As TOKEN_PRIVILEGES, ByVal BufferLength As Long, PreviousState As TOKEN_PRIVILEGES, ReturnLength As Long) As Long
Private Declare Function OpenProcessToken Lib "advapi32.dll" (ByVal ProcessHandle As Long, ByVal DesiredAccess As Long, TokenHandle As Long) As Long

Private Const TOKEN_ASSIGN_PRIMARY = &H1
Private Const TOKEN_DUPLICATE = (&H2)
Private Const TOKEN_IMPERSONATE = (&H4)
Private Const TOKEN_QUERY = (&H8)
Private Const TOKEN_QUERY_SOURCE = (&H10)
Private Const TOKEN_ADJUST_PRIVILEGES = (&H20)
Private Const TOKEN_ADJUST_GROUPS = (&H40)
Private Const TOKEN_ADJUST_DEFAULT = (&H80)
Private Const TOKEN_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED Or TOKEN_ASSIGN_PRIMARY Or _
TOKEN_DUPLICATE Or TOKEN_IMPERSONATE Or TOKEN_QUERY Or TOKEN_QUERY_SOURCE Or _
TOKEN_ADJUST_PRIVILEGES Or TOKEN_ADJUST_GROUPS Or TOKEN_ADJUST_DEFAULT)
Private Const SE_PRIVILEGE_ENABLED = &H2
Private Const ANYSIZE_ARRAY = 1

Private Type LUID
  lowpart As Long
  highpart As Long
End Type

Private Type LUID_AND_ATTRIBUTES
  pLuid As LUID
  Attributes As Long
End Type

Private Type TOKEN_PRIVILEGES
  PrivilegeCount As Long
  Privileges(ANYSIZE_ARRAY) As LUID_AND_ATTRIBUTES
End Type



'提升权限为高
Public Function ToKen() As Boolean
    Dim hdlProcessHandle As Long
    Dim hdlTokenHandle As Long
    Dim tmpLuid As LUID
    Dim tkp As TOKEN_PRIVILEGES
    Dim tkpNewButIgnored As TOKEN_PRIVILEGES
    Dim lBufferNeeded As Long
    Dim lp As Long
    hdlProcessHandle = GetCurrentProcess()
    lp = OpenProcessToken(hdlProcessHandle, TOKEN_ALL_ACCESS, hdlTokenHandle)
    lp = LookupPrivilegeValue("", "SeDebugPrivilege", tmpLuid)
    tkp.PrivilegeCount = 1
    tkp.Privileges(0).pLuid = tmpLuid
    tkp.Privileges(0).Attributes = SE_PRIVILEGE_ENABLED
    lp = AdjustTokenPrivileges(hdlTokenHandle, False, tkp, Len(tkpNewButIgnored), tkpNewButIgnored, lBufferNeeded)
    ToKen = lp
End Function

'获取内存内容
Public Function GetData(ByVal lppid As Long, ByVal lpADDress As Long, Optional ByVal dtLen As Long = 4) As Long
    Dim pHandle As Long ' 储存进程句柄
    ' 使用进程标识符取得进程句柄
    pHandle = OpenProcess(PROCESS_ALL_ACCESS, False, lppid)
    ' 在内存地址中读取数据
    ReadProcessMemory pHandle, ByVal lpADDress, ByVal VarPtr(GetData), dtLen, 0&
    ' 关闭进程句柄
    CloseHandle pHandle
End Function

'获取内存内容字符串
Public Function GetDataStr(ByVal lppid As Long, ByVal lpADDress As Long, Optional ByVal dtLen As Long = 4) As String
    Dim pHandle As Long ' 储存进程句柄
    Dim tmp As Byte
    Dim i As Byte, t As String, B As Byte
    ' 使用进程标识符取得进程句柄
    pHandle = OpenProcess(PROCESS_ALL_ACCESS, False, lppid)
    ' 在内存地址中读取数据
    tmp = 0: GetDataStr = ""
    lpADDress = lpADDress - 1
    'ReadProcessMemory pHandle, ByVal (lpADDress), ByVal VarPtr(b), 2, 0&
    For i = 1 To dtLen
      lpADDress = lpADDress + 1
      ReadProcessMemory pHandle, ByVal (lpADDress), ByVal VarPtr(tmp), 1, 0&
      If B = 1 And tmp = 0 Then
        GoTo aaa
      Else
        If tmp = 0 Then B = 1 Else B = 0
      End If
      GetDataStr = GetDataStr & ChrB(tmp)
      t = GetDataStr
      If lstrlen(t) >= 18 Or B = 2 Then Exit For '如果读出的值为0表示字符串结束
    Next
aaa:
    ' 关闭进程句柄
    CloseHandle pHandle
End Function

'写入单精度浮点值过程 4字节浮点
Public Sub SetMemoryS(ByVal lppid As Long, Adderss As Long, NumVal As Single)
    Dim lBytesReadWrite As Long
    Dim pHandle As Long ' 储存进程句柄
    pHandle = OpenProcess(PROCESS_ALL_ACCESS, False, lppid)
    WriteProcessMemory pHandle, Adderss, NumVal, 4, 0&
    'ReadProcessMemory pHandle, ByVal (&H40E1958), ByVal NumVal, 4, 0&
    ' 关闭进程句柄
    CloseHandle pHandle
End Sub

'将修改内存
Public Function SetData(ByVal lppid As Long, ByVal lpDestAddr As Long, lpSrcAddr() As Byte, Optional ByVal dtLen As Long = 4) As Boolean
    On Error GoTo mErr
    Dim lBytesReadWrite As Long
    Dim pHandle As Long ' 储存进程句柄
    ' 使用进程标识符取得进程句柄
    pHandle = OpenProcess(PROCESS_ALL_ACCESS, False, lppid)
    WriteProcessMemory pHandle, ByVal lpDestAddr, ByVal VarPtr(lpSrcAddr(0)), dtLen, 0&
    ' 关闭进程句柄
    CloseHandle pHandle
    SetData = True
mErr:
End Function

'----------------------------
'将修改内存
'----------------------------
Public Function SetData2(ByVal lppid As Long, ByVal lpDestAddr As Long, value As Long, Optional ByVal dtLen As Long = 4) As Boolean
    On Error GoTo mErr
    Dim lBytesReadWrite As Long
    Dim pHandle As Long ' 储存进程句柄
    ' 使用进程标识符取得进程句柄
    pHandle = OpenProcess(PROCESS_ALL_ACCESS, False, lppid)
    WriteProcessMemory pHandle, ByVal lpDestAddr, ByVal VarPtr(value), dtLen, 0&
    ' 关闭进程句柄
    CloseHandle pHandle
    SetData2 = True
mErr:
End Function


' 取得进程标识符
Public Function GetPid(lpClassName As String, lpWindowName As String) As Long
    GetWindowThreadProcessId FindWindow(lpClassName, lpWindowName), GetPid
End Function

'设置热键
Public Function Myhotkey(vKeyCode) As Boolean
 Myhotkey = GetAsyncKeyState(vKeyCode)
End Function


'移动无标题栏窗体
Public Sub MoveForm(ByVal hwnd As Long)
 ReleaseCapture
 SendMessage hwnd, &HA1, 2, 0&
End Sub
