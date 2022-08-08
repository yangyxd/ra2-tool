Attribute VB_Name = "Module1"
Option Explicit

'��ȡ��ָ�����ڹ�����һ���һ�����̺��̱߳�ʶ��
Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long

Private Type STARTUPINFO
        cb As Long
        lpReserved As String
        lpDesktop As String
        lpTitle As String
        dwX As Long
        dwY As Long
        dwXSize As Long
        dwYSize As Long
        dwXCountChars As Long
        dwYCountChars As Long
        dwFillAttribute As Long
        dwFlags As Long
        wShowWindow As Integer
        cbReserved2 As Integer
        lpReserved2 As Long
        hStdInput As Long
        hStdOutput As Long
        hStdError As Long
End Type

Private Declare Function Module32First Lib "KERNEL32" (ByVal hSnapShot As Long, lppe As MODULEENTRY32) As Long
Private Declare Function Module32Next Lib "KERNEL32" (ByVal hSnapShot As Long, lppe As MODULEENTRY32) As Long

Private Declare Function CreateToolhelpSnapshot Lib "KERNEL32" Alias "CreateToolhelp32Snapshot" (ByVal lFlags As Long, ByVal lProcessID As Long) As Long
Private Declare Function ProcessFirst Lib "KERNEL32" Alias "Process32First" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Private Declare Function ProcessNext Lib "KERNEL32" Alias "Process32Next" (ByVal hSnapShot As Long, uProcess As PROCESSENTRY32) As Long
Public Declare Function TerminateProcess Lib "KERNEL32" (ByVal hProcess As Long, ByVal uExitCode As Long) As Long
Public Declare Function OpenProcess Lib "KERNEL32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function CloseHandle Lib "KERNEL32" (ByVal hObject As Long) As Long

Private Declare Function GetCurrentProcess Lib "KERNEL32" () As Long
Private Declare Function OpenProcessToken Lib "advapi32.dll" (ByVal ProcessHandle As Long, ByVal DesiredAccess As Long, TokenHandle As Long) As Long
Private Declare Function LookupPrivilegeValue Lib "advapi32.dll" Alias "LookupPrivilegeValueA" (ByVal lpSystemName As String, ByVal lpName As String, lpLuid As LUID) As Long
Private Declare Function AdjustTokenPrivileges Lib "advapi32.dll" (ByVal TokenHandle As Long, ByVal DisableAllPrivileges As Long, NewState As TOKEN_PRIVILEGES, ByVal BufferLength As Long, PreviousState As TOKEN_PRIVILEGES, ReturnLength As Long) As Long


Private Type MODULEENTRY32
    dwSize As Long
    th32ModuleID As Long
    th32ProcessID As Long
    GlblcntUsage As Long
    ProccntUsage As Long
    modBaseAddr As Byte
    modBaseSize As Long
    hModule As Long
    szModule As String * 256
    szExePath As String * 1024
End Type
Private Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szExeFile As String * 260
End Type
Private Type LUID
    lowpart As Long
    highpart As Long
End Type
Private Type LUID_AND_ATTRIBUTES
    pLuid As LUID
    Attributes As Long
End Type
Const ANYSIZE_ARRAY = 1
Private Type TOKEN_PRIVILEGES
    PrivilegeCount As Long
    Privileges(ANYSIZE_ARRAY) As LUID_AND_ATTRIBUTES
End Type

Const STANDARD_RIGHTS_REQUIRED = &HF0000
Const TOKEN_ASSIGN_PRIMARY = &H1
Const TOKEN_DUPLICATE = (&H2)
Const TOKEN_IMPERSONATE = (&H4)
Const TOKEN_QUERY = (&H8)
Const TOKEN_QUERY_SOURCE = (&H10)
Const TOKEN_ADJUST_PRIVILEGES = (&H20)
Const TOKEN_ADJUST_GROUPS = (&H40)
Const TOKEN_ADJUST_DEFAULT = (&H80)
Const TOKEN_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED Or TOKEN_ASSIGN_PRIMARY Or TOKEN_DUPLICATE Or TOKEN_IMPERSONATE Or TOKEN_QUERY Or TOKEN_QUERY_SOURCE Or TOKEN_ADJUST_PRIVILEGES Or TOKEN_ADJUST_GROUPS Or TOKEN_ADJUST_DEFAULT)
Const SE_PRIVILEGE_ENABLED = &H2
Const MAX_PATH As Integer = 260
Const TH32CS_SNAPheaplist = &H1
Const TH32CS_SNAPPROCESS = &H2
Const TH32CS_SNAPthread = &H4
Const TH32CS_SNAPmodule = &H8
Const TH32CS_SNAPall = TH32CS_SNAPPROCESS + TH32CS_SNAPheaplist + TH32CS_SNAPthread + TH32CS_SNAPmodule

Public App_hwnd As Long  '�������細�ڵľ��

'��ȡ����������Ϸ�Ľ���PID
Public Function GetWMpid(wndClassName As String, Optional ByVal pid As Long) As Long
    'elementclient.exe,���̾����1839
    Dim URL As String, App_Name As String, result As Long
    Call AdjustTokenPrivileges2000
    App_Name = wndClassName  '��Ϸ��������
    App_hwnd = FindWindow(vbNullString, App_Name)
    URL = GetProcessIDURL(App_hwnd, result)
    GetWMpid = result
End Function


'ͨ��ָ�����ھ����ȡӦ�ó���·���ͽ���ID ,processID�������ػ�õĽ���ID
Public Function GetProcessIDURL(ByVal hwnd As Long, processid As Long) As String
  Dim result As Long, i As Long
  Dim temp As String
  On Error Resume Next
  result = GetWindowThreadProcessId(hwnd, processid)
  temp = GetName(processid)
  GetProcessIDURL = GetURL(temp, processid)
End Function

'�õ�������
Private Function GetName(ByVal processid As Long) As String
    Dim lPid As Long
    Dim Proc As PROCESSENTRY32
    Dim hSnapShot As Long
    
    hSnapShot = CreateToolhelpSnapshot(TH32CS_SNAPall, 0) '��ý��̡����ա��ľ��
    Proc.dwSize = Len(Proc)
    lPid = ProcessFirst(hSnapShot, Proc) '��ȡ��һ�����̵�PROCESSENTRY32�ṹ��Ϣ����
    Do While lPid <> 0 '������ֵ����ʱ������ȡ��һ������
        If Proc.th32ProcessID = processid Then
         GetName = Trim(Left(Proc.szExeFile, InStr(Proc.szExeFile, Chr(0)) - 1)) ' Proc.szExeFile
         Exit Do
        End If
        lPid = ProcessNext(hSnapShot, Proc) 'ѭ����ȡ��һ�����̵�PROCESSENTRY32�ṹ��Ϣ����
    Loop
    CloseHandle hSnapShot '�رս��̡����ա����
End Function

'�õ��ļ�·��
Private Function GetURL(ByVal processname As String, ByVal processid As Long) As String
    Dim i As Long, TmpStr As String, TmpLong As Long
    Dim Mode As MODULEENTRY32
    Dim mSnapshot As Long
    'ͨ��ģ����գ���ý��̵�ģ����վ��
    mSnapshot = CreateToolhelpSnapshot(TH32CS_SNAPmodule, processid)
    If mSnapshot > 0 Then
        Mode.dwSize = Len(Mode) '��ʼ���ṹmo�Ĵ�С
        TmpStr = Trim(processname)
        '�øý��̵�1��ģ���szExePath�ֶΣ���Ϊ���̵ĳ���·��
        If Module32First(mSnapshot, Mode) And UCase(TmpStr) <> "[SYSTEM PROCESS]" Then
            If InStr(UCase(Mode.szExePath), UCase(TmpStr)) Then
                TmpStr = Left(Mode.szExePath, InStr(Mode.szExePath, Chr(0)) - 1)
                If InStr(TmpStr, ":") > 2 Then TmpStr = Mid(TmpStr, InStr(TmpStr, ":") - 1)
                '���̵�ִ�г����·��
                GetURL = TmpStr
                GoTo aaa
            Else
                Do While Module32Next(mSnapshot, Mode) <> 0
                    If InStr(UCase(Mode.szExePath), UCase(TmpStr)) Then
                        TmpStr = Left(Mode.szExePath, InStr(Mode.szExePath, Chr(0)) - 1)
                        If InStr(TmpStr, ":") > 2 Then TmpStr = Mid(TmpStr, InStr(TmpStr, ":") - 1)
                        '���̵�ִ�г����·��
                        GetURL = TmpStr
                        GoTo aaa
                    End If
                    Mode.szExePath = ""
                Loop 'Until Module32Next(mSnapshot, Mode) = 0
            End If
        End If
    End If
aaa:
    CloseHandle (mSnapshot) '�ر�ģ����վ��
End Function

'����Ȩ��
Sub AdjustTokenPrivileges2000()
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
End Sub


